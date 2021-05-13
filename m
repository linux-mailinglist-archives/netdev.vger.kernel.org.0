Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5136837F8AA
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhEMNXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:23:20 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:52992 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234023AbhEMNWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:22:32 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5258941007;
        Thu, 13 May 2021 15:21:07 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v4 09/11] net: bridge: mcast: split multicast router state for IPv4 and IPv6
Date:   Thu, 13 May 2021 15:20:51 +0200
Message-Id: <20210513132053.23445-10-linus.luessing@c0d3.blue>
In-Reply-To: <20210513132053.23445-1-linus.luessing@c0d3.blue>
References: <20210513132053.23445-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A multicast router for IPv4 does not imply that the same host also is a
multicast router for IPv6 and vice versa.

To reduce multicast traffic when a host is only a multicast router for
one of these two protocol families, keep router state for IPv4 and IPv6
separately. Similar to how querier state is kept separately.

For backwards compatibility for netlink and switchdev notifications
these two will still only notify if a port switched from either no
IPv4/IPv6 multicast router to any IPv4/IPv6 multicast router or the
other way round. However a full netlink MDB router dump will now also
include a multicast router timeout for both IPv4 and IPv6.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_mdb.c       |  10 +++
 net/bridge/br_multicast.c | 134 ++++++++++++++++++++++++++++++++++++--
 net/bridge/br_private.h   |  14 +++-
 3 files changed, 151 insertions(+), 7 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 482edb9..10c416c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -18,7 +18,12 @@
 
 static bool br_rports_have_mc_router(struct net_bridge *br)
 {
+#if IS_ENABLED(CONFIG_IPV6)
+	return !hlist_empty(&br->ip4_mc_router_list) ||
+	       !hlist_empty(&br->ip6_mc_router_list);
+#else
 	return !hlist_empty(&br->ip4_mc_router_list);
+#endif
 }
 
 static bool
@@ -31,8 +36,13 @@ br_ip4_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
 static bool
 br_ip6_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
 {
+#if IS_ENABLED(CONFIG_IPV6)
+	*timer = br_timer_value(&port->ip6_mc_router_timer);
+	return !hlist_unhashed(&port->ip6_rlist);
+#else
 	*timer = 0;
 	return false;
+#endif
 }
 
 static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 30144f9..f234c48 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -63,6 +63,8 @@ static void br_multicast_port_group_rexmit(struct timer_list *t);
 static void
 br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted);
 #if IS_ENABLED(CONFIG_IPV6)
+static void br_ip6_multicast_add_router(struct net_bridge *br,
+					struct net_bridge_port *port);
 static void br_ip6_multicast_leave_group(struct net_bridge *br,
 					 struct net_bridge_port *port,
 					 const struct in6_addr *group,
@@ -1369,6 +1371,15 @@ static bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
 	return br_multicast_rport_del(&p->ip4_rlist);
 }
 
+static bool br_ip6_multicast_rport_del(struct net_bridge_port *p)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	return br_multicast_rport_del(&p->ip6_rlist);
+#else
+	return false;
+#endif
+}
+
 static void br_multicast_router_expired(struct net_bridge_port *port,
 					struct timer_list *t,
 					struct hlist_node *rlist)
@@ -1395,6 +1406,15 @@ static void br_ip4_multicast_router_expired(struct timer_list *t)
 	br_multicast_router_expired(port, t, &port->ip4_rlist);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void br_ip6_multicast_router_expired(struct timer_list *t)
+{
+	struct net_bridge_port *port = from_timer(port, t, ip6_mc_router_timer);
+
+	br_multicast_router_expired(port, t, &port->ip6_rlist);
+}
+#endif
+
 static void br_mc_router_state_change(struct net_bridge *p,
 				      bool is_mc_router)
 {
@@ -1430,6 +1450,15 @@ static void br_ip4_multicast_local_router_expired(struct timer_list *t)
 	br_multicast_local_router_expired(br, t);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
+static void br_ip6_multicast_local_router_expired(struct timer_list *t)
+{
+	struct net_bridge *br = from_timer(br, t, ip6_mc_router_timer);
+
+	br_multicast_local_router_expired(br, t);
+}
+#endif
+
 static void br_multicast_querier_expired(struct net_bridge *br,
 					 struct bridge_mcast_own_query *query)
 {
@@ -1649,6 +1678,8 @@ int br_multicast_add_port(struct net_bridge_port *port)
 	timer_setup(&port->ip4_own_query.timer,
 		    br_ip4_multicast_port_query_expired, 0);
 #if IS_ENABLED(CONFIG_IPV6)
+	timer_setup(&port->ip6_mc_router_timer,
+		    br_ip6_multicast_router_expired, 0);
 	timer_setup(&port->ip6_own_query.timer,
 		    br_ip6_multicast_port_query_expired, 0);
 #endif
@@ -1681,6 +1712,9 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	spin_unlock_bh(&br->multicast_lock);
 	br_multicast_gc(&deleted_head);
 	del_timer_sync(&port->ip4_mc_router_timer);
+#if IS_ENABLED(CONFIG_IPV6)
+	del_timer_sync(&port->ip6_mc_router_timer);
+#endif
 	free_percpu(port->mcast_stats);
 }
 
@@ -1704,8 +1738,10 @@ static void __br_multicast_enable_port(struct net_bridge_port *port)
 #if IS_ENABLED(CONFIG_IPV6)
 	br_multicast_enable(&port->ip6_own_query);
 #endif
-	if (port->multicast_router == MDB_RTR_TYPE_PERM)
+	if (port->multicast_router == MDB_RTR_TYPE_PERM) {
 		br_ip4_multicast_add_router(br, port);
+		br_ip6_multicast_add_router(br, port);
+	}
 }
 
 void br_multicast_enable_port(struct net_bridge_port *port)
@@ -1732,7 +1768,9 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	del |= br_ip4_multicast_rport_del(port);
 	del_timer(&port->ip4_mc_router_timer);
 	del_timer(&port->ip4_own_query.timer);
+	del |= br_ip6_multicast_rport_del(port);
 #if IS_ENABLED(CONFIG_IPV6)
+	del_timer(&port->ip6_mc_router_timer);
 	del_timer(&port->ip6_own_query.timer);
 #endif
 	br_multicast_rport_del_notify(port, del);
@@ -2675,6 +2713,10 @@ br_multicast_rport_from_node(struct net_bridge *br,
 			     struct hlist_head *mc_router_list,
 			     struct hlist_node *rlist)
 {
+#if IS_ENABLED(CONFIG_IPV6)
+	if (mc_router_list == &br->ip6_mc_router_list)
+		return hlist_entry(rlist, struct net_bridge_port, ip6_rlist);
+#endif
 	return hlist_entry(rlist, struct net_bridge_port, ip4_rlist);
 }
 
@@ -2700,6 +2742,19 @@ br_multicast_get_rport_slot(struct net_bridge *br,
 	return slot;
 }
 
+static bool br_multicast_no_router_otherpf(struct net_bridge_port *port,
+					   struct hlist_node *rnode)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	if (rnode != &port->ip6_rlist)
+		return hlist_unhashed(&port->ip6_rlist);
+	else
+		return hlist_unhashed(&port->ip4_rlist);
+#else
+	return true;
+#endif
+}
+
 /* Add port to router_list
  *  list is maintained ordered by pointer value
  *  and locked by br->multicast_lock and RCU
@@ -2721,8 +2776,14 @@ static void br_multicast_add_router(struct net_bridge *br,
 	else
 		hlist_add_head_rcu(rlist, mc_router_list);
 
-	br_rtr_notify(br->dev, port, RTM_NEWMDB);
-	br_port_mc_router_state_change(port, true);
+	/* For backwards compatibility for now, only notify if we
+	 * switched from no IPv4/IPv6 multicast router to a new
+	 * IPv4 or IPv6 multicast router.
+	 */
+	if (br_multicast_no_router_otherpf(port, rlist)) {
+		br_rtr_notify(br->dev, port, RTM_NEWMDB);
+		br_port_mc_router_state_change(port, true);
+	}
 }
 
 /* Add port to router_list
@@ -2736,6 +2797,19 @@ static void br_ip4_multicast_add_router(struct net_bridge *br,
 				&br->ip4_mc_router_list);
 }
 
+/* Add port to router_list
+ *  list is maintained ordered by pointer value
+ *  and locked by br->multicast_lock and RCU
+ */
+static void br_ip6_multicast_add_router(struct net_bridge *br,
+					struct net_bridge_port *port)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	br_multicast_add_router(br, port, &port->ip6_rlist,
+				&br->ip6_mc_router_list);
+#endif
+}
+
 static void br_multicast_mark_router(struct net_bridge *br,
 				     struct net_bridge_port *port,
 				     struct timer_list *timer,
@@ -2777,6 +2851,23 @@ static void br_ip4_multicast_mark_router(struct net_bridge *br,
 				 &br->ip4_mc_router_list);
 }
 
+static void br_ip6_multicast_mark_router(struct net_bridge *br,
+					 struct net_bridge_port *port)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	struct timer_list *timer = &br->ip6_mc_router_timer;
+	struct hlist_node *rlist = NULL;
+
+	if (port) {
+		timer = &port->ip6_mc_router_timer;
+		rlist = &port->ip6_rlist;
+	}
+
+	br_multicast_mark_router(br, port, timer, rlist,
+				 &br->ip6_mc_router_list);
+#endif
+}
+
 static void
 br_ip4_multicast_query_received(struct net_bridge *br,
 				struct net_bridge_port *port,
@@ -2803,7 +2894,7 @@ br_ip6_multicast_query_received(struct net_bridge *br,
 		return;
 
 	br_multicast_update_query_timer(br, query, max_delay);
-	br_ip4_multicast_mark_router(br, port);
+	br_ip6_multicast_mark_router(br, port);
 }
 #endif
 
@@ -3252,7 +3343,7 @@ static void br_ip6_multicast_mrd_rcv(struct net_bridge *br,
 	if (icmp6_hdr(skb)->icmp6_type != ICMPV6_MRDISC_ADV)
 		return;
 
-	br_ip4_multicast_mark_router(br, port);
+	br_ip6_multicast_mark_router(br, port);
 }
 
 static int br_multicast_ipv6_rcv(struct net_bridge *br,
@@ -3409,6 +3500,8 @@ void br_multicast_init(struct net_bridge *br)
 	timer_setup(&br->ip4_own_query.timer,
 		    br_ip4_multicast_query_expired, 0);
 #if IS_ENABLED(CONFIG_IPV6)
+	timer_setup(&br->ip6_mc_router_timer,
+		    br_ip6_multicast_local_router_expired, 0);
 	timer_setup(&br->ip6_other_query.timer,
 		    br_ip6_multicast_querier_expired, 0);
 	timer_setup(&br->ip6_own_query.timer,
@@ -3506,6 +3599,7 @@ void br_multicast_stop(struct net_bridge *br)
 	del_timer_sync(&br->ip4_other_query.timer);
 	del_timer_sync(&br->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
+	del_timer_sync(&br->ip6_mc_router_timer);
 	del_timer_sync(&br->ip6_other_query.timer);
 	del_timer_sync(&br->ip6_own_query.timer);
 #endif
@@ -3540,6 +3634,9 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 	case MDB_RTR_TYPE_PERM:
 		br_mc_router_state_change(br, val == MDB_RTR_TYPE_PERM);
 		del_timer(&br->ip4_mc_router_timer);
+#if IS_ENABLED(CONFIG_IPV6)
+		del_timer(&br->ip6_mc_router_timer);
+#endif
 		br->multicast_router = val;
 		err = 0;
 		break;
@@ -3562,6 +3659,16 @@ br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
 	if (!deleted)
 		return;
 
+	/* For backwards compatibility for now, only notify if there is
+	 * no multicast router anymore for both IPv4 and IPv6.
+	 */
+	if (!hlist_unhashed(&p->ip4_rlist))
+		return;
+#if IS_ENABLED(CONFIG_IPV6)
+	if (!hlist_unhashed(&p->ip6_rlist))
+		return;
+#endif
+
 	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
 	br_port_mc_router_state_change(p, false);
 
@@ -3580,9 +3687,14 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	spin_lock(&br->multicast_lock);
 	if (p->multicast_router == val) {
 		/* Refresh the temp router port timer */
-		if (p->multicast_router == MDB_RTR_TYPE_TEMP)
+		if (p->multicast_router == MDB_RTR_TYPE_TEMP) {
 			mod_timer(&p->ip4_mc_router_timer,
 				  now + br->multicast_querier_interval);
+#if IS_ENABLED(CONFIG_IPV6)
+			mod_timer(&p->ip6_mc_router_timer,
+				  now + br->multicast_querier_interval);
+#endif
+		}
 		err = 0;
 		goto unlock;
 	}
@@ -3591,21 +3703,31 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 		p->multicast_router = MDB_RTR_TYPE_DISABLED;
 		del |= br_ip4_multicast_rport_del(p);
 		del_timer(&p->ip4_mc_router_timer);
+		del |= br_ip6_multicast_rport_del(p);
+#if IS_ENABLED(CONFIG_IPV6)
+		del_timer(&p->ip6_mc_router_timer);
+#endif
 		br_multicast_rport_del_notify(p, del);
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
 		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 		del |= br_ip4_multicast_rport_del(p);
+		del |= br_ip6_multicast_rport_del(p);
 		br_multicast_rport_del_notify(p, del);
 		break;
 	case MDB_RTR_TYPE_PERM:
 		p->multicast_router = MDB_RTR_TYPE_PERM;
 		del_timer(&p->ip4_mc_router_timer);
 		br_ip4_multicast_add_router(br, p);
+#if IS_ENABLED(CONFIG_IPV6)
+		del_timer(&p->ip6_mc_router_timer);
+#endif
+		br_ip6_multicast_add_router(br, p);
 		break;
 	case MDB_RTR_TYPE_TEMP:
 		p->multicast_router = MDB_RTR_TYPE_TEMP;
 		br_ip4_multicast_mark_router(br, p);
+		br_ip6_multicast_mark_router(br, p);
 		break;
 	default:
 		goto unlock;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index f9a381f..03197ab 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -311,6 +311,8 @@ struct net_bridge_port {
 	struct hlist_node		ip4_rlist;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct bridge_mcast_own_query	ip6_own_query;
+	struct timer_list		ip6_mc_router_timer;
+	struct hlist_node		ip6_rlist;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 	u32				multicast_eht_hosts_limit;
 	u32				multicast_eht_hosts_cnt;
@@ -457,6 +459,8 @@ struct net_bridge {
 	struct bridge_mcast_querier	ip4_querier;
 	struct bridge_mcast_stats	__percpu *mcast_stats;
 #if IS_ENABLED(CONFIG_IPV6)
+	struct hlist_head		ip6_mc_router_list;
+	struct timer_list		ip6_mc_router_timer;
 	struct bridge_mcast_other_query	ip6_other_query;
 	struct bridge_mcast_own_query	ip6_own_query;
 	struct bridge_mcast_querier	ip6_querier;
@@ -866,11 +870,19 @@ static inline bool br_group_is_l2(const struct br_ip *group)
 
 static inline struct hlist_node *
 br_multicast_get_first_rport_node(struct net_bridge *b, struct sk_buff *skb) {
+#if IS_ENABLED(CONFIG_IPV6)
+	if (skb->protocol == htons(ETH_P_IPV6))
+		return rcu_dereference(hlist_first_rcu(&b->ip6_mc_router_list));
+#endif
 	return rcu_dereference(hlist_first_rcu(&b->ip4_mc_router_list));
 }
 
 static inline struct net_bridge_port *
 br_multicast_rport_from_node_skb(struct hlist_node *rp, struct sk_buff *skb) {
+#if IS_ENABLED(CONFIG_IPV6)
+	if (skb->protocol == htons(ETH_P_IPV6))
+		return hlist_entry_safe(rp, struct net_bridge_port, ip6_rlist);
+#endif
 	return hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
 }
 
@@ -882,7 +894,7 @@ static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
 static inline bool br_ip6_multicast_is_router(struct net_bridge *br)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return timer_pending(&br->ip4_mc_router_timer);
+	return timer_pending(&br->ip6_mc_router_timer);
 #else
 	return false;
 #endif
-- 
2.31.0

