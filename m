Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D19A1A6804
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 16:23:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbgDMOXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 10:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730621AbgDMOX2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 10:23:28 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A94C82075E;
        Mon, 13 Apr 2020 14:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586787807;
        bh=3fo2BpN9qk0hU71oy1G6y0uM5uGgy1CWUCbqt81cEzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T55jCe1jVLY0xNA0gcXpktKcwbfVDaWFzdZmbz7IhTHk9UfNZiOcZnC5hm+TlJ2JA
         rqYPry2tqrHcCqDockbG9OlTzquAVAAcIBKssZoze/BFsNjnYFCa6Bkl6T4gdD+Bgr
         2h1uEaxlmeozZAPPnaC/lj+4804aGn8vPeMaUrzU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 04/13] net/mlx5: Open-code modify QP in steering module
Date:   Mon, 13 Apr 2020 17:22:59 +0300
Message-Id: <20200413142308.936946-5-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413142308.936946-1-leon@kernel.org>
References: <20200413142308.936946-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Remove dependency on qp.c from SW steering by open
coding modify QP interface.

Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_send.c     | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 690e4181db4c..266b913d2f9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -585,8 +585,10 @@ static int dr_modify_qp_rst2init(struct mlx5_core_dev *mdev,
 	MLX5_SET(qpc, qpc, rre, 1);
 	MLX5_SET(qpc, qpc, rwe, 1);
 
-	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RST2INIT_QP, 0, qpc,
-				   &dr_qp->mqp);
+	MLX5_SET(rst2init_qp_in, in, opcode, MLX5_CMD_OP_RST2INIT_QP);
+	MLX5_SET(rst2init_qp_in, in, qpn, dr_qp->mqp.qpn);
+
+	return mlx5_cmd_exec_in(mdev, rst2init_qp, in);
 }
 
 static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
@@ -600,12 +602,13 @@ static int dr_cmd_modify_qp_rtr2rts(struct mlx5_core_dev *mdev,
 
 	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->mqp.qpn);
 
-	MLX5_SET(qpc, qpc, log_ack_req_freq, 0);
 	MLX5_SET(qpc, qpc, retry_count, attr->retry_cnt);
 	MLX5_SET(qpc, qpc, rnr_retry, attr->rnr_retry);
 
-	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_RTR2RTS_QP, 0, qpc,
-				   &dr_qp->mqp);
+	MLX5_SET(rtr2rts_qp_in, in, opcode, MLX5_CMD_OP_RTR2RTS_QP);
+	MLX5_SET(rtr2rts_qp_in, in, qpn, dr_qp->mqp.qpn);
+
+	return mlx5_cmd_exec_in(mdev, rtr2rts_qp, in);
 }
 
 static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
@@ -636,8 +639,10 @@ static int dr_cmd_modify_qp_init2rtr(struct mlx5_core_dev *mdev,
 	MLX5_SET(qpc, qpc, primary_address_path.vhca_port_num, attr->port_num);
 	MLX5_SET(qpc, qpc, min_rnr_nak, 1);
 
-	return mlx5_core_qp_modify(mdev, MLX5_CMD_OP_INIT2RTR_QP, 0, qpc,
-				   &dr_qp->mqp);
+	MLX5_SET(init2rtr_qp_in, in, opcode, MLX5_CMD_OP_INIT2RTR_QP);
+	MLX5_SET(init2rtr_qp_in, in, qpn, dr_qp->mqp.qpn);
+
+	return mlx5_cmd_exec_in(mdev, init2rtr_qp, in);
 }
 
 static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
-- 
2.25.2

