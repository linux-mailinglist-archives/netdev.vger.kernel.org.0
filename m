Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFFC2521524
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241764AbiEJM0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241671AbiEJMZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:25:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C122595A05;
        Tue, 10 May 2022 05:21:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/17] netfilter: cttimeout: decouple unlink and free on netns destruction
Date:   Tue, 10 May 2022 14:21:37 +0200
Message-Id: <20220510122150.92533-5-pablo@netfilter.org>
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

Make it so netns pre_exit unlinks the objects from the pernet list, so
they cannot be found anymore.

netns core issues a synchronize_rcu() before calling the exit hooks so
any the time the exit hooks run unconfirmed nf_conn entries have been
free'd or they have been committed to the hashtable.

The exit hook still tags unconfirmed entries as dying, this can
now be removed in a followup change.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_timeout.h |  8 ------
 net/netfilter/nfnetlink_cttimeout.c          | 30 ++++++++++++++++++--
 2 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 3ea94f6f3844..fea258983d23 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -17,14 +17,6 @@ struct nf_ct_timeout {
 	char			data[];
 };
 
-struct ctnl_timeout {
-	struct list_head	head;
-	struct rcu_head		rcu_head;
-	refcount_t		refcnt;
-	char			name[CTNL_TIMEOUT_NAME_MAX];
-	struct nf_ct_timeout	timeout;
-};
-
 struct nf_conn_timeout {
 	struct nf_ct_timeout __rcu *timeout;
 };
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index eea486f32971..83fa15c4193c 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -33,8 +33,19 @@
 
 static unsigned int nfct_timeout_id __read_mostly;
 
+struct ctnl_timeout {
+	struct list_head	head;
+	struct rcu_head		rcu_head;
+	refcount_t		refcnt;
+	char			name[CTNL_TIMEOUT_NAME_MAX];
+	struct nf_ct_timeout	timeout;
+
+	struct list_head	free_head;
+};
+
 struct nfct_timeout_pernet {
 	struct list_head	nfct_timeout_list;
+	struct list_head	nfct_timeout_freelist;
 };
 
 MODULE_LICENSE("GPL");
@@ -574,10 +585,24 @@ static int __net_init cttimeout_net_init(struct net *net)
 	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
 
 	INIT_LIST_HEAD(&pernet->nfct_timeout_list);
+	INIT_LIST_HEAD(&pernet->nfct_timeout_freelist);
 
 	return 0;
 }
 
+static void __net_exit cttimeout_net_pre_exit(struct net *net)
+{
+	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
+	struct ctnl_timeout *cur, *tmp;
+
+	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list, head) {
+		list_del_rcu(&cur->head);
+		list_add(&cur->free_head, &pernet->nfct_timeout_freelist);
+	}
+
+	/* core calls synchronize_rcu() after this */
+}
+
 static void __net_exit cttimeout_net_exit(struct net *net)
 {
 	struct nfct_timeout_pernet *pernet = nfct_timeout_pernet(net);
@@ -586,8 +611,8 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 	nf_ct_unconfirmed_destroy(net);
 	nf_ct_untimeout(net, NULL);
 
-	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_list, head) {
-		list_del_rcu(&cur->head);
+	list_for_each_entry_safe(cur, tmp, &pernet->nfct_timeout_freelist, head) {
+		list_del(&cur->free_head);
 
 		if (refcount_dec_and_test(&cur->refcnt))
 			kfree_rcu(cur, rcu_head);
@@ -596,6 +621,7 @@ static void __net_exit cttimeout_net_exit(struct net *net)
 
 static struct pernet_operations cttimeout_ops = {
 	.init	= cttimeout_net_init,
+	.pre_exit = cttimeout_net_pre_exit,
 	.exit	= cttimeout_net_exit,
 	.id     = &nfct_timeout_id,
 	.size   = sizeof(struct nfct_timeout_pernet),
-- 
2.30.2

