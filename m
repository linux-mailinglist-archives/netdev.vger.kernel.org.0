Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8243C2545
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 15:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232089AbhGINxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 09:53:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:63320 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbhGINxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 09:53:34 -0400
Received: from fsav113.sakura.ne.jp (fsav113.sakura.ne.jp [27.133.134.240])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 169DoUpb063867;
        Fri, 9 Jul 2021 22:50:30 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav113.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp);
 Fri, 09 Jul 2021 22:50:30 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav113.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 169DoThx063863
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 9 Jul 2021 22:50:30 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Subject: Re: [PATCH v2] Bluetooth: call lock_sock() outside of spinlock
 section
To:     LinMa <linma@zju.edu.cn>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
References: <20210627131134.5434-1-penguin-kernel@I-love.SAKURA.ne.jp>
 <9deece33-5d7f-9dcb-9aaa-94c60d28fc9a@i-love.sakura.ne.jp>
 <CABBYNZ+Vpzy2+u=xYR-7Kxx5M6pAQFQ8TJHYV1-Jr-FvqZ8=OQ@mail.gmail.com>
 <79694c01-b69e-a039-6860-d7e612fbc008@i-love.sakura.ne.jp>
 <5c823fa2.353ff.17a83a190e2.Coremail.linma@zju.edu.cn>
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <05535d35-30d6-28b6-067e-272d01679d24@i-love.sakura.ne.jp>
Date:   Fri, 9 Jul 2021 22:50:28 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <5c823fa2.353ff.17a83a190e2.Coremail.linma@zju.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It seems that history of this locking problem is a trial and error.

Commit b40df5743ee8aed8 ("[PATCH] bluetooth: fix socket locking in
hci_sock_dev_event()") in 2.6.21-rc4 changed bh_lock_sock() to lock_sock()
as an attempt to fix lockdep warning.

Then, commit 4ce61d1c7a8ef4c1 ("[BLUETOOTH]: Fix locking in
hci_sock_dev_event().") in 2.6.22-rc2 changed lock_sock() to
local_bh_disable() + bh_lock_sock_nested() as an attempt to fix
sleep in atomic context warning.

Then, commit 4b5dd696f81b210c ("Bluetooth: Remove local_bh_disable() from
hci_sock.c") in 3.3-rc1 removed local_bh_disable().

Then, commit e305509e678b3a4a ("Bluetooth: use correct lock to prevent UAF
of hdev object") in 5.13-rc5 again changed bh_lock_sock_nested() to
lock_sock() as an attempt to fix CVE-2021-3573.

But unfortunately it is too difficult to convert rw spinlock into mutex;
we need to live with current rw spinlock.

And we have three choices that can live with current rw spinlock.
Patches for these choices are show bottom. All tested by syzbot.

(1) Introduce a global mutex dedicated for hci_sock_dev_event(), and block
    bt_sock_unlink() and concurrent hci_sock_dev_event() callers.

    This is simplest if it is guaranteed that total delay for lock_sock()
    on all sockets is short enough.

    But it is not clear how long lock_sock() might block, for e.g.
    hci_sock_bound_ioctl() which is called inside lock_sock() section is
    doing copy_from_user()/copy_to_user() which may result in blocking
    other lock_sock() waiters for many seconds. I think that POC.zip is
    demonstrating that this delay is controllable via userfaultfd.

    Of course, the robust fix will be not to call
    copy_from_user()/copy_to_user() inside lock_sock() section. But such
    big change is not suitable for a fix for commit e305509e678b3a4a
    ("Bluetooth: use correct lock to prevent UAF of hdev object").

(2) Introduce a global mutex for hci_sock_dev_event(), but don't block
    bt_sock_unlink() nor concurrent hci_sock_dev_event() callers (i.e.
    use this mutex like a spinlock).

    Since it will be safe to resume sk_for_each() as long as currently
    accessing socket remains on that list, we can track which socket is
    currently accessed, and let bt_sock_unlink() wait if that socket is
    currently accessed.

    It is possible that total delay becomes long enough for khungtaskd to
    complain. Commit 8d0caedb75968304 ("can: bcm/raw/isotp: use per module
    netdevice notifier") is an example for avoiding khungtaskd warning
    using this choice. Compared to that commit, this choice for
    hci_sock_dev_event() case will need to also touch "struct hci_pinfo"
    because we need to track concurrent hci_sock_dev_event() callers.

(3) Don't introduce a global mutex for hci_sock_dev_event(), and don't
    block bt_sock_unlink() nor concurrent hci_sock_dev_event() callers.

    Since it will be safe to resume sk_for_each() as long as currently
    accessing socket remains on that list, take a refcount on currently
    accessing socket and check if currently accessing socket is still
    on the list. This choice needs to touch only hci_sock_dev_event().

Which choice do we want to go?

Patch for choice (1):

----------------------------------------
 net/bluetooth/hci_sock.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..c860ec4ea7b8 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -150,6 +150,8 @@ static struct bt_sock_list hci_sk_list = {
 	.lock = __RW_LOCK_UNLOCKED(hci_sk_list.lock)
 };
 
+static DEFINE_MUTEX(hci_sk_list_lock);
+
 static bool is_filtered_packet(struct sock *sk, struct sk_buff *skb)
 {
 	struct hci_filter *flt;
@@ -758,10 +760,13 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
+		int put_count = 0;
 
 		/* Detach sockets from device */
+		mutex_lock(&hci_sk_list_lock);
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
+			read_unlock(&hci_sk_list.lock);
 			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
@@ -769,11 +774,15 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
 
-				hci_dev_put(hdev);
+				put_count++;
 			}
 			release_sock(sk);
+			read_lock(&hci_sk_list.lock);
 		}
 		read_unlock(&hci_sk_list.lock);
+		mutex_unlock(&hci_sk_list_lock);
+		while (put_count--)
+			hci_dev_put(hdev);
 	}
 }
 
@@ -838,6 +847,10 @@ static int hci_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	mutex_lock(&hci_sk_list_lock);
+	bt_sock_unlink(&hci_sk_list, sk);
+	mutex_unlock(&hci_sk_list_lock);
+
 	lock_sock(sk);
 
 	switch (hci_pi(sk)->channel) {
@@ -859,8 +872,6 @@ static int hci_sock_release(struct socket *sock)
 		break;
 	}
 
-	bt_sock_unlink(&hci_sk_list, sk);
-
 	hdev = hci_pi(sk)->hdev;
 	if (hdev) {
 		if (hci_pi(sk)->channel == HCI_CHANNEL_USER) {
----------------------------------------

Patch for choice (2):

----------------------------------------
 net/bluetooth/hci_sock.c |   39 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 36 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..3e65fcc8c9af 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -43,6 +43,8 @@ static DEFINE_IDA(sock_cookie_ida);
 
 static atomic_t monitor_promisc = ATOMIC_INIT(0);
 
+static DEFINE_MUTEX(dev_event_lock);
+
 /* ----- HCI socket interface ----- */
 
 /* Socket info */
@@ -57,6 +59,7 @@ struct hci_pinfo {
 	unsigned long     flags;
 	__u32             cookie;
 	char              comm[TASK_COMM_LEN];
+	unsigned int      event_in_progress;
 };
 
 void hci_sock_set_flag(struct sock *sk, int nr)
@@ -758,10 +761,15 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
+		int put_count = 0;
 
 		/* Detach sockets from device */
+		mutex_lock(&dev_event_lock);
 		read_lock(&hci_sk_list.lock);
 		sk_for_each(sk, &hci_sk_list.head) {
+			read_unlock(&hci_sk_list.lock);
+			hci_pi(sk)->event_in_progress++;
+			mutex_unlock(&dev_event_lock);
 			lock_sock(sk);
 			if (hci_pi(sk)->hdev == hdev) {
 				hci_pi(sk)->hdev = NULL;
@@ -769,11 +777,17 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 				sk->sk_state = BT_OPEN;
 				sk->sk_state_change(sk);
 
-				hci_dev_put(hdev);
+				put_count++;
 			}
 			release_sock(sk);
+			mutex_lock(&dev_event_lock);
+			hci_pi(sk)->event_in_progress--;
+			read_lock(&hci_sk_list.lock);
 		}
 		read_unlock(&hci_sk_list.lock);
+		mutex_unlock(&dev_event_lock);
+		while (put_count--)
+			hci_dev_put(hdev);
 	}
 }
 
@@ -838,6 +852,26 @@ static int hci_sock_release(struct socket *sock)
 	if (!sk)
 		return 0;
 
+	/*
+	 * Wait for sk_for_each() in hci_sock_dev_event() to stop accessing
+	 * this sk before unlinking. Need to unlink before lock_sock(), for
+	 * hci_sock_dev_event() calls lock_sock() after incrementing
+	 * event_in_progress counter.
+	 */
+	while (1) {
+		bool unlinked = true;
+
+		mutex_lock(&dev_event_lock);
+		if (!hci_pi(sk)->event_in_progress)
+			bt_sock_unlink(&hci_sk_list, sk);
+		else
+			unlinked = false;
+		mutex_unlock(&dev_event_lock);
+		if (unlinked)
+			break;
+		schedule_timeout_uninterruptible(1);
+	}
+
 	lock_sock(sk);
 
 	switch (hci_pi(sk)->channel) {
@@ -859,8 +893,6 @@ static int hci_sock_release(struct socket *sock)
 		break;
 	}
 
-	bt_sock_unlink(&hci_sk_list, sk);
-
 	hdev = hci_pi(sk)->hdev;
 	if (hdev) {
 		if (hci_pi(sk)->channel == HCI_CHANNEL_USER) {
@@ -2049,6 +2081,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
 
+	hci_pi(sk)->event_in_progress = 0;
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
 }
----------------------------------------

Patch for choice (3):

----------------------------------------
 net/bluetooth/hci_sock.c |   35 +++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index b04a5a02ecf3..38146cf37378 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -758,22 +758,53 @@ void hci_sock_dev_event(struct hci_dev *hdev, int event)
 
 	if (event == HCI_DEV_UNREG) {
 		struct sock *sk;
+		int put_count = 0;
 
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
 				sk->sk_state_change(sk);
 
-				hci_dev_put(hdev);
+				put_count++;
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
+		while (put_count--)
+			hci_dev_put(hdev);
 	}
 }
 
----------------------------------------

