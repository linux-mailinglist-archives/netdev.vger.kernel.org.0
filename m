Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6A46E9BBD
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjDTSgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjDTSgC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:36:02 -0400
X-Greylist: delayed 621 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 20 Apr 2023 11:35:35 PDT
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C646A272D
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 11:35:35 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 7B9712087D;
        Thu, 20 Apr 2023 20:25:12 +0200 (CEST)
Received: from sakura.iliad.local (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 5EBC6201FD;
        Thu, 20 Apr 2023 20:25:12 +0200 (CEST)
From:   Maxime Bizon <mbizon@freebox.fr>
To:     davem@davemloft.net, edumazet@google.com, tglx@linutronix.de,
        wangyang.guo@intel.com, netdev@vger.kernel.org
Cc:     Maxime Bizon <mbizon@freebox.fr>,
        kernel test robot <oliver.sang@intel.com>,
        David Ahern <dsahern@kernel.org>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH net-next v2] net: dst: fix missing initialization of rt_uncached
Date:   Thu, 20 Apr 2023 20:25:08 +0200
Message-Id: <20230420182508.2417582-1-mbizon@freebox.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_alloc_dst() followed by xfrm4_dst_destroy(), without a
xfrm4_fill_dst() call in between, causes the following BUG:

 BUG: spinlock bad magic on CPU#0, fbxhostapd/732
  lock: 0x890b7668, .magic: 890b7668, .owner: <none>/-1, .owner_cpu: 0
 CPU: 0 PID: 732 Comm: fbxhostapd Not tainted 6.3.0-rc6-next-20230414-00613-ge8de66369925-dirty #9
 Hardware name: Marvell Kirkwood (Flattened Device Tree)
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x28/0x30
  dump_stack_lvl from do_raw_spin_lock+0x20/0x80
  do_raw_spin_lock from rt_del_uncached_list+0x30/0x64
  rt_del_uncached_list from xfrm4_dst_destroy+0x3c/0xbc
  xfrm4_dst_destroy from dst_destroy+0x5c/0xb0
  dst_destroy from rcu_process_callbacks+0xc4/0xec
  rcu_process_callbacks from __do_softirq+0xb4/0x22c
  __do_softirq from call_with_stack+0x1c/0x24
  call_with_stack from do_softirq+0x60/0x6c
  do_softirq from __local_bh_enable_ip+0xa0/0xcc

Patch "net: dst: Prevent false sharing vs. dst_entry:: __refcnt" moved
rt_uncached and rt_uncached_list fields from rtable struct to dst
struct, so they are more zeroed by memset_after(xdst, 0, u.dst) in
xfrm_alloc_dst().

Note that rt_uncached (list_head) was never properly initialized at
alloc time, but xfrm[46]_dst_destroy() is written in such a way that
it was not an issue thanks to the memset:

	if (xdst->u.rt.dst.rt_uncached_list)
		rt_del_uncached_list(&xdst->u.rt);

The route code does it the other way around: rt_uncached_list is
assumed to be valid IIF rt_uncached list_head is not empty:

void rt_del_uncached_list(struct rtable *rt)
{
        if (!list_empty(&rt->dst.rt_uncached)) {
                struct uncached_list *ul = rt->dst.rt_uncached_list;

                spin_lock_bh(&ul->lock);
                list_del_init(&rt->dst.rt_uncached);
                spin_unlock_bh(&ul->lock);
        }
}

This patch adds mandatory rt_uncached list_head initialization in
generic dst_init(), and adapt xfrm[46]_dst_destroy logic to match the
rest of the code.

Fixes: d288a162dd1c ("net: dst: Prevent false sharing vs. dst_entry:: __refcnt")
Reported-by: kernel test robot <oliver.sang@intel.com>
Link: https://lore.kernel.org/oe-lkp/202304162125.18b7bcdd-oliver.sang@intel.com
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
CC: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 net/core/dst.c          | 1 +
 net/ipv4/route.c        | 4 ----
 net/ipv4/xfrm4_policy.c | 4 +---
 net/ipv6/route.c        | 1 -
 net/ipv6/xfrm6_policy.c | 4 +---
 5 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 3247e84045ca..79d9306ad1ee 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -67,6 +67,7 @@ void dst_init(struct dst_entry *dst, struct dst_ops *ops,
 #endif
 	dst->lwtstate = NULL;
 	rcuref_init(&dst->__rcuref, initial_ref);
+	INIT_LIST_HEAD(&dst->rt_uncached);
 	dst->__use = 0;
 	dst->lastuse = jiffies;
 	dst->flags = flags;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 2a3d14d95ada..98d7e6ba7493 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1644,7 +1644,6 @@ struct rtable *rt_dst_alloc(struct net_device *dev,
 		rt->rt_uses_gateway = 0;
 		rt->rt_gw_family = 0;
 		rt->rt_gw4 = 0;
-		INIT_LIST_HEAD(&rt->dst.rt_uncached);
 
 		rt->dst.output = ip_output;
 		if (flags & RTCF_LOCAL)
@@ -1675,7 +1674,6 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
 			new_rt->rt_gw4 = rt->rt_gw4;
 		else if (rt->rt_gw_family == AF_INET6)
 			new_rt->rt_gw6 = rt->rt_gw6;
-		INIT_LIST_HEAD(&new_rt->dst.rt_uncached);
 
 		new_rt->dst.input = rt->dst.input;
 		new_rt->dst.output = rt->dst.output;
@@ -2858,8 +2856,6 @@ struct dst_entry *ipv4_blackhole_route(struct net *net, struct dst_entry *dst_or
 			rt->rt_gw4 = ort->rt_gw4;
 		else if (rt->rt_gw_family == AF_INET6)
 			rt->rt_gw6 = ort->rt_gw6;
-
-		INIT_LIST_HEAD(&rt->dst.rt_uncached);
 	}
 
 	dst_release(dst_orig);
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index 47861c8b7340..9403bbaf1b61 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -91,7 +91,6 @@ static int xfrm4_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 		xdst->u.rt.rt_gw6 = rt->rt_gw6;
 	xdst->u.rt.rt_pmtu = rt->rt_pmtu;
 	xdst->u.rt.rt_mtu_locked = rt->rt_mtu_locked;
-	INIT_LIST_HEAD(&xdst->u.rt.dst.rt_uncached);
 	rt_add_uncached_list(&xdst->u.rt);
 
 	return 0;
@@ -121,8 +120,7 @@ static void xfrm4_dst_destroy(struct dst_entry *dst)
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 
 	dst_destroy_metrics_generic(dst);
-	if (xdst->u.rt.dst.rt_uncached_list)
-		rt_del_uncached_list(&xdst->u.rt);
+	rt_del_uncached_list(&xdst->u.rt);
 	xfrm_dst_destroy(xdst);
 }
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 35085fc0cf15..e3aec46bd466 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -334,7 +334,6 @@ static const struct rt6_info ip6_blk_hole_entry_template = {
 static void rt6_info_init(struct rt6_info *rt)
 {
 	memset_after(rt, 0, dst);
-	INIT_LIST_HEAD(&rt->dst.rt_uncached);
 }
 
 /* allocate dst with ip6_dst_ops */
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index 2b493f8d0091..eecc5e59da17 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -89,7 +89,6 @@ static int xfrm6_fill_dst(struct xfrm_dst *xdst, struct net_device *dev,
 	xdst->u.rt6.rt6i_gateway = rt->rt6i_gateway;
 	xdst->u.rt6.rt6i_dst = rt->rt6i_dst;
 	xdst->u.rt6.rt6i_src = rt->rt6i_src;
-	INIT_LIST_HEAD(&xdst->u.rt6.dst.rt_uncached);
 	rt6_uncached_list_add(&xdst->u.rt6);
 
 	return 0;
@@ -121,8 +120,7 @@ static void xfrm6_dst_destroy(struct dst_entry *dst)
 	if (likely(xdst->u.rt6.rt6i_idev))
 		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	dst_destroy_metrics_generic(dst);
-	if (xdst->u.rt6.dst.rt_uncached_list)
-		rt6_uncached_list_del(&xdst->u.rt6);
+	rt6_uncached_list_del(&xdst->u.rt6);
 	xfrm_dst_destroy(xdst);
 }
 
-- 
2.34.1

