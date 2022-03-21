Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1A74E2689
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 13:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347428AbiCUMcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 08:32:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347378AbiCUMcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 08:32:33 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3DFC84EEB;
        Mon, 21 Mar 2022 05:31:03 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 92FC26303C;
        Mon, 21 Mar 2022 13:28:21 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 12/19] netfilter: nft_socket: track register operations
Date:   Mon, 21 Mar 2022 13:30:45 +0100
Message-Id: <20220321123052.70553-13-pablo@netfilter.org>
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

Check if the destination register already contains the data that this
socket expression performs. This allows to skip this redundant
operation.  If the destination contains a different selector, update the
register tracking information.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_socket.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/net/netfilter/nft_socket.c b/net/netfilter/nft_socket.c
index d601974c9d2e..bd3792f080ed 100644
--- a/net/netfilter/nft_socket.c
+++ b/net/netfilter/nft_socket.c
@@ -10,6 +10,7 @@
 struct nft_socket {
 	enum nft_socket_keys		key:8;
 	u8				level;
+	u8				len;
 	union {
 		u8			dreg;
 	};
@@ -179,6 +180,7 @@ static int nft_socket_init(const struct nft_ctx *ctx,
 		return -EOPNOTSUPP;
 	}
 
+	priv->len = len;
 	return nft_parse_register_store(ctx, tb[NFTA_SOCKET_DREG], &priv->dreg,
 					NULL, NFT_DATA_VALUE, len);
 }
@@ -198,6 +200,31 @@ static int nft_socket_dump(struct sk_buff *skb,
 	return 0;
 }
 
+static bool nft_socket_reduce(struct nft_regs_track *track,
+			      const struct nft_expr *expr)
+{
+	const struct nft_socket *priv = nft_expr_priv(expr);
+	const struct nft_socket *socket;
+
+	if (!nft_reg_track_cmp(track, expr, priv->dreg)) {
+		nft_reg_track_update(track, expr, priv->dreg, priv->len);
+		return false;
+	}
+
+	socket = nft_expr_priv(track->regs[priv->dreg].selector);
+	if (priv->key != socket->key ||
+	    priv->dreg != socket->dreg ||
+	    priv->level != socket->level) {
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
 static struct nft_expr_type nft_socket_type;
 static const struct nft_expr_ops nft_socket_ops = {
 	.type		= &nft_socket_type,
@@ -205,6 +232,7 @@ static const struct nft_expr_ops nft_socket_ops = {
 	.eval		= nft_socket_eval,
 	.init		= nft_socket_init,
 	.dump		= nft_socket_dump,
+	.reduce		= nft_socket_reduce,
 };
 
 static struct nft_expr_type nft_socket_type __read_mostly = {
-- 
2.30.2

