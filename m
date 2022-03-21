Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0FC4E266D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345771AbiCUMck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347401AbiCUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B166885959;
        Mon, 21 Mar 2022 05:31:06 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id CC58463045;
        Mon, 21 Mar 2022 13:28:23 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 16/19] netfilter: nft_exthdr: add reduce support
Date:   Mon, 21 Mar 2022 13:30:49 +0100
Message-Id: <20220321123052.70553-17-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220321123052.70553-1-pablo@netfilter.org>
References: <20220321123052.70553-1-pablo@netfilter.org>
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

Check if we can elide the load. Cancel if the new candidate
isn't identical to previous store.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_exthdr.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index d2b9378164bb..22c3e05b52db 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -603,12 +603,40 @@ static int nft_exthdr_dump_strip(struct sk_buff *skb, const struct nft_expr *exp
 	return nft_exthdr_dump_common(skb, priv);
 }
 
+static bool nft_exthdr_reduce(struct nft_regs_track *track,
+			       const struct nft_expr *expr)
+{
+	const struct nft_exthdr *priv = nft_expr_priv(expr);
+	const struct nft_exthdr *exthdr;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	exthdr = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->type != exthdr->type ||
+	    priv->op != exthdr->op ||
+	    priv->flags != exthdr->flags ||
+	    priv->offset != exthdr->offset ||
+	    priv->len != exthdr->len) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return nft_expr_reduce_bitwise(track, expr);
+}
+
 static const struct nft_expr_ops nft_exthdr_ipv6_ops = {
 	.type		= &nft_exthdr_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_exthdr)),
 	.eval		= nft_exthdr_ipv6_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
@@ -617,6 +645,7 @@ static const struct nft_expr_ops nft_exthdr_ipv4_ops = {
 	.eval		= nft_exthdr_ipv4_eval,
 	.init		= nft_exthdr_ipv4_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_ops = {
@@ -625,6 +654,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_ops = {
 	.eval		= nft_exthdr_tcp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
@@ -633,6 +663,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_set_ops = {
 	.eval		= nft_exthdr_tcp_set_eval,
 	.init		= nft_exthdr_tcp_set_init,
 	.dump		= nft_exthdr_dump_set,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
@@ -641,6 +672,7 @@ static const struct nft_expr_ops nft_exthdr_tcp_strip_ops = {
 	.eval		= nft_exthdr_tcp_strip_eval,
 	.init		= nft_exthdr_tcp_strip_init,
 	.dump		= nft_exthdr_dump_strip,
+	.reduce		= NFT_REDUCE_READONLY,
 };
 
 static const struct nft_expr_ops nft_exthdr_sctp_ops = {
@@ -649,6 +681,7 @@ static const struct nft_expr_ops nft_exthdr_sctp_ops = {
 	.eval		= nft_exthdr_sctp_eval,
 	.init		= nft_exthdr_init,
 	.dump		= nft_exthdr_dump,
+	.reduce		= nft_exthdr_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

