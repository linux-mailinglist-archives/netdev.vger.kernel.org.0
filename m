Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39CC8388742
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 08:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238336AbhESGH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 02:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235421AbhESGHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 02:07:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C67561355;
        Wed, 19 May 2021 06:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621404365;
        bh=Zv+MC0W4ByIfV3o6GH5Pc1NJFrnXy9SVWJbZlX3G8SM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUhqxAJwUNheyLO+KJc5f2Og0RsA7PyDthW4x8RJSNJtFlLSNarA9UpIf9gSsRbc8
         9kfJwz9YalUmqa9iZqdrzVp9gBtIJMmX6M9e5Cr/oAJlEv4/V7Fayh8DMGZJDUx0gQ
         zebx1+NFzTxLDB2VCtSHOs/xcKTO9QCFXMTF+2rKgR3ExzW78KS0GRmo97pDkxlQWf
         5ysGffnXDQ+uJxfqrH6MUKj1xAq9WAfFJFRwi+Por7KWg3JqYRfsz4ppekS2aiZilI
         iI+EqUF00jTzeQvVhVN+reiaEAwysIk+TMAhpThIZmytHhibpuGpbIfwyYk6QQ19fw
         b+6JwQgRHMqmA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 01/16] {net, RDMA}/mlx5: Fix override of log_max_qp by other device
Date:   Tue, 18 May 2021 23:05:08 -0700
Message-Id: <20210519060523.17875-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519060523.17875-1-saeed@kernel.org>
References: <20210519060523.17875-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

mlx5_core_dev holds pointer to static profile, hence when the
log_max_qp of the profile is override by some device, then it
effect all other mlx5 devices that share the same profile.
Fix it by having a profile instance for every mlx5 device.

Fixes: 883371c453b9 ("net/mlx5: Check FW limitations on log_max_qp before setting it")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mr.c               |  4 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 11 +++--
 include/linux/mlx5/driver.h                   | 44 +++++++++----------
 3 files changed, 29 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 4388afeff251..9662cd39c7ff 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -743,10 +743,10 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		ent->xlt = (1 << ent->order) * sizeof(struct mlx5_mtt) /
 			   MLX5_IB_UMR_OCTOWORD;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
-		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
+		if ((dev->mdev->profile.mask & MLX5_PROF_MASK_MR_CACHE) &&
 		    !dev->is_rep && mlx5_core_is_pf(dev->mdev) &&
 		    mlx5_ib_can_load_pas_with_umr(dev, 0))
-			ent->limit = dev->mdev->profile->mr_cache[i].limit;
+			ent->limit = dev->mdev->profile.mr_cache[i].limit;
 		else
 			ent->limit = 0;
 		spin_lock_irq(&ent->lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index c114365eb126..a1d67bd7fb43 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -503,7 +503,7 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
-	struct mlx5_profile *prof = dev->profile;
+	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
 	int err;
 
@@ -524,11 +524,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 		 to_fw_pkey_sz(dev, 128));
 
 	/* Check log_max_qp from HCA caps to set in current profile */
-	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < profile[prof_sel].log_max_qp) {
+	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
-			       profile[prof_sel].log_max_qp,
+			       prof->log_max_qp,
 			       MLX5_CAP_GEN_MAX(dev, log_max_qp));
-		profile[prof_sel].log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
 	}
 	if (prof->mask & MLX5_PROF_MASK_QP_SIZE)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_qp,
@@ -1381,8 +1381,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	struct mlx5_priv *priv = &dev->priv;
 	int err;
 
-	dev->profile = &profile[profile_idx];
-
+	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
 	INIT_LIST_HEAD(&priv->ctx_list);
 	spin_lock_init(&priv->ctx_lock);
 	mutex_init(&dev->intf_state_mutex);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index f8e8d7e90616..020a8f7fdbdd 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -703,6 +703,27 @@ struct mlx5_hv_vhca;
 #define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev) (MLX5_CAP_DEV_MEM(dev, log_sw_icm_alloc_granularity))
 #define MLX5_SW_ICM_BLOCK_SIZE(dev) (1 << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
 
+enum {
+	MLX5_PROF_MASK_QP_SIZE		= (u64)1 << 0,
+	MLX5_PROF_MASK_MR_CACHE		= (u64)1 << 1,
+};
+
+enum {
+	MR_CACHE_LAST_STD_ENTRY = 20,
+	MLX5_IMR_MTT_CACHE_ENTRY,
+	MLX5_IMR_KSM_CACHE_ENTRY,
+	MAX_MR_CACHE_ENTRIES
+};
+
+struct mlx5_profile {
+	u64	mask;
+	u8	log_max_qp;
+	struct {
+		int	size;
+		int	limit;
+	} mr_cache[MAX_MR_CACHE_ENTRIES];
+};
+
 struct mlx5_core_dev {
 	struct device *device;
 	enum mlx5_coredev_type coredev_type;
@@ -731,7 +752,7 @@ struct mlx5_core_dev {
 	struct mutex		intf_state_mutex;
 	unsigned long		intf_state;
 	struct mlx5_priv	priv;
-	struct mlx5_profile	*profile;
+	struct mlx5_profile	profile;
 	u32			issi;
 	struct mlx5e_resources  mlx5e_res;
 	struct mlx5_dm          *dm;
@@ -1083,18 +1104,6 @@ static inline u8 mlx5_mkey_variant(u32 mkey)
 	return mkey & 0xff;
 }
 
-enum {
-	MLX5_PROF_MASK_QP_SIZE		= (u64)1 << 0,
-	MLX5_PROF_MASK_MR_CACHE		= (u64)1 << 1,
-};
-
-enum {
-	MR_CACHE_LAST_STD_ENTRY = 20,
-	MLX5_IMR_MTT_CACHE_ENTRY,
-	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MR_CACHE_ENTRIES
-};
-
 /* Async-atomic event notifier used by mlx5 core to forward FW
  * evetns recived from event queue to mlx5 consumers.
  * Optimise event queue dipatching.
@@ -1148,15 +1157,6 @@ int mlx5_rdma_rn_get_params(struct mlx5_core_dev *mdev,
 			    struct ib_device *device,
 			    struct rdma_netdev_alloc_params *params);
 
-struct mlx5_profile {
-	u64	mask;
-	u8	log_max_qp;
-	struct {
-		int	size;
-		int	limit;
-	} mr_cache[MAX_MR_CACHE_ENTRIES];
-};
-
 enum {
 	MLX5_PCI_DEV_IS_VF		= 1 << 0,
 };
-- 
2.31.1

