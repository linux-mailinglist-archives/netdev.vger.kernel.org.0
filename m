Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AECCDF68DE
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 13:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbfKJMMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 07:12:17 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:35916 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726641AbfKJMMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 07:12:16 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 10 Nov 2019 14:12:14 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xAACCESD002363;
        Sun, 10 Nov 2019 14:12:14 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id xAACCEwg016761;
        Sun, 10 Nov 2019 14:12:14 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id xAACCC44016760;
        Sun, 10 Nov 2019 14:12:12 +0200
From:   Aya Levin <ayal@mellanox.com>
To:     David Miller <davem@davemloft.net>, Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>
Subject: [PATCH net V2] devlink: Add method for time-stamp on reporter's dump
Date:   Sun, 10 Nov 2019 14:11:56 +0200
Message-Id: <1573387916-16717-1-git-send-email-ayal@mellanox.com>
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
Changelog:
v1 -> v2: Rebased against net

 include/uapi/linux/devlink.h | 1 +
 net/core/devlink.c           | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 580b7a2e40e1..a8a2174db030 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -421,6 +421,7 @@ enum devlink_attr {
 
 	DEVLINK_ATTR_RELOAD_FAILED,			/* u8 0 or 1 */
 
+	DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,	/* u64 */
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index f80151eeaf51..e15335b949fa 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4618,6 +4618,7 @@ struct devlink_health_reporter {
 	bool auto_recover;
 	u8 health_state;
 	u64 dump_ts;
+	u64 dump_real_ts;
 	u64 error_count;
 	u64 recovery_count;
 	u64 last_recovery_ts;
@@ -4790,6 +4791,7 @@ static int devlink_health_do_dump(struct devlink_health_reporter *reporter,
 		goto dump_err;
 
 	reporter->dump_ts = jiffies;
+	reporter->dump_real_ts = ktime_get_real_ns();
 
 	return 0;
 
@@ -4952,6 +4954,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
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

