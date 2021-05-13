Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1C737F897
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 15:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhEMNWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 09:22:24 -0400
Received: from mail.aperture-lab.de ([116.203.183.178]:52662 "EHLO
        mail.aperture-lab.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbhEMNWM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 09:22:12 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 485DF3ED8D;
        Thu, 13 May 2021 15:20:58 +0200 (CEST)
From:   =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
To:     netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>
Subject: [net-next v4 01/11] net: bridge: mcast: rename multicast router lists and timers
Date:   Thu, 13 May 2021 15:20:43 +0200
Message-Id: <20210513132053.23445-2-linus.luessing@c0d3.blue>
In-Reply-To: <20210513132053.23445-1-linus.luessing@c0d3.blue>
References: <20210513132053.23445-1-linus.luessing@c0d3.blue>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.2
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for the upcoming split of multicast router state into
their IPv4 and IPv6 variants, rename the affected variable to the IPv4
version first to avoid some renames in later commits.

Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
---
 net/bridge/br_forward.c   |  4 ++--
 net/bridge/br_mdb.c       |  6 ++---
 net/bridge/br_multicast.c | 48 +++++++++++++++++++--------------------
 net/bridge/br_private.h   | 10 ++++----
 4 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 6e9b049..eb9847a 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -276,7 +276,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 	bool allow_mode_include = true;
 	struct hlist_node *rp;
 
-	rp = rcu_dereference(hlist_first_rcu(&br->router_list));
+	rp = rcu_dereference(hlist_first_rcu(&br->ip4_mc_router_list));
 	if (mdst) {
 		p = rcu_dereference(mdst->ports);
 		if (br_multicast_should_handle_mode(br, mdst->addr.proto) &&
@@ -290,7 +290,7 @@ void br_multicast_flood(struct net_bridge_mdb_entry *mdst,
 		struct net_bridge_port *port, *lport, *rport;
 
 		lport = p ? p->key.port : NULL;
-		rport = hlist_entry_safe(rp, struct net_bridge_port, rlist);
+		rport = hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
 
 		if ((unsigned long)lport > (unsigned long)rport) {
 			port = lport;
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 95fa4af..d61def8 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -23,14 +23,14 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 	struct net_bridge_port *p;
 	struct nlattr *nest, *port_nest;
 
-	if (!br->multicast_router || hlist_empty(&br->router_list))
+	if (!br->multicast_router || hlist_empty(&br->ip4_mc_router_list))
 		return 0;
 
 	nest = nla_nest_start_noflag(skb, MDBA_ROUTER);
 	if (nest == NULL)
 		return -EMSGSIZE;
 
-	hlist_for_each_entry_rcu(p, &br->router_list, rlist) {
+	hlist_for_each_entry_rcu(p, &br->ip4_mc_router_list, ip4_rlist) {
 		if (!p)
 			continue;
 		port_nest = nla_nest_start_noflag(skb, MDBA_ROUTER_PORT);
@@ -38,7 +38,7 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 			goto fail;
 		if (nla_put_nohdr(skb, sizeof(u32), &p->dev->ifindex) ||
 		    nla_put_u32(skb, MDBA_ROUTER_PATTR_TIMER,
-				br_timer_value(&p->multicast_router_timer)) ||
+				br_timer_value(&p->ip4_mc_router_timer)) ||
 		    nla_put_u8(skb, MDBA_ROUTER_PATTR_TYPE,
 			       p->multicast_router)) {
 			nla_nest_cancel(skb, port_nest);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 226bb05..6fe93a3 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1357,13 +1357,13 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 static void br_multicast_router_expired(struct timer_list *t)
 {
 	struct net_bridge_port *port =
-			from_timer(port, t, multicast_router_timer);
+			from_timer(port, t, ip4_mc_router_timer);
 	struct net_bridge *br = port->br;
 
 	spin_lock(&br->multicast_lock);
 	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
 	    port->multicast_router == MDB_RTR_TYPE_PERM ||
-	    timer_pending(&port->multicast_router_timer))
+	    timer_pending(&port->ip4_mc_router_timer))
 		goto out;
 
 	__del_port_router(port);
@@ -1386,12 +1386,12 @@ static void br_mc_router_state_change(struct net_bridge *p,
 
 static void br_multicast_local_router_expired(struct timer_list *t)
 {
-	struct net_bridge *br = from_timer(br, t, multicast_router_timer);
+	struct net_bridge *br = from_timer(br, t, ip4_mc_router_timer);
 
 	spin_lock(&br->multicast_lock);
 	if (br->multicast_router == MDB_RTR_TYPE_DISABLED ||
 	    br->multicast_router == MDB_RTR_TYPE_PERM ||
-	    timer_pending(&br->multicast_router_timer))
+	    timer_pending(&br->ip4_mc_router_timer))
 		goto out;
 
 	br_mc_router_state_change(br, false);
@@ -1613,7 +1613,7 @@ int br_multicast_add_port(struct net_bridge_port *port)
 	port->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
 
-	timer_setup(&port->multicast_router_timer,
+	timer_setup(&port->ip4_mc_router_timer,
 		    br_multicast_router_expired, 0);
 	timer_setup(&port->ip4_own_query.timer,
 		    br_ip4_multicast_port_query_expired, 0);
@@ -1649,7 +1649,7 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	hlist_move_list(&br->mcast_gc_list, &deleted_head);
 	spin_unlock_bh(&br->multicast_lock);
 	br_multicast_gc(&deleted_head);
-	del_timer_sync(&port->multicast_router_timer);
+	del_timer_sync(&port->ip4_mc_router_timer);
 	free_percpu(port->mcast_stats);
 }
 
@@ -1674,7 +1674,7 @@ static void __br_multicast_enable_port(struct net_bridge_port *port)
 	br_multicast_enable(&port->ip6_own_query);
 #endif
 	if (port->multicast_router == MDB_RTR_TYPE_PERM &&
-	    hlist_unhashed(&port->rlist))
+	    hlist_unhashed(&port->ip4_rlist))
 		br_multicast_add_router(br, port);
 }
 
@@ -1700,7 +1700,7 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 
 	__del_port_router(port);
 
-	del_timer(&port->multicast_router_timer);
+	del_timer(&port->ip4_mc_router_timer);
 	del_timer(&port->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
 	del_timer(&port->ip6_own_query.timer);
@@ -2666,19 +2666,19 @@ static void br_multicast_add_router(struct net_bridge *br,
 	struct net_bridge_port *p;
 	struct hlist_node *slot = NULL;
 
-	if (!hlist_unhashed(&port->rlist))
+	if (!hlist_unhashed(&port->ip4_rlist))
 		return;
 
-	hlist_for_each_entry(p, &br->router_list, rlist) {
+	hlist_for_each_entry(p, &br->ip4_mc_router_list, ip4_rlist) {
 		if ((unsigned long) port >= (unsigned long) p)
 			break;
-		slot = &p->rlist;
+		slot = &p->ip4_rlist;
 	}
 
 	if (slot)
-		hlist_add_behind_rcu(&port->rlist, slot);
+		hlist_add_behind_rcu(&port->ip4_rlist, slot);
 	else
-		hlist_add_head_rcu(&port->rlist, &br->router_list);
+		hlist_add_head_rcu(&port->ip4_rlist, &br->ip4_mc_router_list);
 	br_rtr_notify(br->dev, port, RTM_NEWMDB);
 	br_port_mc_router_state_change(port, true);
 }
@@ -2690,9 +2690,9 @@ static void br_multicast_mark_router(struct net_bridge *br,
 
 	if (!port) {
 		if (br->multicast_router == MDB_RTR_TYPE_TEMP_QUERY) {
-			if (!timer_pending(&br->multicast_router_timer))
+			if (!timer_pending(&br->ip4_mc_router_timer))
 				br_mc_router_state_change(br, true);
-			mod_timer(&br->multicast_router_timer,
+			mod_timer(&br->ip4_mc_router_timer,
 				  now + br->multicast_querier_interval);
 		}
 		return;
@@ -2704,7 +2704,7 @@ static void br_multicast_mark_router(struct net_bridge *br,
 
 	br_multicast_add_router(br, port);
 
-	mod_timer(&port->multicast_router_timer,
+	mod_timer(&port->ip4_mc_router_timer,
 		  now + br->multicast_querier_interval);
 }
 
@@ -3316,7 +3316,7 @@ void br_multicast_init(struct net_bridge *br)
 	br_opt_toggle(br, BROPT_HAS_IPV6_ADDR, true);
 
 	spin_lock_init(&br->multicast_lock);
-	timer_setup(&br->multicast_router_timer,
+	timer_setup(&br->ip4_mc_router_timer,
 		    br_multicast_local_router_expired, 0);
 	timer_setup(&br->ip4_other_query.timer,
 		    br_ip4_multicast_querier_expired, 0);
@@ -3416,7 +3416,7 @@ void br_multicast_open(struct net_bridge *br)
 
 void br_multicast_stop(struct net_bridge *br)
 {
-	del_timer_sync(&br->multicast_router_timer);
+	del_timer_sync(&br->ip4_mc_router_timer);
 	del_timer_sync(&br->ip4_other_query.timer);
 	del_timer_sync(&br->ip4_own_query.timer);
 #if IS_ENABLED(CONFIG_IPV6)
@@ -3453,7 +3453,7 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 	case MDB_RTR_TYPE_DISABLED:
 	case MDB_RTR_TYPE_PERM:
 		br_mc_router_state_change(br, val == MDB_RTR_TYPE_PERM);
-		del_timer(&br->multicast_router_timer);
+		del_timer(&br->ip4_mc_router_timer);
 		br->multicast_router = val;
 		err = 0;
 		break;
@@ -3472,9 +3472,9 @@ int br_multicast_set_router(struct net_bridge *br, unsigned long val)
 
 static void __del_port_router(struct net_bridge_port *p)
 {
-	if (hlist_unhashed(&p->rlist))
+	if (hlist_unhashed(&p->ip4_rlist))
 		return;
-	hlist_del_init_rcu(&p->rlist);
+	hlist_del_init_rcu(&p->ip4_rlist);
 	br_rtr_notify(p->br->dev, p, RTM_DELMDB);
 	br_port_mc_router_state_change(p, false);
 
@@ -3493,7 +3493,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	if (p->multicast_router == val) {
 		/* Refresh the temp router port timer */
 		if (p->multicast_router == MDB_RTR_TYPE_TEMP)
-			mod_timer(&p->multicast_router_timer,
+			mod_timer(&p->ip4_mc_router_timer,
 				  now + br->multicast_querier_interval);
 		err = 0;
 		goto unlock;
@@ -3502,7 +3502,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	case MDB_RTR_TYPE_DISABLED:
 		p->multicast_router = MDB_RTR_TYPE_DISABLED;
 		__del_port_router(p);
-		del_timer(&p->multicast_router_timer);
+		del_timer(&p->ip4_mc_router_timer);
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
 		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
@@ -3510,7 +3510,7 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 		break;
 	case MDB_RTR_TYPE_PERM:
 		p->multicast_router = MDB_RTR_TYPE_PERM;
-		del_timer(&p->multicast_router_timer);
+		del_timer(&p->ip4_mc_router_timer);
 		br_multicast_add_router(br, p);
 		break;
 	case MDB_RTR_TYPE_TEMP:
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7ce8a77..26e91d2 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -307,6 +307,8 @@ struct net_bridge_port {
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	struct bridge_mcast_own_query	ip4_own_query;
+	struct timer_list		ip4_mc_router_timer;
+	struct hlist_node		ip4_rlist;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct bridge_mcast_own_query	ip6_own_query;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
@@ -314,9 +316,7 @@ struct net_bridge_port {
 	u32				multicast_eht_hosts_cnt;
 	unsigned char			multicast_router;
 	struct bridge_mcast_stats	__percpu *mcast_stats;
-	struct timer_list		multicast_router_timer;
 	struct hlist_head		mglist;
-	struct hlist_node		rlist;
 #endif
 
 #ifdef CONFIG_SYSFS
@@ -449,9 +449,9 @@ struct net_bridge {
 
 	struct hlist_head		mcast_gc_list;
 	struct hlist_head		mdb_list;
-	struct hlist_head		router_list;
 
-	struct timer_list		multicast_router_timer;
+	struct hlist_head		ip4_mc_router_list;
+	struct timer_list		ip4_mc_router_timer;
 	struct bridge_mcast_other_query	ip4_other_query;
 	struct bridge_mcast_own_query	ip4_own_query;
 	struct bridge_mcast_querier	ip4_querier;
@@ -868,7 +868,7 @@ static inline bool br_multicast_is_router(struct net_bridge *br)
 {
 	return br->multicast_router == 2 ||
 	       (br->multicast_router == 1 &&
-		timer_pending(&br->multicast_router_timer));
+		timer_pending(&br->ip4_mc_router_timer));
 }
 
 static inline bool
-- 
2.31.0

