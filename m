Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940BA616FE2
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiKBVeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiKBVd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389D9EE17
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:33:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAAC161C63
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B460C4347C;
        Wed,  2 Nov 2022 21:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667424832;
        bh=lHkOwTt5zrKyn8u6Ecefu+kmZmT9Esf3m287vU0KqzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hT5z6te3tJyOMe0nHs+cWCrbvBHSJ/RGBdoelQS0VW6Fcny6cqZOoEWkySSPN4H9k
         /5MofhXq2yA616Aw1PnGUjs6xUFeXX50Nna644UUQWkjm8kxAGnBzat/DvKHMIe9sW
         57rtzT58WM3wavg3+s+axIvBpnwjEfEgabtSRIxPgPuyhv8KwYDC+BS6FwTdRe3x6+
         m6JiYqhmurv6dxywouT9tEYJ3z57AMiliD2ZYJfxcgRpOkku9gH/EcFNbS8PKVdayD
         Xr1GLj0kH09PvMuIIbsRkZuTszwFcdLYCO3aaNf2trzYjBWNNYJqI0WFT/YYAuV6/i
         Cvl7ZZLUT5yrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 13/13] genetlink: convert control family to split ops
Date:   Wed,  2 Nov 2022 14:33:38 -0700
Message-Id: <20221102213338.194672-14-kuba@kernel.org>
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

Prove that the split ops work.
Sadly we need to keep bug-wards compatibility and specify
the same policy for dump as do, even tho we don't parse
inputs for the dump.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index e95b984fcfe6..1fb04496d94a 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -1597,14 +1597,22 @@ static int ctrl_dumppolicy_done(struct netlink_callback *cb)
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
@@ -1613,6 +1621,7 @@ static const struct genl_ops genl_ctrl_ops[] = {
 		.start		= ctrl_dumppolicy_start,
 		.dumpit		= ctrl_dumppolicy,
 		.done		= ctrl_dumppolicy_done,
+		.flags		= GENL_CMD_CAP_DUMP,
 	},
 };
 
@@ -1622,8 +1631,8 @@ static const struct genl_multicast_group genl_ctrl_groups[] = {
 
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

