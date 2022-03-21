Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725254E2685
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347406AbiCUMce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347379AbiCUMc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5BAA584ECA;
        Mon, 21 Mar 2022 05:31:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5129A63036;
        Mon, 21 Mar 2022 13:28:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/19] netfilter: nft_numgen: cancel register tracking
Date:   Mon, 21 Mar 2022 13:30:41 +0100
Message-Id: <20220321123052.70553-9-pablo@netfilter.org>
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

Random and increment are stateful, each invocation results in fresh output.
Cancel register tracking for these two expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_numgen.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 1d378efd8823..81b40c663d86 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -85,6 +85,16 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 	return err;
 }
 
+static bool nft_ng_inc_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_ng_inc *priv = nft_expr_priv(expr);
+
+	nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
+
+	return false;
+}
+
 static int nft_ng_dump(struct sk_buff *skb, enum nft_registers dreg,
 		       u32 modulus, enum nft_ng_types type, u32 offset)
 {
@@ -172,6 +182,16 @@ static int nft_ng_random_dump(struct sk_buff *skb, const struct nft_expr *expr)
 			   priv->offset);
 }
 
+static bool nft_ng_random_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	const struct nft_ng_random *priv = nft_expr_priv(expr);
+
+	nft_reg_track_cancel(track, priv->dreg, NFT_REG32_SIZE);
+
+	return false;
+}
+
 static struct nft_expr_type nft_ng_type;
 static const struct nft_expr_ops nft_ng_inc_ops = {
 	.type		= &nft_ng_type,
@@ -180,6 +200,7 @@ static const struct nft_expr_ops nft_ng_inc_ops = {
 	.init		= nft_ng_inc_init,
 	.destroy	= nft_ng_inc_destroy,
 	.dump		= nft_ng_inc_dump,
+	.reduce		= nft_ng_inc_reduce,
 };
 
 static const struct nft_expr_ops nft_ng_random_ops = {
@@ -188,6 +209,7 @@ static const struct nft_expr_ops nft_ng_random_ops = {
 	.eval		= nft_ng_random_eval,
 	.init		= nft_ng_random_init,
 	.dump		= nft_ng_random_dump,
+	.reduce		= nft_ng_random_reduce,
 };
 
 static const struct nft_expr_ops *
-- 
2.30.2

