Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95AAA1DD569
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 19:59:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgEUR72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 13:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:59342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727883AbgEUR72 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 13:59:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C299E20759;
        Thu, 21 May 2020 17:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590083967;
        bh=ZtsyQMfxQsQj+r7AGr7M1rrJfqwy3ngNvTeWJrAKq/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPQu72OIVIkUgEzqHlZ7ScLE6gnPbVEbZEnyd+HEGWWmBkmq6EG2v82OgxdgOt2ke
         JVeLXp4QdLWmZGJzCgHmJVkt+ObzErmA16oOpHIJkpEEoBFct+IIDViwQaL0hoiLQ4
         99lI61Ju0cKwBKPSnbNMILmtHbVDZF3C+FnLvwjo=
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 1/4] rdma: Refactor res_qp_line
Date:   Wed, 20 May 2020 13:25:36 +0300
Message-Id: <20200520102539.458983-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200520102539.458983-1-leon@kernel.org>
References: <20200520102539.458983-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Downstream patch adds the support to get the QP data in raw format.
Move the unshared code to function.

Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 rdma/res-qp.c | 114 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 69 insertions(+), 45 deletions(-)

diff --git a/rdma/res-qp.c b/rdma/res-qp.c
index 801cfca9..b36b7289 100644
--- a/rdma/res-qp.c
+++ b/rdma/res-qp.c
@@ -64,54 +64,53 @@ static void print_pathmig(struct rd *rd, uint32_t val, struct nlattr **nla_line)
 			   "path-mig-state %s ", path_mig_to_str(val));
 }

-static int res_qp_line(struct rd *rd, const char *name, int idx,
-		       struct nlattr **nla_line)
+struct res_qp_info {
+	uint32_t lqpn;
+	uint32_t port;
+	uint32_t pid;
+	char *comm;
+};
+
+static bool resp_is_valid(struct nlattr **nla_line)
 {
-	uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
-	uint8_t type, state, path_mig_state = 0;
-	uint32_t port = 0, pid = 0;
-	uint32_t pdn = 0;
-	char *comm = NULL;
-
 	if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
 	    !nla_line[RDMA_NLDEV_ATTR_RES_STATE])
-		return MNL_CB_ERROR;
-
-	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
-		port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
-
-	if (port != rd->port_idx)
-		goto out;
+		return false;
+	return true;
+}

-	lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
-	if (rd_is_filtered_attr(rd, "lqpn", lqpn,
-				nla_line[RDMA_NLDEV_ATTR_RES_LQPN]))
-		goto out;
+static void res_qp_line_query(struct rd *rd, const char *name, int idx,
+			      struct nlattr **nla_line,
+			      struct res_qp_info *info)
+{
+	uint8_t type, state, path_mig_state = 0;
+	uint32_t rqpn = 0, rq_psn = 0, sq_psn;
+	uint32_t pdn = 0;

 	if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
 		pdn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
 	if (rd_is_filtered_attr(rd, "pdn", pdn,
 				nla_line[RDMA_NLDEV_ATTR_RES_PDN]))
-		goto out;
+		return;

 	if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
 		rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
 	if (rd_is_filtered_attr(rd, "rqpn", rqpn,
 				nla_line[RDMA_NLDEV_ATTR_RES_RQPN]))
-		goto out;
+		return;

 	if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
 		rq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
 	if (rd_is_filtered_attr(rd, "rq-psn", rq_psn,
 				nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]))
-		goto out;
+		return;

 	sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
 	if (rd_is_filtered_attr(rd, "sq-psn", sq_psn,
 				nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]))
-		goto out;
+		return;

 	if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
 		path_mig_state = mnl_attr_get_u8(
@@ -119,35 +118,22 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,
 	if (rd_is_string_filtered_attr(
 		    rd, "path-mig-state", path_mig_to_str(path_mig_state),
 		    nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]))
-		goto out;
+		return;

 	type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
 	if (rd_is_string_filtered_attr(rd, "type", qp_types_to_str(type),
 				       nla_line[RDMA_NLDEV_ATTR_RES_TYPE]))
-		goto out;
+		return;

 	state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
 	if (rd_is_string_filtered_attr(rd, "state", qp_states_to_str(state),
 				       nla_line[RDMA_NLDEV_ATTR_RES_STATE]))
-		goto out;
-
-	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
-		pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-		comm = get_task_name(pid);
-	}
-
-	if (rd_is_filtered_attr(rd, "pid", pid,
-				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
-		goto out;
-
-	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
-		/* discard const from mnl_attr_get_str */
-		comm = (char *)mnl_attr_get_str(
-			nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
+		return;

 	open_json_object(NULL);
-	print_link(rd, idx, name, port, nla_line);
-	res_print_uint(rd, "lqpn", lqpn, nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+	print_link(rd, idx, name, info->port, nla_line);
+	res_print_uint(rd, "lqpn", info->lqpn,
+		       nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
 	print_rqpn(rd, rqpn, nla_line);

 	print_type(rd, type);
@@ -159,14 +145,52 @@ static int res_qp_line(struct rd *rd, const char *name, int idx,

 	print_pathmig(rd, path_mig_state, nla_line);
 	res_print_uint(rd, "pdn", pdn, nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
-	res_print_uint(rd, "pid", pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
-	print_comm(rd, comm, nla_line);
+	res_print_uint(rd, "pid", info->pid, nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+	print_comm(rd, info->comm, nla_line);

 	print_driver_table(rd, nla_line[RDMA_NLDEV_ATTR_DRIVER]);
 	newline(rd);
+}
+
+static int res_qp_line(struct rd *rd, const char *name, int idx,
+		       struct nlattr **nla_line)
+{
+	struct res_qp_info info = {};
+
+	if (!resp_is_valid(nla_line))
+		return MNL_CB_ERROR;
+
+	if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
+		info.port =
+			mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
+
+	if (info.port != rd->port_idx)
+		goto out;
+
+	info.lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
+	if (rd_is_filtered_attr(rd, "lqpn", info.lqpn,
+				nla_line[RDMA_NLDEV_ATTR_RES_LQPN]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
+		info.pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
+		info.comm = get_task_name(info.pid);
+	}
+
+	if (rd_is_filtered_attr(rd, "pid", info.pid,
+				nla_line[RDMA_NLDEV_ATTR_RES_PID]))
+		goto out;
+
+	if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]) {
+		struct nlattr *line = nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME];
+		/* discard const from mnl_attr_get_str */
+		info.comm = (char *)mnl_attr_get_str(line);
+	}
+
+	res_qp_line_query(rd, name, idx, nla_line, &info);
 out:
 	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-		free(comm);
+		free(info.comm);
 	return MNL_CB_OK;
 }

--
2.26.2

