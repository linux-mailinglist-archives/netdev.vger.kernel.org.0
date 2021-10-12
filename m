Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476CB42AE3E
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235153AbhJLUzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235130AbhJLUzd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:55:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCED360E09;
        Tue, 12 Oct 2021 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634072011;
        bh=QbKLQW1If2CHebgpkNM6+0mD2Jff83bsM50S6dxh/Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CBDPYJILYhxOG0bEkKZMrAst0Ew7Cml6edqkcFCgdt6Y6sQDm28/FYeeHe1apanHf
         QH42UsBGs+txRYaZjWso6jljJ87Ke51J4MSxvSqs/YZIIyCARS93pfhJo0rB/3UZWZ
         IRCE2ol7lUBy0qXNon5ee56CJBJPrGToGSkuhbTwalEL8PPETu45gHZn/OjNd2s58U
         IyypZNGXF97PfCLdgL4vBMrkxUSmw9WHt7JRBt43RvUkXKAGGrnszfDYQ7W5XddtFH
         jru6xm7Rc5P4ihC+LHSyKgjtGvcDL+hvFFOKJI0rLfY7eD2SBWUV5xbkvXWhdfJGwr
         +OkeHc8j1ZScw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/6] net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp
Date:   Tue, 12 Oct 2021 13:53:22 -0700
Message-Id: <20211012205323.20123-6-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012205323.20123-1-saeed@kernel.org>
References: <20211012205323.20123-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Due to current HW arch limitations, RX-FCS (scattering FCS frame field
to software) and RX-port-timestamp (improved timestamp accuracy on the
receive side) can't work together.
RX-port-timestamp is not controlled by the user and it is enabled by
default when supported by the HW/FW.
This patch sets RX-port-timestamp opposite to RX-FCS configuration.

Fixes: 102722fc6832 ("net/mlx5e: Add support for RXFCS feature flag")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 57 +++++++++++++++++--
 include/linux/mlx5/mlx5_ifc.h                 | 10 +++-
 2 files changed, 60 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 336aa07313da..09c8b71b186c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3325,20 +3325,67 @@ static int set_feature_rx_all(struct net_device *netdev, bool enable)
 	return mlx5_set_port_fcs(mdev, !enable);
 }
 
+static int mlx5e_set_rx_port_ts(struct mlx5_core_dev *mdev, bool enable)
+{
+	u32 in[MLX5_ST_SZ_DW(pcmr_reg)] = {};
+	bool supported, curr_state;
+	int err;
+
+	if (!MLX5_CAP_GEN(mdev, ports_check))
+		return 0;
+
+	err = mlx5_query_ports_check(mdev, in, sizeof(in));
+	if (err)
+		return err;
+
+	supported = MLX5_GET(pcmr_reg, in, rx_ts_over_crc_cap);
+	curr_state = MLX5_GET(pcmr_reg, in, rx_ts_over_crc);
+
+	if (!supported || enable == curr_state)
+		return 0;
+
+	MLX5_SET(pcmr_reg, in, local_port, 1);
+	MLX5_SET(pcmr_reg, in, rx_ts_over_crc, enable);
+
+	return mlx5_set_ports_check(mdev, in, sizeof(in));
+}
+
 static int set_feature_rx_fcs(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_channels *chs = &priv->channels;
+	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
 	mutex_lock(&priv->state_lock);
 
-	priv->channels.params.scatter_fcs_en = enable;
-	err = mlx5e_modify_channels_scatter_fcs(&priv->channels, enable);
-	if (err)
-		priv->channels.params.scatter_fcs_en = !enable;
+	if (enable) {
+		err = mlx5e_set_rx_port_ts(mdev, false);
+		if (err)
+			goto out;
 
-	mutex_unlock(&priv->state_lock);
+		chs->params.scatter_fcs_en = true;
+		err = mlx5e_modify_channels_scatter_fcs(chs, true);
+		if (err) {
+			chs->params.scatter_fcs_en = false;
+			mlx5e_set_rx_port_ts(mdev, true);
+		}
+	} else {
+		chs->params.scatter_fcs_en = false;
+		err = mlx5e_modify_channels_scatter_fcs(chs, false);
+		if (err) {
+			chs->params.scatter_fcs_en = true;
+			goto out;
+		}
+		err = mlx5e_set_rx_port_ts(mdev, true);
+		if (err) {
+			mlx5_core_warn(mdev, "Failed to set RX port timestamp %d\n", err);
+			err = 0;
+		}
+	}
 
+out:
+	mutex_unlock(&priv->state_lock);
 	return err;
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index f3638d09ba77..993204a6c1a1 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9475,16 +9475,22 @@ struct mlx5_ifc_pcmr_reg_bits {
 	u8         reserved_at_0[0x8];
 	u8         local_port[0x8];
 	u8         reserved_at_10[0x10];
+
 	u8         entropy_force_cap[0x1];
 	u8         entropy_calc_cap[0x1];
 	u8         entropy_gre_calc_cap[0x1];
-	u8         reserved_at_23[0x1b];
+	u8         reserved_at_23[0xf];
+	u8         rx_ts_over_crc_cap[0x1];
+	u8         reserved_at_33[0xb];
 	u8         fcs_cap[0x1];
 	u8         reserved_at_3f[0x1];
+
 	u8         entropy_force[0x1];
 	u8         entropy_calc[0x1];
 	u8         entropy_gre_calc[0x1];
-	u8         reserved_at_43[0x1b];
+	u8         reserved_at_43[0xf];
+	u8         rx_ts_over_crc[0x1];
+	u8         reserved_at_53[0xb];
 	u8         fcs_chk[0x1];
 	u8         reserved_at_5f[0x1];
 };
-- 
2.31.1

