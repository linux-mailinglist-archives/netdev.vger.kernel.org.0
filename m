Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C652332726
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 06:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFCEIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 00:08:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfFCEIV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 00:08:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE56127B36;
        Mon,  3 Jun 2019 04:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559534900;
        bh=kayxtH0FbvyRTcEJuyBqi6+3N1UTQq88MSNSjy8b+AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s6H+xnM49GHci6LtsD1yV5NRnYl3reoHWujaGhQz3ktmLK3RWXgnaORTHp3JKusGL
         zClo2CEgls/g24wu0oU7K+Y5SygKuydXoRx+Nid6Ub5o4NzonNxqzgA7XAsaG0UPXO
         6set/9MfAOLzi0OAu9nf04wnZTGWvE6tKdOva0DM=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 3/7] ipv4: Plumb support for nexthop object in a fib_info
Date:   Sun,  2 Jun 2019 21:08:13 -0700
Message-Id: <20190603040817.4825-4-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190603040817.4825-1-dsahern@kernel.org>
References: <20190603040817.4825-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add 'struct nexthop' and nh_list list_head to fib_info. nh_list is the
fib_info side of the nexthop <-> fib_info relationship.

Add fi_list list_head to 'struct nexthop' to track fib_info entries
using a nexthop instance. Add __remove_nexthop_fib and add it to
__remove_nexthop to walk the new list_head and mark those fib entries
as dead when the nexthop is deleted.

Add a few nexthop helpers for use when a nexthop is added to fib_info:
- nexthop_cmp to determine if 2 nexthops are the same
- nexthop_path_fib_result to select a path for a multipath
  'struct nexthop'
- nexthop_fib_nhc to select a specific fib_nh_common within a
  multipath 'struct nexthop'

Update existing fib_info_nhc to use nexthop_fib_nhc if a fib_info uses
a 'struct nexthop', and mark fib_info_nh as only used for the non-nexthop
case.

Update the fib_info functions to check for fi->nh and take a different
path as needed:
- free_fib_info_rcu - put the nexthop object reference
- fib_release_info - remove the fib_info from the nexthop's fi_list
- nh_comp - use nexthop_cmp when either fib_info references a nexthop
  object
- fib_info_hashfn - use the nexthop id for the hashing vs the oif of
  each fib_nh in a fib_info
- fib_nlmsg_size - add space for the RTA_NH_ID attribute
- fib_create_info - verify nexthop reference can be taken, verify
  nexthop spec is valid for fib entry, and add fib_info to fi_list for
  a nexthop
- fib_select_multipath - use the new nexthop_path_fib_result to select a
  path when nexthop objects are used
- fib_table_lookup - if the 'struct nexthop' is a blackhole nexthop, treat
  it the same as a fib entry using 'blackhole'

The bulk of the changes are in fib_semantics.c and most of that is
moving the existing change_nexthops into an else branch.

Update the nexthop code to walk fi_list on a nexthop deleted to remove
fib entries referencing it.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip_fib.h     |   4 ++
 include/net/nexthop.h    |  48 ++++++++++++++++
 net/ipv4/fib_semantics.c | 142 +++++++++++++++++++++++++++++++++++------------
 net/ipv4/fib_trie.c      |   7 +++
 net/ipv4/nexthop.c       |  64 +++++++++++++++++++++
 5 files changed, 229 insertions(+), 36 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index 7da8ea784029..071d280de389 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -129,9 +129,12 @@ struct fib_nh {
  * This structure contains data shared by many of routes.
  */
 
+struct nexthop;
+
 struct fib_info {
 	struct hlist_node	fib_hash;
 	struct hlist_node	fib_lhash;
+	struct list_head	nh_list;
 	struct net		*fib_net;
 	int			fib_treeref;
 	refcount_t		fib_clntref;
@@ -151,6 +154,7 @@ struct fib_info {
 	int			fib_nhs;
 	bool			fib_nh_is_v6;
 	bool			nh_updated;
+	struct nexthop		*nh;
 	struct rcu_head		rcu;
 	struct fib_nh		fib_nh[0];
 };
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index e501d77b82c8..2912a2d7a515 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -77,6 +77,7 @@ struct nh_group {
 
 struct nexthop {
 	struct rb_node		rb_node;    /* entry on netns rbtree */
+	struct list_head	fi_list;    /* v4 entries using nh */
 	struct list_head	grp_list;   /* nh group entries using this nh */
 	struct net		*net;
 
@@ -110,6 +111,12 @@ static inline void nexthop_put(struct nexthop *nh)
 		call_rcu(&nh->rcu, nexthop_free_rcu);
 }
 
+static inline bool nexthop_cmp(const struct nexthop *nh1,
+			       const struct nexthop *nh2)
+{
+	return nh1 == nh2;
+}
+
 static inline bool nexthop_is_multipath(const struct nexthop *nh)
 {
 	if (nh->is_group) {
@@ -193,18 +200,59 @@ static inline bool nexthop_is_blackhole(const struct nexthop *nh)
 	return nhi->reject_nh;
 }
 
+static inline void nexthop_path_fib_result(struct fib_result *res, int hash)
+{
+	struct nh_info *nhi;
+	struct nexthop *nh;
+
+	nh = nexthop_select_path(res->fi->nh, hash);
+	nhi = rcu_dereference(nh->nh_info);
+	res->nhc = &nhi->fib_nhc;
+}
+
+/* called with rcu read lock or rtnl held */
+static inline
+struct fib_nh_common *nexthop_fib_nhc(struct nexthop *nh, int nhsel)
+{
+	struct nh_info *nhi;
+
+	BUILD_BUG_ON(offsetof(struct fib_nh, nh_common) != 0);
+	BUILD_BUG_ON(offsetof(struct fib6_nh, nh_common) != 0);
+
+	if (nexthop_is_multipath(nh)) {
+		nh = nexthop_mpath_select(nh, nhsel);
+		if (!nh)
+			return NULL;
+	}
+
+	nhi = rcu_dereference_rtnl(nh->nh_info);
+	return &nhi->fib_nhc;
+}
+
 static inline unsigned int fib_info_num_path(const struct fib_info *fi)
 {
+	if (unlikely(fi->nh))
+		return nexthop_num_path(fi->nh);
+
 	return fi->fib_nhs;
 }
 
+int fib_check_nexthop(struct nexthop *nh, u8 scope,
+		      struct netlink_ext_ack *extack);
+
 static inline struct fib_nh_common *fib_info_nhc(struct fib_info *fi, int nhsel)
 {
+	if (unlikely(fi->nh))
+		return nexthop_fib_nhc(fi->nh, nhsel);
+
 	return &fi->fib_nh[nhsel].nh_common;
 }
 
+/* only used when fib_nh is built into fib_info */
 static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
 {
+	WARN_ON(fi->nh);
+
 	return &fi->fib_nh[nhsel];
 }
 #endif
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 4a12c69f7fa1..01e587a5dcb1 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -236,9 +236,13 @@ static void free_fib_info_rcu(struct rcu_head *head)
 {
 	struct fib_info *fi = container_of(head, struct fib_info, rcu);
 
-	change_nexthops(fi) {
-		fib_nh_release(fi->fib_net, nexthop_nh);
-	} endfor_nexthops(fi);
+	if (fi->nh) {
+		nexthop_put(fi->nh);
+	} else {
+		change_nexthops(fi) {
+			fib_nh_release(fi->fib_net, nexthop_nh);
+		} endfor_nexthops(fi);
+	}
 
 	ip_fib_metrics_put(fi->fib_metrics);
 
@@ -264,11 +268,15 @@ void fib_release_info(struct fib_info *fi)
 		hlist_del(&fi->fib_hash);
 		if (fi->fib_prefsrc)
 			hlist_del(&fi->fib_lhash);
-		change_nexthops(fi) {
-			if (!nexthop_nh->fib_nh_dev)
-				continue;
-			hlist_del(&nexthop_nh->nh_hash);
-		} endfor_nexthops(fi)
+		if (fi->nh) {
+			list_del(&fi->nh_list);
+		} else {
+			change_nexthops(fi) {
+				if (!nexthop_nh->fib_nh_dev)
+					continue;
+				hlist_del(&nexthop_nh->nh_hash);
+			} endfor_nexthops(fi)
+		}
 		fi->fib_dead = 1;
 		fib_info_put(fi);
 	}
@@ -279,6 +287,12 @@ static inline int nh_comp(struct fib_info *fi, struct fib_info *ofi)
 {
 	const struct fib_nh *onh;
 
+	if (fi->nh || ofi->nh)
+		return nexthop_cmp(fi->nh, ofi->nh) ? 0 : -1;
+
+	if (ofi->fib_nhs == 0)
+		return 0;
+
 	for_nexthops(fi) {
 		onh = fib_info_nh(ofi, nhsel);
 
@@ -323,9 +337,14 @@ static inline unsigned int fib_info_hashfn(const struct fib_info *fi)
 	val ^= (fi->fib_protocol << 8) | fi->fib_scope;
 	val ^= (__force u32)fi->fib_prefsrc;
 	val ^= fi->fib_priority;
-	for_nexthops(fi) {
-		val ^= fib_devindex_hashfn(nh->fib_nh_oif);
-	} endfor_nexthops(fi)
+
+	if (fi->nh) {
+		val ^= fib_devindex_hashfn(fi->nh->id);
+	} else {
+		for_nexthops(fi) {
+			val ^= fib_devindex_hashfn(nh->fib_nh_oif);
+		} endfor_nexthops(fi)
+	}
 
 	return (val ^ (val >> 7) ^ (val >> 12)) & mask;
 }
@@ -352,7 +371,7 @@ static struct fib_info *fib_find_info(struct fib_info *nfi)
 		    memcmp(nfi->fib_metrics, fi->fib_metrics,
 			   sizeof(u32) * RTAX_MAX) == 0 &&
 		    !((nfi->fib_flags ^ fi->fib_flags) & ~RTNH_COMPARE_MASK) &&
-		    (nfi->fib_nhs == 0 || nh_comp(fi, nfi) == 0))
+		    nh_comp(fi, nfi) == 0)
 			return fi;
 	}
 
@@ -399,6 +418,9 @@ static inline size_t fib_nlmsg_size(struct fib_info *fi)
 	/* space for nested metrics */
 	payload += nla_total_size((RTAX_MAX * nla_total_size(4)));
 
+	if (fi->nh)
+		payload += nla_total_size(4); /* RTA_NH_ID */
+
 	if (nhs) {
 		size_t nh_encapsize = 0;
 		/* Also handles the special case nhs == 1 */
@@ -585,6 +607,7 @@ static int fib_count_nexthops(struct rtnexthop *rtnh, int remaining,
 	return nhs;
 }
 
+/* only called when fib_nh is integrated into fib_info */
 static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 		       int remaining, struct fib_config *cfg,
 		       struct netlink_ext_ack *extack)
@@ -683,6 +706,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
 	return ret;
 }
 
+/* only called when fib_nh is integrated into fib_info */
 static void fib_rebalance(struct fib_info *fi)
 {
 	int total;
@@ -1262,6 +1286,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 {
 	int err;
 	struct fib_info *fi = NULL;
+	struct nexthop *nh = NULL;
 	struct fib_info *ofi;
 	int nhs = 1;
 	struct net *net = cfg->fc_nlinfo.nl_net;
@@ -1333,14 +1358,25 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 	fi->fib_tb_id = cfg->fc_table;
 
 	fi->fib_nhs = nhs;
-	change_nexthops(fi) {
-		nexthop_nh->nh_parent = fi;
-	} endfor_nexthops(fi)
+	if (nh) {
+		if (!nexthop_get(nh)) {
+			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			err = -EINVAL;
+		} else {
+			err = 0;
+			fi->nh = nh;
+		}
+	} else {
+		change_nexthops(fi) {
+			nexthop_nh->nh_parent = fi;
+		} endfor_nexthops(fi)
 
-	if (cfg->fc_mp)
-		err = fib_get_nhs(fi, cfg->fc_mp, cfg->fc_mp_len, cfg, extack);
-	else
-		err = fib_nh_init(net, fi->fib_nh, cfg, 1, extack);
+		if (cfg->fc_mp)
+			err = fib_get_nhs(fi, cfg->fc_mp, cfg->fc_mp_len, cfg,
+					  extack);
+		else
+			err = fib_nh_init(net, fi->fib_nh, cfg, 1, extack);
+	}
 
 	if (err != 0)
 		goto failure;
@@ -1371,7 +1407,11 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		goto err_inval;
 	}
 
-	if (cfg->fc_scope == RT_SCOPE_HOST) {
+	if (fi->nh) {
+		err = fib_check_nexthop(fi->nh, cfg->fc_scope, extack);
+		if (err)
+			goto failure;
+	} else if (cfg->fc_scope == RT_SCOPE_HOST) {
 		struct fib_nh *nh = fi->fib_nh;
 
 		/* Local address is added. */
@@ -1411,14 +1451,16 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		goto err_inval;
 	}
 
-	change_nexthops(fi) {
-		fib_info_update_nhc_saddr(net, &nexthop_nh->nh_common,
-					  fi->fib_scope);
-		if (nexthop_nh->fib_nh_gw_family == AF_INET6)
-			fi->fib_nh_is_v6 = true;
-	} endfor_nexthops(fi)
+	if (!fi->nh) {
+		change_nexthops(fi) {
+			fib_info_update_nhc_saddr(net, &nexthop_nh->nh_common,
+						  fi->fib_scope);
+			if (nexthop_nh->fib_nh_gw_family == AF_INET6)
+				fi->fib_nh_is_v6 = true;
+		} endfor_nexthops(fi)
 
-	fib_rebalance(fi);
+		fib_rebalance(fi);
+	}
 
 link_it:
 	ofi = fib_find_info(fi);
@@ -1440,16 +1482,20 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
 		head = &fib_info_laddrhash[fib_laddr_hashfn(fi->fib_prefsrc)];
 		hlist_add_head(&fi->fib_lhash, head);
 	}
-	change_nexthops(fi) {
-		struct hlist_head *head;
-		unsigned int hash;
+	if (fi->nh) {
+		list_add(&fi->nh_list, &nh->fi_list);
+	} else {
+		change_nexthops(fi) {
+			struct hlist_head *head;
+			unsigned int hash;
 
-		if (!nexthop_nh->fib_nh_dev)
-			continue;
-		hash = fib_devindex_hashfn(nexthop_nh->fib_nh_dev->ifindex);
-		head = &fib_info_devhash[hash];
-		hlist_add_head(&nexthop_nh->nh_hash, head);
-	} endfor_nexthops(fi)
+			if (!nexthop_nh->fib_nh_dev)
+				continue;
+			hash = fib_devindex_hashfn(nexthop_nh->fib_nh_dev->ifindex);
+			head = &fib_info_devhash[hash];
+			hlist_add_head(&nexthop_nh->nh_hash, head);
+		} endfor_nexthops(fi)
+	}
 	spin_unlock_bh(&fib_info_lock);
 	return fi;
 
@@ -1576,6 +1622,12 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 	if (!mp)
 		goto nla_put_failure;
 
+	if (unlikely(fi->nh)) {
+		if (nexthop_mpath_fill_node(skb, fi->nh) < 0)
+			goto nla_put_failure;
+		goto mp_end;
+	}
+
 	for_nexthops(fi) {
 		if (fib_add_nexthop(skb, &nh->nh_common, nh->fib_nh_weight) < 0)
 			goto nla_put_failure;
@@ -1586,6 +1638,7 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 #endif
 	} endfor_nexthops(fi);
 
+mp_end:
 	nla_nest_end(skb, mp);
 
 	return 0;
@@ -1640,6 +1693,14 @@ int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
 	if (fi->fib_prefsrc &&
 	    nla_put_in_addr(skb, RTA_PREFSRC, fi->fib_prefsrc))
 		goto nla_put_failure;
+
+	if (fi->nh) {
+		if (nla_put_u32(skb, RTA_NH_ID, fi->nh->id))
+			goto nla_put_failure;
+		if (nexthop_is_blackhole(fi->nh))
+			rtm->rtm_type = RTN_BLACKHOLE;
+	}
+
 	if (nhs == 1) {
 		const struct fib_nh_common *nhc = fib_info_nhc(fi, 0);
 		unsigned char flags = 0;
@@ -1784,6 +1845,8 @@ void fib_sync_mtu(struct net_device *dev, u32 orig_mtu)
  * NETDEV_DOWN        0     LINKDOWN|DEAD   Link down, not for scope host
  * NETDEV_DOWN        1     LINKDOWN|DEAD   Last address removed
  * NETDEV_UNREGISTER  1     LINKDOWN|DEAD   Device removed
+ *
+ * only used when fib_nh is built into fib_info
  */
 int fib_sync_down_dev(struct net_device *dev, unsigned long event, bool force)
 {
@@ -1931,6 +1994,8 @@ static void fib_select_default(const struct flowi4 *flp, struct fib_result *res)
 /*
  * Dead device goes up. We wake up dead nexthops.
  * It takes sense only on multipath routes.
+ *
+ * only used when fib_nh is built into fib_info
  */
 int fib_sync_up(struct net_device *dev, unsigned char nh_flags)
 {
@@ -2025,6 +2090,11 @@ void fib_select_multipath(struct fib_result *res, int hash)
 	struct net *net = fi->fib_net;
 	bool first = false;
 
+	if (unlikely(res->fi->nh)) {
+		nexthop_path_fib_result(res, hash);
+		return;
+	}
+
 	change_nexthops(fi) {
 		if (net->ipv4.sysctl_fib_multipath_use_neigh) {
 			if (!fib_good_nh(nexthop_nh))
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index d704d1606b8f..716f2d66cb3f 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -1461,6 +1461,7 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 		fib_alias_accessed(fa);
 		err = fib_props[fa->fa_type].error;
 		if (unlikely(err < 0)) {
+out_reject:
 #ifdef CONFIG_IP_FIB_TRIE_STATS
 			this_cpu_inc(stats->semantic_match_passed);
 #endif
@@ -1469,6 +1470,12 @@ int fib_table_lookup(struct fib_table *tb, const struct flowi4 *flp,
 		}
 		if (fi->fib_flags & RTNH_F_DEAD)
 			continue;
+
+		if (unlikely(fi->nh && nexthop_is_blackhole(fi->nh))) {
+			err = fib_props[RTN_BLACKHOLE].error;
+			goto out_reject;
+		}
+
 		for (nhsel = 0; nhsel < fib_info_num_path(fi); nhsel++) {
 			struct fib_nh_common *nhc = fib_info_nhc(fi, nhsel);
 
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index aec4ecb145a0..63cbb04f697f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -105,6 +105,7 @@ static struct nexthop *nexthop_alloc(void)
 
 	nh = kzalloc(sizeof(struct nexthop), GFP_KERNEL);
 	if (nh) {
+		INIT_LIST_HEAD(&nh->fi_list);
 		INIT_LIST_HEAD(&nh->grp_list);
 	}
 	return nh;
@@ -515,6 +516,54 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 }
 EXPORT_SYMBOL_GPL(nexthop_select_path);
 
+static int nexthop_check_scope(struct nexthop *nh, u8 scope,
+			       struct netlink_ext_ack *extack)
+{
+	struct nh_info *nhi;
+
+	nhi = rtnl_dereference(nh->nh_info);
+	if (scope == RT_SCOPE_HOST && nhi->fib_nhc.nhc_gw_family) {
+		NL_SET_ERR_MSG(extack,
+			       "Route with host scope can not have a gateway");
+		return -EINVAL;
+	}
+
+	if (nhi->fib_nhc.nhc_flags & RTNH_F_ONLINK && scope >= RT_SCOPE_LINK) {
+		NL_SET_ERR_MSG(extack, "Scope mismatch with nexthop");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* Invoked by fib add code to verify nexthop by id is ok with
+ * config for prefix; parts of fib_check_nh not done when nexthop
+ * object is used.
+ */
+int fib_check_nexthop(struct nexthop *nh, u8 scope,
+		      struct netlink_ext_ack *extack)
+{
+	int err = 0;
+
+	if (nh->is_group) {
+		struct nh_group *nhg;
+
+		if (scope == RT_SCOPE_HOST) {
+			NL_SET_ERR_MSG(extack, "Route with host scope can not have multiple nexthops");
+			err = -EINVAL;
+			goto out;
+		}
+
+		nhg = rtnl_dereference(nh->nh_grp);
+		/* all nexthops in a group have the same scope */
+		err = nexthop_check_scope(nhg->nh_entries[0].nh, scope, extack);
+	} else {
+		err = nexthop_check_scope(nh, scope, extack);
+	}
+out:
+	return err;
+}
+
 static void nh_group_rebalance(struct nh_group *nhg)
 {
 	int total = 0;
@@ -607,9 +656,24 @@ static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 	}
 }
 
+static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
+{
+	bool do_flush = false;
+	struct fib_info *fi;
+
+	list_for_each_entry(fi, &nh->fi_list, nh_list) {
+		fi->fib_flags |= RTNH_F_DEAD;
+		do_flush = true;
+	}
+	if (do_flush)
+		fib_flush(net);
+}
+
 static void __remove_nexthop(struct net *net, struct nexthop *nh,
 			     struct nl_info *nlinfo)
 {
+	__remove_nexthop_fib(net, nh);
+
 	if (nh->is_group) {
 		remove_nexthop_group(nh, nlinfo);
 	} else {
-- 
2.11.0

