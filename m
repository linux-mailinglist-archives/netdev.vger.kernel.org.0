Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4BC3B535A
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 15:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhF0NOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 09:14:43 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:57553 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhF0NOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 09:14:42 -0400
Received: from fsav115.sakura.ne.jp (fsav115.sakura.ne.jp [27.133.134.242])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 15RDBh50091179;
        Sun, 27 Jun 2021 22:11:43 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav115.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp);
 Sun, 27 Jun 2021 22:11:43 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav115.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 15RDBcTs091155
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Sun, 27 Jun 2021 22:11:43 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] Bluetooth: call lock_sock() outside of spinlock section
Date:   Sun, 27 Jun 2021 22:11:34 +0900
Message-Id: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is hitting might_sleep() warning at hci_sock_dev_event() due to
calling lock_sock() with rw spinlock held [1]. Defer calling lock_sock()
via sock_hold().

Link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9 [1]
Reported-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Fixes: e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF of hdev object")
---
 net/bluetooth/hci_sock.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index eed0dd066e12..64e54ab0892f 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -759,19 +759,39 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
 
+restart:
 		/* Detach sockets from device */
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
+			/* hci_sk_list.lock is preventing hci_sock_release()
+			 * from calling bt_sock_unlink().
+			 */
+			if (hci_pi(sk)->hdev != hdev || sk_unhashed(sk))
+				continue;
+			/* Take a ref because we can't call lock_sock() with
+			 * hci_sk_list.lock held.
+			 */
+			sock_hold(sk);
+			read_unlock(&hci_sk_list.lock);
 			lock_sock(sk);
-			if (hci_pi(sk)->hdev == hdev) {
+			/* Since hci_sock_release() might have already called
+			 * bt_sock_unlink() while waiting for lock_sock(),
+			 * use sk_hashed(sk) for checking that bt_sock_unlink()
+			 * is not yet called.
+			 */
+			if (sk_hashed(sk) && hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
 				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
-
 				hci_dev_put(hdev);
 			}
 			release_sock(sk);
+			sock_put(sk);
+			/* Restarting is safe, for hci_pi(sk)->hdev is now NULL
+			 * if condition met and will "continue;" otherwise.
+			 */
+			goto restart;
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.18.4

