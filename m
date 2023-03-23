Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C94C6C71EF
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 21:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbjCWUze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 16:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjCWUzc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 16:55:32 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2CB196B1;
        Thu, 23 Mar 2023 13:55:30 -0700 (PDT)
Message-ID: <20230323102800.042297517@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1679604929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=JXHMhp93Kw/ebB5Ti1phDvCi97j8rxdz0JvFtJbboLs=;
        b=1J+6XXE3vcpEqT8mTqFjAncgsl5Cgt6ofrHt9FERvrkIwnnYzfj1Jo+R5+HymBPHkrv+y1
        15Q6JR9uASSyF21KhFwofgaCsWXeT836edO1FycUxo8sM+xArmOK4N1T7jlGD+78Ve90yE
        5N86reja/fWZNcCWZV6WGzydHHLK3vjctyKWP4hrXeTiG/thIBFTu1DTvnK8FFnZRvDlOz
        Lb8pHbP/HY9bgW6JH/fKcv+pfnwbK34usOs8MvX4mYQj6jrftchTe14kxlImRB2aM5Ko2a
        ADz8Jw890XZA2ChO+i3umXQkmSaROggywUFscebPOOC+1o5li5PIODJa35uGPg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1679604929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=JXHMhp93Kw/ebB5Ti1phDvCi97j8rxdz0JvFtJbboLs=;
        b=bKm+gA+p9aWHHNJ6LVJzRsXesNvxQX+EMPjgSAAhdP3sFf1nJZimXNF64xIunUBxkBZLwp
        W4elR0fcr80qT8Dg==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
        David Ahern <dsahern@kernel.org>
Subject: [patch V3 1/4] [patch V2 1/4] net: dst: Prevent false sharing vs.
 dst_entry:: __refcnt
References: <20230323102649.764958589@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Thu, 23 Mar 2023 21:55:29 +0100 (CET)
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wangyang Guo <wangyang.guo@intel.com>

dst_entry::__refcnt is highly contended in scenarios where many connections
happen from and to the same IP. The reference count is an atomic_t, so the
reference count operations have to take the cache-line exclusive.

Aside of the unavoidable reference count contention there is another
significant problem which is caused by that: False sharing.

perf top identified two affected read accesses. dst_entry::lwtstate and
rtable::rt_genid.

dst_entry:__refcnt is located at offset 64 of dst_entry, which puts it into
a seperate cacheline vs. the read mostly members located at the beginning
of the struct.

That prevents false sharing vs. the struct members in the first 64
bytes of the structure, but there is also

  dst_entry::lwtstate

which is located after the reference count and in the same cache line. This
member is read after a reference count has been acquired.

struct rtable embeds a struct dst_entry at offset 0. struct dst_entry has a
size of 112 bytes, which means that the struct members of rtable which
follow the dst member share the same cache line as dst_entry::__refcnt.
Especially

  rtable::rt_genid

is also read by the contexts which have a reference count acquired
already.

When dst_entry:__refcnt is incremented or decremented via an atomic
operation these read accesses stall. This was found when analysing the
memtier benchmark in 1:100 mode, which amplifies the problem extremly.

Move the rt[6i]_uncached[_list] members out of struct rtable and struct
rt6_info into struct dst_entry to provide padding and move the lwtstate
member after that so it ends up in the same cache line.

The resulting improvement depends on the micro-architecture and the number
of CPUs. It ranges from +20% to +120% with a localhost memtier/memcached
benchmark.

[ tglx: Rearrange struct ]

Signed-off-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
V2: Move uncached[_list] into dst_entry (Eric)
---
 include/net/dst.h       |   15 ++++++++++++++-
 include/net/ip6_fib.h   |    3 ---
 include/net/ip6_route.h |    2 +-
 include/net/route.h     |    3 ---
 net/ipv4/route.c        |   20 ++++++++++----------
 net/ipv4/xfrm4_policy.c |    4 ++--
 net/ipv6/route.c        |   26 +++++++++++++-------------
 net/ipv6/xfrm6_policy.c |    4 ++--
 8 files changed, 42 insertions(+), 35 deletions(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -69,15 +69,28 @@ struct dst_entry {
 #endif
 	int			__use;
 	unsigned long		lastuse;
-	struct lwtunnel_state   *lwtstate;
 	struct rcu_head		rcu_head;
 	short			error;
 	short			__pad;
 	__u32			tclassid;
 #ifndef CONFIG_64BIT
+	struct lwtunnel_state   *lwtstate;
 	atomic_t		__refcnt;	/* 32-bit offset 64 */
 #endif
 	netdevice_tracker	dev_tracker;
+
+	/*
+	 * Used by rtable and rt6_info. Moves lwtstate into the next cache
+	 * line on 64bit so that lwtstate does not cause false sharing with
+	 * __refcnt under contention of __refcnt. This also puts the
+	 * frequently accessed members of rtable and rt6_info out of the
+	 * __refcnt cache line.
+	 */
+	struct list_head	rt_uncached;
+	struct uncached_list	*rt_uncached_list;
+#ifdef CONFIG_64BIT
+	struct lwtunnel_state   *lwtstate;
+#endif
 };
 
 struct dst_metrics {
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -217,9 +217,6 @@ struct rt6_info {
 	struct inet6_dev		*rt6i_idev;
 	u32				rt6i_flags;
 
-	struct list_head		rt6i_uncached;
-	struct uncached_list		*rt6i_uncached_list;
-
 	/* more non-fragment space at head required */
 	unsigned short			rt6i_nfheader_len;
 };
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -100,7 +100,7 @@ static inline struct dst_entry *ip6_rout
 static inline void ip6_rt_put_flags(struct rt6_info *rt, int flags)
 {
 	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
-	    !list_empty(&rt->rt6i_uncached))
+	    !list_empty(&rt->dst.rt_uncached))
 		ip6_rt_put(rt);
 }
 
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -78,9 +78,6 @@ struct rtable {
 	/* Miscellaneous cached information */
 	u32			rt_mtu_locked:1,
 				rt_pmtu:31;
-
-	struct list_head	rt_uncached;
-	struct uncached_list	*rt_uncached_list;
 };
 
 static inline bool rt_is_input_route(const struct rtable *rt)
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1508,20 +1508,20 @@ void rt_add_uncached_list(struct rtable
 {
 	struct uncached_list *ul = raw_cpu_ptr(&rt_uncached_list);
 
-	rt->rt_uncached_list = ul;
+	rt->dst.rt_uncached_list = ul;
 
 	spin_lock_bh(&ul->lock);
-	list_add_tail(&rt->rt_uncached, &ul->head);
+	list_add_tail(&rt->dst.rt_uncached, &ul->head);
 	spin_unlock_bh(&ul->lock);
 }
 
 void rt_del_uncached_list(struct rtable *rt)
 {
-	if (!list_empty(&rt->rt_uncached)) {
-		struct uncached_list *ul = rt->rt_uncached_list;
+	if (!list_empty(&rt->dst.rt_uncached)) {
+		struct uncached_list *ul = rt->dst.rt_uncached_list;
 
 		spin_lock_bh(&ul->lock);
-		list_del_init(&rt->rt_uncached);
+		list_del_init(&rt->dst.rt_uncached);
 		spin_unlock_bh(&ul->lock);
 	}
 }
@@ -1546,13 +1546,13 @@ void rt_flush_dev(struct net_device *dev
 			continue;
 
 		spin_lock_bh(&ul->lock);
-		list_for_each_entry_safe(rt, safe, &ul->head, rt_uncached) {
+		list_for_each_entry_safe(rt, safe, &ul->head, dst.rt_uncached) {
 			if (rt->dst.dev != dev)
 				continue;
 			rt->dst.dev = blackhole_netdev;
 			netdev_ref_replace(dev, blackhole_netdev,
 					   &rt->dst.dev_tracker, GFP_ATOMIC);
-			list_move(&rt->rt_uncached, &ul->quarantine);
+			list_move(&rt->dst.rt_uncached, &ul->quarantine);
 		}
 		spin_unlock_bh(&ul->lock);
 	}
@@ -1644,7 +1644,7 @@ struct rtable *rt_dst_alloc(struct net_d
 		rt->rt_uses_gateway = 0;
 		rt->rt_gw_family = 0;
 		rt->rt_gw4 = 0;
-		INIT_LIST_HEAD(&rt->rt_uncached);
+		INIT_LIST_HEAD(&rt->dst.rt_uncached);
 
 		rt->dst.output = ip_output;
 		if (flags & RTCF_LOCAL)
@@ -1675,7 +1675,7 @@ struct rtable *rt_dst_clone(struct net_d
 			new_rt->rt_gw4 = rt->rt_gw4;
 		else if (rt->rt_gw_family == AF_INET6)
 			new_rt->rt_gw6 = rt->rt_gw6;
-		INIT_LIST_HEAD(&new_rt->rt_uncached);
+		INIT_LIST_HEAD(&new_rt->dst.rt_uncached);
 
 		new_rt->dst.input = rt->dst.input;
 		new_rt->dst.output = rt->dst.output;
@@ -2859,7 +2859,7 @@ struct dst_entry *ipv4_blackhole_route(s
 		else if (rt->rt_gw_family == AF_INET6)
 			rt->rt_gw6 = ort->rt_gw6;
 
-		INIT_LIST_HEAD(&rt->rt_uncached);
+		INIT_LIST_HEAD(&rt->dst.rt_uncached);
 	}
 
 	dst_release(dst_orig);
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -91,7 +91,7 @@ static int xfrm4_fill_dst(struct xfrm_ds
 		xdst->u.rt.rt_gw6 = rt->rt_gw6;
 	xdst->u.rt.rt_pmtu = rt->rt_pmtu;
 	xdst->u.rt.rt_mtu_locked = rt->rt_mtu_locked;
-	INIT_LIST_HEAD(&xdst->u.rt.rt_uncached);
+	INIT_LIST_HEAD(&xdst->u.rt.dst.rt_uncached);
 	rt_add_uncached_list(&xdst->u.rt);
 
 	return 0;
@@ -121,7 +121,7 @@ static void xfrm4_dst_destroy(struct dst
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 
 	dst_destroy_metrics_generic(dst);
-	if (xdst->u.rt.rt_uncached_list)
+	if (xdst->u.rt.dst.rt_uncached_list)
 		rt_del_uncached_list(&xdst->u.rt);
 	xfrm_dst_destroy(xdst);
 }
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -139,20 +139,20 @@ void rt6_uncached_list_add(struct rt6_in
 {
 	struct uncached_list *ul = raw_cpu_ptr(&rt6_uncached_list);
 
-	rt->rt6i_uncached_list = ul;
+	rt->dst.rt_uncached_list = ul;
 
 	spin_lock_bh(&ul->lock);
-	list_add_tail(&rt->rt6i_uncached, &ul->head);
+	list_add_tail(&rt->dst.rt_uncached, &ul->head);
 	spin_unlock_bh(&ul->lock);
 }
 
 void rt6_uncached_list_del(struct rt6_info *rt)
 {
-	if (!list_empty(&rt->rt6i_uncached)) {
-		struct uncached_list *ul = rt->rt6i_uncached_list;
+	if (!list_empty(&rt->dst.rt_uncached)) {
+		struct uncached_list *ul = rt->dst.rt_uncached_list;
 
 		spin_lock_bh(&ul->lock);
-		list_del_init(&rt->rt6i_uncached);
+		list_del_init(&rt->dst.rt_uncached);
 		spin_unlock_bh(&ul->lock);
 	}
 }
@@ -169,7 +169,7 @@ static void rt6_uncached_list_flush_dev(
 			continue;
 
 		spin_lock_bh(&ul->lock);
-		list_for_each_entry_safe(rt, safe, &ul->head, rt6i_uncached) {
+		list_for_each_entry_safe(rt, safe, &ul->head, dst.rt_uncached) {
 			struct inet6_dev *rt_idev = rt->rt6i_idev;
 			struct net_device *rt_dev = rt->dst.dev;
 			bool handled = false;
@@ -188,7 +188,7 @@ static void rt6_uncached_list_flush_dev(
 				handled = true;
 			}
 			if (handled)
-				list_move(&rt->rt6i_uncached,
+				list_move(&rt->dst.rt_uncached,
 					  &ul->quarantine);
 		}
 		spin_unlock_bh(&ul->lock);
@@ -334,7 +334,7 @@ static const struct rt6_info ip6_blk_hol
 static void rt6_info_init(struct rt6_info *rt)
 {
 	memset_after(rt, 0, dst);
-	INIT_LIST_HEAD(&rt->rt6i_uncached);
+	INIT_LIST_HEAD(&rt->dst.rt_uncached);
 }
 
 /* allocate dst with ip6_dst_ops */
@@ -2638,7 +2638,7 @@ struct dst_entry *ip6_route_output_flags
 	dst = ip6_route_output_flags_noref(net, sk, fl6, flags);
 	rt6 = (struct rt6_info *)dst;
 	/* For dst cached in uncached_list, refcnt is already taken. */
-	if (list_empty(&rt6->rt6i_uncached) && !dst_hold_safe(dst)) {
+	if (list_empty(&rt6->dst.rt_uncached) && !dst_hold_safe(dst)) {
 		dst = &net->ipv6.ip6_null_entry->dst;
 		dst_hold(dst);
 	}
@@ -2748,7 +2748,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry
 	from = rcu_dereference(rt->from);
 
 	if (from && (rt->rt6i_flags & RTF_PCPU ||
-	    unlikely(!list_empty(&rt->rt6i_uncached))))
+	    unlikely(!list_empty(&rt->dst.rt_uncached))))
 		dst_ret = rt6_dst_from_check(rt, from, cookie);
 	else
 		dst_ret = rt6_check(rt, from, cookie);
@@ -6477,7 +6477,7 @@ static int __net_init ip6_route_net_init
 	net->ipv6.ip6_null_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_null_entry->dst,
 			 ip6_template_metrics, true);
-	INIT_LIST_HEAD(&net->ipv6.ip6_null_entry->rt6i_uncached);
+	INIT_LIST_HEAD(&net->ipv6.ip6_null_entry->dst.rt_uncached);
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	net->ipv6.fib6_has_custom_rules = false;
@@ -6489,7 +6489,7 @@ static int __net_init ip6_route_net_init
 	net->ipv6.ip6_prohibit_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_prohibit_entry->dst,
 			 ip6_template_metrics, true);
-	INIT_LIST_HEAD(&net->ipv6.ip6_prohibit_entry->rt6i_uncached);
+	INIT_LIST_HEAD(&net->ipv6.ip6_prohibit_entry->dst.rt_uncached);
 
 	net->ipv6.ip6_blk_hole_entry = kmemdup(&ip6_blk_hole_entry_template,
 					       sizeof(*net->ipv6.ip6_blk_hole_entry),
@@ -6499,7 +6499,7 @@ static int __net_init ip6_route_net_init
 	net->ipv6.ip6_blk_hole_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_blk_hole_entry->dst,
 			 ip6_template_metrics, true);
-	INIT_LIST_HEAD(&net->ipv6.ip6_blk_hole_entry->rt6i_uncached);
+	INIT_LIST_HEAD(&net->ipv6.ip6_blk_hole_entry->dst.rt_uncached);
 #ifdef CONFIG_IPV6_SUBTREES
 	net->ipv6.fib6_routes_require_src = 0;
 #endif
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -89,7 +89,7 @@ static int xfrm6_fill_dst(struct xfrm_ds
 	xdst->u.rt6.rt6i_gateway = rt->rt6i_gateway;
 	xdst->u.rt6.rt6i_dst = rt->rt6i_dst;
 	xdst->u.rt6.rt6i_src = rt->rt6i_src;
-	INIT_LIST_HEAD(&xdst->u.rt6.rt6i_uncached);
+	INIT_LIST_HEAD(&xdst->u.rt6.dst.rt_uncached);
 	rt6_uncached_list_add(&xdst->u.rt6);
 
 	return 0;
@@ -121,7 +121,7 @@ static void xfrm6_dst_destroy(struct dst
 	if (likely(xdst->u.rt6.rt6i_idev))
 		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	dst_destroy_metrics_generic(dst);
-	if (xdst->u.rt6.rt6i_uncached_list)
+	if (xdst->u.rt6.dst.rt_uncached_list)
 		rt6_uncached_list_del(&xdst->u.rt6);
 	xfrm_dst_destroy(xdst);
 }

