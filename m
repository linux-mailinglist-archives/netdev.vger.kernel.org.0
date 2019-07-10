Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CCD6429B
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 09:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727212AbfGJHZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 03:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:50720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726043AbfGJHZK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 03:25:10 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FAD920838;
        Wed, 10 Jul 2019 07:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562743509;
        bh=rUQz/RVYEmZJT6QHUPupskHT2EiayyFtW9d9+A0S/Z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l7EwxjfYVI/YH2Ik7Z8D7SnGR2AGGa4F4gp2TfDUyvT5mQZgpA9rzNBYNzh13hGVd
         4yP01SpaH76/f4v+98r7HJUpQPLYt2j9gs6PnZ/CRDfmaniVPEBwm+bUTTD452rg2P
         5ZmbepMIhJrASf74sdnrLCGmeyM9WZpB0jHpZauE=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc 2/8] rdma: Add "stat qp show" support
Date:   Wed, 10 Jul 2019 10:24:49 +0300
Message-Id: <20190710072455.9125-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190710072455.9125-1-leon@kernel.org>
References: <20190710072455.9125-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

This patch presents link, id, task name, lqpn, as well as all sub
counters of a QP counter.
A QP counter is a dynamically allocated statistic counter that is
bound with one or more QPs. It has several sub-counters, each is
used for a different purpose.

Examples:
$ rdma stat qp show
link mlx5_2/1 cntn 5 pid 31609 comm client.1 rx_write_requests 0
rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 out_of_sequence 0
duplicate_request 0 rnr_nak_retry_err 0 packet_seq_err 0
implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0
resp_cqe_error 0 req_cqe_error 0 req_remote_invalid_request 0
req_remote_access_errors 0 resp_remote_access_errors 0
resp_cqe_flush_error 0 req_cqe_flush_error 0
    LQPN: <178>
$ rdma stat show link rocep1s0f5/1
link rocep1s0f5/1 rx_write_requests 0 rx_read_requests 0 rx_atomic_requests 0 out_of_buffer 0 duplicate_request 0
rnr_nak_retry_err 0 packet_seq_err 0 implied_nak_seq_err 0 local_ack_timeout_err 0 resp_local_length_error 0 resp_cqe_error 0
req_cqe_error 0 req_remote_invalid_request 0 req_remote_access_errors 0 resp_remote_access_errors 0 resp_cqe_flush_error 0
req_cqe_flush_error 0 rp_cnp_ignored 0 rp_cnp_handled 0 np_ecn_marked_roce_packets 0 np_cnp_sent 0
$ rdma stat show link rocep1s0f5/1 -p
link rocep1s0f5/1
    rx_write_requests 0
    rx_read_requests 0
    rx_atomic_requests 0
    out_of_buffer 0
    duplicate_request 0
    rnr_nak_retry_err 0
    packet_seq_err 0
    implied_nak_seq_err 0
    local_ack_timeout_err 0
    resp_local_length_error 0
    resp_cqe_error 0
    req_cqe_error 0
    req_remote_invalid_request 0
    req_remote_access_errors 0
    resp_remote_access_errors 0
    resp_cqe_flush_error 0
    req_cqe_flush_error 0
    rp_cnp_ignored 0
    rp_cnp_handled 0
    np_ecn_marked_roce_packets 0
    np_cnp_sent 0

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/Makefile |   2 +-
 rdma/rdma.c   |   3 +-
 rdma/rdma.h   |   1 +
 rdma/stat.c   | 268 ++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c  |   7 ++
 5 files changed, 279 insertions(+), 2 deletions(-)
 create mode 100644 rdma/stat.c

diff --git a/rdma/Makefile b/rdma/Makefile
index 4847f27e..e3f550bf 100644
--- a/rdma/Makefile
+++ b/rdma/Makefile
@@ -7,7 +7,7 @@ ifeq ($(HAVE_MNL),y)
 CFLAGS += -I./include/uapi/
 
 RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
-	   res-cmid.o res-qp.o sys.o
+	   res-cmid.o res-qp.o sys.o stat.o
 
 TARGETS += rdma
 endif
diff --git a/rdma/rdma.c b/rdma/rdma.c
index e9f1b4bb..4e34da92 100644
--- a/rdma/rdma.c
+++ b/rdma/rdma.c
@@ -11,7 +11,7 @@ static void help(char *name)
 {
 	pr_out("Usage: %s [ OPTIONS ] OBJECT { COMMAND | help }\n"
 	       "       %s [ -f[orce] ] -b[atch] filename\n"
-	       "where  OBJECT := { dev | link | resource | system | help }\n"
+	       "where  OBJECT := { dev | link | resource | system | statistic | help }\n"
 	       "       OPTIONS := { -V[ersion] | -d[etails] | -j[son] | -p[retty]}\n", name, name);
 }
 
@@ -30,6 +30,7 @@ static int rd_cmd(struct rd *rd, int argc, char **argv)
 		{ "link",	cmd_link },
 		{ "resource",	cmd_res },
 		{ "system",	cmd_sys },
+		{ "statistic",	cmd_stat },
 		{ 0 }
 	};
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 885a751e..23157743 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -94,6 +94,7 @@ int cmd_dev(struct rd *rd);
 int cmd_link(struct rd *rd);
 int cmd_res(struct rd *rd);
 int cmd_sys(struct rd *rd);
+int cmd_stat(struct rd *rd);
 int rd_exec_cmd(struct rd *rd, const struct rd_cmd *c, const char *str);
 int rd_exec_dev(struct rd *rd, int (*cb)(struct rd *rd));
 int rd_exec_require_dev(struct rd *rd, int (*cb)(struct rd *rd));
diff --git a/rdma/stat.c b/rdma/stat.c
new file mode 100644
index 00000000..da35ef7d
--- /dev/null
+++ b/rdma/stat.c
@@ -0,0 +1,268 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * rdma.c	RDMA tool
+ * Authors:     Mark Zhang <markz@mellanox.com>
+ */
+
+#include "rdma.h"
+#include "res.h"
+#include <inttypes.h>
+
+static int stat_help(struct rd *rd)
+{
+	pr_out("Usage: %s [ OPTIONS ] statistic { COMMAND | help }\n", rd->filename);
+	pr_out("       %s statistic OBJECT show\n", rd->filename);
+	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
+	pr_out("Examples:\n");
+	pr_out("       %s statistic qp show\n", rd->filename);
+	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
+
+	return 0;
+}
+
+static int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table, bool print)
+{
+	struct nlattr *nla_entry;
+	const char *nm;
+	uint64_t v;
+	int err;
+
+	mnl_attr_for_each_nested(nla_entry, hwc_table) {
+		struct nlattr *hw_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, hw_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] ||
+		    !hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE]) {
+			return -EINVAL;
+		}
+
+		if (!print)
+			continue;
+
+		nm = mnl_attr_get_str(hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
+		v = mnl_attr_get_u64(hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE]);
+		if (rd->pretty_output && !rd->json_output)
+			newline_indent(rd);
+		res_print_uint(rd, nm, v, hw_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME]);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int res_counter_line(struct rd *rd, const char *name, int index,
+		       struct nlattr **nla_line)
+{
+	uint32_t cntn, port = 0, pid = 0, qpn;
+	struct nlattr *hwc_table, *qp_table;
+	struct nlattr *nla_entry;
+	const char *comm = NULL;
+	bool isfirst;
+	int err;
+
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+	hwc_table = nla_line[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS];
+	qp_table = nla_line[RDMA_NLDEV_ATTR_RES_QP];
+	if (!hwc_table || !qp_table ||
+	    !nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
+		return MNL_CB_ERROR;
+
+	cntn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+	if (rd_is_filtered_attr(rd, "cntn", cntn,
+				nla_line[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]))
+		return MNL_CB_OK;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		comm = get_task_name(pid);
+	}
+	if (rd_is_filtered_attr(rd, "pid", pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
+		return MNL_CB_OK;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
+		comm = (char *)mnl_attr_get_str(
+			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+
+	mnl_attr_for_each_nested(nla_entry, qp_table) {
+		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN])
+			return -EINVAL;
+
+		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd_is_filtered_attr(rd, "lqpn", qpn,
+					qp_line[RDMA_NLDEV_ATTR_RES_LQPN]))
+			return MNL_CB_OK;
+	}
+
+	err = res_get_hwcounters(rd, hwc_table, false);
+	if (err != MNL_CB_OK)
+		return err;
+
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "ifname", name);
+		if (port)
+			jsonw_uint_field(rd->jw, "port", port);
+		jsonw_uint_field(rd->jw, "cntn", cntn);
+	} else {
+		if (port)
+			pr_out("link %s/%u cntn %u ", name, port, cntn);
+		else
+			pr_out("dev %s cntn %u ", name, cntn);
+	}
+
+	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	print_comm(rd, comm, nla_line);
+
+	res_get_hwcounters(rd, hwc_table, true);
+
+	isfirst = true;
+	mnl_attr_for_each_nested(nla_entry, qp_table) {
+		struct nlattr *qp_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		if (isfirst && !rd->json_output)
+			pr_out("\n    LQPN: <");
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, qp_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!qp_line[RDMA_NLDEV_ATTR_RES_LQPN])
+			return -EINVAL;
+
+		qpn = mnl_attr_get_u32(qp_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		if (rd->json_output) {
+			jsonw_uint_field(rd->jw, "lqpn", qpn);
+		} else {
+			if (isfirst)
+				pr_out("%d", qpn);
+			else
+				pr_out(", %d", qpn);
+		}
+		isfirst = false;
+	}
+
+	if (!rd->json_output)
+		pr_out(">\n");
+	return MNL_CB_OK;
+}
+
+static int stat_qp_show_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	const char *name;
+	uint32_t idx;
+	int ret;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_STAT_COUNTER])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	nla_table = tb[RDMA_NLDEV_ATTR_STAT_COUNTER];
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		ret = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+
+		ret = res_counter_line(rd, name, idx, nla_line);
+		if (ret != MNL_CB_OK)
+			break;
+	}
+
+	return ret;
+}
+
+static const struct filters stat_valid_filters[MAX_NUMBER_OF_FILTERS] = {
+	{ .name = "cntn", .is_number = true },
+	{ .name = "lqpn", .is_number = true },
+	{ .name = "pid", .is_number = true },
+};
+
+static int stat_qp_show_one_link(struct rd *rd)
+{
+	int flags = NLM_F_REQUEST | NLM_F_ACK | NLM_F_DUMP;
+	uint32_t seq;
+	int ret;
+
+	if (!rd->port_idx)
+		return 0;
+
+	ret = rd_build_filter(rd, stat_valid_filters);
+	if (ret)
+		return ret;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	if (rd->json_output)
+		jsonw_start_object(rd->jw);
+	ret = rd_recv_msg(rd, stat_qp_show_parse_cb, rd, seq);
+	if (rd->json_output)
+		jsonw_end_object(rd->jw);
+
+	return ret;
+}
+
+static int stat_qp_show_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_qp_show_one_link, false);
+}
+
+static int stat_qp_show(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_qp_show_link },
+		{ "link",	stat_qp_show_link },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_qp(struct rd *rd)
+{
+	const struct rd_cmd cmds[] =  {
+		{ NULL,		stat_qp_show },
+		{ "show",	stat_qp_show },
+		{ "list",	stat_qp_show },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+int cmd_stat(struct rd *rd)
+{
+	const struct rd_cmd cmds[] =  {
+		{ NULL,		stat_help },
+		{ "help",	stat_help },
+		{ "qp",		stat_qp },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "statistic command");
+}
diff --git a/rdma/utils.c b/rdma/utils.c
index 558d1c29..7bc0439a 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -436,6 +436,13 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_DRIVER_S64] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_DRIVER_U64] = MNL_TYPE_U64,
 	[RDMA_NLDEV_SYS_ATTR_NETNS_MODE] = MNL_TYPE_U8,
+	[RDMA_NLDEV_ATTR_STAT_COUNTER] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_COUNTER_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_COUNTER_ID] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY] = MNL_TYPE_NESTED,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] = MNL_TYPE_NUL_STRING,
+	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = MNL_TYPE_U64,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.20.1

