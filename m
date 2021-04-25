Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5EC36A6F4
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhDYLyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:47982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhDYLyO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 07:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113CC6113B;
        Sun, 25 Apr 2021 11:53:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619351614;
        bh=EJDUGJbKxmHi+ZfQtU0swRITK5z/0NAFy0eQt+ToOWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N7IhVAOADpmKc/s60IPFI8W1Tt5DrTOwj7MjruCm6CkvBKi+FM121lo+wdId3u840
         bHERJ/LQnFOq2UoOgfnfgYk/U0Cr3jUuJLAgUDno3Ext1Brt+H1jL+P4TnUcal2Z5f
         a7S0vP5p8L/ocz64JaT4FzQf1cuDwzX5ouRGq79woVAN/Fel49dKI2cBRPGJYVoB6w
         k4oi+JTaJeCY8k7vN6t67TcfACHMcdIMjo3QwEMIzINkHD68MV1gV55XxIIvRjxrck
         u1saArtyX72oNZW78yUmJdFaBjTPUYJ0iWZXBkGdpCO/7XXhXKQxuaUqzmpdt8Tr7D
         UU2AKutV6FvLA==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Neta Ostrovsky <netao@nvidia.com>, Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 3/3] rdma: Add SRQ resource tracking information
Date:   Sun, 25 Apr 2021 14:53:22 +0300
Message-Id: <12eb2232103f211923e7eafa7e457bce62c42984.1619351025.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1619351025.git.leonro@nvidia.com>
References: <cover.1619351025.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neta Ostrovsky <netao@nvidia.com>

Sample output:

$ rdma res show srq
dev ibp8s0f0 srqn 0 type BASIC pdn 3 comm [ib_ipoib]
dev ibp8s0f0 srqn 4 type BASIC lqpn 125-128,130-140 pdn 9 pid 3581 comm ibv_srq_pingpon
dev ibp8s0f0 srqn 5 type BASIC lqpn 141-156 pdn 10 pid 3584 comm ibv_srq_pingpon
dev ibp8s0f0 srqn 6 type BASIC lqpn 157-172 pdn 11 pid 3590 comm ibv_srq_pingpon
dev ibp8s0f1 srqn 0 type BASIC pdn 3 comm [ib_ipoib]
dev ibp8s0f1 srqn 1 type BASIC lqpn 329-344 pdn 4 pid 3586 comm ibv_srq_pingpon

$ rdma res show srq lqpn 126-141
dev ibp8s0f0 srqn 4 type BASIC lqpn 126-128,130-140 pdn 9 pid 3581 comm ibv_srq_pingpon
dev ibp8s0f0 srqn 5 type BASIC lqpn 141 pdn 10 pid 3584 comm ibv_srq_pingpon

$ rdma res show srq lqpn 127
dev ibp8s0f0 srqn 4 type BASIC lqpn 127 pdn 9 pid 3581 comm ibv_srq_pingpon

Reviewed-by: Ido Kalir <idok@nvidia.com>
Reviewed-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 man/man8/rdma-resource.8 |   7 +-
 rdma/Makefile            |   2 +-
 rdma/res-srq.c           | 274 +++++++++++++++++++++++++++++++++++++++
 rdma/res.c               |   5 +-
 rdma/res.h               |  16 +++
 rdma/utils.c             |   5 +
 6 files changed, 306 insertions(+), 3 deletions(-)
 create mode 100644 rdma/res-srq.c

diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
index c2102853..1035478d 100644
--- a/man/man8/rdma-resource.8
+++ b/man/man8/rdma-resource.8
@@ -13,7 +13,7 @@ rdma-resource \- rdma resource configuration
 
 .ti -8
 .IR RESOURCE " := { "
-.BR cm_id " | " cq " | " mr " | " pd " | " qp " | " ctx " }"
+.BR cm_id " | " cq " | " mr " | " pd " | " qp " | " ctx " | " srq " }"
 .sp
 
 .ti -8
@@ -108,6 +108,11 @@ rdma resource show ctx ctxn 1
 Show contexts that have index equal to 1.
 .RE
 .PP
+rdma resource show srq lqpn 5-7
+.RS 4
+Show SRQs that the QPs with lqpn 5-7 are associated with.
+.RE
+.PP
 
 .SH SEE ALSO
 .BR rdma (8),
diff --git a/rdma/Makefile b/rdma/Makefile
index 32f504fc..9154efeb 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o res-ctx.o
+	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o res-ctx.o res-srq.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-srq.c b/rdma/res-srq.c
new file mode 100644
index 00000000..c14ac5d8
--- /dev/null
+++ b/rdma/res-srq.c
@@ -0,0 +1,274 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-srq.c	RDMA tool
+ * Authors:     Neta Ostrovsky <netao@nvidia.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+#define MAX_QP_STR_LEN 256
+
+static const char *srq_types_to_str(uint8_t idx)
+{
+	static const char *const srq_types_str[] = { "BASIC",
+						     "XRC",
+						     "TM" };
+
+	if (idx < ARRAY_SIZE(srq_types_str))
+		return srq_types_str[idx];
+	return "UNKNOWN";
+}
+
+static void print_type(struct rd *rd, uint32_t val)
+{
+	print_color_string(PRINT_ANY, COLOR_NONE, "type", "type %s ",
+			   srq_types_to_str(val));
+}
+
+static void print_qps(const char *str)
+{
+	if (!strlen(str))
+		return;
+	print_color_string(PRINT_ANY, COLOR_NONE, "lqpn", "lqpn %s ", str);
+}
+
+static int filter_srq_range_qps(struct rd *rd, struct nlattr **qp_line,
+				uint32_t min_range, uint32_t max_range,
+				char **delimiter, char *qp_str)
+{
+	uint32_t qpn = 0, tmp_min_range = 0, tmp_max_range = 0;
+	char tmp[16] = {};
+
+	for (qpn = min_range; qpn <= max_range; qpn++) {
+		if (rd_is_filtered_attr(rd, "lqpn", qpn,
+				qp_line[RDMA_NLDEV_ATTR_MIN_RANGE])) {
+			/* The QPs range contains a LQPN that is filtered */
+			if (!tmp_min_range)
+				/* There are no QPs previous to
+				 * the filtered one
+				 */
+				continue;
+			if (!tmp_max_range)
+				snprintf(tmp, sizeof(tmp), "%s%d", *delimiter,
+					 tmp_min_range);
+			else
+				snprintf(tmp, sizeof(tmp), "%s%d-%d",
+					 *delimiter, tmp_min_range,
+					 tmp_max_range);
+
+			if (strlen(qp_str) + strlen(tmp) >= MAX_QP_STR_LEN)
+				return -EINVAL;
+			strncat(qp_str, tmp, sizeof(tmp) - 1);
+
+			memset(tmp, 0, strlen(tmp));
+			*delimiter = ",";
+			tmp_min_range = 0;
+			tmp_max_range = 0;
+			continue;
+		}
+		if (!tmp_min_range)
+			tmp_min_range = qpn;
+		else
+			tmp_max_range = qpn;
+	}
+
+	if (!tmp_min_range)
+		return 0;
+	if (!tmp_max_range)
+		snprintf(tmp, sizeof(tmp), "%s%d", *delimiter, tmp_min_range);
+	else
+		snprintf(tmp, sizeof(tmp), "%s%d-%d", *delimiter,
+			 tmp_min_range, tmp_max_range);
+
+	if (strlen(qp_str) + strlen(tmp) >= MAX_QP_STR_LEN)
+		return -EINVAL;
+	strncat(qp_str, tmp, sizeof(tmp) - 1);
+	*delimiter = ",";
+	return 0;
+}
+
+static int get_srq_qps(struct rd *rd, struct nlattr *qp_table,  char *qp_str)
+{
+	uint32_t qpn = 0, min_range = 0, max_range = 0;
+	struct nlattr *nla_entry;
+	struct filter_entry *fe;
+	char *delimiter = "";
+	char tmp[16] = {};
+
+	if (!qp_table)
+		return MNL_CB_ERROR;
+
+	/* If there are no QPs associated with the SRQ, return */
+	if (!(mnl_attr_get_payload_len(qp_table))) {
+		list_for_each_entry(fe, &rd->filter_list, list) {
+			if (!strcmpx(fe->key, "lqpn"))
+				/* We found the key -
+				 * user requested to filter by LQPN
+				 */
+				return -EINVAL;
+		}
+		return MNL_CB_OK;
+	}
+
+	mnl_attr_for_each_nested(nla_entry, qp_table) {
+		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		if (mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line) !=
+		    MNL_CB_OK)
+			goto out;
+
+		if (qp_line[RDMA_NLDEV_ATTR_RES_LQPN]) {
+			qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+			if (rd_is_filtered_attr(rd, "lqpn", qpn,
+					qp_line[RDMA_NLDEV_ATTR_RES_LQPN]))
+				continue;
+			snprintf(tmp, sizeof(tmp), "%s%d", delimiter, qpn);
+			if (strlen(qp_str) + strlen(tmp) >= MAX_QP_STR_LEN)
+				goto out;
+			strncat(qp_str, tmp, sizeof(tmp) - 1);
+			delimiter = ",";
+		} else if (qp_line[RDMA_NLDEV_ATTR_MIN_RANGE] &&
+			   qp_line[RDMA_NLDEV_ATTR_MAX_RANGE]) {
+			min_range = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_MIN_RANGE]);
+			max_range = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_MAX_RANGE]);
+
+			if (filter_srq_range_qps(rd, qp_line, min_range,
+						 max_range, &delimiter,
+						 qp_str))
+				goto out;
+		} else {
+			goto out;
+		}
+	}
+
+	if (!strlen(qp_str))
+		/* Check if there are no QPs to display after filter */
+		goto out;
+
+	return MNL_CB_OK;
+
+out:
+	memset(qp_str, 0, strlen(qp_str));
+	return -EINVAL;
+}
+
+static int res_srq_line(struct rd *rd, const char *name, int idx,
+			struct nlattr **nla_line)
+{
+	uint32_t srqn = 0, pid = 0, pdn = 0, cqn = 0;
+	char qp_str[MAX_QP_STR_LEN] = {};
+	char *comm = NULL;
+	uint8_t type = 0;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_SRQN])
+		return MNL_CB_ERROR;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_SRQN])
+		srqn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
+	if (rd_is_filtered_attr(rd, "srqn", srqn,
+				nla_line[RDMA_NLDEV_ATTR_RES_SRQN]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_TYPE])
+		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
+	if (rd_is_string_filtered_attr(rd, "type", srq_types_to_str(type),
+				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
+		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	if (rd_is_filtered_attr(rd, "pdn", pdn,
+				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
+		cqn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+	if (rd_is_filtered_attr(rd, "cqn", cqn,
+				nla_line[RDMA_NLDEV_ATTR_RES_CQN]))
+		goto out;
+
+	if (get_srq_qps(rd, nla_line[RDMA_NLDEV_ATTR_RES_QP], qp_str) !=
+			MNL_CB_OK)
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+	open_json_object(NULL);
+	print_dev(rd, idx, name);
+	res_print_uint(rd, "srqn", srqn, nla_line[RDMA_NLDEV_ATTR_RES_SRQN]);
+	print_type(rd, type);
+	print_qps(qp_str);
+	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
+	res_print_uint(rd, "cqn", cqn, nla_line[RDMA_NLDEV_ATTR_RES_CQN]);
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	print_comm(rd, comm, nla_line);
+
+	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
+	newline(rd);
+
+out:
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
+		free(comm);
+	return MNL_CB_OK;
+}
+
+int res_srq_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+
+	return res_srq_line(rd, name, idx, tb);
+}
+
+int res_srq_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	int ret = MNL_CB_OK;
+	const char *name;
+	uint32_t idx;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_RES_SRQ])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_SRQ];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+
+		ret = res_srq_line(rd, name, idx, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+	}
+	return ret;
+}
diff --git a/rdma/res.c b/rdma/res.c
index dbc3179e..9aae5d4b 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -11,7 +11,7 @@ static int res_help(struct rd *rd)
 {
 	pr_out("Usage: %s resource\n", rd->filename);
 	pr_out("          resource show [DEV]\n");
-	pr_out("          resource show [qp|cm_id|pd|mr|cq|ctx]\n");
+	pr_out("          resource show [qp|cm_id|pd|mr|cq|ctx|srq]\n");
 	pr_out("          resource show qp link [DEV/PORT]\n");
 	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show cm_id link [DEV/PORT]\n");
@@ -24,6 +24,8 @@ static int res_help(struct rd *rd)
 	pr_out("          resource show mr dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show ctx dev [DEV]\n");
 	pr_out("          resource show ctx dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
+	pr_out("          resource show srq dev [DEV]\n");
+	pr_out("          resource show srq dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
 	return 0;
 }
 
@@ -227,6 +229,7 @@ static int res_show(struct rd *rd)
 		{ "mr",		res_mr		},
 		{ "pd",		res_pd		},
 		{ "ctx",	res_ctx		},
+		{ "srq",	res_srq		},
 		{ 0 }
 	};
 
diff --git a/rdma/res.h b/rdma/res.h
index a8093d15..58fa6ad1 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -24,6 +24,8 @@ int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_ctx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_ctx_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_srq_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_srq_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 
 static inline uint32_t res_get_command(uint32_t command, struct rd *rd)
 {
@@ -167,6 +169,20 @@ struct filters ctx_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 RES_FUNC(res_ctx, RDMA_NLDEV_CMD_RES_CTX_GET, ctx_valid_filters, true,
 	 RDMA_NLDEV_ATTR_RES_CTXN);
 
+static const
+struct filters srq_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "pid", .is_number = true },
+	{ .name = "srqn", .is_number = true, .is_doit = true },
+	{ .name = "type", .is_number = false },
+	{ .name = "pdn", .is_number = true },
+	{ .name = "cqn", .is_number = true },
+	{ .name = "lqpn", .is_number = true },
+};
+
+RES_FUNC(res_srq, RDMA_NLDEV_CMD_RES_SRQ_GET, srq_valid_filters, true,
+	 RDMA_NLDEV_ATTR_RES_SRQN);
+
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
diff --git a/rdma/utils.c b/rdma/utils.c
index e2c9bb6f..21177b56 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -438,6 +438,11 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_CTX] = MNL_TYPE_NESTED,
 	[RDMA_NLDEV_ATTR_RES_CTX_ENTRY] = MNL_TYPE_NESTED,
 	[RDMA_NLDEV_ATTR_RES_CTXN] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_RES_SRQ] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_SRQ_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_SRQN] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_MIN_RANGE] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_MAX_RANGE] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_NDEV_INDEX]		= MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_NDEV_NAME]		= MNL_TYPE_NUL_STRING,
 	[RDMA_NLDEV_ATTR_DRIVER] = MNL_TYPE_NESTED,
-- 
2.30.2

