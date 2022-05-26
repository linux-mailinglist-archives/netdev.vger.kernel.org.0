Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA6553552D
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 22:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349190AbiEZUyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 16:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349052AbiEZUy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 16:54:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05AA4E732A;
        Thu, 26 May 2022 13:54:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH net 2/2] netfilter: nft_limit: Clone packet limits' cost value
Date:   Thu, 26 May 2022 22:54:11 +0200
Message-Id: <20220526205411.315136-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220526205411.315136-1-pablo@netfilter.org>
References: <20220526205411.315136-1-pablo@netfilter.org>
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

From: Phil Sutter <phil@nwl.cc>

When cloning a packet-based limit expression, copy the cost value as
well. Otherwise the new limit is not functional anymore.

Fixes: 3b9e2ea6c11bf ("netfilter: nft_limit: move stateful fields out of expression data")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 04ea8b9bf202..981addb2d051 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -213,6 +213,8 @@ static int nft_limit_pkts_clone(struct nft_expr *dst, const struct nft_expr *src
 	struct nft_limit_priv_pkts *priv_dst = nft_expr_priv(dst);
 	struct nft_limit_priv_pkts *priv_src = nft_expr_priv(src);
 
+	priv_dst->cost = priv_src->cost;
+
 	return nft_limit_clone(&priv_dst->limit, &priv_src->limit);
 }
 
-- 
2.30.2

