Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4505E293A48
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393855AbgJTLux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:50:53 -0400
Received: from correo.us.es ([193.147.175.20]:35408 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393641AbgJTLuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 07:50:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE5B8116C89
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 13:50:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A9A6DFB389
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 13:50:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E24EFA52A; Tue, 20 Oct 2020 13:50:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 51AA5DA91F;
        Tue, 20 Oct 2020 13:50:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 13:50:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DA6E141A3F46;
        Tue, 20 Oct 2020 13:50:47 +0200 (CEST)
Date:   Tue, 20 Oct 2020 13:50:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     saeed.mirzamohammadi@oracle.com
Cc:     linux-kernel@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH linux-5.9 1/1] net: netfilter: fix KASAN:
 slab-out-of-bounds Read in nft_flow_rule_create
Message-ID: <20201020115047.GA15628@salvia>
References: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20201019172532.3906-1-saeed.mirzamohammadi@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Oct 19, 2020 at 10:25:32AM -0700, saeed.mirzamohammadi@oracle.com wrote:
> From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
> 
> This patch fixes the issue due to:
> 
> BUG: KASAN: slab-out-of-bounds in nft_flow_rule_create+0x622/0x6a2
> net/netfilter/nf_tables_offload.c:40
> Read of size 8 at addr ffff888103910b58 by task syz-executor227/16244
> 
> The error happens when expr->ops is accessed early on before performing the boundary check and after nft_expr_next() moves the expr to go out-of-bounds.
> 
> This patch checks the boundary condition before expr->ops that fixes the slab-out-of-bounds Read issue.

Thanks. I made a slight variant of your patch.

I'm attaching it, it is also fixing the problem but it introduced
nft_expr_more() and use it everywhere.

Let me know if this looks fine to you.

--J/dobhs11T7y2rNN
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-fix-KASAN-slab-out-of-bounds-Read-in-nft_f.patch"

From 3f60e5f489ec44e8b0a7e9e622c93be4df335fb6 Mon Sep 17 00:00:00 2001
From: Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
Date: Tue, 20 Oct 2020 13:41:36 +0200
Subject: [PATCH nf] netfilter: fix KASAN: slab-out-of-bounds Read in
 nft_flow_rule_create

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


--J/dobhs11T7y2rNN--
