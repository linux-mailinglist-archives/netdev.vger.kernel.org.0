Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0AB63CE83B
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353859AbhGSQj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355614AbhGSQg1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84721C04F95E
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:44 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ec55so24997382edb.1
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JNXW9ngpUv8X2/tyC+6jncNWuBegfmJL3KLqEcgq9Fw=;
        b=wg1e+luGabj2DNwsTy3QL+A1cbJU+P85GJ6LpnJWhBavbjwIV8G/hKsXePNlFEKDNb
         8PVbSp9DGjD8348CyVtfLhHgQDoLF34vYJ5kMYeTQfb8Tu6gaFr5KoOZWn1qaibinoya
         GZaHLSpXb+LcMZNyk9SxB/IfyYPFSB0R5wC9Wq/2+6LNS0kNyHDVko2G0AhAD8OgI1/7
         Fp5NAVqFbrD5CU3Q5fe6N1Yge96OnMs90L+7VF2FzxHnslO3ZNYfX4Qc8XF5D7mMr+8E
         UwAI3dhg+XtVUy5Gj+hUTStSEaxWPjejgv3X+zJjTvb3elitxvN+lhXgxl8fvbP3wSO9
         Xo/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JNXW9ngpUv8X2/tyC+6jncNWuBegfmJL3KLqEcgq9Fw=;
        b=UKyne8dKvZU6Y+SLPKaBvJG3DIZ1lgeahpGPtKZHq88KcKBbiX4OWB1j1Ywzg5Psb7
         iEO1yS/dX9mFU+uPcb9QgLxp771fsLGg5463uQr3X8bBurgpini9oT6ibKBehwLpR60Z
         oKkMuT/geyknhSorqV6KidjhqhPCbiArGoyBb0cLnL2XfYcgQT7DrazE3rF+oyv+ILcX
         bnedZq/HnTaCsPCEEPnFPGDB6EIoktQCwVu1L0xNuD6MUC9U5+sCj4vbvEMKHy5T55B9
         3tCIkCmmpCvgBqjVueWfwU2YGbIggovQKhVwlehRQcmtDaSVc0Nz3liI7BK+25QYetj8
         M8ew==
X-Gm-Message-State: AOAM530O9HngIIaGa6pTHE91cm7x9ddJvs+QyYq6f74ELqhFGIsNjKYk
        y65LRYLQHZaLxfOCWC4wKSmUIeleXHr9NdhO1J4=
X-Google-Smtp-Source: ABdhPJzdCS0xbRIMIhiECk6f0rf5CUUoXYSlbyabr5PQd8LCzHSbvHjmJrytfIh+rMP06OE4cRt4Sw==
X-Received: by 2002:a05:6402:5244:: with SMTP id t4mr26554432edd.346.1626714597281;
        Mon, 19 Jul 2021 10:09:57 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:09:56 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 01/15] net: bridge: multicast: factor out port multicast context
Date:   Mon, 19 Jul 2021 20:06:23 +0300
Message-Id: <20210719170637.435541-2-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Factor out the port's multicast context into a separate structure which
will later be shared for per-port,vlan context. No functional changes
intended. We need the structure even if bridge multicast is not defined
to pass down as pointer to forwarding functions.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_mdb.c       |  10 +-
 net/bridge/br_multicast.c | 186 ++++++++++++++++++++++----------------
 net/bridge/br_netlink.c   |   2 +-
 net/bridge/br_private.h   |  45 ++++++---
 net/bridge/br_sysfs_if.c  |   2 +-
 5 files changed, 146 insertions(+), 99 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 17a720b4473f..64619dc65bc8 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -29,16 +29,16 @@ static bool br_rports_have_mc_router(struct net_bridge *br)
 static bool
 br_ip4_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
 {
-	*timer = br_timer_value(&port->ip4_mc_router_timer);
-	return !hlist_unhashed(&port->ip4_rlist);
+	*timer = br_timer_value(&port->multicast_ctx.ip4_mc_router_timer);
+	return !hlist_unhashed(&port->multicast_ctx.ip4_rlist);
 }
 
 static bool
 br_ip6_rports_get_timer(struct net_bridge_port *port, unsigned long *timer)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	*timer = br_timer_value(&port->ip6_mc_router_timer);
-	return !hlist_unhashed(&port->ip6_rlist);
+	*timer = br_timer_value(&port->multicast_ctx.ip6_mc_router_timer);
+	return !hlist_unhashed(&port->multicast_ctx.ip6_rlist);
 #else
 	*timer = 0;
 	return false;
@@ -79,7 +79,7 @@ static int br_rports_fill_info(struct sk_buff *skb, struct netlink_callback *cb,
 		    nla_put_u32(skb, MDBA_ROUTER_PATTR_TIMER,
 				max(ip4_timer, ip6_timer)) ||
 		    nla_put_u8(skb, MDBA_ROUTER_PATTR_TYPE,
-			       p->multicast_router) ||
+			       p->multicast_ctx.multicast_router) ||
 		    (have_ip4_mc_rtr &&
 		     nla_put_u32(skb, MDBA_ROUTER_PATTR_INET_TIMER,
 				 ip4_timer)) ||
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index d0434dc8c03b..3abb673ee4ee 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -1368,50 +1368,52 @@ static bool br_multicast_rport_del(struct hlist_node *rlist)
 
 static bool br_ip4_multicast_rport_del(struct net_bridge_port *p)
 {
-	return br_multicast_rport_del(&p->ip4_rlist);
+	return br_multicast_rport_del(&p->multicast_ctx.ip4_rlist);
 }
 
 static bool br_ip6_multicast_rport_del(struct net_bridge_port *p)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	return br_multicast_rport_del(&p->ip6_rlist);
+	return br_multicast_rport_del(&p->multicast_ctx.ip6_rlist);
 #else
 	return false;
 #endif
 }
 
-static void br_multicast_router_expired(struct net_bridge_port *port,
+static void br_multicast_router_expired(struct net_bridge_mcast_port *pmctx,
 					struct timer_list *t,
 					struct hlist_node *rlist)
 {
-	struct net_bridge *br = port->br;
+	struct net_bridge *br = pmctx->port->br;
 	bool del;
 
 	spin_lock(&br->multicast_lock);
-	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
-	    port->multicast_router == MDB_RTR_TYPE_PERM ||
+	if (pmctx->multicast_router == MDB_RTR_TYPE_DISABLED ||
+	    pmctx->multicast_router == MDB_RTR_TYPE_PERM ||
 	    timer_pending(t))
 		goto out;
 
 	del = br_multicast_rport_del(rlist);
-	br_multicast_rport_del_notify(port, del);
+	br_multicast_rport_del_notify(pmctx->port, del);
 out:
 	spin_unlock(&br->multicast_lock);
 }
 
 static void br_ip4_multicast_router_expired(struct timer_list *t)
 {
-	struct net_bridge_port *port = from_timer(port, t, ip4_mc_router_timer);
+	struct net_bridge_mcast_port *pmctx = from_timer(pmctx, t,
+							 ip4_mc_router_timer);
 
-	br_multicast_router_expired(port, t, &port->ip4_rlist);
+	br_multicast_router_expired(pmctx, t, &pmctx->ip4_rlist);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_router_expired(struct timer_list *t)
 {
-	struct net_bridge_port *port = from_timer(port, t, ip6_mc_router_timer);
+	struct net_bridge_mcast_port *pmctx = from_timer(pmctx, t,
+							 ip6_mc_router_timer);
 
-	br_multicast_router_expired(port, t, &port->ip6_rlist);
+	br_multicast_router_expired(pmctx, t, &pmctx->ip6_rlist);
 }
 #endif
 
@@ -1555,7 +1557,7 @@ static void br_multicast_send_query(struct net_bridge *br,
 
 	memset(&br_group.dst, 0, sizeof(br_group.dst));
 
-	if (port ? (own_query == &port->ip4_own_query) :
+	if (port ? (own_query == &port->multicast_ctx.ip4_own_query) :
 		   (own_query == &br->ip4_own_query)) {
 		other_query = &br->ip4_other_query;
 		br_group.proto = htons(ETH_P_IP);
@@ -1580,20 +1582,20 @@ static void br_multicast_send_query(struct net_bridge *br,
 }
 
 static void
-br_multicast_port_query_expired(struct net_bridge_port *port,
+br_multicast_port_query_expired(struct net_bridge_mcast_port *pmctx,
 				struct bridge_mcast_own_query *query)
 {
-	struct net_bridge *br = port->br;
+	struct net_bridge *br = pmctx->port->br;
 
 	spin_lock(&br->multicast_lock);
-	if (port->state == BR_STATE_DISABLED ||
-	    port->state == BR_STATE_BLOCKING)
+	if (pmctx->port->state == BR_STATE_DISABLED ||
+	    pmctx->port->state == BR_STATE_BLOCKING)
 		goto out;
 
 	if (query->startup_sent < br->multicast_startup_query_count)
 		query->startup_sent++;
 
-	br_multicast_send_query(port->br, port, query);
+	br_multicast_send_query(pmctx->port->br, pmctx->port, query);
 
 out:
 	spin_unlock(&br->multicast_lock);
@@ -1601,17 +1603,19 @@ br_multicast_port_query_expired(struct net_bridge_port *port,
 
 static void br_ip4_multicast_port_query_expired(struct timer_list *t)
 {
-	struct net_bridge_port *port = from_timer(port, t, ip4_own_query.timer);
+	struct net_bridge_mcast_port *pmctx = from_timer(pmctx, t,
+							 ip4_own_query.timer);
 
-	br_multicast_port_query_expired(port, &port->ip4_own_query);
+	br_multicast_port_query_expired(pmctx, &pmctx->ip4_own_query);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
 static void br_ip6_multicast_port_query_expired(struct timer_list *t)
 {
-	struct net_bridge_port *port = from_timer(port, t, ip6_own_query.timer);
+	struct net_bridge_mcast_port *pmctx = from_timer(pmctx, t,
+							 ip6_own_query.timer);
 
-	br_multicast_port_query_expired(port, &port->ip6_own_query);
+	br_multicast_port_query_expired(pmctx, &pmctx->ip6_own_query);
 }
 #endif
 
@@ -1666,23 +1670,38 @@ static int br_mc_disabled_update(struct net_device *dev, bool value,
 	return switchdev_port_attr_set(dev, &attr, extack);
 }
 
-int br_multicast_add_port(struct net_bridge_port *port)
+static void br_multicast_port_ctx_init(struct net_bridge_port *port,
+				       struct net_bridge_mcast_port *pmctx)
 {
-	int err;
-
-	port->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
-	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
-
-	timer_setup(&port->ip4_mc_router_timer,
+	pmctx->port = port;
+	pmctx->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
+	timer_setup(&pmctx->ip4_mc_router_timer,
 		    br_ip4_multicast_router_expired, 0);
-	timer_setup(&port->ip4_own_query.timer,
+	timer_setup(&pmctx->ip4_own_query.timer,
 		    br_ip4_multicast_port_query_expired, 0);
 #if IS_ENABLED(CONFIG_IPV6)
-	timer_setup(&port->ip6_mc_router_timer,
+	timer_setup(&pmctx->ip6_mc_router_timer,
 		    br_ip6_multicast_router_expired, 0);
-	timer_setup(&port->ip6_own_query.timer,
+	timer_setup(&pmctx->ip6_own_query.timer,
 		    br_ip6_multicast_port_query_expired, 0);
 #endif
+}
+
+static void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx)
+{
+#if IS_ENABLED(CONFIG_IPV6)
+	del_timer_sync(&pmctx->ip6_mc_router_timer);
+#endif
+	del_timer_sync(&pmctx->ip4_mc_router_timer);
+}
+
+int br_multicast_add_port(struct net_bridge_port *port)
+{
+	int err;
+
+	port->multicast_eht_hosts_limit = BR_MCAST_DEFAULT_EHT_HOSTS_LIMIT;
+	br_multicast_port_ctx_init(port, &port->multicast_ctx);
+
 	err = br_mc_disabled_update(port->dev,
 				    br_opt_get(port->br,
 					       BROPT_MULTICAST_ENABLED),
@@ -1711,10 +1730,7 @@ void br_multicast_del_port(struct net_bridge_port *port)
 	hlist_move_list(&br->mcast_gc_list, &deleted_head);
 	spin_unlock_bh(&br->multicast_lock);
 	br_multicast_gc(&deleted_head);
-	del_timer_sync(&port->ip4_mc_router_timer);
-#if IS_ENABLED(CONFIG_IPV6)
-	del_timer_sync(&port->ip6_mc_router_timer);
-#endif
+	br_multicast_port_ctx_deinit(&port->multicast_ctx);
 	free_percpu(port->mcast_stats);
 }
 
@@ -1734,11 +1750,11 @@ static void __br_multicast_enable_port(struct net_bridge_port *port)
 	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED) || !netif_running(br->dev))
 		return;
 
-	br_multicast_enable(&port->ip4_own_query);
+	br_multicast_enable(&port->multicast_ctx.ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_enable(&port->ip6_own_query);
+	br_multicast_enable(&port->multicast_ctx.ip6_own_query);
 #endif
-	if (port->multicast_router == MDB_RTR_TYPE_PERM) {
+	if (port->multicast_ctx.multicast_router == MDB_RTR_TYPE_PERM) {
 		br_ip4_multicast_add_router(br, port);
 		br_ip6_multicast_add_router(br, port);
 	}
@@ -1766,12 +1782,12 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 			br_multicast_find_del_pg(br, pg);
 
 	del |= br_ip4_multicast_rport_del(port);
-	del_timer(&port->ip4_mc_router_timer);
-	del_timer(&port->ip4_own_query.timer);
+	del_timer(&port->multicast_ctx.ip4_mc_router_timer);
+	del_timer(&port->multicast_ctx.ip4_own_query.timer);
 	del |= br_ip6_multicast_rport_del(port);
 #if IS_ENABLED(CONFIG_IPV6)
-	del_timer(&port->ip6_mc_router_timer);
-	del_timer(&port->ip6_own_query.timer);
+	del_timer(&port->multicast_ctx.ip6_mc_router_timer);
+	del_timer(&port->multicast_ctx.ip6_own_query.timer);
 #endif
 	br_multicast_rport_del_notify(port, del);
 	spin_unlock(&br->multicast_lock);
@@ -2713,11 +2729,18 @@ br_multicast_rport_from_node(struct net_bridge *br,
 			     struct hlist_head *mc_router_list,
 			     struct hlist_node *rlist)
 {
+	struct net_bridge_mcast_port *pmctx;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (mc_router_list == &br->ip6_mc_router_list)
-		return hlist_entry(rlist, struct net_bridge_port, ip6_rlist);
+		pmctx = hlist_entry(rlist, struct net_bridge_mcast_port,
+				    ip6_rlist);
+	else
 #endif
-	return hlist_entry(rlist, struct net_bridge_port, ip4_rlist);
+		pmctx = hlist_entry(rlist, struct net_bridge_mcast_port,
+				    ip4_rlist);
+
+	return pmctx->port;
 }
 
 static struct hlist_node *
@@ -2746,10 +2769,10 @@ static bool br_multicast_no_router_otherpf(struct net_bridge_port *port,
 					   struct hlist_node *rnode)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	if (rnode != &port->ip6_rlist)
-		return hlist_unhashed(&port->ip6_rlist);
+	if (rnode != &port->multicast_ctx.ip6_rlist)
+		return hlist_unhashed(&port->multicast_ctx.ip6_rlist);
 	else
-		return hlist_unhashed(&port->ip4_rlist);
+		return hlist_unhashed(&port->multicast_ctx.ip4_rlist);
 #else
 	return true;
 #endif
@@ -2793,7 +2816,7 @@ static void br_multicast_add_router(struct net_bridge *br,
 static void br_ip4_multicast_add_router(struct net_bridge *br,
 					struct net_bridge_port *port)
 {
-	br_multicast_add_router(br, port, &port->ip4_rlist,
+	br_multicast_add_router(br, port, &port->multicast_ctx.ip4_rlist,
 				&br->ip4_mc_router_list);
 }
 
@@ -2805,7 +2828,7 @@ static void br_ip6_multicast_add_router(struct net_bridge *br,
 					struct net_bridge_port *port)
 {
 #if IS_ENABLED(CONFIG_IPV6)
-	br_multicast_add_router(br, port, &port->ip6_rlist,
+	br_multicast_add_router(br, port, &port->multicast_ctx.ip6_rlist,
 				&br->ip6_mc_router_list);
 #endif
 }
@@ -2828,8 +2851,8 @@ static void br_multicast_mark_router(struct net_bridge *br,
 		return;
 	}
 
-	if (port->multicast_router == MDB_RTR_TYPE_DISABLED ||
-	    port->multicast_router == MDB_RTR_TYPE_PERM)
+	if (port->multicast_ctx.multicast_router == MDB_RTR_TYPE_DISABLED ||
+	    port->multicast_ctx.multicast_router == MDB_RTR_TYPE_PERM)
 		return;
 
 	br_multicast_add_router(br, port, rlist, mc_router_list);
@@ -2843,8 +2866,8 @@ static void br_ip4_multicast_mark_router(struct net_bridge *br,
 	struct hlist_node *rlist = NULL;
 
 	if (port) {
-		timer = &port->ip4_mc_router_timer;
-		rlist = &port->ip4_rlist;
+		timer = &port->multicast_ctx.ip4_mc_router_timer;
+		rlist = &port->multicast_ctx.ip4_rlist;
 	}
 
 	br_multicast_mark_router(br, port, timer, rlist,
@@ -2859,8 +2882,8 @@ static void br_ip6_multicast_mark_router(struct net_bridge *br,
 	struct hlist_node *rlist = NULL;
 
 	if (port) {
-		timer = &port->ip6_mc_router_timer;
-		rlist = &port->ip6_rlist;
+		timer = &port->multicast_ctx.ip6_mc_router_timer;
+		rlist = &port->multicast_ctx.ip6_rlist;
 	}
 
 	br_multicast_mark_router(br, port, timer, rlist,
@@ -3183,7 +3206,8 @@ static void br_ip4_multicast_leave_group(struct net_bridge *br,
 	if (ipv4_is_local_multicast(group))
 		return;
 
-	own_query = port ? &port->ip4_own_query : &br->ip4_own_query;
+	own_query = port ? &port->multicast_ctx.ip4_own_query :
+			   &br->ip4_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip4 = group;
@@ -3207,7 +3231,8 @@ static void br_ip6_multicast_leave_group(struct net_bridge *br,
 	if (ipv6_addr_is_ll_all_nodes(group))
 		return;
 
-	own_query = port ? &port->ip6_own_query : &br->ip6_own_query;
+	own_query = port ? &port->multicast_ctx.ip6_own_query :
+			   &br->ip6_own_query;
 
 	memset(&br_group, 0, sizeof(br_group));
 	br_group.dst.ip6 = *group;
@@ -3668,10 +3693,10 @@ br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
 	/* For backwards compatibility for now, only notify if there is
 	 * no multicast router anymore for both IPv4 and IPv6.
 	 */
-	if (!hlist_unhashed(&p->ip4_rlist))
+	if (!hlist_unhashed(&p->multicast_ctx.ip4_rlist))
 		return;
 #if IS_ENABLED(CONFIG_IPV6)
-	if (!hlist_unhashed(&p->ip6_rlist))
+	if (!hlist_unhashed(&p->multicast_ctx.ip6_rlist))
 		return;
 #endif
 
@@ -3679,8 +3704,8 @@ br_multicast_rport_del_notify(struct net_bridge_port *p, bool deleted)
 	br_port_mc_router_state_change(p, false);
 
 	/* don't allow timer refresh */
-	if (p->multicast_router == MDB_RTR_TYPE_TEMP)
-		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
+	if (p->multicast_ctx.multicast_router == MDB_RTR_TYPE_TEMP)
+		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 }
 
 int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
@@ -3691,13 +3716,13 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	bool del = false;
 
 	spin_lock(&br->multicast_lock);
-	if (p->multicast_router == val) {
+	if (p->multicast_ctx.multicast_router == val) {
 		/* Refresh the temp router port timer */
-		if (p->multicast_router == MDB_RTR_TYPE_TEMP) {
-			mod_timer(&p->ip4_mc_router_timer,
+		if (p->multicast_ctx.multicast_router == MDB_RTR_TYPE_TEMP) {
+			mod_timer(&p->multicast_ctx.ip4_mc_router_timer,
 				  now + br->multicast_querier_interval);
 #if IS_ENABLED(CONFIG_IPV6)
-			mod_timer(&p->ip6_mc_router_timer,
+			mod_timer(&p->multicast_ctx.ip6_mc_router_timer,
 				  now + br->multicast_querier_interval);
 #endif
 		}
@@ -3706,32 +3731,32 @@ int br_multicast_set_port_router(struct net_bridge_port *p, unsigned long val)
 	}
 	switch (val) {
 	case MDB_RTR_TYPE_DISABLED:
-		p->multicast_router = MDB_RTR_TYPE_DISABLED;
+		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_DISABLED;
 		del |= br_ip4_multicast_rport_del(p);
-		del_timer(&p->ip4_mc_router_timer);
+		del_timer(&p->multicast_ctx.ip4_mc_router_timer);
 		del |= br_ip6_multicast_rport_del(p);
 #if IS_ENABLED(CONFIG_IPV6)
-		del_timer(&p->ip6_mc_router_timer);
+		del_timer(&p->multicast_ctx.ip6_mc_router_timer);
 #endif
 		br_multicast_rport_del_notify(p, del);
 		break;
 	case MDB_RTR_TYPE_TEMP_QUERY:
-		p->multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
+		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP_QUERY;
 		del |= br_ip4_multicast_rport_del(p);
 		del |= br_ip6_multicast_rport_del(p);
 		br_multicast_rport_del_notify(p, del);
 		break;
 	case MDB_RTR_TYPE_PERM:
-		p->multicast_router = MDB_RTR_TYPE_PERM;
-		del_timer(&p->ip4_mc_router_timer);
+		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_PERM;
+		del_timer(&p->multicast_ctx.ip4_mc_router_timer);
 		br_ip4_multicast_add_router(br, p);
 #if IS_ENABLED(CONFIG_IPV6)
-		del_timer(&p->ip6_mc_router_timer);
+		del_timer(&p->multicast_ctx.ip6_mc_router_timer);
 #endif
 		br_ip6_multicast_add_router(br, p);
 		break;
 	case MDB_RTR_TYPE_TEMP:
-		p->multicast_router = MDB_RTR_TYPE_TEMP;
+		p->multicast_ctx.multicast_router = MDB_RTR_TYPE_TEMP;
 		br_ip4_multicast_mark_router(br, p);
 		br_ip6_multicast_mark_router(br, p);
 		break;
@@ -3759,10 +3784,10 @@ static void br_multicast_start_querier(struct net_bridge *br,
 			continue;
 
 		if (query == &br->ip4_own_query)
-			br_multicast_enable(&port->ip4_own_query);
+			br_multicast_enable(&port->multicast_ctx.ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
 		else
-			br_multicast_enable(&port->ip6_own_query);
+			br_multicast_enable(&port->multicast_ctx.ip6_own_query);
 #endif
 	}
 	rcu_read_unlock();
@@ -4071,7 +4096,8 @@ EXPORT_SYMBOL_GPL(br_multicast_has_querier_adjacent);
  */
 bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
 {
-	struct net_bridge_port *port, *p;
+	struct net_bridge_mcast_port *pmctx;
+	struct net_bridge_port *port;
 	bool ret = false;
 
 	rcu_read_lock();
@@ -4081,9 +4107,9 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
 
 	switch (proto) {
 	case ETH_P_IP:
-		hlist_for_each_entry_rcu(p, &port->br->ip4_mc_router_list,
+		hlist_for_each_entry_rcu(pmctx, &port->br->ip4_mc_router_list,
 					 ip4_rlist) {
-			if (p == port)
+			if (pmctx->port == port)
 				continue;
 
 			ret = true;
@@ -4092,9 +4118,9 @@ bool br_multicast_has_router_adjacent(struct net_device *dev, int proto)
 		break;
 #if IS_ENABLED(CONFIG_IPV6)
 	case ETH_P_IPV6:
-		hlist_for_each_entry_rcu(p, &port->br->ip6_mc_router_list,
+		hlist_for_each_entry_rcu(pmctx, &port->br->ip6_mc_router_list,
 					 ip6_rlist) {
-			if (p == port)
+			if (pmctx->port == port)
 				continue;
 
 			ret = true;
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index d366420f40f1..0cbe5826cfe8 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -287,7 +287,7 @@ static int br_port_fill_attrs(struct sk_buff *skb,
 
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 	if (nla_put_u8(skb, IFLA_BRPORT_MULTICAST_ROUTER,
-		       p->multicast_router) ||
+		       p->multicast_ctx.multicast_router) ||
 	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
 			p->multicast_eht_hosts_limit) ||
 	    nla_put_u32(skb, IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 97ced5e10d04..61034fd8a3bd 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -89,6 +89,23 @@ struct bridge_mcast_stats {
 };
 #endif
 
+/* net_bridge_mcast_port must be always defined due to forwarding stubs */
+struct net_bridge_mcast_port {
+#ifdef CONFIG_BRIDGE_IGMP_SNOOPING
+	struct net_bridge_port		*port;
+
+	struct bridge_mcast_own_query	ip4_own_query;
+	struct timer_list		ip4_mc_router_timer;
+	struct hlist_node		ip4_rlist;
+#if IS_ENABLED(CONFIG_IPV6)
+	struct bridge_mcast_own_query	ip6_own_query;
+	struct timer_list		ip6_mc_router_timer;
+	struct hlist_node		ip6_rlist;
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+	unsigned char			multicast_router;
+#endif /* CONFIG_BRIDGE_IGMP_SNOOPING */
+};
+
 struct br_tunnel_info {
 	__be64				tunnel_id;
 	struct metadata_dst __rcu	*tunnel_dst;
@@ -313,19 +330,13 @@ struct net_bridge_port {
 	struct kobject			kobj;
 	struct rcu_head			rcu;
 
+	struct net_bridge_mcast_port	multicast_ctx;
+
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
-	struct bridge_mcast_own_query	ip4_own_query;
-	struct timer_list		ip4_mc_router_timer;
-	struct hlist_node		ip4_rlist;
-#if IS_ENABLED(CONFIG_IPV6)
-	struct bridge_mcast_own_query	ip6_own_query;
-	struct timer_list		ip6_mc_router_timer;
-	struct hlist_node		ip6_rlist;
-#endif /* IS_ENABLED(CONFIG_IPV6) */
+	struct bridge_mcast_stats	__percpu *mcast_stats;
+
 	u32				multicast_eht_hosts_limit;
 	u32				multicast_eht_hosts_cnt;
-	unsigned char			multicast_router;
-	struct bridge_mcast_stats	__percpu *mcast_stats;
 	struct hlist_head		mglist;
 #endif
 
@@ -892,11 +903,21 @@ br_multicast_get_first_rport_node(struct net_bridge *b, struct sk_buff *skb) {
 
 static inline struct net_bridge_port *
 br_multicast_rport_from_node_skb(struct hlist_node *rp, struct sk_buff *skb) {
+	struct net_bridge_mcast_port *mctx;
+
 #if IS_ENABLED(CONFIG_IPV6)
 	if (skb->protocol == htons(ETH_P_IPV6))
-		return hlist_entry_safe(rp, struct net_bridge_port, ip6_rlist);
+		mctx = hlist_entry_safe(rp, struct net_bridge_mcast_port,
+					ip6_rlist);
+	else
 #endif
-	return hlist_entry_safe(rp, struct net_bridge_port, ip4_rlist);
+		mctx = hlist_entry_safe(rp, struct net_bridge_mcast_port,
+					ip4_rlist);
+
+	if (mctx)
+		return mctx->port;
+	else
+		return NULL;
 }
 
 static inline bool br_ip4_multicast_is_router(struct net_bridge *br)
diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
index 72e92376eef1..e9e3aedd3178 100644
--- a/net/bridge/br_sysfs_if.c
+++ b/net/bridge/br_sysfs_if.c
@@ -244,7 +244,7 @@ BRPORT_ATTR_FLAG(isolated, BR_ISOLATED);
 #ifdef CONFIG_BRIDGE_IGMP_SNOOPING
 static ssize_t show_multicast_router(struct net_bridge_port *p, char *buf)
 {
-	return sprintf(buf, "%d\n", p->multicast_router);
+	return sprintf(buf, "%d\n", p->multicast_ctx.multicast_router);
 }
 
 static int store_multicast_router(struct net_bridge_port *p,
-- 
2.31.1

