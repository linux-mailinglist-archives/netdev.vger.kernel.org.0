Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44FC3521537
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241732AbiEJM15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241681AbiEJMZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:25:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC4CC91365;
        Tue, 10 May 2022 05:22:00 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/17] netfilter: conntrack: remove unconfirmed list
Date:   Tue, 10 May 2022 14:21:42 +0200
Message-Id: <20220510122150.92533-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220510122150.92533-1-pablo@netfilter.org>
References: <20220510122150.92533-1-pablo@netfilter.org>
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

It has no function anymore and can be removed.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  1 -
 include/net/netns/conntrack.h        |  6 ----
 net/netfilter/nf_conntrack_core.c    | 54 ++--------------------------
 net/netfilter/nf_conntrack_netlink.c | 44 +----------------------
 4 files changed, 3 insertions(+), 102 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f60212244b13..3ce9a5b42fe5 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -101,7 +101,6 @@ struct nf_conn {
 	/* Have we seen traffic both ways yet? (bitset) */
 	unsigned long status;
 
-	u16		cpu;
 	possible_net_t ct_net;
 
 #if IS_ENABLED(CONFIG_NF_NAT)
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index e985a3010b89..a71cfd4e2f21 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -93,11 +93,6 @@ struct nf_ip_net {
 #endif
 };
 
-struct ct_pcpu {
-	spinlock_t		lock;
-	struct hlist_nulls_head unconfirmed;
-};
-
 struct netns_ct {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	bool ecache_dwork_pending;
@@ -109,7 +104,6 @@ struct netns_ct {
 	u8			sysctl_tstamp;
 	u8			sysctl_checksum;
 
-	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
 	struct nf_ip_net	nf_ct_proto;
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7b4b3f5db959..c8d58d6d5b87 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -525,35 +525,6 @@ clean_from_lists(struct nf_conn *ct)
 	nf_ct_remove_expectations(ct);
 }
 
-/* must be called with local_bh_disable */
-static void nf_ct_add_to_unconfirmed_list(struct nf_conn *ct)
-{
-	struct ct_pcpu *pcpu;
-
-	/* add this conntrack to the (per cpu) unconfirmed list */
-	ct->cpu = smp_processor_id();
-	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
-
-	spin_lock(&pcpu->lock);
-	hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode,
-			     &pcpu->unconfirmed);
-	spin_unlock(&pcpu->lock);
-}
-
-/* must be called with local_bh_disable */
-static void nf_ct_del_from_unconfirmed_list(struct nf_conn *ct)
-{
-	struct ct_pcpu *pcpu;
-
-	/* We overload first tuple to link into unconfirmed list.*/
-	pcpu = per_cpu_ptr(nf_ct_net(ct)->ct.pcpu_lists, ct->cpu);
-
-	spin_lock(&pcpu->lock);
-	BUG_ON(hlist_nulls_unhashed(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode));
-	hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
-	spin_unlock(&pcpu->lock);
-}
-
 #define NFCT_ALIGN(len)	(((len) + NFCT_INFOMASK) & ~NFCT_INFOMASK)
 
 /* Released via nf_ct_destroy() */
@@ -633,9 +604,6 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	 */
 	nf_ct_remove_expectations(ct);
 
-	if (unlikely(!nf_ct_is_confirmed(ct)))
-		nf_ct_del_from_unconfirmed_list(ct);
-
 	local_bh_enable();
 
 	if (ct->master)
@@ -1248,7 +1216,6 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 	 * user context, else we insert an already 'dead' hash, blocking
 	 * further use of that particular connection -JM.
 	 */
-	nf_ct_del_from_unconfirmed_list(ct);
 	ct->status |= IPS_CONFIRMED;
 
 	if (unlikely(nf_ct_is_dying(ct))) {
@@ -1803,9 +1770,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
-	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
+	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
 	refcount_set(&ct->ct_general.use, 1);
-	nf_ct_add_to_unconfirmed_list(ct);
 
 	local_bh_enable();
 
@@ -2594,7 +2560,6 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
 		free_percpu(net->ct.stat);
-		free_percpu(net->ct.pcpu_lists);
 	}
 }
 
@@ -2805,26 +2770,14 @@ int nf_conntrack_init_net(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	int ret = -ENOMEM;
-	int cpu;
 
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
 	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
 	atomic_set(&cnet->count, 0);
 
-	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
-	if (!net->ct.pcpu_lists)
-		goto err_stat;
-
-	for_each_possible_cpu(cpu) {
-		struct ct_pcpu *pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-
-		spin_lock_init(&pcpu->lock);
-		INIT_HLIST_NULLS_HEAD(&pcpu->unconfirmed, UNCONFIRMED_NULLS_VAL);
-	}
-
 	net->ct.stat = alloc_percpu(struct ip_conntrack_stat);
 	if (!net->ct.stat)
-		goto err_pcpu_lists;
+		return ret;
 
 	ret = nf_conntrack_expect_pernet_init(net);
 	if (ret < 0)
@@ -2840,8 +2793,5 @@ int nf_conntrack_init_net(struct net *net)
 
 err_expect:
 	free_percpu(net->ct.stat);
-err_pcpu_lists:
-	free_percpu(net->ct.pcpu_lists);
-err_stat:
 	return ret;
 }
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2e9c8183e4a2..eafe640b3387 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1752,49 +1752,7 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 static int
 ctnetlink_dump_unconfirmed(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	struct ctnetlink_list_dump_ctx *ctx = (void *)cb->ctx;
-	struct nf_conn *ct, *last;
-	struct nf_conntrack_tuple_hash *h;
-	struct hlist_nulls_node *n;
-	struct net *net = sock_net(skb->sk);
-	int res, cpu;
-
-	if (ctx->done)
-		return 0;
-
-	last = ctx->last;
-
-	for (cpu = ctx->cpu; cpu < nr_cpu_ids; cpu++) {
-		struct ct_pcpu *pcpu;
-
-		if (!cpu_possible(cpu))
-			continue;
-
-		pcpu = per_cpu_ptr(net->ct.pcpu_lists, cpu);
-		spin_lock_bh(&pcpu->lock);
-restart:
-		hlist_nulls_for_each_entry(h, n, &pcpu->unconfirmed, hnnode) {
-			ct = nf_ct_tuplehash_to_ctrack(h);
-
-			res = ctnetlink_dump_one_entry(skb, cb, ct, false);
-			if (res < 0) {
-				ctx->cpu = cpu;
-				spin_unlock_bh(&pcpu->lock);
-				goto out;
-			}
-		}
-		if (ctx->last) {
-			ctx->last = NULL;
-			goto restart;
-		}
-		spin_unlock_bh(&pcpu->lock);
-	}
-	ctx->done = true;
-out:
-	if (last)
-		nf_ct_put(last);
-
-	return skb->len;
+	return 0;
 }
 
 static int
-- 
2.30.2

