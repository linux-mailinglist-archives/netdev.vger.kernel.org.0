Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88777207159
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390480AbgFXKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:40:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388197AbgFXKk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 06:40:26 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BA1420644;
        Wed, 24 Jun 2020 10:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592995225;
        bh=TqN/WwZ4o3gFTt9Bu5yzhxIjN9TVmmu8RFsmLHPVFoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yoff0fNr0BYR3Hy2yc+ed/UNWQJkiTZauxW2kt9GfHjoXc0AeVdmvnCNJwkr5F8kS
         a8DzHscsUx7tovPzOrONH0OYDmRdV6OHym8V5/LSirWgxPLpzZw8wKGW98Eq6oKeAg
         3h6Z4tZrwEgklC+4QUo0b7G9oo3/q4IpzW6ofBr8=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next v1 2/4] rdma: Add support to get QP in raw format
Date:   Wed, 24 Jun 2020 13:40:10 +0300
Message-Id: <20200624104012.1450880-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624104012.1450880-1-leon@kernel.org>
References: <20200624104012.1450880-1-leon@kernel.org>
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
[{"ifindex":7,"ifname":"mlx5_1","port":1,
"data":[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,...]}]

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 man/man8/rdma-resource.8 |  5 +++++
 man/man8/rdma.8          |  4 ++++
 rdma/rdma.c              | 10 ++++++++--
 rdma/rdma.h              |  7 +++++--
 rdma/res-qp.c            | 20 ++++++++++++++++++--
 rdma/res.h               | 26 +++++++++++++++++++++-----
 rdma/utils.c             | 20 ++++++++++++++++++++
 7 files changed, 81 insertions(+), 11 deletions(-)

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
index 22050555..c24894d6 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -13,7 +13,7 @@ static void help(char *name)
 	pr_out("Usage: %s [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       %s [ -f[orce] ] -b[atch] filename\n"
 	       "where  OBJECT := { dev | link | resource | system | statistic | help }\n"
-	       "       OPTIONS := { -V[ersion] | -d[etails] | -j[son] | -p[retty]}\n", name, name);
+	       "       OPTIONS := { -V[ersion] | -d[etails] | -j[son] | -p[retty] -r[aw]}\n", name, name);
 }
 
 static int cmd_help(struct rd *rd)
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
index 801cfca9..a38be399 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -64,6 +64,20 @@ static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 			   "path-mig-state %s ", path_mig_to_str(val));
 }
 
+static int res_qp_line_raw(struct rd *rd, const char *name, int idx,
+			   struct nlattr **nla_line)
+{
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_RAW])
+		return MNL_CB_ERROR;
+
+	open_json_object(NULL);
+	print_link(rd, idx, name, rd->port_idx, nla_line);
+	print_raw_data(rd, nla_line);
+	newline(rd);
+
+	return MNL_CB_OK;
+}
+
 static int res_qp_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
@@ -184,7 +198,8 @@ int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
 	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
 	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
 
-	return res_qp_line(rd, name, idx, tb);
+	return (rd->show_raw) ? res_qp_line_raw(rd, name, idx, tb) :
+		res_qp_line(rd, name, idx, tb);
 }
 
 int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
@@ -212,7 +227,8 @@ int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		if (ret != MNL_CB_OK)
 			break;
 
-		ret = res_qp_line(rd, name, idx, nla_line);
+		ret = (rd->show_raw) ? res_qp_line_raw(rd, name, idx, nla_line) :
+			res_qp_line(rd, name, idx, nla_line);
 		if (ret != MNL_CB_OK)
 			break;
 	}
diff --git a/rdma/res.h b/rdma/res.h
index 525171fc..24eee2a1 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -23,24 +23,40 @@ int res_cm_id_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 
+static inline uint32_t res_get_command(uint32_t command, struct rd *rd)
+{
+	if (!rd->show_raw)
+		return command;
+
+	switch (command) {
+	case RDMA_NLDEV_CMD_RES_QP_GET:
+		return RDMA_NLDEV_CMD_RES_QP_GET_RAW;
+	default:
+		return command;
+	}
+}
+
 #define RES_FUNC(name, command, valid_filters, strict_port, id)                        \
 	static inline int _##name(struct rd *rd)                                       \
 	{                                                                              \
-		uint32_t idx;                                                          \
+		uint32_t idx, _command;                                                \
 		int ret;                                                               \
+		_command = res_get_command(command, rd);			       \
 		if (id) {                                                              \
 			ret = rd_doit_index(rd, &idx);                                 \
 			if (ret) {                                                     \
 				rd->suppress_errors = true;                            \
-				ret = _res_send_idx_msg(rd, command,                   \
+				ret = _res_send_idx_msg(rd, _command,                  \
 							name##_idx_parse_cb,           \
 							idx, id);                      \
-				if (!ret)                                              \
+				if (!ret || rd->show_raw)                              \
 					return ret;                                    \
-				/* Fallback for old systems without .doit callbacks */ \
+				/* Fallback for old systems without .doit callbacks.   \
+				 * Kernel that supports raw, for sure supports doit.   \
+				 */						       \
 			}                                                              \
 		}                                                                      \
-		return _res_send_msg(rd, command, name##_parse_cb);                    \
+		return _res_send_msg(rd, _command, name##_parse_cb);                   \
 	}                                                                              \
 	static inline int name(struct rd *rd)                                          \
 	{                                                                              \
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

