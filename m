Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C49ABBF3
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 17:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388652AbfIFPM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 11:12:59 -0400
Received: from mout.kundenserver.de ([212.227.126.134]:54149 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726019AbfIFPM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 11:12:59 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.129]) with ESMTPA (Nemesis) id
 1McY0L-1ijAZ70D9h-00cviz; Fri, 06 Sep 2019 17:12:44 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        wenxu <wenxu@ucloud.cn>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] netfilter: nf_tables: avoid excessive stack usage
Date:   Fri,  6 Sep 2019 17:12:30 +0200
Message-Id: <20190906151242.1115282-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:H4wBtVZNbYT58k3ooZMgp+mPB1WUVSJqouzTOP8MFKlvBbGsWfC
 CXKQuDBiBcnfb240Ianbu5O/iTJjNIwyMe9ub9lwbE4JlIUx1X8zg1/DjN1srdPSE1C/KQU
 Trz0oDCkLw+4aCZC1cB7J/h6CF0wFXT3sY+XhPtH1nST6si02Rj6Hq8j7o2yMg3uMA4vUoO
 MznQIClCOUcPSv3K49Mxg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dgvyv05Zu8g=:eRZphasKugh5xr/DCQ5H9T
 fNRZ+EXkGK7DYHkdeUs6ZF+q0Y7143WFsoJDKxotd0ykN5nCyaKrGCZSkpSqO7NCO/na2t7bx
 hMkSD0CR2+qf8e1wCQSI98w8VUDkpy1UgPyzGPekwo109R0FJ4yqFZbwCq0IqSYr1YaTynAov
 7YHmV37ox7mzMA4SIVtIUZ6YWUrnN/O8+itm7rvyeU7yYaSYL4ih8ddtXaTrDJ5zzYbjDBb+4
 IMdNdhYVI2zjc+UjpFvx9hJczdz613IQdXEYlG9XkIlLGecBZIwDbeZj3Nx5XPBnIxTuWrHcL
 FWH7sppW//4BztL9Dz2UMvCEqDSNEP+asDftnusmJDN7vnRIAKoOyY52yOKvMxDIsv/3fYLsy
 tABpcEVapheu8pzQZatM1zMGbWwL+4bbfQBmBmT6RemRVTvJj0SVPhWJ7aZoJhsSZH9Zn54R7
 axZvSWBKtb0gVq9k68aEEH3pS6OudQWql0+NYBtEXHJqHngiwntA/LPhBy44BoWYETWikGCCw
 Vc1cdKbr7D636SysLHXyLc5KGViNXOSEYucYWn3OPRx00e+DA2JxqZ4ObxSMfcqbOhq3JawpQ
 4GyHdJ16jiArJZWtmFTqggn/+YHkD8F5bRSTFAAptjd0HnTm7VePYWPr8XBB2kxR+2ic9ekEV
 GO2hVMXX7WD6w6GpqqiEnsdXofbgTdePbrijzJQ0KtOFEcN85jTfgDxUJHdbGSlYoi00uAwg9
 b5LX5nW3SRDHSu31Egllt2TMT5FA+iLFsBPS2Wvs44Jq346tuA95Suve8MNFTZuAFHLC+QmM8
 TSSeQQt98Sh5pXMhV5FJnuRgaslWg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The nft_offload_ctx structure is much too large to put on the
stack:

net/netfilter/nf_tables_offload.c:31:23: error: stack frame size of 1200 bytes in function 'nft_flow_rule_create' [-Werror,-Wframe-larger-than=]

Use dynamic allocation here, as we do elsewhere in the same
function.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Since we only really care about two members of the structure, an
alternative would be a larger rewrite, but that is probably too
late for v5.4.
---
 net/netfilter/nf_tables_offload.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 3c2725ade61b..c94331aae552 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -30,15 +30,13 @@ static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
 
 struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
 {
-	struct nft_offload_ctx ctx = {
-		.dep	= {
-			.type	= NFT_OFFLOAD_DEP_UNSPEC,
-		},
-	};
+	struct nft_offload_ctx *ctx;
+
 	struct nft_flow_rule *flow;
 	int num_actions = 0, err;
 	struct nft_expr *expr;
 
+
 	expr = nft_expr_first(rule);
 	while (expr->ops && expr != nft_expr_last(rule)) {
 		if (expr->ops->offload_flags & NFT_OFFLOAD_F_ACTION)
@@ -52,21 +50,31 @@ struct nft_flow_rule *nft_flow_rule_create(const struct nft_rule *rule)
 		return ERR_PTR(-ENOMEM);
 
 	expr = nft_expr_first(rule);
+
+	ctx = kzalloc(sizeof(struct nft_offload_ctx), GFP_KERNEL);
+	if (!ctx) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+	ctx->dep.type = NFT_OFFLOAD_DEP_UNSPEC;
+
 	while (expr->ops && expr != nft_expr_last(rule)) {
 		if (!expr->ops->offload) {
 			err = -EOPNOTSUPP;
 			goto err_out;
 		}
-		err = expr->ops->offload(&ctx, flow, expr);
+		err = expr->ops->offload(ctx, flow, expr);
 		if (err < 0)
 			goto err_out;
 
 		expr = nft_expr_next(expr);
 	}
-	flow->proto = ctx.dep.l3num;
+	flow->proto = ctx->dep.l3num;
+	kfree(ctx);
 
 	return flow;
 err_out:
+	kfree(ctx);
 	nft_flow_rule_destroy(flow);
 
 	return ERR_PTR(err);
-- 
2.20.0

