Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22AAAA364
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389468AbfIEMna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:43:30 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58416 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389449AbfIEMn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 08:43:29 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Sep 2019 15:43:23 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x85ChNGY021437;
        Thu, 5 Sep 2019 15:43:23 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH iproute2 1/4] devlink: Add helper for left justification print
Date:   Thu,  5 Sep 2019 15:43:04 +0300
Message-Id: <1567687387-12993-2-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
References: <1567687387-12993-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Introduce a helper function which wraps code that adds a left hand side
space separator unless it follows a newline.

Fixes: e3d0f0c0e3d8 ("devlink: add option to generate JSON output")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
---
 devlink/devlink.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 2f084c020765..f1b9b2da39d7 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -355,6 +355,12 @@ static bool dl_no_arg(struct dl *dl)
 	return dl_argc(dl) == 0;
 }
 
+static void __pr_out_indent_newline(struct dl *dl)
+{
+	if (!g_indent_newline && !dl->json_output)
+		pr_out(" ");
+}
+
 static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_BUS_NAME] = MNL_TYPE_NUL_STRING,
 	[DEVLINK_ATTR_DEV_NAME] = MNL_TYPE_NUL_STRING,
@@ -1799,14 +1805,11 @@ static void pr_out_port_handle_end(struct dl *dl)
 
 static void pr_out_str(struct dl *dl, const char *name, const char *val)
 {
-	if (dl->json_output) {
+	__pr_out_indent_newline(dl);
+	if (dl->json_output)
 		jsonw_string_field(dl->jw, name, val);
-	} else {
-		if (g_indent_newline)
-			pr_out("%s %s", name, val);
-		else
-			pr_out(" %s %s", name, val);
-	}
+	else
+		pr_out("%s %s", name, val);
 }
 
 static void pr_out_bool(struct dl *dl, const char *name, bool val)
@@ -1819,29 +1822,23 @@ static void pr_out_bool(struct dl *dl, const char *name, bool val)
 
 static void pr_out_uint(struct dl *dl, const char *name, unsigned int val)
 {
-	if (dl->json_output) {
+	__pr_out_indent_newline(dl);
+	if (dl->json_output)
 		jsonw_uint_field(dl->jw, name, val);
-	} else {
-		if (g_indent_newline)
-			pr_out("%s %u", name, val);
-		else
-			pr_out(" %s %u", name, val);
-	}
+	else
+		pr_out("%s %u", name, val);
 }
 
 static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 {
+	__pr_out_indent_newline(dl);
 	if (val == (uint64_t) -1)
 		return pr_out_str(dl, name, "unlimited");
 
-	if (dl->json_output) {
+	if (dl->json_output)
 		jsonw_u64_field(dl->jw, name, val);
-	} else {
-		if (g_indent_newline)
-			pr_out("%s %"PRIu64, name, val);
-		else
-			pr_out(" %s %"PRIu64, name, val);
-	}
+	else
+		pr_out("%s %"PRIu64, name, val);
 }
 
 static void pr_out_bool_value(struct dl *dl, bool value)
@@ -5835,14 +5832,12 @@ static void pr_out_region_handle_end(struct dl *dl)
 
 static void pr_out_region_snapshots_start(struct dl *dl, bool array)
 {
+	__pr_out_indent_newline(dl);
 	if (dl->json_output) {
 		jsonw_name(dl->jw, "snapshot");
 		jsonw_start_array(dl->jw);
 	} else {
-		if (g_indent_newline)
-			pr_out("snapshot %s", array ? "[" : "");
-		else
-			pr_out(" snapshot %s", array ? "[" : "");
+		pr_out("snapshot %s", array ? "[" : "");
 	}
 }
 
-- 
1.8.3.1

