Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6E30517A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238867AbhA0E33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:29:29 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8631 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389951AbhA0ALX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 19:11:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a9830001>; Tue, 26 Jan 2021 15:45:07 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:45:06 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Maor Dickman <maord@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 07/12] net/mlx5e: Disable hw-tc-offload when MLX5_CLS_ACT config is disabled
Date:   Tue, 26 Jan 2021 15:43:40 -0800
Message-ID: <20210126234345.202096-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126234345.202096-1-saeedm@nvidia.com>
References: <20210126234345.202096-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611704707; bh=HsZv92VbRPkLPdyMax7M1yYXohdIOcoKCJduspTVyhE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=YXJIPjfxb3RLn9P9SfHw5TS1D61ZmP952z8lex0pZWaia1GxRL6lY2/4naAKnSlIM
         7CVtxn8FJPnu9nQIvCz5f44x6i+VTPL6JJCyqgnS4L7Yzvv36MCdmDuCtsbUC/fRpD
         x1fxo038BWjy/WukKeBA/pu2WoRkS6kjMhI4s5uljYFGS2JsB34fyjxmmRNcbGzwJ4
         Lg5diKdVZ/Y4pxUM63n9Aa4aphpZltfGrC5gOPvUdDrMV2p5eR2bsf6vzBozTGoZ2d
         yoYGSiVDfqihW7w7WLUs88yfkRkC3rdY/28b/hn25gTUHdxLEgou10mQLKqmBvivrc
         sLvI8KgHaXe5g==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

The cited commit introduce new CONFIG_MLX5_CLS_ACT kconfig variable
to control compilation of TC hardware offloads implementation.
When this configuration is disabled the driver is still wrongly
reports in ethtool that hw-tc-offload is supported.

Fixed by reporting hw-tc-offload is supported only when
CONFIG_MLX5_CLS_ACT is enabled.

Fixes: d956873f908c ("net/mlx5e: Introduce kconfig var for TC support")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 6a852b4901aa..300e0e9f96b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5027,7 +5027,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 	    FT_CAP(modify_root) &&
 	    FT_CAP(identified_miss_table_mode) &&
 	    FT_CAP(flow_table_modify)) {
-#ifdef CONFIG_MLX5_ESWITCH
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 		netdev->hw_features      |=3D NETIF_F_HW_TC;
 #endif
 #ifdef CONFIG_MLX5_EN_ARFS
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en_rep.c
index 989c70c1eda3..f0ceae65f6cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -737,7 +737,9 @@ static void mlx5e_build_rep_netdev(struct net_device *n=
etdev)
=20
 	netdev->features       |=3D NETIF_F_NETNS_LOCAL;
=20
+#if IS_ENABLED(CONFIG_MLX5_CLS_ACT)
 	netdev->hw_features    |=3D NETIF_F_HW_TC;
+#endif
 	netdev->hw_features    |=3D NETIF_F_SG;
 	netdev->hw_features    |=3D NETIF_F_IP_CSUM;
 	netdev->hw_features    |=3D NETIF_F_IPV6_CSUM;
--=20
2.29.2

