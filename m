Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABFC7FBBC9
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 23:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfKMWlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 17:41:49 -0500
Received: from mail-eopbgr150048.outbound.protection.outlook.com ([40.107.15.48]:22577
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726303AbfKMWlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Nov 2019 17:41:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XyhBYaIdokFVWp39EYaIGMLttDjuZf9xrg8/6yAh6yS1qAPgH3+CGT/smLZYOyhqeXOUXyzseXWurvF8l3IWg/tHOBxCoEE/Cj/6S/kVa7LFYlIC0jRuybgtpr5aBjYNFcSzAn9CXNQUrZgA2yw/fSnhB4Muy3NKbNa1GnpxfoeuEevR3shn9733Ei22zyiNl69wC2kVBtJA54DuDhS1pahc+S1mb9rzI0uMnMp5Pqb7xSZDk2CuCppNA4o5gjHwMHqTuDdfWMzNOBgJ0XaiWU1oiGTGbj46O7+Q+8P1XBaQ58Er0tuawARJgQfWXNbHQMxzpvEgElDokbfHNFlfBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtgNMDIQwbVfMCX5/NE/flx28j8u2lx1H90N47orPdw=;
 b=i5LnEa6YgFoTYmpa/Or7Exwxp5ptjAgFOV1xcnbkf1+rvM68yYy3suwEMOEgGOjZxhJ5j8/WnS5YqkaCtJjxgBOahIcsDTtE9LqkvMJs8ouGc7Xoy5ryLELl0FB+zpE8XxaCstehP6VAEhSgMGTFREhW99lr/MbRs/1IFYX+HwwVNS6VEnNC4kqLUNMtRDjU6fDIF1F672XdKXD7vywkLqJBbp+8uL7o1Ud5Pg89kkYvHG4rmMkqC/1feh9nfRXDz36jUZRHeXikAi0USNpUgg4BC0H0Z0ZI/qwqVv0OqF1iEJyal+zaluYp1i4qCbM4tiHuJFDJUjqDNgn1VKtxgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CtgNMDIQwbVfMCX5/NE/flx28j8u2lx1H90N47orPdw=;
 b=RFmcmrKzheszoh/eIScc8waJctQmm+OcJq9ts9fcLOHQ01vbv+gBAvzoNA1VSPYEYsn8zSSjNcAgDalYBAvLR+tgR7CPiOQGEQrsmnYTda0oiylq2+38eai3LL2RqIDLzIWB9LqwNOccplOqm48BMKs9yIiyMXOrJtJX3jpv0NY=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5135.eurprd05.prod.outlook.com (20.178.11.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 13 Nov 2019 22:41:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.028; Wed, 13 Nov 2019
 22:41:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Michael Guralnik <michaelgur@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 6/7] net/mlx5: Add devlink reload
Thread-Topic: [net-next V2 6/7] net/mlx5: Add devlink reload
Thread-Index: AQHVmnOFM0R5O9wZs0KJlmlXLasE4A==
Date:   Wed, 13 Nov 2019 22:41:42 +0000
Message-ID: <20191113224059.19051-7-saeedm@mellanox.com>
References: <20191113224059.19051-1-saeedm@mellanox.com>
In-Reply-To: <20191113224059.19051-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0022.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::32) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb4a63f8-0081-4969-37a6-08d7688aa788
x-ms-traffictypediagnostic: VI1PR05MB5135:|VI1PR05MB5135:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB51357CA35FF83525452C9696BE760@VI1PR05MB5135.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-forefront-prvs: 0220D4B98D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(376002)(39860400002)(396003)(346002)(189003)(199004)(26005)(3846002)(6116002)(54906003)(66946007)(64756008)(66556008)(66476007)(2906002)(66446008)(36756003)(316002)(99286004)(81166006)(81156014)(8936002)(8676002)(50226002)(5660300002)(1076003)(102836004)(186003)(6512007)(6486002)(6436002)(386003)(478600001)(52116002)(25786009)(76176011)(7736002)(6506007)(14454004)(305945005)(14444005)(86362001)(486006)(107886003)(256004)(4326008)(66066001)(2616005)(6916009)(11346002)(71200400001)(71190400001)(446003)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5135;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2L5wU60ZXKZpI5g2KmVthDZRseLd55hLAhaKd9EqTPzhOzEO4jufeGQF7CXdQKpS3ePtWF1WKOvihcoedF1XKKjTGJKPqzeAYw3VZvLJb9kTV0Ryc1h6XOI8twMPCvjIdwjMI0Q2DN9zbETB1NjkkOojZgQMNqHRXLwGq/ZgDR8Z6X14DFOf82lmpsJZHgQhsgdbKJZGBZWHvNbt+L5VSnuWNUyWy8HWuNrW4cXrEog9wwe7p+VfQHBbUbAgBXds7LoHmi86LiPYLYObiPZthv2tJh82p8nkcCs9AO+JupGyzkVfhffHu6lo+dQmFXirPputZgw0IL0Jiju+k9JyIoeX6hKNH79K2DdN2I6QxW9FEFBUfdTmjDWWZN53CVWt96fE9eKCMtqZyOqYdOoKrrT/sTCrd4g82KvanrKOvh8rbAUZWTIocR+yYdmf/cnm
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb4a63f8-0081-4969-37a6-08d7688aa788
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2019 22:41:42.5949
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8+1SBLzTmKnyfPpZFdqvnT4Pe4C6fzt9L0SnTm2QlP4Sqi0wwjlRc9i/bzviKxAPVKjKF2x6DlveF83TtQBiig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Guralnik <michaelgur@mellanox.com>

Implement devlink reload for mlx5.

Usage example:
devlink dev reload pci/0000:06:00.0

Signed-off-by: Michael Guralnik <michaelgur@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 20 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    |  4 ++--
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  3 +++
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index b2c26388edb1..ac108f1e5bd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -85,6 +85,22 @@ mlx5_devlink_info_get(struct devlink *devlink, struct de=
vlink_info_req *req,
 	return 0;
 }
=20
+static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_ch=
ange,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+
+	return mlx5_unload_one(dev, false);
+}
+
+static int mlx5_devlink_reload_up(struct devlink *devlink,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev =3D devlink_priv(devlink);
+
+	return mlx5_load_one(dev, false);
+}
+
 static const struct devlink_ops mlx5_devlink_ops =3D {
 #ifdef CONFIG_MLX5_ESWITCH
 	.eswitch_mode_set =3D mlx5_devlink_eswitch_mode_set,
@@ -96,6 +112,8 @@ static const struct devlink_ops mlx5_devlink_ops =3D {
 #endif
 	.flash_update =3D mlx5_devlink_flash_update,
 	.info_get =3D mlx5_devlink_info_get,
+	.reload_down =3D mlx5_devlink_reload_down,
+	.reload_up =3D mlx5_devlink_reload_up,
 };
=20
 struct devlink *mlx5_devlink_alloc(void)
@@ -235,6 +253,7 @@ int mlx5_devlink_register(struct devlink *devlink, stru=
ct device *dev)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
+	devlink_reload_enable(devlink);
 	return 0;
=20
 params_reg_err:
@@ -244,6 +263,7 @@ int mlx5_devlink_register(struct devlink *devlink, stru=
ct device *dev)
=20
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_reload_disable(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index c9a091d3226c..31fbfd6e8bb9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1168,7 +1168,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 	mlx5_put_uars_page(dev, dev->priv.uar);
 }
=20
-static int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool boot)
 {
 	int err =3D 0;
=20
@@ -1226,7 +1226,7 @@ static int mlx5_load_one(struct mlx5_core_dev *dev, b=
ool boot)
 	return err;
 }
=20
-static int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
+int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup)
 {
 	if (cleanup) {
 		mlx5_unregister_device(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/=
net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b100489dc85c..da67b28d6e23 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -243,4 +243,7 @@ enum {
=20
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
+
+int mlx5_unload_one(struct mlx5_core_dev *dev, bool cleanup);
+int mlx5_load_one(struct mlx5_core_dev *dev, bool boot);
 #endif /* __MLX5_CORE_H__ */
--=20
2.21.0

