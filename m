Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274899919D
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732586AbfHVLFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 07:05:54 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33431 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732536AbfHVLFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 07:05:54 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Aug 2019 14:05:48 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.134.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x7MB5mUf016288;
        Thu, 22 Aug 2019 14:05:48 +0300
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id x7MB5mC6028570;
        Thu, 22 Aug 2019 14:05:48 +0300
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id x7MB5mHb028569;
        Thu, 22 Aug 2019 14:05:48 +0300
From:   Aya Levin <ayal@mellanox.com>
To:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>, Aya Levin <ayal@mellanox.com>
Subject: [iproute2, master 1/2] devlink: Print health reporter's dump time-stamp in a helper function
Date:   Thu, 22 Aug 2019 14:05:41 +0300
Message-Id: <1566471942-28529-2-git-send-email-ayal@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1566471942-28529-1-git-send-email-ayal@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
 <1566471942-28529-1-git-send-email-ayal@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pr_out_dump_reporter prefix to the helper function's name and
encapsulate the print in it.

Fixes: 2f1242efe9d0 ("devlink: Add devlink health show command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 055eca5d4662..f1d9de8e151d 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6169,8 +6169,11 @@ static const char *health_state_name(uint8_t state)
 	}
 }
 
-static void format_logtime(uint64_t time_ms, char *ts_date, char *ts_time)
+static void pr_out_dump_reporter_format_logtime(struct dl *dl, const struct nlattr *attr)
 {
+	char dump_date[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
+	char dump_time[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
+	uint64_t time_ms = mnl_attr_get_u64(attr);
 	struct sysinfo s_info;
 	struct tm *info;
 	time_t now, sec;
@@ -6188,16 +6191,16 @@ static void format_logtime(uint64_t time_ms, char *ts_date, char *ts_time)
 	sec = now - s_info.uptime + time_ms / 1000;
 	info = localtime(&sec);
 out:
-	strftime(ts_date, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%Y-%m-%d", info);
-	strftime(ts_time, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%H:%M:%S", info);
+	strftime(dump_date, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%Y-%m-%d", info);
+	strftime(dump_time, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%H:%M:%S", info);
+	pr_out_str(dl, "last_dump_date", dump_date);
+	pr_out_str(dl, "last_dump_time", dump_time);
 }
 
 static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 {
 	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
 	enum devlink_health_reporter_state state;
-	const struct nlattr *attr;
-	uint64_t time_ms;
 	int err;
 
 	err = mnl_attr_parse_nested(tb_health[DEVLINK_ATTR_HEALTH_REPORTER],
@@ -6225,17 +6228,8 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT]));
 	pr_out_u64(dl, "recover",
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT]));
-	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS]) {
-		char dump_date[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
-		char dump_time[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
-
-		attr = tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS];
-		time_ms = mnl_attr_get_u64(attr);
-		format_logtime(time_ms, dump_date, dump_time);
-
-		pr_out_str(dl, "last_dump_date", dump_date);
-		pr_out_str(dl, "last_dump_time", dump_time);
-	}
+	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS])
+		pr_out_dump_reporter_format_logtime(dl, tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS]);
 	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		pr_out_u64(dl, "grace_period",
 			   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD]));
-- 
2.14.1

