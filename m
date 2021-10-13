Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D868942CAD9
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 22:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbhJMUWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 16:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229496AbhJMUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 16:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B966604AC;
        Wed, 13 Oct 2021 20:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634156405;
        bh=jta6yXjC/Wl1nw1uLFoDnn4drjCLPWFpLRa4zX5Flbs=;
        h=From:To:Cc:Subject:Date:From;
        b=CoFiDxp+ezkGTSRyDE4yUQiG3UbDw4L32Z6YhyR9zxf6r4mGGLTMoGCl364bbT8/J
         ZXV61EpQzFKuJEjGj67DIvYi8jgisqLHQ+5l4Kmt2ryKfGkqTjNrRT8o1JSxQm/Mqx
         DSFJid34Z3HxYfFIufzqx5pXEq1BSWlTO8z9E6C5fUDj/3Umxj5K2TdPqe1XOFIJqg
         NAbgCcx1TXAVjg2ZqQ8I0DWJb7efSfCHXFFzXNdSAMilZqibOFrDdGbRRkymQtg+Cp
         UqzxnQVdiUWYZdCtZ+RCcBpG+BrnYDKy9v3/dcQWsuzFcQIIAPf0+u4/zhtQD1Ymt1
         KAoasGs/YjXbg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     saeedm@nvidia.com
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] mlx5: don't write directly to netdev->dev_addr
Date:   Wed, 13 Oct 2021 13:20:01 -0700
Message-Id: <20211013202001.311183-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use a local buffer and eth_hw_addr_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
This takes care of Ethernet, mlx5/core/ipoib/ipoib.c
will be changed as part of all the IB conversions.
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index e81e5505207c..430c9e967f5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4385,12 +4385,15 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
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
+	} else {
+		eth_hw_addr_set(netdev, addr);
 	}
 }
 
-- 
2.31.1

