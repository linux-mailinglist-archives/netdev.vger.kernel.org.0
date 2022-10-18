Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3066603667
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiJRXHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJRXHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92899387
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E036CB8218E
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154DBC43143;
        Tue, 18 Oct 2022 23:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134457;
        bh=1H/5oZ+1fAeAQEFKn4UYw0mW0eY2Rtz7yI+nwtKb0G8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJkOr+3zSDeujuRsKv34aVHld4Gg+oJ0S6Hu/J4MDTY2nnQM4bvrzpKFc8oRxlNrK
         +OMfaIJDSLDQcYLSDLJRJoeSj0li2ktf+rR4sZ5HyrD+EQU6TsCS3tzdHeVgJTNWUO
         mQ1rH4p6mcHtCEkXhrNJ/ARFNPutuOn7fWTHfRks7gH0pbsaq2iu7Ui2QersqfXzm3
         uip1ABI8M96RXo1pw8qrSNbIcQqSYhHraGnDpXnyM435BsPGVftKuZ4L/ZboqE/W2V
         mXgGCl0rkLWnsP7BmwNkCZooJiy+DrkCp1G0ZZSuz20Wrqa5nZn5mG3fiFmUIXE5N0
         /PrZBNPkKrtzw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 06/13] genetlink: add policies for both doit and dumpit in ctrl_dumppolicy_start()
Date:   Tue, 18 Oct 2022 16:07:21 -0700
Message-Id: <20221018230728.1039524-7-kuba@kernel.org>
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

Separate adding doit and dumpit policies for CTRL_CMD_GETPOLICY.
This has no effect until we actually allow do and dump to come
from different sources as netlink_policy_dump_add_policy()
does deduplication.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 48 ++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9dfb3cf89b97..234b27977013 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1234,29 +1234,57 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 	ctx->rt = rt;
 
 	if (tb[CTRL_ATTR_OP]) {
+		struct genl_split_ops doit, dump;
+
 		ctx->single_op = true;
 		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
 
-		err = genl_get_cmd(ctx->op, rt, &op);
-		if (err) {
+		if (genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
+		    genl_get_cmd_split(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
-			return err;
+			return -ENOENT;
 		}
 
-		if (!op.policy)
-			return -ENODATA;
+		if (doit.policy) {
+			err = netlink_policy_dump_add_policy(&ctx->state,
+							     doit.policy,
+							     doit.maxattr);
+			if (err)
+				goto err_free_state;
+		}
+		if (dump.policy) {
+			err = netlink_policy_dump_add_policy(&ctx->state,
+							     dump.policy,
+							     dump.maxattr);
+			if (err)
+				goto err_free_state;
+		}
 
-		return netlink_policy_dump_add_policy(&ctx->state, op.policy,
-						      op.maxattr);
+		if (!ctx->state)
+			return -ENODATA;
+		return 0;
 	}
 
 	for (i = 0; i < genl_get_cmd_cnt(rt); i++) {
+		struct genl_split_ops doit, dumpit;
+
 		genl_get_cmd_by_index(i, rt, &op);
 
-		if (op.policy) {
+		genl_cmd_full_to_split(&doit, ctx->rt, &op, GENL_CMD_CAP_DO);
+		genl_cmd_full_to_split(&dumpit, ctx->rt,
+				       &op, GENL_CMD_CAP_DUMP);
+
+		if (doit.policy) {
+			err = netlink_policy_dump_add_policy(&ctx->state,
+							     doit.policy,
+							     doit.maxattr);
+			if (err)
+				goto err_free_state;
+		}
+		if (dumpit.policy) {
 			err = netlink_policy_dump_add_policy(&ctx->state,
-							     op.policy,
-							     op.maxattr);
+							     dumpit.policy,
+							     dumpit.maxattr);
 			if (err)
 				goto err_free_state;
 		}
-- 
2.37.3

