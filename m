Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7705013AE15
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 16:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgANPzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 10:55:52 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:41676 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727044AbgANPzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 10:55:51 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.134.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 00EFtjD4015233;
        Tue, 14 Jan 2020 17:55:45 +0200
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 00EFtjtl019702;
        Tue, 14 Jan 2020 17:55:45 +0200
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 00EFtjK4019701;
        Tue, 14 Jan 2020 17:55:45 +0200
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 2/3] net/mlx5: Add functions to set/query MFRL register
Date:   Tue, 14 Jan 2020 17:55:27 +0200
Message-Id: <1579017328-19643-3-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
References: <1579017328-19643-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add functions to set the reset level required and to query the reset
levels supported by fw.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fw.c       | 44 ++++++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |  2 +
 2 files changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw.c b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
index 1723229..1c6dfe9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw.c
@@ -769,3 +769,47 @@ int mlx5_fw_version_query(struct mlx5_core_dev *dev,
 
 	return 0;
 }
+
+static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
+			     u8 reset_type_sel)
+{
+	u32 out[MLX5_ST_SZ_DW(mfrl_reg)];
+	u32 in[MLX5_ST_SZ_DW(mfrl_reg)] = {};
+
+	MLX5_SET(mfrl_reg, in, reset_level, reset_level);
+	MLX5_SET(mfrl_reg, in, rst_type_sel, reset_type_sel);
+
+	return mlx5_core_access_reg(dev, in, sizeof(in), out,
+				    sizeof(out), MLX5_REG_MFRL, 0, 1);
+}
+
+static int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level,
+			       u8 *reset_type_sel, u8 *reset_type)
+{
+	u32 out[MLX5_ST_SZ_DW(mfrl_reg)] = {};
+	u32 in[MLX5_ST_SZ_DW(mfrl_reg)] = {};
+	int err;
+
+	err = mlx5_core_access_reg(dev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_MFRL, 0, 0);
+	if (err)
+		return err;
+
+	*reset_level = MLX5_GET(mfrl_reg, out, reset_level);
+	*reset_type = MLX5_GET(mfrl_reg, out, reset_type);
+	*reset_type_sel = MLX5_GET(mfrl_reg, out, rst_type_sel);
+
+	return 0;
+}
+
+int mlx5_fw_query_reset_level(struct mlx5_core_dev *dev, u8 *reset_level)
+{
+	u8 reset_type_sel, reset_type;
+
+	return mlx5_reg_mfrl_query(dev, reset_level, &reset_type_sel, &reset_type);
+}
+
+int mlx5_fw_set_reset_level(struct mlx5_core_dev *dev, u8 reset_level)
+{
+	return mlx5_reg_mfrl_set(dev, reset_level, 0);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index da67b28..1b55a5a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -210,6 +210,8 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *fw,
 			struct netlink_ext_ack *extack);
 int mlx5_fw_version_query(struct mlx5_core_dev *dev,
 			  u32 *running_ver, u32 *stored_ver);
+int mlx5_fw_query_reset_level(struct mlx5_core_dev *dev, u8 *reset_level);
+int mlx5_fw_set_reset_level(struct mlx5_core_dev *dev, u8 reset_level);
 
 void mlx5e_init(void);
 void mlx5e_cleanup(void);
-- 
1.8.3.1

