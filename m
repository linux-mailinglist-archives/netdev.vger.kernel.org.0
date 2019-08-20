Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3749096A4C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfHTUY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:57 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731020AbfHTUYs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RZlDgaxh8n5VAW0QsRfbcz6xH8RXz9VQxMp82FeIEkDD1Xw+PczPpFZqnujiR7SYOTtlq6nDc1lhHI215arC0+iLm9IHe6Zopzm2rPBbD29A0+Sk2p8s0KfNzXmxakPl5gLDwzibV2hTSEXFr66ID9zwMl0TqE5OzCdA2ktnkscNz8X0nnQvrNXV0KKSD2mKnK27KkrZQIgh8A6WhHIhgXFAFjlA+nfwPgPy47vlxFWf+jlg1rQXKdTC6XDntmec+7gRzuMgHf7QtdQpAuLRfY2OB05Zg0BSQQbc4I4UIOIDO5c/sx1iDgSe7RiH0gCVYmA+dQ9XgyAjuYmjVklnbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozmHXo0L5fMqFzPVWMOYt4SPIV51AsMyqE/+M9LOTeE=;
 b=XD8fkSEGcIobl6td+9bww7aCGVwP0Po6+ruHztkGv1glnwBSlm9ai/fZ9rXVnyiYSIAs1TG2O/+AeAAOk7Y4hMRhJSVGnYKlzIMf1eixf8pHoNVQ3CM1y+tPBAYIQB7bG2ajO7+ZUr7Y4O7jaFUt8xwN6CbuPOMWbVQvItuFuMuZCfCvvTGFX7K4iT1YqblnUkCg6bkc/uBZymYpCQy0nk9gvJXinYmmoj/ZpwZfpz7SniMWIzggTRl7JOv6ET5QWMxqdxzZYAxuE2/4VsP3XhHyvAvD2gcFMXnjEhTGzoXyleMRCZl/1Env+OuhsHDuS17auJHBv5FA0UWG0Pg3MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozmHXo0L5fMqFzPVWMOYt4SPIV51AsMyqE/+M9LOTeE=;
 b=fljbbYwXWRxqgh5TwrKsi9JcU2m/I6k5CVU1xT6vbRin4ddHVS7ystTAJTkfWnB/W+w2YQb4z8798jUPld80jOR9suko9/pwuYN6k1GV6sG+sYrhz5jdv2Ehsdwmxpp6rnzYvJNXcBSG+pRz8PCMMQZy5c6BUv0oNWKCaq3I8Qg=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:34 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [net-next v2 12/16] net/mlx5e: RX, Handle CQE with error at the
 earliest stage
Thread-Topic: [net-next v2 12/16] net/mlx5e: RX, Handle CQE with error at the
 earliest stage
Thread-Index: AQHVV5VHylflxr4oQE60fM+hlxTG6g==
Date:   Tue, 20 Aug 2019 20:24:34 +0000
Message-ID: <20190820202352.2995-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: b403794a-4134-4757-d018-08d725ac6a0c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB26801EAB89AE689989B822FDBEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: cLqtjomkkjiShHNH/rQXuXOabWZqUfuLw01HK/9aw7/MngXU0sZfR9v+uJthlvS0KX6iUXrNwppPmA+yQccy2RRTMwJKRyRA13qhb2lmvdo53jA1zty9gn6ApNW+WSPvzJ+CAr8wrdnlHJ/DfkP6hubo1T0NAYnFrkad5lmNqlZZnsbCBacueC4SIrUUsBkc7Rl8hNr7CDN88Jtj0Uh60G1IrBqnJxBdpFmB4htEQ23+C0gUEPeBDjUtTiu+FBEhV3saiXJy3cIfnFdJKsM4J985Wi3aIp9wIpzafIn9CAFQfEGJdOptvpSVO7R3EAJ333M6cYogYW0EICPgfwKxXPU29cVy1qMD1QTuagXb7SlLp0t1/oU5PMaf2LmyDZjqWxinP2Ej7kdba1D1qjCBiChK7i2ikhqKmJV9R8LGBic=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b403794a-4134-4757-d018-08d725ac6a0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:34.1251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lRvr9BT2z2aJkWxPd34bucGN9N8+41L7kAqUwqIj41fvMSmgKw1ycajXYmz48UPghQUwgYri3LtU0v4hPDg00Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just to be aligned with the MPWQE handlers, handle RX WQE with error
for legacy RQs in the top RX handlers, just before calling skb_from_cqe().

CQE error handling will now be called at the same stage regardless of
the RQ type or netdev mode NIC, Representor, IPoIB, etc ..

This will be useful for down stream patch to improve error CQE
handling.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 49 +++++++++++--------
 2 files changed, 30 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index b4a2d9be17d6..52e9ca37cf46 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -6,6 +6,8 @@
=20
 #include "en.h"
=20
+#define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND=
)
+
 int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 0f6033ea475d..43d790b7d4ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -48,6 +48,7 @@
 #include "lib/clock.h"
 #include "en/xdp.h"
 #include "en/xsk/rx.h"
+#include "en/health.h"
=20
 static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
 {
@@ -1069,11 +1070,6 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struc=
t mlx5_cqe64 *cqe,
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
=20
-	if (unlikely(get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND)) {
-		rq->stats->wqe_err++;
-		return NULL;
-	}
-
 	rcu_read_lock();
 	consumed =3D mlx5e_xdp_handle(rq, di, va, &rx_headroom, &cqe_bcnt, false)=
;
 	rcu_read_unlock();
@@ -1101,11 +1097,6 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, st=
ruct mlx5_cqe64 *cqe,
 	u16 byte_cnt     =3D cqe_bcnt - headlen;
 	struct sk_buff *skb;
=20
-	if (unlikely(get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND)) {
-		rq->stats->wqe_err++;
-		return NULL;
-	}
-
 	/* XDP is not supported in this configuration, as incoming packets
 	 * might spread among multiple pages.
 	 */
@@ -1151,6 +1142,11 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct=
 mlx5_cqe64 *cqe)
 	wi       =3D get_frag(rq, ci);
 	cqe_bcnt =3D be32_to_cpu(cqe->byte_cnt);
=20
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto free_wqe;
+	}
+
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
@@ -1192,6 +1188,11 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, st=
ruct mlx5_cqe64 *cqe)
 	wi       =3D get_frag(rq, ci);
 	cqe_bcnt =3D be32_to_cpu(cqe->byte_cnt);
=20
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto free_wqe;
+	}
+
 	skb =3D rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
@@ -1326,7 +1327,7 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, s=
truct mlx5_cqe64 *cqe)
=20
 	wi->consumed_strides +=3D cstrides;
=20
-	if (unlikely(get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND)) {
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
 		rq->stats->wqe_err++;
 		goto mpwrq_cqe_out;
 	}
@@ -1502,6 +1503,11 @@ void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, struct=
 mlx5_cqe64 *cqe)
 	wi       =3D get_frag(rq, ci);
 	cqe_bcnt =3D be32_to_cpu(cqe->byte_cnt);
=20
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto wq_free_wqe;
+	}
+
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
@@ -1537,26 +1543,27 @@ void mlx5e_ipsec_handle_rx_cqe(struct mlx5e_rq *rq,=
 struct mlx5_cqe64 *cqe)
 	wi       =3D get_frag(rq, ci);
 	cqe_bcnt =3D be32_to_cpu(cqe->byte_cnt);
=20
+	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		rq->stats->wqe_err++;
+		goto wq_free_wqe;
+	}
+
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
 			      rq, cqe, wi, cqe_bcnt);
-	if (unlikely(!skb)) {
-		/* a DROP, save the page-reuse checks */
-		mlx5e_free_rx_wqe(rq, wi, true);
-		goto wq_cyc_pop;
-	}
+	if (unlikely(!skb)) /* a DROP, save the page-reuse checks */
+		goto wq_free_wqe;
+
 	skb =3D mlx5e_ipsec_handle_rx_skb(rq->netdev, skb, &cqe_bcnt);
-	if (unlikely(!skb)) {
-		mlx5e_free_rx_wqe(rq, wi, true);
-		goto wq_cyc_pop;
-	}
+	if (unlikely(!skb))
+		goto wq_free_wqe;
=20
 	mlx5e_complete_rx_cqe(rq, cqe, cqe_bcnt, skb);
 	napi_gro_receive(rq->cq.napi, skb);
=20
+wq_free_wqe:
 	mlx5e_free_rx_wqe(rq, wi, true);
-wq_cyc_pop:
 	mlx5_wq_cyc_pop(wq);
 }
=20
--=20
2.21.0

