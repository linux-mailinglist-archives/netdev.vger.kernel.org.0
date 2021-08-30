Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A613FB346
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236256AbhH3JkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:40:13 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42602 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236068AbhH3JkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:40:00 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 448A7600E2;
        Mon, 30 Aug 2021 11:38:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 5/8] netfilter: ecache: remove nf_exp_event_notifier structure
Date:   Mon, 30 Aug 2021 11:38:49 +0200
Message-Id: <20210830093852.21654-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Reuse the conntrack event notofier struct, this allows to remove the
extra register/unregister functions and avoids a pointer in struct net.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h | 23 ++++-------
 include/net/netns/conntrack.h               |  1 -
 net/netfilter/nf_conntrack_ecache.c         | 43 ++-------------------
 net/netfilter/nf_conntrack_netlink.c        | 30 ++------------
 4 files changed, 13 insertions(+), 84 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 061a93a03b82..d932e22edcb4 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -72,8 +72,15 @@ struct nf_ct_event {
 	int report;
 };
 
+struct nf_exp_event {
+	struct nf_conntrack_expect *exp;
+	u32 portid;
+	int report;
+};
+
 struct nf_ct_event_notifier {
 	int (*ct_event)(unsigned int events, const struct nf_ct_event *item);
+	int (*exp_event)(unsigned int events, const struct nf_exp_event *item);
 };
 
 void nf_conntrack_register_notifier(struct net *net,
@@ -150,22 +157,6 @@ nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-
-struct nf_exp_event {
-	struct nf_conntrack_expect *exp;
-	u32 portid;
-	int report;
-};
-
-struct nf_exp_event_notifier {
-	int (*exp_event)(unsigned int events, struct nf_exp_event *item);
-};
-
-int nf_ct_expect_register_notifier(struct net *net,
-				   struct nf_exp_event_notifier *nb);
-void nf_ct_expect_unregister_notifier(struct net *net,
-				      struct nf_exp_event_notifier *nb);
-
 void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			       struct nf_conntrack_expect *exp,
 			       u32 portid, int report);
diff --git a/include/net/netns/conntrack.h b/include/net/netns/conntrack.h
index fefd38db95b3..0294f3d473af 100644
--- a/include/net/netns/conntrack.h
+++ b/include/net/netns/conntrack.h
@@ -113,7 +113,6 @@ struct netns_ct {
 	struct ct_pcpu __percpu *pcpu_lists;
 	struct ip_conntrack_stat __percpu *stat;
 	struct nf_ct_event_notifier __rcu *nf_conntrack_event_cb;
-	struct nf_exp_event_notifier __rcu *nf_expect_event_cb;
 	struct nf_ip_net	nf_ct_proto;
 #if defined(CONFIG_NF_CONNTRACK_LABELS)
 	unsigned int		labels_used;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index d92f78e4bc7c..41768ff19464 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -240,11 +240,11 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 
 {
 	struct net *net = nf_ct_exp_net(exp);
-	struct nf_exp_event_notifier *notify;
+	struct nf_ct_event_notifier *notify;
 	struct nf_conntrack_ecache *e;
 
 	rcu_read_lock();
-	notify = rcu_dereference(net->ct.nf_expect_event_cb);
+	notify = rcu_dereference(net->ct.nf_conntrack_event_cb);
 	if (!notify)
 		goto out_unlock;
 
@@ -283,47 +283,10 @@ void nf_conntrack_unregister_notifier(struct net *net)
 	mutex_lock(&nf_ct_ecache_mutex);
 	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
 	mutex_unlock(&nf_ct_ecache_mutex);
-	/* synchronize_rcu() is called from ctnetlink_exit. */
+	/* synchronize_rcu() is called after netns pre_exit */
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_unregister_notifier);
 
-int nf_ct_expect_register_notifier(struct net *net,
-				   struct nf_exp_event_notifier *new)
-{
-	int ret;
-	struct nf_exp_event_notifier *notify;
-
-	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
-					   lockdep_is_held(&nf_ct_ecache_mutex));
-	if (notify != NULL) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-	rcu_assign_pointer(net->ct.nf_expect_event_cb, new);
-	ret = 0;
-
-out_unlock:
-	mutex_unlock(&nf_ct_ecache_mutex);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nf_ct_expect_register_notifier);
-
-void nf_ct_expect_unregister_notifier(struct net *net,
-				      struct nf_exp_event_notifier *new)
-{
-	struct nf_exp_event_notifier *notify;
-
-	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(net->ct.nf_expect_event_cb,
-					   lockdep_is_held(&nf_ct_ecache_mutex));
-	BUG_ON(notify != new);
-	RCU_INIT_POINTER(net->ct.nf_expect_event_cb, NULL);
-	mutex_unlock(&nf_ct_ecache_mutex);
-	/* synchronize_rcu() is called from ctnetlink_exit. */
-}
-EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
-
 void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6d6f7cd70753..5008fa0891b3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3104,7 +3104,7 @@ ctnetlink_exp_fill_info(struct sk_buff *skb, u32 portid, u32 seq,
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static int
-ctnetlink_expect_event(unsigned int events, struct nf_exp_event *item)
+ctnetlink_expect_event(unsigned int events, const struct nf_exp_event *item)
 {
 	struct nf_conntrack_expect *exp = item->exp;
 	struct net *net = nf_ct_exp_net(exp);
@@ -3756,9 +3756,6 @@ static int ctnetlink_stat_exp_cpu(struct sk_buff *skb,
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static struct nf_ct_event_notifier ctnl_notifier = {
 	.ct_event = ctnetlink_conntrack_event,
-};
-
-static struct nf_exp_event_notifier ctnl_notifier_exp = {
 	.exp_event = ctnetlink_expect_event,
 };
 #endif
@@ -3852,42 +3849,21 @@ MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK_EXP);
 static int __net_init ctnetlink_net_init(struct net *net)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	int ret;
-
 	nf_conntrack_register_notifier(net, &ctnl_notifier);
-
-	ret = nf_ct_expect_register_notifier(net, &ctnl_notifier_exp);
-	if (ret < 0) {
-		pr_err("ctnetlink_init: cannot expect register notifier.\n");
-		nf_conntrack_unregister_notifier(net);
-		return ret;
-	}
 #endif
 	return 0;
 }
 
-static void ctnetlink_net_exit(struct net *net)
+static void ctnetlink_net_pre_exit(struct net *net)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	nf_ct_expect_unregister_notifier(net, &ctnl_notifier_exp);
 	nf_conntrack_unregister_notifier(net);
 #endif
 }
 
-static void __net_exit ctnetlink_net_exit_batch(struct list_head *net_exit_list)
-{
-	struct net *net;
-
-	list_for_each_entry(net, net_exit_list, exit_list)
-		ctnetlink_net_exit(net);
-
-	/* wait for other cpus until they are done with ctnl_notifiers */
-	synchronize_rcu();
-}
-
 static struct pernet_operations ctnetlink_net_ops = {
 	.init		= ctnetlink_net_init,
-	.exit_batch	= ctnetlink_net_exit_batch,
+	.pre_exit	= ctnetlink_net_pre_exit,
 };
 
 static int __init ctnetlink_init(void)
-- 
2.20.1

