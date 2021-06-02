Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A464E398E55
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhFBPU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 11:20:27 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:52560 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhFBPUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 11:20:14 -0400
Received: from fsav106.sakura.ne.jp (fsav106.sakura.ne.jp [27.133.134.233])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 152FHoA3006873;
        Thu, 3 Jun 2021 00:17:50 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav106.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp);
 Thu, 03 Jun 2021 00:17:50 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp)
Received: from localhost.localdomain (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 152FHiKp006736
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 3 Jun 2021 00:17:49 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] can: bcm/raw/isotp: use per module netdevice notifier
Date:   Thu,  3 Jun 2021 00:17:33 +0900
Message-Id: <20210602151733.3630-1-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot is reporting hung task at register_netdevice_notifier() [1] and
unregister_netdevice_notifier() [2], for cleanup_net() might perform
time consuming operations while CAN driver's raw/bcm/isotp modules are
calling {register,unregister}_netdevice_notifier() on each socket.

Change raw/bcm/isotp modules to call register_netdevice_notifier() from
module's __init function and call unregister_netdevice_notifier() from
module's __exit function, as with gw/j1939 modules are doing.

Link: https://syzkaller.appspot.com/bug?id=391b9498827788b3cc6830226d4ff5be87107c30 [1]
Link: https://syzkaller.appspot.com/bug?id=1724d278c83ca6e6df100a2e320c10d991cf2bce [2]
Reported-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+0f1827363a305f74996f@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+355f8edb2ff45d5f95fa@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 net/can/bcm.c   | 79 +++++++++++++++++++++++++++++++++++++++--------
 net/can/isotp.c | 82 +++++++++++++++++++++++++++++++++++++++++--------
 net/can/raw.c   | 82 ++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 203 insertions(+), 40 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 909b9e684e04..d503abd020ab 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -121,11 +121,18 @@ struct bcm_op {
 	struct net_device *rx_reg_dev;
 };
 
+struct bcm_notifier_block {
+	/* Linked to bcm_notifier_list list. Becomes empty when removed. */
+	struct list_head list;
+	/* Notifier call is in progress when this value is 0. */
+	unsigned int sequence;
+};
+
 struct bcm_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct bcm_notifier_block notifier;
 	struct list_head rx_ops;
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
@@ -133,6 +140,11 @@ struct bcm_sock {
 	char procname [32]; /* inode number in decimal with \0 */
 };
 
+static DECLARE_WAIT_QUEUE_HEAD(bcm_notifier_wait);
+static LIST_HEAD(bcm_notifier_list);
+static DEFINE_SPINLOCK(bcm_notifier_lock);
+static unsigned int bcm_notifier_sequence = 1; /* Cannot become 0. */
+
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
 {
 	return (struct bcm_sock *)sk;
@@ -1378,20 +1390,15 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 /*
  * notification handler for netdevice status changes
  */
-static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
-			void *ptr)
+static void bcm_notify(struct bcm_sock *bo, unsigned long msg,
+		       struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct bcm_sock *bo = container_of(nb, struct bcm_sock, notifier);
 	struct sock *sk = &bo->sk;
 	struct bcm_op *op;
 	int notify_enodev = 0;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 
@@ -1426,7 +1433,43 @@ static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
 				sk->sk_error_report(sk);
 		}
 	}
+}
 
+static int bcm_notifier(struct notifier_block *nb, unsigned long msg,
+			void *ptr)
+{
+	struct bcm_notifier_block *notify;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+
+	spin_lock(&bcm_notifier_lock);
+	if (unlikely(!++bcm_notifier_sequence))
+		bcm_notifier_sequence = 1;
+ restart:
+	list_for_each_entry(notify, &bcm_notifier_list, list) {
+		if (unlikely(notify->sequence == bcm_notifier_sequence))
+			continue;
+		notify->sequence = 0;
+		spin_unlock(&bcm_notifier_lock);
+		bcm_notify(container_of(notify, struct bcm_sock, notifier),
+			   msg, dev);
+		spin_lock(&bcm_notifier_lock);
+		notify->sequence = bcm_notifier_sequence;
+		/*
+		 * If bcm_release() did not remove this entry while we were at
+		 * bcm_notify(), we can continue list traversal. Otherwise,
+		 * tell bcm_release() that the sequence number became non-zero,
+		 * and then restart list traversal. The sequence number also
+		 * protects us from calling bcm_notify() for more than once.
+		 */
+		if (likely(!list_empty(&notify->list)))
+			continue;
+		wake_up_all(&bcm_notifier_wait);
+		goto restart;
+	}
+	spin_unlock(&bcm_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -1446,9 +1489,10 @@ static int bcm_init(struct sock *sk)
 	INIT_LIST_HEAD(&bo->rx_ops);
 
 	/* set notifier */
-	bo->notifier.notifier_call = bcm_notifier;
-
-	register_netdevice_notifier(&bo->notifier);
+	spin_lock(&bcm_notifier_lock);
+	bo->notifier.sequence = bcm_notifier_sequence;
+	list_add_tail(&bo->notifier.list, &bcm_notifier_list);
+	spin_unlock(&bcm_notifier_lock);
 
 	return 0;
 }
@@ -1471,7 +1515,10 @@ static int bcm_release(struct socket *sock)
 
 	/* remove bcm_ops, timer, rx_unregister(), etc. */
 
-	unregister_netdevice_notifier(&bo->notifier);
+	spin_lock(&bcm_notifier_lock);
+	list_del_init(&bo->notifier.list);
+	spin_unlock(&bcm_notifier_lock);
+	wait_event(bcm_notifier_wait, bo->notifier.sequence);
 
 	lock_sock(sk);
 
@@ -1692,6 +1739,10 @@ static struct pernet_operations canbcm_pernet_ops __read_mostly = {
 	.exit = canbcm_pernet_exit,
 };
 
+static struct notifier_block canbcm_notifier = {
+	.notifier_call = bcm_notifier
+};
+
 static int __init bcm_module_init(void)
 {
 	int err;
@@ -1705,12 +1756,14 @@ static int __init bcm_module_init(void)
 	}
 
 	register_pernet_subsys(&canbcm_pernet_ops);
+	register_netdevice_notifier(&canbcm_notifier);
 	return 0;
 }
 
 static void __exit bcm_module_exit(void)
 {
 	can_proto_unregister(&bcm_can_proto);
+	unregister_netdevice_notifier(&canbcm_notifier);
 	unregister_pernet_subsys(&canbcm_pernet_ops);
 }
 
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 253b24417c8e..4e41babb81b7 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -128,6 +128,13 @@ struct tpcon {
 	u8 buf[MAX_MSG_LENGTH + 1];
 };
 
+struct isotp_notifier_block {
+	/* Linked to isotp_notifier_list list. Becomes empty when removed. */
+	struct list_head list;
+	/* Notifier call is in progress when this value is 0. */
+	unsigned int sequence;
+};
+
 struct isotp_sock {
 	struct sock sk;
 	int bound;
@@ -143,10 +150,15 @@ struct isotp_sock {
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	struct tpcon rx, tx;
-	struct notifier_block notifier;
+	struct isotp_notifier_block notifier;
 	wait_queue_head_t wait;
 };
 
+static DECLARE_WAIT_QUEUE_HEAD(isotp_notifier_wait);
+static LIST_HEAD(isotp_notifier_list);
+static DEFINE_SPINLOCK(isotp_notifier_lock);
+static unsigned int isotp_notifier_sequence = 1; /* Cannot become 0. */
+
 static inline struct isotp_sock *isotp_sk(const struct sock *sk)
 {
 	return (struct isotp_sock *)sk;
@@ -1013,7 +1025,10 @@ static int isotp_release(struct socket *sock)
 	/* wait for complete transmission of current pdu */
 	wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
 
-	unregister_netdevice_notifier(&so->notifier);
+	spin_lock(&isotp_notifier_lock);
+	list_del_init(&so->notifier.list);
+	spin_unlock(&isotp_notifier_lock);
+	wait_event(isotp_notifier_wait, so->notifier.sequence);
 
 	lock_sock(sk);
 
@@ -1317,21 +1332,16 @@ static int isotp_getsockopt(struct socket *sock, int level, int optname,
 	return 0;
 }
 
-static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
-			  void *ptr)
+static void isotp_notify(struct isotp_sock *so, unsigned long msg,
+			 struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct isotp_sock *so = container_of(nb, struct isotp_sock, notifier);
 	struct sock *sk = &so->sk;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	if (so->ifindex != dev->ifindex)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
@@ -1357,7 +1367,44 @@ static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
 			sk->sk_error_report(sk);
 		break;
 	}
+}
 
+static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
+			  void *ptr)
+{
+	struct isotp_notifier_block *notify;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+
+	spin_lock(&isotp_notifier_lock);
+	if (unlikely(!++isotp_notifier_sequence))
+		isotp_notifier_sequence = 1;
+ restart:
+	list_for_each_entry(notify, &isotp_notifier_list, list) {
+		if (unlikely(notify->sequence == isotp_notifier_sequence))
+			continue;
+		notify->sequence = 0;
+		spin_unlock(&isotp_notifier_lock);
+		isotp_notify(container_of(notify, struct isotp_sock, notifier),
+			     msg, dev);
+		spin_lock(&isotp_notifier_lock);
+		notify->sequence = isotp_notifier_sequence;
+		/*
+		 * If isotp_release() did not remove this entry while we were
+		 * at isotp_notify(), we can continue list traversal.
+		 * Otherwise, tell isotp_release() that the sequence number
+		 * became non-zero, and then restart list traversal. The
+		 * sequence number also protects us from calling isotp_notify()
+		 * for more than once.
+		 */
+		if (likely(!list_empty(&notify->list)))
+			continue;
+		wake_up_all(&isotp_notifier_wait);
+		goto restart;
+	}
+	spin_unlock(&isotp_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -1394,8 +1441,10 @@ static int isotp_init(struct sock *sk)
 
 	init_waitqueue_head(&so->wait);
 
-	so->notifier.notifier_call = isotp_notifier;
-	register_netdevice_notifier(&so->notifier);
+	spin_lock(&isotp_notifier_lock);
+	so->notifier.sequence = isotp_notifier_sequence;
+	list_add_tail(&so->notifier.list, &isotp_notifier_list);
+	spin_unlock(&isotp_notifier_lock);
 
 	return 0;
 }
@@ -1442,6 +1491,10 @@ static const struct can_proto isotp_can_proto = {
 	.prot = &isotp_proto,
 };
 
+static struct notifier_block canisotp_notifier = {
+	.notifier_call = isotp_notifier
+};
+
 static __init int isotp_module_init(void)
 {
 	int err;
@@ -1451,6 +1504,8 @@ static __init int isotp_module_init(void)
 	err = can_proto_register(&isotp_can_proto);
 	if (err < 0)
 		pr_err("can: registration of isotp protocol failed\n");
+	else
+		register_netdevice_notifier(&canisotp_notifier);
 
 	return err;
 }
@@ -1458,6 +1513,7 @@ static __init int isotp_module_init(void)
 static __exit void isotp_module_exit(void)
 {
 	can_proto_unregister(&isotp_can_proto);
+	unregister_netdevice_notifier(&canisotp_notifier);
 }
 
 module_init(isotp_module_init);
diff --git a/net/can/raw.c b/net/can/raw.c
index 139d9471ddcf..f9cdd8698dec 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -79,11 +79,18 @@ struct uniqframe {
 	unsigned int join_rx_count;
 };
 
+struct raw_notifier_block {
+	/* Linked to raw_notifier_list list. Becomes empty when removed. */
+	struct list_head list;
+	/* Notifier call is in progress when this value is 0. */
+	unsigned int sequence;
+};
+
 struct raw_sock {
 	struct sock sk;
 	int bound;
 	int ifindex;
-	struct notifier_block notifier;
+	struct raw_notifier_block notifier;
 	int loopback;
 	int recv_own_msgs;
 	int fd_frames;
@@ -95,6 +102,11 @@ struct raw_sock {
 	struct uniqframe __percpu *uniq;
 };
 
+static DECLARE_WAIT_QUEUE_HEAD(raw_notifier_wait);
+static LIST_HEAD(raw_notifier_list);
+static DEFINE_SPINLOCK(raw_notifier_lock);
+static unsigned int raw_notifier_sequence = 1; /* Cannot become 0. */
+
 /* Return pointer to store the extra msg flags for raw_recvmsg().
  * We use the space of one unsigned int beyond the 'struct sockaddr_can'
  * in skb->cb.
@@ -263,21 +275,16 @@ static int raw_enable_allfilters(struct net *net, struct net_device *dev,
 	return err;
 }
 
-static int raw_notifier(struct notifier_block *nb,
-			unsigned long msg, void *ptr)
+static void raw_notify(struct raw_sock *ro, unsigned long msg,
+		       struct net_device *dev)
 {
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct raw_sock *ro = container_of(nb, struct raw_sock, notifier);
 	struct sock *sk = &ro->sk;
 
 	if (!net_eq(dev_net(dev), sock_net(sk)))
-		return NOTIFY_DONE;
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
+		return;
 
 	if (ro->ifindex != dev->ifindex)
-		return NOTIFY_DONE;
+		return;
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
@@ -305,7 +312,43 @@ static int raw_notifier(struct notifier_block *nb,
 			sk->sk_error_report(sk);
 		break;
 	}
+}
 
+static int raw_notifier(struct notifier_block *nb, unsigned long msg,
+			void *ptr)
+{
+	struct raw_notifier_block *notify;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (dev->type != ARPHRD_CAN)
+		return NOTIFY_DONE;
+
+	spin_lock(&raw_notifier_lock);
+	if (unlikely(!++raw_notifier_sequence))
+		raw_notifier_sequence = 1;
+ restart:
+	list_for_each_entry(notify, &raw_notifier_list, list) {
+		if (unlikely(notify->sequence == raw_notifier_sequence))
+			continue;
+		notify->sequence = 0;
+		spin_unlock(&raw_notifier_lock);
+		raw_notify(container_of(notify, struct raw_sock, notifier),
+			   msg, dev);
+		spin_lock(&raw_notifier_lock);
+		notify->sequence = raw_notifier_sequence;
+		/*
+		 * If raw_release() did not remove this entry while we were at
+		 * raw_notify(), we can continue list traversal. Otherwise,
+		 * tell raw_release() that the sequence number became non-zero,
+		 * and then restart list traversal. The sequence number also
+		 * protects us from calling raw_notify() for more than once.
+		 */
+		if (likely(!list_empty(&notify->list)))
+			continue;
+		wake_up_all(&raw_notifier_wait);
+		goto restart;
+	}
+	spin_unlock(&raw_notifier_lock);
 	return NOTIFY_DONE;
 }
 
@@ -334,9 +377,10 @@ static int raw_init(struct sock *sk)
 		return -ENOMEM;
 
 	/* set notifier */
-	ro->notifier.notifier_call = raw_notifier;
-
-	register_netdevice_notifier(&ro->notifier);
+	spin_lock(&raw_notifier_lock);
+	ro->notifier.sequence = raw_notifier_sequence;
+	list_add_tail(&ro->notifier.list, &raw_notifier_list);
+	spin_unlock(&raw_notifier_lock);
 
 	return 0;
 }
@@ -351,7 +395,10 @@ static int raw_release(struct socket *sock)
 
 	ro = raw_sk(sk);
 
-	unregister_netdevice_notifier(&ro->notifier);
+	spin_lock(&raw_notifier_lock);
+	list_del_init(&ro->notifier.list);
+	spin_unlock(&raw_notifier_lock);
+	wait_event(raw_notifier_wait, ro->notifier.sequence);
 
 	lock_sock(sk);
 
@@ -889,6 +936,10 @@ static const struct can_proto raw_can_proto = {
 	.prot       = &raw_proto,
 };
 
+static struct notifier_block canraw_notifier = {
+	.notifier_call = raw_notifier
+};
+
 static __init int raw_module_init(void)
 {
 	int err;
@@ -898,6 +949,8 @@ static __init int raw_module_init(void)
 	err = can_proto_register(&raw_can_proto);
 	if (err < 0)
 		pr_err("can: registration of raw protocol failed\n");
+	else
+		register_netdevice_notifier(&canraw_notifier);
 
 	return err;
 }
@@ -905,6 +958,7 @@ static __init int raw_module_init(void)
 static __exit void raw_module_exit(void)
 {
 	can_proto_unregister(&raw_can_proto);
+	unregister_netdevice_notifier(&canraw_notifier);
 }
 
 module_init(raw_module_init);
-- 
2.18.4

