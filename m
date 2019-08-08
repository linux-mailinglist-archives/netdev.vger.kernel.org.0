Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBE4586B6A
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404870AbfHHUWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:22:32 -0400
Received: from mail-eopbgr60084.outbound.protection.outlook.com ([40.107.6.84]:35264
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404702AbfHHUW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:22:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yj8Sn+Da4PHTcE4XHEa7HaQd4bFUrNb7QBUw0ezw36KY47DjkFPpwbi67afGy5M2LqYqkcijev7hgcBz5YsNCZBkM4n9eqxf8yU4/tWTDWAJ60Uk0xQb0v3goI2MjsehWzBt6U9pjRXhzt80jY1Rs5cYoRTjj+O3ungCpGRIXqgjYIdtUHDUTSSOo6LgkqgGwMUPAw173zLDHNOW/SN0d6A3ugq/6YQ6I01qwTNPgunDazMY3Y3r5QMxQYCvF0o6Qb9EVT5N0EOJr5Kxt4Qrp/sQJ+y+8lyl8PkRxVXKP1iR5M/T6ISpv/Bm+y0EtoBAMiKRzcRvmSbhcznyWiG3wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0vgn3aM5Uf9VIOxxvoRTx+E/RuRInlzqK+yD7hzzDg=;
 b=OGipl9VbRW+E5TyruDmx42IcRq76R9VlupxqngIiE1oZtMyRPr6/0z1yvZajP9chiHM0gafas1V62NFDocLLHmE4aFrsKGNgnv55vtPp3jxMGyIslrP5FMBGgDK1Ous3xepzf9InjKcI77YRcmFlGMl4zb8Aff4Hih3Qk+SZjukDqwl4wyGhYj+Se99JIf0SGV9uKws3saW8LFLGXdTobx/U2R3uGwx5/ExQHyieFpu5yw08o0OxdAvEsfmHll1hJYGLy1X0bsHUNVcsYSLlL8Eg79iHbA3erN0vRIpElYqLQyIqh2O4eYpTxRPk4/iPb+gZ66KSBPCG4s3AyKCVzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n0vgn3aM5Uf9VIOxxvoRTx+E/RuRInlzqK+yD7hzzDg=;
 b=lKnhCl7P5fTCW3+zeHKHK1zj9HQPBjmzJ01JDSGI6hGBMds6XD539vFeSiA7+Y4Bt06gyPDcNIXd0q8G6sbPS1QoTc0j5yJb+Q1vNnSDj4SXLqKX0PaeLv6r+6hiOLv3pSgnGpF0c7jDGYBT/T5WqP4HK/jdMUYWIZ3yytN+2VE=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.15; Thu, 8 Aug 2019 20:22:19 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2157.015; Thu, 8 Aug 2019
 20:22:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 11/12] net/mlx5e: Fix error flow of CQE recovery on tx reporter
Thread-Topic: [net 11/12] net/mlx5e: Fix error flow of CQE recovery on tx
 reporter
Thread-Index: AQHVTib6gZldB8Xlg0ePxSCVmk3RBg==
Date:   Thu, 8 Aug 2019 20:22:19 +0000
Message-ID: <20190808202025.11303-12-saeedm@mellanox.com>
References: <20190808202025.11303-1-saeedm@mellanox.com>
In-Reply-To: <20190808202025.11303-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR08CA0067.namprd08.prod.outlook.com
 (2603:10b6:a03:117::44) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49a6b789-7980-4ad6-9c7a-08d71c3e1c57
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2257;
x-ms-traffictypediagnostic: AM4PR0501MB2257:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB225718DFACEC8E5F47CF73F3BED70@AM4PR0501MB2257.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 012349AD1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(136003)(376002)(396003)(189003)(199004)(53936002)(66556008)(50226002)(66946007)(64756008)(66446008)(14444005)(2906002)(107886003)(66476007)(6512007)(6916009)(81166006)(6486002)(2616005)(11346002)(1076003)(256004)(476003)(486006)(446003)(71190400001)(71200400001)(6436002)(81156014)(86362001)(305945005)(76176011)(7736002)(52116002)(478600001)(36756003)(102836004)(6506007)(386003)(54906003)(99286004)(3846002)(5660300002)(6116002)(66066001)(4326008)(26005)(316002)(8676002)(25786009)(8936002)(14454004)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2257;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: xHMqZVNpHHUUMWvkg8hKDOKouT8qT2c++3GSgMYKqJnEn/sA7rVEZobz4bHtsYGnMo+3RlxgO5PuyEqi38lC4Rc+Saq84Hahxbw1O//PybSuvrEw1o8UcXlBdNKcKiYxwL797vvoxx72NH74V2rSeR0blmXacZ/s5Iewe9FNYCw5FaIWyBOVd5rbcFb42EeRKaQZ3g9iLB5x6CfskKIeoflXXwYoKIaoiKh7nPtmX1tXXLFRyGyL5geo9/IWqJFkKFOHkaL0XzwaI+YHP+WtLbK+rr8TRbjFs+bvU+LRQPeCKqyYUUJVobqM1WG2kQI5g9e/UXTkp+0ZwlILaMx5RniT8avSjqsdU6uzecvSl8/gf+2RSGvyPtPFn26/GfsVF5lK5J0immEv4JtVtAE6rl4CH22ZF2jjB12mUSZL5Dk=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49a6b789-7980-4ad6-9c7a-08d71c3e1c57
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2019 20:22:19.3004
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kVRRv97OlDI59sm/f5sFXAFcU6dHhK1fxJZyeSBjlVbB4/OilmpEkVxtTl+hnJPGDWInLosc2n0pMYhryq8Rzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2257
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

CQE recovery function begins with test and set of recovery bit. Add an
error flow which ensures clearing of this bit when leaving the recovery
function, to allow further recoveries to take place. This allows removal
of clearing recovery bit on sq activate.

Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/reporter_tx.c | 12 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  1 -
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index b307234b4e05..b91814ecfbc9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -83,17 +83,17 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx=
5e_txqsq *sq)
 	if (err) {
 		netdev_err(dev, "Failed to query SQ 0x%x state. err =3D %d\n",
 			   sq->sqn, err);
-		return err;
+		goto out;
 	}
=20
 	if (state !=3D MLX5_SQC_STATE_ERR)
-		return 0;
+		goto out;
=20
 	mlx5e_tx_disable_queue(sq->txq);
=20
 	err =3D mlx5e_wait_for_sq_flush(sq);
 	if (err)
-		return err;
+		goto out;
=20
 	/* At this point, no new packets will arrive from the stack as TXQ is
 	 * marked with QUEUE_STATE_DRV_XOFF. In addition, NAPI cleared all
@@ -102,13 +102,17 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct m=
lx5e_txqsq *sq)
=20
 	err =3D mlx5e_sq_to_ready(sq, state);
 	if (err)
-		return err;
+		goto out;
=20
 	mlx5e_reset_txqsq_cc_pc(sq);
 	sq->stats->recover++;
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
 	mlx5e_activate_txqsq(sq);
=20
 	return 0;
+out:
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
+	return err;
 }
=20
 static int mlx5_tx_health_report(struct devlink_health_reporter *tx_report=
er,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 6c712c5be4d8..9d5f6e56188f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1321,7 +1321,6 @@ static int mlx5e_open_txqsq(struct mlx5e_channel *c,
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
 {
 	sq->txq =3D netdev_get_tx_queue(sq->channel->netdev, sq->txq_ix);
-	clear_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
 	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
--=20
2.21.0

