Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690BD589FDA
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 19:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238734AbiHDR1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 13:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238388AbiHDR04 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 13:26:56 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE446301
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 10:26:55 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oJecY-0007DT-5W; Thu, 04 Aug 2022 19:26:54 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 1/3] netfilter: nf_tables: fix crash when nf_trace is enabled
Date:   Thu,  4 Aug 2022 19:26:27 +0200
Message-Id: <20220804172629.29748-2-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220804172629.29748-1-fw@strlen.de>
References: <20220804172629.29748-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

do not access info->pkt when info->trace is not 1.
nft_traceinfo is not initialized, except when tracing is enabled.

The 'nft_trace_enabled' static key cannot be used for this, we must
always check info->trace first.

Pass nft_pktinfo directly to avoid this.

Fixes: e34b9ed96ce3 ("netfilter: nf_tables: avoid skb access on nf_stolen")
Reported-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_core.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 3ddce24ac76d..cee3e4e905ec 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -34,25 +34,23 @@ static noinline void __nft_trace_packet(struct nft_traceinfo *info,
 	nft_trace_notify(info);
 }
 
-static inline void nft_trace_packet(struct nft_traceinfo *info,
+static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
+				    struct nft_traceinfo *info,
 				    const struct nft_chain *chain,
 				    const struct nft_rule_dp *rule,
 				    enum nft_trace_types type)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		info->nf_trace = pkt->skb->nf_trace;
 		info->rule = rule;
 		__nft_trace_packet(info, chain, type);
 	}
 }
 
-static inline void nft_trace_copy_nftrace(struct nft_traceinfo *info)
+static inline void nft_trace_copy_nftrace(const struct nft_pktinfo *pkt,
+					  struct nft_traceinfo *info)
 {
 	if (static_branch_unlikely(&nft_trace_enabled)) {
-		const struct nft_pktinfo *pkt = info->pkt;
-
 		if (info->trace)
 			info->nf_trace = pkt->skb->nf_trace;
 	}
@@ -96,7 +94,6 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 					 const struct nft_chain *chain,
 					 const struct nft_regs *regs)
 {
-	const struct nft_pktinfo *pkt = info->pkt;
 	enum nft_trace_types type;
 
 	switch (regs->verdict.code) {
@@ -110,7 +107,9 @@ static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
 		break;
 	default:
 		type = NFT_TRACETYPE_RULE;
-		info->nf_trace = pkt->skb->nf_trace;
+
+		if (info->trace)
+			info->nf_trace = info->pkt->skb->nf_trace;
 		break;
 	}
 
@@ -271,10 +270,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		switch (regs.verdict.code) {
 		case NFT_BREAK:
 			regs.verdict.code = NFT_CONTINUE;
-			nft_trace_copy_nftrace(&info);
+			nft_trace_copy_nftrace(pkt, &info);
 			continue;
 		case NFT_CONTINUE:
-			nft_trace_packet(&info, chain, rule,
+			nft_trace_packet(pkt, &info, chain, rule,
 					 NFT_TRACETYPE_RULE);
 			continue;
 		}
@@ -318,7 +317,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		goto next_rule;
 	}
 
-	nft_trace_packet(&info, basechain, NULL, NFT_TRACETYPE_POLICY);
+	nft_trace_packet(pkt, &info, basechain, NULL, NFT_TRACETYPE_POLICY);
 
 	if (static_branch_unlikely(&nft_counters_enabled))
 		nft_update_chain_stats(basechain, pkt);
-- 
2.35.1

