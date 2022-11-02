Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56302616FDA
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiKBVdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbiKBVdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:33:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7F5C4D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:33:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860CA61C52
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F32CC43140;
        Wed,  2 Nov 2022 21:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667424828;
        bh=RnYLYrm7KDQa3AHHQluXfHsYPXmnB1pwhK77MKOsiH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eoDtgU95c0MvIoHJx8rKKLCFLJyOcabZakcUAHuPoF/iahURu9EhVXkTLp4eG5sJG
         qV7gUPs2t3SxkLx1PMNaGkrWadCXefJRVOlm5ojStQDKN61uJ9R2xLONaEeiIgoo40
         oaQvkJi50WA7UcpQ0I85CTYGSXoTm4HK76iI1QtboKhJICX2u5ALI0szVIPviKAWbQ
         Z/GXGXkB/ddFEsNrymVRBF2DDuESuoHTnUVMSOcxtgoWgjGSZFI4B9n1xYWFVURPSx
         CLDFBhIMbyLe6D+FwaoilgUNghTZRoOO3KD4tVUdv3sHo1FUc2VNbIBLt9D7lqkokH
         qgs374bSDQyHQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 04/13] genetlink: load policy based on validation flags
Date:   Wed,  2 Nov 2022 14:33:29 -0700
Message-Id: <20221102213338.194672-5-kuba@kernel.org>
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

Set the policy and maxattr pointers based on validation flags.
genl_family_rcv_msg_attrs_parse() will do nothing and return NULL
if maxattrs is zero, so no behavior change is expected.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
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

