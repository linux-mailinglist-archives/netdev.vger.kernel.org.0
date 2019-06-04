Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5643C33D77
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 05:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfFDDUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 23:20:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:53416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726076AbfFDDT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 23:19:59 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E80E425E90;
        Tue,  4 Jun 2019 03:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559618398;
        bh=39q/cjkEeKAA3IX7ruxrw9wrJSd0Yj7B6IPWhznbGDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NuHW8VGKjpN7xeRyaF7uYxfAr3CTT+0FlE3EFkYuk6eIPab1zvUjcTZV+DXVLoYbt
         FF39nMPY0cWkYRxNYNuNaKyS/i7WkVvVk6vXznZABWR47ItOGf9bDyuA4Cba9Zk36J
         mg5secvzrjrO9ApFe4dqoQLxB3WYnAuxxr76oIos=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, saeedm@mellanox.com, kafai@fb.com,
        weiwan@google.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v3 net-next 4/7] ipv6: Plumb support for nexthop object in a fib6_info
Date:   Mon,  3 Jun 2019 20:19:52 -0700
Message-Id: <20190604031955.26949-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190604031955.26949-1-dsahern@kernel.org>
References: <20190604031955.26949-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add struct nexthop and nh_list list_head to fib6_info. nh_list is the
fib6_info side of the nexthop <-> fib_info relationship. Since a fib6_info
referencing a nexthop object can not have 'sibling' entries (the old way
of doing multipath routes), the nh_list is a union with fib6_siblings.

Add f6i_list list_head to 'struct nexthop' to track fib6_info entries
using a nexthop instance. Update __remove_nexthop_fib to walk f6_list
and delete fib entries using the nexthop.

Add a few nexthop helpers for use when a nexthop is added to fib6_info:
- nexthop_fib6_nh - return first fib6_nh in a nexthop object
- fib6_info_nh_dev moved to nexthop.h and updated to use nexthop_fib6_nh
  if the fib6_info references a nexthop object
- nexthop_path_fib6_result - similar to ipv4, select a path within a
  multipath nexthop object. If the nexthop is a blackhole, set
  fib6_result type to RTN_BLACKHOLE, and set the REJECT flag

Update the fib6_info references to check for nh and take a different path
as needed:
- rt6_qualify_for_ecmp - if a fib entry uses a nexthop object it can NOT
  be coalesced with other fib entries into a multipath route
- rt6_duplicate_nexthop - use nexthop_cmp if either fib6_info references
  a nexthop
- addrconf (host routes), RA's and info entries (anything configured via
  ndisc) does not use nexthop objects
- fib6_info_destroy_rcu - put reference to nexthop object
- fib6_purge_rt - drop fib6_info from f6i_list
- fib6_select_path - update to use the new nexthop_path_fib6_result when
  fib entry uses a nexthop object
- rt6_device_match - update to catch use of nexthop object as a blackhole
  and set fib6_type and flags.
- ip6_route_info_create - don't add space for fib6_nh if fib entry is
  going to reference a nexthop object, take a reference to nexthop object,
  disallow use of source routing
- rt6_nlmsg_size - add space for RTA_NH_ID
- add rt6_fill_node_nexthop to add nexthop data on a dump

As with ipv4, most of the changes push existing code into the else branch
of whether the fib entry uses a nexthop object.

Update the nexthop code to walk f6i_list on a nexthop deleted to remove
fib entries referencing it.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ip6_fib.h   |  11 ++--
 include/net/ip6_route.h |  13 ++++-
 include/net/nexthop.h   |  50 ++++++++++++++++
 net/ipv4/nexthop.c      |  44 ++++++++++++++
 net/ipv6/addrconf.c     |   5 ++
 net/ipv6/ip6_fib.c      |  22 +++++--
 net/ipv6/ndisc.c        |   3 +-
 net/ipv6/route.c        | 148 +++++++++++++++++++++++++++++++++++++++++-------
 8 files changed, 260 insertions(+), 36 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index ebe5d65f97e0..1a8acd51b277 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -146,7 +146,10 @@ struct fib6_info {
 	 * destination, but not the same gateway. nsiblings is just a cache
 	 * to speed up lookup.
 	 */
-	struct list_head		fib6_siblings;
+	union {
+		struct list_head	fib6_siblings;
+		struct list_head	nh_list;
+	};
 	unsigned int			fib6_nsiblings;
 
 	refcount_t			fib6_ref;
@@ -170,6 +173,7 @@ struct fib6_info {
 					unused:3;
 
 	struct rcu_head			rcu;
+	struct nexthop			*nh;
 	struct fib6_nh			fib6_nh[0];
 };
 
@@ -441,11 +445,6 @@ void rt6_get_prefsrc(const struct rt6_info *rt, struct in6_addr *addr)
 	rcu_read_unlock();
 }
 
-static inline struct net_device *fib6_info_nh_dev(const struct fib6_info *f6i)
-{
-	return f6i->fib6_nh->fib_nh_dev;
-}
-
 int fib6_nh_init(struct net *net, struct fib6_nh *fib6_nh,
 		 struct fib6_config *cfg, gfp_t gfp_flags,
 		 struct netlink_ext_ack *extack);
diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index a6ce6ea856b9..7375a165fd98 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -27,6 +27,7 @@ struct route_info {
 #include <linux/ip.h>
 #include <linux/ipv6.h>
 #include <linux/route.h>
+#include <net/nexthop.h>
 
 #define RT6_LOOKUP_F_IFACE		0x00000001
 #define RT6_LOOKUP_F_REACHABLE		0x00000002
@@ -66,10 +67,13 @@ static inline bool rt6_need_strict(const struct in6_addr *daddr)
 		(IPV6_ADDR_MULTICAST | IPV6_ADDR_LINKLOCAL | IPV6_ADDR_LOOPBACK);
 }
 
+/* fib entries using a nexthop object can not be coalesced into
+ * a multipath route
+ */
 static inline bool rt6_qualify_for_ecmp(const struct fib6_info *f6i)
 {
 	/* the RTF_ADDRCONF flag filters out RA's */
-	return !(f6i->fib6_flags & RTF_ADDRCONF) &&
+	return !(f6i->fib6_flags & RTF_ADDRCONF) && !f6i->nh &&
 		f6i->fib6_nh->fib_nh_gw_family;
 }
 
@@ -275,8 +279,13 @@ static inline struct in6_addr *rt6_nexthop(struct rt6_info *rt,
 
 static inline bool rt6_duplicate_nexthop(struct fib6_info *a, struct fib6_info *b)
 {
-	struct fib6_nh *nha = a->fib6_nh, *nhb = b->fib6_nh;
+	struct fib6_nh *nha, *nhb;
+
+	if (a->nh || b->nh)
+		return nexthop_cmp(a->nh, b->nh);
 
+	nha = a->fib6_nh;
+	nhb = b->fib6_nh;
 	return nha->fib_nh_dev == nhb->fib_nh_dev &&
 	       ipv6_addr_equal(&nha->fib_nh_gw6, &nhb->fib_nh_gw6) &&
 	       !lwtunnel_cmp_encap(nha->fib_nh_lws, nhb->fib_nh_lws);
diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 2912a2d7a515..aff7b2410057 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -10,6 +10,7 @@
 #define __LINUX_NEXTHOP_H
 
 #include <linux/netdevice.h>
+#include <linux/route.h>
 #include <linux/types.h>
 #include <net/ip_fib.h>
 #include <net/ip6_fib.h>
@@ -78,6 +79,7 @@ struct nh_group {
 struct nexthop {
 	struct rb_node		rb_node;    /* entry on netns rbtree */
 	struct list_head	fi_list;    /* v4 entries using nh */
+	struct list_head	f6i_list;   /* v6 entries using nh */
 	struct list_head	grp_list;   /* nh group entries using this nh */
 	struct net		*net;
 
@@ -255,4 +257,52 @@ static inline struct fib_nh *fib_info_nh(struct fib_info *fi, int nhsel)
 
 	return &fi->fib_nh[nhsel];
 }
+
+/*
+ * IPv6 variants
+ */
+int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
+		       struct netlink_ext_ack *extack);
+
+static inline struct fib6_nh *nexthop_fib6_nh(struct nexthop *nh)
+{
+	struct nh_info *nhi;
+
+	if (nexthop_is_multipath(nh)) {
+		nh = nexthop_mpath_select(nh, 0);
+		if (!nh)
+			return NULL;
+	}
+
+	nhi = rcu_dereference_rtnl(nh->nh_info);
+	if (nhi->family == AF_INET6)
+		return &nhi->fib6_nh;
+
+	return NULL;
+}
+
+static inline struct net_device *fib6_info_nh_dev(struct fib6_info *f6i)
+{
+	struct fib6_nh *fib6_nh;
+
+	fib6_nh = f6i->nh ? nexthop_fib6_nh(f6i->nh) : f6i->fib6_nh;
+	return fib6_nh->fib_nh_dev;
+}
+
+static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
+{
+	struct nexthop *nh = res->f6i->nh;
+	struct nh_info *nhi;
+
+	nh = nexthop_select_path(nh, hash);
+
+	nhi = rcu_dereference_rtnl(nh->nh_info);
+	if (nhi->reject_nh) {
+		res->fib6_type = RTN_BLACKHOLE;
+		res->fib6_flags |= RTF_REJECT;
+		res->nh = nexthop_fib6_nh(nh);
+	} else {
+		res->nh = &nhi->fib6_nh;
+	}
+}
 #endif
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 63cbb04f697f..5e48762b6b5f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -106,6 +106,7 @@ static struct nexthop *nexthop_alloc(void)
 	nh = kzalloc(sizeof(struct nexthop), GFP_KERNEL);
 	if (nh) {
 		INIT_LIST_HEAD(&nh->fi_list);
+		INIT_LIST_HEAD(&nh->f6i_list);
 		INIT_LIST_HEAD(&nh->grp_list);
 	}
 	return nh;
@@ -516,6 +517,41 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 }
 EXPORT_SYMBOL_GPL(nexthop_select_path);
 
+int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
+		       struct netlink_ext_ack *extack)
+{
+	struct nh_info *nhi;
+
+	/* fib6_src is unique to a fib6_info and limits the ability to cache
+	 * routes in fib6_nh within a nexthop that is potentially shared
+	 * across multiple fib entries. If the config wants to use source
+	 * routing it can not use nexthop objects. mlxsw also does not allow
+	 * fib6_src on routes.
+	 */
+	if (!ipv6_addr_any(&cfg->fc_src)) {
+		NL_SET_ERR_MSG(extack, "IPv6 routes using source address can not use nexthop objects");
+		return -EINVAL;
+	}
+
+	if (nh->is_group) {
+		struct nh_group *nhg;
+
+		nhg = rtnl_dereference(nh->nh_grp);
+		if (nhg->has_v4)
+			goto no_v4_nh;
+	} else {
+		nhi = rtnl_dereference(nh->nh_info);
+		if (nhi->family == AF_INET)
+			goto no_v4_nh;
+	}
+
+	return 0;
+no_v4_nh:
+	NL_SET_ERR_MSG(extack, "IPv6 routes can not use an IPv4 nexthop");
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(fib6_check_nexthop);
+
 static int nexthop_check_scope(struct nexthop *nh, u8 scope,
 			       struct netlink_ext_ack *extack)
 {
@@ -658,6 +694,7 @@ static void remove_nexthop_group(struct nexthop *nh, struct nl_info *nlinfo)
 
 static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 {
+	struct fib6_info *f6i, *tmp;
 	bool do_flush = false;
 	struct fib_info *fi;
 
@@ -667,6 +704,13 @@ static void __remove_nexthop_fib(struct net *net, struct nexthop *nh)
 	}
 	if (do_flush)
 		fib_flush(net);
+
+	/* ip6_del_rt removes the entry from this list hence the _safe */
+	list_for_each_entry_safe(f6i, tmp, &nh->f6i_list, nh_list) {
+		/* __ip6_del_rt does a release, so do a hold here */
+		fib6_info_hold(f6i);
+		ipv6_stub->ip6_del_rt(net, f6i);
+	}
 }
 
 static void __remove_nexthop(struct net *net, struct nexthop *nh,
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4c30726fa7c7..d7fff86c2ef0 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2421,6 +2421,10 @@ static struct fib6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 		goto out;
 
 	for_each_fib6_node_rt_rcu(fn) {
+		/* prefix routes only use builtin fib6_nh */
+		if (rt->nh)
+			continue;
+
 		if (rt->fib6_nh->fib_nh_dev->ifindex != dev->ifindex)
 			continue;
 		if (no_gw && rt->fib6_nh->fib_nh_gw_family)
@@ -6352,6 +6356,7 @@ void addrconf_disable_policy_idev(struct inet6_dev *idev, int val)
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		spin_lock(&ifa->lock);
 		if (ifa->rt) {
+			/* host routes only use builtin fib6_nh */
 			struct fib6_nh *nh = ifa->rt->fib6_nh;
 			int cpu;
 
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index cdfb8500ccae..02feda73a98e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -159,6 +159,7 @@ struct fib6_info *fib6_info_alloc(gfp_t gfp_flags, bool with_fib6_nh)
 	if (!f6i)
 		return NULL;
 
+	/* fib6_siblings is a union with nh_list, so this initializes both */
 	INIT_LIST_HEAD(&f6i->fib6_siblings);
 	refcount_set(&f6i->fib6_ref, 1);
 
@@ -171,7 +172,11 @@ void fib6_info_destroy_rcu(struct rcu_head *head)
 
 	WARN_ON(f6i->fib6_node);
 
-	fib6_nh_release(f6i->fib6_nh);
+	if (f6i->nh)
+		nexthop_put(f6i->nh);
+	else
+		fib6_nh_release(f6i->fib6_nh);
+
 	ip_fib_metrics_put(f6i->fib6_metrics);
 	kfree(f6i);
 }
@@ -927,6 +932,9 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 
 	fib6_drop_pcpu_from(rt, table);
 
+	if (rt->nh && !list_empty(&rt->nh_list))
+		list_del_init(&rt->nh_list);
+
 	if (refcount_read(&rt->fib6_ref) != 1) {
 		/* This route is used as dummy address holder in some split
 		 * nodes. It is not leaked, but it still holds other resources,
@@ -1334,6 +1342,8 @@ int fib6_add(struct fib6_node *root, struct fib6_info *rt,
 
 	err = fib6_add_rt2node(fn, rt, info, extack);
 	if (!err) {
+		if (rt->nh)
+			list_add(&rt->nh_list, &rt->nh->f6i_list);
 		__fib6_update_sernum_upto_root(rt, sernum);
 		fib6_start_gc(info->nl_net, rt);
 	}
@@ -2295,9 +2305,13 @@ static int ipv6_route_seq_show(struct seq_file *seq, void *v)
 {
 	struct fib6_info *rt = v;
 	struct ipv6_route_iter *iter = seq->private;
+	struct fib6_nh *fib6_nh = rt->fib6_nh;
 	unsigned int flags = rt->fib6_flags;
 	const struct net_device *dev;
 
+	if (rt->nh)
+		fib6_nh = nexthop_fib6_nh(rt->nh);
+
 	seq_printf(seq, "%pi6 %02x ", &rt->fib6_dst.addr, rt->fib6_dst.plen);
 
 #ifdef CONFIG_IPV6_SUBTREES
@@ -2305,14 +2319,14 @@ static int ipv6_route_seq_show(struct seq_file *seq, void *v)
 #else
 	seq_puts(seq, "00000000000000000000000000000000 00 ");
 #endif
-	if (rt->fib6_nh->fib_nh_gw_family) {
+	if (fib6_nh->fib_nh_gw_family) {
 		flags |= RTF_GATEWAY;
-		seq_printf(seq, "%pi6", &rt->fib6_nh->fib_nh_gw6);
+		seq_printf(seq, "%pi6", &fib6_nh->fib_nh_gw6);
 	} else {
 		seq_puts(seq, "00000000000000000000000000000000");
 	}
 
-	dev = rt->fib6_nh->fib_nh_dev;
+	dev = fib6_nh->fib_nh_dev;
 	seq_printf(seq, " %08x %08x %08x %08x %8s\n",
 		   rt->fib6_metric, refcount_read(&rt->fib6_ref), 0,
 		   flags, dev ? dev->name : "");
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f874dde1ee85..6e3c51109c83 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1289,9 +1289,8 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	    !in6_dev->cnf.accept_ra_rtr_pref)
 		pref = ICMPV6_ROUTER_PREF_MEDIUM;
 #endif
-
+	/* routes added from RAs do not use nexthop objects */
 	rt = rt6_get_dflt_router(net, &ipv6_hdr(skb)->saddr, skb->dev);
-
 	if (rt) {
 		neigh = ip6_neigh_lookup(&rt->fib6_nh->fib_nh_gw6,
 					 rt->fib6_nh->fib_nh_dev, NULL,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9b9a0159f7fd..df5be3d5d3e5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -432,15 +432,21 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 	struct fib6_info *sibling, *next_sibling;
 	struct fib6_info *match = res->f6i;
 
-	if (!match->fib6_nsiblings || have_oif_match)
+	if ((!match->fib6_nsiblings && !match->nh) || have_oif_match)
 		goto out;
 
 	/* We might have already computed the hash for ICMPv6 errors. In such
 	 * case it will always be non-zero. Otherwise now is the time to do it.
 	 */
-	if (!fl6->mp_hash)
+	if (!fl6->mp_hash &&
+	    (!match->nh || nexthop_is_multipath(match->nh)))
 		fl6->mp_hash = rt6_multipath_hash(net, fl6, skb, NULL);
 
+	if (unlikely(match->nh)) {
+		nexthop_path_fib6_result(res, fl6->mp_hash);
+		return;
+	}
+
 	if (fl6->mp_hash <= atomic_read(&match->fib6_nh->fib_nh_upper_bound))
 		goto out;
 
@@ -496,7 +502,13 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 	struct fib6_nh *nh;
 
 	if (!oif && ipv6_addr_any(saddr)) {
-		nh = f6i->fib6_nh;
+		if (unlikely(f6i->nh)) {
+			nh = nexthop_fib6_nh(f6i->nh);
+			if (nexthop_is_blackhole(f6i->nh))
+				goto out_blackhole;
+		} else {
+			nh = f6i->fib6_nh;
+		}
 		if (!(nh->fib_nh_flags & RTNH_F_DEAD))
 			goto out;
 	}
@@ -515,7 +527,14 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 		goto out;
 	}
 
-	nh = f6i->fib6_nh;
+	if (unlikely(f6i->nh)) {
+		nh = nexthop_fib6_nh(f6i->nh);
+		if (nexthop_is_blackhole(f6i->nh))
+			goto out_blackhole;
+	} else {
+		nh = f6i->fib6_nh;
+	}
+
 	if (nh->fib_nh_flags & RTNH_F_DEAD) {
 		res->f6i = net->ipv6.fib6_null_entry;
 		nh = res->f6i->fib6_nh;
@@ -524,6 +543,12 @@ static void rt6_device_match(struct net *net, struct fib6_result *res,
 	res->nh = nh;
 	res->fib6_type = res->f6i->fib6_type;
 	res->fib6_flags = res->f6i->fib6_flags;
+	return;
+
+out_blackhole:
+	res->fib6_flags |= RTF_REJECT;
+	res->fib6_type = RTN_BLACKHOLE;
+	res->nh = nh;
 }
 
 #ifdef CONFIG_IPV6_ROUTER_PREF
@@ -1117,6 +1142,8 @@ static struct rt6_info *ip6_pol_route_lookup(struct net *net,
 		rt = net->ipv6.ip6_null_entry;
 		dst_hold(&rt->dst);
 		goto out;
+	} else if (res.fib6_flags & RTF_REJECT) {
+		goto do_create;
 	}
 
 	fib6_select_path(net, &res, fl6, fl6->flowi6_oif,
@@ -1128,6 +1155,7 @@ static struct rt6_info *ip6_pol_route_lookup(struct net *net,
 		if (ip6_hold_safe(net, &rt))
 			dst_use_noref(&rt->dst, jiffies);
 	} else {
+do_create:
 		rt = ip6_create_rt_rcu(&res);
 	}
 
@@ -3217,7 +3245,9 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 {
 	struct net *net = cfg->fc_nlinfo.nl_net;
 	struct fib6_info *rt = NULL;
+	struct nexthop *nh = NULL;
 	struct fib6_table *table;
+	struct fib6_nh *fib6_nh;
 	int err = -EINVAL;
 	int addr_type;
 
@@ -3270,7 +3300,7 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 		goto out;
 
 	err = -ENOMEM;
-	rt = fib6_info_alloc(gfp_flags, true);
+	rt = fib6_info_alloc(gfp_flags, !nh);
 	if (!rt)
 		goto out;
 
@@ -3310,19 +3340,35 @@ static struct fib6_info *ip6_route_info_create(struct fib6_config *cfg,
 	ipv6_addr_prefix(&rt->fib6_src.addr, &cfg->fc_src, cfg->fc_src_len);
 	rt->fib6_src.plen = cfg->fc_src_len;
 #endif
-	err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
-	if (err)
-		goto out;
+	if (nh) {
+		if (!nexthop_get(nh)) {
+			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			goto out;
+		}
+		if (rt->fib6_src.plen) {
+			NL_SET_ERR_MSG(extack, "Nexthops can not be used wtih source routing");
+			goto out;
+		}
+		rt->nh = nh;
+		fib6_nh = nexthop_fib6_nh(rt->nh);
+	} else {
+		err = fib6_nh_init(net, rt->fib6_nh, cfg, gfp_flags, extack);
+		if (err)
+			goto out;
 
-	/* We cannot add true routes via loopback here,
-	 * they would result in kernel looping; promote them to reject routes
-	 */
-	addr_type = ipv6_addr_type(&cfg->fc_dst);
-	if (fib6_is_reject(cfg->fc_flags, rt->fib6_nh->fib_nh_dev, addr_type))
-		rt->fib6_flags = RTF_REJECT | RTF_NONEXTHOP;
+		fib6_nh = rt->fib6_nh;
+
+		/* We cannot add true routes via loopback here, they would
+		 * result in kernel looping; promote them to reject routes
+		 */
+		addr_type = ipv6_addr_type(&cfg->fc_dst);
+		if (fib6_is_reject(cfg->fc_flags, rt->fib6_nh->fib_nh_dev,
+				   addr_type))
+			rt->fib6_flags = RTF_REJECT | RTF_NONEXTHOP;
+	}
 
 	if (!ipv6_addr_any(&cfg->fc_prefsrc)) {
-		struct net_device *dev = fib6_info_nh_dev(rt);
+		struct net_device *dev = fib6_nh->fib_nh_dev;
 
 		if (!ipv6_chk_addr(net, &cfg->fc_prefsrc, dev, 0)) {
 			NL_SET_ERR_MSG(extack, "Invalid source address");
@@ -3678,6 +3724,9 @@ static struct fib6_info *rt6_get_route_info(struct net *net,
 		goto out;
 
 	for_each_fib6_node_rt_rcu(fn) {
+		/* these routes do not use nexthops */
+		if (rt->nh)
+			continue;
 		if (rt->fib6_nh->fib_nh_dev->ifindex != ifindex)
 			continue;
 		if (!(rt->fib6_flags & RTF_ROUTEINFO) ||
@@ -3741,8 +3790,13 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
 
 	rcu_read_lock();
 	for_each_fib6_node_rt_rcu(&table->tb6_root) {
-		struct fib6_nh *nh = rt->fib6_nh;
+		struct fib6_nh *nh;
+
+		/* RA routes do not use nexthops */
+		if (rt->nh)
+			continue;
 
+		nh = rt->fib6_nh;
 		if (dev == nh->fib_nh_dev &&
 		    ((rt->fib6_flags & (RTF_ADDRCONF | RTF_DEFAULT)) == (RTF_ADDRCONF | RTF_DEFAULT)) &&
 		    ipv6_addr_equal(&nh->fib_nh_gw6, addr))
@@ -3993,7 +4047,8 @@ static int fib6_remove_prefsrc(struct fib6_info *rt, void *arg)
 	struct net *net = ((struct arg_dev_net_ip *)arg)->net;
 	struct in6_addr *addr = ((struct arg_dev_net_ip *)arg)->addr;
 
-	if (((void *)rt->fib6_nh->fib_nh_dev == dev || !dev) &&
+	if (!rt->nh &&
+	    ((void *)rt->fib6_nh->fib_nh_dev == dev || !dev) &&
 	    rt != net->ipv6.fib6_null_entry &&
 	    ipv6_addr_equal(addr, &rt->fib6_prefsrc.addr)) {
 		spin_lock_bh(&rt6_exception_lock);
@@ -4021,8 +4076,13 @@ void rt6_remove_prefsrc(struct inet6_ifaddr *ifp)
 static int fib6_clean_tohost(struct fib6_info *rt, void *arg)
 {
 	struct in6_addr *gateway = (struct in6_addr *)arg;
-	struct fib6_nh *nh = rt->fib6_nh;
+	struct fib6_nh *nh;
 
+	/* RA routes do not use nexthops */
+	if (rt->nh)
+		return 0;
+
+	nh = rt->fib6_nh;
 	if (((rt->fib6_flags & RTF_RA_ROUTER) == RTF_RA_ROUTER) &&
 	    nh->fib_nh_gw_family && ipv6_addr_equal(gateway, &nh->fib_nh_gw6))
 		return -1;
@@ -4069,6 +4129,7 @@ static struct fib6_info *rt6_multipath_first_sibling(const struct fib6_info *rt)
 	return NULL;
 }
 
+/* only called for fib entries with builtin fib6_nh */
 static bool rt6_is_dead(const struct fib6_info *rt)
 {
 	if (rt->fib6_nh->fib_nh_flags & RTNH_F_DEAD ||
@@ -4147,7 +4208,7 @@ static int fib6_ifup(struct fib6_info *rt, void *p_arg)
 	const struct arg_netdev_event *arg = p_arg;
 	struct net *net = dev_net(arg->dev);
 
-	if (rt != net->ipv6.fib6_null_entry &&
+	if (rt != net->ipv6.fib6_null_entry && !rt->nh &&
 	    rt->fib6_nh->fib_nh_dev == arg->dev) {
 		rt->fib6_nh->fib_nh_flags &= ~arg->nh_flags;
 		fib6_update_sernum_upto_root(net, rt);
@@ -4172,6 +4233,7 @@ void rt6_sync_up(struct net_device *dev, unsigned char nh_flags)
 	fib6_clean_all(dev_net(dev), fib6_ifup, &arg);
 }
 
+/* only called for fib entries with inline fib6_nh */
 static bool rt6_multipath_uses_dev(const struct fib6_info *rt,
 				   const struct net_device *dev)
 {
@@ -4232,7 +4294,7 @@ static int fib6_ifdown(struct fib6_info *rt, void *p_arg)
 	const struct net_device *dev = arg->dev;
 	struct net *net = dev_net(dev);
 
-	if (rt == net->ipv6.fib6_null_entry)
+	if (rt == net->ipv6.fib6_null_entry || rt->nh)
 		return 0;
 
 	switch (arg->event) {
@@ -4786,6 +4848,9 @@ static size_t rt6_nlmsg_size(struct fib6_info *rt)
 {
 	int nexthop_len = 0;
 
+	if (rt->nh)
+		nexthop_len += nla_total_size(4); /* RTA_NH_ID */
+
 	if (rt->fib6_nsiblings) {
 		nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
 			    + NLA_ALIGN(sizeof(struct rtnexthop))
@@ -4812,6 +4877,35 @@ static size_t rt6_nlmsg_size(struct fib6_info *rt)
 	       + nexthop_len;
 }
 
+static int rt6_fill_node_nexthop(struct sk_buff *skb, struct nexthop *nh,
+				 unsigned char *flags)
+{
+	if (nexthop_is_multipath(nh)) {
+		struct nlattr *mp;
+
+		mp = nla_nest_start(skb, RTA_MULTIPATH);
+		if (!mp)
+			goto nla_put_failure;
+
+		if (nexthop_mpath_fill_node(skb, nh))
+			goto nla_put_failure;
+
+		nla_nest_end(skb, mp);
+	} else {
+		struct fib6_nh *fib6_nh;
+
+		fib6_nh = nexthop_fib6_nh(nh);
+		if (fib_nexthop_info(skb, &fib6_nh->nh_common,
+				     flags, false) < 0)
+			goto nla_put_failure;
+	}
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 			 struct fib6_info *rt, struct dst_entry *dst,
 			 struct in6_addr *dest, struct in6_addr *src,
@@ -4821,6 +4915,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 	struct rt6_info *rt6 = (struct rt6_info *)dst;
 	struct rt6key *rt6_dst, *rt6_src;
 	u32 *pmetrics, table, rt6_flags;
+	unsigned char nh_flags = 0;
 	struct nlmsghdr *nlh;
 	struct rtmsg *rtm;
 	long expires = 0;
@@ -4940,9 +5035,18 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		}
 
 		nla_nest_end(skb, mp);
-	} else {
-		unsigned char nh_flags = 0;
+	} else if (rt->nh) {
+		if (nla_put_u32(skb, RTA_NH_ID, rt->nh->id))
+			goto nla_put_failure;
+
+		if (nexthop_is_blackhole(rt->nh))
+			rtm->rtm_type = RTN_BLACKHOLE;
 
+		if (rt6_fill_node_nexthop(skb, rt->nh, &nh_flags) < 0)
+			goto nla_put_failure;
+
+		rtm->rtm_flags |= nh_flags;
+	} else {
 		if (fib_nexthop_info(skb, &rt->fib6_nh->nh_common,
 				     &nh_flags, false) < 0)
 			goto nla_put_failure;
-- 
2.11.0

