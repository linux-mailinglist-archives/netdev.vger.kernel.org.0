Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423733671C3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbhDURsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:48:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:59438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244925AbhDURsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A06D61422;
        Wed, 21 Apr 2021 17:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619027262;
        bh=Nr8U6o3+jJv6bFbPULUGHDAqEvnEL/xgFxbgxvvGFXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKhAgWxbw5PHh0c9pTN33oHvYXXgi/zNFIb0yf4jj9RS6RX+IACZbDMG3ZOk98HQF
         a9jjc+ydh0mWps0dpA+mlVKujpirhPcOtOcYsoL1BlGFHclVuCdxDPcL0rKN3QYhb9
         Gef+kA9/YmUPCMexN+Q3C2LVA6FiqWGTicNECvje/dyHW1z4idBr6abooGxMM4Y2HW
         smz/2wAo1wRt64ShUfeAZQbL7dErl69aQ96yvAS9qPu+VL1IJsirE/qWXT4xzZFEbD
         Ti0E9bsYQl9ZbSA0LMtLSD6egl39Dt8nB2CI6pEKaZWFrnMpSJ6+8QbJWJR538UlYd
         HpXcuElntOOTA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/11] net/mlx5: SF, Use helpers for allocation and free
Date:   Wed, 21 Apr 2021 10:47:21 -0700
Message-Id: <20210421174723.159428-10-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210421174723.159428-1-saeed@kernel.org>
References: <20210421174723.159428-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Use helper routines for SF id and SF table allocation and free
so that subsequent patch can reuse it for multiple SF function
id range.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Vu Pham <vuhuong@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c | 98 ++++++++++++-------
 1 file changed, 61 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index c3126031c2bf..691ca9dd3991 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -38,37 +38,46 @@ static u16 mlx5_sf_hw_to_sw_id(const struct mlx5_core_dev *dev, u16 hw_id)
 	return hw_id - table->start_fn_id;
 }
 
-int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
+static int mlx5_sf_hw_table_id_alloc(struct mlx5_sf_hw_table *table, u32 usr_sfnum)
 {
-	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
-	int sw_id = -ENOSPC;
-	u16 hw_fn_id;
-	int err;
 	int i;
 
-	if (!table || !table->max_local_functions)
-		return -EOPNOTSUPP;
-
-	mutex_lock(&table->table_lock);
 	/* Check if sf with same sfnum already exists or not. */
 	for (i = 0; i < table->max_local_functions; i++) {
-		if (table->sfs[i].allocated && table->sfs[i].usr_sfnum == usr_sfnum) {
-			err = -EEXIST;
-			goto exist_err;
-		}
+		if (table->sfs[i].allocated && table->sfs[i].usr_sfnum == usr_sfnum)
+			return -EEXIST;
 	}
-
 	/* Find the free entry and allocate the entry from the array */
 	for (i = 0; i < table->max_local_functions; i++) {
 		if (!table->sfs[i].allocated) {
 			table->sfs[i].usr_sfnum = usr_sfnum;
 			table->sfs[i].allocated = true;
-			sw_id = i;
-			break;
+			return i;
 		}
 	}
-	if (sw_id == -ENOSPC) {
-		err = -ENOSPC;
+	return -ENOSPC;
+}
+
+static void mlx5_sf_hw_table_id_free(struct mlx5_sf_hw_table *table, int id)
+{
+	table->sfs[id].allocated = false;
+	table->sfs[id].pending_delete = false;
+}
+
+int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
+{
+	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
+	u16 hw_fn_id;
+	int sw_id;
+	int err;
+
+	if (!table)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&table->table_lock);
+	sw_id = mlx5_sf_hw_table_id_alloc(table, usr_sfnum);
+	if (sw_id < 0) {
+		err = sw_id;
 		goto exist_err;
 	}
 
@@ -87,21 +96,20 @@ int mlx5_sf_hw_table_sf_alloc(struct mlx5_core_dev *dev, u32 usr_sfnum)
 vhca_err:
 	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
 err:
-	table->sfs[i].allocated = false;
+	mlx5_sf_hw_table_id_free(table, sw_id);
 exist_err:
 	mutex_unlock(&table->table_lock);
 	return err;
 }
 
-static void _mlx5_sf_hw_id_free(struct mlx5_core_dev *dev, u16 id)
+static void _mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
 {
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 	u16 hw_fn_id;
 
 	hw_fn_id = mlx5_sf_sw_to_hw_id(dev, id);
 	mlx5_cmd_dealloc_sf(dev, hw_fn_id);
-	table->sfs[id].allocated = false;
-	table->sfs[id].pending_delete = false;
+	mlx5_sf_hw_table_id_free(table, id);
 }
 
 void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
@@ -109,7 +117,7 @@ void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u16 id)
 	struct mlx5_sf_hw_table *table = dev->priv.sf_hw_table;
 
 	mutex_lock(&table->table_lock);
-	_mlx5_sf_hw_id_free(dev, id);
+	_mlx5_sf_hw_table_sf_free(dev, id);
 	mutex_unlock(&table->table_lock);
 }
 
@@ -143,40 +151,56 @@ static void mlx5_sf_hw_dealloc_all(struct mlx5_sf_hw_table *table)
 
 	for (i = 0; i < table->max_local_functions; i++) {
 		if (table->sfs[i].allocated)
-			_mlx5_sf_hw_id_free(table->dev, i);
+			_mlx5_sf_hw_table_sf_free(table->dev, i);
 	}
 }
 
+static int mlx5_sf_hw_table_alloc(struct mlx5_sf_hw_table *table, u16 max_fn, u16 base_id)
+{
+	struct mlx5_sf_hw *sfs;
+
+	sfs = kcalloc(max_fn, sizeof(*sfs), GFP_KERNEL);
+	if (!sfs)
+		return -ENOMEM;
+
+	table->sfs = sfs;
+	table->max_local_functions = max_fn;
+	table->start_fn_id = base_id;
+	return 0;
+}
+
 int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_hw_table *table;
-	struct mlx5_sf_hw *sfs;
-	int max_functions;
+	u16 base_id;
+	u16 max_fn;
+	bool ecpu;
+	int err;
 
 	if (!mlx5_sf_supported(dev) || !mlx5_vhca_event_supported(dev))
 		return 0;
 
-	max_functions = mlx5_sf_max_functions(dev);
+	max_fn = mlx5_sf_max_functions(dev);
 	table = kzalloc(sizeof(*table), GFP_KERNEL);
 	if (!table)
 		return -ENOMEM;
 
-	sfs = kcalloc(max_functions, sizeof(*sfs), GFP_KERNEL);
-	if (!sfs)
-		goto table_err;
-
 	mutex_init(&table->table_lock);
 	table->dev = dev;
-	table->sfs = sfs;
-	table->max_local_functions = max_functions;
-	table->start_fn_id = mlx5_sf_start_function_id(dev);
 	dev->priv.sf_hw_table = table;
-	mlx5_core_dbg(dev, "SF HW table: max sfs = %d\n", max_functions);
+
+	base_id = mlx5_sf_start_function_id(dev);
+	err = mlx5_sf_hw_table_alloc(table, max_fn, base_id);
+	if (err)
+		goto table_err;
+
+	mlx5_core_dbg(dev, "SF HW table: max sfs = %d\n", max_fn);
 	return 0;
 
 table_err:
+	mutex_destroy(&table->table_lock);
 	kfree(table);
-	return -ENOMEM;
+	return err;
 }
 
 void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
@@ -209,7 +233,7 @@ static int mlx5_sf_hw_vhca_event(struct notifier_block *nb, unsigned long opcode
 	 * Hence recycle the sf hardware id for reuse.
 	 */
 	if (sf_hw->allocated && sf_hw->pending_delete)
-		_mlx5_sf_hw_id_free(table->dev, sw_id);
+		_mlx5_sf_hw_table_sf_free(table->dev, sw_id);
 	mutex_unlock(&table->table_lock);
 	return 0;
 }
-- 
2.30.2

