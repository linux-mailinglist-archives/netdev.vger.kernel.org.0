Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385713DD75F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhHBNkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhHBNkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 09:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E672660FA0;
        Mon,  2 Aug 2021 13:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627911599;
        bh=/rc/fmEQNm7tX9Hto7Zsot8Q0d2YVntUB8FgufBENuc=;
        h=From:To:Cc:Subject:Date:From;
        b=JuPE8Un3A6DROxi81XBrmppayxp/W/KjrkODiG3ZvynSJXWwzcEsR7oHr1QVAxvQu
         qHOiQWHbnQEvq0mxqxeL9tW9UhIzXIKGaUW1x5OnFYtbDTkmbcfgTGS0GB7ZG0cw8H
         SSy5Y/uiUNGTvq8RuE/DTmXuhMJ/Cfkgp6dvoHo92MUs4wOEdcLE558zOBfTU9X17H
         8y6oOV9Qk3cxsocoWTkB6OIJbK9GZsKdMbPpDjIjha4rELjtZQMJVHzr/hOuvUCoVK
         IQ4SRPz3OFAICnEmhlGFMnqiOiMFoahCNDh72DdBT+TAFE9QTCYTBEhUP0d5kse5FF
         Tn4oBGeWQ2ByQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>
Subject: [PATCH net] net/mlx5: Don't skip subfunction cleanup in case of error in module init
Date:   Mon,  2 Aug 2021 16:39:54 +0300
Message-Id: <955a0ebca11c8e41470e37ec2eb2a3bbcd77bbe5.1627911426.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Clean SF resources if mlx5 eth failed to initialize.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
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

