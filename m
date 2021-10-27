Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D4843C003
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 04:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbhJ0ChV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 22:37:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238466AbhJ0ChM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 22:37:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 828C461074;
        Wed, 27 Oct 2021 02:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635302087;
        bh=68BdOgERCaN0bsjWYPMVRF1mKLmzi3Y9ogbcQZztHqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AhQ8nb4a4lqaNP780dJya5iCVbdTigNUCJs7Qs089pv0Y6kCpZwVmLgHSMBM6OmdK
         4w5v1fETblP8mpWl/gSyq5fQm91uQ9tPo6yAgqmAHxYLz6xFo88Ev4sCBf//5HHO9u
         zu8NpM/9iBDwZA//oqKlPgYr4JxVVZe8/KCk++NScf2uXU/QVhdg9NtOQKRNypfPkY
         scE7+PBhq9NBU8X1ImHF+O8vlriyFcqA3tGkFWFlF3ncFbatC8pYCHzzBkJSKo0x1P
         c6J7HvLDqCt9zxR1b5DKiqRCwLeOP8W6iVGe5C17JBhcJ3w31ptN8FiL/JOdd3vfIG
         z0JDMEqs37puw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Khalid Manaa <khalidm@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/14] net/mlx5e: Prevent HW-GRO and CQE-COMPRESS features operate together
Date:   Tue, 26 Oct 2021 19:33:46 -0700
Message-Id: <20211027023347.699076-14-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211027023347.699076-1-saeed@kernel.org>
References: <20211027023347.699076-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Khalid Manaa <khalidm@nvidia.com>

HW-GRO and CQE-COMPRESS are mutually exclusive, this commit adds this
restriction.

Signed-off-by: Khalid Manaa <khalidm@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 5 +++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 5a46b6e1b9da..c2ea5fad48dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1900,6 +1900,11 @@ int mlx5e_modify_rx_cqe_compression_locked(struct mlx5e_priv *priv, bool new_val
 		return -EINVAL;
 	}
 
+	if (priv->channels.params.packet_merge.type == MLX5E_PACKET_MERGE_SHAMPO) {
+		netdev_warn(priv->netdev, "Can't set CQE compression with HW-GRO, disable it first.\n");
+		return -EINVAL;
+	}
+
 	new_params = priv->channels.params;
 	MLX5E_SET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS, new_val);
 	if (rx_filter)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ecaad2d6c216..6f398f636f01 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3560,6 +3560,11 @@ static int set_feature_hw_gro(struct net_device *netdev, bool enable)
 	new_params = priv->channels.params;
 
 	if (enable) {
+		if (MLX5E_GET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
+			netdev_warn(netdev, "Can't set HW-GRO when CQE compress is active\n");
+			err = -EINVAL;
+			goto out;
+		}
 		new_params.packet_merge.type = MLX5E_PACKET_MERGE_SHAMPO;
 		new_params.packet_merge.shampo.match_criteria_type =
 			MLX5_RQC_SHAMPO_MATCH_CRITERIA_TYPE_EXTENDED;
-- 
2.31.1

