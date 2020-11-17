Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3312B6F9F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgKQUHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:41 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:6732 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726851AbgKQUHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:41 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d970002>; Tue, 17 Nov 2020 12:07:51 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:40 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Maor Dickman" <maord@nvidia.com>, Raed Salem <raeds@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 4/9] net/mlx5e: Fix check if netdev is bond slave
Date:   Tue, 17 Nov 2020 11:56:57 -0800
Message-ID: <20201117195702.386113-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643671; bh=WTx1xh54M/EJuL69XqRfAXWxNabOsDEwfYzqtP55qZQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=hXI+M9j8ph3htJUDANnLjJU2u2KWKVmujsP3Td8oy+3IYLkc5BVaIAueenyrXSWqY
         EkX9aJFNcxI4WSUnfe3X1zVjqJWDV+4RtuWCuW/7kiQyulz1AiXWX1OfOVPZjZbgRm
         LoIRMv1nAp1IvM/kg+hju2ORZUUTZ7tEURoK63fieTapPJrYzn7atUOi1n2JqvITMV
         moWxcIbt18fHMDfsYzgAUk4ScohVd5FCnUuAL6ZXD+MPGEZUBEOYv+51Hk857sSnUN
         XitGB2MymSuEWGCz/BgBnd3ENgqIteWb96xEVYdjcG5yAZL/BEsmGp2HLvSwumuLi6
         KdOuFIlaD3Plw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Bond events handler uses bond_slave_get_rtnl to check if net device
is bond slave. bond_slave_get_rtnl return the rcu rx_handler pointer
from the netdev which exists for bond slaves but also exists for
devices that are attached to linux bridge so using it as indication
for bond slave is wrong.

Fix by using netif_is_lag_port instead.

Fixes: 7e51891a237f ("net/mlx5e: Use netdev events to set/del egress acl fo=
rward-to-vport rule")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c b/driver=
s/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
index 3e44e4d820c5..95f2b26a3ee3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/bond.c
@@ -187,7 +187,7 @@ static bool mlx5e_rep_is_lag_netdev(struct net_device *=
netdev)
 	struct mlx5e_priv *priv;
=20
 	/* A given netdev is not a representor or not a slave of LAG configuratio=
n */
-	if (!mlx5e_eswitch_rep(netdev) || !bond_slave_get_rtnl(netdev))
+	if (!mlx5e_eswitch_rep(netdev) || !netif_is_lag_port(netdev))
 		return false;
=20
 	priv =3D netdev_priv(netdev);
--=20
2.26.2

