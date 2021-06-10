Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1A23A215C
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbhFJAYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 20:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230161AbhFJAYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 20:24:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 980C4613FA;
        Thu, 10 Jun 2021 00:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623284541;
        bh=W6L03CM7auTKxp84cA8W3FEfco1+DGB5kInjc61/js8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tdxbnTpwZLJq4RnNfx8rtjCyMXbbCrxmEf+rWDFyTONZUZxsRTOrVm44k5FGcMuOC
         NLzCEAw6D5Ic9YNMcUO0Qn791Jsdwp632GCSnGa2frJbNMetC5aG0EoOBc/4SEgaFN
         Del4f7yHj2osvIDI43Sh/D26Fhlq+aoooylSS4+4GI1u56tVX3CSX6Uf5ENs0jkgFZ
         2rZjmC1pUyCGRO300QBoYj1zfKDmPkQ7R97+R5quP4TFddwMHGFzbNUB/SpyWtod3h
         Pis6CyC6sjxuQ+K2wySNYMYNZ4yeVsakI3Ut65ph97D3EeXAnp86XP5mgrfeefRkbK
         8syoWCN2WJNOQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aya Levin <ayal@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 11/12] net/mlx5e: Block offload of outer header csum for UDP tunnels
Date:   Wed,  9 Jun 2021 17:21:54 -0700
Message-Id: <20210610002155.196735-12-saeed@kernel.org>
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
header csum. The driver utilizes the inner csum offload. Hence, block
setting of tx-udp_tnl-csum-segmentation and set it to off[fixed].

Fixes: b49663c8fb49 ("net/mlx5e: Add support for UDP tunnel segmentation with outer checksum offload")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 263adc82b4e1..d4167f7be99c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4822,13 +4822,9 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 	}
 
 	if (mlx5_vxlan_allowed(mdev->vxlan) || mlx5_geneve_tx_allowed(mdev)) {
-		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL |
-					   NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->gso_partial_features = NETIF_F_GSO_UDP_TUNNEL_CSUM;
-		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL |
-					 NETIF_F_GSO_UDP_TUNNEL_CSUM;
+		netdev->hw_features     |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->hw_enc_features |= NETIF_F_GSO_UDP_TUNNEL;
+		netdev->vlan_features |= NETIF_F_GSO_UDP_TUNNEL;
 	}
 
 	if (mlx5e_tunnel_proto_supported_tx(mdev, IPPROTO_GRE)) {
-- 
2.31.1

