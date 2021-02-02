Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CCF30C920
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238084AbhBBSKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:10:16 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:17849 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238285AbhBBSH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:07:28 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994b80000>; Tue, 02 Feb 2021 10:06:48 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:45 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 7/8] mlxsw: ethtool: Pass link mode in use to ethtool
Date:   Tue, 2 Feb 2021 20:06:11 +0200
Message-ID: <20210202180612.325099-8-danieller@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210202180612.325099-1-danieller@nvidia.com>
References: <20210202180612.325099-1-danieller@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612289208; bh=bfdiMz1Kq3100r/7mB6NmR7jTT1MQSkhFdBUlns9568=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=MM+TdlHEJhSr1WkCqG9n+X1I7S0TaDRDc+5PcCgTBVdMXkDW+Aiaq2yPuXtxW5XSy
         SgVMG0NThAtTxuetbxMONRiZV1iZz2hjBKa0zEPRmJXrc918IalHYR8qmNrpGJzrxt
         YTrDUCvvNf9PYU4VDAGwKk3XMUxo6QnoqLRqaO9crhj3B8/QYTu1kDV95fy8n/Khbm
         ucjo/69fFehWL8nbSYNRlBSOryrPwn3gdKhc/EQgt2vdQuo0QbN0JP9seab8DettZo
         rcpl2z+YAxLnwXCofqupyw+JzqByJbkW6JOn4TTkdo2fEdI+Ronkx+q+0MEMUGIRTy
         kKUt0cXRYF9cQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when user space queries the link's parameters, as speed and
duplex, each parameter is passed from the driver to ethtool.

Instead, pass the link mode bit in use.
In Spectrum-1, simply pass the bit that is set to '1' from PTYS register.
In Spectrum-2, pass the first link mode bit in the mask of the used
link mode.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---

Notes:
    v2:
    	* Reword commit message.
    	* Pass link mode bit to ethtool instead of link parameters.
    	* Use u32 for lanes param instead ETHTOOL_LANES defines.

 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 47 +++++++++++--------
 2 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.h
index 0ad6b8a581d5..4bf5c4ebc030 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -331,9 +331,9 @@ struct mlxsw_sp_port_type_speed_ops {
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
 			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
-	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
-				       bool carrier_ok, u32 ptys_eth_proto,
-				       struct ethtool_link_ksettings *cmd);
+	void (*from_ptys_link_mode)(struct mlxsw_sp *mlxsw_sp,
+				    bool carrier_ok, u32 ptys_eth_proto,
+				    struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_spe=
ed);
 	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index b0031ae7e623..f3a7b8226912 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -966,8 +966,8 @@ static int mlxsw_sp_port_get_link_ksettings(struct net_=
device *dev,
=20
 	cmd->base.autoneg =3D autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port =3D mlxsw_sp_port_connector_port(connector_type);
-	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
-				    eth_proto_oper, cmd);
+	ops->from_ptys_link_mode(mlxsw_sp, netif_carrier_ok(dev),
+				 eth_proto_oper, cmd);
=20
 	return 0;
 }
@@ -1223,19 +1223,21 @@ mlxsw_sp1_from_ptys_speed(struct mlxsw_sp *mlxsw_sp=
, u32 ptys_eth_proto)
 }
=20
 static void
-mlxsw_sp1_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_o=
k,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp1_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+			      u32 ptys_eth_proto,
+			      struct ethtool_link_ksettings *cmd)
 {
-	cmd->base.speed =3D SPEED_UNKNOWN;
-	cmd->base.duplex =3D DUPLEX_UNKNOWN;
+	int i;
+
+	cmd->link_mode =3D -1;
=20
 	if (!carrier_ok)
 		return;
=20
-	cmd->base.speed =3D mlxsw_sp1_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed !=3D SPEED_UNKNOWN)
-		cmd->base.duplex =3D DUPLEX_FULL;
+	for (i =3D 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp1_port_link_mode[i].mask)
+			cmd->link_mode =3D mlxsw_sp1_port_link_mode[i].mask_ethtool;
+	}
 }
=20
 static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u=
32 *p_max_speed)
@@ -1324,7 +1326,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_p=
ort_type_speed_ops =3D {
 	.from_ptys_supported_port	=3D mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			=3D mlxsw_sp1_from_ptys_link,
 	.from_ptys_speed		=3D mlxsw_sp1_from_ptys_speed,
-	.from_ptys_speed_duplex		=3D mlxsw_sp1_from_ptys_speed_duplex,
+	.from_ptys_link_mode		=3D mlxsw_sp1_from_ptys_link_mode,
 	.ptys_max_speed			=3D mlxsw_sp1_ptys_max_speed,
 	.to_ptys_advert_link		=3D mlxsw_sp1_to_ptys_advert_link,
 	.to_ptys_speed_lanes		=3D mlxsw_sp1_to_ptys_speed_lanes,
@@ -1660,19 +1662,24 @@ mlxsw_sp2_from_ptys_speed(struct mlxsw_sp *mlxsw_sp=
, u32 ptys_eth_proto)
 }
=20
 static void
-mlxsw_sp2_from_ptys_speed_duplex(struct mlxsw_sp *mlxsw_sp, bool carrier_o=
k,
-				 u32 ptys_eth_proto,
-				 struct ethtool_link_ksettings *cmd)
+mlxsw_sp2_from_ptys_link_mode(struct mlxsw_sp *mlxsw_sp, bool carrier_ok,
+			      u32 ptys_eth_proto,
+			      struct ethtool_link_ksettings *cmd)
 {
-	cmd->base.speed =3D SPEED_UNKNOWN;
-	cmd->base.duplex =3D DUPLEX_UNKNOWN;
+	struct mlxsw_sp2_port_link_mode link;
+	int i;
+
+	cmd->link_mode =3D -1;
=20
 	if (!carrier_ok)
 		return;
=20
-	cmd->base.speed =3D mlxsw_sp2_from_ptys_speed(mlxsw_sp, ptys_eth_proto);
-	if (cmd->base.speed !=3D SPEED_UNKNOWN)
-		cmd->base.duplex =3D DUPLEX_FULL;
+	for (i =3D 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) {
+			link =3D mlxsw_sp2_port_link_mode[i];
+			cmd->link_mode =3D link.mask_ethtool[1];
+		}
+	}
 }
=20
 static int mlxsw_sp2_ptys_max_speed(struct mlxsw_sp_port *mlxsw_sp_port, u=
32 *p_max_speed)
@@ -1795,7 +1802,7 @@ const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_p=
ort_type_speed_ops =3D {
 	.from_ptys_supported_port	=3D mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			=3D mlxsw_sp2_from_ptys_link,
 	.from_ptys_speed		=3D mlxsw_sp2_from_ptys_speed,
-	.from_ptys_speed_duplex		=3D mlxsw_sp2_from_ptys_speed_duplex,
+	.from_ptys_link_mode		=3D mlxsw_sp2_from_ptys_link_mode,
 	.ptys_max_speed			=3D mlxsw_sp2_ptys_max_speed,
 	.to_ptys_advert_link		=3D mlxsw_sp2_to_ptys_advert_link,
 	.to_ptys_speed_lanes		=3D mlxsw_sp2_to_ptys_speed_lanes,
--=20
2.26.2

