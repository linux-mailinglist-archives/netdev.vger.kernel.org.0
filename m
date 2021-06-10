Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B743A215B
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhFJAYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230162AbhFJAYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D530613FE;
        Thu, 10 Jun 2021 00:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284542;
        bh=fitC/c02j/0vdHzAU9BJ1wA+eccFcKtyGMj5FFCN0jc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNPUj2MhXNMaZjBvmy2G+1shL8YNy28dwPSak/dr5vWMf/s+fq37TRo9wDd6yFd0u
         dWk7gNCji8YIKCpmKS9mrcTSuUEZ/7+Mwzg6v+mbofAtGx1kEes+7tsgcTB1gmp0ka
         qplUMRXlAg+bYkdvymye/MspRXpWy3IOtNY+wxLYC9keOOvqQ8tlqxIO02OKoNT5gs
         IInc1yzDBHdDkSVDnB0RgvSbXcFK1QgpkSA+qJ6fLgSf448cD8sUQERd3aF68oyXBT
         8pUi738Nu8Ie/TrxjXATrpCCCtd5CRv/Bolgp0i53Buj9UP0ufVIE3jbDqg2LaYYkg
         PLXzGIZcXQT8w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 12/12] net/mlx5e: Block offload of outer header csum for GRE tunnel
Date:   Wed,  9 Jun 2021 17:21:55 -0700
Message-Id: <20210610002155.196735-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210610002155.196735-1-saeed@kernel.org>
References: <20210610002155.196735-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

The device is able to offload either the outer header csum or inner
header csum. The driver utilizes the inner csum offload. So, prohibit
setting of tx-gre-csum-segmentation and let it be: off[fixed].

Fixes: 2729984149e6 ("net/mlx5e: Support TSO and TX checksum offloads for GRE tunnels")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d4167f7be99c..d26b8ed51195 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4828,12 +4828,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-		netdev->hw_features     |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_GRE |
-					   NETIF_F_GSO_GRE_CSUM;
-		netdev->gso_partial_features |= NETIF_F_GSO_GRE |
-						NETIF_F_GSO_GRE_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_GRE;
+		netdev->hw_enc_features |= NETIF_F_GSO_GRE;
+		netdev->gso_partial_features |= NETIF_F_GSO_GRE;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_IPIP)) {
-- 
2.31.1

