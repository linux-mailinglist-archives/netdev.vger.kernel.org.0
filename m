Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C53314196D
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 21:14:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgARUOn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 15:14:43 -0500
Received: from correo.us.es ([193.147.175.20]:48426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728949AbgARUOf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 15:14:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 843932EFEA5
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 776C4DA711
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 21:14:34 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6C2F3DA70F; Sat, 18 Jan 2020 21:14:34 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77C46DA709;
        Sat, 18 Jan 2020 21:14:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 18 Jan 2020 21:14:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 488F541E4800;
        Sat, 18 Jan 2020 21:14:32 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 19/21] netfilter: bitwise: only offload boolean operations.
Date:   Sat, 18 Jan 2020 21:14:15 +0100
Message-Id: <20200118201417.334111-20-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200118201417.334111-1-pablo@netfilter.org>
References: <20200118201417.334111-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

Only boolean operations supports offloading, so check the type of the
operation and return an error for other types.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 41265134cf0b..b4619d9989ea 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -189,6 +189,9 @@ static int nft_bitwise_offload(struct nft_offload_ctx *ctx,
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	struct nft_offload_reg *reg = &ctx->regs[priv->dreg];
 
+	if (priv->op != NFT_BITWISE_BOOL)
+		return -EOPNOTSUPP;
+
 	if (memcmp(&priv->xor, &zero, sizeof(priv->xor)) ||
 	    priv->sreg != priv->dreg || priv->len != reg->len)
 		return -EOPNOTSUPP;
-- 
2.11.0

