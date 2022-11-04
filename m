Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF7861A0A1
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKDTN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbiKDTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392AA4C24E
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C811D62314
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DAFC433D6;
        Fri,  4 Nov 2022 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589231;
        bh=zRnVgGNUkGhmWpE7mtiGfMH9+PP3ODq9FHhzSoxbl7E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kH0XwTlWwlS6B1D+XB3RZjj7+9zvEg14TqPpOZwaYNG0wdHfZRyJgBBzck+uxSagG
         2/gCxGvV6hYBbor0nNrtV5v+Gpqv61diGXdfKevWLHt5Z08lLezV+bqXfZ9FA12lzM
         d3XV/VcXl0lM2YTTvYcJ2KUPL4H2daNyFuo6wyHB/7THDuNo88/f8U81P4n0sgHin/
         OrHgh4fBkIjP7PJsqPSjup73Db8YIcWq0dVNRDSavCBu7mnqWkJVLrCZIiCW8CCGPl
         sussVErJ5EvXkaZaaZ2iCmxPT33Ohu0XoaLq8LvXBYYo/xtj9YlLX1ABjQNIPzbgRz
         CD7nDtYOcM17Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 08/13] genetlink: inline genl_get_cmd()
Date:   Fri,  4 Nov 2022 12:13:38 -0700
Message-Id: <20221104191343.690543-9-kuba@kernel.org>
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

All callers go via genl_get_cmd_split() now, so rename it
to genl_get_cmd() remove the original.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 93e33e20a0e8..ec32b6063a3f 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -181,14 +181,6 @@ static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
 	return -ENOENT;
 }
 
-static int genl_get_cmd(u32 cmd, const struct genl_family *family,
-			struct genl_ops *op)
-{
-	if (!genl_get_cmd_full(cmd, family, op))
-		return 0;
-	return genl_get_cmd_small(cmd, family, op);
-}
-
 static int
 genl_cmd_full_to_split(struct genl_split_ops *op,
 		       const struct genl_family *family,
@@ -231,13 +223,15 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 }
 
 static int
-genl_get_cmd_split(u32 cmd, u8 flags, const struct genl_family *family,
-		   struct genl_split_ops *op)
+genl_get_cmd(u32 cmd, u8 flags, const struct genl_family *family,
+	     struct genl_split_ops *op)
 {
 	struct genl_ops full;
 	int err;
 
-	err = genl_get_cmd(cmd, family, &full);
+	err = genl_get_cmd_full(cmd, family, &full);
+	if (err == -ENOENT)
+		err = genl_get_cmd_small(cmd, family, &full);
 	if (err) {
 		memset(op, 0, sizeof(*op));
 		return err;
@@ -867,7 +861,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 
 	flags = (nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP ?
 		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;
-	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
+	if (genl_get_cmd(hdr->cmd, flags, family, &op))
 		return -EOPNOTSUPP;
 
 	if ((op.flags & GENL_ADMIN_PERM) &&
@@ -1265,8 +1259,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		ctx->single_op = true;
 		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
 
-		if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
-		    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
+		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
+		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
 			return -ENOENT;
 		}
@@ -1406,10 +1400,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		struct genl_ops op;
 
 		if (ctx->single_op) {
-			if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO,
-					       ctx->rt, &doit) &&
-			    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP,
-					       ctx->rt, &dumpit)) {
+			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
+					 ctx->rt, &doit) &&
+			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
+					 ctx->rt, &dumpit)) {
 				WARN_ON(1);
 				return -ENOENT;
 			}
-- 
2.38.1

