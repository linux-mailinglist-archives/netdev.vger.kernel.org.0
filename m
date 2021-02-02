Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB78930C921
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 19:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhBBSKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 13:10:41 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2808 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237346AbhBBSIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 13:08:25 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B601994b20000>; Tue, 02 Feb 2021 10:06:42 -0800
Received: from dev-r-vrt-156.mtr.labs.mlnx (172.20.145.6) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 2 Feb 2021 18:06:39 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@nvidia.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <mkubecek@suse.cz>,
        <mlxsw@nvidia.com>, <idosch@nvidia.com>,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v4 5/8] mlxsw: ethtool: Remove max lanes filtering
Date:   Tue, 2 Feb 2021 20:06:09 +0200
Message-ID: <20210202180612.325099-6-danieller@nvidia.com>
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
        t=1612289202; bh=L57M6JieDqsPW1h6jc90uuqXy7tgZ6ZwimGLR5QYdi8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=aVx2x3WZrKg4ee0AFziDUieq1LpPwo3gH9HgLsahnt7WYreTPzL7++ED9yHHcpJgV
         3pshdEGh9YeGlN3kjMcGBvTj4UzZg8iiZrWDnfzfk/Omc0Jvcl4D2tBp/Kr33hddGy
         9GbziY23KBPmrCqmyrC8vuYOHehS397OY3AZrpNHaGzPpE62FlgUq/HnxF4wgj0V/8
         VX4uYHpcCki20HtTWwe0BQcNb2ETwyF9wW8eFEyCapOHrn4Pr1AvxbmyfpxUXOKJiT
         y2vzM0lQdNfdMzwksKd6s5+OAsMcSJLfBDBJP5NZH6zHVtlQHaBAHW3E2gVaPE7OcF
         BzwbBTsZ927Aw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a speed can be supported by different number of lanes,
the supported link modes bitmask contains only link modes with a single
number of lanes.

This was done in order to prevent auto negotiation on number of
lanes after 50G-1-lane and 100G-2-lanes link modes were introduced.

For example, if a port's max width is 4, only link modes with 4 lanes
will be presented as supported by that port, so 100G is always achieved by
4 lanes of 25G.

After the previous patches that allow selection of the number of lanes,
auto negotiation on number of lanes becomes practical.

Remove that filtering of the maximum number of lanes supported link modes,
so indeed all the supported and advertised link modes will be shown.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +--
 .../mellanox/mlxsw/spectrum_ethtool.c         | 33 ++++++++-----------
 2 files changed, 15 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/e=
thernet/mellanox/mlxsw/spectrum.h
index b1b593076a76..cc4aeb3cdd10 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -329,13 +329,13 @@ struct mlxsw_sp_port_type_speed_ops {
 					 u32 ptys_eth_proto,
 					 struct ethtool_link_ksettings *cmd);
 	void (*from_ptys_link)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			       u8 width, unsigned long *mode);
+			       unsigned long *mode);
 	u32 (*from_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto);
 	void (*from_ptys_speed_duplex)(struct mlxsw_sp *mlxsw_sp,
 				       bool carrier_ok, u32 ptys_eth_proto,
 				       struct ethtool_link_ksettings *cmd);
 	int (*ptys_max_speed)(struct mlxsw_sp_port *mlxsw_sp_port, u32 *p_max_spe=
ed);
-	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp, u8 width,
+	u32 (*to_ptys_advert_link)(struct mlxsw_sp *mlxsw_sp,
 				   const struct ethtool_link_ksettings *cmd);
 	u32 (*to_ptys_speed)(struct mlxsw_sp *mlxsw_sp, u8 width, u32 speed);
 	void (*reg_ptys_eth_pack)(struct mlxsw_sp *mlxsw_sp, char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drive=
rs/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 41288144852d..aa13af0f33f0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -858,7 +858,7 @@ static int mlxsw_sp_port_get_sset_count(struct net_devi=
ce *dev, int sset)
=20
 static void
 mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_=
cap,
-				 u8 width, struct ethtool_link_ksettings *cmd)
+				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
=20
@@ -869,13 +869,13 @@ mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlx=
sw_sp, u32 eth_proto_cap,
 	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
=20
 	ops->from_ptys_supported_port(mlxsw_sp, eth_proto_cap, cmd);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, width,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_cap,
 			    cmd->link_modes.supported);
 }
=20
 static void
 mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
-				 u32 eth_proto_admin, bool autoneg, u8 width,
+				 u32 eth_proto_admin, bool autoneg,
 				 struct ethtool_link_ksettings *cmd)
 {
 	const struct mlxsw_sp_port_type_speed_ops *ops;
@@ -886,7 +886,7 @@ mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw=
_sp,
 		return;
=20
 	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_admin, width,
+	ops->from_ptys_link(mlxsw_sp, eth_proto_admin,
 			    cmd->link_modes.advertising);
 }
=20
@@ -960,11 +960,9 @@ static int mlxsw_sp_port_get_link_ksettings(struct net=
_device *dev,
 	ops =3D mlxsw_sp->port_type_speed_ops;
 	autoneg =3D mlxsw_sp_port->link.autoneg;
=20
-	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
-					 mlxsw_sp_port->mapping.width, cmd);
+	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap, cmd);
=20
-	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg,
-					 mlxsw_sp_port->mapping.width, cmd);
+	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg, cmd)=
;
=20
 	cmd->base.autoneg =3D autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
 	cmd->base.port =3D mlxsw_sp_port_connector_port(connector_type);
@@ -997,8 +995,7 @@ mlxsw_sp_port_set_link_ksettings(struct net_device *dev=
,
=20
 	autoneg =3D cmd->base.autoneg =3D=3D AUTONEG_ENABLE;
 	eth_proto_new =3D autoneg ?
-		ops->to_ptys_advert_link(mlxsw_sp, mlxsw_sp_port->mapping.width,
-					 cmd) :
+		ops->to_ptys_advert_link(mlxsw_sp, cmd) :
 		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
 				   cmd->base.speed);
=20
@@ -1200,7 +1197,7 @@ mlxsw_sp1_from_ptys_supported_port(struct mlxsw_sp *m=
lxsw_sp,
=20
 static void
 mlxsw_sp1_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
+			 unsigned long *mode)
 {
 	int i;
=20
@@ -1262,7 +1259,7 @@ static int mlxsw_sp1_ptys_max_speed(struct mlxsw_sp_p=
ort *mlxsw_sp_port, u32 *p_
 }
=20
 static u32
-mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+mlxsw_sp1_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 			      const struct ethtool_link_ksettings *cmd)
 {
 	u32 ptys_proto =3D 0;
@@ -1621,14 +1618,12 @@ mlxsw_sp2_set_bit_ethtool(const struct mlxsw_sp2_po=
rt_link_mode *link_mode,
=20
 static void
 mlxsw_sp2_from_ptys_link(struct mlxsw_sp *mlxsw_sp, u32 ptys_eth_proto,
-			 u8 width, unsigned long *mode)
+			 unsigned long *mode)
 {
-	u8 mask_width =3D mlxsw_sp_port_mask_width_get(width);
 	int i;
=20
 	for (i =3D 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask) &&
-		    (mask_width & mlxsw_sp2_port_link_mode[i].mask_width))
+		if (ptys_eth_proto & mlxsw_sp2_port_link_mode[i].mask)
 			mlxsw_sp2_set_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 						  mode);
 	}
@@ -1700,16 +1695,14 @@ mlxsw_sp2_test_bit_ethtool(const struct mlxsw_sp2_p=
ort_link_mode *link_mode,
 }
=20
 static u32
-mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp, u8 width,
+mlxsw_sp2_to_ptys_advert_link(struct mlxsw_sp *mlxsw_sp,
 			      const struct ethtool_link_ksettings *cmd)
 {
-	u8 mask_width =3D mlxsw_sp_port_mask_width_get(width);
 	u32 ptys_proto =3D 0;
 	int i;
=20
 	for (i =3D 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
-		if ((mask_width & mlxsw_sp2_port_link_mode[i].mask_width) &&
-		    mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
+		if (mlxsw_sp2_test_bit_ethtool(&mlxsw_sp2_port_link_mode[i],
 					       cmd->link_modes.advertising))
 			ptys_proto |=3D mlxsw_sp2_port_link_mode[i].mask;
 	}
--=20
2.26.2

