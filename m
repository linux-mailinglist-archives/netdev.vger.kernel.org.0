Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D2C30517F
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbhA0E2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:28:12 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5016 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388704AbhAZXZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:30 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4c20000>; Tue, 26 Jan 2021 15:24:50 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:49 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 13/14] net/mlx5e: Add listener to DMAC filter trap event
Date:   Tue, 26 Jan 2021 15:24:18 -0800
Message-ID: <20210126232419.175836-14-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703490; bh=RNHs/J9ouQJZh6jxeD7svrEmNQatuQbe17bZbpRu3T4=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=WsluKBaJyV+4nUm91eiW62SFHe4YV9x60C8Lnas3x8Nwl3KvEyCRdrjXxEWUBKoMI
         bV6S+0mRUCBEenmTkVSQRCXiZinKt+51YMFqoX4rL6jO+zfoRxhTze/fuVXC5JHqpe
         XF0gmvdDikR30E/h857PkRe+bxpV1gBfRJCslpTbqH+K3la9Lke3gSK6/mAOmmzM6M
         2GbmF6OOznSsuJWG8yN4MqFsyjW+Oh7LonazVRd5VtuN0nBJpP5AwWuPFZRPUPhQI6
         K13JkaY/EjsBKYBocXluNbS0Zja3c1nzyrnJ5LVg7M0rJAz6spUCyi7+Mblsm3QDzs
         Np9puXibfyhDA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add support for trapping packets which didn't match any DMAC in the MAC
table. Add a listener which adds/removes MAC trap rule in the flow
steering according to the trap's action trap/drop.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/trap.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/trap.c
index 5507efacb9dc..d078281dbd1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -360,6 +360,11 @@ static int mlx5e_handle_action_trap(struct mlx5e_priv =
*priv, int trap_id)
 		if (err)
 			goto err_out;
 		break;
+	case DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER:
+		err =3D mlx5e_add_mac_trap(priv, trap_id, mlx5e_trap_get_tirn(priv->en_t=
rap));
+		if (err)
+			goto err_out;
+		break;
 	default:
 		netdev_warn(priv->netdev, "%s: Unknown trap id %d\n", __func__, trap_id)=
;
 		err =3D -EINVAL;
@@ -379,6 +384,9 @@ static int mlx5e_handle_action_drop(struct mlx5e_priv *=
priv, int trap_id)
 	case DEVLINK_TRAP_GENERIC_ID_INGRESS_VLAN_FILTER:
 		mlx5e_remove_vlan_trap(priv);
 		break;
+	case DEVLINK_TRAP_GENERIC_ID_DMAC_FILTER:
+		mlx5e_remove_mac_trap(priv);
+		break;
 	default:
 		netdev_warn(priv->netdev, "%s: Unknown trap id %d\n", __func__, trap_id)=
;
 		return -EINVAL;
--=20
2.29.2

