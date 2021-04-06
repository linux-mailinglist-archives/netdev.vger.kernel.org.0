Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4E43553C6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344226AbhDFMXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:23:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34488 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344002AbhDFMWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:07 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 39BEC63E65;
        Tue,  6 Apr 2021 14:21:39 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 27/28] netfilter: conntrack: move ecache dwork to net_generic infra
Date:   Tue,  6 Apr 2021 14:21:32 +0200
Message-Id: <20210406122133.1644-28-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

dwork struct is large (>128 byte) and not needed when conntrack module
is not loaded.

Place it in net_generic data instead.  The struct net dwork member is now
obsolete and will be removed in a followup patch.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h        |  4 +++
 include/net/netfilter/nf_conntrack_ecache.h | 33 ++++++++-------------
 net/netfilter/nf_conntrack_core.c           |  7 +++--
 net/netfilter/nf_conntrack_ecache.c         | 31 +++++++++++++++----
 4 files changed, 47 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index ef405a134307..86d86c860ede 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -50,6 +50,10 @@ struct nf_conntrack_net {
 #ifdef CONFIG_SYSCTL
 	struct ctl_table_header	*sysctl_header;
 #endif
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	struct delayed_work ecache_dwork;
+	struct netns_ct *ct_net;
+#endif
 };
 
 #include <linux/types.h>
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index eb81f9195e28..d00ba6048e44 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -171,12 +171,18 @@ void nf_ct_expect_event_report(enum ip_conntrack_expect_events event,
 			       struct nf_conntrack_expect *exp,
 			       u32 portid, int report);
 
+void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state);
+
 void nf_conntrack_ecache_pernet_init(struct net *net);
 void nf_conntrack_ecache_pernet_fini(struct net *net);
 
 int nf_conntrack_ecache_init(void);
 void nf_conntrack_ecache_fini(void);
 
+static inline bool nf_conntrack_ecache_dwork_pending(const struct net *net)
+{
+	return net->ct.ecache_dwork_pending;
+}
 #else /* CONFIG_NF_CONNTRACK_EVENTS */
 
 static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
@@ -186,6 +192,11 @@ static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
 {
 }
 
+static inline void nf_conntrack_ecache_work(struct net *net,
+					    enum nf_ct_ecache_state s)
+{
+}
+
 static inline void nf_conntrack_ecache_pernet_init(struct net *net)
 {
 }
@@ -203,26 +214,6 @@ static inline void nf_conntrack_ecache_fini(void)
 {
 }
 
+static inline bool nf_conntrack_ecache_dwork_pending(const struct net *net) { return false; }
 #endif /* CONFIG_NF_CONNTRACK_EVENTS */
-
-static inline void nf_conntrack_ecache_delayed_work(struct net *net)
-{
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	if (!delayed_work_pending(&net->ct.ecache_dwork)) {
-		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
-		net->ct.ecache_dwork_pending = true;
-	}
-#endif
-}
-
-static inline void nf_conntrack_ecache_work(struct net *net)
-{
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	if (net->ct.ecache_dwork_pending) {
-		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &net->ct.ecache_dwork, 0);
-	}
-#endif
-}
-
 #endif /*_NF_CONNTRACK_ECACHE_H*/
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index ff0168736f6e..ace3e8265e0a 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -656,6 +656,7 @@ static void nf_ct_delete_from_lists(struct nf_conn *ct)
 bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 {
 	struct nf_conn_tstamp *tstamp;
+	struct net *net;
 
 	if (test_and_set_bit(IPS_DYING_BIT, &ct->status))
 		return false;
@@ -670,11 +671,13 @@ bool nf_ct_delete(struct nf_conn *ct, u32 portid, int report)
 		 * be done by event cache worker on redelivery.
 		 */
 		nf_ct_delete_from_lists(ct);
-		nf_conntrack_ecache_delayed_work(nf_ct_net(ct));
+		nf_conntrack_ecache_work(nf_ct_net(ct), NFCT_ECACHE_DESTROY_FAIL);
 		return false;
 	}
 
-	nf_conntrack_ecache_work(nf_ct_net(ct));
+	net = nf_ct_net(ct);
+	if (nf_conntrack_ecache_dwork_pending(net))
+		nf_conntrack_ecache_work(net, NFCT_ECACHE_DESTROY_SENT);
 	nf_ct_delete_from_lists(ct);
 	nf_ct_put(ct);
 	return true;
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 7956c9f19899..759d87aef95f 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -27,6 +27,8 @@
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_conntrack_extend.h>
 
+extern unsigned int nf_conntrack_net_id;
+
 static DEFINE_MUTEX(nf_ct_ecache_mutex);
 
 #define ECACHE_RETRY_WAIT (HZ/10)
@@ -96,8 +98,8 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 
 static void ecache_work(struct work_struct *work)
 {
-	struct netns_ct *ctnet =
-		container_of(work, struct netns_ct, ecache_dwork.work);
+	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache_dwork.work);
+	struct netns_ct *ctnet = cnet->ct_net;
 	int cpu, delay = -1;
 	struct ct_pcpu *pcpu;
 
@@ -127,7 +129,7 @@ static void ecache_work(struct work_struct *work)
 
 	ctnet->ecache_dwork_pending = delay > 0;
 	if (delay >= 0)
-		schedule_delayed_work(&ctnet->ecache_dwork, delay);
+		schedule_delayed_work(&cnet->ecache_dwork, delay);
 }
 
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
@@ -344,6 +346,20 @@ void nf_ct_expect_unregister_notifier(struct net *net,
 }
 EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
 
+void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
+{
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
+	if (state == NFCT_ECACHE_DESTROY_FAIL &&
+	    !delayed_work_pending(&cnet->ecache_dwork)) {
+		schedule_delayed_work(&cnet->ecache_dwork, HZ);
+		net->ct.ecache_dwork_pending = true;
+	} else if (state == NFCT_ECACHE_DESTROY_SENT) {
+		net->ct.ecache_dwork_pending = false;
+		mod_delayed_work(system_wq, &cnet->ecache_dwork, 0);
+	}
+}
+
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
@@ -355,13 +371,18 @@ static const struct nf_ct_ext_type event_extend = {
 
 void nf_conntrack_ecache_pernet_init(struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
 	net->ct.sysctl_events = nf_ct_events;
-	INIT_DELAYED_WORK(&net->ct.ecache_dwork, ecache_work);
+	cnet->ct_net = &net->ct;
+	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
 }
 
 void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
-	cancel_delayed_work_sync(&net->ct.ecache_dwork);
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
+	cancel_delayed_work_sync(&cnet->ecache_dwork);
 }
 
 int nf_conntrack_ecache_init(void)
-- 
2.30.2

