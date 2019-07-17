Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C94A26BE4A
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727574AbfGQOcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:53588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727535AbfGQOcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:32:16 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAF4F2182B;
        Wed, 17 Jul 2019 14:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373933;
        bh=jnrmpC/XPkwuy0tjOWmDM+GhPdluEAz214Abmx5ciPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SUfOh54RlCg0ouDv2c2Oaq3J01HTW/x8+NDidC0eHxzTNxW5fHbjQrxodFvA/lDZf
         6bLTAoYc8bj88xcGkwjlsCGgV0zrfUTk78pRmt5CdxsDR9GAJW/P/Evt60ZBU+qJIL
         VdUrDghMS55eAYKrCpcl+1wjLVl7Nti9b4Oqz24w=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 2/7] rdma: Add get per-port counter mode support
Date:   Wed, 17 Jul 2019 17:31:51 +0300
Message-Id: <20190717143157.27205-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717143157.27205-1-leon@kernel.org>
References: <20190717143157.27205-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

Add an interface to show which mode is active. Two modes are supported:
- "auto": In this mode all QPs belong to one category are bind automatically
  to a single counter set. Currently only "qp type" is supported;
- "manual": In this mode QPs are bound to a counter manually.

Examples:
$ rdma statistic qp mode
0/1: mlx5_0/1: qp auto off
1/1: mlx5_1/1: qp auto off
2/1: mlx5_2/1: qp auto type on
3/1: mlx5_3/1: qp auto off

$ rdma statistic qp mode link mlx5_0
0/1: mlx5_0/1: qp auto off

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/stat.c  | 140 +++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c |   2 +
 2 files changed, 142 insertions(+)

diff --git a/rdma/stat.c b/rdma/stat.c
index da35ef7d..0c239851 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -13,13 +13,152 @@ static int stat_help(struct rd *rd)
 	pr_out("Usage: %s [ OPTIONS ] statistic { COMMAND | help }\n", rd->filename);
 	pr_out("       %s statistic OBJECT show\n", rd->filename);
 	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
+	pr_out("       %s statistic OBJECT mode\n", rd->filename);
+	pr_out("where  OBJECT: = { qp }\n");
 	pr_out("Examples:\n");
 	pr_out("       %s statistic qp show\n", rd->filename);
 	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
+	pr_out("       %s statistic qp mode\n", rd->filename);
+	pr_out("       %s statistic qp mode link mlx5_0\n", rd->filename);
 
 	return 0;
 }
 
+struct counter_param {
+	char *name;
+	uint32_t attr;
+};
+
+static struct counter_param auto_params[] = {
+	{ "type", RDMA_COUNTER_MASK_QP_TYPE, },
+	{ NULL },
+};
+
+static int prepare_auto_mode_str(struct nlattr **tb, uint32_t mask,
+				 char *output, int len)
+{
+	char s[] = "qp auto";
+	int i, outlen = strlen(s);
+
+	memset(output, 0, len);
+	snprintf(output, len, "%s", s);
+
+	if (mask) {
+		for (i = 0; auto_params[i].name != NULL; i++) {
+			if (mask & auto_params[i].attr) {
+				outlen += strlen(auto_params[i].name) + 1;
+				if (outlen >= len)
+					return -EINVAL;
+				strcat(output, " ");
+				strcat(output, auto_params[i].name);
+			}
+		}
+
+		if (outlen + strlen(" on") >= len)
+			return -EINVAL;
+		strcat(output, " on");
+	} else {
+		if (outlen + strlen(" off") >= len)
+			return -EINVAL;
+		strcat(output, " off");
+	}
+
+	return 0;
+}
+
+static int qp_link_get_mode_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	uint32_t mode = 0, mask = 0;
+	char output[128] = {};
+	struct rd *rd = data;
+	uint32_t idx, port;
+	const char *name;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME])
+		return MNL_CB_ERROR;
+
+	if (!tb[RDMA_NLDEV_ATTR_PORT_INDEX]) {
+		pr_err("This tool doesn't support switches yet\n");
+		return MNL_CB_ERROR;
+	}
+
+	idx = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	if (tb[RDMA_NLDEV_ATTR_STAT_MODE])
+		mode = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
+
+	if (mode == RDMA_COUNTER_MODE_AUTO) {
+		if (!tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK])
+			return MNL_CB_ERROR;
+		mask = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK]);
+		prepare_auto_mode_str(tb, mask, output, sizeof(output));
+	} else {
+		snprintf(output, sizeof(output), "qp auto off");
+	}
+
+	if (rd->json_output) {
+		jsonw_uint_field(rd->jw, "ifindex", idx);
+		jsonw_uint_field(rd->jw, "port", port);
+		jsonw_string_field(rd->jw, "mode", output);
+	} else {
+		pr_out("%u/%u: %s/%u: %s\n", idx, port, name, port, output);
+	}
+
+	return MNL_CB_OK;
+}
+
+static int stat_one_qp_link_get_mode(struct rd *rd)
+{
+	uint32_t seq;
+	int ret;
+
+	if (!rd->port_idx)
+		return 0;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	/* Make RDMA_NLDEV_ATTR_STAT_MODE valid so that kernel knows
+	 * return only mode instead of all counters
+	 */
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_MODE,
+			 RDMA_COUNTER_MODE_MANUAL);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	if (rd->json_output)
+		jsonw_start_object(rd->jw);
+	ret = rd_recv_msg(rd, qp_link_get_mode_parse_cb, rd, seq);
+	if (rd->json_output)
+		jsonw_end_object(rd->jw);
+
+	return ret;
+}
+
+static int stat_qp_link_get_mode(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_qp_link_get_mode, false);
+}
+
+static int stat_qp_get_mode(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_qp_link_get_mode },
+		{ "link",	stat_qp_link_get_mode },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int res_get_hwcounters(struct rd *rd, struct nlattr *hwc_table, bool print)
 {
 	struct nlattr *nla_entry;
@@ -248,6 +387,7 @@ static int stat_qp(struct rd *rd)
 		{ NULL,		stat_qp_show },
 		{ "show",	stat_qp_show },
 		{ "list",	stat_qp_show },
+		{ "mode",	stat_qp_get_mode },
 		{ "help",	stat_help },
 		{ 0 }
 	};
diff --git a/rdma/utils.c b/rdma/utils.c
index 7bc0439a..9c885ad7 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -443,6 +443,8 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY] = MNL_TYPE_NESTED,
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_NAME] = MNL_TYPE_NUL_STRING,
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = MNL_TYPE_U64,
+	[RDMA_NLDEV_ATTR_STAT_MODE] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_STAT_RES] = MNL_TYPE_U32,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.20.1

