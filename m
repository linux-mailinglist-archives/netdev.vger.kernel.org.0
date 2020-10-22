Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574072963B9
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2900177AbgJVR3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 13:29:41 -0400
Received: from correo.us.es ([193.147.175.20]:54156 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2900136AbgJVR3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 13:29:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7699B1C43A5
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66B90DA853
        for <netdev@vger.kernel.org>; Thu, 22 Oct 2020 19:29:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5C771DA730; Thu, 22 Oct 2020 19:29:38 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 31763DA722;
        Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 22 Oct 2020 19:29:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 0647042EE38E;
        Thu, 22 Oct 2020 19:29:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/7] netfilter: nftables_offload: KASAN slab-out-of-bounds Read in nft_flow_rule_create
Date:   Thu, 22 Oct 2020 19:29:24 +0200
Message-Id: <20201022172925.22770-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201022172925.22770-1-pablo@netfilter.org>
References: <20201022172925.22770-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>

This patch fixes the issue due to:

BUG: KASAN: slab-out-of-bounds in nft_flow_rule_create+0x622/0x6a2
net/netfilter/nf_tables_offload.c:40
Read of size 8 at addr ffff888103910b58 by task syz-executor227/16244

The error happens when expr->ops is accessed early on before performing the boundary check and after nft_expr_next() moves the expr to go out-of-bounds.

This patch checks the boundary condition before expr->ops that fixes the slab-out-of-bounds Read issue.

Add nft_expr_more() and use it to fix this problem.

Signed-off-by: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 6 ++++++
 net/netfilter/nf_tables_api.c     | 6 +++---
 net/netfilter/nf_tables_offload.c | 4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3f7e56b1171e..55b4cadf290a 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -891,6 +891,12 @@ static inline struct nft_expr *nft_expr_last(const struct nft_rule *rule)
 	return (struct nft_expr *)&rule->data[rule->dlen];
 }
 
+static inline bool nft_expr_more(const struct nft_rule *rule,
+				 const struct nft_expr *expr)
+{
+	return expr != nft_expr_last(rule) && expr->ops;
+}
+
 static inline struct nft_userdata *nft_userdata(const struct nft_rule *rule)
 {
 	return (void *)&rule->data[rule->dlen];
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9957e0ed8658..65cb8e3c13d9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -302,7 +302,7 @@ static void nft_rule_expr_activate(const struct nft_ctx *ctx,
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr != nft_expr_last(rule) && expr->ops) {
+	while (nft_expr_more(rule, expr)) {
 		if (expr->ops->activate)
 			expr->ops->activate(ctx, expr);
 
@@ -317,7 +317,7 @@ static void nft_rule_expr_deactivate(const struct nft_ctx *ctx,
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr != nft_expr_last(rule) && expr->ops) {
+	while (nft_expr_more(rule, expr)) {
 		if (expr->ops->deactivate)
 			expr->ops->deactivate(ctx, expr, phase);
 
@@ -3080,7 +3080,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 	 * is called on error from nf_tables_newrule().
 	 */
 	expr = nft_expr_first(rule);
-	while (expr != nft_expr_last(rule) && expr->ops) {
+	while (nft_expr_more(rule, expr)) {
 		next = nft_expr_next(expr);
 		nf_tables_expr_destroy(ctx, expr);
 		expr = next;
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 7c7e06624dc3..9f625724a20f 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -37,7 +37,7 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 	struct nft_expr *expr;
 
 	expr = nft_expr_first(rule);
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (nft_expr_more(rule, expr)) {
 		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
 			num_actions++;
 
@@ -61,7 +61,7 @@ struct nft_flow_rule *nft_flow_rule_create(struct net *net,
 	ctx->net = net;
 	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
 
-	while (expr->ops && expr != nft_expr_last(rule)) {
+	while (nft_expr_more(rule, expr)) {
 		if (!expr->ops->offload) {
 			err = -EOPNOTSUPP;
 			goto err_out;
-- 
2.20.1

