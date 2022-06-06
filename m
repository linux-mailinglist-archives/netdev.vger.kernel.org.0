Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4488E53F199
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 23:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234442AbiFFVVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 17:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234486AbiFFVVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 17:21:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA0EEC5D98;
        Mon,  6 Jun 2022 14:21:03 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 5/7] netfilter: nf_tables: release new hooks on unsupported flowtable flags
Date:   Mon,  6 Jun 2022 23:20:53 +0200
Message-Id: <20220606212055.98300-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220606212055.98300-1-pablo@netfilter.org>
References: <20220606212055.98300-1-pablo@netfilter.org>
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

Release the list of new hooks that are pending to be registered in case
that unsupported flowtable flags are provided.

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2faa77cd2fe2..252796a99f5e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7433,11 +7433,15 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flags = ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flags & ~NFT_FLOWTABLE_MASK)
-			return -EOPNOTSUPP;
+		if (flags & ~NFT_FLOWTABLE_MASK) {
+			err = -EOPNOTSUPP;
+			goto err_flowtable_update_hook;
+		}
 		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
-		    (flags & NFT_FLOWTABLE_HW_OFFLOAD))
-			return -EOPNOTSUPP;
+		    (flags & NFT_FLOWTABLE_HW_OFFLOAD)) {
+			err = -EOPNOTSUPP;
+			goto err_flowtable_update_hook;
+		}
 	} else {
 		flags = flowtable->data.flags;
 	}
-- 
2.30.2

