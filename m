Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B4E27FD5A
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731986AbgJAKcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:32:43 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:19704 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgJAKcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1601548358; x=1633084358;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=acVWUt6NgBOkQEdqnYmHqpeVq1d7tfhgx7v9Ior6zWA=;
  b=SXdJEwMv1XPUd56B5GWxS19M9g8VHr6oYrZSAoylxVK4xLc0MYh1ArtI
   itegQ6AszB8vvGhCmcIsZFhaOV7z7nODGAncO1bZzAwJZrz3UvVn/TrSb
   YBR+6JjyxpzWrxj0prhBmGbE5huhlWN+8tkoxyy5F6Ab031hphZtkWqlS
   YXSSc1UiAIy+lDCZJE+7Hcs4Y0XFxF+FaqIEZUo1gH0LmpiDrMuqEm9rb
   Dob3iPR++R5I+Gtk0eCsd1IuPpdnBzdWOF4rSV2MfL8iby4HvNs/zw5Ou
   c+rLys8ZI2uUVSDBvtjFcY4WECWM7Bk8R0hLkN5sYUgaHMcPeG/XoQ8nG
   w==;
IronPort-SDR: pWwFaJL4M16UCJ5iWVcTm68LGEs18grcsNSirHvvwn49aD5HxPBZ7qyNW8HFHmnxVWwuw6VQZY
 8WWhZmIqfHS4DDB+K5ugKCXxnKqJxfqh/P8S1ckly1mcx1TbRlkA8fHmQylXqRA6Xraysgtk5I
 Q4ZqyQ9Ma2N036q+E7KTje+IkGfuvztzSymzPUtKk4EdfC0yop5uSUmSLHoKU+PLNUbYhPEZD9
 PPrC9blrKo4zscAl70yNLzp91uDm8JOO7VFI1cewSfafsmHaf7WJWf9VQTjEHueSZFAZIrEvBn
 VUw=
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="28360879"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Oct 2020 03:32:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 03:32:12 -0700
Received: from soft-test08.microsemi.net (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Thu, 1 Oct 2020 03:32:10 -0700
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <UNGLinuxDriver@microchip.com>
CC:     Henrik Bjoernlund <henrik.bjoernlund@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [net-next v2 01/11] net: bridge: extend the process of special frames
Date:   Thu, 1 Oct 2020 10:30:09 +0000
Message-ID: <20201001103019.1342470-2-henrik.bjoernlund@microchip.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
References: <20201001103019.1342470-1-henrik.bjoernlund@microchip.com>
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

Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
---
 net/bridge/br_device.c  |  1 +
 net/bridge/br_input.c   | 31 ++++++++++++++++++++++++++++++-
 net/bridge/br_mrp.c     | 19 +++++++++++++++----
 net/bridge/br_private.h | 18 ++++++++++++------
 4 files changed, 58 insertions(+), 11 deletions(-)

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
index 59a318b9f646..8b2638cb550d 100644
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
@@ -380,3 +395,17 @@ rx_handler_func_t *br_get_rx_handler(const struct net_device *dev)
 
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
+		if (ft == tmp)
+			hlist_del_rcu(&ft->list);
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
index 345118e35c42..747f6f08f439 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -89,6 +89,13 @@ struct bridge_mcast_stats {
 };
 #endif
 
+struct br_frame_type {
+	__be16			type;
+	int			(*frame_handler)(struct net_bridge_port *port,
+						 struct sk_buff *skb);
+	struct hlist_node	list;
+};
+
 struct br_vlan_stats {
 	u64 rx_bytes;
 	u64 rx_packets;
@@ -480,6 +487,8 @@ struct net_bridge {
 #endif
 	struct hlist_head		fdb_list;
 
+	struct hlist_head		frame_type_list;
+
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 	struct list_head		mrp_list;
 #endif
@@ -755,6 +764,9 @@ int nbp_backup_change(struct net_bridge_port *p, struct net_device *backup_dev);
 int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb);
 rx_handler_func_t *br_get_rx_handler(const struct net_device *dev);
 
+void br_add_frame(struct net_bridge *br, struct br_frame_type *ft);
+void br_del_frame(struct net_bridge *br, struct br_frame_type *ft);
+
 static inline bool br_rx_handler_check_rcu(const struct net_device *dev)
 {
 	return rcu_dereference(dev->rx_handler) == br_get_rx_handler(dev);
@@ -1417,7 +1429,6 @@ extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr)
 #if IS_ENABLED(CONFIG_BRIDGE_MRP)
 int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
 		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
-int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
 bool br_mrp_enabled(struct net_bridge *br);
 void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
 int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br);
@@ -1429,11 +1440,6 @@ static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
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

