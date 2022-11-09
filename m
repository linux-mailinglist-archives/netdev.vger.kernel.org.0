Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D324623277
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiKISc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiKISc5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:32:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 287C01A218
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6B8661C58
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7823C433D6;
        Wed,  9 Nov 2022 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668018776;
        bh=lZTwdkWwtZtwoFwuyb5f3bTvNg019YjjIQu8hyNT4oo=;
        h=From:To:Cc:Subject:Date:From;
        b=tVojZTHEhaKFpKAoty+KzIyLYVyTrEFelqTWN/ypA/o92jZ3BByoJrd3LXOjlK+Dr
         wgDvotQbKr5bPQ+igyMkHujgOPl9rWpuu7y8F7wT+yzS+Cpf7k92USDhfWb0t4AnbZ
         YPJCMoPaVCTnZgHvI/gd46FV7A8EdHzICZcBvBdZ6fBv2mZAMnZV3JVGIDfhUsoKOs
         sbrcjsuVjGIGfPWQGPTr/d4pRB3WW7NtVWr2MN/RYKr/2DRZ+Z7akSpoUvoqFgzj1n
         umduIzsOf/88Ak3NcpcLl5HQ/xZaZo6F9OBXpZF/aAXvZ9UudXOM65M2/q+6Av+bW1
         eLrqqqIvKPNBg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <bsd@meta.com>, jacob.e.keller@intel.com,
        leon@kernel.org
Subject: [PATCH net-next v2] genetlink: fix single op policy dump when do is present
Date:   Wed,  9 Nov 2022 10:32:54 -0800
Message-Id: <20221109183254.554051-1-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonathan reports crashes when running net-next in Meta's fleet.
Stats collection uses ethtool -I which does a per-op policy dump
to check if stats are supported. We don't initialize the dumpit
information if doit succeeds due to evaluation short-circuiting.

The crash may look like this:

   BUG: kernel NULL pointer dereference, address: 0000000000000cc0
   RIP: 0010:netlink_policy_dump_add_policy+0x174/0x2a0
     ctrl_dumppolicy_start+0x19f/0x2f0
     genl_start+0xe7/0x140

Or we may trigger a warning:

   WARNING: CPU: 1 PID: 785 at net/netlink/policy.c:87 netlink_policy_dump_get_policy_idx+0x79/0x80
   RIP: 0010:netlink_policy_dump_get_policy_idx+0x79/0x80
     ctrl_dumppolicy_put_op+0x214/0x360

depending on what garbage we pick up from the stack.

Reported-by: Jonathan Lemon <bsd@meta.com>
Fixes: 26588edbef60 ("genetlink: support split policies in ctrl_dumppolicy_put_op()")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jacob.e.keller@intel.com
CC: leon@kernel.org

v2:
 - add a helper instead of doing magic sums
 - improve title
v1: https://lore.kernel.org/all/20221108204041.330172-1-kuba@kernel.org/
---
 net/netlink/genetlink.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9b7dfc45dd67..600993c80050 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -282,6 +282,7 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 	return 0;
 }
 
+/* Must make sure that op is initialized to 0 on failure */
 static int
 genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
 	     struct genl_split_ops *op)
@@ -302,6 +303,21 @@ genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
 	return err;
 }
 
+/* For policy dumping only, get ops of both do and dump.
+ * Fail if both are missing, genl_get_cmd() will zero-init in case of failure.
+ */
+static int
+genl_get_cmd_both(u32 cmd, const struct genl_family *family,
+		  struct genl_split_ops *doit, struct genl_split_ops *dumpit)
+{
+	int err1, err2;
+
+	err1 = genl_get_cmd(cmd, GENL_CMD_CAP_DO, family, doit);
+	err2 = genl_get_cmd(cmd, GENL_CMD_CAP_DUMP, family, dumpit);
+
+	return err1 && err2 ? -ENOENT : 0;
+}
+
 static bool
 genl_op_iter_init(const struct genl_family *family, struct genl_op_iter *iter)
 {
@@ -1406,10 +1422,10 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		ctx->single_op = true;
 		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
 
-		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
-		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
+		err = genl_get_cmd_both(ctx->op, rt, &doit, &dump);
+		if (err) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
-			return -ENOENT;
+			return err;
 		}
 
 		if (doit.policy) {
@@ -1551,13 +1567,9 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (ctx->single_op) {
 			struct genl_split_ops doit, dumpit;
 
-			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
-					 ctx->rt, &doit) &&
-			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
-					 ctx->rt, &dumpit)) {
-				WARN_ON(1);
+			if (WARN_ON(genl_get_cmd_both(ctx->op, ctx->rt,
+						      &doit, &dumpit)))
 				return -ENOENT;
-			}
 
 			if (ctrl_dumppolicy_put_op(skb, cb, &doit, &dumpit))
 				return skb->len;
-- 
2.38.1

