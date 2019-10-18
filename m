Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21F0ADCF72
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506022AbfJRTkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:40:14 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:32581
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443146AbfJRTkN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:40:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=moMYY16iKLZtWjChSrM9rDmLrB8wOtJCGbgQtahHXMuVJgtdJCmP+34tJaEhZBgQUf2/Ux1Vm0AIrkke8zoxLTUAxpFENILNKJUZi14BTdMrVfxPTqxj528KajTA67lkuveV/5vAmiiutcMJk4ScMVP6lOUG4QMNJ8CbjiQt090gi9cFQprqQ2jcpJ1NEODNdvdpCUKv6JG/i9wxHtYdHINskskWwXfwJ5JMhSuiiH4INzoQErtQXUP/Y94X2jut954wjbyzjZhdExdd07JdhbUtNAHOmWkAEctrBqxmwlp1YgV74n8nz+5vV1CzdDbFKJOiRNh1lYa/IZY48sc6Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWiJw/ZV+Is9uKUmoDGgrSzewKlXQRjfN4h6b1tBvw0=;
 b=YrRQCZ1YotnrqO0j4rX2o8UEcpxU1FfJlPCE+OLrxNvyUdLfmwUisPbY1H6qnPbYkmayit/tjL+A/nnKjnFoh59Qu4njVCtpMCnZVuAQ0qsGOQct2TWrPhNzIKBvUu9SLzkytrDRBU5ESzZ7DPv9hTbn/l/0b4878/IS+KGgrufKerMq34dWIpO5wUbPKkbZM7oI0J4iA8yJv6cNvPvyU9sgYZMYH+RGWF3CCzF3ec2MLhvs8+/eukP7kWV6hz9Ia9tSb3bRb1rZB4HQhsWt432ruQ9NRkx5dB0Rr14xgC6zBCgyoeJAa83D3xMFluUng+YYEZGziPTTV7pSVjynKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BWiJw/ZV+Is9uKUmoDGgrSzewKlXQRjfN4h6b1tBvw0=;
 b=cdp3GPglKFHmudaaPKFg/sWquWQ3NlPX8TrgTGNIIeB4o1xg2GG8ahbjN1k1nK/T0acQg3KYF64XPHwOcsI0VxGa4Wa9Y6F5OVnUZWOUuZjXkNsDrJQoAjC64iYL9Ga5IpNXhtms08M3Xfr92PgCH9WRrVivTTzDEUl79CArxzE=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:07 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/15] net/mlx5e: kTLS, Release reference on DUMPed fragments in
 shutdown flow
Thread-Topic: [net 03/15] net/mlx5e: kTLS, Release reference on DUMPed
 fragments in shutdown flow
Thread-Index: AQHVheuQn9rN5+lXAUqsg6fqJBXGaQ==
Date:   Fri, 18 Oct 2019 19:38:06 +0000
Message-ID: <20191018193737.13959-4-saeedm@mellanox.com>
References: <20191018193737.13959-1-saeedm@mellanox.com>
In-Reply-To: <20191018193737.13959-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR07CA0079.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1cfee06f-4f0c-4515-99db-08d75402b2b5
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392BA3D5F30A17A197B43C4BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9z88hLtQWiJJJHcwUCpsGovdANiGtUknCfNjvSMZi0ZM0EOvJGaloeOqA/J6pmu6vgJpkDhQCO0Ef0p8LOps9a6gtBp+in394+GngY2cB6ly6SfXqGp/2py4MEaeet9DBiIAyuhR1J74fbi2G6EcGn0SSrqpQub2KYCxr9UwrJcI5G6ijSktvNZkc0mZMP0CsQ/MKhg30klnUQqMg/2E4iGUXCMUUAJoy4/sD6nfVAHN7S8Ev6IvNCGlhZnHjfeaDopgye/azg/s4vx3hOZjYkzpuub6QQAmA18CFviGSyyUAP5BsyxEUvTWXFAGqM8shpIPmVNGcf8EFewMo+GvLV45qJoKxHzXuL8g1s7tXMBysrDU/fOWfi0ydDzlHIxS3A1Qo1oL8dq7B96CyLuZViNamU55yKxc0EvpA41ldt0zUu0lhTlSTz3nJpJGdIut
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfee06f-4f0c-4515-99db-08d75402b2b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:07.4570
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rjv/077CtkpdO7GUzw0FP++RWwKxOP6Z1Wwy2zI9BNaifrzI97azHJtMi3WX5LNIz9JxqKwAUK/XZBgvaCfv9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

A call to kTLS completion handler was missing in the TXQSQ release
flow. Add it.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en_accel/ktls.h        |  7 ++++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 11 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 28 ++++++++++---------
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index b7298f9ee3d3..c4c128908b6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -86,7 +86,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_devic=
e *netdev,
 					 struct mlx5e_tx_wqe **wqe, u16 *pi);
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
-					   struct mlx5e_sq_dma *dma);
+					   u32 *dma_fifo_cc);
=20
 #else
=20
@@ -94,6 +94,11 @@ static inline void mlx5e_ktls_build_netdev(struct mlx5e_=
priv *priv)
 {
 }
=20
+static inline void
+mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+				      struct mlx5e_tx_wqe_info *wi,
+				      u32 *dma_fifo_cc) {}
+
 #endif
=20
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index d195366461c9..90c6ce530a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -303,9 +303,16 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t=
 *frag, u32 tisn, bool fir
=20
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
-					   struct mlx5e_sq_dma *dma)
+					   u32 *dma_fifo_cc)
 {
-	struct mlx5e_sq_stats *stats =3D sq->stats;
+	struct mlx5e_sq_stats *stats;
+	struct mlx5e_sq_dma *dma;
+
+	if (!wi->resync_dump_frag)
+		return;
+
+	dma =3D mlx5e_dma_get(sq, (*dma_fifo_cc)++);
+	stats =3D sq->stats;
=20
 	mlx5e_tx_dma_unmap(sq->pdev, dma);
 	__skb_frag_unref(wi->resync_dump_frag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 9094e9519db7..8dd8f0be101b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -479,14 +479,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bu=
dget)
 			skb =3D wi->skb;
=20
 			if (unlikely(!skb)) {
-#ifdef CONFIG_MLX5_EN_TLS
-				if (wi->resync_dump_frag) {
-					struct mlx5e_sq_dma *dma =3D
-						mlx5e_dma_get(sq, dma_fifo_cc++);
-
-					mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma);
-				}
-#endif
+				mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
 				sqcc +=3D wi->num_wqebbs;
 				continue;
 			}
@@ -542,29 +535,38 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
 	struct sk_buff *skb;
+	u32 dma_fifo_cc;
+	u16 sqcc;
 	u16 ci;
 	int i;
=20
-	while (sq->cc !=3D sq->pc) {
-		ci =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sq->cc);
+	sqcc =3D sq->cc;
+	dma_fifo_cc =3D sq->dma_fifo_cc;
+
+	while (sqcc !=3D sq->pc) {
+		ci =3D mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi =3D &sq->db.wqe_info[ci];
 		skb =3D wi->skb;
=20
 		if (!skb) {
-			sq->cc +=3D wi->num_wqebbs;
+			mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+			sqcc +=3D wi->num_wqebbs;
 			continue;
 		}
=20
 		for (i =3D 0; i < wi->num_dma; i++) {
 			struct mlx5e_sq_dma *dma =3D
-				mlx5e_dma_get(sq, sq->dma_fifo_cc++);
+				mlx5e_dma_get(sq, dma_fifo_cc++);
=20
 			mlx5e_tx_dma_unmap(sq->pdev, dma);
 		}
=20
 		dev_kfree_skb_any(skb);
-		sq->cc +=3D wi->num_wqebbs;
+		sqcc +=3D wi->num_wqebbs;
 	}
+
+	sq->dma_fifo_cc =3D dma_fifo_cc;
+	sq->cc =3D sqcc;
 }
=20
 #ifdef CONFIG_MLX5_CORE_IPOIB
--=20
2.21.0

