Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4721521FD
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 22:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727483AbgBDVhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 16:37:41 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58650 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727389AbgBDVhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 16:37:40 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 Feb 2020 23:37:33 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 014LbX64009488;
        Tue, 4 Feb 2020 23:37:33 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 014LbXLa028549;
        Tue, 4 Feb 2020 23:37:33 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 014LbQNN028546;
        Tue, 4 Feb 2020 23:37:26 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2-next] devlink: Add health error recovery status monitoring
Date:   Tue,  4 Feb 2020 23:37:02 +0200
Message-Id: <1580852222-28483-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for devlink health error recovery status monitoring.
Update devlink-monitor man page accordingly.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c          | 15 ++++++++++++++-
 man/man8/devlink-monitor.8 |  3 ++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 73ce986..f48ff6c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -4128,6 +4128,7 @@ static const char *cmd_name(uint8_t cmd)
 	case DEVLINK_CMD_FLASH_UPDATE: return "begin";
 	case DEVLINK_CMD_FLASH_UPDATE_END: return "end";
 	case DEVLINK_CMD_FLASH_UPDATE_STATUS: return "status";
+	case DEVLINK_CMD_HEALTH_REPORTER_RECOVER: return "status";
 	case DEVLINK_CMD_TRAP_GET: return "get";
 	case DEVLINK_CMD_TRAP_SET: return "set";
 	case DEVLINK_CMD_TRAP_NEW: return "new";
@@ -4168,6 +4169,8 @@ static const char *cmd_obj(uint8_t cmd)
 	case DEVLINK_CMD_FLASH_UPDATE_END:
 	case DEVLINK_CMD_FLASH_UPDATE_STATUS:
 		return "flash";
+	case DEVLINK_CMD_HEALTH_REPORTER_RECOVER:
+		return "health";
 	case DEVLINK_CMD_TRAP_GET:
 	case DEVLINK_CMD_TRAP_SET:
 	case DEVLINK_CMD_TRAP_NEW:
@@ -4229,6 +4232,7 @@ static void pr_out_flash_update(struct dl *dl, struct nlattr **tb)
 }
 
 static void pr_out_region(struct dl *dl, struct nlattr **tb);
+static void pr_out_health(struct dl *dl, struct nlattr **tb_health);
 static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array);
 static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array);
 
@@ -4295,6 +4299,14 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		pr_out_mon_header(genl->cmd);
 		pr_out_flash_update(dl, tb);
 		break;
+	case DEVLINK_CMD_HEALTH_REPORTER_RECOVER:
+		mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
+		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME] ||
+		    !tb[DEVLINK_ATTR_HEALTH_REPORTER])
+			return MNL_CB_ERROR;
+		pr_out_mon_header(genl->cmd);
+		pr_out_health(dl, tb);
+		break;
 	case DEVLINK_CMD_TRAP_GET: /* fall through */
 	case DEVLINK_CMD_TRAP_SET: /* fall through */
 	case DEVLINK_CMD_TRAP_NEW: /* fall through */
@@ -4337,6 +4349,7 @@ static int cmd_mon_show(struct dl *dl)
 		if (strcmp(cur_obj, "all") != 0 &&
 		    strcmp(cur_obj, "dev") != 0 &&
 		    strcmp(cur_obj, "port") != 0 &&
+		    strcmp(cur_obj, "health") != 0 &&
 		    strcmp(cur_obj, "trap") != 0 &&
 		    strcmp(cur_obj, "trap-group") != 0) {
 			pr_err("Unknown object \"%s\"\n", cur_obj);
@@ -4355,7 +4368,7 @@ static int cmd_mon_show(struct dl *dl)
 static void cmd_mon_help(void)
 {
 	pr_err("Usage: devlink monitor [ all | OBJECT-LIST ]\n"
-	       "where  OBJECT-LIST := { dev | port | trap | trap-group }\n");
+	       "where  OBJECT-LIST := { dev | port | health | trap | trap-group }\n");
 }
 
 static int cmd_mon(struct dl *dl)
diff --git a/man/man8/devlink-monitor.8 b/man/man8/devlink-monitor.8
index fffab3a..a96d350 100644
--- a/man/man8/devlink-monitor.8
+++ b/man/man8/devlink-monitor.8
@@ -21,7 +21,7 @@ command is the first in the command line and then the object list.
 .I OBJECT-LIST
 is the list of object types that we want to monitor.
 It may contain
-.BR dev ", " port ", " trap ", " trap-group .
+.BR dev ", " port ", " health ", " trap ", " trap-group .
 
 .B devlink
 opens Devlink Netlink socket, listens on it and dumps state changes.
@@ -31,6 +31,7 @@ opens Devlink Netlink socket, listens on it and dumps state changes.
 .BR devlink-dev (8),
 .BR devlink-sb (8),
 .BR devlink-port (8),
+.BR devlink-health (8),
 .BR devlink-trap (8),
 .br
 
-- 
1.8.3.1

