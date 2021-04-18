Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182003637AF
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbhDRVFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:05:01 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35010 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232288AbhDRVEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:55 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 49AAC63E87;
        Sun, 18 Apr 2021 23:03:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/14] netfilter: conntrack: move expect counter to net_generic data
Date:   Sun, 18 Apr 2021 23:04:06 +0200
Message-Id: <20210418210415.4719-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Creation of a new conntrack entry isn't a frequent operation (compared
to 'ct entry already exists').  Creation of a new entry that is also an
expected (related) connection even less so.

Place this counter in net_generic data.

A followup patch will also move the conntrack count -- this will make
netns_ct a read-mostly structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  1 +
 net/netfilter/nf_conntrack_core.c    |  6 +++++-
 net/netfilter/nf_conntrack_expect.c  | 22 ++++++++++++++++------
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index db8f047eb75f..0578a905b1df 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,6 +45,7 @@ union nf_conntrack_expect_proto {
 
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
+	unsigned int expect_count;
 	u8 sysctl_auto_assign_helper;
 	bool auto_assign_helper_warned;
 
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ace3e8265e0a..5fa68f94ec65 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -55,6 +55,8 @@
 
 #include "nf_internals.h"
 
+extern unsigned int nf_conntrack_net_id;
+
 __cacheline_aligned_in_smp spinlock_t nf_conntrack_locks[CONNTRACK_LOCKS];
 EXPORT_SYMBOL_GPL(nf_conntrack_locks);
 
@@ -1570,6 +1572,7 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn_timeout *timeout_ext;
 	struct nf_conntrack_zone tmp;
+	struct nf_conntrack_net *cnet;
 
 	if (!nf_ct_invert_tuple(&repl_tuple, tuple)) {
 		pr_debug("Can't invert tuple.\n");
@@ -1603,7 +1606,8 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 			     GFP_ATOMIC);
 
 	local_bh_disable();
-	if (net->ct.expect_count) {
+	cnet = net_generic(net, nf_conntrack_net_id);
+	if (cnet->expect_count) {
 		spin_lock(&nf_conntrack_expect_lock);
 		exp = nf_ct_find_expectation(net, zone, tuple);
 		if (exp) {
diff --git a/net/netfilter/nf_conntrack_expect.c b/net/netfilter/nf_conntrack_expect.c
index 42557d2b6a90..efdd391b3f72 100644
--- a/net/netfilter/nf_conntrack_expect.c
+++ b/net/netfilter/nf_conntrack_expect.c
@@ -43,18 +43,23 @@ unsigned int nf_ct_expect_max __read_mostly;
 static struct kmem_cache *nf_ct_expect_cachep __read_mostly;
 static unsigned int nf_ct_expect_hashrnd __read_mostly;
 
+extern unsigned int nf_conntrack_net_id;
+
 /* nf_conntrack_expect helper functions */
 void nf_ct_unlink_expect_report(struct nf_conntrack_expect *exp,
 				u32 portid, int report)
 {
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct net *net = nf_ct_exp_net(exp);
+	struct nf_conntrack_net *cnet;
 
 	WARN_ON(!master_help);
 	WARN_ON(timer_pending(&exp->timeout));
 
 	hlist_del_rcu(&exp->hnode);
-	net->ct.expect_count--;
+
+	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet->expect_count--;
 
 	hlist_del_rcu(&exp->lnode);
 	master_help->expecting[exp->class]--;
@@ -118,10 +123,11 @@ __nf_ct_expect_find(struct net *net,
 		    const struct nf_conntrack_zone *zone,
 		    const struct nf_conntrack_tuple *tuple)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct nf_conntrack_expect *i;
 	unsigned int h;
 
-	if (!net->ct.expect_count)
+	if (!cnet->expect_count)
 		return NULL;
 
 	h = nf_ct_expect_dst_hash(net, tuple);
@@ -158,10 +164,11 @@ nf_ct_find_expectation(struct net *net,
 		       const struct nf_conntrack_zone *zone,
 		       const struct nf_conntrack_tuple *tuple)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 	struct nf_conntrack_expect *i, *exp = NULL;
 	unsigned int h;
 
-	if (!net->ct.expect_count)
+	if (!cnet->expect_count)
 		return NULL;
 
 	h = nf_ct_expect_dst_hash(net, tuple);
@@ -368,6 +375,7 @@ EXPORT_SYMBOL_GPL(nf_ct_expect_put);
 
 static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 {
+	struct nf_conntrack_net *cnet;
 	struct nf_conn_help *master_help = nfct_help(exp->master);
 	struct nf_conntrack_helper *helper;
 	struct net *net = nf_ct_exp_net(exp);
@@ -389,7 +397,8 @@ static void nf_ct_expect_insert(struct nf_conntrack_expect *exp)
 	master_help->expecting[exp->class]++;
 
 	hlist_add_head_rcu(&exp->hnode, &nf_ct_expect_hash[h]);
-	net->ct.expect_count++;
+	cnet = net_generic(net, nf_conntrack_net_id);
+	cnet->expect_count++;
 
 	NF_CT_STAT_INC(net, expect_create);
 }
@@ -415,6 +424,7 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 {
 	const struct nf_conntrack_expect_policy *p;
 	struct nf_conntrack_expect *i;
+	struct nf_conntrack_net *cnet;
 	struct nf_conn *master = expect->master;
 	struct nf_conn_help *master_help = nfct_help(master);
 	struct nf_conntrack_helper *helper;
@@ -458,7 +468,8 @@ static inline int __nf_ct_expect_check(struct nf_conntrack_expect *expect,
 		}
 	}
 
-	if (net->ct.expect_count >= nf_ct_expect_max) {
+	cnet = net_generic(net, nf_conntrack_net_id);
+	if (cnet->expect_count >= nf_ct_expect_max) {
 		net_warn_ratelimited("nf_conntrack: expectation table full\n");
 		ret = -EMFILE;
 	}
@@ -686,7 +697,6 @@ module_param_named(expect_hashsize, nf_ct_expect_hsize, uint, 0400);
 
 int nf_conntrack_expect_pernet_init(struct net *net)
 {
-	net->ct.expect_count = 0;
 	return exp_proc_init(net);
 }
 
-- 
2.30.2

