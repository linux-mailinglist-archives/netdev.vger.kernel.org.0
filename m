Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BE66BE55
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfGQOcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:32:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbfGQOcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:32:42 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5275121743;
        Wed, 17 Jul 2019 14:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373961;
        bh=AdwEpxyJ1eJuGvJPr4f48rGWB+DKXfBSL/iJJnSVrAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qD7e7JpfZ499wtLoShKs/UQEh/R1l9EEw/FbgirEE1g4050OD9/qBw3waRuMjQsnW
         UOKoAS35Bf5ZXg2YgDTwSBofJqTaPH5bS5y0VMOrbFoUtuNkrplO9eQx32j7dgf/gd
         WCsr7x0sjBai0n7OXqmtwrA5haNZef6/AWkpm2so=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 5/7] rdma: Add stat manual mode support
Date:   Wed, 17 Jul 2019 17:31:54 +0300
Message-Id: <20190717143157.27205-6-leon@kernel.org>
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

In manual mode a QP can be manually bound to a counter. If the counter
id(cntn) is not specified that kernel will allocate one. After a
successful bind, the cntn can be seen through "rdma statistic qp show".
And in unbind if lqpn is not specified then all QPs on this counter will
be unbound.
The manual and auto mode are mutual-exclusive.

Examples:
$ rdma statistic qp bind link mlx5_2/1 lqpn 178
$ rdma statistic qp bind link mlx5_2/1 lqpn 178 cntn 4
$ rdma statistic qp unbind link mlx5_2/1 cntn 4
$ rdma statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/stat.c | 192 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 192 insertions(+)

diff --git a/rdma/stat.c b/rdma/stat.c
index ad1cc063..942c1ac3 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -15,6 +15,8 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic OBJECT show link [ DEV/PORT_INDEX ] [ FILTER-NAME FILTER-VALUE ]\n", rd->filename);
 	pr_out("       %s statistic OBJECT mode\n", rd->filename);
 	pr_out("       %s statistic OBJECT set COUNTER_SCOPE [DEV/PORT_INDEX] auto {CRITERIA | off}\n", rd->filename);
+	pr_out("       %s statistic OBJECT bind COUNTER_SCOPE [DEV/PORT_INDEX] [OBJECT-ID] [COUNTER-ID]\n", rd->filename);
+	pr_out("       %s statistic OBJECT unbind COUNTER_SCOPE [DEV/PORT_INDEX] [COUNTER-ID]\n", rd->filename);
 	pr_out("where  OBJECT: = { qp }\n");
 	pr_out("       CRITERIA : = { type }\n");
 	pr_out("       COUNTER_SCOPE: = { link | dev }\n");
@@ -25,6 +27,10 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic qp mode link mlx5_0\n", rd->filename);
 	pr_out("       %s statistic qp set link mlx5_2/1 auto type on\n", rd->filename);
 	pr_out("       %s statistic qp set link mlx5_2/1 auto off\n", rd->filename);
+	pr_out("       %s statistic qp bind link mlx5_2/1 lqpn 178\n", rd->filename);
+	pr_out("       %s statistic qp bind link mlx5_2/1 lqpn 178 cntn 4\n", rd->filename);
+	pr_out("       %s statistic qp unbind link mlx5_2/1 cntn 4\n", rd->filename);
+	pr_out("       %s statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178\n", rd->filename);
 
 	return 0;
 }
@@ -467,6 +473,190 @@ static int stat_qp_set(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int stat_get_arg(struct rd *rd, const char *arg)
+{
+	int value = 0;
+	char *endp;
+
+	if (strcmpx(rd_argv(rd), arg) != 0)
+		return -EINVAL;
+
+	rd_arg_inc(rd);
+	value = strtol(rd_argv(rd), &endp, 10);
+	rd_arg_inc(rd);
+
+	return value;
+}
+
+static int stat_one_qp_bind(struct rd *rd)
+{
+	int lqpn = 0, cntn = 0, ret;
+	uint32_t seq;
+
+	if (rd_no_arg(rd)) {
+		stat_help(rd);
+		return -EINVAL;
+	}
+
+	ret = rd_build_filter(rd, stat_valid_filters);
+	if (ret)
+		return ret;
+
+	lqpn = stat_get_arg(rd, "lqpn");
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_SET,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_MODE,
+			 RDMA_COUNTER_MODE_MANUAL);
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_RES_LQPN, lqpn);
+
+	if (rd_argc(rd)) {
+		cntn = stat_get_arg(rd, "cntn");
+		mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_COUNTER_ID,
+				 cntn);
+	}
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int do_stat_qp_unbind_lqpn(struct rd *rd, uint32_t cntn, uint32_t lqpn)
+{
+	uint32_t seq;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_DEL,
+		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
+
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_MODE,
+			 RDMA_COUNTER_MODE_MANUAL);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_RES_LQPN, lqpn);
+
+	return rd_sendrecv_msg(rd, seq);
+}
+
+static int stat_get_counter_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct nlattr *nla_table, *nla_entry;
+	struct rd *rd = data;
+	uint32_t lqpn, cntn;
+	int err;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+
+	if (!tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID])
+		return MNL_CB_ERROR;
+	cntn = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
+
+	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
+	if (!nla_table)
+		return MNL_CB_ERROR;
+
+	mnl_attr_for_each_nested(nla_entry, nla_table) {
+		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
+
+		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
+		if (err != MNL_CB_OK)
+			return -EINVAL;
+
+		if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN])
+			return -EINVAL;
+
+		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+		err = do_stat_qp_unbind_lqpn(rd, cntn, lqpn);
+		if (err)
+			return MNL_CB_ERROR;
+	}
+
+	return MNL_CB_OK;
+}
+
+static int stat_one_qp_unbind(struct rd *rd)
+{
+	int flags = NLM_F_REQUEST | NLM_F_ACK, ret;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int lqpn = 0, cntn = 0;
+	unsigned int portid;
+	uint32_t seq;
+
+	ret = rd_build_filter(rd, stat_valid_filters);
+	if (ret)
+		return ret;
+
+	cntn = stat_get_arg(rd, "cntn");
+	if (rd_argc(rd)) {
+		lqpn = stat_get_arg(rd, "lqpn");
+		return do_stat_qp_unbind_lqpn(rd, cntn, lqpn);
+	}
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET, &seq, flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_RES, RDMA_NLDEV_ATTR_RES_QP);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_STAT_COUNTER_ID, cntn);
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+
+	/* Can't use rd_recv_msg() since the callback also calls it (recursively),
+	 * then rd_recv_msg() always return -1 here
+	 */
+	portid = mnl_socket_get_portid(rd->nl);
+	ret = mnl_socket_recvfrom(rd->nl, buf, sizeof(buf));
+	if (ret <= 0)
+		return ret;
+
+	ret = mnl_cb_run(buf, ret, seq, portid, stat_get_counter_parse_cb, rd);
+	mnl_socket_close(rd->nl);
+	if (ret != MNL_CB_OK)
+		return ret;
+
+	return 0;
+}
+
+static int stat_qp_bind_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_qp_bind, true);
+}
+
+static int stat_qp_bind(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "link",	stat_qp_bind_link },
+		{ "help",	stat_help },
+		{ 0 },
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
+static int stat_qp_unbind_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_one_qp_unbind, true);
+}
+
+static int stat_qp_unbind(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_help },
+		{ "link",	stat_qp_unbind_link },
+		{ "help",	stat_help },
+		{ 0 },
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 static int stat_qp(struct rd *rd)
 {
 	const struct rd_cmd cmds[] =  {
@@ -475,6 +665,8 @@ static int stat_qp(struct rd *rd)
 		{ "list",	stat_qp_show },
 		{ "mode",	stat_qp_get_mode },
 		{ "set",	stat_qp_set },
+		{ "bind",	stat_qp_bind },
+		{ "unbind",	stat_qp_unbind },
 		{ "help",	stat_help },
 		{ 0 }
 	};
-- 
2.20.1

