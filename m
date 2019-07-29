Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D633E78679
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 09:42:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfG2Hmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 03:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfG2Hmh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 03:42:37 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F579206E0;
        Mon, 29 Jul 2019 07:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564386156;
        bh=1JUqeT8ctKek+jYDM8yo4uExahkQL/RgSRbVgoDobMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lxLGksO2H+GLz/FbPcdnJxYhV1lP9HcTJElaUBH1lMVc5El5EBk+QV1wyovJ9vzBu
         DVVD05wB/QDkrfZSN7zSdvuCLr9SAVCV0+6bgnMsXpLIQzH/Eqohw0w9hbDgKgVHHs
         0REqqyeXm+Eoke1GpRX6IgFEFaMNj5FGiFlyoFwI=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>
Subject: [PATCH iproute2-rc 1/2] rdma: Control CQ adaptive moderation (DIM)
Date:   Mon, 29 Jul 2019 10:42:25 +0300
Message-Id: <20190729074226.4335-2-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190729074226.4335-1-leon@kernel.org>
References: <20190729074226.4335-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yamin Friedman <yaminf@mellanox.com>

In order to set adaptive-moderation for an ib device the command is:
rdma dev set [DEV] adaptive-moderation [on|off]

rdma dev show -d
0: mlx5_0: node_type ca fw 16.25.0319 node_guid 248a:0703:00a5:29d0
sys_image_guid 248a:0703:00a5:29d0 adaptive-moderation on
caps: <BAD_PKEY_CNTR, BAD_QKEY_CNTR, AUTO_PATH_MIG, CHANGE_PHY_PORT,
PORT_ACTIVE_EVENT, SYS_IMAGE_GUID, RC_RNR_NAK_GEN, MEM_WINDOW, XRC,
MEM_MGT_EXTENSIONS, BLOCK_MULTICAST_LOOPBACK, MEM_WINDOW_TYPE_2B,
RAW_IP_CSUM, CROSS_CHANNEL, MANAGED_FLOW_STEERING, SIGNATURE_HANDOVER,
ON_DEMAND_PAGING, SG_GAPS_REG, RAW_SCATTER_FCS, PCI_WRITE_END_PADDING>

rdma resource show cq
dev mlx5_0 cqn 0 cqe 1023 users 4 poll-ctx UNBOUND_WORKQUEUE
adaptive-moderation off comm [ib_core]

Signed-off-by: Yamin Friedman <yaminf@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/dev.c    | 55 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 rdma/rdma.h   |  1 +
 rdma/res-cq.c | 15 ++++++++++++++
 rdma/utils.c  |  6 ++++++
 4 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/rdma/dev.c b/rdma/dev.c
index d28bf6b3..c597cba5 100644
--- a/rdma/dev.c
+++ b/rdma/dev.c
@@ -12,6 +12,7 @@ static int dev_help(struct rd *rd)
 	pr_out("Usage: %s dev show [DEV]\n", rd->filename);
 	pr_out("       %s dev set [DEV] name DEVNAME\n", rd->filename);
 	pr_out("       %s dev set [DEV] netns NSNAME\n", rd->filename);
+	pr_out("       %s dev set [DEV] adaptive-moderation [on|off]\n", rd->filename);
 	return 0;
 }
 
@@ -167,6 +168,21 @@ static void dev_print_sys_image_guid(struct rd *rd, struct nlattr **tb)
 		pr_out("sys_image_guid %s ", str);
 }
 
+static void dev_print_dim_setting(struct rd *rd, struct nlattr **tb)
+{
+	uint8_t dim_setting;
+
+	if (!tb[RDMA_NLDEV_ATTR_DEV_DIM])
+		return;
+
+	dim_setting = mnl_attr_get_u8(tb[RDMA_NLDEV_ATTR_DEV_DIM]);
+	if (dim_setting > 1)
+		return;
+
+	print_on_off(rd, "adaptive-moderation", dim_setting);
+
+}
+
 static const char *node_type_to_str(uint8_t node_type)
 {
 	static const char * const node_type_str[] = { "unknown", "ca",
@@ -219,8 +235,10 @@ static int dev_parse_cb(const struct nlmsghdr *nlh, void *data)
 	dev_print_fw(rd, tb);
 	dev_print_node_guid(rd, tb);
 	dev_print_sys_image_guid(rd, tb);
-	if (rd->show_details)
+	if (rd->show_details) {
+		dev_print_dim_setting(rd, tb);
 		dev_print_caps(rd, tb);
+	}
 
 	if (!rd->json_output)
 		pr_out("\n");
@@ -308,12 +326,47 @@ done:
 	return ret;
 }
 
+static int dev_set_dim_sendmsg(struct rd *rd, uint8_t dim_setting)
+{
+	uint32_t seq;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SET, &seq,
+		       (NLM_F_REQUEST | NLM_F_ACK));
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u8(rd->nlh, RDMA_NLDEV_ATTR_DEV_DIM, dim_setting);
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int dev_set_dim_off(struct rd *rd)
+{
+	return dev_set_dim_sendmsg(rd, 0);
+}
+
+static int dev_set_dim_on(struct rd *rd)
+{
+	return dev_set_dim_sendmsg(rd, 1);
+}
+
+static int dev_set_dim(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		dev_help},
+		{ "on",		dev_set_dim_on},
+		{ "off",	dev_set_dim_off},
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int dev_one_set(struct rd *rd)
 {
 	const struct rd_cmd cmds[] = {
 		{ NULL,		dev_help},
 		{ "name",	dev_set_name},
 		{ "netns",	dev_set_netns},
+		{ "adaptive-moderation",	dev_set_dim},
 		{ 0 }
 	};
 
diff --git a/rdma/rdma.h b/rdma/rdma.h
index 23157743..dfd1b70b 100644
--- a/rdma/rdma.h
+++ b/rdma/rdma.h
@@ -136,6 +136,7 @@ int rd_attr_check(const struct nlattr *attr, int *typep);
 void print_driver_table(struct rd *rd, struct nlattr *tb);
 void newline(struct rd *rd);
 void newline_indent(struct rd *rd);
+void print_on_off(struct rd *rd, const char *key_str, bool on);
 #define MAX_LINE_LENGTH 80
 
 #endif /* _RDMA_TOOL_H_ */
diff --git a/rdma/res-cq.c b/rdma/res-cq.c
index 5afb97c5..d2591fbe 100644
--- a/rdma/res-cq.c
+++ b/rdma/res-cq.c
@@ -30,6 +30,20 @@ static void print_poll_ctx(struct rd *rd, uint8_t poll_ctx, struct nlattr *attr)
 	pr_out("poll-ctx %s ", poll_ctx_to_str(poll_ctx));
 }
 
+static void print_cq_dim_setting(struct rd *rd, struct nlattr *attr)
+{
+	uint8_t dim_setting;
+
+	if (!attr)
+		return;
+
+	dim_setting = mnl_attr_get_u8(attr);
+	if (dim_setting > 1)
+		return;
+
+	print_on_off(rd, "adaptive-moderation", dim_setting);
+}
+
 static int res_cq_line(struct rd *rd, const char *name, int idx,
 		       struct nlattr **nla_line)
 {
@@ -97,6 +111,7 @@ static int res_cq_line(struct rd *rd, const char *name, int idx,
 	res_print_uint(rd, "users", users,
 		       nla_line[RDMA_NLDEV_ATTR_RES_USECNT]);
 	print_poll_ctx(rd, poll_ctx, nla_line[RDMA_NLDEV_ATTR_RES_POLL_CTX]);
+	print_cq_dim_setting(rd, nla_line[RDMA_NLDEV_ATTR_DEV_DIM]);
 	res_print_uint(rd, "ctxn", ctxn, nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
 	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
 	print_comm(rd, comm, nla_line);
diff --git a/rdma/utils.c b/rdma/utils.c
index 95b669f3..37659011 100644
--- a/rdma/utils.c
+++ b/rdma/utils.c
@@ -449,6 +449,7 @@ static const enum mnl_attr_data_type nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_STAT_MODE] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_STAT_RES] = MNL_TYPE_U32,
 	[RDMA_NLDEV_ATTR_STAT_AUTO_MODE_MASK] = MNL_TYPE_U32,
+	[RDMA_NLDEV_ATTR_DEV_DIM] = MNL_TYPE_U8,
 };
 
 int rd_attr_check(const struct nlattr *attr, int *typep)
@@ -789,6 +790,11 @@ static int print_driver_string(struct rd *rd, const char *key_str,
 	}
 }
 
+void print_on_off(struct rd *rd, const char *key_str, bool on)
+{
+	print_driver_string(rd, key_str, (on) ? "on":"off");
+}
+
 static int print_driver_s32(struct rd *rd, const char *key_str, int32_t val,
 			      enum rdma_nldev_print_type print_type)
 {
-- 
2.20.1

