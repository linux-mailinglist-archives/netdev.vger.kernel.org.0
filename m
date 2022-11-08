Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EC0621DCB
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 21:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiKHUk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 15:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKHUk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 15:40:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB4765856
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 12:40:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5226FCE1C6D
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 20:40:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF57C433D6;
        Tue,  8 Nov 2022 20:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667940053;
        bh=V0CMBcRFFzEtzCqQq2CXIVJn9z3gFZu9yIHXCIhN8Qs=;
        h=From:To:Cc:Subject:Date:From;
        b=LPnF8KhmTacTts4ETDcY9Py5/8fkY6c9gEPAo84xH/SsKiC8hIfDpeVmyFhzKHoeZ
         wHDe683V0IGfhZN3lrqCUWgosHK6Ep8CP8Z5iqRWNQ8JH6lnAQpr+TJQqkuw051HqD
         IQ9odQXa3niUSUzgCd2E1sRMUjZFl6KIMtWkwteWOLmMTmvss6vNQBU85rYwEc1Tsr
         jd2lCSQcz1FgAWCcaxZCgb+QgeSgFdU+HZ82My1p6e0o1AtPA1W2Wt0NCM8uQA074c
         Ym4XEUEQck0/Jb3cezZ3/XG0j8EQ4J1VYa4oJxUsMkzbtnzQY+vcad4BSwwhUEzMy9
         BJnlp9io4NwDA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <bsd@meta.com>, jacob.e.keller@intel.com
Subject: [PATCH net-next] genetlink: fix policy dump for dumps
Date:   Tue,  8 Nov 2022 12:40:41 -0800
Message-Id: <20221108204041.330172-1-kuba@kernel.org>
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
---
 net/netlink/genetlink.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 9b7dfc45dd67..7b7bac9e7524 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1406,8 +1406,8 @@ static int ctrl_dumppolicy_start(struct netlink_callback *cb)
 		ctx->single_op = true;
 		ctx->op = nla_get_u32(tb[CTRL_ATTR_OP]);
 
-		if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) &&
-		    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump)) {
+		if (!!genl_get_cmd(ctx->op, GENL_CMD_CAP_DO, rt, &doit) +
+		    !!genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP, rt, &dump) < 1) {
 			NL_SET_BAD_ATTR(cb->extack, tb[CTRL_ATTR_OP]);
 			return -ENOENT;
 		}
@@ -1551,10 +1551,10 @@ static int ctrl_dumppolicy(struct sk_buff *skb, struct netlink_callback *cb)
 		if (ctx->single_op) {
 			struct genl_split_ops doit, dumpit;
 
-			if (genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
-					 ctx->rt, &doit) &&
-			    genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
-					 ctx->rt, &dumpit)) {
+			if (!!genl_get_cmd(ctx->op, GENL_CMD_CAP_DO,
+					   ctx->rt, &doit) +
+			    !!genl_get_cmd(ctx->op, GENL_CMD_CAP_DUMP,
+					   ctx->rt, &dumpit) < 1) {
 				WARN_ON(1);
 				return -ENOENT;
 			}
-- 
2.38.1

