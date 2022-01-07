Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF021486ED1
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344276AbiAGAac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:30:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59214 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344225AbiAGAaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:30:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E351E61D00
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ACAC36AF4;
        Fri,  7 Jan 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641515415;
        bh=SfiiWQ7lgExWOv/RViiPp++qbzw6StygAeojqqhmoDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JxYldIC5k+zj+NcHPmv0M76HFAHZojzVjAkQHkeGObB+9e0VlgrjhU0PGtCQTR+Cl
         JuZ0SH2G7lmGQXttZ3qxJvfph8gFB1jqGRJVDWGYBIvLJTQ+9TYtN62PJwkJL8bmNs
         24w4G/95blsVQkdxtAYuveKVPfXaVJO+i+mkQar7nRGKtK+YOTgEdSTHTFwag9QcOM
         XSzmRjPZV+hgaZTDYf7JDschL5URl12dPj576SZEc2SeskWM0waGsQ/1aXeT4Hgdqp
         RM8umQBre3cgeaQe/AXVw6Ng+emE51B8VxDwu7G/HkN5VCU4RUYFKpBaBecz6VEEFC
         R/fmsssV90AQQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH net-next 11/15] net/mlx5e: Move HW-GRO and CQE compression check to fix features flow
Date:   Thu,  6 Jan 2022 16:29:52 -0800
Message-Id: <20220107002956.74849-12-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107002956.74849-1-saeed@kernel.org>
References: <20220107002956.74849-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gal Pressman <gal@nvidia.com>

Feature dependencies should be resolved in fix features rather than in
set features flow. Move the check that disables HW-GRO in case CQE
compression is enabled from set_feature_hw_gro() to
mlx5e_fix_features().

Signed-off-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 31c911182498..d36489363a26 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3605,11 +3605,6 @@ static int set_feature_hw_gro(struct net_device *netdev, bool enable)
 	new_params = priv->channels.params;
 
 	if (enable) {
-		if (MLX5E_GET_PFLAG(&new_params, MLX5E_PFLAG_RX_CQE_COMPRESS)) {
-			netdev_warn(netdev, "Can't set HW-GRO when CQE compress is active\n");
-			err = -EINVAL;
-			goto out;
-		}
 		new_params.packet_merge.type = MLX5E_PACKET_MERGE_SHAMPO;
 		new_params.packet_merge.shampo.match_criteria_type =
 			MLX5_RQC_SHAMPO_MATCH_CRITERIA_TYPE_EXTENDED;
@@ -3871,6 +3866,11 @@ static netdev_features_t mlx5e_fix_features(struct net_device *netdev,
 		features &= ~NETIF_F_RXHASH;
 		if (netdev->features & NETIF_F_RXHASH)
 			netdev_warn(netdev, "Disabling rxhash, not supported when CQE compress is active\n");
+
+		if (features & NETIF_F_GRO_HW) {
+			netdev_warn(netdev, "Disabling HW-GRO, not supported when CQE compress is active\n");
+			features &= ~NETIF_F_GRO_HW;
+		}
 	}
 
 	if (mlx5e_is_uplink_rep(priv))
-- 
2.33.1

