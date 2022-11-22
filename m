Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDFFC633347
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 03:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbiKVC2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 21:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbiKVC22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 21:28:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E34B7167E7
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 18:28:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E3EB61541
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 02:28:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF29AC433B5;
        Tue, 22 Nov 2022 02:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669084105;
        bh=yJ6S+EBYOKbKZ3j5OhhTVDFkyQuKM2U1HahtC+YP4P4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2v6rcMOklqsi5Wy/+dPH8hhNRkSJYpiDtctbglbaSSlwghF2zPUxGJJ92JWaeQ3d
         rPl6POJCfPMoRxxtMb/IZIrQopUPeBsJc7RvfeL2iPPeAaeFDKdM7oohaSfL7foqDI
         UcIdi91uxsiWkJy/J+Js5tQgthgsygSWHzW0J9Mt8bbrlUKmn+XRLd/WhPWYYk7asY
         BgudTYj3Jdurd3dFIGpZUpXhDfJnbjhvsLuHskVq9qwxd8Q99NTlzIArqsFIaOKImL
         0l9A2U/0MwaxCZ45yOLAbg8DYoQECl7JoePu2AMOCfQAlVodoR+40cEzZ0zFSODQBt
         ZcwHwetb+rZZg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: [net 03/14] net/mlx5: SF: Fix probing active SFs during driver probe phase
Date:   Mon, 21 Nov 2022 18:25:48 -0800
Message-Id: <20221122022559.89459-4-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122022559.89459-1-saeed@kernel.org>
References: <20221122022559.89459-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

When SF devices and SF port representors are located on different
functions, unloading and reloading of SF parent driver doesn't recreate
the existing SF present in the device.
Fix it by querying SFs and probe active SFs during driver probe phase.

Fixes: 90d010b8634b ("net/mlx5: SF, Add auxiliary device support")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 88 +++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 7da012ff0d41..8e2abbab05f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -18,6 +18,10 @@ struct mlx5_sf_dev_table {
 	phys_addr_t base_address;
 	u64 sf_bar_length;
 	struct notifier_block nb;
+	struct mutex table_lock; /* Serializes sf life cycle and vhca state change handler */
+	struct workqueue_struct *active_wq;
+	struct work_struct work;
+	u8 stop_active_wq:1;
 	struct mlx5_core_dev *dev;
 };
 
@@ -168,6 +172,7 @@ mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_
 		return 0;
 
 	sf_index = event->function_id - base_id;
+	mutex_lock(&table->table_lock);
 	sf_dev = xa_load(&table->devices, sf_index);
 	switch (event->new_vhca_state) {
 	case MLX5_VHCA_STATE_INVALID:
@@ -191,6 +196,7 @@ mlx5_sf_dev_state_change_handler(struct notifier_block *nb, unsigned long event_
 	default:
 		break;
 	}
+	mutex_unlock(&table->table_lock);
 	return 0;
 }
 
@@ -215,6 +221,78 @@ static int mlx5_sf_dev_vhca_arm_all(struct mlx5_sf_dev_table *table)
 	return 0;
 }
 
+static void mlx5_sf_dev_add_active_work(struct work_struct *work)
+{
+	struct mlx5_sf_dev_table *table = container_of(work, struct mlx5_sf_dev_table, work);
+	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
+	struct mlx5_core_dev *dev = table->dev;
+	u16 max_functions;
+	u16 function_id;
+	u16 sw_func_id;
+	int err = 0;
+	u8 state;
+	int i;
+
+	max_functions = mlx5_sf_max_functions(dev);
+	function_id = MLX5_CAP_GEN(dev, sf_base_id);
+	for (i = 0; i < max_functions; i++, function_id++) {
+		if (table->stop_active_wq)
+			return;
+		err = mlx5_cmd_query_vhca_state(dev, function_id, out, sizeof(out));
+		if (err)
+			/* A failure of specific vhca doesn't mean others will
+			 * fail as well.
+			 */
+			continue;
+		state = MLX5_GET(query_vhca_state_out, out, vhca_state_context.vhca_state);
+		if (state != MLX5_VHCA_STATE_ACTIVE)
+			continue;
+
+		sw_func_id = MLX5_GET(query_vhca_state_out, out, vhca_state_context.sw_function_id);
+		mutex_lock(&table->table_lock);
+		/* Don't probe device which is already probe */
+		if (!xa_load(&table->devices, i))
+			mlx5_sf_dev_add(dev, i, function_id, sw_func_id);
+		/* There is a race where SF got inactive after the query
+		 * above. e.g.: the query returns that the state of the
+		 * SF is active, and after that the eswitch manager set it to
+		 * inactive.
+		 * This case cannot be managed in SW, since the probing of the
+		 * SF is on one system, and the inactivation is on a different
+		 * system.
+		 * If the inactive is done after the SF perform init_hca(),
+		 * the SF will fully probe and then removed. If it was
+		 * done before init_hca(), the SF probe will fail.
+		 */
+		mutex_unlock(&table->table_lock);
+	}
+}
+
+/* In case SFs are generated externally, probe active SFs */
+static int mlx5_sf_dev_queue_active_work(struct mlx5_sf_dev_table *table)
+{
+	if (MLX5_CAP_GEN(table->dev, eswitch_manager))
+		return 0; /* the table is local */
+
+	/* Use a workqueue to probe active SFs, which are in large
+	 * quantity and may take up to minutes to probe.
+	 */
+	table->active_wq = create_singlethread_workqueue("mlx5_active_sf");
+	if (!table->active_wq)
+		return -ENOMEM;
+	INIT_WORK(&table->work, &mlx5_sf_dev_add_active_work);
+	queue_work(table->active_wq, &table->work);
+	return 0;
+}
+
+static void mlx5_sf_dev_destroy_active_work(struct mlx5_sf_dev_table *table)
+{
+	if (table->active_wq) {
+		table->stop_active_wq = true;
+		destroy_workqueue(table->active_wq);
+	}
+}
+
 void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_dev_table *table;
@@ -240,11 +318,17 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 	table->base_address = pci_resource_start(dev->pdev, 2);
 	table->max_sfs = max_sfs;
 	xa_init(&table->devices);
+	mutex_init(&table->table_lock);
 	dev->priv.sf_dev_table = table;
 
 	err = mlx5_vhca_event_notifier_register(dev, &table->nb);
 	if (err)
 		goto vhca_err;
+
+	err = mlx5_sf_dev_queue_active_work(table);
+	if (err)
+		goto add_active_err;
+
 	err = mlx5_sf_dev_vhca_arm_all(table);
 	if (err)
 		goto arm_err;
@@ -252,6 +336,8 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 	return;
 
 arm_err:
+	mlx5_sf_dev_destroy_active_work(table);
+add_active_err:
 	mlx5_vhca_event_notifier_unregister(dev, &table->nb);
 vhca_err:
 	table->max_sfs = 0;
@@ -279,7 +365,9 @@ void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev)
 	if (!table)
 		return;
 
+	mlx5_sf_dev_destroy_active_work(table);
 	mlx5_vhca_event_notifier_unregister(dev, &table->nb);
+	mutex_destroy(&table->table_lock);
 
 	/* Now that event handler is not running, it is safe to destroy
 	 * the sf device without race.
-- 
2.38.1

