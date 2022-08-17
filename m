Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E936E597085
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbiHQOBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239908AbiHQOBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:01:05 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2179991082;
        Wed, 17 Aug 2022 07:01:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oOJbS-0008Oh-L4; Wed, 17 Aug 2022 16:01:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 03/17] netfilter: nf_tables: possible module reference underflow in error path
Date:   Wed, 17 Aug 2022 16:00:01 +0200
Message-Id: <20220817140015.25843-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220817140015.25843-1-fw@strlen.de>
References: <20220817140015.25843-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

dst->ops is set on when nft_expr_clone() fails, but module refcount has
not been bumped yet, therefore nft_expr_destroy() leads to module
reference underflow.

Fixes: 8cfd9b0f8515 ("netfilter: nftables: generalize set expressions support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ac549c5b88c2..989c9782ecc3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5601,7 +5601,7 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 
 		err = nft_expr_clone(expr, set->exprs[i]);
 		if (err < 0) {
-			nft_expr_destroy(ctx, expr);
+			kfree(expr);
 			goto err_expr;
 		}
 		expr_array[i] = expr;
-- 
2.35.1

