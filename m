Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E803E60366C
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbiJRXHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbiJRXHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F95422E0
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F75CB8218C
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C029C433B5;
        Tue, 18 Oct 2022 23:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134458;
        bh=pBiaUJm/flonCnzd7Gc9QEi0G5lUAkIUCOTcyaa+uaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIaOLiFtUtws1j1jDCJquTjKTpg5D0fPnvKrRK9T/OKAKNFx9nOgOv1EX7qUwqyBN
         CuzldeouaHS0JU7RJ+t4gQf8jP2zFf1Jt7VmQb8bWuZaJj2MUOgSBzCfSR04UkvQbZ
         IeM0bjZJlFc3MHaEDUmRnSOeSuIuzjje2/MJDB7tMK+EubEaKJlix1KOlp2g89t9WS
         azZHmiXn/vrp8uerggB5RnPaV+LN3HSJz9E4fEZN8rxosnVixrZ94c5uD191omykpm
         xV/YoL31C2Lc8Vut32np7x7/DA/PnhCYloo1aX5kvgy+sMg4K701v7dJFT4poopY1w
         SkV/ai5xhLAbg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 08/13] genetlink: inline genl_get_cmd()
Date:   Tue, 18 Oct 2022 16:07:23 -0700
Message-Id: <20221018230728.1039524-9-kuba@kernel.org>
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

All callers go via genl_get_cmd_split() now,
so merge genl_get_cmd() into it.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 3e821c346577..9bfb110053c7 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -158,14 +158,6 @@ static int genl_get_cmd_small(u32 cmd, const struct genl_family *family,
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
@@ -207,13 +199,15 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
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
@@ -841,7 +835,7 @@ static int genl_family_rcv_msg(const struct genl_family *family,
 
 	flags = (nlh->nlmsg_flags & NLM_F_DUMP) == NLM_F_DUMP ?
 		GENL_CMD_CAP_DUMP : GENL_CMD_CAP_DO;
-	if (genl_get_cmd_split(hdr->cmd, flags, family, &op))
+	if (genl_get_cmd(hdr->cmd, flags, family, &op))
 		return -EOPNOTSUPP;
 
 	if ((op.flags & GENL_ADMIN_PERM) &&
@@ -1239,8 +1233,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		ctx->single_op = true;
 		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
 
-		if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
-		    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
+		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
+		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
 			return -ENOENT;
 		}
@@ -1380,10 +1374,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
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
2.37.3

