Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EC22C52A9
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 12:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388797AbgKZLPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 06:15:45 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34956 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728965AbgKZLPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 06:15:44 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 26 Nov 2020 13:15:39 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AQBFdBi025621;
        Thu, 26 Nov 2020 13:15:39 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AQBFd2E004265;
        Thu, 26 Nov 2020 13:15:39 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AQBFdDv004264;
        Thu, 26 Nov 2020 13:15:39 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        netdev@vger.kernel.org
Cc:     Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH iproute2-net 3/3] devlink: Add reload stats to dev show
Date:   Thu, 26 Nov 2020 13:14:56 +0200
Message-Id: <1606389296-3906-4-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
References: <1606389296-3906-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Show reload statistics through devlink dev show using devlink stats
flag. The reload statistics show the history per reload action type and
limit. Add remote reload statistics to show the history of actions
performed due devlink reload commands initiated by remote host.

Output examples:
$ devlink dev show -s
pci/0000:82:00.0:
  stats:
      reload:
          driver_reinit:
            unspecified 2
          fw_activate:
            unspecified 1 no_reset 0
      remote_reload:
          driver_reinit:
            unspecified 0
          fw_activate:
            unspecified 0 no_reset 0
pci/0000:82:00.1:
  stats:
      reload:
          driver_reinit:
            unspecified 0
          fw_activate:
            unspecified 0 no_reset 0
      remote_reload:
          driver_reinit:
            unspecified 1
          fw_activate:
            unspecified 1 no_reset 0

$ devlink dev show -s -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "stats": {
                "reload": {
                    "driver_reinit": {
                        "unspecified": 2
                    },
                    "fw_activate": {
                        "unspecified": 1,
                        "no_reset": 0
                    }
                },
                "remote_reload": {
                    "driver_reinit": {
                        "unspecified": 0
                    },
                    "fw_activate": {
                        "unspecified": 0,
                        "no_reset": 0
                    }
                }
            }
        },
        "pci/0000:82:00.1": {
            "stats": {
                "reload": {
                    "driver_reinit": {
                        "unspecified": 0
                    },
                    "fw_activate": {
                        "unspecified": 0,
                        "no_reset": 0
                    }
                },
                "remote_reload": {
                    "driver_reinit": {
                        "unspecified": 1
                    },
                    "fw_activate": {
                        "unspecified": 1,
                        "no_reset": 0
                    }
                }
            }
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c            | 102 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/devlink.h |   2 +
 2 files changed, 102 insertions(+), 2 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index bd588869..b588ba98 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -682,6 +682,15 @@ static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_TRAP_METADATA] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_GROUP_NAME] = MNL_TYPE_STRING,
 	[DEVLINK_ATTR_RELOAD_FAILED] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_DEV_STATS] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_RELOAD_STATS] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_RELOAD_STATS_ENTRY] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_RELOAD_ACTION] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_RELOAD_STATS_LIMIT] = MNL_TYPE_U8,
+	[DEVLINK_ATTR_RELOAD_STATS_VALUE] = MNL_TYPE_U32,
+	[DEVLINK_ATTR_REMOTE_RELOAD_STATS] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_RELOAD_ACTION_INFO] = MNL_TYPE_NESTED,
+	[DEVLINK_ATTR_RELOAD_ACTION_STATS] = MNL_TYPE_NESTED,
 	[DEVLINK_ATTR_TRAP_POLICER_ID] = MNL_TYPE_U32,
 	[DEVLINK_ATTR_TRAP_POLICER_RATE] = MNL_TYPE_U64,
 	[DEVLINK_ATTR_TRAP_POLICER_BURST] = MNL_TYPE_U64,
@@ -2370,6 +2379,18 @@ static const char *reload_action_name(uint8_t reload_action)
 	}
 }
 
+static const char *reload_limit_name(uint8_t reload_limit)
+{
+	switch (reload_limit) {
+	case DEVLINK_RELOAD_LIMIT_UNSPEC:
+		return "unspecified";
+	case DEVLINK_RELOAD_LIMIT_NO_RESET:
+		return "no_reset";
+	default:
+		return "<unknown reload action>";
+	}
+}
+
 static const char *eswitch_mode_name(uint32_t mode)
 {
 	switch (mode) {
@@ -2975,17 +2996,93 @@ static int cmd_dev_param(struct dl *dl)
 	return -ENOENT;
 }
 
-static void pr_out_dev(struct dl *dl, struct nlattr **tb)
+static void pr_out_action_stats(struct dl *dl, struct nlattr *action_stats)
+{
+	struct nlattr *tb_stats_entry[DEVLINK_ATTR_MAX + 1] = {};
+	struct nlattr *reload_stats_entry;
+	enum devlink_reload_limit limit;
+	uint32_t value;
+	int err;
+
+	mnl_attr_for_each_nested(reload_stats_entry, action_stats) {
+		err = mnl_attr_parse_nested(reload_stats_entry, attr_cb, tb_stats_entry);
+		if (err != MNL_CB_OK)
+			return;
+		if (!tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_LIMIT] ||
+		    !tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_VALUE])
+			return;
+
+		check_indent_newline(dl);
+		limit = mnl_attr_get_u8(tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_LIMIT]);
+		value = mnl_attr_get_u32(tb_stats_entry[DEVLINK_ATTR_RELOAD_STATS_VALUE]);
+		print_uint_name_value(reload_limit_name(limit), value);
+	}
+}
+
+static void pr_out_reload_stats(struct dl *dl, struct nlattr *reload_stats)
+{
+	struct nlattr *tb_action_info[DEVLINK_ATTR_MAX + 1] = {};
+	enum devlink_reload_action action;
+	struct nlattr *action_info;
+	int err;
+
+	mnl_attr_for_each_nested(action_info, reload_stats) {
+		err = mnl_attr_parse_nested(action_info, attr_cb, tb_action_info);
+		if (err != MNL_CB_OK)
+			return;
+		if (!tb_action_info[DEVLINK_ATTR_RELOAD_ACTION] ||
+		    !tb_action_info[DEVLINK_ATTR_RELOAD_ACTION_STATS])
+			return;
+
+		action = mnl_attr_get_u8(tb_action_info[DEVLINK_ATTR_RELOAD_ACTION]);
+		pr_out_object_start(dl, reload_action_name(action));
+		pr_out_action_stats(dl, tb_action_info[DEVLINK_ATTR_RELOAD_ACTION_STATS]);
+		pr_out_object_end(dl);
+	}
+}
+
+static void pr_out_reload_data(struct dl *dl, struct nlattr **tb)
 {
+	struct nlattr *tb_stats[DEVLINK_ATTR_MAX + 1] = {};
 	uint8_t reload_failed = 0;
+	int err;
 
 	if (tb[DEVLINK_ATTR_RELOAD_FAILED])
 		reload_failed = mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED]);
 
 	if (reload_failed) {
-		__pr_out_handle_start(dl, tb, true, false);
 		check_indent_newline(dl);
 		print_bool(PRINT_ANY, "reload_failed", "reload_failed %s", true);
+	}
+	if (!tb[DEVLINK_ATTR_DEV_STATS] || !dl->stats)
+		return;
+	err = mnl_attr_parse_nested(tb[DEVLINK_ATTR_DEV_STATS], attr_cb, tb_stats);
+	if (err != MNL_CB_OK)
+		return;
+
+	pr_out_object_start(dl, "stats");
+
+	if (tb_stats[DEVLINK_ATTR_RELOAD_STATS]) {
+		pr_out_object_start(dl, "reload");
+		pr_out_reload_stats(dl, tb_stats[DEVLINK_ATTR_RELOAD_STATS]);
+		pr_out_object_end(dl);
+	}
+	if (tb_stats[DEVLINK_ATTR_REMOTE_RELOAD_STATS]) {
+		pr_out_object_start(dl, "remote_reload");
+		pr_out_reload_stats(dl, tb_stats[DEVLINK_ATTR_REMOTE_RELOAD_STATS]);
+		pr_out_object_end(dl);
+	}
+
+	pr_out_object_end(dl);
+}
+
+
+static void pr_out_dev(struct dl *dl, struct nlattr **tb)
+{
+	if ((tb[DEVLINK_ATTR_RELOAD_FAILED] && mnl_attr_get_u8(tb[DEVLINK_ATTR_RELOAD_FAILED])) ||
+	    (tb[DEVLINK_ATTR_DEV_STATS] && dl->stats)) {
+		__pr_out_handle_start(dl, tb, true, false);
+		pr_out_reload_data(dl, tb);
 		pr_out_handle_end(dl);
 	} else {
 		pr_out_handle(dl, tb);
@@ -4844,6 +4941,7 @@ static int cmd_mon_show_cb(const struct nlmsghdr *nlh, void *data)
 		if (!tb[DEVLINK_ATTR_BUS_NAME] || !tb[DEVLINK_ATTR_DEV_NAME])
 			return MNL_CB_ERROR;
 		pr_out_mon_header(genl->cmd);
+		dl->stats = true;
 		pr_out_dev(dl, tb);
 		pr_out_mon_footer();
 		break;
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index e639a4e5..6ffa0121 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -526,6 +526,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_STATS_LIMIT,	/* u8 */
 	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
 	DEVLINK_ATTR_REMOTE_RELOAD_STATS,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_INFO,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_STATS,	/* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
-- 
2.18.2

