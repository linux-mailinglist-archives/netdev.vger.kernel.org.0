Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9BD5870CA
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233803AbiHATDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbiHATCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:02:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B912CE32;
        Mon,  1 Aug 2022 12:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0CB261172;
        Mon,  1 Aug 2022 19:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF998C433D6;
        Mon,  1 Aug 2022 19:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380560;
        bh=pMLp0+qYNKEIUa9AGUAmCf0y2RNO1+e4eW/XAxC26Kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAdizMjBY73krWXhiXSvndEBHdigfiEe+MrU50nCLAw/zigwq4aiM/EqwCMgAL+Wl
         EMJkRid+9wxl1ptGRfFybyPVigs+4aOmmB+CUl8BdhbDmUehiOCsq7ap+G27MonQd5
         K+j8dD7Gg6d9gNQDcXY+xVuPmHakLaLnmvASor0J02ZzIDKNXMgktB81/2T8FWKxfA
         BC7SQi7MFy/HtPmkKFmey8rSQGMfRPd2ZMyWGNL9HFnTi0CHZ11rjN95GIoy8a+rgb
         7psf+qRewCnPjizZNsEyt4EIHqViphIIycgZQhovBBQHmz2eaNieiDxSIrVqc6JamR
         T9CT0J7rn/QOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 09/10] netfilter: nft_queue: only allow supported familes and hooks
Date:   Mon,  1 Aug 2022 15:02:21 -0400
Message-Id: <20220801190222.3818378-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190222.3818378-1-sashal@kernel.org>
References: <20220801190222.3818378-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 47f4f510ad586032b85c89a0773fbb011d412425 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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

