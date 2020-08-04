Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CA123B70A
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 10:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730000AbgHDIt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 04:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726233AbgHDIt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 04:49:29 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6E232075D;
        Tue,  4 Aug 2020 08:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596530968;
        bh=fjJjn3m2BoYC2H6sV6Tj3PBYC9sDR5hbmtPKyA5xZYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n5LDGmXsJXFPZxE+DGY/46IpuLzfOYN/MN73ZfIt43JWFUV8LKHDrdSQzfR2kK7d0
         G3OwDl2P9SxEeuTha+JTj77OG67ebQSSVmYkppYAS8tJLJUMIqu3R3xng/gm7XGcqA
         nTD7ylva490LWibFLMdET+TC0TOEIzzPKjMPMKuo=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Ido Kalir <idok@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 2/3] rdma: Add "PID" criteria support for statistic counter auto mode
Date:   Tue,  4 Aug 2020 11:49:08 +0300
Message-Id: <20200804084909.604846-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200804084909.604846-1-leon@kernel.org>
References: <20200804084909.604846-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

With this new criteria, QPs have different PIDs will be bound to
different counters in auto mode. This can be used in combination with
other criteria like "type". Examples:

$ rdma statistic qp set link mlx5_2/1 auto pid on
$ rdma statistic qp set link mlx5_2/1 auto type,pid on
$ rdma statistic qp set link mlx5_2/1 auto off
$ rdma statistic qp show link mlx5_0 qp-type UD

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Ido Kalir <idok@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-cmid.c |  6 ----
 rdma/res.c      |  6 ++++
 rdma/res.h      |  2 +-
 rdma/stat.c     | 95 ++++++++++++++++++++++++++++++++++++-------------
 4 files changed, 78 insertions(+), 31 deletions(-)

diff --git a/rdma/res-cmid.c b/rdma/res-cmid.c
index f167800f..bfaa47b5 100644
--- a/rdma/res-cmid.c
+++ b/rdma/res-cmid.c
@@ -7,12 +7,6 @@
 #include "res.h"
 #include <inttypes.h>
 
-static void print_qp_type(struct rd *rd, uint32_t val)
-{
-	print_color_string(PRINT_ANY, COLOR_NONE, "qp-type", "qp-type %s ",
-			   qp_types_to_str(val));
-}
-
 static const char *cm_id_state_to_str(uint8_t idx)
 {
 	static const char *const cm_id_states_str[] = {
diff --git a/rdma/res.c b/rdma/res.c
index 251f5041..c99a1fcb 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -179,6 +179,12 @@ void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		print_color_uint(PRINT_ANY, COLOR_NONE, "port", "%u ", port);
 }
 
+void print_qp_type(struct rd *rd, uint32_t val)
+{
+	print_color_string(PRINT_ANY, COLOR_NONE, "qp-type", "qp-type %s ",
+			   qp_types_to_str(val));
+}
+
 char *get_task_name(uint32_t pid)
 {
 	char *comm;
diff --git a/rdma/res.h b/rdma/res.h
index 70ce5758..707941da 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -165,5 +165,5 @@ void res_print_uint(struct rd *rd, const char *name, uint64_t val,
 		    struct nlattr *nlattr);
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line);
 const char *qp_types_to_str(uint8_t idx);
-
+void print_qp_type(struct rd *rd, uint32_t val);
 #endif /* _RDMA_TOOL_RES_H_ */
diff --git a/rdma/stat.c b/rdma/stat.c
index 8d4b7a11..a2b5da1c 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -48,6 +48,7 @@ struct counter_param {
 
 static struct counter_param auto_params[] = {
 	{ "type", RDMA_COUNTER_MASK_QP_TYPE, },
+	{ "pid", RDMA_COUNTER_MASK_PID, },
 	{ NULL },
 };
 
@@ -56,6 +57,7 @@ static int prepare_auto_mode_str(struct nlattr **tb, uint32_t mask,
 {
 	char s[] = "qp auto";
 	int i, outlen = strlen(s);
+	bool first = true;
 
 	memset(output, 0, len);
 	snprintf(output, len, "%s", s);
@@ -66,7 +68,12 @@ static int prepare_auto_mode_str(struct nlattr **tb, uint32_t mask,
 				outlen += strlen(auto_params[i].name) + 1;
 				if (outlen >= len)
 					return -EINVAL;
-				strcat(output, " ");
+				if (first) {
+					strcat(output, " ");
+					first = false;
+				} else
+					strcat(output, ",");
+
 				strcat(output, auto_params[i].name);
 			}
 		}
@@ -202,7 +209,7 @@ int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table, bool print)
 static int res_counter_line(struct rd *rd, const char *name, int index,
 		       struct nlattr **nla_line)
 {
-	uint32_t cntn, port = 0, pid = 0, qpn;
+	uint32_t cntn, port = 0, pid = 0, qpn, qp_type = 0;
 	struct nlattr *hwc_table, *qp_table;
 	struct nlattr *nla_entry;
 	const char *comm = NULL;
@@ -223,6 +230,13 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 				nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]))
 		return MNL_CB_OK;
 
+	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
+		qp_type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+
+	if (rd_is_string_filtered_attr(rd, "qp-type", qp_types_to_str(qp_type),
+				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE]))
+		return MNL_CB_OK;
+
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
 		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 		comm = get_task_name(pid);
@@ -257,6 +271,8 @@ static int res_counter_line(struct rd *rd, const char *name, int index,
 	open_json_object(NULL);
 	print_link(rd, index, name, port, nla_line);
 	print_color_uint(PRINT_ANY, COLOR_NONE, "cntn", "cntn %u ", cntn);
+	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
+		print_qp_type(rd, qp_type);
 	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
 	res_get_hwcounters(rd, hwc_table, true);
@@ -321,6 +337,7 @@ static const struct filters stat_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 	{ .name = "cntn", .is_number = true },
 	{ .name = "lqpn", .is_number = true },
 	{ .name = "pid", .is_number = true },
+	{ .name = "qp-type", .is_number = false },
 };
 
 static int stat_qp_show_one_link(struct rd *rd)
@@ -382,37 +399,67 @@ static int stat_qp_set_link_auto_sendmsg(struct rd *rd, uint32_t mask)
 	return rd_sendrecv_msg(rd, seq);
 }
 
-static int stat_one_qp_set_link_auto_off(struct rd *rd)
+static int stat_get_auto_mode_mask(struct rd *rd)
 {
-	return stat_qp_set_link_auto_sendmsg(rd, 0);
-}
+	char *modes = rd_argv(rd), *mode, *saved_ptr;
+	const char *delim = ",";
+	int mask = 0, found, i;
 
-static int stat_one_qp_set_auto_type_on(struct rd *rd)
-{
-	return stat_qp_set_link_auto_sendmsg(rd, RDMA_COUNTER_MASK_QP_TYPE);
-}
+	if (!modes)
+		return mask;
 
-static int stat_one_qp_set_link_auto_type(struct rd *rd)
-{
-	const struct rd_cmd cmds[] = {
-		{ NULL,		stat_help },
-		{ "on",		stat_one_qp_set_auto_type_on },
-		{ 0 }
-	};
+	mode = strtok_r(modes, delim, &saved_ptr);
+	do {
+		if (!mode)
+			break;
 
-	return rd_exec_cmd(rd, cmds, "parameter");
+		found = false;
+		for (i = 0;  auto_params[i].name != NULL; i++) {
+			if (!strcmp(mode, auto_params[i].name)) {
+				mask |= auto_params[i].attr;
+				found = true;
+				break;
+			}
+		}
+
+		if (!found) {
+			pr_err("Unknown auto mode '%s'.\n", mode);
+			mask = 0;
+			break;
+		}
+
+		mode = strtok_r(NULL, delim, &saved_ptr);
+	} while(1);
+
+	if (mask)
+		rd_arg_inc(rd);
+
+	return mask;
 }
 
 static int stat_one_qp_set_link_auto(struct rd *rd)
 {
-	const struct rd_cmd cmds[] = {
-		{ NULL,		stat_one_qp_link_get_mode },
-		{ "off",	stat_one_qp_set_link_auto_off },
-		{ "type",	stat_one_qp_set_link_auto_type },
-		{ 0 }
-	};
+	int auto_mask = 0;
 
-	return rd_exec_cmd(rd, cmds, "parameter");
+	if (!rd_argc(rd))
+		return -EINVAL;
+
+	if (!strcmpx(rd_argv(rd), "off")) {
+		rd_arg_inc(rd);
+		return stat_qp_set_link_auto_sendmsg(rd, 0);
+	}
+
+	auto_mask = stat_get_auto_mode_mask(rd);
+	if (!auto_mask || !rd_argc(rd))
+		return -EINVAL;
+
+	if (!strcmpx(rd_argv(rd), "on")) {
+		rd_arg_inc(rd);
+		return stat_qp_set_link_auto_sendmsg(rd, auto_mask);
+	} else {
+		pr_err("Unknown parameter '%s'.\n", rd_argv(rd));
+		return -EINVAL;
+	}
 }
 
 static int stat_one_qp_set_link(struct rd *rd)
-- 
2.26.2

