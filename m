Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4F9A2B1A
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 01:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfH2Xml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 19:42:41 -0400
Received: from mail-eopbgr150089.outbound.protection.outlook.com ([40.107.15.89]:7907
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726416AbfH2Xmk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 19:42:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BA4+EI28mNnTMNyxcuV68SfjpKJhu5SczDBoKm1cfHJuz3hygODqEL2tGMOvOk4jar9/hFoInSXXhDDplx30s2QAHYc8/2m2wdLkymRPhiJqG+O/F+y3nkNwNbz/Wy8PEAKDdL4+qoF/jRnpeglusAc6h/QF6XP/+q3CG7rLQZVNSTgQPvb+/BA1k7asKsny9+d2SqNb4TGdJEQi/+Jx9W0h5Ha57ZXpEbZhVnST2c/5YIK4ZTjGo9QuEmXav0PQcstVOmUEQvDNIvEBtlya3mgTHQoU7AjxjH0URRAe0ntq02f/r0AlXenxwAXApoqX8l8fnHc9GFDYDIfK4pojLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CsKnRfIPCG8rwTK2OAlEinx22jbL8WGPnoXWJFaLsQ=;
 b=mf/l6yzryYh3tPEi44o1eNp8SH/qyH3oDv+J5cBA22H/RdKwHsV+w+GA+bgVauObhV4H+6qYr89jMS6wHHUnTfY71iotJQ06RZ93rT87gN7raVq+hZEUCRGKTTVKOhoHeIXP9IUZZru/sAZCWPH8YiSgChicZg+qq3N8BEsNjtLN0GGG42d5zdu8vdAsB6+uIO7Mmw8xyB8uk8i2wY/nl0hAALfi+O6EJUtIiQb+eLAZWUzdXY8dXSBGp1dWeoXhbS7AQnm/COE+LDIYPHUY99I1+bXH/MVZUrKJoeMWb+nQjCYP9PH/ijnBYZ7QAD5wmJxO0i8coAJ/fTX/Q8tm4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5CsKnRfIPCG8rwTK2OAlEinx22jbL8WGPnoXWJFaLsQ=;
 b=jcxV3bb1lhtwleWb5dFl0w0FZ4gFBEJZR3Ji6xbHECi2nQjv3xyUuX49O05su3KPLxJgehtnfXaPnLVWGh+o7tU0mbWFkS7MxX/lVm2Hsl95/Z1Vsjgo55YTNevXLQrcJSFgwK9KwkXJQwFZ9YisST0gWZj8cGIwo0aQ0h2x/yI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2333.eurprd05.prod.outlook.com (10.169.135.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Thu, 29 Aug 2019 23:42:35 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 23:42:35 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        Mark Bloch <markb@mellanox.com>
Subject: [PATCH mlx5-next 3/5] net/mlx5: Avoid disabling RoCE when
 uninitialized
Thread-Topic: [PATCH mlx5-next 3/5] net/mlx5: Avoid disabling RoCE when
 uninitialized
Thread-Index: AQHVXsNuPcxzBDrAtEalj6yPtNVfQA==
Date:   Thu, 29 Aug 2019 23:42:34 +0000
Message-ID: <20190829234151.9958-4-saeedm@mellanox.com>
References: <20190829234151.9958-1-saeedm@mellanox.com>
In-Reply-To: <20190829234151.9958-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::28) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78317bcb-a044-41b7-4699-08d72cda9139
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2333;
x-ms-traffictypediagnostic: VI1PR0501MB2333:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB23331C2EC5774847A6293923BEA20@VI1PR0501MB2333.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(199004)(189003)(476003)(486006)(450100002)(4326008)(478600001)(2906002)(81156014)(6636002)(110136005)(71200400001)(36756003)(54906003)(71190400001)(305945005)(11346002)(446003)(8676002)(81166006)(7736002)(8936002)(5660300002)(50226002)(256004)(2616005)(64756008)(66446008)(186003)(66946007)(14454004)(6116002)(3846002)(316002)(1076003)(6512007)(6486002)(53936002)(6506007)(76176011)(107886003)(102836004)(6436002)(386003)(25786009)(99286004)(52116002)(86362001)(26005)(66066001)(66556008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2333;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jXMOUXLlPT2Nq3w+IIokhjVlLEcSKwxbj8Hyk43X9bGBpaRaeJVGYoId/0iZRLDqxl1isAb1HJSEYnug07G5g36VXuMv9uwuehxZJmfuguk0gpXcG7VfoMMQDDYOjX0apmEao7AvIfWfDKhxQTh45eS9K7E617tAgyH0KRd4fRgW5OHyC0FyjVEtr1FtFgz4SysiYF/4ma0a7aTW5yEdVU3/l2MS5xhtjzX1SyqIF9TlSJb385Tg8gn7LJbF3eYdpR2cAaBbtVRf1xG+8Wy5SYccn/4kFXejl32IJeBPQqflY7UDGvbZ8+jjDiLIQyq0c/V/iij2cfdlED6QQkpyQmYD9oPPTyNLN52uoMwoAq/+mRvp/CC/Bq4guEwZ2j5mrYe+BJoZKlcWk0ZGkR0C6YSRNm7+GloEyUdK4f0kWf4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78317bcb-a044-41b7-4699-08d72cda9139
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 23:42:34.9696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: equ0FJplKh1fzx68A8Eu0Rb1lKTrnF+bOd4IApljBhnj9efMR5RcKhJglUB3O39S1A+spxBJyM9Id7aekRZKnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Gottlieb <maorg@mellanox.com>

Move the check if RoCE steering is initialized to the
disable RoCE function, it will ensure that we disable
RoCE only if we succeeded in enabling it before.

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/e=
thernet/mellanox/mlx5/core/rdma.c
index 18af6981e0be..0fc7de4aa572 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -14,9 +14,6 @@ static void mlx5_rdma_disable_roce_steering(struct mlx5_c=
ore_dev *dev)
 {
 	struct mlx5_core_roce *roce =3D &dev->priv.roce;
=20
-	if (!roce->ft)
-		return;
-
 	mlx5_del_flow_rules(roce->allow_rule);
 	mlx5_destroy_flow_group(roce->fg);
 	mlx5_destroy_flow_table(roce->ft);
@@ -145,6 +142,11 @@ static int mlx5_rdma_add_roce_addr(struct mlx5_core_de=
v *dev)
=20
 void mlx5_rdma_disable_roce(struct mlx5_core_dev *dev)
 {
+	struct mlx5_core_roce *roce =3D &dev->priv.roce;
+
+	if (!roce->ft)
+		return;
+
 	mlx5_rdma_disable_roce_steering(dev);
 	mlx5_rdma_del_roce_addr(dev);
 	mlx5_nic_vport_disable_roce(dev);
--=20
2.21.0

