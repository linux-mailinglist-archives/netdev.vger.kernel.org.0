Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1652761A09E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 20:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbiKDTNy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 15:13:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiKDTNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 15:13:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF754AF23
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 12:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0A6DB82F63
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4577AC43141;
        Fri,  4 Nov 2022 19:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667589229;
        bh=sdaYGWsbV49j7YSP0I7vPI2V8O79GZlnLbcjhZhHuRs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiCr8tC8lR/xA+7/tYR1cka6tZQu77qKycRBlwfsQHtCASQEX/GJCbKKVBm5vqrbQ
         QtJV648GrMP18w/Vq2afyz2/Uz1hb2s8c/yWmNR4sXHDh+4kdcN4ytLFyOIZiyxvDz
         N6dnnWqKMqVT5Rx1fKIWhjNYeMDseDSQiE3pdfRRsG8Nob+Am7/DdGD/gmEBtTtBJ0
         WXQksn05fLQ1nAzyoGOki9k7EvjIk4E6xncQ/M/kZevaGEwjx2JPDOBxkhun53ZNS5
         ezl8tGDIR1g1hUQdgivXFrdiAaFTYyzwoZqRY/GJeBMhYzk/D+BTUxeZGz4Amtw7lK
         0QrpPRMkzbHuw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 05/13] genetlink: check for callback type at op load time
Date:   Fri,  4 Nov 2022 12:13:35 -0700
Message-Id: <20221104191343.690543-6-kuba@kernel.org>
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

Now that genl_get_cmd_split() is informed what type of callback
user is trying to access (do or dump) we can check that this
callback is indeed available and return an error early.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 net/netlink/genetlink.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 770726ac491e..7c04df1bee2b 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -189,11 +189,17 @@ static int genl_get_cmd(u32 cmd, const struct genl_family *family,
 	return genl_get_cmd_small(cmd, family, op);
 }
 
-static void
+static int
 genl_cmd_full_to_split(struct genl_split_ops *op,
 		       const struct genl_family *family,
 		       const struct genl_ops *full, u8 flags)
 {
+	if ((flags & GENL_CMD_CAP_DO && !full->doit) ||
+	    (flags & GENL_CMD_CAP_DUMP && !full->dumpit)) {
+		memset(op, 0, sizeof(*op));
+		return -ENOENT;
+	}
+
 	if (flags & GENL_CMD_CAP_DUMP) {
 		op->start	= full->start;
 		op->dumpit	= full->dumpit;
@@ -220,6 +226,8 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
 
 	/* Make sure flags include the GENL_CMD_CAP_DO / GENL_CMD_CAP_DUMP */
 	op->flags		|= flags;
+
+	return 0;
 }
 
 static int
@@ -235,9 +243,7 @@ genl_get_cmd_split(u32 cmd, u8 flags, const struct genl_family *family,
 		return err;
 	}
 
-	genl_cmd_full_to_split(op, family, &full, flags);
-
-	return 0;
+	return genl_cmd_full_to_split(op, family, &full, flags);
 }
 
 static void genl_get_cmd_by_index(unsigned int i,
@@ -730,9 +736,6 @@ static int genl_family_rcv_msg_dumpit(const struct genl_family *family,
 	struct genl_start_context ctx;
 	int err;
 
-	if (!ops->dumpit)
-		return -EOPNOTSUPP;
-
 	ctx.family = family;
 	ctx.nlh = nlh;
 	ctx.extack = extack;
@@ -777,9 +780,6 @@ static int genl_family_rcv_msg_doit(const struct genl_family *family,
 	struct genl_info info;
 	int err;
 
-	if (!ops->doit)
-		return -EOPNOTSUPP;
-
 	attrbuf = genl_family_rcv_msg_attrs_parse(family, nlh, extack,
 						  ops, hdrlen,
 						  GENL_DONT_VALIDATE_STRICT);
-- 
2.38.1

