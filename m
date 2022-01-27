Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA79E49EF0B
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344106AbiA0Xwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:47 -0500
Received: from mail.netfilter.org ([217.70.188.207]:43018 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343896AbiA0Xwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:44 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 682A66086A;
        Fri, 28 Jan 2022 00:49:39 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/8] netfilter: nft_byteorder: track register operations
Date:   Fri, 28 Jan 2022 00:52:33 +0100
Message-Id: <20220127235235.656931-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cancel tracking for byteorder operation, otherwise selector + byteorder
operation is incorrectly reduced if source and destination registers are
the same.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_byteorder.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 9d5947ab8d4e..e646e9ee4a98 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -167,12 +167,24 @@ static int nft_byteorder_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static bool nft_byteorder_reduce(struct nft_regs_track *track,
+				 const struct nft_expr *expr)
+{
+	struct nft_byteorder *priv = nft_expr_priv(expr);
+
+	track->regs[priv->dreg].selector = NULL;
+	track->regs[priv->dreg].bitwise = NULL;
+
+	return false;
+}
+
 static const struct nft_expr_ops nft_byteorder_ops = {
 	.type		= &nft_byteorder_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_byteorder)),
 	.eval		= nft_byteorder_eval,
 	.init		= nft_byteorder_init,
 	.dump		= nft_byteorder_dump,
+	.reduce		= nft_byteorder_reduce,
 };
 
 struct nft_expr_type nft_byteorder_type __read_mostly = {
-- 
2.30.2

