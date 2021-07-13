Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46533C6FB8
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhGMLbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:31:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56390 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbhGMLbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:31:02 -0400
Received: from fsav313.sakura.ne.jp (fsav313.sakura.ne.jp [153.120.85.144])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 16DBRpRX036255;
        Tue, 13 Jul 2021 20:27:51 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav313.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp);
 Tue, 13 Jul 2021 20:27:51 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav313.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 16DBRp4q036252
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Tue, 13 Jul 2021 20:27:51 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Subject: [PATCH v3] Bluetooth: call lock_sock() outside of spinlock section
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Lin Ma <linma@zju.edu.cn>,
        netdev@vger.kernel.org
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
Message-ID: <48d66166-4d39-4fe2-3392-7e0c84b9bdb3@i-love.sakura.ne.jp>
Date:   Tue, 13 Jul 2021 20:27:49 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is hitting might_sleep() warning at hci_sock_dev_event() due to
calling lock_sock() with rw spinlock held [1]. Among three possible
approaches [2], this patch chose holding a refcount via sock_hold() and
revalidating the element via sk_hashed().

Link: https://syzkaller.appspot.com/bug?extid=a5df189917e79d5e59c9 [1]
Link: https://lkml.kernel.org/r/05535d35-30d6-28b6-067e-272d01679d24@i-love.sakura.ne.jp [2]
Reported-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: syzbot <syzbot+a5df189917e79d5e59c9@syzkaller.appspotmail.com>
Fixes: e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF of hdev object")
---
Changes in v3:
  Don't use unlocked hci_pi(sk)->hdev != hdev test, for it is racy.
  No need to defer hci_dev_put(hdev), for it can't be the last reference.

Changes in v2:
  Take hci_sk_list.lock for write in case bt_sock_unlink() is called after
  sk_hashed(sk) test, and defer hci_dev_put(hdev) till schedulable context.

 net/bluetooth/hci_sock.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..786a06a232fd 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -760,10 +760,18 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 		struct sock *sk;
 
 		/* Detach sockets from device */
+restart:
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
+			/* This sock_hold(sk) is safe, for bt_sock_unlink(sk)
+			 * is not called yet.
+			 */
+			sock_hold(sk);
+			read_unlock(&hci_sk_list.lock);
 			lock_sock(sk);
-			if (hci_pi(sk)->hdev == hdev) {
+			write_lock(&hci_sk_list.lock);
+			/* Check that bt_sock_unlink(sk) is not called yet. */
+			if (sk_hashed(sk) && hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
 				sk->sk_err = EPIPE;
 				sk->sk_state = BT_OPEN;
@@ -771,7 +779,27 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 				hci_dev_put(hdev);
 			}
+			write_unlock(&hci_sk_list.lock);
 			release_sock(sk);
+			read_lock(&hci_sk_list.lock);
+			/* If bt_sock_unlink(sk) is not called yet, we can
+			 * continue iteration. We can use __sock_put(sk) here
+			 * because hci_sock_release() will call sock_put(sk)
+			 * after bt_sock_unlink(sk).
+			 */
+			if (sk_hashed(sk)) {
+				__sock_put(sk);
+				continue;
+			}
+			/* Otherwise, we need to restart iteration, for the
+			 * next socket pointed by sk->next might be already
+			 * gone. We can't use __sock_put(sk) here because
+			 * hci_sock_release() might have already called
+			 * sock_put(sk) after bt_sock_unlink(sk).
+			 */
+			read_unlock(&hci_sk_list.lock);
+			sock_put(sk);
+			goto restart;
 		}
 		read_unlock(&hci_sk_list.lock);
 	}
-- 
2.18.4

