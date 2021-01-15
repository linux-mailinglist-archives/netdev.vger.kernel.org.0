Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C86D2F7E3E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 15:32:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732420AbhAOOb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 09:31:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732038AbhAOOb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 09:31:28 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE78EC061793
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:30:47 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l0Q7b-0002jc-UJ; Fri, 15 Jan 2021 15:30:39 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1l0Q7Z-00089K-JC; Fri, 15 Jan 2021 15:30:37 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     mkl@pengutronix.de, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Robin van der Gracht <robin@protonic.nl>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+5138c4dd15a0401bec7b@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net 1/2] net: introduce CAN specific pointer in the struct net_device
Date:   Fri, 15 Jan 2021 15:30:35 +0100
Message-Id: <20210115143036.31275-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.0
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
 drivers/net/can/dev/dev.c |  2 +-
 drivers/net/can/slcan.c   |  2 +-
 drivers/net/can/vcan.c    |  2 +-
 drivers/net/can/vxcan.c   |  2 +-
 include/linux/netdevice.h |  4 ++++
 net/can/af_can.c          |  4 ++--
 net/can/j1939/main.c      |  4 ++--
 net/can/j1939/socket.c    |  2 +-
 net/can/proc.c            | 13 +++++++------
 9 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/net/can/dev/dev.c b/drivers/net/can/dev/dev.c
index f580f0ac6497..0e5265cb635f 100644
--- a/drivers/net/can/dev/dev.c
+++ b/drivers/net/can/dev/dev.c
@@ -269,7 +269,7 @@ struct net_device *alloc_candev_mqs(int sizeof_priv, unsigned int echo_skb_max,
 	priv = netdev_priv(dev);
 	priv->dev = dev;
 
-	dev->ml_priv = (void *)priv + ALIGN(sizeof_priv, NETDEV_ALIGN);
+	dev->can = (void *)priv + ALIGN(sizeof_priv, NETDEV_ALIGN);
 
 	if (echo_skb_max) {
 		priv->echo_skb_max = echo_skb_max;
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index a1bd1be09548..f703bd3b7415 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -538,7 +538,7 @@ static struct slcan *slc_alloc(void)
 
 	dev->base_addr  = i;
 	sl = netdev_priv(dev);
-	dev->ml_priv = (void *)sl + ALIGN(sizeof(*sl), NETDEV_ALIGN);
+	dev->can = (void *)sl + ALIGN(sizeof(*sl), NETDEV_ALIGN);
 
 	/* Initialize channel control data */
 	sl->magic = SLCAN_MAGIC;
diff --git a/drivers/net/can/vcan.c b/drivers/net/can/vcan.c
index 39ca14b0585d..d8c8f9cc769f 100644
--- a/drivers/net/can/vcan.c
+++ b/drivers/net/can/vcan.c
@@ -153,7 +153,7 @@ static void vcan_setup(struct net_device *dev)
 	dev->addr_len		= 0;
 	dev->tx_queue_len	= 0;
 	dev->flags		= IFF_NOARP;
-	dev->ml_priv		= netdev_priv(dev);
+	dev->can		= netdev_priv(dev);
 
 	/* set flags according to driver capabilities */
 	if (echo)
diff --git a/drivers/net/can/vxcan.c b/drivers/net/can/vxcan.c
index fa47bab510bb..0fea82935bf0 100644
--- a/drivers/net/can/vxcan.c
+++ b/drivers/net/can/vxcan.c
@@ -147,7 +147,7 @@ static void vxcan_setup(struct net_device *dev)
 	dev->flags		= (IFF_NOARP|IFF_ECHO);
 	dev->netdev_ops		= &vxcan_netdev_ops;
 	dev->needs_free_netdev	= true;
-	dev->ml_priv		= netdev_priv(dev) + ALIGN(sizeof(struct vxcan_priv), NETDEV_ALIGN);
+	dev->can		= netdev_priv(dev) + ALIGN(sizeof(struct vxcan_priv), NETDEV_ALIGN);
 }
 
 /* forward declaration for rtnl_create_link() */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b949076ed23..825220da2e4f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2153,6 +2153,10 @@ struct net_device {
 
 	/* protected by rtnl_lock */
 	struct bpf_xdp_entity	xdp_state[__MAX_XDP_MODE];
+
+#if IS_ENABLED(CONFIG_CAN)
+	struct can_ml_priv	*can;
+#endif
 };
 #define to_net_dev(d) container_of(d, struct net_device, dev)
 
diff --git a/net/can/af_can.c b/net/can/af_can.c
index 837bb8af0ec3..8651c8112a65 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -304,7 +304,7 @@ static struct can_dev_rcv_lists *can_dev_rcv_lists_find(struct net *net,
 							struct net_device *dev)
 {
 	if (dev) {
-		struct can_ml_priv *ml_priv = dev->ml_priv;
+		struct can_ml_priv *ml_priv = dev->can;
 		return &ml_priv->dev_rcv_lists;
 	} else {
 		return net->can.rx_alldev_list;
@@ -801,7 +801,7 @@ static int can_notifier(struct notifier_block *nb, unsigned long msg,
 
 	switch (msg) {
 	case NETDEV_REGISTER:
-		WARN(!dev->ml_priv,
+		WARN(!dev->can,
 		     "No CAN mid layer private allocated, please fix your driver and use alloc_candev()!\n");
 		break;
 	}
diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index bb914d8b4216..62088074230d 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -140,7 +140,7 @@ static struct j1939_priv *j1939_priv_create(struct net_device *ndev)
 static inline void j1939_priv_set(struct net_device *ndev,
 				  struct j1939_priv *priv)
 {
-	struct can_ml_priv *can_ml_priv = ndev->ml_priv;
+	struct can_ml_priv *can_ml_priv = ndev->can;
 
 	can_ml_priv->j1939_priv = priv;
 }
@@ -211,7 +211,7 @@ static void __j1939_rx_release(struct kref *kref)
 /* get pointer to priv without increasing ref counter */
 static inline struct j1939_priv *j1939_ndev_to_priv(struct net_device *ndev)
 {
-	struct can_ml_priv *can_ml_priv = ndev->ml_priv;
+	struct can_ml_priv *can_ml_priv = ndev->can;
 
 	if (!can_ml_priv)
 		return NULL;
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index f23966526a88..8010fbc8bd29 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -467,7 +467,7 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
-		if (!ndev->ml_priv) {
+		if (!ndev->can) {
 			netdev_warn_once(ndev,
 					 "No CAN mid layer private allocated, please fix your driver and use alloc_candev()!\n");
 			dev_put(ndev);
diff --git a/net/can/proc.c b/net/can/proc.c
index 5ea8695f507e..7d7a7f6d2cc9 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -322,8 +322,9 @@ static int can_rcvlist_proc_show(struct seq_file *m, void *v)
 
 	/* receive list for registered CAN devices */
 	for_each_netdev_rcu(net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv)
-			can_rcvlist_proc_show_one(m, idx, dev, dev->ml_priv);
+		if (dev->type == ARPHRD_CAN && dev->can)
+			can_rcvlist_proc_show_one(m, idx, dev,
+						  &dev->can->dev_rcv_lists);
 	}
 
 	rcu_read_unlock();
@@ -375,8 +376,8 @@ static int can_rcvlist_sff_proc_show(struct seq_file *m, void *v)
 
 	/* sff receive list for registered CAN devices */
 	for_each_netdev_rcu(net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv) {
-			dev_rcv_lists = dev->ml_priv;
+		if (dev->type == ARPHRD_CAN && dev->can) {
+			dev_rcv_lists = &dev->can->dev_rcv_lists;
 			can_rcvlist_proc_show_array(m, dev, dev_rcv_lists->rx_sff,
 						    ARRAY_SIZE(dev_rcv_lists->rx_sff));
 		}
@@ -406,8 +407,8 @@ static int can_rcvlist_eff_proc_show(struct seq_file *m, void *v)
 
 	/* eff receive list for registered CAN devices */
 	for_each_netdev_rcu(net, dev) {
-		if (dev->type == ARPHRD_CAN && dev->ml_priv) {
-			dev_rcv_lists = dev->ml_priv;
+		if (dev->type == ARPHRD_CAN && dev->can) {
+			dev_rcv_lists = &dev->can->dev_rcv_lists;
 			can_rcvlist_proc_show_array(m, dev, dev_rcv_lists->rx_eff,
 						    ARRAY_SIZE(dev_rcv_lists->rx_eff));
 		}
-- 
2.30.0

