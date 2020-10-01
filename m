Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C09C1280816
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732896AbgJATxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726671AbgJATxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:10 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB03E20848;
        Thu,  1 Oct 2020 19:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581990;
        bh=whY2DGKlHduCB2qFeBuHGZPAWbE6Zf7dltDCcinaLqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vnJ+Noqls8FONGk6bdv5PrmVw3cxEG6nGHxnCEc0l+sQNxbvuC+/l4WWgQE/+zxnW
         IIit/fV6Rsnn6ip4Z89N/3tBfUXnzi/AyFYW/SWTOvAeKqgwSVy8SWYB7AHq9yf/JJ
         Zbb+mWZnIV0hwfo41R/UNq1aYtIlqBp8XzXMc9bg=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 01/15] net/mlx5: Don't allow health work when device is uninitialized
Date:   Thu,  1 Oct 2020 12:52:33 -0700
Message-Id: <20201001195247.66636-2-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@mellanox.com>

On error flow due to failure on driver load, driver can be
un-initializing while a health work is running in the background,
health work shouldn't be allowed at this point, as it needs resources to
be initialized and there is no point to recover on driver load failures.

Therefore, introducing a new state bit to indicated if device is
initialized, for health work to check before trying to recover the driver.

Fixes: b6e0b6bebe07 ("net/mlx5: Fix fatal error handling during device load")
Signed-off-by: Shay Drory <shayd@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 11 +++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/main.c   |  2 ++
 include/linux/mlx5/driver.h                      |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index b31f769d2df9..bbaffe7af619 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -190,6 +190,11 @@ static bool reset_fw_if_needed(struct mlx5_core_dev *dev)
 	return true;
 }
 
+static bool mlx5_is_device_initialized(struct mlx5_core_dev *dev)
+{
+	return test_bit(MLX5_INTERFACE_STATE_INITIALIZED, &dev->intf_state);
+}
+
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 {
 	bool err_detected = false;
@@ -201,6 +206,9 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 		err_detected = true;
 	}
 	mutex_lock(&dev->intf_state_mutex);
+	if (!mlx5_is_device_initialized(dev))
+		goto unlock;
+
 	if (!err_detected && dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		goto unlock;/* a previous error is still being handled */
 	if (dev->state == MLX5_DEVICE_STATE_UNINITIALIZED) {
@@ -609,6 +617,9 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 
 	mlx5_enter_error_state(dev, false);
+	if (!mlx5_is_device_initialized(dev))
+		return;
+
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		if (mlx5_health_try_recover(dev))
 			mlx5_core_err(dev, "health recovery failed\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index ce43e3feccd9..8ebb8d27d3ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -878,6 +878,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	dev->tracer = mlx5_fw_tracer_create(dev);
 	dev->hv_vhca = mlx5_hv_vhca_create(dev);
 	dev->rsc_dump = mlx5_rsc_dump_create(dev);
+	set_bit(MLX5_INTERFACE_STATE_INITIALIZED, &dev->intf_state);
 
 	return 0;
 
@@ -906,6 +907,7 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 
 static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 {
+	clear_bit(MLX5_INTERFACE_STATE_INITIALIZED, &dev->intf_state);
 	mlx5_rsc_dump_destroy(dev);
 	mlx5_hv_vhca_destroy(dev->hv_vhca);
 	mlx5_fw_tracer_destroy(dev->tracer);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c145de0473bc..223aaaaaf8a6 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -594,6 +594,7 @@ enum mlx5_device_state {
 
 enum mlx5_interface_state {
 	MLX5_INTERFACE_STATE_UP = BIT(0),
+	MLX5_INTERFACE_STATE_INITIALIZED = BIT(1),
 };
 
 enum mlx5_pci_status {
-- 
2.26.2

