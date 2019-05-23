Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 411CB274CD
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 05:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbfEWD2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 23:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbfEWD2G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 May 2019 23:28:06 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53F61217D9;
        Thu, 23 May 2019 03:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558582084;
        bh=CyIgMwbO/z8B5GAlsOFokRiDNl0dKHFtvlzVDXJ1oqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FSPi0cBzFaIZtHgARJowSm3lNpAkO+In9USM8quDeJncPl1lFjrRjkVXA9wsB0FJG
         hB2qDp6F7p2UxjksyAYT/LdyqcVvI2k3vCCNr4Vis2PoiVugLU9Si59kY7XLiMV3Ng
         yyQkz+830YCg5BrwqiZ9oNMr6j/BCvE56MGlPHiE=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     eric.dumazet@gmail.com, idosch@mellanox.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH net-next 5/7] ipv6: Make fib6_nh optional at the end of fib6_info
Date:   Wed, 22 May 2019 20:27:59 -0700
Message-Id: <20190523032801.11122-6-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190523032801.11122-1-dsahern@kernel.org>
References: <20190523032801.11122-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Move fib6_nh to the end of fib6_info and make it an array of
size 0. Pass a flag to fib6_info_alloc indicating if the
allocation needs to add space for a fib6_nh.

The current code path always has a fib6_nh allocated with a
fib6_info; with nexthop objects they will be separate.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  31 ++---
 include/net/ip6_fib.h                              |   6 +-
 include/net/ip6_route.h                            |   4 +-
 net/ipv6/addrconf.c                                |   6 +-
 net/ipv6/ip6_fib.c                                 |  18 +--
 net/ipv6/ndisc.c                                   |   8 +-
 net/ipv6/route.c                                   | 134 ++++++++++-----------
 7 files changed, 106 insertions(+), 101 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1cda8a248b12..0ec52be7cc33 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2886,7 +2886,7 @@ mlxsw_sp_nexthop6_group_cmp(const struct mlxsw_sp_nexthop_group *nh_grp,
 		return false;
 
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
-		struct fib6_nh *fib6_nh = &mlxsw_sp_rt6->rt->fib6_nh;
+		struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
 		struct in6_addr *gw;
 		int ifindex, weight;
 
@@ -2958,7 +2958,7 @@ mlxsw_sp_nexthop6_group_hash(struct mlxsw_sp_fib6_entry *fib6_entry, u32 seed)
 	struct net_device *dev;
 
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
-		dev = mlxsw_sp_rt6->rt->fib6_nh.fib_nh_dev;
+		dev = mlxsw_sp_rt6->rt->fib6_nh->fib_nh_dev;
 		val ^= dev->ifindex;
 	}
 
@@ -3960,9 +3960,9 @@ mlxsw_sp_rt6_nexthop(struct mlxsw_sp_nexthop_group *nh_grp,
 		struct mlxsw_sp_nexthop *nh = &nh_grp->nexthops[i];
 		struct fib6_info *rt = mlxsw_sp_rt6->rt;
 
-		if (nh->rif && nh->rif->dev == rt->fib6_nh.fib_nh_dev &&
+		if (nh->rif && nh->rif->dev == rt->fib6_nh->fib_nh_dev &&
 		    ipv6_addr_equal((const struct in6_addr *) &nh->gw_addr,
-				    &rt->fib6_nh.fib_nh_gw6))
+				    &rt->fib6_nh->fib_nh_gw6))
 			return nh;
 		continue;
 	}
@@ -4022,13 +4022,13 @@ mlxsw_sp_fib6_entry_offload_set(struct mlxsw_sp_fib_entry *fib_entry)
 	if (fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_LOCAL ||
 	    fib_entry->type == MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE) {
 		list_first_entry(&fib6_entry->rt6_list, struct mlxsw_sp_rt6,
-				 list)->rt->fib6_nh.fib_nh_flags |= RTNH_F_OFFLOAD;
+				 list)->rt->fib6_nh->fib_nh_flags |= RTNH_F_OFFLOAD;
 		return;
 	}
 
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
 		struct mlxsw_sp_nexthop_group *nh_grp = fib_entry->nh_group;
-		struct fib6_nh *fib6_nh = &mlxsw_sp_rt6->rt->fib6_nh;
+		struct fib6_nh *fib6_nh = mlxsw_sp_rt6->rt->fib6_nh;
 		struct mlxsw_sp_nexthop *nh;
 
 		nh = mlxsw_sp_rt6_nexthop(nh_grp, mlxsw_sp_rt6);
@@ -4050,7 +4050,7 @@ mlxsw_sp_fib6_entry_offload_unset(struct mlxsw_sp_fib_entry *fib_entry)
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list) {
 		struct fib6_info *rt = mlxsw_sp_rt6->rt;
 
-		rt->fib6_nh.fib_nh_flags &= ~RTNH_F_OFFLOAD;
+		rt->fib6_nh->fib_nh_flags &= ~RTNH_F_OFFLOAD;
 	}
 }
 
@@ -4928,7 +4928,8 @@ static void mlxsw_sp_rt6_destroy(struct mlxsw_sp_rt6 *mlxsw_sp_rt6)
 static bool mlxsw_sp_fib6_rt_can_mp(const struct fib6_info *rt)
 {
 	/* RTF_CACHE routes are ignored */
-	return !(rt->fib6_flags & RTF_ADDRCONF) && rt->fib6_nh.fib_nh_gw_family;
+	return !(rt->fib6_flags & RTF_ADDRCONF) &&
+		rt->fib6_nh->fib_nh_gw_family;
 }
 
 static struct fib6_info *
@@ -4987,8 +4988,8 @@ static bool mlxsw_sp_nexthop6_ipip_type(const struct mlxsw_sp *mlxsw_sp,
 					const struct fib6_info *rt,
 					enum mlxsw_sp_ipip_type *ret)
 {
-	return rt->fib6_nh.fib_nh_dev &&
-	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, rt->fib6_nh.fib_nh_dev, ret);
+	return rt->fib6_nh->fib_nh_dev &&
+	       mlxsw_sp_netdev_ipip_type(mlxsw_sp, rt->fib6_nh->fib_nh_dev, ret);
 }
 
 static int mlxsw_sp_nexthop6_type_init(struct mlxsw_sp *mlxsw_sp,
@@ -4998,7 +4999,7 @@ static int mlxsw_sp_nexthop6_type_init(struct mlxsw_sp *mlxsw_sp,
 {
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
-	struct net_device *dev = rt->fib6_nh.fib_nh_dev;
+	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
 	struct mlxsw_sp_rif *rif;
 	int err;
 
@@ -5041,11 +5042,11 @@ static int mlxsw_sp_nexthop6_init(struct mlxsw_sp *mlxsw_sp,
 				  struct mlxsw_sp_nexthop *nh,
 				  const struct fib6_info *rt)
 {
-	struct net_device *dev = rt->fib6_nh.fib_nh_dev;
+	struct net_device *dev = rt->fib6_nh->fib_nh_dev;
 
 	nh->nh_grp = nh_grp;
-	nh->nh_weight = rt->fib6_nh.fib_nh_weight;
-	memcpy(&nh->gw_addr, &rt->fib6_nh.fib_nh_gw6, sizeof(nh->gw_addr));
+	nh->nh_weight = rt->fib6_nh->fib_nh_weight;
+	memcpy(&nh->gw_addr, &rt->fib6_nh->fib_nh_gw6, sizeof(nh->gw_addr));
 	mlxsw_sp_nexthop_counter_alloc(mlxsw_sp, nh);
 
 	list_add_tail(&nh->router_list_node, &mlxsw_sp->router->nexthop_list);
@@ -5068,7 +5069,7 @@ static void mlxsw_sp_nexthop6_fini(struct mlxsw_sp *mlxsw_sp,
 static bool mlxsw_sp_rt6_is_gateway(const struct mlxsw_sp *mlxsw_sp,
 				    const struct fib6_info *rt)
 {
-	return rt->fib6_nh.fib_nh_gw_family ||
+	return rt->fib6_nh->fib_nh_gw_family ||
 	       mlxsw_sp_nexthop6_ipip_type(mlxsw_sp, rt, NULL);
 }
 
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 6b4852cf2fc2..ebe5d65f97e0 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -169,8 +169,8 @@ struct fib6_info {
 					fib6_destroying:1,
 					unused:3;
 
-	struct fib6_nh			fib6_nh;
 	struct rcu_head			rcu;
+	struct fib6_nh			fib6_nh[0];
 };
 
 struct rt6_info {
@@ -280,7 +280,7 @@ static inline void ip6_rt_put(struct rt6_info *rt)
 	dst_release(&rt->dst);
 }
 
-struct fib6_info *fib6_info_alloc(gfp_t gfp_flags);
+struct fib6_info *fib6_info_alloc(gfp_t gfp_flags, bool with_fib6_nh);
 void fib6_info_destroy_rcu(struct rcu_head *head);
 
 static inline void fib6_info_hold(struct fib6_info *f6i)
@@ -443,7 +443,7 @@ void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
 
 static inline struct net_device *fib6_info_nh_dev(const struct fib6_info *f6i)
 {
-	return f6i->fib6_nh.fib_nh_dev;
+	return f6i->fib6_nh->fib_nh_dev;
 }
 
 int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 4790beaa86e0..a6ce6ea856b9 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -70,7 +70,7 @@ static inline bool rt6_qualify_for_ecmp(const struct fib6_info *f6i)
 {
 	/* the RTF_ADDRCONF flag filters out RA's */
 	return !(f6i->fib6_flags & RTF_ADDRCONF) &&
-		f6i->fib6_nh.fib_nh_gw_family;
+		f6i->fib6_nh->fib_nh_gw_family;
 }
 
 void ip6_route_input(struct sk_buff *skb);
@@ -275,7 +275,7 @@ static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt,
 
 static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *b)
 {
-	struct fib6_nh *nha = &a->fib6_nh, *nhb = &b->fib6_nh;
+	struct fib6_nh *nha = a->fib6_nh, *nhb = b->fib6_nh;
 
 	return nha->fib_nh_dev == nhb->fib_nh_dev &&
 	       ipv6_addr_equal(&nha->fib_nh_gw6, &nhb->fib_nh_gw6) &&
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4bc35dd02b56..683613e7355b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2421,9 +2421,9 @@ static struct fib6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 		goto out;
 
 	for_each_fib6_node_rt_rcu(fn) {
-		if (rt->fib6_nh.fib_nh_dev->ifindex != dev->ifindex)
+		if (rt->fib6_nh->fib_nh_dev->ifindex != dev->ifindex)
 			continue;
-		if (no_gw && rt->fib6_nh.fib_nh_gw_family)
+		if (no_gw && rt->fib6_nh->fib_nh_gw_family)
 			continue;
 		if ((rt->fib6_flags & flags) != flags)
 			continue;
@@ -6341,7 +6341,7 @@ void addrconf_disable_policy_idev(struct inet6_dev *idev, int val)
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		spin_lock(&ifa->lock);
 		if (ifa->rt) {
-			struct fib6_nh *nh = &ifa->rt->fib6_nh;
+			struct fib6_nh *nh = ifa->rt->fib6_nh;
 			int cpu;
 
 			rcu_read_lock();
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 87ac82f850d2..cdfb8500ccae 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -147,11 +147,15 @@ static __be32 addr_bit_set(const void *token, int fn_bit)
 	       addr[fn_bit >> 5];
 }
 
-struct fib6_info *fib6_info_alloc(gfp_t gfp_flags)
+struct fib6_info *fib6_info_alloc(gfp_t gfp_flags, bool with_fib6_nh)
 {
 	struct fib6_info *f6i;
+	size_t sz = sizeof(*f6i);
 
-	f6i = kzalloc(sizeof(*f6i), gfp_flags);
+	if (with_fib6_nh)
+		sz += sizeof(struct fib6_nh);
+
+	f6i = kzalloc(sz, gfp_flags);
 	if (!f6i)
 		return NULL;
 
@@ -167,7 +171,7 @@ void fib6_info_destroy_rcu(struct rcu_head *head)
 
 	WARN_ON(f6i->fib6_node);
 
-	fib6_nh_release(&f6i->fib6_nh);
+	fib6_nh_release(f6i->fib6_nh);
 	ip_fib_metrics_put(f6i->fib6_metrics);
 	kfree(f6i);
 }
@@ -912,7 +916,7 @@ static void fib6_drop_pcpu_from(struct fib6_info *f6i,
 	f6i->fib6_destroying = 1;
 	mb(); /* paired with the cmpxchg() in rt6_make_pcpu_route() */
 
-	fib6_nh = &f6i->fib6_nh;
+	fib6_nh = f6i->fib6_nh;
 	__fib6_drop_pcpu_from(fib6_nh, f6i, table);
 }
 
@@ -2301,14 +2305,14 @@ static int ipv6_route_seq_show(struct seq_file *seq, void *v)
 #else
 	seq_puts(seq, "00000000000000000000000000000000 00 ");
 #endif
-	if (rt->fib6_nh.fib_nh_gw_family) {
+	if (rt->fib6_nh->fib_nh_gw_family) {
 		flags |= RTF_GATEWAY;
-		seq_printf(seq, "%pi6", &rt->fib6_nh.fib_nh_gw6);
+		seq_printf(seq, "%pi6", &rt->fib6_nh->fib_nh_gw6);
 	} else {
 		seq_puts(seq, "00000000000000000000000000000000");
 	}
 
-	dev = rt->fib6_nh.fib_nh_dev;
+	dev = rt->fib6_nh->fib_nh_dev;
 	seq_printf(seq, " %08x %08x %08x %08x %8s\n",
 		   rt->fib6_metric, refcount_read(&rt->fib6_ref), 0,
 		   flags, dev ? dev->name : "");
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 4c8e2ea8bf19..f874dde1ee85 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1293,8 +1293,8 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	rt = rt6_get_dflt_router(net, &ipv6_hdr(skb)->saddr, skb->dev);
 
 	if (rt) {
-		neigh = ip6_neigh_lookup(&rt->fib6_nh.fib_nh_gw6,
-					 rt->fib6_nh.fib_nh_dev, NULL,
+		neigh = ip6_neigh_lookup(&rt->fib6_nh->fib_nh_gw6,
+					 rt->fib6_nh->fib_nh_dev, NULL,
 					  &ipv6_hdr(skb)->saddr);
 		if (!neigh) {
 			ND_PRINTK(0, err,
@@ -1323,8 +1323,8 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 			return;
 		}
 
-		neigh = ip6_neigh_lookup(&rt->fib6_nh.fib_nh_gw6,
-					 rt->fib6_nh.fib_nh_dev, NULL,
+		neigh = ip6_neigh_lookup(&rt->fib6_nh->fib_nh_gw6,
+					 rt->fib6_nh->fib_nh_dev, NULL,
 					  &ipv6_hdr(skb)->saddr);
 		if (!neigh) {
 			ND_PRINTK(0, err,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b01118a3c42e..f248ce807116 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -441,12 +441,12 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 	if (!fl6->mp_hash)
 		fl6->mp_hash = rt6_multipath_hash(net, fl6, skb, NULL);
 
-	if (fl6->mp_hash <= atomic_read(&match->fib6_nh.fib_nh_upper_bound))
+	if (fl6->mp_hash <= atomic_read(&match->fib6_nh->fib_nh_upper_bound))
 		goto out;
 
 	list_for_each_entry_safe(sibling, next_sibling, &match->fib6_siblings,
 				 fib6_siblings) {
-		const struct fib6_nh *nh = &sibling->fib6_nh;
+		const struct fib6_nh *nh = sibling->fib6_nh;
 		int nh_upper_bound;
 
 		nh_upper_bound = atomic_read(&nh->fib_nh_upper_bound);
@@ -460,7 +460,7 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 
 out:
 	res->f6i = match;
-	res->nh = &match->fib6_nh;
+	res->nh = match->fib6_nh;
 }
 
 /*
@@ -496,13 +496,13 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 	struct fib6_nh *nh;
 
 	if (!oif && ipv6_addr_any(saddr)) {
-		nh = &f6i->fib6_nh;
+		nh = f6i->fib6_nh;
 		if (!(nh->fib_nh_flags & RTNH_F_DEAD))
 			goto out;
 	}
 
 	for (spf6i = f6i; spf6i; spf6i = rcu_dereference(spf6i->fib6_next)) {
-		nh = &spf6i->fib6_nh;
+		nh = spf6i->fib6_nh;
 		if (__rt6_device_match(net, nh, saddr, oif, flags)) {
 			res->f6i = spf6i;
 			goto out;
@@ -511,14 +511,14 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 
 	if (oif && flags & RT6_LOOKUP_F_IFACE) {
 		res->f6i = net->ipv6.fib6_null_entry;
-		nh = &res->f6i->fib6_nh;
+		nh = res->f6i->fib6_nh;
 		goto out;
 	}
 
-	nh = &f6i->fib6_nh;
+	nh = f6i->fib6_nh;
 	if (nh->fib_nh_flags & RTNH_F_DEAD) {
 		res->f6i = net->ipv6.fib6_null_entry;
-		nh = &res->f6i->fib6_nh;
+		nh = res->f6i->fib6_nh;
 	}
 out:
 	res->nh = nh;
@@ -714,7 +714,7 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 		if (fib6_check_expired(f6i))
 			continue;
 
-		nh = &f6i->fib6_nh;
+		nh = f6i->fib6_nh;
 		if (find_match(nh, f6i->fib6_flags, oif, strict, mpri, do_rr)) {
 			res->f6i = f6i;
 			res->nh = nh;
@@ -796,7 +796,7 @@ static void rt6_select(struct net *net, struct fib6_node *fn, int oif,
 out:
 	if (!res->f6i) {
 		res->f6i = net->ipv6.fib6_null_entry;
-		res->nh = &res->f6i->fib6_nh;
+		res->nh = res->f6i->fib6_nh;
 		res->fib6_flags = res->f6i->fib6_flags;
 		res->fib6_type = res->f6i->fib6_type;
 	}
@@ -1626,7 +1626,7 @@ static void fib6_nh_flush_exceptions(struct fib6_nh *nh, struct fib6_info *from)
 
 void rt6_flush_exceptions(struct fib6_info *f6i)
 {
-	fib6_nh_flush_exceptions(&f6i->fib6_nh, f6i);
+	fib6_nh_flush_exceptions(f6i->fib6_nh, f6i);
 }
 
 /* Find cached rt in the hash table inside passed in rt
@@ -1721,7 +1721,7 @@ static int rt6_remove_exception_rt(struct rt6_info *rt)
 	if (!from || !(rt->rt6i_flags & RTF_CACHE))
 		return -EINVAL;
 
-	return fib6_nh_remove_exception(&from->fib6_nh,
+	return fib6_nh_remove_exception(from->fib6_nh,
 					from->fib6_src.plen, rt);
 }
 
@@ -1761,7 +1761,7 @@ static void rt6_update_exception_stamp_rt(struct rt6_info *rt)
 	if (!from || !(rt->rt6i_flags & RTF_CACHE))
 		goto unlock;
 
-	fib6_nh_update_exception(&from->fib6_nh, from->fib6_src.plen, rt);
+	fib6_nh_update_exception(from->fib6_nh, from->fib6_src.plen, rt);
 unlock:
 	rcu_read_unlock();
 }
@@ -1927,7 +1927,7 @@ void rt6_age_exceptions(struct fib6_info *f6i,
 			struct fib6_gc_args *gc_args,
 			unsigned long now)
 {
-	fib6_nh_age_exceptions(&f6i->fib6_nh, gc_args, now);
+	fib6_nh_age_exceptions(f6i->fib6_nh, gc_args, now);
 }
 
 /* must be called with rcu lock held */
@@ -2456,7 +2456,7 @@ static void __ip6_rt_update_pmtu(struct dst_entry *dst, const struct sock *sk,
 			rcu_read_unlock();
 			return;
 		}
-		res.nh = &res.f6i->fib6_nh;
+		res.nh = res.f6i->fib6_nh;
 		res.fib6_flags = res.f6i->fib6_flags;
 		res.fib6_type = res.f6i->fib6_type;
 
@@ -2599,7 +2599,7 @@ static struct rt6_info *__ip6_route_redirect(struct net *net,
 restart:
 	for_each_fib6_node_rt_rcu(fn) {
 		res.f6i = rt;
-		res.nh = &rt->fib6_nh;
+		res.nh = rt->fib6_nh;
 
 		if (fib6_check_expired(rt))
 			continue;
@@ -2623,7 +2623,7 @@ static struct rt6_info *__ip6_route_redirect(struct net *net,
 	}
 
 	res.f6i = rt;
-	res.nh = &rt->fib6_nh;
+	res.nh = rt->fib6_nh;
 out:
 	if (ret) {
 		ip6_hold_safe(net, &ret);
@@ -3264,7 +3264,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		goto out;
 
 	err = -ENOMEM;
-	rt = fib6_info_alloc(gfp_flags);
+	rt = fib6_info_alloc(gfp_flags, true);
 	if (!rt)
 		goto out;
 
@@ -3304,7 +3304,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	ipv6_addr_prefix(&rt->fib6_src.addr, &cfg->fc_src, cfg->fc_src_len);
 	rt->fib6_src.plen = cfg->fc_src_len;
 #endif
-	err = fib6_nh_init(net, &rt->fib6_nh, cfg, gfp_flags, extack);
+	err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
 	if (err)
 		goto out;
 
@@ -3312,7 +3312,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	 * they would result in kernel looping; promote them to reject routes
 	 */
 	addr_type = ipv6_addr_type(&cfg->fc_dst);
-	if (fib6_is_reject(cfg->fc_flags, rt->fib6_nh.fib_nh_dev, addr_type))
+	if (fib6_is_reject(cfg->fc_flags, rt->fib6_nh->fib_nh_dev, addr_type))
 		rt->fib6_flags = RTF_REJECT | RTF_NONEXTHOP;
 
 	if (!ipv6_addr_any(&cfg->fc_prefsrc)) {
@@ -3472,7 +3472,7 @@ static int ip6_route_del(struct fib6_config *cfg,
 		for_each_fib6_node_rt_rcu(fn) {
 			struct fib6_nh *nh;
 
-			nh = &rt->fib6_nh;
+			nh = rt->fib6_nh;
 			if (cfg->fc_flags & RTF_CACHE) {
 				struct fib6_result res = {
 					.f6i = rt,
@@ -3614,7 +3614,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 	if (!res.f6i)
 		goto out;
 
-	res.nh = &res.f6i->fib6_nh;
+	res.nh = res.f6i->fib6_nh;
 	res.fib6_flags = res.f6i->fib6_flags;
 	res.fib6_type = res.f6i->fib6_type;
 	nrt = ip6_rt_cache_alloc(&res, &msg->dest, NULL);
@@ -3666,12 +3666,12 @@ static struct fib6_info *rt6_get_route_info(struct net *net,
 		goto out;
 
 	for_each_fib6_node_rt_rcu(fn) {
-		if (rt->fib6_nh.fib_nh_dev->ifindex != ifindex)
+		if (rt->fib6_nh->fib_nh_dev->ifindex != ifindex)
 			continue;
 		if (!(rt->fib6_flags & RTF_ROUTEINFO) ||
-		    !rt->fib6_nh.fib_nh_gw_family)
+		    !rt->fib6_nh->fib_nh_gw_family)
 			continue;
-		if (!ipv6_addr_equal(&rt->fib6_nh.fib_nh_gw6, gwaddr))
+		if (!ipv6_addr_equal(&rt->fib6_nh->fib_nh_gw6, gwaddr))
 			continue;
 		if (!fib6_info_hold_safe(rt))
 			continue;
@@ -3729,7 +3729,7 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 
 	rcu_read_lock();
 	for_each_fib6_node_rt_rcu(&table->tb6_root) {
-		struct fib6_nh *nh = &rt->fib6_nh;
+		struct fib6_nh *nh = rt->fib6_nh;
 
 		if (dev == nh->fib_nh_dev &&
 		    ((rt->fib6_flags & (RTF_ADDRCONF | RTF_DEFAULT)) == (RTF_ADDRCONF | RTF_DEFAULT)) &&
@@ -3981,7 +3981,7 @@ static int fib6_remove_prefsrc(struct fib6_info *rt, void *arg)
 	struct net *net = ((struct arg_dev_net_ip *)arg)->net;
 	struct in6_addr *addr = ((struct arg_dev_net_ip *)arg)->addr;
 
-	if (((void *)rt->fib6_nh.fib_nh_dev == dev || !dev) &&
+	if (((void *)rt->fib6_nh->fib_nh_dev == dev || !dev) &&
 	    rt != net->ipv6.fib6_null_entry &&
 	    ipv6_addr_equal(addr, &rt->fib6_prefsrc.addr)) {
 		spin_lock_bh(&rt6_exception_lock);
@@ -4009,7 +4009,7 @@ void rt6_remove_prefsrc(struct inet6_ifaddr *ifp)
 static int fib6_clean_tohost(struct fib6_info *rt, void *arg)
 {
 	struct in6_addr *gateway = (struct in6_addr *)arg;
-	struct fib6_nh *nh = &rt->fib6_nh;
+	struct fib6_nh *nh = rt->fib6_nh;
 
 	if (((rt->fib6_flags & RTF_RA_ROUTER) == RTF_RA_ROUTER) &&
 	    nh->fib_nh_gw_family && ipv6_addr_equal(gateway, &nh->fib_nh_gw6))
@@ -4059,9 +4059,9 @@ static struct fib6_info *rt6_multipath_first_sibling(const struct fib6_info *rt)
 
 static bool rt6_is_dead(const struct fib6_info *rt)
 {
-	if (rt->fib6_nh.fib_nh_flags & RTNH_F_DEAD ||
-	    (rt->fib6_nh.fib_nh_flags & RTNH_F_LINKDOWN &&
-	     ip6_ignore_linkdown(rt->fib6_nh.fib_nh_dev)))
+	if (rt->fib6_nh->fib_nh_flags & RTNH_F_DEAD ||
+	    (rt->fib6_nh->fib_nh_flags & RTNH_F_LINKDOWN &&
+	     ip6_ignore_linkdown(rt->fib6_nh->fib_nh_dev)))
 		return true;
 
 	return false;
@@ -4073,11 +4073,11 @@ static int rt6_multipath_total_weight(const struct fib6_info *rt)
 	int total = 0;
 
 	if (!rt6_is_dead(rt))
-		total += rt->fib6_nh.fib_nh_weight;
+		total += rt->fib6_nh->fib_nh_weight;
 
 	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
 		if (!rt6_is_dead(iter))
-			total += iter->fib6_nh.fib_nh_weight;
+			total += iter->fib6_nh->fib_nh_weight;
 	}
 
 	return total;
@@ -4088,11 +4088,11 @@ static void rt6_upper_bound_set(struct fib6_info *rt, int *weight, int total)
 	int upper_bound = -1;
 
 	if (!rt6_is_dead(rt)) {
-		*weight += rt->fib6_nh.fib_nh_weight;
+		*weight += rt->fib6_nh->fib_nh_weight;
 		upper_bound = DIV_ROUND_CLOSEST_ULL((u64) (*weight) << 31,
 						    total) - 1;
 	}
-	atomic_set(&rt->fib6_nh.fib_nh_upper_bound, upper_bound);
+	atomic_set(&rt->fib6_nh->fib_nh_upper_bound, upper_bound);
 }
 
 static void rt6_multipath_upper_bound_set(struct fib6_info *rt, int total)
@@ -4136,8 +4136,8 @@ static int fib6_ifup(struct fib6_info *rt, void *p_arg)
 	struct net *net = dev_net(arg->dev);
 
 	if (rt != net->ipv6.fib6_null_entry &&
-	    rt->fib6_nh.fib_nh_dev == arg->dev) {
-		rt->fib6_nh.fib_nh_flags &= ~arg->nh_flags;
+	    rt->fib6_nh->fib_nh_dev == arg->dev) {
+		rt->fib6_nh->fib_nh_flags &= ~arg->nh_flags;
 		fib6_update_sernum_upto_root(net, rt);
 		rt6_multipath_rebalance(rt);
 	}
@@ -4165,10 +4165,10 @@ static bool rt6_multipath_uses_dev(const struct fib6_info *rt,
 {
 	struct fib6_info *iter;
 
-	if (rt->fib6_nh.fib_nh_dev == dev)
+	if (rt->fib6_nh->fib_nh_dev == dev)
 		return true;
 	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings)
-		if (iter->fib6_nh.fib_nh_dev == dev)
+		if (iter->fib6_nh->fib_nh_dev == dev)
 			return true;
 
 	return false;
@@ -4189,12 +4189,12 @@ static unsigned int rt6_multipath_dead_count(const struct fib6_info *rt,
 	struct fib6_info *iter;
 	unsigned int dead = 0;
 
-	if (rt->fib6_nh.fib_nh_dev == down_dev ||
-	    rt->fib6_nh.fib_nh_flags & RTNH_F_DEAD)
+	if (rt->fib6_nh->fib_nh_dev == down_dev ||
+	    rt->fib6_nh->fib_nh_flags & RTNH_F_DEAD)
 		dead++;
 	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings)
-		if (iter->fib6_nh.fib_nh_dev == down_dev ||
-		    iter->fib6_nh.fib_nh_flags & RTNH_F_DEAD)
+		if (iter->fib6_nh->fib_nh_dev == down_dev ||
+		    iter->fib6_nh->fib_nh_flags & RTNH_F_DEAD)
 			dead++;
 
 	return dead;
@@ -4206,11 +4206,11 @@ static void rt6_multipath_nh_flags_set(struct fib6_info *rt,
 {
 	struct fib6_info *iter;
 
-	if (rt->fib6_nh.fib_nh_dev == dev)
-		rt->fib6_nh.fib_nh_flags |= nh_flags;
+	if (rt->fib6_nh->fib_nh_dev == dev)
+		rt->fib6_nh->fib_nh_flags |= nh_flags;
 	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings)
-		if (iter->fib6_nh.fib_nh_dev == dev)
-			iter->fib6_nh.fib_nh_flags |= nh_flags;
+		if (iter->fib6_nh->fib_nh_dev == dev)
+			iter->fib6_nh->fib_nh_flags |= nh_flags;
 }
 
 /* called with write lock held for table with rt */
@@ -4225,12 +4225,12 @@ static int fib6_ifdown(struct fib6_info *rt, void *p_arg)
 
 	switch (arg->event) {
 	case NETDEV_UNREGISTER:
-		return rt->fib6_nh.fib_nh_dev == dev ? -1 : 0;
+		return rt->fib6_nh->fib_nh_dev == dev ? -1 : 0;
 	case NETDEV_DOWN:
 		if (rt->should_flush)
 			return -1;
 		if (!rt->fib6_nsiblings)
-			return rt->fib6_nh.fib_nh_dev == dev ? -1 : 0;
+			return rt->fib6_nh->fib_nh_dev == dev ? -1 : 0;
 		if (rt6_multipath_uses_dev(rt, dev)) {
 			unsigned int count;
 
@@ -4246,10 +4246,10 @@ static int fib6_ifdown(struct fib6_info *rt, void *p_arg)
 		}
 		return -2;
 	case NETDEV_CHANGE:
-		if (rt->fib6_nh.fib_nh_dev != dev ||
+		if (rt->fib6_nh->fib_nh_dev != dev ||
 		    rt->fib6_flags & (RTF_LOCAL | RTF_ANYCAST))
 			break;
-		rt->fib6_nh.fib_nh_flags |= RTNH_F_LINKDOWN;
+		rt->fib6_nh->fib_nh_flags |= RTNH_F_LINKDOWN;
 		rt6_multipath_rebalance(rt);
 		break;
 	}
@@ -4331,7 +4331,7 @@ static int rt6_mtu_change_route(struct fib6_info *f6i, void *p_arg)
 		return 0;
 
 	arg->f6i = f6i;
-	return fib6_nh_mtu_change(&f6i->fib6_nh, arg);
+	return fib6_nh_mtu_change(f6i->fib6_nh, arg);
 }
 
 void rt6_mtu_change(struct net_device *dev, unsigned int mtu)
@@ -4611,7 +4611,7 @@ static int ip6_route_multipath_add(struct fib6_config *cfg,
 			goto cleanup;
 		}
 
-		rt->fib6_nh.fib_nh_weight = rtnh->rtnh_hops + 1;
+		rt->fib6_nh->fib_nh_weight = rtnh->rtnh_hops + 1;
 
 		err = ip6_route_info_append(info->nl_net, &rt6_nh_list,
 					    rt, &r_cfg);
@@ -4778,7 +4778,7 @@ static size_t rt6_nlmsg_size(struct fib6_info *rt)
 		nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
 			    + NLA_ALIGN(sizeof(struct rtnexthop))
 			    + nla_total_size(16) /* RTA_GATEWAY */
-			    + lwtunnel_get_encap_size(rt->fib6_nh.fib_nh_lws);
+			    + lwtunnel_get_encap_size(rt->fib6_nh->fib_nh_lws);
 
 		nexthop_len *= rt->fib6_nsiblings;
 	}
@@ -4796,7 +4796,7 @@ static size_t rt6_nlmsg_size(struct fib6_info *rt)
 	       + nla_total_size(sizeof(struct rta_cacheinfo))
 	       + nla_total_size(TCP_CA_NAME_MAX) /* RTAX_CC_ALGO */
 	       + nla_total_size(1) /* RTA_PREF */
-	       + lwtunnel_get_encap_size(rt->fib6_nh.fib_nh_lws)
+	       + lwtunnel_get_encap_size(rt->fib6_nh->fib_nh_lws)
 	       + nexthop_len;
 }
 
@@ -4916,14 +4916,14 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (!mp)
 			goto nla_put_failure;
 
-		if (fib_add_nexthop(skb, &rt->fib6_nh.nh_common,
-				    rt->fib6_nh.fib_nh_weight) < 0)
+		if (fib_add_nexthop(skb, &rt->fib6_nh->nh_common,
+				    rt->fib6_nh->fib_nh_weight) < 0)
 			goto nla_put_failure;
 
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
-			if (fib_add_nexthop(skb, &sibling->fib6_nh.nh_common,
-					    sibling->fib6_nh.fib_nh_weight) < 0)
+			if (fib_add_nexthop(skb, &sibling->fib6_nh->nh_common,
+					    sibling->fib6_nh->fib_nh_weight) < 0)
 				goto nla_put_failure;
 		}
 
@@ -4931,7 +4931,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	} else {
 		unsigned char nh_flags = 0;
 
-		if (fib_nexthop_info(skb, &rt->fib6_nh.nh_common,
+		if (fib_nexthop_info(skb, &rt->fib6_nh->nh_common,
 				     &nh_flags, false) < 0)
 			goto nla_put_failure;
 
@@ -4961,7 +4961,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 			       const struct net_device *dev)
 {
-	if (f6i->fib6_nh.fib_nh_dev == dev)
+	if (f6i->fib6_nh->fib_nh_dev == dev)
 		return true;
 
 	if (f6i->fib6_nsiblings) {
@@ -4969,7 +4969,7 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &f6i->fib6_siblings, fib6_siblings) {
-			if (sibling->fib6_nh.fib_nh_dev == dev)
+			if (sibling->fib6_nh->fib_nh_dev == dev)
 				return true;
 		}
 	}
@@ -5290,7 +5290,7 @@ static int ip6_route_dev_notify(struct notifier_block *this,
 		return NOTIFY_OK;
 
 	if (event == NETDEV_REGISTER) {
-		net->ipv6.fib6_null_entry->fib6_nh.fib_nh_dev = dev;
+		net->ipv6.fib6_null_entry->fib6_nh->fib_nh_dev = dev;
 		net->ipv6.ip6_null_entry->dst.dev = dev;
 		net->ipv6.ip6_null_entry->rt6i_idev = in6_dev_get(dev);
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
@@ -5484,11 +5484,11 @@ static int __net_init ip6_route_net_init(struct net *net)
 	if (dst_entries_init(&net->ipv6.ip6_dst_ops) < 0)
 		goto out_ip6_dst_ops;
 
-	net->ipv6.fib6_null_entry = kmemdup(&fib6_null_entry_template,
-					    sizeof(*net->ipv6.fib6_null_entry),
-					    GFP_KERNEL);
+	net->ipv6.fib6_null_entry = fib6_info_alloc(GFP_KERNEL, true);
 	if (!net->ipv6.fib6_null_entry)
 		goto out_ip6_dst_entries;
+	memcpy(net->ipv6.fib6_null_entry, &fib6_null_entry_template,
+	       sizeof(*net->ipv6.fib6_null_entry));
 
 	net->ipv6.ip6_null_entry = kmemdup(&ip6_null_entry_template,
 					   sizeof(*net->ipv6.ip6_null_entry),
@@ -5625,7 +5625,7 @@ void __init ip6_route_init_special_entries(void)
 	/* Registering of the loopback is done before this portion of code,
 	 * the loopback reference in rt6_info will not be taken, do it
 	 * manually for init_net */
-	init_net.ipv6.fib6_null_entry->fib6_nh.fib_nh_dev = init_net.loopback_dev;
+	init_net.ipv6.fib6_null_entry->fib6_nh->fib_nh_dev = init_net.loopback_dev;
 	init_net.ipv6.ip6_null_entry->dst.dev = init_net.loopback_dev;
 	init_net.ipv6.ip6_null_entry->rt6i_idev = in6_dev_get(init_net.loopback_dev);
   #ifdef CONFIG_IPV6_MULTIPLE_TABLES
-- 
2.11.0

