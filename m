Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71717581A35
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 21:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239785AbiGZTVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 15:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239784AbiGZTVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 15:21:41 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9801033E39
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:21:39 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oGQ7e-00081Q-20; Tue, 26 Jul 2022 21:21:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net 3/3] netfilter: nft_queue: only allow supported familes and hooks
Date:   Tue, 26 Jul 2022 21:20:56 +0200
Message-Id: <20220726192056.13497-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220726192056.13497-1-fw@strlen.de>
References: <20220726192056.13497-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Trying to use 'queue' statement in ingress (for example)
triggers a splat on reinject:

WARNING: CPU: 3 PID: 1345 at net/netfilter/nf_queue.c:291

... because nf_reinject cannot find the ruleset head.

The netdev family doesn't support async resume at the moment anyway,
so disallow loading such rulesets with a more appropriate
error message.

v2: add 'validate' callback and also check hook points, v1 did
allow ingress use in 'table inet', but that doesn't work either. (Pablo)

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_queue.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/netfilter/nft_queue.c b/net/netfilter/nft_queue.c
index 15e4b7640dc0..da29e92c03e2 100644
--- a/net/netfilter/nft_queue.c
+++ b/net/netfilter/nft_queue.c
@@ -68,6 +68,31 @@ static void nft_queue_sreg_eval(const struct nft_expr *expr,
 	regs->verdict.code = ret;
 }
 
+static int nft_queue_validate(const struct nft_ctx *ctx,
+			      const struct nft_expr *expr,
+			      const struct nft_data **data)
+{
+	static const unsigned int supported_hooks = ((1 << NF_INET_PRE_ROUTING) |
+						     (1 << NF_INET_LOCAL_IN) |
+						     (1 << NF_INET_FORWARD) |
+						     (1 << NF_INET_LOCAL_OUT) |
+						     (1 << NF_INET_POST_ROUTING));
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		break;
+	case NFPROTO_NETDEV: /* lacks okfn */
+		fallthrough;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return nft_chain_validate_hooks(ctx->chain, supported_hooks);
+}
+
 static const struct nla_policy nft_queue_policy[NFTA_QUEUE_MAX + 1] = {
 	[NFTA_QUEUE_NUM]	= { .type = NLA_U16 },
 	[NFTA_QUEUE_TOTAL]	= { .type = NLA_U16 },
@@ -164,6 +189,7 @@ static const struct nft_expr_ops nft_queue_ops = {
 	.eval		= nft_queue_eval,
 	.init		= nft_queue_init,
 	.dump		= nft_queue_dump,
+	.validate	= nft_queue_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
@@ -173,6 +199,7 @@ static const struct nft_expr_ops nft_queue_sreg_ops = {
 	.eval		= nft_queue_sreg_eval,
 	.init		= nft_queue_sreg_init,
 	.dump		= nft_queue_sreg_dump,
+	.validate	= nft_queue_validate,
 	.reduce		= NFT_REDUCE_READONLY,
 };
 
-- 
2.35.1

