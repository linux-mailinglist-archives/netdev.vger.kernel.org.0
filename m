Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B785F4A9BCB
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359628AbiBDPTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:15 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50354 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359624AbiBDPTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:14 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C55AF60187;
        Fri,  4 Feb 2022 16:19:07 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/6] netfilter: nft_payload: don't allow th access for fragments
Date:   Fri,  4 Feb 2022 16:18:59 +0100
Message-Id: <20220204151903.320786-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Loads relative to ->thoff naturally expect that this points to the
transport header, but this is only true if pkt->fragoff == 0.

This has little effect for rulesets with connection tracking/nat because
these enable ip defra. For other rulesets this prevents false matches.

Fixes: 96518518cc41 ("netfilter: add nftables")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c  | 2 +-
 net/netfilter/nft_payload.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index dbe1f2e7dd9e..9e927ab4df15 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -167,7 +167,7 @@ nft_tcp_header_pointer(const struct nft_pktinfo *pkt,
 {
 	struct tcphdr *tcph;
 
-	if (pkt->tprot != IPPROTO_TCP)
+	if (pkt->tprot != IPPROTO_TCP || pkt->fragoff)
 		return NULL;
 
 	tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(*tcph), buffer);
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 940fed9a760b..5cc06aef4345 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -83,7 +83,7 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 {
 	unsigned int thoff = nft_thoff(pkt);
 
-	if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 		return -1;
 
 	switch (pkt->tprot) {
@@ -147,7 +147,7 @@ void nft_payload_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -688,7 +688,7 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 		offset = skb_network_offset(skb);
 		break;
 	case NFT_PAYLOAD_TRANSPORT_HEADER:
-		if (!(pkt->flags & NFT_PKTINFO_L4PROTO))
+		if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
 			goto err;
 		offset = nft_thoff(pkt);
 		break;
@@ -728,7 +728,8 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
 	    pkt->tprot == IPPROTO_SCTP &&
 	    skb->ip_summed != CHECKSUM_PARTIAL) {
-		if (nft_payload_csum_sctp(skb, nft_thoff(pkt)))
+		if (pkt->fragoff == 0 &&
+		    nft_payload_csum_sctp(skb, nft_thoff(pkt)))
 			goto err;
 	}
 
-- 
2.30.2

