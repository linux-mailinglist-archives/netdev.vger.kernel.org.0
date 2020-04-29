Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC411BE7B3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgD2TsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:48:15 -0400
Received: from correo.us.es ([193.147.175.20]:50216 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbgD2TsL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 15:48:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F306DE1714
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:42:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0F5BBAAB8
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 21:42:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D69DCBAAA1; Wed, 29 Apr 2020 21:42:51 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3C05BAAB1;
        Wed, 29 Apr 2020 21:42:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 21:42:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CEFE942EF9E0;
        Wed, 29 Apr 2020 21:42:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 4/6] netfilter: nft_nat: set flags from initialization path
Date:   Wed, 29 Apr 2020 21:42:41 +0200
Message-Id: <20200429194243.22228-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200429194243.22228-1-pablo@netfilter.org>
References: <20200429194243.22228-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sets the NAT flags from the control plane path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index bb49a217635e..5c7ff213c030 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -55,7 +55,6 @@ static void nft_nat_eval(const struct nft_expr *expr,
 			       &regs->data[priv->sreg_addr_max],
 			       sizeof(range.max_addr.ip6));
 		}
-		range.flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
 	if (priv->sreg_proto_min) {
@@ -63,10 +62,9 @@ static void nft_nat_eval(const struct nft_expr *expr,
 			&regs->data[priv->sreg_proto_min]);
 		range.max_proto.all = (__force __be16)nft_reg_load16(
 			&regs->data[priv->sreg_proto_max]);
-		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
-	range.flags |= priv->flags;
+	range.flags = priv->flags;
 
 	regs->verdict.code = nf_nat_setup_info(ct, &range, priv->type);
 }
@@ -169,6 +167,8 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		} else {
 			priv->sreg_addr_max = priv->sreg_addr_min;
 		}
+
+		priv->flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
 	plen = sizeof_field(struct nf_nat_range, min_addr.all);
@@ -191,10 +191,12 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		} else {
 			priv->sreg_proto_max = priv->sreg_proto_min;
 		}
+
+		priv->flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
 	if (tb[NFTA_NAT_FLAGS]) {
-		priv->flags = ntohl(nla_get_be32(tb[NFTA_NAT_FLAGS]));
+		priv->flags |= ntohl(nla_get_be32(tb[NFTA_NAT_FLAGS]));
 		if (priv->flags & ~NF_NAT_RANGE_MASK)
 			return -EOPNOTSUPP;
 	}
-- 
2.20.1

