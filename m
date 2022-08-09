Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EBB58E279
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiHIWGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbiHIWFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:05:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 657FA1263F;
        Tue,  9 Aug 2022 15:05:45 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 7/8] netfilter: nf_tables: disallow jump to implicit chain from set element
Date:   Wed, 10 Aug 2022 00:05:31 +0200
Message-Id: <20220809220532.130240-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809220532.130240-1-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
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

Extend struct nft_data_desc to add a flag field that specifies
nft_data_init() is being called for set element data.

Use it to disallow jump to implicit chain from set element, only jump
to chain via immediate expression is allowed.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 5 +++++
 net/netfilter/nf_tables_api.c     | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1554f1e7215b..99aae36c04b9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -221,10 +221,15 @@ struct nft_ctx {
 	bool				report;
 };
 
+enum nft_data_desc_flags {
+	NFT_DATA_DESC_SETELEM	= (1 << 0),
+};
+
 struct nft_data_desc {
 	enum nft_data_types		type;
 	unsigned int			size;
 	unsigned int			len;
+	unsigned int			flags;
 };
 
 int nft_data_init(const struct nft_ctx *ctx, struct nft_data *data,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 05896765c68f..460b0925ea60 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5226,6 +5226,7 @@ static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
 	desc->type = dtype;
 	desc->size = NFT_DATA_VALUE_MAXLEN;
 	desc->len = set->dlen;
+	desc->flags = NFT_DATA_DESC_SETELEM;
 
 	return nft_data_init(ctx, data, desc, attr);
 }
@@ -9665,6 +9666,9 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
 			return -EOPNOTSUPP;
+		if (desc->flags & NFT_DATA_DESC_SETELEM &&
+		    chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
 
 		chain->use++;
 		data->verdict.chain = chain;
-- 
2.30.2

