Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B7635FA3E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352175AbhDNSGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:36634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352042AbhDNSGg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 58F7A6128E;
        Wed, 14 Apr 2021 18:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618423574;
        bh=e+hZtfhLjPi7byu6VEpDLUC31rlUERHUgkSCT9zJ+rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jOi3TlLFmSXd/IcAA200g9N9t/IsboJU0lHDqdEMH7jt1UPp+1yMfEVhFP+H4TcXG
         L8yvtg9wu4OjA41Z5HBUdPwdA++hJnDjNVggBpIzSt37Z2SjHw5x2sMq791OYpeZlp
         S5+if3ai9Av/gI+1cT22i5Y38V8esmlxt6RBV21xYFql9fZi7Nvk0FleSxQqYQbhE9
         Q1TPp4FR1BJgR2bDV4jTisbLTM9baImjXZK5Q0nvM/2rjT534EoR3sUokGEiVQZ0bo
         NtPGiJV+jz9lh5q6RPw6R6aPjxzXK4ho8hZ+OUJqNffJNpailtZNQaHXEQ1WWmDlz8
         pxcNyvyMk+e6w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 05/16] net/mlx5: E-Switch, Convert a macro to a helper routine
Date:   Wed, 14 Apr 2021 11:05:54 -0700
Message-Id: <20210414180605.111070-6-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414180605.111070-1-saeed@kernel.org>
References: <20210414180605.111070-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Convert ESW_ALLOWED macro to a helper routine so that it can be used in
other eswitch files.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 32 +++++++++----------
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  5 +++
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 9009574372fc..6a70e385beb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1443,8 +1443,6 @@ static void mlx5_eswitch_clear_vf_vports_info(struct mlx5_eswitch *esw)
 }
 
 /* Public E-Switch API */
-#define ESW_ALLOWED(esw) ((esw) && MLX5_ESWITCH_MANAGER((esw)->dev))
-
 int mlx5_eswitch_load_vport(struct mlx5_eswitch *esw, u16 vport_num,
 			    enum mlx5_eswitch_vport_event enabled_events)
 {
@@ -1713,7 +1711,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 {
 	int ret;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return 0;
 
 	down_write(&esw->mode_lock);
@@ -1773,7 +1771,7 @@ void mlx5_eswitch_disable_locked(struct mlx5_eswitch *esw, bool clear_vf)
 
 void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 {
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return;
 
 	down_write(&esw->mode_lock);
@@ -2023,7 +2021,7 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 	int other_vport = 1;
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
@@ -2111,7 +2109,7 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 	u8 set_flags = 0;
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 
 	if (vlan || qos)
@@ -2140,7 +2138,7 @@ int mlx5_eswitch_set_vport_spoofchk(struct mlx5_eswitch *esw,
 	bool pschk;
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
@@ -2248,7 +2246,7 @@ int mlx5_eswitch_set_vepa(struct mlx5_eswitch *esw, u8 setting)
 	if (!esw)
 		return -EOPNOTSUPP;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 
 	mutex_lock(&esw->state_lock);
@@ -2269,7 +2267,7 @@ int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting)
 	if (!esw)
 		return -EOPNOTSUPP;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 
 	if (esw->mode != MLX5_ESWITCH_LEGACY)
@@ -2285,7 +2283,7 @@ int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
@@ -2369,7 +2367,7 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
 	bool max_rate_supported;
 	int err = 0;
 
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
@@ -2534,7 +2532,7 @@ u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
-	return ESW_ALLOWED(esw) ? esw->mode : MLX5_ESWITCH_NONE;
+	return mlx5_esw_allowed(esw) ? esw->mode : MLX5_ESWITCH_NONE;
 }
 EXPORT_SYMBOL_GPL(mlx5_eswitch_mode);
 
@@ -2544,7 +2542,7 @@ mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
 	struct mlx5_eswitch *esw;
 
 	esw = dev->priv.eswitch;
-	return ESW_ALLOWED(esw) ? esw->offloads.encap :
+	return mlx5_esw_allowed(esw) ? esw->offloads.encap :
 		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
@@ -2590,7 +2588,7 @@ bool mlx5_esw_hold(struct mlx5_core_dev *mdev)
 	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 
 	/* e.g. VF doesn't have eswitch so nothing to do */
-	if (!ESW_ALLOWED(esw))
+	if (!mlx5_esw_allowed(esw))
 		return true;
 
 	if (down_read_trylock(&esw->mode_lock) != 0)
@@ -2607,7 +2605,7 @@ void mlx5_esw_release(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 
-	if (ESW_ALLOWED(esw))
+	if (mlx5_esw_allowed(esw))
 		up_read(&esw->mode_lock);
 }
 
@@ -2619,7 +2617,7 @@ void mlx5_esw_get(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 
-	if (ESW_ALLOWED(esw))
+	if (mlx5_esw_allowed(esw))
 		atomic64_inc(&esw->user_count);
 }
 
@@ -2631,7 +2629,7 @@ void mlx5_esw_put(struct mlx5_core_dev *mdev)
 {
 	struct mlx5_eswitch *esw = mdev->priv.eswitch;
 
-	if (ESW_ALLOWED(esw))
+	if (mlx5_esw_allowed(esw))
 		atomic64_dec_if_positive(&esw->user_count);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a4b9f78bf4d6..a61a33c36fa8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -521,6 +521,11 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev);
 #define esw_debug(dev, format, ...)				\
 	mlx5_core_dbg_mask(dev, MLX5_DEBUG_ESWITCH_MASK, format, ##__VA_ARGS__)
 
+static inline bool mlx5_esw_allowed(const struct mlx5_eswitch *esw)
+{
+	return esw && MLX5_ESWITCH_MANAGER(esw->dev);
+}
+
 /* The returned number is valid only when the dev is eswitch manager. */
 static inline u16 mlx5_eswitch_manager_vport(struct mlx5_core_dev *dev)
 {
-- 
2.30.2

