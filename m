Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B44BE24843E
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgHRLxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:53:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:55176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726552AbgHRLxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 07:53:07 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3248206B5;
        Tue, 18 Aug 2020 11:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597751586;
        bh=amyjZxo9LAmzASSVfTG7gzBBjkYIYlz6yD1x2EBEznU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xsulJjg737ZZOpKS4O+znzI5VZInAEqT7iKd0ooMooSLk19dC1o8y8pC2VsDdQTKW
         YA85o61mJ9vQOrYSD0NcVTV1XGeZX/malowuqh377VaOV7outKVu/aaf5Do3IFZJx9
         2Nn5GpaYCT6cFsBTZ9hdGVXnjpyT+tLN1zXXyeWs=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 2/2] IB/mlx5: Add DCT RoCE LAG support
Date:   Tue, 18 Aug 2020 14:52:45 +0300
Message-Id: <20200818115245.700581-3-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818115245.700581-1-leon@kernel.org>
References: <20200818115245.700581-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When DCT QPs work in RoCE LAG mode:
1. DCT creation is allowed only when it is supported.
2. The "port" of a DCT QP is assigned in a round-robin way.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c | 9 ++++++++-
 include/linux/mlx5/mlx5_ifc.h   | 3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0526d574cd9b..4eff325c4d2c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2409,6 +2409,9 @@ static int create_dct(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	u32 uidx = params->uidx;
 	void *dctc;

+	if (mlx5_lag_is_active(dev->mdev) && !MLX5_CAP_GEN(dev->mdev, lag_dct))
+		return -EOPNOTSUPP;
+
 	qp->dct.in = kzalloc(MLX5_ST_SZ_BYTES(create_dct_in), GFP_KERNEL);
 	if (!qp->dct.in)
 		return -ENOMEM;
@@ -4183,7 +4186,11 @@ static int mlx5_ib_modify_dct(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			MLX5_SET(dctc, dctc, rae, 1);
 		}
 		MLX5_SET(dctc, dctc, pkey_index, attr->pkey_index);
-		MLX5_SET(dctc, dctc, port, attr->port_num);
+		if (mlx5_lag_is_active(dev->mdev))
+			MLX5_SET(dctc, dctc, port,
+				 get_tx_affinity_rr(dev, udata));
+		else
+			MLX5_SET(dctc, dctc, port, attr->port_num);

 		set_id = mlx5_ib_get_counters_id(dev, attr->port_num - 1);
 		MLX5_SET(dctc, dctc, counter_set_id, set_id);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index de1ffb4804d6..aee25e4fb2cc 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1430,7 +1430,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {

 	u8         log_bf_reg_size[0x5];

-	u8         reserved_at_270[0x8];
+	u8         reserved_at_270[0x6];
+	u8         lag_dct[0x2];
 	u8         lag_tx_port_affinity[0x1];
 	u8         reserved_at_279[0x2];
 	u8         lag_master[0x1];
--
2.26.2

