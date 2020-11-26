Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306392C52A8
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388706AbgKZLPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 06:15:44 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34955 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726602AbgKZLPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 06:15:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 26 Nov 2020 13:15:39 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AQBFddF025593;
        Thu, 26 Nov 2020 13:15:39 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AQBFdwf004263;
        Thu, 26 Nov 2020 13:15:39 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AQBFd8M004262;
        Thu, 26 Nov 2020 13:15:39 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2-net 2/3] devlink: Add pr_out_dev() helper function
Date:   Thu, 26 Nov 2020 13:14:55 +0200
Message-Id: <1606389296-3906-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pr_out_dev() helper function and use it both by cmd_dev_show_cb()
and by cmd_mon_show_cb().

Dev stats will be added on the next patch to dev context, so
cmd_mon_show_cb() should print the whole dev context and not just dev
handle.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a9ba0072..bd588869 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2974,17 +2974,11 @@ static int cmd_dev_param(struct dl *dl)
 	pr_err("Command \"%s\" not found\n", dl_argv(dl));
 	return -ENOENT;
 }
-static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
+
+static void pr_out_dev(struct dl *dl, struct nlattr **tb)
 {
-	struct dl *dl = data;
-	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
-	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
 	uint8_t reload_failed = 0;
 
-	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
-	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
-		return MNL_CB_ERROR;
-
 	if (tb[DEVLINK_ATTR_RELOAD_FAILED])
 		reload_failed = mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED]);
 
@@ -2996,7 +2990,19 @@ static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
 	} else {
 		pr_out_handle(dl, tb);
 	}
+}
 
+static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct dl *dl = data;
+	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
+	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
+
+	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+	if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	pr_out_dev(dl, tb);
 	return MNL_CB_OK;
 }
 
@@ -4838,7 +4844,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
-		pr_out_handle(dl, tb);
+		pr_out_dev(dl, tb);
 		pr_out_mon_footer();
 		break;
 	case DEVLINK_CMD_PORT_GET: /* fall through */
-- 
2.18.2

