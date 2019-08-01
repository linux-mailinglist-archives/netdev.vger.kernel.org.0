Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6F87E3A3
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 22:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388864AbfHAT5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 15:57:20 -0400
Received: from mail-eopbgr130040.outbound.protection.outlook.com ([40.107.13.40]:64391
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388851AbfHAT5T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 15:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsDHZnNIXy4zyZ8APXxpJWKoTYzz78kcBiOc+qXNynWMPD2Q0rBO/zlFkp1cGdQzwVuWK/7WlsiyFywGQJfUinYkosXki8xd2UGh723Rc1gjFcRW7xOIxkjOxA3lzuTbGVShdNC+FwqKp00pYSSRTN7iyFKznsB+djsrQJizvLCAR4SE0eY06iC1PJ/3GA1Um4GsuRSTr10T1fo8ya7sBnL6YD0sJrBhTTfGKi5L2fDATVgMWaY9l+ICEfDyVH6Yb+jC52K79IWrurT3Xjevl+Y7isaXWaGiM7cuTk9rJAW+6us57ILUt6A/wWLPqPZNLXIR2X1O5lr7hU5D63PIKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZMbAlKfsWEoH9vYqRlYDSlxT6eqHUmqPitRi+6YtkI=;
 b=IqMRx3JfA9jPYWHhRERyqejJxrqM3j8+CkMyLTdE3lznVmZw4A5aVWiSAUMBCTtxP+GCc6+cML0NX5hBnwKCWQyEbKr0g6X31UNOraK7odGWvqBp6QAptXu7iM6QGhqA+30STBFyEJc/4w7HIcJ8ZZdI+HBu+Z/0jEtDBTDwoxXVYn+294/7kSmt6OHWclKTEIWLuWXjL/YFWcjRdeJiBsJig88GKOiABNLIBFsUp5THENVBqlhypDTmWWdezFKO/XEOw/VauaDej6ZQsfRLT/6aWiS2MADgFWzl1b4LLNJhW2GkARgV8SRfLV1LnrIVh8be2w858YpZ9dsPVtoW1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wZMbAlKfsWEoH9vYqRlYDSlxT6eqHUmqPitRi+6YtkI=;
 b=jNAMT2K+1uEmrFzU2UqbqO4BvSsrBHsJq7+tWhad8NT7m7rJgn3kpLXwAjMnPkfSKiIdDo2rRn4U6PtN5grAoRX450GEm7lXEGTVOtahblW1P753YAa1zx5w/79tgvye7eEMsnMvvgQ9lpUGTd0Tey3L1f6chLIKk2UglDr/1qQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 19:56:59 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Thu, 1 Aug 2019
 19:56:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Shay Agroskin <shayag@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/12] net/mlx5e: XDP, Close TX MPWQE session when no room
 for inline packet left
Thread-Topic: [net-next 05/12] net/mlx5e: XDP, Close TX MPWQE session when no
 room for inline packet left
Thread-Index: AQHVSKNHp8njrADDD0e/YuLCTAr0Ww==
Date:   Thu, 1 Aug 2019 19:56:59 +0000
Message-ID: <20190801195620.26180-6-saeedm@mellanox.com>
References: <20190801195620.26180-1-saeedm@mellanox.com>
In-Reply-To: <20190801195620.26180-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: MWHPR22CA0034.namprd22.prod.outlook.com
 (2603:10b6:300:69::20) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9358f280-8e71-4bb6-9195-08d716ba69d6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2759;
x-ms-traffictypediagnostic: DB6PR0501MB2759:
x-microsoft-antispam-prvs: <DB6PR0501MB2759BED3AF8E4478C93104CFBEDE0@DB6PR0501MB2759.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:628;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(71200400001)(71190400001)(5660300002)(6916009)(4326008)(107886003)(1076003)(6116002)(3846002)(476003)(486006)(256004)(14444005)(66066001)(86362001)(11346002)(446003)(25786009)(30864003)(2616005)(66446008)(64756008)(66556008)(66476007)(66946007)(478600001)(14454004)(53936002)(316002)(7736002)(6486002)(76176011)(52116002)(99286004)(54906003)(36756003)(50226002)(386003)(6506007)(102836004)(305945005)(2906002)(81166006)(81156014)(186003)(8676002)(8936002)(6512007)(68736007)(6436002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2759;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r1kRDztDV3KSBXgvQBsiQ5q2nckcTcpQ9Gqy6xUOWqav+gV6hFgDeGTanCbOILOvKQEDUoUtlWV/uZ63ZF+Lx0U+uWp+74H4/3ye5INZLY7dLfoccarS9DcvDcOsVv2jv9Z59nvWl/1CtBIqI6/1lA3sIF1t8V+SnvrbTBjNW4ylzCO0io5nIDvAAHGgcW4ogI92TnX5jSowBfkubRJ+A2etVx0beDHMROuvL/iGJUh0PAQ8CyNnmZRyb6dDubG17douzo7g7l5U5iRt4MdjuKThbeIyFQpRvOfUi2diU17V/3NyTyx9FDn/XAiyARRa77iCfjd6QSqtAZN4E/HE4ia9rt8hlATOorJDzMZiYcxpz7d4u4hbU/PobyjfMAcDX0K2iy0gWdrhlqzq3dHYY8t90yah9y19rMdb27OBoDQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9358f280-8e71-4bb6-9195-08d716ba69d6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 19:56:59.4401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2759
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Agroskin <shayag@mellanox.com>

In MPWQE mode, when transmitting packets with XDP, a packet that is smaller
than a certain size (set to 256 bytes) would be sent inline within its WQE
TX descriptor (mem-copied), in case the hardware tx queue is congested
beyond a pre-defined water-mark.

If a MPWQE cannot contain an additional inline packet, we close this
MPWQE session, and send the packet inlined within the next MPWQE.
To save some MPWQE session close+open operations, we don't open MPWQE
sessions that are contiguously smaller than certain size (set to the
HW MPWQE maximum size). If there isn't enough contiguous room in the
send queue, we fill it with NOPs and wrap the send queue index around.

This way, qualified packets are always sent inline.

Perf tests:
Tested packet rate for UDP 64Byte multi-stream
over two dual port ConnectX-5 100Gbps NICs.
CPU: Intel(R) Xeon(R) CPU E5-2680 v3 @ 2.50GHz

XDP_TX:

With 24 channels:
| ------ | bounced packets | inlined packets | inline ratio |
| before | 113.6Mpps       | 96.3Mpps        | 84%          |
| after  |   115Mpps       | 99.5Mpps        | 86%          |

With one channel:

| ------ | bounced packets | inlined packets | inline ratio |
| before | 6.7Mpps         | 0pps            | 0%           |
| after  | 6.8Mpps         | 0pps            | 0%           |

As we can see, there is improvement in both inline ratio and overall
packet rate for 24 channels. Also, we see no degradation for the
one-channel case.

Signed-off-by: Shay Agroskin <shayag@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 -
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 32 ++++-------
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 53 +++++++++++++++----
 .../ethernet/mellanox/mlx5/core/en_stats.c    |  6 +++
 .../ethernet/mellanox/mlx5/core/en_stats.h    |  3 ++
 5 files changed, 63 insertions(+), 33 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 79d93d6c7d7a..745bcc25c6f8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -483,8 +483,6 @@ struct mlx5e_xdp_mpwqe {
 	struct mlx5e_tx_wqe *wqe;
 	u8                   ds_count;
 	u8                   pkt_count;
-	u8                   max_ds_count;
-	u8                   complete;
 	u8                   inline_on;
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index b0b982cf69bb..8cb98326531f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -179,34 +179,22 @@ static void mlx5e_xdp_mpwqe_session_start(struct mlx5=
e_xdpsq *sq)
 	struct mlx5e_xdp_mpwqe *session =3D &sq->mpwqe;
 	struct mlx5e_xdpsq_stats *stats =3D sq->stats;
 	struct mlx5_wq_cyc *wq =3D &sq->wq;
-	u8  wqebbs;
-	u16 pi;
+	u16 pi, contig_wqebbs;
+
+	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
+	contig_wqebbs =3D mlx5_wq_cyc_get_contig_wqebbs(wq, pi);
+
+	if (unlikely(contig_wqebbs < MLX5_SEND_WQE_MAX_WQEBBS))
+		mlx5e_fill_xdpsq_frag_edge(sq, wq, pi, contig_wqebbs);
=20
 	mlx5e_xdpsq_fetch_wqe(sq, &session->wqe);
=20
 	prefetchw(session->wqe->data);
 	session->ds_count  =3D MLX5E_XDP_TX_EMPTY_DS_COUNT;
 	session->pkt_count =3D 0;
-	session->complete  =3D 0;
=20
 	pi =3D mlx5_wq_cyc_ctr2ix(wq, sq->pc);
=20
-/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
- * (16 * 4 =3D=3D 64) does not fit in the 6-bit DS field of Ctrl Segment.
- * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
- * full-session WQE be cache-aligned.
- */
-#if L1_CACHE_BYTES < 128
-#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
-#else
-#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
-#endif
-
-	wqebbs =3D min_t(u16, mlx5_wq_cyc_get_contig_wqebbs(wq, pi),
-		       MLX5E_XDP_MPW_MAX_WQEBBS);
-
-	session->max_ds_count =3D MLX5_SEND_WQEBB_NUM_DS * wqebbs;
-
 	mlx5e_xdp_update_inline_state(sq);
=20
 	stats->mpwqe++;
@@ -244,7 +232,7 @@ static int mlx5e_xmit_xdp_frame_check_mpwqe(struct mlx5=
e_xdpsq *sq)
 {
 	if (unlikely(!sq->mpwqe.wqe)) {
 		if (unlikely(!mlx5e_wqc_has_room_for(&sq->wq, sq->cc, sq->pc,
-						     MLX5_SEND_WQE_MAX_WQEBBS))) {
+						     MLX5E_XDPSQ_STOP_ROOM))) {
 			/* SQ is full, ring doorbell */
 			mlx5e_xmit_xdp_doorbell(sq);
 			sq->stats->full++;
@@ -285,8 +273,8 @@ static bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdp=
sq *sq,
=20
 	mlx5e_xdp_mpwqe_add_dseg(sq, xdptxd, stats);
=20
-	if (unlikely(session->complete ||
-		     session->ds_count =3D=3D session->max_ds_count))
+	if (unlikely(mlx5e_xdp_no_room_for_inline_pkt(session) ||
+		     session->ds_count =3D=3D MLX5E_XDP_MPW_MAX_NUM_DS))
 		mlx5e_xdp_mpwqe_complete(sq);
=20
 	mlx5e_xdpi_fifo_push(&sq->db.xdpi_fifo, xdpi);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index b90923932668..e0ed7710f5f1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -40,6 +40,26 @@
 	(sizeof(struct mlx5e_tx_wqe) / MLX5_SEND_WQE_DS)
 #define MLX5E_XDP_TX_DS_COUNT (MLX5E_XDP_TX_EMPTY_DS_COUNT + 1 /* SG DS */=
)
=20
+#define MLX5E_XDPSQ_STOP_ROOM (MLX5E_SQ_STOP_ROOM)
+
+#define MLX5E_XDP_INLINE_WQE_SZ_THRSD (256 - sizeof(struct mlx5_wqe_inline=
_seg))
+#define MLX5E_XDP_INLINE_WQE_MAX_DS_CNT \
+	DIV_ROUND_UP(MLX5E_XDP_INLINE_WQE_SZ_THRSD, MLX5_SEND_WQE_DS)
+
+/* The mult of MLX5_SEND_WQE_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS
+ * (16 * 4 =3D=3D 64) does not fit in the 6-bit DS field of Ctrl Segment.
+ * We use a bound lower that MLX5_SEND_WQE_MAX_WQEBBS to let a
+ * full-session WQE be cache-aligned.
+ */
+#if L1_CACHE_BYTES < 128
+#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 1)
+#else
+#define MLX5E_XDP_MPW_MAX_WQEBBS (MLX5_SEND_WQE_MAX_WQEBBS - 2)
+#endif
+
+#define MLX5E_XDP_MPW_MAX_NUM_DS \
+	(MLX5E_XDP_MPW_MAX_WQEBBS * MLX5_SEND_WQEBB_NUM_DS)
+
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param =
*xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
@@ -114,6 +134,30 @@ static inline void mlx5e_xdp_update_inline_state(struc=
t mlx5e_xdpsq *sq)
 		session->inline_on =3D 1;
 }
=20
+static inline bool
+mlx5e_xdp_no_room_for_inline_pkt(struct mlx5e_xdp_mpwqe *session)
+{
+	return session->inline_on &&
+	       session->ds_count + MLX5E_XDP_INLINE_WQE_MAX_DS_CNT > MLX5E_XDP_MP=
W_MAX_NUM_DS;
+}
+
+static inline void
+mlx5e_fill_xdpsq_frag_edge(struct mlx5e_xdpsq *sq, struct mlx5_wq_cyc *wq,
+			   u16 pi, u16 nnops)
+{
+	struct mlx5e_xdp_wqe_info *edge_wi, *wi =3D &sq->db.wqe_info[pi];
+
+	edge_wi =3D wi + nnops;
+	/* fill sq frag edge with nops to avoid wqe wrapping two pages */
+	for (; wi < edge_wi; wi++) {
+		wi->num_wqebbs =3D 1;
+		wi->num_pkts   =3D 0;
+		mlx5e_post_nop(wq, sq->sqn, &sq->pc);
+	}
+
+	sq->stats->nops +=3D nnops;
+}
+
 static inline void
 mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 			 struct mlx5e_xdp_xmit_data *xdptxd,
@@ -126,20 +170,12 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
=20
 	session->pkt_count++;
=20
-#define MLX5E_XDP_INLINE_WQE_SZ_THRSD (256 - sizeof(struct mlx5_wqe_inline=
_seg))
-
 	if (session->inline_on && dma_len <=3D MLX5E_XDP_INLINE_WQE_SZ_THRSD) {
 		struct mlx5_wqe_inline_seg *inline_dseg =3D
 			(struct mlx5_wqe_inline_seg *)dseg;
 		u16 ds_len =3D sizeof(*inline_dseg) + dma_len;
 		u16 ds_cnt =3D DIV_ROUND_UP(ds_len, MLX5_SEND_WQE_DS);
=20
-		if (unlikely(session->ds_count + ds_cnt > session->max_ds_count)) {
-			/* Not enough space for inline wqe, send with memory pointer */
-			session->complete =3D true;
-			goto no_inline;
-		}
-
 		inline_dseg->byte_count =3D cpu_to_be32(dma_len | MLX5_INLINE_SEG);
 		memcpy(inline_dseg->data, xdptxd->data, dma_len);
=20
@@ -148,7 +184,6 @@ mlx5e_xdp_mpwqe_add_dseg(struct mlx5e_xdpsq *sq,
 		return;
 	}
=20
-no_inline:
 	dseg->addr       =3D cpu_to_be64(xdptxd->dma_addr);
 	dseg->byte_count =3D cpu_to_be32(dma_len);
 	dseg->lkey       =3D sq->mkey_be;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 539b4d3656da..6eee3c7d4b06 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -74,6 +74,7 @@ static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_xmit) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_mpwqe) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_inlnw) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_nops) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_full) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_xdp_tx_cqe) },
@@ -90,6 +91,7 @@ static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_xmit) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_mpwqe) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_inlnw) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_nops) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_full) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_err) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, tx_xdp_cqes) },
@@ -200,6 +202,7 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv=
 *priv)
 		s->rx_xdp_tx_xmit  +=3D xdpsq_stats->xmit;
 		s->rx_xdp_tx_mpwqe +=3D xdpsq_stats->mpwqe;
 		s->rx_xdp_tx_inlnw +=3D xdpsq_stats->inlnw;
+		s->rx_xdp_tx_nops  +=3D xdpsq_stats->nops;
 		s->rx_xdp_tx_full  +=3D xdpsq_stats->full;
 		s->rx_xdp_tx_err   +=3D xdpsq_stats->err;
 		s->rx_xdp_tx_cqe   +=3D xdpsq_stats->cqes;
@@ -227,6 +230,7 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv=
 *priv)
 		s->tx_xdp_xmit    +=3D xdpsq_red_stats->xmit;
 		s->tx_xdp_mpwqe   +=3D xdpsq_red_stats->mpwqe;
 		s->tx_xdp_inlnw   +=3D xdpsq_red_stats->inlnw;
+		s->tx_xdp_nops	  +=3D xdpsq_red_stats->nops;
 		s->tx_xdp_full    +=3D xdpsq_red_stats->full;
 		s->tx_xdp_err     +=3D xdpsq_red_stats->err;
 		s->tx_xdp_cqes    +=3D xdpsq_red_stats->cqes;
@@ -1331,6 +1335,7 @@ static const struct counter_desc rq_xdpsq_stats_desc[=
] =3D {
 	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, xmit) },
 	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, mpwqe) },
 	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, inlnw) },
+	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, nops) },
 	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, full) },
 	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, err) },
 	{ MLX5E_DECLARE_RQ_XDPSQ_STAT(struct mlx5e_xdpsq_stats, cqes) },
@@ -1340,6 +1345,7 @@ static const struct counter_desc xdpsq_stats_desc[] =
=3D {
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, xmit) },
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, mpwqe) },
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, inlnw) },
+	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, nops) },
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, full) },
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, err) },
 	{ MLX5E_DECLARE_XDPSQ_STAT(struct mlx5e_xdpsq_stats, cqes) },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index 76ac111e14d0..bf645d42c833 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -81,6 +81,7 @@ struct mlx5e_sw_stats {
 	u64 rx_xdp_tx_xmit;
 	u64 rx_xdp_tx_mpwqe;
 	u64 rx_xdp_tx_inlnw;
+	u64 rx_xdp_tx_nops;
 	u64 rx_xdp_tx_full;
 	u64 rx_xdp_tx_err;
 	u64 rx_xdp_tx_cqe;
@@ -97,6 +98,7 @@ struct mlx5e_sw_stats {
 	u64 tx_xdp_xmit;
 	u64 tx_xdp_mpwqe;
 	u64 tx_xdp_inlnw;
+	u64 tx_xdp_nops;
 	u64 tx_xdp_full;
 	u64 tx_xdp_err;
 	u64 tx_xdp_cqes;
@@ -288,6 +290,7 @@ struct mlx5e_xdpsq_stats {
 	u64 xmit;
 	u64 mpwqe;
 	u64 inlnw;
+	u64 nops;
 	u64 full;
 	u64 err;
 	/* dirtied @completion */
--=20
2.21.0

