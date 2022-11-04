Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3045061A0A9
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKDTOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKDTOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:14:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2EE4D5D6
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F9D1B82F66
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDBCC433D7;
        Fri,  4 Nov 2022 19:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589233;
        bh=lGUowKPCdleRRa1Z8ZxxHSDgl6l5BApGhJyHI8oZM3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9R1B/+1N1Us9/YbsPDVCqrCKQ77Py32XcqnKyn7u4+IXGW4VjXFRA4Q1/pOnpMcl
         yoyD1dkUZPnG4KFKBShu4r6oqNTx9cWZD8Ja0zD1R9dzvGTQllg9NvKGtHH4VDoMZV
         NEW882MxPEmdyiisVkr6+WI6OQd7TBZN2DC0WOoHBZ/o3bQfHE4O+9CQfGtOmwd8UD
         lREPoS7Lg3fMD/tHaKdbqmb1KUibuYL7ZtznJM0JsrnF+vGIxaSuxsMNN/vOI0rGPI
         DZv0e3K2pvaRDP+uFSDYNc+27zTEBqzfAnMUP37eyFEDvOIzglrMH85ekZD0WYwA56
         tqGyu2aiyzgow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 13/13] genetlink: convert control family to split ops
Date:   Fri,  4 Nov 2022 12:13:43 -0700
Message-Id: <20221104191343.690543-14-kuba@kernel.org>
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

Prove that the split ops work.
Sadly we need to keep bug-wards compatibility and specify
the same policy for dump as do, even tho we don't parse
inputs for the dump.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/netlink/genetlink.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 90b0feb5eb73..362a61179036 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1609,14 +1609,22 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
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
@@ -1625,6 +1633,7 @@ static const struct genl_ops genl_ctrl_ops[] = {
 		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 		.done		= ctrl_dumppolicy_done,
+		.flags		= GENL_CMD_CAP_DUMP,
 	},
 };
 
@@ -1634,8 +1643,8 @@ static const struct genl_multicast_group genl_ctrl_groups[] = {
 
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
2.38.1

