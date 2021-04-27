Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B788D36CC82
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbhD0Uoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:38 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54314 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237906AbhD0Uoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:37 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 21BB964124;
        Tue, 27 Apr 2021 22:43:15 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 2/7] netfilter: nftables: add loop check helper function
Date:   Tue, 27 Apr 2021 22:43:40 +0200
Message-Id: <20210427204345.22043-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds nft_check_loops() to reuse it in the new catch-all
element codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d66be7d8f3e5..502240fbb087 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8626,26 +8626,38 @@ EXPORT_SYMBOL_GPL(nft_chain_validate_hooks);
 static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				 const struct nft_chain *chain);
 
+static int nft_check_loops(const struct nft_ctx *ctx,
+			   const struct nft_set_ext *ext)
+{
+	const struct nft_data *data;
+	int ret;
+
+	data = nft_set_ext_data(ext);
+	switch (data->verdict.code) {
+	case NFT_JUMP:
+	case NFT_GOTO:
+		ret = nf_tables_check_loops(ctx, data->verdict.chain);
+		break;
+	default:
+		ret = 0;
+		break;
+	}
+
+	return ret;
+}
+
 static int nf_tables_loop_check_setelem(const struct nft_ctx *ctx,
 					struct nft_set *set,
 					const struct nft_set_iter *iter,
 					struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
-	const struct nft_data *data;
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
 		return 0;
 
-	data = nft_set_ext_data(ext);
-	switch (data->verdict.code) {
-	case NFT_JUMP:
-	case NFT_GOTO:
-		return nf_tables_check_loops(ctx, data->verdict.chain);
-	default:
-		return 0;
-	}
+	return nft_check_loops(ctx, ext);
 }
 
 static int nf_tables_check_loops(const struct nft_ctx *ctx,
-- 
2.30.2

