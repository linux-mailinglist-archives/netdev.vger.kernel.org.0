Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64C2A661B
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730381AbgKDOMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:12:30 -0500
Received: from correo.us.es ([193.147.175.20]:35740 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729484AbgKDOMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2E8C1B60D4
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0E0E5DA78B
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:12:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0CA06DA78A; Wed,  4 Nov 2020 15:12:00 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A6F31DA791;
        Wed,  4 Nov 2020 15:11:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:11:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 6AB6842EF9E0;
        Wed,  4 Nov 2020 15:11:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 2/8] netfilter: nft_reject: unify reject init and dump into nft_reject
Date:   Wed,  4 Nov 2020 15:11:43 +0100
Message-Id: <20201104141149.30082-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201104141149.30082-1-pablo@netfilter.org>
References: <20201104141149.30082-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

Bridge family is using the same static init and dump function as inet.

This patch removes duplicate code unifying these functions body into
nft_reject.c so they can be reused in the rest of families supporting
reject verdict.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nft_reject_bridge.c | 60 +-----------------------
 net/netfilter/nft_reject.c               | 12 ++++-
 net/netfilter/nft_reject_inet.c          | 60 +-----------------------
 3 files changed, 15 insertions(+), 117 deletions(-)

diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index 25ca7723c6c2..eba0efe64d05 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -177,69 +177,13 @@ static int nft_reject_bridge_validate(const struct nft_ctx *ctx,
 						    (1 << NF_BR_LOCAL_IN));
 }
 
-static int nft_reject_bridge_init(const struct nft_ctx *ctx,
-				  const struct nft_expr *expr,
-				  const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code;
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-
-		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
-		    icmp_code > NFT_REJECT_ICMPX_MAX)
-			return -EINVAL;
-
-		priv->icmp_code = icmp_code;
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int nft_reject_bridge_dump(struct sk_buff *skb,
-				  const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
 static struct nft_expr_type nft_reject_bridge_type;
 static const struct nft_expr_ops nft_reject_bridge_ops = {
 	.type		= &nft_reject_bridge_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_bridge_eval,
-	.init		= nft_reject_bridge_init,
-	.dump		= nft_reject_bridge_dump,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
 	.validate	= nft_reject_bridge_validate,
 };
 
diff --git a/net/netfilter/nft_reject.c b/net/netfilter/nft_reject.c
index 61fb7e8afbf0..927ff8459bd9 100644
--- a/net/netfilter/nft_reject.c
+++ b/net/netfilter/nft_reject.c
@@ -40,6 +40,7 @@ int nft_reject_init(const struct nft_ctx *ctx,
 		    const struct nlattr * const tb[])
 {
 	struct nft_reject *priv = nft_expr_priv(expr);
+	int icmp_code;
 
 	if (tb[NFTA_REJECT_TYPE] == NULL)
 		return -EINVAL;
@@ -47,9 +48,17 @@ int nft_reject_init(const struct nft_ctx *ctx,
 	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
 			return -EINVAL;
-		priv->icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+
+		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
+		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
+		    icmp_code > NFT_REJECT_ICMPX_MAX)
+			return -EINVAL;
+
+		priv->icmp_code = icmp_code;
+		break;
 	case NFT_REJECT_TCP_RST:
 		break;
 	default:
@@ -69,6 +78,7 @@ int nft_reject_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	switch (priv->type) {
 	case NFT_REJECT_ICMP_UNREACH:
+	case NFT_REJECT_ICMPX_UNREACH:
 		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
 			goto nla_put_failure;
 		break;
diff --git a/net/netfilter/nft_reject_inet.c b/net/netfilter/nft_reject_inet.c
index cf8f2646e93c..ffd1aa1f9576 100644
--- a/net/netfilter/nft_reject_inet.c
+++ b/net/netfilter/nft_reject_inet.c
@@ -58,69 +58,13 @@ static void nft_reject_inet_eval(const struct nft_expr *expr,
 	regs->verdict.code = NF_DROP;
 }
 
-static int nft_reject_inet_init(const struct nft_ctx *ctx,
-				const struct nft_expr *expr,
-				const struct nlattr * const tb[])
-{
-	struct nft_reject *priv = nft_expr_priv(expr);
-	int icmp_code;
-
-	if (tb[NFTA_REJECT_TYPE] == NULL)
-		return -EINVAL;
-
-	priv->type = ntohl(nla_get_be32(tb[NFTA_REJECT_TYPE]));
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (tb[NFTA_REJECT_ICMP_CODE] == NULL)
-			return -EINVAL;
-
-		icmp_code = nla_get_u8(tb[NFTA_REJECT_ICMP_CODE]);
-		if (priv->type == NFT_REJECT_ICMPX_UNREACH &&
-		    icmp_code > NFT_REJECT_ICMPX_MAX)
-			return -EINVAL;
-
-		priv->icmp_code = icmp_code;
-		break;
-	case NFT_REJECT_TCP_RST:
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
-}
-
-static int nft_reject_inet_dump(struct sk_buff *skb,
-				const struct nft_expr *expr)
-{
-	const struct nft_reject *priv = nft_expr_priv(expr);
-
-	if (nla_put_be32(skb, NFTA_REJECT_TYPE, htonl(priv->type)))
-		goto nla_put_failure;
-
-	switch (priv->type) {
-	case NFT_REJECT_ICMP_UNREACH:
-	case NFT_REJECT_ICMPX_UNREACH:
-		if (nla_put_u8(skb, NFTA_REJECT_ICMP_CODE, priv->icmp_code))
-			goto nla_put_failure;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-
-nla_put_failure:
-	return -1;
-}
-
 static struct nft_expr_type nft_reject_inet_type;
 static const struct nft_expr_ops nft_reject_inet_ops = {
 	.type		= &nft_reject_inet_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
 	.eval		= nft_reject_inet_eval,
-	.init		= nft_reject_inet_init,
-	.dump		= nft_reject_inet_dump,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
 	.validate	= nft_reject_validate,
 };
 
-- 
2.20.1

