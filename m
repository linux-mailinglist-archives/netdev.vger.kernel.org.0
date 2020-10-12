Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF0628BA3A
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 16:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403816AbgJLOHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 10:07:03 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:23637 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391125AbgJLOGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 10:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602511609; x=1634047609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VKxwr4NlEdUKM+raaIoybU4fTvA/IgUNXYamCppVHXQ=;
  b=crq+h1SNbICkpCqFtrl7Warld7YayaxZdULbFNlx1+4ZBljfeR8sULfy
   5Ktb6o5sHmbxPkFea432MHcgZ5HlWm2ISr2kz+ogOc2PFf7Ds9PuVUe0q
   PocuUXD0jBjBMcc4rKnUU8SFmrh0IQs2RD3AGEgfX30e0WscSUaGhkTO/
   mpSvV1lIG4cazhzc8QVgBpY2RtdoFKi4Pe7tL8VyTYU38OWvybuXtuBHk
   cMn5axyMXWOJDiosrmL9o+BImVdkExx+MNGooM4yyC51d1IFBV3EyU3Cj
   fYLokyhn08hZEJ4MglxS5XSM0ocJxkRQzkZPpdyPaulFbjNBFa1/LdSme
   A==;
IronPort-SDR: TkZbqAGngT5gNFWhRAOM0wneNk6FlW5zobqXj9ux40HYvqdDl4/0ykoG+/D6QuFi1hQWoV4MYV
 ZEv3R8I+QFfOGlnk+ci5Qhsrk6Zl+KXxe0Cd2kEEdtKJD1giRViuc8WCeedFf/q24VGx8LMAh+
 wT2eYNogGIYPPlsvT78ps5R5D3lDRUK8Zvncw7EJwUckW6Vv83MvhTCpiyOcgqIHGbTNNLb7hK
 Jwia6KiIIDpVLSdbWdW1dcKREjvY29qcvY8yOmArD0m4nGu6NNc2YO1u+vcfTXliJUG/TkXcst
 oy8=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="29560812"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 07:06:24 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 07:06:24 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 12 Oct 2020 07:06:21 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v5 01/10] net: bridge: extend the process of special frames
Date:   Mon, 12 Oct 2020 14:04:19 +0000
Message-ID: <20201012140428.2549163-2-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch extends the processing of frames in the bridge. Currently MRP
frames needs special processing and the current implementation doesn't
allow a nice way to process different frame types. Therefore try to
improve this by adding a list that contains frame types that need
special processing. This list is iterated for each input frame and if
there is a match based on frame type then these functions will be called
and decide what to do with the frame. It can process the frame then the
bridge doesn't need to do anything or don't process so then the bridge
will do normal forwarding.

Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
---
 net/bridge/br_device.c  |  1 +
 net/bridge/br_input.c   | 33 ++++++++++++++++++++++++++++++++-
 net/bridge/br_mrp.c     | 19 +++++++++++++++----
 net/bridge/br_private.h | 19 ++++++++++++-------
 4 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 9a2fb4aa1a10..206c4ba51cd2 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -473,6 +473,7 @@ void br_dev_setup(struct net_device *dev)
 	spin_lock_init(&br->lock);
 	INIT_LIST_HEAD(&br->port_list);
 	INIT_HLIST_HEAD(&br->fdb_list);
+	INIT_HLIST_HEAD(&br->frame_type_list);
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	INIT_LIST_HEAD(&br->mrp_list);
 #endif
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 59a318b9f646..bece03bf83c4 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -254,6 +254,21 @@ static int nf_hook_bridge_pre(struct sk_buff *skb, struct sk_buff **pskb)
 	return RX_HANDLER_CONSUMED;
 }
 
+/* Return 0 if the frame was not processed otherwise 1
+ * note: already called with rcu_read_lock
+ */
+static int br_process_frame_type(struct net_bridge_port *p,
+				 struct sk_buff *skb)
+{
+	struct br_frame_type *tmp;
+
+	hlist_for_each_entry_rcu(tmp, &p->br->frame_type_list, list)
+		if (unlikely(tmp->type == skb->protocol))
+			return tmp->frame_handler(p, skb);
+
+	return 0;
+}
+
 /*
  * Return NULL if skb is handled
  * note: already called with rcu_read_lock
@@ -343,7 +358,7 @@ static rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		}
 	}
 
-	if (unlikely(br_mrp_process(p, skb)))
+	if (unlikely(br_process_frame_type(p, skb)))
 		return RX_HANDLER_PASS;
 
 forward:
@@ -380,3 +395,19 @@ rx_handler_func_t *br_get_rx_handler(const struct net_device *dev)
 
 	return br_handle_frame;
 }
+
+void br_add_frame(struct net_bridge *br, struct br_frame_type *ft)
+{
+	hlist_add_head_rcu(&ft->list, &br->frame_type_list);
+}
+
+void br_del_frame(struct net_bridge *br, struct br_frame_type *ft)
+{
+	struct br_frame_type *tmp;
+
+	hlist_for_each_entry(tmp, &br->frame_type_list, list)
+		if (ft == tmp) {
+			hlist_del_rcu(&ft->list);
+			return;
+		}
+}
diff --git a/net/bridge/br_mrp.c b/net/bridge/br_mrp.c
index b36689e6e7cb..f94d72bb7c32 100644
--- a/net/bridge/br_mrp.c
+++ b/net/bridge/br_mrp.c
@@ -6,6 +6,13 @@
 static const u8 mrp_test_dmac[ETH_ALEN] = { 0x1, 0x15, 0x4e, 0x0, 0x0, 0x1 };
 static const u8 mrp_in_test_dmac[ETH_ALEN] = { 0x1, 0x15, 0x4e, 0x0, 0x0, 0x3 };
 
+static int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
+
+static struct br_frame_type mrp_frame_type __read_mostly = {
+	.type = cpu_to_be16(ETH_P_MRP),
+	.frame_handler = br_mrp_process,
+};
+
 static bool br_mrp_is_ring_port(struct net_bridge_port *p_port,
 				struct net_bridge_port *s_port,
 				struct net_bridge_port *port)
@@ -445,6 +452,9 @@ static void br_mrp_del_impl(struct net_bridge *br, struct br_mrp *mrp)
 
 	list_del_rcu(&mrp->list);
 	kfree_rcu(mrp, rcu);
+
+	if (list_empty(&br->mrp_list))
+		br_del_frame(br, &mrp_frame_type);
 }
 
 /* Adds a new MRP instance.
@@ -493,6 +503,9 @@ int br_mrp_add(struct net_bridge *br, struct br_mrp_instance *instance)
 	spin_unlock_bh(&br->lock);
 	rcu_assign_pointer(mrp->s_port, p);
 
+	if (list_empty(&br->mrp_list))
+		br_add_frame(br, &mrp_frame_type);
+
 	INIT_DELAYED_WORK(&mrp->test_work, br_mrp_test_work_expired);
 	INIT_DELAYED_WORK(&mrp->in_test_work, br_mrp_in_test_work_expired);
 	list_add_tail_rcu(&mrp->list, &br->mrp_list);
@@ -1172,15 +1185,13 @@ static int br_mrp_rcv(struct net_bridge_port *p,
  * normal forwarding.
  * note: already called with rcu_read_lock
  */
-int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
+static int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
 {
 	/* If there is no MRP instance do normal forwarding */
 	if (likely(!(p->flags & BR_MRP_AWARE)))
 		goto out;
 
-	if (unlikely(skb->protocol == htons(ETH_P_MRP)))
-		return br_mrp_rcv(p, skb, p->dev);
-
+	return br_mrp_rcv(p, skb, p->dev);
 out:
 	return 0;
 }
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 345118e35c42..2fe8b88d090e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -383,7 +383,7 @@ enum net_bridge_opts {
 struct net_bridge {
 	spinlock_t			lock;
 	spinlock_t			hash_lock;
-	struct list_head		port_list;
+	struct hlist_head		frame_type_list;
 	struct net_device		*dev;
 	struct pcpu_sw_netstats		__percpu *stats;
 	unsigned long			options;
@@ -395,6 +395,7 @@ struct net_bridge {
 #endif
 
 	struct rhashtable		fdb_hash_tbl;
+	struct list_head		port_list;
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	union {
 		struct rtable		fake_rtable;
@@ -755,6 +756,16 @@ int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
 
+struct br_frame_type {
+	__be16			type;
+	int			(*frame_handler)(struct net_bridge_port *port,
+						 struct sk_buff *skb);
+	struct hlist_node	list;
+};
+
+void br_add_frame(struct net_bridge *br, struct br_frame_type *ft);
+void br_del_frame(struct net_bridge *br, struct br_frame_type *ft);
+
 static inline bool br_rx_handler_check_rcu(const struct net_device *dev)
 {
 	return rcu_dereference(dev->rx_handler) == br_get_rx_handler(dev);
@@ -1417,7 +1428,6 @@ extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr)
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
-int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
 bool br_mrp_enabled(struct net_bridge *br);
 void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
 int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br);
@@ -1429,11 +1439,6 @@ static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 	return -EOPNOTSUPP;
 }
 
-static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
-{
-	return 0;
-}
-
 static inline bool br_mrp_enabled(struct net_bridge *br)
 {
 	return false;
-- 
2.28.0

