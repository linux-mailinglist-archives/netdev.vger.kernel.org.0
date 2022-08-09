Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F9058E283
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiHIWGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiHIWFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:05:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 252C212778;
        Tue,  9 Aug 2022 15:05:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/8] netfilter: nf_tables: do not allow CHAIN_ID to refer to another table
Date:   Wed, 10 Aug 2022 00:05:27 +0200
Message-Id: <20220809220532.130240-4-pablo@netfilter.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

When doing lookups for chains on the same batch by using its ID, a chain
from a different table can be used. If a rule is added to a table but
refers to a chain in a different table, it will be linked to the chain in
table2, but would have expressions referring to objects in table1.

Then, when table1 is removed, the rule will not be removed as its linked to
a chain in table2. When expressions in the rule are processed or removed,
that will lead to a use-after-free.

When looking for chains by ID, use the table that was used for the lookup
by name, and only return chains belonging to that same table.

Fixes: 837830a4b439 ("netfilter: nf_tables: add NFTA_RULE_CHAIN_ID attribute")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 41c529b0001c..041accbaca32 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2472,6 +2472,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 }
 
 static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
+					       const struct nft_table *table,
 					       const struct nlattr *nla)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -2482,6 +2483,7 @@ static struct nft_chain *nft_chain_lookup_byid(const struct net *net,
 		struct nft_chain *chain = trans->ctx.chain;
 
 		if (trans->msg_type == NFT_MSG_NEWCHAIN &&
+		    chain->table == table &&
 		    id == nft_trans_chain_id(trans))
 			return chain;
 	}
@@ -3417,7 +3419,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 
 	} else if (nla[NFTA_RULE_CHAIN_ID]) {
-		chain = nft_chain_lookup_byid(net, nla[NFTA_RULE_CHAIN_ID]);
+		chain = nft_chain_lookup_byid(net, table, nla[NFTA_RULE_CHAIN_ID]);
 		if (IS_ERR(chain)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_CHAIN_ID]);
 			return PTR_ERR(chain);
@@ -9661,7 +9663,7 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 						 tb[NFTA_VERDICT_CHAIN],
 						 genmask);
 		} else if (tb[NFTA_VERDICT_CHAIN_ID]) {
-			chain = nft_chain_lookup_byid(ctx->net,
+			chain = nft_chain_lookup_byid(ctx->net, ctx->table,
 						      tb[NFTA_VERDICT_CHAIN_ID]);
 			if (IS_ERR(chain))
 				return PTR_ERR(chain);
-- 
2.30.2

