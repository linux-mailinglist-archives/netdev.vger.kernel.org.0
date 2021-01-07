Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2514C2EE6E6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 21:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbhAGUa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 15:30:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726666AbhAGUaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 15:30:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3326D235F8;
        Thu,  7 Jan 2021 20:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610051352;
        bh=N7WXOTahHFAMGfOLB9Z4gwU2egX6bG9OVFN4fg2+zgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L9DYNV3a16bjRbiNobeZV/akRItD7JkEM/Z91Mw7TFclWLK75yXPqgyFd85f2YkI8
         Cf7F85JG7wF3dJf7IZeO285mbg7zxf9mnzegflT7GGWxZTCYsh7otNWdlo80bG7tyl
         esiq6dzWnEJ7fxU6tMAhD63brYEnQzJ6ofoTxqeqkc63yGfu5Kob9mrIcL9ZJoDnv1
         7OwvWbei4f2g0lWoTikm5RMQO7foP4iVCafwwA2921aNjS+Xt5wrxBAWezElEIXj+2
         RytB5XGZvNHn2fDX1eSs/kwGrrvoYVPdX+PYCI3szNyF/rVnMdFH0DRm1rz39/hc+2
         zN/Sou4HMPjLQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/11] net/mlx5e: ethtool, Fix restriction of autoneg with 56G
Date:   Thu,  7 Jan 2021 12:28:42 -0800
Message-Id: <20210107202845.470205-9-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107202845.470205-1-saeed@kernel.org>
References: <20210107202845.470205-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Prior to this patch, configuring speed to 50G with autoneg off over
devices supporting 50G per lane failed.
Support for 50G per lane introduced a new set of link-modes, on which
driver always performed a speed validation as if only legacy link-modes
were configured. Fix driver speed validation to force setting autoneg
over 56G only if in legacy link-mode.

Fixes: 3d7cadae51f1 ("net/mlx5e: ethtool, Fix analysis of speed setting")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d9076d543104..2d37742a888c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1010,6 +1010,22 @@ static int mlx5e_get_link_ksettings(struct net_device *netdev,
 	return mlx5e_ethtool_get_link_ksettings(priv, link_ksettings);
 }
 
+static int mlx5e_speed_validate(struct net_device *netdev, bool ext,
+				const unsigned long link_modes, u8 autoneg)
+{
+	/* Extended link-mode has no speed limitations. */
+	if (ext)
+		return 0;
+
+	if ((link_modes & MLX5E_PROT_MASK(MLX5E_56GBASE_R4)) &&
+	    autoneg != AUTONEG_ENABLE) {
+		netdev_err(netdev, "%s: 56G link speed requires autoneg enabled\n",
+			   __func__);
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static u32 mlx5e_ethtool2ptys_adver_link(const unsigned long *link_modes)
 {
 	u32 i, ptys_modes = 0;
@@ -1103,13 +1119,9 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	link_modes = autoneg == AUTONEG_ENABLE ? ethtool2ptys_adver_func(adver) :
 		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
 
-	if ((link_modes & MLX5E_PROT_MASK(MLX5E_56GBASE_R4)) &&
-	    autoneg != AUTONEG_ENABLE) {
-		netdev_err(priv->netdev, "%s: 56G link speed requires autoneg enabled\n",
-			   __func__);
-		err = -EINVAL;
+	err = mlx5e_speed_validate(priv->netdev, ext, link_modes, autoneg);
+	if (err)
 		goto out;
-	}
 
 	link_modes = link_modes & eproto.cap;
 	if (!link_modes) {
-- 
2.26.2

