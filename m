Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B333B5F0F
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 15:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbhF1Nha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 09:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232158AbhF1NhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 09:37:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A26AC6145F;
        Mon, 28 Jun 2021 13:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624887279;
        bh=0nXYrEEfuMc45WiOyMWXMVBqmZmqmLptBufGjfPEi/Y=;
        h=From:To:Cc:Subject:Date:From;
        b=dDWycofUnRPVqAD3+/8zFPdWD2bRv00uY2WGv1toTe+mymd1xse1sVcElE3HmAf7P
         rc8gzG1rqENnadENDGj6qRIaAGV/z1Dir1Z7HB5eTZVvT23FchlK/YN4KKGPQv62mC
         unhjyHpwhar0KzLzOaHIxvK+f8yhIMdC1tlIgN9TBNFDRF7q7Wm6SMFOlRm/oa50Lz
         BvFKK/OefAdr0FWYkhKshpQ6ongncbc6lAjS+8txdiBCdI4CsUzslShfMPXOAhsXFb
         DhvdPAG4IEedUz8VGzi9kUJ6/NeqfzhkKNtxNO3XhKllhHt7IU4LKGbhjETNXYme2i
         gqnlAzLYWjD4g==
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        stable@vger.kernel.org, Varad Gautam <varad.gautam@suse.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH] xfrm: Fix RCU vs hash_resize_mutex lock inversion
Date:   Mon, 28 Jun 2021 15:34:28 +0200
Message-Id: <20210628133428.5660-1-frederic@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_bydst_resize() calls synchronize_rcu() while holding
hash_resize_mutex. But then on PREEMPT_RT configurations,
xfrm_policy_lookup_bytype() may acquire that mutex while running in an
RCU read side critical section. This results in a deadlock.

In fact the scope of hash_resize_mutex is way beyond the purpose of
xfrm_policy_lookup_bytype() to just fetch a coherent and stable policy
for a given destination/direction, along with other details.

The lower level net->xfrm.xfrm_policy_lock, which among other things
protects per destination/direction references to policy entries, is
enough to serialize and benefit from priority inheritance against the
write side. As a bonus, it makes it officially a per network namespace
synchronization business where a policy table resize on namespace A
shouldn't block a policy lookup on namespace B.

Fixes: 77cc278f7b20 (xfrm: policy: Use sequence counters with associated lock)
Cc: stable@vger.kernel.org
Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Varad Gautam <varad.gautam@suse.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/net/netns/xfrm.h |  1 +
 net/xfrm/xfrm_policy.c   | 17 ++++++++---------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index e816b6a3ef2b..9b376b87bd54 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -74,6 +74,7 @@ struct netns_xfrm {
 #endif
 	spinlock_t		xfrm_state_lock;
 	seqcount_spinlock_t	xfrm_state_hash_generation;
+	seqcount_spinlock_t	xfrm_policy_hash_generation;
 
 	spinlock_t xfrm_policy_lock;
 	struct mutex xfrm_cfg_mutex;
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ce500f847b99..46a6d15b66d6 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -155,7 +155,6 @@ static struct xfrm_policy_afinfo const __rcu *xfrm_policy_afinfo[AF_INET6 + 1]
 						__read_mostly;
 
 static struct kmem_cache *xfrm_dst_cache __ro_after_init;
-static __read_mostly seqcount_mutex_t xfrm_policy_hash_generation;
 
 static struct rhashtable xfrm_policy_inexact_table;
 static const struct rhashtable_params xfrm_pol_inexact_params;
@@ -585,7 +584,7 @@ static void xfrm_bydst_resize(struct net *net, int dir)
 		return;
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
-	write_seqcount_begin(&xfrm_policy_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
 
 	odst = rcu_dereference_protected(net->xfrm.policy_bydst[dir].table,
 				lockdep_is_held(&net->xfrm.xfrm_policy_lock));
@@ -596,7 +595,7 @@ static void xfrm_bydst_resize(struct net *net, int dir)
 	rcu_assign_pointer(net->xfrm.policy_bydst[dir].table, ndst);
 	net->xfrm.policy_bydst[dir].hmask = nhashmask;
 
-	write_seqcount_end(&xfrm_policy_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_policy_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 
 	synchronize_rcu();
@@ -1245,7 +1244,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 	} while (read_seqretry(&net->xfrm.policy_hthresh.lock, seq));
 
 	spin_lock_bh(&net->xfrm.xfrm_policy_lock);
-	write_seqcount_begin(&xfrm_policy_hash_generation);
+	write_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
 
 	/* make sure that we can insert the indirect policies again before
 	 * we start with destructive action.
@@ -1354,7 +1353,7 @@ static void xfrm_hash_rebuild(struct work_struct *work)
 
 out_unlock:
 	__xfrm_policy_inexact_flush(net);
-	write_seqcount_end(&xfrm_policy_hash_generation);
+	write_seqcount_end(&net->xfrm.xfrm_policy_hash_generation);
 	spin_unlock_bh(&net->xfrm.xfrm_policy_lock);
 
 	mutex_unlock(&hash_resize_mutex);
@@ -2095,9 +2094,9 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	rcu_read_lock();
  retry:
 	do {
-		sequence = read_seqcount_begin(&xfrm_policy_hash_generation);
+		sequence = read_seqcount_begin(&net->xfrm.xfrm_policy_hash_generation);
 		chain = policy_hash_direct(net, daddr, saddr, family, dir);
-	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
+	} while (read_seqcount_retry(&net->xfrm.xfrm_policy_hash_generation, sequence));
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
@@ -2128,7 +2127,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 	}
 
 skip_inexact:
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
+	if (read_seqcount_retry(&net->xfrm.xfrm_policy_hash_generation, sequence))
 		goto retry;
 
 	if (ret && !xfrm_pol_hold_rcu(ret))
@@ -4084,6 +4083,7 @@ static int __net_init xfrm_net_init(struct net *net)
 	/* Initialize the per-net locks here */
 	spin_lock_init(&net->xfrm.xfrm_state_lock);
 	spin_lock_init(&net->xfrm.xfrm_policy_lock);
+	seqcount_spinlock_init(&net->xfrm.xfrm_policy_hash_generation, &net->xfrm.xfrm_policy_lock);
 	mutex_init(&net->xfrm.xfrm_cfg_mutex);
 
 	rv = xfrm_statistics_init(net);
@@ -4128,7 +4128,6 @@ void __init xfrm_init(void)
 {
 	register_pernet_subsys(&xfrm_net_ops);
 	xfrm_dev_init();
-	seqcount_mutex_init(&xfrm_policy_hash_generation, &hash_resize_mutex);
 	xfrm_input_init();
 
 #ifdef CONFIG_XFRM_ESPINTCP
-- 
2.25.1

