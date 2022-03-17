Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F75B4DCF4D
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 21:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiCQU1A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 16:27:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiCQU06 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 16:26:58 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C9BBB1546A5;
        Thu, 17 Mar 2022 13:25:40 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5364463022;
        Thu, 17 Mar 2022 21:23:12 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/3] netfilter: nf_tables: validate registers coming from userspace.
Date:   Thu, 17 Mar 2022 21:25:33 +0100
Message-Id: <20220317202534.41530-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220317202534.41530-1-pablo@netfilter.org>
References: <20220317202534.41530-1-pablo@netfilter.org>
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

Bail out in case userspace uses unsupported registers.

Fixes: 49499c3e6e18 ("netfilter: nf_tables: switch registers to 32 bit addressing")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d71a33ae39b3..1f5a0eece0d1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9275,17 +9275,23 @@ int nft_parse_u32_check(const struct nlattr *attr, int max, u32 *dest)
 }
 EXPORT_SYMBOL_GPL(nft_parse_u32_check);
 
-static unsigned int nft_parse_register(const struct nlattr *attr)
+static unsigned int nft_parse_register(const struct nlattr *attr, u32 *preg)
 {
 	unsigned int reg;
 
 	reg = ntohl(nla_get_be32(attr));
 	switch (reg) {
 	case NFT_REG_VERDICT...NFT_REG_4:
-		return reg * NFT_REG_SIZE / NFT_REG32_SIZE;
+		*preg = reg * NFT_REG_SIZE / NFT_REG32_SIZE;
+		break;
+	case NFT_REG32_00...NFT_REG32_15:
+		*preg = reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
+		break;
 	default:
-		return reg + NFT_REG_SIZE / NFT_REG32_SIZE - NFT_REG32_00;
+		return -ERANGE;
 	}
+
+	return 0;
 }
 
 /**
@@ -9327,7 +9333,10 @@ int nft_parse_register_load(const struct nlattr *attr, u8 *sreg, u32 len)
 	u32 reg;
 	int err;
 
-	reg = nft_parse_register(attr);
+	err = nft_parse_register(attr, &reg);
+	if (err < 0)
+		return err;
+
 	err = nft_validate_register_load(reg, len);
 	if (err < 0)
 		return err;
@@ -9382,7 +9391,10 @@ int nft_parse_register_store(const struct nft_ctx *ctx,
 	int err;
 	u32 reg;
 
-	reg = nft_parse_register(attr);
+	err = nft_parse_register(attr, &reg);
+	if (err < 0)
+		return err;
+
 	err = nft_validate_register_store(ctx, reg, data, type, len);
 	if (err < 0)
 		return err;
-- 
2.30.2

