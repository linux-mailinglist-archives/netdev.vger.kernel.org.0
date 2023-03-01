Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44C366A76BD
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 23:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjCAWUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 17:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCAWUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 17:20:32 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 66AC7521ED;
        Wed,  1 Mar 2023 14:20:29 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 3/3] netfilter: nft_quota: copy content when cloning expression
Date:   Wed,  1 Mar 2023 23:20:21 +0100
Message-Id: <20230301222021.154670-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230301222021.154670-1-pablo@netfilter.org>
References: <20230301222021.154670-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the ruleset contains consumed quota, restore them accordingly.
Otherwise, listing after restoration shows never used items.

Restore the user-defined quota and flags too.

Fixes: ed0a0c60f0e5 ("netfilter: nft_quota: move stateful fields out of expression data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 123578e28917..3ba12a7471b0 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -236,12 +236,16 @@ static void nft_quota_destroy(const struct nft_ctx *ctx,
 static int nft_quota_clone(struct nft_expr *dst, const struct nft_expr *src)
 {
 	struct nft_quota *priv_dst = nft_expr_priv(dst);
+	struct nft_quota *priv_src = nft_expr_priv(src);
+
+	priv_dst->quota = priv_src->quota;
+	priv_dst->flags = priv_src->flags;
 
 	priv_dst->consumed = kmalloc(sizeof(*priv_dst->consumed), GFP_ATOMIC);
 	if (!priv_dst->consumed)
 		return -ENOMEM;
 
-	atomic64_set(priv_dst->consumed, 0);
+	*priv_dst->consumed = *priv_src->consumed;
 
 	return 0;
 }
-- 
2.30.2

