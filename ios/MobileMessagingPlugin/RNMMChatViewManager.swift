//
//  RNMMChatViewManager.swift
//  infobip-mobile-messaging-react-native-plugin
//
//  Created by Olga Koroleva on 28.05.2020.
//

import Foundation
import MobileMessaging

@objc(RNMMChatViewManager)
class RNMMChatViewManager: RCTViewManager {
    override func view() -> UIView! {
        return RNMMChatView()
    }
}


@objc class RNMMChatView: UIView {
    override init(frame: CGRect) {
         super.init(frame: frame)
     }
     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    weak var viewController: MMChatViewController?

    @objc func setSendButtonColor(_ colorString: NSString) {
        MobileMessaging.inAppChat?.settings.configureWith(rawConfig: ["sendButtonColor": colorString])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        viewController?.view.frame = bounds
    }

    override func didMoveToWindow() {
        embedViewController()
        super.didMoveToWindow()
    }

    override func removeFromSuperview() {
        self.viewController?.removeFromParent()
        super.removeFromSuperview()
    }

    private func embedViewController() {
        guard let parentVC = parentViewController else {
            return
        }
        guard let existingChatVC = parentVC.children.filter({ $0 is MMChatViewController }).first as? MMChatViewController else {
            let newChatVC = MMChatViewController.makeModalViewController()
            parentVC.addChild(newChatVC)
            addSubview(newChatVC.view)
            newChatVC.didMove(toParent: parentVC)
            self.viewController = newChatVC
            return
        }
        /* existingChatVC is the case of didMoveToWindow being triggered from the presentation of other view (ie RTCImageView) */
        self.viewController = existingChatVC
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
