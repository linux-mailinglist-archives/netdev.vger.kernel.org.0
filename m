Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F783FB343
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236204AbhH3JkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:40:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42602 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235950AbhH3Jj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:39:59 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id A74F3600D2;
        Mon, 30 Aug 2021 11:38:06 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 4/8] netfilter: ecache: prepare for event notifier merge
Date:   Mon, 30 Aug 2021 11:38:48 +0200
Message-Id: <20210830093852.21654-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This prepares for merge for ct and exp notifier structs.

The 'fcn' member is renamed to something unique.
Second, the register/unregister api is simplified.  There is only
one implementation so there is no need to do any error checking.

Replace the EBUSY logic with WARN_ON_ONCE.  This allows to remove
error unwinding.

The exp notifier register/unregister function is removed in
a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h | 11 ++++-----
 net/netfilter/nf_conntrack_ecache.c         | 26 +++++----------------
 net/netfilter/nf_conntrack_netlink.c        | 22 +++++------------
 3 files changed, 17 insertions(+), 42 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 3734bacf9763..061a93a03b82 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -73,13 +73,12 @@ struct nf_ct_event {
 };
 
 struct nf_ct_event_notifier {
-	int (*fcn)(unsigned int events, const struct nf_ct_event *item);
+	int (*ct_event)(unsigned int events, const struct nf_ct_event *item);
 };
 
-int nf_conntrack_register_notifier(struct net *net,
-				   struct nf_ct_event_notifier *nb);
-void nf_conntrack_unregister_notifier(struct net *net,
-				      struct nf_ct_event_notifier *nb);
+void nf_conntrack_register_notifier(struct net *net,
+				   const struct nf_ct_event_notifier *nb);
+void nf_conntrack_unregister_notifier(struct net *net);
 
 void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
@@ -159,7 +158,7 @@ struct nf_exp_event {
 };
 
 struct nf_exp_event_notifier {
-	int (*fcn)(unsigned int events, struct nf_exp_event *item);
+	int (*exp_event)(unsigned int events, struct nf_exp_event *item);
 };
 
 int nf_ct_expect_register_notifier(struct net *net,
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index fbe04e16280a..d92f78e4bc7c 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -151,7 +151,7 @@ static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
 		return 0;
 	}
 
-	ret = notify->fcn(events | missed, item);
+	ret = notify->ct_event(events | missed, item);
 	rcu_read_unlock();
 
 	if (likely(ret >= 0 && missed == 0))
@@ -258,43 +258,29 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			.portid	= portid,
 			.report = report
 		};
-		notify->fcn(1 << event, &item);
+		notify->exp_event(1 << event, &item);
 	}
 out_unlock:
 	rcu_read_unlock();
 }
 
-int nf_conntrack_register_notifier(struct net *net,
-				   struct nf_ct_event_notifier *new)
+void nf_conntrack_register_notifier(struct net *net,
+				    const struct nf_ct_event_notifier *new)
 {
-	int ret;
 	struct nf_ct_event_notifier *notify;
 
 	mutex_lock(&nf_ct_ecache_mutex);
 	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
 					   lockdep_is_held(&nf_ct_ecache_mutex));
-	if (notify != NULL) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
+	WARN_ON_ONCE(notify);
 	rcu_assign_pointer(net->ct.nf_conntrack_event_cb, new);
-	ret = 0;
-
-out_unlock:
 	mutex_unlock(&nf_ct_ecache_mutex);
-	return ret;
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_register_notifier);
 
-void nf_conntrack_unregister_notifier(struct net *net,
-				      struct nf_ct_event_notifier *new)
+void nf_conntrack_unregister_notifier(struct net *net)
 {
-	struct nf_ct_event_notifier *notify;
-
 	mutex_lock(&nf_ct_ecache_mutex);
-	notify = rcu_dereference_protected(net->ct.nf_conntrack_event_cb,
-					   lockdep_is_held(&nf_ct_ecache_mutex));
-	BUG_ON(notify != new);
 	RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
 	mutex_unlock(&nf_ct_ecache_mutex);
 	/* synchronize_rcu() is called from ctnetlink_exit. */
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 43b891a902de..6d6f7cd70753 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3755,11 +3755,11 @@ static int ctnetlink_stat_exp_cpu(struct sk_buff *skb,
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 static struct nf_ct_event_notifier ctnl_notifier = {
-	.fcn = ctnetlink_conntrack_event,
+	.ct_event = ctnetlink_conntrack_event,
 };
 
 static struct nf_exp_event_notifier ctnl_notifier_exp = {
-	.fcn = ctnetlink_expect_event,
+	.exp_event = ctnetlink_expect_event,
 };
 #endif
 
@@ -3854,33 +3854,23 @@ static int __net_init ctnetlink_net_init(struct net *net)
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	int ret;
 
-	ret = nf_conntrack_register_notifier(net, &ctnl_notifier);
-	if (ret < 0) {
-		pr_err("ctnetlink_init: cannot register notifier.\n");
-		goto err_out;
-	}
+	nf_conntrack_register_notifier(net, &ctnl_notifier);
 
 	ret = nf_ct_expect_register_notifier(net, &ctnl_notifier_exp);
 	if (ret < 0) {
 		pr_err("ctnetlink_init: cannot expect register notifier.\n");
-		goto err_unreg_notifier;
+		nf_conntrack_unregister_notifier(net);
+		return ret;
 	}
 #endif
 	return 0;
-
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-err_unreg_notifier:
-	nf_conntrack_unregister_notifier(net, &ctnl_notifier);
-err_out:
-	return ret;
-#endif
 }
 
 static void ctnetlink_net_exit(struct net *net)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	nf_ct_expect_unregister_notifier(net, &ctnl_notifier_exp);
-	nf_conntrack_unregister_notifier(net, &ctnl_notifier);
+	nf_conntrack_unregister_notifier(net);
 #endif
 }
 
-- 
2.20.1

