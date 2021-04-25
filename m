Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2198F36A6F6
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhDYLyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:54:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230173AbhDYLyR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 07:54:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7538661165;
        Sun, 25 Apr 2021 11:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619351618;
        bh=GUamF/j9inaWdwzjFFLUCVoM6Qq1wIxAtSiXLt4WARE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joGxogSuDXSej21YeoxMJ/e1bBGSMVn/Pc6QFXCw9UvziA1Qdsz9lB8RpZl8y/+Wo
         KJjNZ22P6sddv2XrCuiefP3oDQv9Krkwk3q5mNKe9yhesg4xIOxF2ZM2rfz4GruuhX
         5b7dtptbl5etM+eGJjtTyi6sZbIoD/wjOp+YNo/IAAmTsHxQOI+yqFgA3Yu7RGGoFR
         AIfhhfMfVAPNSylyimG7+Y3CUAomS+zTcM2gM3eu7QzhtGVxmpVMCfqIgD0qgQcvmc
         dB94ElrVRYI5YgdhPgQjMBj3HftOBTFeA3msUYvLjh+KK7m2UkeOvGEOPorcwese37
         dVBYxrU2MHtLA==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Neta Ostrovsky <netao@nvidia.com>, Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 2/3] rdma: Add context resource tracking information
Date:   Sun, 25 Apr 2021 14:53:21 +0300
Message-Id: <42633040e133fdaa15158ffc006b68fc405cd034.1619351025.git.leonro@nvidia.com>
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

$ rdma res show ctx
dev ibp8s0f0 ctxn 0 pid 980 comm ibv_rc_pingpong
dev ibp8s0f0 ctxn 1 pid 981 comm ibv_rc_pingpong
dev ibp8s0f0 ctxn 2 pid 992 comm ibv_rc_pingpong
dev ibp8s0f1 ctxn 0 pid 984 comm ibv_rc_pingpong
dev ibp8s0f1 ctxn 1 pid 987 comm ibv_rc_pingpong

$ rdma res show ctx dev ibp8s0f1
dev ibp8s0f1 ctxn 0 pid 984 comm ibv_rc_pingpong
dev ibp8s0f1 ctxn 1 pid 987 comm ibv_rc_pingpong

Reviewed-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Ido Kalir <idok@nvidia.com>
Signed-off-by: Neta Ostrovsky <netao@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 man/man8/rdma-resource.8 |   7 ++-
 rdma/Makefile            |   2 +-
 rdma/res-ctx.c           | 103 +++++++++++++++++++++++++++++++++++++++
 rdma/res.c               |   5 +-
 rdma/res.h               |  12 +++++
 rdma/utils.c             |   3 ++
 6 files changed, 129 insertions(+), 3 deletions(-)
 create mode 100644 rdma/res-ctx.c

diff --git a/man/man8/rdma-resource.8 b/man/man8/rdma-resource.8
index 8d0d14c6..c2102853 100644
--- a/man/man8/rdma-resource.8
+++ b/man/man8/rdma-resource.8
@@ -13,7 +13,7 @@ rdma-resource \- rdma resource configuration
 
 .ti -8
 .IR RESOURCE " := { "
-.BR cm_id " | " cq " | " mr " | " pd " | " qp " }"
+.BR cm_id " | " cq " | " mr " | " pd " | " qp " | " ctx " }"
 .sp
 
 .ti -8
@@ -103,6 +103,11 @@ rdma resource show cq pid 30489
 Show CQs belonging to pid 30489
 .RE
 .PP
+rdma resource show ctx ctxn 1
+.RS 4
+Show contexts that have index equal to 1.
+.RE
+.PP
 
 .SH SEE ALSO
 .BR rdma (8),
diff --git a/rdma/Makefile b/rdma/Makefile
index aa5ce822..32f504fc 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o
+	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o res-ctx.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res-ctx.c b/rdma/res-ctx.c
new file mode 100644
index 00000000..30afe97a
--- /dev/null
+++ b/rdma/res-ctx.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * res-ctx.c	RDMA tool
+ * Authors:     Neta Ostrovsky <netao@nvidia.com>
+ */
+
+#include "res.h"
+#include <inttypes.h>
+
+static int res_ctx_line(struct rd *rd, const char *name, int idx,
+			struct nlattr **nla_line)
+{
+	char *comm = NULL;
+	uint32_t ctxn = 0;
+	uint32_t pid = 0;
+
+	if (!nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+		return MNL_CB_ERROR;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
+		ctxn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
+
+	if (rd_is_filtered_attr(rd, "ctxn", ctxn,
+				nla_line[RDMA_NLDEV_ATTR_RES_CTXN]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+		/* discard const from mnl_attr_get_str */
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+	open_json_object(NULL);
+	print_dev(rd, idx, name);
+	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
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
+int res_ctx_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
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
+	return res_ctx_line(rd, name, idx, tb);
+}
+
+int res_ctx_parse_cb(const struct nlmsghdr *nlh, void *data)
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
+	    !tb[RDMA_NLDEV_ATTR_RES_CTX])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_CTX];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+
+		ret = res_ctx_line(rd, name, idx, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+	}
+	return ret;
+}
diff --git a/rdma/res.c b/rdma/res.c
index f42ae938..dbc3179e 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -11,7 +11,7 @@ static int res_help(struct rd *rd)
 {
 	pr_out("Usage: %s resource\n", rd->filename);
 	pr_out("          resource show [DEV]\n");
-	pr_out("          resource show [qp|cm_id|pd|mr|cq]\n");
+	pr_out("          resource show [qp|cm_id|pd|mr|cq|ctx]\n");
 	pr_out("          resource show qp link [DEV/PORT]\n");
 	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show cm_id link [DEV/PORT]\n");
@@ -22,6 +22,8 @@ static int res_help(struct rd *rd)
 	pr_out("          resource show pd dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
 	pr_out("          resource show mr dev [DEV]\n");
 	pr_out("          resource show mr dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
+	pr_out("          resource show ctx dev [DEV]\n");
+	pr_out("          resource show ctx dev [DEV] [FILTER-NAME FILTER-VALUE]\n");
 	return 0;
 }
 
@@ -224,6 +226,7 @@ static int res_show(struct rd *rd)
 		{ "cq",		res_cq		},
 		{ "mr",		res_mr		},
 		{ "pd",		res_pd		},
+		{ "ctx",	res_ctx		},
 		{ 0 }
 	};
 
diff --git a/rdma/res.h b/rdma/res.h
index e8bd02e4..a8093d15 100644
--- a/rdma/res.h
+++ b/rdma/res.h
@@ -22,6 +22,8 @@ int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_cm_id_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data);
 int res_qp_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_ctx_parse_cb(const struct nlmsghdr *nlh, void *data);
+int res_ctx_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
 
 static inline uint32_t res_get_command(uint32_t command, struct rd *rd)
 {
@@ -155,6 +157,16 @@ filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {
 RES_FUNC(res_qp, RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false,
 	 RDMA_NLDEV_ATTR_RES_LQPN);
 
+static const
+struct filters ctx_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "dev", .is_number = false },
+	{ .name = "pid", .is_number = true },
+	{ .name = "ctxn", .is_number = true, .is_doit = true },
+};
+
+RES_FUNC(res_ctx, RDMA_NLDEV_CMD_RES_CTX_GET, ctx_valid_filters, true,
+	 RDMA_NLDEV_ATTR_RES_CTXN);
+
 void print_dev(struct rd *rd, uint32_t idx, const char *name);
 void print_link(struct rd *rd, uint32_t idx, const char *name, uint32_t port,
 		struct nlattr **nla_line);
diff --git a/rdma/utils.c b/rdma/utils.c
index 292e1808..e2c9bb6f 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -435,6 +435,9 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_LKEY] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_RES_IOVA] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_RES_MRLEN] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_RES_CTX] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_CTX_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_RES_CTXN] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_NDEV_INDEX]		= MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_NDEV_NAME]		= MNL_TYPE_NUL_STRING,
 	[RDMA_NLDEV_ATTR_DRIVER] = MNL_TYPE_NESTED,
-- 
2.30.2

