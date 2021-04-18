Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBD53637B6
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbhDRVFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:05:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35022 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232539AbhDRVE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:56 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CF37863E8A;
        Sun, 18 Apr 2021 23:03:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/14] netfilter: conntrack: move ct counter to net_generic data
Date:   Sun, 18 Apr 2021 23:04:07 +0200
Message-Id: <20210418210415.4719-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Its only needed from slowpath (sysctl, ctnetlink, gc worker) and
when a new conntrack object is allocated.

Furthermore, each write dirties the otherwise read-mostly pernet
data in struct net.ct, which are accessed from packet path.

Move it to the net_generic data.  This makes struct netns_ct
read-mostly.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h    |  2 ++
 net/netfilter/nf_conntrack_core.c       | 40 +++++++++++++++++--------
 net/netfilter/nf_conntrack_netlink.c    |  5 ++--
 net/netfilter/nf_conntrack_standalone.c | 17 +++++++++--
 4 files changed, 47 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 0578a905b1df..06dc6db70d18 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,6 +45,7 @@ union nf_conntrack_expect_proto {
 
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
+	atomic_t count;
 	unsigned int expect_count;
 	u8 sysctl_auto_assign_helper;
 	bool auto_assign_helper_warned;
@@ -337,6 +338,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 void nf_ct_tmpl_free(struct nf_conn *tmpl);
 
 u32 nf_ct_get_id(const struct nf_conn *ct);
+u32 nf_conntrack_count(const struct net *net);
 
 static inline void
 nf_ct_set(struct sk_buff *skb, struct nf_conn *ct, enum ip_conntrack_info info)
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 5fa68f94ec65..e0befcf8113a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -87,6 +87,8 @@ static __read_mostly bool nf_conntrack_locks_all;
 
 static struct conntrack_gc_work conntrack_gc_work;
 
+extern unsigned int nf_conntrack_net_id;
+
 void nf_conntrack_lock(spinlock_t *lock) __acquires(lock)
 {
 	/* 1) Acquire the lock */
@@ -1381,6 +1383,7 @@ static void gc_worker(struct work_struct *work)
 			i = 0;
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
+			struct nf_conntrack_net *cnet;
 			struct net *net;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
@@ -1401,7 +1404,8 @@ static void gc_worker(struct work_struct *work)
 				continue;
 
 			net = nf_ct_net(tmp);
-			if (atomic_read(&net->ct.count) < nf_conntrack_max95)
+			cnet = net_generic(net, nf_conntrack_net_id);
+			if (atomic_read(&cnet->count) < nf_conntrack_max95)
 				continue;
 
 			/* need to take reference to avoid possible races */
@@ -1480,17 +1484,18 @@ __nf_conntrack_alloc(struct net *net,
 		     const struct nf_conntrack_tuple *repl,
 		     gfp_t gfp, u32 hash)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+	unsigned int ct_count;
 	struct nf_conn *ct;
 
 	/* We don't want any race condition at early drop stage */
-	atomic_inc(&net->ct.count);
+	ct_count = atomic_inc_return(&cnet->count);
 
-	if (nf_conntrack_max &&
-	    unlikely(atomic_read(&net->ct.count) > nf_conntrack_max)) {
+	if (nf_conntrack_max && unlikely(ct_count > nf_conntrack_max)) {
 		if (!early_drop(net, hash)) {
 			if (!conntrack_gc_work.early_drop)
 				conntrack_gc_work.early_drop = true;
-			atomic_dec(&net->ct.count);
+			atomic_dec(&cnet->count);
 			net_warn_ratelimited("nf_conntrack: table full, dropping packet\n");
 			return ERR_PTR(-ENOMEM);
 		}
@@ -1525,7 +1530,7 @@ __nf_conntrack_alloc(struct net *net,
 	atomic_set(&ct->ct_general.use, 0);
 	return ct;
 out:
-	atomic_dec(&net->ct.count);
+	atomic_dec(&cnet->count);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -1542,6 +1547,7 @@ EXPORT_SYMBOL_GPL(nf_conntrack_alloc);
 void nf_conntrack_free(struct nf_conn *ct)
 {
 	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_net *cnet;
 
 	/* A freed object has refcnt == 0, that's
 	 * the golden rule for SLAB_TYPESAFE_BY_RCU
@@ -1550,8 +1556,10 @@ void nf_conntrack_free(struct nf_conn *ct)
 
 	nf_ct_ext_destroy(ct);
 	kmem_cache_free(nf_conntrack_cachep, ct);
+	cnet = net_generic(net, nf_conntrack_net_id);
+
 	smp_mb__before_atomic();
-	atomic_dec(&net->ct.count);
+	atomic_dec(&cnet->count);
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_free);
 
@@ -2309,9 +2317,11 @@ __nf_ct_unconfirmed_destroy(struct net *net)
 
 void nf_ct_unconfirmed_destroy(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
 	might_sleep();
 
-	if (atomic_read(&net->ct.count) > 0) {
+	if (atomic_read(&cnet->count) > 0) {
 		__nf_ct_unconfirmed_destroy(net);
 		nf_queue_nf_hook_drop(net);
 		synchronize_net();
@@ -2323,11 +2333,12 @@ void nf_ct_iterate_cleanup_net(struct net *net,
 			       int (*iter)(struct nf_conn *i, void *data),
 			       void *data, u32 portid, int report)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct iter_data d;
 
 	might_sleep();
 
-	if (atomic_read(&net->ct.count) == 0)
+	if (atomic_read(&cnet->count) == 0)
 		return;
 
 	d.iter = iter;
@@ -2356,7 +2367,9 @@ nf_ct_iterate_destroy(int (*iter)(struct nf_conn *i, void *data), void *data)
 
 	down_read(&net_rwsem);
 	for_each_net(net) {
-		if (atomic_read(&net->ct.count) == 0)
+		struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
+		if (atomic_read(&cnet->count) == 0)
 			continue;
 		__nf_ct_unconfirmed_destroy(net);
 		nf_queue_nf_hook_drop(net);
@@ -2436,8 +2449,10 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 i_see_dead_people:
 	busy = 0;
 	list_for_each_entry(net, net_exit_list, exit_list) {
+		struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
 		nf_ct_iterate_cleanup(kill_all, net, 0, 0);
-		if (atomic_read(&net->ct.count) != 0)
+		if (atomic_read(&cnet->count) != 0)
 			busy = 1;
 	}
 	if (busy) {
@@ -2718,12 +2733,13 @@ void nf_conntrack_init_end(void)
 
 int nf_conntrack_init_net(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	int ret = -ENOMEM;
 	int cpu;
 
 	BUILD_BUG_ON(IP_CT_UNTRACKED == IP_CT_NUMBER);
 	BUILD_BUG_ON_NOT_POWER_OF_2(CONNTRACK_LOCKS);
-	atomic_set(&net->ct.count, 0);
+	atomic_set(&cnet->count, 0);
 
 	net->ct.pcpu_lists = alloc_percpu(struct ct_pcpu);
 	if (!net->ct.pcpu_lists)
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c67a6ec22a74..44e3cb80e2e0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2559,9 +2559,9 @@ static int
 ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 			    struct net *net)
 {
-	struct nlmsghdr *nlh;
 	unsigned int flags = portid ? NLM_F_MULTI : 0, event;
-	unsigned int nr_conntracks = atomic_read(&net->ct.count);
+	unsigned int nr_conntracks;
+	struct nlmsghdr *nlh;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_GET_STATS);
 	nlh = nfnl_msg_put(skb, portid, seq, event, flags, AF_UNSPEC,
@@ -2569,6 +2569,7 @@ ctnetlink_stat_ct_fill_info(struct sk_buff *skb, u32 portid, u32 seq, u32 type,
 	if (!nlh)
 		goto nlmsg_failure;
 
+	nr_conntracks = nf_conntrack_count(net);
 	if (nla_put_be32(skb, CTA_STATS_GLOBAL_ENTRIES, htonl(nr_conntracks)))
 		goto nla_put_failure;
 
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index a7538379cfca..fb89f6e5c8bc 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -424,14 +424,16 @@ static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
 static int ct_cpu_seq_show(struct seq_file *seq, void *v)
 {
 	struct net *net = seq_file_net(seq);
-	unsigned int nr_conntracks = atomic_read(&net->ct.count);
 	const struct ip_conntrack_stat *st = v;
+	unsigned int nr_conntracks;
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq, "entries  clashres found new invalid ignore delete delete_list insert insert_failed drop early_drop icmp_error  expect_new expect_create expect_delete search_restart\n");
 		return 0;
 	}
 
+	nr_conntracks = nf_conntrack_count(net);
+
 	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
 			"%08x %08x %08x %08x %08x  %08x %08x %08x %08x\n",
 		   nr_conntracks,
@@ -507,6 +509,16 @@ static void nf_conntrack_standalone_fini_proc(struct net *net)
 }
 #endif /* CONFIG_NF_CONNTRACK_PROCFS */
 
+u32 nf_conntrack_count(const struct net *net)
+{
+	const struct nf_conntrack_net *cnet;
+
+	cnet = net_generic(net, nf_conntrack_net_id);
+
+	return atomic_read(&cnet->count);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_count);
+
 /* Sysctl support */
 
 #ifdef CONFIG_SYSCTL
@@ -614,7 +626,6 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_COUNT] = {
 		.procname	= "nf_conntrack_count",
-		.data		= &init_net.ct.count,
 		.maxlen		= sizeof(int),
 		.mode		= 0444,
 		.proc_handler	= proc_dointvec,
@@ -1037,7 +1048,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	if (!table)
 		return -ENOMEM;
 
-	table[NF_SYSCTL_CT_COUNT].data = &net->ct.count;
+	table[NF_SYSCTL_CT_COUNT].data = &cnet->count;
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
-- 
2.30.2

