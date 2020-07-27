Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71C22EAD9
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728532AbgG0LHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:45 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40684 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726701AbgG0LGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:06:17 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6Bn5022176;
        Mon, 27 Jul 2020 14:06:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6BIK002386;
        Mon, 27 Jul 2020 14:06:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6B3W002385;
        Mon, 27 Jul 2020 14:06:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 02/13] devlink: Add reload levels data to dev get
Date:   Mon, 27 Jul 2020 14:02:22 +0300
Message-Id: <1595847753-2234-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose devlink reload supported levels and driver's default level to the
user through devlink dev get command.

Examples:
$ devlink dev show
pci/0000:82:00.0:
  reload_levels_info:
    default_level driver
    supported_levels:
      driver fw_reset fw_live_patch
pci/0000:82:00.1:
  reload_levels_info:
    default_level driver
    supported_levels:
      driver fw_reset fw_live_patch

$ devlink dev show -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "reload_levels_info": {
                "default_level": "driver",
                "supported_levels": [ "driver","fw_reset","fw_live_patch" ]
            }
        },
        "pci/0000:82:00.1": {
            "reload_levels_info": {
                "default_level": "driver",
                "supported_levels": [ "driver","fw_reset","fw_live_patch" ]
            }
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 include/uapi/linux/devlink.h |  3 +++
 net/core/devlink.c           | 38 +++++++++++++++++++++++++++++++-----
 2 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index fa5f66db5012..249e921ff106 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -476,6 +476,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_SPLITTABLE,			/* u8 */
 
 	DEVLINK_ATTR_RELOAD_LEVEL,		/* u8 */
+	DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL,	/* u8 */
+	DEVLINK_ATTR_RELOAD_SUPPORTED_LEVELS,	/* nested */
+	DEVLINK_ATTR_RELOAD_LEVELS_INFO,	/* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 31b367a1612d..f1812fc620d4 100644
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
 devlink_reload_level_is_supported(struct devlink *devlink, enum devlink_reload_level level)
 {
@@ -472,7 +477,9 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
 {
+	struct nlattr *reload_levels_info, *supported_levels;
 	void *hdr;
+	int i;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -483,9 +490,35 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
 		goto nla_put_failure;
 
+	if (devlink_reload_supported(devlink)) {
+		reload_levels_info = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_LEVELS_INFO);
+		if (!reload_levels_info)
+			goto nla_put_failure;
+		if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL,
+			       devlink->ops->default_reload_level))
+			goto reload_levels_info_nest_cancel;
+
+		supported_levels = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_SUPPORTED_LEVELS);
+		if (!supported_levels)
+			goto reload_levels_info_nest_cancel;
+
+		for (i = 0; i <= DEVLINK_RELOAD_LEVEL_MAX; i++) {
+			if (!devlink_reload_level_is_supported(devlink, i))
+				continue;
+			if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_LEVEL, i))
+				goto supported_levels_nest_cancel;
+		}
+		nla_nest_end(msg, supported_levels);
+		nla_nest_end(msg, reload_levels_info);
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
+supported_levels_nest_cancel:
+	nla_nest_cancel(msg, supported_levels);
+reload_levels_info_nest_cancel:
+	nla_nest_cancel(msg, reload_levels_info);
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
@@ -2943,11 +2976,6 @@ static void devlink_reload_netns_change(struct devlink *devlink,
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

