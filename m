Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07ABDCF61
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443313AbfJRTi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:27 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2394836AbfJRTiY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDgKmfd3dOgnQq++RCWWTVioiGiYff0sm7dUV44GR3QSXgslqRnu1eoI1eGUvznnlnBYxKb1cj5zwmFIGGOeAuNv70ovpvx4j9en+5fD/1cjfo8JfjVbbtwGeHtskv7EhxEGYnCa0HKoSB+ELUADT1n7wCRQ39s2BfsBbtgxqKC7t33NyDCvjrLuTTAUkbGT4S9zIGp4wRFDgR5GWu3MuwUWnWqH0RjNiRYLIMuAuoLKV22eqfLmcTuXHMLBLHu+BvQejSauLGc1N9uRUPyaPSlD5KVDtQy3/rFICdN0tjVE9rrxbWv8AgQ8xhTe6sNoQ3Y5OWtzy52TJ6t0TlSFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2K25CncF5kRR2xd/3mlWzlOr/hXoVXtCv/Z9+94+Jq8=;
 b=NV+D3NAdkfo7+isI6aASpIthtmLNTrIR61xI9nHXKJdmVeWQQCgsjfST3PxqUohdni+zJ313KLHQE8IpBV9HKbf5XlMMsHDFfuaVski55SuSqmBHac11ey0P0TS7IwJ9B/KpumrEcFbvEnn5XtcpXSPMLczY5DkSsIvzHQLgh6vK3cvg3ixSu1H6RKJmdjS5Z1KRdZc+7SHnDb7mjFlrgPZs2FMS/O5oqrWzvPyytG2vrB89k3HerSs/XRd5NOVRr41ztfxJTBV7noD5ZRizfa7sTusZX2Xj7wssB3Rnzv4/zJaWbs6DXAPLp2X61dVfar8/mnylqTB+1Vc/Z7eiGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2K25CncF5kRR2xd/3mlWzlOr/hXoVXtCv/Z9+94+Jq8=;
 b=WyOAahpSZetKnhceEtEd9R+hzh+9lDwhBJjPYmUVLSkl3Mgbj6iUH/1A6fKeQw+q5snq+LFIADD6df7jxPg6R97I4IH0yhuDW6ZDLAO4ILpjyZad9IbRcwpX+xeUEBBInRsSl6mS1ZRKKxmgqsZvFwZD8PUYOAqUYbZbht2mUO4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 05/15] net/mlx5e: kTLS, Save only the frag page to release at
 completion
Thread-Topic: [net 05/15] net/mlx5e: kTLS, Save only the frag page to release
 at completion
Thread-Index: AQHVheuTwo3bv1X+LUO7F5O70gkMgQ==
Date:   Fri, 18 Oct 2019 19:38:11 +0000
Message-ID: <20191018193737.13959-6-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 7ebd5d00-28bc-4b82-8085-08d75402b59b
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB0392F49A9D7F560BB7E751C1BE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(14444005)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +VugPTGrteOrwvjRi4WDhul4Ygt5M6L/G79hUOiooCfBcN2Gm1WnTE31IrAfTJba+GAmfjajnNqZZbyC7ev4nIubFzFYuOLrOvntCeoX5pECjNlVqmHa8h26LmjVeUp6R4MQDxXPfhrk5WvAi4TxIh5jRV8WdHojNGzUc2lGkpzTIJwGhCI1n2mQ8H6OO1+t7FY/VWkQeWX8FEHsc42WDLPHbZhxnJ+0bB1e1CXXxc0K3K3Nbvb170Yd0a+xMQ2sZCorTrHmwGzHrzrwQ393L0v1jskffw7ryOFFoa38LcY2MM3SY49h7Y2bRoOXe0ZJchZr716ozplJfxWbSqOPEaewoWdfi6vz+HkV0Ah7hI8zR2nDZ3KPcrg+qm0drR5qjyouTyLgvcQzAp5t1H+Wc0X2nD9+rbH2nVsbmYlwidcELeyS8GEcT7TZtIBfueNN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ebd5d00-28bc-4b82-8085-08d75402b59b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:11.1468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ek4y5uJBtONgz8oZL45RcagSEv8u2EZrNgeblleoomfnxCg1RK1ZcyxOk8o+TJShFtgq+qZ2CGsB5n1sEQ2CIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

In TX resync flow where DUMP WQEs are posted, keep a pointer to
the fragment page to unref it upon completion, instead of saving
the whole fragment.

In addition, move it the end of the arguments list in tx_fill_wi().

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 27 +++++++++----------
 2 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 8d76452cacdc..cb6f7b87e38f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -345,7 +345,7 @@ struct mlx5e_tx_wqe_info {
 	u8  num_wqebbs;
 	u8  num_dma;
 #ifdef CONFIG_MLX5_EN_TLS
-	skb_frag_t *resync_dump_frag;
+	struct page *resync_dump_frag_page;
 #endif
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index ac54767b7d86..6dfb22d705b2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -108,16 +108,15 @@ build_progress_params(struct mlx5e_tx_wqe *wqe, u16 p=
c, u32 sqn,
 }
=20
 static void tx_fill_wi(struct mlx5e_txqsq *sq,
-		       u16 pi, u8 num_wqebbs,
-		       skb_frag_t *resync_dump_frag,
-		       u32 num_bytes)
+		       u16 pi, u8 num_wqebbs, u32 num_bytes,
+		       struct page *page)
 {
 	struct mlx5e_tx_wqe_info *wi =3D &sq->db.wqe_info[pi];
=20
-	wi->skb              =3D NULL;
-	wi->num_wqebbs       =3D num_wqebbs;
-	wi->resync_dump_frag =3D resync_dump_frag;
-	wi->num_bytes        =3D num_bytes;
+	memset(wi, 0, sizeof(*wi));
+	wi->num_wqebbs =3D num_wqebbs;
+	wi->num_bytes  =3D num_bytes;
+	wi->resync_dump_frag_page =3D page;
 }
=20
 void mlx5e_ktls_tx_offload_set_pending(struct mlx5e_ktls_offload_context_t=
x *priv_tx)
@@ -145,7 +144,7 @@ post_static_params(struct mlx5e_txqsq *sq,
=20
 	umr_wqe =3D mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_STATIC_UMR_WQE_SZ, &pi);
 	build_static_params(umr_wqe, sq->pc, sq->sqn, priv_tx, fence);
-	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, NULL, 0);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_STATIC_WQEBBS, 0, NULL);
 	sq->pc +=3D MLX5E_KTLS_STATIC_WQEBBS;
 }
=20
@@ -159,7 +158,7 @@ post_progress_params(struct mlx5e_txqsq *sq,
=20
 	wqe =3D mlx5e_sq_fetch_wqe(sq, MLX5E_KTLS_PROGRESS_WQE_SZ, &pi);
 	build_progress_params(wqe, sq->pc, sq->sqn, priv_tx, fence);
-	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, NULL, 0);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_PROGRESS_WQEBBS, 0, NULL);
 	sq->pc +=3D MLX5E_KTLS_PROGRESS_WQEBBS;
 }
=20
@@ -211,7 +210,7 @@ static bool tx_sync_info_get(struct mlx5e_ktls_offload_=
context_tx *priv_tx,
 	while (remaining > 0) {
 		skb_frag_t *frag =3D &record->frags[i];
=20
-		__skb_frag_ref(frag);
+		get_page(skb_frag_page(frag));
 		remaining -=3D skb_frag_size(frag);
 		info->frags[i++] =3D frag;
 	}
@@ -284,7 +283,7 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, skb_frag_t =
*frag, u32 tisn, bool fir
 	dseg->byte_count =3D cpu_to_be32(fsz);
 	mlx5e_dma_push(sq, dma_addr, fsz, MLX5E_DMA_MAP_PAGE);
=20
-	tx_fill_wi(sq, pi, MLX5E_KTLS_DUMP_WQEBBS, frag, fsz);
+	tx_fill_wi(sq, pi, MLX5E_KTLS_DUMP_WQEBBS, fsz, skb_frag_page(frag));
 	sq->pc +=3D MLX5E_KTLS_DUMP_WQEBBS;
=20
 	return 0;
@@ -297,14 +296,14 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx=
5e_txqsq *sq,
 	struct mlx5e_sq_stats *stats;
 	struct mlx5e_sq_dma *dma;
=20
-	if (!wi->resync_dump_frag)
+	if (!wi->resync_dump_frag_page)
 		return;
=20
 	dma =3D mlx5e_dma_get(sq, (*dma_fifo_cc)++);
 	stats =3D sq->stats;
=20
 	mlx5e_tx_dma_unmap(sq->pdev, dma);
-	__skb_frag_unref(wi->resync_dump_frag);
+	put_page(wi->resync_dump_frag_page);
 	stats->tls_dump_packets++;
 	stats->tls_dump_bytes +=3D wi->num_bytes;
 }
@@ -314,7 +313,7 @@ static void tx_post_fence_nop(struct mlx5e_txqsq *sq)
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
 	u16 pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
=20
-	tx_fill_wi(sq, pi, 1, NULL, 0);
+	tx_fill_wi(sq, pi, 1, 0, NULL);
=20
 	mlx5e_post_nop_fence(wq, sq->sqn, &sq->pc);
 }
--=20
2.21.0

