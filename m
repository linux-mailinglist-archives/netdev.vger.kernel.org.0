Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48081A672F
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 15:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgDMNhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 09:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730069AbgDMNhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 09:37:17 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 775B32073E;
        Mon, 13 Apr 2020 13:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586785037;
        bh=qFaDlggGFM54TuO5amVPGo1vhVNYrb6Zop3L+Y6SQ24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PM0+Uvi+Xwh4xPoHeWFTG0KMyKtjHabLO4i6hpGVNV1kq8DoDqSQEgDUbWVf+T9tw
         TpPg/qn3NfjZwbHKFz0fQtXe8LxBiCg04EaBBnkTKCAgkUKicETg42uolvRu1bM237
         LfJaucledjHaIEyiImv93EQUS21naslbTacpgG+g=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v2 2/6] net/mlx5: Enable SW-defined RoCEv2 UDP source port
Date:   Mon, 13 Apr 2020 16:36:59 +0300
Message-Id: <20200413133703.932731-3-leon@kernel.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200413133703.932731-1-leon@kernel.org>
References: <20200413133703.932731-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

When this is enabled, UDP source port for RoCEv2 packets are defined
by software instead of firmware.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Maor Gottlieb <maorg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 32 +++++++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                 |  5 ++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b9182add689..bbe1a2110204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -559,6 +559,31 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	return err;
 }
 
+static int handle_hca_cap_roce(struct mlx5_core_dev *dev, void *set_ctx)
+{
+	void *set_hca_cap;
+	int err;
+
+	if (!MLX5_CAP_GEN(dev, roce))
+		return 0;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_ROCE);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_ROCE(dev, sw_r_roce_src_udp_port) ||
+	    !MLX5_CAP_ROCE_MAX(dev, sw_r_roce_src_udp_port))
+		return 0;
+
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, dev->caps.hca_cur[MLX5_CAP_ROCE],
+	       MLX5_ST_SZ_BYTES(roce_cap));
+	MLX5_SET(roce_cap, set_hca_cap, sw_r_roce_src_udp_port, 1);
+
+	err = set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ROCE);
+	return err;
+}
+
 static int set_hca_cap(struct mlx5_core_dev *dev)
 {
 	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
@@ -589,6 +614,13 @@ static int set_hca_cap(struct mlx5_core_dev *dev)
 		goto out;
 	}
 
+	memset(set_ctx, 0, set_sz);
+	err = handle_hca_cap_roce(dev, set_ctx);
+	if (err) {
+		mlx5_core_err(dev, "handle_hca_cap_roce failed\n");
+		goto out;
+	}
+
 out:
 	kfree(set_ctx);
 	return err;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a3b6c92e889e..95dd9cc1d979 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -74,6 +74,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE        = 0x0,
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
+	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
 };
 
 enum {
@@ -903,7 +904,9 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 
 struct mlx5_ifc_roce_cap_bits {
 	u8         roce_apm[0x1];
-	u8         reserved_at_1[0x1f];
+	u8         reserved_at_1[0x3];
+	u8         sw_r_roce_src_udp_port[0x1];
+	u8         reserved_at_5[0x1b];
 
 	u8         reserved_at_20[0x60];
 
-- 
2.25.2

