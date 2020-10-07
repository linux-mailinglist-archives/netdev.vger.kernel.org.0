Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EAB28588C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 08:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgJGGOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 02:14:20 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:37583 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727210AbgJGGOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 02:14:16 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 7 Oct 2020 09:14:08 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (dev-l-vrt-136.mtl.labs.mlnx [10.234.136.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 09761IR8018885;
        Wed, 7 Oct 2020 09:01:18 +0300
Received: from dev-l-vrt-136.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7) with ESMTP id 09761IGx021792;
        Wed, 7 Oct 2020 09:01:18 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-136.mtl.labs.mlnx (8.14.7/8.14.7/Submit) id 09761Ibw021791;
        Wed, 7 Oct 2020 09:01:18 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next v2 14/16] net/mlx5: Add support for fw live patch event
Date:   Wed,  7 Oct 2020 09:00:55 +0300
Message-Id: <1602050457-21700-15-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firmware live patch event notifies the driver that the firmware was just
updated using live patch. In such case the driver should not reload or
re-initiate entities, part to updating the firmware version and
re-initiate the firmware tracer which can be updated by live patch with
new strings database to help debugging an issue.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 52 +++++++++++++++++++
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 24 +++++++++
 include/linux/mlx5/device.h                   |  1 +
 4 files changed, 78 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index ede4640b8428..2eb022ad7fd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1066,6 +1066,58 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	kvfree(tracer);
 }
 
+static int mlx5_fw_tracer_recreate_strings_db(struct mlx5_fw_tracer *tracer)
+{
+	struct mlx5_core_dev *dev;
+	int err;
+
+	cancel_work_sync(&tracer->read_fw_strings_work);
+	mlx5_fw_tracer_clean_ready_list(tracer);
+	mlx5_fw_tracer_clean_print_hash(tracer);
+	mlx5_fw_tracer_clean_saved_traces_array(tracer);
+	mlx5_fw_tracer_free_strings_db(tracer);
+
+	dev = tracer->dev;
+	err = mlx5_query_mtrc_caps(tracer);
+	if (err) {
+		mlx5_core_dbg(dev, "FWTracer: Failed to query capabilities %d\n", err);
+		return err;
+	}
+
+	err = mlx5_fw_tracer_allocate_strings_db(tracer);
+	if (err) {
+		mlx5_core_warn(dev, "FWTracer: Allocate strings DB failed %d\n", err);
+		return err;
+	}
+	mlx5_fw_tracer_init_saved_traces_array(tracer);
+
+	return 0;
+}
+
+int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer)
+{
+	struct mlx5_core_dev *dev;
+	int err;
+
+	if (IS_ERR_OR_NULL(tracer))
+		return -EINVAL;
+
+	dev = tracer->dev;
+	mlx5_fw_tracer_cleanup(tracer);
+	err = mlx5_fw_tracer_recreate_strings_db(tracer);
+	if (err) {
+		mlx5_core_warn(dev, "Failed to recreate FW tracer strings DB\n");
+		return err;
+	}
+	err = mlx5_fw_tracer_init(tracer);
+	if (err) {
+		mlx5_core_warn(dev, "Failed to re-initialize FW tracer\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct mlx5_fw_tracer *tracer = mlx5_nb_cof(nb, struct mlx5_fw_tracer, nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 40601fba80ba..97252a85d65e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -191,5 +191,6 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer);
 int mlx5_fw_tracer_trigger_core_dump_general(struct mlx5_core_dev *dev);
 int mlx5_fw_tracer_get_saved_traces_objects(struct mlx5_fw_tracer *tracer,
 					    struct devlink_fmsg *fmsg);
+int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index b2aaff8d4fcd..f9042e147c7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020, Mellanox Technologies inc.  All rights reserved. */
 
 #include "fw_reset.h"
+#include "diag/fw_tracer.h"
 
 enum {
 	MLX5_FW_RESET_FLAGS_RESET_REQUESTED,
@@ -13,6 +14,7 @@ struct mlx5_fw_reset {
 	struct mlx5_core_dev *dev;
 	struct mlx5_nb nb;
 	struct workqueue_struct *wq;
+	struct work_struct fw_live_patch_work;
 	struct work_struct reset_request_work;
 	struct work_struct reset_reload_work;
 	struct work_struct reset_now_work;
@@ -192,6 +194,24 @@ static void mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
 	mlx5_start_sync_reset_poll(dev);
 }
 
+static void mlx5_fw_live_patch_event(struct work_struct *work)
+{
+	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
+						      fw_live_patch_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+	struct mlx5_fw_tracer *tracer;
+
+	mlx5_core_info(dev, "Live patch updated firmware version: %d.%d.%d\n", fw_rev_maj(dev),
+		       fw_rev_min(dev), fw_rev_sub(dev));
+
+	tracer = dev->tracer;
+	if (IS_ERR_OR_NULL(tracer))
+		return;
+
+	if (mlx5_fw_tracer_reload(tracer))
+		mlx5_core_err(dev, "Failed to reload FW tracer\n");
+}
+
 static void mlx5_sync_reset_request_event(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
@@ -364,6 +384,9 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	struct mlx5_eqe *eqe = data;
 
 	switch (eqe->sub_type) {
+	case MLX5_GENERAL_SUBTYPE_FW_LIVE_PATCH_EVENT:
+			queue_work(fw_reset->wq, &fw_reset->fw_live_patch_work);
+		break;
 	case MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT:
 		mlx5_sync_reset_events_handle(fw_reset, eqe);
 		break;
@@ -421,6 +444,7 @@ int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 	fw_reset->dev = dev;
 	dev->priv.fw_reset = fw_reset;
 
+	INIT_WORK(&fw_reset->fw_live_patch_work, mlx5_fw_live_patch_event);
 	INIT_WORK(&fw_reset->reset_request_work, mlx5_sync_reset_request_event);
 	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 81ca5989009b..cf824366a7d1 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -366,6 +366,7 @@ enum {
 enum {
 	MLX5_GENERAL_SUBTYPE_DELAY_DROP_TIMEOUT = 0x1,
 	MLX5_GENERAL_SUBTYPE_PCI_POWER_CHANGE_EVENT = 0x5,
+	MLX5_GENERAL_SUBTYPE_FW_LIVE_PATCH_EVENT = 0x7,
 	MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT = 0x8,
 };
 
-- 
2.18.2

