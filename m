Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7A461A0A4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiKDTOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKDTNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0654C262
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0DE3AB82CD4
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53323C433D7;
        Fri,  4 Nov 2022 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589230;
        bh=ayB4ERSIPd2fDk5/rsqYqi9EITGM9gJAScDbjIYK3HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bCwl6xx3Js4pmIMaIBMmhitj5RdA27ESP3ky3xOqUByX/cxbcsdPKe5M4jv9i9JBB
         5Kjt/mNudQf2IsfDtrri9DYQ3KSUAovIKv2m5pQrdRJ7f8iFdGWEoNYZnH0HujXlAe
         Xdg7+hvIR+scKIWfqi6GlhfbGEGdPXNgKouV8D1O1iqkE+yrJ4mWYP3+zLfmxkTasI
         d9TFtM+kkR7z97uXu2Mbl0isT+nAeu7bf0FCErX0yunnC1gbKEcIyLDpX9lcWJytoJ
         uH3WwXQVTXjDB7geM1j5bRVksDwLqUFxg1dg2JSRlpppQ9q6yU7czNNjROjqRg3nRl
         Wvz/QI1PPj5ug==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 07/13] genetlink: support split policies in ctrl_dumppolicy_put_op()
Date:   Fri,  4 Nov 2022 12:13:37 -0700
Message-Id: <20221104191343.690543-8-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104191343.690543-1-kuba@kernel.org>
References: <20221104191343.690543-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass do and dump versions of the op to ctrl_dumppolicy_put_op()
so that it can provide a different policy index for the two.

Since we now look at policies, and those are set appropriately
there's no need to look at the GENL_DONT_VALIDATE_DUMP flag.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v2: while at it fix the whitespace to appease checkpatch
---
 net/netlink/genetlink.c | 55 ++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index d0c35738839b..93e33e20a0e8 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1345,7 +1345,8 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 
 static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 				  struct netlink_callback *cb,
-			          struct genl_ops *op)
+				  struct genl_split_ops *doit,
+				  struct genl_split_ops *dumpit)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	struct nlattr *nest_pol, *nest_op;
@@ -1353,10 +1354,7 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 	int idx;
 
 	/* skip if we have nothing to show */
-	if (!op->policy)
-		return 0;
-	if (!op->doit &&
-	    (!op->dumpit || op->validate & GENL_DONT_VALIDATE_DUMP))
+	if (!doit->policy && !dumpit->policy)
 		return 0;
 
 	hdr = ctrl_dumppolicy_prep(skb, cb);
@@ -1367,21 +1365,26 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 	if (!nest_pol)
 		goto err;
 
-	nest_op = nla_nest_start(skb, op->cmd);
+	nest_op = nla_nest_start(skb, doit->cmd);
 	if (!nest_op)
 		goto err;
 
-	/* for now both do/dump are always the same */
-	idx = netlink_policy_dump_get_policy_idx(ctx->state,
-						 op->policy,
-						 op->maxattr);
+	if (doit->policy) {
+		idx = netlink_policy_dump_get_policy_idx(ctx->state,
+							 doit->policy,
+							 doit->maxattr);
 
-	if (op->doit && nla_put_u32(skb, CTRL_ATTR_POLICY_DO, idx))
-		goto err;
+		if (nla_put_u32(skb, CTRL_ATTR_POLICY_DO, idx))
+			goto err;
+	}
+	if (dumpit->policy) {
+		idx = netlink_policy_dump_get_policy_idx(ctx->state,
+							 dumpit->policy,
+							 dumpit->maxattr);
 
-	if (op->dumpit && !(op->validate & GENL_DONT_VALIDATE_DUMP) &&
-	    nla_put_u32(skb, CTRL_ATTR_POLICY_DUMP, idx))
-		goto err;
+		if (nla_put_u32(skb, CTRL_ATTR_POLICY_DUMP, idx))
+			goto err;
+	}
 
 	nla_nest_end(skb, nest_op);
 	nla_nest_end(skb, nest_pol);
@@ -1399,16 +1402,19 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	void *hdr;
 
 	if (!ctx->policies) {
+		struct genl_split_ops doit, dumpit;
 		struct genl_ops op;
 
 		if (ctx->single_op) {
-			int err;
-
-			err = genl_get_cmd(ctx->op, ctx->rt, &op);
-			if (WARN_ON(err))
-				return err;
+			if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO,
+					       ctx->rt, &doit) &&
+			    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP,
+					       ctx->rt, &dumpit)) {
+				WARN_ON(1);
+				return -ENOENT;
+			}
 
-			if (ctrl_dumppolicy_put_op(skb, cb, &op))
+			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
 				return skb->len;
 
 			/* don't enter the loop below */
@@ -1418,7 +1424,12 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
 			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
 
-			if (ctrl_dumppolicy_put_op(skb, cb, &op))
+			genl_cmd_full_to_split(&doit, ctx->rt,
+					       &op, GENL_CMD_CAP_DO);
+			genl_cmd_full_to_split(&dumpit, ctx->rt,
+					       &op, GENL_CMD_CAP_DUMP);
+
+			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
 				return skb->len;
 
 			ctx->opidx++;
-- 
2.38.1

