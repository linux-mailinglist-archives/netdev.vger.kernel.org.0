Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC58204FE8
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 13:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732454AbgFWLBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 07:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732245AbgFWLBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 07:01:14 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56C0020738;
        Tue, 23 Jun 2020 11:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592910074;
        bh=YdxgoHVtdRoAhScrjYZNg31Btg0H9bfILML8a7AB+3U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIQirhh7uPFPak+WV5eB8pB2r3N2TVGNcoFSS/oo8tTZrKxmcuEi2qbeyZgNEgxJo
         7dpQFN2ZDqiJvnGauYhwNPSeLOyUFULWaGWj0Lm0oAMK7XX2Th51x2P2W/dKgbEYg2
         7jvfAVuTxm75owkiQ19pTmg66ue48i/+KG0zofsY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Michael Guralnik <michaelgur@mellanox.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Enable QP number request when creating IPoIB underlay QP
Date:   Tue, 23 Jun 2020 14:01:04 +0300
Message-Id: <20200623110105.1225750-2-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623110105.1225750-1-leon@kernel.org>
References: <20200623110105.1225750-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

If in the process of creating the underlay QP for an IPoIB interface
the user has set the address and specifically the 1st-3rd bytes
representing the QP number, use the requested QP number when creating
the underlay QP.

For a user to be able to request a QP number on QP creation, the MKEY_BY_NAME
NVCONFIG should be set. As mkey_by_name and qp_by_name are coupled in FW.
This requires driver to query the mkey_by_name max cap during initialization
and set the current cap if it was enabled in FW.

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c | 7 +++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c        | 3 +++
 include/linux/mlx5/mlx5_ifc.h                         | 9 +++++++--
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 690b822c6152..d1266d8fed97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -226,13 +226,20 @@ void mlx5i_uninit_underlay_qp(struct mlx5e_priv *priv)
 
 int mlx5i_create_underlay_qp(struct mlx5e_priv *priv)
 {
+	unsigned char *dev_addr = priv->netdev->dev_addr;
 	u32 out[MLX5_ST_SZ_DW(create_qp_out)] = {};
 	u32 in[MLX5_ST_SZ_DW(create_qp_in)] = {};
 	struct mlx5i_priv *ipriv = priv->ppriv;
 	void *addr_path;
+	int qpn = 0;
 	int ret = 0;
 	void *qpc;
 
+	if (MLX5_CAP_GEN(priv->mdev, mkey_by_name)) {
+		qpn = (dev_addr[1] << 16) + (dev_addr[2] << 8) + dev_addr[3];
+		MLX5_SET(create_qp_in, in, input_qpn, qpn);
+	}
+
 	qpc = MLX5_ADDR_OF(create_qp_in, in, qpc);
 	MLX5_SET(qpc, qpc, st, MLX5_QP_ST_UD);
 	MLX5_SET(qpc, qpc, pm_state, MLX5_QP_PM_MIGRATED);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 8b658908f044..623785fe74b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -557,6 +557,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN_MAX(dev, release_all_pages))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, release_all_pages, 1);
 
+	if (MLX5_CAP_GEN_MAX(dev, mkey_by_name))
+		MLX5_SET(cmd_hca_cap, set_hca_cap, mkey_by_name, 1);
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ca1887dd0423..7a00110f2f01 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1392,7 +1392,10 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         bf[0x1];
 	u8         driver_version[0x1];
 	u8         pad_tx_eth_packet[0x1];
-	u8         reserved_at_263[0x8];
+	u8         reserved_at_263[0x3];
+	u8         mkey_by_name[0x1];
+	u8         reserved_at_267[0x4];
+
 	u8         log_bf_reg_size[0x5];
 
 	u8         reserved_at_270[0x8];
@@ -7714,8 +7717,10 @@ struct mlx5_ifc_create_qp_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x40];
+	u8         reserved_at_40[0x8];
+	u8         input_qpn[0x18];
 
+	u8         reserved_at_60[0x20];
 	u8         opt_param_mask[0x20];
 
 	u8         ece[0x20];
-- 
2.26.2

