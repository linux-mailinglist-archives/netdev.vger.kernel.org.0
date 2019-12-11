Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4038911B422
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387462AbfLKPqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:46:14 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43804 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732292AbfLKPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:46:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Dec 2019 17:46:07 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xBBFk7xZ022467;
        Wed, 11 Dec 2019 17:46:07 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        jiri@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 1/3] devlink: Print health reporter's dump time-stamp in a helper function
Date:   Wed, 11 Dec 2019 17:45:34 +0200
Message-Id: <20191211154536.5701-2-tariqt@mellanox.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191211154536.5701-1-tariqt@mellanox.com>
References: <20191211154536.5701-1-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add pr_out_dump_reporter prefix to the helper function's name and
encapsulate the print in it.

Fixes: 2f1242efe9d0 ("devlink: Add devlink health show command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 0b8985f32636..aee6c87cbce7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6654,8 +6654,11 @@ static const char *health_state_name(uint8_t state)
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
@@ -6673,16 +6676,16 @@ static void format_logtime(uint64_t time_ms, char *ts_date, char *ts_time)
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
@@ -6710,17 +6713,8 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
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
2.21.0

