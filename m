Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 551E46E6A71
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 19:04:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231432AbjDRREm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 13:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjDRREl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 13:04:41 -0400
X-Greylist: delayed 572 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 18 Apr 2023 10:04:36 PDT
Received: from ns.iliad.fr (ns.iliad.fr [212.27.33.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD466A6A
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 10:04:36 -0700 (PDT)
Received: from ns.iliad.fr (localhost [127.0.0.1])
        by ns.iliad.fr (Postfix) with ESMTP id 8D10D200D6;
        Tue, 18 Apr 2023 18:55:02 +0200 (CEST)
Received: from sakura.iliad.local (freebox.vlq16.iliad.fr [213.36.7.13])
        by ns.iliad.fr (Postfix) with ESMTP id 71D0B20066;
        Tue, 18 Apr 2023 18:55:02 +0200 (CEST)
From:   Maxime Bizon <mbizon@freebox.fr>
To:     davem@davemloft.net, edumazet@google.com, tglx@linutronix.de,
        wangyang.guo@intel.com, netdev@vger.kernel.org
Cc:     Maxime Bizon <mbizon@freebox.fr>
Subject: [PATCH net-next] net: dst: fix missing initialization of rt_uncached
Date:   Tue, 18 Apr 2023 18:54:26 +0200
Message-Id: <20230418165426.1869051-1-mbizon@freebox.fr>
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
Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
---
 net/core/dst.c          | 1 +
 net/ipv4/xfrm4_policy.c | 4 +---
 net/ipv6/route.c        | 1 -
 net/ipv6/xfrm6_policy.c | 4 +---
 4 files changed, 3 insertions(+), 7 deletions(-)

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

