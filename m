Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C32383D3CEB
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhGWPOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:06 -0400
Received: from mail.netfilter.org ([217.70.188.207]:57312 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235680AbhGWPNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:13:55 -0400
Received: from localhost.localdomain (unknown [78.30.39.111])
        by mail.netfilter.org (Postfix) with ESMTPSA id E1C28642A4;
        Fri, 23 Jul 2021 17:53:56 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/6] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
Date:   Fri, 23 Jul 2021 17:54:11 +0200
Message-Id: <20210723155412.17916-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210723155412.17916-1-pablo@netfilter.org>
References: <20210723155412.17916-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

nft_nat reports a bogus EAFNOSUPPORT if no layer 3 information is specified.

Fixes: d07db9884a5f ("netfilter: nf_tables: introduce nft_validate_register_load()")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index 0840c635b752..be1595d6979d 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -201,7 +201,9 @@ static int nft_nat_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		alen = sizeof_field(struct nf_nat_range, min_addr.ip6);
 		break;
 	default:
-		return -EAFNOSUPPORT;
+		if (tb[NFTA_NAT_REG_ADDR_MIN])
+			return -EAFNOSUPPORT;
+		break;
 	}
 	priv->family = family;
 
-- 
2.20.1

