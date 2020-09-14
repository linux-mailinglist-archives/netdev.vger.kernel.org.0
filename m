Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA41E268462
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 08:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgINGI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 02:08:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59447 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726069AbgINGIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 02:08:24 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 14 Sep 2020 09:08:15 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08E68FwH020944;
        Mon, 14 Sep 2020 09:08:15 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08E68FHZ017387;
        Mon, 14 Sep 2020 09:08:15 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08E68FjI017386;
        Mon, 14 Sep 2020 09:08:15 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v4 04/15] devlink: Add reload actions stats to dev get
Date:   Mon, 14 Sep 2020 09:07:51 +0300
Message-Id: <1600063682-17313-5-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose devlink reload actions stats to the user through devlink dev
get command.

Examples:
$ devlink dev show
pci/0000:82:00.0:
  reload_action_stats:
    driver_reinit 2
    fw_activate 1
    driver_reinit_no_reset 0
    fw_activate_no_reset 0
pci/0000:82:00.1:
  reload_action_stats:
    driver_reinit 1
    fw_activate 1
    driver_reinit_no_reset 0
    fw_activate_no_reset 0

$ devlink dev show -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "reload_action_stats": [ {
                    "driver_reinit": 2
                },{
                    "fw_activate": 1
                },{
                    "driver_reinit_no_reset": 0
                },{
                    "fw_activate_no_reset": 0
                } ]
        },
        "pci/0000:82:00.1": {
            "reload_action_stats": [ {
                    "driver_reinit": 1
                },{
                    "fw_activate": 1
                },{
                    "driver_reinit_no_reset": 0
                },{
                    "fw_activate_no_reset": 0
                } ]
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v3 -> v4:
- Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
  DEVLINK_ATTR_RELOAD_ACTION_STAT
- Add stats per action per limit level
v2 -> v3:
- Add reload actions counters instead of supported reload actions
  (reload actions counters are only for supported action so no need for
   both)
v1 -> v2:
- Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
- Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
- Have actions instead of levels
---
 include/uapi/linux/devlink.h |  3 +++
 net/core/devlink.c           | 45 ++++++++++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b19686fd80ff..ac9be467d243 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -495,6 +495,9 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
 	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
+	DEVLINK_ATTR_RELOAD_ACTION_STATS,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_STAT,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE,	/* u32 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index cbf746966913..1063b7a4123a 100644
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
@@ -479,7 +484,9 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
 {
+	struct nlattr *reload_action_stats, *reload_action_stat;
+	int i, j, stat_idx;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -490,9 +497,42 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
 		goto nla_put_failure;
 
+	if (!devlink_reload_supported(devlink))
+		goto out;
+
+	reload_action_stats = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
+	if (!reload_action_stats)
+		goto nla_put_failure;
+
+	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
+		if (!devlink_reload_action_limit_level_is_supported(devlink, j))
+			continue;
+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+			if (!devlink_reload_action_is_supported(devlink, i))
+				continue;
+			reload_action_stat = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT);
+			if (!reload_action_stat)
+				goto reload_action_stats_nest_cancel;
+			if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
+				goto reload_action_stat_nest_cancel;
+			if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL, j))
+				goto reload_action_stat_nest_cancel;
+			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
+			if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE,
+					devlink->reload_action_stats[stat_idx]))
+				goto reload_action_stat_nest_cancel;
+			nla_nest_end(msg, reload_action_stat);
+		}
+		nla_nest_end(msg, reload_action_stats);
+	}
+out:
 	genlmsg_end(msg, hdr);
 	return 0;
 
+reload_action_stat_nest_cancel:
+	nla_nest_cancel(msg, reload_action_stat);
+reload_action_stats_nest_cancel:
+	nla_nest_cancel(msg, reload_action_stats);
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
@@ -2961,11 +3001,6 @@ static void devlink_reload_netns_change(struct devlink *devlink,
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

