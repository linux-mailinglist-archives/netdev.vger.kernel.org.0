Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92D404E267E
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347416AbiCUMci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347383AbiCUMc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:27 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 31D4584ECC;
        Mon, 21 Mar 2022 05:31:02 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id D8F8E63037;
        Mon, 21 Mar 2022 13:28:19 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/19] netfilter: nft_osf: track register operations
Date:   Mon, 21 Mar 2022 13:30:42 +0100
Message-Id: <20220321123052.70553-10-pablo@netfilter.org>
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

Allow to recycle the previous output of the OS fingerprint expression
if flags and ttl are the same.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_osf.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index d82677e83400..5eed18f90b02 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -120,6 +120,30 @@ static int nft_osf_validate(const struct nft_ctx *ctx,
 						    (1 << NF_INET_FORWARD));
 }
 
+static bool nft_osf_reduce(struct nft_regs_track *track,
+			   const struct nft_expr *expr)
+{
+	struct nft_osf *priv = nft_expr_priv(expr);
+	struct nft_osf *osf;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
+		return false;
+	}
+
+	osf = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->flags != osf->flags ||
+	    priv->ttl != osf->ttl) {
+		nft_reg_track_update(track, expr, priv->dreg, NFT_OSF_MAXGENRELEN);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+
 static struct nft_expr_type nft_osf_type;
 static const struct nft_expr_ops nft_osf_op = {
 	.eval		= nft_osf_eval,
@@ -128,6 +152,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
 	.validate	= nft_osf_validate,
+	.reduce		= nft_osf_reduce,
 };
 
 static struct nft_expr_type nft_osf_type __read_mostly = {
-- 
2.30.2

