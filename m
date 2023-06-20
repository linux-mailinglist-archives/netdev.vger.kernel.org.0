Return-Path: <netdev+bounces-12172-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 63E6D7367F8
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 11:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9670E1C203B0
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 09:40:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B3314ABF;
	Tue, 20 Jun 2023 09:35:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE34156EC
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 09:35:57 +0000 (UTC)
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0AF73D1;
	Tue, 20 Jun 2023 02:35:56 -0700 (PDT)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com
Subject: [PATCH net 14/14] netfilter: nf_tables: Fix for deleting base chains with payload
Date: Tue, 20 Jun 2023 11:35:42 +0200
Message-Id: <20230620093542.69232-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230620093542.69232-1-pablo@netfilter.org>
References: <20230620093542.69232-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Phil Sutter <phil@nwl.cc>

When deleting a base chain, iptables-nft simply submits the whole chain
to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
added by fixed commit then turned this into a chain update, destroying
the hook but not the chain itself. Detect the situation by checking if
the chain type is either netdev or inet/ingress.

Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c1db2f4b2aa4..4c7937fd803f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2811,21 +2811,18 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	return nf_tables_addchain(&ctx, family, genmask, policy, flags, extack);
 }
 
-static int nft_delchain_hook(struct nft_ctx *ctx, struct nft_chain *chain,
+static int nft_delchain_hook(struct nft_ctx *ctx,
+			     struct nft_base_chain *basechain,
 			     struct netlink_ext_ack *extack)
 {
+	const struct nft_chain *chain = &basechain->chain;
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_chain_hook chain_hook = {};
-	struct nft_base_chain *basechain;
 	struct nft_hook *this, *hook;
 	LIST_HEAD(chain_del_list);
 	struct nft_trans *trans;
 	int err;
 
-	if (!nft_is_base_chain(chain))
-		return -EOPNOTSUPP;
-
-	basechain = nft_base_chain(chain);
 	err = nft_chain_parse_hook(ctx->net, basechain, nla, &chain_hook,
 				   ctx->family, chain->flags, extack);
 	if (err < 0)
@@ -2910,7 +2907,12 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
 			return -EOPNOTSUPP;
 
-		return nft_delchain_hook(&ctx, chain, extack);
+		if (nft_is_base_chain(chain)) {
+			struct nft_base_chain *basechain = nft_base_chain(chain);
+
+			if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
+				return nft_delchain_hook(&ctx, basechain, extack);
+		}
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_NONREC &&
-- 
2.30.2


