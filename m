Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABAC51465CE
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAWKdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:10 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47576 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726099AbgAWKdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:09 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX1e0002816;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX1R1022719;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAX1Vr022718;
        Thu, 23 Jan 2020 12:33:01 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 4/6] devlink: Replace pr_out_str wrapper function with common function
Date:   Thu, 23 Jan 2020 12:32:29 +0200
Message-Id: <1579775551-22659-5-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace calls for pr_out_str() and pr_out_str_value() with direct calls to
common json_print library functions.

Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 292 ++++++++++++++++++++++++++--------------------
 1 file changed, 166 insertions(+), 126 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index a641c4dc..a25dd818 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -395,6 +395,17 @@ static void __pr_out_indent_newline(struct dl *dl)
 		pr_out(" ");
 }
 
+static void check_indent_newline(struct dl *dl)
+{
+	__pr_out_indent_newline(dl);
+
+	if (g_indent_newline && !is_json_context()) {
+		printf("%s", g_indent_str);
+		g_indent_newline = false;
+	}
+	g_new_line_count = 0;
+}
+
 static const enum mnl_attr_data_type devlink_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_BUS_NAME] = MNL_TYPE_NUL_STRING,
 	[DEVLINK_ATTR_DEV_NAME] = MNL_TYPE_NUL_STRING,
@@ -1865,22 +1876,12 @@ static void pr_out_port_handle_end(struct dl *dl)
 		pr_out("\n");
 }
 
-
-static void pr_out_str(struct dl *dl, const char *name, const char *val)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_string(PRINT_JSON, name, NULL, val);
-	else
-		pr_out("%s %s", name, val);
-}
-
 static void pr_out_bool(struct dl *dl, const char *name, bool val)
 {
 	if (dl->json_output)
 		print_bool(PRINT_JSON, name, NULL, val);
 	else
-		pr_out_str(dl, name, val ? "true" : "false");
+		print_string_name_value(name, val ? "true" : "false");
 }
 
 static void pr_out_uint(struct dl *dl, const char *name, unsigned int val)
@@ -1896,7 +1897,7 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 {
 	__pr_out_indent_newline(dl);
 	if (val == (uint64_t) -1)
-		return pr_out_str(dl, name, "unlimited");
+		return print_string_name_value(name, "unlimited");
 
 	if (dl->json_output)
 		print_u64(PRINT_JSON, name, NULL, val);
@@ -1953,15 +1954,6 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 		__pr_out_newline();
 }
 
-static void pr_out_str_value(struct dl *dl, const char *value)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_string(PRINT_JSON, NULL, NULL, value);
-	else
-		pr_out("%s", value);
-}
-
 static void pr_out_name(struct dl *dl, const char *name)
 {
 	__pr_out_indent_newline(dl);
@@ -2156,19 +2148,24 @@ static void pr_out_eswitch(struct dl *dl, struct nlattr **tb)
 {
 	__pr_out_handle_start(dl, tb, true, false);
 
-	if (tb[DEVLINK_ATTR_ESWITCH_MODE])
-		pr_out_str(dl, "mode",
-			   eswitch_mode_name(mnl_attr_get_u16(tb[DEVLINK_ATTR_ESWITCH_MODE])));
-
-	if (tb[DEVLINK_ATTR_ESWITCH_INLINE_MODE])
-		pr_out_str(dl, "inline-mode",
-			   eswitch_inline_mode_name(mnl_attr_get_u8(
-				   tb[DEVLINK_ATTR_ESWITCH_INLINE_MODE])));
-
+	if (tb[DEVLINK_ATTR_ESWITCH_MODE]) {
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "mode", "mode %s",
+			     eswitch_mode_name(mnl_attr_get_u16(
+				     tb[DEVLINK_ATTR_ESWITCH_MODE])));
+	}
+	if (tb[DEVLINK_ATTR_ESWITCH_INLINE_MODE]) {
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "inline-mode", "inline-mode %s",
+			     eswitch_inline_mode_name(mnl_attr_get_u8(
+				     tb[DEVLINK_ATTR_ESWITCH_INLINE_MODE])));
+	}
 	if (tb[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]) {
 		bool encap_mode = !!mnl_attr_get_u8(tb[DEVLINK_ATTR_ESWITCH_ENCAP_MODE]);
 
-		pr_out_str(dl, "encap", encap_mode ? "enable" : "disable");
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "encap", "encap %s",
+			     encap_mode ? "enable" : "disable");
 	}
 
 	pr_out_handle_end(dl);
@@ -2355,8 +2352,10 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 	     !nla_value[DEVLINK_ATTR_PARAM_VALUE_DATA]))
 		return;
 
-	pr_out_str(dl, "cmode",
-		   param_cmode_name(mnl_attr_get_u8(nla_value[DEVLINK_ATTR_PARAM_VALUE_CMODE])));
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "cmode", "cmode %s",
+		     param_cmode_name(mnl_attr_get_u8(nla_value[DEVLINK_ATTR_PARAM_VALUE_CMODE])));
+
 	val_attr = nla_value[DEVLINK_ATTR_PARAM_VALUE_DATA];
 
 	conv_exists = param_val_conv_exists(param_val_conv, PARAM_VAL_CONV_LEN,
@@ -2372,7 +2371,7 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 						     &vstr);
 			if (err)
 				return;
-			pr_out_str(dl, "value", vstr);
+			print_string(PRINT_ANY, "value", " value %s", vstr);
 		} else {
 			pr_out_uint(dl, "value", mnl_attr_get_u8(val_attr));
 		}
@@ -2386,7 +2385,7 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 						     &vstr);
 			if (err)
 				return;
-			pr_out_str(dl, "value", vstr);
+			print_string(PRINT_ANY, "value", " value %s", vstr);
 		} else {
 			pr_out_uint(dl, "value", mnl_attr_get_u16(val_attr));
 		}
@@ -2400,13 +2399,14 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 						     &vstr);
 			if (err)
 				return;
-			pr_out_str(dl, "value", vstr);
+			print_string(PRINT_ANY, "value", " value %s", vstr);
 		} else {
 			pr_out_uint(dl, "value", mnl_attr_get_u32(val_attr));
 		}
 		break;
 	case MNL_TYPE_STRING:
-		pr_out_str(dl, "value", mnl_attr_get_str(val_attr));
+		print_string(PRINT_ANY, "value", " value %s",
+			     mnl_attr_get_str(val_attr));
 		break;
 	case MNL_TYPE_FLAG:
 		pr_out_bool(dl, "value", val_attr ? true : false);
@@ -2438,12 +2438,12 @@ static void pr_out_param(struct dl *dl, struct nlattr **tb, bool array)
 	nla_type = mnl_attr_get_u8(nla_param[DEVLINK_ATTR_PARAM_TYPE]);
 
 	nla_name = mnl_attr_get_str(nla_param[DEVLINK_ATTR_PARAM_NAME]);
-	pr_out_str(dl, "name", nla_name);
-
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "name", "name %s ", nla_name);
 	if (!nla_param[DEVLINK_ATTR_PARAM_GENERIC])
-		pr_out_str(dl, "type", "driver-specific");
+		print_string(PRINT_ANY, "type", "type %s", "driver-specific");
 	else
-		pr_out_str(dl, "type", "generic");
+		print_string(PRINT_ANY, "type", "type %s", "generic");
 
 	pr_out_array_start(dl, "values");
 	mnl_attr_for_each_nested(param_value_attr,
@@ -2807,7 +2807,8 @@ static void pr_out_versions_single(struct dl *dl, const struct nlmsghdr *nlh,
 		ver_name = mnl_attr_get_str(tb[DEVLINK_ATTR_INFO_VERSION_NAME]);
 		ver_value = mnl_attr_get_str(tb[DEVLINK_ATTR_INFO_VERSION_VALUE]);
 
-		pr_out_str(dl, ver_name, ver_value);
+		check_indent_newline(dl);
+		print_string_name_value(ver_name, ver_value);
 		if (!dl->json_output)
 			__pr_out_newline();
 	}
@@ -2827,7 +2828,9 @@ static void pr_out_info(struct dl *dl, const struct nlmsghdr *nlh,
 
 		if (!dl->json_output)
 			__pr_out_newline();
-		pr_out_str(dl, "driver", mnl_attr_get_str(nla_drv));
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "driver", "driver %s",
+			     mnl_attr_get_str(nla_drv));
 	}
 
 	if (tb[DEVLINK_ATTR_INFO_SERIAL_NUMBER]) {
@@ -2835,7 +2838,9 @@ static void pr_out_info(struct dl *dl, const struct nlmsghdr *nlh,
 
 		if (!dl->json_output)
 			__pr_out_newline();
-		pr_out_str(dl, "serial_number", mnl_attr_get_str(nla_sn));
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "serial_number", "serial_number %s",
+			     mnl_attr_get_str(nla_sn));
 	}
 	__pr_out_indent_dec();
 
@@ -3208,29 +3213,34 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 	struct nlattr *dpt_attr = tb[DEVLINK_ATTR_PORT_DESIRED_TYPE];
 
 	pr_out_port_handle_start(dl, tb, false);
+	check_indent_newline(dl);
 	if (pt_attr) {
 		uint16_t port_type = mnl_attr_get_u16(pt_attr);
 
-		pr_out_str(dl, "type", port_type_name(port_type));
+		print_string(PRINT_ANY, "type", "type %s",
+			     port_type_name(port_type));
 		if (dpt_attr) {
 			uint16_t des_port_type = mnl_attr_get_u16(dpt_attr);
 
 			if (port_type != des_port_type)
-				pr_out_str(dl, "des_type",
-					   port_type_name(des_port_type));
+				print_string(PRINT_ANY, "des_type", " des_type %s",
+					     port_type_name(des_port_type));
 		}
 	}
-	if (tb[DEVLINK_ATTR_PORT_NETDEV_NAME])
-		pr_out_str(dl, "netdev",
-			   mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]));
-	if (tb[DEVLINK_ATTR_PORT_IBDEV_NAME])
-		pr_out_str(dl, "ibdev",
-			   mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_IBDEV_NAME]));
+	if (tb[DEVLINK_ATTR_PORT_NETDEV_NAME]) {
+		print_string(PRINT_ANY, "netdev", " netdev %s",
+			     mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]));
+	}
+	if (tb[DEVLINK_ATTR_PORT_IBDEV_NAME]) {
+		print_string(PRINT_ANY, "ibdev", " ibdev %s",
+			     mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_IBDEV_NAME]));
+		}
 	if (tb[DEVLINK_ATTR_PORT_FLAVOUR]) {
 		uint16_t port_flavour =
 				mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_FLAVOUR]);
 
-		pr_out_str(dl, "flavour", port_flavour_name(port_flavour));
+		print_string(PRINT_ANY, "flavour", " flavour %s",
+			     port_flavour_name(port_flavour));
 
 		switch (port_flavour) {
 		case DEVLINK_PORT_FLAVOUR_PCI_PF:
@@ -3381,6 +3391,7 @@ static void cmd_sb_help(void)
 static void pr_out_sb(struct dl *dl, struct nlattr **tb)
 {
 	pr_out_handle_start_arr(dl, tb);
+	check_indent_newline(dl);
 	pr_out_uint(dl, "sb",
 		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
 	pr_out_uint(dl, "size",
@@ -3462,12 +3473,12 @@ static void pr_out_sb_pool(struct dl *dl, struct nlattr **tb)
 		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
 	pr_out_uint(dl, "pool",
 		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
-	pr_out_str(dl, "type",
-		   pool_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_TYPE])));
+	print_string(PRINT_ANY, "type", " type %s",
+		     pool_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_TYPE])));
 	pr_out_uint(dl, "size",
 		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_POOL_SIZE]));
-	pr_out_str(dl, "thtype",
-		   threshold_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE])));
+	print_string(PRINT_ANY, "thtype", " thtype %s",
+		     threshold_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE])));
 	if (tb[DEVLINK_ATTR_SB_POOL_CELL_SIZE])
 		pr_out_uint(dl, "cell_size",
 			    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_POOL_CELL_SIZE]));
@@ -3652,8 +3663,8 @@ static void pr_out_sb_tc_bind(struct dl *dl, struct nlattr **tb)
 	       mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
 	pr_out_uint(dl, "tc",
 	       mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_TC_INDEX]));
-	pr_out_str(dl, "type",
-	       pool_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_TYPE])));
+	print_string(PRINT_ANY, "type", " type %s",
+		     pool_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_TYPE])));
 	pr_out_uint(dl, "pool",
 	       mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
 	pr_out_uint(dl, "threshold",
@@ -4232,13 +4243,16 @@ static void pr_out_flash_update(struct dl *dl, struct nlattr **tb)
 {
 	__pr_out_handle_start(dl, tb, true, false);
 
-	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG])
-		pr_out_str(dl, "msg",
-			   mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]));
-
-	if (tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT])
-		pr_out_str(dl, "component",
-			   mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT]));
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]) {
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "msg", "msg %s",
+			     mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_MSG]));
+	}
+	if (tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT]) {
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "component", "component %s",
+			     mnl_attr_get_str(tb[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT]));
+	}
 
 	if (tb[DEVLINK_ATTR_FLASH_UPDATE_STATUS_DONE])
 		pr_out_u64(dl, "done",
@@ -4705,13 +4719,15 @@ static void pr_out_dpipe_fields(struct dpipe_ctx *ctx,
 	for (i = 0; i < field_count; i++) {
 		field = &fields[i];
 		pr_out_entry_start(ctx->dl);
-		pr_out_str(ctx->dl, "name", field->name);
+		check_indent_newline(ctx->dl);
+		print_string(PRINT_ANY, "name", "name %s", field->name);
 		if (ctx->dl->verbose)
 			pr_out_uint(ctx->dl, "id", field->id);
 		pr_out_uint(ctx->dl, "bitwidth", field->bitwidth);
-		if (field->mapping_type)
-			pr_out_str(ctx->dl, "mapping_type",
-				   dpipe_field_mapping_e2s(field->mapping_type));
+		if (field->mapping_type) {
+			print_string(PRINT_ANY, "mapping_type", " mapping_type %s",
+				     dpipe_field_mapping_e2s(field->mapping_type));
+		}
 		pr_out_entry_end(ctx->dl);
 	}
 }
@@ -4721,11 +4737,11 @@ pr_out_dpipe_header(struct dpipe_ctx *ctx, struct nlattr **tb,
 		    struct dpipe_header *header, bool global)
 {
 	pr_out_handle_start_arr(ctx->dl, tb);
-	pr_out_str(ctx->dl, "name", header->name);
+	check_indent_newline(ctx->dl);
+	print_string(PRINT_ANY, "name", "name %s", header->name);
 	if (ctx->dl->verbose) {
 		pr_out_uint(ctx->dl, "id", header->id);
-		pr_out_str(ctx->dl, "global",
-			   global ? "true" : "false");
+		print_bool(PRINT_ANY, "global", " global %s", global);
 	}
 	pr_out_array_start(ctx->dl, "field");
 	pr_out_dpipe_fields(ctx, header->fields,
@@ -4949,20 +4965,21 @@ static void pr_out_dpipe_action(struct dpipe_action *action,
 	struct dpipe_op_info *op_info = &action->info;
 	const char *mapping;
 
-	pr_out_str(ctx->dl, "type",
-		   dpipe_action_type_e2s(action->type));
-	pr_out_str(ctx->dl, "header",
-		   dpipe_header_id2s(ctx, op_info->header_id,
-				     op_info->header_global));
-	pr_out_str(ctx->dl, "field",
-		   dpipe_field_id2s(ctx, op_info->header_id,
-				    op_info->field_id,
-				    op_info->header_global));
+	check_indent_newline(ctx->dl);
+	print_string(PRINT_ANY, "type", "type %s",
+		     dpipe_action_type_e2s(action->type));
+	print_string(PRINT_ANY, "header", " header %s",
+		     dpipe_header_id2s(ctx, op_info->header_id,
+				       op_info->header_global));
+	print_string(PRINT_ANY, "field", " field %s",
+		     dpipe_field_id2s(ctx, op_info->header_id,
+				      op_info->field_id,
+				      op_info->header_global));
 	mapping = dpipe_mapping_get(ctx, op_info->header_id,
 				    op_info->field_id,
 				    op_info->header_global);
 	if (mapping)
-		pr_out_str(ctx->dl, "mapping", mapping);
+		print_string(PRINT_ANY, "mapping", " mapping %s", mapping);
 }
 
 static int dpipe_action_parse(struct dpipe_action *action, struct nlattr *nl)
@@ -5031,20 +5048,21 @@ static void pr_out_dpipe_match(struct dpipe_match *match,
 	struct dpipe_op_info *op_info = &match->info;
 	const char *mapping;
 
-	pr_out_str(ctx->dl, "type",
-		   dpipe_match_type_e2s(match->type));
-	pr_out_str(ctx->dl, "header",
-		   dpipe_header_id2s(ctx, op_info->header_id,
-				     op_info->header_global));
-	pr_out_str(ctx->dl, "field",
-		   dpipe_field_id2s(ctx, op_info->header_id,
-				    op_info->field_id,
-				    op_info->header_global));
+	check_indent_newline(ctx->dl);
+	print_string(PRINT_ANY, "type", "type %s",
+		     dpipe_match_type_e2s(match->type));
+	print_string(PRINT_ANY, "header", " header %s",
+		     dpipe_header_id2s(ctx, op_info->header_id,
+				       op_info->header_global));
+	print_string(PRINT_ANY, "field", " field %s",
+		     dpipe_field_id2s(ctx, op_info->header_id,
+				      op_info->field_id,
+				      op_info->header_global));
 	mapping = dpipe_mapping_get(ctx, op_info->header_id,
 				    op_info->field_id,
 				    op_info->header_global);
 	if (mapping)
-		pr_out_str(ctx->dl, "mapping", mapping);
+		print_string(PRINT_ANY, "mapping", " mapping %s", mapping);
 }
 
 static int dpipe_match_parse(struct dpipe_match *match,
@@ -5149,7 +5167,8 @@ resource_path_print(struct dl *dl, struct resources *resources,
 		path -= strlen(del);
 		memcpy(path, del, strlen(del));
 	}
-	pr_out_str(dl, "resource_path", path);
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "resource_path", "resource_path %s", path);
 	free(path);
 }
 
@@ -5194,10 +5213,10 @@ static int dpipe_table_show(struct dpipe_ctx *ctx, struct nlattr *nl)
 	if (!ctx->print_tables)
 		return 0;
 
-	pr_out_str(ctx->dl, "name", table->name);
+	check_indent_newline(ctx->dl);
+	print_string(PRINT_ANY, "name", "name %s", table->name);
 	pr_out_uint(ctx->dl, "size", size);
-	pr_out_str(ctx->dl, "counters_enabled",
-		   counters_enabled ? "true" : "false");
+	print_bool(PRINT_ANY, "counters_enabled", " counters_enabled %s", counters_enabled);
 
 	if (resource_valid) {
 		resource_units = mnl_attr_get_u32(nla_table[DEVLINK_ATTR_DPIPE_TABLE_RESOURCE_UNITS]);
@@ -5374,7 +5393,8 @@ static void dpipe_field_printer_ipv4_addr(struct dpipe_ctx *ctx,
 	struct in_addr ip_addr;
 
 	ip_addr.s_addr = htonl(*(uint32_t *)value);
-	pr_out_str(ctx->dl, dpipe_value_type_e2s(type), inet_ntoa(ip_addr));
+	check_indent_newline(ctx->dl);
+	print_string_name_value(dpipe_value_type_e2s(type), inet_ntoa(ip_addr));
 }
 
 static void
@@ -5382,8 +5402,9 @@ dpipe_field_printer_ethernet_addr(struct dpipe_ctx *ctx,
 				  enum dpipe_value_type type,
 				  void *value)
 {
-	pr_out_str(ctx->dl, dpipe_value_type_e2s(type),
-		   ether_ntoa((struct ether_addr *)value));
+	check_indent_newline(ctx->dl);
+	print_string_name_value(dpipe_value_type_e2s(type),
+				ether_ntoa((struct ether_addr *)value));
 }
 
 static void dpipe_field_printer_ipv6_addr(struct dpipe_ctx *ctx,
@@ -5393,7 +5414,8 @@ static void dpipe_field_printer_ipv6_addr(struct dpipe_ctx *ctx,
 	char str[INET6_ADDRSTRLEN];
 
 	inet_ntop(AF_INET6, value, str, INET6_ADDRSTRLEN);
-	pr_out_str(ctx->dl, dpipe_value_type_e2s(type), str);
+	check_indent_newline(ctx->dl);
+	print_string_name_value(dpipe_value_type_e2s(type), str);
 }
 
 static struct dpipe_field_printer dpipe_field_printers_ipv4[] = {
@@ -5872,7 +5894,8 @@ static void resource_show(struct resource *resource,
 	struct dl *dl = ctx->dl;
 	bool array = false;
 
-	pr_out_str(dl, "name", resource->name);
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "name", "name %s", resource->name);
 	if (dl->verbose)
 		resource_path_print(dl, ctx->resources, resource->id);
 	pr_out_u64(dl, "size", resource->size);
@@ -5880,7 +5903,8 @@ static void resource_show(struct resource *resource,
 		pr_out_u64(dl, "size_new", resource->size_new);
 	if (resource->occ_valid)
 		pr_out_uint(dl, "occ", resource->size_occ);
-	pr_out_str(dl, "unit", resource_unit_str_get(resource->unit));
+	print_string(PRINT_ANY, "unit", " unit %s",
+		     resource_unit_str_get(resource->unit));
 
 	if (resource->size_min != resource->size_max) {
 		pr_out_uint(dl, "size_min", resource->size_min);
@@ -5896,14 +5920,17 @@ static void resource_show(struct resource *resource,
 	if (array)
 		pr_out_array_start(dl, "dpipe_tables");
 	else
-		pr_out_str(dl, "dpipe_tables", "none");
+		print_string(PRINT_ANY, "dpipe_tables", " dpipe_tables none",
+			     "none");
 
 	list_for_each_entry(table, &ctx->tables->table_list, list) {
 		if (table->resource_id != resource->id ||
 		    !table->resource_valid)
 			continue;
 		pr_out_entry_start(dl);
-		pr_out_str(dl, "table_name", table->name);
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "table_name", "table_name %s",
+			     table->name);
 		pr_out_entry_end(dl);
 	}
 	if (array)
@@ -5912,9 +5939,11 @@ static void resource_show(struct resource *resource,
 	if (list_empty(&resource->resource_list))
 		return;
 
-	if (ctx->pending_change)
-		pr_out_str(dl, "size_valid", resource->size_valid ?
-			   "true" : "false");
+	if (ctx->pending_change) {
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, "size_valid", "size_valid %s",
+			     resource->size_valid ? "true" : "false");
+	}
 	pr_out_array_start(dl, "resources");
 	list_for_each_entry(child_resource, &resource->resource_list, list) {
 		pr_out_entry_start(dl);
@@ -6418,6 +6447,7 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 	uint8_t *data;
 	uint32_t len;
 
+	check_indent_newline(dl);
 	switch (type) {
 	case MNL_TYPE_FLAG:
 		pr_out_bool_value(dl, mnl_attr_get_u8(nl_data));
@@ -6435,7 +6465,7 @@ static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
 		pr_out_uint64_value(dl, mnl_attr_get_u64(nl_data));
 		break;
 	case MNL_TYPE_NUL_STRING:
-		pr_out_str_value(dl, mnl_attr_get_str(nl_data));
+		print_string(PRINT_ANY, NULL, "%s", mnl_attr_get_str(nl_data));
 		break;
 	case MNL_TYPE_BINARY:
 		len = mnl_attr_get_payload_len(nl_data);
@@ -6733,8 +6763,9 @@ static void pr_out_dump_reporter_format_logtime(struct dl *dl, const struct nlat
 out:
 	strftime(dump_date, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%Y-%m-%d", info);
 	strftime(dump_time, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%H:%M:%S", info);
-	pr_out_str(dl, "last_dump_date", dump_date);
-	pr_out_str(dl, "last_dump_time", dump_time);
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "last_dump_date", "last_dump_date %s", dump_date);
+	print_string(PRINT_ANY, "last_dump_time", " last_dump_time %s", dump_time);
 }
 
 static void pr_out_dump_report_timestamp(struct dl *dl, const struct nlattr *attr)
@@ -6752,8 +6783,9 @@ static void pr_out_dump_report_timestamp(struct dl *dl, const struct nlattr *att
 	strftime(dump_date, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%Y-%m-%d", tm);
 	strftime(dump_time, HEALTH_REPORTER_TIMESTAMP_FMT_LEN, "%H:%M:%S", tm);
 
-	pr_out_str(dl, "last_dump_date", dump_date);
-	pr_out_str(dl, "last_dump_time", dump_time);
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "last_dump_date", "last_dump_date %s", dump_date);
+	print_string(PRINT_ANY, "last_dump_time", " last_dump_time %s", dump_time);
 }
 
 static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
@@ -6775,14 +6807,16 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 
 	pr_out_handle_start_arr(dl, tb_health);
 
-	pr_out_str(dl, "reporter",
-		   mnl_attr_get_str(tb[DEVLINK_ATTR_HEALTH_REPORTER_NAME]));
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "reporter", "reporter %s",
+		     mnl_attr_get_str(tb[DEVLINK_ATTR_HEALTH_REPORTER_NAME]));
 	if (!dl->json_output) {
 		__pr_out_newline();
 		__pr_out_indent_inc();
 	}
 	state = mnl_attr_get_u8(tb[DEVLINK_ATTR_HEALTH_REPORTER_STATE]);
-	pr_out_str(dl, "state", health_state_name(state));
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "state", "state %s", health_state_name(state));
 	pr_out_u64(dl, "error",
 		   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_ERR_COUNT]));
 	pr_out_u64(dl, "recover",
@@ -6923,8 +6957,11 @@ static void pr_out_trap_metadata(struct dl *dl, struct nlattr *attr)
 	struct nlattr *attr_metadata;
 
 	pr_out_array_start(dl, "metadata");
-	mnl_attr_for_each_nested(attr_metadata, attr)
-		pr_out_str_value(dl, trap_metadata_name(attr_metadata));
+	mnl_attr_for_each_nested(attr_metadata, attr) {
+		check_indent_newline(dl);
+		print_string(PRINT_ANY, NULL, "%s",
+			     trap_metadata_name(attr_metadata));
+	}
 	pr_out_array_end(dl);
 }
 
@@ -6938,12 +6975,14 @@ static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array)
 	else
 		__pr_out_handle_start(dl, tb, true, false);
 
-	pr_out_str(dl, "name", mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_NAME]));
-	pr_out_str(dl, "type", trap_type_name(type));
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "name", "name %s",
+		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_NAME]));
+	print_string(PRINT_ANY, "type", " type %s", trap_type_name(type));
 	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
-	pr_out_str(dl, "action", trap_action_name(action));
-	pr_out_str(dl, "group",
-		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	print_string(PRINT_ANY, "action", " action %s", trap_action_name(action));
+	print_string(PRINT_ANY, "group", " group %s",
+		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
 	if (dl->verbose)
 		pr_out_trap_metadata(dl, tb[DEVLINK_ATTR_TRAP_METADATA]);
 	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
@@ -7025,8 +7064,9 @@ static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array)
 	else
 		__pr_out_handle_start(dl, tb, true, false);
 
-	pr_out_str(dl, "name",
-		   mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
+	check_indent_newline(dl);
+	print_string(PRINT_ANY, "name", "name %s",
+		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
 	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
 	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
 	pr_out_handle_end(dl);
-- 
2.19.1

