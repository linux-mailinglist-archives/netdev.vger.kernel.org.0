Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B0F758F2
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfGYUgx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:36:53 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:18494
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfGYUgw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 16:36:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O7w7Rd22NALkRaty5bulmVpoURl2irH/99YOXe1Vv2r8BD7Yfa2lnybnf589dzcH8lDXh95jWohEiT1834OnhVpFtTul4atbE1qaF7v1OXYrbzZMdqEVMsw2y7htkhdY3ZdE4/99OA13fhi7Yt9eKj6vuNXCE6rRGuiUz+rhPtNBK3ZSWLfQUw+VvrdZM7zy/Ndidf29d5oJY0eXaPcyxKtIFmIcJi6eB9vhSwaeHnNbjtrtOhzCSnqqvFWSIx+gzGKSro81ird71mcI3YrOkKJ6N5gdCJf8W9NGgh26hOmpeitt9KbeBfWvHmrdFpC+euFomnlDlxRz+ZeoB3S8dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljRRGgwDvPV/gl3YEJZpT1RlVOlt3rkNYqC9OMrhx7I=;
 b=AWkL+bhAiMD9LGG5fFgizx8Tg9yPYftQ2GI+MglUd5xyOlZ3/oMR7XDG1nAfo5sQTJNsitU2Bzio4e7nVxXGkcyl4EnXC8p7lNSBxyDRNdciYB9WfCHe5FkjDgF5v5QzNJDpCFd02oMzWb6lQ4C7FMNX0urJ9FFK7DZ/cpYZiljNbStzQKNsyOfmF9Ua/zMBVg8MtxE50nJpxaW4KGLCXR+DkalYS12ot7MTChoxJY6WtHNTVFiMKaQfQaffh4DE88whkCFvrABQyKs+yZ+vfj6yrFz+PzirEXzzLXRwT0jUjchkZk3FMiYrN79mbOSfv77qDl22J0UAI+r0+Wqjnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ljRRGgwDvPV/gl3YEJZpT1RlVOlt3rkNYqC9OMrhx7I=;
 b=UZ+2/DtqSaIov1b2V7uz/4dyms5UcDEC4/d8TW5mft4ARNdCLRrL4s6+Ge0AlKF+/FZ/sTx/FPIr/V3U1rX7xvqHooEOW/xUPP5GTYkngWARN+6gPfZXXAgrLgCVIqZHF2rmd5B/EbpA9kFG8wYd1uuSxKhdn7FP7LQxRftb8V8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2504.eurprd05.prod.outlook.com (10.168.76.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 20:36:44 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 20:36:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/9] net/mlx5e: Fix matching of speed to PRM link modes
Thread-Topic: [net 5/9] net/mlx5e: Fix matching of speed to PRM link modes
Thread-Index: AQHVQyisoHPz05/P8kKgRKN9zbis/Q==
Date:   Thu, 25 Jul 2019 20:36:44 +0000
Message-ID: <20190725203618.11011-6-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
In-Reply-To: <20190725203618.11011-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0042.namprd02.prod.outlook.com
 (2603:10b6:a03:54::19) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0be9e69d-0e2a-4d8a-3c3d-08d7113fce7c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2504;
x-ms-traffictypediagnostic: DB6PR0501MB2504:
x-microsoft-antispam-prvs: <DB6PR0501MB250482E1A412989484D95383BEC10@DB6PR0501MB2504.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(136003)(376002)(346002)(396003)(189003)(199004)(2906002)(6512007)(25786009)(305945005)(81166006)(7736002)(8936002)(53936002)(71190400001)(107886003)(476003)(6436002)(2616005)(50226002)(186003)(52116002)(1076003)(71200400001)(386003)(99286004)(6506007)(6116002)(36756003)(14444005)(256004)(81156014)(478600001)(316002)(446003)(11346002)(64756008)(86362001)(66446008)(30864003)(14454004)(6916009)(8676002)(66946007)(66476007)(4326008)(54906003)(68736007)(66556008)(26005)(76176011)(6486002)(66066001)(486006)(5660300002)(102836004)(19627235002)(3846002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2504;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: unNdrI2Cg5ON0DHnX3HzCViaDhjg4/pQpyNVbLKRURgGl0XqmZ2sN+nvbqbEx7jxn97JlX8mMW7D4q15XcQIq13IYjPn1GRooFrYz+/MOb+uLC+q409h8Bd8AHR45aOorFp83G+7TZJ4NP/tsnItVN/DjKIxmfTLS+xCh9UwMry7dvzstyhjtk51o4xYqMv7axbJcAWqVH/GZ6ka0EFiaUVkEo8bPq/Cy+SdQ02MJ3ehVAedP4u4yyOxwwivQvXSZ8fm+Ww64Kv7I7seZscwXZlUiWNtKw9Ve58go9GNIHGAiXFsaCr6Ak7NzfyjYI5LntavrpeMpJCykFoda8x7ReRfjyFtWwtloIiqPpxE3Irbe/d4uWtRRM3ufQI6a7iLi/SQfltJGLBTnNZyMzYw07eye500SjvR4aplGCZSXP0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0be9e69d-0e2a-4d8a-3c3d-08d7113fce7c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 20:36:44.3593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2504
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Speed translation is performed based on legacy or extended PTYS
register. Translate speed with respect to:
1) Capability bit of extended PTYS table.
2) User request:
 a) When auto-negotiation is turned on, inspect advertisement whether it
 contains extended link modes.
 b) When auto-negotiation is turned off, speed > 100Gbps (maximal
 speed supported in legacy mode).
With both conditions fulfilled translation is done with extended PTYS
table otherwise use legacy PTYS table.
Without this patch 25/50/100 Gbps speed cannot be set, since try to
configure in extended mode but read from legacy mode.

Fixes: dd1b9e09c12b ("net/mlx5: ethtool, Allow legacy link-modes configurat=
ion via non-extended ptys")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 27 +++++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  6 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 67 +++++++++++++------
 3 files changed, 68 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.c
index d5e5afbdca6d..f777994f3005 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -78,9 +78,10 @@ static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MOD=
ES_NUMBER] =3D {
 };
=20
 static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
-				     const u32 **arr, u32 *size)
+				     const u32 **arr, u32 *size,
+				     bool force_legacy)
 {
-	bool ext =3D MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext =3D force_legacy ? false : MLX5_CAP_PCAM_FEATURE(mdev, ptys_exte=
nded_ethernet);
=20
 	*size =3D ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
 		      ARRAY_SIZE(mlx5e_link_speed);
@@ -152,7 +153,8 @@ int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, b=
ool an_disable,
 			    sizeof(out), MLX5_REG_PTYS, 0, 1);
 }
=20
-u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper)
+u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
+			  bool force_legacy)
 {
 	unsigned long temp =3D eth_proto_oper;
 	const u32 *table;
@@ -160,7 +162,7 @@ u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u=
32 eth_proto_oper)
 	u32 max_size;
 	int i;
=20
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
 	i =3D find_first_bit(&temp, max_size);
 	if (i < max_size)
 		speed =3D table[i];
@@ -170,6 +172,7 @@ u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u=
32 eth_proto_oper)
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
 	struct mlx5e_port_eth_proto eproto;
+	bool force_legacy =3D false;
 	bool ext;
 	int err;
=20
@@ -177,8 +180,13 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u=
32 *speed)
 	err =3D mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		goto out;
-
-	*speed =3D mlx5e_port_ptys2speed(mdev, eproto.oper);
+	if (ext && !eproto.admin) {
+		force_legacy =3D true;
+		err =3D mlx5_port_query_eth_proto(mdev, 1, false, &eproto);
+		if (err)
+			goto out;
+	}
+	*speed =3D mlx5e_port_ptys2speed(mdev, eproto.oper, force_legacy);
 	if (!(*speed))
 		err =3D -EINVAL;
=20
@@ -201,7 +209,7 @@ int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev=
, u32 *speed)
 	if (err)
 		return err;
=20
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, false);
 	for (i =3D 0; i < max_size; ++i)
 		if (eproto.cap & MLX5E_PROT_MASK(i))
 			max_speed =3D max(max_speed, table[i]);
@@ -210,14 +218,15 @@ int mlx5e_port_max_linkspeed(struct mlx5_core_dev *md=
ev, u32 *speed)
 	return 0;
 }
=20
-u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed)
+u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
+			       bool force_legacy)
 {
 	u32 link_modes =3D 0;
 	const u32 *table;
 	u32 max_size;
 	int i;
=20
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
 	for (i =3D 0; i < max_size; ++i) {
 		if (table[i] =3D=3D speed)
 			link_modes |=3D MLX5E_PROT_MASK(i);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/port.h
index 70f536ec51c4..4a7f4497692b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -48,10 +48,12 @@ void mlx5_port_query_eth_autoneg(struct mlx5_core_dev *=
dev, u8 *an_status,
 				 u8 *an_disable_cap, u8 *an_disable_admin);
 int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
 			   u32 proto_admin, bool ext);
-u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper);
+u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
+			  bool force_legacy);
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
-u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed);
+u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
+			       bool force_legacy);
=20
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ed25757ac5bd..03bed714bac3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -785,7 +785,7 @@ static void ptys2ethtool_supported_advertised_port(stru=
ct ethtool_link_ksettings
 }
=20
 static void get_speed_duplex(struct net_device *netdev,
-			     u32 eth_proto_oper,
+			     u32 eth_proto_oper, bool force_legacy,
 			     struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5e_priv *priv =3D netdev_priv(netdev);
@@ -795,7 +795,7 @@ static void get_speed_duplex(struct net_device *netdev,
 	if (!netif_carrier_ok(netdev))
 		goto out;
=20
-	speed =3D mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper);
+	speed =3D mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper, force_legacy)=
;
 	if (!speed) {
 		speed =3D SPEED_UNKNOWN;
 		goto out;
@@ -914,8 +914,8 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv =
*priv,
 	/* Fields: eth_proto_admin and ext_eth_proto_admin  are
 	 * mutually exclusive. Hence try reading legacy advertising
 	 * when extended advertising is zero.
-	 * admin_ext indicates how eth_proto_admin should be
-	 * interpreted
+	 * admin_ext indicates which proto_admin (ext vs. legacy)
+	 * should be read and interpreted
 	 */
 	admin_ext =3D ext;
 	if (ext && !eth_proto_admin) {
@@ -924,7 +924,7 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv =
*priv,
 		admin_ext =3D false;
 	}
=20
-	eth_proto_oper   =3D MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
+	eth_proto_oper   =3D MLX5_GET_ETH_PROTO(ptys_reg, out, admin_ext,
 					      eth_proto_oper);
 	eth_proto_lp	    =3D MLX5_GET(ptys_reg, out, eth_proto_lp_advertise);
 	an_disable_admin    =3D MLX5_GET(ptys_reg, out, an_disable_admin);
@@ -939,7 +939,8 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv =
*priv,
 	get_supported(mdev, eth_proto_cap, link_ksettings);
 	get_advertising(eth_proto_admin, tx_pause, rx_pause, link_ksettings,
 			admin_ext);
-	get_speed_duplex(priv->netdev, eth_proto_oper, link_ksettings);
+	get_speed_duplex(priv->netdev, eth_proto_oper, !admin_ext,
+			 link_ksettings);
=20
 	eth_proto_oper =3D eth_proto_oper ? eth_proto_oper : eth_proto_cap;
=20
@@ -1016,45 +1017,69 @@ static u32 mlx5e_ethtool2ptys_ext_adver_link(const =
unsigned long *link_modes)
 	return ptys_modes;
 }
=20
+static bool ext_link_mode_requested(const unsigned long *adver)
+{
+#define MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT ETHTOOL_LINK_MODE_50000baseKR_Ful=
l_BIT
+	int size =3D __ETHTOOL_LINK_MODE_MASK_NBITS - MLX5E_MIN_PTYS_EXT_LINK_MOD=
E_BIT;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes);
+
+	bitmap_set(modes, MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT, size);
+	return bitmap_intersects(modes, adver, __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static bool ext_speed_requested(u32 speed)
+{
+#define MLX5E_MAX_PTYS_LEGACY_SPEED 100000
+	return !!(speed > MLX5E_MAX_PTYS_LEGACY_SPEED);
+}
+
+static bool ext_requested(u8 autoneg, const unsigned long *adver, u32 spee=
d)
+{
+	bool ext_link_mode =3D ext_link_mode_requested(adver);
+	bool ext_speed =3D ext_speed_requested(speed);
+
+	return  autoneg =3D=3D AUTONEG_ENABLE ? ext_link_mode : ext_speed;
+}
+
 int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 				     const struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5_core_dev *mdev =3D priv->mdev;
 	struct mlx5e_port_eth_proto eproto;
+	const unsigned long *adver;
 	bool an_changes =3D false;
 	u8 an_disable_admin;
 	bool ext_supported;
-	bool ext_requested;
 	u8 an_disable_cap;
 	bool an_disable;
 	u32 link_modes;
 	u8 an_status;
+	u8 autoneg;
 	u32 speed;
+	bool ext;
 	int err;
=20
 	u32 (*ethtool2ptys_adver_func)(const unsigned long *adver);
=20
-#define MLX5E_PTYS_EXT ((1ULL << ETHTOOL_LINK_MODE_50000baseKR_Full_BIT) -=
 1)
+	adver =3D link_ksettings->link_modes.advertising;
+	autoneg =3D link_ksettings->base.autoneg;
+	speed =3D link_ksettings->base.speed;
=20
-	ext_requested =3D !!(link_ksettings->link_modes.advertising[0] >
-			MLX5E_PTYS_EXT ||
-			link_ksettings->link_modes.advertising[1]);
+	ext =3D ext_requested(autoneg, adver, speed),
 	ext_supported =3D MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
-	ext_requested &=3D ext_supported;
+	if (!ext_supported && ext)
+		return -EOPNOTSUPP;
=20
-	speed =3D link_ksettings->base.speed;
-	ethtool2ptys_adver_func =3D ext_requested ?
-				  mlx5e_ethtool2ptys_ext_adver_link :
+	ethtool2ptys_adver_func =3D ext ? mlx5e_ethtool2ptys_ext_adver_link :
 				  mlx5e_ethtool2ptys_adver_link;
-	err =3D mlx5_port_query_eth_proto(mdev, 1, ext_requested, &eproto);
+	err =3D mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err) {
 		netdev_err(priv->netdev, "%s: query port eth proto failed: %d\n",
 			   __func__, err);
 		goto out;
 	}
-	link_modes =3D link_ksettings->base.autoneg =3D=3D AUTONEG_ENABLE ?
-		ethtool2ptys_adver_func(link_ksettings->link_modes.advertising) :
-		mlx5e_port_speed2linkmodes(mdev, speed);
+	link_modes =3D autoneg =3D=3D AUTONEG_ENABLE ? ethtool2ptys_adver_func(ad=
ver) :
+		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
=20
 	link_modes =3D link_modes & eproto.cap;
 	if (!link_modes) {
@@ -1067,14 +1092,14 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_p=
riv *priv,
 	mlx5_port_query_eth_autoneg(mdev, &an_status, &an_disable_cap,
 				    &an_disable_admin);
=20
-	an_disable =3D link_ksettings->base.autoneg =3D=3D AUTONEG_DISABLE;
+	an_disable =3D autoneg =3D=3D AUTONEG_DISABLE;
 	an_changes =3D ((!an_disable && an_disable_admin) ||
 		      (an_disable && !an_disable_admin));
=20
 	if (!an_changes && link_modes =3D=3D eproto.admin)
 		goto out;
=20
-	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext_requested);
+	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext);
 	mlx5_toggle_port_link(mdev);
=20
 out:
--=20
2.21.0

