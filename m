Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE044246376
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgHQJi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:38:28 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55833 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728348AbgHQJiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:38:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 17 Aug 2020 12:38:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 07H9cBCQ011403;
        Mon, 17 Aug 2020 12:38:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 07H9cBwN003229;
        Mon, 17 Aug 2020 12:38:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 07H9cBj6003228;
        Mon, 17 Aug 2020 12:38:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v2 02/13] devlink: Add supported reload actions to dev get
Date:   Mon, 17 Aug 2020 12:37:41 +0300
Message-Id: <1597657072-3130-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose devlink reload supported actions to the user through devlink dev
get command.

Examples:
$ devlink dev show
pci/0000:82:00.0:
  supported_reload_actions:
    fw_live_patch driver_reinit fw_activate
pci/0000:82:00.1:
  supported_reload_actions:
    fw_live_patch driver_reinit fw_activate

$ devlink dev show -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "supported_reload_actions": [ "fw_live_patch","driver_reinit","fw_activate" ]
        },
        "pci/0000:82:00.1": {
            "supported_reload_actions": [ "fw_live_patch","driver_reinit","fw_activate" ]
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v1 -> v2:
- Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
- Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
- Have actions instead of levels
---
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 28 +++++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 6728029d2e1e..803a9717110c 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -476,6 +476,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
+	DEVLINK_ATTR_RELOAD_SUPPORTED_ACTIONS,	/* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 88438ffd6015..6bab1b02ca99 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -462,6 +462,11 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
 	return 0;
 }
 
+static bool devlink_reload_supported(struct devlink *devlink)
+{
+	return devlink->ops->reload_down && devlink->ops->reload_up;
+}
+
 static bool
 devlink_reload_action_is_supported(struct devlink *devlink, enum devlink_reload_action action)
 {
@@ -472,7 +477,9 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
 {
+	struct nlattr *supported_actions;
 	void *hdr;
+	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -483,9 +490,25 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
 		goto nla_put_failure;
 
+	if (devlink_reload_supported(devlink)) {
+		supported_actions = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_SUPPORTED_ACTIONS);
+		if (!supported_actions)
+			goto nla_put_failure;
+
+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+			if (!devlink_reload_action_is_supported(devlink, i))
+				continue;
+			if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
+				goto supported_actions_nest_cancel;
+		}
+		nla_nest_end(msg, supported_actions);
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
+supported_actions_nest_cancel:
+	nla_nest_cancel(msg, supported_actions);
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
@@ -2949,11 +2972,6 @@ static void devlink_reload_netns_change(struct devlink *devlink,
 				     DEVLINK_CMD_PARAM_NEW);
 }
 
-static bool devlink_reload_supported(const struct devlink *devlink)
-{
-	return devlink->ops->reload_down && devlink->ops->reload_up;
-}
-
 static void devlink_reload_failed_set(struct devlink *devlink,
 				      bool reload_failed)
 {
-- 
2.17.1

