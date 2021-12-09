Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEE346E856
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237343AbhLIMZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:25:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237317AbhLIMY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 07:24:59 -0500
X-Greylist: delayed 377 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 09 Dec 2021 04:21:25 PST
Received: from eidolon.nox.tf (eidolon.nox.tf [IPv6:2a07:2ec0:2185::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D51C061746
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 04:21:25 -0800 (PST)
Received: from [2a02:3038:403:e467:ff71:9e4d:df8:31c8] (helo=areia)
        by eidolon.nox.tf with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <equinox@diac24.net>)
        id 1mvIKF-00BM1G-8I; Thu, 09 Dec 2021 13:15:04 +0100
Received: from equinox by areia with local (Exim 4.95)
        (envelope-from <equinox@diac24.net>)
        id 1mvIJr-001zJ1-Qw;
        Thu, 09 Dec 2021 13:14:39 +0100
From:   David Lamparter <equinox@diac24.net>
To:     netdev@vger.kernel.org
Cc:     David Lamparter <equinox@diac24.net>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Alexandra Winter <wintera@linux.ibm.com>
Subject: [PATCH] bridge: extend BR_ISOLATE to full split-horizon
Date:   Thu,  9 Dec 2021 13:14:32 +0100
Message-Id: <20211209121432.473979-1-equinox@diac24.net>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split-horizon essentially just means being able to create multiple
groups of isolated ports that are isolated within the group, but not
with respect to each other.

The intent is very different, while isolation is a policy feature,
split-horizon is intended to provide functional "multiple member ports
are treated as one for loop avoidance."  But it boils down to the same
thing in the end.

Signed-off-by: David Lamparter <equinox@diac24.net>
Cc: Nikolay Aleksandrov <nikolay@nvidia.com>
Cc: Alexandra Winter <wintera@linux.ibm.com>
---

Alexandra, could you double check my change to the qeth_l2 driver?  I
can't really test it...

Cheers,

David
---
 drivers/s390/net/qeth_l2_main.c | 10 ++++++----
 include/linux/if_bridge.h       |  9 ++++++++-
 include/uapi/linux/if_link.h    |  1 +
 net/bridge/br_if.c              | 12 ++++++++++++
 net/bridge/br_input.c           |  2 +-
 net/bridge/br_netlink.c         | 33 +++++++++++++++++++++++++++++++--
 net/bridge/br_private.h         | 13 ++++++++++---
 net/bridge/br_sysfs_if.c        | 33 ++++++++++++++++++++++++++++++++-
 8 files changed, 101 insertions(+), 12 deletions(-)

diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 303461d70af3..405d36757c22 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -729,8 +729,8 @@ static bool qeth_l2_must_learn(struct net_device *netdev,
 	priv = netdev_priv(netdev);
 	return (netdev != dstdev &&
 		(priv->brport_features & BR_LEARNING_SYNC) &&
-		!(br_port_flag_is_set(netdev, BR_ISOLATED) &&
-		  br_port_flag_is_set(dstdev, BR_ISOLATED)) &&
+		!(br_port_horizon_group(netdev) != 0 &&
+		  br_port_horizon_group(netdev) == br_port_horizon_group(dstdev)) &&
 		(netdev->netdev_ops == &qeth_l2_iqd_netdev_ops ||
 		 netdev->netdev_ops == &qeth_l2_osa_netdev_ops));
 }
@@ -757,6 +757,7 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	struct net_device *lowerdev;
 	struct list_head *iter;
 	int err = 0;
+	u32 horizon_group;
 
 	kfree(br2dev_event_work);
 	QETH_CARD_TEXT_(card, 4, "b2dw%04lx", event);
@@ -770,12 +771,13 @@ static void qeth_l2_br2dev_worker(struct work_struct *work)
 	if (!qeth_l2_must_learn(lsyncdev, dstdev))
 		goto unlock;
 
-	if (br_port_flag_is_set(lsyncdev, BR_ISOLATED)) {
+	horizon_group = br_port_horizon_group(lsyncdev);
+	if (horizon_group) {
 		/* Update lsyncdev and its isolated sibling(s): */
 		iter = &brdev->adj_list.lower;
 		lowerdev = netdev_next_lower_dev_rcu(brdev, &iter);
 		while (lowerdev) {
-			if (br_port_flag_is_set(lowerdev, BR_ISOLATED)) {
+			if (br_port_horizon_group(lowerdev) == horizon_group) {
 				switch (event) {
 				case SWITCHDEV_FDB_ADD_TO_DEVICE:
 					err = dev_uc_add(lowerdev, addr);
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index 509e18c7e740..a9738cb40066 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -53,7 +53,7 @@ struct br_ip_list {
 #define BR_VLAN_TUNNEL		BIT(13)
 #define BR_BCAST_FLOOD		BIT(14)
 #define BR_NEIGH_SUPPRESS	BIT(15)
-#define BR_ISOLATED		BIT(16)
+/* BR_ISOLATED - previously BIT(16) */
 #define BR_MRP_AWARE		BIT(17)
 #define BR_MRP_LOST_CONT	BIT(18)
 #define BR_MRP_LOST_IN_CONT	BIT(19)
@@ -158,6 +158,7 @@ struct net_device *br_fdb_find_port(const struct net_device *br_dev,
 				    __u16 vid);
 void br_fdb_clear_offload(const struct net_device *dev, u16 vid);
 bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag);
+u32 br_port_horizon_group(const struct net_device *dev);
 u8 br_port_get_stp_state(const struct net_device *dev);
 clock_t br_get_ageing_time(const struct net_device *br_dev);
 #else
@@ -179,6 +180,12 @@ br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
 	return false;
 }
 
+static inline u32
+br_port_horizon_group(const struct net_device *dev)
+{
+	return 0;
+}
+
 static inline u8 br_port_get_stp_state(const struct net_device *dev)
 {
 	return BR_STATE_DISABLED;
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4ac53b30b6dc..d3a65ae33a62 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -536,6 +536,7 @@ enum {
 	IFLA_BRPORT_MRP_IN_OPEN,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
+	IFLA_BRPORT_HORIZON_GROUP,	/* split-horizon (isolation) index */
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a52ad81596b7..837d8e2fd191 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -784,3 +784,15 @@ bool br_port_flag_is_set(const struct net_device *dev, unsigned long flag)
 	return p->flags & flag;
 }
 EXPORT_SYMBOL_GPL(br_port_flag_is_set);
+
+u32 br_port_horizon_group(const struct net_device *dev)
+{
+	struct net_bridge_port *p;
+
+	p = br_port_get_rtnl_rcu(dev);
+	if (!p)
+		return 0;
+
+	return p->horizon_group;
+}
+EXPORT_SYMBOL_GPL(br_port_horizon_group);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index b50382f957c1..b0d71d01bc02 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -112,7 +112,7 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
 		goto drop;
 
 	BR_INPUT_SKB_CB(skb)->brdev = br->dev;
-	BR_INPUT_SKB_CB(skb)->src_port_isolated = !!(p->flags & BR_ISOLATED);
+	BR_INPUT_SKB_CB(skb)->src_horizon_group = p->horizon_group;
 
 	if (IS_ENABLED(CONFIG_INET) &&
 	    (skb->protocol == htons(ETH_P_ARP) ||
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 0c8b5f1a15bc..eb139a73cbbf 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -203,6 +203,7 @@ static inline size_t br_port_info_size(void)
 		+ nla_total_size(sizeof(u8))	/* IFLA_BRPORT_MRP_IN_OPEN */
 		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT */
 		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_MCAST_EHT_HOSTS_CNT */
+		+ nla_total_size(sizeof(u32))	/* IFLA_BRPORT_HORIZON_GROUP */
 		+ 0;
 }
 
@@ -269,7 +270,8 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 							  BR_MRP_LOST_CONT)) ||
 	    nla_put_u8(skb, IFLA_BRPORT_MRP_IN_OPEN,
 		       !!(p->flags & BR_MRP_LOST_IN_CONT)) ||
-	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!(p->flags & BR_ISOLATED)))
+	    nla_put_u8(skb, IFLA_BRPORT_ISOLATED, !!p->horizon_group) ||
+	    nla_put_u32(skb, IFLA_BRPORT_HORIZON_GROUP, p->horizon_group))
 		return -EMSGSIZE;
 
 	timerval = br_timer_value(&p->message_age_timer);
@@ -829,6 +831,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
 	[IFLA_BRPORT_ISOLATED]	= { .type = NLA_U8 },
 	[IFLA_BRPORT_BACKUP_PORT] = { .type = NLA_U32 },
 	[IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT] = { .type = NLA_U32 },
+	[IFLA_BRPORT_HORIZON_GROUP] = NLA_POLICY_MIN(NLA_S32, 0),
 };
 
 /* Change the state of the port and notify spanning tree */
@@ -874,6 +877,21 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	bool br_vlan_tunnel_old;
 	int err;
 
+	if (tb[IFLA_BRPORT_ISOLATED] && tb[IFLA_BRPORT_HORIZON_GROUP]) {
+		if (nla_get_u8(tb[IFLA_BRPORT_ISOLATED]) &&
+		    nla_get_u32(tb[IFLA_BRPORT_HORIZON_GROUP]) == 0) {
+			NL_SET_ERR_MSG(extack,
+				       "HORIZON_GROUP must be non-zero for ISOLATED flag");
+			return -EINVAL;
+		}
+		if (!nla_get_u8(tb[IFLA_BRPORT_ISOLATED]) &&
+		    nla_get_u32(tb[IFLA_BRPORT_HORIZON_GROUP]) != 0) {
+			NL_SET_ERR_MSG(extack,
+				       "ISOLATED cannot be unset with nonzero HORIZON_GROUP");
+			return -EINVAL;
+		}
+	}
+
 	old_flags = p->flags;
 	br_vlan_tunnel_old = (old_flags & BR_VLAN_TUNNEL) ? true : false;
 
@@ -892,7 +910,6 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 	br_set_port_flag(p, tb, IFLA_BRPORT_PROXYARP_WIFI, BR_PROXYARP_WIFI);
 	br_set_port_flag(p, tb, IFLA_BRPORT_VLAN_TUNNEL, BR_VLAN_TUNNEL);
 	br_set_port_flag(p, tb, IFLA_BRPORT_NEIGH_SUPPRESS, BR_NEIGH_SUPPRESS);
-	br_set_port_flag(p, tb, IFLA_BRPORT_ISOLATED, BR_ISOLATED);
 
 	changed_mask = old_flags ^ p->flags;
 
@@ -973,6 +990,18 @@ static int br_setport(struct net_bridge_port *p, struct nlattr *tb[],
 			return err;
 	}
 
+	if (tb[IFLA_BRPORT_HORIZON_GROUP]) {
+		p->horizon_group = nla_get_u32(tb[IFLA_BRPORT_HORIZON_GROUP]);
+	} else if (tb[IFLA_BRPORT_ISOLATED]) {
+		u8 isolated = nla_get_u8(tb[IFLA_BRPORT_ISOLATED]);
+
+		/* don't trample other values set by HORIZON_GROUP */
+		if (isolated && p->horizon_group == 0)
+			p->horizon_group = 1;
+		else if (!isolated)
+			p->horizon_group = 0;
+	}
+
 	return 0;
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index af2b3512d86c..7916f0aa39de 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -353,6 +353,12 @@ struct net_bridge_port {
 #endif
 	struct net_bridge_port		__rcu *backup_port;
 
+	/* Ports with the *same* non-zero horizon_group are isolated from
+	 * each other.  Zero or *differing* horizon_group forwards normally.
+	 * UAPI limited to positive signed int. (recommended ifindex namespace)
+	 */
+	u32				horizon_group;
+
 	/* STP */
 	u8				priority;
 	u8				state;
@@ -539,13 +545,14 @@ struct net_bridge {
 struct br_input_skb_cb {
 	struct net_device *brdev;
 
+	u32 src_horizon_group;
+
 	u16 frag_max_size;
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	u8 igmp;
 	u8 mrouters_only:1;
 #endif
 	u8 proxyarp_replied:1;
-	u8 src_port_isolated:1;
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
 	u8 vlan_filtered:1;
 #endif
@@ -811,8 +818,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 static inline bool br_skb_isolated(const struct net_bridge_port *to,
 				   const struct sk_buff *skb)
 {
-	return BR_INPUT_SKB_CB(skb)->src_port_isolated &&
-	       (to->flags & BR_ISOLATED);
+	return BR_INPUT_SKB_CB(skb)->src_horizon_group &&
+		BR_INPUT_SKB_CB(skb)->src_horizon_group == to->horizon_group;
 }
 
 /* br_if.c */
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 07fa76080512..0344315b6f37 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -239,7 +239,37 @@ BRPORT_ATTR_FLAG(proxyarp_wifi, BR_PROXYARP_WIFI);
 BRPORT_ATTR_FLAG(multicast_flood, BR_MCAST_FLOOD);
 BRPORT_ATTR_FLAG(broadcast_flood, BR_BCAST_FLOOD);
 BRPORT_ATTR_FLAG(neigh_suppress, BR_NEIGH_SUPPRESS);
-BRPORT_ATTR_FLAG(isolated, BR_ISOLATED);
+
+static ssize_t show_isolated(struct net_bridge_port *p, char *buf)
+{
+	return sprintf(buf, "%u\n", !!p->horizon_group);
+}
+
+static int br_set_isolated(struct net_bridge_port *p, unsigned long val)
+{
+	if (val == 0)
+		p->horizon_group = 0;
+	else if (p->horizon_group == 0)
+		p->horizon_group = 1;
+	return 0;
+}
+static BRPORT_ATTR(isolated, 0644, show_isolated, br_set_isolated);
+
+static ssize_t show_horizon_group(struct net_bridge_port *p, char *buf)
+{
+	return sprintf(buf, "%u\n", p->horizon_group);
+}
+
+static int br_set_horizon_group(struct net_bridge_port *p, unsigned long val)
+{
+	if (val > INT_MAX)
+		return -EINVAL;
+
+	p->horizon_group = val;
+	return 0;
+}
+static BRPORT_ATTR(horizon_group, 0644, show_horizon_group,
+		   br_set_horizon_group);
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 static ssize_t show_multicast_router(struct net_bridge_port *p, char *buf)
@@ -292,6 +322,7 @@ static const struct brport_attribute *brport_attrs[] = {
 	&brport_attr_group_fwd_mask,
 	&brport_attr_neigh_suppress,
 	&brport_attr_isolated,
+	&brport_attr_horizon_group,
 	&brport_attr_backup_port,
 	NULL
 };
-- 
2.34.1

