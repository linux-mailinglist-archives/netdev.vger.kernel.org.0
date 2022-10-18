Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F2C60366A
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiJRXHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229767AbiJRXHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6356E733DF
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FC21B8218A
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8BCC433C1;
        Tue, 18 Oct 2022 23:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134458;
        bh=FoR/o6mvrW9NkbxKfjC37D9DKoklhyL2lHPWIyH9slk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HHkNArovfnIur4GpQc6uUcRWDBQgIRxR+NIGlfNH/SRoPjBRwFAsNuaer/eMAaxyx
         fU09IFW5cq1utoEI0V1OsZGH4IA/aEL0Lhfi2dIYo5ka0zRYjzzXKocrLewqe4LJqM
         8HQ+HKKYwNNwsQFKxqmJ3KizOXIJHlxqCA5BpQVi9ZKIWsSCGYisEEbVjIXjx1m/Lj
         3eEP8dnlLV214XnUH7yeKfbJaYE8kaH/8iBp5UQrCtu43AeGSMBj2u4Q8LTXxE7hEb
         VTKNesaKrg4NR3jpObvUbhtZZ7EGXEvhDdiBMH1fix39OYDRO7ILKEn5kDxf0xikQL
         NYu944mSu6oDg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 07/13] genetlink: support split policies in ctrl_dumppolicy_put_op()
Date:   Tue, 18 Oct 2022 16:07:22 -0700
Message-Id: <20221018230728.1039524-8-kuba@kernel.org>
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

Pass do and dump versions of the op to ctrl_dumppolicy_put_op()
so that it can provide a different policy index for the two.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 55 ++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 234b27977013..3e821c346577 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1319,7 +1319,8 @@ static void *ctrl_dumppolicy_prep(struct sk_buff *skb,
 
 static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 				  struct netlink_callback *cb,
-			          struct genl_ops *op)
+			          struct genl_split_ops *doit,
+				  struct genl_split_ops *dumpit)
 {
 	struct ctrl_dump_policy_ctx *ctx = (void *)cb->ctx;
 	struct nlattr *nest_pol, *nest_op;
@@ -1327,10 +1328,7 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
 	int idx;
 
 	/* skip if we have nothing to show */
-	if (!op->policy)
-		return 0;
-	if (!op->doit &&
-	    (!op->dumpit || op->validate & GENL_DONT_VALIDATE_DUMP))
+	if (!doit->policy && !dumpit->policy)
 		return 0;
 
 	hdr = ctrl_dumppolicy_prep(skb, cb);
@@ -1341,21 +1339,26 @@ static int ctrl_dumppolicy_put_op(struct sk_buff *skb,
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
@@ -1373,16 +1376,19 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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
 
 			ctx->opidx = genl_get_cmd_cnt(ctx->rt);
@@ -1391,7 +1397,12 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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
2.37.3

