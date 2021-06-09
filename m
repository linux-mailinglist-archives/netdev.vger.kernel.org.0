Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D88133A1F49
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFIVrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:47:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:60534 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbhFIVre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 17:47:34 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1725464237;
        Wed,  9 Jun 2021 23:44:25 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 13/13] netfilter: nf_tables: move base hook annotation to init helper
Date:   Wed,  9 Jun 2021 23:45:23 +0200
Message-Id: <20210609214523.1678-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609214523.1678-1-pablo@netfilter.org>
References: <20210609214523.1678-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

coverity scanner says:
2187  if (nft_is_base_chain(chain)) {
vvv   CID 1505166:  Memory - corruptions  (UNINIT)
vvv   Using uninitialized value "basechain".
2188  basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;

... I don't see how nft_is_base_chain() can evaluate to true
while basechain pointer is garbage.

However, it seems better to place the NF_HOOK_OP_NF_TABLES annotation
in nft_basechain_hook_init() instead.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1505166 ("Memory - corruptions")
Fixes: 65b8b7bfc5284f ("netfilter: annotate nf_tables base hook ops")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c9308241b688..caaff7ab9e73 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1997,11 +1997,12 @@ static void nft_basechain_hook_init(struct nf_hook_ops *ops, u8 family,
 				    const struct nft_chain_hook *hook,
 				    struct nft_chain *chain)
 {
-	ops->pf		= family;
-	ops->hooknum	= hook->num;
-	ops->priority	= hook->priority;
-	ops->priv	= chain;
-	ops->hook	= hook->type->hooks[ops->hooknum];
+	ops->pf			= family;
+	ops->hooknum		= hook->num;
+	ops->priority		= hook->priority;
+	ops->priv		= chain;
+	ops->hook		= hook->type->hooks[ops->hooknum];
+	ops->hook_ops_type	= NF_HOOK_OP_NF_TABLES;
 }
 
 static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
@@ -2168,10 +2169,8 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	}
 
 	nft_trans_chain_policy(trans) = NFT_CHAIN_POLICY_UNSET;
-	if (nft_is_base_chain(chain)) {
-		basechain->ops.hook_ops_type = NF_HOOK_OP_NF_TABLES;
+	if (nft_is_base_chain(chain))
 		nft_trans_chain_policy(trans) = policy;
-	}
 
 	err = nft_chain_add(table, chain);
 	if (err < 0) {
-- 
2.30.2

