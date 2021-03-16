Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE7633E25D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbhCPXv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhCPXvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29B6164F98;
        Tue, 16 Mar 2021 23:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938677;
        bh=+sDHZe0PTfUzahuSuBQE3RwH1CANH5YHA7DNGLkKuKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ocd+3r+K3eZ34RFrAOR4CPhY7ERAh89JTSraYo+j+shuoPAnQx8EbEo1rJVTRkEpr
         33aVe31avf66o18qD3kMx73vcl++yo/UW43TZIXJketviVG9ukVu/2u4cygroeDVN5
         RCMEY76AZ4w6LVPobwGRQmmV8eeFZoFskT4ROtWozVmvY5alYP0x+WSszd5gvhTnIk
         //d/x3Ph5Jc7Tp4MV71sWoINMgSFWIm+O1/N8khCvvvRYhSl4QUKoSnztaJMqqhIFR
         oFLQSdFDMk6AhlHvasT/v14wKrP9sp7t65LPtzvTZozSX2ymf5XI8eTsOKl+1wjy/x
         pB4zQyHGp+uhw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 03/15] net/mlx5e: Allow legacy vf ndos only if in legacy mode
Date:   Tue, 16 Mar 2021 16:51:00 -0700
Message-Id: <20210316235112.72626-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210316235112.72626-1-saeed@kernel.org>
References: <20210316235112.72626-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

We will re-use the native NIC port net device instance for the Uplink
representor. Several VF ndo ops are not relevant in switchdev mode.
Disallow them when eswitch mode is not legacy as a preparation.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |  7 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 ++++++++---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 34 ++++++++++++++++---
 3 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 16ce7756ac43..cf1d3c9c88af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -36,6 +36,7 @@
 #include <linux/tcp.h>
 #include <linux/mlx5/fs.h>
 #include "en.h"
+#include "en_rep.h"
 #include "lib/mpfs.h"
 
 static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
@@ -435,6 +436,9 @@ int mlx5e_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
+	if (mlx5e_is_uplink_rep(priv))
+		return 0; /* no vlan table for uplink rep */
+
 	if (be16_to_cpu(proto) == ETH_P_8021Q)
 		return mlx5e_vlan_rx_add_cvid(priv, vid);
 	else if (be16_to_cpu(proto) == ETH_P_8021AD)
@@ -447,6 +451,9 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
+	if (mlx5e_is_uplink_rep(priv))
+		return 0; /* no vlan table for uplink rep */
+
 	if (be16_to_cpu(proto) == ETH_P_8021Q) {
 		clear_bit(vid, priv->fs.vlan.active_cvlans);
 		mlx5e_del_vlan_rule(priv, MLX5E_VLAN_RULE_TYPE_MATCH_CTAG_VID, vid);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ec2fcb2a2977..efd1a23ce7a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3857,11 +3857,19 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->tx_errors = stats->tx_aborted_errors + stats->tx_carrier_errors;
 }
 
+static void mlx5e_nic_set_rx_mode(struct mlx5e_priv *priv)
+{
+	if (mlx5e_is_uplink_rep(priv))
+		return; /* no rx mode for uplink rep */
+
+	queue_work(priv->wq, &priv->set_rx_mode_work);
+}
+
 static void mlx5e_set_rx_mode(struct net_device *dev)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
-	queue_work(priv->wq, &priv->set_rx_mode_work);
+	mlx5e_nic_set_rx_mode(priv);
 }
 
 static int mlx5e_set_mac(struct net_device *netdev, void *addr)
@@ -3876,7 +3884,7 @@ static int mlx5e_set_mac(struct net_device *netdev, void *addr)
 	ether_addr_copy(netdev->dev_addr, saddr->sa_data);
 	netif_addr_unlock_bh(netdev);
 
-	queue_work(priv->wq, &priv->set_rx_mode_work);
+	mlx5e_nic_set_rx_mode(priv);
 
 	return 0;
 }
@@ -4414,6 +4422,9 @@ static int mlx5e_set_vf_link_state(struct net_device *dev, int vf,
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5_core_dev *mdev = priv->mdev;
 
+	if (mlx5e_is_uplink_rep(priv))
+		return -EOPNOTSUPP;
+
 	return mlx5_eswitch_set_vport_state(mdev->priv.eswitch, vf + 1,
 					    mlx5_ifla_link2vport(link_state));
 }
@@ -5405,7 +5416,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 		return;
 	mlx5e_dcbnl_init_app(priv);
 
-	queue_work(priv->wq, &priv->set_rx_mode_work);
+	mlx5e_nic_set_rx_mode(priv);
 
 	rtnl_lock();
 	if (netif_running(netdev))
@@ -5428,7 +5439,7 @@ static void mlx5e_nic_disable(struct mlx5e_priv *priv)
 	netif_device_detach(priv->netdev);
 	rtnl_unlock();
 
-	queue_work(priv->wq, &priv->set_rx_mode_work);
+	mlx5e_nic_set_rx_mode(priv);
 
 	mlx5e_hv_vhca_stats_destroy(priv);
 	if (mlx5e_monitor_counter_supported(priv))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fe1e06d95a12..9eb8e7a22dc2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2040,6 +2040,10 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 		vport = 0;
 	}
 	mutex_lock(&esw->state_lock);
+	if (esw->mode != MLX5_ESWITCH_LEGACY) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
 
 	err = mlx5_modify_vport_admin_state(esw->dev, opmod, vport, other_vport, link_state);
 	if (err) {
@@ -2111,7 +2115,7 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 				u16 vport, u16 vlan, u8 qos)
 {
 	u8 set_flags = 0;
-	int err;
+	int err = 0;
 
 	if (!ESW_ALLOWED(esw))
 		return -EPERM;
@@ -2120,9 +2124,18 @@ int mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
 		set_flags = SET_VLAN_STRIP | SET_VLAN_INSERT;
 
 	mutex_lock(&esw->state_lock);
+	if (esw->mode != MLX5_ESWITCH_LEGACY) {
+		if (!vlan)
+			goto unlock; /* compatibility with libvirt */
+
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
+
 	err = __mlx5_eswitch_set_vport_vlan(esw, vport, vlan, qos, set_flags);
-	mutex_unlock(&esw->state_lock);
 
+unlock:
+	mutex_unlock(&esw->state_lock);
 	return err;
 }
 
@@ -2139,6 +2152,10 @@ int mlx5_eswitch_set_vport_spoofchk(struct mlx5_eswitch *esw,
 		return PTR_ERR(evport);
 
 	mutex_lock(&esw->state_lock);
+	if (esw->mode != MLX5_ESWITCH_LEGACY) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
 	pschk = evport->info.spoofchk;
 	evport->info.spoofchk = spoofchk;
 	if (pschk && !is_valid_ether_addr(evport->info.mac))
@@ -2149,8 +2166,9 @@ int mlx5_eswitch_set_vport_spoofchk(struct mlx5_eswitch *esw,
 		err = esw_acl_ingress_lgcy_setup(esw, evport);
 	if (err)
 		evport->info.spoofchk = pschk;
-	mutex_unlock(&esw->state_lock);
 
+unlock:
+	mutex_unlock(&esw->state_lock);
 	return err;
 }
 
@@ -2271,6 +2289,7 @@ int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
 				 u16 vport, bool setting)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	int err = 0;
 
 	if (!ESW_ALLOWED(esw))
 		return -EPERM;
@@ -2278,12 +2297,17 @@ int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
 		return PTR_ERR(evport);
 
 	mutex_lock(&esw->state_lock);
+	if (esw->mode != MLX5_ESWITCH_LEGACY) {
+		err = -EOPNOTSUPP;
+		goto unlock;
+	}
 	evport->info.trusted = setting;
 	if (evport->enabled)
 		esw_vport_change_handle_locked(evport);
-	mutex_unlock(&esw->state_lock);
 
-	return 0;
+unlock:
+	mutex_unlock(&esw->state_lock);
+	return err;
 }
 
 static u32 calculate_vports_min_rate_divider(struct mlx5_eswitch *esw)
-- 
2.30.2

