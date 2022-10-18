Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67447603666
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 01:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJRXHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 19:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJRXHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 19:07:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B652A711
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 16:07:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EF48B8207D
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C5DC433D7;
        Tue, 18 Oct 2022 23:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666134456;
        bh=CdQojpdc8mrEEedbY/4JlGg6J9dkfUDmZN9lS3zChsw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qu3ZWd/vZQ0ukSWdhQvozRu/yS0Y+o3vceoLd7TxlzMhO2PfDeZl90QMYciUR2Ipt
         2CZ9LlojcLINjOyqmD7e2pmHLOq839mJ5KenMUkVMZeg7/ccoQRBw0ET9p43TAFd3t
         ZWQPbD/XMpCjFqDQq8L2ddK72pm1d5V+ip5ZVe5W1NFRiS6mZ2vt67psEKzE/AAiu7
         gj2pYhKcd1RWgEtt0xn/fv524ttpMiwBoAxyJasTodSYeb4Aef5UfyFgdcj/5o2LyW
         55gaVu6DefbQTK/GSs3ZdvCwVlXamyMOOe+sVKV9X23WMPoa6kV4B+khXPu14/eR4L
         kfBbm++35pZKQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, razor@blackwall.org, nicolas.dichtel@6wind.com,
        gnault@redhat.com, jacob.e.keller@intel.com, fw@strlen.de,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 04/13] genetlink: load policy based on validation flags
Date:   Tue, 18 Oct 2022 16:07:19 -0700
Message-Id: <20221018230728.1039524-5-kuba@kernel.org>
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

Set the policy and maxattr pointers based on validation flags.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/netlink/genetlink.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/netlink/genetlink.c b/net/netlink/genetlink.c
index 23d3682d8f94..26ddbd23549d 100644
--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -181,8 +181,14 @@ genl_cmd_full_to_split(struct genl_split_ops *op,
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
@@ -612,10 +618,8 @@ static int genl_start(struct netlink_callback *cb)
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
@@ -624,7 +628,6 @@ static int genl_start(struct netlink_callback *cb)
 	if (IS_ERR(attrs))
 		return PTR_ERR(attrs);
 
-no_attrs:
 	info = genl_dumpit_info_alloc();
 	if (!info) {
 		genl_family_rcv_msg_attrs_free(attrs);
-- 
2.37.3

