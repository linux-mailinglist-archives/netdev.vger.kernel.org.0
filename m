Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8CC93A948B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbhFPH74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhFPH7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:59:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BFCF611BE;
        Wed, 16 Jun 2021 07:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623830269;
        bh=4TkXloCYrvM3Lo8a7KonMNtyrO8BPwjAw6KGTZTSrMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=evN7PFujsievEDXrlr4tHIQ0nM9DutCey78+fnH4uwINbziPsM7hJpt2Le0cRL93D
         xNni5ce3/+XKQvOhG57jLNhRskGsBca09N/iQGTjD4qIr3C5OsXPevMX9gmQTCd9eM
         P32y8dwtd1qNCwWtPH4Q2M0g89zpP9A0Bmcs8AJumJSnB2b/n5cNPobdXTQbsdFhYt
         f+LCYWHCaqJMBYBV06IRRbeWR4MsIR+3/oaqb3rFeSaRWaqfpYIr+x0FbIYwaQzdD6
         xrqGCq9DsW3b8q7A2lVUR7W+Sd6wxcgVb2e3serEun5kLeJPNj4jMWcwYDLezIaJah
         GFxiGZ99N9bMw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 2/2] RDMA/mlx5: Support real-time timestamp directly from the device
Date:   Wed, 16 Jun 2021 10:57:39 +0300
Message-Id: <c6cfc8e6f038575c5c2de6505830f7e74e4de80d.1623829775.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623829775.git.leonro@nvidia.com>
References: <cover.1623829775.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Currently, if the user asks for a real-time timestamp, the device will
return a free-running one, and the timestamp will be translated to
real-time in the user-space.

When the device supports only real-time timestamp and not free-running,
the creation of the QP will fail even though the user needs supported the
real-time one. To prevent this, we will return the real-time timestamp
directly from the device.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/cq.c      |  6 +++++-
 drivers/infiniband/hw/mlx5/main.c    |  6 ++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  7 +++++++
 drivers/infiniband/hw/mlx5/qp.c      | 30 +++++++++++++++++++++++-----
 include/uapi/rdma/mlx5-abi.h         |  2 ++
 5 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index cce3cdd191e6..7575f7b2aa77 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -725,7 +725,8 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		return -EFAULT;
 
 	if ((ucmd.flags & ~(MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD |
-			    MLX5_IB_CREATE_CQ_FLAGS_UAR_PAGE_INDEX)))
+			    MLX5_IB_CREATE_CQ_FLAGS_UAR_PAGE_INDEX |
+			    MLX5_IB_CREATE_CQ_FLAGS_REAL_TIME_TS)))
 		return -EINVAL;
 
 	if ((ucmd.cqe_size != 64 && ucmd.cqe_size != 128) ||
@@ -826,6 +827,9 @@ static int create_cq_user(struct mlx5_ib_dev *dev, struct ib_udata *udata,
 		cq->private_flags |= MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD;
 	}
 
+	if (ucmd.flags & MLX5_IB_CREATE_CQ_FLAGS_REAL_TIME_TS)
+		cq->private_flags |= MLX5_IB_CQ_PR_FLAGS_REAL_TIME_TS;
+
 	MLX5_SET(create_cq_in, *cqb, uid, context->devx_uid);
 	return 0;
 
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c46581686258..087633b01bc5 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1826,6 +1826,12 @@ static int set_ucontext_resp(struct ib_ucontext *uctx,
 	if (MLX5_CAP_GEN(dev->mdev, ece_support))
 		resp->comp_mask |= MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_ECE;
 
+	if (rt_supported(MLX5_CAP_GEN(dev->mdev, sq_ts_format)) &&
+	    rt_supported(MLX5_CAP_GEN(dev->mdev, rq_ts_format)) &&
+	    rt_supported(MLX5_CAP_ROCE(dev->mdev, qp_ts_format)))
+		resp->comp_mask |=
+			MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_REAL_TIME_TS;
+
 	resp->num_dyn_bfregs = bfregi->num_dyn_bfregs;
 
 	if (MLX5_CAP_GEN(dev->mdev, drain_sigerr))
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 6043a42e8dda..ab078720cb27 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -549,6 +549,7 @@ static inline const struct mlx5_umr_wr *umr_wr(const struct ib_send_wr *wr)
 
 enum mlx5_ib_cq_pr_flags {
 	MLX5_IB_CQ_PR_FLAGS_CQE_128_PAD	= 1 << 0,
+	MLX5_IB_CQ_PR_FLAGS_REAL_TIME_TS = 1 << 1,
 };
 
 struct mlx5_ib_cq {
@@ -1636,4 +1637,10 @@ static inline bool mlx5_ib_lag_should_assign_affinity(struct mlx5_ib_dev *dev)
 		(MLX5_CAP_GEN(dev->mdev, num_lag_ports) > 1 &&
 		 MLX5_CAP_GEN(dev->mdev, lag_tx_port_affinity));
 }
+
+static inline bool rt_supported(int ts_cap)
+{
+	return ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_REAL_TIME ||
+	       ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
+}
 #endif /* MLX5_IB_H */
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index dfe9eab7bd72..3d797be84bfa 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1182,8 +1182,16 @@ static bool fr_supported(int ts_cap)
 }
 
 static int get_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
-			 bool fr_sup)
+			 bool fr_sup, bool rt_sup)
 {
+	if (cq->private_flags & MLX5_IB_CQ_PR_FLAGS_REAL_TIME_TS) {
+		if (!rt_sup) {
+			mlx5_ib_dbg(dev,
+				    "Real time TS format is not supported\n");
+			return -EOPNOTSUPP;
+		}
+		return MLX5_TIMESTAMP_FORMAT_REAL_TIME;
+	}
 	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION) {
 		if (!fr_sup) {
 			mlx5_ib_dbg(dev,
@@ -1200,14 +1208,16 @@ static int get_rq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *recv_cq)
 {
 	u8 ts_cap = MLX5_CAP_GEN(dev->mdev, rq_ts_format);
 
-	return get_ts_format(dev, recv_cq, fr_supported(ts_cap));
+	return get_ts_format(dev, recv_cq, fr_supported(ts_cap),
+			     rt_supported(ts_cap));
 }
 
 static int get_sq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
 {
 	u8 ts_cap = MLX5_CAP_GEN(dev->mdev, sq_ts_format);
 
-	return get_ts_format(dev, send_cq, fr_supported(ts_cap));
+	return get_ts_format(dev, send_cq, fr_supported(ts_cap),
+			     rt_supported(ts_cap));
 }
 
 static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
@@ -1215,18 +1225,28 @@ static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
 {
 	u8 ts_cap = MLX5_CAP_ROCE(dev->mdev, qp_ts_format);
 	bool fr_sup = fr_supported(ts_cap);
+	bool rt_sup = rt_supported(ts_cap);
 	u8 default_ts = fr_sup ? MLX5_TIMESTAMP_FORMAT_FREE_RUNNING :
 				 MLX5_TIMESTAMP_FORMAT_DEFAULT;
 	int send_ts_format =
-		send_cq ? get_ts_format(dev, send_cq, fr_sup) :
+		send_cq ? get_ts_format(dev, send_cq, fr_sup, rt_sup) :
 			  default_ts;
 	int recv_ts_format =
-		recv_cq ? get_ts_format(dev, recv_cq, fr_sup) :
+		recv_cq ? get_ts_format(dev, recv_cq, fr_sup, rt_sup) :
 			  default_ts;
 
 	if (send_ts_format < 0 || recv_ts_format < 0)
 		return -EOPNOTSUPP;
 
+	if (send_ts_format != MLX5_TIMESTAMP_FORMAT_DEFAULT &&
+	    recv_ts_format != MLX5_TIMESTAMP_FORMAT_DEFAULT &&
+	    send_ts_format != recv_ts_format) {
+		mlx5_ib_dbg(
+			dev,
+			"The send ts_format does not match the receive ts_format\n");
+		return -EOPNOTSUPP;
+	}
+
 	return send_ts_format == default_ts ? recv_ts_format : send_ts_format;
 }
 
diff --git a/include/uapi/rdma/mlx5-abi.h b/include/uapi/rdma/mlx5-abi.h
index 6f54ab3d99e5..86be4a92b67b 100644
--- a/include/uapi/rdma/mlx5-abi.h
+++ b/include/uapi/rdma/mlx5-abi.h
@@ -103,6 +103,7 @@ enum mlx5_ib_alloc_ucontext_resp_mask {
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_DUMP_FILL_MKEY    = 1UL << 1,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_ECE               = 1UL << 2,
 	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_SQD2RTS           = 1UL << 3,
+	MLX5_IB_ALLOC_UCONTEXT_RESP_MASK_REAL_TIME_TS	   = 1UL << 4,
 };
 
 enum mlx5_user_cmds_supp_uhw {
@@ -278,6 +279,7 @@ struct mlx5_ib_query_device_resp {
 enum mlx5_ib_create_cq_flags {
 	MLX5_IB_CREATE_CQ_FLAGS_CQE_128B_PAD	= 1 << 0,
 	MLX5_IB_CREATE_CQ_FLAGS_UAR_PAGE_INDEX  = 1 << 1,
+	MLX5_IB_CREATE_CQ_FLAGS_REAL_TIME_TS	= 1 << 2,
 };
 
 struct mlx5_ib_create_cq {
-- 
2.31.1

