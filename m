Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7170727219C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbgIUK4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgIUK40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:56:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A691C0613D0
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t10so12247316wrv.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=a2eErsYdK6krYgn30Vbo9aouigbIeTUlmqrfel5I2U8=;
        b=dE+uDIaWF+2+yeq/IBYpOnv8q63/xY9PkiU1yKGuM/BiFyuEATXk5lbJsLKptWHv8d
         5NpGcjEpqQWNdUZa6uKfLB86Or7HHArFxgFMPFAzuEbdWIMYq+XZQkrtjMePmvLIEPGw
         xTKTnxldIAPXF8i7RKyhZ/e3jOrRH0N0dzQ4dgLWtNo7A0Rymz7K+wIDRynmJh4Nm9ab
         PX8kvccRPhrzdMpEkaHt0L3JdlxNmBo5pCvR+EwSqBpEg4eQZy7l4XCDmfdbsf0bd9TL
         hwC1V0BZbl5XZV7B/r5zkybnMeA2Se6RLdi/2TIjYxy97UiXTyr6g5t4Q5UoZYNlbWhg
         D1dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a2eErsYdK6krYgn30Vbo9aouigbIeTUlmqrfel5I2U8=;
        b=agvXwgtmuYYFI6GNc9HciyV/gHokQpjlBkXdR0/nC5XXsHqojoPVZY2p08c2uqZn3s
         VKU8RoGtGicVNBrc9QegiOmGYKkiaRUM+svc4Fhxe5U8MITolk+nobRIfQ1YcoxVwjY7
         MMXLTLmJ8BcKxXgcxn5aLWYWwPC6vnTQW6mT4xNhPPGe2F2Ui0CkdGbduq+H1k+34Bzo
         UvE+DcLUZOlEfDpBpHuiSqzrdhvQY+o/ECdexPJQi3FO7IWE6UbyuiSQjskQsgoOzZYw
         rg1bqHEdsgz3vqE8pu3zLJTxowMGeOsZWQD7jjvYW+fCg6nOFwz3m7s+vuqDpwW0hzY5
         xZ4g==
X-Gm-Message-State: AOAM5326y4y0t+BHkWZpzI3PMKYkI3rrevVf3kmaSliWvUSZcEHeARS0
        82j802R0tiG9iTRu79BAO6X8B80x93IXp7N4ZfxmPw==
X-Google-Smtp-Source: ABdhPJxqvtiuObiK//VIExCM93VK4zf0xTFkroSfbpTJXOZHZu36SUoaUFeZ8jBzL3y5kk2cqrzyPA==
X-Received: by 2002:adf:f7d0:: with SMTP id a16mr49607264wrq.381.1600685783758;
        Mon, 21 Sep 2020 03:56:23 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id s11sm19637727wrt.43.2020.09.21.03.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 03:56:23 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 13/16] net: bridge: mcast: handle port group filter modes
Date:   Mon, 21 Sep 2020 13:55:23 +0300
Message-Id: <20200921105526.1056983-14-razor@blackwall.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200921105526.1056983-1-razor@blackwall.org>
References: <20200921105526.1056983-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

We need to handle group filter mode transitions and initial state.
To change a port group's INCLUDE -> EXCLUDE mode (or when we have added
a new port group in EXCLUDE mode) we need to add that port to all of
*,G ports' S,G entries for proper replication. When the EXCLUDE state is
changed from IGMPv3 report, br_multicast_fwd_filter_exclude() must be
called after the source list processing because the assumption is that
all of the group's S,G entries will be created before transitioning to
EXCLUDE mode, i.e. most importantly its blocked entries will already be
added so it will not get automatically added to them.
The transition EXCLUDE -> INCLUDE happens only when a port group timer
expires, it requires us to remove that port from all of *,G ports' S,G
entries where it was automatically added previously.
Finally when we are adding a new S,G entry we must add all of *,G's
EXCLUDE ports to it.
In order to distinguish automatically added *,G EXCLUDE ports we have a
new port group flag - MDB_PG_FLAGS_STAR_EXCL.

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |   1 +
 net/bridge/br_mdb.c            |  25 ++++-
 net/bridge/br_multicast.c      | 172 +++++++++++++++++++++++++++++++++
 net/bridge/br_private.h        |  20 ++++
 4 files changed, 216 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 1054f151078d..e4bd30a25f6b 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -518,6 +518,7 @@ struct br_mdb_entry {
 	__u8 state;
 #define MDB_FLAGS_OFFLOAD	(1 << 0)
 #define MDB_FLAGS_FAST_LEAVE	(1 << 1)
+#define MDB_FLAGS_STAR_EXCL	(1 << 2)
 	__u8 flags;
 	__u16 vid;
 	struct {
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 4e3a5cefc626..28cd35a9cf37 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -62,6 +62,8 @@ static void __mdb_entry_fill_flags(struct br_mdb_entry *e, unsigned char flags)
 		e->flags |= MDB_FLAGS_OFFLOAD;
 	if (flags & MDB_PG_FLAGS_FAST_LEAVE)
 		e->flags |= MDB_FLAGS_FAST_LEAVE;
+	if (flags & MDB_PG_FLAGS_STAR_EXCL)
+		e->flags |= MDB_FLAGS_STAR_EXCL;
 }
 
 static void __mdb_entry_to_br_ip(struct br_mdb_entry *entry, struct br_ip *ip,
@@ -822,11 +824,11 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			    struct nlattr **mdb_attrs,
 			    struct netlink_ext_ack *extack)
 {
-	struct net_bridge_mdb_entry *mp;
+	struct net_bridge_mdb_entry *mp, *star_mp;
 	struct net_bridge_port_group *p;
 	struct net_bridge_port_group __rcu **pp;
+	struct br_ip group, star_group;
 	unsigned long now = jiffies;
-	struct br_ip group;
 	u8 filter_mode;
 	int err;
 
@@ -890,6 +892,25 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 	if (entry->state == MDB_TEMPORARY)
 		mod_timer(&p->timer, now + br->multicast_membership_interval);
 	br_mdb_notify(br->dev, mp, p, RTM_NEWMDB);
+	/* if we are adding a new EXCLUDE port group (*,G) it needs to be also
+	 * added to all S,G entries for proper replication, if we are adding
+	 * a new INCLUDE port (S,G) then all of *,G EXCLUDE ports need to be
+	 * added to it for proper replication
+	 */
+	if (br_multicast_should_handle_mode(br, group.proto)) {
+		switch (filter_mode) {
+		case MCAST_EXCLUDE:
+			br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
+			break;
+		case MCAST_INCLUDE:
+			star_group = p->key.addr;
+			memset(&star_group.src, 0, sizeof(star_group.src));
+			star_mp = br_mdb_ip_get(br, &star_group);
+			if (star_mp)
+				br_multicast_sg_add_exclude_ports(star_mp, p);
+			break;
+		}
+	}
 
 	return 0;
 }
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ece8ac805e98..f39bbd733722 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -73,6 +73,8 @@ __br_multicast_add_group(struct net_bridge *br,
 			 const unsigned char *src,
 			 u8 filter_mode,
 			 bool igmpv2_mldv1);
+static void br_multicast_find_del_pg(struct net_bridge *br,
+				     struct net_bridge_port_group *pg);
 
 static struct net_bridge_port_group *
 br_sg_port_find(struct net_bridge *br,
@@ -195,8 +197,163 @@ static bool br_port_group_equal(struct net_bridge_port_group *p,
 	return ether_addr_equal(src, p->eth_addr);
 }
 
+static void __fwd_add_star_excl(struct net_bridge_port_group *pg,
+				struct br_ip *sg_ip)
+{
+	struct net_bridge_port_group_sg_key sg_key;
+	struct net_bridge *br = pg->key.port->br;
+	struct net_bridge_port_group *src_pg;
+
+	memset(&sg_key, 0, sizeof(sg_key));
+	sg_key.port = pg->key.port;
+	sg_key.addr = *sg_ip;
+	if (br_sg_port_find(br, &sg_key))
+		return;
+
+	src_pg = __br_multicast_add_group(br, pg->key.port, sg_ip, pg->eth_addr,
+					  MCAST_INCLUDE, false);
+	if (IS_ERR_OR_NULL(src_pg) ||
+	    src_pg->rt_protocol != RTPROT_KERNEL)
+		return;
+
+	src_pg->flags |= MDB_PG_FLAGS_STAR_EXCL;
+}
+
+static void __fwd_del_star_excl(struct net_bridge_port_group *pg,
+				struct br_ip *sg_ip)
+{
+	struct net_bridge_port_group_sg_key sg_key;
+	struct net_bridge *br = pg->key.port->br;
+	struct net_bridge_port_group *src_pg;
+
+	memset(&sg_key, 0, sizeof(sg_key));
+	sg_key.port = pg->key.port;
+	sg_key.addr = *sg_ip;
+	src_pg = br_sg_port_find(br, &sg_key);
+	if (!src_pg || !(src_pg->flags & MDB_PG_FLAGS_STAR_EXCL) ||
+	    src_pg->rt_protocol != RTPROT_KERNEL)
+		return;
+
+	br_multicast_find_del_pg(br, src_pg);
+}
+
+/* When a port group transitions to (or is added as) EXCLUDE we need to add it
+ * to all other ports' S,G entries which are not blocked by the current group
+ * for proper replication, the assumption is that any S,G blocked entries
+ * are already added so the S,G,port lookup should skip them.
+ * When a port group transitions from EXCLUDE -> INCLUDE mode or is being
+ * deleted we need to remove it from all ports' S,G entries where it was
+ * automatically installed before (i.e. where it's MDB_PG_FLAGS_STAR_EXCL).
+ */
+void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
+				     u8 filter_mode)
+{
+	struct net_bridge *br = pg->key.port->br;
+	struct net_bridge_port_group *pg_lst;
+	struct net_bridge_mdb_entry *mp;
+	struct br_ip sg_ip;
+
+	if (WARN_ON(!br_multicast_is_star_g(&pg->key.addr)))
+		return;
+
+	mp = br_mdb_ip_get(br, &pg->key.addr);
+	if (!mp)
+		return;
+
+	memset(&sg_ip, 0, sizeof(sg_ip));
+	sg_ip = pg->key.addr;
+	for (pg_lst = mlock_dereference(mp->ports, br);
+	     pg_lst;
+	     pg_lst = mlock_dereference(pg_lst->next, br)) {
+		struct net_bridge_group_src *src_ent;
+
+		if (pg_lst == pg)
+			continue;
+		hlist_for_each_entry(src_ent, &pg_lst->src_list, node) {
+			if (!(src_ent->flags & BR_SGRP_F_INSTALLED))
+				continue;
+			sg_ip.src = src_ent->addr.src;
+			switch (filter_mode) {
+			case MCAST_INCLUDE:
+				__fwd_del_star_excl(pg, &sg_ip);
+				break;
+			case MCAST_EXCLUDE:
+				__fwd_add_star_excl(pg, &sg_ip);
+				break;
+			}
+		}
+	}
+}
+
+static void br_multicast_sg_del_exclude_ports(struct net_bridge_mdb_entry *sgmp)
+{
+	struct net_bridge_port_group __rcu **pp;
+	struct net_bridge_port_group *p;
+
+	/* *,G exclude ports are only added to S,G entries */
+	if (WARN_ON(br_multicast_is_star_g(&sgmp->addr)))
+		return;
+
+	/* we need the STAR_EXCLUDE ports if there are non-STAR_EXCLUDE ports
+	 * we should ignore perm entries since they're managed by user-space
+	 */
+	for (pp = &sgmp->ports;
+	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;
+	     pp = &p->next)
+		if (!(p->flags & (MDB_PG_FLAGS_STAR_EXCL |
+				  MDB_PG_FLAGS_PERMANENT)))
+			return;
+
+	for (pp = &sgmp->ports;
+	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;) {
+		if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
+			br_multicast_del_pg(sgmp, p, pp);
+		else
+			pp = &p->next;
+	}
+}
+
+void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
+				       struct net_bridge_port_group *sg)
+{
+	struct net_bridge_port_group_sg_key sg_key;
+	struct net_bridge *br = star_mp->br;
+	struct net_bridge_port_group *pg;
+
+	if (WARN_ON(br_multicast_is_star_g(&sg->key.addr)))
+		return;
+	if (WARN_ON(!br_multicast_is_star_g(&star_mp->addr)))
+		return;
+
+	memset(&sg_key, 0, sizeof(sg_key));
+	sg_key.addr = sg->key.addr;
+	/* we need to add all exclude ports to the S,G */
+	for (pg = mlock_dereference(star_mp->ports, br);
+	     pg;
+	     pg = mlock_dereference(pg->next, br)) {
+		struct net_bridge_port_group *src_pg;
+
+		if (pg == sg || pg->filter_mode == MCAST_INCLUDE)
+			continue;
+
+		sg_key.port = pg->key.port;
+		if (br_sg_port_find(br, &sg_key))
+			continue;
+
+		src_pg = __br_multicast_add_group(br, pg->key.port,
+						  &sg->key.addr,
+						  sg->eth_addr,
+						  MCAST_INCLUDE, false);
+		if (IS_ERR_OR_NULL(src_pg) ||
+		    src_pg->rt_protocol != RTPROT_KERNEL)
+			continue;
+		src_pg->flags |= MDB_PG_FLAGS_STAR_EXCL;
+	}
+}
+
 static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 {
+	struct net_bridge_mdb_entry *star_mp;
 	struct net_bridge_port_group *sg;
 	struct br_ip sg_ip;
 
@@ -211,6 +368,7 @@ static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 	if (IS_ERR_OR_NULL(sg))
 		return;
 	src->flags |= BR_SGRP_F_INSTALLED;
+	sg->flags &= ~MDB_PG_FLAGS_STAR_EXCL;
 
 	/* if it was added by user-space as perm we can skip next steps */
 	if (sg->rt_protocol != RTPROT_KERNEL &&
@@ -219,6 +377,11 @@ static void br_multicast_fwd_src_add(struct net_bridge_group_src *src)
 
 	/* the kernel is now responsible for removing this S,G */
 	del_timer(&sg->timer);
+	star_mp = br_mdb_ip_get(src->br, &src->pg->key.addr);
+	if (!star_mp)
+		return;
+
+	br_multicast_sg_add_exclude_ports(star_mp, sg);
 }
 
 static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src)
@@ -349,6 +512,10 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
 		br_multicast_del_group_src(ent);
 	br_mdb_notify(br->dev, mp, pg, RTM_DELMDB);
+	if (!br_multicast_is_star_g(&mp->addr))
+		br_multicast_sg_del_exclude_ports(mp);
+	else
+		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	hlist_add_head(&pg->mcast_gc.gc_node, &br->mcast_gc_list);
 	queue_work(system_long_wq, &br->mcast_gc_work);
 
@@ -407,6 +574,9 @@ static void br_multicast_port_group_expired(struct timer_list *t)
 	} else if (changed) {
 		struct net_bridge_mdb_entry *mp = br_mdb_ip_get(br, &pg->key.addr);
 
+		if (changed && br_multicast_is_star_g(&pg->key.addr))
+			br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
+
 		if (WARN_ON(!mp))
 			goto out;
 		br_mdb_notify(br->dev, mp, pg, RTM_NEWMDB);
@@ -1641,6 +1811,7 @@ static bool br_multicast_isexc(struct net_bridge_port_group *pg,
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
 		__grp_src_isexc_incl(pg, srcs, nsrcs, src_size);
+		br_multicast_star_g_handle_mode(pg, MCAST_EXCLUDE);
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
@@ -1853,6 +2024,7 @@ static bool br_multicast_toex(struct net_bridge_port_group *pg,
 	switch (pg->filter_mode) {
 	case MCAST_INCLUDE:
 		__grp_src_toex_incl(pg, srcs, nsrcs, src_size);
+		br_multicast_star_g_handle_mode(pg, MCAST_EXCLUDE);
 		changed = true;
 		break;
 	case MCAST_EXCLUDE:
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 93d76b3dfc35..128d2d0417a0 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -213,6 +213,7 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_PERMANENT	BIT(0)
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
+#define MDB_PG_FLAGS_STAR_EXCL	BIT(3)
 
 #define PG_SRC_ENT_LIMIT	32
 
@@ -833,6 +834,10 @@ void br_mdb_init(void);
 void br_mdb_uninit(void);
 void br_multicast_host_join(struct net_bridge_mdb_entry *mp, bool notify);
 void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify);
+void br_multicast_star_g_handle_mode(struct net_bridge_port_group *pg,
+				     u8 filter_mode);
+void br_multicast_sg_add_exclude_ports(struct net_bridge_mdb_entry *star_mp,
+				       struct net_bridge_port_group *sg);
 
 #define mlock_dereference(X, br) \
 	rcu_dereference_protected(X, lockdep_is_held(&br->multicast_lock))
@@ -895,6 +900,21 @@ static inline bool br_multicast_is_star_g(const struct br_ip *ip)
 	}
 }
 
+static inline bool br_multicast_should_handle_mode(const struct net_bridge *br,
+						   __be16 proto)
+{
+	switch (proto) {
+	case htons(ETH_P_IP):
+		return !!(br->multicast_igmp_version == 3);
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		return !!(br->multicast_mld_version == 2);
+#endif
+	default:
+		return false;
+	}
+}
+
 static inline int br_multicast_igmp_type(const struct sk_buff *skb)
 {
 	return BR_INPUT_SKB_CB(skb)->igmp;
-- 
2.25.4

