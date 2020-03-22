Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586D618E7D5
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 10:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgCVJak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 05:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbgCVJak (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 05:30:40 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14E0B20753;
        Sun, 22 Mar 2020 09:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584869439;
        bh=bynSzeli358DlgvplDKntDZ9PIBtHAWWNq51tsirlOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p6C5S3dOLgrJEMWKUPasKI/1YLUIlBSAZB+QTd/wGIH6gVUtF4AWUSHkEf6uWXZDM
         Y7aW3uYAczXWQ4EP8F4XbJWo/zcl8pmlYOYx98yXDKohDwFl/NVdX0Z4k6Oudu+nXx
         Ivgtb2VxzGK63rDgu3oWla8xE5fyH1/BAPIH7J+M=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Mark Zhang <markz@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next v1 2/7] net/mlx5: Enable SW-defined RoCEv2 UDP source port
Date:   Sun, 22 Mar 2020 11:30:26 +0200
Message-Id: <20200322093031.918447-3-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200322093031.918447-1-leon@kernel.org>
References: <20200322093031.918447-1-leon@kernel.org>
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
index 150a4a67e572..df9aa5cac2bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -558,6 +558,31 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
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
@@ -588,6 +613,13 @@ static int set_hca_cap(struct mlx5_core_dev *dev)
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
index 208bf1127be7..bb217c3f30da 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -74,6 +74,7 @@ enum {
 	MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE        = 0x0,
 	MLX5_SET_HCA_CAP_OP_MOD_ODP                   = 0x2,
 	MLX5_SET_HCA_CAP_OP_MOD_ATOMIC                = 0x3,
+	MLX5_SET_HCA_CAP_OP_MOD_ROCE                  = 0x4,
 };

 enum {
@@ -902,7 +903,9 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {

 struct mlx5_ifc_roce_cap_bits {
 	u8         roce_apm[0x1];
-	u8         reserved_at_1[0x1f];
+	u8         reserved_at_1[0x3];
+	u8         sw_r_roce_src_udp_port[0x1];
+	u8         reserved_at_5[0x1b];

 	u8         reserved_at_20[0x60];

--
2.24.1

