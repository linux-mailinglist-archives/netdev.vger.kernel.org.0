Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C643752154A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241766AbiEJM2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:28:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241697AbiEJM0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:26:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E92A79BAFD;
        Tue, 10 May 2022 05:22:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 15/17] netfilter: prefer extension check to pointer check
Date:   Tue, 10 May 2022 14:21:48 +0200
Message-Id: <20220510122150.92533-16-pablo@netfilter.org>
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

The pointer check usually results in a 'false positive': its likely
that the ctnetlink module is loaded but no event monitoring is enabled.

After recent change to autodetect ctnetlink usage and only allocate
the ecache extension if a listener is active, check if the extension
is present on a given conntrack.

If its not there, there is nothing to report and calls to the
notification framework can be elided.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack_core.h   |  2 +-
 include/net/netfilter/nf_conntrack_ecache.h | 31 ++++++++++-----------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_core.h b/include/net/netfilter/nf_conntrack_core.h
index 13807ea94cd2..6406cfee34c2 100644
--- a/include/net/netfilter/nf_conntrack_core.h
+++ b/include/net/netfilter/nf_conntrack_core.h
@@ -60,7 +60,7 @@ static inline int nf_conntrack_confirm(struct sk_buff *skb)
 	if (ct) {
 		if (!nf_ct_is_confirmed(ct))
 			ret = __nf_conntrack_confirm(skb);
-		if (likely(ret == NF_ACCEPT))
+		if (ret == NF_ACCEPT && nf_ct_ecache_exist(ct))
 			nf_ct_deliver_cached_events(ct);
 	}
 	return ret;
diff --git a/include/net/netfilter/nf_conntrack_ecache.h b/include/net/netfilter/nf_conntrack_ecache.h
index 2e3d58439e34..0c1dac318e02 100644
--- a/include/net/netfilter/nf_conntrack_ecache.h
+++ b/include/net/netfilter/nf_conntrack_ecache.h
@@ -36,6 +36,15 @@ nf_ct_ecache_find(const struct nf_conn *ct)
 #endif
 }
 
+static inline bool nf_ct_ecache_exist(const struct nf_conn *ct)
+{
+#ifdef CONFIG_NF_CONNTRACK_EVENTS
+	return nf_ct_ext_exist(ct, NF_CT_EXT_ECACHE);
+#else
+	return false;
+#endif
+}
+
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 
 /* This structure is passed to event handler */
@@ -108,30 +117,20 @@ nf_conntrack_event_report(enum ip_conntrack_events event, struct nf_conn *ct,
 			  u32 portid, int report)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	const struct net *net = nf_ct_net(ct);
-
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
-		return 0;
-
-	return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
-#else
-	return 0;
+	if (nf_ct_ecache_exist(ct))
+		return nf_conntrack_eventmask_report(1 << event, ct, portid, report);
 #endif
+	return 0;
 }
 
 static inline int
 nf_conntrack_event(enum ip_conntrack_events event, struct nf_conn *ct)
 {
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	const struct net *net = nf_ct_net(ct);
-
-	if (!rcu_access_pointer(net->ct.nf_conntrack_event_cb))
-		return 0;
-
-	return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
-#else
-	return 0;
+	if (nf_ct_ecache_exist(ct))
+		return nf_conntrack_eventmask_report(1 << event, ct, 0, 0);
 #endif
+	return 0;
 }
 
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-- 
2.30.2

