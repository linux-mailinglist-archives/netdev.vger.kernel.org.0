Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A17A8E013
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 23:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbfHNVoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 17:44:01 -0400
Received: from correo.us.es ([193.147.175.20]:47266 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729085AbfHNVoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 17:44:00 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4F559C4140
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:43:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FC5F1150D8
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 23:43:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35549DA704; Wed, 14 Aug 2019 23:43:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE95ADA72F;
        Wed, 14 Aug 2019 23:43:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 23:43:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B73A84265A2F;
        Wed, 14 Aug 2019 23:43:55 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/2] netfilter: nft_bitwise: Adjust parentheses to fix memcmp size argument
Date:   Wed, 14 Aug 2019 23:43:47 +0200
Message-Id: <20190814214347.4940-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190814214347.4940-1-pablo@netfilter.org>
References: <20190814214347.4940-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

clang warns:

net/netfilter/nft_bitwise.c:138:50: error: size argument in 'memcmp'
call is a comparison [-Werror,-Wmemsize-comparison]
        if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
                                      ~~~~~~~~~~~~~~~~~~^~
net/netfilter/nft_bitwise.c:138:6: note: did you mean to compare the
result of 'memcmp' instead?
        if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
            ^
                                                       )
net/netfilter/nft_bitwise.c:138:32: note: explicitly cast the argument
to size_t to silence this warning
        if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
                                      ^
                                      (size_t)(
1 error generated.

Adjust the parentheses so that the result of the sizeof is used for the
size argument in memcmp, rather than the result of the comparison (which
would always be true because sizeof is a non-zero number).

Fixes: bd8699e9e292 ("netfilter: nft_bitwise: add offload support")
Link: https://github.com/ClangBuiltLinux/linux/issues/638
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 1f04ed5c518c..974300178fa9 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -135,8 +135,8 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 
-	if (memcmp(&priv->xor, &zero, sizeof(priv->xor) ||
-	    priv->sreg != priv->dreg))
+	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
+	    priv->sreg != priv->dreg)
 		return -EOPNOTSUPP;
 
 	memcpy(&ctx->regs[priv->dreg].mask, &priv->mask, sizeof(priv->mask));
-- 
2.11.0

