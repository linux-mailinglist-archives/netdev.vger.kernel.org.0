Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADAA4AF2EA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 14:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbiBINgc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 08:36:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiBINgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 08:36:25 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D67FC0613C9;
        Wed,  9 Feb 2022 05:36:29 -0800 (PST)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id BE0AE601CC;
        Wed,  9 Feb 2022 14:36:17 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 09/14] netfilter: nft_compat: suppress comment match
Date:   Wed,  9 Feb 2022 14:36:11 +0100
Message-Id: <20220209133616.165104-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220209133616.165104-1-pablo@netfilter.org>
References: <20220209133616.165104-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

No need to have the datapath call the always-true comment match stub.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index f69cc73c5813..5a46d8289d1d 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -731,6 +731,14 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
+static bool nft_match_reduce(struct nft_regs_track *track,
+			     const struct nft_expr *expr)
+{
+	const struct xt_match *match = expr->ops->data;
+
+	return strcmp(match->name, "comment") == 0;
+}
+
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -773,6 +781,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
 	ops->data = match;
+	ops->reduce = nft_match_reduce;
 
 	matchsize = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
 	if (matchsize > NFT_MATCH_LARGE_THRESH) {
-- 
2.30.2

