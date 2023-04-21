Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B2F6EB55D
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbjDUXCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 19:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231614AbjDUXCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 19:02:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7ECFA2109;
        Fri, 21 Apr 2023 16:02:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net-next 08/20] netfilter: nf_tables: do not store pktinfo in traceinfo structure
Date:   Sat, 22 Apr 2023 01:01:59 +0200
Message-Id: <20230421230211.214635-9-pablo@netfilter.org>
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

pass it as argument.  No change in object size.

stack usage decreases by 8 byte:
 nf_tables_core.c:254  nft_do_chain       320     static

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 ++---
 net/netfilter/nf_tables_core.c    | 21 ++++++++++++---------
 net/netfilter/nf_tables_trace.c   |  5 ++---
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ec347d9cff9e..cab351928cd2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1408,7 +1408,6 @@ void nft_unregister_flowtable_type(struct nf_flowtable_type *type);
  *	@type: event type (enum nft_trace_types)
  *	@skbid: hash of skb to be used as trace id
  *	@packet_dumped: packet headers sent in a previous traceinfo message
- *	@pkt: pktinfo currently processed
  *	@basechain: base chain currently processed
  *	@rule:  rule that was evaluated
  *	@verdict: verdict given by rule
@@ -1419,7 +1418,6 @@ struct nft_traceinfo {
 	bool				packet_dumped;
 	enum nft_trace_types		type:8;
 	u32				skbid;
-	const struct nft_pktinfo	*pkt;
 	const struct nft_base_chain	*basechain;
 	const struct nft_rule_dp	*rule;
 	const struct nft_verdict	*verdict;
@@ -1429,7 +1427,8 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 		    const struct nft_verdict *verdict,
 		    const struct nft_chain *basechain);
 
-void nft_trace_notify(struct nft_traceinfo *info);
+void nft_trace_notify(const struct nft_pktinfo *pkt,
+		      struct nft_traceinfo *info);
 
 #define MODULE_ALIAS_NFT_CHAIN(family, name) \
 	MODULE_ALIAS("nft-chain-" __stringify(family) "-" name)
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index bed855638050..776eb2b9f632 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -41,7 +41,8 @@ static inline bool nf_skip_indirect_calls(void) { return false; }
 static inline void nf_skip_indirect_calls_enable(void) { }
 #endif
 
-static noinline void __nft_trace_packet(struct nft_traceinfo *info,
+static noinline void __nft_trace_packet(const struct nft_pktinfo *pkt,
+					struct nft_traceinfo *info,
 					enum nft_trace_types type)
 {
 	if (!info->trace || !info->nf_trace)
@@ -49,7 +50,7 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 
 	info->type = type;
 
-	nft_trace_notify(info);
+	nft_trace_notify(pkt, info);
 }
 
 static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
@@ -60,7 +61,7 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
-		__nft_trace_packet(info, type);
+		__nft_trace_packet(pkt, info, type);
 	}
 }
 
@@ -105,7 +106,8 @@ static void nft_cmp16_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
-static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
+static noinline void __nft_trace_verdict(const struct nft_pktinfo *pkt,
+					 struct nft_traceinfo *info,
 					 const struct nft_regs *regs)
 {
 	enum nft_trace_types type;
@@ -123,20 +125,21 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 		type = NFT_TRACETYPE_RULE;
 
 		if (info->trace)
-			info->nf_trace = info->pkt->skb->nf_trace;
+			info->nf_trace = pkt->skb->nf_trace;
 		break;
 	}
 
-	__nft_trace_packet(info, type);
+	__nft_trace_packet(pkt, info, type);
 }
 
-static inline void nft_trace_verdict(struct nft_traceinfo *info,
+static inline void nft_trace_verdict(const struct nft_pktinfo *pkt,
+				     struct nft_traceinfo *info,
 				     const struct nft_rule_dp *rule,
 				     const struct nft_regs *regs)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
 		info->rule = rule;
-		__nft_trace_verdict(info, regs);
+		__nft_trace_verdict(pkt, info, regs);
 	}
 }
 
@@ -300,7 +303,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
-	nft_trace_verdict(&info, rule, &regs);
+	nft_trace_verdict(pkt, &info, rule, &regs);
 
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
diff --git a/net/netfilter/nf_tables_trace.c b/net/netfilter/nf_tables_trace.c
index 3d9b83d84a84..0a0dcf2587fd 100644
--- a/net/netfilter/nf_tables_trace.c
+++ b/net/netfilter/nf_tables_trace.c
@@ -183,9 +183,9 @@ static const struct nft_chain *nft_trace_get_chain(const struct nft_traceinfo *i
 	return last->chain;
 }
 
-void nft_trace_notify(struct nft_traceinfo *info)
+void nft_trace_notify(const struct nft_pktinfo *pkt,
+		      struct nft_traceinfo *info)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
 	const struct nft_chain *chain;
 	struct nlmsghdr *nlh;
 	struct sk_buff *skb;
@@ -305,7 +305,6 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 	info->trace = true;
 	info->nf_trace = pkt->skb->nf_trace;
 	info->packet_dumped = false;
-	info->pkt = pkt;
 	info->verdict = verdict;
 
 	net_get_random_once(&trace_key, sizeof(trace_key));
-- 
2.30.2

