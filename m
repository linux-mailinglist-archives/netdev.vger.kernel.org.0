Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E632616FDD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbiKBVeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiKBVdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:33:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581485FC4
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:33:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0995261C3D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D632C433C1;
        Wed,  2 Nov 2022 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667424829;
        bh=ayB4ERSIPd2fDk5/rsqYqi9EITGM9gJAScDbjIYK3HQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxjjRqlsBA5gtnPxu4OLssxJe6ZvMbYw1zLDA94doVkFeYw67LlIuZEizexoO0QPO
         MnLiDOzDYS9vhup85Igfboix8fowrPR31ysV66ilG/nJ3+EW85VQNeLZMV6q96z/ws
         VV+WWjBbmJsnU0qHvUEq48UiVsrtiGYARf2tiHzznsnluUpl7gL599TkRI6mFCatwG
         4RZ3plyuetBH1w7q6lm2O0Pdek4ibmN4I7p3w/8JBRxKezQQe2w1lUDu3JJmEFPejZ
         l/de2/q7gosEsWkVz5KlYdqqTP4MIOHp2GRGJopheNB1mcGAvscl0Ls1lyMD/5O0mp
         kO8Ebq0nOmmHA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 07/13] genetlink: support split policies in ctrl_dumppolicy_put_op()
Date:   Wed,  2 Nov 2022 14:33:32 -0700
Message-Id: <20221102213338.194672-8-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102213338.194672-1-kuba@kernel.org>
References: <20221102213338.194672-1-kuba@kernel.org>
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

