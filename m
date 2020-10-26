Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEFD298BC3
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 12:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1773437AbgJZLTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 07:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1773381AbgJZLTj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 07:19:39 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 788922463C;
        Mon, 26 Oct 2020 11:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603711178;
        bh=Bwf9EeRDzNlTwd3uiv9ShTYlaGrimLdvLHv/ch9Ke90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgdGoEBYFq+NorLzheAeRZQi7R/OCUUOk6TkqZLDPOPNfurTwpWq0dc91X2RRbNd8
         lF6GFidxKfoH9lTalaunBrynKDDeKStuV3+6ZXEZBYNFp3l5BJEASUmVzsrpqpc/Mi
         hfak58GBhU3mvxHsdV1D9egoLy7X2thIhk1HkeGY=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Wang <jasowang@redhat.com>, linux-rdma@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, tiwai@suse.de, broonie@kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        ranjani.sridharan@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, fred.oh@linux.intel.com,
        shiraz.saleem@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH mlx5-next 10/11] net/mlx5: Simplify eswitch mode check
Date:   Mon, 26 Oct 2020 13:18:48 +0200
Message-Id: <20201026111849.1035786-11-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026111849.1035786-1-leon@kernel.org>
References: <20201026111849.1035786-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Provide mlx5_core device instead of "priv" pointer while checking
eswith mode.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c             | 7 -------
 drivers/infiniband/hw/mlx5/ib_rep.c               | 5 -----
 drivers/infiniband/hw/mlx5/ib_rep.h               | 6 ------
 drivers/net/ethernet/mellanox/mlx5/core/dev.c     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c   | 8 +++-----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 +++-
 include/linux/mlx5/eswitch.h                      | 8 ++++++--
 9 files changed, 16 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 70c8fd67ee2f..084652e2b15a 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -138,13 +138,6 @@ static int mlx5_ib_create_counters(struct ib_counters *counters,
 }


-static bool is_mdev_switchdev_mode(const struct mlx5_core_dev *mdev)
-{
-	return MLX5_ESWITCH_MANAGER(mdev) &&
-	       mlx5_ib_eswitch_mode(mdev->priv.eswitch) ==
-		       MLX5_ESWITCH_OFFLOADS;
-}
-
 static const struct mlx5_ib_counters *get_counters(struct mlx5_ib_dev *dev,
 						   u8 port_num)
 {
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.c b/drivers/infiniband/hw/mlx5/ib_rep.c
index 0dc15757cc66..9810bdd7f3bc 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.c
+++ b/drivers/infiniband/hw/mlx5/ib_rep.c
@@ -102,11 +102,6 @@ static const struct mlx5_eswitch_rep_ops rep_ops = {
 	.get_proto_dev = mlx5_ib_vport_get_proto_dev,
 };

-u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw)
-{
-	return mlx5_eswitch_mode(esw);
-}
-
 struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
 					  u16 vport_num)
 {
diff --git a/drivers/infiniband/hw/mlx5/ib_rep.h b/drivers/infiniband/hw/mlx5/ib_rep.h
index 94bf51ddd422..93f562735e89 100644
--- a/drivers/infiniband/hw/mlx5/ib_rep.h
+++ b/drivers/infiniband/hw/mlx5/ib_rep.h
@@ -12,7 +12,6 @@
 extern const struct mlx5_ib_profile raw_eth_profile;

 #ifdef CONFIG_MLX5_ESWITCH
-u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw);
 struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
 					  u16 vport_num);
 struct mlx5_ib_dev *mlx5_ib_get_uplink_ibdev(struct mlx5_eswitch *esw);
@@ -26,11 +25,6 @@ struct mlx5_flow_handle *create_flow_rule_vport_sq(struct mlx5_ib_dev *dev,
 struct net_device *mlx5_ib_get_rep_netdev(struct mlx5_eswitch *esw,
 					  u16 vport_num);
 #else /* CONFIG_MLX5_ESWITCH */
-static inline u8 mlx5_ib_eswitch_mode(struct mlx5_eswitch *esw)
-{
-	return MLX5_ESWITCH_NONE;
-}
-
 static inline
 struct mlx5_ib_dev *mlx5_ib_get_rep_ibdev(struct mlx5_eswitch *esw,
 					  u16 vport_num)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 81803bc75066..842b6f8ae457 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -47,7 +47,7 @@ static bool is_eth_rep_supported(struct mlx5_core_dev *dev)
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		return false;

-	if (mlx5_eswitch_mode(dev->priv.eswitch) != MLX5_ESWITCH_OFFLOADS)
+	if (!is_mdev_switchdev_mode(dev))
 		return false;

 	return true;
@@ -144,7 +144,7 @@ static bool is_ib_rep_supported(struct mlx5_core_dev *dev)
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		return false;

-	if (mlx5_eswitch_mode(dev->priv.eswitch) != MLX5_ESWITCH_OFFLOADS)
+	if (!is_mdev_switchdev_mode(dev))
 		return false;

 	if (mlx5_core_mp_enabled(dev))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1a351e2f6ace..aeffb6b135ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -221,7 +221,7 @@ static int mlx5_devlink_fs_mode_validate(struct devlink *devlink, u32 id,
 		u8 eswitch_mode;
 		bool smfs_cap;

-		eswitch_mode = mlx5_eswitch_mode(dev->priv.eswitch);
+		eswitch_mode = mlx5_eswitch_mode(dev);
 		smfs_cap = mlx5_fs_dr_is_supported(dev);

 		if (!smfs_cap) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3c4f880c6329..8d65ac888a28 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3135,7 +3135,7 @@ static void mlx5e_modify_admin_state(struct mlx5_core_dev *mdev,

 	mlx5_set_port_admin_status(mdev, state);

-	if (!MLX5_ESWITCH_MANAGER(mdev) ||  mlx5_eswitch_mode(esw) == MLX5_ESWITCH_OFFLOADS)
+	if (mlx5_eswitch_mode(mdev) != MLX5_ESWITCH_LEGACY)
 		return;

 	if (state == MLX5_PORT_UP)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e3a968e9e2a0..7548bab78654 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -271,8 +271,6 @@ mlx5e_tc_match_to_reg_set(struct mlx5_core_dev *mdev,
 	return 0;
 }

-#define esw_offloads_mode(esw) (mlx5_eswitch_mode(esw) == MLX5_ESWITCH_OFFLOADS)
-
 static struct mlx5_tc_ct_priv *
 get_ct_priv(struct mlx5e_priv *priv)
 {
@@ -280,7 +278,7 @@ get_ct_priv(struct mlx5e_priv *priv)
 	struct mlx5_rep_uplink_priv *uplink_priv;
 	struct mlx5e_rep_priv *uplink_rpriv;

-	if (esw_offloads_mode(esw)) {
+	if (is_mdev_switchdev_mode(priv->mdev)) {
 		uplink_rpriv = mlx5_eswitch_get_uplink_priv(esw, REP_ETH);
 		uplink_priv = &uplink_rpriv->uplink_priv;

@@ -297,7 +295,7 @@ mlx5_tc_rule_insert(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;

-	if (esw_offloads_mode(esw))
+	if (is_mdev_switchdev_mode(priv->mdev))
 		return mlx5_eswitch_add_offloaded_rule(esw, spec, attr);

 	return	mlx5e_add_offloaded_nic_rule(priv, spec, attr);
@@ -310,7 +308,7 @@ mlx5_tc_rule_delete(struct mlx5e_priv *priv,
 {
 	struct mlx5_eswitch *esw = priv->mdev->priv.eswitch;

-	if (esw_offloads_mode(esw)) {
+	if (is_mdev_switchdev_mode(priv->mdev)) {
 		mlx5_eswitch_del_offloaded_rule(esw, rule, attr);

 		return;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b652b4bde733..b44f28fb5518 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2439,8 +2439,10 @@ int mlx5_eswitch_get_vport_stats(struct mlx5_eswitch *esw,
 	return err;
 }

-u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
+u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
 {
+	struct mlx5_eswitch *esw = dev->priv.eswitch;
+
 	return ESW_ALLOWED(esw) ? esw->mode : MLX5_ESWITCH_NONE;
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index b0ae8020f13e..29fd832950e0 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -96,10 +96,10 @@ static inline u32 mlx5_eswitch_get_vport_metadata_mask(void)

 u32 mlx5_eswitch_get_vport_metadata_for_match(struct mlx5_eswitch *esw,
 					      u16 vport_num);
-u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw);
+u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
 #else  /* CONFIG_MLX5_ESWITCH */

-static inline u8 mlx5_eswitch_mode(struct mlx5_eswitch *esw)
+static inline u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
 {
 	return MLX5_ESWITCH_NONE;
 }
@@ -136,4 +136,8 @@ mlx5_eswitch_get_vport_metadata_mask(void)
 }
 #endif /* CONFIG_MLX5_ESWITCH */

+static inline bool is_mdev_switchdev_mode(struct mlx5_core_dev *dev)
+{
+	return mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS;
+}
 #endif
--
2.26.2

