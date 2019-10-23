Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1A4BE1825
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404552AbfJWKjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:39:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:59246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404434AbfJWKjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 06:39:07 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BAFF20679;
        Wed, 23 Oct 2019 10:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571827146;
        bh=3aGJ3/twgnLeOdQ2Qe+wzXTbOxQPEY1mD6PPBGrbLBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRxXXFkwLNlXjl8VQ2zq0XMVb8pr3eTdQ1c++lP7rh6AfGG4qofjuaD4wfKPmqwFJ
         U7SJV3TQjR/K3Y+BTYtIl52X9rCRbwq/orgBhfHubSuaCStbrIAlT/FP3WeNLX95kK
         tbElFJL2NInB1Lv/OWh9l8qUtDBnIHUe+UtKw+e8=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        Erez Alfasi <ereza@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 1/2] rdma: Add "stat show mr" support
Date:   Wed, 23 Oct 2019 13:38:53 +0300
Message-Id: <20191023103854.5981-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023103854.5981-1-leon@kernel.org>
References: <20191023103854.5981-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Alfasi <ereza@mellanox.com>

Show MR counters statistics. Filters are also enabled.

Examples:
~$: rdma stat show mr
dev mlx5_0 mrn 8 page_faults 1221 page_invalidations 0
dev mlx5_0 mrn 9 page_faults 1221 page_invalidations 0

~$: rdma stat show mr mrn 8
dev mlx5_0 mrn 8 page_faults 1221 page_invalidations 0

Signed-off-by: Erez Alfasi <ereza@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile  |  2 +-
 rdma/res.c     |  8 +++++
 rdma/stat-mr.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/stat.c    |  5 ++-
 rdma/stat.h    | 26 +++++++++++++++
 5 files changed, 127 insertions(+), 2 deletions(-)
 create mode 100644 rdma/stat-mr.c
 create mode 100644 rdma/stat.h

diff --git a/rdma/Makefile b/rdma/Makefile
index e3f550bf..aa5ce822 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o res-qp.o sys.o stat.o
+	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/res.c b/rdma/res.c
index e8607808..7cd05721 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -103,6 +103,10 @@ int _res_send_idx_msg(struct rd *rd, uint32_t command, mnl_cb_t callback,
 
 	mnl_attr_put_u32(rd->nlh, id, idx);
 
+	if (command == RDMA_NLDEV_CMD_STAT_GET)
+		mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES,
+				 RDMA_NLDEV_ATTR_RES_MR);
+
 	ret = rd_send_msg(rd);
 	if (ret)
 		return ret;
@@ -130,6 +134,10 @@ int _res_send_msg(struct rd *rd, uint32_t command, mnl_cb_t callback)
 		mnl_attr_put_u32(rd->nlh,
 				 RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
 
+	if (command == RDMA_NLDEV_CMD_STAT_GET)
+		mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES,
+				 RDMA_NLDEV_ATTR_RES_MR);
+
 	ret = rd_send_msg(rd);
 	if (ret)
 		return ret;
diff --git a/rdma/stat-mr.c b/rdma/stat-mr.c
new file mode 100644
index 00000000..11f042d4
--- /dev/null
+++ b/rdma/stat-mr.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * stat-mr.c     RDMA tool
+ * Authors:     Erez Alfasi <ereza@mellanox.com>
+ */
+
+#include "res.h"
+#include "stat.h"
+#include <inttypes.h>
+
+static int stat_mr_line(struct rd *rd, const char *name, int idx,
+			struct nlattr **nla_line)
+{
+	uint32_t mrn = 0;
+	int ret;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
+		mrn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+	if (rd_is_filtered_attr(rd, "mrn", mrn,
+				nla_line[RDMA_NLDEV_ATTR_RES_MRN]))
+		goto out;
+
+	if (rd->json_output)
+		jsonw_start_array(rd->jw);
+
+	print_dev(rd, idx, name);
+	res_print_uint(rd, "mrn", mrn, nla_line[RDMA_NLDEV_ATTR_RES_MRN]);
+
+	if (nla_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS]) {
+		ret = res_get_hwcounters(
+			rd, nla_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], true);
+		if (ret != MNL_CB_OK)
+			return ret;
+	}
+
+	newline(rd);
+out:
+	return MNL_CB_OK;
+}
+
+int stat_mr_idx_parse_cb(const struct nlmsghdr *nlh, void *data)
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
+	return stat_mr_line(rd, name, idx, tb);
+}
+
+int stat_mr_parse_cb(const struct nlmsghdr *nlh, void *data)
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
+	    !tb[RDMA_NLDEV_ATTR_RES_MR])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_MR];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+
+		ret = stat_mr_line(rd, name, idx, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+	}
+	return ret;
+}
diff --git a/rdma/stat.c b/rdma/stat.c
index ef0bbcf1..c5641522 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -6,6 +6,7 @@
 
 #include "rdma.h"
 #include "res.h"
+#include "stat.h"
 #include <inttypes.h>
 
 static int stat_help(struct rd *rd)
@@ -174,7 +175,7 @@ static int stat_qp_get_mode(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
-static int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table, bool print)
+int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table, bool print)
 {
 	struct nlattr *nla_entry;
 	const char *nm;
@@ -737,6 +738,7 @@ static int stat_show(struct rd *rd)
 	const struct rd_cmd cmds[] = {
 		{ NULL,		stat_show_link },
 		{ "link",	stat_show_link },
+		{ "mr",		stat_mr },
 		{ "help",	stat_help },
 		{ 0 }
 	};
@@ -752,6 +754,7 @@ int cmd_stat(struct rd *rd)
 		{ "list",	stat_show },
 		{ "help",	stat_help },
 		{ "qp",		stat_qp },
+		{ "mr",		stat_mr },
 		{ 0 }
 	};
 
diff --git a/rdma/stat.h b/rdma/stat.h
new file mode 100644
index 00000000..b03a10c9
--- /dev/null
+++ b/rdma/stat.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/*
+ * stat.h        RDMA tool
+ * Authors:      Mark Zhang <markz@mellanox.com>
+ *		 Erez Alfasi <ereza@mellanox.com>
+ */
+#ifndef _RDMA_TOOL_STAT_H_
+#define _RDMA_TOOL_STAT_H_
+
+#include "rdma.h"
+
+int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table,
+		       bool print);
+
+int stat_mr_parse_cb(const struct nlmsghdr *nlh, void *data);
+int stat_mr_idx_parse_cb(const struct nlmsghdr *nlh, void *data);
+
+static const
+struct filters stat_mr_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "mrn", .is_number = true, .is_doit = true },
+};
+
+RES_FUNC(stat_mr, RDMA_NLDEV_CMD_STAT_GET, stat_mr_valid_filters, true,
+	 RDMA_NLDEV_ATTR_RES_MRN);
+
+#endif /* _RDMA_TOOL_STAT_H_ */
-- 
2.20.1

