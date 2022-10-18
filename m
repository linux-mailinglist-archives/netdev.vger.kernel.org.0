Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6EE60366E
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbiJRXHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiJRXHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F88EBD056
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83608B8207D
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20CEC43141;
        Tue, 18 Oct 2022 23:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134460;
        bh=rVsZCfKTzriIPgjvgfJ9dblAuHU9IQCmyXb/aa0JXJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQGl8UNryBMdGmowqOnjsZmxrq2Qv4+gNvhlSxtO3rRtfgDugXG0MZe+7MLyNqwDc
         13m6UuV8oquwitkLzeShMEAJCMwhvFw+QayT2CRgtIZ7V65fOuReIHdAwu7XJywDlS
         34r3rWeo07KJfas0oxkFE9Mjuk4zITik0uJ18xbHk5l1d9Yk6sbozvHuh8tbfZgext
         GLMmn/EdyESpHaMe9+oyAkv5haVgzGo7qdoU7HREAseYGvPwCXPYm4ngkuFWbL9C2D
         pc1gM+VPPml9Kr4NYI6KyCmRL65RW+ky257jPXRLIq9szoa/awY1KDg/CITrYFqdxJ
         SLqmd8kTkc94Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 10/13] genetlink: use iterator in the op to policy map dumping
Date:   Tue, 18 Oct 2022 16:07:25 -0700
Message-Id: <20221018230728.1039524-11-kuba@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018230728.1039524-1-kuba@kernel.org>
References: <20221018230728.1039524-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can't put the full iterator in the struct ctrl_dump_policy_ctx
because dump context is statically sized by netlink core.
Allocate it dynamically.

Rename policy to dump_map to make the logic a little easier to follow.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 48 ++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index c5fcb7b9c383..63807204805a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1225,10 +1225,10 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
 struct ctrl_dump_policy_ctx {
 	struct netlink_policy_dump_state *state;
 	const struct genl_family *rt;
-	unsigned int opidx;
+	struct genl_op_iter *op_iter;
 	u32 op;
 	u16 fam_id;
-	u8 policies:1,
+	u8 dump_map:1,
 	   single_op:1;
 };
 
@@ -1298,9 +1298,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 
 		if (!ctx->state)
 			return -ENODATA;
+
+		ctx->dump_map = 1;
 		return 0;
 	}
 
+	ctx->op_iter = kmalloc(sizeof(*ctx->op_iter), GFP_KERNEL);
+	if (!ctx->op_iter)
+		return -ENOMEM;
+	ctx->dump_map = genl_op_iter_init(rt, ctx->op_iter);
+
 	for (genl_op_iter_init(rt, &i); genl_op_iter_next(&i); ) {
 		if (i.doit.policy) {
 			err = netlink_policy_dump_add_policy(&ctx->state,
@@ -1318,12 +1325,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		}
 	}
 
-	if (!ctx->state)
-		return -ENODATA;
+	if (!ctx->state) {
+		err = -ENODATA;
+		goto err_free_op_iter;
+	}
 	return 0;
 
 err_free_state:
 	netlink_policy_dump_free(ctx->state);
+err_free_op_iter:
+	kfree(ctx->op_iter);
 	return err;
 }
 
@@ -1403,11 +1414,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	void *hdr;
 
-	if (!ctx->policies) {
-		struct genl_split_ops doit, dumpit;
-		struct genl_ops op;
-
+	if (ctx->dump_map) {
 		if (ctx->single_op) {
+			struct genl_split_ops doit, dumpit;
+
 			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
 					 ctx->rt, &doit) &&
 			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
@@ -1419,25 +1429,18 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
 				return skb->len;
 
-			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
+			/* done with the per-op policy index list */
+			ctx->dump_map = 0;
 		}
 
-		while (ctx->opidx < genl_get_cmd_cnt(ctx->rt)) {
-			genl_get_cmd_by_index(ctx->opidx, ctx->rt, &op);
-
-			genl_cmd_full_to_split(&doit, ctx->rt,
-					       &op, GENL_CMD_CAP_DO);
-			genl_cmd_full_to_split(&dumpit, ctx->rt,
-					       &op, GENL_CMD_CAP_DUMP);
-
-			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
+		while (ctx->dump_map) {
+			if (ctrl_dumppolicy_put_op(skb, cb,
+						   &ctx->op_iter->doit,
+						   &ctx->op_iter->dumpit))
 				return skb->len;
 
-			ctx->opidx++;
+			ctx->dump_map = genl_op_iter_next(ctx->op_iter);
 		}
-
-		/* completed with the per-op policy index list */
-		ctx->policies = true;
 	}
 
 	while (netlink_policy_dump_loop(ctx->state)) {
@@ -1470,6 +1473,7 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 
+	kfree(ctx->op_iter);
 	netlink_policy_dump_free(ctx->state);
 	return 0;
 }
-- 
2.37.3

