Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0D72BFFA9
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 06:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbgKWFgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 00:36:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:36270 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726265AbgKWFgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 00:36:49 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 23 Nov 2020 07:36:43 +0200
Received: from vnc1.mtl.labs.mlnx (vnc1.mtl.labs.mlnx [10.7.2.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AN5ahTA000721;
        Mon, 23 Nov 2020 07:36:43 +0200
Received: from vnc1.mtl.labs.mlnx (localhost [127.0.0.1])
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4) with ESMTP id 0AN5ahth025283;
        Mon, 23 Nov 2020 07:36:43 +0200
Received: (from moshe@localhost)
        by vnc1.mtl.labs.mlnx (8.14.4/8.14.4/Submit) id 0AN5abhC025268;
        Mon, 23 Nov 2020 07:36:37 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net v2] devlink: Fix reload stats structure
Date:   Mon, 23 Nov 2020 07:36:25 +0200
Message-Id: <1606109785-25197-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix reload stats structure exposed to the user. Change stats structure
hierarchy to have the reload action as a parent of the stat entry and
then stat entry includes value per limit. This will also help to avoid
string concatenation on iproute2 output.

Reload stats structure before this fix:
"stats": {
    "reload": {
        "driver_reinit": 2,
        "fw_activate": 1,
        "fw_activate_no_reset": 0
     }
}

After this fix:
"stats": {
    "reload": {
        "driver_reinit": {
            "unspecified": 2
        },
        "fw_activate": {
            "unspecified": 1,
            "no_reset": 0
        }
}

Fixes: a254c264267e ("devlink: Add reload stats")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
v1 -> v2:
- Fold comment at 80 characters.
---
 include/uapi/linux/devlink.h |  2 ++
 net/core/devlink.c           | 49 +++++++++++++++++++++++-------------
 2 files changed, 34 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 0113bc4db9f5..5203f54a2be1 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -526,6 +526,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_RELOAD_STATS_LIMIT,	/* u8 */
 	DEVLINK_ATTR_RELOAD_STATS_VALUE,	/* u32 */
 	DEVLINK_ATTR_REMOTE_RELOAD_STATS,	/* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_INFO,        /* nested */
+	DEVLINK_ATTR_RELOAD_ACTION_STATS,       /* nested */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index e6fb1fdedded..bf79d018990c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -517,8 +517,7 @@ devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_l
 	return test_bit(limit, &devlink->ops->reload_limits);
 }
 
-static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
-				   enum devlink_reload_limit limit, u32 value)
+static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_limit limit, u32 value)
 {
 	struct nlattr *reload_stats_entry;
 
@@ -526,8 +525,7 @@ static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_acti
 	if (!reload_stats_entry)
 		return -EMSGSIZE;
 
-	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action) ||
-	    nla_put_u8(msg, DEVLINK_ATTR_RELOAD_STATS_LIMIT, limit) ||
+	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_STATS_LIMIT, limit) ||
 	    nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
 		goto nla_put_failure;
 	nla_nest_end(msg, reload_stats_entry);
@@ -540,7 +538,7 @@ static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_acti
 
 static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink, bool is_remote)
 {
-	struct nlattr *reload_stats_attr;
+	struct nlattr *reload_stats_attr, *action_info_attr, *action_stats_attr;
 	int i, j, stat_idx;
 	u32 value;
 
@@ -552,17 +550,28 @@ static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink
 	if (!reload_stats_attr)
 		return -EMSGSIZE;
 
-	for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
-		/* Remote stats are shown even if not locally supported. Stats
-		 * of actions with unspecified limit are shown though drivers
-		 * don't need to register unspecified limit.
-		 */
-		if (!is_remote && j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
-		    !devlink_reload_limit_is_supported(devlink, j))
+	for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
+		if ((!is_remote && !devlink_reload_action_is_supported(devlink, i)) ||
+		    i == DEVLINK_RELOAD_ACTION_UNSPEC)
 			continue;
-		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
-			if ((!is_remote && !devlink_reload_action_is_supported(devlink, i)) ||
-			    i == DEVLINK_RELOAD_ACTION_UNSPEC ||
+		action_info_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_INFO);
+		if (!action_info_attr)
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
+			goto action_info_nest_cancel;
+		action_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
+		if (!action_stats_attr)
+			goto action_info_nest_cancel;
+
+		for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
+			/* Remote stats are shown even if not locally supported.
+			 * Stats of actions with unspecified limit are shown
+			 * though drivers don't need to register unspecified
+			 * limit.
+			 */
+			if ((!is_remote && j != DEVLINK_RELOAD_LIMIT_UNSPEC &&
+			     !devlink_reload_limit_is_supported(devlink, j)) ||
 			    devlink_reload_combination_is_invalid(i, j))
 				continue;
 
@@ -571,13 +580,19 @@ static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink
 				value = devlink->stats.reload_stats[stat_idx];
 			else
 				value = devlink->stats.remote_reload_stats[stat_idx];
-			if (devlink_reload_stat_put(msg, i, j, value))
-				goto nla_put_failure;
+			if (devlink_reload_stat_put(msg, j, value))
+				goto action_stats_nest_cancel;
 		}
+		nla_nest_end(msg, action_stats_attr);
+		nla_nest_end(msg, action_info_attr);
 	}
 	nla_nest_end(msg, reload_stats_attr);
 	return 0;
 
+action_stats_nest_cancel:
+	nla_nest_cancel(msg, action_stats_attr);
+action_info_nest_cancel:
+	nla_nest_cancel(msg, action_info_attr);
 nla_put_failure:
 	nla_nest_cancel(msg, reload_stats_attr);
 	return -EMSGSIZE;
-- 
2.18.2

