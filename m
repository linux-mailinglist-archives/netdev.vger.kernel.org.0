Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DC11FAE6D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 12:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgFPKqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 06:46:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:60002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728309AbgFPKqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 06:46:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8E0F20767;
        Tue, 16 Jun 2020 10:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592304399;
        bh=KGLx1hyAASqYzFFy4Lt5IQfUrXK5M1lu2QGGJRSHenQ=;
        h=From:To:Cc:Subject:Date:From;
        b=MGQ4IWpNUWrikQD2g6KTxwNOxTxi8b2uxidVec9ofjLPLnYij6IAusOCbG0gP1jYc
         +Xd3hjTryDj0j/I+il5m7RBHnVPGoMKCzrKbJBkXcYj6CH8TUZjH1K48IfK3xjDQ45
         tHPKp5/YEdpuMDNcwiJXsr1cMXE17MoPy58hQiIU=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org,
        Mark Zhang <markz@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH rdma-rc] RDMA/mlx5: Fix missed RST2INIT and INIT2INIT steps during ECE handshake
Date:   Tue, 16 Jun 2020 13:45:36 +0300
Message-Id: <20200616104536.2426384-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Missed step during ECE handshake left userspace application with less
options for the ECE handshake with a need to do workarounds.

Fixes: 50aec2c3135e ("RDMA/mlx5: Return ECE data after modify QP")
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qpc.c |  8 ++++++++
 include/linux/mlx5/mlx5_ifc.h    | 10 ++++++----
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index c19d91d6dce8..7c3968ef9cd1 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -346,6 +346,9 @@ static int get_ece_from_mbox(void *out, u16 opcode)
 	int ece = 0;

 	switch (opcode) {
+	case MLX5_CMD_OP_INIT2INIT_QP:
+		ece = MLX5_GET(init2init_qp_out, out, ece);
+		break;
 	case MLX5_CMD_OP_INIT2RTR_QP:
 		ece = MLX5_GET(init2rtr_qp_out, out, ece);
 		break;
@@ -355,6 +358,9 @@ static int get_ece_from_mbox(void *out, u16 opcode)
 	case MLX5_CMD_OP_RTS2RTS_QP:
 		ece = MLX5_GET(rts2rts_qp_out, out, ece);
 		break;
+	case MLX5_CMD_OP_RST2INIT_QP:
+		ece = MLX5_GET(rst2init_qp_out, out, ece);
+		break;
 	default:
 		break;
 	}
@@ -406,6 +412,7 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(rst2init_qp, mbox->in, opcode, qpn,
 				  opt_param_mask, qpc, uid);
+		MLX5_SET(rst2init_qp_in, mbox->in, ece, ece);
 		break;
 	case MLX5_CMD_OP_INIT2RTR_QP:
 		if (MBOX_ALLOC(mbox, init2rtr_qp))
@@ -439,6 +446,7 @@ static int modify_qp_mbox_alloc(struct mlx5_core_dev *dev, u16 opcode, int qpn,
 			return -ENOMEM;
 		MOD_QP_IN_SET_QPC(init2init_qp, mbox->in, opcode, qpn,
 				  opt_param_mask, qpc, uid);
+		MLX5_SET(init2init_qp_in, mbox->in, ece, ece);
 		break;
 	default:
 		return -EINVAL;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 66aeaf113995..7a00110f2f01 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4286,7 +4286,8 @@ struct mlx5_ifc_rst2init_qp_out_bits {

 	u8         syndrome[0x20];

-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };

 struct mlx5_ifc_rst2init_qp_in_bits {
@@ -4303,7 +4304,7 @@ struct mlx5_ifc_rst2init_qp_in_bits {

 	u8         opt_param_mask[0x20];

-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];

 	struct mlx5_ifc_qpc_bits qpc;

@@ -6622,7 +6623,8 @@ struct mlx5_ifc_init2init_qp_out_bits {

 	u8         syndrome[0x20];

-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x20];
+	u8         ece[0x20];
 };

 struct mlx5_ifc_init2init_qp_in_bits {
@@ -6639,7 +6641,7 @@ struct mlx5_ifc_init2init_qp_in_bits {

 	u8         opt_param_mask[0x20];

-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];

 	struct mlx5_ifc_qpc_bits qpc;

--
2.26.2

