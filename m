Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0750828585F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbgJGGBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:01:53 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:34395 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727175AbgJGGB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:01:28 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 7 Oct 2020 09:01:17 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09761GGo018854;
        Wed, 7 Oct 2020 09:01:16 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 09761G7B021779;
        Wed, 7 Oct 2020 09:01:16 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 09761GWE021778;
        Wed, 7 Oct 2020 09:01:16 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2 08/16] net/mlx5: Handle sync reset request event
Date:   Wed,  7 Oct 2020 09:00:49 +0300
Message-Id: <1602050457-21700-9-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the driver gets sync_reset_request from firmware it prepares for the
coming reset and sends acknowledge.
After getting this event the driver expects device reset, either it will
trigger PCI reset on sync_reset_now event or such PCI reset will be
triggered by another PF of the same device. So it moves to reset
requested mode and if it gets PCI reset triggered by the other PF it
detect the reset and reloads.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
RFCv1 -> RFCv2:
- Moved handling of sync reset recovery from health to fw_reset
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 178 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |   5 +
 .../net/ethernet/mellanox/mlx5/core/health.c  |  35 ++--
 .../net/ethernet/mellanox/mlx5/core/main.c    |  13 ++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 include/linux/mlx5/driver.h                   |   2 +
 6 files changed, 220 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 7feae827b4bc..cd1b4e1b56ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -3,6 +3,20 @@
 
 #include "fw_reset.h"
 
+enum {
+	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
+};
+
+struct mlx5_fw_reset {
+	struct mlx5_core_dev *dev;
+	struct mlx5_nb nb;
+	struct workqueue_struct *wq;
+	struct work_struct reset_request_work;
+	struct work_struct reset_reload_work;
+	unsigned long reset_flags;
+	struct timer_list timer;
+};
+
 static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
 			     u8 reset_type_sel, u8 sync_resp, bool sync_start)
 {
@@ -49,3 +63,167 @@ int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev)
 {
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL0, 0, 0, false);
 }
+
+static void mlx5_sync_reset_reload_work(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_reload_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+
+	mlx5_enter_error_state(dev, true);
+	mlx5_unload_one(dev, false);
+	if (mlx5_health_wait_pci_up(dev)) {
+		mlx5_core_err(dev, "reset reload flow aborted, PCI reads still not working\n");
+		return;
+	}
+	mlx5_load_one(dev, false);
+}
+
+static void mlx5_stop_sync_reset_poll(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	del_timer(&fw_reset->timer);
+}
+
+static void mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool poll_health)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	mlx5_stop_sync_reset_poll(dev);
+	clear_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags);
+	if (poll_health)
+		mlx5_start_health_poll(dev);
+}
+
+#define MLX5_RESET_POLL_INTERVAL	(HZ / 10)
+static void poll_sync_reset(struct timer_list *t)
+{
+	struct mlx5_fw_reset *fw_reset = from_timer(fw_reset, t, timer);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+	u32 fatal_error;
+
+	if (!test_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags))
+		return;
+
+	fatal_error = mlx5_health_check_fatal_sensors(dev);
+
+	if (fatal_error) {
+		mlx5_core_warn(dev, "Got Device Reset\n");
+		mlx5_sync_reset_clear_reset_requested(dev, false);
+		queue_work(fw_reset->wq, &fw_reset->reset_reload_work);
+		return;
+	}
+
+	mod_timer(&fw_reset->timer, round_jiffies(jiffies + MLX5_RESET_POLL_INTERVAL));
+}
+
+static void mlx5_start_sync_reset_poll(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	timer_setup(&fw_reset->timer, poll_sync_reset, 0);
+	fw_reset->timer.expires = round_jiffies(jiffies + MLX5_RESET_POLL_INTERVAL);
+	add_timer(&fw_reset->timer);
+}
+
+static int mlx5_fw_reset_set_reset_sync_ack(struct mlx5_core_dev *dev)
+{
+	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 1, false);
+}
+
+static void mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	mlx5_stop_health_poll(dev, true);
+	set_bit(MLX5_FW_RESET_FLAGS_RESET_REQUESTED, &fw_reset->reset_flags);
+	mlx5_start_sync_reset_poll(dev);
+}
+
+static void mlx5_sync_reset_request_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_request_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+	int err;
+
+	mlx5_sync_reset_set_reset_requested(dev);
+	err = mlx5_fw_reset_set_reset_sync_ack(dev);
+	if (err)
+		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack Failed. Error code: %d\n", err);
+	else
+		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack. Device reset is expected.\n");
+}
+
+static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct mlx5_eqe *eqe)
+{
+	struct mlx5_eqe_sync_fw_update *sync_fw_update_eqe;
+	u8 sync_event_rst_type;
+
+	sync_fw_update_eqe = &eqe->data.sync_fw_update;
+	sync_event_rst_type = sync_fw_update_eqe->sync_rst_state & SYNC_RST_STATE_MASK;
+	switch (sync_event_rst_type) {
+	case MLX5_SYNC_RST_STATE_RESET_REQUEST:
+		queue_work(fw_reset->wq, &fw_reset->reset_request_work);
+		break;
+	}
+}
+
+static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long action, void *data)
+{
+	struct mlx5_fw_reset *fw_reset = mlx5_nb_cof(nb, struct mlx5_fw_reset, nb);
+	struct mlx5_eqe *eqe = data;
+
+	switch (eqe->sub_type) {
+	case MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT:
+		mlx5_sync_reset_events_handle(fw_reset, eqe);
+		break;
+	default:
+		return NOTIFY_DONE;
+	}
+
+	return NOTIFY_OK;
+}
+
+void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
+	mlx5_eq_notifier_register(dev, &fw_reset->nb);
+}
+
+void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev)
+{
+	mlx5_eq_notifier_unregister(dev, &dev->priv.fw_reset->nb);
+}
+
+int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = kzalloc(sizeof(*fw_reset), GFP_KERNEL);
+
+	if (!fw_reset)
+		return -ENOMEM;
+	fw_reset->wq = create_singlethread_workqueue("mlx5_fw_reset_events");
+	if (!fw_reset->wq) {
+		kfree(fw_reset);
+		return -ENOMEM;
+	}
+
+	fw_reset->dev = dev;
+	dev->priv.fw_reset = fw_reset;
+
+	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
+	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
+
+	return 0;
+}
+
+void mlx5_fw_reset_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	destroy_workqueue(fw_reset->wq);
+	kfree(dev->priv.fw_reset);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index 10b5f108cc8b..a231f7848a8f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -10,4 +10,9 @@ int mlx5_fw_reset_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 int mlx5_fw_reset_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
 int mlx5_fw_reset_set_live_patch(struct mlx5_core_dev *dev);
 
+void mlx5_fw_reset_events_start(struct mlx5_core_dev *dev);
+void mlx5_fw_reset_events_stop(struct mlx5_core_dev *dev);
+int mlx5_fw_reset_init(struct mlx5_core_dev *dev);
+void mlx5_fw_reset_cleanup(struct mlx5_core_dev *dev);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index b31f769d2df9..54523bed16cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -110,7 +110,7 @@ static bool sensor_fw_synd_rfr(struct mlx5_core_dev *dev)
 	return rfr && synd;
 }
 
-static u32 check_fatal_sensors(struct mlx5_core_dev *dev)
+u32 mlx5_health_check_fatal_sensors(struct mlx5_core_dev *dev)
 {
 	if (sensor_pci_not_working(dev))
 		return MLX5_SENSOR_PCI_COMM_ERR;
@@ -173,7 +173,7 @@ static bool reset_fw_if_needed(struct mlx5_core_dev *dev)
 	 * Check again to avoid a redundant 2nd reset. If the fatal erros was
 	 * PCI related a reset won't help.
 	 */
-	fatal_error = check_fatal_sensors(dev);
+	fatal_error = mlx5_health_check_fatal_sensors(dev);
 	if (fatal_error == MLX5_SENSOR_PCI_COMM_ERR ||
 	    fatal_error == MLX5_SENSOR_NIC_DISABLED ||
 	    fatal_error == MLX5_SENSOR_NIC_SW_RESET) {
@@ -195,7 +195,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 	bool err_detected = false;
 
 	/* Mark the device as fatal in order to abort FW commands */
-	if ((check_fatal_sensors(dev) || force) &&
+	if ((mlx5_health_check_fatal_sensors(dev) || force) &&
 	    dev->state == MLX5_DEVICE_STATE_UP) {
 		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 		err_detected = true;
@@ -208,7 +208,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 		goto unlock;
 	}
 
-	if (check_fatal_sensors(dev) || force) { /* protected state setting */
+	if (mlx5_health_check_fatal_sensors(dev) || force) { /* protected state setting */
 		dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 		mlx5_cmd_flush(dev);
 	}
@@ -231,7 +231,7 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 
 	mlx5_core_err(dev, "start\n");
 
-	if (check_fatal_sensors(dev) == MLX5_SENSOR_FW_SYND_RFR) {
+	if (mlx5_health_check_fatal_sensors(dev) == MLX5_SENSOR_FW_SYND_RFR) {
 		/* Get cr-dump and reset FW semaphore */
 		lock = lock_sem_sw_reset(dev, true);
 
@@ -308,26 +308,31 @@ static void mlx5_handle_bad_state(struct mlx5_core_dev *dev)
 
 /* How much time to wait until health resetting the driver (in msecs) */
 #define MLX5_RECOVERY_WAIT_MSECS 60000
-static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
+int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev)
 {
 	unsigned long end;
 
-	mlx5_core_warn(dev, "handling bad device here\n");
-	mlx5_handle_bad_state(dev);
 	end = jiffies + msecs_to_jiffies(MLX5_RECOVERY_WAIT_MSECS);
 	while (sensor_pci_not_working(dev)) {
-		if (time_after(jiffies, end)) {
-			mlx5_core_err(dev,
-				      "health recovery flow aborted, PCI reads still not working\n");
-			return -EIO;
-		}
+		if (time_after(jiffies, end))
+			return -ETIMEDOUT;
 		msleep(100);
 	}
+	return 0;
+}
 
+static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
+{
+	mlx5_core_warn(dev, "handling bad device here\n");
+	mlx5_handle_bad_state(dev);
+	if (mlx5_health_wait_pci_up(dev)) {
+		mlx5_core_err(dev, "health recovery flow aborted, PCI reads still not working\n");
+		return -EIO;
+	}
 	mlx5_core_err(dev, "starting health recovery flow\n");
 	mlx5_recover_device(dev);
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state) ||
-	    check_fatal_sensors(dev)) {
+	    mlx5_health_check_fatal_sensors(dev)) {
 		mlx5_core_err(dev, "health recovery failed\n");
 		return -EIO;
 	}
@@ -696,7 +701,7 @@ static void poll_health(struct timer_list *t)
 	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		goto out;
 
-	fatal_error = check_fatal_sensors(dev);
+	fatal_error = mlx5_health_check_fatal_sensors(dev);
 
 	if (fatal_error && !health->fatal_error) {
 		mlx5_core_err(dev, "Fatal error %u detected\n", fatal_error);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5dd23790e7ee..8ff207aa1479 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -57,6 +57,7 @@
 #include "lib/mpfs.h"
 #include "eswitch.h"
 #include "devlink.h"
+#include "fw_reset.h"
 #include "lib/mlx5.h"
 #include "fpga/core.h"
 #include "fpga/ipsec.h"
@@ -835,6 +836,12 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eq_cleanup;
 	}
 
+	err = mlx5_fw_reset_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "failed to initialize fw reset events\n");
+		goto err_events_cleanup;
+	}
+
 	mlx5_cq_debugfs_init(dev);
 
 	mlx5_init_reserved_gids(dev);
@@ -896,6 +903,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
 	mlx5_cq_debugfs_cleanup(dev);
+	mlx5_fw_reset_cleanup(dev);
+err_events_cleanup:
 	mlx5_events_cleanup(dev);
 err_eq_cleanup:
 	mlx5_eq_table_cleanup(dev);
@@ -923,6 +932,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_clock(dev);
 	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
+	mlx5_fw_reset_cleanup(dev);
 	mlx5_events_cleanup(dev);
 	mlx5_eq_table_cleanup(dev);
 	mlx5_irq_table_cleanup(dev);
@@ -1081,6 +1091,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 		goto err_fw_tracer;
 	}
 
+	mlx5_fw_reset_events_start(dev);
 	mlx5_hv_vhca_init(dev->hv_vhca);
 
 	err = mlx5_rsc_dump_init(dev);
@@ -1142,6 +1153,7 @@ static int mlx5_load(struct mlx5_core_dev *dev)
 	mlx5_rsc_dump_cleanup(dev);
 err_rsc_dump:
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
+	mlx5_fw_reset_events_stop(dev);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 err_fw_tracer:
 	mlx5_eq_table_destroy(dev);
@@ -1164,6 +1176,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_fpga_device_stop(dev);
 	mlx5_rsc_dump_cleanup(dev);
 	mlx5_hv_vhca_cleanup(dev->hv_vhca);
+	mlx5_fw_reset_events_stop(dev);
 	mlx5_fw_tracer_cleanup(dev->tracer);
 	mlx5_eq_table_destroy(dev);
 	mlx5_irq_table_destroy(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index e994f84f50b6..8cec85ab419d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -128,6 +128,8 @@ int mlx5_cmd_force_teardown_hca(struct mlx5_core_dev *dev);
 int mlx5_cmd_fast_teardown_hca(struct mlx5_core_dev *dev);
 void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force);
 void mlx5_error_sw_reset(struct mlx5_core_dev *dev);
+u32 mlx5_health_check_fatal_sensors(struct mlx5_core_dev *dev);
+int mlx5_health_wait_pci_up(struct mlx5_core_dev *dev);
 void mlx5_disable_device(struct mlx5_core_dev *dev);
 void mlx5_recover_device(struct mlx5_core_dev *dev);
 int mlx5_sriov_init(struct mlx5_core_dev *dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 239e5348ee09..add85094f9a5 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -501,6 +501,7 @@ struct mlx5_mpfs;
 struct mlx5_eswitch;
 struct mlx5_lag;
 struct mlx5_devcom;
+struct mlx5_fw_reset;
 struct mlx5_eq_table;
 struct mlx5_irq_table;
 
@@ -578,6 +579,7 @@ struct mlx5_priv {
 	struct mlx5_core_sriov	sriov;
 	struct mlx5_lag		*lag;
 	struct mlx5_devcom	*devcom;
+	struct mlx5_fw_reset	*fw_reset;
 	struct mlx5_core_roce	roce;
 	struct mlx5_fc_stats		fc_stats;
 	struct mlx5_rl_table            rl_table;
-- 
2.18.2

