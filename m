Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6CD3BE5CA
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 11:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhGGJqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 05:46:34 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55757 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhGGJqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 05:46:33 -0400
Received: from fsav411.sakura.ne.jp (fsav411.sakura.ne.jp [133.242.250.110])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 1679hawo045341;
        Wed, 7 Jul 2021 18:43:36 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav411.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp);
 Wed, 07 Jul 2021 18:43:36 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav411.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 1679haQ0045338
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 7 Jul 2021 18:43:36 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: [PATCH v2] Bluetooth: call lock_sock() outside of spinlock section
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        netdev@vger.kernel.org
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
Date:   Wed, 7 Jul 2021 18:43:36 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
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
Changes in v2:
  Take hci_sk_list.lock for write in case bt_sock_unlink() is called after
  sk_hashed(sk) test, and defer hci_dev_put(hdev) till schedulable context.

 net/bluetooth/hci_sock.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..d8e1ac1ae10d 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -758,20 +758,46 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
+		bool put_dev;
 
+restart:
+		put_dev = false;
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
+			write_lock(&hci_sk_list.lock);
+			if (sk_hashed(sk) && hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
 				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
-
-				hci_dev_put(hdev);
+				put_dev = true;
 			}
+			write_unlock(&hci_sk_list.lock);
 			release_sock(sk);
+			sock_put(sk);
+			if (put_dev)
+				hci_dev_put(hdev);
+			/* Restarting is safe, for hci_pi(sk)->hdev != hdev if
+			 * condition met and sk_unhashed(sk) == true otherwise.
+			 */
+			goto restart;
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.18.4


