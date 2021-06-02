Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA50B397E21
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhFBBjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhFBBjQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C5B7613B4;
        Wed,  2 Jun 2021 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597854;
        bh=y1Z8HA5h4EiXZ/r0BN4CLBKRS5iIsIwNfOeVzwyb2iw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VP9IW4WpN3jA2L0JVlXaggmtXkGI1QoJR05Gq52EVIMtyfqH/N5UpDP6W0CL4xKWN
         HuAXTs3eZ29MkcZ+wCkG22FYodzhBH+wLvaZh9vMRvPq+KyW2tQEBxx/ScXNz5Wmf7
         JDjwuWu5l9LI3HbxYZNv6UukQDrJwxNr1t80lnkqlEGoslXwuQUeIJpr3pS58+z21+
         UixOhHFBADCrI81k8xM+rV4rRScCN0+oaOm4D2bdGRX8kZgZMTvOhGMmcsZr2+TYpW
         wv6HPbCqDCMjFKqV81CEq6W0oIKGjIdI1ew3+vMP25MCnoecWG/5YTlSeyJC+fvnCn
         sBJjbRZ3wGqzQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 6/8] net/mlx5e: Fix HW TS with CQE compression according to profile
Date:   Tue,  1 Jun 2021 18:37:21 -0700
Message-Id: <20210602013723.1142650-7-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When the driver's profile doesn't support a dedicated PTP-RQ, the PTP
accuracy of HW TS is affected by the CQE compression. In this case,
turn off CQE compression. Otherwise, the driver crashes:

BUG: kernel NULL pointer dereference, address:0000000000000018
...
...
RIP: 0010:mlx5e_ptp_rx_set_fs+0x25/0x1a0 [mlx5_core]
...
...
Call Trace:
 mlx5e_ptp_activate_channel+0xb2/0xf0 [mlx5_core]
 mlx5e_activate_priv_channels+0x3b9/0x8c0 [mlx5_core]
 ? __mutex_unlock_slowpath+0x45/0x2a0
 ? mlx5e_refresh_tirs+0x151/0x1e0 [mlx5_core]
 mlx5e_switch_priv_channels+0x1cd/0x2d0 [mlx5_core]
 ? mlx5e_xdp_allowed+0x150/0x150 [mlx5_core]
 mlx5e_safe_switch_params+0x118/0x3c0 [mlx5_core]
 ? __mutex_lock+0x6e/0x8e0
 ? mlx5e_hwstamp_set+0xa9/0x300 [mlx5_core]
 mlx5e_hwstamp_set+0x194/0x300 [mlx5_core]
 ? dev_ioctl+0x9b/0x3d0
 mlx5i_ioctl+0x37/0x60 [mlx5_core]
 mlx5i_pkey_ioctl+0x12/0x20 [mlx5_core]
 dev_ioctl+0xa9/0x3d0
 sock_ioctl+0x268/0x420
 __x64_sys_ioctl+0x3d8/0x790
 ? lockdep_hardirqs_on_prepare+0xe4/0x190
 do_syscall_64+0x2d/0x40
entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 960fbfe222a4 ("net/mlx5e: Allow coexistence of CQE compression and HW TS PTP")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 67 ++++++++++++++-----
 1 file changed, 52 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 8eed2dcc8898..ec6bafe7a2e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3984,11 +3984,45 @@ int mlx5e_ptp_rx_manage_fs_ctx(struct mlx5e_priv *priv, void *ctx)
 	return mlx5e_ptp_rx_manage_fs(priv, set);
 }
 
-int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
+static int mlx5e_hwstamp_config_no_ptp_rx(struct mlx5e_priv *priv, bool rx_filter)
+{
+	bool rx_cqe_compress_def = priv->channels.params.rx_cqe_compress_def;
+	int err;
+
+	if (!rx_filter)
+		/* Reset CQE compression to Admin default */
+		return mlx5e_modify_rx_cqe_compression_locked(priv, rx_cqe_compress_def);
+
+	if (!MLX5E_GET_PFLAG(&priv->channels.params, MLX5E_PFLAG_RX_CQE_COMPRESS))
+		return 0;
+
+	/* Disable CQE compression */
+	netdev_warn(priv->netdev, "Disabling RX cqe compression\n");
+	err = mlx5e_modify_rx_cqe_compression_locked(priv, false);
+	if (err)
+		netdev_err(priv->netdev, "Failed disabling cqe compression err=%d\n", err);
+
+	return err;
+}
+
+static int mlx5e_hwstamp_config_ptp_rx(struct mlx5e_priv *priv, bool ptp_rx)
 {
 	struct mlx5e_params new_params;
+
+	if (ptp_rx == priv->channels.params.ptp_rx)
+		return 0;
+
+	new_params = priv->channels.params;
+	new_params.ptp_rx = ptp_rx;
+	return mlx5e_safe_switch_params(priv, &new_params, mlx5e_ptp_rx_manage_fs_ctx,
+					&new_params.ptp_rx, true);
+}
+
+int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
+{
 	struct hwtstamp_config config;
 	bool rx_cqe_compress_def;
+	bool ptp_rx;
 	int err;
 
 	if (!MLX5_CAP_GEN(priv->mdev, device_frequency_khz) ||
@@ -4008,13 +4042,12 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	}
 
 	mutex_lock(&priv->state_lock);
-	new_params = priv->channels.params;
 	rx_cqe_compress_def = priv->channels.params.rx_cqe_compress_def;
 
 	/* RX HW timestamp */
 	switch (config.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
-		new_params.ptp_rx = false;
+		ptp_rx = false;
 		break;
 	case HWTSTAMP_FILTER_ALL:
 	case HWTSTAMP_FILTER_SOME:
@@ -4031,24 +4064,25 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
-		new_params.ptp_rx = rx_cqe_compress_def;
 		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		/* ptp_rx is set if both HW TS is set and CQE
+		 * compression is set
+		 */
+		ptp_rx = rx_cqe_compress_def;
 		break;
 	default:
-		mutex_unlock(&priv->state_lock);
-		return -ERANGE;
+		err = -ERANGE;
+		goto err_unlock;
 	}
 
-	if (new_params.ptp_rx == priv->channels.params.ptp_rx)
-		goto out;
+	if (!priv->profile->rx_ptp_support)
+		err = mlx5e_hwstamp_config_no_ptp_rx(priv,
+						     config.rx_filter != HWTSTAMP_FILTER_NONE);
+	else
+		err = mlx5e_hwstamp_config_ptp_rx(priv, ptp_rx);
+	if (err)
+		goto err_unlock;
 
-	err = mlx5e_safe_switch_params(priv, &new_params, mlx5e_ptp_rx_manage_fs_ctx,
-				       &new_params.ptp_rx, true);
-	if (err) {
-		mutex_unlock(&priv->state_lock);
-		return err;
-	}
-out:
 	memcpy(&priv->tstamp, &config, sizeof(config));
 	mutex_unlock(&priv->state_lock);
 
@@ -4057,6 +4091,9 @@ int mlx5e_hwstamp_set(struct mlx5e_priv *priv, struct ifreq *ifr)
 
 	return copy_to_user(ifr->ifr_data, &config,
 			    sizeof(config)) ? -EFAULT : 0;
+err_unlock:
+	mutex_unlock(&priv->state_lock);
+	return err;
 }
 
 int mlx5e_hwstamp_get(struct mlx5e_priv *priv, struct ifreq *ifr)
-- 
2.31.1

