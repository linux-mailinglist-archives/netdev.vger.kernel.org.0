Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506CE43C002
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238408AbhJ0ChU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238348AbhJ0ChM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F08AF60232;
        Wed, 27 Oct 2021 02:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302087;
        bh=t7QuTd58hmsVUGJKwmlHYRNCyrsA/jeh6vkhzMJT1sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R12tX/Jt3/yydO234BWT+WRouSR482nbcQT1IgNZwQAAzHvVvjqpjfmZ3gp4cHzrZ
         zdVIO9q0Hy7Bj9gb8a3aGIOaFRVppFexffnZyr/7vOrgbtKm82JiU8zxTYMHU7vTAX
         fG1bALWhUPxUmwR0FgyDkmZvm18dfeikCoOTdAT0Tlzqkaf1aLmMMWrLMPE73e8QAp
         WkAJZqZiJ7i4eyVXvm48w2ASuGyJqxDrxN7n/dkJrzADZqouADE4GzzmYCkYiNrxX7
         7b8ZbVQr3Jp6G6tGXi3tDlaqpsQ7BdwaNXzTACy184Zam5d/bqjy7ftpdWyj/Yu/Rf
         i6BfD76Z7iHBA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Khalid Manaa <khalidm@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/14] net/mlx5e: Add HW-GRO offload
Date:   Tue, 26 Oct 2021 19:33:45 -0700
Message-Id: <20211027023347.699076-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Manaa <khalidm@nvidia.com>

This commit introduces HW-GRO offload by using the SHAMPO feature
- Add set feature handler for HW-GRO.

Signed-off-by: Ben Ben-Ishay <benishay@nvidia.com>
Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e922584f2702..ecaad2d6c216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3549,6 +3549,35 @@ static int set_feature_lro(struct net_device *netdev, bool enable)
 	return err;
 }
 
+static int set_feature_hw_gro(struct net_device *netdev, bool enable)
+{
+	struct mlx5e_priv *priv = netdev_priv(netdev);
+	struct mlx5e_params new_params;
+	bool reset = true;
+	int err = 0;
+
+	mutex_lock(&priv->state_lock);
+	new_params = priv->channels.params;
+
+	if (enable) {
+		new_params.packet_merge.type = MLX5E_PACKET_MERGE_SHAMPO;
+		new_params.packet_merge.shampo.match_criteria_type =
+			MLX5_RQC_SHAMPO_MATCH_CRITERIA_TYPE_EXTENDED;
+		new_params.packet_merge.shampo.alignment_granularity =
+			MLX5_RQC_SHAMPO_NO_MATCH_ALIGNMENT_GRANULARITY_STRIDE;
+	} else if (new_params.packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO) {
+		new_params.packet_merge.type = MLX5E_PACKET_MERGE_NONE;
+	} else {
+		goto out;
+	}
+
+	err = mlx5e_safe_switch_params(priv, &new_params,
+				       mlx5e_modify_tirs_packet_merge_ctx, NULL, reset);
+out:
+	mutex_unlock(&priv->state_lock);
+	return err;
+}
+
 static int set_feature_cvlan_filter(struct net_device *netdev, bool enable)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -3722,6 +3751,7 @@ int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
 	mlx5e_handle_feature(netdev, &oper_features, features, feature, handler)
 
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_LRO, set_feature_lro);
+	err |= MLX5E_HANDLE_FEATURE(NETIF_F_GRO_HW, set_feature_hw_gro);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_VLAN_CTAG_FILTER,
 				    set_feature_cvlan_filter);
 	err |= MLX5E_HANDLE_FEATURE(NETIF_F_HW_TC, set_feature_hw_tc);
@@ -3782,6 +3812,10 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 			netdev_warn(netdev, "Disabling LRO, not supported in legacy RQ\n");
 			features &= ~NETIF_F_LRO;
 		}
+		if (features & NETIF_F_GRO_HW) {
+			netdev_warn(netdev, "Disabling HW-GRO, not supported in legacy RQ\n");
+			features &= ~NETIF_F_GRO_HW;
+		}
 	}
 
 	if (MLX5E_GET_PFLAG(params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
@@ -4723,6 +4757,10 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_features      |= NETIF_F_HW_VLAN_CTAG_FILTER;
 	netdev->hw_features      |= NETIF_F_HW_VLAN_STAG_TX;
 
+	if (!!MLX5_CAP_GEN(mdev, shampo) &&
+	    mlx5e_check_fragmented_striding_rq_cap(mdev))
+		netdev->hw_features    |= NETIF_F_GRO_HW;
+
 	if (mlx5e_tunnel_any_tx_proto_supported(mdev)) {
 		netdev->hw_enc_features |= NETIF_F_HW_CSUM;
 		netdev->hw_enc_features |= NETIF_F_TSO;
@@ -4773,6 +4811,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	if (fcs_enabled)
 		netdev->features  &= ~NETIF_F_RXALL;
 	netdev->features  &= ~NETIF_F_LRO;
+	netdev->features  &= ~NETIF_F_GRO_HW;
 	netdev->features  &= ~NETIF_F_RXFCS;
 
 #define FT_CAP(f) MLX5_CAP_FLOWTABLE(mdev, flow_table_properties_nic_receive.f)
-- 
2.31.1

