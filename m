Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5046EB563
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbjDUXCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233714AbjDUXCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13513212F;
        Fri, 21 Apr 2023 16:02:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 09/20] netfilter: nf_tables: do not store verdict in traceinfo structure
Date:   Sat, 22 Apr 2023 01:02:00 +0200
Message-Id: <20230421230211.214635-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230421230211.214635-1-pablo@netfilter.org>
References: <20230421230211.214635-1-pablo@netfilter.org>
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

Just pass it as argument to nft_trace_notify. Stack is reduced by 8 bytes:

nf_tables_core.c:256 nft_do_chain    312     static

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 +---
 net/netfilter/nf_tables_core.c    | 14 ++++++++------
 net/netfilter/nf_tables_trace.c   | 21 +++++++++++----------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cab351928cd2..693469ecfa54 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1410,7 +1410,6 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
  *	@packet_dumped: packet headers sent in a previous traceinfo message
  *	@basechain: base chain currently processed
  *	@rule:  rule that was evaluated
- *	@verdict: verdict given by rule
  */
 struct nft_traceinfo {
 	bool				trace;
@@ -1420,14 +1419,13 @@ struct nft_traceinfo {
 	u32				skbid;
 	const struct nft_base_chain	*basechain;
 	const struct nft_rule_dp	*rule;
-	const struct nft_verdict	*verdict;
 };
 
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
-		    const struct nft_verdict *verdict,
 		    const struct nft_chain *basechain);
 
 void nft_trace_notify(const struct nft_pktinfo *pkt,
+		      const struct nft_verdict *verdict,
 		      struct nft_traceinfo *info);
 
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 776eb2b9f632..6debe8b2623f 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -42,6 +42,7 @@ static inline void nf_skip_indirect_calls_enable(void) { }
 #endif
 
 static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
+					const struct nft_verdict *verdict,
 					struct nft_traceinfo *info,
 					enum nft_trace_types type)
 {
@@ -50,10 +51,11 @@ static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
 
 	info->type = type;
 
-	nft_trace_notify(pkt, info);
+	nft_trace_notify(pkt, verdict, info);
 }
 
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+				    struct nft_verdict *verdict,
 				    struct nft_traceinfo *info,
 				    const struct nft_rule_dp *rule,
 				    enum nft_trace_types type)
@@ -61,7 +63,7 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
-		__nft_trace_packet(pkt, info, type);
+		__nft_trace_packet(pkt, verdict, info, type);
 	}
 }
 
@@ -129,7 +131,7 @@ static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
 		break;
 	}
 
-	__nft_trace_packet(pkt, info, type);
+	__nft_trace_packet(pkt, &regs->verdict, info, type);
 }
 
 static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
@@ -264,7 +266,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	info.trace = false;
 	if (static_branch_unlikely(&nft_trace_enabled))
-		nft_trace_init(&info, pkt, &regs.verdict, basechain);
+		nft_trace_init(&info, pkt, basechain);
 do_chain:
 	if (genbit)
 		blob = rcu_dereference(chain->blob_gen_1);
@@ -296,7 +298,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 			nft_trace_copy_nftrace(pkt, &info);
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(pkt, &info, rule,
+			nft_trace_packet(pkt, &regs.verdict,  &info, rule,
 					 NFT_TRACETYPE_RULE);
 			continue;
 		}
@@ -336,7 +338,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		goto next_rule;
 	}
 
-	nft_trace_packet(pkt, &info, NULL, NFT_TRACETYPE_POLICY);
+	nft_trace_packet(pkt, &regs.verdict, &info, NULL, NFT_TRACETYPE_POLICY);
 
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 0a0dcf2587fd..e635104a42be 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -124,6 +124,7 @@ static int nf_trace_fill_pkt_info(struct sk_buff *nlskb,
 }
 
 static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
+				   const struct nft_verdict *verdict,
 				   const struct nft_traceinfo *info)
 {
 	if (!info->rule || info->rule->is_last)
@@ -135,7 +136,7 @@ static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 	 * Since no rule matched, the ->rule pointer is invalid.
 	 */
 	if (info->type == NFT_TRACETYPE_RETURN &&
-	    info->verdict->code == NFT_CONTINUE)
+	    verdict->code == NFT_CONTINUE)
 		return 0;
 
 	return nla_put_be64(nlskb, NFTA_TRACE_RULE_HANDLE,
@@ -143,7 +144,8 @@ static int nf_trace_fill_rule_info(struct sk_buff *nlskb,
 			    NFTA_TRACE_PAD);
 }
 
-static bool nft_trace_have_verdict_chain(struct nft_traceinfo *info)
+static bool nft_trace_have_verdict_chain(const struct nft_verdict *verdict,
+					 struct nft_traceinfo *info)
 {
 	switch (info->type) {
 	case NFT_TRACETYPE_RETURN:
@@ -153,7 +155,7 @@ static bool nft_trace_have_verdict_chain(struct nft_traceinfo *info)
 		return false;
 	}
 
-	switch (info->verdict->code) {
+	switch (verdict->code) {
 	case NFT_JUMP:
 	case NFT_GOTO:
 		break;
@@ -184,6 +186,7 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *i
 }
 
 void nft_trace_notify(const struct nft_pktinfo *pkt,
+		      const struct nft_verdict *verdict,
 		      struct nft_traceinfo *info)
 {
 	const struct nft_chain *chain;
@@ -217,8 +220,8 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 		nla_total_size(sizeof(u32)) +		/* nfproto */
 		nla_total_size(sizeof(u32));		/* policy */
 
-	if (nft_trace_have_verdict_chain(info))
-		size += nla_total_size(strlen(info->verdict->chain->name)); /* jump target */
+	if (nft_trace_have_verdict_chain(verdict, info))
+		size += nla_total_size(strlen(verdict->chain->name)); /* jump target */
 
 	skb = nlmsg_new(size, GFP_ATOMIC);
 	if (!skb)
@@ -245,7 +248,7 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 	if (nla_put_string(skb, NFTA_TRACE_TABLE, chain->table->name))
 		goto nla_put_failure;
 
-	if (nf_trace_fill_rule_info(skb, info))
+	if (nf_trace_fill_rule_info(skb, verdict, info))
 		goto nla_put_failure;
 
 	switch (info->type) {
@@ -254,11 +257,11 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 		break;
 	case NFT_TRACETYPE_RETURN:
 	case NFT_TRACETYPE_RULE:
-		if (nft_verdict_dump(skb, NFTA_TRACE_VERDICT, info->verdict))
+		if (nft_verdict_dump(skb, NFTA_TRACE_VERDICT, verdict))
 			goto nla_put_failure;
 
 		/* pkt->skb undefined iff NF_STOLEN, disable dump */
-		if (info->verdict->code == NF_STOLEN)
+		if (verdict->code == NF_STOLEN)
 			info->packet_dumped = true;
 		else
 			mark = pkt->skb->mark;
@@ -295,7 +298,6 @@ void nft_trace_notify(const struct nft_pktinfo *pkt,
 }
 
 void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
-		    const struct nft_verdict *verdict,
 		    const struct nft_chain *chain)
 {
 	static siphash_key_t trace_key __read_mostly;
@@ -305,7 +307,6 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 	info->trace = true;
 	info->nf_trace = pkt->skb->nf_trace;
 	info->packet_dumped = false;
-	info->verdict = verdict;
 
 	net_get_random_once(&trace_key, sizeof(trace_key));
 
-- 
2.30.2

