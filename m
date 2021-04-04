Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C05A353670
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 06:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236945AbhDDEUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 00:20:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:40860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232196AbhDDEUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 00:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C4C261386;
        Sun,  4 Apr 2021 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617510010;
        bh=DvXpLJf9fZga/ItLSLcUOdJemPKzj+tpAOLwqTdEQtU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aaLGgdgpSXdRf46UB56aMBS0CoppZ3Qz85KO4wiQ5Z9sPalVojN4ykQkyG8GYBmow
         KlWP6CMulRF5cjJiOPZQaNUDtz2vI/rp4SPan7+ThUcNn2xvMHXcALBDrvHLPyY4Mv
         1oPS1IaJWCBYhHTYW9BJMewBcWtlZGeco1y65IfngfsdGlQjHLu8tdBypFFne0xHQC
         9NlumEBDIgbUqrUc3Ipz/Yv3i35+K2Tba36UNlglySfdp1auqnC0VcZnodDSOy2unG
         dR7gEEz+Qs0bqNHofCXDdf4PpdbyuxnwMBkfGA/zrgeHNBOxlsHg6toTw68fVIPiwA
         BzE8x9oUxtlQA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/16] net/mlx5: Allocate rate limit table when rate is configured
Date:   Sat,  3 Apr 2021 21:19:47 -0700
Message-Id: <20210404041954.146958-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210404041954.146958-1-saeed@kernel.org>
References: <20210404041954.146958-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

A device supports 128 rate limiters. A static table allocation consumes
8KB of memory even when rate is not configured.

Instead, allocate the table when at least one rate is configured.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 46 ++++++++++++++++----
 include/linux/mlx5/driver.h                  |  1 +
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 08792fe701e3..0526e3798c09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -117,6 +117,9 @@ static struct mlx5_rl_entry *find_rl_entry(struct mlx5_rl_table *table,
 	bool empty_found = false;
 	int i;
 
+	lockdep_assert_held(&table->rl_lock);
+	WARN_ON(!table->rl_entry);
+
 	for (i = 0; i < table->max_size; i++) {
 		if (dedicated) {
 			if (!table->rl_entry[i].refcount)
@@ -172,10 +175,17 @@ bool mlx5_rl_are_equal(struct mlx5_rate_limit *rl_0,
 }
 EXPORT_SYMBOL(mlx5_rl_are_equal);
 
-static int mlx5_rl_table_alloc(struct mlx5_rl_table *table)
+static int mlx5_rl_table_get(struct mlx5_rl_table *table)
 {
 	int i;
 
+	lockdep_assert_held(&table->rl_lock);
+
+	if (table->rl_entry) {
+		table->refcount++;
+		return 0;
+	}
+
 	table->rl_entry = kcalloc(table->max_size, sizeof(struct mlx5_rl_entry),
 				  GFP_KERNEL);
 	if (!table->rl_entry)
@@ -187,13 +197,27 @@ static int mlx5_rl_table_alloc(struct mlx5_rl_table *table)
 	for (i = 0; i < table->max_size; i++)
 		table->rl_entry[i].index = i + 1;
 
+	table->refcount++;
 	return 0;
 }
 
+static void mlx5_rl_table_put(struct mlx5_rl_table *table)
+{
+	lockdep_assert_held(&table->rl_lock);
+	if (--table->refcount)
+		return;
+
+	kfree(table->rl_entry);
+	table->rl_entry = NULL;
+}
+
 static void mlx5_rl_table_free(struct mlx5_core_dev *dev, struct mlx5_rl_table *table)
 {
 	int i;
 
+	if (!table->rl_entry)
+		return;
+
 	/* Clear all configured rates */
 	for (i = 0; i < table->max_size; i++)
 		if (table->rl_entry[i].refcount)
@@ -219,8 +243,8 @@ int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
 	struct mlx5_rl_entry *entry;
-	int err = 0;
 	u32 rate;
+	int err;
 
 	if (!table->max_size)
 		return -EOPNOTSUPP;
@@ -233,13 +257,16 @@ int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 	}
 
 	mutex_lock(&table->rl_lock);
+	err = mlx5_rl_table_get(table);
+	if (err)
+		goto out;
 
 	entry = find_rl_entry(table, rl_in, uid, dedicated_entry);
 	if (!entry) {
 		mlx5_core_err(dev, "Max number of %u rates reached\n",
 			      table->max_size);
 		err = -ENOSPC;
-		goto out;
+		goto rl_err;
 	}
 	if (!entry->refcount) {
 		/* new rate limit */
@@ -255,14 +282,18 @@ int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
 					 burst_upper_bound),
 				MLX5_GET(set_pp_rate_limit_context, rl_in,
 					 typical_packet_size));
-			goto out;
+			goto rl_err;
 		}
 
 		entry->dedicated = dedicated_entry;
 	}
 	mlx5_rl_entry_get(entry);
 	*index = entry->index;
+	mutex_unlock(&table->rl_lock);
+	return 0;
 
+rl_err:
+	mlx5_rl_table_put(table);
 out:
 	mutex_unlock(&table->rl_lock);
 	return err;
@@ -277,6 +308,7 @@ void mlx5_rl_remove_rate_raw(struct mlx5_core_dev *dev, u16 index)
 	mutex_lock(&table->rl_lock);
 	entry = &table->rl_entry[index - 1];
 	mlx5_rl_entry_put(dev, entry);
+	mlx5_rl_table_put(table);
 	mutex_unlock(&table->rl_lock);
 }
 EXPORT_SYMBOL(mlx5_rl_remove_rate_raw);
@@ -325,6 +357,7 @@ void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl)
 		goto out;
 	}
 	mlx5_rl_entry_put(dev, entry);
+	mlx5_rl_table_put(table);
 out:
 	mutex_unlock(&table->rl_lock);
 }
@@ -333,7 +366,6 @@ EXPORT_SYMBOL(mlx5_rl_remove_rate);
 int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
-	int err;
 
 	mutex_init(&table->rl_lock);
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, packet_pacing)) {
@@ -346,10 +378,6 @@ int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 	table->max_rate = MLX5_CAP_QOS(dev, packet_pacing_max_rate);
 	table->min_rate = MLX5_CAP_QOS(dev, packet_pacing_min_rate);
 
-	err = mlx5_rl_table_alloc(table);
-	if (err)
-		return err;
-
 	mlx5_core_info(dev, "Rate limit: %u rates are supported, range: %uMbps to %uMbps\n",
 		       table->max_size,
 		       table->min_rate >> 10,
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a9bd7e3bd554..baf38b5a2a8c 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -530,6 +530,7 @@ struct mlx5_rl_table {
 	u32                     max_rate;
 	u32                     min_rate;
 	struct mlx5_rl_entry   *rl_entry;
+	u64 refcount;
 };
 
 struct mlx5_core_roce {
-- 
2.30.2

