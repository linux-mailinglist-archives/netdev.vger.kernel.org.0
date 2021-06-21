Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443BF3AE3BE
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFUHIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:08:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFUHIo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 03:08:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16C9761279;
        Mon, 21 Jun 2021 07:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624259190;
        bh=lCqUVUVemoEr/r9qwpg+LYNlq5e96lZer/58WomkW+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ANh9uGbhtcOmnoudkyIIF08nigsuljcdsvVFzOW1630WHoEaXm7HcQetnVisEFTA5
         nd6XL7IJeUZ1AP/pBAotehCe5NmnFR0+3V+Ce68RktJAite/zP3Terxt3vR8EIUmD0
         WjR0Ge4p/yUm6Iqn4C6D7/QtvmjeQkIN3969i88QjOGtRlVNmm076vJOP6w93nv8ai
         bWiPpuuJ3t0fiQMhl3nCyuei3aYw8+XHoaWCwhiNBZ5jU86IkNAnlHlaPRzuzwRpX6
         quqWSVo+juG1J8P4OqpQGEAtBceVUQHdwvC1xDaINka5vdyeVKBq9GpYgqJcrZ3EtB
         O/5mWeHvxOYtQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Lior Nahmanson <liorna@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Meir Lichtinger <meirl@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next v1 2/3] RDMA/mlx5: Separate DCI QP creation logic
Date:   Mon, 21 Jun 2021 10:06:15 +0300
Message-Id: <b4530bdd999349c59691224f016ff1efb5dc3b92.1624258894.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1624258894.git.leonro@nvidia.com>
References: <cover.1624258894.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lior Nahmanson <liorna@nvidia.com>

This patch isolates DCI QP creation logic to separate function, so this
change will reduce complexity when adding new features to DCI QP without
interfering with other QP types.

The code was copied from create_user_qp() while taking only DCI relevant bits.

Reviewed-by: Meir Lichtinger <meirl@nvidia.com>
Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 157 ++++++++++++++++++++++++++++++++
 1 file changed, 157 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 7a5f1eba60e3..65a380543f5a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1974,6 +1974,160 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	return 0;
 }
 
+static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
+		      struct mlx5_ib_qp *qp,
+		      struct mlx5_create_qp_params *params)
+{
+	struct ib_qp_init_attr *init_attr = params->attr;
+	struct mlx5_ib_create_qp *ucmd = params->ucmd;
+	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
+	struct ib_udata *udata = params->udata;
+	u32 uidx = params->uidx;
+	struct mlx5_ib_resources *devr = &dev->devr;
+	int inlen = MLX5_ST_SZ_BYTES(create_qp_in);
+	struct mlx5_core_dev *mdev = dev->mdev;
+	struct mlx5_ib_cq *send_cq;
+	struct mlx5_ib_cq *recv_cq;
+	unsigned long flags;
+	struct mlx5_ib_qp_base *base;
+	int ts_format;
+	int mlx5_st;
+	void *qpc;
+	u32 *in;
+	int err;
+
+	spin_lock_init(&qp->sq.lock);
+	spin_lock_init(&qp->rq.lock);
+
+	mlx5_st = to_mlx5_st(qp->type);
+	if (mlx5_st < 0)
+		return -EINVAL;
+
+	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
+		qp->sq_signal_bits = MLX5_WQE_CTRL_CQ_UPDATE;
+
+	base = &qp->trans_qp.base;
+
+	qp->has_rq = qp_has_rq(init_attr);
+	err = set_rq_size(dev, &init_attr->cap, qp->has_rq, qp, ucmd);
+	if (err) {
+		mlx5_ib_dbg(dev, "err %d\n", err);
+		return err;
+	}
+
+	if (ucmd->rq_wqe_shift != qp->rq.wqe_shift ||
+	    ucmd->rq_wqe_count != qp->rq.wqe_cnt)
+		return -EINVAL;
+
+	if (ucmd->sq_wqe_count > (1 << MLX5_CAP_GEN(mdev, log_max_qp_sz)))
+		return -EINVAL;
+
+	ts_format = get_qp_ts_format(dev, to_mcq(init_attr->send_cq),
+				     to_mcq(init_attr->recv_cq));
+
+	if (ts_format < 0)
+		return ts_format;
+
+	err = _create_user_qp(dev, pd, qp, udata, init_attr, &in, &params->resp,
+			      &inlen, base, ucmd);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_GEN(mdev, ece_support))
+		MLX5_SET(create_qp_in, in, ece, ucmd->ece_options);
+	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
+
+	MLX5_SET(qpc, qpc, st, mlx5_st);
+	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
+	MLX5_SET(qpc, qpc, pd, to_mpd(pd)->pdn);
+
+	if (qp->flags_en & MLX5_QP_FLAG_SIGNATURE)
+		MLX5_SET(qpc, qpc, wq_signature, 1);
+
+	if (qp->flags & IB_QP_CREATE_CROSS_CHANNEL)
+		MLX5_SET(qpc, qpc, cd_master, 1);
+	if (qp->flags & IB_QP_CREATE_MANAGED_SEND)
+		MLX5_SET(qpc, qpc, cd_slave_send, 1);
+	if (qp->flags_en & MLX5_QP_FLAG_SCATTER_CQE)
+		configure_requester_scat_cqe(dev, qp, init_attr, qpc);
+
+	if (qp->rq.wqe_cnt) {
+		MLX5_SET(qpc, qpc, log_rq_stride, qp->rq.wqe_shift - 4);
+		MLX5_SET(qpc, qpc, log_rq_size, ilog2(qp->rq.wqe_cnt));
+	}
+
+	MLX5_SET(qpc, qpc, ts_format, ts_format);
+	MLX5_SET(qpc, qpc, rq_type, get_rx_type(qp, init_attr));
+
+	MLX5_SET(qpc, qpc, log_sq_size, ilog2(qp->sq.wqe_cnt));
+
+	/* Set default resources */
+	if (init_attr->srq) {
+		MLX5_SET(qpc, qpc, xrcd, devr->xrcdn0);
+		MLX5_SET(qpc, qpc, srqn_rmpn_xrqn,
+			 to_msrq(init_attr->srq)->msrq.srqn);
+	} else {
+		MLX5_SET(qpc, qpc, xrcd, devr->xrcdn1);
+		MLX5_SET(qpc, qpc, srqn_rmpn_xrqn,
+			 to_msrq(devr->s1)->msrq.srqn);
+	}
+
+	if (init_attr->send_cq)
+		MLX5_SET(qpc, qpc, cqn_snd,
+			 to_mcq(init_attr->send_cq)->mcq.cqn);
+
+	if (init_attr->recv_cq)
+		MLX5_SET(qpc, qpc, cqn_rcv,
+			 to_mcq(init_attr->recv_cq)->mcq.cqn);
+
+	MLX5_SET64(qpc, qpc, dbr_addr, qp->db.dma);
+
+	/* 0xffffff means we ask to work with cqe version 0 */
+	if (MLX5_CAP_GEN(mdev, cqe_version) == MLX5_CQE_VERSION_V1)
+		MLX5_SET(qpc, qpc, user_index, uidx);
+
+	if (qp->flags & IB_QP_CREATE_PCI_WRITE_END_PADDING) {
+		MLX5_SET(qpc, qpc, end_padding_mode,
+			 MLX5_WQ_END_PAD_MODE_ALIGN);
+		/* Special case to clean flag */
+		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
+	}
+
+	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
+
+	kvfree(in);
+	if (err)
+		goto err_create;
+
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
+	if (MLX5_CAP_GEN(mdev, ece_support))
+		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
+
+	get_cqs(qp->type, init_attr->send_cq, init_attr->recv_cq,
+		&send_cq, &recv_cq);
+	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
+	mlx5_ib_lock_cqs(send_cq, recv_cq);
+	/* Maintain device to QPs access, needed for further handling via reset
+	 * flow
+	 */
+	list_add_tail(&qp->qps_list, &dev->qp_list);
+	/* Maintain CQ to QPs access, needed for further handling via reset flow
+	 */
+	if (send_cq)
+		list_add_tail(&qp->cq_send_list, &send_cq->list_send_qp);
+	if (recv_cq)
+		list_add_tail(&qp->cq_recv_list, &recv_cq->list_recv_qp);
+	mlx5_ib_unlock_cqs(send_cq, recv_cq);
+	spin_unlock_irqrestore(&dev->reset_flow_resource_lock, flags);
+
+	return 0;
+
+err_create:
+	destroy_qp(dev, qp, base, udata);
+	return err;
+}
+
 static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 			  struct mlx5_ib_qp *qp,
 			  struct mlx5_create_qp_params *params)
@@ -2840,6 +2994,9 @@ static int create_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	case MLX5_IB_QPT_DCT:
 		err = create_dct(dev, pd, qp, params);
 		break;
+	case MLX5_IB_QPT_DCI:
+		err = create_dci(dev, pd, qp, params);
+		break;
 	case IB_QPT_XRC_TGT:
 		err = create_xrc_tgt_qp(dev, qp, params);
 		break;
-- 
2.31.1

