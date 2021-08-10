Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED563E51A7
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236862AbhHJD76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 23:59:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236555AbhHJD74 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:59:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7082C60F8F;
        Tue, 10 Aug 2021 03:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628567975;
        bh=jq1vfjFw27xul6dryPDw+5jNW+gm2E8jB2d509Hy7sQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WCaCHLXCKssxaZeIU+Mm7q69ERUEcmnA7+S+RRwgZvG9f53sPyGs5OzXKuTz75zlr
         th2nPxY61aEuU4csjDcdf6S5viG4jqqMwrjGvyJWciS5dwP52imyqo8vZttC86MEQ1
         WfPO+lYeNoGahannnmGqHAR3r+ahqSEc7/ElvoYZgRF0QFp7jSy+nRl5mhoo1+oFaC
         5yS6UcyIy0Mlmytz+ZFPLxX9+paYIsDtu03B1rb2h3M4mFzivzPSEbFOSSPoXQ52JL
         E1jl5qu0LmyH1h+LUunJMdX+q4x3ddWZEJmLYCao0KG2ckn6c+4G2ZGC/sV35+lEDM
         TLjcZBBZ9Z3Sw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/12] net/mlx5: Don't skip subfunction cleanup in case of error in module init
Date:   Mon,  9 Aug 2021 20:59:12 -0700
Message-Id: <20210810035923.345745-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210810035923.345745-1-saeed@kernel.org>
References: <20210810035923.345745-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Clean SF resources if mlx5 eth failed to initialize.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 12 ++++--------
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h |  5 +++++
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index eb1b316560a8..c84ad87c99bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1784,16 +1784,14 @@ static int __init init(void)
 	if (err)
 		goto err_sf;
 
-#ifdef CONFIG_MLX5_CORE_EN
 	err = mlx5e_init();
-	if (err) {
-		pci_unregister_driver(&mlx5_core_driver);
-		goto err_debug;
-	}
-#endif
+	if (err)
+		goto err_en;
 
 	return 0;
 
+err_en:
+	mlx5_sf_driver_unregister();
 err_sf:
 	pci_unregister_driver(&mlx5_core_driver);
 err_debug:
@@ -1803,9 +1801,7 @@ static int __init init(void)
 
 static void __exit cleanup(void)
 {
-#ifdef CONFIG_MLX5_CORE_EN
 	mlx5e_cleanup();
-#endif
 	mlx5_sf_driver_unregister();
 	pci_unregister_driver(&mlx5_core_driver);
 	mlx5_unregister_debugfs();
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 343807ac2036..da365b8f0141 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -206,8 +206,13 @@ int mlx5_firmware_flash(struct mlx5_core_dev *dev, const struct firmware *fw,
 int mlx5_fw_version_query(struct mlx5_core_dev *dev,
 			  u32 *running_ver, u32 *stored_ver);
 
+#ifdef CONFIG_MLX5_CORE_EN
 int mlx5e_init(void);
 void mlx5e_cleanup(void);
+#else
+static inline int mlx5e_init(void){ return 0; }
+static inline void mlx5e_cleanup(void){}
+#endif
 
 static inline bool mlx5_sriov_is_enabled(struct mlx5_core_dev *dev)
 {
-- 
2.31.1

