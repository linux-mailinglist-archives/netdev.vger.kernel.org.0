Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAEBF5FCC8
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfGDSQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 14:16:15 -0400
Received: from mail-eopbgr150077.outbound.protection.outlook.com ([40.107.15.77]:20736
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727174AbfGDSQM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jul 2019 14:16:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P27DlTwibOvwmzgCjtCX87qxXfp/PGrEtcwSons6EMQ=;
 b=KqrKxeTK8Opb3AOsbv6OldGJSd3l3H+k2T42vTU4eQ3JjhG422vXz8PEOHZlI6TxAE5wghy4Xe86VXBFfRBjozjMOOMY2Rr2cWYbPlRQBaLtruifQV3PXGhjFYHQNxKHTOYvH8GvgQLdW+tmWfO0yXCklSe7loF0kI8GPHDqoQA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2584.eurprd05.prod.outlook.com (10.168.74.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Thu, 4 Jul 2019 18:16:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::c1b3:b3a8:bced:493c%4]) with mapi id 15.20.2032.019; Thu, 4 Jul 2019
 18:16:03 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 09/14] net/mlx5e: Tx, Make SQ WQE fetch function type
 generic
Thread-Topic: [net-next 09/14] net/mlx5e: Tx, Make SQ WQE fetch function type
 generic
Thread-Index: AQHVMpSKSOlYMZCt10uKCJGjuDps7Q==
Date:   Thu, 4 Jul 2019 18:16:03 +0000
Message-ID: <20190704181235.8966-10-saeedm@mellanox.com>
References: <20190704181235.8966-1-saeedm@mellanox.com>
In-Reply-To: <20190704181235.8966-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.148.53.10]
x-clientproxiedby: BYAPR06CA0061.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::38) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7f13d9d3-f235-4288-25cf-08d700abaccb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2584;
x-ms-traffictypediagnostic: DB6PR0501MB2584:
x-microsoft-antispam-prvs: <DB6PR0501MB25847A6311BA5B5CBA91C82BBEFA0@DB6PR0501MB2584.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0088C92887
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(136003)(39860400002)(366004)(396003)(199004)(189003)(486006)(14454004)(186003)(305945005)(26005)(6916009)(71200400001)(6486002)(7736002)(86362001)(256004)(14444005)(8936002)(81156014)(386003)(76176011)(8676002)(81166006)(6116002)(52116002)(2906002)(6436002)(3846002)(102836004)(71190400001)(2616005)(476003)(446003)(11346002)(6506007)(99286004)(73956011)(25786009)(1076003)(107886003)(66946007)(66556008)(66476007)(68736007)(66446008)(64756008)(5660300002)(478600001)(4326008)(50226002)(6512007)(54906003)(66066001)(316002)(36756003)(53936002)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2584;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 9xMIrF3s9MmauP8ehtMjBqrIzKDXCgWKgEGolW5s56nEIMqUKvqGkYRul/j/9d/+D6T34XYPdBp74uxeH73VUo0YbGG+7inZlutwSCkHczaYT7+mcYsg3UHuI5Wn6Lz3JPa5v3szuop9fKLVNrc/K7PGPKx+kwomiwKnSraqNSkffRKt7S3ioNaxrvY6BZDUKCYTk4w5wlthC851n3DV3v4pt9tiMjmlxlWkZXlMgwr30SFY6pKpxDvoNpXzTtf0FfpyZJDdZJDfWAU06804TFcQtGONgNpzEfj/tJXd+FDunLAaKCkaPzDCqcv6ba4Nwd5vk5LIwLNlROeKcVpfcYnbxcPocGVV5iooe1KXhtlkaMlQE2cn16aCtLIopf3Av19vQ3WNDrsYGsP0nFRfn0O552zySyVeXZpS0Xaj3GA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f13d9d3-f235-4288-25cf-08d700abaccb
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2019 18:16:03.9180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2584
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Change mlx5e_sq_fetch_wqe to be agnostic to the Work Queue
Element (WQE) type.
Before this patch, it was specific for struct mlx5e_tx_wqe.

In order to allow the change, the function now returns the
generic void pointer, and gets the WQE size to do the zero
memset.

Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h    | 12 +++++++-----
 .../ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c      |  4 ++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index bd41f89afef1..1280f4163b53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -14,15 +14,17 @@ mlx5e_wqc_has_room_for(struct mlx5_wq_cyc *wq, u16 cc, =
u16 pc, u16 n)
 	return (mlx5_wq_cyc_ctr2ix(wq, cc - pc) >=3D n) || (cc =3D=3D pc);
 }
=20
-static inline void mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq,
-				      struct mlx5e_tx_wqe **wqe,
-				      u16 *pi)
+static inline void *
+mlx5e_sq_fetch_wqe(struct mlx5e_txqsq *sq, size_t size, u16 *pi)
 {
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
+	void *wqe;
=20
 	*pi  =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
-	*wqe =3D mlx5_wq_cyc_get_wqe(wq, *pi);
-	memset(*wqe, 0, sizeof(**wqe));
+	wqe =3D mlx5_wq_cyc_get_wqe(wq, *pi);
+	memset(wqe, 0, size);
+
+	return wqe;
 }
=20
 static inline struct mlx5e_tx_wqe *
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 439bf5953885..7d191d98ac94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -248,7 +248,7 @@ mlx5e_tls_handle_ooo(struct mlx5e_tls_offload_context_t=
x *context,
 	mlx5e_tls_complete_sync_skb(skb, nskb, tcp_seq, headln,
 				    cpu_to_be64(info.rcd_sn));
 	mlx5e_sq_xmit(sq, nskb, *wqe, *pi, true);
-	mlx5e_sq_fetch_wqe(sq, wqe, pi);
+	*wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(**wqe), pi);
 	return skb;
=20
 err_out:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index b1a163e66053..983ea6206a94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -335,7 +335,7 @@ netdev_tx_t mlx5e_sq_xmit(struct mlx5e_txqsq *sq, struc=
t sk_buff *skb,
 		struct mlx5_wqe_eth_seg cur_eth =3D wqe->eth;
 #endif
 		mlx5e_fill_sq_frag_edge(sq, wq, pi, contig_wqebbs_room);
-		mlx5e_sq_fetch_wqe(sq, &wqe, &pi);
+		wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
 #ifdef CONFIG_MLX5_EN_IPSEC
 		wqe->eth =3D cur_eth;
 #endif
@@ -397,7 +397,7 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_=
device *dev)
 	u16 pi;
=20
 	sq =3D priv->txq2sq[skb_get_queue_mapping(skb)];
-	mlx5e_sq_fetch_wqe(sq, &wqe, &pi);
+	wqe =3D mlx5e_sq_fetch_wqe(sq, sizeof(*wqe), &pi);
=20
 	/* might send skbs and update wqe and pi */
 	skb =3D mlx5e_accel_handle_tx(skb, sq, dev, &wqe, &pi);
--=20
2.21.0

