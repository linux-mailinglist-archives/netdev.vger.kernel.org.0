Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3376BE4D
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbfGQOcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727423AbfGQOcU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:32:20 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 034E42182B;
        Wed, 17 Jul 2019 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373939;
        bh=amLX3eh5KPTW4tcOZzx0sxsoFSHElEgac6P7zZoYSr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gh4mj2DlgReKExjGNPFi7jTxQp0a0k1e/WniGaLi9e6Kmwgk7evh1hK5VP3VZEJJs
         3PqjICWoOvaNS/Q9VjnGs6gyCDOmNR4u9ybu6HrndgdWDf2m7GbA4xTENM1T6ey1sE
         7l5duT0KQ6li+ljQUfBKfcRwsmXNdGPP+xzvpgfI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 3/7] rdma: Add rdma statistic counter per-port auto mode support
Date:   Wed, 17 Jul 2019 17:31:52 +0300
Message-Id: <20190717143157.27205-4-leon@kernel.org>
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

With per-QP statistic counter support, a user is allowed to monitor
specific QPs categories, which are bound to/unbound from counters
dynamically allocated/deallocated.

In per-port "auto" mode, QPs are bound to counters automatically
according to common criteria. For example a per "type"(qp type)
scheme, where in each process all QPs have same qp type are bind
automatically to a single counter.
Currently only "type" (qp type) is supported. Examples:

$ rdma statistic qp set link mlx5_2/1 auto type on
$ rdma statistic qp set link mlx5_2/1 auto off

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/stat.c  | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 rdma/utils.c |  1 +
 2 files changed, 88 insertions(+)

diff --git a/rdma/stat.c b/rdma/stat.c
index 0c239851..ad1cc063 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -14,12 +14,17 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic OBJECT show\n", rd->filename);
 	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
 	pr_out("       %s statistic OBJECT mode\n", rd->filename);
+	pr_out("       %s statistic OBJECT set COUNTER_SCOPE [DEV/PORT_INDEX] auto {CRITERIA | off}\n", rd->filename);
 	pr_out("where  OBJECT: = { qp }\n");
+	pr_out("       CRITERIA : = { type }\n");
+	pr_out("       COUNTER_SCOPE: = { link | dev }\n");
 	pr_out("Examples:\n");
 	pr_out("       %s statistic qp show\n", rd->filename);
 	pr_out("       %s statistic qp show link mlx5_2/1\n", rd->filename);
 	pr_out("       %s statistic qp mode\n", rd->filename);
 	pr_out("       %s statistic qp mode link mlx5_0\n", rd->filename);
+	pr_out("       %s statistic qp set link mlx5_2/1 auto type on\n", rd->filename);
+	pr_out("       %s statistic qp set link mlx5_2/1 auto off\n", rd->filename);
 
 	return 0;
 }
@@ -381,6 +386,87 @@ static int stat_qp_show(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int stat_qp_set_link_auto_sendmsg(struct rd *rd, uint32_t mask)
+{
+	uint32_t seq;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_MODE,
+			 RDMA_COUNTER_MODE_AUTO);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK, mask);
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int stat_one_qp_set_link_auto_off(struct rd *rd)
+{
+	return stat_qp_set_link_auto_sendmsg(rd, 0);
+}
+
+static int stat_one_qp_set_auto_type_on(struct rd *rd)
+{
+	return stat_qp_set_link_auto_sendmsg(rd, RDMA_COUNTER_MASK_QP_TYPE);
+}
+
+static int stat_one_qp_set_link_auto_type(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "on",		stat_one_qp_set_auto_type_on },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_one_qp_set_link_auto(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_one_qp_link_get_mode },
+		{ "off",	stat_one_qp_set_link_auto_off },
+		{ "type",	stat_one_qp_set_link_auto_type },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_one_qp_set_link(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_one_qp_link_get_mode },
+		{ "auto",	stat_one_qp_set_link_auto },
+		{ 0 }
+	};
+
+	if (!rd->port_idx)
+		return 0;
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_qp_set_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_qp_set_link, false);
+}
+
+static int stat_qp_set(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "link",	stat_qp_set_link },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int stat_qp(struct rd *rd)
 {
 	const struct rd_cmd cmds[] =  {
@@ -388,6 +474,7 @@ static int stat_qp(struct rd *rd)
 		{ "show",	stat_qp_show },
 		{ "list",	stat_qp_show },
 		{ "mode",	stat_qp_get_mode },
+		{ "set",	stat_qp_set },
 		{ "help",	stat_help },
 		{ 0 }
 	};
diff --git a/rdma/utils.c b/rdma/utils.c
index 9c885ad7..aed1a3d0 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -445,6 +445,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_HWCOUNTER_ENTRY_VALUE] = MNL_TYPE_U64,
 	[RDMA_NLDEV_ATTR_STAT_MODE] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_STAT_RES] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK] = MNL_TYPE_U32,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
-- 
2.20.1

