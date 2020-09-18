Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C832701CE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgIRQOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:14:48 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55263 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726389AbgIRQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:13:59 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 18 Sep 2020 19:07:09 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08IG79v0025137;
        Fri, 18 Sep 2020 19:07:09 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08IG79pe031154;
        Fri, 18 Sep 2020 19:07:09 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08IG79Se031153;
        Fri, 18 Sep 2020 19:07:09 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v5 04/15] devlink: Add reload actions stats to dev get
Date:   Fri, 18 Sep 2020 19:06:40 +0300
Message-Id: <1600445211-31078-5-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expose devlink reload actions stats to the user through devlink dev
get command.

Examples:
$ devlink dev show
pci/0000:82:00.0:
  stats:
      reload_action_stats:
        driver_reinit 2
        fw_activate 1
        fw_activate_no_reset 0
        remote_driver_reinit 0
        remote_fw_activate 0
        remote_fw_activate_no_reset 0
pci/0000:82:00.1:
  stats:
      reload_action_stats:
        driver_reinit 0
        fw_activate 0
        fw_activate_no_reset 0
        remote_driver_reinit 1
        remote_fw_activate 1
        remote_fw_activate_no_reset 0

$ devlink dev show -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "stats": {
                "reload_action_stats": [ {
                        "driver_reinit": 2
                    },{
                        "fw_activate": 1
                    },{
                        "fw_activate_no_reset": 0
                    },{
                        "remote_driver_reinit": 0
                    },{
                        "remote_fw_activate": 0
                    },{
                        "remote_fw_activate_no_reset": 0
                    } ]
            }
        },
        "pci/0000:82:00.1": {
            "stats": {
                "reload_action_stats": [ {
                        "driver_reinit": 0
                    },{
                        "fw_activate": 0
                    },{
                        "fw_activate_no_reset": 0
                    },{
                        "remote_driver_reinit": 1
                    },{
                        "remote_fw_activate": 1
                    },{
                        "remote_fw_activate_no_reset": 0
                    } ]
            }
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
v4 -> v5:
- Add remote actions stats
- If devlink reload is not supported, show only remote_stats
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
 include/uapi/linux/devlink.h |  5 +++
 net/core/devlink.c           | 70 ++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 0c5d942dcbd5..648d53be691e 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -497,7 +497,12 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
 	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
+	DEVLINK_ATTR_RELOAD_ACTION_STATS,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_STAT,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_STAT_REMOTE,	/* flag */
+	DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE,	/* u32 */
 
+	DEVLINK_ATTR_DEV_STATS,			/* nested */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 1509c2ffb98b..71aeda259e6a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -501,10 +501,39 @@ devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
 	return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
 }
 
+static int devlink_reload_action_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
+					  enum devlink_reload_action_limit_level limit_level,
+					  bool is_remote, u32 value)
+{
+	struct nlattr *reload_action_stat;
+
+	reload_action_stat = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT);
+	if (!reload_action_stat)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
+		goto nla_put_failure;
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL, limit_level))
+		goto nla_put_failure;
+	if (is_remote && nla_put_flag(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_REMOTE))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE, value))
+		goto nla_put_failure;
+	nla_nest_end(msg, reload_action_stat);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, reload_action_stat);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
 {
+	struct nlattr *dev_stats, *reload_action_stats;
+	int i, j, stat_idx;
+	u32 value;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
@@ -516,9 +545,50 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
 		goto nla_put_failure;
 
+	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);
+	if (!dev_stats)
+		goto nla_put_failure;
+	reload_action_stats = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
+	if (!reload_action_stats)
+		goto dev_stats_nest_cancel;
+
+	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
+		if (!devlink_reload_action_limit_level_is_supported(devlink, j))
+			continue;
+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+			if (!devlink_reload_action_is_supported(devlink, i) ||
+			    devlink_reload_combination_is_invalid(i, j))
+				continue;
+
+			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
+			value = devlink->reload_action_stats[stat_idx];
+			if (devlink_reload_action_stat_put(msg, i, j, false, value))
+				goto reload_action_stats_nest_cancel;
+		}
+	}
+
+	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+			if (i == DEVLINK_RELOAD_ACTION_UNSPEC ||
+			    devlink_reload_combination_is_invalid(i, j))
+				continue;
+
+			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
+			value = devlink->remote_reload_action_stats[stat_idx];
+			if (devlink_reload_action_stat_put(msg, i, j, true, value))
+				goto reload_action_stats_nest_cancel;
+		}
+	}
+
+	nla_nest_end(msg, reload_action_stats);
+	nla_nest_end(msg, dev_stats);
 	genlmsg_end(msg, hdr);
 	return 0;
 
+dev_stats_nest_cancel:
+	nla_nest_cancel(msg, dev_stats);
+reload_action_stats_nest_cancel:
+	nla_nest_cancel(msg, reload_action_stats);
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
-- 
2.17.1

