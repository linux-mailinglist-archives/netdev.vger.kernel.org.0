Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58BA4424BD
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 01:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhKBAbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 20:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229670AbhKBAbv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 20:31:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A080F61053;
        Tue,  2 Nov 2021 00:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635812957;
        bh=M2smWHRLdmS4ErIGSkeDd6DY7l2hTg+wQjLaQytJMvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMUS9DeAjv0jY3dOvBgjvzOg/n2Kt4ganl0mdzuLPBJM3dlgko93aXacIfTXBaue0
         HPdtW1mNGYkn3AmY1nBC+SlnD6a/5UW/UZsAs74sT/8ZqqsrYuZ3IocCoLOSVvyJ1D
         bP+rSQg11/4eIgDzFN5WLe6pt06K/BnR4yn4USD9wgBqSnldurab+aqpwF8Q57GcDG
         KZIl6D7lT33aE2PtTEffu30wultdvaLTGX7WtUK+Anr2AlrOlSP4ycUpOvCysq3lDP
         8MVXfOLUyYDxptIuKCsAYYCNvmRZfyb3TMAW5Ii6nsli5OmfLx6rdfukBMomIh6wiN
         +o5dFfDWRF19A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 2/7] net/mlx5: Print more info on pci error handlers
Date:   Mon,  1 Nov 2021 17:29:09 -0700
Message-Id: <20211102002914.1052888-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211102002914.1052888-1-saeed@kernel.org>
References: <20211102002914.1052888-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

In case mlx5_pci_err_detected was called with state equals to
pci_channel_io_perm_failure, the driver will never come back up.

It is nice to know why the driver went to zombie land, so print some
useful information on pci err handlers.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 51 ++++++++++++++-----
 1 file changed, 37 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index a92a92a52346..d9361546d5e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1604,12 +1604,28 @@ static void remove_one(struct pci_dev *pdev)
 	mlx5_devlink_free(devlink);
 }
 
+#define mlx5_pci_trace(dev, fmt, ...) ({ \
+	struct mlx5_core_dev *__dev = (dev); \
+	mlx5_core_info(__dev, "%s Device state = %d health sensors: %d pci_status: %d. " fmt, \
+		       __func__, __dev->state, mlx5_health_check_fatal_sensors(__dev), \
+		       __dev->pci_status, ##__VA_ARGS__); \
+})
+
+static const char *result2str(enum pci_ers_result result)
+{
+	return  result == PCI_ERS_RESULT_NEED_RESET ? "need reset" :
+		result == PCI_ERS_RESULT_DISCONNECT ? "disconnect" :
+		result == PCI_ERS_RESULT_RECOVERED  ? "recovered" :
+		"unknown";
+}
+
 static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 					      pci_channel_state_t state)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
+	enum pci_ers_result res;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter, pci channel state = %d\n", state);
 
 	mlx5_enter_error_state(dev, false);
 	mlx5_error_sw_reset(dev);
@@ -1617,8 +1633,11 @@ static pci_ers_result_t mlx5_pci_err_detected(struct pci_dev *pdev,
 	mlx5_drain_health_wq(dev);
 	mlx5_pci_disable_device(dev);
 
-	return state == pci_channel_io_perm_failure ?
+	res = state == pci_channel_io_perm_failure ?
 		PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_NEED_RESET;
+
+	mlx5_pci_trace(dev, "Exit, result = %d, %s\n",  res, result2str(res));
+	return res;
 }
 
 /* wait for the device to show vital signs by waiting
@@ -1652,28 +1671,34 @@ static int wait_vital(struct pci_dev *pdev)
 
 static pci_ers_result_t mlx5_pci_slot_reset(struct pci_dev *pdev)
 {
+	enum pci_ers_result res = PCI_ERS_RESULT_DISCONNECT;
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter\n");
 
 	err = mlx5_pci_enable_device(dev);
 	if (err) {
 		mlx5_core_err(dev, "%s: mlx5_pci_enable_device failed with error code: %d\n",
 			      __func__, err);
-		return PCI_ERS_RESULT_DISCONNECT;
+		goto out;
 	}
 
 	pci_set_master(pdev);
 	pci_restore_state(pdev);
 	pci_save_state(pdev);
 
-	if (wait_vital(pdev)) {
-		mlx5_core_err(dev, "%s: wait_vital timed out\n", __func__);
-		return PCI_ERS_RESULT_DISCONNECT;
+	err = wait_vital(pdev);
+	if (err) {
+		mlx5_core_err(dev, "%s: wait vital failed with error code: %d\n",
+			      __func__, err);
+		goto out;
 	}
 
-	return PCI_ERS_RESULT_RECOVERED;
+	res = PCI_ERS_RESULT_RECOVERED;
+out:
+	mlx5_pci_trace(dev, "Exit, err = %d, result = %d, %s\n", err, res, result2str(res));
+	return res;
 }
 
 static void mlx5_pci_resume(struct pci_dev *pdev)
@@ -1681,14 +1706,12 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 	int err;
 
-	mlx5_core_info(dev, "%s was called\n", __func__);
+	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
 	err = mlx5_load_one(dev);
-	if (err)
-		mlx5_core_err(dev, "%s: mlx5_load_one failed with error code: %d\n",
-			      __func__, err);
-	else
-		mlx5_core_info(dev, "%s: device recovered\n", __func__);
+
+	mlx5_pci_trace(dev, "Done, err = %d, device %s\n", err,
+		       !err ? "recovered" : "Failed");
 }
 
 static const struct pci_error_handlers mlx5_err_handler = {
-- 
2.31.1

