Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4547403040
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348148AbhIGVZt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 17:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347975AbhIGVZh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 17:25:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C302161102;
        Tue,  7 Sep 2021 21:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631049871;
        bh=Jwk1LNzAVlL/9CyoU3tfZPH2fIplD/6bGF2mPYtfIWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KEMeUjtwTuLJ6r6nf9p63fl0+Cvb2y8R4H9/a4ssbloHoUP6FZerUw8U8U6asAypp
         clVUM+Z7h1IeecYjdpmnf0JIlw/nxAnViu6SBOVnugZMv6XEpXa1GCDox9FD91MwHh
         R2PtzJSBQdIfvdnOMm6WhNefClSaF6SqKxDg+HfYsev/sTxpyVbX1Ltm/5m7vFI065
         rvXAfCg6eQB4Po9h+cTshWkknYnyVyqHYQYmeFe920hR7tPl78lRov3Dzr+Aiqajz5
         8saG4iIUb5CxLqsjCb+EXFr9tNhlHXUst01nUKMEcHBs5H0ZWnS6MgrHf3Fcc0eH4Q
         VBu0QvSXgvrYw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/7] net/mlx5e: Fix mutual exclusion between CQE compression and HW TS
Date:   Tue,  7 Sep 2021 14:24:19 -0700
Message-Id: <20210907212420.28529-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210907212420.28529-1-saeed@kernel.org>
References: <20210907212420.28529-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Some profiles of the driver don't support a dedicated PTP-RQ, hence can't
support HW TS and CQE compression simultaneously. When HW TS is enabled
the COE compression is disabled, and should be restored when the HW TS
is turned off. Add rx_filter as an input to modifying CQE compression to
enforce this restriction.

Fixes: 256f79d13c1d ("net/mlx5e: Fix HW TS with CQE compression according to profile")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 11 ++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  4 ++--
 3 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 669a75f3537a..7b8c8187543a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -922,7 +922,7 @@ void mlx5e_set_rx_mode_work(struct work_struct *work);
 
 int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr);
 int mlx5e_hwstamp_get(struct mlx5e_priv *priv, struct ifreq *ifr);
-int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool val);
+int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool val, bool rx_filter);
 
 int mlx5e_vlan_rx_add_vid(struct net_device *dev, __always_unused __be16 proto,
 			  u16 vid);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 2cfd12953909..306fb5d6a36d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1884,7 +1884,7 @@ static int set_pflag_rx_cqe_based_moder(struct net_device *netdev, bool enable)
 	return set_pflag_cqe_based_moder(netdev, enable, true);
 }
 
-int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val)
+int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val, bool rx_filter)
 {
 	bool curr_val = MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS);
 	struct mlx5e_params new_params;
@@ -1896,8 +1896,7 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (curr_val == new_val)
 		return 0;
 
-	if (new_val && !priv->profile->rx_ptp_support &&
-	    priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE) {
+	if (new_val && !priv->profile->rx_ptp_support && rx_filter) {
 		netdev_err(priv->netdev,
 			   "Profile doesn't support enabling of CQE compression while hardware time-stamping is enabled.\n");
 		return -EINVAL;
@@ -1905,7 +1904,7 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 
 	new_params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
-	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
+	if (rx_filter)
 		new_params.ptp_rx = new_val;
 
 	if (new_params.ptp_rx == priv->channels.params.ptp_rx)
@@ -1928,12 +1927,14 @@ static int set_pflag_rx_cqe_compress(struct net_device *netdev,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5_core_dev *mdev = priv->mdev;
+	bool rx_filter;
 	int err;
 
 	if (!MLX5_CAP_GEN(mdev, cqe_compression))
 		return -EOPNOTSUPP;
 
-	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable);
+	rx_filter = priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE;
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, enable, rx_filter);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47efd858964d..3fd515e7bf30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3554,14 +3554,14 @@ static int mlx5e_hwstamp_config_no_ptp_rx(struct mlx5e_priv *priv, bool rx_filte
 
 	if (!rx_filter)
 		/* Reset CQE compression to Admin default */
-		return mlx5e_modify_rx_cqe_compression_locked(priv, rx_cqe_compress_def);
+		return mlx5e_modify_rx_cqe_compression_locked(priv, rx_cqe_compress_def, false);
 
 	if (!MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
 		return 0;
 
 	/* Disable CQE compression */
 	netdev_warn(priv->netdev, "Disabling RX cqe compression\n");
-	err = mlx5e_modify_rx_cqe_compression_locked(priv, false);
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, false, true);
 	if (err)
 		netdev_err(priv->netdev, "Failed disabling cqe compression err=%d\n", err);
 
-- 
2.31.1

