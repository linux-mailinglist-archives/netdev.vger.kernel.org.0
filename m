Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E955642C9
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 22:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiGBU5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 16:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiGBU5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 16:57:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E60CE2C;
        Sat,  2 Jul 2022 13:57:09 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1o7kAd-0000y7-Fo; Sat, 02 Jul 2022 22:56:51 +0200
Date:   Sat, 2 Jul 2022 22:56:51 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Mel Gorman <mgorman@suse.de>,
        lukasz.luba@arm.com, dietmar.eggemann@arm.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [Regression] stress-ng udp-flood causes kernel panic on Ampere
 Altra
Message-ID: <20220702205651.GB15144@breakpoint.cc>
References: <Yr7WTfd6AVTQkLjI@e126311.manchester.arm.com>
 <20220701200110.GA15144@breakpoint.cc>
 <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <YsAnPhPfWRjpkdmn@e126311.manchester.arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> On Fri, Jul 01, 2022 at 10:01:10PM +0200, Florian Westphal wrote:
> > Kajetan Puchalski <kajetan.puchalski@arm.com> wrote:
> > > While running the udp-flood test from stress-ng on Ampere Altra (Mt.
> > > Jade platform) I encountered a kernel panic caused by NULL pointer
> > > dereference within nf_conntrack.
> > > 
> > > The issue is present in the latest mainline (5.19-rc4), latest stable
> > > (5.18.8), as well as multiple older stable versions. The last working
> > > stable version I found was 5.15.40.
> > 
> > Do I need a special setup for conntrack?
> 
> I don't think there was any special setup involved, the config I started
> from was a generic distribution config and I didn't change any
> networking-specific options. In case that's helpful here's the .config I
> used.
> 
> https://pastebin.com/Bb2wttdx
> 
> > 
> > No crashes after more than one hour of stress-ng on
> > 1. 4 core amd64 Fedora 5.17 kernel
> > 2. 16 core amd64, linux stable 5.17.15
> > 3. 12 core intel, Fedora 5.18 kernel
> > 4. 3 core aarch64 vm, 5.18.7-200.fc36.aarch64
> > 
> 
> That would make sense, from further experiments I ran it somehow seems
> to be related to the number of workers being spawned by stress-ng along
> with the CPUs/cores involved.
>
> For instance, running the test with <=25 workers (--udp-flood 25 etc.)
> results in the test running fine for at least 15 minutes.

Ok.  I will let it run for longer on the machines I have access to.

In mean time, you could test attached patch, its simple s/refcount_/atomic_/
in nf_conntrack.

If mainline (patch vs. HEAD 69cb6c6556ad89620547318439) crashes for you
but works with attached patch someone who understands aarch64 memory ordering
would have to look more closely at refcount_XXX functions to see where they
might differ from atomic_ ones.

If it still crashes, please try below hunk in addition, although I don't see
how it would make a difference.

This is the one spot where the original conversion replaced atomic_inc()
with refcount_set(), this is on allocation, refcount is expected to be 0 so
refcount_inc() triggers a warning hinting at a use-after free.

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1776,7 +1776,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
                __nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
        /* Now it is going to be associated with an sk_buff, set refcount to 1. */
-       atomic_set(&ct->ct_general.use, 1);
+       atomic_inc(&ct->ct_general.use);
 
        if (exp) {
                if (exp->expectfn)

--CE+1k2dSO48ffgeK
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-conntrack-revert-to-atomic_t-api.patch"

From 4234018dff486bdc30f4fe4625c8da1a8e30c2f6 Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Sat, 2 Jul 2022 22:42:57 +0200
Subject: [PATCH 1/1] netfilter: conntrack: revert to atomic_t api

Just for testing.
---
 include/linux/netfilter/nf_conntrack_common.h |  6 ++---
 include/net/netfilter/nf_conntrack.h          |  2 +-
 net/netfilter/nf_conntrack_core.c             | 24 +++++++++----------
 net/netfilter/nf_conntrack_expect.c           |  2 +-
 net/netfilter/nf_conntrack_netlink.c          |  6 ++---
 net/netfilter/nf_conntrack_standalone.c       |  4 ++--
 net/netfilter/nf_flow_table_core.c            |  2 +-
 net/netfilter/nft_ct.c                        |  4 ++--
 net/netfilter/xt_CT.c                         |  2 +-
 9 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_common.h b/include/linux/netfilter/nf_conntrack_common.h
index 2770db2fa080..48a78944182d 100644
--- a/include/linux/netfilter/nf_conntrack_common.h
+++ b/include/linux/netfilter/nf_conntrack_common.h
@@ -25,7 +25,7 @@ struct ip_conntrack_stat {
 #define NFCT_PTRMASK	~(NFCT_INFOMASK)
 
 struct nf_conntrack {
-	refcount_t use;
+	atomic_t use;
 };
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct);
@@ -33,13 +33,13 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct);
 /* like nf_ct_put, but without module dependency on nf_conntrack */
 static inline void nf_conntrack_put(struct nf_conntrack *nfct)
 {
-	if (nfct && refcount_dec_and_test(&nfct->use))
+	if (nfct && atomic_dec_and_test(&nfct->use))
 		nf_conntrack_destroy(nfct);
 }
 static inline void nf_conntrack_get(struct nf_conntrack *nfct)
 {
 	if (nfct)
-		refcount_inc(&nfct->use);
+		atomic_inc(&nfct->use);
 }
 
 #endif /* _NF_CONNTRACK_COMMON_H */
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index a32be8aa7ed2..9fab0c8835bb 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -180,7 +180,7 @@ void nf_ct_destroy(struct nf_conntrack *nfct);
 /* decrement reference count on a conntrack */
 static inline void nf_ct_put(struct nf_conn *ct)
 {
-	if (ct && refcount_dec_and_test(&ct->ct_general.use))
+	if (ct && atomic_dec_and_test(&ct->ct_general.use))
 		nf_ct_destroy(&ct->ct_general);
 }
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 082a2fd8d85b..4469e49d78a7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -554,7 +554,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 	tmpl->status = IPS_TEMPLATE;
 	write_pnet(&tmpl->ct_net, net);
 	nf_ct_zone_add(tmpl, zone);
-	refcount_set(&tmpl->ct_general.use, 1);
+	atomic_set(&tmpl->ct_general.use, 1);
 
 	return tmpl;
 }
@@ -586,7 +586,7 @@ void nf_ct_destroy(struct nf_conntrack *nfct)
 	struct nf_conn *ct = (struct nf_conn *)nfct;
 
 	pr_debug("%s(%p)\n", __func__, ct);
-	WARN_ON(refcount_read(&nfct->use) != 0);
+	WARN_ON(atomic_read(&nfct->use) != 0);
 
 	if (unlikely(nf_ct_is_template(ct))) {
 		nf_ct_tmpl_free(ct);
@@ -726,7 +726,7 @@ nf_ct_match(const struct nf_conn *ct1, const struct nf_conn *ct2)
 /* caller must hold rcu readlock and none of the nf_conntrack_locks */
 static void nf_ct_gc_expired(struct nf_conn *ct)
 {
-	if (!refcount_inc_not_zero(&ct->ct_general.use))
+	if (!atomic_inc_not_zero(&ct->ct_general.use))
 		return;
 
 	if (nf_ct_should_gc(ct))
@@ -794,7 +794,7 @@ __nf_conntrack_find_get(struct net *net, const struct nf_conntrack_zone *zone,
 		 * in, try to obtain a reference and re-check tuple
 		 */
 		ct = nf_ct_tuplehash_to_ctrack(h);
-		if (likely(refcount_inc_not_zero(&ct->ct_general.use))) {
+		if (likely(atomic_inc_not_zero(&ct->ct_general.use))) {
 			if (likely(nf_ct_key_equal(h, tuple, zone, net)))
 				goto found;
 
@@ -923,7 +923,7 @@ nf_conntrack_hash_check_insert(struct nf_conn *ct)
 
 	smp_wmb();
 	/* The caller holds a reference to this object */
-	refcount_set(&ct->ct_general.use, 2);
+	atomic_set(&ct->ct_general.use, 2);
 	__nf_conntrack_hash_insert(ct, hash, reply_hash);
 	nf_conntrack_double_unlock(hash, reply_hash);
 	NF_CT_STAT_INC(net, insert);
@@ -981,7 +981,7 @@ static void __nf_conntrack_insert_prepare(struct nf_conn *ct)
 {
 	struct nf_conn_tstamp *tstamp;
 
-	refcount_inc(&ct->ct_general.use);
+	atomic_inc(&ct->ct_general.use);
 
 	/* set conntrack timestamp, if enabled. */
 	tstamp = nf_conn_tstamp_find(ct);
@@ -1384,7 +1384,7 @@ static unsigned int early_drop_list(struct net *net,
 		    nf_ct_is_dying(tmp))
 			continue;
 
-		if (!refcount_inc_not_zero(&tmp->ct_general.use))
+		if (!atomic_inc_not_zero(&tmp->ct_general.use))
 			continue;
 
 		/* kill only if still in same netns -- might have moved due to
@@ -1533,7 +1533,7 @@ static void gc_worker(struct work_struct *work)
 				continue;
 
 			/* need to take reference to avoid possible races */
-			if (!refcount_inc_not_zero(&tmp->ct_general.use))
+			if (!atomic_inc_not_zero(&tmp->ct_general.use))
 				continue;
 
 			if (gc_worker_skip_ct(tmp)) {
@@ -1640,7 +1640,7 @@ __nf_conntrack_alloc(struct net *net,
 	/* Because we use RCU lookups, we set ct_general.use to zero before
 	 * this is inserted in any list.
 	 */
-	refcount_set(&ct->ct_general.use, 0);
+	atomic_set(&ct->ct_general.use, 0);
 	return ct;
 out:
 	atomic_dec(&cnet->count);
@@ -1665,7 +1665,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
 	 */
-	WARN_ON(refcount_read(&ct->ct_general.use) != 0);
+	WARN_ON(atomic_read(&ct->ct_general.use) != 0);
 
 	if (ct->status & IPS_SRC_NAT_DONE) {
 		const struct nf_nat_hook *nat_hook;
@@ -1776,7 +1776,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 		__nf_ct_try_assign_helper(ct, tmpl, GFP_ATOMIC);
 
 	/* Now it is going to be associated with an sk_buff, set refcount to 1. */
-	refcount_set(&ct->ct_general.use, 1);
+	atomic_set(&ct->ct_general.use, 1);
 
 	if (exp) {
 		if (exp->expectfn)
@@ -2390,7 +2390,7 @@ get_next_corpse(int (*iter)(struct nf_conn *i, void *data),
 
 	return NULL;
 found:
-	refcount_inc(&ct->ct_general.use);
+	atomic_inc(&ct->ct_general.use);
 	spin_unlock(lockp);
 	local_bh_enable();
 	return ct;
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 96948e98ec53..84cb05eae410 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -208,7 +208,7 @@ nf_ct_find_expectation(struct net *net,
 	 * can be sure the ct cannot disappear underneath.
 	 */
 	if (unlikely(nf_ct_is_dying(exp->master) ||
-		     !refcount_inc_not_zero(&exp->master->ct_general.use)))
+		     !atomic_inc_not_zero(&exp->master->ct_general.use)))
 		return NULL;
 
 	if (exp->flags & NF_CT_EXPECT_PERMANENT) {
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 722af5e309ba..d5de0e580e6c 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -514,7 +514,7 @@ static int ctnetlink_dump_id(struct sk_buff *skb, const struct nf_conn *ct)
 
 static int ctnetlink_dump_use(struct sk_buff *skb, const struct nf_conn *ct)
 {
-	if (nla_put_be32(skb, CTA_USE, htonl(refcount_read(&ct->ct_general.use))))
+	if (nla_put_be32(skb, CTA_USE, htonl(atomic_read(&ct->ct_general.use))))
 		goto nla_put_failure;
 	return 0;
 
@@ -1204,7 +1204,7 @@ ctnetlink_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
 			ct = nf_ct_tuplehash_to_ctrack(h);
 			if (nf_ct_is_expired(ct)) {
 				if (i < ARRAY_SIZE(nf_ct_evict) &&
-				    refcount_inc_not_zero(&ct->ct_general.use))
+				    atomic_inc_not_zero(&ct->ct_general.use))
 					nf_ct_evict[i++] = ct;
 				continue;
 			}
@@ -1747,7 +1747,7 @@ static int ctnetlink_dump_one_entry(struct sk_buff *skb,
 				  NFNL_MSG_TYPE(cb->nlh->nlmsg_type),
 				  ct, dying, 0);
 	if (res < 0) {
-		if (!refcount_inc_not_zero(&ct->ct_general.use))
+		if (!atomic_inc_not_zero(&ct->ct_general.use))
 			return 0;
 
 		ctx->last = ct;
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 6ad7bbc90d38..badd3f219533 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -303,7 +303,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	int ret = 0;
 
 	WARN_ON(!ct);
-	if (unlikely(!refcount_inc_not_zero(&ct->ct_general.use)))
+	if (unlikely(!atomic_inc_not_zero(&ct->ct_general.use)))
 		return 0;
 
 	if (nf_ct_should_gc(ct)) {
@@ -370,7 +370,7 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	ct_show_zone(s, ct, NF_CT_DEFAULT_ZONE_DIR);
 	ct_show_delta_time(s, ct);
 
-	seq_printf(s, "use=%u\n", refcount_read(&ct->ct_general.use));
+	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
 
 	if (seq_has_overflowed(s))
 		goto release;
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index f2def06d1070..8b3f91a60ba2 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -54,7 +54,7 @@ struct flow_offload *flow_offload_alloc(struct nf_conn *ct)
 	struct flow_offload *flow;
 
 	if (unlikely(nf_ct_is_dying(ct) ||
-	    !refcount_inc_not_zero(&ct->ct_general.use)))
+	    !atomic_inc_not_zero(&ct->ct_general.use)))
 		return NULL;
 
 	flow = kzalloc(sizeof(*flow), GFP_ATOMIC);
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d8e1614918a1..1b6ead61a8f1 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -260,8 +260,8 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
-		refcount_inc(&ct->ct_general.use);
+	if (likely(atomic_read(&ct->ct_general.use) == 1)) {
+		atomic_inc(&ct->ct_general.use);
 		nf_ct_zone_add(ct, &zone);
 	} else {
 		/* previous skb got queued to userspace, allocate temporary
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
index 267757b0392a..cf2f8c1d4fb5 100644
--- a/net/netfilter/xt_CT.c
+++ b/net/netfilter/xt_CT.c
@@ -24,7 +24,7 @@ static inline int xt_ct_target(struct sk_buff *skb, struct nf_conn *ct)
 		return XT_CONTINUE;
 
 	if (ct) {
-		refcount_inc(&ct->ct_general.use);
+		atomic_inc(&ct->ct_general.use);
 		nf_ct_set(skb, ct, IP_CT_NEW);
 	} else {
 		nf_ct_set(skb, ct, IP_CT_UNTRACKED);
-- 
2.35.1


--CE+1k2dSO48ffgeK--
