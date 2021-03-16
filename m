Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79633E268
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbhCPXvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:45684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhCPXvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EDD964F99;
        Tue, 16 Mar 2021 23:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938682;
        bh=28/sc9sVm4b/CaiFsC4kL3vtFWEW6kAgPqCgWrbzWfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjOOmYwi0oZlQMrgWNLJfYcIhic47yQgrLwtBeJPTEIQEp3VFj7L1W40H+zFT7qnh
         360Zz8kd9RhA9JL0vQTsx2JCjlxKVCmClbOUE0Oqgrt2au8zS0NCgnBroSACdKgCUP
         J537wfrWsc/Vg9lXiWTxRYyBh3iDlBKaFsxCzDoiWp0a97r55ilGOzUwsPvG6gMDlt
         yeQOKDyno+oJUKBYCZ4Rrwfv0UAF7jsNDUi61iLPTj8077TJZX02bSehVIQSmjXq+n
         0niM+Oh8MIef9cx8jfgLXSpUBiPe0hJX8qJaDwmvqaWIZdH0WnkeSMjghBnQAvaTuE
         Kn0qfl3LHB14w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 14/15] net/mlx5: E-Switch, Change mode lock from mutex to rw semaphore
Date:   Tue, 16 Mar 2021 16:51:11 -0700
Message-Id: <20210316235112.72626-15-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

E-Switch mode change routine will take the write lock to prevent any
consumer to access the E-Switch resources while E-Switch is going
through a mode change.

In the next patch
E-Switch consumers (e.g vport representors) will take read_lock prior to
accessing E-Switch resources to prevent E-Switch mode changing in the
middle of the operation.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 26 +++++++++----------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9eb8e7a22dc2..ddee2aefe8b9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1720,7 +1720,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 	if (!ESW_ALLOWED(esw))
 		return 0;
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	if (esw->mode == MLX5_ESWITCH_NONE) {
 		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
 	} else {
@@ -1732,7 +1732,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 		if (!ret)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return ret;
 }
 
@@ -1780,10 +1780,10 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 	if (!ESW_ALLOWED(esw))
 		return;
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw, clear_vf);
 	esw->esw_funcs.num_vfs = 0;
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 }
 
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
@@ -1840,7 +1840,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	ida_init(&esw->offloads.vport_metadata_ida);
 	xa_init_flags(&esw->offloads.vhca_map, XA_FLAGS_ALLOC);
 	mutex_init(&esw->state_lock);
-	mutex_init(&esw->mode_lock);
+	init_rwsem(&esw->mode_lock);
 
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		vport->vport = mlx5_eswitch_index_to_vport_num(esw, i);
@@ -1876,7 +1876,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
-	mutex_destroy(&esw->mode_lock);
 	mutex_destroy(&esw->state_lock);
 	WARN_ON(!xa_empty(&esw->offloads.vhca_map));
 	xa_destroy(&esw->offloads.vhca_map);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index d0b907a9ef28..b149d1d2c150 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -271,7 +271,7 @@ struct mlx5_eswitch {
 	/* Protects eswitch mode change that occurs via one or more
 	 * user commands, i.e. sriov state change, devlink commands.
 	 */
-	struct mutex mode_lock;
+	struct rw_semaphore mode_lock;
 
 	struct {
 		bool            enabled;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index e1e33e991123..5e2712521fec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2925,7 +2925,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	cur_mlx5_mode = esw->mode;
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
@@ -2938,7 +2938,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = -EINVAL;
 
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2951,14 +2951,14 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	err = esw_mode_to_devlink(esw->mode, mode);
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2974,7 +2974,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto out;
@@ -3013,7 +3013,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	}
 
 	esw->offloads.inline_mode = mlx5_mode;
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return 0;
 
 revert_inline_mode:
@@ -3023,7 +3023,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 						 vport,
 						 esw->offloads.inline_mode);
 out:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3036,14 +3036,14 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3059,7 +3059,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
@@ -3105,7 +3105,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	}
 
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -3120,14 +3120,14 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 		return PTR_ERR(esw);
 
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	*encap = esw->offloads.encap;
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return 0;
 }
 
-- 
2.30.2

