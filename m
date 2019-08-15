Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCA08F430
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732799AbfHOTKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:36 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732788AbfHOTKf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YVu6HU3MOlh+BjvBXnlYrKJ200xKxep6y1hOk/QaNmDo+NAXHHtI/DoS0r7QXd1AocA/J3wS0mClXzpDH7MDZ+yusVHVes8Tzic3XMiHG1xAUOYQhzSaow+OUwng9byRz+eiCqeEKXH6hdLB4pw+JaVZDTQ1DExDR7gfJK02orEcV6ogOfNUE2mf/FGYb4TcXYd43ObMn6Tya1faFf8GwMH5hYddlBDZAAKf4Ik/AsrZ2ufhbyVTrk1kdLv0bslf0sm1yMJyVm8g6LXZgwwL2BO4xhB/uUP5siL9X1rLs045pebpMzXq1Vv4Tkutm6tmNFn2QEKO44e6ykmh6V4PqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dr6GLVCiFcsPjbTEUjM7Xd1RuaP42vH43h4wlXtrliE=;
 b=MlzWKILWyE5rGRnhAegGPKTBojrSSHf3FXQP88tZl2SInUY/JDhe99XaFdIl14mfZ9Stn54QVnNcvrcwHaq65KL/f4BnrUBbFvYmietIxZW/JLNJK2VY3NJelydv7h6muQY+ulgnOXDQC8ZV950HxrfD9ukNa/+vwwCVUbNxPcC7J//ghEBjWPoSIh++gEEBGglQWbFmRxuNBjv5pPEuC8/R50JTA/UoX5TLfFD3tREHYAz/wJOVWmkpREx89vqS2AJXSXqmMx0SrzuJfUa36QW+rDgp5YrqArGkKSU2lzpavD3freYCpQiserfEDjq9MMrh7osN9fl2hL4wItUi7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dr6GLVCiFcsPjbTEUjM7Xd1RuaP42vH43h4wlXtrliE=;
 b=CBxKmTbdwyDrQJNTvdrxFZ7Fox2tFs/d3KvBy5aYY0lpj0V/KucPuWujKdcU//vuhxiE2j/cVCHLSItTq2uRFCzhbbruf9EuJ/f/1jcW1AAs9VeRYqrE65QkSWdH4u62D99Yilk46GdEQliKsKJ2/1k+CM4O/TAbRULV5cgNWNs=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/16] net/mlx5e: Split open/close ICOSQ into stages
Thread-Topic: [net-next 09/16] net/mlx5e: Split open/close ICOSQ into stages
Thread-Index: AQHVU50LjNe6rPJJTUiWXV3gK+6rqg==
Date:   Thu, 15 Aug 2019 19:10:03 +0000
Message-ID: <20190815190911.12050-10-saeedm@mellanox.com>
References: <20190815190911.12050-1-saeedm@mellanox.com>
In-Reply-To: <20190815190911.12050-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::27) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c7d0476-bb5d-420a-8525-08d721b42d7d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB24405D57BC436233CDFE9F82BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:172;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KVkzeNrA3r+M9DZDcxSIWtyiSHyDXbYEtL6sFtuF3J5u+msPWQECTQ8qVyLzEUyyI/cYamhTeCenb9suRQsCeoN0VTZacagcqPfwgrPFnbmmv+Uh9Q/oGjEeFKjfhQCtHoZefaMu/d+7xhCGAU/BA0jMrWjXk77rCeHX/2VcAhX5bFo9U/n/yJZQvrJ5eWRPnOSxp8cEBS7s4WDm18l4S2/AG1k0mCzjIzbIeGVn1yLKp/VfNb6CvqXkdNL+zPj97RKSb6QVw4RQ2E4PsAFnRCtmXlPJkpkp7ziRoyQPsdNTR2A8gVgQLTiity32XRcDny+hVfGsQbJDz5VQLgT4jKAqIwWI/YzPKywWSF1ykq9gZDVXe7H7usjPfzyvWoOmcBMnTPbbBykPD8xE692ZbEsK6Ne0QHve9vHjQlRnEjk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c7d0476-bb5d-420a-8525-08d721b42d7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:03.9034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nzB8hL1BttYEt+cmwXgL5m9SfUKqq2YBuXLOuCTRBPKQmsfvjDQ41DzMsUVr+kiYAPQx95VcwZjVeIt7xf5VVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Align ICOSQ open/close behaviour with RQ and SQ. Split open flow into
open and activate where open handles creation and activate enables the
queue. Do a symmetric thing in close flow: split into close and
deactivate.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/xsk/setup.c         |  2 ++
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   |  7 +++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +++++++++++++++----
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index f701e4f3c076..18d59ab2cf86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -150,6 +150,7 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
=20
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
+	mlx5e_activate_icosq(&c->xskicosq);
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	/* TX queue is created active. */
 	mlx5e_trigger_irq(&c->xskicosq);
@@ -159,6 +160,7 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 {
 	mlx5e_deactivate_rq(&c->xskrq);
 	/* TX queue is disabled on close. */
+	mlx5e_deactivate_icosq(&c->xskicosq);
 }
=20
 static int mlx5e_redirect_xsk_rqt(struct mlx5e_priv *priv, u16 ix, u32 rqn=
)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 35e188cf4ea4..fd2c75b4b519 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -26,6 +26,13 @@ int mlx5e_xsk_async_xmit(struct net_device *dev, u32 qid=
)
 		return -ENXIO;
=20
 	if (!napi_if_scheduled_mark_missed(&c->napi)) {
+		/* To avoid WQE overrun, don't post a NOP if XSKICOSQ is not
+		 * active and not polled by NAPI. Return 0, because the upcoming
+		 * activate will trigger the IRQ for us.
+		 */
+		if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &c->xskicosq.state)))
+			return 0;
+
 		spin_lock(&c->xskicosq_lock);
 		mlx5e_trigger_irq(&c->xskicosq);
 		spin_unlock(&c->xskicosq_lock);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 006e33e718d9..b9a7b6563ae6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1376,7 +1376,6 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct =
mlx5e_params *params,
 	csp.cqn             =3D sq->cq.mcq.cqn;
 	csp.wq_ctrl         =3D &sq->wq_ctrl;
 	csp.min_inline_mode =3D params->tx_min_inline_mode;
-	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	err =3D mlx5e_create_sq_rdy(c->mdev, param, &csp, &sq->sqn);
 	if (err)
 		goto err_free_icosq;
@@ -1390,12 +1389,22 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struc=
t mlx5e_params *params,
 	return err;
 }
=20
-void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+static void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 {
-	struct mlx5e_channel *c =3D sq->channel;
+	set_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+}
=20
-	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+static void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
+{
+	struct mlx5e_channel *c =3D icosq->channel;
+
+	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
 	napi_synchronize(&c->napi);
+}
+
+void mlx5e_close_icosq(struct mlx5e_icosq *sq)
+{
+	struct mlx5e_channel *c =3D sq->channel;
=20
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_icosq(sq);
@@ -1972,6 +1981,7 @@ static void mlx5e_activate_channel(struct mlx5e_chann=
el *c)
=20
 	for (tc =3D 0; tc < c->num_tc; tc++)
 		mlx5e_activate_txqsq(&c->sq[tc]);
+	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_rq(&c->rq);
 	netif_set_xps_queue(c->netdev, c->xps_cpumask, c->ix);
=20
@@ -1987,6 +1997,7 @@ static void mlx5e_deactivate_channel(struct mlx5e_cha=
nnel *c)
 		mlx5e_deactivate_xsk(c);
=20
 	mlx5e_deactivate_rq(&c->rq);
+	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc =3D 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->sq[tc]);
 }
--=20
2.21.0

