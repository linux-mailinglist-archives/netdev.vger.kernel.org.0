Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680CA79D12
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 01:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfG2XwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 19:52:08 -0400
Received: from mail-eopbgr130080.outbound.protection.outlook.com ([40.107.13.80]:10726
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726190AbfG2XwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 19:52:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cjQ0wwpgVjZq0Ju5dSOC1GXOsEj6FrRfO/yusEbvSziOWRBpy5NduMRYGnJUfKVvlW+2hiTNCjzatSFvP0MoFYJYHSDaIoe6hrmbGNIqj95ZBTWA/9n8DY4qoXVJ5p98b29MeicVe0sS6zbfWUfxmEy6kP0J+u5fQhScNTuO6G8tc0cD26Eodx+DxdyeGT0kHBipummh0qYJ+MLN9lchpEqLP8Fxz/5MiYJ6Xq+q3Q2/60wbhwsU1GMTeNiM7LsKegF7K9RzK1Ak/D1nzphUxz5LaNJ2dLX4mC9HxE2Gu2APvYAC6jAR4kAf4+OYFC0rrtaeo2xYZvgnv6+gxbyF7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2wOJUgf9e+zN4qR2vjMOFtTDQKDqGSm4TfdZ3NXu24=;
 b=DpYde90/L7bOVrgfRvQlw+FtVRV0lordIYmeS/kW/FgM3GwBxavPv/MVkI+RbTmGzIdYMc8gphSpAv4UjVzFgPEZHfvvsOqBXl9C9AoAmEpWRCH3EESrIV/RHq4kV6Rq5ItJzTmk45c9uEMSNTrwd+7URcirA1hQkCT0OeHbIOiYlVBD7b7QgUHCG1nba0scjYifKcagsPENWNfh9OB8tZqV9uo5ns/aH+sku2vfb3zNBH9lEKVjpdDVGGPgI+2QNk/WMPEcSIH9rHEJHdGP5uEHjYjVJoCjs15/3WgkVo7U3NX3S+5slPOidzay8L/5d9hPDTufKXfyINCh4tDXng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2wOJUgf9e+zN4qR2vjMOFtTDQKDqGSm4TfdZ3NXu24=;
 b=NcLpPpZbnj0SAgCCGIsRhDjvSonMouyvwVF7VgXzZsPvSysEfKvnMvft+2U6GSPD0W77XdukTHKZxnETOFIoTKc98n0RUNXGq33f4OzBnh8f4YRd0iUWwJiU2g1lMc8EVEKZhskcwHEcPn77nDnTm1F5ZU5mi+ZU5LuCwuIq1ps=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2343.eurprd05.prod.outlook.com (10.168.56.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Mon, 29 Jul 2019 23:50:35 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 23:50:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/13] net/mlx5e: Rely on rcu instead of rtnl lock when
 getting upper dev
Thread-Topic: [net-next 12/13] net/mlx5e: Rely on rcu instead of rtnl lock
 when getting upper dev
Thread-Index: AQHVRmhqNinvtjwD5EqxyYKTx9nD5A==
Date:   Mon, 29 Jul 2019 23:50:34 +0000
Message-ID: <20190729234934.23595-13-saeedm@mellanox.com>
References: <20190729234934.23595-1-saeedm@mellanox.com>
In-Reply-To: <20190729234934.23595-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0015.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::28) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e40e5dfb-0836-48a3-725c-08d7147f8c84
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2343;
x-ms-traffictypediagnostic: DB6PR0501MB2343:
x-microsoft-antispam-prvs: <DB6PR0501MB23439C4E81D6980D8BB58D79BEDD0@DB6PR0501MB2343.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(199004)(189003)(14454004)(25786009)(71190400001)(71200400001)(386003)(6506007)(6512007)(81166006)(81156014)(76176011)(8936002)(6436002)(8676002)(6486002)(316002)(102836004)(54906003)(6916009)(7736002)(478600001)(52116002)(186003)(26005)(99286004)(14444005)(256004)(476003)(5660300002)(1076003)(66446008)(66066001)(66556008)(66476007)(64756008)(36756003)(53936002)(486006)(86362001)(305945005)(107886003)(66946007)(68736007)(446003)(2616005)(11346002)(50226002)(6116002)(3846002)(4326008)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2343;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kenvRA1+1ezNFcqktdYOTC2NGtI30T4oqYzq8i/wykHKnvfIYBHvqv0S0OcwVy0uUgz24SXSSOJa3Rru6zsoJbjk0tcPd8unEHpiYUHIYfM1HY73WunlYf+87tN5XYRlIBhONsxCliXN3+RahAvNTUPkGtno7ruVW/bEnmxCTe1PqsV+2SyaOtOmIwxQ8yEOa/lklbV64vSu22l+yt1b/uFtZxpYXXsh8A3ew2P/6vs/6SBQSNYyppQgqUQoK0NI9irej8+NAKjmWHo22/j1tqaI5G6P4hATICTXnzYZ9MTZesEvMSh0A34iV7/HZ7PCgAbsLUkjqqPE4keH2+q4ecpOKzRgA3yhpyUF+O+Tj7MZBDde0mot25Hf1pbuy7iNko9TIv/Nfov2BtiC1lU3Am58rOslQv7z8Knc4AS7MlE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e40e5dfb-0836-48a3-725c-08d7147f8c84
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 23:50:34.8936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2343
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Function netdev_master_upper_dev_get() generates warning if caller doesn't
hold rtnl lock. Modify rules update path to use rcu version of that
function.

Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 14 +++++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  6 +++++-
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index ae439d95f5a3..4c4620db3d31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -31,11 +31,23 @@ static int get_route_and_out_devs(struct mlx5e_priv *pr=
iv,
=20
 	real_dev =3D is_vlan_dev(dev) ? vlan_dev_real_dev(dev) : dev;
 	uplink_dev =3D mlx5_eswitch_uplink_get_proto_dev(esw, REP_ETH);
-	uplink_upper =3D netdev_master_upper_dev_get(uplink_dev);
+
+	rcu_read_lock();
+	uplink_upper =3D netdev_master_upper_dev_get_rcu(uplink_dev);
+	/* mlx5_lag_is_sriov() is a blocking function which can't be called
+	 * while holding rcu read lock. Take the net_device for correctness
+	 * sake.
+	 */
+	if (uplink_upper)
+		dev_hold(uplink_upper);
+	rcu_read_unlock();
+
 	dst_is_lag_dev =3D (uplink_upper &&
 			  netif_is_lag_master(uplink_upper) &&
 			  real_dev =3D=3D uplink_upper &&
 			  mlx5_lag_is_sriov(priv->mdev));
+	if (uplink_upper)
+		dev_put(uplink_upper);
=20
 	/* if the egress device isn't on the same HW e-switch or
 	 * it's a LAG device, use the uplink
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index 714aa9d7180b..595a4c5667ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -2978,12 +2978,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *=
priv,
 			if (netdev_port_same_parent_id(priv->netdev, out_dev)) {
 				struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev =3D mlx5_eswitch_uplink_get_proto_dev(es=
w, REP_ETH);
-				struct net_device *uplink_upper =3D netdev_master_upper_dev_get(uplink=
_dev);
+				struct net_device *uplink_upper;
=20
+				rcu_read_lock();
+				uplink_upper =3D
+					netdev_master_upper_dev_get_rcu(uplink_dev);
 				if (uplink_upper &&
 				    netif_is_lag_master(uplink_upper) &&
 				    uplink_upper =3D=3D out_dev)
 					out_dev =3D uplink_dev;
+				rcu_read_unlock();
=20
 				if (is_vlan_dev(out_dev)) {
 					err =3D add_vlan_push_action(priv, attr,
--=20
2.21.0

