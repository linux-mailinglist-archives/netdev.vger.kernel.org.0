Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C75AB4E2667
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347433AbiCUMcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347400AbiCUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 53B7C85940;
        Mon, 21 Mar 2022 05:31:05 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4ABB963043;
        Mon, 21 Mar 2022 13:28:23 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 15/19] netfilter: nft_fib: add reduce support
Date:   Mon, 21 Mar 2022 13:30:48 +0100
Message-Id: <20220321123052.70553-16-pablo@netfilter.org>
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

The fib expression stores to a register, so we can't add empty stub.
Check that the register that is being written is in fact redundant.

In most cases, this is expected to cancel tracking as re-use is
unlikely.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nft_fib.h   |  3 +++
 net/ipv4/netfilter/nft_fib_ipv4.c |  2 ++
 net/ipv6/netfilter/nft_fib_ipv6.c |  2 ++
 net/netfilter/nft_fib.c           | 42 +++++++++++++++++++++++++++++++
 net/netfilter/nft_fib_inet.c      |  1 +
 net/netfilter/nft_fib_netdev.c    |  1 +
 6 files changed, 51 insertions(+)

diff --git a/include/net/netfilter/nft_fib.h b/include/net/netfilter/nft_fib.h
index 237f3757637e..eed099eae672 100644
--- a/include/net/netfilter/nft_fib.h
+++ b/include/net/netfilter/nft_fib.h
@@ -37,4 +37,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 
 void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 			  const struct net_device *dev);
+
+bool nft_fib_reduce(struct nft_regs_track *track,
+		    const struct nft_expr *expr);
 #endif
diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 03df986217b7..4151eb1262dd 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -152,6 +152,7 @@ static const struct nft_expr_ops nft_fib4_type_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops nft_fib4_ops = {
@@ -161,6 +162,7 @@ static const struct nft_expr_ops nft_fib4_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 92f3235fa287..b3f163b40c2b 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -211,6 +211,7 @@ static const struct nft_expr_ops nft_fib6_type_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops nft_fib6_ops = {
@@ -220,6 +221,7 @@ static const struct nft_expr_ops nft_fib6_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.reduce		= nft_fib_reduce,
 };
 
 static const struct nft_expr_ops *
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index b10ce732b337..f198f2d9ef90 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -156,5 +156,47 @@ void nft_fib_store_result(void *reg, const struct nft_fib *priv,
 }
 EXPORT_SYMBOL_GPL(nft_fib_store_result);
 
+bool nft_fib_reduce(struct nft_regs_track *track,
+		    const struct nft_expr *expr)
+{
+	const struct nft_fib *priv = nft_expr_priv(expr);
+	unsigned int len = NFT_REG32_SIZE;
+	const struct nft_fib *fib;
+
+	switch (priv->result) {
+	case NFT_FIB_RESULT_OIF:
+		break;
+	case NFT_FIB_RESULT_OIFNAME:
+		if (priv->flags & NFTA_FIB_F_PRESENT)
+			len = NFT_REG32_SIZE;
+		else
+			len = IFNAMSIZ;
+		break;
+	case NFT_FIB_RESULT_ADDRTYPE:
+	     break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, len);
+		return false;
+	}
+
+	fib = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->result != fib->result ||
+	    priv->flags != fib->flags) {
+		nft_reg_track_update(track, expr, priv->dreg, len);
+		return false;
+	}
+
+	if (!track->regs[priv->dreg].bitwise)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(nft_fib_reduce);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Florian Westphal <fw@strlen.de>");
diff --git a/net/netfilter/nft_fib_inet.c b/net/netfilter/nft_fib_inet.c
index a88d44e163d1..666a3741d20b 100644
--- a/net/netfilter/nft_fib_inet.c
+++ b/net/netfilter/nft_fib_inet.c
@@ -49,6 +49,7 @@ static const struct nft_expr_ops nft_fib_inet_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.reduce		= nft_fib_reduce,
 };
 
 static struct nft_expr_type nft_fib_inet_type __read_mostly = {
diff --git a/net/netfilter/nft_fib_netdev.c b/net/netfilter/nft_fib_netdev.c
index 3f3478abd845..9121ec64e918 100644
--- a/net/netfilter/nft_fib_netdev.c
+++ b/net/netfilter/nft_fib_netdev.c
@@ -58,6 +58,7 @@ static const struct nft_expr_ops nft_fib_netdev_ops = {
 	.init		= nft_fib_init,
 	.dump		= nft_fib_dump,
 	.validate	= nft_fib_validate,
+	.reduce		= nft_fib_reduce,
 };
 
 static struct nft_expr_type nft_fib_netdev_type __read_mostly = {
-- 
2.30.2

