Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F8457C087
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiGTXI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiGTXIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:08:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 06AD566AC6;
        Wed, 20 Jul 2022 16:08:07 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH nf-next 14/18] netfilter: nf_tables: move nft_cmp_fast_mask to where its used
Date:   Thu, 21 Jul 2022 01:07:50 +0200
Message-Id: <20220720230754.209053-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220720230754.209053-1-pablo@netfilter.org>
References: <20220720230754.209053-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

... and cast result to u32 so sparse won't complain anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h | 10 ----------
 net/netfilter/nft_cmp.c                | 12 ++++++++++++
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 0ea7c55cea4d..1223af68cd9a 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -56,16 +56,6 @@ struct nft_immediate_expr {
 	u8			dlen;
 };
 
-/* Calculate the mask for the nft_cmp_fast expression. On big endian the
- * mask needs to include the *upper* bytes when interpreting that data as
- * something smaller than the full u32, therefore a cpu_to_le32 is done.
- */
-static inline u32 nft_cmp_fast_mask(unsigned int len)
-{
-	return cpu_to_le32(~0U >> (sizeof_field(struct nft_cmp_fast_expr,
-						data) * BITS_PER_BYTE - len));
-}
-
 extern const struct nft_expr_ops nft_cmp_fast_ops;
 extern const struct nft_expr_ops nft_cmp16_fast_ops;
 
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index bec22584395f..777f09e4dc60 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -197,6 +197,18 @@ static const struct nft_expr_ops nft_cmp_ops = {
 	.offload	= nft_cmp_offload,
 };
 
+/* Calculate the mask for the nft_cmp_fast expression. On big endian the
+ * mask needs to include the *upper* bytes when interpreting that data as
+ * something smaller than the full u32, therefore a cpu_to_le32 is done.
+ */
+static u32 nft_cmp_fast_mask(unsigned int len)
+{
+	__le32 mask = cpu_to_le32(~0U >> (sizeof_field(struct nft_cmp_fast_expr,
+					  data) * BITS_PER_BYTE - len));
+
+	return (__force u32)mask;
+}
+
 static int nft_cmp_fast_init(const struct nft_ctx *ctx,
 			     const struct nft_expr *expr,
 			     const struct nlattr * const tb[])
-- 
2.30.2

