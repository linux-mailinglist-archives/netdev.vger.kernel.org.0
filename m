Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2A834E026
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 06:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhC3E2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 00:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230282AbhC3E1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 00:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3476198F;
        Tue, 30 Mar 2021 04:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617078468;
        bh=4gXq2WvOcGklwS3or1UQ7y1Z8sB4OwAFRHTFiGF6q4c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLrMLzJIzj2XE4wzPngaqy9X5X+SzvMUgi0rtXL0zDXaXRX9pIwzo5uz5KceDTh7Y
         lbh6Hbzlm+9VZHIUWwvBzGkFx1yfhBqnC5avHx/xBfLJNyqZUElfkR1NBsIWNg0WLW
         iqFxocn/QKDlZxAmzufLIDBoh+gKYp1aBiqBXfAB3aoOrvKcsPGnr0G6dmCeYT4dJz
         5/CxR2J6kdBR9tnuARXAr6GHZXNCPP6y1AZkCkXMLPGBDvw97QnBeil3/bHUhtlDsj
         HsDt/dEyYdGuWF38x9IC7+Ww3ZOy0MlLF1xQiOKsy9jrWY0aqXtOeTSdaZjYyI5B37
         9HWgwRJHy1P7w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/12] net/mlx5e: Add PTP Flow Steering support
Date:   Mon, 29 Mar 2021 21:27:39 -0700
Message-Id: <20210330042741.198601-11-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210330042741.198601-1-saeed@kernel.org>
References: <20210330042741.198601-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When opening PTP channel with MLX5E_PTP_STATE_RX set, add the
corresponding flow steering rules. Capture UDP packets with destination
port 319 and L2 packets with ethertype 0x88F7 and steer them into the RQ
of the PTP channel.
Add API that manages the flow steering rules to be used in the following
patches via safe_reopen_channels mechanism.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/ptp.c  | 134 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/ptp.h  |   3 +
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   |   8 ++
 4 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index c61fbb9c6fa8..d53fb1e31b05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -245,6 +245,7 @@ struct mlx5e_accel_fs_tcp;
 
 struct mlx5e_fs_udp;
 struct mlx5e_fs_any;
+struct mlx5e_ptp_fs;
 
 struct mlx5e_flow_steering {
 	struct mlx5_flow_namespace      *ns;
@@ -266,6 +267,7 @@ struct mlx5e_flow_steering {
 #endif
 	struct mlx5e_fs_udp            *udp;
 	struct mlx5e_fs_any            *any;
+	struct mlx5e_ptp_fs            *ptp_fs;
 };
 
 struct ttc_params {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index c1c41c8656dc..995a0947b2d5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -1,9 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
 // Copyright (c) 2020 Mellanox Technologies
 
+#include <linux/ptp_classify.h>
 #include "en/ptp.h"
 #include "en/txrx.h"
 #include "en/params.h"
+#include "en/fs_tt_redirect.h"
+
+struct mlx5e_ptp_fs {
+	struct mlx5_flow_handle *l2_rule;
+	struct mlx5_flow_handle *udp_v4_rule;
+	struct mlx5_flow_handle *udp_v6_rule;
+	bool valid;
+};
 
 #define MLX5E_PTP_CHANNEL_IX 0
 
@@ -573,6 +582,78 @@ static int mlx5e_ptp_set_state(struct mlx5e_ptp *c, struct mlx5e_params *params)
 	return bitmap_empty(c->state, MLX5E_PTP_STATE_NUM_STATES) ? -EINVAL : 0;
 }
 
+static void mlx5e_ptp_rx_unset_fs(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ptp_fs *ptp_fs = priv->fs.ptp_fs;
+
+	if (!ptp_fs->valid)
+		return;
+
+	mlx5e_fs_tt_redirect_del_rule(ptp_fs->l2_rule);
+	mlx5e_fs_tt_redirect_any_destroy(priv);
+
+	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v6_rule);
+	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v4_rule);
+	mlx5e_fs_tt_redirect_udp_destroy(priv);
+	ptp_fs->valid = false;
+}
+
+static int mlx5e_ptp_rx_set_fs(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ptp_fs *ptp_fs = priv->fs.ptp_fs;
+	struct mlx5_flow_handle *rule;
+	u32 tirn = priv->ptp_tir.tirn;
+	int err;
+
+	if (ptp_fs->valid)
+		return 0;
+
+	err = mlx5e_fs_tt_redirect_udp_create(priv);
+	if (err)
+		goto out_free;
+
+	rule = mlx5e_fs_tt_redirect_udp_add_rule(priv, MLX5E_TT_IPV4_UDP,
+						 tirn, PTP_EV_PORT);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		goto out_destroy_fs_udp;
+	}
+	ptp_fs->udp_v4_rule = rule;
+
+	rule = mlx5e_fs_tt_redirect_udp_add_rule(priv, MLX5E_TT_IPV6_UDP,
+						 tirn, PTP_EV_PORT);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		goto out_destroy_udp_v4_rule;
+	}
+	ptp_fs->udp_v6_rule = rule;
+
+	err = mlx5e_fs_tt_redirect_any_create(priv);
+	if (err)
+		goto out_destroy_udp_v6_rule;
+
+	rule = mlx5e_fs_tt_redirect_any_add_rule(priv, tirn, ETH_P_1588);
+	if (IS_ERR(rule)) {
+		err = PTR_ERR(rule);
+		goto out_destroy_fs_any;
+	}
+	ptp_fs->l2_rule = rule;
+	ptp_fs->valid = true;
+
+	return 0;
+
+out_destroy_fs_any:
+	mlx5e_fs_tt_redirect_any_destroy(priv);
+out_destroy_udp_v6_rule:
+	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v6_rule);
+out_destroy_udp_v4_rule:
+	mlx5e_fs_tt_redirect_del_rule(ptp_fs->udp_v4_rule);
+out_destroy_fs_udp:
+	mlx5e_fs_tt_redirect_udp_destroy(priv);
+out_free:
+	return err;
+}
+
 int mlx5e_ptp_open(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   u8 lag_port, struct mlx5e_ptp **cp)
 {
@@ -645,8 +726,10 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 		for (tc = 0; tc < c->num_tc; tc++)
 			mlx5e_activate_txqsq(&c->ptpsq[tc].txqsq);
 	}
-	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
+		mlx5e_ptp_rx_set_fs(c->priv);
 		mlx5e_activate_rq(&c->rq);
+	}
 }
 
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c)
@@ -672,3 +755,52 @@ int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn)
 	*rqn = c->rq.rqn;
 	return 0;
 }
+
+int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ptp_fs *ptp_fs;
+
+	if (!priv->profile->rx_ptp_support)
+		return 0;
+
+	ptp_fs = kzalloc(sizeof(*ptp_fs), GFP_KERNEL);
+	if (!ptp_fs)
+		return -ENOMEM;
+
+	priv->fs.ptp_fs = ptp_fs;
+	return 0;
+}
+
+void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv)
+{
+	struct mlx5e_ptp_fs *ptp_fs = priv->fs.ptp_fs;
+
+	if (!priv->profile->rx_ptp_support)
+		return;
+
+	mlx5e_ptp_rx_unset_fs(priv);
+	kfree(ptp_fs);
+}
+
+int mlx5e_ptp_rx_manage_fs(struct mlx5e_priv *priv, bool set)
+{
+	struct mlx5e_ptp *c = priv->channels.ptp;
+
+	if (!priv->profile->rx_ptp_support)
+		return 0;
+
+	if (set) {
+		if (!c || !test_bit(MLX5E_PTP_STATE_RX, c->state)) {
+			netdev_WARN_ONCE(priv->netdev, "Don't try to add PTP RX-FS rules");
+			return -EINVAL;
+		}
+		return mlx5e_ptp_rx_set_fs(priv);
+	}
+	/* set == false */
+	if (c && test_bit(MLX5E_PTP_STATE_RX, c->state)) {
+		netdev_WARN_ONCE(priv->netdev, "Don't try to remove PTP RX-FS rules");
+		return -EINVAL;
+	}
+	mlx5e_ptp_rx_unset_fs(priv);
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
index 460b167887bc..ab935cce952b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.h
@@ -49,6 +49,9 @@ void mlx5e_ptp_close(struct mlx5e_ptp *c);
 void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c);
 void mlx5e_ptp_deactivate_channel(struct mlx5e_ptp *c);
 int mlx5e_ptp_get_rqn(struct mlx5e_ptp *c, u32 *rqn);
+int mlx5e_ptp_alloc_rx_fs(struct mlx5e_priv *priv);
+void mlx5e_ptp_free_rx_fs(struct mlx5e_priv *priv);
+int mlx5e_ptp_rx_manage_fs(struct mlx5e_priv *priv, bool set);
 
 enum {
 	MLX5E_SKB_CB_CQE_HWTSTAMP  = BIT(0),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index cf1d3c9c88af..98f0b857947e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -38,6 +38,7 @@
 #include "en.h"
 #include "en_rep.h"
 #include "lib/mpfs.h"
+#include "en/ptp.h"
 
 static int mlx5e_add_l2_flow_rule(struct mlx5e_priv *priv,
 				  struct mlx5e_l2_rule *ai, int type);
@@ -1792,10 +1793,16 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 		goto err_destroy_l2_table;
 	}
 
+	err = mlx5e_ptp_alloc_rx_fs(priv);
+	if (err)
+		goto err_destory_vlan_table;
+
 	mlx5e_ethtool_init_steering(priv);
 
 	return 0;
 
+err_destory_vlan_table:
+	mlx5e_destroy_vlan_table(priv);
 err_destroy_l2_table:
 	mlx5e_destroy_l2_table(priv);
 err_destroy_ttc_table:
@@ -1810,6 +1817,7 @@ int mlx5e_create_flow_steering(struct mlx5e_priv *priv)
 
 void mlx5e_destroy_flow_steering(struct mlx5e_priv *priv)
 {
+	mlx5e_ptp_free_rx_fs(priv);
 	mlx5e_destroy_vlan_table(priv);
 	mlx5e_destroy_l2_table(priv);
 	mlx5e_destroy_ttc_table(priv, &priv->fs.ttc);
-- 
2.30.2

