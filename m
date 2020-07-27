Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4342D22EACF
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 13:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgG0LHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 07:07:24 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:40691 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728541AbgG0LHV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 07:07:21 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 27 Jul 2020 14:06:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 06RB6C8J022230;
        Mon, 27 Jul 2020 14:06:12 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 06RB6CEx002392;
        Mon, 27 Jul 2020 14:06:12 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 06RB6CrE002391;
        Mon, 27 Jul 2020 14:06:12 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC 05/13] net/mlx5: Handle sync reset request event
Date:   Mon, 27 Jul 2020 14:02:25 +0300
Message-Id: <1595847753-2234-6-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once the driver gets sync_reset_request from firmware it prepares for the
coming reset and sends acknowledge.
After getting this event the driver expects device reset, either it will
trigger PCI reset on sync_reset_now event or such PCI reset will be
triggered by another PF of the same device. So it moves to reset
requested mode and if it gets PCI reset triggered by the other PF it
does silent recovery without reporting it as an error.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 88 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/fw_reset.h    |  3 +
 .../net/ethernet/mellanox/mlx5/core/health.c  | 74 +++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 10 +++
 include/linux/mlx5/driver.h                   | 11 +++
 5 files changed, 173 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 76d2cece29ac..13f83fc1783f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -3,6 +3,13 @@
 
 #include "fw_reset.h"
 
+struct mlx5_fw_reset {
+	struct mlx5_core_dev *dev;
+	struct mlx5_nb nb;
+	struct workqueue_struct *wq;
+	struct work_struct reset_request_work;
+};
+
 static int mlx5_reg_mfrl_set(struct mlx5_core_dev *dev, u8 reset_level,
 			     u8 reset_type_sel, u8 sync_resp, bool sync_start)
 {
@@ -44,3 +51,84 @@ int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev)
 {
 	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL0, 0, 0, false);
 }
+
+static int mlx5_fw_set_reset_sync_ack(struct mlx5_core_dev *dev)
+{
+	return mlx5_reg_mfrl_set(dev, MLX5_MFRL_REG_RESET_LEVEL3, 0, 1, false);
+}
+
+static void mlx5_sync_reset_request_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      reset_request_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+
+	mlx5_health_set_reset_requested_mode(dev);
+	mlx5_reload_health_poll_timer(dev);
+	if (mlx5_fw_set_reset_sync_ack(dev))
+		mlx5_core_warn(dev, "PCI Sync FW Update Reset Ack Failed.\n");
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
+int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
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
+
+	MLX5_NB_INIT(&fw_reset->nb, fw_reset_event_notifier, GENERAL_EVENT);
+	mlx5_eq_notifier_register(dev, &fw_reset->nb);
+
+	return 0;
+}
+
+void mlx5_fw_reset_events_cleanup(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fw_reset *fw_reset = dev->priv.fw_reset;
+
+	mlx5_eq_notifier_unregister(dev, &fw_reset->nb);
+	destroy_workqueue(fw_reset->wq);
+	kvfree(dev->priv.fw_reset);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
index 1bbd95182ca6..278f538ea92a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.h
@@ -10,4 +10,7 @@ int mlx5_reg_mfrl_query(struct mlx5_core_dev *dev, u8 *reset_level, u8 *reset_ty
 int mlx5_fw_set_reset_sync(struct mlx5_core_dev *dev, u8 reset_type_sel);
 int mlx5_fw_set_live_patch(struct mlx5_core_dev *dev);
 
+int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev);
+void mlx5_fw_reset_events_cleanup(struct mlx5_core_dev *dev);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index b31f769d2df9..371134789375 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -47,6 +47,8 @@ enum {
 	MAX_MISSES			= 3,
 };
 
+#define MLX5_HEALTH_RR_POLL_INTERVAL	(HZ / 10)
+
 enum {
 	MLX5_HEALTH_SYNDR_FW_ERR		= 0x1,
 	MLX5_HEALTH_SYNDR_IRISC_ERR		= 0x7,
@@ -222,6 +224,7 @@ void mlx5_enter_error_state(struct mlx5_core_dev *dev, bool force)
 #define MLX5_FW_RESET_WAIT_MS	1000
 void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 {
+	struct mlx5_core_health *health = &dev->priv.health;
 	unsigned long end, delay_ms = MLX5_FW_RESET_WAIT_MS;
 	int lock = -EBUSY;
 
@@ -229,7 +232,8 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 	if (dev->state != MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		goto unlock;
 
-	mlx5_core_err(dev, "start\n");
+	if (!test_bit(MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY, &health->reset_flags))
+		mlx5_core_err(dev, "start\n");
 
 	if (check_fatal_sensors(dev) == MLX5_SENSOR_FW_SYND_RFR) {
 		/* Get cr-dump and reset FW semaphore */
@@ -262,7 +266,8 @@ void mlx5_error_sw_reset(struct mlx5_core_dev *dev)
 	if (!lock)
 		lock_sem_sw_reset(dev, false);
 
-	mlx5_core_err(dev, "end\n");
+	if (!test_bit(MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY, &health->reset_flags))
+		mlx5_core_err(dev, "end\n");
 
 unlock:
 	mutex_unlock(&dev->intf_state_mutex);
@@ -310,10 +315,15 @@ static void mlx5_handle_bad_state(struct mlx5_core_dev *dev)
 #define MLX5_RECOVERY_WAIT_MSECS 60000
 static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 {
+	struct mlx5_core_health *health = &dev->priv.health;
 	unsigned long end;
 
-	mlx5_core_warn(dev, "handling bad device here\n");
-	mlx5_handle_bad_state(dev);
+	if (!test_bit(MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY, &health->reset_flags)) {
+		mlx5_core_warn(dev, "handling bad device here\n");
+		mlx5_handle_bad_state(dev);
+	} else {
+		mlx5_disable_device(dev);
+	}
 	end = jiffies + msecs_to_jiffies(MLX5_RECOVERY_WAIT_MSECS);
 	while (sensor_pci_not_working(dev)) {
 		if (time_after(jiffies, end)) {
@@ -324,7 +334,8 @@ static int mlx5_health_try_recover(struct mlx5_core_dev *dev)
 		msleep(100);
 	}
 
-	mlx5_core_err(dev, "starting health recovery flow\n");
+	if (!test_and_clear_bit(MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY, &health->reset_flags))
+		mlx5_core_err(dev, "starting health recovery flow\n");
 	mlx5_recover_device(dev);
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state) ||
 	    check_fatal_sensors(dev)) {
@@ -609,7 +620,8 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	dev = container_of(priv, struct mlx5_core_dev, priv);
 
 	mlx5_enter_error_state(dev, false);
-	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
+	if (test_bit(MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY, &health->reset_flags) ||
+	    IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
 		if (mlx5_health_try_recover(dev))
 			mlx5_core_err(dev, "health recovery failed\n");
 		return;
@@ -660,13 +672,17 @@ static void mlx5_fw_reporters_destroy(struct mlx5_core_dev *dev)
 		devlink_health_reporter_destroy(health->fw_fatal_reporter);
 }
 
-static unsigned long get_next_poll_jiffies(void)
+static unsigned long get_next_poll_jiffies(bool reset_requested)
 {
 	unsigned long next;
 
-	get_random_bytes(&next, sizeof(next));
-	next %= HZ;
-	next += jiffies + MLX5_HEALTH_POLL_INTERVAL;
+	if (reset_requested) {
+		next = jiffies + MLX5_HEALTH_RR_POLL_INTERVAL;
+	} else {
+		get_random_bytes(&next, sizeof(next));
+		next %= HZ;
+		next += jiffies + MLX5_HEALTH_POLL_INTERVAL;
+	}
 
 	return next;
 }
@@ -699,9 +715,16 @@ static void poll_health(struct timer_list *t)
 	fatal_error = check_fatal_sensors(dev);
 
 	if (fatal_error && !health->fatal_error) {
-		mlx5_core_err(dev, "Fatal error %u detected\n", fatal_error);
+		if (!test_and_clear_bit(MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED,
+					&health->reset_flags)) {
+			mlx5_core_err(dev, "Fatal error %u detected\n",
+				      fatal_error);
+			print_health_info(dev);
+		} else {
+			mlx5_core_warn(dev, "Got Device Reset\n");
+			set_bit(MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY, &health->reset_flags);
+		}
 		dev->priv.health.fatal_error = fatal_error;
-		print_health_info(dev);
 		mlx5_trigger_health_work(dev);
 		goto out;
 	}
@@ -725,7 +748,9 @@ static void poll_health(struct timer_list *t)
 		queue_work(health->wq, &health->report_work);
 
 out:
-	mod_timer(&health->timer, get_next_poll_jiffies());
+	mod_timer(&health->timer,
+		  get_next_poll_jiffies(test_bit(MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED,
+						 &health->reset_flags)));
 }
 
 void mlx5_start_health_poll(struct mlx5_core_dev *dev)
@@ -756,6 +781,15 @@ void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health)
 	del_timer_sync(&health->timer);
 }
 
+void mlx5_reload_health_poll_timer(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	mod_timer(&health->timer,
+		  get_next_poll_jiffies(test_bit(MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED,
+						 &health->reset_flags)));
+}
+
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
@@ -768,6 +802,20 @@ void mlx5_drain_health_wq(struct mlx5_core_dev *dev)
 	cancel_work_sync(&health->fatal_report_work);
 }
 
+void mlx5_health_set_reset_requested_mode(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	set_bit(MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED, &health->reset_flags);
+}
+
+void mlx5_health_clear_reset_requested_mode(struct mlx5_core_dev *dev)
+{
+	struct mlx5_core_health *health = &dev->priv.health;
+
+	clear_bit(MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED, &health->reset_flags);
+}
+
 void mlx5_health_flush(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5fb23cfecd71..8aa4d5aec105 100644
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
@@ -832,6 +833,12 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_eq_cleanup;
 	}
 
+	err = mlx5_fw_reset_events_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "failed to initialize fw reset events\n");
+		goto err_events_cleanup;
+	}
+
 	mlx5_cq_debugfs_init(dev);
 
 	mlx5_init_reserved_gids(dev);
@@ -893,6 +900,8 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	mlx5_geneve_destroy(dev->geneve);
 	mlx5_vxlan_destroy(dev->vxlan);
 	mlx5_cq_debugfs_cleanup(dev);
+	mlx5_fw_reset_events_cleanup(dev);
+err_events_cleanup:
 	mlx5_events_cleanup(dev);
 err_eq_cleanup:
 	mlx5_eq_table_cleanup(dev);
@@ -920,6 +929,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_clock(dev);
 	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
+	mlx5_fw_reset_events_cleanup(dev);
 	mlx5_events_cleanup(dev);
 	mlx5_eq_table_cleanup(dev);
 	mlx5_irq_table_cleanup(dev);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 6a97ad601991..27b6086f3095 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -423,6 +423,11 @@ struct mlx5_sq_bfreg {
 	unsigned int		offset;
 };
 
+enum {
+	MLX5_HEALTH_RESET_FLAGS_RESET_REQUESTED,
+	MLX5_HEALTH_RESET_FLAGS_SILENT_RECOVERY,
+};
+
 struct mlx5_core_health {
 	struct health_buffer __iomem   *health;
 	__be32 __iomem		       *health_counter;
@@ -432,6 +437,7 @@ struct mlx5_core_health {
 	u8				synd;
 	u32				fatal_error;
 	u32				crdump_size;
+	unsigned long			reset_flags;
 	/* wq spinlock to synchronize draining */
 	spinlock_t			wq_lock;
 	struct workqueue_struct	       *wq;
@@ -501,6 +507,7 @@ struct mlx5_mpfs;
 struct mlx5_eswitch;
 struct mlx5_lag;
 struct mlx5_devcom;
+struct mlx5_fw_reset;
 struct mlx5_eq_table;
 struct mlx5_irq_table;
 
@@ -578,6 +585,7 @@ struct mlx5_priv {
 	struct mlx5_core_sriov	sriov;
 	struct mlx5_lag		*lag;
 	struct mlx5_devcom	*devcom;
+	struct mlx5_fw_reset	*fw_reset;
 	struct mlx5_core_roce	roce;
 	struct mlx5_fc_stats		fc_stats;
 	struct mlx5_rl_table            rl_table;
@@ -942,8 +950,11 @@ void mlx5_health_cleanup(struct mlx5_core_dev *dev);
 int mlx5_health_init(struct mlx5_core_dev *dev);
 void mlx5_start_health_poll(struct mlx5_core_dev *dev);
 void mlx5_stop_health_poll(struct mlx5_core_dev *dev, bool disable_health);
+void mlx5_reload_health_poll_timer(struct mlx5_core_dev *dev);
 void mlx5_drain_health_wq(struct mlx5_core_dev *dev);
 void mlx5_trigger_health_work(struct mlx5_core_dev *dev);
+void mlx5_health_set_reset_requested_mode(struct mlx5_core_dev *dev);
+void mlx5_health_clear_reset_requested_mode(struct mlx5_core_dev *dev);
 int mlx5_buf_alloc(struct mlx5_core_dev *dev,
 		   int size, struct mlx5_frag_buf *buf);
 void mlx5_buf_free(struct mlx5_core_dev *dev, struct mlx5_frag_buf *buf);
-- 
2.17.1

