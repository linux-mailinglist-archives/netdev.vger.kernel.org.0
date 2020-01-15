Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A109113C150
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 13:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgAOMn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 07:43:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725999AbgAOMn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jan 2020 07:43:56 -0500
Received: from localhost (unknown [193.47.165.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1937222C3;
        Wed, 15 Jan 2020 12:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579092234;
        bh=lPZnYEF1mpGk8s4H2funcIUaAEjUP5DWuSsyBsp7B0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WF9a1bFsytqV3zvrBQ1jn5IVGQQKF0qM6OuEFy9ix55EgFuor5zat6gIHVGRjkE8q
         xLlXUK1tCLGsjBWHDaM8LO4FR0I1szfxzOl0lGqMceVQkuYQYIgQ/3mdsavZ4w320x
         HPxvNi9+xyztRzkQcut9WH6RJi2wtY+Pj2aSeY1Y=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 04/10] IB/mlx5: Add ODP WQE handlers for kernel QPs
Date:   Wed, 15 Jan 2020 14:43:34 +0200
Message-Id: <20200115124340.79108-5-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
References: <20200115124340.79108-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

One of the steps in ODP page fault handler for WQEs is to read a WQE
from a QP send queue or receive queue buffer at a specific index.

Since the implementation of this buffer is different between kernel and
user QP the implementation of the handler needs to be aware of that and
handle it in a different way.

ODP for kernel MRs is currently supported only for RDMA_READ
and RDMA_WRITE operations so change the handler to
- read a WQE from a kernel QP send queue
- fail if access to receive queue or shared receive queue is
  required for a kernel QP

Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  12 +-
 drivers/infiniband/hw/mlx5/odp.c     |  12 +-
 drivers/infiniband/hw/mlx5/qp.c      | 163 +++++++++++++++++----------
 3 files changed, 117 insertions(+), 70 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index aa14d3c8abd9..7b019bd4de4b 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -1170,12 +1170,12 @@ int mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr);
 int mlx5_ib_post_recv(struct ib_qp *ibqp, const struct ib_recv_wr *wr,
 		      const struct ib_recv_wr **bad_wr);
-int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
-			     int buflen, size_t *bc);
-int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
-			     int buflen, size_t *bc);
-int mlx5_ib_read_user_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index,
-			      void *buffer, int buflen, size_t *bc);
+int mlx5_ib_read_wqe_sq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
+			size_t buflen, size_t *bc);
+int mlx5_ib_read_wqe_rq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
+			size_t buflen, size_t *bc);
+int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
+			 size_t buflen, size_t *bc);
 int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		      struct ib_udata *udata);
 void mlx5_ib_destroy_cq(struct ib_cq *cq, struct ib_udata *udata);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 14265175a2d8..879ed9ac0af9 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1275,15 +1275,15 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	wqe = wqe_start;
 	qp = (res->res == MLX5_RES_QP) ? res_to_qp(res) : NULL;
 	if (qp && sq) {
-		ret = mlx5_ib_read_user_wqe_sq(qp, wqe_index, wqe, PAGE_SIZE,
-					       &bytes_copied);
+		ret = mlx5_ib_read_wqe_sq(qp, wqe_index, wqe, PAGE_SIZE,
+					  &bytes_copied);
 		if (ret)
 			goto read_user;
 		ret = mlx5_ib_mr_initiator_pfault_handler(
 			dev, pfault, qp, &wqe, &wqe_end, bytes_copied);
 	} else if (qp && !sq) {
-		ret = mlx5_ib_read_user_wqe_rq(qp, wqe_index, wqe, PAGE_SIZE,
-					       &bytes_copied);
+		ret = mlx5_ib_read_wqe_rq(qp, wqe_index, wqe, PAGE_SIZE,
+					  &bytes_copied);
 		if (ret)
 			goto read_user;
 		ret = mlx5_ib_mr_responder_pfault_handler_rq(
@@ -1291,8 +1291,8 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 	} else if (!qp) {
 		struct mlx5_ib_srq *srq = res_to_srq(res);

-		ret = mlx5_ib_read_user_wqe_srq(srq, wqe_index, wqe, PAGE_SIZE,
-						&bytes_copied);
+		ret = mlx5_ib_read_wqe_srq(srq, wqe_index, wqe, PAGE_SIZE,
+					   &bytes_copied);
 		if (ret)
 			goto read_user;
 		ret = mlx5_ib_mr_responder_pfault_handler_srq(
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index a102bae6d74b..a4f8e7030787 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -129,14 +129,10 @@ static int is_sqp(enum ib_qp_type qp_type)
  *
  * Return: zero on success, or an error code.
  */
-static int mlx5_ib_read_user_wqe_common(struct ib_umem *umem,
-					void *buffer,
-					u32 buflen,
-					int wqe_index,
-					int wq_offset,
-					int wq_wqe_cnt,
-					int wq_wqe_shift,
-					int bcnt,
+static int mlx5_ib_read_user_wqe_common(struct ib_umem *umem, void *buffer,
+					size_t buflen, int wqe_index,
+					int wq_offset, int wq_wqe_cnt,
+					int wq_wqe_shift, int bcnt,
 					size_t *bytes_copied)
 {
 	size_t offset = wq_offset + ((wqe_index % wq_wqe_cnt) << wq_wqe_shift);
@@ -160,11 +156,43 @@ static int mlx5_ib_read_user_wqe_common(struct ib_umem *umem,
 	return 0;
 }

-int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp,
-			     int wqe_index,
-			     void *buffer,
-			     int buflen,
-			     size_t *bc)
+static int mlx5_ib_read_kernel_wqe_sq(struct mlx5_ib_qp *qp, int wqe_index,
+				      void *buffer, size_t buflen, size_t *bc)
+{
+	struct mlx5_wqe_ctrl_seg *ctrl;
+	size_t bytes_copied = 0;
+	size_t wqe_length;
+	void *p;
+	int ds;
+
+	wqe_index = wqe_index & qp->sq.fbc.sz_m1;
+
+	/* read the control segment first */
+	p = mlx5_frag_buf_get_wqe(&qp->sq.fbc, wqe_index);
+	ctrl = p;
+	ds = be32_to_cpu(ctrl->qpn_ds) & MLX5_WQE_CTRL_DS_MASK;
+	wqe_length = ds * MLX5_WQE_DS_UNITS;
+
+	/* read rest of WQE if it spreads over more than one stride */
+	while (bytes_copied < wqe_length) {
+		size_t copy_length =
+			min_t(size_t, buflen - bytes_copied, MLX5_SEND_WQE_BB);
+
+		if (!copy_length)
+			break;
+
+		memcpy(buffer + bytes_copied, p, copy_length);
+		bytes_copied += copy_length;
+
+		wqe_index = (wqe_index + 1) & qp->sq.fbc.sz_m1;
+		p = mlx5_frag_buf_get_wqe(&qp->sq.fbc, wqe_index);
+	}
+	*bc = bytes_copied;
+	return 0;
+}
+
+static int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp, int wqe_index,
+				    void *buffer, size_t buflen, size_t *bc)
 {
 	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
 	struct ib_umem *umem = base->ubuffer.umem;
@@ -176,18 +204,10 @@ int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp,
 	int ret;
 	int ds;

-	if (buflen < sizeof(*ctrl))
-		return -EINVAL;
-
 	/* at first read as much as possible */
-	ret = mlx5_ib_read_user_wqe_common(umem,
-					   buffer,
-					   buflen,
-					   wqe_index,
-					   wq->offset,
-					   wq->wqe_cnt,
-					   wq->wqe_shift,
-					   buflen,
+	ret = mlx5_ib_read_user_wqe_common(umem, buffer, buflen, wqe_index,
+					   wq->offset, wq->wqe_cnt,
+					   wq->wqe_shift, buflen,
 					   &bytes_copied);
 	if (ret)
 		return ret;
@@ -210,13 +230,9 @@ int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp,
 	 * so read the remaining bytes starting
 	 * from  wqe_index 0
 	 */
-	ret = mlx5_ib_read_user_wqe_common(umem,
-					   buffer + bytes_copied,
-					   buflen - bytes_copied,
-					   0,
-					   wq->offset,
-					   wq->wqe_cnt,
-					   wq->wqe_shift,
+	ret = mlx5_ib_read_user_wqe_common(umem, buffer + bytes_copied,
+					   buflen - bytes_copied, 0, wq->offset,
+					   wq->wqe_cnt, wq->wqe_shift,
 					   wqe_length - bytes_copied,
 					   &bytes_copied2);

@@ -226,11 +242,24 @@ int mlx5_ib_read_user_wqe_sq(struct mlx5_ib_qp *qp,
 	return 0;
 }

-int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp,
-			     int wqe_index,
-			     void *buffer,
-			     int buflen,
-			     size_t *bc)
+int mlx5_ib_read_wqe_sq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
+			size_t buflen, size_t *bc)
+{
+	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
+	struct ib_umem *umem = base->ubuffer.umem;
+
+	if (buflen < sizeof(struct mlx5_wqe_ctrl_seg))
+		return -EINVAL;
+
+	if (!umem)
+		return mlx5_ib_read_kernel_wqe_sq(qp, wqe_index, buffer,
+						  buflen, bc);
+
+	return mlx5_ib_read_user_wqe_sq(qp, wqe_index, buffer, buflen, bc);
+}
+
+static int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp, int wqe_index,
+				    void *buffer, size_t buflen, size_t *bc)
 {
 	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
 	struct ib_umem *umem = base->ubuffer.umem;
@@ -238,14 +267,9 @@ int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp,
 	size_t bytes_copied;
 	int ret;

-	ret = mlx5_ib_read_user_wqe_common(umem,
-					   buffer,
-					   buflen,
-					   wqe_index,
-					   wq->offset,
-					   wq->wqe_cnt,
-					   wq->wqe_shift,
-					   buflen,
+	ret = mlx5_ib_read_user_wqe_common(umem, buffer, buflen, wqe_index,
+					   wq->offset, wq->wqe_cnt,
+					   wq->wqe_shift, buflen,
 					   &bytes_copied);

 	if (ret)
@@ -254,25 +278,33 @@ int mlx5_ib_read_user_wqe_rq(struct mlx5_ib_qp *qp,
 	return 0;
 }

-int mlx5_ib_read_user_wqe_srq(struct mlx5_ib_srq *srq,
-			      int wqe_index,
-			      void *buffer,
-			      int buflen,
-			      size_t *bc)
+int mlx5_ib_read_wqe_rq(struct mlx5_ib_qp *qp, int wqe_index, void *buffer,
+			size_t buflen, size_t *bc)
+{
+	struct mlx5_ib_qp_base *base = &qp->trans_qp.base;
+	struct ib_umem *umem = base->ubuffer.umem;
+	struct mlx5_ib_wq *wq = &qp->rq;
+	size_t wqe_size = 1 << wq->wqe_shift;
+
+	if (buflen < wqe_size)
+		return -EINVAL;
+
+	if (!umem)
+		return -EOPNOTSUPP;
+
+	return mlx5_ib_read_user_wqe_rq(qp, wqe_index, buffer, buflen, bc);
+}
+
+static int mlx5_ib_read_user_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index,
+				     void *buffer, size_t buflen, size_t *bc)
 {
 	struct ib_umem *umem = srq->umem;
 	size_t bytes_copied;
 	int ret;

-	ret = mlx5_ib_read_user_wqe_common(umem,
-					   buffer,
-					   buflen,
-					   wqe_index,
-					   0,
-					   srq->msrq.max,
-					   srq->msrq.wqe_shift,
-					   buflen,
-					   &bytes_copied);
+	ret = mlx5_ib_read_user_wqe_common(umem, buffer, buflen, wqe_index, 0,
+					   srq->msrq.max, srq->msrq.wqe_shift,
+					   buflen, &bytes_copied);

 	if (ret)
 		return ret;
@@ -280,6 +312,21 @@ int mlx5_ib_read_user_wqe_srq(struct mlx5_ib_srq *srq,
 	return 0;
 }

+int mlx5_ib_read_wqe_srq(struct mlx5_ib_srq *srq, int wqe_index, void *buffer,
+			 size_t buflen, size_t *bc)
+{
+	struct ib_umem *umem = srq->umem;
+	size_t wqe_size = 1 << srq->msrq.wqe_shift;
+
+	if (buflen < wqe_size)
+		return -EINVAL;
+
+	if (!umem)
+		return -EOPNOTSUPP;
+
+	return mlx5_ib_read_user_wqe_srq(srq, wqe_index, buffer, buflen, bc);
+}
+
 static void mlx5_ib_qp_event(struct mlx5_core_qp *qp, int type)
 {
 	struct ib_qp *ibqp = &to_mibqp(qp)->ibqp;
--
2.20.1

