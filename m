Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8478179AC2
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388487AbfG2VNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:13:19 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388449AbfG2VNS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:13:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grdB0GKovN+Cv6xDTV3J0ozQk9pW1JlCf6raDtHEg3SHLr80LOCi1++oMMnPfgdF8XnjNOx+SG83hc97Pt10mV1PQABCQXXUVwkFrWW1ac2WQHUmoqa0sRg6N6KHwWbGm+GclmLfdc37ecYeb0ch3Iep6O0G4YGfjTzHjTWDIP8TkIg4zNzeVDrlawrl0DIU7oKuO1Kr/iFIFcmds6MmJrp9a1SGxhzzOY7EeK8fV1OqmO98s/ChKU1XPEdXw0UVusUPXQGM6lY9HllTbaHZf2BDemfO144qmM9LFSuq8F7S1LVZ/W8qFr+n2hqyk/tuBo4PTAHggMMESYrkgZ82Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m8el9CZYJwtKwDuMiM/I8qzbt3V7RWpFPcpSX+OMcU=;
 b=QmTMPr1nohiVs2SJ8ROchZwtK2pb25PaeL5876SPFPmc16zQkq1Cyu1auRK3R8rIta79VERY57YMUa9YfZEkQPaLjMg41HisbY2RX5jd0TdxrPKS+c52USMtzUaqcKnp8q39t+4NBCsfEwqHz/oWaIsqs3sIaLREEqjU1+QVv9AweRKy05ka1oJMXaNK4OXj3wZ+H52SJX58BWXQM+8mAfT6DDIdyuGaxCKAMTjW+sACqQ2j0BuHdVGdsF/N3ZUwPasGMLna9klO50GuKGIItYw7MHq5M4HOvdx4Vp8zqCZ2t2NMaeUFAhGZ80JvX2Kq5wUVmOifNNXn/y/Wam2o2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8m8el9CZYJwtKwDuMiM/I8qzbt3V7RWpFPcpSX+OMcU=;
 b=HtCE6ToW0LghJlVq7eC4/8zVjz8Cm4mIs3ZQqNfMkIF0IDY787u8JHgaqyShfDXy4b1mx1m+3SM+207r23nD1vcu9IkUv7Hhe9ABvtYhaU9CkWwWYpr/O6n0U8f8rlfuDJs3zMN6k5QJWHH61SXufoeocdzFTV5DeKajMe/MuRU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:12:58 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:12:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Parav Pandit <parav@mellanox.com>
Subject: [PATCH mlx5-next 04/11] net/mlx5: Make load_one() and unload_one()
 symmetric
Thread-Topic: [PATCH mlx5-next 04/11] net/mlx5: Make load_one() and
 unload_one() symmetric
Thread-Index: AQHVRlJlDvaQzr4jf0W0UiiDRpTtBA==
Date:   Mon, 29 Jul 2019 21:12:58 +0000
Message-ID: <20190729211209.14772-5-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1808e248-b549-40f0-a8b4-08d7146987db
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB23752C5A6294223710C0FBCFBEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:425;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: So9VoMVabro420hw2EzCiSCvwvZZ0rp+t9sKGWdoieHlvLfnjHcPLo5OOKlIw8Q21UmHUhemH3rAJc3uYQ3iA3ngNxK/MezCpcxkJlxovnZUzYh3g7F/FZh4QjEdiNGze55aLL68d9farVuQmGSkleYQ18JfPuneX5u0R7aSBVAl3Us+k14Qj+OwUr09TaWruUVH/mDbeFWtMjpG5uQLgSemueOlw0kWMzHJKBwpyGwE5WD1kVvHHun6JpXrcBzcoqb7CyxuvhiLaiskJH8UPIwHULhU6PJUFvc+70Ugs0HsX2AC1uROotIEghPAAOksQ4ysBwFTInJrlapiOE3dtqXFBz8GuawMZLLIKe/mYQ6EDt9zbZSlvFO+wxHnIpd6TevyRk5E2W6WZ08CI9ktx5k4Oxe9q5Al4toN9xR72bM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1808e248-b549-40f0-a8b4-08d7146987db
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:12:58.4613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Currently mlx5_load_one() perform device registration using
mlx5_register_device(). But mlx5_unload_one() doesn't unregister.

Make them symmetric by doing device unregistration in
mlx5_unload_one().

Signed-off-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/e=
thernet/mellanox/mlx5/core/main.c
index b15b27a497fc..fa0e991f1983 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1217,8 +1217,10 @@ static int mlx5_unload_one(struct mlx5_core_dev *dev=
, bool cleanup)
 {
 	int err =3D 0;
=20
-	if (cleanup)
+	if (cleanup) {
+		mlx5_unregister_device(dev);
 		mlx5_drain_health_wq(dev);
+	}
=20
 	mutex_lock(&dev->intf_state_mutex);
 	if (!test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1369,7 +1371,6 @@ static void remove_one(struct pci_dev *pdev)
=20
 	mlx5_crdump_disable(dev);
 	mlx5_devlink_unregister(devlink);
-	mlx5_unregister_device(dev);
=20
 	if (mlx5_unload_one(dev, true)) {
 		mlx5_core_err(dev, "mlx5_unload_one failed\n");
--=20
2.21.0

