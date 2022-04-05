Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148E44F35C0
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 15:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236659AbiDEKy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 06:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357272AbiDEKZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 06:25:59 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E903B3701F;
        Tue,  5 Apr 2022 03:09:55 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5032363038;
        Tue,  5 Apr 2022 12:06:17 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/2] netfilter: bitwise: fix reduce comparisons
Date:   Tue,  5 Apr 2022 12:09:22 +0200
Message-Id: <20220405100923.7231-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220405100923.7231-1-pablo@netfilter.org>
References: <20220405100923.7231-1-pablo@netfilter.org>
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

From: Jeremy Sowden <jeremy@azazel.net>

The `nft_bitwise_reduce` and `nft_bitwise_fast_reduce` functions should
compare the bitwise operation in `expr` with the tracked operation
associated with the destination register of `expr`.  However, instead of
being called on `expr` and `track->regs[priv->dreg].selector`,
`nft_expr_priv` is called on `expr` twice, so both reduce functions
return true even when the operations differ.

Fixes: be5650f8f47e ("netfilter: nft_bitwise: track register operations")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 38caa66632b4..f590ee1c8a1b 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -290,7 +290,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
-	bitwise = nft_expr_priv(expr);
+	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
 	    track->regs[priv->sreg].num_reg == 0 &&
 	    track->regs[priv->dreg].bitwise &&
@@ -442,7 +442,7 @@ static bool nft_bitwise_fast_reduce(struct nft_regs_track *track,
 	if (!track->regs[priv->sreg].selector)
 		return false;
 
-	bitwise = nft_expr_priv(expr);
+	bitwise = nft_expr_priv(track->regs[priv->dreg].selector);
 	if (track->regs[priv->sreg].selector == track->regs[priv->dreg].selector &&
 	    track->regs[priv->dreg].bitwise &&
 	    track->regs[priv->dreg].bitwise->ops == expr->ops &&
-- 
2.30.2

