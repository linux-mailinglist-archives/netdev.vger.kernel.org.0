Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42C1D319869
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 04:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhBLC6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:49894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229497AbhBLC6C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:58:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56BAC64E65;
        Fri, 12 Feb 2021 02:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613098641;
        bh=2ZaF/jU7GhCl8qw24zhc46mllkpojVy6Td5tR+UciZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mhld27hHnai8gZQihv0fBhRUwB01kFknKizpchtcZGxI+uiu7FJq8+wasgbK+7E/x
         wjklOjtBlyjwTCD31ihkh+E4abeCIsqVw1dr5GzgCwIoulVzSldkRTZQKRdRKCzdfm
         RFj68A7cdpBXLLXT6JKaHpY/7d+MFvipsfkCLxTF8V3+0LccNxzvEesaKCbtDUXa4w
         Kp0psKAZERfwr2eNOO7WdI9pGH/Lxb0SXL0e/i5nXD80w7D7IM/mhzGzuprIc7XaH5
         7/HSGaT7C9QO8LbZGVB1x74aXNzFodK0dDwhisDIHBDIppsfwHUsdBLfxIQMgzkjF4
         I5Ab3cMJnfUbQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 02/15] net/mlx5e: Enable striding RQ for Connect-X IPsec capable devices
Date:   Thu, 11 Feb 2021 18:56:28 -0800
Message-Id: <20210212025641.323844-3-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210212025641.323844-1-saeed@kernel.org>
References: <20210212025641.323844-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

This limitation was inherited by previous Innova (FPGA) IPsec
implementation, it uses its private set of RQ handlers which does
not support striding rq, for Connect-X this is no longer true.

Fix by keeping this limitation only for Innova IPsec supporting devices,
as otherwise this limitation effectively wrongly blocks striding RQs for
all future Connect-X devices for all flows even if IPsec offload is not
used.

Fixes: 2d64663cd559 ("net/mlx5: IPsec: Add HW crypto offload support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h | 2 ++
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3fc7d18ac868..0ae22a018dc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -65,6 +65,7 @@
 #include "en/devlink.h"
 #include "lib/mlx5.h"
 #include "en/ptp.h"
+#include "fpga/ipsec.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -106,7 +107,7 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
 		return false;
 
-	if (MLX5_IPSEC_DEV(mdev))
+	if (mlx5_fpga_is_ipsec_device(mdev))
 		return false;
 
 	if (params->xdp_prog) {
@@ -2069,7 +2070,7 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	int i;
 
 #ifdef CONFIG_MLX5_EN_IPSEC
-	if (MLX5_IPSEC_DEV(mdev))
+	if (mlx5_fpga_is_ipsec_device(mdev))
 		byte_count += MLX5E_METADATA_ETHER_LEN;
 #endif
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ca4b55839a8a..4864deed9dc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1795,8 +1795,8 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 
 		rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
 #ifdef CONFIG_MLX5_EN_IPSEC
-		if (MLX5_IPSEC_DEV(mdev)) {
-			netdev_err(netdev, "MPWQE RQ with IPSec offload not supported\n");
+		if (mlx5_fpga_is_ipsec_device(mdev)) {
+			netdev_err(netdev, "MPWQE RQ with Innova IPSec offload not supported\n");
 			return -EINVAL;
 		}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index cc67366495b0..22bee4990232 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -124,7 +124,7 @@ struct mlx5_fpga_ipsec {
 	struct ida halloc;
 };
 
-static bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev)
+bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev)
 {
 	if (!mdev->fpga || !MLX5_CAP_GEN(mdev, fpga))
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index db88eb4c49e3..8931b5584477 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -43,6 +43,7 @@ u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev);
 const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type);
 void mlx5_fpga_ipsec_build_fs_cmds(void);
+bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev);
 #else
 static inline
 const struct mlx5_accel_ipsec_ops *mlx5_fpga_ipsec_ops(struct mlx5_core_dev *mdev)
@@ -55,6 +56,7 @@ mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type)
 }
 
 static inline void mlx5_fpga_ipsec_build_fs_cmds(void) {};
+static inline bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev) { return false; }
 
 #endif /* CONFIG_MLX5_FPGA_IPSEC */
 #endif	/* __MLX5_FPGA_IPSEC_H__ */
-- 
2.29.2

