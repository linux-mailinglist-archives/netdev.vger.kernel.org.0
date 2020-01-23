Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5161465D2
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 11:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWKdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 05:33:15 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47578 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726771AbgAWKdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 05:33:09 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from rondi@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (nps-server-35.mtl.labs.mlnx [10.137.1.140])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00NAX1xB002813;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: from nps-server-35.mtl.labs.mlnx (localhost [127.0.0.1])
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Debian-11ubuntu1) with ESMTP id 00NAX1Fr022717;
        Thu, 23 Jan 2020 12:33:01 +0200
Received: (from rondi@localhost)
        by nps-server-35.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 00NAX1bk022716;
        Thu, 23 Jan 2020 12:33:01 +0200
From:   Ron Diskin <rondi@mellanox.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Moshe Shemesh <moshe@mellanox.com>,
        netdev@vger.kernel.org, Ron Diskin <rondi@mellanox.com>
Subject: [PATCH iproute2 3/6] devlink: Replace json prints by common library functions
Date:   Thu, 23 Jan 2020 12:32:28 +0200
Message-Id: <1579775551-22659-4-git-send-email-rondi@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
References: <1579775551-22659-1-git-send-email-rondi@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Substitute json prints to use json_print.c common library functions,
instead of directly calling jsonw_functions.

Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 147 +++++++++++++++++++---------------------------
 1 file changed, 61 insertions(+), 86 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 95f05a0b..a641c4dc 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -1715,19 +1715,17 @@ static void __pr_out_handle_start(struct dl *dl, struct nlattr **tb,
 	if (dl->json_output) {
 		if (array) {
 			if (should_arr_last_handle_end(dl, bus_name, dev_name))
-				jsonw_end_array(dl->jw);
+				close_json_array(PRINT_JSON, NULL);
 			if (should_arr_last_handle_start(dl, bus_name,
 							 dev_name)) {
-				jsonw_name(dl->jw, buf);
-				jsonw_start_array(dl->jw);
-				jsonw_start_object(dl->jw);
+				open_json_array(PRINT_JSON, buf);
+				open_json_object(NULL);
 				arr_last_handle_set(dl, bus_name, dev_name);
 			} else {
-				jsonw_start_object(dl->jw);
+				open_json_object(NULL);
 			}
 		} else {
-			jsonw_name(dl->jw, buf);
-			jsonw_start_object(dl->jw);
+			open_json_object(buf);
 		}
 	} else {
 		if (array) {
@@ -1754,7 +1752,7 @@ static void pr_out_handle_start_arr(struct dl *dl, struct nlattr **tb)
 static void pr_out_handle_end(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_object(dl->jw);
+		close_json_object();
 	else
 		__pr_out_newline();
 }
@@ -1816,21 +1814,19 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 			if (should_arr_last_port_handle_end(dl, bus_name,
 							    dev_name,
 							    port_index))
-				jsonw_end_array(dl->jw);
+				close_json_array(PRINT_JSON, NULL);
 			if (should_arr_last_port_handle_start(dl, bus_name,
 							      dev_name,
 							      port_index)) {
-				jsonw_name(dl->jw, buf);
-				jsonw_start_array(dl->jw);
-				jsonw_start_object(dl->jw);
+				open_json_array(PRINT_JSON, buf);
+				open_json_object(NULL);
 				arr_last_port_handle_set(dl, bus_name, dev_name,
 							 port_index);
 			} else {
-				jsonw_start_object(dl->jw);
+				open_json_object(NULL);
 			}
 		} else {
-			jsonw_name(dl->jw, buf);
-			jsonw_start_object(dl->jw);
+			open_json_object(buf);
 		}
 	} else {
 		pr_out("%s:", buf);
@@ -1864,7 +1860,7 @@ static void pr_out_port_handle_start_arr(struct dl *dl, struct nlattr **tb, bool
 static void pr_out_port_handle_end(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_object(dl->jw);
+		close_json_object();
 	else
 		pr_out("\n");
 }
@@ -1874,7 +1870,7 @@ static void pr_out_str(struct dl *dl, const char *name, const char *val)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_string_field(dl->jw, name, val);
+		print_string(PRINT_JSON, name, NULL, val);
 	else
 		pr_out("%s %s", name, val);
 }
@@ -1882,7 +1878,7 @@ static void pr_out_str(struct dl *dl, const char *name, const char *val)
 static void pr_out_bool(struct dl *dl, const char *name, bool val)
 {
 	if (dl->json_output)
-		jsonw_bool_field(dl->jw, name, val);
+		print_bool(PRINT_JSON, name, NULL, val);
 	else
 		pr_out_str(dl, name, val ? "true" : "false");
 }
@@ -1891,7 +1887,7 @@ static void pr_out_uint(struct dl *dl, const char *name, unsigned int val)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_uint_field(dl->jw, name, val);
+		print_uint(PRINT_JSON, name, NULL, val);
 	else
 		pr_out("%s %u", name, val);
 }
@@ -1903,7 +1899,7 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
 		return pr_out_str(dl, name, "unlimited");
 
 	if (dl->json_output)
-		jsonw_u64_field(dl->jw, name, val);
+		print_u64(PRINT_JSON, name, NULL, val);
 	else
 		pr_out("%s %"PRIu64, name, val);
 }
@@ -1912,7 +1908,7 @@ static void pr_out_bool_value(struct dl *dl, bool value)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_bool(dl->jw, value);
+		print_bool(PRINT_JSON, NULL, NULL, value);
 	else
 		pr_out("%s", value ? "true" : "false");
 }
@@ -1921,7 +1917,7 @@ static void pr_out_uint_value(struct dl *dl, unsigned int value)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_uint(dl->jw, value);
+		print_uint(PRINT_JSON, NULL, NULL, value);
 	else
 		pr_out("%u", value);
 }
@@ -1930,7 +1926,7 @@ static void pr_out_uint64_value(struct dl *dl, uint64_t value)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_u64(dl->jw, value);
+		print_u64(PRINT_JSON, NULL, NULL, value);
 	else
 		pr_out("%"PRIu64, value);
 }
@@ -1946,7 +1942,7 @@ static void pr_out_binary_value(struct dl *dl, uint8_t *data, uint32_t len)
 
 	while (i < len) {
 		if (dl->json_output)
-			jsonw_printf(dl->jw, "%d", data[i]);
+			print_int(PRINT_JSON, NULL, NULL, data[i]);
 		else
 			pr_out("%02x ", data[i]);
 		i++;
@@ -1961,7 +1957,7 @@ static void pr_out_str_value(struct dl *dl, const char *value)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_string(dl->jw, value);
+		print_string(PRINT_JSON, NULL, NULL, value);
 	else
 		pr_out("%s", value);
 }
@@ -1970,7 +1966,7 @@ static void pr_out_name(struct dl *dl, const char *name)
 {
 	__pr_out_indent_newline(dl);
 	if (dl->json_output)
-		jsonw_name(dl->jw, name);
+		print_string(PRINT_JSON, name, NULL, NULL);
 	else
 		pr_out("%s:", name);
 }
@@ -1978,17 +1974,15 @@ static void pr_out_name(struct dl *dl, const char *name)
 static void pr_out_region_chunk_start(struct dl *dl, uint64_t addr)
 {
 	if (dl->json_output) {
-		jsonw_name(dl->jw, "address");
-		jsonw_uint(dl->jw, addr);
-		jsonw_name(dl->jw, "data");
-		jsonw_start_array(dl->jw);
+		print_uint(PRINT_JSON, "address", NULL, addr);
+		open_json_array(PRINT_JSON, "data");
 	}
 }
 
 static void pr_out_region_chunk_end(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_array(dl->jw);
+		close_json_array(PRINT_JSON, NULL);
 }
 
 static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
@@ -2008,7 +2002,7 @@ static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
 		align_val++;
 
 		if (dl->json_output)
-			jsonw_printf(dl->jw, "%d", data[i]);
+			print_int(PRINT_JSON, NULL, NULL, data[i]);
 		else
 			pr_out("%02x ", data[i]);
 
@@ -2021,9 +2015,8 @@ static void pr_out_region_chunk(struct dl *dl, uint8_t *data, uint32_t len,
 static void pr_out_section_start(struct dl *dl, const char *name)
 {
 	if (dl->json_output) {
-		jsonw_start_object(dl->jw);
-		jsonw_name(dl->jw, name);
-		jsonw_start_object(dl->jw);
+		open_json_object(NULL);
+		open_json_object(name);
 	}
 }
 
@@ -2031,17 +2024,16 @@ static void pr_out_section_end(struct dl *dl)
 {
 	if (dl->json_output) {
 		if (dl->arr_last.present)
-			jsonw_end_array(dl->jw);
-		jsonw_end_object(dl->jw);
-		jsonw_end_object(dl->jw);
+			close_json_array(PRINT_JSON, NULL);
+		close_json_object();
+		close_json_object();
 	}
 }
 
 static void pr_out_array_start(struct dl *dl, const char *name)
 {
 	if (dl->json_output) {
-		jsonw_name(dl->jw, name);
-		jsonw_start_array(dl->jw);
+		open_json_array(PRINT_JSON, name);
 	} else {
 		__pr_out_indent_inc();
 		__pr_out_newline();
@@ -2054,7 +2046,7 @@ static void pr_out_array_start(struct dl *dl, const char *name)
 static void pr_out_array_end(struct dl *dl)
 {
 	if (dl->json_output) {
-		jsonw_end_array(dl->jw);
+		close_json_array(PRINT_JSON, NULL);
 	} else {
 		__pr_out_indent_dec();
 		__pr_out_indent_dec();
@@ -2064,8 +2056,7 @@ static void pr_out_array_end(struct dl *dl)
 static void pr_out_object_start(struct dl *dl, const char *name)
 {
 	if (dl->json_output) {
-		jsonw_name(dl->jw, name);
-		jsonw_start_object(dl->jw);
+		open_json_object(name);
 	} else {
 		__pr_out_indent_inc();
 		__pr_out_newline();
@@ -2078,7 +2069,7 @@ static void pr_out_object_start(struct dl *dl, const char *name)
 static void pr_out_object_end(struct dl *dl)
 {
 	if (dl->json_output) {
-		jsonw_end_object(dl->jw);
+		close_json_object();
 	} else {
 		__pr_out_indent_dec();
 		__pr_out_indent_dec();
@@ -2088,13 +2079,13 @@ static void pr_out_object_end(struct dl *dl)
 static void pr_out_entry_start(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_start_object(dl->jw);
+		open_json_object(NULL);
 }
 
 static void pr_out_entry_end(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_object(dl->jw);
+		close_json_object();
 	else
 		__pr_out_newline();
 }
@@ -3887,20 +3878,18 @@ static void pr_out_json_occ_show_item_list(struct dl *dl, const char *label,
 	struct occ_item *occ_item;
 	char buf[32];
 
-	jsonw_name(dl->jw, label);
-	jsonw_start_object(dl->jw);
+	open_json_object(label);
 	list_for_each_entry(occ_item, list, list) {
 		sprintf(buf, "%u", occ_item->index);
-		jsonw_name(dl->jw, buf);
-		jsonw_start_object(dl->jw);
+		open_json_object(buf);
 		if (bound_pool)
-			jsonw_uint_field(dl->jw, "bound_pool",
-					 occ_item->bound_pool_index);
-		jsonw_uint_field(dl->jw, "current", occ_item->cur);
-		jsonw_uint_field(dl->jw, "max", occ_item->max);
-		jsonw_end_object(dl->jw);
+			print_uint(PRINT_JSON, "bound_pool", NULL,
+				   occ_item->bound_pool_index);
+		print_uint(PRINT_JSON, "current", NULL, occ_item->cur);
+		print_uint(PRINT_JSON, "max", NULL, occ_item->max);
+		close_json_object();
 	}
-	jsonw_end_object(dl->jw);
+	close_json_object();
 }
 
 static void pr_out_occ_show_port(struct dl *dl, struct occ_port *occ_port)
@@ -6140,18 +6129,16 @@ static void pr_out_region_handle_start(struct dl *dl, struct nlattr **tb)
 	char buf[256];
 
 	sprintf(buf, "%s/%s/%s", bus_name, dev_name, region_name);
-	if (dl->json_output) {
-		jsonw_name(dl->jw, buf);
-		jsonw_start_object(dl->jw);
-	} else {
+	if (dl->json_output)
+		open_json_object(buf);
+	else
 		pr_out("%s:", buf);
-	}
 }
 
 static void pr_out_region_handle_end(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_object(dl->jw);
+		close_json_object();
 	else
 		pr_out("\n");
 }
@@ -6159,18 +6146,16 @@ static void pr_out_region_handle_end(struct dl *dl)
 static void pr_out_region_snapshots_start(struct dl *dl, bool array)
 {
 	__pr_out_indent_newline(dl);
-	if (dl->json_output) {
-		jsonw_name(dl->jw, "snapshot");
-		jsonw_start_array(dl->jw);
-	} else {
+	if (dl->json_output)
+		open_json_array(PRINT_JSON, "snapshot");
+	else
 		pr_out("snapshot %s", array ? "[" : "");
-	}
 }
 
 static void pr_out_region_snapshots_end(struct dl *dl, bool array)
 {
 	if (dl->json_output)
-		jsonw_end_array(dl->jw);
+		close_json_array(PRINT_JSON, NULL);
 	else if (array)
 		pr_out("]");
 }
@@ -6185,7 +6170,7 @@ static void pr_out_region_snapshots_id(struct dl *dl, struct nlattr **tb, int in
 	snapshot_id = mnl_attr_get_u32(tb[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
 
 	if (dl->json_output)
-		jsonw_uint(dl->jw, snapshot_id);
+		print_uint(PRINT_JSON, NULL, NULL, snapshot_id);
 	else
 		pr_out("%s%u", index ? " " : "", snapshot_id);
 }
@@ -6527,7 +6512,7 @@ static void pr_out_fmsg_start_object(struct dl *dl, char **name)
 {
 	if (dl->json_output) {
 		pr_out_fmsg_name(dl, name);
-		jsonw_start_object(dl->jw);
+		open_json_object(NULL);
 	} else {
 		pr_out_fmsg_group_start(dl, name);
 	}
@@ -6536,7 +6521,7 @@ static void pr_out_fmsg_start_object(struct dl *dl, char **name)
 static void pr_out_fmsg_end_object(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_object(dl->jw);
+		close_json_object();
 	else
 		pr_out_fmsg_group_end(dl);
 }
@@ -6545,7 +6530,7 @@ static void pr_out_fmsg_start_array(struct dl *dl, char **name)
 {
 	if (dl->json_output) {
 		pr_out_fmsg_name(dl, name);
-		jsonw_start_array(dl->jw);
+		open_json_array(PRINT_JSON, NULL);
 	} else {
 		pr_out_fmsg_group_start(dl, name);
 	}
@@ -6554,7 +6539,7 @@ static void pr_out_fmsg_start_array(struct dl *dl, char **name)
 static void pr_out_fmsg_end_array(struct dl *dl)
 {
 	if (dl->json_output)
-		jsonw_end_array(dl->jw);
+		close_json_array(PRINT_JSON, NULL);
 	else
 		pr_out_fmsg_group_end(dl);
 }
@@ -7206,18 +7191,9 @@ static int dl_init(struct dl *dl)
 		pr_err("Failed to create index map\n");
 		goto err_ifname_map_create;
 	}
-	if (dl->json_output) {
-		dl->jw = jsonw_new(stdout);
-		if (!dl->jw) {
-			pr_err("Failed to create JSON writer\n");
-			goto err_json_new;
-		}
-		jsonw_pretty(dl->jw, dl->pretty_output);
-	}
+	new_json_obj_plain(dl->json_output);
 	return 0;
 
-err_json_new:
-	ifname_map_fini(dl);
 err_ifname_map_create:
 	mnlg_socket_close(dl->nlg);
 	return err;
@@ -7225,8 +7201,7 @@ err_ifname_map_create:
 
 static void dl_fini(struct dl *dl)
 {
-	if (dl->json_output)
-		jsonw_destroy(&dl->jw);
+	delete_json_obj_plain();
 	ifname_map_fini(dl);
 	mnlg_socket_close(dl->nlg);
 }
@@ -7333,7 +7308,7 @@ int main(int argc, char **argv)
 			dl->json_output = true;
 			break;
 		case 'p':
-			dl->pretty_output = true;
+			pretty = true;
 			break;
 		case 'v':
 			dl->verbose = true;
-- 
2.19.1

