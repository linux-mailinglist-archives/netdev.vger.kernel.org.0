Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B96E21465D1
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAWKdJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:09 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47582 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726227AbgAWKdI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:08 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX1XI002819;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX10O022721;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAX1bu022720;
        Thu, 23 Jan 2020 12:33:01 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 5/6] devlink: Replace pr_#type_value wrapper functions with common functions
Date:   Thu, 23 Jan 2020 12:32:30 +0200
Message-Id: <1579775551-22659-6-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace calls for pr_bool/uint/uint64_value with direct calls for the
matching common json_print library function: print_bool(), print_uint()
and print_u64()

Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 37 +++++--------------------------------
 1 file changed, 5 insertions(+), 32 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a25dd818..231a2838 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1905,33 +1905,6 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 		pr_out("%s %"PRIu64, name, val);
 }
 
-static void pr_out_bool_value(struct dl *dl, bool value)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_bool(PRINT_JSON, NULL, NULL, value);
-	else
-		pr_out("%s", value ? "true" : "false");
-}
-
-static void pr_out_uint_value(struct dl *dl, unsigned int value)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_uint(PRINT_JSON, NULL, NULL, value);
-	else
-		pr_out("%u", value);
-}
-
-static void pr_out_uint64_value(struct dl *dl, uint64_t value)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_u64(PRINT_JSON, NULL, NULL, value);
-	else
-		pr_out("%"PRIu64, value);
-}
-
 static bool is_binary_eol(int i)
 {
 	return !(i%16);
@@ -6450,19 +6423,19 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 	check_indent_newline(dl);
 	switch (type) {
 	case MNL_TYPE_FLAG:
-		pr_out_bool_value(dl, mnl_attr_get_u8(nl_data));
+		print_bool(PRINT_ANY, NULL, "%s", mnl_attr_get_u8(nl_data));
 		break;
 	case MNL_TYPE_U8:
-		pr_out_uint_value(dl, mnl_attr_get_u8(nl_data));
+		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u8(nl_data));
 		break;
 	case MNL_TYPE_U16:
-		pr_out_uint_value(dl, mnl_attr_get_u16(nl_data));
+		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u16(nl_data));
 		break;
 	case MNL_TYPE_U32:
-		pr_out_uint_value(dl, mnl_attr_get_u32(nl_data));
+		print_uint(PRINT_ANY, NULL, "%u", mnl_attr_get_u32(nl_data));
 		break;
 	case MNL_TYPE_U64:
-		pr_out_uint64_value(dl, mnl_attr_get_u64(nl_data));
+		print_u64(PRINT_ANY, NULL, "%"PRIu64, mnl_attr_get_u64(nl_data));
 		break;
 	case MNL_TYPE_NUL_STRING:
 		print_string(PRINT_ANY, NULL, "%s", mnl_attr_get_str(nl_data));
-- 
2.19.1

