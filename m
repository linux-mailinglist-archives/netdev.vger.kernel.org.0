Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3155464745
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 07:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346997AbhLAGlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 01:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346962AbhLAGkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 01:40:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9E8C061757
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 22:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CA539CE1D76
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 06:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F8DC53FAD;
        Wed,  1 Dec 2021 06:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638340646;
        bh=BgQt/nRrT1lVTB8YsEZmzp92Oq5nL92JhJXn9/Vg404=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZNLMRbajUqKtjczEcd5Rut7U1fHqzVY2Gj4uwwcbzz+T/OM6VXMU9G2aF5M/28Hl
         Ug1GB01hxKLx6/UUSiBUu9AACxRqEwTUmNTH7d5qBfMOU+sYZYnKV70DNjbxjiS1Vm
         ofTMiLBSMZxIpdLECjnwv5+uEuGeqQ/GmKvsrxEfFrDHGsMDW18qEsRsUtXou/HuNh
         JIR6LzOMqIkSC4pvSKAJFUKLN/h/Hije/eiYe0+LYILkKyvSlIYWN1zIec8qXS3aS4
         k6H5e5sJ1CsNsQOxWAvbqqoki4yFB79CzTD7YnFjOFU6vozIHWb9E0AJsV5WJtHF4P
         LECXrmEod1cDg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Amir Tzin <amirtz@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 10/13] net/mlx5: Fix use after free in mlx5_health_wait_pci_up
Date:   Tue, 30 Nov 2021 22:37:06 -0800
Message-Id: <20211201063709.229103-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201063709.229103-1-saeed@kernel.org>
References: <20211201063709.229103-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amir Tzin <amirtz@nvidia.com>

The device health recovery flow calls mlx5_health_wait_pci_up() which
queries the device for FW_RESET timeout after freeing the device
timeouts structure on mlx5_function_teardown(). Fix this bug by moving
timeouts structure init/cleanup to the device's init/uninit phases.
Since it is necessary to reset default software timeouts on function
reload, extract setting of defaults values from mlx5_tout_init() and
call mlx5_tout_set_def_val() directly from mlx5_function_setup().

Fixes: 5945e1adeab5 ("net/mlx5: Read timeout values from init segment")
Reported by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Amir Tzin <amirtz@nvidia.com>
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/lib/tout.c    |  5 ++---
 .../ethernet/mellanox/mlx5/core/lib/tout.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    | 22 ++++++++++---------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
index 0dd96a6b140d..c1df0d3595d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -31,11 +31,11 @@ static void tout_set(struct mlx5_core_dev *dev, u64 val, enum mlx5_timeouts_type
 	dev->timeouts->to[type] = val;
 }
 
-static void tout_set_def_val(struct mlx5_core_dev *dev)
+void mlx5_tout_set_def_val(struct mlx5_core_dev *dev)
 {
 	int i;
 
-	for (i = MLX5_TO_FW_PRE_INIT_TIMEOUT_MS; i < MAX_TIMEOUT_TYPES; i++)
+	for (i = 0; i < MAX_TIMEOUT_TYPES; i++)
 		tout_set(dev, tout_def_sw_val[i], i);
 }
 
@@ -45,7 +45,6 @@ int mlx5_tout_init(struct mlx5_core_dev *dev)
 	if (!dev->timeouts)
 		return -ENOMEM;
 
-	tout_set_def_val(dev);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
index 31faa5c17aa9..1c42ead782fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
@@ -34,6 +34,7 @@ int mlx5_tout_init(struct mlx5_core_dev *dev);
 void mlx5_tout_cleanup(struct mlx5_core_dev *dev);
 void mlx5_tout_query_iseg(struct mlx5_core_dev *dev);
 int mlx5_tout_query_dtor(struct mlx5_core_dev *dev);
+void mlx5_tout_set_def_val(struct mlx5_core_dev *dev);
 u64 _mlx5_tout_ms(struct mlx5_core_dev *dev, enum mlx5_timeouts_types type);
 
 #define mlx5_tout_ms(dev, type) _mlx5_tout_ms(dev, MLX5_TO_##type##_MS)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a92a92a52346..e127c0530b3a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -992,11 +992,7 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 	if (mlx5_core_is_pf(dev))
 		pcie_print_link_status(dev->pdev);
 
-	err = mlx5_tout_init(dev);
-	if (err) {
-		mlx5_core_err(dev, "Failed initializing timeouts, aborting\n");
-		return err;
-	}
+	mlx5_tout_set_def_val(dev);
 
 	/* wait for firmware to accept initialization segments configurations
 	 */
@@ -1005,13 +1001,13 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 	if (err) {
 		mlx5_core_err(dev, "Firmware over %llu MS in pre-initializing state, aborting\n",
 			      mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
-		goto err_tout_cleanup;
+		return err;
 	}
 
 	err = mlx5_cmd_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "Failed initializing command interface, aborting\n");
-		goto err_tout_cleanup;
+		return err;
 	}
 
 	mlx5_tout_query_iseg(dev);
@@ -1094,8 +1090,6 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 err_cmd_cleanup:
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
-err_tout_cleanup:
-	mlx5_tout_cleanup(dev);
 
 	return err;
 }
@@ -1114,7 +1108,6 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 	mlx5_core_disable_hca(dev, 0);
 	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
 	mlx5_cmd_cleanup(dev);
-	mlx5_tout_cleanup(dev);
 
 	return 0;
 }
@@ -1476,6 +1469,12 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 					    mlx5_debugfs_root);
 	INIT_LIST_HEAD(&priv->traps);
 
+	err = mlx5_tout_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "Failed initializing timeouts, aborting\n");
+		goto err_timeout_init;
+	}
+
 	err = mlx5_health_init(dev);
 	if (err)
 		goto err_health_init;
@@ -1501,6 +1500,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 err_pagealloc_init:
 	mlx5_health_cleanup(dev);
 err_health_init:
+	mlx5_tout_cleanup(dev);
+err_timeout_init:
 	debugfs_remove(dev->priv.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
@@ -1518,6 +1519,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	mlx5_adev_cleanup(dev);
 	mlx5_pagealloc_cleanup(dev);
 	mlx5_health_cleanup(dev);
+	mlx5_tout_cleanup(dev);
 	debugfs_remove_recursive(dev->priv.dbg_root);
 	mutex_destroy(&priv->pgdir_mutex);
 	mutex_destroy(&priv->alloc_mutex);
-- 
2.31.1

