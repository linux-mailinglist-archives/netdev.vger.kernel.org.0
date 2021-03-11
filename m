Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDD33380AD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 23:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhCKWhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 17:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229678AbhCKWhh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 17:37:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70E8264F9A;
        Thu, 11 Mar 2021 22:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615502256;
        bh=63zc9a2TcICeWxaVl+ln137zpVYnCihOv+bXEROrJRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJqpv+c/Y2rbXRbmpTCMSSFAHr9YeygXxfhKCJTC0Wymw2KaGo9od32FUKPrBQz5k
         CNgYlSa87TUVopMcqdOoGejoHUOZdw/B70Unh3YWObFSrqTvyJOQ6jDnPbatjUIp7w
         fZGpENlCZMwEyT++7jb1tbOrbi6FsO3O/gKKxHxwsSNKnbgkgxaCJ65kNxnoG6JyJZ
         CEXrBnOQ+xzupxx7J03lbaY2xcbcCHNWt777f4GgHmzM4GN/o7yje9FOrsdKVuXvsB
         3RcBYw9Y2YlAa/iVrDFEctOHc8LyjZ0q3aoYCupuJxc5G15wlZoHZ0acSx9NnJdvwv
         1gRw8wAJDcnJA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/15] net/mlx5: Check returned value from health recover sequence
Date:   Thu, 11 Mar 2021 14:37:14 -0800
Message-Id: <20210311223723.361301-7-saeed@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311223723.361301-1-saeed@kernel.org>
References: <20210311223723.361301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

MLX5_INTERFACE_STATE_UP is far from being reliable check for success to
recover, because it can be changed any time and health logic doesn't
have any locks to protect from it.

The locks are not needed here because health recover is good to have,
but not must to success, so rely on the returned value from the
mlx5_recover_device() as a marker for success/failure.

Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c    | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c      | 7 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h | 2 +-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 0c32c485eb58..a0a851640804 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -335,12 +335,12 @@ static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 		return -EIO;
 	}
 	mlx5_core_err(dev, "starting health recovery flow\n");
-	mlx5_recover_device(dev);
-	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state) ||
-	    mlx5_health_check_fatal_sensors(dev)) {
+	if (mlx5_recover_device(dev) || mlx5_health_check_fatal_sensors(dev)) {
 		mlx5_core_err(dev, "health recovery failed\n");
 		return -EIO;
 	}
+
+	mlx5_core_info(dev, "health revovery succeded\n");
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 363bc3e917c2..e3a417d17707 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1721,11 +1721,14 @@ void mlx5_disable_device(struct mlx5_core_dev *dev)
 	mlx5_unload_one(dev);
 }
 
-void mlx5_recover_device(struct mlx5_core_dev *dev)
+int mlx5_recover_device(struct mlx5_core_dev *dev)
 {
+	int ret = -EIO;
+
 	mlx5_pci_disable_device(dev);
 	if (mlx5_pci_slot_reset(dev->pdev) == PCI_ERS_RESULT_RECOVERED)
-		mlx5_pci_resume(dev->pdev);
+		ret = mlx5_load_one(dev);
+	return ret;
 }
 
 static struct pci_driver mlx5_core_driver = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 02993a51b114..37c8ec7d2217 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -134,7 +134,7 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev);
 u32 mlx5_health_check_fatal_sensors(struct mlx5_core_dev *dev);
 int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev);
 void mlx5_disable_device(struct mlx5_core_dev *dev);
-void mlx5_recover_device(struct mlx5_core_dev *dev);
+int mlx5_recover_device(struct mlx5_core_dev *dev);
 int mlx5_sriov_init(struct mlx5_core_dev *dev);
 void mlx5_sriov_cleanup(struct mlx5_core_dev *dev);
 int mlx5_sriov_attach(struct mlx5_core_dev *dev);
-- 
2.29.2

