Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFD53D64F0
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236063AbhGZQRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:17:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:49884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241129AbhGZQPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 12:15:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCBA60F57;
        Mon, 26 Jul 2021 16:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627318553;
        bh=EevERKxgq8g7N6FFNGl7+xFknPDb6AKUPvnKdbzFUqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0zOaDNJMGUSx39WZ4fL36NbJ39sPZKLYHI9KoUUftAPbKJGx3XjeSPvDSWU5QVE9
         y/UFzUsJvTLV+nkWEG54VafmJ0VguesX/mWFs0NZiDfN1Pfd1Q2/q6MT35DP+2DQdy
         D58KqhAausjH/XuPYoe7wPHR5kfSCXeL0rAzGYGV6WW43ATNzEsaUsxW2f64x+O7ws
         46uS4ZfK0TDhRNBLgi6lhEzZOiE7wk1N0WEssu7nBrawbYNnUX5iuiTZHXxx4cP8Bv
         C9ffn87TQHjN3sNZwpZQ5ATJgl8S+PBH04BnXgvSEm5Hekv0t5Uo2w2w1DJGb1iAwa
         6dj7+6csFNuXA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/16] net/mlx5e: Block LRO if firmware asks for tunneled LRO
Date:   Mon, 26 Jul 2021 09:55:30 -0700
Message-Id: <20210726165544.389143-3-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726165544.389143-1-saeed@kernel.org>
References: <20210726165544.389143-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

This commit does a cleanup in LRO configuration.

LRO is a parameter of an RQ, but its state is changed by modifying a TIR
related to the RQ.

The current status: LRO for tunneled packets is not supported in the
driver, inner TIRs may enable LRO on creation, but LRO status of inner
TIRs isn't changed in mlx5e_modify_tirs_lro(). This is inconsistent, but
as long as the firmware doesn't declare support for tunneled LRO, it
works, because the same RQs are shared between the inner and outer TIRs.

This commit does two fixes:

1. If the firmware has the tunneled LRO capability, LRO is blocked
altogether, because it's not possible to block it for inner TIRs only,
when the same RQs are shared between inner and outer TIRs, and the
driver won't be able to handle tunneled LRO traffic.

2. mlx5e_modify_tirs_lro() is patched to modify LRO state for all TIRs,
including inner ones, because all TIRs related to an RQ should agree on
their LRO state.

Fixes: 7b3722fa9ef6 ("net/mlx5e: Support RSS for GRE tunneled packets")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 15 +++++++++++++++
 include/linux/mlx5/mlx5_ifc.h                     |  3 ++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d09e65557e75..b651134b0f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2576,6 +2576,14 @@ static int mlx5e_modify_tirs_lro(struct mlx5e_priv *priv)
 		err = mlx5_core_modify_tir(mdev, priv->indir_tir[tt].tirn, in);
 		if (err)
 			goto free_in;
+
+		/* Verify inner tirs resources allocated */
+		if (!priv->inner_indir_tir[0].tirn)
+			continue;
+
+		err = mlx5_core_modify_tir(mdev, priv->inner_indir_tir[tt].tirn, in);
+		if (err)
+			goto free_in;
 	}
 
 	for (ix = 0; ix < priv->max_nch; ix++) {
@@ -4808,7 +4816,14 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_TX;
 	netdev->hw_enc_features  |= NETIF_F_HW_VLAN_CTAG_RX;
 
+	/* Tunneled LRO is not supported in the driver, and the same RQs are
+	 * shared between inner and outer TIRs, so the driver can't disable LRO
+	 * for inner TIRs while having it enabled for outer TIRs. Due to this,
+	 * block LRO altogether if the firmware declares tunneled LRO support.
+	 */
 	if (!!MLX5_CAP_ETH(mdev, lro_cap) &&
+	    !MLX5_CAP_ETH(mdev, tunnel_lro_vxlan) &&
+	    !MLX5_CAP_ETH(mdev, tunnel_lro_gre) &&
 	    mlx5e_check_fragmented_striding_rq_cap(mdev))
 		netdev->vlan_features    |= NETIF_F_LRO;
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b0009aa3647f..6bbae0c3bc0b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -921,7 +921,8 @@ struct mlx5_ifc_per_protocol_networking_offload_caps_bits {
 	u8         scatter_fcs[0x1];
 	u8         enhanced_multi_pkt_send_wqe[0x1];
 	u8         tunnel_lso_const_out_ip_id[0x1];
-	u8         reserved_at_1c[0x2];
+	u8         tunnel_lro_gre[0x1];
+	u8         tunnel_lro_vxlan[0x1];
 	u8         tunnel_stateless_gre[0x1];
 	u8         tunnel_stateless_vxlan[0x1];
 
-- 
2.31.1

