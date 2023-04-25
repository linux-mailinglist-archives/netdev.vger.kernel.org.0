Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1776ED923
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 02:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231985AbjDYAHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 20:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDYAHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 20:07:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859674EC9
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 17:07:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2122362A05
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 00:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C631C433D2;
        Tue, 25 Apr 2023 00:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682381265;
        bh=aS2tmXHin7i+CMIo2ud/q2WvxR7xHhFqlbPoxzgG1y4=;
        h=From:To:Cc:Subject:Date:From;
        b=hHLrB/i0AYdhtflgwTxasOC8/jUmdxQIscXeWvev25YCaVuTczTN+6pcuoo49Apqk
         8HSEiihZV79apay1cSGRO5VtKpCfffL/NAj+aAfCtwv7pVsfKrwrNvWrhHVgVyY6zi
         4OS1eSePpDGzcgxrqviyclkd3dsExIQriRuJzWhmeJ4z9BEeiMqE1eGJhMEY6Rt2Np
         VC6XjlMRaejl1uO7Gj9/66epDhJcaS52O8VhL7hmmlM+OFxsL0qm1bwsWkFIbLDc2k
         +pTC3NXgk3oPGpzIHzcQ4uKiBlLKgbdUx30RdHLWRH2gv4uyPhkDGeU9x0ZdfLgses
         HSnodsMmhnTWA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, piergiorgio.beruto@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool] netlink: settings: fix netlink support when PLCA is not present
Date:   Mon, 24 Apr 2023 17:07:42 -0700
Message-Id: <20230425000742.130480-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PLCA support threw the PLCA commands as required into the initial
support check at the start of nl_gset(). That's not correct.
The initial check (AFAIU) queries for the base support in the kernel
i.e. support for the commands which correspond to ioctls.
If those are not available (presumably very old kernel or kernel
without ethtool-netlink) we're better off using the ioctl.

For new functionality, however, falling back to ioctl
is counterproductive. New functionality (like PLCA) isn't
supported via the ioctl, anyway, and we're losing all the other
netlink-only functionality (I noticed that the link down statistics
are gone).

After much deliberation I decided to add a second check for
command support in gset_request(). Seems cleanest and if any
of the non-required commands narrows the capabilities (e.g.
does not support dump) we should just skip it too. Falling
back to ioctl would again be a regression.

Fixes: cf02fc1b1095 ("add support for IEEE 802.3cg-2019 Clause 148")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/settings.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/netlink/settings.c b/netlink/settings.c
index 168b182530a2..4fd75d2e0a5a 100644
--- a/netlink/settings.c
+++ b/netlink/settings.c
@@ -963,13 +963,17 @@ int plca_status_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	return MNL_CB_OK;
 }
 
-static int gset_request(struct nl_context *nlctx, uint8_t msg_type,
+static int gset_request(struct cmd_context *ctx, uint8_t msg_type,
 			uint16_t hdr_attr, mnl_cb_t cb)
 {
+	struct nl_context *nlctx = ctx->nlctx;
 	struct nl_socket *nlsk = nlctx->ethnl_socket;
 	u32 flags;
 	int ret;
 
+	if (netlink_cmd_check(ctx, msg_type, true))
+		return 0;
+
 	flags = get_stats_flag(nlctx, msg_type, hdr_attr);
 
 	ret = nlsock_prep_get_request(nlsk, msg_type, hdr_attr, flags);
@@ -980,61 +984,58 @@ static int gset_request(struct nl_context *nlctx, uint8_t msg_type,
 
 int nl_gset(struct cmd_context *ctx)
 {
-	struct nl_context *nlctx = ctx->nlctx;
 	int ret;
 
+	/* Check for the base set of commands */
 	if (netlink_cmd_check(ctx, ETHTOOL_MSG_LINKMODES_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKINFO_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_WOL_GET, true) ||
 	    netlink_cmd_check(ctx, ETHTOOL_MSG_DEBUG_GET, true) ||
-	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true) ||
-	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_CFG, true) ||
-	    netlink_cmd_check(ctx, ETHTOOL_MSG_PLCA_GET_STATUS, true))
+	    netlink_cmd_check(ctx, ETHTOOL_MSG_LINKSTATE_GET, true))
 		return -EOPNOTSUPP;
 
-	nlctx->suppress_nlerr = 1;
+	ctx->nlctx->suppress_nlerr = 1;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_LINKMODES_GET,
+	ret = gset_request(ctx, ETHTOOL_MSG_LINKMODES_GET,
 			   ETHTOOL_A_LINKMODES_HEADER, linkmodes_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_LINKINFO_GET,
+	ret = gset_request(ctx, ETHTOOL_MSG_LINKINFO_GET,
 			   ETHTOOL_A_LINKINFO_HEADER, linkinfo_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_WOL_GET, ETHTOOL_A_WOL_HEADER,
+	ret = gset_request(ctx, ETHTOOL_MSG_WOL_GET, ETHTOOL_A_WOL_HEADER,
 			   wol_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_CFG,
+	ret = gset_request(ctx, ETHTOOL_MSG_PLCA_GET_CFG,
 			   ETHTOOL_A_PLCA_HEADER, plca_cfg_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
+	ret = gset_request(ctx, ETHTOOL_MSG_DEBUG_GET, ETHTOOL_A_DEBUG_HEADER,
 			   debug_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_LINKSTATE_GET,
+	ret = gset_request(ctx, ETHTOOL_MSG_LINKSTATE_GET,
 			   ETHTOOL_A_LINKSTATE_HEADER, linkstate_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	ret = gset_request(nlctx, ETHTOOL_MSG_PLCA_GET_STATUS,
+	ret = gset_request(ctx, ETHTOOL_MSG_PLCA_GET_STATUS,
 			   ETHTOOL_A_PLCA_HEADER, plca_status_reply_cb);
 	if (ret == -ENODEV)
 		return ret;
 
-	if (!nlctx->no_banner) {
+	if (!ctx->nlctx->no_banner) {
 		printf("No data available\n");
 		return 75;
 	}
 
-
 	return 0;
 }
 
-- 
2.40.0

