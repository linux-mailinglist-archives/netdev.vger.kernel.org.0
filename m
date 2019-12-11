Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B39011B43D
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 16:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388670AbfLKPqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 10:46:11 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:43819 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732896AbfLKPqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 10:46:10 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 11 Dec 2019 17:46:07 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.134.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xBBFk7xa022467;
        Wed, 11 Dec 2019 17:46:07 +0200
From:   Tariq Toukan <tariqt@mellanox.com>
To:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, ayal@mellanox.com, moshe@mellanox.com,
        jiri@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 2/3] devlink: Add a new time-stamp format for health reporter's dump
Date:   Wed, 11 Dec 2019 17:45:35 +0200
Message-Id: <20191211154536.5701-3-tariqt@mellanox.com>
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

Introduce a new attribute representing a new time-stamp format: current
time in ns (to comply with y2038) instead of jiffies. If the new
attribute was received, translate the time-stamp accordingly (ns).

Fixes: 2f1242efe9d0 ("devlink: Add devlink health show command")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index aee6c87cbce7..f0181e41faa4 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -6682,6 +6682,25 @@ out:
 	pr_out_str(dl, "last_dump_time", dump_time);
 }
 
+static void pr_out_dump_report_timestamp(struct dl *dl, const struct nlattr *attr)
+{
+	char dump_date[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
+	char dump_time[HEALTH_REPORTER_TIMESTAMP_FMT_LEN];
+	time_t tv_sec;
+	struct tm *tm;
+	uint64_t ts;
+
+	ts = mnl_attr_get_u64(attr);
+	tv_sec = ts / 1000000000;
+	tm = localtime(&tv_sec);
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
@@ -6713,7 +6732,9 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT]));
 	pr_out_u64(dl, "recover",
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_RECOVER_COUNT]));
-	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS])
+	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS])
+		pr_out_dump_report_timestamp(dl, tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS]);
+	else if (tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS])
 		pr_out_dump_reporter_format_logtime(dl, tb[DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS]);
 	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
 		pr_out_u64(dl, "grace_period",
-- 
2.21.0

