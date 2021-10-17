Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4321430C94
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 00:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344758AbhJQWRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 18:17:52 -0400
Received: from mail.netfilter.org ([217.70.188.207]:53394 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344751AbhJQWRw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 18:17:52 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4B76363EE1;
        Mon, 18 Oct 2021 00:14:00 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH nf-next 02/15] netfilter: nft_dynset: relax superfluous check on set updates
Date:   Mon, 18 Oct 2021 00:15:09 +0200
Message-Id: <20211017221522.853838-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211017221522.853838-1-pablo@netfilter.org>
References: <20211017221522.853838-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relax this condition to make add and update commands idempotent for sets
with no timeout. The eval function already checks if the set element
timeout is available and updates it if the update command is used.

Fixes: 22fe54d5fefc ("netfilter: nf_tables: add support for dynamic set updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_dynset.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6ba3256fa844..87f3af4645d9 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -198,17 +198,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		return -EBUSY;
 
 	priv->op = ntohl(nla_get_be32(tb[NFTA_DYNSET_OP]));
-	switch (priv->op) {
-	case NFT_DYNSET_OP_ADD:
-	case NFT_DYNSET_OP_DELETE:
-		break;
-	case NFT_DYNSET_OP_UPDATE:
-		if (!(set->flags & NFT_SET_TIMEOUT))
-			return -EOPNOTSUPP;
-		break;
-	default:
+	if (priv->op > NFT_DYNSET_OP_DELETE)
 		return -EOPNOTSUPP;
-	}
 
 	timeout = 0;
 	if (tb[NFTA_DYNSET_TIMEOUT] != NULL) {
-- 
2.30.2

