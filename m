Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49DCD488D23
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237451AbiAIXRF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:17:05 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42172 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237408AbiAIXQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:59 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4C79B64693;
        Mon, 10 Jan 2022 00:14:07 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/32] netfilter: conntrack: convert to refcount_t api
Date:   Mon, 10 Jan 2022 00:16:21 +0100
Message-Id: <20220109231640.104123-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Convert nf_conn reference counting from atomic_t to refcount_t based api.
refcount_t api provides more runtime sanity checks and will warn on
certain constructs, e.g. refcount_inc() on a zero reference count, which
usually indicates use-after-free.

For this reason template allocation is changed to init the refcount to
1, the subsequenct add operations are removed.

Likewise, init_conntrack() is changed to set the initial refcount to 1
instead refcount_inc().

This is safe because the new entry is not (yet) visible to other cpus.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nf_conntrack_common.h |  8 +++---
 net/netfilter/nf_conntrack_core.c             | 26 +++++++++----------
 net/netfilter/nf_conntrack_expect.c           |  4 +--
 net/netfilter/nf_conntrack_netlink.c          |  6 ++---
 net/netfilter/nf_conntrack_standalone.c       |  4 +--
 net/netfilter/nf_flow_table_core.c            |  2 +-
 net/netfilter/nf_synproxy_core.c              |  1 -
 net/netfilter/nft_ct.c                        |  4 +--
 net/netfilter/xt_CT.c                         |  3 +--
 net/openvswitch/conntrack.c                   |  1 -
 net/sched/act_ct.c                            |  1 -
 11 files changed, 27 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 700ea077ce2d..a03f7a80b9ab 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -2,7 +2,7 @@
 #ifndef _NF_CONNTRACK_COMMON_H
 #define _NF_CONNTRACK_COMMON_H
 
-#include <linux/atomic.h>
+#include <linux/refcount.h>
 #include <uapi/linux/netfilter/nf_conntrack_common.h>
 
 struct ip_conntrack_stat {
@@ -25,19 +25,19 @@ struct ip_conntrack_stat {
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
 struct nf_conntrack {
-	atomic_t use;
+	refcount_t use;
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && atomic_dec_and_test(&nfct->use))
+	if (nfct && refcount_dec_and_test(&nfct->use))
 		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		atomic_inc(&nfct->use);
+		refcount_inc(&nfct->use);
 }
 
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index bed0017cadb0..328d359fcabe 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -585,7 +585,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 	nf_ct_zone_add(tmpl, zone);
-	atomic_set(&tmpl->ct_general.use, 0);
+	refcount_set(&tmpl->ct_general.use, 1);
 
 	return tmpl;
 }
@@ -618,7 +618,7 @@ destroy_conntrack(struct nf_conntrack *nfct)
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
 	pr_debug("destroy_conntrack(%p)\n", ct);
-	WARN_ON(atomic_read(&nfct->use) != 0);
+	WARN_ON(refcount_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -742,7 +742,7 @@ nf_ct_match(const struct nf_conn *ct1, const struct nf_conn *ct2)
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
-	if (!atomic_inc_not_zero(&ct->ct_general.use))
+	if (!refcount_inc_not_zero(&ct->ct_general.use))
 		return;
 
 	if (nf_ct_should_gc(ct))
@@ -810,7 +810,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		 * in, try to obtain a reference and re-check tuple
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
+		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -907,7 +907,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
-	atomic_set(&ct->ct_general.use, 2);
+	refcount_set(&ct->ct_general.use, 2);
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
@@ -958,7 +958,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 {
 	struct nf_conn_tstamp *tstamp;
 
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	ct->status |= IPS_CONFIRMED;
 
 	/* set conntrack timestamp, if enabled. */
@@ -1351,7 +1351,7 @@ static unsigned int early_drop_list(struct net *net,
 		    nf_ct_is_dying(tmp))
 			continue;
 
-		if (!atomic_inc_not_zero(&tmp->ct_general.use))
+		if (!refcount_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
 		/* kill only if still in same netns -- might have moved due to
@@ -1469,7 +1469,7 @@ static void gc_worker(struct work_struct *work)
 				continue;
 
 			/* need to take reference to avoid possible races */
-			if (!atomic_inc_not_zero(&tmp->ct_general.use))
+			if (!refcount_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
 			if (gc_worker_skip_ct(tmp)) {
@@ -1569,7 +1569,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
-	atomic_set(&ct->ct_general.use, 0);
+	refcount_set(&ct->ct_general.use, 0);
 	return ct;
 out:
 	atomic_dec(&cnet->count);
@@ -1594,7 +1594,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
 	 */
-	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
+	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
 
 	nf_ct_ext_destroy(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
@@ -1686,8 +1686,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	if (!exp)
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
-	/* Now it is inserted into the unconfirmed list, bump refcount */
-	nf_conntrack_get(&ct->ct_general);
+	/* Now it is inserted into the unconfirmed list, set refcount to 1. */
+	refcount_set(&ct->ct_general.use, 1);
 	nf_ct_add_to_unconfirmed_list(ct);
 
 	local_bh_enable();
@@ -2300,7 +2300,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 
 	return NULL;
 found:
-	atomic_inc(&ct->ct_general.use);
+	refcount_inc(&ct->ct_general.use);
 	spin_unlock(lockp);
 	local_bh_enable();
 	return ct;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 1e89b595ecd0..96948e98ec53 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -203,12 +203,12 @@ nf_ct_find_expectation(struct net *net,
 	 * about to invoke ->destroy(), or nf_ct_delete() via timeout
 	 * or early_drop().
 	 *
-	 * The atomic_inc_not_zero() check tells:  If that fails, we
+	 * The refcount_inc_not_zero() check tells:  If that fails, we
 	 * know that the ct is being destroyed.  If it succeeds, we
 	 * can be sure the ct cannot disappear underneath.
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
-		     !atomic_inc_not_zero(&exp->master->ct_general.use)))
+		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 4f53d9480ed5..13e2e0390c77 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -508,7 +508,7 @@ static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 
 static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
+	if (nla_put_be32(skb, CTA_USE, htonl(refcount_read(&ct->ct_general.use))))
 		goto nla_put_failure;
 	return 0;
 
@@ -1200,7 +1200,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
-				    atomic_inc_not_zero(&ct->ct_general.use))
+				    refcount_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
 				continue;
 			}
@@ -1748,7 +1748,7 @@ ctnetlink_dump_list(struct sk_buff *skb, struct netlink_callback *cb, bool dying
 						  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 						  ct, dying, 0);
 			if (res < 0) {
-				if (!atomic_inc_not_zero(&ct->ct_general.use))
+				if (!refcount_inc_not_zero(&ct->ct_general.use))
 					continue;
 				cb->args[0] = cpu;
 				cb->args[1] = (unsigned long)ct;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 80f675d884b2..3e1afd10a9b6 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -303,7 +303,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	int ret = 0;
 
 	WARN_ON(!ct);
-	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
 	if (nf_ct_should_gc(ct)) {
@@ -370,7 +370,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	ct_show_zone(s, ct, NF_CT_DEFAULT_ZONE_DIR);
 	ct_show_delta_time(s, ct);
 
-	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	seq_printf(s, "use=%u\n", refcount_read(&ct->ct_general.use));
 
 	if (seq_has_overflowed(s))
 		goto release;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index ed37bb9b4e58..b90eca7a2f22 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -48,7 +48,7 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 	struct flow_offload *flow;
 
 	if (unlikely(nf_ct_is_dying(ct) ||
-	    !atomic_inc_not_zero(&ct->ct_general.use)))
+	    !refcount_inc_not_zero(&ct->ct_general.use)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
index 3d6d49420db8..2dfc5dae0656 100644
--- a/net/netfilter/nf_synproxy_core.c
+++ b/net/netfilter/nf_synproxy_core.c
@@ -349,7 +349,6 @@ static int __net_init synproxy_net_init(struct net *net)
 		goto err2;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 	snet->tmpl = ct;
 
 	snet->stats = alloc_percpu(struct synproxy_stats);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 99b1de14ff7e..518d96c8c247 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -259,7 +259,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(atomic_read(&ct->ct_general.use) == 1)) {
+	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
 		/* previous skb got queued to userspace */
@@ -270,7 +270,6 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 		}
 	}
 
-	atomic_inc(&ct->ct_general.use);
 	nf_ct_set(skb, ct, IP_CT_NEW);
 }
 #endif
@@ -375,7 +374,6 @@ static bool nft_ct_tmpl_alloc_pcpu(void)
 			return false;
 		}
 
-		atomic_set(&tmp->ct_general.use, 1);
 		per_cpu(nft_ct_pcpu_template, cpu) = tmp;
 	}
 
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 0a913ce07425..267757b0392a 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -24,7 +24,7 @@ static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 		return XT_CONTINUE;
 
 	if (ct) {
-		atomic_inc(&ct->ct_general.use);
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_set(skb, ct, IP_CT_NEW);
 	} else {
 		nf_ct_set(skb, ct, IP_CT_UNTRACKED);
@@ -201,7 +201,6 @@ static int xt_ct_tg_check(const struct xt_tgchk_param *par,
 			goto err4;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &ct->status);
-	nf_conntrack_get(&ct->ct_general);
 out:
 	info->ct = ct;
 	return 0;
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 1b5eae57bc90..121664e52271 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1716,7 +1716,6 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 		goto err_free_ct;
 
 	__set_bit(IPS_CONFIRMED_BIT, &ct_info.ct->status);
-	nf_conntrack_get(&ct_info.ct->ct_general);
 	return 0;
 err_free_ct:
 	__ovs_ct_free_action(&ct_info);
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index ab1810f2e660..3fa904cf8f27 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1228,7 +1228,6 @@ static int tcf_ct_fill_params(struct net *net,
 		return -ENOMEM;
 	}
 	__set_bit(IPS_CONFIRMED_BIT, &tmpl->status);
-	nf_conntrack_get(&tmpl->ct_general);
 	p->tmpl = tmpl;
 
 	return 0;
-- 
2.30.2

