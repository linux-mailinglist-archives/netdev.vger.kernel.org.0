Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4424132261E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 08:03:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhBWHCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 02:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbhBWHCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 02:02:16 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F763C06174A
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 23:01:36 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lERhI-0003DV-V8; Tue, 23 Feb 2021 08:01:28 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lERhH-0001Co-Rd; Tue, 23 Feb 2021 08:01:27 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v4 1/1] net: introduce CAN specific pointer in the struct net_device
Date:   Tue, 23 Feb 2021 08:01:26 +0100
Message-Id: <20210223070127.4538-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 20dd3850bcf8 ("can: Speed up CAN frame receiption by using
ml_priv") the CAN framework uses per device specific data in the AF_CAN
protocol. For this purpose the struct net_device->ml_priv is used. Later
the ml_priv usage in CAN was extended for other users, one of them being
CAN_J1939.

Later in the kernel ml_priv was converted to an union, used by other
drivers. E.g. the tun driver started storing it's stats pointer.

Since tun devices can claim to be a CAN device, CAN specific protocols
will wrongly interpret this pointer, which will cause system crashes.
Mostly this issue is visible in the CAN_J1939 stack.

To fix this issue, we request a dedicated CAN pointer within the
net_device struct.

Reported-by: syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com
Fixes: 20dd3850bcf8 ("can: Speed up CAN frame receiption by using ml_priv")
Fixes: ffd956eef69b ("can: introduce CAN midlayer private and allocate it automatically")
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Fixes: 497a5757ce4e ("tun: switch to net core provided statistics counters")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/can/dev/dev.c  |  4 +++-
 drivers/net/can/slcan.c    |  4 +++-
 drivers/net/can/vcan.c     |  2 +-
 drivers/net/can/vxcan.c    |  6 +++++-
 include/linux/can/can-ml.h | 12 ++++++++++++
 include/linux/netdevice.h  | 34 +++++++++++++++++++++++++++++++++-
 net/can/af_can.c           | 34 ++--------------------------------
 net/can/j1939/main.c       | 22 ++++++++--------------
 net/can/j1939/socket.c     | 13 ++++---------
 net/can/proc.c             | 19 +++++++++++++------
 10 files changed, 84 insertions(+), 66 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index d9281ae853f8..311d8564d611 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -239,6 +239,7 @@ void can_setup(struct net_device *dev)
 struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 				    unsigned int txqs, unsigned int rxqs)
 {
+	struct can_ml_priv *can_ml;
 	struct net_device *dev;
 	struct can_priv *priv;
 	int size;
@@ -270,7 +271,8 @@ struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 	priv = netdev_priv(dev);
 	priv->dev = dev;
 
-	dev->ml_priv = (void *)priv + ALIGN(sizeof_priv, NETDEV_ALIGN);
+	can_ml = (void *)priv + ALIGN(sizeof_priv, NETDEV_ALIGN);
+	can_set_ml_priv(dev, can_ml);
 
 	if (echo_skb_max) {
 		priv->echo_skb_max = echo_skb_max;
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index a1bd1be09548..30c8d53c9745 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -516,6 +516,7 @@ static struct slcan *slc_alloc(void)
 	int i;
 	char name[IFNAMSIZ];
 	struct net_device *dev = NULL;
+	struct can_ml_priv *can_ml;
 	struct slcan       *sl;
 	int size;
 
@@ -538,7 +539,8 @@ static struct slcan *slc_alloc(void)
 
 	dev->base_addr  = i;
 	sl = netdev_priv(dev);
-	dev->ml_priv = (void *)sl + ALIGN(sizeof(*sl), NETDEV_ALIGN);
+	can_ml = (void *)sl + ALIGN(sizeof(*sl), NETDEV_ALIGN);
+	can_set_ml_priv(dev, can_ml);
 
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index 39ca14b0585d..067705e2850b 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -153,7 +153,7 @@ static void vcan_setup(struct net_device *dev)
 	dev->addr_len		= 0;
 	dev->tx_queue_len	= 0;
 	dev->flags		= IFF_NOARP;
-	dev->ml_priv		= netdev_priv(dev);
+	can_set_ml_priv(dev, netdev_priv(dev));
 
 	/* set flags according to driver capabilities */
 	if (echo)
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index f9a524c5f6d6..8861a7d875e7 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -141,6 +141,8 @@ static const struct net_device_ops vxcan_netdev_ops = {
 
 static void vxcan_setup(struct net_device *dev)
 {
+	struct can_ml_priv *can_ml;
+
 	dev->type		= ARPHRD_CAN;
 	dev->mtu		= CANFD_MTU;
 	dev->hard_header_len	= 0;
@@ -149,7 +151,9 @@ static void vxcan_setup(struct net_device *dev)
 	dev->flags		= (IFF_NOARP|IFF_ECHO);
 	dev->netdev_ops		= &vxcan_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->ml_priv		= netdev_priv(dev) + ALIGN(sizeof(struct vxcan_priv), NETDEV_ALIGN);
+
+	can_ml = netdev_priv(dev) + ALIGN(sizeof(struct vxcan_priv), NETDEV_ALIGN);
+	can_set_ml_priv(dev, can_ml);
 }
 
 /* forward declaration for rtnl_create_link() */
diff --git a/include/linux/can/can-ml.h b/include/linux/can/can-ml.h
index 2f5d731ae251..8afa92d15a66 100644
--- a/include/linux/can/can-ml.h
+++ b/include/linux/can/can-ml.h
@@ -44,6 +44,7 @@
 
 #include <linux/can.h>
 #include <linux/list.h>
+#include <linux/netdevice.h>
 
 #define CAN_SFF_RCV_ARRAY_SZ (1 << CAN_SFF_ID_BITS)
 #define CAN_EFF_RCV_HASH_BITS 10
@@ -65,4 +66,15 @@ struct can_ml_priv {
 #endif
 };
 
+static inline struct can_ml_priv *can_get_ml_priv(struct net_device *dev)
+{
+	return netdev_get_ml_priv(dev, ML_PRIV_CAN);
+}
+
+static inline void can_set_ml_priv(struct net_device *dev,
+				   struct can_ml_priv *ml_priv)
+{
+	netdev_set_ml_priv(dev, ml_priv, ML_PRIV_CAN);
+}
+
 #endif /* CAN_ML_H */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..f06fbee8638e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1584,6 +1584,12 @@ enum netdev_priv_flags {
 #define IFF_L3MDEV_RX_HANDLER		IFF_L3MDEV_RX_HANDLER
 #define IFF_LIVE_RENAME_OK		IFF_LIVE_RENAME_OK
 
+/* Specifies the type of the struct net_device::ml_priv pointer */
+enum netdev_ml_priv_type {
+	ML_PRIV_NONE,
+	ML_PRIV_CAN,
+};
+
 /**
  *	struct net_device - The DEVICE structure.
  *
@@ -1779,6 +1785,7 @@ enum netdev_priv_flags {
  * 	@nd_net:		Network namespace this network device is inside
  *
  * 	@ml_priv:	Mid-layer private
+ *	@ml_priv_type:  Mid-layer private type
  * 	@lstats:	Loopback statistics
  * 	@tstats:	Tunnel statistics
  * 	@dstats:	Dummy statistics
@@ -2094,8 +2101,10 @@ struct net_device {
 	possible_net_t			nd_net;
 
 	/* mid-layer private */
+	void				*ml_priv;
+	enum netdev_ml_priv_type	ml_priv_type;
+
 	union {
-		void					*ml_priv;
 		struct pcpu_lstats __percpu		*lstats;
 		struct pcpu_sw_netstats __percpu	*tstats;
 		struct pcpu_dstats __percpu		*dstats;
@@ -2286,6 +2295,29 @@ static inline void netdev_reset_rx_headroom(struct net_device *dev)
 	netdev_set_rx_headroom(dev, -1);
 }
 
+static inline void *netdev_get_ml_priv(struct net_device *dev,
+				       enum netdev_ml_priv_type type)
+{
+	if (dev->ml_priv_type != type)
+		return NULL;
+
+	return dev->ml_priv;
+}
+
+static inline void netdev_set_ml_priv(struct net_device *dev,
+				      void *ml_priv,
+				      enum netdev_ml_priv_type type)
+{
+	WARN(dev->ml_priv_type && dev->ml_priv_type != type,
+	     "Overwriting already set ml_priv_type (%u) with different ml_priv_type (%u)!\n",
+	     dev->ml_priv_type, type);
+	WARN(!dev->ml_priv_type && dev->ml_priv,
+	     "Overwriting already set ml_priv and ml_priv_type is ML_PRIV_NONE!\n");
+
+	dev->ml_priv = ml_priv;
+	dev->ml_priv_type = type;
+}
+
 /*
  * Net namespace inlines
  */
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 837bb8af0ec3..cce2af10eb3e 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -304,8 +304,8 @@ static struct can_dev_rcv_lists *can_dev_rcv_lists_find(struct net *net,
 							struct net_device *dev)
 {
 	if (dev) {
-		struct can_ml_priv *ml_priv = dev->ml_priv;
-		return &ml_priv->dev_rcv_lists;
+		struct can_ml_priv *can_ml = can_get_ml_priv(dev);
+		return &can_ml->dev_rcv_lists;
 	} else {
 		return net->can.rx_alldev_list;
 	}
@@ -790,25 +790,6 @@ void can_proto_unregister(const struct can_proto *cp)
 }
 EXPORT_SYMBOL(can_proto_unregister);
 
-/* af_can notifier to create/remove CAN netdevice specific structs */
-static int can_notifier(struct notifier_block *nb, unsigned long msg,
-			void *ptr)
-{
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-
-	if (dev->type != ARPHRD_CAN)
-		return NOTIFY_DONE;
-
-	switch (msg) {
-	case NETDEV_REGISTER:
-		WARN(!dev->ml_priv,
-		     "No CAN mid layer private allocated, please fix your driver and use alloc_candev()!\n");
-		break;
-	}
-
-	return NOTIFY_DONE;
-}
-
 static int can_pernet_init(struct net *net)
 {
 	spin_lock_init(&net->can.rcvlists_lock);
@@ -876,11 +857,6 @@ static const struct net_proto_family can_family_ops = {
 	.owner  = THIS_MODULE,
 };
 
-/* notifier block for netdevice event */
-static struct notifier_block can_netdev_notifier __read_mostly = {
-	.notifier_call = can_notifier,
-};
-
 static struct pernet_operations can_pernet_ops __read_mostly = {
 	.init = can_pernet_init,
 	.exit = can_pernet_exit,
@@ -911,17 +887,12 @@ static __init int can_init(void)
 	err = sock_register(&can_family_ops);
 	if (err)
 		goto out_sock;
-	err = register_netdevice_notifier(&can_netdev_notifier);
-	if (err)
-		goto out_notifier;
 
 	dev_add_pack(&can_packet);
 	dev_add_pack(&canfd_packet);
 
 	return 0;
 
-out_notifier:
-	sock_unregister(PF_CAN);
 out_sock:
 	unregister_pernet_subsys(&can_pernet_ops);
 out_pernet:
@@ -935,7 +906,6 @@ static __exit void can_exit(void)
 	/* protocol unregister */
 	dev_remove_pack(&canfd_packet);
 	dev_remove_pack(&can_packet);
-	unregister_netdevice_notifier(&can_netdev_notifier);
 	sock_unregister(PF_CAN);
 
 	unregister_pernet_subsys(&can_pernet_ops);
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index bb914d8b4216..da3a7a7bcff2 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -140,9 +140,9 @@ static struct j1939_priv *j1939_priv_create(struct net_device *ndev)
 static inline void j1939_priv_set(struct net_device *ndev,
 				  struct j1939_priv *priv)
 {
-	struct can_ml_priv *can_ml_priv = ndev->ml_priv;
+	struct can_ml_priv *can_ml = can_get_ml_priv(ndev);
 
-	can_ml_priv->j1939_priv = priv;
+	can_ml->j1939_priv = priv;
 }
 
 static void __j1939_priv_release(struct kref *kref)
@@ -211,12 +211,9 @@ static void __j1939_rx_release(struct kref *kref)
 /* get pointer to priv without increasing ref counter */
 static inline struct j1939_priv *j1939_ndev_to_priv(struct net_device *ndev)
 {
-	struct can_ml_priv *can_ml_priv = ndev->ml_priv;
+	struct can_ml_priv *can_ml = can_get_ml_priv(ndev);
 
-	if (!can_ml_priv)
-		return NULL;
-
-	return can_ml_priv->j1939_priv;
+	return can_ml->j1939_priv;
 }
 
 static struct j1939_priv *j1939_priv_get_by_ndev_locked(struct net_device *ndev)
@@ -225,9 +222,6 @@ static struct j1939_priv *j1939_priv_get_by_ndev_locked(struct net_device *ndev)
 
 	lockdep_assert_held(&j1939_netdev_lock);
 
-	if (ndev->type != ARPHRD_CAN)
-		return NULL;
-
 	priv = j1939_ndev_to_priv(ndev);
 	if (priv)
 		j1939_priv_get(priv);
@@ -348,15 +342,16 @@ static int j1939_netdev_notify(struct notifier_block *nb,
 			       unsigned long msg, void *data)
 {
 	struct net_device *ndev = netdev_notifier_info_to_dev(data);
+	struct can_ml_priv *can_ml = can_get_ml_priv(ndev);
 	struct j1939_priv *priv;
 
+	if (!can_ml)
+		goto notify_done;
+
 	priv = j1939_priv_get_by_ndev(ndev);
 	if (!priv)
 		goto notify_done;
 
-	if (ndev->type != ARPHRD_CAN)
-		goto notify_put;
-
 	switch (msg) {
 	case NETDEV_DOWN:
 		j1939_cancel_active_session(priv, NULL);
@@ -365,7 +360,6 @@ static int j1939_netdev_notify(struct notifier_block *nb,
 		break;
 	}
 
-notify_put:
 	j1939_priv_put(priv);
 
 notify_done:
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index f23966526a88..56aa66147d5a 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -12,6 +12,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/can/can-ml.h>
 #include <linux/can/core.h>
 #include <linux/can/skb.h>
 #include <linux/errqueue.h>
@@ -453,6 +454,7 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		j1939_jsk_del(priv, jsk);
 		j1939_local_ecu_put(priv, jsk->addr.src_name, jsk->addr.sa);
 	} else {
+		struct can_ml_priv *can_ml;
 		struct net_device *ndev;
 
 		ndev = dev_get_by_index(net, addr->can_ifindex);
@@ -461,15 +463,8 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
-		if (ndev->type != ARPHRD_CAN) {
-			dev_put(ndev);
-			ret = -ENODEV;
-			goto out_release_sock;
-		}
-
-		if (!ndev->ml_priv) {
-			netdev_warn_once(ndev,
-					 "No CAN mid layer private allocated, please fix your driver and use alloc_candev()!\n");
+		can_ml = can_get_ml_priv(ndev);
+		if (!can_ml) {
 			dev_put(ndev);
 			ret = -ENODEV;
 			goto out_release_sock;
diff --git a/net/can/proc.c b/net/can/proc.c
index 5ea8695f507e..b15760b5c1cc 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -322,8 +322,11 @@ static int can_rcvlist_proc_show(struct seq_file *m, void *v)
 
 	/* receive list for registered CAN devices */
 	for_each_netdev_rcu(net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv)
-			can_rcvlist_proc_show_one(m, idx, dev, dev->ml_priv);
+		struct can_ml_priv *can_ml = can_get_ml_priv(dev);
+
+		if (can_ml)
+			can_rcvlist_proc_show_one(m, idx, dev,
+						  &can_ml->dev_rcv_lists);
 	}
 
 	rcu_read_unlock();
@@ -375,8 +378,10 @@ static int can_rcvlist_sff_proc_show(struct seq_file *m, void *v)
 
 	/* sff receive list for registered CAN devices */
 	for_each_netdev_rcu(net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv) {
-			dev_rcv_lists = dev->ml_priv;
+		struct can_ml_priv *can_ml = can_get_ml_priv(dev);
+
+		if (can_ml) {
+			dev_rcv_lists = &can_ml->dev_rcv_lists;
 			can_rcvlist_proc_show_array(m, dev, dev_rcv_lists->rx_sff,
 						    ARRAY_SIZE(dev_rcv_lists->rx_sff));
 		}
@@ -406,8 +411,10 @@ static int can_rcvlist_eff_proc_show(struct seq_file *m, void *v)
 
 	/* eff receive list for registered CAN devices */
 	for_each_netdev_rcu(net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv) {
-			dev_rcv_lists = dev->ml_priv;
+		struct can_ml_priv *can_ml = can_get_ml_priv(dev);
+
+		if (can_ml) {
+			dev_rcv_lists = &can_ml->dev_rcv_lists;
 			can_rcvlist_proc_show_array(m, dev, dev_rcv_lists->rx_eff,
 						    ARRAY_SIZE(dev_rcv_lists->rx_eff));
 		}
-- 
2.29.2

