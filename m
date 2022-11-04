Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5204961A0A8
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbiKDTOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:14:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiKDTN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDF64732F
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E0EAB82F63
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4541C43141;
        Fri,  4 Nov 2022 19:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589232;
        bh=bXm+gDAWWC90mSM2QWPalihwCEFv1kOvpEwU37tcvuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOXy3tbzOtBR38Q5pTeqb0aRgPJwPy/yZclE4prQ0Jyo8UYiOqhZnZFF2DcADtjpF
         ScCG9EKf1hMi5wEKWFglNftA89Slq9Y08h++6Z3hRoLFNB1bEobsnD91Tfyx/+L1Kp
         FpPiBTcezKAZiOd7/TTJE9BKrzdLi7m8KzUQMbwN0XfikYf9x47l7eJlXVEvyEnyay
         Ej6rZ07CIL3OJCmQ4di+UtAdlNwIq9FKhVHDUVKlx0ChrqUXpvrFeAiaVRkwSCAc5N
         kS9j8HtmC70kD0gcqCGSWmc7hAzUvEbQ2KmkAKpiGdiTPonxc5/6xSHx0+Rp17nV+x
         BHHMAtWIVjdeQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 10/13] genetlink: use iterator in the op to policy map dumping
Date:   Fri,  4 Nov 2022 12:13:40 -0700
Message-Id: <20221104191343.690543-11-kuba@kernel.org>
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

We can't put the full iterator in the struct ctrl_dump_policy_ctx
because dump context is statically sized by netlink core.
Allocate it dynamically.

Rename policy to dump_map to make the logic a little easier to follow.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/netlink/genetlink.c | 49 ++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 23 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 06bf091c1b8a..4b8c65d9e9d3 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1252,10 +1252,10 @@ static int genl_ctrl_event(int event, const struct genl_family *family,
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
 
@@ -1325,9 +1325,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 
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
@@ -1345,12 +1352,16 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
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
 
@@ -1430,11 +1441,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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
@@ -1446,26 +1456,18 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
 				return skb->len;
 
-			/* don't enter the loop below */
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
@@ -1498,6 +1500,7 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 
+	kfree(ctx->op_iter);
 	netlink_policy_dump_free(ctx->state);
 	return 0;
 }
-- 
2.38.1

