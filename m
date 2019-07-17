Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE856BE52
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 16:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbfGQOcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 10:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727720AbfGQOcb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 10:32:31 -0400
Received: from localhost (unknown [37.142.3.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4376E21743;
        Wed, 17 Jul 2019 14:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563373950;
        bh=oXNAxpjwh9nlKPHsBydBqueLpSUXhiQEV2sMq+jvq24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u7CTf30HRExqBJ01lTtA60uwkAqgKR0WO2YzyTr0ddjqylqATClTx6cWhkfoorwUr
         rEzE0uv0jpEKpeAiTkMLrFflI4yAw2jU7mn43AutYdaG8ND5iA078u+Ch5ZcH1UX19
         dWe/8t94ZBeRK67lSxa/vHMceOUoFcrMgKOAJdiA=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Mark Zhang <markz@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 6/7] rdma: Add default counter show support
Date:   Wed, 17 Jul 2019 17:31:55 +0300
Message-Id: <20190717143157.27205-7-leon@kernel.org>
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

Show default counter statistics, which are same through the sysfs
interface: /sys/class/infiniband/<dev>/ports/<port>/hw_counters/

Example:
$ rdma stat show link mlx5_2/1
link mlx5_2/1 rx_write_requests 8 rx_read_requests 4 rx_atomic_requests 0
out_of_buffer 0 out_of_sequence 0 duplicate_request 0 rnr_nak_retry_err 0
packet_seq_err 0 implied_nak_seq_err 0 local_ack_timeout_err 0
resp_local_length_error 0 resp_cqe_error 0 req_cqe_error 0
req_remote_invalid_request 0 req_remote_access_errors 0
resp_remote_access_errors 0 resp_cqe_flush_error 0 req_cqe_flush_error 0
rp_cnp_ignored 0 rp_cnp_handled 0 np_ecn_marked_roce_packets 0
np_cnp_sent 0 rx_icrc_encapsulated 0

Signed-off-by: Mark Zhang <markz@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/stat.c | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 73 insertions(+), 1 deletion(-)

diff --git a/rdma/stat.c b/rdma/stat.c
index 942c1ac3..ef0bbcf1 100644
--- a/rdma/stat.c
+++ b/rdma/stat.c
@@ -17,6 +17,8 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic OBJECT set COUNTER_SCOPE [DEV/PORT_INDEX] auto {CRITERIA | off}\n", rd->filename);
 	pr_out("       %s statistic OBJECT bind COUNTER_SCOPE [DEV/PORT_INDEX] [OBJECT-ID] [COUNTER-ID]\n", rd->filename);
 	pr_out("       %s statistic OBJECT unbind COUNTER_SCOPE [DEV/PORT_INDEX] [COUNTER-ID]\n", rd->filename);
+	pr_out("       %s statistic show\n", rd->filename);
+	pr_out("       %s statistic show link [ DEV/PORT_INDEX ]\n", rd->filename);
 	pr_out("where  OBJECT: = { qp }\n");
 	pr_out("       CRITERIA : = { type }\n");
 	pr_out("       COUNTER_SCOPE: = { link | dev }\n");
@@ -31,6 +33,8 @@ static int stat_help(struct rd *rd)
 	pr_out("       %s statistic qp bind link mlx5_2/1 lqpn 178 cntn 4\n", rd->filename);
 	pr_out("       %s statistic qp unbind link mlx5_2/1 cntn 4\n", rd->filename);
 	pr_out("       %s statistic qp unbind link mlx5_2/1 cntn 4 lqpn 178\n", rd->filename);
+	pr_out("       %s statistic show\n", rd->filename);
+	pr_out("       %s statistic show link mlx5_2/1\n", rd->filename);
 
 	return 0;
 }
@@ -674,10 +678,78 @@ static int stat_qp(struct rd *rd)
 	return rd_exec_cmd(rd, cmds, "parameter");
 }
 
+static int stat_show_parse_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
+	struct rd *rd = data;
+	const char *name;
+	uint32_t port;
+	int ret;
+
+	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
+	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
+	    !tb[RDMA_NLDEV_ATTR_PORT_INDEX] ||
+	    !tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS])
+		return MNL_CB_ERROR;
+
+	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
+	port = mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+	if (rd->json_output) {
+		jsonw_string_field(rd->jw, "ifname", name);
+		jsonw_uint_field(rd->jw, "port", port);
+	} else {
+		pr_out("link %s/%u ", name, port);
+	}
+
+	ret = res_get_hwcounters(rd, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], true);
+
+	if (!rd->json_output)
+		pr_out("\n");
+	return ret;
+}
+
+static int stat_show_one_link(struct rd *rd)
+{
+	int flags = NLM_F_REQUEST | NLM_F_ACK;
+	uint32_t seq;
+	int ret;
+
+	if (!rd->port_idx)
+		return 0;
+
+	rd_prepare_msg(rd, RDMA_NLDEV_CMD_STAT_GET, &seq,  flags);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_DEV_INDEX, rd->dev_idx);
+	mnl_attr_put_u32(rd->nlh, RDMA_NLDEV_ATTR_PORT_INDEX, rd->port_idx);
+	ret = rd_send_msg(rd);
+	if (ret)
+		return ret;
+
+	return rd_recv_msg(rd, stat_show_parse_cb, rd, seq);
+}
+
+static int stat_show_link(struct rd *rd)
+{
+	return rd_exec_link(rd, stat_show_one_link, false);
+}
+
+static int stat_show(struct rd *rd)
+{
+	const struct rd_cmd cmds[] = {
+		{ NULL,		stat_show_link },
+		{ "link",	stat_show_link },
+		{ "help",	stat_help },
+		{ 0 }
+	};
+
+	return rd_exec_cmd(rd, cmds, "parameter");
+}
+
 int cmd_stat(struct rd *rd)
 {
 	const struct rd_cmd cmds[] =  {
-		{ NULL,		stat_help },
+		{ NULL,		stat_show },
+		{ "show",	stat_show },
+		{ "list",	stat_show },
 		{ "help",	stat_help },
 		{ "qp",		stat_qp },
 		{ 0 }
-- 
2.20.1

