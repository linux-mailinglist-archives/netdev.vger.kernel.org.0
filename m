Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442F33DFBAB
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 09:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235752AbhHDHDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 03:03:49 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41826 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235720AbhHDHDq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 03:03:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D73BB205E3;
        Wed,  4 Aug 2021 09:03:32 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id X0KoHjyTzM4c; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C2AE2205A4;
        Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id BDA9C80004A;
        Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 4 Aug 2021 09:03:31 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 4 Aug 2021
 09:03:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 10DD531808F6; Wed,  4 Aug 2021 09:03:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/6] xfrm: Fix RCU vs hash_resize_mutex lock inversion
Date:   Wed, 4 Aug 2021 09:03:26 +0200
Message-ID: <20210804070329.1357123-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210804070329.1357123-1-steffen.klassert@secunet.com>
References: <20210804070329.1357123-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Frederic Weisbecker <frederic@kernel.org>

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
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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

