Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7875F2800A5
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 16:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732527AbgJAOAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 10:00:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36619 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732440AbgJAOAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 10:00:30 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 1 Oct 2020 17:00:24 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 091E0OCR001830;
        Thu, 1 Oct 2020 17:00:24 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 091E0Ol0011167;
        Thu, 1 Oct 2020 17:00:24 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 091E0OSm011166;
        Thu, 1 Oct 2020 17:00:24 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next 04/16] devlink: Add reload stats
Date:   Thu,  1 Oct 2020 16:59:07 +0300
Message-Id: <1601560759-11030-5-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add reload stats to hold the history per reload action type and limit.

For example, the number of times fw_activate has been performed on this
device since the driver module was added or if the firmware activation
was performed with or without reset.

Add devlink notification on stats update.

Expose devlink reload stats to the user through devlink dev get command.

Examples:
$ devlink dev show
pci/0000:82:00.0:
  stats:
      reload_stats:
        driver_reinit 2
        fw_activate 1
        fw_activate_no_reset 0
pci/0000:82:00.1:
  stats:
      reload_stats:
        driver_reinit 1
        fw_activate 0
        fw_activate_no_reset 0

$ devlink dev show -jp
{
    "dev": {
        "pci/0000:82:00.0": {
            "stats": {
                "reload_stats": [ {
                        "driver_reinit": 2
                    },{
                        "fw_activate": 1
                    },{
                        "fw_activate_no_reset": 0
                    } ]
            }
        },
        "pci/0000:82:00.1": {
            "stats": {
                "reload_stats": [ {
                        "driver_reinit": 1
                    },{
                        "fw_activate": 0
                    },{
                        "fw_activate_no_reset": 0
                    } ]
            }
        }
    }
}

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
RFCv5 -> v1:
- Changed the stats output structure, have 2 stats, one for local and
one for remote
- Resplit this patch and the next one by remote/local reload stast
instead of set/get reload stats
- Add helper function devlink_reload_stats_put()
RFCv4 -> RFCv5:
- Add separate reload action stats for updating on remote actions
- Protect  from updating remote actions stats during reload_down()/up()
RFCv3 -> RFCv4:
- Renamed reload_actions_cnts to reload_action_stats
- Add devlink notifications on stats update
- Renamed devlink_reload_actions_implicit_actions_performed() and add
  function comment in code
RFCv2 -> RFCv3:
- New patch
---
 include/net/devlink.h        |  7 +++
 include/uapi/linux/devlink.h |  5 ++
 net/core/devlink.c           | 97 ++++++++++++++++++++++++++++++++++++
 3 files changed, 109 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 43dde69086e5..0f3bd23b6c04 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -20,6 +20,9 @@
 #include <uapi/linux/devlink.h>
 #include <linux/xarray.h>
 
+#define DEVLINK_RELOAD_STATS_ARRAY_SIZE \
+	(__DEVLINK_RELOAD_LIMIT_MAX * __DEVLINK_RELOAD_ACTION_MAX)
+
 struct devlink_ops;
 
 struct devlink {
@@ -38,6 +41,7 @@ struct devlink {
 	struct list_head trap_policer_list;
 	const struct devlink_ops *ops;
 	struct xarray snapshot_ids;
+	u32 reload_stats[DEVLINK_RELOAD_STATS_ARRAY_SIZE];
 	struct device *dev;
 	possible_net_t _net;
 	struct mutex lock; /* Serializes access to devlink instance specific objects such as
@@ -1470,6 +1474,9 @@ void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
 
 bool devlink_is_reload_failed(const struct devlink *devlink);
+void devlink_remote_reload_actions_performed(struct devlink *devlink,
+					     enum devlink_reload_limit limit,
+					     unsigned long actions_performed);
 
 void devlink_flash_update_begin_notify(struct devlink *devlink);
 void devlink_flash_update_end_notify(struct devlink *devlink);
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index cc5dc4c07b4a..97e0137f6201 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -526,6 +526,11 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* u64 */
 	DEVLINK_ATTR_RELOAD_LIMIT,	/* u8 */
 
+	DEVLINK_ATTR_DEV_STATS,			/* nested */
+	DEVLINK_ATTR_RELOAD_STATS,		/* nested */
+	DEVLINK_ATTR_RELOAD_STATS_ENTRY,	/* nested */
+	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6de7d6aa6ed1..05516f1e4c3e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -500,10 +500,68 @@ devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_l
 	return test_bit(limit, &devlink->ops->reload_limits);
 }
 
+static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
+				   enum devlink_reload_limit limit, u32 value)
+{
+	struct nlattr *reload_stats_entry;
+
+	reload_stats_entry = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS_ENTRY);
+	if (!reload_stats_entry)
+		return -EMSGSIZE;
+
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
+		goto nla_put_failure;
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_LIMIT, limit))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
+		goto nla_put_failure;
+	nla_nest_end(msg, reload_stats_entry);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, reload_stats_entry);
+	return -EMSGSIZE;
+}
+
+static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink)
+{
+	struct nlattr *reload_stats_attr;
+	int i, j, stat_idx;
+	u32 value;
+
+	reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
+
+	if (!reload_stats_attr)
+		return -EMSGSIZE;
+
+	for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
+		if (j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
+		    !devlink_reload_limit_is_supported(devlink, j))
+			continue;
+		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+			if (!devlink_reload_action_is_supported(devlink, i) ||
+			    devlink_reload_combination_is_invalid(i, j))
+				continue;
+
+			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
+			value = devlink->reload_stats[stat_idx];
+			if (devlink_reload_stat_put(msg, i, j, value))
+				goto nla_put_failure;
+		}
+	}
+	nla_nest_end(msg, reload_stats_attr);
+	return 0;
+
+nla_put_failure:
+	nla_nest_cancel(msg, reload_stats_attr);
+	return -EMSGSIZE;
+}
+
 static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 			   enum devlink_command cmd, u32 portid,
 			   u32 seq, int flags)
 {
+	struct nlattr *dev_stats;
 	void *hdr;
 
 	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
@@ -515,9 +573,19 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
 		goto nla_put_failure;
 
+	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);
+	if (!dev_stats)
+		goto nla_put_failure;
+
+	if (devlink_reload_stats_put(msg, devlink))
+		goto dev_stats_nest_cancel;
+
+	nla_nest_end(msg, dev_stats);
 	genlmsg_end(msg, hdr);
 	return 0;
 
+dev_stats_nest_cancel:
+	nla_nest_cancel(msg, dev_stats);
 nla_put_failure:
 	genlmsg_cancel(msg, hdr);
 	return -EMSGSIZE;
@@ -3004,6 +3072,34 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
 }
 EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
 
+static void
+__devlink_reload_stats_update(struct devlink *devlink, u32 *reload_stats,
+			      enum devlink_reload_limit limit, unsigned long actions_performed)
+{
+	int stat_idx;
+	int action;
+
+	if (!actions_performed)
+		return;
+
+	if (WARN_ON(limit > DEVLINK_RELOAD_LIMIT_MAX))
+		return;
+	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
+		if (!test_bit(action, &actions_performed))
+			continue;
+		stat_idx = limit * __DEVLINK_RELOAD_ACTION_MAX + action;
+		reload_stats[stat_idx]++;
+	}
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
+}
+
+static void
+devlink_reload_stats_update(struct devlink *devlink, enum devlink_reload_limit limit,
+			    unsigned long actions_performed)
+{
+	__devlink_reload_stats_update(devlink, devlink->reload_stats, limit, actions_performed);
+}
+
 static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 			  enum devlink_reload_action action, enum devlink_reload_limit limit,
 			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
@@ -3026,6 +3122,7 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
 		return err;
 
 	WARN_ON(!test_bit(action, actions_performed));
+	devlink_reload_stats_update(devlink, limit, *actions_performed);
 	return 0;
 }
 
-- 
2.18.2

