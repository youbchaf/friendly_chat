import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // NEW

void main() {

  runApp(

    MaterialApp(
      title: 'FriendlyChat',
      home: ChatScreen(),
    ),
  );

}
class ChatMessage extends StatelessWidget {
  const ChatMessage({
    required this.text,              // NEW
    required this.animationController,                // NEW

    Key? key,
  }) : super(key: key);
  final String text;
  final AnimationController animationController;      // NEW


  @override
  Widget build(BuildContext context) {
    String _name = 'Chafik ayoub';


    return SizeTransition(             // NEW
        sizeFactor:                      // NEW
        CurvedAnimation(parent: animationController, curve: Curves.easeOut),  // NEW
    axisAlignment: 0.0,              // NEW
    child: Container(                // MODIFIED
    // Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(_name[0])),
          ),
        Expanded(            // NEW
        child: Column(     // MODIFIED
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_name, style: Theme.of(context).textTheme.headline4),
              Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(text),
              ),
            ],
          ),
        )
        ],
      ),
    ));
  }
}


class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];      // NEW
  final FocusNode _focusNode = FocusNode();    // NEW
  final _textController = TextEditingController();
  bool _isComposing = false;            // NEW

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text ('FriendlyChat')),
      body: Column(                                            // MODIFIED
        children: [                                            // NEW
          Flexible(                                            // NEW
            child: ListView.builder(                           // NEW
              padding: const EdgeInsets.all(8.0),              // NEW
              reverse: true,                                   // NEW
              itemBuilder: (_, index) => _messages[index],     // NEW
              itemCount: _messages.length,                     // NEW
            ),                                                 // NEW
          ),                                                   // NEW
          const Divider(height: 1.0),                          // NEW
          Container(                                           // NEW
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor),             // NEW
            child: _buildTextComposer(),                       // MODIFIED
          ),                                                   // NEW
        ],                                                     // NEW
      ),                                                       // NEW
    );
  }
  @override
  void dispose() {
    for (var message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }

  Widget _buildTextComposer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onChanged: (text) {                   // NEW
                setState(() {                       // NEW
                  _isComposing = text.isNotEmpty;   // NEW
                });                                 // NEW
              },                                    // NEW
              onSubmitted: _isComposing ? _handleSubmitted : null, // MODIFIED
              decoration:
                  const InputDecoration.collapsed(hintText: 'Send a message'),
              focusNode: _focusNode,  // NEW

            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
                color: Theme.of(context).accentColor,
                icon: const Icon(Icons.send),
                onPressed: _isComposing
    ? () => _handleSubmitted(_textController.text)
                    : null,)
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {                             // NEW
      _isComposing = false;                   // NEW
    });                                       // NEW
    var message = ChatMessage(      // NEW
      text: text,                   // NEW
      animationController: AnimationController(      // NEW
        duration: const Duration(milliseconds: 700), // NEW
        vsync: this,                                 // NEW
      ),                                             // NEW
    );                                               // NEW                              // NEW
    setState(() {                   // NEW
      _messages.insert(0, message); // NEW
    });                             // NEW
    _focusNode.requestFocus();  // NEW
    message.animationController.forward();           // NEW


  }
}
