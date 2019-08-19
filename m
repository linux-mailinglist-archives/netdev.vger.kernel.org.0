Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5F5192315
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 14:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfHSMIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 08:08:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726987AbfHSMIc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 08:08:32 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD3520851;
        Mon, 19 Aug 2019 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566216511;
        bh=aosPnERQ1Ip+qp+Z1xF6d76QS7ZxGePLisfLCpO0mnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZkyt6o+BWe7ALhzCvRqx0vsC6UAWi34VQVscFl2CZFRjGmehDpxasUcZr/q1m6qm
         JO9aGJ+S086OX+J0cjvhbtmXgwo4cUzETvXxQaGBOilG5nxPTDQ5oNAJg9/RhTDb/R
         FipqWGMa68coX7X2jFlstW1X3d+Ypo+Qdf0eFy0I=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH rdma-next v3 2/3] IB/mlx5: Remove check of FW capabilities in ODP page fault handling
Date:   Mon, 19 Aug 2019 15:08:14 +0300
Message-Id: <20190819120815.21225-3-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190819120815.21225-1-leon@kernel.org>
References: <20190819120815.21225-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

As page fault handling is initiated by FW, there is no need to check that
the ODP supports the operation and transport.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 48 +-------------------------------
 1 file changed, 1 insertion(+), 47 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 8b155a1f0b38..e7a4ea979209 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -986,17 +986,6 @@ static int pagefault_data_segments(struct mlx5_ib_dev *dev,
 	return ret < 0 ? ret : npages;
 }
 
-static const u32 mlx5_ib_odp_opcode_cap[] = {
-	[MLX5_OPCODE_SEND]	       = IB_ODP_SUPPORT_SEND,
-	[MLX5_OPCODE_SEND_IMM]	       = IB_ODP_SUPPORT_SEND,
-	[MLX5_OPCODE_SEND_INVAL]       = IB_ODP_SUPPORT_SEND,
-	[MLX5_OPCODE_RDMA_WRITE]       = IB_ODP_SUPPORT_WRITE,
-	[MLX5_OPCODE_RDMA_WRITE_IMM]   = IB_ODP_SUPPORT_WRITE,
-	[MLX5_OPCODE_RDMA_READ]	       = IB_ODP_SUPPORT_READ,
-	[MLX5_OPCODE_ATOMIC_CS]	       = IB_ODP_SUPPORT_ATOMIC,
-	[MLX5_OPCODE_ATOMIC_FA]	       = IB_ODP_SUPPORT_ATOMIC,
-};
-
 /*
  * Parse initiator WQE. Advances the wqe pointer to point at the
  * scatter-gather list, and set wqe_end to the end of the WQE.
@@ -1007,7 +996,6 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 {
 	struct mlx5_wqe_ctrl_seg *ctrl = *wqe;
 	u16 wqe_index = pfault->wqe.wqe_index;
-	u32 transport_caps;
 	struct mlx5_base_av *av;
 	unsigned ds, opcode;
 	u32 qpn = qp->trans_qp.base.mqp.qpn;
@@ -1031,29 +1019,8 @@ static int mlx5_ib_mr_initiator_pfault_handler(
 	opcode = be32_to_cpu(ctrl->opmod_idx_opcode) &
 		 MLX5_WQE_CTRL_OPCODE_MASK;
 
-	switch (qp->ibqp.qp_type) {
-	case IB_QPT_XRC_INI:
+	if (qp->ibqp.qp_type == IB_QPT_XRC_INI)
 		*wqe += sizeof(struct mlx5_wqe_xrc_seg);
-		transport_caps = dev->odp_caps.per_transport_caps.xrc_odp_caps;
-		break;
-	case IB_QPT_RC:
-		transport_caps = dev->odp_caps.per_transport_caps.rc_odp_caps;
-		break;
-	case IB_QPT_UD:
-		transport_caps = dev->odp_caps.per_transport_caps.ud_odp_caps;
-		break;
-	default:
-		mlx5_ib_err(dev, "ODP fault on QP of an unsupported transport 0x%x\n",
-			    qp->ibqp.qp_type);
-		return -EFAULT;
-	}
-
-	if (unlikely(opcode >= ARRAY_SIZE(mlx5_ib_odp_opcode_cap) ||
-		     !(transport_caps & mlx5_ib_odp_opcode_cap[opcode]))) {
-		mlx5_ib_err(dev, "ODP fault on QP of an unsupported opcode 0x%x\n",
-			    opcode);
-		return -EFAULT;
-	}
 
 	if (qp->ibqp.qp_type == IB_QPT_UD) {
 		av = *wqe;
@@ -1118,19 +1085,6 @@ static int mlx5_ib_mr_responder_pfault_handler_rq(struct mlx5_ib_dev *dev,
 		return -EFAULT;
 	}
 
-	switch (qp->ibqp.qp_type) {
-	case IB_QPT_RC:
-		if (!(dev->odp_caps.per_transport_caps.rc_odp_caps &
-		      IB_ODP_SUPPORT_RECV))
-			goto invalid_transport_or_opcode;
-		break;
-	default:
-invalid_transport_or_opcode:
-		mlx5_ib_err(dev, "ODP fault on QP of an unsupported transport. transport: 0x%x\n",
-			    qp->ibqp.qp_type);
-		return -EFAULT;
-	}
-
 	*wqe_end = wqe + wqe_size;
 
 	return 0;
-- 
2.20.1

