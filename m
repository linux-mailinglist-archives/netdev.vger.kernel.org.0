Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42EB61A0A0
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiKDTNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:13:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiKDTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C883C4AF18
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C65AB82F64
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD822C433C1;
        Fri,  4 Nov 2022 19:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589229;
        bh=ac8f5N/2o1twO4/7bO4DSlb3uliAW6VmZKZZUqwFWho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ndiUuaBauJESnBfF4FZkWtuWpe4sP1SgSe3TjZnCdSObSs/R72Aw776CMG4oP3mOy
         kWY1pZejHDya9loOKuDA3ZFgZAhdPmj3IKq9PWx38LzhJKkgVADDymNPUDsWAfWtuC
         8d4+dtu7gLmgf5Jx+pT3QOLw3YM/BrpvaSng+9NCO6zc1th+KGsbtmlPev2NvE3ef0
         EKDq4UzuN2d27elrgxOxMmBobCMEODurG3bOGWQFFU2BcXKO+mNKV1hfNoo0WNGtqi
         FxsjMrOatN1AoEXIIQn0bxT7Rbw0g0HhDNf1SINgOKY/sPKbZ2R2WrO+73I6zCkdzn
         o9OHgDCA94pVQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 04/13] genetlink: load policy based on validation flags
Date:   Fri,  4 Nov 2022 12:13:34 -0700
Message-Id: <20221104191343.690543-5-kuba@kernel.org>
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

Set the policy and maxattr pointers based on validation flags.
genl_family_rcv_msg_attrs_parse() will do nothing and return NULL
if maxattrs is zero, so no behavior change is expected.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
v2: improve commit msg
---
 net/netlink/genetlink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index c66299740c05..770726ac491e 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -204,8 +204,14 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 		op->post_doit	= family->post_doit;
 	}
 
-	op->policy		= full->policy;
-	op->maxattr		= full->maxattr;
+	if (flags & GENL_CMD_CAP_DUMP &&
+	    full->validate & GENL_DONT_VALIDATE_DUMP) {
+		op->policy	= NULL;
+		op->maxattr	= 0;
+	} else {
+		op->policy	= full->policy;
+		op->maxattr	= full->maxattr;
+	}
 
 	op->cmd			= full->cmd;
 	op->internal_flags	= full->internal_flags;
@@ -638,10 +644,8 @@ static int genl_start(struct netlink_callback *cb)
 	int rc = 0;
 
 	ops = ctx->ops;
-	if (ops->validate & GENL_DONT_VALIDATE_DUMP)
-		goto no_attrs;
-
-	if (ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
+	if (!(ops->validate & GENL_DONT_VALIDATE_DUMP) &&
+	    ctx->nlh->nlmsg_len < nlmsg_msg_size(ctx->hdrlen))
 		return -EINVAL;
 
 	attrs = genl_family_rcv_msg_attrs_parse(ctx->family, ctx->nlh, ctx->extack,
@@ -650,7 +654,6 @@ static int genl_start(struct netlink_callback *cb)
 	if (IS_ERR(attrs))
 		return PTR_ERR(attrs);
 
-no_attrs:
 	info = genl_dumpit_info_alloc();
 	if (!info) {
 		genl_family_rcv_msg_attrs_free(attrs);
-- 
2.38.1

