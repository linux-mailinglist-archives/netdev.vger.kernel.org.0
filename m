Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFD63CE83E
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355202AbhGSQja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355638AbhGSQg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:28 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283E6C04F973
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:49 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id dp20so27988704ejc.7
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rMOg4u/ufyGzocm7b1ODLZi3F0RCwEsf+WQjWvZrTkM=;
        b=iDH2ookIezgXKu65gP8cc1DSbEYPk9qw06UXsM86MojRjPXOBRiwwEubqRk0eymtYm
         Z41lLbtyPgl8P2QMVM9Ed73YZjo+jUFzzOeIqyJjbYF03slynrkuTKeEYcFzmDBKv8cI
         UlxWP5yvRGxztsLp3Q6HKXJJPUJiQhuY1ehcPoaYuFGvdsRMvgiQgOIUvAieiLM4F4cy
         tY0Ex9gbjq9AQA3V2CSQX0kStY/D61jBKR6x/DPdyZ4S2ghjhyQguui+YV8SnXajZ1WP
         ipRIvIZ/3EdOgX2mVox7uCK1i+E6yaL3pQNnPyeM/vocrlVFpRCbTB6UyaRx2Z0S/XB1
         TlpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rMOg4u/ufyGzocm7b1ODLZi3F0RCwEsf+WQjWvZrTkM=;
        b=OOlpTT5VD1azN0nBKfIBgITBvz3rHtPm3f2gZ+Ilxa6bNkwZLuXrvnyRTClRmxZpwP
         Lfy6vDuFTDLafktzxqGZEg9xmHnLN7VDs3spGi6Rpc42YcLP9+avPhgVjLHfYxT0dT0m
         +1ie/lpKGp32IJETKkWIDP9RKheZfSov1uHgMbnVTE0iZY3qwppMjUx4l0cMzFyDOEHg
         Xb+thjyWNNm9cEyrrsSWI1cmjl1tzGmPBxG3yGeV9D41QLP4A0ARc+JSxqBoCdQ7IZW/
         Gonrt4NekVx7+opJDJI733js7sNdmOSHF7AbGwXNr6IdO37e2JOm8Tm3mnoXSLhgNGGY
         hBKg==
X-Gm-Message-State: AOAM530Vex7JoN7pIVY7FkLdndGVb6JEqfpsKV7I4zl834PRr1K2ZRB0
        x9D6SNsUwg3fu4nagJqmmm9iWU7z+6R0eAue0fo=
X-Google-Smtp-Source: ABdhPJzgeCm2FxTD1xDd+2QaY9NUzBQIOi8b6CUBrHkH4yat6RSseiUP1pSwxwiMuIb3pswHqBe1sg==
X-Received: by 2002:a17:906:c49:: with SMTP id t9mr27649534ejf.405.1626714601335;
        Mon, 19 Jul 2021 10:10:01 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:00 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 05/15] net: bridge: multicast: add vlan state initialization and control
Date:   Mon, 19 Jul 2021 20:06:27 +0300
Message-Id: <20210719170637.435541-6-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add helpers to enable/disable vlan multicast based on its flags, we need
two flags because we need to know if the vlan has multicast enabled
globally (user-controlled) and if it has it enabled on the specific device
(bridge or port). The new private vlan flags are:
 - BR_VLFLAG_MCAST_ENABLED: locally enabled multicast on the device, used
   when removing a vlan, toggling vlan mcast snooping and controlling
   single vlan (kernel-controlled, valid under RTNL and multicast_lock)
 - BR_VLFLAG_GLOBAL_MCAST_ENABLED: globally enabled multicast for the
   vlan, used to control the bridge-wide vlan mcast snooping for a
   single vlan (user-controlled, can be checked under any context)

Bridge vlan contexts are created with multicast snooping enabled by
default to be in line with the current bridge snooping defaults. In
order to actually activate per vlan snooping and context usage a
bridge-wide knob will be added later which will default to disabled.
If that knob is enabled then automatically all vlan snooping will be
enabled. All vlan contexts are initialized with the current bridge
multicast context defaults.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 net/bridge/br_multicast.c | 128 ++++++++++++++++++++++++++++++++------
 net/bridge/br_private.h   |  50 +++++++++++++++
 net/bridge/br_vlan.c      |   4 ++
 3 files changed, 164 insertions(+), 18 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 6f803f789217..ef4e7de3f18d 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -214,7 +214,7 @@ static void __fwd_add_star_excl(struct net_bridge_mcast_port *pmctx,
 	struct net_bridge_mcast *brmctx;
 
 	memset(&sg_key, 0, sizeof(sg_key));
-	brmctx = &pg->key.port->br->multicast_ctx;
+	brmctx = br_multicast_port_ctx_get_global(pmctx);
 	sg_key.port = pg->key.port;
 	sg_key.addr = *sg_ip;
 	if (br_sg_port_find(brmctx->br, &sg_key))
@@ -275,6 +275,7 @@ void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
 
 	memset(&sg_ip, 0, sizeof(sg_ip));
 	sg_ip = pg->key.addr;
+
 	for (pg_lst = mlock_dereference(mp->ports, br);
 	     pg_lst;
 	     pg_lst = mlock_dereference(pg_lst->next, br)) {
@@ -435,7 +436,7 @@ static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 
 	memset(&sg_ip, 0, sizeof(sg_ip));
 	pmctx = &src->pg->key.port->multicast_ctx;
-	brmctx = &src->br->multicast_ctx;
+	brmctx = br_multicast_port_ctx_get_global(pmctx);
 	sg_ip = src->pg->key.addr;
 	sg_ip.src = src->addr.src;
 
@@ -1775,9 +1776,11 @@ static void br_multicast_enable(struct bridge_mcast_own_query *query)
 static void __br_multicast_enable_port_ctx(struct net_bridge_mcast_port *pmctx)
 {
 	struct net_bridge *br = pmctx->port->br;
-	struct net_bridge_mcast *brmctx = &pmctx->port->br->multicast_ctx;
+	struct net_bridge_mcast *brmctx;
 
-	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED) || !netif_running(br->dev))
+	brmctx = br_multicast_port_ctx_get_global(pmctx);
+	if (!br_opt_get(br, BROPT_MULTICAST_ENABLED) ||
+	    !netif_running(br->dev))
 		return;
 
 	br_multicast_enable(&pmctx->ip4_own_query);
@@ -1799,18 +1802,17 @@ void br_multicast_enable_port(struct net_bridge_port *port)
 	spin_unlock(&br->multicast_lock);
 }
 
-void br_multicast_disable_port(struct net_bridge_port *port)
+static void __br_multicast_disable_port_ctx(struct net_bridge_mcast_port *pmctx)
 {
-	struct net_bridge_mcast_port *pmctx = &port->multicast_ctx;
-	struct net_bridge *br = port->br;
 	struct net_bridge_port_group *pg;
 	struct hlist_node *n;
 	bool del = false;
 
-	spin_lock(&br->multicast_lock);
-	hlist_for_each_entry_safe(pg, n, &port->mglist, mglist)
-		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_find_del_pg(br, pg);
+	hlist_for_each_entry_safe(pg, n, &pmctx->port->mglist, mglist)
+		if (!(pg->flags & MDB_PG_FLAGS_PERMANENT) &&
+		    (!br_multicast_port_ctx_is_vlan(pmctx) ||
+		     pg->key.addr.vid == pmctx->vlan->vid))
+			br_multicast_find_del_pg(pmctx->port->br, pg);
 
 	del |= br_ip4_multicast_rport_del(pmctx);
 	del_timer(&pmctx->ip4_mc_router_timer);
@@ -1821,7 +1823,13 @@ void br_multicast_disable_port(struct net_bridge_port *port)
 	del_timer(&pmctx->ip6_own_query.timer);
 #endif
 	br_multicast_rport_del_notify(pmctx, del);
-	spin_unlock(&br->multicast_lock);
+}
+
+void br_multicast_disable_port(struct net_bridge_port *port)
+{
+	spin_lock(&port->br->multicast_lock);
+	__br_multicast_disable_port_ctx(&port->multicast_ctx);
+	spin_unlock(&port->br->multicast_lock);
 }
 
 static int __grp_src_delete_marked(struct net_bridge_port_group *pg)
@@ -3698,8 +3706,8 @@ void br_multicast_leave_snoopers(struct net_bridge *br)
 	br_ip6_multicast_leave_snoopers(br);
 }
 
-static void __br_multicast_open(struct net_bridge *br,
-				struct bridge_mcast_own_query *query)
+static void __br_multicast_open_query(struct net_bridge *br,
+				      struct bridge_mcast_own_query *query)
 {
 	query->startup_sent = 0;
 
@@ -3709,14 +3717,36 @@ static void __br_multicast_open(struct net_bridge *br,
 	mod_timer(&query->timer, jiffies);
 }
 
-void br_multicast_open(struct net_bridge *br)
+static void __br_multicast_open(struct net_bridge_mcast *brmctx)
 {
-	__br_multicast_open(br, &br->multicast_ctx.ip4_own_query);
+	__br_multicast_open_query(brmctx->br, &brmctx->ip4_own_query);
 #if IS_ENABLED(CONFIG_IPV6)
-	__br_multicast_open(br, &br->multicast_ctx.ip6_own_query);
+	__br_multicast_open_query(brmctx->br, &brmctx->ip6_own_query);
 #endif
 }
 
+void br_multicast_open(struct net_bridge *br)
+{
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *vlan;
+
+	ASSERT_RTNL();
+
+	vg = br_vlan_group(br);
+	if (vg) {
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			struct net_bridge_mcast *brmctx;
+
+			brmctx = &vlan->br_mcast_ctx;
+			if (br_vlan_is_brentry(vlan) &&
+			    !br_multicast_ctx_vlan_disabled(brmctx))
+				__br_multicast_open(&vlan->br_mcast_ctx);
+		}
+	}
+
+	__br_multicast_open(&br->multicast_ctx);
+}
+
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx)
 {
 	del_timer_sync(&brmctx->ip4_mc_router_timer);
@@ -3729,8 +3759,70 @@ static void __br_multicast_stop(struct net_bridge_mcast *brmctx)
 #endif
 }
 
+void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on)
+{
+	struct net_bridge *br;
+
+	/* it's okay to check for the flag without the multicast lock because it
+	 * can only change under RTNL -> multicast_lock, we need the latter to
+	 * sync with timers and packets
+	 */
+	if (on == !!(vlan->priv_flags & BR_VLFLAG_MCAST_ENABLED))
+		return;
+
+	if (br_vlan_is_master(vlan)) {
+		br = vlan->br;
+
+		if (!br_vlan_is_brentry(vlan) ||
+		    (on &&
+		     br_multicast_ctx_vlan_global_disabled(&vlan->br_mcast_ctx)))
+			return;
+
+		spin_lock_bh(&br->multicast_lock);
+		vlan->priv_flags ^= BR_VLFLAG_MCAST_ENABLED;
+		spin_unlock_bh(&br->multicast_lock);
+
+		if (on)
+			__br_multicast_open(&vlan->br_mcast_ctx);
+		else
+			__br_multicast_stop(&vlan->br_mcast_ctx);
+	} else {
+		struct net_bridge_mcast *brmctx;
+
+		brmctx = br_multicast_port_ctx_get_global(&vlan->port_mcast_ctx);
+		if (on && br_multicast_ctx_vlan_global_disabled(brmctx))
+			return;
+
+		br = vlan->port->br;
+		spin_lock_bh(&br->multicast_lock);
+		vlan->priv_flags ^= BR_VLFLAG_MCAST_ENABLED;
+		if (on)
+			__br_multicast_enable_port_ctx(&vlan->port_mcast_ctx);
+		else
+			__br_multicast_disable_port_ctx(&vlan->port_mcast_ctx);
+		spin_unlock_bh(&br->multicast_lock);
+	}
+}
+
 void br_multicast_stop(struct net_bridge *br)
 {
+	struct net_bridge_vlan_group *vg;
+	struct net_bridge_vlan *vlan;
+
+	ASSERT_RTNL();
+
+	vg = br_vlan_group(br);
+	if (vg) {
+		list_for_each_entry(vlan, &vg->vlan_list, vlist) {
+			struct net_bridge_mcast *brmctx;
+
+			brmctx = &vlan->br_mcast_ctx;
+			if (br_vlan_is_brentry(vlan) &&
+			    !br_multicast_ctx_vlan_disabled(brmctx))
+				__br_multicast_stop(&vlan->br_mcast_ctx);
+		}
+	}
+
 	__br_multicast_stop(&br->multicast_ctx);
 }
 
@@ -3876,7 +3968,7 @@ static void br_multicast_start_querier(struct net_bridge_mcast *brmctx,
 {
 	struct net_bridge_port *port;
 
-	__br_multicast_open(brmctx->br, query);
+	__br_multicast_open_query(brmctx->br, query);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &brmctx->br->port_list, list) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7a0d077c2c39..a27c8b8f6efd 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -151,6 +151,8 @@ struct br_tunnel_info {
 enum {
 	BR_VLFLAG_PER_PORT_STATS = BIT(0),
 	BR_VLFLAG_ADDED_BY_SWITCHDEV = BIT(1),
+	BR_VLFLAG_MCAST_ENABLED = BIT(2),
+	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 };
 
 /**
@@ -914,6 +916,7 @@ void br_multicast_port_ctx_init(struct net_bridge_port *port,
 				struct net_bridge_vlan *vlan,
 				struct net_bridge_mcast_port *pmctx);
 void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx);
+void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan, bool on);
 
 static inline bool br_group_is_l2(const struct br_ip *group)
 {
@@ -1075,6 +1078,48 @@ static inline unsigned long br_multicast_gmi(const struct net_bridge_mcast *brmc
 	return 2 * brmctx->multicast_query_interval +
 	       brmctx->multicast_query_response_interval;
 }
+
+static inline bool
+br_multicast_ctx_is_vlan(const struct net_bridge_mcast *brmctx)
+{
+	return !!brmctx->vlan;
+}
+
+static inline bool
+br_multicast_port_ctx_is_vlan(const struct net_bridge_mcast_port *pmctx)
+{
+	return !!pmctx->vlan;
+}
+
+static inline struct net_bridge_mcast *
+br_multicast_port_ctx_get_global(const struct net_bridge_mcast_port *pmctx)
+{
+	if (!br_multicast_port_ctx_is_vlan(pmctx))
+		return &pmctx->port->br->multicast_ctx;
+	else
+		return &pmctx->vlan->brvlan->br_mcast_ctx;
+}
+
+static inline bool
+br_multicast_ctx_vlan_global_disabled(const struct net_bridge_mcast *brmctx)
+{
+	return br_multicast_ctx_is_vlan(brmctx) &&
+	       !(brmctx->vlan->priv_flags & BR_VLFLAG_GLOBAL_MCAST_ENABLED);
+}
+
+static inline bool
+br_multicast_ctx_vlan_disabled(const struct net_bridge_mcast *brmctx)
+{
+	return br_multicast_ctx_is_vlan(brmctx) &&
+	       !(brmctx->vlan->priv_flags & BR_VLFLAG_MCAST_ENABLED);
+}
+
+static inline bool
+br_multicast_port_ctx_vlan_disabled(const struct net_bridge_mcast_port *pmctx)
+{
+	return br_multicast_port_ctx_is_vlan(pmctx) &&
+	       !(pmctx->vlan->priv_flags & BR_VLFLAG_MCAST_ENABLED);
+}
 #else
 static inline int br_multicast_rcv(struct net_bridge_mcast *brmctx,
 				   struct net_bridge_mcast_port *pmctx,
@@ -1208,6 +1253,11 @@ static inline void br_multicast_port_ctx_init(struct net_bridge_port *port,
 static inline void br_multicast_port_ctx_deinit(struct net_bridge_mcast_port *pmctx)
 {
 }
+
+static inline void br_multicast_toggle_one_vlan(struct net_bridge_vlan *vlan,
+						bool on)
+{
+}
 #endif
 
 /* br_vlan.c */
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index e7b7bb0a005b..1a8cb2b1b762 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -190,6 +190,7 @@ static void br_vlan_put_master(struct net_bridge_vlan *masterv)
 		rhashtable_remove_fast(&vg->vlan_hash,
 				       &masterv->vnode, br_vlan_rht_params);
 		__vlan_del_list(masterv);
+		br_multicast_toggle_one_vlan(masterv, false);
 		br_multicast_ctx_deinit(&masterv->br_mcast_ctx);
 		call_rcu(&masterv->rcu, br_master_vlan_rcu_free);
 	}
@@ -287,6 +288,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 		if (err && err != -EOPNOTSUPP)
 			goto out;
 		br_multicast_ctx_init(br, v, &v->br_mcast_ctx);
+		v->priv_flags |= BR_VLFLAG_GLOBAL_MCAST_ENABLED;
 	}
 
 	/* Add the dev mac and count the vlan only if it's usable */
@@ -309,6 +311,7 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 
 	__vlan_add_list(v);
 	__vlan_add_flags(v, flags);
+	br_multicast_toggle_one_vlan(v, true);
 
 	if (p)
 		nbp_vlan_set_vlan_dev_state(p, v->vid);
@@ -377,6 +380,7 @@ static int __vlan_del(struct net_bridge_vlan *v)
 				       br_vlan_rht_params);
 		__vlan_del_list(v);
 		nbp_vlan_set_vlan_dev_state(p, v->vid);
+		br_multicast_toggle_one_vlan(v, false);
 		br_multicast_port_ctx_deinit(&v->port_mcast_ctx);
 		call_rcu(&v->rcu, nbp_vlan_rcu_free);
 	}
-- 
2.31.1

