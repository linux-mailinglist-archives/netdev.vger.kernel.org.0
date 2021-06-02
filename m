Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E901397E22
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 03:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhFBBjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 21:39:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230055AbhFBBjR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 21:39:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE3E5613D0;
        Wed,  2 Jun 2021 01:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622597855;
        bh=M/ZysRBLIPv4r8ElzEgdCcwOQrmKbRoWvBHNauuJh3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGSjSQhgWn5TqNaaGGYVhmAISmKxkJokI2MsqPjmkWvtpXVywFXOSJTjRITZDlz61
         Ufc+xlpNtYxbEROuQ1KPSWpAqWIWwjed0ldv8OX2tHOOghMrU5K3VWy+yECNjooVN4
         /vsS1ABhQ5aaHJ+B0VydrUdtetdK7/MNnmhiV7zc9iLgvjQaDV8l5gM9UXLMmTj6+Z
         1a5/UFIYl1l4hBWOj2wMAAMUp6aP9VZEVwvcoeYfRGAfvJs9F4KYxrsONikDni/ycv
         alldJsiV/AoYi7GeEEPIPB5ENz3imoP7P6NQNS2pju/Acz/NP2uBqONk9cGIuNLRJF
         +Va9VDV0IZ/IQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 7/8] net/mlx5e: Fix conflict with HW TS and CQE compression
Date:   Tue,  1 Jun 2021 18:37:22 -0700
Message-Id: <20210602013723.1142650-8-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210602013723.1142650-1-saeed@kernel.org>
References: <20210602013723.1142650-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

When a driver's profile doesn't support a dedicated PTP-RQ,
configuration of CQE compression while HW TS is configured should fail.

Fixes: 885b8cfb161e ("net/mlx5e: Update ethtool setting of CQE compression")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c4724742eef1..d6513aef5cd4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1894,6 +1894,13 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 	if (curr_val == new_val)
 		return 0;
 
+	if (new_val && !priv->profile->rx_ptp_support &&
+	    priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE) {
+		netdev_err(priv->netdev,
+			   "Profile doesn't support enabling of CQE compression while hardware time-stamping is enabled.\n");
+		return -EINVAL;
+	}
+
 	new_params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
 	if (priv->tstamp.rx_filter != HWTSTAMP_FILTER_NONE)
-- 
2.31.1

