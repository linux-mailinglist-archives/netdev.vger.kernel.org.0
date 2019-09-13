Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 783C1B1C38
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 13:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388177AbfIMLb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 07:31:29 -0400
Received: from correo.us.es ([193.147.175.20]:42758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388155AbfIMLb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 07:31:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4CFD44FFE1D
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3CA7DA7E2A
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 13:31:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 312F5A7E1F; Fri, 13 Sep 2019 13:31:24 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F25E0A7E1F;
        Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BD2884265A5A;
        Fri, 13 Sep 2019 13:31:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 19/27] netfilter: conntrack: use consistent style when defining inline functions
Date:   Fri, 13 Sep 2019 13:30:54 +0200
Message-Id: <20190913113102.15776-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190913113102.15776-1-pablo@netfilter.org>
References: <20190913113102.15776-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

The header contains some inline functions defined as:

  static inline f (...)
  {
  #ifdef CONFIG_NF_CONNTRACK_EVENTS
    ...
  #else
    ...
  #endif
  }

and a few others as:

  #ifdef CONFIG_NF_CONNTRACK_EVENTS
  static inline f (...)
  {
    ...
  }
  #else
  static inline f (...)
  {
    ...
  }
  #endif

Prefer the former style, which is more numerous.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h | 82 ++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 32 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 0815bfadfefe..eb81f9195e28 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -64,6 +64,7 @@ nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
+
 /* This structure is passed to event handler */
 struct nf_ct_event {
 	struct nf_conn *ct;
@@ -84,9 +85,26 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 				  u32 portid, int report);
 
+#else
+
+static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct)
+{
+}
+
+static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
+						struct nf_conn *ct,
+						u32 portid,
+						int report)
+{
+	return 0;
+}
+
+#endif
+
 static inline void
 nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_ecache *e;
 
@@ -98,31 +116,42 @@ nf_conntrack_event_cache(enum ip_conntrack_events event, struct nf_conn *ct)
 		return;
 
 	set_bit(event, &e->cache);
+#endif
 }
 
 static inline int
 nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 portid, int report)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	const struct net *net = nf_ct_net(ct);
 
 	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
 		return 0;
 
 	return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
+#else
+	return 0;
+#endif
 }
 
 static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	const struct net *net = nf_ct_net(ct);
 
 	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
 		return 0;
 
 	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
+#else
+	return 0;
+#endif
 }
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+
 struct nf_exp_event {
 	struct nf_conntrack_expect *exp;
 	u32 portid;
@@ -148,41 +177,18 @@ void nf_conntrack_ecache_pernet_fini(struct net *net);
 int nf_conntrack_ecache_init(void);
 void nf_conntrack_ecache_fini(void);
 
-static inline void nf_conntrack_ecache_delayed_work(struct net *net)
+#else /* CONFIG_NF_CONNTRACK_EVENTS */
+
+static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
+					     struct nf_conntrack_expect *exp,
+					     u32 portid,
+					     int report)
 {
-	if (!delayed_work_pending(&net->ct.ecache_dwork)) {
-		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
-		net->ct.ecache_dwork_pending = true;
-	}
 }
 
-static inline void nf_conntrack_ecache_work(struct net *net)
+static inline void nf_conntrack_ecache_pernet_init(struct net *net)
 {
-	if (net->ct.ecache_dwork_pending) {
-		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &net->ct.ecache_dwork, 0);
-	}
 }
-#else /* CONFIG_NF_CONNTRACK_EVENTS */
-static inline void nf_conntrack_event_cache(enum ip_conntrack_events event,
-					    struct nf_conn *ct) {}
-static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
-						struct nf_conn *ct,
-						u32 portid,
-						int report) { return 0; }
-static inline int nf_conntrack_event(enum ip_conntrack_events event,
-				     struct nf_conn *ct) { return 0; }
-static inline int nf_conntrack_event_report(enum ip_conntrack_events event,
-					    struct nf_conn *ct,
-					    u32 portid,
-					    int report) { return 0; }
-static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct) {}
-static inline void nf_ct_expect_event_report(enum ip_conntrack_expect_events e,
-					     struct nf_conntrack_expect *exp,
- 					     u32 portid,
- 					     int report) {}
-
-static inline void nf_conntrack_ecache_pernet_init(struct net *net) {}
 
 static inline void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
@@ -197,14 +203,26 @@ static inline void nf_conntrack_ecache_fini(void)
 {
 }
 
+#endif /* CONFIG_NF_CONNTRACK_EVENTS */
+
 static inline void nf_conntrack_ecache_delayed_work(struct net *net)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	if (!delayed_work_pending(&net->ct.ecache_dwork)) {
+		schedule_delayed_work(&net->ct.ecache_dwork, HZ);
+		net->ct.ecache_dwork_pending = true;
+	}
+#endif
 }
 
 static inline void nf_conntrack_ecache_work(struct net *net)
 {
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	if (net->ct.ecache_dwork_pending) {
+		net->ct.ecache_dwork_pending = false;
+		mod_delayed_work(system_wq, &net->ct.ecache_dwork, 0);
+	}
+#endif
 }
-#endif /* CONFIG_NF_CONNTRACK_EVENTS */
 
 #endif /*_NF_CONNTRACK_ECACHE_H*/
-
-- 
2.11.0

