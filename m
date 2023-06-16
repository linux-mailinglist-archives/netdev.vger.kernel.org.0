Return-Path: <netdev+bounces-11593-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7BF5733A8E
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:12:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D9D9280C8B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D62200AF;
	Fri, 16 Jun 2023 20:11:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825F21ED58
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B15DC433CA;
	Fri, 16 Jun 2023 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946295;
	bh=GoDSxYkriBgrbL4Gjrr3/Fd2RJkY1wHse0D2pMt3aww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JHvkoTI7nVNqCDAxFDAsxSob8Uy3Q/YPCJ+u0gYyOvjEcvvKshZzC39r6Y0+yEe1X
	 Eou+JU5LIebgx8JLrV+xNAbafyVFw0Dg41No0YgZ3TbmRfrYg3teniOTVxZODtyNu/
	 B24T9QHKj6og81daEt18/tR87oqzXk2TGbDgpeQfqETEFF3Dh5F1wfPXIAjcR163ve
	 X8c+qO/qsHzku4kra46JCj++RMyMXD7BtXWvG7nSvEvLnvXCL/O6XGiZ2HJ+Nr2Rjb
	 6MhE/WgR4q8T+aIgrEMn0P2biZsRGkUriNOK0XaNEmJXEZN5fcI6vzK53zg8Fm72QR
	 SBRXlcPevNmVw==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drory <shayd@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Handle sync reset unload event
Date: Fri, 16 Jun 2023 13:11:02 -0700
Message-Id: <20230616201113.45510-5-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230616201113.45510-1-saeed@kernel.org>
References: <20230616201113.45510-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

Added a new event handler to firmware sync reset, which is used to
support firmware sync reset flow on smart NIC. Adding this new stage to
the flow enables the firmware to ensure host PFs unload before ECPFs
unload, to avoid race of PFs recovery.

If firmware sends sync_reset_unload event to driver the driver should
unload and close all HW resources of the function. Once the driver
finishes unloading part, it can't get any more events from firmware as
event queues are closed, so it polls the reset state field to know when
to continue to next stage of the sync reset flow.

Added capability bit for supporting sync_reset_unload event.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 103 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/main.c    |   3 +
 include/linux/mlx5/device.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |   3 +-
 4 files changed, 104 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 952cc340b510..7af2b14ab5d8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -21,6 +21,7 @@ struct mlx5_fw_reset {
 	struct workqueue_struct *wq;
 	struct work_struct fw_live_patch_work;
 	struct work_struct reset_request_work;
+	struct work_struct reset_unload_work;
 	struct work_struct reset_reload_work;
 	struct work_struct reset_now_work;
 	struct work_struct reset_abort_work;
@@ -30,6 +31,26 @@ struct mlx5_fw_reset {
 	int ret;
 };
 
+enum {
+	MLX5_FW_RST_STATE_IDLE = 0,
+	MLX5_FW_RST_STATE_TOGGLE_REQ = 4,
+};
+
+enum {
+	MLX5_RST_STATE_BIT_NUM = 12,
+	MLX5_RST_ACK_BIT_NUM = 22,
+};
+
+static u8 mlx5_get_fw_rst_state(struct mlx5_core_dev *dev)
+{
+	return (ioread32be(&dev->iseg->initializing) >> MLX5_RST_STATE_BIT_NUM) & 0xF;
+}
+
+static void mlx5_set_fw_rst_ack(struct mlx5_core_dev *dev)
+{
+	iowrite32be(BIT(MLX5_RST_ACK_BIT_NUM), &dev->iseg->initializing);
+}
+
 static int mlx5_fw_reset_enable_remote_dev_reset_set(struct devlink *devlink, u32 id,
 						     struct devlink_param_gset_ctx *ctx)
 {
@@ -155,7 +176,7 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL0, 0, 0, false);
 }
 
-static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
+static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev, bool unloaded)
 {
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
 
@@ -163,7 +184,8 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
-		mlx5_unload_one(dev, false);
+		if (!unloaded)
+			mlx5_unload_one(dev, false);
 		if (mlx5_health_wait_pci_up(dev))
 			mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
 		else
@@ -204,7 +226,7 @@ static void mlx5_sync_reset_reload_work(struct work_struct *work)
 
 	mlx5_sync_reset_clear_reset_requested(dev, false);
 	mlx5_enter_error_state(dev, true);
-	mlx5_fw_reset_complete_reload(dev);
+	mlx5_fw_reset_complete_reload(dev, false);
 }
 
 #define MLX5_RESET_POLL_INTERVAL	(HZ / 10)
@@ -458,7 +480,70 @@ static void mlx5_sync_reset_now_event(struct work_struct *work)
 	mlx5_enter_error_state(dev, true);
 done:
 	fw_reset->ret = err;
-	mlx5_fw_reset_complete_reload(dev);
+	mlx5_fw_reset_complete_reload(dev, false);
+}
+
+static void mlx5_sync_reset_unload_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset;
+	struct mlx5_core_dev *dev;
+	unsigned long timeout;
+	bool reset_action;
+	u8 rst_state;
+	int err;
+
+	fw_reset = container_of(work, struct mlx5_fw_reset, reset_unload_work);
+	dev = fw_reset->dev;
+
+	if (mlx5_sync_reset_clear_reset_requested(dev, false))
+		return;
+
+	mlx5_core_warn(dev, "Sync Reset Unload. Function is forced down.\n");
+
+	err = mlx5_cmd_fast_teardown_hca(dev);
+	if (err)
+		mlx5_core_warn(dev, "Fast teardown failed, unloading, err %d\n", err);
+	else
+		mlx5_enter_error_state(dev, true);
+
+	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags))
+		mlx5_unload_one_devl_locked(dev, false);
+	else
+		mlx5_unload_one(dev, false);
+
+	mlx5_set_fw_rst_ack(dev);
+	mlx5_core_warn(dev, "Sync Reset Unload done, device reset expected\n");
+
+	reset_action = false;
+	timeout = jiffies + msecs_to_jiffies(mlx5_tout_ms(dev, RESET_UNLOAD));
+	do {
+		rst_state = mlx5_get_fw_rst_state(dev);
+		if (rst_state == MLX5_FW_RST_STATE_TOGGLE_REQ ||
+		    rst_state == MLX5_FW_RST_STATE_IDLE) {
+			reset_action = true;
+			break;
+		}
+		msleep(20);
+	} while (!time_after(jiffies, timeout));
+
+	if (!reset_action) {
+		mlx5_core_err(dev, "Got timeout waiting for sync reset action, state = %u\n",
+			      rst_state);
+		fw_reset->ret = -ETIMEDOUT;
+		goto done;
+	}
+
+	mlx5_core_warn(dev, "Sync Reset, got reset action. rst_state = %u\n", rst_state);
+	if (rst_state == MLX5_FW_RST_STATE_TOGGLE_REQ) {
+		err = mlx5_pci_link_toggle(dev);
+		if (err) {
+			mlx5_core_warn(dev, "mlx5_pci_link_toggle failed, err %d\n", err);
+			fw_reset->ret = err;
+		}
+	}
+
+done:
+	mlx5_fw_reset_complete_reload(dev, true);
 }
 
 static void mlx5_sync_reset_abort_event(struct work_struct *work)
@@ -483,6 +568,9 @@ static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct
 	case MLX5_SYNC_RST_STATE_RESET_REQUEST:
 		queue_work(fw_reset->wq, &fw_reset->reset_request_work);
 		break;
+	case MLX5_SYNC_RST_STATE_RESET_UNLOAD:
+		queue_work(fw_reset->wq, &fw_reset->reset_unload_work);
+		break;
 	case MLX5_SYNC_RST_STATE_RESET_NOW:
 		queue_work(fw_reset->wq, &fw_reset->reset_now_work);
 		break;
@@ -517,10 +605,13 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 int mlx5_fw_reset_wait_reset_done(struct mlx5_core_dev *dev)
 {
 	unsigned long pci_sync_update_timeout = mlx5_tout_ms(dev, PCI_SYNC_UPDATE);
-	unsigned long timeout = msecs_to_jiffies(pci_sync_update_timeout);
 	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+	unsigned long timeout;
 	int err;
 
+	if (MLX5_CAP_GEN(dev, pci_sync_for_fw_update_with_driver_unload))
+		pci_sync_update_timeout += mlx5_tout_ms(dev, RESET_UNLOAD);
+	timeout = msecs_to_jiffies(pci_sync_update_timeout);
 	if (!wait_for_completion_timeout(&fw_reset->done, timeout)) {
 		mlx5_core_warn(dev, "FW sync reset timeout after %lu seconds\n",
 			       pci_sync_update_timeout / 1000);
@@ -557,6 +648,7 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
 	set_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS, &fw_reset->reset_flags);
 	cancel_work_sync(&fw_reset->fw_live_patch_work);
 	cancel_work_sync(&fw_reset->reset_request_work);
+	cancel_work_sync(&fw_reset->reset_unload_work);
 	cancel_work_sync(&fw_reset->reset_reload_work);
 	cancel_work_sync(&fw_reset->reset_now_work);
 	cancel_work_sync(&fw_reset->reset_abort_work);
@@ -595,6 +687,7 @@ int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 
 	INIT_WORK(&fw_reset->fw_live_patch_work, mlx5_fw_live_patch_event);
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
+	INIT_WORK(&fw_reset->reset_unload_work, mlx5_sync_reset_unload_event);
 	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
 	INIT_WORK(&fw_reset->reset_abort_work, mlx5_sync_reset_abort_event);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 6fa314f8e5ee..88dbea6631d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -619,6 +619,9 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 
 	if (MLX5_CAP_GEN_MAX(dev, pci_sync_for_fw_update_event))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, pci_sync_for_fw_update_event, 1);
+	if (MLX5_CAP_GEN_MAX(dev, pci_sync_for_fw_update_with_driver_unload))
+		MLX5_SET(cmd_hca_cap, set_hca_cap,
+			 pci_sync_for_fw_update_with_driver_unload, 1);
 
 	if (MLX5_CAP_GEN_MAX(dev, num_vhca_ports))
 		MLX5_SET(cmd_hca_cap,
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index c0af74efd3cb..80cc12a9a531 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -716,6 +716,7 @@ enum sync_rst_state_type {
 	MLX5_SYNC_RST_STATE_RESET_REQUEST	= 0x0,
 	MLX5_SYNC_RST_STATE_RESET_NOW		= 0x1,
 	MLX5_SYNC_RST_STATE_RESET_ABORT		= 0x2,
+	MLX5_SYNC_RST_STATE_RESET_UNLOAD	= 0x3,
 };
 
 struct mlx5_eqe_sync_fw_update {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 14892e795808..d61dcb5d7cd5 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1755,7 +1755,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_328[0x2];
 	u8	   relaxed_ordering_read[0x1];
 	u8         log_max_pd[0x5];
-	u8         reserved_at_330[0x7];
+	u8         reserved_at_330[0x6];
+	u8         pci_sync_for_fw_update_with_driver_unload[0x1];
 	u8         vnic_env_cnt_steering_fail[0x1];
 	u8         reserved_at_338[0x1];
 	u8         q_counter_aggregation[0x1];
-- 
2.40.1


