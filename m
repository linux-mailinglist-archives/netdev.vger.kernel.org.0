Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E5324544E
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 00:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgHOWTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 18:19:22 -0400
Received: from correo.us.es ([193.147.175.20]:38906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727994AbgHOWSv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 18:18:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B98F6DA89A
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AD0BADA704
        for <netdev@vger.kernel.org>; Sat, 15 Aug 2020 12:32:17 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A2B9ADA73D; Sat, 15 Aug 2020 12:32:17 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4627DDA704;
        Sat, 15 Aug 2020 12:32:15 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 15 Aug 2020 12:32:15 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [213.143.48.187])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 59D2542EF4E0;
        Sat, 15 Aug 2020 12:32:14 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 2/8] netfilter: nft_compat: remove flush counter optimization
Date:   Sat, 15 Aug 2020 12:31:55 +0200
Message-Id: <20200815103201.1768-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200815103201.1768-1-pablo@netfilter.org>
References: <20200815103201.1768-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

WARNING: CPU: 1 PID: 16059 at lib/refcount.c:31 refcount_warn_saturate+0xdf/0xf
[..]
 __nft_mt_tg_destroy+0x42/0x50 [nft_compat]
 nft_target_destroy+0x63/0x80 [nft_compat]
 nf_tables_expr_destroy+0x1b/0x30 [nf_tables]
 nf_tables_rule_destroy+0x3a/0x70 [nf_tables]
 nf_tables_exit_net+0x186/0x3d0 [nf_tables]

Happens when a compat expr is destoyed from abort path.
There is no functional impact; after this work queue is flushed
unconditionally if its pending.

This removes the waitcount optimization.  Test of repeated
iptables-restore of a ~60k kubernetes ruleset doesn't indicate
a slowdown.  In case the counter is needed after all for some workloads
we can revert this and increment the refcount for the
!= NFT_PREPARE_TRANS case to avoid the increment/decrement imbalance.

While at it, also flush for match case, this was an oversight
in the original patch.

Fixes: ffe8923f109b7e ("netfilter: nft_compat: make sure xtables destructors have run")
Reported-by: kernel test robot <rong.a.chen@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 6428856ccbec..8e56f353ff35 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -27,8 +27,6 @@ struct nft_xt_match_priv {
 	void *info;
 };
 
-static refcount_t nft_compat_pending_destroy = REFCOUNT_INIT(1);
-
 static int nft_compat_chain_validate_dependency(const struct nft_ctx *ctx,
 						const char *tablename)
 {
@@ -215,6 +213,17 @@ static int nft_parse_compat(const struct nlattr *attr, u16 *proto, bool *inv)
 	return 0;
 }
 
+static void nft_compat_wait_for_destructors(void)
+{
+	/* xtables matches or targets can have side effects, e.g.
+	 * creation/destruction of /proc files.
+	 * The xt ->destroy functions are run asynchronously from
+	 * work queue.  If we have pending invocations we thus
+	 * need to wait for those to finish.
+	 */
+	nf_tables_trans_destroy_flush_work();
+}
+
 static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -238,14 +247,7 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_target_set_tgchk_param(&par, ctx, target, info, &e, proto, inv);
 
-	/* xtables matches or targets can have side effects, e.g.
-	 * creation/destruction of /proc files.
-	 * The xt ->destroy functions are run asynchronously from
-	 * work queue.  If we have pending invocations we thus
-	 * need to wait for those to finish.
-	 */
-	if (refcount_read(&nft_compat_pending_destroy) > 1)
-		nf_tables_trans_destroy_flush_work();
+	nft_compat_wait_for_destructors();
 
 	ret = xt_check_target(&par, size, proto, inv);
 	if (ret < 0)
@@ -260,7 +262,6 @@ nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 static void __nft_mt_tg_destroy(struct module *me, const struct nft_expr *expr)
 {
-	refcount_dec(&nft_compat_pending_destroy);
 	module_put(me);
 	kfree(expr->ops);
 }
@@ -468,6 +469,8 @@ __nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 
 	nft_match_set_mtchk_param(&par, ctx, match, info, &e, proto, inv);
 
+	nft_compat_wait_for_destructors();
+
 	return xt_check_match(&par, size, proto, inv);
 }
 
@@ -716,14 +719,6 @@ static const struct nfnetlink_subsystem nfnl_compat_subsys = {
 
 static struct nft_expr_type nft_match_type;
 
-static void nft_mt_tg_deactivate(const struct nft_ctx *ctx,
-				 const struct nft_expr *expr,
-				 enum nft_trans_phase phase)
-{
-	if (phase == NFT_TRANS_COMMIT)
-		refcount_inc(&nft_compat_pending_destroy);
-}
-
 static const struct nft_expr_ops *
 nft_match_select_ops(const struct nft_ctx *ctx,
 		     const struct nlattr * const tb[])
@@ -762,7 +757,6 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	ops->type = &nft_match_type;
 	ops->eval = nft_match_eval;
 	ops->init = nft_match_init;
-	ops->deactivate = nft_mt_tg_deactivate,
 	ops->destroy = nft_match_destroy;
 	ops->dump = nft_match_dump;
 	ops->validate = nft_match_validate;
@@ -853,7 +847,6 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	ops->size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
 	ops->init = nft_target_init;
 	ops->destroy = nft_target_destroy;
-	ops->deactivate = nft_mt_tg_deactivate,
 	ops->dump = nft_target_dump;
 	ops->validate = nft_target_validate;
 	ops->data = target;
@@ -917,8 +910,6 @@ static void __exit nft_compat_module_exit(void)
 	nfnetlink_subsys_unregister(&nfnl_compat_subsys);
 	nft_unregister_expr(&nft_target_type);
 	nft_unregister_expr(&nft_match_type);
-
-	WARN_ON_ONCE(refcount_read(&nft_compat_pending_destroy) != 1);
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_NFT_COMPAT);
-- 
2.20.1

