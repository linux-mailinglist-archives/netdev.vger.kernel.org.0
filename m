Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6AB9919B
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388004AbfHVLFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 07:05:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33432 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729922AbfHVLFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 07:05:54 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 14:05:49 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MB5n1N016291;
        Thu, 22 Aug 2019 14:05:49 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id x7MB5nZx028572;
        Thu, 22 Aug 2019 14:05:49 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id x7MB5nDq028571;
        Thu, 22 Aug 2019 14:05:49 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>, Aya Levin <ayal@mellanox.com>
Subject: [iproute2, master 2/2] devlink: Add a new time-stamp format for health reporter's dump
Date:   Thu, 22 Aug 2019 14:05:42 +0300
Message-Id: <1566471942-28529-3-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1566471942-28529-1-git-send-email-ayal@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
 <1566471942-28529-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new attribute representing a new time-stamp format: current
time instead of jiffies. If the new attribute was received, translate
the time-stamp accordingly.

Fixes: 2f1242efe9d0 ("devlink: Add devlink health show command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c            | 20 +++++++++++++++++++-
 include/uapi/linux/devlink.h |  2 ++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index f1d9de8e151d..623d1b52c4ca 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6197,6 +6197,22 @@ out:
 	pr_out_str(dl, "last_dump_time", dump_time);
 }
 
+static void pr_out_dump_report_timestamp(struct dl *dl, const struct nlattr *attr)
+{
+	char dump_date[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
+	char dump_time[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
+	struct timespec *ts = mnl_attr_get_payload(attr);
+	struct tm *tm;
+
+	tm = localtime(&ts->tv_sec);
+
+	strftime(dump_date, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%Y-%m-%d", tm);
+	strftime(dump_time, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%H:%M:%S", tm);
+
+	pr_out_str(dl, "last_dump_date", dump_date);
+	pr_out_str(dl, "last_dump_time", dump_time);
+}
+
 static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
@@ -6228,7 +6244,9 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT]));
 	pr_out_u64(dl, "recover",
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT]));
-	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS])
+	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TSPEC])
+		pr_out_dump_report_timestamp(dl, tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TSPEC]);
+	else if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS])
 		pr_out_dump_reporter_format_logtime(dl, tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS]);
 	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		pr_out_u64(dl, "grace_period",
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index fc195cbd66f4..3f8532711315 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -348,6 +348,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_PORT_PCI_PF_NUMBER,	/* u16 */
 	DEVLINK_ATTR_PORT_PCI_VF_NUMBER,	/* u16 */
 
+	DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TSPEC,
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
-- 
2.14.1

