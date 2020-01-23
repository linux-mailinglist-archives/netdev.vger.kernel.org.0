Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB60714702A
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 18:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729098AbgAWR6B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 12:58:01 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:42834 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728731AbgAWR56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 12:57:58 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 19:57:55 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NHvtqD024477;
        Thu, 23 Jan 2020 19:57:55 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 00NHvtkn027292;
        Thu, 23 Jan 2020 19:57:55 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 00NHvsUM027291;
        Thu, 23 Jan 2020 19:57:54 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2] devlink: Add health recover notifications on devlink flows
Date:   Thu, 23 Jan 2020 19:57:13 +0200
Message-Id: <1579802233-27224-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink health recover notifications were added only on driver direct
updates of health_state through devlink_health_reporter_state_update().
Add notifications on updates of health_state by devlink flows of report
and recover.

Moved functions devlink_nl_health_reporter_fill() and
devlink_recover_notify() to avoid forward declaration.

Fixes: 97ff3bd37fac ("devlink: add devink notification when reporter update health state")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---

v2 changes:
 - Move functions to avoid forward declaration
---
 net/core/devlink.c | 176 +++++++++++++++++++++++----------------------
 1 file changed, 89 insertions(+), 87 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 64367eeb21e6..ca1df0ec3c97 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4843,6 +4843,93 @@ devlink_health_reporter_destroy(struct devlink_health_reporter *reporter)
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_destroy);
 
+static int
+devlink_nl_health_reporter_fill(struct sk_buff *msg,
+				struct devlink *devlink,
+				struct devlink_health_reporter *reporter,
+				enum devlink_command cmd, u32 portid,
+				u32 seq, int flags)
+{
+	struct nlattr *reporter_attr;
+	void *hdr;
+
+	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto genlmsg_cancel;
+
+	reporter_attr = nla_nest_start_noflag(msg,
+					      DEVLINK_ATTR_HEALTH_REPORTER);
+	if (!reporter_attr)
+		goto genlmsg_cancel;
+	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
+			   reporter->ops->name))
+		goto reporter_nest_cancel;
+	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
+		       reporter->health_state))
+		goto reporter_nest_cancel;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT,
+			      reporter->error_count, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT,
+			      reporter->recovery_count, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->recover &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD,
+			      reporter->graceful_period,
+			      DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->ops->recover &&
+	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
+		       reporter->auto_recover))
+		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS,
+			      jiffies_to_msecs(reporter->dump_ts),
+			      DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
+			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
+
+	nla_nest_end(msg, reporter_attr);
+	genlmsg_end(msg, hdr);
+	return 0;
+
+reporter_nest_cancel:
+	nla_nest_end(msg, reporter_attr);
+genlmsg_cancel:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void devlink_recover_notify(struct devlink_health_reporter *reporter,
+				   enum devlink_command cmd)
+{
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_health_reporter_fill(msg, reporter->devlink,
+					      reporter, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family,
+				devlink_net(reporter->devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
 void
 devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter)
 {
@@ -4869,6 +4956,7 @@ devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 
 	devlink_health_reporter_recovery_done(reporter);
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	return 0;
 }
@@ -4935,6 +5023,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	reporter->error_count++;
 	prev_health_state = reporter->health_state;
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	/* abort if the previous error wasn't recovered */
 	if (reporter->auto_recover &&
@@ -5017,93 +5106,6 @@ devlink_health_reporter_put(struct devlink_health_reporter *reporter)
 	refcount_dec(&reporter->refcount);
 }
 
-static int
-devlink_nl_health_reporter_fill(struct sk_buff *msg,
-				struct devlink *devlink,
-				struct devlink_health_reporter *reporter,
-				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags)
-{
-	struct nlattr *reporter_attr;
-	void *hdr;
-
-	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
-	if (!hdr)
-		return -EMSGSIZE;
-
-	if (devlink_nl_put_handle(msg, devlink))
-		goto genlmsg_cancel;
-
-	reporter_attr = nla_nest_start_noflag(msg,
-					      DEVLINK_ATTR_HEALTH_REPORTER);
-	if (!reporter_attr)
-		goto genlmsg_cancel;
-	if (nla_put_string(msg, DEVLINK_ATTR_HEALTH_REPORTER_NAME,
-			   reporter->ops->name))
-		goto reporter_nest_cancel;
-	if (nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_STATE,
-		       reporter->health_state))
-		goto reporter_nest_cancel;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT,
-			      reporter->error_count, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT,
-			      reporter->recovery_count, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->recover &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD,
-			      reporter->graceful_period,
-			      DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->ops->recover &&
-	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER,
-		       reporter->auto_recover))
-		goto reporter_nest_cancel;
-	if (reporter->dump_fmsg &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS,
-			      jiffies_to_msecs(reporter->dump_ts),
-			      DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-	if (reporter->dump_fmsg &&
-	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
-			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
-		goto reporter_nest_cancel;
-
-	nla_nest_end(msg, reporter_attr);
-	genlmsg_end(msg, hdr);
-	return 0;
-
-reporter_nest_cancel:
-	nla_nest_end(msg, reporter_attr);
-genlmsg_cancel:
-	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
-}
-
-static void devlink_recover_notify(struct devlink_health_reporter *reporter,
-				   enum devlink_command cmd)
-{
-	struct sk_buff *msg;
-	int err;
-
-	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (!msg)
-		return;
-
-	err = devlink_nl_health_reporter_fill(msg, reporter->devlink,
-					      reporter, cmd, 0, 0, 0);
-	if (err) {
-		nlmsg_free(msg);
-		return;
-	}
-
-	genlmsg_multicast_netns(&devlink_nl_family,
-				devlink_net(reporter->devlink),
-				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
-}
-
 void
 devlink_health_reporter_state_update(struct devlink_health_reporter *reporter,
 				     enum devlink_health_reporter_state state)
-- 
2.17.1

