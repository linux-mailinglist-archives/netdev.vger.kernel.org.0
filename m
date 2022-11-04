Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88A61A0A5
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiKDTOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKDTNx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D971D4AF31
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F4ADB82F65
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6290C43470;
        Fri,  4 Nov 2022 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589230;
        bh=Ot+USnzCw/8n69AvPboQgNTW+kvdksyzFglmKHCqATg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjvtH5wX+cjRumQ7x0k8vmzxo9NvRsbL2JPuuTOKPi2CFAKyzLYtUnIloIkJd7egc
         JQeC+GDBaVALC8D1ZhSXYfqeNMaFUJfzXhZ4NyfLSy02K5wLB08B+n5xZzQwAwyzuo
         cXzDIs9yjQhMkZfsg036TZ+r4fi2iLddisk4cROezadxkq1ifoWJ9cuxuT3rbgRwLn
         y3qPJ+078l4oAlat8E3hHB/BNyDs8f5C5mUDpfBn3/lZa+S455qQzudLB6gVLcng7j
         bFJZlU0Ldm7v2KsCfl7ELThTmrQJo0vBnj/7TdnORvm/tESiRu3VVqVfEcodscbRkl
         gR7k5UrZCu0FA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 06/13] genetlink: add policies for both doit and dumpit in ctrl_dumppolicy_start()
Date:   Fri,  4 Nov 2022 12:13:36 -0700
Message-Id: <20221104191343.690543-7-kuba@kernel.org>
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

Separate adding doit and dumpit policies for CTRL_CMD_GETPOLICY.
This has no effect until we actually allow do and dump to come
from different sources as netlink_policy_dump_add_policy()
does deduplication.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/netlink/genetlink.c | 48 ++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 10 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 7c04df1bee2b..d0c35738839b 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1260,29 +1260,57 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
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
2.38.1

