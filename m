Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA76039E5
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 08:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbiJSGjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 02:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiJSGjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 02:39:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B236E898
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 23:38:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBC906150E
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12658C433D7;
        Wed, 19 Oct 2022 06:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666161523;
        bh=WBfBLo74MxvWWA4c9fDGQen97B+9G3hhjC29KuS96xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlAKmhDRX3FIgL6dCjvHIEBktJWF95ot72tOjBsUljH799G+xRIUS5PWc7Wj5IvEl
         Y8zdtIbix3s20QAlKg/bqxxaTypcjFjzxhToc+29Jcuzs7bMVryXGv8z1SD2qYjiwP
         CQM7uS1v4tfz5NKvSxXhWnSWx+rE6k6eiTsYkOJ0hzXdi25B4Pt/BtFxZAj31aB+Wy
         qdwaJyDpd2OW0lqFidUSragPrKd8Y4OQCrLpk6+Qba0h1VtAciHvvghu+aNQ45MLd4
         CnUrq8mj5sxu4eSkzSAhw97FW3OSKDV+mUIQ4fBxEMFmCqXRYw7ffDQYW3/OdBg2cA
         2vcDRV1GpNKMA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: [net 09/16] net/mlx5: SF: Fix probing active SFs during driver probe phase
Date:   Tue, 18 Oct 2022 23:38:06 -0700
Message-Id: <20221019063813.802772-10-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221019063813.802772-1-saeed@kernel.org>
References: <20221019063813.802772-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 .../ethernet/mellanox/mlx5/core/sf/dev/dev.c  | 86 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/sf/sf.h   | 10 +++
 2 files changed, 96 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index 7da012ff0d41..4fa4ed36b3ef 100644
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
+		sw_func_id = MLX5_GET(query_vhca_state_out, out, vhca_state_context.sw_function_id);
+		if (state == MLX5_VHCA_STATE_ACTIVE) {
+			mutex_lock(&table->table_lock);
+			/* Don't probe device which is already probe */
+			if (!xa_load(&table->devices, i))
+				mlx5_sf_dev_add(dev, i, function_id, sw_func_id);
+			/* There is a race where SF got inactive after the query
+			 * above. e.g.: the query returns that the state of the
+			 * SF is active, and after that the eswitch manager set it to
+			 * inactive.
+			 * This case cannot be managed in SW, since the probing of the
+			 * SF is on one system, and the inactivation is on a different
+			 * system.
+			 * If the inactive is done after the SF perform init_hca(),
+			 * the SF will fully probe and then removed. If it was
+			 * done before init_hca(), the SF probe will fail.
+			 */
+			mutex_unlock(&table->table_lock);
+		}
+	}
+}
+
+/* In case SFs are generated externally, probe active SFs */
+int mlx5_sf_dev_queue_active_work(struct mlx5_sf_dev_table *table)
+{
+	if (!mlx5_sf_table_external(table->dev))
+		return 0;
+	/* Use a workqueue to probe active SFs, which are in large
+	 * quantity and may take up to minutes to probe.
+	 */
+	table->active_wq = create_singlethread_workqueue("mlx5_active_sf");
+	if (!table->active_wq)
+		return -ENOMEM;
+	INIT_WORK(&table->work, &mlx5_sf_dev_add_active_work);
+	mutex_init(&table->table_lock);
+	queue_work(table->active_wq, &table->work);
+	return 0;
+}
+
+void mlx5_sf_dev_destroy_active_work(struct mlx5_sf_dev_table *table)
+{
+	if (table->active_wq) {
+		table->stop_active_wq = true;
+		destroy_workqueue(table->active_wq);
+		mutex_destroy(&table->table_lock);
+	}
+}
+
 void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_dev_table *table;
@@ -245,6 +323,11 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
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
@@ -252,6 +335,8 @@ void mlx5_sf_dev_table_create(struct mlx5_core_dev *dev)
 	return;
 
 arm_err:
+	mlx5_sf_dev_destroy_active_work(table);
+add_active_err:
 	mlx5_vhca_event_notifier_unregister(dev, &table->nb);
 vhca_err:
 	table->max_sfs = 0;
@@ -279,6 +364,7 @@ void mlx5_sf_dev_table_destroy(struct mlx5_core_dev *dev)
 	if (!table)
 		return;
 
+	mlx5_sf_dev_destroy_active_work(table);
 	mlx5_vhca_event_notifier_unregister(dev, &table->nb);
 
 	/* Now that event handler is not running, it is safe to destroy
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
index 3a480e06ecc0..be7aac4e47b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/sf.h
@@ -18,6 +18,11 @@ void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev);
 int mlx5_sf_table_init(struct mlx5_core_dev *dev);
 void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev);
 
+static inline bool mlx5_sf_table_external(const struct mlx5_core_dev *dev)
+{
+	return !MLX5_CAP_GEN(dev, eswitch_manager);
+}
+
 int mlx5_devlink_sf_port_new(struct devlink *devlink,
 			     const struct devlink_port_new_attrs *add_attr,
 			     struct netlink_ext_ack *extack,
@@ -60,6 +65,11 @@ static inline void mlx5_sf_table_cleanup(struct mlx5_core_dev *dev)
 {
 }
 
+static inline bool mlx5_sf_table_external(const struct mlx5_core_dev *dev)
+{
+	return true;
+}
+
 #endif
 
 #endif
-- 
2.37.3

