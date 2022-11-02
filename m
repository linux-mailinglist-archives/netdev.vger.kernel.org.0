Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25EF616FE1
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:34:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbiKBVeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiKBVd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:33:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D337BE0ED
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 507F3B82521
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9957FC433B5;
        Wed,  2 Nov 2022 21:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667424830;
        bh=b97UM+4uCPhhT9AVJsuxZqAl4Oep+NuC4DttYIspfI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oK+ov3N2545jE/Bu2bpY9OfkguZP3HFsSSIuUlmvivLbVEEf1hxrTeeBJ1hXsJMUs
         FS6cAOkjlV79wgOSBMDO3/nwXAYtmkvdx6G5+0qygnQEsAx/+ODvbC/nK7T8Vk6RKg
         1MXyauB7lJnA6rjTYv1yNCiFq80B24UU+kkV6DH1yxNEW6fL6IKV9gyKaoXbUkZly7
         BjtXRQzUds9iIPd+f9us1uJ4oK7ZlkKaQ2ug4iM8D9uCedqJzhtPCYfVWdfnoN+FDi
         M4qRc3KSEFaKFG6aS0crXjbqgFIpHBHCKHVJT+eTEp0oXgx3e3FsjK/spKeHwgkPTo
         LPcIC0SQ8qRhQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 08/13] genetlink: inline genl_get_cmd()
Date:   Wed,  2 Nov 2022 14:33:33 -0700
Message-Id: <20221102213338.194672-9-kuba@kernel.org>
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

All callers go via genl_get_cmd_split() now,
so merge genl_get_cmd() into it.

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

