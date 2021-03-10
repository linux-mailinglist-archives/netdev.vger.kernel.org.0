Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E700233477C
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbhCJTEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:44378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233749AbhCJTEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80E5F64FCD;
        Wed, 10 Mar 2021 19:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403039;
        bh=wgCvTOdTj9QlfxodPHyGMS1TatC8CA3u/k0OY5IvK0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cm2HzbH7tkJlm8wg5jmvymHEY6cNwDbjoCnZdCrPtKDjLEj7yja+0/Uf5OsyawC+7
         g4/pBZmIqMCMVIkCoP0suYjm7PPmuc6relwZ8B9C6z2A343Y7tUEPwP54hDvjlWc+O
         n4qA7eGqOd2YB8q9LvExFNlOeK9zt3+DY7wk0ztaiRk209wpFPlvUY47ermnfpeCea
         kd9rV9IA4AknRbFiBdhXk6retzm8pWYD5qJmuY8d1QqS14+k29Ks1TQfrK2LpiwLmb
         VXDwmAozVEdNglEaxwr2bsqulaR/ssG/DO3eF25Vyp4i2dfnzbZOMt/dgRkzMY2b4a
         VVOXKujfF+Fxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/18] net/mlx5: Set QP timestamp mode to default
Date:   Wed, 10 Mar 2021 11:03:36 -0800
Message-Id: <20210310190342.238957-13-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

QPs which don't care from timestamp mode, should set the ts_format
to default, otherwise the QP creation could be failed if the timestamp
mode is not supported.

Fixes: 2fe8d4b87802 ("RDMA/mlx5: Fail QP creation if the device can not support the CQE TS")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c        | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c      | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 1 +
 include/linux/mlx5/qp.h                                    | 7 +++++++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 80da50e12915..bd66ab2af5b5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -575,6 +575,7 @@ static int mlx5_fpga_conn_create_qp(struct mlx5_fpga_conn *conn,
 	MLX5_SET(qpc, qpc, log_sq_size, ilog2(conn->qp.sq.size));
 	MLX5_SET(qpc, qpc, cqn_snd, conn->cq.mcq.cqn);
 	MLX5_SET(qpc, qpc, cqn_rcv, conn->cq.mcq.cqn);
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(mdev));
 	MLX5_SET64(qpc, qpc, dbr_addr, conn->qp.wq_ctrl.db.dma);
 	if (MLX5_CAP_GEN(mdev, cqe_version) == 1)
 		MLX5_SET(qpc, qpc, user_index, 0xFFFFFF);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 756fa0401ab7..6f7cef47e04c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -233,6 +233,7 @@ int mlx5i_create_underlay_qp(struct mlx5e_priv *priv)
 	}
 
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(priv->mdev));
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_UD);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
 	MLX5_SET(qpc, qpc, ulp_stateless_offload_mode,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 83c4c877d558..8a6a56f9dc4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -169,6 +169,7 @@ static struct mlx5dr_qp *dr_create_rc_qp(struct mlx5_core_dev *mdev,
 	MLX5_SET(qpc, qpc, log_rq_size, ilog2(dr_qp->rq.wqe_cnt));
 	MLX5_SET(qpc, qpc, rq_type, MLX5_NON_ZERO_RQ);
 	MLX5_SET(qpc, qpc, log_sq_size, ilog2(dr_qp->sq.wqe_cnt));
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(mdev));
 	MLX5_SET64(qpc, qpc, dbr_addr, dr_qp->wq_ctrl.db.dma);
 	if (MLX5_CAP_GEN(mdev, cqe_version) == 1)
 		MLX5_SET(qpc, qpc, user_index, 0xFFFFFF);
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d75ef8aa8fac..b7deb790f257 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -547,4 +547,11 @@ static inline const char *mlx5_qp_state_str(int state)
 	}
 }
 
+static inline int mlx5_get_qp_default_ts(struct mlx5_core_dev *dev)
+{
+	return !MLX5_CAP_ROCE(dev, qp_ts_format) ?
+		       MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING :
+		       MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT;
+}
+
 #endif /* MLX5_QP_H */
-- 
2.29.2

