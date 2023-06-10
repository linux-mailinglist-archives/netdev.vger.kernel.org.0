Return-Path: <netdev+bounces-9771-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BC872A7B7
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:46:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D5801C21129
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73943A930;
	Sat, 10 Jun 2023 01:43:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D099479
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56364C433A4;
	Sat, 10 Jun 2023 01:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361396;
	bh=Rtic2puoAAfN5wkbPuuVSKMgulztQJIT/aVqHw+v1YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zylu1CKIzOfBLgIQgE9kJI/STSUDHfjetEbZzCE7EhT/eKRwC3CzZZ6lpBwjU4Q/8
	 JNH7VNiACOSXtEjADQy7xygWn+4SZHPBNuqrsbHpH4kvO89lbbAFh0sNV0cmRnR1IM
	 lzx45wowbve4VFCETzdLDgPuIXNiamTGigG+VgVKtpl8PqaFpMVdMRt5Bd5J3Nrqev
	 p9wwIX62ttk3aGfn0dWTh4+MHJwhUsl/IzQTyAMBpGfXgbF9XCcQp7pQ/p43CXXQ3I
	 UTBwIcz1+4F3tuPMWHfjoZgPPUJeb6Qscv/KsJkkHYjuyNXu31Gc2hMghUGGooiSxQ
	 Xx+/MjYqhvnnw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: [net-next 10/15] net/mlx5: Update SRIOV enable/disable to handle EC/VFs
Date: Fri,  9 Jun 2023 18:42:49 -0700
Message-Id: <20230610014254.343576-11-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Previously on the embedded CPU platform SRIOV was never enabled/disabled
via mlx5_core_sriov_configure. Host VF updates are provided by an event
handler. Now in the disable flow it must be known if this is a disable
due to driver unload or SRIOV detach, or if the user updated the number
of VFs. If due to change in the number of VFs only wait for the pages of
ECVFs.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +-
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 35 +++++++++++++++----
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d6ee016deae1..fed8b48a5b20 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1809,7 +1809,7 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_drain_fw_reset(dev);
 	mlx5_drain_health_wq(dev);
 	devlink_unregister(devlink);
-	mlx5_sriov_disable(pdev);
+	mlx5_sriov_disable(pdev, false);
 	mlx5_thermal_uninit(dev);
 	mlx5_crdump_disable(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 7ca0c7a547aa..7a5f04082058 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -195,7 +195,7 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
 void mlx5_sriov_detach(struct mlx5_core_dev *dev);
 int mlx5_core_sriov_configure(struct pci_dev *dev, int num_vfs);
-void mlx5_sriov_disable(struct pci_dev *pdev);
+void mlx5_sriov_disable(struct pci_dev *pdev, bool num_vf_change);
 int mlx5_core_sriov_set_msix_vec_count(struct pci_dev *vf, int msix_vec_count);
 int mlx5_core_enable_hca(struct mlx5_core_dev *dev, u16 func_id);
 int mlx5_core_disable_hca(struct mlx5_core_dev *dev, u16 func_id);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index c2463a1d7035..b73583b0a0fe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -123,9 +123,11 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 }
 
 static void
-mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
+mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf, bool num_vf_change)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
+	bool wait_for_ec_vf_pages = true;
+	bool wait_for_vf_pages = true;
 	int err;
 	int vf;
 
@@ -147,11 +149,30 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
+	/* There are a number of scenarios when SRIOV is being disabled:
+	 *     1. VFs or ECVFs had been created, and now set back to 0 (num_vf_change == true).
+	 *		- If EC SRIOV is enabled then this flow is happening on the
+	 *		  embedded platform, wait for only EC VF pages.
+	 *		- If EC SRIOV is not enabled this flow is happening on non-embedded
+	 *		  platform, wait for the VF pages.
+	 *
+	 *     2. The driver is being unloaded. In this case wait for all pages.
+	 */
+	if (num_vf_change) {
+		if (mlx5_core_ec_sriov_enabled(dev))
+			wait_for_vf_pages = false;
+		else
+			wait_for_ec_vf_pages = false;
+	}
+
+	if (wait_for_ec_vf_pages && mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_EC_VF]))
+		mlx5_core_warn(dev, "timeout reclaiming EC VFs pages\n");
+
 	/* For ECPFs, skip waiting for host VF pages until ECPF is destroyed */
 	if (mlx5_core_is_ecpf(dev))
 		return;
 
-	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
+	if (wait_for_vf_pages && mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
 
@@ -172,12 +193,12 @@ static int mlx5_sriov_enable(struct pci_dev *pdev, int num_vfs)
 	err = pci_enable_sriov(pdev, num_vfs);
 	if (err) {
 		mlx5_core_warn(dev, "pci_enable_sriov failed : %d\n", err);
-		mlx5_device_disable_sriov(dev, num_vfs, true);
+		mlx5_device_disable_sriov(dev, num_vfs, true, true);
 	}
 	return err;
 }
 
-void mlx5_sriov_disable(struct pci_dev *pdev)
+void mlx5_sriov_disable(struct pci_dev *pdev, bool num_vf_change)
 {
 	struct mlx5_core_dev *dev  = pci_get_drvdata(pdev);
 	struct devlink *devlink = priv_to_devlink(dev);
@@ -185,7 +206,7 @@ void mlx5_sriov_disable(struct pci_dev *pdev)
 
 	pci_disable_sriov(pdev);
 	devl_lock(devlink);
-	mlx5_device_disable_sriov(dev, num_vfs, true);
+	mlx5_device_disable_sriov(dev, num_vfs, true, num_vf_change);
 	devl_unlock(devlink);
 }
 
@@ -200,7 +221,7 @@ int mlx5_core_sriov_configure(struct pci_dev *pdev, int num_vfs)
 	if (num_vfs)
 		err = mlx5_sriov_enable(pdev, num_vfs);
 	else
-		mlx5_sriov_disable(pdev);
+		mlx5_sriov_disable(pdev, true);
 
 	if (!err)
 		sriov->num_vfs = num_vfs;
@@ -245,7 +266,7 @@ void mlx5_sriov_detach(struct mlx5_core_dev *dev)
 	if (!mlx5_core_is_pf(dev))
 		return;
 
-	mlx5_device_disable_sriov(dev, pci_num_vf(dev->pdev), false);
+	mlx5_device_disable_sriov(dev, pci_num_vf(dev->pdev), false, false);
 }
 
 static u16 mlx5_get_max_vfs(struct mlx5_core_dev *dev)
-- 
2.40.1


