Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5871F97FBD
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 18:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfHUQMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 12:12:02 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:41342 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727041AbfHUQMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 12:12:02 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i0TDL-0005Nn-Mp; Wed, 21 Aug 2019 18:11:59 +0200
Date:   Wed, 21 Aug 2019 18:11:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Help needed - Kernel lockup while running ipsec
Message-ID: <20190821161159.GA20113@breakpoint.cc>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820093800.GN2588@breakpoint.cc>
 <DB7PR04MB46204E237BB1E495FC799E588BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <DB7PR04MB4620B6ACB01BFA338ADAED048BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <DB7PR04MB46204E4A3EBD5DD665F492D38BAA0@DB7PR04MB4620.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <DB7PR04MB46204E4A3EBD5DD665F492D38BAA0@DB7PR04MB4620.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Vakul Garg <vakul.garg@nxp.com> wrote:
> > Policy refcount is decreasing properly on 4.19.
> > Same should be on the latest kernel too.
> 
> On kernel-4.14, I find dst_release() is getting called through xfrm_output_one().
> However since dst->__refcnt gets decremented to '1', 
> the call_rcu(&dst->rcu_head, dst_destroy_rcu) is not invoked. 
> 
> On kernel-4.19, dst->__refcnt gets decremented to '0', hence things fall in place and 
> dst_destroy_rcu() eventually executes.
> 
> Any further help/pointers for kernel-4.14 would be deeply appreciated.

Can you try getting rid of the pcpu dst cache?

I had a look at 4.14-stable and it at least lacks 2950278d2d04ff531.

I've attached an (untested) revert of the pcpu cache (its gone in 4.19
and onwards).



--r5Pyd7+fXNt84Ff3
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-xfrm-policy-remove-pcpu-policy-cache.patch"

From 058cb6719223d10dc57743dbf5c20424f118e7e7 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Mon, 25 Jun 2018 17:26:02 +0200
Subject: [PATCH 4.4.14.y] xfrm: policy: remove pcpu policy cache

commit e4db5b61c572475bbbcf63e3c8a2606bfccf2c9d upstream.

Kristian Evensen says:
  In a project I am involved in, we are running ipsec (Strongswan) on
  different mt7621-based routers. Each router is configured as an
  initiator and has around ~30 tunnels to different responders (running
  on misc. devices). Before the flow cache was removed (kernel 4.9), we
  got a combined throughput of around 70Mbit/s for all tunnels on one
  router. However, we recently switched to kernel 4.14 (4.14.48), and
  the total throughput is somewhere around 57Mbit/s (best-case). I.e., a
  drop of around 20%. Reverting the flow cache removal restores, as
  expected, performance levels to that of kernel 4.9.

When pcpu xdst exists, it has to be validated first before it can be
used.

A negative hit thus increases cost vs. no-cache.

As number of tunnels increases, hit rate decreases so this pcpu caching
isn't a viable strategy.

Furthermore, the xdst cache also needs to run with BH off, so when
removing this the bh disable/enable pairs can be removed too.

Kristian tested a 4.14.y backport of this change and reported
increased performance:

  In our tests, the throughput reduction has been reduced from around -20%
  to -5%. We also see that the overall throughput is independent of the
  number of tunnels, while before the throughput was reduced as the number
  of tunnels increased.

Reported-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     |   1 -
 net/xfrm/xfrm_device.c |  10 ---
 net/xfrm/xfrm_policy.c | 138 +----------------------------------------
 net/xfrm/xfrm_state.c  |   5 +-
 4 files changed, 3 insertions(+), 151 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index db99efb2d1d0..bdf185ae93db 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -323,7 +323,6 @@ int xfrm_policy_register_afinfo(const struct xfrm_policy_afinfo *afinfo, int fam
 void xfrm_policy_unregister_afinfo(const struct xfrm_policy_afinfo *afinfo);
 void km_policy_notify(struct xfrm_policy *xp, int dir,
 		      const struct km_event *c);
-void xfrm_policy_cache_flush(void);
 void km_state_notify(struct xfrm_state *x, const struct km_event *c);
 
 struct xfrm_tmpl;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 30e5746085b8..4e458fd9236a 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -153,12 +153,6 @@ static int xfrm_dev_register(struct net_device *dev)
 	return NOTIFY_DONE;
 }
 
-static int xfrm_dev_unregister(struct net_device *dev)
-{
-	xfrm_policy_cache_flush();
-	return NOTIFY_DONE;
-}
-
 static int xfrm_dev_feat_change(struct net_device *dev)
 {
 	if ((dev->features & NETIF_F_HW_ESP) && !dev->xfrmdev_ops)
@@ -178,7 +172,6 @@ static int xfrm_dev_down(struct net_device *dev)
 	if (dev->features & NETIF_F_HW_ESP)
 		xfrm_dev_state_flush(dev_net(dev), dev, true);
 
-	xfrm_policy_cache_flush();
 	return NOTIFY_DONE;
 }
 
@@ -190,9 +183,6 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
 	case NETDEV_REGISTER:
 		return xfrm_dev_register(dev);
 
-	case NETDEV_UNREGISTER:
-		return xfrm_dev_unregister(dev);
-
 	case NETDEV_FEAT_CHANGE:
 		return xfrm_dev_feat_change(dev);
 
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 70ec57b887f6..b5006a091fd6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -45,8 +45,6 @@ struct xfrm_flo {
 	u8 flags;
 };
 
-static DEFINE_PER_CPU(struct xfrm_dst *, xfrm_last_dst);
-static struct work_struct *xfrm_pcpu_work __read_mostly;
 static DEFINE_SPINLOCK(xfrm_policy_afinfo_lock);
 static struct xfrm_policy_afinfo const __rcu *xfrm_policy_afinfo[AF_INET6 + 1]
 						__read_mostly;
@@ -1715,108 +1713,6 @@ static int xfrm_expand_policies(const struct flowi *fl, u16 family,
 
 }
 
-static void xfrm_last_dst_update(struct xfrm_dst *xdst, struct xfrm_dst *old)
-{
-	this_cpu_write(xfrm_last_dst, xdst);
-	if (old)
-		dst_release(&old->u.dst);
-}
-
-static void __xfrm_pcpu_work_fn(void)
-{
-	struct xfrm_dst *old;
-
-	old = this_cpu_read(xfrm_last_dst);
-	if (old && !xfrm_bundle_ok(old))
-		xfrm_last_dst_update(NULL, old);
-}
-
-static void xfrm_pcpu_work_fn(struct work_struct *work)
-{
-	local_bh_disable();
-	rcu_read_lock();
-	__xfrm_pcpu_work_fn();
-	rcu_read_unlock();
-	local_bh_enable();
-}
-
-void xfrm_policy_cache_flush(void)
-{
-	struct xfrm_dst *old;
-	bool found = 0;
-	int cpu;
-
-	might_sleep();
-
-	local_bh_disable();
-	rcu_read_lock();
-	for_each_possible_cpu(cpu) {
-		old = per_cpu(xfrm_last_dst, cpu);
-		if (old && !xfrm_bundle_ok(old)) {
-			if (smp_processor_id() == cpu) {
-				__xfrm_pcpu_work_fn();
-				continue;
-			}
-			found = true;
-			break;
-		}
-	}
-
-	rcu_read_unlock();
-	local_bh_enable();
-
-	if (!found)
-		return;
-
-	get_online_cpus();
-
-	for_each_possible_cpu(cpu) {
-		bool bundle_release;
-
-		rcu_read_lock();
-		old = per_cpu(xfrm_last_dst, cpu);
-		bundle_release = old && !xfrm_bundle_ok(old);
-		rcu_read_unlock();
-
-		if (!bundle_release)
-			continue;
-
-		if (cpu_online(cpu)) {
-			schedule_work_on(cpu, &xfrm_pcpu_work[cpu]);
-			continue;
-		}
-
-		rcu_read_lock();
-		old = per_cpu(xfrm_last_dst, cpu);
-		if (old && !xfrm_bundle_ok(old)) {
-			per_cpu(xfrm_last_dst, cpu) = NULL;
-			dst_release(&old->u.dst);
-		}
-		rcu_read_unlock();
-	}
-
-	put_online_cpus();
-}
-
-static bool xfrm_xdst_can_reuse(struct xfrm_dst *xdst,
-				struct xfrm_state * const xfrm[],
-				int num)
-{
-	const struct dst_entry *dst = &xdst->u.dst;
-	int i;
-
-	if (xdst->num_xfrms != num)
-		return false;
-
-	for (i = 0; i < num; i++) {
-		if (!dst || dst->xfrm != xfrm[i])
-			return false;
-		dst = dst->child;
-	}
-
-	return xfrm_bundle_ok(xdst);
-}
-
 static struct xfrm_dst *
 xfrm_resolve_and_create_bundle(struct xfrm_policy **pols, int num_pols,
 			       const struct flowi *fl, u16 family,
@@ -1824,7 +1720,7 @@ xfrm_resolve_and_create_bundle(struct xfrm_policy **pols, int num_pols,
 {
 	struct net *net = xp_net(pols[0]);
 	struct xfrm_state *xfrm[XFRM_MAX_DEPTH];
-	struct xfrm_dst *xdst, *old;
+	struct xfrm_dst *xdst;
 	struct dst_entry *dst;
 	int err;
 
@@ -1839,21 +1735,6 @@ xfrm_resolve_and_create_bundle(struct xfrm_policy **pols, int num_pols,
 		return ERR_PTR(err);
 	}
 
-	xdst = this_cpu_read(xfrm_last_dst);
-	if (xdst &&
-	    xdst->u.dst.dev == dst_orig->dev &&
-	    xdst->num_pols == num_pols &&
-	    memcmp(xdst->pols, pols,
-		   sizeof(struct xfrm_policy *) * num_pols) == 0 &&
-	    xfrm_xdst_can_reuse(xdst, xfrm, err)) {
-		dst_hold(&xdst->u.dst);
-		while (err > 0)
-			xfrm_state_put(xfrm[--err]);
-		return xdst;
-	}
-
-	old = xdst;
-
 	dst = xfrm_bundle_create(pols[0], xfrm, err, fl, dst_orig);
 	if (IS_ERR(dst)) {
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTBUNDLEGENERROR);
@@ -1866,9 +1747,6 @@ xfrm_resolve_and_create_bundle(struct xfrm_policy **pols, int num_pols,
 	memcpy(xdst->pols, pols, sizeof(struct xfrm_policy *) * num_pols);
 	xdst->policy_genid = atomic_read(&pols[0]->genid);
 
-	atomic_set(&xdst->u.dst.__refcnt, 2);
-	xfrm_last_dst_update(xdst, old);
-
 	return xdst;
 }
 
@@ -2069,11 +1947,8 @@ xfrm_bundle_lookup(struct net *net, const struct flowi *fl, u16 family, u8 dir,
 	if (num_xfrms <= 0)
 		goto make_dummy_bundle;
 
-	local_bh_disable();
 	xdst = xfrm_resolve_and_create_bundle(pols, num_pols, fl, family,
 					      xflo->dst_orig);
-	local_bh_enable();
-
 	if (IS_ERR(xdst)) {
 		err = PTR_ERR(xdst);
 		if (err != -EAGAIN)
@@ -2160,11 +2035,9 @@ struct dst_entry *xfrm_lookup(struct net *net, struct dst_entry *dst_orig,
 				goto no_transform;
 			}
 
-			local_bh_disable();
 			xdst = xfrm_resolve_and_create_bundle(
 					pols, num_pols, fl,
 					family, dst_orig);
-			local_bh_enable();
 
 			if (IS_ERR(xdst)) {
 				xfrm_pols_put(pols, num_pols);
@@ -2992,15 +2865,6 @@ static struct pernet_operations __net_initdata xfrm_net_ops = {
 
 void __init xfrm_init(void)
 {
-	int i;
-
-	xfrm_pcpu_work = kmalloc_array(NR_CPUS, sizeof(*xfrm_pcpu_work),
-				       GFP_KERNEL);
-	BUG_ON(!xfrm_pcpu_work);
-
-	for (i = 0; i < NR_CPUS; i++)
-		INIT_WORK(&xfrm_pcpu_work[i], xfrm_pcpu_work_fn);
-
 	register_pernet_subsys(&xfrm_net_ops);
 	seqcount_init(&xfrm_policy_hash_generation);
 	xfrm_input_init();
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 0cd2bdf3b217..7c093de68780 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -735,10 +735,9 @@ int xfrm_state_flush(struct net *net, u8 proto, bool task_valid)
 	}
 out:
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
-	if (cnt) {
+	if (cnt)
 		err = 0;
-		xfrm_policy_cache_flush();
-	}
+
 	return err;
 }
 EXPORT_SYMBOL(xfrm_state_flush);
-- 
2.21.0


--r5Pyd7+fXNt84Ff3--
