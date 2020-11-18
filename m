Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049732B7850
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 09:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgKRITu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 03:19:50 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:33497 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725772AbgKRITu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 03:19:50 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from tariqt@nvidia.com)
        with SMTP; 18 Nov 2020 10:19:43 +0200
Received: from dev-l-vrt-206-005.mtl.labs.mlnx (dev-l-vrt-206-005.mtl.labs.mlnx [10.234.206.5])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 0AI8Jhfv008451;
        Wed, 18 Nov 2020 10:19:43 +0200
From:   Tariq Toukan <tariqt@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net] net/mlx4_core: Fix init_hca fields offset
Date:   Wed, 18 Nov 2020 10:19:22 +0200
Message-Id: <20201118081922.553-1-tariqt@nvidia.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Slave function read the following capabilities from the wrong offset:
1. log_mc_entry_sz
2. fs_log_entry_sz
3. log_mc_hash_sz

Fix that by adjusting these capabilities offset to match firmware
layout.

Due to the wrong offset read, the following issues might occur:
1+2. Negative value reported at max_mcast_qp_attach.
3. Driver to init FW with multicast hash size of zero.

Fixes: a40ded604365 ("net/mlx4_core: Add masking for a few queries on HCA caps")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/fw.c | 6 +++---
 drivers/net/ethernet/mellanox/mlx4/fw.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

Hi,

Please queue to -stable >= v5.0.

Thanks,
Tariq

diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.c b/drivers/net/ethernet/mellanox/mlx4/fw.c
index f6ff9620a137..f6cfec81ccc3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.c
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.c
@@ -1864,8 +1864,8 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define	 INIT_HCA_LOG_RD_OFFSET		 (INIT_HCA_QPC_OFFSET + 0x77)
 #define INIT_HCA_MCAST_OFFSET		 0x0c0
 #define	 INIT_HCA_MC_BASE_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x00)
-#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x12)
-#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x16)
+#define	 INIT_HCA_LOG_MC_ENTRY_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x13)
+#define	 INIT_HCA_LOG_MC_HASH_SZ_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x17)
 #define  INIT_HCA_UC_STEERING_OFFSET	 (INIT_HCA_MCAST_OFFSET + 0x18)
 #define	 INIT_HCA_LOG_MC_TABLE_SZ_OFFSET (INIT_HCA_MCAST_OFFSET + 0x1b)
 #define  INIT_HCA_DEVICE_MANAGED_FLOW_STEERING_EN	0x6
@@ -1873,7 +1873,7 @@ int mlx4_INIT_HCA(struct mlx4_dev *dev, struct mlx4_init_hca_param *param)
 #define  INIT_HCA_DRIVER_VERSION_SZ       0x40
 #define  INIT_HCA_FS_PARAM_OFFSET         0x1d0
 #define  INIT_HCA_FS_BASE_OFFSET          (INIT_HCA_FS_PARAM_OFFSET + 0x00)
-#define  INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x12)
+#define  INIT_HCA_FS_LOG_ENTRY_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x13)
 #define  INIT_HCA_FS_A0_OFFSET		  (INIT_HCA_FS_PARAM_OFFSET + 0x18)
 #define  INIT_HCA_FS_LOG_TABLE_SZ_OFFSET  (INIT_HCA_FS_PARAM_OFFSET + 0x1b)
 #define  INIT_HCA_FS_ETH_BITS_OFFSET      (INIT_HCA_FS_PARAM_OFFSET + 0x21)
diff --git a/drivers/net/ethernet/mellanox/mlx4/fw.h b/drivers/net/ethernet/mellanox/mlx4/fw.h
index 650ae08c71de..8f020f26ebf5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/fw.h
+++ b/drivers/net/ethernet/mellanox/mlx4/fw.h
@@ -182,8 +182,8 @@ struct mlx4_init_hca_param {
 	u64 cmpt_base;
 	u64 mtt_base;
 	u64 global_caps;
-	u16 log_mc_entry_sz;
-	u16 log_mc_hash_sz;
+	u8 log_mc_entry_sz;
+	u8 log_mc_hash_sz;
 	u16 hca_core_clock; /* Internal Clock Frequency (in MHz) */
 	u8  log_num_qps;
 	u8  log_num_srqs;
-- 
2.21.0

