Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21CB163AC5
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgBSDGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:31 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:44883
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728202AbgBSDGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpsjURkDrMHJsED4sKhKjpo1d0sz/UP8nLoIuHyspp5dTMGgaqmhUVzHmOTDTjRfBWhOrne5SBFlu7Y7WAhfWZrFy8THrXIxehC7NGNF3XsKCMX39Wwkv//dzoKVE2xNDQjZoY/Mcn3kLiAR7Aby+jx8pOkclJ99PkLhpPtV89nhn1obskeqWGH3HCpeRXV5Mb3H1NdAZhT+EsUv7O0v6aibLh+3cFuc79Akvw9TpkX7XwVF0bvRmueqrxzifrwuY5LPYjo0YyJBeAhaVVp9IeC86vFVV88p9yhBv4+xjLD6Y/Aq9bD+HAsNmYBDCuc6vuW3bbUaxEdQkUUh97M7eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq6uH0e4AYWWImdLT/c1CzYbHmB+tlSwXA3gkPcdfqY=;
 b=RUpBgvM9pEju7vSBXkDjtaJN+pYXz1DtoHmjA6Ps4EpgASdYHynfZMugF55Cm5ffGzCqSzUX7eTXlpPpaDP65WrXDXK7q8MdgGh/CCks4qHStwZ/YWaa2uXYNxAMO+0hBCsuaKkwXr18yhFcEUxdMnUMdCc3TndXb4YrVwCsyu9t2eU5eP+2HdKSnhj27lgzhbdWuv+GI26ZqpGf4jlmoGIWj7W1olppstP0X0uYm6t3YdYoPD2FxIrVTCeY/neGNNc5SWyRahFP5Yfe2sJnLgwjlgBVhTifuFb/hQNjZ1zoR8JtSNSGkhhOl1YNVs6bhbW3utKk8x6lmYpg2UN/Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fq6uH0e4AYWWImdLT/c1CzYbHmB+tlSwXA3gkPcdfqY=;
 b=CWVU3LKMs45iGtxXppsoNCluHrRefQs/8fIvola2222YA0d23/7sgpjI+6IQBZWzLGxAJqc6raZIV+pSU1wbZdZ1HV9abnkqOBQ8ewn8nmPS3+hJnJQDvRorb2BtvCmx1ITYw407FychPJPWF4IetaxgLixKXp0g1OEpesQtQWI=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:27 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:23 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/7] net/mlx5e: Reset RQ doorbell counter before moving RQ state
 from RST to RDY
Thread-Topic: [net 2/7] net/mlx5e: Reset RQ doorbell counter before moving RQ
 state from RST to RDY
Thread-Index: AQHV5tGSLsZbZuoA10+q7Odu+2Pi8Q==
Date:   Wed, 19 Feb 2020 03:06:26 +0000
Message-ID: <20200219030548.13215-3-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8c4d2a0-f648-4876-dfbc-08d7b4e8b4bc
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB58539E048AD4694AB9B23EEEBE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o1l8sxCv8YS1CpvojOtTORM4Dx9JFpb7Uv0ciRuZjRtzY6MiRwejrbsUahGIArWHd6/MloOyG00kakP9XyJT+eESqEUAc2+BdwGZm/M0YgWRDIzhgj76bdcjLzhJR3JT+5EUZIiV8gJCFfekhFkZtz+K4fqnnKp+AMgTIJqwIq4QKnfjpZw3vmMEc9PG9FAw+BFQY4Snim7J29STS0GCmUB6gnjIMxLVj7TrumuedlQfs+RAl5hzyxzxx8uskcbP6mN1I4bXrLp749H2oZaf+35Mis0F3sYdbPtOALejb5sXM2q2ljqjpRFkIKZFhBSgNmdbtTF5drN15bgnzvIZ6UTFtnrPGOS6KwviF7MeOaYU7x2E+k/WFuix6BS5sc/Q590pVaobkZpPPHO/fLwoGyUX6plY3D6J00UikdI8GKgTDpoBCbBrMXHc/altiv3ijeLmSVWGtURLP+BGojnZqwELO5j22bpGnVhH6cy18U+LJfvrNFIsY96JcUb2UFJbnA8z19mUlAvQ9NaebvbhbLvr+Wq6Fmiy8FLvpEsZkqk=
x-ms-exchange-antispam-messagedata: RdALnK2NWcmAKP5lP7kUcPE51mcXaH2AnEwVpfsDFyDOOgoSlRLIgVCkp8mHqbH4MzaRXYS47og4170uC9cHDMFgofGo1qAoDjhFtUkdZE2jJa8O6hjQPEh2XXqz2l1jkQ6N9bK+feX7YQzyp7mTGQ==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8c4d2a0-f648-4876-dfbc-08d7b4e8b4bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:26.3878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vD2m2aAdznX1nApzYwm9MkbgmuNPPdWCNfYXSIjKExlOL2c0koFO6GH2bWrJTrBGXsQpEJyFyBlMl+A1lljdgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Initialize RQ doorbell counters to zero prior to moving an RQ from RST
to RDY state. Per HW spec, when RQ is back to RDY state, the descriptor
ID on the completion is reset. The doorbell record must comply.

Fixes: 8276ea1353a4 ("net/mlx5e: Report and recover from CQE with error on =
RQ")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reported-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  8 ++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++
 drivers/net/ethernet/mellanox/mlx5/core/wq.c  | 39 ++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/wq.h  |  2 +
 4 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 7c8796d9743f..a226277b0980 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -179,6 +179,14 @@ mlx5e_tx_dma_unmap(struct device *pdev, struct mlx5e_s=
q_dma *dma)
 	}
 }
=20
+static inline void mlx5e_rqwq_reset(struct mlx5e_rq *rq)
+{
+	if (rq->wq_type =3D=3D MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ)
+		mlx5_wq_ll_reset(&rq->mpwqe.wq);
+	else
+		mlx5_wq_cyc_reset(&rq->wqe.wq);
+}
+
 /* SW parser related functions */
=20
 struct mlx5e_swp_spec {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 454d3459bd8b..966983674663 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -712,6 +712,9 @@ int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr=
_state, int next_state)
 	if (!in)
 		return -ENOMEM;
=20
+	if (curr_state =3D=3D MLX5_RQC_STATE_RST && next_state =3D=3D MLX5_RQC_ST=
ATE_RDY)
+		mlx5e_rqwq_reset(rq);
+
 	rqc =3D MLX5_ADDR_OF(modify_rq_in, in, ctx);
=20
 	MLX5_SET(modify_rq_in, in, rq_state, curr_state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.c b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.c
index 02f7e4a39578..01f075fac276 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.c
@@ -94,6 +94,13 @@ void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix=
, u8 nstrides)
 	print_hex_dump(KERN_WARNING, "", DUMP_PREFIX_OFFSET, 16, 1, wqe, len, fal=
se);
 }
=20
+void mlx5_wq_cyc_reset(struct mlx5_wq_cyc *wq)
+{
+	wq->wqe_ctr =3D 0;
+	wq->cur_sz =3D 0;
+	mlx5_wq_cyc_update_db_record(wq);
+}
+
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *qpc, struct mlx5_wq_qp *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl)
@@ -192,6 +199,19 @@ int mlx5_cqwq_create(struct mlx5_core_dev *mdev, struc=
t mlx5_wq_param *param,
 	return err;
 }
=20
+static void mlx5_wq_ll_init_list(struct mlx5_wq_ll *wq)
+{
+	struct mlx5_wqe_srq_next_seg *next_seg;
+	int i;
+
+	for (i =3D 0; i < wq->fbc.sz_m1; i++) {
+		next_seg =3D mlx5_wq_ll_get_wqe(wq, i);
+		next_seg->next_wqe_index =3D cpu_to_be16(i + 1);
+	}
+	next_seg =3D mlx5_wq_ll_get_wqe(wq, i);
+	wq->tail_next =3D &next_seg->next_wqe_index;
+}
+
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *wqc, struct mlx5_wq_ll *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl)
@@ -199,9 +219,7 @@ int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struc=
t mlx5_wq_param *param,
 	u8 log_wq_stride =3D MLX5_GET(wq, wqc, log_wq_stride);
 	u8 log_wq_sz     =3D MLX5_GET(wq, wqc, log_wq_sz);
 	struct mlx5_frag_buf_ctrl *fbc =3D &wq->fbc;
-	struct mlx5_wqe_srq_next_seg *next_seg;
 	int err;
-	int i;
=20
 	err =3D mlx5_db_alloc_node(mdev, &wq_ctrl->db, param->db_numa_node);
 	if (err) {
@@ -220,13 +238,7 @@ int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, stru=
ct mlx5_wq_param *param,
=20
 	mlx5_init_fbc(wq_ctrl->buf.frags, log_wq_stride, log_wq_sz, fbc);
=20
-	for (i =3D 0; i < fbc->sz_m1; i++) {
-		next_seg =3D mlx5_wq_ll_get_wqe(wq, i);
-		next_seg->next_wqe_index =3D cpu_to_be16(i + 1);
-	}
-	next_seg =3D mlx5_wq_ll_get_wqe(wq, i);
-	wq->tail_next =3D &next_seg->next_wqe_index;
-
+	mlx5_wq_ll_init_list(wq);
 	wq_ctrl->mdev =3D mdev;
=20
 	return 0;
@@ -237,6 +249,15 @@ int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, stru=
ct mlx5_wq_param *param,
 	return err;
 }
=20
+void mlx5_wq_ll_reset(struct mlx5_wq_ll *wq)
+{
+	wq->head =3D 0;
+	wq->wqe_ctr =3D 0;
+	wq->cur_sz =3D 0;
+	mlx5_wq_ll_init_list(wq);
+	mlx5_wq_ll_update_db_record(wq);
+}
+
 void mlx5_wq_destroy(struct mlx5_wq_ctrl *wq_ctrl)
 {
 	mlx5_frag_buf_free(wq_ctrl->mdev, &wq_ctrl->buf);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wq.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/wq.h
index d9a94bc223c0..4cadc336593f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wq.h
@@ -80,6 +80,7 @@ int mlx5_wq_cyc_create(struct mlx5_core_dev *mdev, struct=
 mlx5_wq_param *param,
 		       void *wqc, struct mlx5_wq_cyc *wq,
 		       struct mlx5_wq_ctrl *wq_ctrl);
 void mlx5_wq_cyc_wqe_dump(struct mlx5_wq_cyc *wq, u16 ix, u8 nstrides);
+void mlx5_wq_cyc_reset(struct mlx5_wq_cyc *wq);
=20
 int mlx5_wq_qp_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *qpc, struct mlx5_wq_qp *wq,
@@ -92,6 +93,7 @@ int mlx5_cqwq_create(struct mlx5_core_dev *mdev, struct m=
lx5_wq_param *param,
 int mlx5_wq_ll_create(struct mlx5_core_dev *mdev, struct mlx5_wq_param *pa=
ram,
 		      void *wqc, struct mlx5_wq_ll *wq,
 		      struct mlx5_wq_ctrl *wq_ctrl);
+void mlx5_wq_ll_reset(struct mlx5_wq_ll *wq);
=20
 void mlx5_wq_destroy(struct mlx5_wq_ctrl *wq_ctrl);
=20
--=20
2.24.1

