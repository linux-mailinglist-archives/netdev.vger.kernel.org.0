Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3E72701CB
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 18:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgIRQOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 12:14:39 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55258 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726393AbgIRQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 12:13:59 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from moshe@mellanox.com)
        with SMTP; 18 Sep 2020 19:07:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (dev-l-vrt-135.mtl.labs.mlnx [10.234.135.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 08IG7B0F025165;
        Fri, 18 Sep 2020 19:07:11 +0300
Received: from dev-l-vrt-135.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Debian-10) with ESMTP id 08IG7Bk6031173;
        Fri, 18 Sep 2020 19:07:11 +0300
Received: (from moshe@localhost)
        by dev-l-vrt-135.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 08IG7B9r031172;
        Fri, 18 Sep 2020 19:07:11 +0300
From:   Moshe Shemesh <moshe@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>
Subject: [PATCH net-next RFC v5 13/15] net/mlx5: Add support for fw live patch event
Date:   Fri, 18 Sep 2020 19:06:49 +0300
Message-Id: <1600445211-31078-14-git-send-email-moshe@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firmware live patch event notifies the driver that the firmware was just
updated using live patch. In such case the driver should not reload or
re-initiate entities, part to updating the firmware version and
re-initiate the firmware tracer which can be updated by live patch with
new strings database to help debugging an issue.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 31 +++++++++++++++++++
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  1 +
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 27 ++++++++++++++++
 include/linux/mlx5/device.h                   |  1 +
 4 files changed, 60 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index ad3594c4afcb..08dae045d185 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1064,6 +1064,37 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 	kvfree(tracer);
 }
 
+int mlx5_fw_tracer_recreate_strings_db(struct mlx5_fw_tracer *tracer)
+{
+	struct mlx5_core_dev *dev;
+	int err;
+
+	if (IS_ERR_OR_NULL(tracer))
+		return -EINVAL;
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
 static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct mlx5_fw_tracer *tracer = mlx5_nb_cof(nb, struct mlx5_fw_tracer, nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 40601fba80ba..1a755098aeeb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -191,5 +191,6 @@ void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer);
 int mlx5_fw_tracer_trigger_core_dump_general(struct mlx5_core_dev *dev);
 int mlx5_fw_tracer_get_saved_traces_objects(struct mlx5_fw_tracer *tracer,
 					    struct devlink_fmsg *fmsg);
+int mlx5_fw_tracer_recreate_strings_db(struct mlx5_fw_tracer *tracer);
 
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 95a02e0e3a41..cc838e5c0172 100644
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
@@ -188,6 +190,27 @@ static void mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
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
+	mlx5_fw_tracer_cleanup(tracer);
+	if (mlx5_fw_tracer_recreate_strings_db(tracer))
+		mlx5_core_err(dev, "Failed to recreate FW tracer strings DB\n");
+	if (mlx5_fw_tracer_init(tracer))
+		mlx5_core_err(dev, "Failed to re-initialize FW tracer\n");
+}
+
 static void mlx5_sync_reset_request_event(struct work_struct *work)
 {
 	struct mlx5_fw_reset *fw_reset = container_of(work, struct mlx5_fw_reset,
@@ -361,6 +384,9 @@ static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long acti
 	struct mlx5_eqe *eqe = data;
 
 	switch (eqe->sub_type) {
+	case MLX5_GENERAL_SUBTYPE_FW_LIVE_PATCH_EVENT:
+			queue_work(fw_reset->wq, &fw_reset->fw_live_patch_work);
+		break;
 	case MLX5_GENERAL_SUBTYPE_PCI_SYNC_FOR_FW_UPDATE_EVENT:
 		mlx5_sync_reset_events_handle(fw_reset, eqe);
 		break;
@@ -405,6 +431,7 @@ int mlx5_fw_reset_events_init(struct mlx5_core_dev *dev)
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
2.17.1

