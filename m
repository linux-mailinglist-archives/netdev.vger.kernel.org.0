Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F24C4292025
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:32:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgJRVcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:32:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:47014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728036AbgJRVcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:32:01 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79B37222E7;
        Sun, 18 Oct 2020 21:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603056720;
        bh=4n0rObmDSbi7LahmXq9n2QapHkJN41lZHJPAcMtVJB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bRVKlLcq1vNSQgruyYq/eVW2dFj15FvXHRYsMOxwZWh21Ti2zSqaVzEoU1tZLMgv2
         2DxjgpnzKIjFkLv7hXf/c00xnOhxQczZlVwHm405VEiZQmStLfuuqTSZ+nmqIB93qy
         +tUX7O8kJtNEwioz4qSa+OtXADWNxqRaEbLtMfHY=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v3 5/7] netlink: prepare for more per-op info
Date:   Sun, 18 Oct 2020 14:31:49 -0700
Message-Id: <20201018213151.3450437-6-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201018213151.3450437-1-kuba@kernel.org>
References: <20201018213151.3450437-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We stored an array of op flags, to check if operations are
supported. Make that array a structure rather than plain
uint32_t in preparation for storing more state.

v3: new patch

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 netlink/netlink.c | 25 +++++++++++++------------
 netlink/netlink.h |  6 +++++-
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index e42d57076a4b..86dc1efdf5ce 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -120,19 +120,19 @@ bool netlink_cmd_check(struct cmd_context *ctx, unsigned int cmd,
 		nlctx->wildcard_unsupported = true;
 		return true;
 	}
-	if (!nlctx->ops_flags) {
+	if (!nlctx->ops_info) {
 		nlctx->ioctl_fallback = true;
 		return false;
 	}
-	if (cmd > ETHTOOL_MSG_USER_MAX || !nlctx->ops_flags[cmd]) {
+	if (cmd > ETHTOOL_MSG_USER_MAX || !nlctx->ops_info[cmd].op_flags) {
 		nlctx->ioctl_fallback = true;
 		return true;
 	}
 
-	if (is_dump && !(nlctx->ops_flags[cmd] & GENL_CMD_CAP_DUMP))
+	if (is_dump && !(nlctx->ops_info[cmd].op_flags & GENL_CMD_CAP_DUMP))
 		nlctx->wildcard_unsupported = true;
 
-	return !(nlctx->ops_flags[cmd] & cap);
+	return !(nlctx->ops_info[cmd].op_flags & cap);
 }
 
 /* initialization */
@@ -140,12 +140,12 @@ bool netlink_cmd_check(struct cmd_context *ctx, unsigned int cmd,
 static int genl_read_ops(struct nl_context *nlctx,
 			 const struct nlattr *ops_attr)
 {
+	struct nl_op_info *ops_info;
 	struct nlattr *op_attr;
-	uint32_t *ops_flags;
 	int ret;
 
-	ops_flags = calloc(__ETHTOOL_MSG_USER_CNT, sizeof(ops_flags[0]));
-	if (!ops_flags)
+	ops_info = calloc(__ETHTOOL_MSG_USER_CNT, sizeof(ops_info[0]));
+	if (!ops_info)
 		return -ENOMEM;
 
 	mnl_attr_for_each_nested(op_attr, ops_attr) {
@@ -163,13 +163,14 @@ static int genl_read_ops(struct nl_context *nlctx,
 		if (op_id >= __ETHTOOL_MSG_USER_CNT)
 			continue;
 
-		ops_flags[op_id] = mnl_attr_get_u32(tb[CTRL_ATTR_OP_FLAGS]);
+		ops_info[op_id].op_flags =
+			mnl_attr_get_u32(tb[CTRL_ATTR_OP_FLAGS]);
 	}
 
-	nlctx->ops_flags = ops_flags;
+	nlctx->ops_info = ops_info;
 	return 0;
 err:
-	free(ops_flags);
+	free(ops_info);
 	return ret;
 }
 
@@ -273,7 +274,7 @@ int netlink_init(struct cmd_context *ctx)
 out_nlsk:
 	nlsock_done(nlctx->ethnl_socket);
 out_free:
-	free(nlctx->ops_flags);
+	free(nlctx->ops_info);
 	free(nlctx);
 	return ret;
 }
@@ -283,7 +284,7 @@ static void netlink_done(struct cmd_context *ctx)
 	if (!ctx->nlctx)
 		return;
 
-	free(ctx->nlctx->ops_flags);
+	free(ctx->nlctx->ops_info);
 	free(ctx->nlctx);
 	ctx->nlctx = NULL;
 	cleanup_all_strings();
diff --git a/netlink/netlink.h b/netlink/netlink.h
index 1012e8e32cd8..e79143016bd5 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -25,6 +25,10 @@ enum link_mode_class {
 	LM_CLASS_FEC,
 };
 
+struct nl_op_info {
+	uint32_t		op_flags;
+};
+
 struct nl_context {
 	struct cmd_context	*ctx;
 	void			*cmd_private;
@@ -34,7 +38,7 @@ struct nl_context {
 	unsigned int		suppress_nlerr;
 	uint16_t		ethnl_fam;
 	uint32_t		ethnl_mongrp;
-	uint32_t		*ops_flags;
+	struct nl_op_info	*ops_info;
 	struct nl_socket	*ethnl_socket;
 	struct nl_socket	*ethnl2_socket;
 	struct nl_socket	*rtnl_socket;
-- 
2.26.2

