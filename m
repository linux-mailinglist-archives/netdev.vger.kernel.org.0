Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6CC1C3460
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 10:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgEDI15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 04:27:57 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47876 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725941AbgEDI15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 04:27:57 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 4 May 2020 11:27:54 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0448Rsrc006040;
        Mon, 4 May 2020 11:27:54 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 0448Rs13018143;
        Mon, 4 May 2020 11:27:54 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 0448RrbH018142;
        Mon, 4 May 2020 11:27:53 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>
Subject: [PATCH net] devlink: Fix reporter's recovery condition
Date:   Mon,  4 May 2020 11:27:46 +0300
Message-Id: <1588580866-18098-1-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink health core conditions the reporter's recovery with the
expiration of the grace period. This is not relevant for the first
recovery. Explicitly demand that the grace period will only apply to
recoveries other than the first.

Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 80f97722f31f..4a802b9377e3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -5363,6 +5363,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 {
 	enum devlink_health_reporter_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
+	unsigned long recover_ts_threshold;
 
 	/* write a log message of the current error */
 	WARN_ON(!msg);
@@ -5373,10 +5374,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	devlink_recover_notify(reporter, DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
 
 	/* abort if the previous error wasn't recovered */
+	recover_ts_threshold = reporter->last_recovery_ts +
+			       msecs_to_jiffies(reporter->graceful_period);
 	if (reporter->auto_recover &&
 	    (prev_health_state != DEVLINK_HEALTH_REPORTER_STATE_HEALTHY ||
-	     jiffies - reporter->last_recovery_ts <
-	     msecs_to_jiffies(reporter->graceful_period))) {
+	     (reporter->last_recovery_ts && reporter->recovery_count &&
+	      time_is_after_jiffies(recover_ts_threshold)))) {
 		trace_devlink_health_recover_aborted(devlink,
 						     reporter->ops->name,
 						     reporter->health_state,
-- 
2.14.1

