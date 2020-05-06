Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570D91C7670
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbgEFQbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:31:25 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:42230 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbgEFQan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:30:43 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 046GUdaj085542;
        Wed, 6 May 2020 11:30:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588782639;
        bh=fFnWfeM2JVHN2A9+SaufSrU4DKAi5Xb8oPteITavH+o=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=t17leRyWZ9KrSjjjDyH3Ivi5GBn4fMWGzZJFlYmaKRAi/xIUV/gbDRJ+gvJdPb50k
         b8KtyFqD/0uIH4HYZK6bI8xly28V/8dA0JzulSLEXKjuGzEzZ7eTzM2VD9PCRV1OpU
         QcVV46g69W1Psxl60+ilI866t/8DoEEzsybIlwHk=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 046GUd8n022040
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 May 2020 11:30:39 -0500
Received: from DLEE110.ent.ti.com (157.170.170.21) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 6 May
 2020 11:30:38 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 6 May 2020 11:30:39 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 046GUXDn119719;
        Wed, 6 May 2020 11:30:38 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <grygorii.strashko@ti.com>
Subject: [net-next RFC PATCH 10/13] net: hsr: add netlink socket interface for PRP
Date:   Wed, 6 May 2020 12:30:30 -0400
Message-ID: <20200506163033.3843-11-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200506163033.3843-1-m-karicheri2@ti.com>
References: <20200506163033.3843-1-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to HSR, add a netlink socket interface code re-using the
common functions from hsr_prp_netlink.c. Use wrapper functions
for hsr_dev_setup() and prp_dev_setup() to setup HSR/PRP interface
by calling common hsr_prp_dev_setup().

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 net/hsr-prp/Makefile           |   2 +-
 net/hsr-prp/hsr_netlink.c      |  11 ++-
 net/hsr-prp/hsr_netlink.h      |   1 +
 net/hsr-prp/hsr_prp_device.c   |  34 +++++---
 net/hsr-prp/hsr_prp_device.h   |   3 +-
 net/hsr-prp/hsr_prp_framereg.c |   6 +-
 net/hsr-prp/hsr_prp_main.c     |  51 ++++++++++--
 net/hsr-prp/hsr_prp_main.h     |   5 ++
 net/hsr-prp/hsr_prp_netlink.c  |  80 +++++++++----------
 net/hsr-prp/hsr_prp_netlink.h  |   5 +-
 net/hsr-prp/prp_netlink.c      | 141 +++++++++++++++++++++++++++++++++
 net/hsr-prp/prp_netlink.h      |  27 +++++++
 12 files changed, 302 insertions(+), 64 deletions(-)
 create mode 100644 net/hsr-prp/prp_netlink.c
 create mode 100644 net/hsr-prp/prp_netlink.h

diff --git a/net/hsr-prp/Makefile b/net/hsr-prp/Makefile
index 76f266cd1976..9b84b0d813c2 100644
--- a/net/hsr-prp/Makefile
+++ b/net/hsr-prp/Makefile
@@ -7,5 +7,5 @@ obj-$(CONFIG_HSR_PRP)	+= hsr-prp.o
 
 hsr-prp-y		:= hsr_prp_main.o hsr_prp_framereg.o \
 			   hsr_prp_device.o hsr_netlink.o hsr_prp_slave.o \
-			   hsr_prp_forward.o hsr_prp_netlink.o
+			   hsr_prp_forward.o hsr_prp_netlink.o prp_netlink.o
 hsr-prp-$(CONFIG_DEBUG_FS) += hsr_prp_debugfs.o
diff --git a/net/hsr-prp/hsr_netlink.c b/net/hsr-prp/hsr_netlink.c
index 6bdb369ced36..f14ed521dcb2 100644
--- a/net/hsr-prp/hsr_netlink.c
+++ b/net/hsr-prp/hsr_netlink.c
@@ -32,7 +32,7 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 		       struct nlattr *tb[], struct nlattr *data[],
 		       struct netlink_ext_ack *extack)
 {
-	return hsr_prp_newlink(src_net, dev, tb, data, extack);
+	return hsr_prp_newlink(HSR, src_net, dev, tb, data, extack);
 }
 
 static struct rtnl_link_ops hsr_link_ops __read_mostly = {
@@ -40,7 +40,7 @@ static struct rtnl_link_ops hsr_link_ops __read_mostly = {
 	.maxtype	= IFLA_HSR_PRP_MAX,
 	.policy		= hsr_policy,
 	.priv_size	= sizeof(struct hsr_prp_priv),
-	.setup		= hsr_prp_dev_setup,
+	.setup		= hsr_dev_setup,
 	.newlink	= hsr_newlink,
 	.fill_info	= hsr_prp_fill_info,
 };
@@ -188,10 +188,15 @@ int __init hsr_netlink_init(void)
 	return rc;
 }
 
-void __exit hsr_netlink_exit(void)
+void hsr_nl_cleanup(void)
 {
 	genl_unregister_family(&hsr_genl_family);
 	rtnl_link_unregister(&hsr_link_ops);
 }
 
+void __exit hsr_netlink_exit(void)
+{
+	hsr_nl_cleanup();
+}
+
 MODULE_ALIAS_RTNL_LINK("hsr");
diff --git a/net/hsr-prp/hsr_netlink.h b/net/hsr-prp/hsr_netlink.h
index df3d1acb08e0..b0e96193b09f 100644
--- a/net/hsr-prp/hsr_netlink.h
+++ b/net/hsr-prp/hsr_netlink.h
@@ -18,6 +18,7 @@ struct hsr_prp_port;
 int __init hsr_netlink_init(void);
 void __exit hsr_netlink_exit(void);
 
+void hsr_nl_cleanup(void);
 void hsr_nl_ringerror(struct hsr_prp_priv *priv,
 		      unsigned char addr[ETH_ALEN],
 		      struct hsr_prp_port *port);
diff --git a/net/hsr-prp/hsr_prp_device.c b/net/hsr-prp/hsr_prp_device.c
index 43269c204445..501de23a97f5 100644
--- a/net/hsr-prp/hsr_prp_device.c
+++ b/net/hsr-prp/hsr_prp_device.c
@@ -321,7 +321,7 @@ static void hsr_prp_announce(struct timer_list *t)
 	rcu_read_lock();
 	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
 
-	if (priv->announce_count < 3 && priv->prot_version == 0) {
+	if (priv->announce_count < 3 && priv->prot_version == HSR_V0) {
 		send_hsr_prp_supervision_frame(master, HSR_TLV_ANNOUNCE,
 					       priv->prot_version);
 		priv->announce_count++;
@@ -384,11 +384,7 @@ static const struct net_device_ops hsr_prp_device_ops = {
 	.ndo_uninit = hsr_prp_dev_destroy,
 };
 
-static struct device_type hsr_type = {
-	.name = "hsr",
-};
-
-void hsr_prp_dev_setup(struct net_device *dev)
+static void hsr_prp_dev_setup(struct net_device *dev, struct device_type *type)
 {
 	eth_hw_addr_random(dev);
 
@@ -396,7 +392,7 @@ void hsr_prp_dev_setup(struct net_device *dev)
 	dev->min_mtu = 0;
 	dev->header_ops = &hsr_prp_header_ops;
 	dev->netdev_ops = &hsr_prp_device_ops;
-	SET_NETDEV_DEVTYPE(dev, &hsr_type);
+	SET_NETDEV_DEVTYPE(dev, type);
 	dev->priv_flags |= IFF_NO_QUEUE;
 
 	dev->needs_free_netdev = true;
@@ -419,6 +415,24 @@ void hsr_prp_dev_setup(struct net_device *dev)
 	dev->features |= NETIF_F_NETNS_LOCAL;
 }
 
+static struct device_type hsr_type = {
+	.name = "hsr",
+};
+
+void hsr_dev_setup(struct net_device *dev)
+{
+	hsr_prp_dev_setup(dev, &hsr_type);
+}
+
+static struct device_type prp_type = {
+	.name = "prp",
+};
+
+void prp_dev_setup(struct net_device *dev)
+{
+	hsr_prp_dev_setup(dev, &prp_type);
+}
+
 /* Return true if dev is a HSR master; return false otherwise.
  */
 inline bool is_hsr_prp_master(struct net_device *dev)
@@ -439,6 +453,10 @@ int hsr_prp_dev_finalize(struct net_device *hsr_prp_dev,
 	struct hsr_prp_priv *priv;
 	int res;
 
+	/* PRP not supported yet */
+	if (protocol_version == PRP_V1)
+		return -EPROTONOSUPPORT;
+
 	priv = netdev_priv(hsr_prp_dev);
 	INIT_LIST_HEAD(&priv->ports);
 	INIT_LIST_HEAD(&priv->node_db);
@@ -464,8 +482,6 @@ int hsr_prp_dev_finalize(struct net_device *hsr_prp_dev,
 	ether_addr_copy(priv->sup_multicast_addr, def_multicast_addr);
 	priv->sup_multicast_addr[ETH_ALEN - 1] = multicast_spec;
 
-	priv->prot_version = protocol_version;
-
 	/* FIXME: should I modify the value of these?
 	 *
 	 * - hsr_ptp_dev->flags - i.e.
diff --git a/net/hsr-prp/hsr_prp_device.h b/net/hsr-prp/hsr_prp_device.h
index 4f734a36b2d6..107f1c498442 100644
--- a/net/hsr-prp/hsr_prp_device.h
+++ b/net/hsr-prp/hsr_prp_device.h
@@ -11,7 +11,8 @@
 #include <linux/netdevice.h>
 #include "hsr_prp_main.h"
 
-void hsr_prp_dev_setup(struct net_device *dev);
+void hsr_dev_setup(struct net_device *dev);
+void prp_dev_setup(struct net_device *dev);
 int hsr_prp_dev_finalize(struct net_device *dev, struct net_device *slave[2],
 			 unsigned char multicast_spec, u8 protocol_version,
 			 struct netlink_ext_ack *extack);
diff --git a/net/hsr-prp/hsr_prp_framereg.c b/net/hsr-prp/hsr_prp_framereg.c
index d78d32d513ca..42c673befe2c 100644
--- a/net/hsr-prp/hsr_prp_framereg.c
+++ b/net/hsr-prp/hsr_prp_framereg.c
@@ -17,6 +17,7 @@
 #include "hsr_prp_main.h"
 #include "hsr_prp_framereg.h"
 #include "hsr_netlink.h"
+#include "prp_netlink.h"
 
 /*	TODO: use hash lists for mac addresses (linux/jhash.h)?    */
 
@@ -443,7 +444,10 @@ void hsr_prp_prune_nodes(struct timer_list *t)
 		/* Prune old entries */
 		if (time_is_before_jiffies(timestamp +
 				msecs_to_jiffies(HSR_PRP_NODE_FORGET_TIME))) {
-			hsr_nl_nodedown(priv, node->macaddress_A);
+			if (priv->prot_version <= HSR_V1)
+				hsr_nl_nodedown(priv, node->macaddress_A);
+			else
+				prp_nl_nodedown(priv, node->macaddress_A);
 			list_del_rcu(&node->mac_list);
 			/* Note that we need to free this entry later: */
 			kfree_rcu(node, rcu_head);
diff --git a/net/hsr-prp/hsr_prp_main.c b/net/hsr-prp/hsr_prp_main.c
index 4565744ce1a1..e7e5ca537456 100644
--- a/net/hsr-prp/hsr_prp_main.c
+++ b/net/hsr-prp/hsr_prp_main.c
@@ -12,6 +12,7 @@
 #include "hsr_prp_main.h"
 #include "hsr_prp_device.h"
 #include "hsr_netlink.h"
+#include "prp_netlink.h"
 #include "hsr_prp_framereg.h"
 #include "hsr_prp_slave.h"
 
@@ -25,6 +26,17 @@ static bool hsr_prp_slave_empty(struct hsr_prp_priv *priv)
 	return true;
 }
 
+static int hsr_prp_netdev_notify(struct notifier_block *nb, unsigned long event,
+				 void *ptr);
+
+static struct notifier_block hsr_nb = {
+	.notifier_call = hsr_prp_netdev_notify,	/* Slave event notifications */
+};
+
+static struct notifier_block prp_nb = {
+	.notifier_call = hsr_prp_netdev_notify,	/* Slave event notifications */
+};
+
 static int hsr_prp_netdev_notify(struct notifier_block *nb, unsigned long event,
 				 void *ptr)
 {
@@ -50,6 +62,11 @@ static int hsr_prp_netdev_notify(struct notifier_block *nb, unsigned long event,
 		priv = port->priv;
 	}
 
+	if (priv->prot_version <= HSR_V1 && nb != &hsr_nb)
+		return NOTIFY_DONE;
+	else if (priv->prot_version == PRP_V1 && nb != &prp_nb)
+		return NOTIFY_DONE;
+
 	switch (event) {
 	case NETDEV_UP:		/* Administrative state DOWN */
 	case NETDEV_DOWN:	/* Administrative state UP */
@@ -127,18 +144,38 @@ struct hsr_prp_port *hsr_prp_get_port(struct hsr_prp_priv *priv,
 	return NULL;
 }
 
-static struct notifier_block hsr_nb = {
-	.notifier_call = hsr_prp_netdev_notify,	/* Slave event notifications */
-};
-
 static int __init hsr_prp_init(void)
 {
 	int res;
 
 	BUILD_BUG_ON(sizeof(struct hsr_tag) != HSR_PRP_HLEN);
 
-	register_netdevice_notifier(&hsr_nb);
-	res = hsr_netlink_init();
+	res = register_netdevice_notifier(&hsr_nb);
+	if (!res)
+		res = hsr_netlink_init();
+	else
+		return res;
+
+	if (res)
+		goto cleanup_hsr_notify;
+
+	res = register_netdevice_notifier(&prp_nb);
+	if (!res)
+		res = prp_netlink_init();
+	else
+		goto cleanup_hsr_link;
+
+	if (res)
+		goto cleanup_prp_notify;
+
+	return res;
+
+cleanup_prp_notify:
+	unregister_netdevice_notifier(&prp_nb);
+cleanup_hsr_link:
+	hsr_nl_cleanup();
+cleanup_hsr_notify:
+	unregister_netdevice_notifier(&hsr_nb);
 
 	return res;
 }
@@ -146,7 +183,9 @@ static int __init hsr_prp_init(void)
 static void __exit hsr_prp_exit(void)
 {
 	unregister_netdevice_notifier(&hsr_nb);
+	unregister_netdevice_notifier(&prp_nb);
 	hsr_netlink_exit();
+	prp_netlink_exit();
 	hsr_prp_debugfs_remove_root();
 }
 
diff --git a/net/hsr-prp/hsr_prp_main.h b/net/hsr-prp/hsr_prp_main.h
index 7d9a3e009a2d..00c312e5189f 100644
--- a/net/hsr-prp/hsr_prp_main.h
+++ b/net/hsr-prp/hsr_prp_main.h
@@ -132,6 +132,8 @@ struct hsr_prp_port {
 	enum hsr_prp_port_type	type;
 };
 
+#define HSR	0
+#define PRP	1
 struct hsr_prp_priv {
 	struct rcu_head		rcu_head;
 	struct list_head	ports;
@@ -145,6 +147,9 @@ struct hsr_prp_priv {
 	u8 prot_version;	/* Indicate if HSRv0 or HSRv1. */
 	spinlock_t seqnr_lock;	/* locking for sequence_nr */
 	spinlock_t list_lock;	/* locking for node list */
+#define HSR_V0	0
+#define HSR_V1	1
+#define PRP_V1	2
 	unsigned char		sup_multicast_addr[ETH_ALEN];
 #ifdef	CONFIG_DEBUG_FS
 	struct dentry *node_tbl_root;
diff --git a/net/hsr-prp/hsr_prp_netlink.c b/net/hsr-prp/hsr_prp_netlink.c
index 04d51cd97496..865df1dbe621 100644
--- a/net/hsr-prp/hsr_prp_netlink.c
+++ b/net/hsr-prp/hsr_prp_netlink.c
@@ -12,12 +12,13 @@
 #include "hsr_prp_device.h"
 #include "hsr_prp_framereg.h"
 
-int hsr_prp_newlink(struct net *src_net, struct net_device *dev,
-		    struct nlattr *tb[], struct nlattr *data[],
+int hsr_prp_newlink(int proto, struct net *src_net,
+		    struct net_device *dev, struct nlattr *tb[],
+		    struct nlattr *data[],
 		    struct netlink_ext_ack *extack)
 {
 	struct net_device *link[2];
-	unsigned char multicast_spec, hsr_version;
+	unsigned char mc_lsb, version = 0;
 
 	if (!data) {
 		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
@@ -50,23 +51,22 @@ int hsr_prp_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	if (!data[IFLA_HSR_PRP_SF_MC_ADDR_LSB])
-		multicast_spec = 0;
+		mc_lsb = 0;
 	else
-		multicast_spec = nla_get_u8(data[IFLA_HSR_PRP_SF_MC_ADDR_LSB]);
+		mc_lsb = nla_get_u8(data[IFLA_HSR_PRP_SF_MC_ADDR_LSB]);
 
-	if (!data[IFLA_HSR_PRP_VERSION]) {
-		hsr_version = 0;
+	if (proto == PRP) {
+		version = PRP_V1;
 	} else {
-		hsr_version = nla_get_u8(data[IFLA_HSR_PRP_VERSION]);
-		if (hsr_version > 1) {
+		version = nla_get_u8(data[IFLA_HSR_PRP_VERSION]);
+		if (version > 1) {
 			NL_SET_ERR_MSG_MOD(extack,
 					   "Only versions 0..1 are supported");
 			return -EINVAL;
 		}
 	}
 
-	return hsr_prp_dev_finalize(dev, link, multicast_spec, hsr_version,
-				    extack);
+	return hsr_prp_dev_finalize(dev, link, mc_lsb, version, extack);
 }
 
 int hsr_prp_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -133,7 +133,7 @@ void hsr_prp_nl_nodedown(struct hsr_prp_priv *priv,
 fail:
 	rcu_read_lock();
 	master = hsr_prp_get_port(priv, HSR_PRP_PT_MASTER);
-	netdev_warn(master->dev, "Could not send HSR node down\n");
+	netdev_warn(master->dev, "Could not send HSR/PRP node down\n");
 	rcu_read_unlock();
 }
 
@@ -142,7 +142,7 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 {
 	/* For receiving */
 	struct nlattr *na;
-	struct net_device *hsr_dev;
+	struct net_device *ndev;
 
 	/* For sending */
 	struct sk_buff *skb_out;
@@ -150,10 +150,10 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 	struct hsr_prp_priv *priv;
 	struct hsr_prp_port *port;
 	unsigned char node_addr_b[ETH_ALEN];
-	int hsr_node_if1_age;
-	u16 hsr_node_if1_seq;
-	int hsr_node_if2_age;
-	u16 hsr_node_if2_seq;
+	int node_if1_age;
+	u16 node_if1_seq;
+	int node_if2_age;
+	u16 node_if2_seq;
 	int addr_b_ifindex;
 	int res;
 
@@ -168,12 +168,11 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 		goto invalid;
 
 	rcu_read_lock();
-	hsr_dev =
-	dev_get_by_index_rcu(genl_info_net(info),
-			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
-	if (!hsr_dev)
+	ndev = __dev_get_by_index(genl_info_net(info),
+				  nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
+	if (!ndev)
 		goto rcu_unlock;
-	if (!is_hsr_prp_master(hsr_dev))
+	if (!is_hsr_prp_master(ndev))
 		goto rcu_unlock;
 
 	/* Send reply */
@@ -191,20 +190,20 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 		goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
+	res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, ndev->ifindex);
 	if (res < 0)
 		goto nla_put_failure;
 
-	priv = netdev_priv(hsr_dev);
+	priv = netdev_priv(ndev);
 	res = hsr_prp_get_node_data(priv,
 				    (unsigned char *)
 				    nla_data(info->attrs[HSR_PRP_A_NODE_ADDR]),
 					     node_addr_b,
 					     &addr_b_ifindex,
-					     &hsr_node_if1_age,
-					     &hsr_node_if1_seq,
-					     &hsr_node_if2_age,
-					     &hsr_node_if2_seq);
+					     &node_if1_age,
+					     &node_if1_seq,
+					     &node_if2_age,
+					     &node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
 
@@ -225,10 +224,10 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 			goto nla_put_failure;
 	}
 
-	res = nla_put_u32(skb_out, HSR_PRP_A_IF1_AGE, hsr_node_if1_age);
+	res = nla_put_u32(skb_out, HSR_PRP_A_IF1_AGE, node_if1_age);
 	if (res < 0)
 		goto nla_put_failure;
-	res = nla_put_u16(skb_out, HSR_PRP_A_IF1_SEQ, hsr_node_if1_seq);
+	res = nla_put_u16(skb_out, HSR_PRP_A_IF1_SEQ, node_if1_seq);
 	if (res < 0)
 		goto nla_put_failure;
 	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_A);
@@ -238,10 +237,10 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 	if (res < 0)
 		goto nla_put_failure;
 
-	res = nla_put_u32(skb_out, HSR_PRP_A_IF2_AGE, hsr_node_if2_age);
+	res = nla_put_u32(skb_out, HSR_PRP_A_IF2_AGE, node_if2_age);
 	if (res < 0)
 		goto nla_put_failure;
-	res = nla_put_u16(skb_out, HSR_PRP_A_IF2_SEQ, hsr_node_if2_seq);
+	res = nla_put_u16(skb_out, HSR_PRP_A_IF2_SEQ, node_if2_seq);
 	if (res < 0)
 		goto nla_put_failure;
 	port = hsr_prp_get_port(priv, HSR_PRP_PT_SLAVE_B);
@@ -273,14 +272,14 @@ int hsr_prp_get_node_status(struct genl_family *genl_family,
 	return res;
 }
 
-/* Get a list of MacAddressA of all nodes known to this node (including self).
+/* Get a list of mac_address_a of all nodes known to this node (including self).
  */
 int hsr_prp_get_node_list(struct genl_family *genl_family,
 			  struct sk_buff *skb_in, struct genl_info *info)
 {
 	unsigned char addr[ETH_ALEN];
-	struct net_device *hsr_dev;
 	struct hsr_prp_priv *priv;
+	struct net_device *ndev;
 	struct sk_buff *skb_out;
 	bool restart = false;
 	struct nlattr *na;
@@ -296,12 +295,11 @@ int hsr_prp_get_node_list(struct genl_family *genl_family,
 		goto invalid;
 
 	rcu_read_lock();
-	hsr_dev =
-	dev_get_by_index_rcu(genl_info_net(info),
-			     nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
-	if (!hsr_dev)
+	ndev = __dev_get_by_index(genl_info_net(info),
+				  nla_get_u32(info->attrs[HSR_PRP_A_IFINDEX]));
+	if (!ndev)
 		goto rcu_unlock;
-	if (!is_hsr_prp_master(hsr_dev))
+	if (!is_hsr_prp_master(ndev))
 		goto rcu_unlock;
 
 restart:
@@ -321,12 +319,12 @@ int hsr_prp_get_node_list(struct genl_family *genl_family,
 	}
 
 	if (!restart) {
-		res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, hsr_dev->ifindex);
+		res = nla_put_u32(skb_out, HSR_PRP_A_IFINDEX, ndev->ifindex);
 		if (res < 0)
 			goto nla_put_failure;
 	}
 
-	priv = netdev_priv(hsr_dev);
+	priv = netdev_priv(ndev);
 
 	if (!pos)
 		pos = hsr_prp_get_next_node(priv, NULL, addr);
diff --git a/net/hsr-prp/hsr_prp_netlink.h b/net/hsr-prp/hsr_prp_netlink.h
index a3a4e6252e45..5bd0f8cf2644 100644
--- a/net/hsr-prp/hsr_prp_netlink.h
+++ b/net/hsr-prp/hsr_prp_netlink.h
@@ -13,8 +13,9 @@
 
 #include "hsr_prp_main.h"
 
-int hsr_prp_newlink(struct net *src_net, struct net_device *dev,
-		    struct nlattr *tb[], struct nlattr *data[],
+int hsr_prp_newlink(int proto, struct net *src_net,
+		    struct net_device *dev, struct nlattr *tb[],
+		    struct nlattr *data[],
 		    struct netlink_ext_ack *extack);
 int hsr_prp_fill_info(struct sk_buff *skb, const struct net_device *dev);
 void hsr_prp_nl_nodedown(struct hsr_prp_priv *priv,
diff --git a/net/hsr-prp/prp_netlink.c b/net/hsr-prp/prp_netlink.c
new file mode 100644
index 000000000000..d6c0a64e0a84
--- /dev/null
+++ b/net/hsr-prp/prp_netlink.c
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+/* This is based on hsr_netlink.c from Arvid Brodin, arvid.brodin@alten.se
+ *
+ * Copyright (C) 2020 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Author(s):
+ *	Murali Karicheri <m-karicheri2@ti.com>
+ *	Routines for handling Netlink messages for PRP
+ */
+
+#include <linux/kernel.h>
+#include <net/genetlink.h>
+#include <net/rtnetlink.h>
+
+#include "prp_netlink.h"
+#include "hsr_prp_netlink.h"
+#include "hsr_prp_main.h"
+#include "hsr_prp_device.h"
+#include "hsr_prp_framereg.h"
+
+static const struct nla_policy prp_policy[IFLA_HSR_PRP_MAX + 1] = {
+	[IFLA_HSR_PRP_SLAVE1]		= { .type = NLA_U32 },
+	[IFLA_HSR_PRP_SLAVE2]		= { .type = NLA_U32 },
+	[IFLA_HSR_PRP_SF_MC_ADDR_LSB]	= { .type = NLA_U8 },
+	[IFLA_HSR_PRP_SF_MC_ADDR]	= { .len = ETH_ALEN },
+	[IFLA_HSR_PRP_SEQ_NR]		= { .type = NLA_U16 },
+};
+
+/* Here, it seems a netdevice has already been allocated for us, and the
+ * hsr_prp_dev_setup routine has been executed. Nice!
+ */
+static int prp_newlink(struct net *src_net, struct net_device *dev,
+		       struct nlattr *tb[], struct nlattr *data[],
+		       struct netlink_ext_ack *extack)
+{
+	return hsr_prp_newlink(PRP, src_net, dev, tb, data, extack);
+}
+
+static struct rtnl_link_ops prp_link_ops __read_mostly = {
+	.kind		= "prp",
+	.maxtype	= IFLA_HSR_PRP_MAX,
+	.policy		= prp_policy,
+	.priv_size	= sizeof(struct hsr_prp_priv),
+	.setup		= prp_dev_setup,
+	.newlink	= prp_newlink,
+	.fill_info	= hsr_prp_fill_info,
+};
+
+/* NLA_BINARY missing in libnl; use NLA_UNSPEC in userspace instead. */
+static const struct nla_policy prp_genl_policy[HSR_PRP_A_MAX + 1] = {
+	[HSR_PRP_A_NODE_ADDR] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[HSR_PRP_A_NODE_ADDR_B] = { .type = NLA_BINARY, .len = ETH_ALEN },
+	[HSR_PRP_A_IFINDEX] = { .type = NLA_U32 },
+	[HSR_PRP_A_IF1_AGE] = { .type = NLA_U32 },
+	[HSR_PRP_A_IF2_AGE] = { .type = NLA_U32 },
+	[HSR_PRP_A_IF1_SEQ] = { .type = NLA_U16 },
+	[HSR_PRP_A_IF2_SEQ] = { .type = NLA_U16 },
+};
+
+static struct genl_family prp_genl_family;
+
+static const struct genl_multicast_group prp_mcgrps[] = {
+	{ .name = "prp-network", },
+};
+
+/* This is called when we haven't heard from the node with MAC address addr for
+ * some time (just before the node is removed from the node table/list).
+ */
+void prp_nl_nodedown(struct hsr_prp_priv *priv, unsigned char addr[ETH_ALEN])
+{
+	hsr_prp_nl_nodedown(priv, &prp_genl_family, addr);
+}
+
+static int prp_get_node_status(struct sk_buff *skb_in, struct genl_info *info)
+{
+	return hsr_prp_get_node_status(&prp_genl_family, skb_in, info);
+}
+
+static int prp_get_node_list(struct sk_buff *skb_in, struct genl_info *info)
+{
+	return hsr_prp_get_node_list(&prp_genl_family, skb_in, info);
+}
+
+static const struct genl_ops prp_ops[] = {
+	{
+		.cmd = HSR_PRP_C_GET_NODE_STATUS,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = 0,
+		.doit = prp_get_node_status,
+		.dumpit = NULL,
+	},
+	{
+		.cmd = HSR_PRP_C_GET_NODE_LIST,
+		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.flags = 0,
+		.doit = prp_get_node_list,
+		.dumpit = NULL,
+	},
+};
+
+static struct genl_family prp_genl_family __ro_after_init = {
+	.hdrsize = 0,
+	.name = "PRP",
+	.version = 1,
+	.maxattr = HSR_PRP_A_MAX,
+	.policy = prp_genl_policy,
+	.module = THIS_MODULE,
+	.ops = prp_ops,
+	.n_ops = ARRAY_SIZE(prp_ops),
+	.mcgrps = prp_mcgrps,
+	.n_mcgrps = ARRAY_SIZE(prp_mcgrps),
+};
+
+int __init prp_netlink_init(void)
+{
+	int rc;
+
+	rc = rtnl_link_register(&prp_link_ops);
+	if (rc)
+		goto fail_rtnl_link_register;
+
+	rc = genl_register_family(&prp_genl_family);
+	if (rc)
+		goto fail_genl_register_family;
+
+	return 0;
+
+fail_genl_register_family:
+	rtnl_link_unregister(&prp_link_ops);
+fail_rtnl_link_register:
+
+	return rc;
+}
+
+void __exit prp_netlink_exit(void)
+{
+	genl_unregister_family(&prp_genl_family);
+	rtnl_link_unregister(&prp_link_ops);
+}
+
+MODULE_ALIAS_RTNL_LINK("prp");
diff --git a/net/hsr-prp/prp_netlink.h b/net/hsr-prp/prp_netlink.h
new file mode 100644
index 000000000000..ad43b33b5bfb
--- /dev/null
+++ b/net/hsr-prp/prp_netlink.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* prp_netlink.h:
+ * This is based on hsr_netlink.h from Arvid Brodin, arvid.brodin@alten.se
+ *
+ * Copyright (C) 2017-2020 Texas Instruments Incorporated - http://www.ti.com
+ *
+ * Author(s):
+ *	Murali Karicheri <m-karicheri2@ti.com>
+ */
+
+#ifndef __PRP_NETLINK_H
+#define __PRP_NETLINK_H
+
+#include <linux/if_ether.h>
+#include <linux/module.h>
+
+#include <uapi/linux/hsr_prp_netlink.h>
+
+struct hsr_prp_priv;
+struct hsr_prp_port;
+
+int __init prp_netlink_init(void);
+void __exit prp_netlink_exit(void);
+
+void prp_nl_nodedown(struct hsr_prp_priv *priv, unsigned char addr[ETH_ALEN]);
+
+#endif /* __PRP_NETLINK_H */
-- 
2.17.1

