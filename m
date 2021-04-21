Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C523671C4
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244972AbhDURsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244927AbhDURsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0197861427;
        Wed, 21 Apr 2021 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027263;
        bh=0d29s1p7ZxqA5DDAoSEjRxX6cjWyaN/MBnmDVevRAp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rNxmCW/8kzGQWGnXDFhtTMPoRmBea3CDPwKH0xnvVDbLfJ2Bphlc6bRLLvg7L7kRE
         8i5b2lKdhldkzSqgKx+A6PiBmjMa/Uy8rMAfAxTSMjAMwSPINmS6rpOON0W8JzgVu+
         YIxb5p78v50A3lVBjHS6vKo8JTqLUO4wc0WR3coVRISl9qDXf/Nc1JHttOmyU9A0eB
         LaCr07Lddg+9DdH/ctX23SQwcuY7yEJNa2bp0hwRIyeNp4MupbHBCCD7vII9QmkuBO
         RL34EHPUcxEgT8TVAsHnTuAWoKF4h6/taa3NEFa8gM5HGV1tFLFqv9+fYVoO7BZ0JQ
         1FxuFi1S9P/AQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/11] net/mlx5: SF, Split mlx5_sf_hw_table into two parts
Date:   Wed, 21 Apr 2021 10:47:22 -0700
Message-Id: <20210421174723.159428-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Device has SF ids in two different contiguous ranges. One for the local
controller and second for the external controller's PF.

Each such range has its own maximum number of functions and base id.
To allocate SF from either of the range, prepare code to split into
range specific fields into its own structure.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 88 ++++++++++++-------
 1 file changed, 58 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 691ca9dd3991..b5eab48bbe08 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -15,43 +15,55 @@ struct mlx5_sf_hw {
 	u8 pending_delete: 1;
 };
 
-struct mlx5_sf_hw_table {
-	struct mlx5_core_dev *dev;
+struct mlx5_sf_hwc_table {
 	struct mlx5_sf_hw *sfs;
-	int max_local_functions;
+	int max_fn;
 	u16 start_fn_id;
+};
+
+enum mlx5_sf_hwc_index {
+	MLX5_SF_HWC_LOCAL,
+	MLX5_SF_HWC_MAX,
+};
+
+struct mlx5_sf_hw_table {
+	struct mlx5_core_dev *dev;
 	struct mutex table_lock; /* Serializes sf deletion and vhca state change handler. */
 	struct notifier_block vhca_nb;
+	struct mlx5_sf_hwc_table hwc[MLX5_SF_HWC_MAX];
 };
 
 u16 mlx5_sf_sw_to_hw_id(const struct mlx5_core_dev *dev, u16 sw_id)
 {
-	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	struct mlx5_sf_hwc_table *hwc = &dev->priv.sf_hw_table->hwc[MLX5_SF_HWC_LOCAL];
 
-	return table->start_fn_id + sw_id;
+	return hwc->start_fn_id + sw_id;
 }
 
 static u16 mlx5_sf_hw_to_sw_id(const struct mlx5_core_dev *dev, u16 hw_id)
 {
-	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	struct mlx5_sf_hwc_table *hwc = &dev->priv.sf_hw_table->hwc[MLX5_SF_HWC_LOCAL];
 
-	return hw_id - table->start_fn_id;
+	return hw_id - hwc->start_fn_id;
 }
 
 static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 usr_sfnum)
 {
+	struct mlx5_sf_hwc_table *hwc;
 	int i;
 
+	hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
+
 	/* Check if sf with same sfnum already exists or not. */
-	for (i = 0; i < table->max_local_functions; i++) {
-		if (table->sfs[i].allocated && table->sfs[i].usr_sfnum == usr_sfnum)
+	for (i = 0; i < hwc->max_fn; i++) {
+		if (hwc->sfs[i].allocated && hwc->sfs[i].usr_sfnum == usr_sfnum)
 			return -EEXIST;
 	}
 	/* Find the free entry and allocate the entry from the array */
-	for (i = 0; i < table->max_local_functions; i++) {
-		if (!table->sfs[i].allocated) {
-			table->sfs[i].usr_sfnum = usr_sfnum;
-			table->sfs[i].allocated = true;
+	for (i = 0; i < hwc->max_fn; i++) {
+		if (!hwc->sfs[i].allocated) {
+			hwc->sfs[i].usr_sfnum = usr_sfnum;
+			hwc->sfs[i].allocated = true;
 			return i;
 		}
 	}
@@ -60,8 +72,10 @@ static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 usr_sfn
 
 static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, int id)
 {
-	table->sfs[id].allocated = false;
-	table->sfs[id].pending_delete = false;
+	struct mlx5_sf_hwc_table *hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
+
+	hwc->sfs[id].allocated = false;
+	hwc->sfs[id].pending_delete = false;
 }
 
 int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
@@ -125,11 +139,13 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u32 out[MLX5_ST_SZ_DW(query_vhca_state_out)] = {};
+	struct mlx5_sf_hwc_table *hwc;
 	u16 hw_fn_id;
 	u8 state;
 	int err;
 
 	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
+	hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
 	mutex_lock(&table->table_lock);
 	err = mlx5_cmd_query_vhca_state(dev, hw_fn_id, out, sizeof(out));
 	if (err)
@@ -137,25 +153,31 @@ void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u16 id)
 	state = MLX5_GET(query_vhca_state_out, out, vhca_state_context.vhca_state);
 	if (state == MLX5_VHCA_STATE_ALLOCATED) {
 		mlx5_cmd_dealloc_sf(dev, hw_fn_id);
-		table->sfs[id].allocated = false;
+		hwc->sfs[id].allocated = false;
 	} else {
-		table->sfs[id].pending_delete = true;
+		hwc->sfs[id].pending_delete = true;
 	}
 err:
 	mutex_unlock(&table->table_lock);
 }
 
-static void mlx5_sf_hw_dealloc_all(struct mlx5_sf_hw_table *table)
+static void mlx5_sf_hw_table_hwc_dealloc_all(struct mlx5_core_dev *dev,
+					     struct mlx5_sf_hwc_table *hwc)
 {
 	int i;
 
-	for (i = 0; i < table->max_local_functions; i++) {
-		if (table->sfs[i].allocated)
-			_mlx5_sf_hw_table_sf_free(table->dev, i);
+	for (i = 0; i < hwc->max_fn; i++) {
+		if (hwc->sfs[i].allocated)
+			_mlx5_sf_hw_table_sf_free(dev, i);
 	}
 }
 
-static int mlx5_sf_hw_table_alloc(struct mlx5_sf_hw_table *table, u16 max_fn, u16 base_id)
+static void mlx5_sf_hw_table_dealloc_all(struct mlx5_sf_hw_table *table)
+{
+	mlx5_sf_hw_table_hwc_dealloc_all(table->dev, &table->hwc[MLX5_SF_HWC_LOCAL]);
+}
+
+static int mlx5_sf_hw_table_hwc_init(struct mlx5_sf_hwc_table *hwc, u16 max_fn, u16 base_id)
 {
 	struct mlx5_sf_hw *sfs;
 
@@ -163,18 +185,22 @@ static int mlx5_sf_hw_table_alloc(struct mlx5_sf_hw_table *table, u16 max_fn, u1
 	if (!sfs)
 		return -ENOMEM;
 
-	table->sfs = sfs;
-	table->max_local_functions = max_fn;
-	table->start_fn_id = base_id;
+	hwc->sfs = sfs;
+	hwc->max_fn = max_fn;
+	hwc->start_fn_id = base_id;
 	return 0;
 }
 
+static void mlx5_sf_hw_table_hwc_cleanup(struct mlx5_sf_hwc_table *hwc)
+{
+	kfree(hwc->sfs);
+}
+
 int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_hw_table *table;
 	u16 base_id;
 	u16 max_fn;
-	bool ecpu;
 	int err;
 
 	if (!mlx5_sf_supported(dev) || !mlx5_vhca_event_supported(dev))
@@ -190,7 +216,7 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	dev->priv.sf_hw_table = table;
 
 	base_id = mlx5_sf_start_function_id(dev);
-	err = mlx5_sf_hw_table_alloc(table, max_fn, base_id);
+	err = mlx5_sf_hw_table_hwc_init(&table->hwc[MLX5_SF_HWC_LOCAL], max_fn, base_id);
 	if (err)
 		goto table_err;
 
@@ -211,7 +237,7 @@ void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
 		return;
 
 	mutex_destroy(&table->table_lock);
-	kfree(table->sfs);
+	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_LOCAL]);
 	kfree(table);
 }
 
@@ -219,14 +245,16 @@ static int mlx5_sf_hw_vhca_event(struct notifier_block *nb, unsigned long opcode
 {
 	struct mlx5_sf_hw_table *table = container_of(nb, struct mlx5_sf_hw_table, vhca_nb);
 	const struct mlx5_vhca_state_event *event = data;
+	struct mlx5_sf_hwc_table *hwc;
 	struct mlx5_sf_hw *sf_hw;
 	u16 sw_id;
 
 	if (event->new_vhca_state != MLX5_VHCA_STATE_ALLOCATED)
 		return 0;
 
+	hwc = &table->hwc[MLX5_SF_HWC_LOCAL];
 	sw_id = mlx5_sf_hw_to_sw_id(table->dev, event->function_id);
-	sf_hw = &table->sfs[sw_id];
+	sf_hw = &hwc->sfs[sw_id];
 
 	mutex_lock(&table->table_lock);
 	/* SF driver notified through firmware that SF is finally detached.
@@ -258,7 +286,7 @@ void mlx5_sf_hw_table_destroy(struct mlx5_core_dev *dev)
 
 	mlx5_vhca_event_notifier_unregister(dev, &table->vhca_nb);
 	/* Dealloc SFs whose firmware event has been missed. */
-	mlx5_sf_hw_dealloc_all(table);
+	mlx5_sf_hw_table_dealloc_all(table);
 }
 
 bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev)
-- 
2.30.2

