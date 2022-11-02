Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32EBB616FDC
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 22:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbiKBVeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 17:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiKBVdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 17:33:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C37E3B
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 14:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A13A561C58
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 21:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24287C433D7;
        Wed,  2 Nov 2022 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667424828;
        bh=7SZYX6NR/XeFprIop8mPSJT5OAYRZBHBQT0QY3ZYLqE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RgOH6F9Q96i/nEAhU/HPYQBY04KTSj4KV3dyLVRyu+fIS/5uSloMiSiw6/JH057W5
         8C005opdaz3a66BI/ci42b7FOT6mpCqqSWMrq+9pLKbs0+CI5aXiPY8bNCgVvCmkQU
         n4cNOIFQO7dfwGOdRdl5e8K1nb20ImCR/1yn4qNdj3T1EVAFL0ycdPn1LOTvEDwzks
         A5f/Qu+LO3GfBDZ7t9ALgHiM4UfQPhcl3E0Yeo4hpKhSWOpLB0SpfM4BfbE+n2WDSB
         p8xcTVfolKhKgBc8R/0jQxUtJRXwHW/qMk1XUYXgBm6q0w9mNzRsYl6HF3vnlCMBXj
         QL0p2bjC80BZA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 05/13] genetlink: check for callback type at op load time
Date:   Wed,  2 Nov 2022 14:33:30 -0700
Message-Id: <20221102213338.194672-6-kuba@kernel.org>
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

Now that genl_get_cmd_split() is informed what type of callback
user is trying to access (do or dump) we can check that this
callback is indeed available and return an error early.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
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

