Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134173D83D6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233796AbhG0XVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233023AbhG0XU4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 19:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E680B60F59;
        Tue, 27 Jul 2021 23:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627428056;
        bh=aSrRhwjXJz7fU1KqDHae2KP0XC4i7+R2VRLscfvrQ8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cK4tP2ITobNHfcwcd0ciwDfhcKSkYRSFYUxjgZ3JCLJ1BlMcCfoprEQLGs8I2NfqN
         NIbrkAzk5xnTNuRudIEaEbBXVYxHfybrxgt76BViHMwEbHW9wI2JCJqhax+SFC7vEK
         tAKOR8blFzsdtYoR428IKBUUa6kqTfpInluBh5pukQ0d30yD/WnUtafmb5eBGhGZ2N
         1tYk41dvz+rjyCzoHJaSNzlJ3lhNqRtdsmKuQihFPJH+hpjoFqzUKSF9nS05BH+f6A
         apwX2pLBKXAMnwXkjbEsY6hHOhPqSm3bATVkgDH6d3XHcUt5ElCVn7NNpj3eQZsm/e
         sSiemmNEioT1g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/12] net/mlx5e: Consider PTP-RQ when setting RX VLAN stripping
Date:   Tue, 27 Jul 2021 16:20:45 -0700
Message-Id: <20210727232050.606896-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727232050.606896-1-saeed@kernel.org>
References: <20210727232050.606896-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add PTP-RQ to the loop when setting rx-vlan-offload feature via ethtool.
On PTP-RQ's creation, set rx-vlan-offload into its parameters.

Fixes: a099da8ffcf6 ("net/mlx5e: Add RQ to PTP channel")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c  | 5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 778e229310a9..07b429b94d93 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -482,8 +482,11 @@ static void mlx5e_ptp_build_params(struct mlx5e_ptp *c,
 		params->log_sq_size = orig->log_sq_size;
 		mlx5e_ptp_build_sq_param(c->mdev, params, &cparams->txq_sq_param);
 	}
-	if (test_bit(MLX5E_PTP_STATE_RX, c->state))
+	/* RQ */
+	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
+		params->vlan_strip_disable = orig->vlan_strip_disable;
 		mlx5e_ptp_build_rq_param(c->mdev, c->netdev, c->priv->q_counter, cparams);
+	}
 }
 
 static int mlx5e_init_ptp_rq(struct mlx5e_ptp *c, struct mlx5e_params *params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index c5a2e3e6fe4b..37c440837945 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3384,7 +3384,7 @@ static int mlx5e_modify_channels_scatter_fcs(struct mlx5e_channels *chs, bool en
 
 static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 {
-	int err = 0;
+	int err;
 	int i;
 
 	for (i = 0; i < chs->num; i++) {
@@ -3392,6 +3392,8 @@ static int mlx5e_modify_channels_vsd(struct mlx5e_channels *chs, bool vsd)
 		if (err)
 			return err;
 	}
+	if (chs->ptp && test_bit(MLX5E_PTP_STATE_RX, chs->ptp->state))
+		return mlx5e_modify_rq_vsd(&chs->ptp->rq, vsd);
 
 	return 0;
 }
-- 
2.31.1

