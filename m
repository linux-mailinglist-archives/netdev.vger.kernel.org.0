Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D51C025F701
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 12:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgIGKAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 06:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbgIGKAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 06:00:16 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCBDC061574
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 03:00:16 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id a65so13761441wme.5
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 03:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gF8tTbcX13Y5wpolM+nEA4o4BCNDLOqyYK0Q0/g1IsQ=;
        b=ZwPZefNeeSwUKEJrGAV+bNuFbsaIT2NZLsLtTdj3IodD/vLoO0XYmGGlajy7dGtlWb
         lGGcFmwmfmvid4EtGvuBwo1sirNQpGYPuyfww4BcU481hH8sq3mCLTYfQscS4rzj5Kwa
         v3j5lpaRT5Biw3eL0gemqMdAj0qtQYxN3bG9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gF8tTbcX13Y5wpolM+nEA4o4BCNDLOqyYK0Q0/g1IsQ=;
        b=kyldmzAZf/i/VihBxxcB8y/9QolBDRSWy9B8R2nIG/o0TYjNqs3jo2bvzITyEFrhPT
         wGKZX+3MzWD1uX9oQktMOyIcmOvP30gDRG5eXYxiNKOJ++ZEhjxoiVNOAlnJCexAqACY
         BFdap3418oivLWcA1naxuZFcf+VhdkBI2IvqhX+u3WsSycIL0VpPhXAEkXPXiQ5T7V0r
         /H6slJ7Y/Ibk3Yb3jIJJKZTb01aD/FV7yIu2wJgmDCZFU66BDsGnX8FM8RllJyJmJFV9
         rFpPoTjonxcwegVf5yeIm0syczxlN2yzq9r+Q4yujvwf2Kskh1/SjNq4K2rmZfMY6fQi
         MMxg==
X-Gm-Message-State: AOAM5302ecEJ/0TZRf2H9PtNBRzh5dI8ySogHoMWuh0EWkPBXVTIYlxQ
        ZhHq0XpQkYot4DhPw0B87rzlS14i4g7K/sFb
X-Google-Smtp-Source: ABdhPJzR7s4CZQEAFZ0H16kbOhvtHKfrxKDUplymroG3uhPjKDh3aAVvXkQTXswtIg3ZRLpEZj7OpQ==
X-Received: by 2002:a1c:ba42:: with SMTP id k63mr19479112wmf.31.1599472814259;
        Mon, 07 Sep 2020 03:00:14 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 9sm6686289wmf.7.2020.09.07.03.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 03:00:13 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v4 03/15] net: bridge: mcast: add support for group source list
Date:   Mon,  7 Sep 2020 12:56:07 +0300
Message-Id: <20200907095619.11216-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
References: <20200907095619.11216-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Initial functions for group source lists which are needed for IGMPv3
and MLDv2 include/exclude lists. Both IPv4 and IPv6 sources are supported.
User-added mdb entries are created with exclude filter mode, we can
extend that later to allow user-supplied mode. When group src entries
are deleted, they're freed from a workqueue to make sure their timers
are not still running. Source entries are protected by the multicast_lock
and rcu. The number of src groups per port group is limited to 32.

v4: use the new port group del function directly
    add igmpv2/mldv1 bool to denote if the entry was added in those
    modes, it will later replace the old update_timer bool
v3: add IPv6 support
v2: allow src groups to be traversed under rcu

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/bridge/br_mdb.c       |   3 +-
 net/bridge/br_multicast.c | 164 +++++++++++++++++++++++++++++++++++---
 net/bridge/br_private.h   |  26 +++++-
 3 files changed, 179 insertions(+), 14 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 9a975e2a2489..559bdc256a1e 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -638,7 +638,8 @@ static int br_mdb_add_group(struct net_bridge *br, struct net_bridge_port *port,
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, state, NULL);
+	p = br_multicast_new_port_group(port, group, *pp, state, NULL,
+					MCAST_EXCLUDE);
 	if (unlikely(!p))
 		return -ENOMEM;
 	rcu_assign_pointer(*pp, p);
diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index e1739652f859..bbfa0219fa4a 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -163,15 +163,29 @@ static void br_multicast_group_expired(struct timer_list *t)
 	spin_unlock(&br->multicast_lock);
 }
 
+static void br_multicast_del_group_src(struct net_bridge_group_src *src)
+{
+	struct net_bridge *br = src->pg->port->br;
+
+	hlist_del_init_rcu(&src->node);
+	src->pg->src_ents--;
+	hlist_add_head(&src->del_node, &br->src_gc_list);
+	queue_work(system_long_wq, &br->src_gc_work);
+}
+
 void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 			 struct net_bridge_port_group *pg,
 			 struct net_bridge_port_group __rcu **pp)
 {
 	struct net_bridge *br = pg->port->br;
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
 
 	rcu_assign_pointer(*pp, pg->next);
 	hlist_del_init(&pg->mglist);
 	del_timer(&pg->timer);
+	hlist_for_each_entry_safe(ent, tmp, &pg->src_list, node)
+		br_multicast_del_group_src(ent);
 	br_mdb_notify(br->dev, pg->port, &pg->addr, RTM_DELMDB, pg->flags);
 	kfree_rcu(pg, rcu);
 
@@ -182,9 +196,9 @@ void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg)
 {
+	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_mdb_entry *mp;
 	struct net_bridge_port_group *p;
-	struct net_bridge_port_group __rcu **pp;
 
 	mp = br_mdb_ip_get(br, &pg->addr);
 	if (WARN_ON(!mp))
@@ -476,12 +490,96 @@ struct net_bridge_mdb_entry *br_multicast_new_group(struct net_bridge *br,
 	return mp;
 }
 
+static void br_multicast_group_src_expired(struct timer_list *t)
+{
+	struct net_bridge_group_src *src = from_timer(src, t, timer);
+	struct net_bridge_port_group *pg;
+	struct net_bridge *br = src->br;
+
+	spin_lock(&br->multicast_lock);
+	if (hlist_unhashed(&src->node) || !netif_running(br->dev) ||
+	    timer_pending(&src->timer))
+		goto out;
+
+	pg = src->pg;
+	if (pg->filter_mode == MCAST_INCLUDE) {
+		br_multicast_del_group_src(src);
+		if (!hlist_empty(&pg->src_list))
+			goto out;
+		br_multicast_find_del_pg(br, pg);
+	}
+out:
+	spin_unlock(&br->multicast_lock);
+}
+
+static struct net_bridge_group_src *
+br_multicast_find_group_src(struct net_bridge_port_group *pg, struct br_ip *ip)
+{
+	struct net_bridge_group_src *ent;
+
+	switch (ip->proto) {
+	case htons(ETH_P_IP):
+		hlist_for_each_entry(ent, &pg->src_list, node)
+			if (ip->u.ip4 == ent->addr.u.ip4)
+				return ent;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		hlist_for_each_entry(ent, &pg->src_list, node)
+			if (!ipv6_addr_cmp(&ent->addr.u.ip6, &ip->u.ip6))
+				return ent;
+		break;
+#endif
+	}
+
+	return NULL;
+}
+
+static struct net_bridge_group_src *
+br_multicast_new_group_src(struct net_bridge_port_group *pg, struct br_ip *src_ip)
+{
+	struct net_bridge_group_src *grp_src;
+
+	if (unlikely(pg->src_ents >= PG_SRC_ENT_LIMIT))
+		return NULL;
+
+	switch (src_ip->proto) {
+	case htons(ETH_P_IP):
+		if (ipv4_is_zeronet(src_ip->u.ip4) ||
+		    ipv4_is_multicast(src_ip->u.ip4))
+			return NULL;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case htons(ETH_P_IPV6):
+		if (ipv6_addr_any(&src_ip->u.ip6) ||
+		    ipv6_addr_is_multicast(&src_ip->u.ip6))
+			return NULL;
+		break;
+#endif
+	}
+
+	grp_src = kzalloc(sizeof(*grp_src), GFP_ATOMIC);
+	if (unlikely(!grp_src))
+		return NULL;
+
+	grp_src->pg = pg;
+	grp_src->br = pg->port->br;
+	grp_src->addr = *src_ip;
+	timer_setup(&grp_src->timer, br_multicast_group_src_expired, 0);
+
+	hlist_add_head_rcu(&grp_src->node, &pg->src_list);
+	pg->src_ents++;
+
+	return grp_src;
+}
+
 struct net_bridge_port_group *br_multicast_new_port_group(
 			struct net_bridge_port *port,
 			struct br_ip *group,
 			struct net_bridge_port_group __rcu *next,
 			unsigned char flags,
-			const unsigned char *src)
+			const unsigned char *src,
+			u8 filter_mode)
 {
 	struct net_bridge_port_group *p;
 
@@ -492,6 +590,8 @@ struct net_bridge_port_group *br_multicast_new_port_group(
 	p->addr = *group;
 	p->port = port;
 	p->flags = flags;
+	p->filter_mode = filter_mode;
+	INIT_HLIST_HEAD(&p->src_list);
 	rcu_assign_pointer(p->next, next);
 	hlist_add_head(&p->mglist, &port->mglist);
 	timer_setup(&p->timer, br_multicast_port_group_expired, 0);
@@ -541,7 +641,8 @@ void br_multicast_host_leave(struct net_bridge_mdb_entry *mp, bool notify)
 static int br_multicast_add_group(struct net_bridge *br,
 				  struct net_bridge_port *port,
 				  struct br_ip *group,
-				  const unsigned char *src)
+				  const unsigned char *src,
+				  u8 filter_mode)
 {
 	struct net_bridge_port_group __rcu **pp;
 	struct net_bridge_port_group *p;
@@ -573,7 +674,7 @@ static int br_multicast_add_group(struct net_bridge *br,
 			break;
 	}
 
-	p = br_multicast_new_port_group(port, group, *pp, 0, src);
+	p = br_multicast_new_port_group(port, group, *pp, 0, src, filter_mode);
 	if (unlikely(!p))
 		goto err;
 	rcu_assign_pointer(*pp, p);
@@ -593,9 +694,11 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 				      struct net_bridge_port *port,
 				      __be32 group,
 				      __u16 vid,
-				      const unsigned char *src)
+				      const unsigned char *src,
+				      bool igmpv2)
 {
 	struct br_ip br_group;
+	u8 filter_mode;
 
 	if (ipv4_is_local_multicast(group))
 		return 0;
@@ -604,8 +707,9 @@ static int br_ip4_multicast_add_group(struct net_bridge *br,
 	br_group.u.ip4 = group;
 	br_group.proto = htons(ETH_P_IP);
 	br_group.vid = vid;
+	filter_mode = igmpv2 ? MCAST_EXCLUDE : MCAST_INCLUDE;
 
-	return br_multicast_add_group(br, port, &br_group, src);
+	return br_multicast_add_group(br, port, &br_group, src, filter_mode);
 }
 
 #if IS_ENABLED(CONFIG_IPV6)
@@ -613,9 +717,11 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 				      struct net_bridge_port *port,
 				      const struct in6_addr *group,
 				      __u16 vid,
-				      const unsigned char *src)
+				      const unsigned char *src,
+				      bool mldv1)
 {
 	struct br_ip br_group;
+	u8 filter_mode;
 
 	if (ipv6_addr_is_ll_all_nodes(group))
 		return 0;
@@ -624,8 +730,9 @@ static int br_ip6_multicast_add_group(struct net_bridge *br,
 	br_group.u.ip6 = *group;
 	br_group.proto = htons(ETH_P_IPV6);
 	br_group.vid = vid;
+	filter_mode = mldv1 ? MCAST_EXCLUDE : MCAST_INCLUDE;
 
-	return br_multicast_add_group(br, port, &br_group, src);
+	return br_multicast_add_group(br, port, &br_group, src, filter_mode);
 }
 #endif
 
@@ -974,7 +1081,7 @@ static int br_ip4_multicast_igmp3_report(struct net_bridge *br,
 			br_ip4_multicast_leave_group(br, port, group, vid, src);
 		} else {
 			err = br_ip4_multicast_add_group(br, port, group, vid,
-							 src);
+							 src, true);
 			if (err)
 				break;
 		}
@@ -1053,7 +1160,7 @@ static int br_ip6_multicast_mld2_report(struct net_bridge *br,
 		} else {
 			err = br_ip6_multicast_add_group(br, port,
 							 &grec->grec_mca, vid,
-							 src);
+							 src, true);
 			if (err)
 				break;
 		}
@@ -1625,7 +1732,8 @@ static int br_multicast_ipv4_rcv(struct net_bridge *br,
 	case IGMP_HOST_MEMBERSHIP_REPORT:
 	case IGMPV2_HOST_MEMBERSHIP_REPORT:
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
-		err = br_ip4_multicast_add_group(br, port, ih->group, vid, src);
+		err = br_ip4_multicast_add_group(br, port, ih->group, vid, src,
+						 true);
 		break;
 	case IGMPV3_HOST_MEMBERSHIP_REPORT:
 		err = br_ip4_multicast_igmp3_report(br, port, skb, vid);
@@ -1704,7 +1812,7 @@ static int br_multicast_ipv6_rcv(struct net_bridge *br,
 		src = eth_hdr(skb)->h_source;
 		BR_INPUT_SKB_CB(skb)->mrouters_only = 1;
 		err = br_ip6_multicast_add_group(br, port, &mld->mld_mca, vid,
-						 src);
+						 src, true);
 		break;
 	case ICMPV6_MLD2_REPORT:
 		err = br_ip6_multicast_mld2_report(br, port, skb, vid);
@@ -1779,6 +1887,31 @@ static void br_ip6_multicast_query_expired(struct timer_list *t)
 }
 #endif
 
+static void __grp_src_gc(struct hlist_head *head)
+{
+	struct net_bridge_group_src *ent;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry_safe(ent, tmp, head, del_node) {
+		hlist_del_init(&ent->del_node);
+		del_timer_sync(&ent->timer);
+		kfree_rcu(ent, rcu);
+	}
+}
+
+static void br_multicast_src_gc(struct work_struct *work)
+{
+	struct net_bridge *br = container_of(work, struct net_bridge,
+					     src_gc_work);
+	HLIST_HEAD(deleted_head);
+
+	spin_lock_bh(&br->multicast_lock);
+	hlist_move_list(&br->src_gc_list, &deleted_head);
+	spin_unlock_bh(&br->multicast_lock);
+
+	__grp_src_gc(&deleted_head);
+}
+
 void br_multicast_init(struct net_bridge *br)
 {
 	br->hash_max = BR_MULTICAST_DEFAULT_HASH_MAX;
@@ -1819,6 +1952,8 @@ void br_multicast_init(struct net_bridge *br)
 		    br_ip6_multicast_query_expired, 0);
 #endif
 	INIT_HLIST_HEAD(&br->mdb_list);
+	INIT_HLIST_HEAD(&br->src_gc_list);
+	INIT_WORK(&br->src_gc_work, br_multicast_src_gc);
 }
 
 static void br_ip4_multicast_join_snoopers(struct net_bridge *br)
@@ -1922,6 +2057,7 @@ void br_multicast_stop(struct net_bridge *br)
 void br_multicast_dev_del(struct net_bridge *br)
 {
 	struct net_bridge_mdb_entry *mp;
+	HLIST_HEAD(deleted_head);
 	struct hlist_node *tmp;
 
 	spin_lock_bh(&br->multicast_lock);
@@ -1932,8 +2068,12 @@ void br_multicast_dev_del(struct net_bridge *br)
 		hlist_del_rcu(&mp->mdb_node);
 		kfree_rcu(mp, rcu);
 	}
+	hlist_move_list(&br->src_gc_list, &deleted_head);
 	spin_unlock_bh(&br->multicast_lock);
 
+	__grp_src_gc(&deleted_head);
+	cancel_work_sync(&br->src_gc_work);
+
 	rcu_barrier();
 }
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 800e9b91483c..eab8952a332a 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -214,13 +214,34 @@ struct net_bridge_fdb_entry {
 #define MDB_PG_FLAGS_OFFLOAD	BIT(1)
 #define MDB_PG_FLAGS_FAST_LEAVE	BIT(2)
 
+#define PG_SRC_ENT_LIMIT	32
+
+#define BR_SGRP_F_DELETE	BIT(0)
+#define BR_SGRP_F_SEND		BIT(1)
+
+struct net_bridge_group_src {
+	struct hlist_node		node;
+
+	struct br_ip			addr;
+	struct net_bridge_port_group	*pg;
+	u8				flags;
+	struct timer_list		timer;
+
+	struct net_bridge		*br;
+	struct hlist_node		del_node;
+	struct rcu_head			rcu;
+};
+
 struct net_bridge_port_group {
 	struct net_bridge_port		*port;
 	struct net_bridge_port_group __rcu *next;
 	struct br_ip			addr;
 	unsigned char			eth_addr[ETH_ALEN] __aligned(2);
 	unsigned char			flags;
+	unsigned char			filter_mode;
 
+	struct hlist_head		src_list;
+	unsigned int			src_ents;
 	struct timer_list		timer;
 	struct hlist_node		mglist;
 
@@ -410,6 +431,7 @@ struct net_bridge {
 
 	struct rhashtable		mdb_hash_tbl;
 
+	struct hlist_head		src_gc_list;
 	struct hlist_head		mdb_list;
 	struct hlist_head		router_list;
 
@@ -423,6 +445,7 @@ struct net_bridge {
 	struct bridge_mcast_own_query	ip6_own_query;
 	struct bridge_mcast_querier	ip6_querier;
 #endif /* IS_ENABLED(CONFIG_IPV6) */
+	struct work_struct		src_gc_work;
 #endif
 
 	struct timer_list		hello_timer;
@@ -770,7 +793,8 @@ br_multicast_new_group(struct net_bridge *br, struct br_ip *group);
 struct net_bridge_port_group *
 br_multicast_new_port_group(struct net_bridge_port *port, struct br_ip *group,
 			    struct net_bridge_port_group __rcu *next,
-			    unsigned char flags, const unsigned char *src);
+			    unsigned char flags, const unsigned char *src,
+			    u8 filter_mode);
 int br_mdb_hash_init(struct net_bridge *br);
 void br_mdb_hash_fini(struct net_bridge *br);
 void br_mdb_notify(struct net_device *dev, struct net_bridge_port *port,
-- 
2.25.4

