Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85A633E263
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCPXvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:51:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229574AbhCPXvT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 19:51:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F382564F18;
        Tue, 16 Mar 2021 23:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615938679;
        bh=XrBoUXY0YbdHWzWjjyOf39u9XKkh71ZSAV37G2x7FZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGhaSGsn9ejjbNyulJ4/lflQVUJ5nbyVqgznPVtA2ORquQMbEezq+ZLDD+vMHjBwP
         j6n/vdhZV0RErKaVfFniVZl8Gu7zg4iBCmWxPPhehL3wxRqiZwOPWPg5iWgdBeU2pV
         d1NQdRCrBys/D5oT15QYnwoVhdOOd44RRIgFXvkNBBx+LnmkQEcaGZRIxee/tl0eJq
         +bSJiUNOH/YE/Ij9zEOLkXQ+qMjmjEnxiyw3IeLTcEw8lsaEklJt/eCwpA6mHji4JY
         QbSeP228PG2b42KIOVeAkfzbTsE9Scnuj6ePtPcrX9lmvW4ByH8Rw7bCdir09LwQoK
         33Zx9xKmVHplQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Verify dev is present in some ndos
Date:   Tue, 16 Mar 2021 16:51:04 -0700
Message-Id: <20210316235112.72626-8-saeed@kernel.org>
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
representor. While changing profiles private resources are not
available but some ndos are not checking if the netdev is present.
So for those ndos check the netdev is present in the driver before
accessing the private resources.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c |  6 ++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c   | 17 +++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |  3 +++
 3 files changed, 26 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index fcae3c0a4e9f..11a44d30adc7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -169,6 +169,9 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 	unsigned long flags = MLX5_TC_FLAG(INGRESS) | MLX5_TC_FLAG(ESW_OFFLOAD);
 	struct mlx5e_priv *priv = cb_priv;
 
+	if (!priv->netdev || !netif_device_present(priv->netdev))
+		return -EOPNOTSUPP;
+
 	switch (type) {
 	case TC_SETUP_CLSFLOWER:
 		return mlx5e_rep_setup_tc_cls_flower(priv, type_data, flags);
@@ -321,6 +324,9 @@ mlx5e_rep_indr_offload(struct net_device *netdev,
 	struct mlx5e_priv *priv = netdev_priv(indr_priv->rpriv->netdev);
 	int err = 0;
 
+	if (!netif_device_present(indr_priv->rpriv->netdev))
+		return -EOPNOTSUPP;
+
 	switch (flower->command) {
 	case FLOW_CLS_REPLACE:
 		err = mlx5e_configure_flower(netdev, priv, flower, flags);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 39de3156877c..efe8af49b908 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3769,8 +3769,16 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
+	bool tc_unbind = false;
 	int err;
 
+	if (type == TC_SETUP_BLOCK &&
+	    ((struct flow_block_offload *)type_data)->command == FLOW_BLOCK_UNBIND)
+		tc_unbind = true;
+
+	if (!netif_device_present(dev) && !tc_unbind)
+		return -ENODEV;
+
 	switch (type) {
 	case TC_SETUP_BLOCK: {
 		struct flow_block_offload *f = type_data;
@@ -3823,6 +3831,9 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	struct mlx5e_priv *priv = netdev_priv(dev);
 	struct mlx5e_pport_stats *pstats = &priv->stats.pport;
 
+	if (!netif_device_present(dev))
+		return;
+
 	/* In switchdev mode, monitor counters doesn't monitor
 	 * rx/tx stats of 802_3. The update stats mechanism
 	 * should keep the 802_3 layout counters updated
@@ -4436,6 +4447,9 @@ int mlx5e_get_vf_config(struct net_device *dev,
 	struct mlx5_core_dev *mdev = priv->mdev;
 	int err;
 
+	if (!netif_device_present(dev))
+		return -EOPNOTSUPP;
+
 	err = mlx5_eswitch_get_vport_config(mdev->priv.eswitch, vf + 1, ivi);
 	if (err)
 		return err;
@@ -4458,6 +4472,9 @@ mlx5e_has_offload_stats(const struct net_device *dev, int attr_id)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
 
+	if (!netif_device_present(dev))
+		return false;
+
 	if (!mlx5e_is_uplink_rep(priv))
 		return false;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 8a3b2d76cc82..b3bf7bb7b97e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4895,6 +4895,9 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	unsigned long flags = MLX5_TC_FLAG(INGRESS);
 	struct mlx5e_priv *priv = cb_priv;
 
+	if (!priv->netdev || !netif_device_present(priv->netdev))
+		return -EOPNOTSUPP;
+
 	if (mlx5e_is_uplink_rep(priv))
 		flags |= MLX5_TC_FLAG(ESW_OFFLOAD);
 	else
-- 
2.30.2

