Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3001892F6
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 01:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgCRAkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 20:40:25 -0400
Received: from correo.us.es ([193.147.175.20]:45650 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgCRAkX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 20:40:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B270E27F8A9
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:53 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A4B88DA3A0
        for <netdev@vger.kernel.org>; Wed, 18 Mar 2020 01:39:53 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9A043DA390; Wed, 18 Mar 2020 01:39:53 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D823DDA736;
        Wed, 18 Mar 2020 01:39:51 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 01:39:51 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B13B3426CCB9;
        Wed, 18 Mar 2020 01:39:51 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 24/29] netfilter: nf_tables: add nft_set_elem_update_expr() helper function
Date:   Wed, 18 Mar 2020 01:39:51 +0100
Message-Id: <20200318003956.73573-25-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200318003956.73573-1-pablo@netfilter.org>
References: <20200318003956.73573-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This helper function runs the eval path of the stateful expression
of an existing set element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 12 ++++++++++++
 net/netfilter/nft_dynset.c        |  8 +-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 025ec148ea4f..5d80e09f8148 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -890,6 +890,18 @@ static inline struct nft_userdata *nft_userdata(const struct nft_rule *rule)
 	return (void *)&rule->data[rule->dlen];
 }
 
+static inline void nft_set_elem_update_expr(const struct nft_set_ext *ext,
+					    struct nft_regs *regs,
+					    const struct nft_pktinfo *pkt)
+{
+	struct nft_expr *expr;
+
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
+		expr = nft_set_ext_expr(ext);
+		expr->ops->eval(expr, regs, pkt);
+	}
+}
+
 /*
  * The last pointer isn't really necessary, but the compiler isn't able to
  * determine that the result of nft_expr_last() is always the same since it
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index e106cf1c5b8b..46ab28ec4b53 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -81,7 +81,6 @@ void nft_dynset_eval(const struct nft_expr *expr,
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
-	const struct nft_expr *sexpr;
 	u64 timeout;
 
 	if (priv->op == NFT_DYNSET_OP_DELETE) {
@@ -91,18 +90,13 @@ void nft_dynset_eval(const struct nft_expr *expr,
 
 	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
-		sexpr = NULL;
-		if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-			sexpr = nft_set_ext_expr(ext);
-
 		if (priv->op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
 			timeout = priv->timeout ? : set->timeout;
 			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
 		}
 
-		if (sexpr != NULL)
-			sexpr->ops->eval(sexpr, regs, pkt);
+		nft_set_elem_update_expr(ext, regs, pkt);
 
 		if (priv->invert)
 			regs->verdict.code = NFT_BREAK;
-- 
2.11.0

