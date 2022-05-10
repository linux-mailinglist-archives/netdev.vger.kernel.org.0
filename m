Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B509F52154D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241750AbiEJM2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241691AbiEJM0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:26:00 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D4190ABF7B;
        Tue, 10 May 2022 05:22:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/17] netfilter: conntrack: un-inline nf_ct_ecache_ext_add
Date:   Tue, 10 May 2022 14:21:46 +0200
Message-Id: <20220510122150.92533-14-pablo@netfilter.org>
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

Only called when new ct is allocated or the extension isn't present.
This function will be extended, place this in the conntrack module
instead of inlining.

The callers already depend on nf_conntrack module.
Return value is changed to bool, noone used the returned pointer.

Make sure that the core drops the newly allocated conntrack
if the extension is requested but can't be added.
This makes it necessary to ifdef the section, as the stub
always returns false we'd drop every new conntrack if the
the ecache extension is disabled in kconfig.

Add from data path (xt_CT, nft_ct) is unchanged.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_ecache.h | 30 ++++-----------------
 net/netfilter/nf_conntrack_core.c           | 14 +++++++---
 net/netfilter/nf_conntrack_ecache.c         | 22 +++++++++++++++
 3 files changed, 38 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index b57d73785e4d..2e3d58439e34 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -36,31 +36,6 @@ nf_ct_ecache_find(const struct nf_conn *ct)
 #endif
 }
 
-static inline struct nf_conntrack_ecache *
-nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
-{
-#ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct net *net = nf_ct_net(ct);
-	struct nf_conntrack_ecache *e;
-
-	if (!ctmask && !expmask && net->ct.sysctl_events) {
-		ctmask = ~0;
-		expmask = ~0;
-	}
-	if (!ctmask && !expmask)
-		return NULL;
-
-	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
-	if (e) {
-		e->ctmask  = ctmask;
-		e->expmask = expmask;
-	}
-	return e;
-#else
-	return NULL;
-#endif
-}
-
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 
 /* This structure is passed to event handler */
@@ -89,6 +64,7 @@ void nf_ct_deliver_cached_events(struct nf_conn *ct);
 int nf_conntrack_eventmask_report(unsigned int eventmask, struct nf_conn *ct,
 				  u32 portid, int report);
 
+bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp);
 #else
 
 static inline void nf_ct_deliver_cached_events(const struct nf_conn *ct)
@@ -103,6 +79,10 @@ static inline int nf_conntrack_eventmask_report(unsigned int eventmask,
 	return 0;
 }
 
+static inline bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
+{
+	return false;
+}
 #endif
 
 static inline void
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index d3ffdfbe4dd9..fc772045b67d 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1701,7 +1701,9 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	struct nf_conn *ct;
 	struct nf_conn_help *help;
 	struct nf_conntrack_tuple repl_tuple;
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	struct nf_conntrack_ecache *ecache;
+#endif
 	struct nf_conntrack_expect *exp = NULL;
 	const struct nf_conntrack_zone *zone;
 	struct nf_conn_timeout *timeout_ext;
@@ -1734,10 +1736,16 @@ init_conntrack(struct net *net, struct nf_conn *tmpl,
 	nf_ct_tstamp_ext_add(ct, GFP_ATOMIC);
 	nf_ct_labels_ext_add(ct);
 
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
 	ecache = tmpl ? nf_ct_ecache_find(tmpl) : NULL;
-	nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
-				 ecache ? ecache->expmask : 0,
-			     GFP_ATOMIC);
+
+	if (!nf_ct_ecache_ext_add(ct, ecache ? ecache->ctmask : 0,
+				  ecache ? ecache->expmask : 0,
+				  GFP_ATOMIC)) {
+		nf_conntrack_free(ct);
+		return ERR_PTR(-ENOMEM);
+	}
+#endif
 
 	cnet = nf_ct_pernet(net);
 	if (cnet->expect_count) {
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 0d075161ae3a..0ed4cf2464c9 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -298,6 +298,28 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	}
 }
 
+bool nf_ct_ecache_ext_add(struct nf_conn *ct, u16 ctmask, u16 expmask, gfp_t gfp)
+{
+	struct net *net = nf_ct_net(ct);
+	struct nf_conntrack_ecache *e;
+
+	if (!ctmask && !expmask && net->ct.sysctl_events) {
+		ctmask = ~0;
+		expmask = ~0;
+	}
+	if (!ctmask && !expmask)
+		return false;
+
+	e = nf_ct_ext_add(ct, NF_CT_EXT_ECACHE, gfp);
+	if (e) {
+		e->ctmask  = ctmask;
+		e->expmask = expmask;
+	}
+
+	return e != NULL;
+}
+EXPORT_SYMBOL_GPL(nf_ct_ecache_ext_add);
+
 #define NF_CT_EVENTS_DEFAULT 1
 static int nf_ct_events __read_mostly = NF_CT_EVENTS_DEFAULT;
 
-- 
2.30.2

