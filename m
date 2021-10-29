Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649C544047B
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 22:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbhJ2U7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 16:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:58476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231270AbhJ2U7N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 16:59:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7FFF6108F;
        Fri, 29 Oct 2021 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635541005;
        bh=MtIvbCI2hLPAdRePWQ6F/MlMWllHCQTbWvn7o/xXCf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkh0PTFJ0YdBX0wwivvSJLBEn/ZBNcEvfT2sAf/S3nANyPFjb++1v0puD13RuGwjL
         S2GD3oteBiWToMG5UT8+rzbpCVRc6rP9uD3tIpAzwFVxIdVgI7BjkDP1F18jHnY/CL
         E4DbsJgw7+MtUg0thm650Gm5caRLXH6bjKYfhV1QerNRIbqbNwV5IvFk+3Tmo5W3Kn
         Px2kAtbg9MDZD5xVuVQdZrBImtc3/BHVqvqAAdXkR+xlYa4p/nq4giFuies2tz5dj+
         Xj0GF0C5OsHwbnPDdDa/mWBfbEoVomvZpU9iTA7tWfZD6LtNRrDlzsIgAax25gOzEY
         Xjtbvlg6QVzWQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/14] net/mlx5: Allow skipping counter refresh on creation
Date:   Fri, 29 Oct 2021 13:56:22 -0700
Message-Id: <20211029205632.390403-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029205632.390403-1-saeed@kernel.org>
References: <20211029205632.390403-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

CT creates a counter for each CT rule, and for each such counter,
fs_counters tries to queue mlx5_fc_stats_work() work again via
mod_delayed_work(0) call to refresh all counters. This call has a
large performance impact when reaching high insertion rate and
accounts for ~8% of the insertion time when using software steering.

Allow skipping the refresh of all counters during counter creation.
Change CT to use this refresh skipping for it's counters.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  2 +-
 .../net/ethernet/mellanox/mlx5/core/fs_counters.c  | 14 +++++++++++---
 include/linux/mlx5/fs.h                            |  4 ++++
 3 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index f44e5de25037..c1c6e74c79c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -889,7 +889,7 @@ mlx5_tc_ct_counter_create(struct mlx5_tc_ct_priv *ct_priv)
 		return ERR_PTR(-ENOMEM);
 
 	counter->is_shared = false;
-	counter->counter = mlx5_fc_create(ct_priv->dev, true);
+	counter->counter = mlx5_fc_create_ex(ct_priv->dev, true);
 	if (IS_ERR(counter->counter)) {
 		ct_dbg("Failed to create counter for ct entry");
 		ret = PTR_ERR(counter->counter);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
index 60c9df1bc912..31c99d53faf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -301,7 +301,7 @@ static struct mlx5_fc *mlx5_fc_acquire(struct mlx5_core_dev *dev, bool aging)
 	return mlx5_fc_single_alloc(dev);
 }
 
-struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
+struct mlx5_fc *mlx5_fc_create_ex(struct mlx5_core_dev *dev, bool aging)
 {
 	struct mlx5_fc *counter = mlx5_fc_acquire(dev, aging);
 	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
@@ -332,8 +332,6 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
 			goto err_out_alloc;
 
 		llist_add(&counter->addlist, &fc_stats->addlist);
-
-		mod_delayed_work(fc_stats->wq, &fc_stats->work, 0);
 	}
 
 	return counter;
@@ -342,6 +340,16 @@ struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
 	mlx5_fc_release(dev, counter);
 	return ERR_PTR(err);
 }
+
+struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging)
+{
+	struct mlx5_fc *counter = mlx5_fc_create_ex(dev, aging);
+	struct mlx5_fc_stats *fc_stats = &dev->priv.fc_stats;
+
+	if (aging)
+		mod_delayed_work(fc_stats->wq, &fc_stats->work, 0);
+	return counter;
+}
 EXPORT_SYMBOL(mlx5_fc_create);
 
 u32 mlx5_fc_id(struct mlx5_fc *counter)
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index a7e1155bc4da..cd2d4c572367 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -245,6 +245,10 @@ int mlx5_modify_rule_destination(struct mlx5_flow_handle *handler,
 				 struct mlx5_flow_destination *old_dest);
 
 struct mlx5_fc *mlx5_fc_create(struct mlx5_core_dev *dev, bool aging);
+
+/* As mlx5_fc_create() but doesn't queue stats refresh thread. */
+struct mlx5_fc *mlx5_fc_create_ex(struct mlx5_core_dev *dev, bool aging);
+
 void mlx5_fc_destroy(struct mlx5_core_dev *dev, struct mlx5_fc *counter);
 u64 mlx5_fc_query_lastuse(struct mlx5_fc *counter);
 void mlx5_fc_query_cached(struct mlx5_fc *counter,
-- 
2.31.1

