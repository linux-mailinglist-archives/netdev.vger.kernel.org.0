Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4561343A50B
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232467AbhJYU45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230464AbhJYU44 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 16:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD4B60FE8;
        Mon, 25 Oct 2021 20:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635195274;
        bh=JE9BGkaAawC1/M+lSQm+MD466LBhyLZK1BjZVGuOFVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pi6I7ThXI1kS/Vh+w6voZNersWvgWTfFVOR3WqffVVandTZFFxt2rIpRiWRqsZSwt
         342WEHKaSngXX+LRD7Ekd59IkEtIAS4GJJgU9C3IbgFTulw1x9KSU8jVhpx2iUIQew
         U302guaZjaG9YPExelN0I1RzmkEMJwkJh518EybFURlfTHc/aBkrLD7y7HL8j8hZOd
         ENF08iH2ZjAYst7dgeiwD1bDz1Y0VMmkNwE4Wv9pXP/JiJsGbglzIcXpg2ng/A3kcj
         mD5YhN78zZwzTZeob8ErFipWwVG0N3WzvVMtTOAdeYdQ5EZZW06SoZoyIo7kdm/ST6
         9Je1VW7spuShQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 01/14] net/mlx5e: don't write directly to netdev->dev_addr
Date:   Mon, 25 Oct 2021 13:54:18 -0700
Message-Id: <20211025205431.365080-2-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211025205431.365080-1-saeed@kernel.org>
References: <20211025205431.365080-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

Use a local buffer and eth_hw_addr_set()

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 0ff36c83714b..f3dec58026d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4432,13 +4432,17 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 static void mlx5e_set_netdev_dev_addr(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
+	u8 addr[ETH_ALEN];
 
-	mlx5_query_mac_address(priv->mdev, netdev->dev_addr);
-	if (is_zero_ether_addr(netdev->dev_addr) &&
+	mlx5_query_mac_address(priv->mdev, addr);
+	if (is_zero_ether_addr(addr) &&
 	    !MLX5_CAP_GEN(priv->mdev, vport_group_manager)) {
 		eth_hw_addr_random(netdev);
 		mlx5_core_info(priv->mdev, "Assigned random MAC address %pM\n", netdev->dev_addr);
+		return;
 	}
+
+	eth_hw_addr_set(netdev, addr);
 }
 
 static int mlx5e_vxlan_set_port(struct net_device *netdev, unsigned int table,
-- 
2.31.1

