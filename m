Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9690A63CCE8
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 02:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiK3Bhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 20:37:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiK3Bhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 20:37:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACDB658B
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 17:37:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A355619A9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 01:37:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DFD0C433C1;
        Wed, 30 Nov 2022 01:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669772259;
        bh=mSQXL7849BT4BXTgGUUVzavHSQTQKHY0bFwSt0q5Zbk=;
        h=From:To:Cc:Subject:Date:From;
        b=WomaS85aEr+C4kJjEu8/xFSf/bMyHtiRAOcxnu5wCjbH8Uhg/BZUO2Am93esmmHmm
         TrBPSfAy8FaotoNWm+NUmn3Jv/lN+6NOXosrighQ2OvdA8PFxs98fo53Obw2Lb7a8Q
         xrc6fJyzZydJrNNyaTKilSTnO7ILiDJ//oWXsH3oquyQ15ntMAVthi4Xy2sS0F5A9Q
         j8bSrLWTnPpcDSyqvc650kOtUGQSklzSV3L5WsD1e7A56e7zi5+BCDbD+QZkdVWq1S
         BqP5lmoBUGhgynCAclzyGveKo468oPuWPWfW1ZME71u4qTJ1UTC4gngftb/AuILLiD
         yweawPsAW4nUg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next] linkstate: report the number of hard link flaps
Date:   Tue, 29 Nov 2022 17:37:36 -0800
Message-Id: <20221130013736.90875-1-kuba@kernel.org>
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

Print the recently added link down event statistics when
present. We need to query the netlink policy to know if
the stats are supported.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/settings.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index ea86e365383b..14ad0b46e102 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -5,6 +5,7 @@
  */
 
 #include <errno.h>
+#include <inttypes.h>
 #include <string.h>
 #include <stdio.h>
 
@@ -772,6 +773,13 @@ int linkstate_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 		}
 	}
 
+	if (tb[ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT]) {
+		uint32_t val;
+
+		val = mnl_attr_get_u32(tb[ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT]);
+		printf("\tLink Down Events: %u\n", val);
+	}
+
 	return MNL_CB_OK;
 }
 
@@ -882,12 +890,16 @@ int debug_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
-static int gset_request(struct nl_socket *nlsk, uint8_t msg_type,
+static int gset_request(struct nl_context *nlctx, uint8_t msg_type,
 			uint16_t hdr_attr, mnl_cb_t cb)
 {
+	struct nl_socket *nlsk = nlctx->ethnl_socket;
+	u32 flags;
 	int ret;
 
-	ret = nlsock_prep_get_request(nlsk, msg_type, hdr_attr, 0);
+	flags = get_stats_flag(nlctx, msg_type, hdr_attr);
+
+	ret = nlsock_prep_get_request(nlsk, msg_type, hdr_attr, flags);
 	if (ret < 0)
 		return ret;
 	return nlsock_send_get_request(nlsk, cb);
@@ -896,7 +908,6 @@ static int gset_request(struct nl_socket *nlsk, uint8_t msg_type,
 int nl_gset(struct cmd_context *ctx)
 {
 	struct nl_context *nlctx = ctx->nlctx;
-	struct nl_socket *nlsk = nlctx->ethnl_socket;
 	int ret;
 
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_LINKMODES_GET, true) ||
@@ -908,27 +919,27 @@ int nl_gset(struct cmd_context *ctx)
 
 	nlctx->suppress_nlerr = 1;
 
-	ret = gset_request(nlsk, ETHTOOL_MSG_LINKMODES_GET,
+	ret = gset_request(nlctx, ETHTOOL_MSG_LINKMODES_GET,
 			   ETHTOOL_A_LINKMODES_HEADER, linkmodes_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlsk, ETHTOOL_MSG_LINKINFO_GET,
+	ret = gset_request(nlctx, ETHTOOL_MSG_LINKINFO_GET,
 			   ETHTOOL_A_LINKINFO_HEADER, linkinfo_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlsk, ETHTOOL_MSG_WOL_GET, ETHTOOL_A_WOL_HEADER,
+	ret = gset_request(nlctx, ETHTOOL_MSG_WOL_GET, ETHTOOL_A_WOL_HEADER,
 			   wol_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlsk, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
+	ret = gset_request(nlctx, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
 			   debug_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlsk, ETHTOOL_MSG_LINKSTATE_GET,
+	ret = gset_request(nlctx, ETHTOOL_MSG_LINKSTATE_GET,
 			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
-- 
2.38.1

