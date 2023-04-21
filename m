Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EA4C6EB5F5
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbjDUXus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbjDUXuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:50:32 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 510E82682;
        Fri, 21 Apr 2023 16:50:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 09/19] netfilter: nf_tables: do not store rule in traceinfo structure
Date:   Sat, 22 Apr 2023 01:50:11 +0200
Message-Id: <20230421235021.216950-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421235021.216950-1-pablo@netfilter.org>
References: <20230421235021.216950-1-pablo@netfilter.org>
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

pass it as argument instead.  This reduces size of traceinfo to
16 bytes.  Total stack usage:

 nf_tables_core.c:252 nft_do_chain    304     static

While its possible to also pass basechain as argument, doing so
increases nft_do_chaininfo function size.

Unlike pktinfo/verdict/rule the basechain info isn't used in
the expression evaluation path. gcc places it on the stack, which
results in extra push/pop when it gets passed to the trace helpers
as argument rather than as part of the traceinfo structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 +--
 net/netfilter/nf_tables_core.c    | 15 +++++++--------
 net/netfilter/nf_tables_trace.c   | 14 ++++++++------
 3 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 693469ecfa54..58a4d217faaf 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1409,7 +1409,6 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
  *	@skbid: hash of skb to be used as trace id
  *	@packet_dumped: packet headers sent in a previous traceinfo message
  *	@basechain: base chain currently processed
- *	@rule:  rule that was evaluated
  */
 struct nft_traceinfo {
 	bool				trace;
@@ -1418,7 +1417,6 @@ struct nft_traceinfo {
 	enum nft_trace_types		type:8;
 	u32				skbid;
 	const struct nft_base_chain	*basechain;
-	const struct nft_rule_dp	*rule;
 };
 
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
@@ -1426,6 +1424,7 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 
 void nft_trace_notify(const struct nft_pktinfo *pkt,
 		      const struct nft_verdict *verdict,
+		      const struct nft_rule_dp *rule,
 		      struct nft_traceinfo *info);
 
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 6debe8b2623f..4d0ce12221f6 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -43,6 +43,7 @@ static inline void nf_skip_indirect_calls_enable(void) { }
 
 static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 					const struct nft_verdict *verdict,
+					const struct nft_rule_dp *rule,
 					struct nft_traceinfo *info,
 					enum nft_trace_types type)
 {
@@ -51,7 +52,7 @@ static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 
 	info->type = type;
 
-	nft_trace_notify(pkt, verdict, info);
+	nft_trace_notify(pkt, verdict, rule, info);
 }
 
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
@@ -62,8 +63,7 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->nf_trace = pkt->skb->nf_trace;
-		info->rule = rule;
-		__nft_trace_packet(pkt, verdict, info, type);
+		__nft_trace_packet(pkt, verdict, rule, info, type);
 	}
 }
 
@@ -110,6 +110,7 @@ static void nft_cmp16_fast_eval(const struct nft_expr *expr,
 
 static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 					 struct nft_traceinfo *info,
+					 const struct nft_rule_dp *rule,
 					 const struct nft_regs *regs)
 {
 	enum nft_trace_types type;
@@ -131,7 +132,7 @@ static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 		break;
 	}
 
-	__nft_trace_packet(pkt, &regs->verdict, info, type);
+	__nft_trace_packet(pkt, &regs->verdict, rule, info, type);
 }
 
 static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
@@ -139,10 +140,8 @@ static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
 				     const struct nft_rule_dp *rule,
 				     const struct nft_regs *regs)
 {
-	if (static_branch_unlikely(&nft_trace_enabled)) {
-		info->rule = rule;
-		__nft_trace_verdict(pkt, info, regs);
-	}
+	if (static_branch_unlikely(&nft_trace_enabled))
+		__nft_trace_verdict(pkt, info, rule, regs);
 }
 
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index e635104a42be..6d41c0bd3d78 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -125,9 +125,10 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 
 static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 				   const struct nft_verdict *verdict,
+				   const struct nft_rule_dp *rule,
 				   const struct nft_traceinfo *info)
 {
-	if (!info->rule || info->rule->is_last)
+	if (!rule || rule->is_last)
 		return 0;
 
 	/* a continue verdict with ->type == RETURN means that this is
@@ -140,7 +141,7 @@ static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 		return 0;
 
 	return nla_put_be64(nlskb, NFTA_TRACE_RULE_HANDLE,
-			    cpu_to_be64(info->rule->handle),
+			    cpu_to_be64(rule->handle),
 			    NFTA_TRACE_PAD);
 }
 
@@ -166,9 +167,9 @@ static bool nft_trace_have_verdict_chain(const struct nft_verdict *verdict,
 	return true;
 }
 
-static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *info)
+static const struct nft_chain *nft_trace_get_chain(const struct nft_rule_dp *rule,
+						   const struct nft_traceinfo *info)
 {
-	const struct nft_rule_dp *rule = info->rule;
 	const struct nft_rule_dp_last *last;
 
 	if (!rule)
@@ -187,6 +188,7 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *i
 
 void nft_trace_notify(const struct nft_pktinfo *pkt,
 		      const struct nft_verdict *verdict,
+		      const struct nft_rule_dp *rule,
 		      struct nft_traceinfo *info)
 {
 	const struct nft_chain *chain;
@@ -199,7 +201,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	if (!nfnetlink_has_listeners(nft_net(pkt), NFNLGRP_NFTRACE))
 		return;
 
-	chain = nft_trace_get_chain(info);
+	chain = nft_trace_get_chain(rule, info);
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg)) +
 		nla_total_size(strlen(chain->table->name)) +
@@ -248,7 +250,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	if (nla_put_string(skb, NFTA_TRACE_TABLE, chain->table->name))
 		goto nla_put_failure;
 
-	if (nf_trace_fill_rule_info(skb, verdict, info))
+	if (nf_trace_fill_rule_info(skb, verdict, rule, info))
 		goto nla_put_failure;
 
 	switch (info->type) {
-- 
2.30.2

