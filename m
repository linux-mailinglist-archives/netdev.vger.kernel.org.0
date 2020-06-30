Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B086020EDC2
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 07:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgF3FqB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 01:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728854AbgF3Fp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 01:45:59 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B46BC061755;
        Mon, 29 Jun 2020 22:45:59 -0700 (PDT)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1593495956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDImi88zFV81pjdnOgUX9XebIgS39WaOUsCCEI1b+mc=;
        b=IwtBZl1vrYKr/WuO2PKW9GtJpBZxUtVwp+y0+FhMma/ipCVm5fnIDd1uEnQdbxmsCjuKVd
        wk4nrSRexpVY979jcR9zPvdtlBXiaEJI9vTnmnsKvdkz/vfSNgIPTdE0itzt236Cfd/CUo
        mgbwQXCQubbqbb5zZ4/6J+7U+zVrAWe1eVH9GyojzU6zjUIgx5Nv6sK/rj9YmgmuYubT3/
        iDf97JeF5NxilmWPAhyQNZq0ajxvhsXtl2YqT+HM3E37S06bJgSTcj4pD42MBTPF0CoMTR
        xHRRTjeI+fdSx3qmABKsxlzsp1Kmtr/vUsQdbvARNvtKkwzgrS5IuxjHpl+qUA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1593495956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fDImi88zFV81pjdnOgUX9XebIgS39WaOUsCCEI1b+mc=;
        b=yPJijgJdbTsy/TB5q2S+gWyVLzjggeu+IciP6M6m+8z05YTyhuqQvUW/SUvV4TbJmai6d9
        qgP51HSV2bKXZcDQ==
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v3 12/20] xfrm: policy: Use sequence counters with associated lock
Date:   Tue, 30 Jun 2020 07:44:44 +0200
Message-Id: <20200630054452.3675847-13-a.darwish@linutronix.de>
In-Reply-To: <20200630054452.3675847-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200630054452.3675847-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sequence counter write side critical section must be protected by some
form of locking to serialize writers. If the serialization primitive is
not disabling preemption implicitly, preemption has to be explicitly
disabled before entering the sequence counter write side critical
section.

A plain seqcount_t does not contain the information of which lock must
be held when entering a write side critical section.

Use the new seqcount_spinlock_t and seqcount_mutex_t data types instead,
which allow to associate a lock with the sequence counter. This enables
lockdep to verify that the lock used for writer serialization is held
when the write side critical section is entered.

If lockdep is disabled this lock association is compiled out and has
neither storage size nor runtime overhead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 net/xfrm/xfrm_policy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 564aa6492e7c..732a940468b0 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -122,7 +122,7 @@ struct xfrm_pol_inexact_bin {
 	/* list containing '*:*' policies */
 	struct hlist_head hhead;
 
-	seqcount_t count;
+	seqcount_spinlock_t count;
 	/* tree sorted by daddr/prefix */
 	struct rb_root root_d;
 
@@ -155,7 +155,7 @@ static struct xfrm_policy_afinfo const __rcu *xfrm_policy_afinfo[AF_INET6 + 1]
 						__read_mostly;
 
 static struct kmem_cache *xfrm_dst_cache __ro_after_init;
-static __read_mostly seqcount_t xfrm_policy_hash_generation;
+static __read_mostly seqcount_mutex_t xfrm_policy_hash_generation;
 
 static struct rhashtable xfrm_policy_inexact_table;
 static const struct rhashtable_params xfrm_pol_inexact_params;
@@ -719,7 +719,7 @@ xfrm_policy_inexact_alloc_bin(const struct xfrm_policy *pol, u8 dir)
 	INIT_HLIST_HEAD(&bin->hhead);
 	bin->root_d = RB_ROOT;
 	bin->root_s = RB_ROOT;
-	seqcount_init(&bin->count);
+	seqcount_spinlock_init(&bin->count, &net->xfrm.xfrm_policy_lock);
 
 	prev = rhashtable_lookup_get_insert_key(&xfrm_policy_inexact_table,
 						&bin->k, &bin->head,
@@ -1906,7 +1906,7 @@ static int xfrm_policy_match(const struct xfrm_policy *pol,
 
 static struct xfrm_pol_inexact_node *
 xfrm_policy_lookup_inexact_addr(const struct rb_root *r,
-				seqcount_t *count,
+				seqcount_spinlock_t *count,
 				const xfrm_address_t *addr, u16 family)
 {
 	const struct rb_node *parent;
@@ -4153,7 +4153,7 @@ void __init xfrm_init(void)
 {
 	register_pernet_subsys(&xfrm_net_ops);
 	xfrm_dev_init();
-	seqcount_init(&xfrm_policy_hash_generation);
+	seqcount_mutex_init(&xfrm_policy_hash_generation, &hash_resize_mutex);
 	xfrm_input_init();
 
 #ifdef CONFIG_INET_ESPINTCP
-- 
2.20.1

