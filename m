Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B7F6A7795
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 00:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCAXMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 18:12:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjCAXM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 18:12:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47077126F9;
        Wed,  1 Mar 2023 15:12:27 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1677712344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=opAsMuDJOZgaPfax6rnMMsPpGdf3lfCykqhuzz0Srj4=;
        b=ZFCYbbuo6s5J5pirORhC15tHQ8ebscHlF62G/NHUw6uyptSEbWTg7SApFrEYPFsbDhBnYd
        qATf5H8xzUuyoyZjuWPhQKfiaDFF7R7oYw5FUJSk2fvtt4eeu5HlM82QgpDo5TNX3c1U9p
        aGtZ8ahe1tA65tN5fo2MrZlGmNXoAwtbwFfd54x58Y+Mv+tTqnOyelgywk5FC8wrGkoDuK
        gUUAafoolgACthrUpg2WqcZEknaNdhfCD2d+bWeJZvnGNimH/fUTSoW0gTY7HRpuGF7gqR
        rGa4C2mc1WJWpdy5LiFDEt/FhUMfpp8DJi/RZwRV2N1gwjgq26/3OFa+RzCN6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1677712344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=opAsMuDJOZgaPfax6rnMMsPpGdf3lfCykqhuzz0Srj4=;
        b=Xp5XI/fYC8xA+pOY7DrpxcJgDS3EGDvvMjBhNiHZQoe7HiEZgiGaAzUL33aZvXyRNdX8p3
        18gO4uyBpbGi2/Cw==
To:     Eric Dumazet <edumazet@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linuxfoundation.org>, x86@kernel.org,
        Wangyang Guo <wangyang.guo@intel.com>,
        Arjan van De Ven <arjan@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [patch 1/3] net: dst: Prevent false sharing vs.
 dst_entry::__refcnt
In-Reply-To: <875yblmq83.ffs@tglx>
References: <20230228132118.978145284@linutronix.de>
 <20230228132910.934296889@linutronix.de>
 <CANn89iKM6yMP2Doy0MuCrfX1LASPFt_OnpPY-aNg+hu=F3W7AA@mail.gmail.com>
 <875yblmq83.ffs@tglx>
Date:   Thu, 02 Mar 2023 00:12:23 +0100
Message-ID: <87edq8kqw8.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 28 2023 at 22:31, Thomas Gleixner wrote:
> On Tue, Feb 28 2023 at 16:17, Eric Dumazet wrote:
>> Instead of mere pads, add some unions, and let rt6i_uncached/rt6i_uncached_list
>> use them.
>
> If I understand correctly, you suggest to move
>
>    rt6_info::rt6i_uncached[_list], rtable::rt_uncached[_list]
>    
> into struct dst_entry and fixup the usage sites, right?
>
> I don't see why that would need a union. dst_entry::rt_uncached[_list]
> would work for both, no?

So I came up with the below.

rt6_info shrinks from 232 to 224 bytes. rtable size is unchanged

Thanks,

        tglx
---

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
@@ -104,7 +104,7 @@ static inline struct dst_entry *ip6_rout
 static inline void ip6_rt_put_flags(struct rt6_info *rt, int flags)
 {
 	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
-	    !list_empty(&rt->rt6i_uncached))
+	    !list_empty(&rt->dst.rt_uncached))
 		ip6_rt_put(rt);
 }
 
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -81,9 +81,6 @@ struct rtable {
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
@@ -6483,7 +6483,7 @@ static int __net_init ip6_route_net_init
 	net->ipv6.ip6_null_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_null_entry->dst,
 			 ip6_template_metrics, true);
-	INIT_LIST_HEAD(&net->ipv6.ip6_null_entry->rt6i_uncached);
+	INIT_LIST_HEAD(&net->ipv6.ip6_null_entry->dst.rt_uncached);
 
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
 	net->ipv6.fib6_has_custom_rules = false;
@@ -6495,7 +6495,7 @@ static int __net_init ip6_route_net_init
 	net->ipv6.ip6_prohibit_entry->dst.ops = &net->ipv6.ip6_dst_ops;
 	dst_init_metrics(&net->ipv6.ip6_prohibit_entry->dst,
 			 ip6_template_metrics, true);
-	INIT_LIST_HEAD(&net->ipv6.ip6_prohibit_entry->rt6i_uncached);
+	INIT_LIST_HEAD(&net->ipv6.ip6_prohibit_entry->dst.rt_uncached);
 
 	net->ipv6.ip6_blk_hole_entry = kmemdup(&ip6_blk_hole_entry_template,
 					       sizeof(*net->ipv6.ip6_blk_hole_entry),
@@ -6505,7 +6505,7 @@ static int __net_init ip6_route_net_init
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
