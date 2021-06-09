Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9843A1F3B
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhFIVrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:37 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60490 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbhFIVr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:29 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 176E66422F;
        Wed,  9 Jun 2021 23:44:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/13] netfilter: nftables: add nf_ct_pernet() helper function
Date:   Wed,  9 Jun 2021 23:45:14 +0200
Message-Id: <20210609214523.1678-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Consolidate call to net_generic(net, nf_conntrack_net_id) in this
wrapper function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h    |  7 +++++++
 net/netfilter/nf_conntrack_core.c       | 22 +++++++++-------------
 net/netfilter/nf_conntrack_ecache.c     |  8 +++-----
 net/netfilter/nf_conntrack_expect.c     | 12 +++++-------
 net/netfilter/nf_conntrack_helper.c     |  6 ++----
 net/netfilter/nf_conntrack_proto.c      |  6 ++----
 net/netfilter/nf_conntrack_standalone.c |  8 +++-----
 7 files changed, 31 insertions(+), 38 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 06dc6db70d18..cc663c68ddc4 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -346,6 +346,13 @@ nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
 	skb_set_nfct(skb, (unsigned long)ct | info);
 }
 
+extern unsigned int nf_conntrack_net_id;
+
+static inline struct nf_conntrack_net *nf_ct_pernet(const struct net *net)
+{
+	return net_generic(net, nf_conntrack_net_id);
+}
+
 #define NF_CT_STAT_INC(net, count)	  __this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_INC_ATOMIC(net, count) this_cpu_inc((net)->ct.stat->count)
 #define NF_CT_STAT_ADD_ATOMIC(net, count, v) this_cpu_add((net)->ct.stat->count, (v))
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index e0befcf8113a..96ba19fc8155 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -55,8 +55,6 @@
 
 #include "nf_internals.h"
 
-extern unsigned int nf_conntrack_net_id;
-
 __cacheline_aligned_in_smp spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 EXPORT_SYMBOL_GPL(nf_conntrack_locks);
 
@@ -87,8 +85,6 @@ static __read_mostly bool nf_conntrack_locks_all;
 
 static struct conntrack_gc_work conntrack_gc_work;
 
-extern unsigned int nf_conntrack_net_id;
-
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
 {
 	/* 1) Acquire the lock */
@@ -1404,7 +1400,7 @@ static void gc_worker(struct work_struct *work)
 				continue;
 
 			net = nf_ct_net(tmp);
-			cnet = net_generic(net, nf_conntrack_net_id);
+			cnet = nf_ct_pernet(net);
 			if (atomic_read(&cnet->count) < nf_conntrack_max95)
 				continue;
 
@@ -1484,7 +1480,7 @@ __nf_conntrack_alloc(struct net *net,
 		     const struct nf_conntrack_tuple *repl,
 		     gfp_t gfp, u32 hash)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	unsigned int ct_count;
 	struct nf_conn *ct;
 
@@ -1556,7 +1552,7 @@ void nf_conntrack_free(struct nf_conn *ct)
 
 	nf_ct_ext_destroy(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
-	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet = nf_ct_pernet(net);
 
 	smp_mb__before_atomic();
 	atomic_dec(&cnet->count);
@@ -1614,7 +1610,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			     GFP_ATOMIC);
 
 	local_bh_disable();
-	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count) {
 		spin_lock(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
@@ -2317,7 +2313,7 @@ __nf_ct_unconfirmed_destroy(struct net *net)
 
 void nf_ct_unconfirmed_destroy(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	might_sleep();
 
@@ -2333,7 +2329,7 @@ void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
 			       void *data, u32 portid, int report)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct iter_data d;
 
 	might_sleep();
@@ -2367,7 +2363,7 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 
 	down_read(&net_rwsem);
 	for_each_net(net) {
-		struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+		struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 		if (atomic_read(&cnet->count) == 0)
 			continue;
@@ -2449,7 +2445,7 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
-		struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+		struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 		nf_ct_iterate_cleanup(kill_all, net, 0, 0);
 		if (atomic_read(&cnet->count) != 0)
@@ -2733,7 +2729,7 @@ void nf_conntrack_init_end(void)
 
 int nf_conntrack_init_net(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	int ret = -ENOMEM;
 	int cpu;
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 759d87aef95f..296e4a171bd1 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -27,8 +27,6 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
-extern unsigned int nf_conntrack_net_id;
-
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
 #define ECACHE_RETRY_WAIT (HZ/10)
@@ -348,7 +346,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
 void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	if (state == NFCT_ECACHE_DESTROY_FAIL &&
 	    !delayed_work_pending(&cnet->ecache_dwork)) {
@@ -371,7 +369,7 @@ static const struct nf_ct_ext_type event_extend = {
 
 void nf_conntrack_ecache_pernet_init(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	net->ct.sysctl_events = nf_ct_events;
 	cnet->ct_net = &net->ct;
@@ -380,7 +378,7 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	cancel_delayed_work_sync(&cnet->ecache_dwork);
 }
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index efdd391b3f72..1e851bc2e61a 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -43,8 +43,6 @@ unsigned int nf_ct_expect_max __read_mostly;
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 static unsigned int nf_ct_expect_hashrnd __read_mostly;
 
-extern unsigned int nf_conntrack_net_id;
-
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 				u32 portid, int report)
@@ -58,7 +56,7 @@ void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 
 	hlist_del_rcu(&exp->hnode);
 
-	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet = nf_ct_pernet(net);
 	cnet->expect_count--;
 
 	hlist_del_rcu(&exp->lnode);
@@ -123,7 +121,7 @@ __nf_ct_expect_find(struct net *net,
 		    const struct nf_conntrack_zone *zone,
 		    const struct nf_conntrack_tuple *tuple)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct nf_conntrack_expect *i;
 	unsigned int h;
 
@@ -164,7 +162,7 @@ nf_ct_find_expectation(struct net *net,
 		       const struct nf_conntrack_zone *zone,
 		       const struct nf_conntrack_tuple *tuple)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct nf_conntrack_expect *i, *exp = NULL;
 	unsigned int h;
 
@@ -397,7 +395,7 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
-	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet = nf_ct_pernet(net);
 	cnet->expect_count++;
 
 	NF_CT_STAT_INC(net, expect_create);
@@ -468,7 +466,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 		}
 	}
 
-	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count >= nf_ct_expect_max) {
 		net_warn_ratelimited("nf_conntrack: expectation table full\n");
 		ret = -EMFILE;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ac396cc8bfae..ae4488a13c70 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -43,8 +43,6 @@ MODULE_PARM_DESC(nf_conntrack_helper,
 static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
 static struct list_head nf_ct_nat_helpers __read_mostly;
 
-extern unsigned int nf_conntrack_net_id;
-
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
@@ -214,7 +212,7 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 static struct nf_conntrack_helper *
 nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	if (!cnet->sysctl_auto_assign_helper) {
 		if (cnet->auto_assign_helper_warned)
@@ -560,7 +558,7 @@ static const struct nf_ct_ext_type helper_extend = {
 
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	cnet->sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
 }
diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 89e5bac384d7..fbc1fa36d2c2 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -42,8 +42,6 @@
 #include <net/ipv6.h>
 #include <net/inet_frag.h>
 
-extern unsigned int nf_conntrack_net_id;
-
 static DEFINE_MUTEX(nf_ct_proto_mutex);
 
 #ifdef CONFIG_SYSCTL
@@ -446,7 +444,7 @@ static struct nf_ct_bridge_info *nf_ct_bridge_info;
 
 static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	bool fixup_needed = false, retry = true;
 	int err = 0;
 retry:
@@ -531,7 +529,7 @@ static int nf_ct_netns_do_get(struct net *net, u8 nfproto)
 
 static void nf_ct_netns_do_put(struct net *net, u8 nfproto)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	mutex_lock(&nf_ct_proto_mutex);
 	switch (nfproto) {
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index aaa55246d0ca..bce93656fad9 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -512,9 +512,7 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 
 u32 nf_conntrack_count(const struct net *net)
 {
-	const struct nf_conntrack_net *cnet;
-
-	cnet = net_generic(net, nf_conntrack_net_id);
+	const struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	return atomic_read(&cnet->count);
 }
@@ -1032,7 +1030,7 @@ static void nf_conntrack_standalone_init_gre_sysctl(struct net *net,
 
 static int nf_conntrack_standalone_init_sysctl(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct nf_udp_net *un = nf_udp_pernet(net);
 	struct ctl_table *table;
 
@@ -1085,7 +1083,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 
 static void nf_conntrack_standalone_fini_sysctl(struct net *net)
 {
-	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 	struct ctl_table *table;
 
 	table = cnet->sysctl_header->ctl_table_arg;
-- 
2.30.2

