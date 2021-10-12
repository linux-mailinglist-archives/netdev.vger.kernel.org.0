Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2E4242AE3D
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 22:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbhJLUzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 16:55:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:33012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhJLUzc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 16:55:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F9A9610CB;
        Tue, 12 Oct 2021 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634072010;
        bh=uJOjRxMKzU22MYV7BFjoodUOUdUK2lMWbHhaUvf08SE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeeBI2ditw7L3o415sxSjHEEK8wbLqhRvb80WX5OaIN3ep0Cwj7Zc+cb7anlFAlbQ
         bOJOwyLsoCdd4vtQd4lp8uYsisI1c0lIuiFnxToDIqeJn2yCQYvPkfiml8WeMbCd+T
         j8NJlqyc4gEBEz4oaoNJYXXYKvGvU/mWqDFbFPURyCkzDWAMwlvbFlWCPW7xL3dzgr
         mL9l65KsN3pOsF381oUkoBenDprMHRcdklOgMG8nqwdUnxyd4cLX8kw1CRs8XJyD/i
         E9HZzdCeY0yAZwt8tFj3KOUcohufjCietOys03z2LkT281WpIduq7YcHxfojZrENmK
         EeIn8tO05oh0w==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net 4/6] net/mlx5e: Switchdev representors are not vlan challenged
Date:   Tue, 12 Oct 2021 13:53:21 -0700
Message-Id: <20211012205323.20123-5-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012205323.20123-1-saeed@kernel.org>
References: <20211012205323.20123-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Before this patch, mlx5 representors advertised the
NETIF_F_VLAN_CHALLENGED bit, this could lead to missing features when
using reps with vxlan/bridge and maybe other virtual interfaces,
when such interfaces inherit this bit and block vlan usage in their
topology.

Example:
$ip link add dev bridge type bridge
 # add representor interface to the bridge
$ip link set dev pf0hpf master
$ip link add link bridge name vlan10 type vlan id 10 protocol 802.1q
Error: 8021q: VLANs not supported on device.

Reps are perfectly capable of handling vlan traffic, although they don't
implement vlan_{add,kill}_vid ndos, hence, remove
NETIF_F_VLAN_CHALLENGED advertisement.

Fixes: cb67b832921c ("net/mlx5e: Introduce SRIOV VF representors")
Reported-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3dd1101cc693..0439203fc7d9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -643,7 +643,6 @@ static void mlx5e_build_rep_netdev(struct net_device *netdev,
 	netdev->hw_features    |= NETIF_F_RXCSUM;
 
 	netdev->features |= netdev->hw_features;
-	netdev->features |= NETIF_F_VLAN_CHALLENGED;
 	netdev->features |= NETIF_F_NETNS_LOCAL;
 }
 
-- 
2.31.1

