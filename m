Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D3B1DD56F
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgEUR7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgEUR7j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:39 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4825C20759;
        Thu, 21 May 2020 17:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590083979;
        bh=Xzcvdz3FlpLT9Nzn5Hqst0gx8lZ3MqeNZ8pXGB0b1VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PQIxPAeXq6Nw7MWyWR8exN7IOzaLtEXLehsVACfkmWtpG3qXuqEYEabwtt5Yh4kVR
         yJ3Y10mnNrt15UbpFMcXhzbz0+00bfOadhlNNteZdA7gyHKuKwiuoBDyqCYzq6Aef8
         PpeSc4JdezvXcN0e04gY3z/ABPLst6gOJsLo3+hw=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 2/4] rdma: Add support to get QP in raw format
Date:   Wed, 20 May 2020 13:25:37 +0300
Message-Id: <20200520102539.458983-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520102539.458983-1-leon@kernel.org>
References: <20200520102539.458983-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Add 'raw' argument to get the resource in raw format.
When RDMA_NLDEV_ATTR_RES_RAW is set in the netlink message,
then the resource fields are in raw format, print it as byte array.

Example:
$rdma res show qp link rocep0s12f0/1 lqpn 1137 -j -r
[{"ifindex":7,"ifname":"mlx5_1","port":1,"lqpn":265,"pid":24336
"comm":"ibv_rc_pingpong","data":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,...]}]

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-resource.8 |  5 +++++
 man/man8/rdma.8          |  4 ++++
 rdma/rdma.c              |  8 +++++++-
 rdma/rdma.h              |  7 +++++--
 rdma/res-qp.c            | 37 ++++++++++++++++++++++++++++++++-----
 rdma/res.c               |  1 +
 rdma/utils.c             | 20 ++++++++++++++++++++
 7 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
index 05030d0a..8d0d14c6 100644
--- a/man/man8/rdma-resource.8
+++ b/man/man8/rdma-resource.8
@@ -83,6 +83,11 @@ rdma res show qp link mlx5_4/1 lqpn 0-6
 Limit to specific Local QPNs.
 .RE
 .PP
+rdma res show qp link mlx5_4/1 lqpn 6 -r
+.RS 4
+Driver specific details in raw format.
+.RE
+.PP
 rdma resource show cm_id dst-port 7174
 .RS 4
 Show CM_IDs with destination ip port of 7174.
diff --git a/man/man8/rdma.8 b/man/man8/rdma.8
index 221bf334..c9e5d50d 100644
--- a/man/man8/rdma.8
+++ b/man/man8/rdma.8
@@ -51,6 +51,10 @@ If there were any errors during execution of the commands, the application retur
 .BR "\-d" , " --details"
 Output detailed information.  Adding a second \-d includes driver-specific details.

+.TP
+.BR "\-r" , " --raw"
+Output includes driver-specific details in raw format.
+
 .TP
 .BR "\-p" , " --pretty"
 When combined with -j generate a pretty JSON output.
diff --git a/rdma/rdma.c b/rdma/rdma.c
index 22050555..19fadeb5 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -112,6 +112,7 @@ int main(int argc, char **argv)
 		{ "json",		no_argument,		NULL, 'j' },
 		{ "pretty",		no_argument,		NULL, 'p' },
 		{ "details",		no_argument,		NULL, 'd' },
+		{ "raw",		no_argument,		NULL, 'r' },
 		{ "force",		no_argument,		NULL, 'f' },
 		{ "batch",		required_argument,	NULL, 'b' },
 		{ NULL, 0, NULL, 0 }
@@ -120,6 +121,7 @@ int main(int argc, char **argv)
 	const char *batch_file = NULL;
 	bool show_details = false;
 	bool json_output = false;
+	bool show_raw = false;
 	bool force = false;
 	struct rd rd = {};
 	char *filename;
@@ -127,7 +129,7 @@ int main(int argc, char **argv)
 	int err;
 	filename = basename(argv[0]);

-	while ((opt = getopt_long(argc, argv, ":Vhdpjfb:",
+	while ((opt = getopt_long(argc, argv, ":Vhdrpjfb:",
 				  long_options, NULL)) >= 0) {
 		switch (opt) {
 		case 'V':
@@ -143,6 +145,9 @@ int main(int argc, char **argv)
 			else
 				show_details = true;
 			break;
+		case 'r':
+			show_raw = true;
+			break;
 		case 'j':
 			json_output = 1;
 			break;
@@ -172,6 +177,7 @@ int main(int argc, char **argv)
 	rd.show_driver_details = show_driver_details;
 	rd.json_output = json_output;
 	rd.pretty_output = pretty;
+	rd.show_raw = show_raw;

 	err = rd_init(&rd, filename);
 	if (err)
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 735b1bf7..a6c6bdea 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -57,8 +57,9 @@ struct rd {
 	int argc;
 	char **argv;
 	char *filename;
-	bool show_details;
-	bool show_driver_details;
+	uint8_t show_details:1;
+	uint8_t show_driver_details:1;
+	uint8_t show_raw:1;
 	struct list_head dev_map_list;
 	uint32_t dev_idx;
 	uint32_t port_idx;
@@ -134,9 +135,11 @@ int rd_attr_check(const struct nlattr *attr, int *typep);
  * Print helpers
  */
 void print_driver_table(struct rd *rd, struct nlattr *tb);
+void print_raw_data(struct rd *rd, struct nlattr **nla_line);
 void newline(struct rd *rd);
 void newline_indent(struct rd *rd);
 void print_on_off(struct rd *rd, const char *key_str, bool on);
+void print_raw_data(struct rd *rd, struct nlattr **nla_line);
 #define MAX_LINE_LENGTH 80

 #endif /* _RDMA_TOOL_H_ */
diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index b36b7289..f5e36439 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -71,16 +71,38 @@ struct res_qp_info {
 	char *comm;
 };

-static bool resp_is_valid(struct nlattr **nla_line)
+static bool resp_is_valid(struct nlattr **nla_line, bool raw)
 {
-	if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
-	    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
+		return false;
+
+	if (raw)
+		return nla_line[RDMA_NLDEV_ATTR_RES_RAW] ? true : false;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_STATE])
 		return false;
+
 	return true;
 }

+static void res_qp_line_raw(struct rd *rd, const char *name, int idx,
+			    struct nlattr **nla_line,
+			    struct res_qp_info *info)
+{
+	open_json_object(NULL);
+	print_link(rd, idx, name, info->port, nla_line);
+	res_print_uint(rd, "lqpn", info->lqpn,
+		       nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+
+	res_print_uint(rd, "pid", info->pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	print_comm(rd, info->comm, nla_line);
+
+	print_raw_data(rd, nla_line);
+	newline(rd);
+}
+
 static void res_qp_line_query(struct rd *rd, const char *name, int idx,
 			      struct nlattr **nla_line,
 			      struct res_qp_info *info)
@@ -156,8 +178,9 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
 	struct res_qp_info info = {};
+	bool raw = rd->show_raw;

-	if (!resp_is_valid(nla_line))
+	if (!resp_is_valid(nla_line, raw))
 		return MNL_CB_ERROR;

 	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
@@ -187,7 +210,11 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 		info.comm = (char *)mnl_attr_get_str(line);
 	}

-	res_qp_line_query(rd, name, idx, nla_line, &info);
+	if (raw)
+		res_qp_line_raw(rd, name, idx, nla_line, &info);
+	else
+		res_qp_line_query(rd, name, idx, nla_line, &info);
+
 out:
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
 		free(info.comm);
diff --git a/rdma/res.c b/rdma/res.c
index 251f5041..759a1151 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -97,6 +97,7 @@ int _res_send_idx_msg(struct rd *rd, uint32_t command, mnl_cb_t callback,

 	mnl_attr_put_u32(rd->nlh, id, idx);

+	mnl_attr_put_u8(rd->nlh, RDMA_NLDEV_ATTR_RES_RAW, rd->show_raw);
 	if (command == RDMA_NLDEV_CMD_STAT_GET)
 		mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES,
 				 RDMA_NLDEV_ATTR_RES_MR);
diff --git a/rdma/utils.c b/rdma/utils.c
index e25c3adf..4d3de4fa 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -450,6 +450,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_RES] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_DEV_DIM] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_RES_RAW] = MNL_TYPE_BINARY,
 };

 int rd_attr_check(const struct nlattr *attr, int *typep)
@@ -890,6 +891,25 @@ static int print_driver_entry(struct rd *rd, struct nlattr *key_attr,
 	return ret;
 }

+void print_raw_data(struct rd *rd, struct nlattr **nla_line)
+{
+	uint8_t *data;
+	uint32_t len;
+	int i = 0;
+
+	if (!rd->show_raw)
+		return;
+
+	len = mnl_attr_get_payload_len(nla_line[RDMA_NLDEV_ATTR_RES_RAW]);
+	data = mnl_attr_get_payload(nla_line[RDMA_NLDEV_ATTR_RES_RAW]);
+	open_json_array(PRINT_JSON, "data");
+	while (i < len) {
+		print_color_uint(PRINT_ANY, COLOR_NONE, NULL, "%d", data[i]);
+		i++;
+	}
+	close_json_array(PRINT_ANY, ">");
+}
+
 void print_driver_table(struct rd *rd, struct nlattr *tb)
 {
 	int print_type = RDMA_NLDEV_PRINT_TYPE_UNSPEC;
--
2.26.2

