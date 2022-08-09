Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9AC58E3BC
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 01:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiHIX1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 19:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiHIX1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 19:27:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD407E828
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 16:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E05E9B818E4
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 23:27:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F556C433D6;
        Tue,  9 Aug 2022 23:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660087663;
        bh=S0Gk5Gw1ShG4IY2DrREO/li65KKTQDLbO+GKoD5Apt8=;
        h=From:To:Cc:Subject:Date:From;
        b=HWYNoQBO9uhxIPxzaDNiRq6GF6Z6WhZ2KQFaxBjdla5zrdiZSC0uOgp5Vs8o5Q5Vw
         fgRAb58ilIRwzaiOodBzckz8Wm9dU4xgFtxzCiIvtzXAXWSmxkdwhmvHt2FjZfHZjs
         7LeyNrR2naGZ7EU64nj0KMraX27w8P+bWRxpKJO5K1UbxTpVJOgAQZ79hPIdDhAngM
         LVNT1sfAMw7tgEQ4A4rlw9qRXKb4X62qrKsfm0JosT2tJRmIjo8T3ihp/6IMt2cpmU
         lidUF4KARywhK4ApSpqDzIPuX5NQD6JQi9L6Zo3I/R0PI2LEy3RU6FEDfH7zx/HAxy
         S3kAHI41t00+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        johannes.berg@intel.com, johannes@sipsolutions.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] genetlink: correct uAPI defines
Date:   Tue,  9 Aug 2022 16:27:40 -0700
Message-Id: <20220809232740.405668-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 50a896cf2d6f ("genetlink: properly support per-op policy dumping")
seems to have copy'n'pasted things a little incorrectly.

The #define CTRL_ATTR_MCAST_GRP_MAX should have stayed right
after the previous enum. The new CTRL_ATTR_POLICY_* needs
its own define for MAX and that max should not contain the
superfluous _DUMP in the name.

We probably can't do anything about the CTRL_ATTR_POLICY_DUMP_MAX
any more, there's likely code which uses it. For consistency
(*cough* codegen *cough*) let's add the correctly name define
nonetheless.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/uapi/linux/genetlink.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/genetlink.h b/include/uapi/linux/genetlink.h
index d83f214b4134..ddba3ca01e39 100644
--- a/include/uapi/linux/genetlink.h
+++ b/include/uapi/linux/genetlink.h
@@ -87,6 +87,8 @@ enum {
 	__CTRL_ATTR_MCAST_GRP_MAX,
 };
 
+#define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
+
 enum {
 	CTRL_ATTR_POLICY_UNSPEC,
 	CTRL_ATTR_POLICY_DO,
@@ -96,7 +98,6 @@ enum {
 	CTRL_ATTR_POLICY_DUMP_MAX = __CTRL_ATTR_POLICY_DUMP_MAX - 1
 };
 
-#define CTRL_ATTR_MCAST_GRP_MAX (__CTRL_ATTR_MCAST_GRP_MAX - 1)
-
+#define CTRL_ATTR_POLICY_MAX (__CTRL_ATTR_POLICY_DUMP_MAX - 1)
 
 #endif /* _UAPI__LINUX_GENERIC_NETLINK_H */
-- 
2.37.1

