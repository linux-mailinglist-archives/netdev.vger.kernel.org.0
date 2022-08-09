Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78E9F58E275
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 00:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbiHIWGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 18:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiHIWFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 18:05:44 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1844814012;
        Tue,  9 Aug 2022 15:05:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 4/8] netfilter: nf_tables: do not allow RULE_ID to refer to another chain
Date:   Wed, 10 Aug 2022 00:05:28 +0200
Message-Id: <20220809220532.130240-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220809220532.130240-1-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

When doing lookups for rules on the same batch by using its ID, a rule from
a different chain can be used. If a rule is added to a chain but tries to
be positioned next to a rule from a different chain, it will be linked to
chain2, but the use counter on chain1 would be the one to be incremented.

When looking for rules by ID, use the chain that was used for the lookup by
name. The chain used in the context copied to the transaction needs to
match that same chain. That way, struct nft_rule does not need to get
enlarged with another member.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Fixes: 75dd48e2e420 ("netfilter: nf_tables: Support RULE_ID reference in new rule")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 041accbaca32..0c3c0523e5f2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3373,6 +3373,7 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
 
 #define NFT_RULE_MAXEXPRS	128
@@ -3461,7 +3462,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 				return PTR_ERR(old_rule);
 			}
 		} else if (nla[NFTA_RULE_POSITION_ID]) {
-			old_rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_POSITION_ID]);
+			old_rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_POSITION_ID]);
 			if (IS_ERR(old_rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_POSITION_ID]);
 				return PTR_ERR(old_rule);
@@ -3606,6 +3607,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 }
 
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
+					     const struct nft_chain *chain,
 					     const struct nlattr *nla)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -3616,6 +3618,7 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 		struct nft_rule *rule = nft_trans_rule(trans);
 
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
+		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
 			return rule;
 	}
@@ -3665,7 +3668,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 			err = nft_delrule(&ctx, rule);
 		} else if (nla[NFTA_RULE_ID]) {
-			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
+			rule = nft_rule_lookup_byid(net, chain, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);
-- 
2.30.2

