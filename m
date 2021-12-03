Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435CD466EE0
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 01:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245650AbhLCBAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 20:00:00 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60728 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245162AbhLCA7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 19:59:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC0E96291D
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 00:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30809C53FD3;
        Fri,  3 Dec 2021 00:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638492992;
        bh=b5pTCRbwyZM4p9UHj6PI18VtK3aEFtz3D1MkqxgbbBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DbV/oepgGA5rpUVWh3MIpIJUZm/iZGAdK67ET2KZ50qG6r02FiMTTRDGxlNCy6D67
         AvHvrSiPeronUOIEETAuLQQCPAlu4gfZL9+k6SqODxH3ENEcajLyqKXTYK66GKm5Hl
         AT8JG4e6xpkmmhzHIwebWQFSARx1cJWPDFdULQ4JVRxRWGNPK8dYMC63WY/ddbJk6T
         TCDT2mU/N+o2JNH5/0/4+fW5KBAArQBfcmCk3pulYZjU8IZ2XfOUvZ2o8t6xpFp21H
         XwUHKvxS8bAKEklVtK4XNDFwfmAa+fOIR2b59MOk26Jn/iBc7iL3RjRg1xo3vP99M1
         tvgq0PDul8lBQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Avihai Horon <avihaih@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 14/14] net/mlx5: Dynamically resize flow counters query buffer
Date:   Thu,  2 Dec 2021 16:56:22 -0800
Message-Id: <20211203005622.183325-15-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203005622.183325-1-saeed@kernel.org>
References: <20211203005622.183325-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avihai Horon <avihaih@nvidia.com>

The flow counters bulk query buffer is allocated once during
mlx5_fc_init_stats(). For PFs and VFs this buffer usually takes a little
more than 512KB of memory, which is aligned to the next power of 2, to
1MB. For SFs, this buffer is reduced and takes around 128 Bytes.

The buffer size determines the maximum number of flow counters that
can be queried at a time. Thus, having a bigger buffer can improve
performance for users that need to query many flow counters.

There are cases that don't use many flow counters and don't need a big
buffer (e.g. SFs, VFs). Since this size is critical with large scale,
in these cases the buffer size should be reduced.

In order to reduce memory consumption while maintaining query
performance, change the query buffer's allocation scheme to the
following:
- First allocate the buffer with small initial size.
- If the number of counters surpasses the initial size, resize the
  buffer to the maximum size.

The buffer only grows and isn't shrank, because users with many flow
counters don't care about the buffer size and we don't want to add
resize overhead if the current number of counters drops.

This solution is preferable to the current one, which is less accurate
and only addresses SFs.

Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 74 +++++++++++++++----
 include/linux/mlx5/driver.h                   |  4 +
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 7e0e04cf26f8..b406e0367af6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -38,9 +38,10 @@
 #include "fs_cmd.h"
 
 #define MLX5_FC_STATS_PERIOD msecs_to_jiffies(1000)
+#define MLX5_FC_BULK_QUERY_ALLOC_PERIOD msecs_to_jiffies(180 * 1000)
 /* Max number of counters to query in bulk read is 32K */
 #define MLX5_SW_MAX_COUNTERS_BULK BIT(15)
-#define MLX5_SF_NUM_COUNTERS_BULK 8
+#define MLX5_INIT_COUNTERS_BULK 8
 #define MLX5_FC_POOL_MAX_THRESHOLD BIT(18)
 #define MLX5_FC_POOL_USED_BUFF_RATIO 10
 
@@ -145,13 +146,15 @@ static void mlx5_fc_stats_remove(struct mlx5_core_dev *dev,
 	spin_unlock(&fc_stats->counters_idr_lock);
 }
 
-static int get_max_bulk_query_len(struct mlx5_core_dev *dev)
+static int get_init_bulk_query_len(struct mlx5_core_dev *dev)
 {
-	int num_counters_bulk = mlx5_core_is_sf(dev) ?
-					MLX5_SF_NUM_COUNTERS_BULK :
-					MLX5_SW_MAX_COUNTERS_BULK;
+	return min_t(int, MLX5_INIT_COUNTERS_BULK,
+		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
+}
 
-	return min_t(int, num_counters_bulk,
+static int get_max_bulk_query_len(struct mlx5_core_dev *dev)
+{
+	return min_t(int, MLX5_SW_MAX_COUNTERS_BULK,
 		     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
 }
 
@@ -177,7 +180,7 @@ static void mlx5_fc_stats_query_counter_range(struct mlx5_core_dev *dev,
 {
 	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
 	bool query_more_counters = (first->id <= last_id);
-	int max_bulk_len = get_max_bulk_query_len(dev);
+	int cur_bulk_len = fc_stats->bulk_query_len;
 	u32 *data = fc_stats->bulk_query_out;
 	struct mlx5_fc *counter = first;
 	u32 bulk_base_id;
@@ -189,7 +192,7 @@ static void mlx5_fc_stats_query_counter_range(struct mlx5_core_dev *dev,
 		bulk_base_id = counter->id & ~0x3;
 
 		/* number of counters to query inc. the last counter */
-		bulk_len = min_t(int, max_bulk_len,
+		bulk_len = min_t(int, cur_bulk_len,
 				 ALIGN(last_id - bulk_base_id + 1, 4));
 
 		err = mlx5_cmd_fc_bulk_query(dev, bulk_base_id, bulk_len,
@@ -230,6 +233,41 @@ static void mlx5_fc_release(struct mlx5_core_dev *dev, struct mlx5_fc *counter)
 		mlx5_fc_free(dev, counter);
 }
 
+static void mlx5_fc_stats_bulk_query_size_increase(struct mlx5_core_dev *dev)
+{
+	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
+	int max_bulk_len = get_max_bulk_query_len(dev);
+	unsigned long now = jiffies;
+	u32 *bulk_query_out_tmp;
+	int max_out_len;
+
+	if (fc_stats->bulk_query_alloc_failed &&
+	    time_before(now, fc_stats->next_bulk_query_alloc))
+		return;
+
+	max_out_len = mlx5_cmd_fc_get_bulk_query_out_len(max_bulk_len);
+	bulk_query_out_tmp = kzalloc(max_out_len, GFP_KERNEL);
+	if (!bulk_query_out_tmp) {
+		mlx5_core_warn_once(dev,
+				    "Can't increase flow counters bulk query buffer size, insufficient memory, bulk_size(%d)\n",
+				    max_bulk_len);
+		fc_stats->bulk_query_alloc_failed = true;
+		fc_stats->next_bulk_query_alloc =
+			now + MLX5_FC_BULK_QUERY_ALLOC_PERIOD;
+		return;
+	}
+
+	kfree(fc_stats->bulk_query_out);
+	fc_stats->bulk_query_out = bulk_query_out_tmp;
+	fc_stats->bulk_query_len = max_bulk_len;
+	if (fc_stats->bulk_query_alloc_failed) {
+		mlx5_core_info(dev,
+			       "Flow counters bulk query buffer size increased, bulk_size(%d)\n",
+			       max_bulk_len);
+		fc_stats->bulk_query_alloc_failed = false;
+	}
+}
+
 static void mlx5_fc_stats_work(struct work_struct *work)
 {
 	struct mlx5_core_dev *dev = container_of(work, struct mlx5_core_dev,
@@ -247,15 +285,22 @@ static void mlx5_fc_stats_work(struct work_struct *work)
 		queue_delayed_work(fc_stats->wq, &fc_stats->work,
 				   fc_stats->sampling_interval);
 
-	llist_for_each_entry(counter, addlist, addlist)
+	llist_for_each_entry(counter, addlist, addlist) {
 		mlx5_fc_stats_insert(dev, counter);
+		fc_stats->num_counters++;
+	}
 
 	llist_for_each_entry_safe(counter, tmp, dellist, dellist) {
 		mlx5_fc_stats_remove(dev, counter);
 
 		mlx5_fc_release(dev, counter);
+		fc_stats->num_counters--;
 	}
 
+	if (fc_stats->bulk_query_len < get_max_bulk_query_len(dev) &&
+	    fc_stats->num_counters > get_init_bulk_query_len(dev))
+		mlx5_fc_stats_bulk_query_size_increase(dev);
+
 	if (time_before(now, fc_stats->next_query) ||
 	    list_empty(&fc_stats->counters))
 		return;
@@ -378,8 +423,8 @@ EXPORT_SYMBOL(mlx5_fc_destroy);
 int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
-	int max_bulk_len;
-	int max_out_len;
+	int init_bulk_len;
+	int init_out_len;
 
 	spin_lock_init(&fc_stats->counters_idr_lock);
 	idr_init(&fc_stats->counters_idr);
@@ -387,11 +432,12 @@ int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 	init_llist_head(&fc_stats->addlist);
 	init_llist_head(&fc_stats->dellist);
 
-	max_bulk_len = get_max_bulk_query_len(dev);
-	max_out_len = mlx5_cmd_fc_get_bulk_query_out_len(max_bulk_len);
-	fc_stats->bulk_query_out = kzalloc(max_out_len, GFP_KERNEL);
+	init_bulk_len = get_init_bulk_query_len(dev);
+	init_out_len = mlx5_cmd_fc_get_bulk_query_out_len(init_bulk_len);
+	fc_stats->bulk_query_out = kzalloc(init_out_len, GFP_KERNEL);
 	if (!fc_stats->bulk_query_out)
 		return -ENOMEM;
+	fc_stats->bulk_query_len = init_bulk_len;
 
 	fc_stats->wq = create_singlethread_workqueue("mlx5_fc");
 	if (!fc_stats->wq)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a623ec635947..78655d8d13a7 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -478,6 +478,10 @@ struct mlx5_fc_stats {
 	unsigned long next_query;
 	unsigned long sampling_interval; /* jiffies */
 	u32 *bulk_query_out;
+	int bulk_query_len;
+	size_t num_counters;
+	bool bulk_query_alloc_failed;
+	unsigned long next_bulk_query_alloc;
 	struct mlx5_fc_pool fc_pool;
 };
 
-- 
2.31.1

