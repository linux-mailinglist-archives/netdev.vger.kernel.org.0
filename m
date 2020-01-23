Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3AAF1465D0
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWKdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:12 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47581 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726234AbgAWKdL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:11 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX1Xt002822;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX1aY022723;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAX1uV022722;
        Thu, 23 Jan 2020 12:33:01 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 6/6] devlink: Replace pr_out_bool/uint() wrappers with common print functions
Date:   Thu, 23 Jan 2020 12:32:31 +0200
Message-Id: <1579775551-22659-7-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace calls for pr_out_bool() and pr_out_uint() with direct calls
to common json_print library function print_bool() and print_uint().

Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 150 ++++++++++++++++++++++------------------------
 1 file changed, 73 insertions(+), 77 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 231a2838..73ce9865 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1876,23 +1876,6 @@ static void pr_out_port_handle_end(struct dl *dl)
 		pr_out("\n");
 }
 
-static void pr_out_bool(struct dl *dl, const char *name, bool val)
-{
-	if (dl->json_output)
-		print_bool(PRINT_JSON, name, NULL, val);
-	else
-		print_string_name_value(name, val ? "true" : "false");
-}
-
-static void pr_out_uint(struct dl *dl, const char *name, unsigned int val)
-{
-	__pr_out_indent_newline(dl);
-	if (dl->json_output)
-		print_uint(PRINT_JSON, name, NULL, val);
-	else
-		pr_out("%s %u", name, val);
-}
-
 static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 {
 	__pr_out_indent_newline(dl);
@@ -2346,7 +2329,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 				return;
 			print_string(PRINT_ANY, "value", " value %s", vstr);
 		} else {
-			pr_out_uint(dl, "value", mnl_attr_get_u8(val_attr));
+			print_uint(PRINT_ANY, "value", " value %u",
+				   mnl_attr_get_u8(val_attr));
 		}
 		break;
 	case MNL_TYPE_U16:
@@ -2360,7 +2344,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 				return;
 			print_string(PRINT_ANY, "value", " value %s", vstr);
 		} else {
-			pr_out_uint(dl, "value", mnl_attr_get_u16(val_attr));
+			print_uint(PRINT_ANY, "value", " value %u",
+				   mnl_attr_get_u16(val_attr));
 		}
 		break;
 	case MNL_TYPE_U32:
@@ -2374,7 +2359,8 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 				return;
 			print_string(PRINT_ANY, "value", " value %s", vstr);
 		} else {
-			pr_out_uint(dl, "value", mnl_attr_get_u32(val_attr));
+			print_uint(PRINT_ANY, "value", " value %u",
+				   mnl_attr_get_u32(val_attr));
 		}
 		break;
 	case MNL_TYPE_STRING:
@@ -2382,7 +2368,7 @@ static void pr_out_param_value(struct dl *dl, const char *nla_name,
 			     mnl_attr_get_str(val_attr));
 		break;
 	case MNL_TYPE_FLAG:
-		pr_out_bool(dl, "value", val_attr ? true : false);
+		print_bool(PRINT_ANY, "value", " value %s", val_attr);
 		break;
 	}
 }
@@ -2693,7 +2679,8 @@ static int cmd_dev_show_cb(const struct nlmsghdr *nlh, void *data)
 
 	if (reload_failed) {
 		__pr_out_handle_start(dl, tb, true, false);
-		pr_out_bool(dl, "reload_failed", true);
+		check_indent_newline(dl);
+		print_bool(PRINT_ANY, "reload_failed", "reload_failed %s", true);
 		pr_out_handle_end(dl);
 	} else {
 		pr_out_handle(dl, tb);
@@ -3172,11 +3159,11 @@ static void pr_out_port_pfvf_num(struct dl *dl, struct nlattr **tb)
 
 	if (tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
 		fn_num = mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
-		pr_out_uint(dl, "pfnum", fn_num);
+		print_uint(PRINT_ANY, "pfnum", " pfnum %u", fn_num);
 	}
 	if (tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]) {
 		fn_num = mnl_attr_get_u16(tb[DEVLINK_ATTR_PORT_PCI_VF_NUMBER]);
-		pr_out_uint(dl, "vfnum", fn_num);
+		print_uint(PRINT_ANY, "vfnum", " vfnum %u", fn_num);
 	}
 }
 
@@ -3228,11 +3215,11 @@ static void pr_out_port(struct dl *dl, struct nlattr **tb)
 		uint32_t port_number;
 
 		port_number = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_NUMBER]);
-		pr_out_uint(dl, "port", port_number);
+		print_uint(PRINT_ANY, "port", " port %u", port_number);
 	}
 	if (tb[DEVLINK_ATTR_PORT_SPLIT_GROUP])
-		pr_out_uint(dl, "split_group",
-			    mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
+		print_uint(PRINT_ANY, "split_group", " split_group %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_SPLIT_GROUP]));
 	pr_out_port_handle_end(dl);
 }
 
@@ -3365,18 +3352,18 @@ static void pr_out_sb(struct dl *dl, struct nlattr **tb)
 {
 	pr_out_handle_start_arr(dl, tb);
 	check_indent_newline(dl);
-	pr_out_uint(dl, "sb",
-		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
-	pr_out_uint(dl, "size",
-		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_SIZE]));
-	pr_out_uint(dl, "ing_pools",
-		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_INGRESS_POOL_COUNT]));
-	pr_out_uint(dl, "eg_pools",
-		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_EGRESS_POOL_COUNT]));
-	pr_out_uint(dl, "ing_tcs",
-		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_INGRESS_TC_COUNT]));
-	pr_out_uint(dl, "eg_tcs",
-		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_EGRESS_TC_COUNT]));
+	print_uint(PRINT_ANY, "sb", "sb %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
+	print_uint(PRINT_ANY, "size", " size %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_SIZE]));
+	print_uint(PRINT_ANY, "ing_pools", " ing_pools %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_INGRESS_POOL_COUNT]));
+	print_uint(PRINT_ANY, "eg_pools", " eg_pools %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_EGRESS_POOL_COUNT]));
+	print_uint(PRINT_ANY, "ing_tcs", " ing_tcs %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_INGRESS_TC_COUNT]));
+	print_uint(PRINT_ANY, "eg_tcs", " eg_tcs %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_EGRESS_TC_COUNT]));
 	pr_out_handle_end(dl);
 }
 
@@ -3442,19 +3429,20 @@ static const char *threshold_type_name(uint8_t type)
 static void pr_out_sb_pool(struct dl *dl, struct nlattr **tb)
 {
 	pr_out_handle_start_arr(dl, tb);
-	pr_out_uint(dl, "sb",
-		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
-	pr_out_uint(dl, "pool",
-		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
+	check_indent_newline(dl);
+	print_uint(PRINT_ANY, "sb", "sb %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
+	print_uint(PRINT_ANY, "pool", " pool %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
 	print_string(PRINT_ANY, "type", " type %s",
 		     pool_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_TYPE])));
-	pr_out_uint(dl, "size",
-		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_POOL_SIZE]));
+	print_uint(PRINT_ANY, "size", " size %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_POOL_SIZE]));
 	print_string(PRINT_ANY, "thtype", " thtype %s",
 		     threshold_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_THRESHOLD_TYPE])));
 	if (tb[DEVLINK_ATTR_SB_POOL_CELL_SIZE])
-		pr_out_uint(dl, "cell_size",
-			    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_POOL_CELL_SIZE]));
+		print_uint(PRINT_ANY, "cell_size", " cell size %u",
+			   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_POOL_CELL_SIZE]));
 	pr_out_handle_end(dl);
 }
 
@@ -3534,12 +3522,13 @@ static int cmd_sb_pool(struct dl *dl)
 static void pr_out_sb_port_pool(struct dl *dl, struct nlattr **tb)
 {
 	pr_out_port_handle_start_arr(dl, tb, true);
-	pr_out_uint(dl, "sb",
-		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
-	pr_out_uint(dl, "pool",
-		    mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
-	pr_out_uint(dl, "threshold",
-		    mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_THRESHOLD]));
+	check_indent_newline(dl);
+	print_uint(PRINT_ANY, "sb", "sb %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
+	print_uint(PRINT_ANY, "pool", " pool %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
+	print_uint(PRINT_ANY, "threshold", " threshold %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_THRESHOLD]));
 	pr_out_port_handle_end(dl);
 }
 
@@ -3632,16 +3621,17 @@ static int cmd_sb_port(struct dl *dl)
 static void pr_out_sb_tc_bind(struct dl *dl, struct nlattr **tb)
 {
 	pr_out_port_handle_start_arr(dl, tb, true);
-	pr_out_uint(dl, "sb",
-	       mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
-	pr_out_uint(dl, "tc",
-	       mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_TC_INDEX]));
+	check_indent_newline(dl);
+	print_uint(PRINT_ANY, "sb", "sb %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_INDEX]));
+	print_uint(PRINT_ANY, "tc", " tc %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_TC_INDEX]));
 	print_string(PRINT_ANY, "type", " type %s",
 		     pool_type_name(mnl_attr_get_u8(tb[DEVLINK_ATTR_SB_POOL_TYPE])));
-	pr_out_uint(dl, "pool",
-	       mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
-	pr_out_uint(dl, "threshold",
-	       mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_THRESHOLD]));
+	print_uint(PRINT_ANY, "pool", " pool %u",
+		   mnl_attr_get_u16(tb[DEVLINK_ATTR_SB_POOL_INDEX]));
+	print_uint(PRINT_ANY, "threshold", " threshold %u",
+		   mnl_attr_get_u32(tb[DEVLINK_ATTR_SB_THRESHOLD]));
 	pr_out_port_handle_end(dl);
 }
 
@@ -4695,8 +4685,8 @@ static void pr_out_dpipe_fields(struct dpipe_ctx *ctx,
 		check_indent_newline(ctx->dl);
 		print_string(PRINT_ANY, "name", "name %s", field->name);
 		if (ctx->dl->verbose)
-			pr_out_uint(ctx->dl, "id", field->id);
-		pr_out_uint(ctx->dl, "bitwidth", field->bitwidth);
+			print_uint(PRINT_ANY, "id", " id %u", field->id);
+		print_uint(PRINT_ANY, "bitwidth", " bitwidth %u", field->bitwidth);
 		if (field->mapping_type) {
 			print_string(PRINT_ANY, "mapping_type", " mapping_type %s",
 				     dpipe_field_mapping_e2s(field->mapping_type));
@@ -4713,7 +4703,7 @@ pr_out_dpipe_header(struct dpipe_ctx *ctx, struct nlattr **tb,
 	check_indent_newline(ctx->dl);
 	print_string(PRINT_ANY, "name", "name %s", header->name);
 	if (ctx->dl->verbose) {
-		pr_out_uint(ctx->dl, "id", header->id);
+		print_uint(PRINT_ANY, "id", " id %u", header->id);
 		print_bool(PRINT_ANY, "global", " global %s", global);
 	}
 	pr_out_array_start(ctx->dl, "field");
@@ -5188,14 +5178,15 @@ static int dpipe_table_show(struct dpipe_ctx *ctx, struct nlattr *nl)
 
 	check_indent_newline(ctx->dl);
 	print_string(PRINT_ANY, "name", "name %s", table->name);
-	pr_out_uint(ctx->dl, "size", size);
+	print_uint(PRINT_ANY, "size", " size %u", size);
 	print_bool(PRINT_ANY, "counters_enabled", " counters_enabled %s", counters_enabled);
 
 	if (resource_valid) {
 		resource_units = mnl_attr_get_u32(nla_table[DEVLINK_ATTR_DPIPE_TABLE_RESOURCE_UNITS]);
 		resource_path_print(ctx->dl, ctx->resources,
 				    table->resource_id);
-		pr_out_uint(ctx->dl, "resource_units", resource_units);
+		print_uint(PRINT_ANY, "resource_units", " resource_units %u",
+			   resource_units);
 	}
 
 	pr_out_array_start(ctx->dl, "match");
@@ -5478,7 +5469,8 @@ static void __pr_out_entry_value(struct dpipe_ctx *ctx,
 	if (value_len == sizeof(uint32_t)) {
 		uint32_t *value_32 = value;
 
-		pr_out_uint(ctx->dl, dpipe_value_type_e2s(type), *value_32);
+		check_indent_newline(ctx->dl);
+		print_uint_name_value(dpipe_value_type_e2s(type), *value_32);
 	}
 }
 
@@ -5499,7 +5491,8 @@ static void pr_out_dpipe_entry_value(struct dpipe_ctx *ctx,
 
 	if (mapping) {
 		value_mapping = mnl_attr_get_u32(nla_match_value[DEVLINK_ATTR_DPIPE_VALUE_MAPPING]);
-		pr_out_uint(ctx->dl, "mapping_value", value_mapping);
+		check_indent_newline(ctx->dl);
+		print_uint(PRINT_ANY, "mapping_value", "mapping_value %u", value_mapping);
 	}
 
 	if (mask) {
@@ -5616,12 +5609,13 @@ static int dpipe_entry_show(struct dpipe_ctx *ctx, struct nlattr *nl)
 		return -EINVAL;
 	}
 
+	check_indent_newline(ctx->dl);
 	entry_index = mnl_attr_get_u32(nla_entry[DEVLINK_ATTR_DPIPE_ENTRY_INDEX]);
-	pr_out_uint(ctx->dl, "index", entry_index);
+	print_uint(PRINT_ANY, "index", "index %u", entry_index);
 
 	if (nla_entry[DEVLINK_ATTR_DPIPE_ENTRY_COUNTER]) {
 		counter = mnl_attr_get_u64(nla_entry[DEVLINK_ATTR_DPIPE_ENTRY_COUNTER]);
-		pr_out_uint(ctx->dl, "counter", counter);
+		print_uint(PRINT_ANY, "counter", " counter %u", counter);
 	}
 
 	pr_out_array_start(ctx->dl, "match_value");
@@ -5875,14 +5869,16 @@ static void resource_show(struct resource *resource,
 	if (resource->size != resource->size_new)
 		pr_out_u64(dl, "size_new", resource->size_new);
 	if (resource->occ_valid)
-		pr_out_uint(dl, "occ", resource->size_occ);
+		print_uint(PRINT_ANY, "occ", " occ %u",  resource->size_occ);
 	print_string(PRINT_ANY, "unit", " unit %s",
 		     resource_unit_str_get(resource->unit));
 
 	if (resource->size_min != resource->size_max) {
-		pr_out_uint(dl, "size_min", resource->size_min);
+		print_uint(PRINT_ANY, "size_min", " size_min %u",
+			   resource->size_min);
 		pr_out_u64(dl, "size_max", resource->size_max);
-		pr_out_uint(dl, "size_gran", resource->size_gran);
+		print_uint(PRINT_ANY, "size_gran", " size_gran %u",
+			   resource->size_gran);
 	}
 
 	list_for_each_entry(table, &ctx->tables->table_list, list)
@@ -6802,8 +6798,8 @@ static void pr_out_health(struct dl *dl, struct nlattr **tb_health)
 		pr_out_u64(dl, "grace_period",
 			   mnl_attr_get_u64(tb[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD]));
 	if (tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER])
-		pr_out_bool(dl, "auto_recover",
-			    mnl_attr_get_u8(tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]));
+		print_bool(PRINT_ANY, "auto_recover", " auto_recover %s",
+			   mnl_attr_get_u8(tb[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]));
 
 	__pr_out_indent_dec();
 	pr_out_handle_end(dl);
@@ -6952,7 +6948,7 @@ static void pr_out_trap(struct dl *dl, struct nlattr **tb, bool array)
 	print_string(PRINT_ANY, "name", "name %s",
 		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_NAME]));
 	print_string(PRINT_ANY, "type", " type %s", trap_type_name(type));
-	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	print_bool(PRINT_ANY, "generic", " generic %s", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
 	print_string(PRINT_ANY, "action", " action %s", trap_action_name(action));
 	print_string(PRINT_ANY, "group", " group %s",
 		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
@@ -7040,7 +7036,7 @@ static void pr_out_trap_group(struct dl *dl, struct nlattr **tb, bool array)
 	check_indent_newline(dl);
 	print_string(PRINT_ANY, "name", "name %s",
 		     mnl_attr_get_str(tb[DEVLINK_ATTR_TRAP_GROUP_NAME]));
-	pr_out_bool(dl, "generic", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
+	print_bool(PRINT_ANY, "generic", " generic %s", !!tb[DEVLINK_ATTR_TRAP_GENERIC]);
 	pr_out_stats(dl, tb[DEVLINK_ATTR_STATS]);
 	pr_out_handle_end(dl);
 }
-- 
2.19.1

