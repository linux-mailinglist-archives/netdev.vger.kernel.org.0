Return-Path: <netdev+bounces-3551-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06351707D92
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:08:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA3D62818A9
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60F50125A0;
	Thu, 18 May 2023 10:08:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A6711CA0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:08:12 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8D51BDD;
	Thu, 18 May 2023 03:08:10 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzaYG-0005n3-Om; Thu, 18 May 2023 12:08:04 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH net-next 1/9] netfilter: nf_tables: relax set/map validation checks
Date: Thu, 18 May 2023 12:07:51 +0200
Message-Id: <20230518100759.84858-2-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518100759.84858-1-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Its currently not allowed to perform queries on a map, for example:

table t {
	map m {
		typeof ip saddr : meta mark
		..

	chain c {
		ip saddr @m counter

will fail, because kernel requires that userspace provides a destination
register when the referenced set is a map.

However, internally there is no real distinction between sets and maps,
maps are just sets where each key is associated with a value.

Relax this so that maps can be used just like sets.

This allows to have rules that query if a given key exists
without making use of the associated value.

This also permits != checks which don't work for map lookups.

When no destination reg is given for a map, then permit this for named
maps.

Data and dump paths need to be updated to consider priv->dreg_set
instead of the 'set-is-a-map' check.

Checks in reduce and validate callbacks are not changed, this
can be relaxed later if a need arises.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_lookup.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 03ef4fdaa460..29ac48cdd6db 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -19,6 +19,7 @@ struct nft_lookup {
 	struct nft_set			*set;
 	u8				sreg;
 	u8				dreg;
+	bool				dreg_set;
 	bool				invert;
 	struct nft_set_binding		binding;
 };
@@ -75,7 +76,7 @@ void nft_lookup_eval(const struct nft_expr *expr,
 	}
 
 	if (ext) {
-		if (set->flags & NFT_SET_MAP)
+		if (priv->dreg_set)
 			nft_data_copy(&regs->data[priv->dreg],
 				      nft_set_ext_data(ext), set->dlen);
 
@@ -122,11 +123,8 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 		if (flags & ~NFT_LOOKUP_F_INV)
 			return -EINVAL;
 
-		if (flags & NFT_LOOKUP_F_INV) {
-			if (set->flags & NFT_SET_MAP)
-				return -EINVAL;
+		if (flags & NFT_LOOKUP_F_INV)
 			priv->invert = true;
-		}
 	}
 
 	if (tb[NFTA_LOOKUP_DREG] != NULL) {
@@ -140,8 +138,17 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 					       set->dlen);
 		if (err < 0)
 			return err;
-	} else if (set->flags & NFT_SET_MAP)
-		return -EINVAL;
+		priv->dreg_set = true;
+	} else if (set->flags & NFT_SET_MAP) {
+		/* Map given, but user asks for lookup only (i.e. to
+		 * ignore value assoicated with key).
+		 *
+		 * This makes no sense for anonymous maps since they are
+		 * scoped to the rule, but for named sets this can be useful.
+		 */
+		if (set->flags & NFT_SET_ANONYMOUS)
+			return -EINVAL;
+	}
 
 	priv->binding.flags = set->flags & NFT_SET_MAP;
 
@@ -188,7 +195,7 @@ static int nft_lookup_dump(struct sk_buff *skb,
 		goto nla_put_failure;
 	if (nft_dump_register(skb, NFTA_LOOKUP_SREG, priv->sreg))
 		goto nla_put_failure;
-	if (priv->set->flags & NFT_SET_MAP)
+	if (priv->dreg_set)
 		if (nft_dump_register(skb, NFTA_LOOKUP_DREG, priv->dreg))
 			goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_LOOKUP_FLAGS, htonl(flags)))
-- 
2.40.1


