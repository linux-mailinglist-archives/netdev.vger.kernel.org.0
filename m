Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AF1334780
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 20:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhCJTEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 14:04:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:44386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233753AbhCJTEA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 14:04:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FCAC64FB1;
        Wed, 10 Mar 2021 19:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615403040;
        bh=M5RNtTaJJhMbzcU7o/iTE1TLc3kHX9TPqT/nKsSYf5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qugC67IyUuma4ZgwPLdYcl/sn73BIbG0Zt6OwirFXv1bLR7ejK5fgMyrROaeLFKo8
         kvzHM2dS6nRlj57ldLIm1xSA4upV46QQFit6z4eW8o+5blj1ShtoSpIiHpE/yQZCdd
         2G6HN/+xVXK/KzZRmXZv1EsDGczH5BwEZQu8v/UL8HVpr9ab/DZUX8CwWf6lSxIGZl
         hoRO7GQ/e/suZFdKhzL4ACGSi+55mMLqnF6YL+6eXo5te+XshtXu9793Blwh6eREfn
         5zswof2zHEYDBDxkpmNFLpKHigN1ZccKgllDW0yNGR8OHLeyOZtMHH0Q47Q+3fn9DL
         hbyvHt0uRqqdg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 13/18] RDMA/mlx5: Fix timestamp default mode
Date:   Wed, 10 Mar 2021 11:03:37 -0800
Message-Id: <20210310190342.238957-14-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310190342.238957-1-saeed@kernel.org>
References: <20210310190342.238957-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

1. Don't set the ts_format bit to default when it reserved - device is
   running in the old mode (free running).
2. XRC doesn't have a CQ therefore the ts format in the QP
   context should be default / free running.
3. Set ts_format to WQ.

Fixes: 2fe8d4b87802 ("RDMA/mlx5: Fail QP creation if the device can not support the CQE TS")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ec4b3f6a8222..f5a52a6fae43 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1078,7 +1078,7 @@ static int _create_kernel_qp(struct mlx5_ib_dev *dev,
 
 	qpc = MLX5_ADDR_OF(create_qp_in, *in, qpc);
 	MLX5_SET(qpc, qpc, uar_page, uar_index);
-	MLX5_SET(qpc, qpc, ts_format, MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT);
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(dev->mdev));
 	MLX5_SET(qpc, qpc, log_page_size, qp->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT);
 
 	/* Set "fast registration enabled" for all kernel QPs */
@@ -1188,7 +1188,8 @@ static int get_rq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
 		}
 		return MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING;
 	}
-	return MLX5_RQC_TIMESTAMP_FORMAT_DEFAULT;
+	return fr_supported ? MLX5_RQC_TIMESTAMP_FORMAT_FREE_RUNNING :
+			      MLX5_RQC_TIMESTAMP_FORMAT_DEFAULT;
 }
 
 static int get_sq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
@@ -1206,7 +1207,8 @@ static int get_sq_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq)
 		}
 		return MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING;
 	}
-	return MLX5_SQC_TIMESTAMP_FORMAT_DEFAULT;
+	return fr_supported ? MLX5_SQC_TIMESTAMP_FORMAT_FREE_RUNNING :
+			      MLX5_SQC_TIMESTAMP_FORMAT_DEFAULT;
 }
 
 static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
@@ -1217,7 +1219,8 @@ static int get_qp_ts_format(struct mlx5_ib_dev *dev, struct mlx5_ib_cq *send_cq,
 			MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING ||
 		MLX5_CAP_ROCE(dev->mdev, qp_ts_format) ==
 			MLX5_QP_TIMESTAMP_FORMAT_CAP_FREE_RUNNING_AND_REAL_TIME;
-	int ts_format = MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT;
+	int ts_format = fr_supported ? MLX5_QPC_TIMESTAMP_FORMAT_FREE_RUNNING :
+				       MLX5_QPC_TIMESTAMP_FORMAT_DEFAULT;
 
 	if (recv_cq &&
 	    recv_cq->create_flags & IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION)
@@ -1930,6 +1933,7 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (qp->flags & IB_QP_CREATE_MANAGED_RECV)
 		MLX5_SET(qpc, qpc, cd_slave_receive, 1);
 
+	MLX5_SET(qpc, qpc, ts_format, mlx5_get_qp_default_ts(dev->mdev));
 	MLX5_SET(qpc, qpc, rq_type, MLX5_SRQ_RQ);
 	MLX5_SET(qpc, qpc, no_sq, 1);
 	MLX5_SET(qpc, qpc, cqn_rcv, to_mcq(devr->c0)->mcq.cqn);
@@ -4873,6 +4877,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	struct mlx5_ib_dev *dev;
 	int has_net_offloads;
 	__be64 *rq_pas0;
+	int ts_format;
 	void *in;
 	void *rqc;
 	void *wq;
@@ -4881,6 +4886,10 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 
 	dev = to_mdev(pd->device);
 
+	ts_format = get_rq_ts_format(dev, to_mcq(init_attr->cq));
+	if (ts_format < 0)
+		return ts_format;
+
 	inlen = MLX5_ST_SZ_BYTES(create_rq_in) + sizeof(u64) * rwq->rq_num_pas;
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if (!in)
@@ -4890,6 +4899,7 @@ static int  create_rq(struct mlx5_ib_rwq *rwq, struct ib_pd *pd,
 	rqc = MLX5_ADDR_OF(create_rq_in, in, ctx);
 	MLX5_SET(rqc,  rqc, mem_rq_type,
 		 MLX5_RQC_MEM_RQ_TYPE_MEMORY_RQ_INLINE);
+	MLX5_SET(rqc, rqc, ts_format, ts_format);
 	MLX5_SET(rqc, rqc, user_index, rwq->user_index);
 	MLX5_SET(rqc,  rqc, cqn, to_mcq(init_attr->cq)->mcq.cqn);
 	MLX5_SET(rqc,  rqc, state, MLX5_RQC_STATE_RST);
-- 
2.29.2

