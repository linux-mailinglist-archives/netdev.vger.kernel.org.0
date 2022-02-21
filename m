Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E584BDC3B
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380083AbiBUQSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:18:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380074AbiBUQSd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:18:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6BE5027144;
        Mon, 21 Feb 2022 08:18:10 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id ECAC860253;
        Mon, 21 Feb 2022 17:17:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf 4/5] netfilter: nft_limit: fix stateful object memory leak
Date:   Mon, 21 Feb 2022 17:17:56 +0100
Message-Id: <20220221161757.250801-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220221161757.250801-1-pablo@netfilter.org>
References: <20220221161757.250801-1-pablo@netfilter.org>
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

We need to provide a destroy callback to release the extra fields.

Fixes: 3b9e2ea6c11b ("netfilter: nft_limit: move stateful fields out of expression data")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index c4f308460dd1..a726b623963d 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -340,11 +340,20 @@ static int nft_limit_obj_pkts_dump(struct sk_buff *skb,
 	return nft_limit_dump(skb, &priv->limit, NFT_LIMIT_PKTS);
 }
 
+static void nft_limit_obj_pkts_destroy(const struct nft_ctx *ctx,
+				       struct nft_object *obj)
+{
+	struct nft_limit_priv_pkts *priv = nft_obj_data(obj);
+
+	nft_limit_destroy(ctx, &priv->limit);
+}
+
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_pkts_ops = {
 	.type		= &nft_limit_obj_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_limit_priv_pkts)),
 	.init		= nft_limit_obj_pkts_init,
+	.destroy	= nft_limit_obj_pkts_destroy,
 	.eval		= nft_limit_obj_pkts_eval,
 	.dump		= nft_limit_obj_pkts_dump,
 };
@@ -378,11 +387,20 @@ static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
 	return nft_limit_dump(skb, priv, NFT_LIMIT_PKT_BYTES);
 }
 
+static void nft_limit_obj_bytes_destroy(const struct nft_ctx *ctx,
+					struct nft_object *obj)
+{
+	struct nft_limit_priv *priv = nft_obj_data(obj);
+
+	nft_limit_destroy(ctx, priv);
+}
+
 static struct nft_object_type nft_limit_obj_type;
 static const struct nft_object_ops nft_limit_obj_bytes_ops = {
 	.type		= &nft_limit_obj_type,
 	.size		= sizeof(struct nft_limit_priv),
 	.init		= nft_limit_obj_bytes_init,
+	.destroy	= nft_limit_obj_bytes_destroy,
 	.eval		= nft_limit_obj_bytes_eval,
 	.dump		= nft_limit_obj_bytes_dump,
 };
-- 
2.30.2

