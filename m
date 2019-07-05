Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CEA6095D
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfGEPbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:31:03 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:52434 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727908AbfGEPav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:30:51 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from tariqt@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 5 Jul 2019 18:30:42 +0300
Received: from dev-l-vrt-207-011.mtl.labs.mlnx. (dev-l-vrt-207-011.mtl.labs.mlnx [10.134.207.11])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x65FUfOa029656;
        Fri, 5 Jul 2019 18:30:41 +0300
From:   Tariq Toukan <tariqt@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        moshe@mellanox.com, Tariq Toukan <tariqt@mellanox.com>
Subject: [PATCH net-next 01/12] net/mlx5: Accel, Expose accel wrapper for IPsec FPGA function
Date:   Fri,  5 Jul 2019 18:30:11 +0300
Message-Id: <1562340622-4423-2-git-send-email-tariqt@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
References: <1562340622-4423-1-git-send-email-tariqt@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not directly call fpga version of IPsec function from main.c.
Wrap it by an accel version, and call the wrapper.

This will allow deprecating the FPGA IPsec stubs in downstream
patch.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c        | 2 +-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
index 9f1b1939716a..d1e76d5a413b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.c
@@ -74,6 +74,11 @@ int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
 	return mlx5_fpga_ipsec_init(mdev);
 }
 
+void mlx5_accel_ipsec_build_fs_cmds(void)
+{
+	mlx5_fpga_ipsec_build_fs_cmds();
+}
+
 void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
 {
 	mlx5_fpga_ipsec_cleanup(mdev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
index 024dbd22a89b..93b3f5faddb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/accel/ipsec.h
@@ -54,6 +54,7 @@ void *mlx5_accel_esp_create_hw_context(struct mlx5_core_dev *mdev,
 void mlx5_accel_esp_free_hw_context(void *context);
 
 int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev);
+void mlx5_accel_ipsec_build_fs_cmds(void);
 void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev);
 
 #else
@@ -79,6 +80,10 @@ static inline int mlx5_accel_ipsec_init(struct mlx5_core_dev *mdev)
 	return 0;
 }
 
+static inline void mlx5_accel_ipsec_build_fs_cmds(void)
+{
+}
+
 static inline void mlx5_accel_ipsec_cleanup(struct mlx5_core_dev *mdev)
 {
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 4084c4e74fb7..b15b27a497fc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1600,7 +1600,7 @@ static int __init init(void)
 	get_random_bytes(&sw_owner_id, sizeof(sw_owner_id));
 
 	mlx5_core_verify_params();
-	mlx5_fpga_ipsec_build_fs_cmds();
+	mlx5_accel_ipsec_build_fs_cmds();
 	mlx5_register_debugfs();
 
 	err = pci_register_driver(&mlx5_core_driver);
-- 
1.8.3.1

