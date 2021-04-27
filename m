Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65CA636CC84
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239007AbhD0Uoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54322 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238928AbhD0Uoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:38 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id ECA1064139;
        Tue, 27 Apr 2021 22:43:15 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 3/7] netfilter: nftables: add helper function to flush set elements
Date:   Tue, 27 Apr 2021 22:43:41 +0200
Message-Id: <20210427204345.22043-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds nft_set_flush() which prepares for the catch-all
element support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 502240fbb087..3342f260d534 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5839,10 +5839,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	return err;
 }
 
-static int nft_flush_set(const struct nft_ctx *ctx,
-			 struct nft_set *set,
-			 const struct nft_set_iter *iter,
-			 struct nft_set_elem *elem)
+static int nft_setelem_flush(const struct nft_ctx *ctx,
+			     struct nft_set *set,
+			     const struct nft_set_iter *iter,
+			     struct nft_set_elem *elem)
 {
 	struct nft_trans *trans;
 	int err;
@@ -5869,6 +5869,18 @@ static int nft_flush_set(const struct nft_ctx *ctx,
 	return err;
 }
 
+static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
+{
+	struct nft_set_iter iter = {
+		.genmask	= genmask,
+		.fn		= nft_setelem_flush,
+	};
+
+	set->ops->walk(ctx, set, &iter);
+
+	return iter.err;
+}
+
 static int nf_tables_delsetelem(struct sk_buff *skb,
 				const struct nfnl_info *info,
 				const struct nlattr * const nla[])
@@ -5892,15 +5904,8 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
-	if (nla[NFTA_SET_ELEM_LIST_ELEMENTS] == NULL) {
-		struct nft_set_iter iter = {
-			.genmask	= genmask,
-			.fn		= nft_flush_set,
-		};
-		set->ops->walk(&ctx, set, &iter);
-
-		return iter.err;
-	}
+	if (!nla[NFTA_SET_ELEM_LIST_ELEMENTS])
+		return nft_set_flush(&ctx, set, genmask);
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
-- 
2.30.2

