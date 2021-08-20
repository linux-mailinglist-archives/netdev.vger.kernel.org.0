Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D263F2621
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 06:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbhHTE4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 00:56:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234401AbhHTE4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 00:56:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C6A6108F;
        Fri, 20 Aug 2021 04:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629435329;
        bh=VIA0FNa+bfIh13GqoiFe9Ap6sZngV2/Rut+WKJKoyR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KCCBwhQ0+/GSF/f9udkwGudaItEYq+Pcn9FMvc83ybzF+bm1T1F6numNU0LrUdcd9
         E7jkaICkI7QpQzPjPki9U4qGpBLfLl5vwBhlolRL3XX2k0EPtKTNcW2IZZLvXtheUA
         3gcxoVkUqcIm5LKmPRQ9jF3mjzldJ/DD0cY952aDo2Z7GsfL8IjvVMUbBeIVJ+6z19
         EsJqn4TnINV7Lqpt2GMp/8stUks5F8wjfeMX/1ch8qZT7VTgfmVDFsExZ7Uombh+QM
         t7LT4At4sIw26+GJ+KvFtikEkHXpQUFs1Mrc8V1iTX43cEpzD+SoKfyS6tGj4zVo3u
         rmEo8EJLyDVVw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, Huy Nguyen <huyn@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 11/15] net/mlx5: E-switch, Enable devlink port tx_{share|max} rate control
Date:   Thu, 19 Aug 2021 21:55:11 -0700
Message-Id: <20210820045515.265297-12-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210820045515.265297-1-saeed@kernel.org>
References: <20210820045515.265297-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

Register devlink rate leaf object for every eswitch vport.
Implement devlink ops that enable setting shared and max tx rates
through devlink API.
Extract common eswitch code from existing tx rate set function that is
accessed through NDO to be reused for the devlink. Values configured
with NDO API are not visible for the devlink API, therefore shouldn't be
used simultaneously.

When normalizing the BW share value, dividing the desired minimum rate
by the common divider results in losing information since the quotient
is rounded down. This has a significant affect on configurations of low
rate where the round down eliminates a large percentage of the total
rate. To improve the formula, round up the division result to make sure
that the BW share is at least the value it was supposed to be and won't
lost a significant amount of the expected value.

Co-developed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   3 +
 .../mellanox/mlx5/core/esw/devlink_port.c     |  22 +++
 .../ethernet/mellanox/mlx5/core/esw/legacy.c  |   4 +-
 .../net/ethernet/mellanox/mlx5/core/esw/qos.c | 141 +++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/esw/qos.h |  14 +-
 5 files changed, 157 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 6f4d7c7f06e0..f4cd2573d4ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -7,6 +7,7 @@
 #include "fw_reset.h"
 #include "fs_core.h"
 #include "eswitch.h"
+#include "esw/qos.h"
 #include "sf/dev/dev.h"
 #include "sf/sf.h"
 
@@ -292,6 +293,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
 	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
+	.rate_leaf_tx_share_set = mlx5_esw_devlink_rate_leaf_tx_share_set,
+	.rate_leaf_tx_max_set = mlx5_esw_devlink_rate_leaf_tx_max_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
index 1703384eca95..bbfc498cb3dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/devlink_port.c
@@ -91,9 +91,15 @@ int mlx5_esw_offloads_devlink_port_register(struct mlx5_eswitch *esw, u16 vport_
 	if (err)
 		goto reg_err;
 
+	err = devlink_rate_leaf_create(dl_port, vport);
+	if (err)
+		goto rate_err;
+
 	vport->dl_port = dl_port;
 	return 0;
 
+rate_err:
+	devlink_port_unregister(dl_port);
 reg_err:
 	mlx5_esw_dl_port_free(dl_port);
 	return err;
@@ -109,6 +115,10 @@ void mlx5_esw_offloads_devlink_port_unregister(struct mlx5_eswitch *esw, u16 vpo
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
 	if (IS_ERR(vport))
 		return;
+
+	if (vport->dl_port->devlink_rate)
+		devlink_rate_leaf_destroy(vport->dl_port);
+
 	devlink_port_unregister(vport->dl_port);
 	mlx5_esw_dl_port_free(vport->dl_port);
 	vport->dl_port = NULL;
@@ -148,8 +158,16 @@ int mlx5_esw_devlink_sf_port_register(struct mlx5_eswitch *esw, struct devlink_p
 	if (err)
 		return err;
 
+	err = devlink_rate_leaf_create(dl_port, vport);
+	if (err)
+		goto rate_err;
+
 	vport->dl_port = dl_port;
 	return 0;
+
+rate_err:
+	devlink_port_unregister(dl_port);
+	return err;
 }
 
 void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num)
@@ -159,6 +177,10 @@ void mlx5_esw_devlink_sf_port_unregister(struct mlx5_eswitch *esw, u16 vport_num
 	vport = mlx5_eswitch_get_vport(esw, vport_num);
 	if (IS_ERR(vport))
 		return;
+
+	if (vport->dl_port->devlink_rate)
+		devlink_rate_leaf_destroy(vport->dl_port);
+
 	devlink_port_unregister(vport->dl_port);
 	vport->dl_port = NULL;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 2b52f7c09152..df277a6cddc0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -522,7 +522,9 @@ int mlx5_eswitch_set_vport_rate(struct mlx5_eswitch *esw, u16 vport,
 		return PTR_ERR(evport);
 
 	mutex_lock(&esw->state_lock);
-	err = mlx5_esw_qos_set_vport_rate(esw, evport, max_rate, min_rate);
+	err = mlx5_esw_qos_set_vport_min_rate(esw, evport, min_rate, NULL);
+	if (!err)
+		err = mlx5_esw_qos_set_vport_max_rate(esw, evport, max_rate, NULL);
 	mutex_unlock(&esw->state_lock);
 	return err;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 7f4a8a927115..fcdcddf4a710 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -3,16 +3,18 @@
 
 #include "eswitch.h"
 #include "esw/qos.h"
+#include "en/port.h"
 
 /* Minimum supported BW share value by the HW is 1 Mbit/sec */
 #define MLX5_MIN_BW_SHARE 1
 
 #define MLX5_RATE_TO_BW_SHARE(rate, divider, limit) \
-	min_t(u32, max_t(u32, (rate) / (divider), MLX5_MIN_BW_SHARE), limit)
+	min_t(u32, max_t(u32, DIV_ROUND_UP(rate, divider), MLX5_MIN_BW_SHARE), limit)
 
 static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 				struct mlx5_vport *vport,
-				u32 max_rate, u32 bw_share)
+				u32 max_rate, u32 bw_share,
+				struct netlink_ext_ack *extack)
 {
 	u32 sched_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_core_dev *dev = esw->dev;
@@ -45,6 +47,7 @@ static int esw_qos_vport_config(struct mlx5_eswitch *esw,
 	if (err) {
 		esw_warn(esw->dev, "E-Switch modify TSAR vport element failed (vport=%d,err=%d)\n",
 			 vport->vport, err);
+		NL_SET_ERR_MSG_MOD(extack, "E-Switch modify TSAR vport element failed");
 		return err;
 	}
 
@@ -69,7 +72,8 @@ static u32 calculate_vports_min_rate_divider(struct mlx5_eswitch *esw)
 	return 0;
 }
 
-static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
+static int
+esw_qos_normalize_vports_min_rate(struct mlx5_eswitch *esw, struct netlink_ext_ack *extack)
 {
 	u32 fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
 	u32 divider = calculate_vports_min_rate_divider(esw);
@@ -95,8 +99,7 @@ static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
 		if (bw_share == evport->qos.bw_share)
 			continue;
 
-		err = esw_qos_vport_config(esw, evport, vport_max_rate,
-					   bw_share);
+		err = esw_qos_vport_config(esw, evport, vport_max_rate, bw_share, extack);
 		if (!err)
 			evport->qos.bw_share = bw_share;
 		else
@@ -106,42 +109,50 @@ static int normalize_vports_min_rate(struct mlx5_eswitch *esw)
 	return 0;
 }
 
-int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
-				u32 max_rate, u32 min_rate)
+int mlx5_esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *evport,
+				    u32 min_rate,
+				    struct netlink_ext_ack *extack)
 {
+	u32 fw_max_bw_share, previous_min_rate;
 	bool min_rate_supported;
-	bool max_rate_supported;
-	u32 previous_min_rate;
-	u32 fw_max_bw_share;
 	int err;
 
+	lockdep_assert_held(&esw->state_lock);
 	fw_max_bw_share = MLX5_CAP_QOS(esw->dev, max_tsar_bw_share);
 	min_rate_supported = MLX5_CAP_QOS(esw->dev, esw_bw_share) &&
 				fw_max_bw_share >= MLX5_MIN_BW_SHARE;
-	max_rate_supported = MLX5_CAP_QOS(esw->dev, esw_rate_limit);
-
-	if (!esw->qos.enabled || !evport->enabled || !evport->qos.enabled)
+	if (min_rate && !min_rate_supported)
 		return -EOPNOTSUPP;
-
-	if ((min_rate && !min_rate_supported) || (max_rate && !max_rate_supported))
-		return -EOPNOTSUPP;
-
 	if (min_rate == evport->qos.min_rate)
-		goto set_max_rate;
+		return 0;
 
 	previous_min_rate = evport->qos.min_rate;
 	evport->qos.min_rate = min_rate;
-	err = normalize_vports_min_rate(esw);
-	if (err) {
+	err = esw_qos_normalize_vports_min_rate(esw, extack);
+	if (err)
 		evport->qos.min_rate = previous_min_rate;
-		return err;
-	}
 
-set_max_rate:
+	return err;
+}
+
+int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *evport,
+				    u32 max_rate,
+				    struct netlink_ext_ack *extack)
+{
+	bool max_rate_supported;
+	int err;
+
+	lockdep_assert_held(&esw->state_lock);
+	max_rate_supported = MLX5_CAP_QOS(esw->dev, esw_rate_limit);
+
+	if (max_rate && !max_rate_supported)
+		return -EOPNOTSUPP;
 	if (max_rate == evport->qos.max_rate)
 		return 0;
 
-	err = esw_qos_vport_config(esw, evport, max_rate, evport->qos.bw_share);
+	err = esw_qos_vport_config(esw, evport, max_rate, evport->qos.bw_share, extack);
 	if (!err)
 		evport->qos.max_rate = max_rate;
 
@@ -293,3 +304,85 @@ int mlx5_esw_qos_modify_vport_rate(struct mlx5_eswitch *esw, u16 vport_num, u32
 						  vport->qos.esw_tsar_ix,
 						  bitmask);
 }
+
+#define MLX5_LINKSPEED_UNIT 125000 /* 1Mbps in Bps */
+
+/* Converts bytes per second value passed in a pointer into megabits per
+ * second, rewriting last. If converted rate exceed link speed or is not a
+ * fraction of Mbps - returns error.
+ */
+static int esw_qos_devlink_rate_to_mbps(struct mlx5_core_dev *mdev, const char *name,
+					u64 *rate, struct netlink_ext_ack *extack)
+{
+	u32 link_speed_max, reminder;
+	u64 value;
+	int err;
+
+	err = mlx5e_port_max_linkspeed(mdev, &link_speed_max);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed to get link maximum speed");
+		return err;
+	}
+
+	value = div_u64_rem(*rate, MLX5_LINKSPEED_UNIT, &reminder);
+	if (reminder) {
+		pr_err("%s rate value %lluBps not in link speed units of 1Mbps.\n",
+		       name, *rate);
+		NL_SET_ERR_MSG_MOD(extack, "TX rate value not in link speed units of 1Mbps");
+		return -EINVAL;
+	}
+
+	if (value > link_speed_max) {
+		pr_err("%s rate value %lluMbps exceed link maximum speed %u.\n",
+		       name, value, link_speed_max);
+		NL_SET_ERR_MSG_MOD(extack, "TX rate value exceed link maximum speed");
+		return -EINVAL;
+	}
+
+	*rate = value;
+	return 0;
+}
+
+/* Eswitch devlink rate API */
+
+int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
+					    u64 tx_share, struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = priv;
+	struct mlx5_eswitch *esw;
+	int err;
+
+	esw = vport->dev->priv.eswitch;
+	if (!mlx5_esw_allowed(esw))
+		return -EPERM;
+
+	err = esw_qos_devlink_rate_to_mbps(vport->dev, "tx_share", &tx_share, extack);
+	if (err)
+		return err;
+
+	mutex_lock(&esw->state_lock);
+	err = mlx5_esw_qos_set_vport_min_rate(esw, vport, tx_share, extack);
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
+					  u64 tx_max, struct netlink_ext_ack *extack)
+{
+	struct mlx5_vport *vport = priv;
+	struct mlx5_eswitch *esw;
+	int err;
+
+	esw = vport->dev->priv.eswitch;
+	if (!mlx5_esw_allowed(esw))
+		return -EPERM;
+
+	err = esw_qos_devlink_rate_to_mbps(vport->dev, "tx_max", &tx_max, extack);
+	if (err)
+		return err;
+
+	mutex_lock(&esw->state_lock);
+	err = mlx5_esw_qos_set_vport_max_rate(esw, vport, tx_max, extack);
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
index 7329405282ad..507c7e017834 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.h
@@ -6,14 +6,24 @@
 
 #ifdef CONFIG_MLX5_ESWITCH
 
-int mlx5_esw_qos_set_vport_rate(struct mlx5_eswitch *esw, struct mlx5_vport *evport,
-				u32 max_rate, u32 min_rate);
+int mlx5_esw_qos_set_vport_min_rate(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *evport,
+				    u32 min_rate,
+				    struct netlink_ext_ack *extack);
+int mlx5_esw_qos_set_vport_max_rate(struct mlx5_eswitch *esw,
+				    struct mlx5_vport *evport,
+				    u32 max_rate,
+				    struct netlink_ext_ack *extack);
 void mlx5_esw_qos_create(struct mlx5_eswitch *esw);
 void mlx5_esw_qos_destroy(struct mlx5_eswitch *esw);
 int mlx5_esw_qos_vport_enable(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 			      u32 max_rate, u32 bw_share);
 void mlx5_esw_qos_vport_disable(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
 
+int mlx5_esw_devlink_rate_leaf_tx_share_set(struct devlink_rate *rate_leaf, void *priv,
+					    u64 tx_share, struct netlink_ext_ack *extack);
+int mlx5_esw_devlink_rate_leaf_tx_max_set(struct devlink_rate *rate_leaf, void *priv,
+					  u64 tx_max, struct netlink_ext_ack *extack);
 #endif
 
 #endif
-- 
2.31.1

