Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE02E2359DF
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 20:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgHBScD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 14:32:03 -0400
Received: from correo.us.es ([193.147.175.20]:45724 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgHBScC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 14:32:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A27FAE4B84
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:32:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94F80DA73F
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 20:32:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8A6C3DA78B; Sun,  2 Aug 2020 20:32:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 65D2ADA73F;
        Sun,  2 Aug 2020 20:31:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 02 Aug 2020 20:31:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (120.205.137.78.rev.vodafone.pt [78.137.205.120])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8588E4265A2F;
        Sun,  2 Aug 2020 20:31:57 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/7] netfilter: nf_tables: Fix a use after free in nft_immediate_destroy()
Date:   Sun,  2 Aug 2020 20:31:42 +0200
Message-Id: <20200802183149.2808-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200802183149.2808-1-pablo@netfilter.org>
References: <20200802183149.2808-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The nf_tables_rule_release() function frees "rule" so we have to use
the _safe() version of list_for_each_entry().

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_immediate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 9e556638bb32..c63eb3b17178 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -103,9 +103,9 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 	const struct nft_data *data = &priv->data;
+	struct nft_rule *rule, *n;
 	struct nft_ctx chain_ctx;
 	struct nft_chain *chain;
-	struct nft_rule *rule;
 
 	if (priv->dreg != NFT_REG_VERDICT)
 		return;
@@ -121,7 +121,7 @@ static void nft_immediate_destroy(const struct nft_ctx *ctx,
 		chain_ctx = *ctx;
 		chain_ctx.chain = chain;
 
-		list_for_each_entry(rule, &chain->rules, list)
+		list_for_each_entry_safe(rule, n, &chain->rules, list)
 			nf_tables_rule_release(&chain_ctx, rule);
 
 		nf_tables_chain_destroy(&chain_ctx);
-- 
2.20.1

