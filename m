Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B16D856FE99
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiGKKOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiGKKOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:14:04 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF78B7AB0D;
        Mon, 11 Jul 2022 02:34:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] netfilter: conntrack: fix crash due to confirmed bit load reordering
Date:   Mon, 11 Jul 2022 11:33:55 +0200
Message-Id: <20220711093357.107260-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220711093357.107260-1-pablo@netfilter.org>
References: <20220711093357.107260-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Kajetan Puchalski reports crash on ARM, with backtrace of:

__nf_ct_delete_from_lists
nf_ct_delete
early_drop
__nf_conntrack_alloc

Unlike atomic_inc_not_zero, refcount_inc_not_zero is not a full barrier.
conntrack uses SLAB_TYPESAFE_BY_RCU, i.e. it is possible that a 'newly'
allocated object is still in use on another CPU:

CPU1						CPU2
						encounter 'ct' during hlist walk
 delete_from_lists
 refcount drops to 0
 kmem_cache_free(ct);
 __nf_conntrack_alloc() // returns same object
						refcount_inc_not_zero(ct); /* might fail */

						/* If set, ct is public/in the hash table */
						test_bit(IPS_CONFIRMED_BIT, &ct->status);

In case CPU1 already set refcount back to 1, refcount_inc_not_zero()
will succeed.

The expected possibilities for a CPU that obtained the object 'ct'
(but no reference so far) are:

1. refcount_inc_not_zero() fails.  CPU2 ignores the object and moves to
   the next entry in the list.  This happens for objects that are about
   to be free'd, that have been free'd, or that have been reallocated
   by __nf_conntrack_alloc(), but where the refcount has not been
   increased back to 1 yet.

2. refcount_inc_not_zero() succeeds. CPU2 checks the CONFIRMED bit
   in ct->status.  If set, the object is public/in the table.

   If not, the object must be skipped; CPU2 calls nf_ct_put() to
   un-do the refcount increment and moves to the next object.

Parallel deletion from the hlists is prevented by a
'test_and_set_bit(IPS_DYING_BIT, &ct->status);' check, i.e. only one
cpu will do the unlink, the other one will only drop its reference count.

Because refcount_inc_not_zero is not a full barrier, CPU2 may try to
delete an object that is not on any list:

1. refcount_inc_not_zero() successful (refcount inited to 1 on other CPU)
2. CONFIRMED test also successful (load was reordered or zeroing
   of ct->status not yet visible)
3. delete_from_lists unlinks entry not on the hlist, because
   IPS_DYING_BIT is 0 (already cleared).

2) is already wrong: CPU2 will handle a partially initited object
that is supposed to be private to CPU1.

Add needed barriers when refcount_inc_not_zero() is successful.

It also inserts a smp_wmb() before the refcount is set to 1 during
allocation.

Because other CPU might still see the object, refcount_set(1)
"resurrects" it, so we need to make sure that other CPUs will also observe
the right content.  In particular, the CONFIRMED bit test must only pass
once the object is fully initialised and either in the hash or about to be
inserted (with locks held to delay possible unlink from early_drop or
gc worker).

I did not change flow_offload_alloc(), as far as I can see it should call
refcount_inc(), not refcount_inc_not_zero(): the ct object is attached to
the skb so its refcount should be >= 1 in all cases.

v2: prefer smp_acquire__after_ctrl_dep to smp_rmb (Will Deacon).
v3: keep smp_acquire__after_ctrl_dep close to refcount_inc_not_zero call
    add comment in nf_conntrack_netlink, no control dependency there
    due to locks.

Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/all/Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com/
Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
Diagnosed-by: Will Deacon <will@kernel.org>
Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Will Deacon <will@kernel.org>
---
 net/netfilter/nf_conntrack_core.c       | 22 ++++++++++++++++++++++
 net/netfilter/nf_conntrack_netlink.c    |  1 +
 net/netfilter/nf_conntrack_standalone.c |  3 +++
 3 files changed, 26 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..369aeabb94fe 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -729,6 +729,9 @@ static void nf_ct_gc_expired(struct nf_conn *ct)
 	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
+	/* load ->status after refcount increase */
+	smp_acquire__after_ctrl_dep();
+
 	if (nf_ct_should_gc(ct))
 		nf_ct_kill(ct);
 
@@ -795,6 +798,9 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
 		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
+			/* re-check key after refcount */
+			smp_acquire__after_ctrl_dep();
+
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -1387,6 +1393,9 @@ static unsigned int early_drop_list(struct net *net,
 		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
+		/* load ->ct_net and ->status after refcount increase */
+		smp_acquire__after_ctrl_dep();
+
 		/* kill only if still in same netns -- might have moved due to
 		 * SLAB_TYPESAFE_BY_RCU rules.
 		 *
@@ -1536,6 +1545,9 @@ static void gc_worker(struct work_struct *work)
 			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
+			/* load ->status after refcount increase */
+			smp_acquire__after_ctrl_dep();
+
 			if (gc_worker_skip_ct(tmp)) {
 				nf_ct_put(tmp);
 				continue;
@@ -1775,6 +1787,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
+	/* Other CPU might have obtained a pointer to this object before it was
+	 * released.  Because refcount is 0, refcount_inc_not_zero() will fail.
+	 *
+	 * After refcount_set(1) it will succeed; ensure that zeroing of
+	 * ct->status and the correct ct->net pointer are visible; else other
+	 * core might observe CONFIRMED bit which means the entry is valid and
+	 * in the hash table, but its not (anymore).
+	 */
+	smp_wmb();
+
 	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 722af5e309ba..f5905b5201a7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1203,6 +1203,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 					   hnnode) {
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
+				/* need to defer nf_ct_kill() until lock is released */
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
 				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6ad7bbc90d38..05895878610c 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -306,6 +306,9 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
+	/* load ->status after refcount increase */
+	smp_acquire__after_ctrl_dep();
+
 	if (nf_ct_should_gc(ct)) {
 		nf_ct_kill(ct);
 		goto release;
-- 
2.30.2

