Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6463A948E
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232085AbhFPIAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 04:00:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231645AbhFPH76 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:59:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2E6061351;
        Wed, 16 Jun 2021 07:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623830272;
        bh=z9UPn78OW8cuY6rmS5cR8HwwxFoMLYG/xBbP3z5kMvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2asYzDN8F88RqxFaRu2cvgTG89FZZwHTV52QD7jB0tuu14flrn4wcQNRKgt4EvcL
         TWE+isBrK7bpuiJMaZOvYFH5SRaMiAHfOLhncPkJ1b8ubkjyTjnkM8vuKbinXjQoI+
         fIuLCQDuT4mWza28RPGMiTFvNrW4Dz53/C8HSshV84UiFiyDPWA39E6TKgfuM9xLGs
         YIBqtHS3+31Z9JPebGBmYpoohrJZU4lJ7xbb8QJJqqaa80MAhvEh1hwm3fiwFrtBDF
         UOx/jF21l4NCCa0stDHWQpC74X2P8V/94yxoJwfYnZv3rngn9IJLzsbGwn1yuqX5/i
         D0lC/VeSjXxtw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/2] RDMA/mlx5: Refactor get_ts_format functions to simplify code
Date:   Wed, 16 Jun 2021 10:57:38 +0300
Message-Id: <7a94fa93c2517fbfc6ca3a018086fb64aaea9358.1623829775.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623829775.git.leonro@nvidia.com>
References: <cover.1623829775.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

QPC, SQC and RQC timestamp formats and capabilities are always equal
because they represent general hardware support. So instead of code
duplication, let's merge them into general enum and logic.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c               | 84 ++++++++-----------
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  8 +-
 .../ethernet/mellanox/mlx5/core/lib/clock.h   | 10 ++-
 include/linux/mlx5/mlx5_ifc.h                 | 36 ++------
 include/linux/mlx5/qp.h                       |  4 +-
 5 files changed, 55 insertions(+), 87 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7b545eac37a3..dfe9eab7bd72 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1175,69 +1175,59 @@ static void destroy_flow_rule_vport_sq(struct mlx5_ib_sq *sq)
 	sq->flow_rule = NULL;
 }
 
-static int get_rq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
+static bool fr_supported(int ts_cap)
 {
-	bool fr_supported =
-		MLX5_CAP_GEN(dev->mdev, rq_ts_format) ==
-			MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING ||
-		MLX5_CAP_GEN(dev->mdev, rq_ts_format) ==
-			MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
+	return ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING ||
+	       ts_cap == MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
+}
 
-	if (send_cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION) {
-		if (!fr_supported) {
-			mlx5_ib_dbg(dev, "Free running TS format is not supported\n");
+static int get_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *cq,
+			 bool fr_sup)
+{
+	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION) {
+		if (!fr_sup) {
+			mlx5_ib_dbg(dev,
+				    "Free running TS format is not supported\n");
 			return -EOPNOTSUPP;
 		}
-		return MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING;
+		return MLX5_TIMESTAMP_FORMAT_FREE_RUNNING;
 	}
-	return fr_supported ? MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING :
-			      MLX5_RQC_TIMESTAMP_FORMAT_DEFAULT;
+	return fr_sup ? MLX5_TIMESTAMP_FORMAT_FREE_RUNNING :
+			MLX5_TIMESTAMP_FORMAT_DEFAULT;
+}
+
+static int get_rq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *recv_cq)
+{
+	u8 ts_cap = MLX5_CAP_GEN(dev->mdev, rq_ts_format);
+
+	return get_ts_format(dev, recv_cq, fr_supported(ts_cap));
 }
 
 static int get_sq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
 {
-	bool fr_supported =
-		MLX5_CAP_GEN(dev->mdev, sq_ts_format) ==
-			MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING ||
-		MLX5_CAP_GEN(dev->mdev, sq_ts_format) ==
-			MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
+	u8 ts_cap = MLX5_CAP_GEN(dev->mdev, sq_ts_format);
 
-	if (send_cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION) {
-		if (!fr_supported) {
-			mlx5_ib_dbg(dev, "Free running TS format is not supported\n");
-			return -EOPNOTSUPP;
-		}
-		return MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING;
-	}
-	return fr_supported ? MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING :
-			      MLX5_SQC_TIMESTAMP_FORMAT_DEFAULT;
+	return get_ts_format(dev, send_cq, fr_supported(ts_cap));
 }
 
 static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
 			    struct mlx5_ib_cq *recv_cq)
 {
-	bool fr_supported =
-		MLX5_CAP_ROCE(dev->mdev, qp_ts_format) ==
-			MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING ||
-		MLX5_CAP_ROCE(dev->mdev, qp_ts_format) ==
-			MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
-	int ts_format = fr_supported ? MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING :
-				       MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT;
-
-	if (recv_cq &&
-	    recv_cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION)
-		ts_format = MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING;
-
-	if (send_cq &&
-	    send_cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION)
-		ts_format = MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING;
-
-	if (ts_format == MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING &&
-	    !fr_supported) {
-		mlx5_ib_dbg(dev, "Free running TS format is not supported\n");
+	u8 ts_cap = MLX5_CAP_ROCE(dev->mdev, qp_ts_format);
+	bool fr_sup = fr_supported(ts_cap);
+	u8 default_ts = fr_sup ? MLX5_TIMESTAMP_FORMAT_FREE_RUNNING :
+				 MLX5_TIMESTAMP_FORMAT_DEFAULT;
+	int send_ts_format =
+		send_cq ? get_ts_format(dev, send_cq, fr_sup) :
+			  default_ts;
+	int recv_ts_format =
+		recv_cq ? get_ts_format(dev, recv_cq, fr_sup) :
+			  default_ts;
+
+	if (send_ts_format < 0 || recv_ts_format < 0)
 		return -EOPNOTSUPP;
-	}
-	return ts_format;
+
+	return send_ts_format == default_ts ? recv_ts_format : send_ts_format;
 }
 
 static int create_raw_packet_qp_sq(struct mlx5_ib_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 153b7a081c8f..9c3e29ab8bbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -643,8 +643,8 @@ int mlx5e_create_rq(struct mlx5e_rq *rq, struct mlx5e_rq_param *param)
 		return -ENOMEM;
 
 	ts_format = mlx5_is_real_time_rq(mdev) ?
-		    MLX5_RQC_TIMESTAMP_FORMAT_REAL_TIME :
-		    MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING;
+			    MLX5_TIMESTAMP_FORMAT_REAL_TIME :
+			    MLX5_TIMESTAMP_FORMAT_FREE_RUNNING;
 	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
 	wq  = MLX5_ADDR_OF(rqc, rqc, wq);
 
@@ -1184,8 +1184,8 @@ static int mlx5e_create_sq(struct mlx5_core_dev *mdev,
 		return -ENOMEM;
 
 	ts_format = mlx5_is_real_time_sq(mdev) ?
-		    MLX5_SQC_TIMESTAMP_FORMAT_REAL_TIME :
-		    MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING;
+			    MLX5_TIMESTAMP_FORMAT_REAL_TIME :
+			    MLX5_TIMESTAMP_FORMAT_FREE_RUNNING;
 	sqc = MLX5_ADDR_OF(create_sq_in, in, ctx);
 	wq = MLX5_ADDR_OF(sqc, sqc, wq);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
index ceae6bc378e0..bd95b9f8d143 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.h
@@ -37,16 +37,18 @@ static inline bool mlx5_is_real_time_rq(struct mlx5_core_dev *mdev)
 {
 	u8 rq_ts_format_cap = MLX5_CAP_GEN(mdev, rq_ts_format);
 
-	return (rq_ts_format_cap == MLX5_RQ_TIMESTAMP_FORMAT_CAP_REAL_TIME  ||
-		rq_ts_format_cap == MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME);
+	return (rq_ts_format_cap == MLX5_TIMESTAMP_FORMAT_CAP_REAL_TIME ||
+		rq_ts_format_cap ==
+			MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME);
 }
 
 static inline bool mlx5_is_real_time_sq(struct mlx5_core_dev *mdev)
 {
 	u8 sq_ts_format_cap = MLX5_CAP_GEN(mdev, sq_ts_format);
 
-	return (sq_ts_format_cap == MLX5_SQ_TIMESTAMP_FORMAT_CAP_REAL_TIME  ||
-		sq_ts_format_cap == MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME);
+	return (sq_ts_format_cap == MLX5_TIMESTAMP_FORMAT_CAP_REAL_TIME ||
+		sq_ts_format_cap ==
+			MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME);
 }
 
 typedef ktime_t (*cqe_ts_to_ns)(struct mlx5_clock *, u64);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 48b2529451eb..74907557f2a9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -953,9 +953,9 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 };
 
 enum {
-	MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
-	MLX5_QP_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
-	MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
+	MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
+	MLX5_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
+	MLX5_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
 };
 
 struct mlx5_ifc_roce_cap_bits {
@@ -1294,18 +1294,6 @@ enum {
 	MLX5_STEERING_FORMAT_CONNECTX_6DX = 1,
 };
 
-enum {
-	MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
-	MLX5_SQ_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
-	MLX5_SQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
-};
-
-enum {
-	MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING               = 0x0,
-	MLX5_RQ_TIMESTAMP_FORMAT_CAP_REAL_TIME                  = 0x1,
-	MLX5_RQ_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME = 0x2,
-};
-
 struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_0[0x1f];
 	u8         vhca_resource_manager[0x1];
@@ -2948,9 +2936,9 @@ enum {
 };
 
 enum {
-	MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
-	MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
-	MLX5_QPC_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
+	MLX5_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
+	MLX5_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
+	MLX5_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
 };
 
 struct mlx5_ifc_qpc_bits {
@@ -3402,12 +3390,6 @@ enum {
 	MLX5_SQC_STATE_ERR  = 0x3,
 };
 
-enum {
-	MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
-	MLX5_SQC_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
-	MLX5_SQC_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
-};
-
 struct mlx5_ifc_sqc_bits {
 	u8         rlky[0x1];
 	u8         cd_master[0x1];
@@ -3513,12 +3495,6 @@ enum {
 	MLX5_RQC_STATE_ERR  = 0x3,
 };
 
-enum {
-	MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING = 0x0,
-	MLX5_RQC_TIMESTAMP_FORMAT_DEFAULT      = 0x1,
-	MLX5_RQC_TIMESTAMP_FORMAT_REAL_TIME    = 0x2,
-};
-
 struct mlx5_ifc_rqc_bits {
 	u8         rlky[0x1];
 	u8	   delay_drop_en[0x1];
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index b7deb790f257..61e48d459b23 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -550,8 +550,8 @@ static inline const char *mlx5_qp_state_str(int state)
 static inline int mlx5_get_qp_default_ts(struct mlx5_core_dev *dev)
 {
 	return !MLX5_CAP_ROCE(dev, qp_ts_format) ?
-		       MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING :
-		       MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT;
+		       MLX5_TIMESTAMP_FORMAT_FREE_RUNNING :
+		       MLX5_TIMESTAMP_FORMAT_DEFAULT;
 }
 
 #endif /* MLX5_QP_H */
-- 
2.31.1

