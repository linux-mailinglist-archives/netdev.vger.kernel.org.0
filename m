Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E61466EDA
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245512AbhLCA7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 19:59:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245448AbhLCA7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0087C061757
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 16:56:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3741EB823BC
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D021C5831B;
        Fri,  3 Dec 2021 00:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492987;
        bh=QHzEEWobZ8JBz03gXnLppgr94OAOK15jGXM+1ZXJcQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhvytmlp3Mu89xO5JBCWD19MfP8yj/hcLRNTHt44M+jTwQ5E31YNXmaLGm8nQXuNM
         yLaBfkG31ZX939uGltmSFuChJF+tJ9xzfzoVzf4FtmxyUKgh3e3OSe5jnyvkS5ji5j
         4ZfyRPvsD1Eo+4qJy70Pbp0oEwZ07PaEz/S+O7OohLOsMYP3vlLrChXevSyjdOKPxz
         dr9Zdhu9cR9TqvzW7u2p1NDiAAoWjs47sTR1oPPcVzkAjMO47mzTotid7XFbRpmpJz
         952PwIdLAbLQIgi/ktyP//xTBP0mW3ZVFD8Mp5VRpHCeXQEOYPkbtSN0DWE5qVwGXY
         3JbzwP08Lq1nQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next v0 06/14] net/mlx5: Print more info on pci error handlers
Date:   Thu,  2 Dec 2021 16:56:14 -0800
Message-Id: <20211203005622.183325-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
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
index 7df9c7f8d9c8..d97c9e86d7b3 100644
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

