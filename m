Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4951A2BF1
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfH3Ax7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:53:59 -0400
Received: from correo.us.es ([193.147.175.20]:55036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbfH3Ax6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 20:53:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D56627F8C6
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 02:53:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B5A4D1911
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 02:53:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5EB6FDA840; Fri, 30 Aug 2019 02:53:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2F174DA72F;
        Fri, 30 Aug 2019 02:53:52 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 30 Aug 2019 02:53:52 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CCEF84265A5A;
        Fri, 30 Aug 2019 02:53:51 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, vishal@chelsio.com,
        jakub.kicinski@netronome.com, saeedm@mellanox.com, jiri@resnulli.us
Subject: [PATCH net-next 4/4] netfilter: nft_payload: packet mangling offload support
Date:   Fri, 30 Aug 2019 02:53:36 +0200
Message-Id: <20190830005336.23604-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190830005336.23604-1-pablo@netfilter.org>
References: <20190830005336.23604-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows for mangling packet fields using hardware offload
infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 72 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 22a80eb60222..39882f81ca8d 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -562,12 +562,84 @@ static int nft_payload_set_dump(struct sk_buff *skb, const struct nft_expr *expr
 	return -1;
 }
 
+static int nft_payload_offload_set_nh(struct nft_offload_ctx *ctx,
+				      struct nft_flow_rule *flow,
+				      const struct nft_payload_set *priv)
+{
+	int type = FLOW_ACT_MANGLE_UNSPEC;
+
+	switch (ctx->dep.l3num) {
+	case htons(ETH_P_IP):
+		type = FLOW_ACT_MANGLE_HDR_TYPE_IP4;
+		break;
+	case htons(ETH_P_IPV6):
+		type = FLOW_ACT_MANGLE_HDR_TYPE_IP6;
+		break;
+	}
+
+	return type;
+}
+
+static int nft_payload_offload_set_th(struct nft_offload_ctx *ctx,
+				      struct nft_flow_rule *flow,
+				      const struct nft_payload_set *priv)
+{
+	int type = FLOW_ACT_MANGLE_UNSPEC;
+
+	switch (ctx->dep.protonum) {
+	case IPPROTO_TCP:
+		type = FLOW_ACT_MANGLE_HDR_TYPE_TCP;
+		break;
+	case IPPROTO_UDP:
+		type = FLOW_ACT_MANGLE_HDR_TYPE_UDP;
+		break;
+	}
+
+	return type;
+}
+
+static int nft_payload_set_offload(struct nft_offload_ctx *ctx,
+				   struct nft_flow_rule *flow,
+				   const struct nft_expr *expr)
+{
+	const struct nft_payload_set *priv = nft_expr_priv(expr);
+	struct nft_offload_reg *sreg = &ctx->regs[priv->sreg];
+	int type = FLOW_ACT_MANGLE_UNSPEC;
+	struct flow_action_entry *entry;
+
+	switch (priv->base) {
+	case NFT_PAYLOAD_LL_HEADER:
+		type = FLOW_ACT_MANGLE_HDR_TYPE_ETH;
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		type = nft_payload_offload_set_nh(ctx, flow, priv);
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		type = nft_payload_offload_set_th(ctx, flow, priv);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	entry = &flow->rule->action.entries[ctx->num_actions++];
+	entry->mangle.htype	= type;
+	entry->mangle.offset	= priv->offset;
+	entry->mangle.len	= priv->len;
+
+	memcpy(entry->mangle.val, sreg->data.data, priv->len);
+	memset(entry->mangle.mask, 0xff, priv->len);
+
+	return type != FLOW_ACT_MANGLE_UNSPEC ? 0 : -EOPNOTSUPP;
+}
+
 static const struct nft_expr_ops nft_payload_set_ops = {
 	.type		= &nft_payload_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload_set)),
 	.eval		= nft_payload_set_eval,
 	.init		= nft_payload_set_init,
 	.dump		= nft_payload_set_dump,
+	.offload	= nft_payload_set_offload,
 };
 
 static const struct nft_expr_ops *
-- 
2.11.0

