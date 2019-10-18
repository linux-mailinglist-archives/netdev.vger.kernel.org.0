Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 981E9DCF62
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443333AbfJRTif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:38:35 -0400
Received: from mail-eopbgr50054.outbound.protection.outlook.com ([40.107.5.54]:47134
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2443157AbfJRTid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:38:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ud8NdlAE6TF1KA/2tZc/w2/EVDGyXCSKt5uVHoaB9R7HEmg+dtqyVHYN7vY+kOGMyExm/9eW75bk9cy+E1dy2K8IYWsA3S7YUQHQOqDzivpHSAjh04relllO9FZ4xwWO2o1oh827Hu7EJlfIy4BCtvCJl2CbnpHT8yBlvvST1MAfZogcOf9vEpU8z3BPVO+BzHtcZATtQcCs0x5PtBiEVNw0X0Ogqcr3Gv9ULwLKB+2pHvCa6ywOn4UWkJrPi8R3ykqvHI64wg0tz32TJ11rXeUZKeRbvuVKMzrIiOctKqYcMoNE0EL+rgcxSFtfK1ww5KxL5/kAHJGHOoUmKcEXIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QypnKNo5s/HKCTuJtJVBWe5nRCwWu1NOaLFXacKxauQ=;
 b=RHcasQu0vqolPBiE3aCcIAO3EDvtN8MriU/HwPyiaVBKp78y8aZz7NnJ3JOkwcINnvYzvIqYQ6Z52GNKy1yK4Fg2SaE5/cCTMyTJfTO83CYyFeWi4K+hKEiIQwQp4iMFBNgRT0EkrnsLB/WCLGnTA1oRC7Qey07NWX2NM9AeSJnVmBbOva48WS5UJW12KNozh1DxD5HyuWxIUQmWEM7XDZDE40jWD6BKBWLxmiNuQZCAqwcoA5Yt28tpy/b3abw6I7FANmTxT0np5Jys18FH/s6hoXs6f/vyB72/H+LuJ7KqwIqe4pWKX1lMcSTizVpBhc2tTGlhAMebVbXgxO+jeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QypnKNo5s/HKCTuJtJVBWe5nRCwWu1NOaLFXacKxauQ=;
 b=NT2WGTHUti96GwOdEYotprYm/hSn4VH/uy38ABs3DDzprh8TgY5keLV/JlLdPJgOcNJc2avwdqhp2Kxl9SIC5bP+YUOlKdwAqfxf9PsUM8jgYr1OXjpjJeSrxSyrWzV8a5thQ7V6JTZ174/G4hroDHtVy41zEaSY2dVt4VYooGI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB0392.eurprd05.prod.outlook.com (52.133.247.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.20; Fri, 18 Oct 2019 19:38:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.024; Fri, 18 Oct 2019
 19:38:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 09/15] net/mlx5e: kTLS, Limit DUMP wqe size
Thread-Topic: [net 09/15] net/mlx5e: kTLS, Limit DUMP wqe size
Thread-Index: AQHVheuXyyoujB7oH02raiSZkf/gJw==
Date:   Fri, 18 Oct 2019 19:38:18 +0000
Message-ID: <20191018193737.13959-10-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: cd9c468b-05b5-426a-099d-08d75402b9fe
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1SPR01MB0392:|VI1SPR01MB0392:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1SPR01MB03926D7F83E4CDACD151F87FBE6C0@VI1SPR01MB0392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 01949FE337
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(39860400002)(396003)(366004)(376002)(199004)(189003)(86362001)(5660300002)(186003)(6436002)(102836004)(446003)(486006)(6506007)(71200400001)(71190400001)(14454004)(2616005)(11346002)(2906002)(26005)(476003)(6512007)(8936002)(81166006)(81156014)(6916009)(1076003)(50226002)(107886003)(8676002)(36756003)(6486002)(256004)(478600001)(386003)(66066001)(64756008)(66946007)(66556008)(66476007)(99286004)(66446008)(4326008)(316002)(54906003)(3846002)(6116002)(25786009)(52116002)(305945005)(76176011)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB0392;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oRsSbmsn/TnTR7H/Ii2r1je2emNv/RsSVn6uKMJhjHXINuKu8HcBX+NSdIvkJdVXeLQ2+S9P871Fe4rdVNtCD+9ZLADtB7Z/PCDGSxfnliFU7uKV5pGh4V/2EvXiyc9+Lu0p0tyqNRf+sUi978zpiJBGqHIGG9GMkri58m88tDacKbi1+tAsGAVgVTI8JOsHkYjc72KZx/TYszJxqD4ZGR48kVVdmzU/CMdLzZ1wS1we5AuEBLmZqel+6MEdgWCeTFITtugvFFH7QiKMKV0DK/KWIRshHyz4w/LU8ZUWeBssTPb+DifOEo7Pp4gCPZtYXKYyBCesCxPHcD8GDpvrUVt2imuQLNINqnBMksyn4D2ju+ohqUcoSq4J71tyFKybGnhtSdOUZpvKVJ87ETyEfkoEn0n5TrNQv+IjCXF9m7le8WFowKNMRzNTn0v7xwWc
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd9c468b-05b5-426a-099d-08d75402b9fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2019 19:38:18.6034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mON7r2oMkX4CracF1r72coyPk2cTqRucPFjytxgNtJu83SjPqjKC0TIlZdtKE3iSLrpSIgef7dJ35ahuTytEgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB0392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

HW expects the data size in DUMP WQEs to be up to MTU.
Make sure they are in range.

We elevate the frag page refcount by 'n-1', in addition to the
one obtained in tx_sync_info_get(), having an overall of 'n'
references. We bulk increments by using a single page_ref_add()
command, to optimize perfermance.
The refcounts are released one by one, by the corresponding completions.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h | 11 +++---
 .../mellanox/mlx5/core/en_accel/ktls.h        | 11 +++++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 34 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 +++-
 5 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index cb6f7b87e38f..f1a7bc46f1c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -410,6 +410,7 @@ struct mlx5e_txqsq {
 	struct device             *pdev;
 	__be32                     mkey_be;
 	unsigned long              state;
+	unsigned int               hw_mtu;
 	struct hwtstamp_config    *tstamp;
 	struct mlx5_clock         *clock;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 25f9dda578ac..7c8796d9743f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -15,15 +15,14 @@
 #else
 /* TLS offload requires additional stop_room for:
  *  - a resync SKB.
- * kTLS offload requires additional stop_room for:
- * - static params WQE,
- * - progress params WQE, and
- * - resync DUMP per frag.
+ * kTLS offload requires fixed additional stop_room for:
+ * - a static params WQE, and a progress params WQE.
+ * The additional MTU-depending room for the resync DUMP WQEs
+ * will be calculated and added in runtime.
  */
 #define MLX5E_SQ_TLS_ROOM  \
 	(MLX5_SEND_WQE_MAX_WQEBBS + \
-	 MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS + \
-	 MAX_SKB_FRAGS * MLX5E_KTLS_DUMP_WQEBBS)
+	 MLX5E_KTLS_STATIC_WQEBBS + MLX5E_KTLS_PROGRESS_WQEBBS)
 #endif
=20
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/driv=
ers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index eb692feba4a6..929966e6fbc4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -94,7 +94,16 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_devi=
ce *netdev,
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
-
+static inline u8
+mlx5e_ktls_dumps_num_wqebbs(struct mlx5e_txqsq *sq, unsigned int nfrags,
+			    unsigned int sync_len)
+{
+	/* Given the MTU and sync_len, calculates an upper bound for the
+	 * number of WQEBBs needed for the TX resync DUMP WQEs of a record.
+	 */
+	return MLX5E_KTLS_DUMP_WQEBBS *
+		(nfrags + DIV_ROUND_UP(sync_len, sq->hw_mtu));
+}
 #else
=20
 static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 59e3f48470d9..e10b0bb696da 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -373,7 +373,7 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_cont=
ext_tx *priv_tx,
 		return skb;
 	}
=20
-	num_wqebbs =3D info.nr_frags * MLX5E_KTLS_DUMP_WQEBBS;
+	num_wqebbs =3D mlx5e_ktls_dumps_num_wqebbs(sq, info.nr_frags, info.sync_l=
en);
 	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
 	contig_wqebbs_room =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
=20
@@ -382,14 +382,40 @@ mlx5e_ktls_tx_handle_ooo(struct mlx5e_ktls_offload_co=
ntext_tx *priv_tx,
=20
 	tx_post_resync_params(sq, priv_tx, info.rcd_sn);
=20
-	for (; i < info.nr_frags; i++)
-		if (tx_post_resync_dump(sq, &info.frags[i], priv_tx->tisn, !i))
-			goto err_out;
+	for (; i < info.nr_frags; i++) {
+		unsigned int orig_fsz, frag_offset =3D 0, n =3D 0;
+		skb_frag_t *f =3D &info.frags[i];
+
+		orig_fsz =3D skb_frag_size(f);
+
+		do {
+			bool fence =3D !(i || frag_offset);
+			unsigned int fsz;
+
+			n++;
+			fsz =3D min_t(unsigned int, sq->hw_mtu, orig_fsz - frag_offset);
+			skb_frag_size_set(f, fsz);
+			if (tx_post_resync_dump(sq, f, priv_tx->tisn, fence)) {
+				page_ref_add(skb_frag_page(f), n - 1);
+				goto err_out;
+			}
+
+			skb_frag_off_add(f, fsz);
+			frag_offset +=3D fsz;
+		} while (frag_offset < orig_fsz);
+
+		page_ref_add(skb_frag_page(f), n - 1);
+	}
=20
 	return skb;
=20
 err_out:
 	for (; i < info.nr_frags; i++)
+		/* The put_page() here undoes the page ref obtained in tx_sync_info_get(=
).
+		 * Page refs obtained for the DUMP WQEs above (by page_ref_add) will be
+		 * released only upon their completions (or in mlx5e_free_txqsq_descs,
+		 * if channel closes).
+		 */
 		put_page(skb_frag_page(&info.frags[i]));
=20
 	dev_kfree_skb_any(skb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b476b007f093..772bfdbdeb9c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1128,6 +1128,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 	sq->txq_ix    =3D txq_ix;
 	sq->uar_map   =3D mdev->mlx5e_res.bfreg.map;
 	sq->min_inline_mode =3D params->tx_min_inline_mode;
+	sq->hw_mtu    =3D MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	sq->stats     =3D &c->priv->channel_stats[c->ix].sq[tc];
 	sq->stop_room =3D MLX5E_SQ_STOP_ROOM;
 	INIT_WORK(&sq->recover_work, mlx5e_tx_err_cqe_work);
@@ -1135,10 +1136,14 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *=
c,
 		set_bit(MLX5E_SQ_STATE_VLAN_NEED_L2_INLINE, &sq->state);
 	if (MLX5_IPSEC_DEV(c->priv->mdev))
 		set_bit(MLX5E_SQ_STATE_IPSEC, &sq->state);
+#ifdef CONFIG_MLX5_EN_TLS
 	if (mlx5_accel_is_tls_device(c->priv->mdev)) {
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
-		sq->stop_room +=3D MLX5E_SQ_TLS_ROOM;
+		sq->stop_room +=3D MLX5E_SQ_TLS_ROOM +
+			mlx5e_ktls_dumps_num_wqebbs(sq, MAX_SKB_FRAGS,
+						    TLS_MAX_PAYLOAD_SIZE);
 	}
+#endif
=20
 	param->wq.db_numa_node =3D cpu_to_node(c->cpu);
 	err =3D mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
--=20
2.21.0

