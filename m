Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9794A3A2152
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhFJAYT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhFJAYN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C20FF6108E;
        Thu, 10 Jun 2021 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284538;
        bh=erdPIIMRISVdjn5KSHNR7wZc7rA322FfVxMnvHg91wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYgSWYdSSH/YHlbeFp/Ut5KiarbR394qytHnkGvMZlyaYo48ZY5hqJE+N1zPkePFo
         mRoeipilmp6I/DQa4U0POXBrDsr92MAvf7Vdk8pZsPF7+25z6bVPmLse+rjWL5+TpJ
         d7bjLoBGImNnOx7HhVAsSCQUqqz+8cVNZoNo2grtxrCKlY2OVhlGvnsd+wm/HJ9pqh
         18CWsqI0VEIlewLx7/22uomuSdAkr78rPO66eCSLeK+ZHkLp/tQMSE3heDpW/bce93
         ha4gumgIFCBb8WSYmjogCPQfPSCv0yZQrJb/5oM163o/ZlJTc/8Ro/KuDxZad09bEv
         VLv1L/aAlK0AA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 03/12] net/mlx5e: Remove dependency in IPsec initialization flows
Date:   Wed,  9 Jun 2021 17:21:46 -0700
Message-Id: <20210610002155.196735-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@nvidia.com>

Currently, IPsec feature is disabled because mlx5e_build_nic_netdev
is required to be called after mlx5e_ipsec_init. This requirement is
invalid as mlx5e_build_nic_netdev and mlx5e_ipsec_init initialize
independent resources.

Remove ipsec pointer check in mlx5e_build_nic_netdev so that the
two functions can be called at any order.

Fixes: 547eede070eb ("net/mlx5e: IPSec, Innova IPSec offload infrastructure")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3d45341e2216..26f7fab109d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -532,9 +532,6 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct net_device *netdev = priv->netdev;
 
-	if (!priv->ipsec)
-		return;
-
 	if (!(mlx5_accel_ipsec_device_caps(mdev) & MLX5_ACCEL_IPSEC_CAP_ESP) ||
 	    !MLX5_CAP_ETH(mdev, swp)) {
 		mlx5_core_dbg(mdev, "mlx5e: ESP and SWP offload not supported\n");
-- 
2.31.1

