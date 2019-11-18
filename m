Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8CFB10005F
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 09:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbfKRIfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 03:35:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726464AbfKRIfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Nov 2019 03:35:40 -0500
Received: from localhost (unknown [5.29.147.182])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 383B5206A4;
        Mon, 18 Nov 2019 08:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574066138;
        bh=muMxH1sVmfh+CNFxP+OFOBObso6gTGJH2QzJcrmpqks=;
        h=From:To:Cc:Subject:Date:From;
        b=Zqt0AHxB8SnNm7ettE0ShJJz0XQDZ4q4PrTB32doRGwoQSz0EaWjDbpuH+t3b+ZjI
         GSdaB2xLCP3Q4HCAIkGUPTv/v7oBvgzP++HcdnupW3gNftAmnWR3dArx2fkM6+hi/Q
         fwG68+GfJLLf3FOyi0PGRkjULWnctdFz0NHNQucY=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Kalir <idok@mellanox.com>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH iproute2-next] rdma: Rewrite custom JSON and prints logic to use common API
Date:   Mon, 18 Nov 2019 10:35:30 +0200
Message-Id: <20191118083530.51788-1-leon@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Kalir <idok@mellanox.com>

Instead of doing open-coded solution to generate JSON and prints, let's
reuse existing infrastructure and APIs to do the same as ip/*.

Before this change:
 if (rd->json_output)
     jsonw_uint_field(rd->jw, "sm_lid", sm_lid);
 else
     pr_out("sm_lid %u ", sm_lid);

After this change:
 print_uint(PRINT_ANY, "sm_lid", "sm_lid %u ", sm_lid);

All the print functions are converted to support color but for now the
type of color is COLOR_NONE. This is done as a preparation to addition
of color enable option. Such change will require rewrite of command line
arguments parser which is out-of-scope for this patch.

Signed-off-by: Ido Kalir <idok@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/dev.c      |  67 ++++++++-------------------
 rdma/link.c     |  98 +++++++++++-----------------------------
 rdma/rdma.c     |  20 ++------
 rdma/rdma.h     |   6 +--
 rdma/res-cmid.c |  38 ++++++----------
 rdma/res-cq.c   |  13 ++----
 rdma/res-mr.c   |   5 +-
 rdma/res-pd.c   |   4 +-
 rdma/res-qp.c   |  35 ++++----------
 rdma/res.c      |  71 ++++++-----------------------
 rdma/stat-mr.c  |   4 +-
 rdma/stat.c     |  76 ++++++++-----------------------
 rdma/sys.c      |   7 +--
 rdma/utils.c    | 118 ++++++++++++++++++++++--------------------------
 14 files changed, 170 insertions(+), 392 deletions(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index c597cba5..a11081b8 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -94,29 +94,16 @@ static void dev_print_caps(struct rd *rd, struct nlattr **tb)
 
 	caps = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_CAP_FLAGS]);
 
-	if (rd->json_output) {
-		jsonw_name(rd->jw, "caps");
-		jsonw_start_array(rd->jw);
-	} else {
-		pr_out("\n    caps: <");
-	}
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n    caps: <", NULL);
+	open_json_array(PRINT_JSON, "caps");
 	for (idx = 0; caps; idx++) {
-		if (caps & 0x1) {
-			if (rd->json_output) {
-				jsonw_string(rd->jw, dev_caps_to_str(idx));
-			} else {
-				pr_out("%s", dev_caps_to_str(idx));
-				if (caps >> 0x1)
-					pr_out(", ");
-			}
-		}
+		if (caps & 0x1)
+			print_color_string(PRINT_ANY, COLOR_NONE, NULL,
+					   caps >> 0x1 ? "%s, " : "%s",
+					   dev_caps_to_str(idx));
 		caps >>= 0x1;
 	}
-
-	if (rd->json_output)
-		jsonw_end_array(rd->jw);
-	else
-		pr_out(">");
+	close_json_array(PRINT_ANY, ">");
 }
 
 static void dev_print_fw(struct rd *rd, struct nlattr **tb)
@@ -126,10 +113,7 @@ static void dev_print_fw(struct rd *rd, struct nlattr **tb)
 		return;
 
 	str = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_FW_VERSION]);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "fw", str);
-	else
-		pr_out("fw %s ", str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "fw", "fw %s ", str);
 }
 
 static void dev_print_node_guid(struct rd *rd, struct nlattr **tb)
@@ -144,10 +128,8 @@ static void dev_print_node_guid(struct rd *rd, struct nlattr **tb)
 	node_guid = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_NODE_GUID]);
 	memcpy(vp, &node_guid, sizeof(uint64_t));
 	snprintf(str, 32, "%04x:%04x:%04x:%04x", vp[3], vp[2], vp[1], vp[0]);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "node_guid", str);
-	else
-		pr_out("node_guid %s ", str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "node_guid", "node_guid %s ",
+			   str);
 }
 
 static void dev_print_sys_image_guid(struct rd *rd, struct nlattr **tb)
@@ -162,10 +144,8 @@ static void dev_print_sys_image_guid(struct rd *rd, struct nlattr **tb)
 	sys_image_guid = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_SYS_IMAGE_GUID]);
 	memcpy(vp, &sys_image_guid, sizeof(uint64_t));
 	snprintf(str, 32, "%04x:%04x:%04x:%04x", vp[3], vp[2], vp[1], vp[0]);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "sys_image_guid", str);
-	else
-		pr_out("sys_image_guid %s ", str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "sys_image_guid",
+			   "sys_image_guid %s ", str);
 }
 
 static void dev_print_dim_setting(struct rd *rd, struct nlattr **tb)
@@ -205,10 +185,8 @@ static void dev_print_node_type(struct rd *rd, struct nlattr **tb)
 
 	node_type = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_DEV_NODE_TYPE]);
 	node_str = node_type_to_str(node_type);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "node_type", node_str);
-	else
-		pr_out("node_type %s ", node_str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "node_type", "node_type %s ",
+			   node_str);
 }
 
 static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
@@ -221,15 +199,11 @@ static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
 	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
 		return MNL_CB_ERROR;
-
+	open_json_object(NULL);
 	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	if (rd->json_output) {
-		jsonw_uint_field(rd->jw, "ifindex", idx);
-		jsonw_string_field(rd->jw, "ifname", name);
-	} else {
-		pr_out("%u: %s: ", idx, name);
-	}
+	print_color_uint(PRINT_ANY, COLOR_NONE, "ifindex", "%u: ", idx);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "%s: ", name);
 
 	dev_print_node_type(rd, tb);
 	dev_print_fw(rd, tb);
@@ -240,8 +214,7 @@ static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 		dev_print_caps(rd, tb);
 	}
 
-	if (!rd->json_output)
-		pr_out("\n");
+	newline(rd);
 	return MNL_CB_OK;
 }
 
@@ -257,11 +230,7 @@ static int dev_no_args(struct rd *rd)
 	if (ret)
 		return ret;
 
-	if (rd->json_output)
-		jsonw_start_object(rd->jw);
 	ret = rd_recv_msg(rd, dev_parse_cb, rd, seq);
-	if (rd->json_output)
-		jsonw_end_object(rd->jw);
 	return ret;
 }
 
diff --git a/rdma/link.c b/rdma/link.c
index 10b2e513..bf24b849 100644
--- a/rdma/link.c
+++ b/rdma/link.c
@@ -96,29 +96,16 @@ static void link_print_caps(struct rd *rd, struct nlattr **tb)
 
 	caps = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_CAP_FLAGS]);
 
-	if (rd->json_output) {
-		jsonw_name(rd->jw, "caps");
-		jsonw_start_array(rd->jw);
-	} else {
-		pr_out("\n    caps: <");
-	}
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n    caps: <", NULL);
+	open_json_array(PRINT_JSON, "caps");
 	for (idx = 0; caps; idx++) {
-		if (caps & 0x1) {
-			if (rd->json_output) {
-				jsonw_string(rd->jw, caps_to_str(idx));
-			} else {
-				pr_out("%s", caps_to_str(idx));
-				if (caps >> 0x1)
-					pr_out(", ");
-			}
-		}
+		if (caps & 0x1)
+			print_color_string(PRINT_ANY, COLOR_NONE, NULL,
+					   caps >> 0x1 ? "%s, " : "%s",
+					   caps_to_str(idx));
 		caps >>= 0x1;
 	}
-
-	if (rd->json_output)
-		jsonw_end_array(rd->jw);
-	else
-		pr_out(">");
+	close_json_array(PRINT_ANY, ">");
 }
 
 static void link_print_subnet_prefix(struct rd *rd, struct nlattr **tb)
@@ -133,10 +120,8 @@ static void link_print_subnet_prefix(struct rd *rd, struct nlattr **tb)
 	subnet_prefix = mnl_attr_get_u64(tb[RDMA_NLDEV_ATTR_SUBNET_PREFIX]);
 	memcpy(vp, &subnet_prefix, sizeof(uint64_t));
 	snprintf(str, 32, "%04x:%04x:%04x:%04x", vp[3], vp[2], vp[1], vp[0]);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "subnet_prefix", str);
-	else
-		pr_out("subnet_prefix %s ", str);
+	print_color_string(PRINT_ANY, COLOR_NONE, "subnet_prefix",
+			   "subnet_prefix %s ", str);
 }
 
 static void link_print_lid(struct rd *rd, struct nlattr **tb)
@@ -147,10 +132,7 @@ static void link_print_lid(struct rd *rd, struct nlattr **tb)
 		return;
 
 	lid = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_LID]);
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "lid", lid);
-	else
-		pr_out("lid %u ", lid);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "lid", "lid %u ", lid);
 }
 
 static void link_print_sm_lid(struct rd *rd, struct nlattr **tb)
@@ -161,10 +143,7 @@ static void link_print_sm_lid(struct rd *rd, struct nlattr **tb)
 		return;
 
 	sm_lid = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_SM_LID]);
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "sm_lid", sm_lid);
-	else
-		pr_out("sm_lid %u ", sm_lid);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "sm_lid", "sm_lid %u ", sm_lid);
 }
 
 static void link_print_lmc(struct rd *rd, struct nlattr **tb)
@@ -175,10 +154,7 @@ static void link_print_lmc(struct rd *rd, struct nlattr **tb)
 		return;
 
 	lmc = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_LMC]);
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "lmc", lmc);
-	else
-		pr_out("lmc %u ", lmc);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "lmc", "lmc %u ", lmc);
 }
 
 static const char *link_state_to_str(uint8_t link_state)
@@ -200,10 +176,8 @@ static void link_print_state(struct rd *rd, struct nlattr **tb)
 		return;
 
 	state = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_PORT_STATE]);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "state", link_state_to_str(state));
-	else
-		pr_out("state %s ", link_state_to_str(state));
+	print_color_string(PRINT_ANY, COLOR_NONE, "state", "state %s ",
+			   link_state_to_str(state));
 }
 
 static const char *phys_state_to_str(uint8_t phys_state)
@@ -228,11 +202,8 @@ static void link_print_phys_state(struct rd *rd, struct nlattr **tb)
 		return;
 
 	phys_state = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_PORT_PHYS_STATE]);
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "physical_state",
-				   phys_state_to_str(phys_state));
-	else
-		pr_out("physical_state %s ", phys_state_to_str(phys_state));
+	print_color_string(PRINT_ANY, COLOR_NONE, "physical_state",
+			   "physical_state %s ", phys_state_to_str(phys_state));
 }
 
 static void link_print_netdev(struct rd *rd, struct nlattr **tb)
@@ -245,14 +216,10 @@ static void link_print_netdev(struct rd *rd, struct nlattr **tb)
 
 	netdev_name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_NDEV_NAME]);
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_NDEV_INDEX]);
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "netdev", netdev_name);
-		jsonw_uint_field(rd->jw, "netdev_index", idx);
-	} else {
-		pr_out("netdev %s ", netdev_name);
-		if (rd->show_details)
-			pr_out("netdev_index %u ", idx);
-	}
+	print_color_string(PRINT_ANY, COLOR_NONE, "netdev", "netdev %s ",
+			   netdev_name);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "netdev_index",
+			 rd->show_details ? "netdev_index %u " : "", idx);
 }
 
 static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
@@ -260,7 +227,7 @@ static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
 	struct rd *rd = data;
 	uint32_t port, idx;
-	char name[32];
+	const char *name;
 
 	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
 	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
@@ -273,18 +240,12 @@ static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	snprintf(name, 32, "%s/%u",
-		 mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]), port);
-
-	if (rd->json_output) {
-		jsonw_uint_field(rd->jw, "ifindex", idx);
-		jsonw_uint_field(rd->jw, "port", port);
-		jsonw_string_field(rd->jw, "ifname", name);
-
-	} else {
-		pr_out("%u/%u: %s: ", idx, port, name);
-	}
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 
+	open_json_object(NULL);
+	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "link %s/", name);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
 	link_print_subnet_prefix(rd, tb);
 	link_print_lid(rd, tb);
 	link_print_sm_lid(rd, tb);
@@ -295,8 +256,7 @@ static int link_parse_cb(const struct nlmsghdr *nlh, void *data)
 	if (rd->show_details)
 		link_print_caps(rd, tb);
 
-	if (!rd->json_output)
-		pr_out("\n");
+	newline(rd);
 	return MNL_CB_OK;
 }
 
@@ -313,11 +273,7 @@ static int link_no_args(struct rd *rd)
 	if (ret)
 		return ret;
 
-	if (rd->json_output)
-		jsonw_start_object(rd->jw);
 	ret = rd_recv_msg(rd, link_parse_cb, rd, seq);
-	if (rd->json_output)
-		jsonw_end_object(rd->jw);
 	return ret;
 }
 
diff --git a/rdma/rdma.c b/rdma/rdma.c
index 4e34da92..22050555 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -6,6 +6,7 @@
 
 #include "rdma.h"
 #include "SNAPSHOT.h"
+#include "color.h"
 
 static void help(char *name)
 {
@@ -85,15 +86,6 @@ static int rd_init(struct rd *rd, char *filename)
 	INIT_LIST_HEAD(&rd->dev_map_list);
 	INIT_LIST_HEAD(&rd->filter_list);
 
-	if (rd->json_output) {
-		rd->jw = jsonw_new(stdout);
-		if (!rd->jw) {
-			pr_err("Failed to create JSON writer\n");
-			return -ENOMEM;
-		}
-		jsonw_pretty(rd->jw, rd->pretty_output);
-	}
-
 	rd->buff = malloc(MNL_SOCKET_BUFFER_SIZE);
 	if (!rd->buff)
 		return -ENOMEM;
@@ -109,8 +101,6 @@ static int rd_init(struct rd *rd, char *filename)
 
 static void rd_cleanup(struct rd *rd)
 {
-	if (rd->json_output)
-		jsonw_destroy(&rd->jw);
 	rd_free(rd);
 }
 
@@ -128,7 +118,6 @@ int main(int argc, char **argv)
 	};
 	bool show_driver_details = false;
 	const char *batch_file = NULL;
-	bool pretty_output = false;
 	bool show_details = false;
 	bool json_output = false;
 	bool force = false;
@@ -136,7 +125,6 @@ int main(int argc, char **argv)
 	char *filename;
 	int opt;
 	int err;
-
 	filename = basename(argv[0]);
 
 	while ((opt = getopt_long(argc, argv, ":Vhdpjfb:",
@@ -147,7 +135,7 @@ int main(int argc, char **argv)
 			       filename, SNAPSHOT);
 			return EXIT_SUCCESS;
 		case 'p':
-			pretty_output = true;
+			pretty = 1;
 			break;
 		case 'd':
 			if (show_details)
@@ -156,7 +144,7 @@ int main(int argc, char **argv)
 				show_details = true;
 			break;
 		case 'j':
-			json_output = true;
+			json_output = 1;
 			break;
 		case 'f':
 			force = true;
@@ -183,7 +171,7 @@ int main(int argc, char **argv)
 	rd.show_details = show_details;
 	rd.show_driver_details = show_driver_details;
 	rd.json_output = json_output;
-	rd.pretty_output = pretty_output;
+	rd.pretty_output = pretty;
 
 	err = rd_init(&rd, filename);
 	if (err)
diff --git a/rdma/rdma.h b/rdma/rdma.h
index dfd1b70b..735b1bf7 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -19,7 +19,7 @@
 
 #include "list.h"
 #include "utils.h"
-#include "json_writer.h"
+#include "json_print.h"
 
 #define pr_err(args...) fprintf(stderr, ##args)
 #define pr_out(args...) fprintf(stdout, ##args)
@@ -66,8 +66,8 @@ struct rd {
 	struct nlmsghdr *nlh;
 	char *buff;
 	json_writer_t *jw;
-	bool json_output;
-	bool pretty_output;
+	int json_output;
+	int pretty_output;
 	bool suppress_errors;
 	struct list_head filter_list;
 	char *link_name;
diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index 0ee9c3d4..f167800f 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -9,10 +9,8 @@
 
 static void print_qp_type(struct rd *rd, uint32_t val)
 {
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "qp-type", qp_types_to_str(val));
-	else
-		pr_out("qp-type %s ", qp_types_to_str(val));
+	print_color_string(PRINT_ANY, COLOR_NONE, "qp-type", "qp-type %s ",
+			   qp_types_to_str(val));
 }
 
 static const char *cm_id_state_to_str(uint8_t idx)
@@ -47,34 +45,26 @@ static const char *cm_id_ps_to_str(uint32_t ps)
 
 static void print_cm_id_state(struct rd *rd, uint8_t state)
 {
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "state", cm_id_state_to_str(state));
-		return;
-	}
-	pr_out("state %s ", cm_id_state_to_str(state));
+	print_color_string(PRINT_ANY, COLOR_NONE, "state", "state %s ",
+			   cm_id_state_to_str(state));
 }
 
 static void print_ps(struct rd *rd, uint32_t ps)
 {
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "ps", cm_id_ps_to_str(ps));
-		return;
-	}
-	pr_out("ps %s ", cm_id_ps_to_str(ps));
+	print_color_string(PRINT_ANY, COLOR_NONE, "ps", "ps %s ",
+			   cm_id_ps_to_str(ps));
 }
 
 static void print_ipaddr(struct rd *rd, const char *key, char *addrstr,
 			 uint16_t port)
 {
-	if (rd->json_output) {
-		int name_size = INET6_ADDRSTRLEN + strlen(":65535");
-		char json_name[name_size];
+	int name_size = INET6_ADDRSTRLEN + strlen(":65535");
+	char json_name[name_size];
 
-		snprintf(json_name, name_size, "%s:%u", addrstr, port);
-		jsonw_string_field(rd->jw, key, json_name);
-		return;
-	}
-	pr_out("%s %s:%u ", key, addrstr, port);
+	snprintf(json_name, name_size, "%s:%u", addrstr, port);
+	print_color_string(PRINT_ANY, COLOR_NONE, key, key, json_name);
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, " %s:", addrstr);
+	print_color_uint(PRINT_FP, COLOR_NONE, NULL, "%u ", port);
 }
 
 static int ss_ntop(struct nlattr *nla_line, char *addr_str, uint16_t *port)
@@ -195,9 +185,7 @@ static int res_cm_id_line(struct rd *rd, const char *name, int idx,
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 	}
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
-
+	open_json_object(NULL);
 	print_link(rd, idx, name, port, nla_line);
 	res_print_uint(rd, "cm-idn", cm_idn,
 		       nla_line[RDMA_NLDEV_ATTR_RES_CM_IDN]);
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 6855e798..e1efe3ba 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -21,13 +21,8 @@ static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx, struct nlattr *attr)
 {
 	if (!attr)
 		return;
-
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "poll-ctx",
-				   poll_ctx_to_str(poll_ctx));
-		return;
-	}
-	pr_out("poll-ctx %s ", poll_ctx_to_str(poll_ctx));
+	print_color_string(PRINT_ANY, COLOR_NONE, "poll-ctx", "poll-ctx %s ",
+			   poll_ctx_to_str(poll_ctx));
 }
 
 static void print_cq_dim_setting(struct rd *rd, struct nlattr *attr)
@@ -99,9 +94,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 		comm = (char *)mnl_attr_get_str(
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
-
+	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
 	res_print_uint(rd, "cqe", cqe, nla_line[RDMA_NLDEV_ATTR_RES_CQE]);
diff --git a/rdma/res-mr.c b/rdma/res-mr.c
index c1b8069a..c1366035 100644
--- a/rdma/res-mr.c
+++ b/rdma/res-mr.c
@@ -57,10 +57,7 @@ static int res_mr_line(struct rd *rd, const char *name, int idx,
 		/* discard const from mnl_attr_get_str */
 		comm = (char *)mnl_attr_get_str(
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
-
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
-
+	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
 	print_key(rd, "rkey", rkey, nla_line[RDMA_NLDEV_ATTR_RES_RKEY]);
diff --git a/rdma/res-pd.c b/rdma/res-pd.c
index 6e5e4e6b..df538010 100644
--- a/rdma/res-pd.c
+++ b/rdma/res-pd.c
@@ -60,9 +60,7 @@ static int res_pd_line(struct rd *rd, const char *name, int idx,
 		comm = (char *)mnl_attr_get_str(
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
-
+	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
 	print_key(rd, "local_dma_lkey", local_dma_lkey,
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index e30d68ed..801cfca9 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -32,27 +32,19 @@ static void print_rqpn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 {
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
 		return;
-
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "rqpn", val);
-	else
-		pr_out("rqpn %u ", val);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "rqpn", "rqpn %d ", val);
 }
 
 static void print_type(struct rd *rd, uint32_t val)
 {
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "type", qp_types_to_str(val));
-	else
-		pr_out("type %s ", qp_types_to_str(val));
+	print_color_string(PRINT_ANY, COLOR_NONE, "type", "type %s ",
+			   qp_types_to_str(val));
 }
 
 static void print_state(struct rd *rd, uint32_t val)
 {
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "state", qp_states_to_str(val));
-	else
-		pr_out("state %s ", qp_states_to_str(val));
+	print_color_string(PRINT_ANY, COLOR_NONE, "state", "state %s ",
+			   qp_states_to_str(val));
 }
 
 static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
@@ -60,10 +52,7 @@ static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
 		return;
 
-	if (rd->json_output)
-		jsonw_uint_field(rd->jw, "rq-psn", val);
-	else
-		pr_out("rq-psn %u ", val);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "rq-psn", "rq-psn %d ", val);
 }
 
 static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
@@ -71,11 +60,8 @@ static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
 		return;
 
-	if (rd->json_output)
-		jsonw_string_field(rd->jw, "path-mig-state",
-				   path_mig_to_str(val));
-	else
-		pr_out("path-mig-state %s ", path_mig_to_str(val));
+	print_color_string(PRINT_ANY, COLOR_NONE, "path-mig-state",
+			   "path-mig-state %s ", path_mig_to_str(val));
 }
 
 static int res_qp_line(struct rd *rd, const char *name, int idx,
@@ -159,11 +145,8 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		comm = (char *)mnl_attr_get_str(
 			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
-
+	open_json_object(NULL);
 	print_link(rd, idx, name, port, nla_line);
-
 	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 	print_rqpn(rd, rqpn, nla_line);
 
diff --git a/rdma/res.c b/rdma/res.c
index 7cd05721..251f5041 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -74,17 +74,11 @@ static int res_no_args_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
-	if (rd->json_output) {
-		jsonw_uint_field(rd->jw, "ifindex", idx);
-		jsonw_string_field(rd->jw, "ifname", name);
-	} else {
-		pr_out("%u: %s: ", idx, name);
-	}
-
+	open_json_object(NULL);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "ifindex", "%u: ", idx);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "%s: ", name);
 	res_print_summary(rd, tb);
-
-	if (!rd->json_output)
-		pr_out("\n");
+	newline(rd);
 	return MNL_CB_OK;
 }
 
@@ -110,12 +104,7 @@ int _res_send_idx_msg(struct rd *rd, uint32_t command, mnl_cb_t callback,
 	ret = rd_send_msg(rd);
 	if (ret)
 		return ret;
-
-	if (rd->json_output)
-		jsonw_start_object(rd->jw);
 	ret = rd_recv_msg(rd, callback, rd, seq);
-	if (rd->json_output)
-		jsonw_end_object(rd->jw);
 	return ret;
 }
 
@@ -142,11 +131,7 @@ int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 	if (ret)
 		return ret;
 
-	if (rd->json_output)
-		jsonw_start_object(rd->jw);
 	ret = rd_recv_msg(rd, callback, rd, seq);
-	if (rd->json_output)
-		jsonw_end_object(rd->jw);
 	return ret;
 }
 
@@ -172,46 +157,26 @@ void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
 	if (!str)
 		return;
 
-	if (rd->json_output) {
-		/* Don't beatify output in JSON format */
-		jsonw_string_field(rd->jw, "comm", str);
-		return;
-	}
-
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 		snprintf(tmp, sizeof(tmp), "%s", str);
 	else
 		snprintf(tmp, sizeof(tmp), "[%s]", str);
-
-	pr_out("comm %s ", tmp);
+	print_color_string(PRINT_ANY, COLOR_NONE, "comm", "comm %s ", str);
 }
 
 void print_dev(struct rd *rd, uint32_t idx, const char *name)
 {
-	if (rd->json_output) {
-		jsonw_uint_field(rd->jw, "ifindex", idx);
-		jsonw_string_field(rd->jw, "ifname", name);
-	} else {
-		pr_out("dev %s ", name);
-	}
+	print_color_int(PRINT_ANY, COLOR_NONE, "ifindex", "ifindex %d ", idx);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "ifname %s ", name);
 }
 
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line)
 {
-	if (rd->json_output) {
-		jsonw_uint_field(rd->jw, "ifindex", idx);
-
-		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-			jsonw_uint_field(rd->jw, "port", port);
-
-		jsonw_string_field(rd->jw, "ifname", name);
-	} else {
-		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-			pr_out("link %s/%u ", name, port);
-		else
-			pr_out("link %s/- ", name);
-	}
+	print_color_uint(PRINT_JSON, COLOR_NONE, "ifindex", NULL, idx);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "link %s/", name);
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+		print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
 }
 
 char *get_task_name(uint32_t pid)
@@ -243,11 +208,8 @@ void print_key(struct rd *rd, const char *name, uint64_t val,
 {
 	if (!nlattr)
 		return;
-
-	if (rd->json_output)
-		jsonw_xint_field(rd->jw, name, val);
-	else
-		pr_out("%s 0x%" PRIx64 " ", name, val);
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, name, NULL);
+	print_color_hex(PRINT_ANY, COLOR_NONE, name, " 0x%" PRIx64 " ", val);
 }
 
 void res_print_uint(struct rd *rd, const char *name, uint64_t val,
@@ -255,11 +217,8 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
 {
 	if (!nlattr)
 		return;
-
-	if (rd->json_output)
-		jsonw_u64_field(rd->jw, name, val);
-	else
-		pr_out("%s %" PRIu64 " ", name, val);
+	print_color_uint(PRINT_ANY, COLOR_NONE, name, name, val);
+	print_color_uint(PRINT_FP, COLOR_NONE, NULL, " %d ", val);
 }
 
 RES_FUNC(res_no_args,	RDMA_NLDEV_CMD_RES_GET,	NULL, true, 0);
diff --git a/rdma/stat-mr.c b/rdma/stat-mr.c
index 11f042d4..f39526b4 100644
--- a/rdma/stat-mr.c
+++ b/rdma/stat-mr.c
@@ -20,9 +20,7 @@ static int stat_mr_line(struct rd *rd, const char *name, int idx,
 				nla_line[RDMA_NLDEV_ATTR_RES_MRN]))
 		goto out;
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
-
+	open_json_object(NULL);
 	print_dev(rd, idx, name);
 	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
 
diff --git a/rdma/stat.c b/rdma/stat.c
index c5641522..2f575287 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -115,14 +115,10 @@ static int qp_link_get_mode_parse_cb(const struct nlmsghdr *nlh, void *data)
 		snprintf(output, sizeof(output), "qp auto off");
 	}
 
-	if (rd->json_output) {
-		jsonw_uint_field(rd->jw, "ifindex", idx);
-		jsonw_uint_field(rd->jw, "port", port);
-		jsonw_string_field(rd->jw, "mode", output);
-	} else {
-		pr_out("%u/%u: %s/%u: %s\n", idx, port, name, port, output);
-	}
-
+	open_json_object(NULL);
+	print_link(rd, idx, name, port, tb);
+	print_color_string(PRINT_ANY, COLOR_NONE, "mode", "mode %s ", output);
+	newline(rd);
 	return MNL_CB_OK;
 }
 
@@ -149,12 +145,7 @@ static int stat_one_qp_link_get_mode(struct rd *rd)
 	if (ret)
 		return ret;
 
-	if (rd->json_output)
-		jsonw_start_object(rd->jw);
 	ret = rd_recv_msg(rd, qp_link_get_mode_parse_cb, rd, seq);
-	if (rd->json_output)
-		jsonw_end_object(rd->jw);
-
 	return ret;
 }
 
@@ -262,31 +253,17 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	err = res_get_hwcounters(rd, hwc_table, false);
 	if (err != MNL_CB_OK)
 		return err;
-
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "ifname", name);
-		if (port)
-			jsonw_uint_field(rd->jw, "port", port);
-		jsonw_uint_field(rd->jw, "cntn", cntn);
-	} else {
-		if (port)
-			pr_out("link %s/%u cntn %u ", name, port, cntn);
-		else
-			pr_out("dev %s cntn %u ", name, cntn);
-	}
-
+	open_json_object(NULL);
+	print_link(rd, index, name, port, nla_line);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "cntn", "cntn %u ", cntn);
 	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
-
 	res_get_hwcounters(rd, hwc_table, true);
-
 	isfirst = true;
+	open_json_array(PRINT_JSON, "lqpn");
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n    LQPN: <", NULL);
 	mnl_attr_for_each_nested(nla_entry, qp_table) {
 		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
-
-		if (isfirst && !rd->json_output)
-			pr_out("\n    LQPN: <");
-
 		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
 		if (err != MNL_CB_OK)
 			return -EINVAL;
@@ -295,19 +272,14 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 			return -EINVAL;
 
 		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-		if (rd->json_output) {
-			jsonw_uint_field(rd->jw, "lqpn", qpn);
-		} else {
-			if (isfirst)
-				pr_out("%d", qpn);
-			else
-				pr_out(", %d", qpn);
-		}
+		if (!isfirst)
+			print_color_string(PRINT_FP, COLOR_NONE, NULL, ",",
+					   NULL);
+		print_color_uint(PRINT_ANY, COLOR_NONE, NULL, "%d", qpn);
 		isfirst = false;
 	}
-
-	if (!rd->json_output)
-		pr_out(">\n");
+	close_json_array(PRINT_ANY, ">");
+	newline(rd);
 	return MNL_CB_OK;
 }
 
@@ -371,12 +343,7 @@ static int stat_qp_show_one_link(struct rd *rd)
 	if (ret)
 		return ret;
 
-	if (rd->json_output)
-		jsonw_start_object(rd->jw);
 	ret = rd_recv_msg(rd, stat_qp_show_parse_cb, rd, seq);
-	if (rd->json_output)
-		jsonw_end_object(rd->jw);
-
 	return ret;
 }
 
@@ -695,17 +662,12 @@ static int stat_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, "ifname", name);
-		jsonw_uint_field(rd->jw, "port", port);
-	} else {
-		pr_out("link %s/%u ", name, port);
-	}
-
+	open_json_object(NULL);
+	print_color_string(PRINT_ANY, COLOR_NONE, "ifname", "link %s/", name);
+	print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
 	ret = res_get_hwcounters(rd, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], true);
 
-	if (!rd->json_output)
-		pr_out("\n");
+	newline(rd);
 	return ret;
 }
 
diff --git a/rdma/sys.c b/rdma/sys.c
index 1a434a25..8fb565d7 100644
--- a/rdma/sys.c
+++ b/rdma/sys.c
@@ -20,7 +20,6 @@ static const char *netns_modes_str[] = {
 static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 {
 	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
-	struct rd *rd = data;
 
 	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
 
@@ -36,10 +35,8 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
 		else
 			mode_str = "unknown";
 
-		if (rd->json_output)
-			jsonw_string_field(rd->jw, "netns", mode_str);
-		else
-			pr_out("netns %s\n", mode_str);
+		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s\n",
+				   mode_str);
 	}
 	return MNL_CB_OK;
 }
diff --git a/rdma/utils.c b/rdma/utils.c
index 37659011..e25c3adf 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -548,8 +548,7 @@ int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port)
 	uint32_t port;
 	int ret = 0;
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
+	new_json_obj(rd->json_output);
 	if (rd_no_arg(rd)) {
 		list_for_each_entry(dev_map, &rd->dev_map_list, list) {
 			rd->dev_idx = dev_map->idx;
@@ -589,8 +588,7 @@ int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port)
 	}
 
 out:
-	if (rd->json_output)
-		jsonw_end_array(rd->jw);
+	delete_json_obj();
 	return ret;
 }
 
@@ -599,8 +597,7 @@ int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd))
 	struct dev_map *dev_map;
 	int ret = 0;
 
-	if (rd->json_output)
-		jsonw_start_array(rd->jw);
+	new_json_obj(rd->json_output);
 	if (rd_no_arg(rd)) {
 		list_for_each_entry(dev_map, &rd->dev_map_list, list) {
 			rd->dev_idx = dev_map->idx;
@@ -620,8 +617,7 @@ int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd))
 		ret = cb(rd);
 	}
 out:
-	if (rd->json_output)
-		jsonw_end_array(rd->jw);
+	delete_json_obj();
 	return ret;
 }
 
@@ -766,28 +762,22 @@ struct dev_map *dev_map_lookup(struct rd *rd, bool allow_port_index)
 
 void newline(struct rd *rd)
 {
-	if (rd->json_output)
-		jsonw_end_array(rd->jw);
-	else
-		pr_out("\n");
+	close_json_object();
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, "\n", NULL);
 }
 
 void newline_indent(struct rd *rd)
 {
 	newline(rd);
-	if (!rd->json_output)
-		pr_out("    ");
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, "    ", NULL);
 }
 
 static int print_driver_string(struct rd *rd, const char *key_str,
 				 const char *val_str)
 {
-	if (rd->json_output) {
-		jsonw_string_field(rd->jw, key_str, val_str);
-		return 0;
-	} else {
-		return pr_out("%s %s ", key_str, val_str);
-	}
+	print_color_string(PRINT_ANY, COLOR_NONE, key_str, key_str, val_str);
+	print_color_string(PRINT_FP, COLOR_NONE, NULL, " %s ", val_str);
+	return 0;
 }
 
 void print_on_off(struct rd *rd, const char *key_str, bool on)
@@ -798,69 +788,69 @@ void print_on_off(struct rd *rd, const char *key_str, bool on)
 static int print_driver_s32(struct rd *rd, const char *key_str, int32_t val,
 			      enum rdma_nldev_print_type print_type)
 {
-	if (rd->json_output) {
-		jsonw_int_field(rd->jw, key_str, val);
-		return 0;
-	}
-	switch (print_type) {
-	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
-		return pr_out("%s %d ", key_str, val);
-	case RDMA_NLDEV_PRINT_TYPE_HEX:
-		return pr_out("%s 0x%x ", key_str, val);
-	default:
-		return -EINVAL;
+	if (!rd->json_output) {
+		switch (print_type) {
+		case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+			return pr_out("%s %d ", key_str, val);
+		case RDMA_NLDEV_PRINT_TYPE_HEX:
+			return pr_out("%s 0x%x ", key_str, val);
+		default:
+			return -EINVAL;
+		}
 	}
+	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	return 0;
 }
 
 static int print_driver_u32(struct rd *rd, const char *key_str, uint32_t val,
 			      enum rdma_nldev_print_type print_type)
 {
-	if (rd->json_output) {
-		jsonw_int_field(rd->jw, key_str, val);
-		return 0;
-	}
-	switch (print_type) {
-	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
-		return pr_out("%s %u ", key_str, val);
-	case RDMA_NLDEV_PRINT_TYPE_HEX:
-		return pr_out("%s 0x%x ", key_str, val);
-	default:
-		return -EINVAL;
+	if (!rd->json_output) {
+		switch (print_type) {
+		case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+			return pr_out("%s %u ", key_str, val);
+		case RDMA_NLDEV_PRINT_TYPE_HEX:
+			return pr_out("%s 0x%x ", key_str, val);
+		default:
+			return -EINVAL;
+		}
 	}
+	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	return 0;
 }
 
 static int print_driver_s64(struct rd *rd, const char *key_str, int64_t val,
 			      enum rdma_nldev_print_type print_type)
 {
-	if (rd->json_output) {
-		jsonw_int_field(rd->jw, key_str, val);
-		return 0;
-	}
-	switch (print_type) {
-	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
-		return pr_out("%s %" PRId64 " ", key_str, val);
-	case RDMA_NLDEV_PRINT_TYPE_HEX:
-		return pr_out("%s 0x%" PRIx64 " ", key_str, val);
-	default:
-		return -EINVAL;
+	if (!rd->json_output) {
+		switch (print_type) {
+		case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+			return pr_out("%s %" PRId64 " ", key_str, val);
+		case RDMA_NLDEV_PRINT_TYPE_HEX:
+			return pr_out("%s 0x%" PRIx64 " ", key_str, val);
+		default:
+			return -EINVAL;
+		}
 	}
+	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	return 0;
 }
 
 static int print_driver_u64(struct rd *rd, const char *key_str, uint64_t val,
 			      enum rdma_nldev_print_type print_type)
 {
-	if (rd->json_output) {
-		jsonw_int_field(rd->jw, key_str, val);
-		return 0;
-	}
-	switch (print_type) {
-	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
-		return pr_out("%s %" PRIu64 " ", key_str, val);
-	case RDMA_NLDEV_PRINT_TYPE_HEX:
-		return pr_out("%s 0x%" PRIx64 " ", key_str, val);
-	default:
-		return -EINVAL;
+	if (!rd->json_output) {
+		switch (print_type) {
+		case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
+			return pr_out("%s %" PRIu64 " ", key_str, val);
+		case RDMA_NLDEV_PRINT_TYPE_HEX:
+			return pr_out("%s 0x%" PRIx64 " ", key_str, val);
+		default:
+			return -EINVAL;
+		}
 	}
+	print_color_int(PRINT_JSON, COLOR_NONE, key_str, NULL, val);
+	return 0;
 }
 
 static int print_driver_entry(struct rd *rd, struct nlattr *key_attr,
-- 
2.20.1

