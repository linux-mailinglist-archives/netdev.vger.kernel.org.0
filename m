Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2CD4141EB5
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbgASPEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:04:52 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37670 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726778AbgASPEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:04:51 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 19 Jan 2020 17:04:48 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00JF4mPF007486;
        Sun, 19 Jan 2020 17:04:48 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 00JF4m5D026590;
        Sun, 19 Jan 2020 17:04:48 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 00JF4iXd026587;
        Sun, 19 Jan 2020 17:04:44 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        Vikas Gupta <vikas.gupta@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next] devlink: Add health recover notifications on devlink flows
Date:   Sun, 19 Jan 2020 17:04:28 +0200
Message-Id: <1579446268-26540-1-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink health recover notifications were added only on driver direct
updates of health_state through devlink_health_reporter_state_update().
Add notifications on updates of health_state by devlink flows of report
and recover.

Fixes: 97ff3bd37fac ("devlink: add devink notification when reporter update health state")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index b41b2e3..99f2057 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4851,6 +4851,9 @@ struct devlink_health_reporter *
 }
 EXPORT_SYMBOL_GPL(devlink_health_reporter_recovery_done);
 
+static void devlink_recover_notify(struct devlink_health_reporter *reporter,
+				   enum devlink_command cmd);
+
 static int
 devlink_health_reporter_recover(struct devlink_health_reporter *reporter,
 				void *priv_ctx, struct netlink_ext_ack *extack)
@@ -4869,6 +4872,7 @@ struct devlink_health_reporter *
 
 	devlink_health_reporter_recovery_done(reporter);
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	return 0;
 }
@@ -4935,6 +4939,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	reporter->error_count++;
 	prev_health_state = reporter->health_state;
 	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
+	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	/* abort if the previous error wasn't recovered */
 	if (reporter->auto_recover &&
-- 
1.8.3.1

