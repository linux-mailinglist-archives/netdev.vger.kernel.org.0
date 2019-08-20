Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E3B96A46
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731057AbfHTUYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:45 -0400
Received: from mail-eopbgr140043.outbound.protection.outlook.com ([40.107.14.43]:15333
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731029AbfHTUYn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E2uS0AnSQXAv+DXtj/dCjOQseWYcEw227bsa3w35QLXz+bMukhe+IiJzOS2qH7AR6TeurC79hDEG2hKVT2QcdUIPUxb/WUwqgsaSuAkY7XPmm86gi0vjFxf0T0bLCJflDOoEluyGiUib0idnSIW9ZCAnVCfEv76cCoQPo2fM7V4fTN1whUHMc9/lusWt7ItsFTuVT3aMXeeiar2x7mktnDnGAUIZjYKgDGYsWUM6PMJ3MsIo4eKhrHZarRc3IpdySgseX3ePsyajgSqLZs/iHZTi7QXrkWUMkP0tflHhuELY3To0ex0awDpZp8KodHHUpyFhph0FqBx9L/dDdbvKhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxnSwyL8i4MFdbbcL0ofJIbA4Winja+rANFKtzH4vTc=;
 b=BvXub+JvrXCod1gmWpUwV/9cPUfk4RvHAtH8ZJ/zOMek4cAFfL+nNByJ8Eqf4JtHf3sXXU7hu869c3rOEtmn9uO6VUz8s1y9qppW+GPGS/xD6ZyKZ2hWq1rVqhaCU8Dc6J3BbzC44iCoG1wySxkUEJWf07YaIIpRxX5MhAJ9QmTNjIS1Bmh2XqwNcP6HF6dt40f2zYXM7waXrVFZvPAEovH5ESpOHjqrBHp5vKPQlt0dZr8Ztzt8HH3eC8+JbdVMn8FnTqZSoye/r5ogo+k2GGwIaJ+8IG/54+jc4l/IB2tW1Fq66ILZYMVNbC2nA1e6+/izb/WcM8jTkkHY2wKAfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SxnSwyL8i4MFdbbcL0ofJIbA4Winja+rANFKtzH4vTc=;
 b=BwySLE5T/kTv3lYDZXeJCDVW95/rL5b2cK72umNtbg4MRm2aBwvN2e7skZWuazva09PH1xNaPkFKU0F3VNsYZv8eRcumz8E0Vk+VqMPYR35/bo1tmgIGN9nHQP6k3CFP6otTSi6MASbOVrRpo3+DkmQ87oPFT8xGUsQNT/Du/gU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:28 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 09/16] net/mlx5e: Split open/close ICOSQ into stages
Thread-Topic: [net-next v2 09/16] net/mlx5e: Split open/close ICOSQ into
 stages
Thread-Index: AQHVV5VE/GnbwLIQzES9JCne81HX/Q==
Date:   Tue, 20 Aug 2019 20:24:28 +0000
Message-ID: <20190820202352.2995-10-saeedm@mellanox.com>
References: <20190820202352.2995-1-saeedm@mellanox.com>
In-Reply-To: <20190820202352.2995-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:a03:54::23) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 16f1ff1f-f6bf-4b2e-ca9f-08d725ac6691
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB26801D448D6216D3718F424FBEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:172;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: nbt56AxqPkA5/u7mqQUcgFShcUTZlHVgv+FJseuzzLGS56NbgFpYf2iJiZzt/yqyV37UurC5by/pVi3zRFalmeLtvln3UI7kJH3u2RC1x7/HnVBkoB87dYwC5yx7rLegQscOUk8C1CmCxxIkj1rqWuRFt8PtR/6QkiObUXkfLx8ond59YnJ/7ffGEjzlgxth2WTR4wyXEHsXPxFKDQN2bSnrOcJOQ33QoOZbG0nfpEmS4hxfGcEeYGiSxgrDdu+LWv3K9ahDBcL4yIMPdmFJgYf+YD5pwquOHuHclPtybLt5iklLCtt54/j9FRwzVG+MLQhwNif2CHmD14/K+BCM1rEqW275972A30QRxdB3oLKv85apMvFUSKavvpEe9mx0rTrNM36bkGUnssN2GxE1vKOenTZV89JxxLrRjoGvgY8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16f1ff1f-f6bf-4b2e-ca9f-08d725ac6691
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:28.3337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QaIrMpGVxCPD9IGMngZ0N7hCUzUEv0nWC7b6aixQKDMgI+/+sbxbG2RXuhuGEYXt9s4N7/gjFYKET0aZp1zvoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
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
index 2c4d1f415968..d360750b25b7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -150,6 +150,7 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
=20
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
+	mlx5e_activate_icosq(&c->xskicosq);
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	/* TX queue is created active. */
=20
@@ -162,6 +163,7 @@ void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
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
index 1cec30627bb0..2c4e1cb54402 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1375,7 +1375,6 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struct =
mlx5e_params *params,
 	csp.cqn             =3D sq->cq.mcq.cqn;
 	csp.wq_ctrl         =3D &sq->wq_ctrl;
 	csp.min_inline_mode =3D params->tx_min_inline_mode;
-	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	err =3D mlx5e_create_sq_rdy(c->mdev, param, &csp, &sq->sqn);
 	if (err)
 		goto err_free_icosq;
@@ -1389,12 +1388,22 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struc=
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
@@ -1971,6 +1980,7 @@ static void mlx5e_activate_channel(struct mlx5e_chann=
el *c)
=20
 	for (tc =3D 0; tc < c->num_tc; tc++)
 		mlx5e_activate_txqsq(&c->sq[tc]);
+	mlx5e_activate_icosq(&c->icosq);
 	mlx5e_activate_rq(&c->rq);
 	netif_set_xps_queue(c->netdev, c->xps_cpumask, c->ix);
=20
@@ -1986,6 +1996,7 @@ static void mlx5e_deactivate_channel(struct mlx5e_cha=
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

