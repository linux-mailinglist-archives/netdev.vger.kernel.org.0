Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A467D1F10E5
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 02:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgFHA6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 20:58:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgFHA6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 20:58:41 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0482C08C5C4;
        Sun,  7 Jun 2020 17:58:40 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1ji67H-0000sJ-Rq; Mon, 08 Jun 2020 02:58:20 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
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
Subject: [PATCH v2 10/18] xfrm: policy: Use sequence counters with associated lock
Date:   Mon,  8 Jun 2020 02:57:21 +0200
Message-Id: <20200608005729.1874024-11-a.darwish@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200608005729.1874024-1-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200608005729.1874024-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
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

