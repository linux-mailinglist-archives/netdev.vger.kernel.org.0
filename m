Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACC78488D07
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbiAIXQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:16:54 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42128 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236098AbiAIXQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:16:53 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 19DFE6468F;
        Mon, 10 Jan 2022 00:14:02 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/32] netfilter: nf_tables: consolidate rule verdict trace call
Date:   Mon, 10 Jan 2022 00:16:13 +0100
Message-Id: <20220109231640.104123-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220109231640.104123-1-pablo@netfilter.org>
References: <20220109231640.104123-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add function to consolidate verdict tracing.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_core.c | 39 ++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 41c7509955e6..d026890a9842 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -67,6 +67,36 @@ static void nft_cmp_fast_eval(const struct nft_expr *expr,
 	regs->verdict.code = NFT_BREAK;
 }
 
+static noinline void __nft_trace_verdict(struct nft_traceinfo *info,
+					 const struct nft_chain *chain,
+					 const struct nft_regs *regs)
+{
+	enum nft_trace_types type;
+
+	switch (regs->verdict.code) {
+	case NFT_CONTINUE:
+	case NFT_RETURN:
+		type = NFT_TRACETYPE_RETURN;
+		break;
+	default:
+		type = NFT_TRACETYPE_RULE;
+		break;
+	}
+
+	__nft_trace_packet(info, chain, type);
+}
+
+static inline void nft_trace_verdict(struct nft_traceinfo *info,
+				     const struct nft_chain *chain,
+				     const struct nft_rule *rule,
+				     const struct nft_regs *regs)
+{
+	if (static_branch_unlikely(&nft_trace_enabled)) {
+		info->rule = rule;
+		__nft_trace_verdict(info, chain, regs);
+	}
+}
+
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
@@ -205,13 +235,13 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		break;
 	}
 
+	nft_trace_verdict(&info, chain, rule, &regs);
+
 	switch (regs.verdict.code & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
 	case NF_STOLEN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
 		return regs.verdict.code;
 	}
 
@@ -224,15 +254,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 		stackptr++;
 		fallthrough;
 	case NFT_GOTO:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RULE);
-
 		chain = regs.verdict.chain;
 		goto do_chain;
 	case NFT_CONTINUE:
 	case NFT_RETURN:
-		nft_trace_packet(&info, chain, rule,
-				 NFT_TRACETYPE_RETURN);
 		break;
 	default:
 		WARN_ON(1);
-- 
2.30.2

