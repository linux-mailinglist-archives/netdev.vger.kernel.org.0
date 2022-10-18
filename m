Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAEE603670
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJRXID (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJRXHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9BCD73D2
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85ADEB8218D
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD550C43470;
        Tue, 18 Oct 2022 23:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134462;
        bh=fBhYxGfpbGrsrV7SB//6gAP9eMXvKVDK2A8FSOj23vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jjfwWjAW8pnQgN2pwgOtAJU1kWiDWB9N//E+xKxpZPwXg3tWfiVbstH29RcBjyfTy
         0GtQjXGdvKEqsnMZ5BS4LK9jJ2qgCe4Re7m01SO4/QASevSBwmL6z/oBBn9a+0bnf7
         5i1xFOVBb6QI8VRBs6yO9qYNC5lcUi6z6cKQFIi+wran8+Fk48TtRH2txDKGuMIw8z
         d061qjVDewyJYwMLRrYXnJhDnDBeeZGOf8DB+6blX/Mh04KVHfuVBKAQJju8zmhp1Z
         ZOCjGw+repBXfx/sQb8LeMqZOi6JHnPpW3UG7Ggh0SZb+iWamZAC0e0JyeVy16cyZB
         x55dnJLKzcMEA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 13/13] genetlink: convert control family to split ops
Date:   Tue, 18 Oct 2022 16:07:28 -0700
Message-Id: <20221018230728.1039524-14-kuba@kernel.org>
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

Prove that the split ops work.
Sadly we need to keep bug-wards compatibility and specify
the same policy for dump as do, even tho we don't parse
inputs for the dump.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 53cc5cfcdc57..05b5e22561f2 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1570,14 +1570,22 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
 	return 0;
 }
 
-static const struct genl_ops genl_ctrl_ops[] = {
+static const struct genl_split_ops genl_ctrl_ops[] = {
 	{
 		.cmd		= CTRL_CMD_GETFAMILY,
-		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
+		.validate	= GENL_DONT_VALIDATE_STRICT,
 		.policy		= ctrl_policy_family,
 		.maxattr	= ARRAY_SIZE(ctrl_policy_family) - 1,
 		.doit		= ctrl_getfamily,
+		.flags		= GENL_CMD_CAP_DO,
+	},
+	{
+		.cmd		= CTRL_CMD_GETFAMILY,
+		.validate	= GENL_DONT_VALIDATE_DUMP,
+		.policy		= ctrl_policy_family,
+		.maxattr	= ARRAY_SIZE(ctrl_policy_family) - 1,
 		.dumpit		= ctrl_dumpfamily,
+		.flags		= GENL_CMD_CAP_DUMP,
 	},
 	{
 		.cmd		= CTRL_CMD_GETPOLICY,
@@ -1586,6 +1594,7 @@ static const struct genl_ops genl_ctrl_ops[] = {
 		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 		.done		= ctrl_dumppolicy_done,
+		.flags		= GENL_CMD_CAP_DUMP,
 	},
 };
 
@@ -1595,8 +1604,8 @@ static const struct genl_multicast_group genl_ctrl_groups[] = {
 
 static struct genl_family genl_ctrl __ro_after_init = {
 	.module = THIS_MODULE,
-	.ops = genl_ctrl_ops,
-	.n_ops = ARRAY_SIZE(genl_ctrl_ops),
+	.split_ops = genl_ctrl_ops,
+	.n_split_ops = ARRAY_SIZE(genl_ctrl_ops),
 	.resv_start_op = CTRL_CMD_GETPOLICY + 1,
 	.mcgrps = genl_ctrl_groups,
 	.n_mcgrps = ARRAY_SIZE(genl_ctrl_groups),
-- 
2.37.3

