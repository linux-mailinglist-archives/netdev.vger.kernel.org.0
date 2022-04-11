Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A13A34FB990
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345527AbiDKKaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345493AbiDKKaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 91560433B5;
        Mon, 11 Apr 2022 03:27:54 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5455063050;
        Mon, 11 Apr 2022 12:23:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 10/11] netfilter: nft_fib: reverse path filter for policy-based routing on iif
Date:   Mon, 11 Apr 2022 12:27:43 +0200
Message-Id: <20220411102744.282101-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
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

If policy-based routing using the iif selector is used, then the fib
expression fails to look up for the reverse path from the prerouting
hook because the input interface cannot be inferred. In order to support
this scenario, extend the fib expression to allow to use after the route
lookup, from the forward hook.

This patch also adds support for the input hook for usability reasons.
Since the prerouting hook cannot be used for the scenario described
above, users need two rules: one for the forward chain and another rule
for the input chain to check for the reverse path check for locally
targeted traffic.

Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 4 ++++
 net/ipv6/netfilter/nft_fib_ipv6.c | 4 ++++
 net/netfilter/nft_fib.c           | 4 ++++
 3 files changed, 12 insertions(+)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index 4151eb1262dd..b75cac69bd7e 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -112,6 +112,10 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		fl4.daddr = iph->daddr;
 		fl4.saddr = get_saddr(iph->saddr);
 	} else {
+		if (nft_hook(pkt) == NF_INET_FORWARD &&
+		    priv->flags & NFTA_FIB_F_IIF)
+			fl4.flowi4_iif = nft_out(pkt)->ifindex;
+
 		fl4.daddr = iph->saddr;
 		fl4.saddr = get_saddr(iph->daddr);
 	}
diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index b3f163b40c2b..8970d0b4faeb 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -30,6 +30,10 @@ static int nft_fib6_flowi_init(struct flowi6 *fl6, const struct nft_fib *priv,
 		fl6->daddr = iph->daddr;
 		fl6->saddr = iph->saddr;
 	} else {
+		if (nft_hook(pkt) == NF_INET_FORWARD &&
+		    priv->flags & NFTA_FIB_F_IIF)
+			fl6->flowi6_iif = nft_out(pkt)->ifindex;
+
 		fl6->daddr = iph->saddr;
 		fl6->saddr = iph->daddr;
 	}
diff --git a/net/netfilter/nft_fib.c b/net/netfilter/nft_fib.c
index f198f2d9ef90..1f12d7ade606 100644
--- a/net/netfilter/nft_fib.c
+++ b/net/netfilter/nft_fib.c
@@ -35,6 +35,10 @@ int nft_fib_validate(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	case NFT_FIB_RESULT_OIF:
 	case NFT_FIB_RESULT_OIFNAME:
 		hooks = (1 << NF_INET_PRE_ROUTING);
+		if (priv->flags & NFTA_FIB_F_IIF) {
+			hooks |= (1 << NF_INET_LOCAL_IN) |
+				 (1 << NF_INET_FORWARD);
+		}
 		break;
 	case NFT_FIB_RESULT_ADDRTYPE:
 		if (priv->flags & NFTA_FIB_F_IIF)
-- 
2.30.2

