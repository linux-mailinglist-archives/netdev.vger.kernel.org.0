Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD82C8F435
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732860AbfHOTKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:45 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730466AbfHOTKn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPOhfp3UkbCcqbimTQsJEho8dDQVnUx/zSi+HX3x4cZXNGJw9qOR6WxVsFeKNdx6aAOna8eFYKmS6M2uFyiWtOgo5kjsJH/xBvv90qmksVu+o6d+/6nStJwIp1JiwQ0sfp3HZfhdVt9MDhe4+BSQwLU/+PGFDtDb5LkRNJedTEzNACWTi2YRPiJoOFWvBiSI6uEEzhik+OuYYt+TwVDcOedbD/o77n/BM1YV+ZfpjgqjyAziIOaXRjueeWcOj2CMRvPBeUg9QoE/s3C6uTnn9c4s0Yx6Db9rfxW56Q3xAPWk2LLF+am8FWYmRVZEmjE2oxZn6+Om3mZEdxit2z8nfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYD6tHh7AdB6pcYZSX9kkT4kKDNunz9AWs93RNc3KBE=;
 b=Lceek6EFYK+oBYofsISpoewBqtjJulh1du1ETWD3Mc3SHgjBcZeM5t34TLsKfy8S8xovTNtXscENU2Pxed1dmDwPHiniL1B5vWlr5sKkax/vw4W/siiAQSHxAI7VjuO+dgoJaguoMVC8lixoT8obl3dHqNa0pyS1ZnjFrFaJEDZ0o+zL3RqQck0IpYF8yJ48lJ2kQGvVCHgEk1N6WdMwZ4Es3dtF+KKDnCMyH20suTFTgjG1UVs3P2jLYKJFiWm4t8k5SPcEmTwTUs6BDSe3wtznWHIy4hMdSV7sHDy06JNXFPorAKnidwyzsFDlc6ZbYxXdyIqBUXRafDOX4Gdrrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jYD6tHh7AdB6pcYZSX9kkT4kKDNunz9AWs93RNc3KBE=;
 b=MrCWo8MeMroWHC3i53piPcXqIsDLTbpK643US0Ro1pWt5+NFU3TAhQ/zjQjvNZqWIvSyT9rAMufVtmUr5PKsvaG8Ygzp0p+047CBJhRpWom9mUvnX3zv/xeeVeEVxLfSrvO567Px4+vLgaQRqCqYKuhY2Ie7zsi+H412JIw+/Q4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:10 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: [net-next 12/16] net/mlx5e: RX, Handle CQE with error at the earliest
 stage
Thread-Topic: [net-next 12/16] net/mlx5e: RX, Handle CQE with error at the
 earliest stage
Thread-Index: AQHVU50O5QWVHECJnUuXo/lbp7+Vrw==
Date:   Thu, 15 Aug 2019 19:10:09 +0000
Message-ID: <20190815190911.12050-13-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2e4b5e94-2b2c-4344-09ca-08d721b43129
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB244058568073494345941623BEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: B/wOh86inW8/9DJ9xwxsa0loXINXT6NQdzjFaNU7cdf/YWeyVWO1CU6DJsC3xehUZ0jb3NqAhf+FzotSHKM+Rytaj7Sc0XLZ6nOrPR7sNT3727ZqxK+VRFDYnjBqj38uDkx5en8CiNDDAMTApa0uFDDK6j2G5N/n8WEUoyGQEKehZ1fNDoXF47WGI1c+bHNoXKgOPxb1fSenoWuscdVsq8OEgsmq56Q4cE/YkQ0x89w+/leVV6z+EqUuVud5cHIkUD0X9KrMcG/h8HnEbhnMDNZoZAyHKhnrkatodFgTAsy+E2e1PvNNeCF8uollZYD/xXl5q8IERxSa0TZ5VhJZDH1tG8ACwmK1ZUacDNhMuzkTt5ewLPBQOEYPxGe7lny9dIvl133s/i1YzzW/ocvCVPaDXI62VY6O3jSSMYbzsNA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e4b5e94-2b2c-4344-09ca-08d721b43129
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:10.0406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Djlo33sjNRP75Yq4oiwN/1T5f6nxPEMKB6QBHFYyodMD8xm10Y7+DbTkQzmMuiVaunkZLvex2Vb3XkH94mF2eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
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

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
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

