Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFA33F2B96
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 10:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387983AbfKGJ4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 04:56:17 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:50580 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727926AbfKGJ4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 04:56:16 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 7 Nov 2019 11:56:12 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA79uCCB016418;
        Thu, 7 Nov 2019 11:56:12 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xA79uCSa003933;
        Thu, 7 Nov 2019 11:56:12 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xA79uBYs003931;
        Thu, 7 Nov 2019 11:56:11 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net] devlink: Add method for time-stamp on reporter's dump
Date:   Thu,  7 Nov 2019 11:55:53 +0200
Message-Id: <1573120553-3887-1-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting the dump's time-stamp, use ktime_get_real in addition to
jiffies. This simplifies the user space implementation and bypasses
some inconsistent behavior with translating jiffies to current time.
The time taken is transformed into nsec, to comply with y2038 issue.

Fixes: c8e1da0bf923 ("devlink: Add health report functionality")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---
 include/uapi/linux/devlink.h | 1 +
 net/core/devlink.c           | 6 ++++++
 2 files changed, 7 insertions(+)

Please queue for -stable >= v5.1.

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b558ea88b766..45501ef372a8 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -424,6 +424,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_FD,			/* u32 */
 	DEVLINK_ATTR_NETNS_PID,			/* u32 */
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
+	DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,	/* u64 */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..876fbd0f949d 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4733,6 +4733,7 @@ struct devlink_health_reporter {
 	bool auto_recover;
 	u8 health_state;
 	u64 dump_ts;
+	u64 dump_real_ts;
 	u64 error_count;
 	u64 recovery_count;
 	u64 last_recovery_ts;
@@ -4909,6 +4910,7 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 		goto dump_err;
 
 	reporter->dump_ts = jiffies;
+	reporter->dump_real_ts = ktime_get_real_ns();
 
 	return 0;
 
@@ -5058,6 +5060,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
 			      jiffies_to_msecs(reporter->dump_ts),
 			      DEVLINK_ATTR_PAD))
 		goto reporter_nest_cancel;
+	if (reporter->dump_fmsg &&
+	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
+			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
+		goto reporter_nest_cancel;
 
 	nla_nest_end(msg, reporter_attr);
 	genlmsg_end(msg, hdr);
-- 
2.14.1

