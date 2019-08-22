Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE6D991FA
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 13:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388170AbfHVLVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 07:21:08 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46064 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726844AbfHVLVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 07:21:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i0l9M-00033b-0K; Thu, 22 Aug 2019 13:21:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     stable@vger.kernel.org
Cc:     vakul.garg@nxp.com, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.14.y stable] xfrm: policy: remove pcpu policy cache
Date:   Thu, 22 Aug 2019 13:21:09 +0200
Message-Id: <20190822112109.13269-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <DB7PR04MB46208495C3ADCCD58B1131C88BA50@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB46208495C3ADCCD58B1131C88BA50@DB7PR04MB4620.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 Vakul Garg reports traffic going via ipsec tunnels will cause the kernel
 to spin in an infinite loop due to xfrm policy reference count
 overflowing and becoming 0.
 The refcount leak is in the pcpu cache.  Instead of fixing this, just
 remove the pcpu cache -- its not present in any other stable release.
 Vakul reported that this patch fixes the problem.

 There are no major deviations from the upstream revert; conflicts
 were only due to context.

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

