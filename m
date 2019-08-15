Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D738F431
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732810AbfHOTKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:39 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726008AbfHOTKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVYNUZC048nbeBuh520pv0JA4jytJirN4cAEw1ldfiWL0o1d7aLlrUMi3BKBntzQiX4giZRICCOWWuP+QH58rIWWUlq5rqwvkPM0NG/tPO2S4/wDBhKZIgl6cbPPPFdEI3S7fzXcu3x0zFIU9yXeIpNv3rhHZUbWpY75GjuJqrwjzFSEiialY4Uwr+MNtJQjYSC3vgTCEK0/UEnEfOZbisPSHXzWJPYtAZkPxF1cb1FxW31qVVGNM0j0GkNq/4S/Ljkr3eOsIsCx9I4pMupex6ju87p80lR5bZwyxILSOBDLVWydIffxaIcru3wVqMvmtsCJjtYEdIPO9czMRCfqfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncSr8CGQ60CMbG527iLiidZLe5uyiiQXuJgXD1paeF4=;
 b=MBNl5YrjaaX4D2HMzDnxXYXlOtKba2ebLdhV2DsSgLZCnIRg34qdfchYodUdCL5DIGU+tADXjD6jVT2l2AKBRTEmkc7PLS2ncwUbI84rTA0AiGVwK4fKjw0acKJKxBl70eFws6fC0Kfs23um1osW9SoafXFmMbxAB7+xS/R6muq4xhp+dNayQ3BevrQId7Im1xqhONlrtW9pdpaXQ9WJqEka3P1QIJ3RuL3JAtHHEvQGjU9XlrGx5BQ98WTFH/8qwej8bF2vTUvUs4Kq0NFerq7RISWqI9mC1KFTS0MF87h0/wsYiu+Ibh1nqnLMU28tVLbX4y+eXfk42JUjtMuOWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ncSr8CGQ60CMbG527iLiidZLe5uyiiQXuJgXD1paeF4=;
 b=aPJwFtEH17BFmR+PO0tMZPxufepHwOLN4jERFgLf3Apo6zIIcsA/QmAIT5zTRPX1fvn1WXnuV0ZebLboYfsI4ZHBKqKcJ/RFXQQ6v1gnb4G8rvRnrc7cxzIvZwGkvu74YZ14GCQKead8e9t8H3AAiSRhVg7QImoBjUBg7Vs//hA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:06 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/16] net/mlx5e: Report and recover from CQE error on
 ICOSQ
Thread-Topic: [net-next 10/16] net/mlx5e: Report and recover from CQE error on
 ICOSQ
Thread-Index: AQHVU50Mx9T8RxUX2keMt5ZUBGuIuA==
Date:   Thu, 15 Aug 2019 19:10:05 +0000
Message-ID: <20190815190911.12050-11-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: d5d904c4-c3ff-431e-0ce7-08d721b42eab
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2440523BD3312DF1920B5E3ABEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:277;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(30864003)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Xysp2Bw16fPpotxXGeMGs8vqifHcx6v/xwEC13QZcwf0v2hcg78K1XVzctkJhIXDyeWTWSLwpvVSlkwjF+pSuVxlA4audGOAwqA+bIQ6rW4uM9In/xtjE2BmuZeyIHtdkyScZ15BT32bPkf+P1IWyp2E90C2IN6SNztn6PF6E7Ry7+SXAzb+GVVUGImwqjVmXNOrqo/Kf7DbTfOCysfd4Uo8CqpNYl/aBRYlvaeFUS+7/svmEVwsAWnpC0VxgPdstd9ykazZXNfCHtE1aLUxepnNqgN8CdRHtlANLVY3q1gec8Lhvk4buYXq0YQY2W5gInJXi4/We5s8rZCUen0nuH53m+WGL8zgA9o0oo0jrQX+yPP8R+7knb/ua7lRDF8NTw7WZQchClmI87opYfsI/DoaBDt/CTb+w+1WGywvj/w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5d904c4-c3ff-431e-0ce7-08d721b42eab
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:05.8395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yem2Gw8RRAVa5QJ29w8U2k5j5rGO2HeQVdDPFfX2TDPLWsFSUcUeVIcQJuMfoDNe5NoR1maNBh+0ZL5r2GHMIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for report and recovery from error on completion on ICOSQ.
Deactivate RQ and flush, then deactivate ICOSQ. Set the queue back to
ready state (firmware) and reset the ICOSQ and the RQ (software
resources). Finally, activate the ICOSQ and the RQ.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |   8 ++
 .../ethernet/mellanox/mlx5/core/en/health.h   |   1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       | 105 +++++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  22 +++-
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   2 +
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   3 +
 .../ethernet/mellanox/mlx5/core/en_stats.h    |   2 +
 7 files changed, 136 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index de234650ba57..5f2a1d14de68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -546,6 +546,8 @@ struct mlx5e_icosq {
 	/* control path */
 	struct mlx5_wq_ctrl        wq_ctrl;
 	struct mlx5e_channel      *channel;
+
+	struct work_struct         recover_work;
 } ____cacheline_aligned_in_smp;
=20
 struct mlx5e_wqe_frag_info {
@@ -1021,6 +1023,12 @@ void mlx5e_set_rx_cq_mode_params(struct mlx5e_params=
 *params,
 void mlx5e_set_rq_type(struct mlx5_core_dev *mdev, struct mlx5e_params *pa=
rams);
 void mlx5e_init_rq_type_params(struct mlx5_core_dev *mdev,
 			       struct mlx5e_params *params);
+int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_st=
ate);
+void mlx5e_activate_rq(struct mlx5e_rq *rq);
+void mlx5e_deactivate_rq(struct mlx5e_rq *rq);
+void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
+void mlx5e_activate_icosq(struct mlx5e_icosq *icosq);
+void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq);
=20
 int mlx5e_modify_sq(struct mlx5_core_dev *mdev, u32 sqn,
 		    struct mlx5e_modify_sq_param *p);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index a751c5316baf..8acd9dc520cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -18,6 +18,7 @@ int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg=
 *fmsg);
=20
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
+void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
=20
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 66611c50e1c9..1eec17a36d00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -27,6 +27,105 @@ static int mlx5e_query_rq_state(struct mlx5_core_dev *d=
ev, u32 rqn, u8 *state)
 	return err;
 }
=20
+static int mlx5e_wait_for_icosq_flush(struct mlx5e_icosq *icosq)
+{
+	unsigned long exp_time =3D jiffies + msecs_to_jiffies(2000);
+
+	while (time_before(jiffies, exp_time)) {
+		if (icosq->cc =3D=3D icosq->pc)
+			return 0;
+
+		msleep(20);
+	}
+
+	netdev_err(icosq->channel->netdev,
+		   "Wait for ICOSQ 0x%x flush timeout (cc =3D 0x%x, pc =3D 0x%x)\n",
+		   icosq->sqn, icosq->cc, icosq->pc);
+
+	return -ETIMEDOUT;
+}
+
+static void mlx5e_reset_icosq_cc_pc(struct mlx5e_icosq *icosq)
+{
+	WARN_ONCE(icosq->cc !=3D icosq->pc, "ICOSQ 0x%x: cc (0x%x) !=3D pc (0x%x)=
\n",
+		  icosq->sqn, icosq->cc, icosq->pc);
+	icosq->cc =3D 0;
+	icosq->pc =3D 0;
+}
+
+static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
+{
+	struct mlx5e_icosq *icosq =3D ctx;
+	struct mlx5_core_dev *mdev =3D icosq->channel->mdev;
+	struct net_device *dev =3D icosq->channel->netdev;
+	struct mlx5e_rq *rq =3D &icosq->channel->rq;
+	u8 state;
+	int err;
+
+	err =3D mlx5_core_query_sq_state(mdev, icosq->sqn, &state);
+	if (err) {
+		netdev_err(dev, "Failed to query ICOSQ 0x%x state. err =3D %d\n",
+			   icosq->sqn, err);
+		goto out;
+	}
+
+	if (state !=3D MLX5_SQC_STATE_ERR)
+		goto out;
+
+	mlx5e_deactivate_rq(rq);
+	err =3D mlx5e_wait_for_icosq_flush(icosq);
+	if (err)
+		goto out;
+
+	mlx5e_deactivate_icosq(icosq);
+
+	/* At this point, both the rq and the icosq are disabled */
+
+	err =3D mlx5e_health_sq_to_ready(icosq->channel, icosq->sqn);
+	if (err)
+		goto out;
+
+	mlx5e_reset_icosq_cc_pc(icosq);
+	mlx5e_free_rx_descs(rq);
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
+	mlx5e_activate_icosq(icosq);
+	mlx5e_activate_rq(rq);
+
+	rq->stats->recover++;
+	return 0;
+out:
+	clear_bit(MLX5E_SQ_STATE_RECOVERING, &icosq->state);
+	return err;
+}
+
+void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq)
+{
+	struct mlx5e_priv *priv =3D icosq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D icosq;
+	err_ctx.recover =3D mlx5e_rx_reporter_err_icosq_cqe_recover;
+	sprintf(err_str, "ERR CQE on ICOSQ: 0x%x", icosq->sqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
+static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ct=
x)
+{
+	return err_ctx->recover(err_ctx->ctx);
+}
+
+static int mlx5e_rx_reporter_recover(struct devlink_health_reporter *repor=
ter,
+				     void *context)
+{
+	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
+	struct mlx5e_err_ctx *err_ctx =3D context;
+
+	return err_ctx ? mlx5e_rx_reporter_recover_from_ctx(err_ctx) :
+			 mlx5e_health_recover_channels(priv);
+}
+
 static int mlx5e_rx_reporter_build_diagnose_output(struct mlx5e_rq *rq,
 						   struct devlink_fmsg *fmsg)
 {
@@ -165,9 +264,12 @@ static int mlx5e_rx_reporter_diagnose(struct devlink_h=
ealth_reporter *reporter,
=20
 static const struct devlink_health_reporter_ops mlx5_rx_reporter_ops =3D {
 	.name =3D "rx",
+	.recover =3D mlx5e_rx_reporter_recover,
 	.diagnose =3D mlx5e_rx_reporter_diagnose,
 };
=20
+#define MLX5E_REPORTER_RX_GRACEFUL_PERIOD 500
+
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
@@ -176,7 +278,8 @@ int mlx5e_reporter_rx_create(struct mlx5e_priv *priv)
=20
 	reporter =3D devlink_health_reporter_create(devlink,
 						  &mlx5_rx_reporter_ops,
-						  0, false, priv);
+						  MLX5E_REPORTER_RX_GRACEFUL_PERIOD,
+						  true, priv);
 	if (IS_ERR(reporter)) {
 		netdev_warn(priv->netdev, "Failed to create rx reporter, err =3D %ld\n",
 			    PTR_ERR(reporter));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b9a7b6563ae6..db2bcc48cfcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -700,8 +700,7 @@ static int mlx5e_create_rq(struct mlx5e_rq *rq,
 	return err;
 }
=20
-static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state,
-				 int next_state)
+int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_st=
ate)
 {
 	struct mlx5_core_dev *mdev =3D rq->mdev;
=20
@@ -812,7 +811,7 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int=
 wait_time)
 	return -ETIMEDOUT;
 }
=20
-static void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
+void mlx5e_free_rx_descs(struct mlx5e_rq *rq)
 {
 	__be16 wqe_ix_be;
 	u16 wqe_ix;
@@ -891,7 +890,7 @@ int mlx5e_open_rq(struct mlx5e_channel *c, struct mlx5e=
_params *params,
 	return err;
 }
=20
-static void mlx5e_activate_rq(struct mlx5e_rq *rq)
+void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
 	mlx5e_trigger_irq(&rq->channel->icosq);
@@ -906,6 +905,7 @@ void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
+	cancel_work_sync(&rq->channel->icosq.recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
 	mlx5e_free_rq(rq);
@@ -1022,6 +1022,14 @@ static int mlx5e_alloc_icosq_db(struct mlx5e_icosq *=
sq, int numa)
 	return 0;
 }
=20
+static void mlx5e_icosq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_icosq *sq =3D container_of(recover_work, struct mlx5e_icosq,
+					      recover_work);
+
+	mlx5e_reporter_icosq_cqe_err(sq);
+}
+
 static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 			     struct mlx5e_sq_param *param,
 			     struct mlx5e_icosq *sq)
@@ -1044,6 +1052,8 @@ static int mlx5e_alloc_icosq(struct mlx5e_channel *c,
 	if (err)
 		goto err_sq_wq_destroy;
=20
+	INIT_WORK(&sq->recover_work, mlx5e_icosq_err_cqe_work);
+
 	return 0;
=20
 err_sq_wq_destroy:
@@ -1389,12 +1399,12 @@ int mlx5e_open_icosq(struct mlx5e_channel *c, struc=
t mlx5e_params *params,
 	return err;
 }
=20
-static void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
+void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 {
 	set_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
 }
=20
-static void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
+void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
 	struct mlx5e_channel *c =3D icosq->channel;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 60570b442fff..0f6033ea475d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -615,6 +615,8 @@ void mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		if (unlikely(get_cqe_opcode(cqe) !=3D MLX5_CQE_REQ)) {
 			netdev_WARN_ONCE(cq->channel->netdev,
 					 "Bad OP in ICOSQ CQE: 0x%x\n", get_cqe_opcode(cqe));
+			if (!test_and_set_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
+				queue_work(cq->channel->priv->wq, &sq->recover_work);
 			break;
 		}
 		do {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 94a32c76c182..18e4c162256a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -109,6 +109,7 @@ static const struct counter_desc sw_stats_desc[] =3D {
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_cache_waive) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_congst_umr) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_arfs_err) },
+	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, rx_recover) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_events) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_poll) },
 	{ MLX5E_DECLARE_STAT(struct mlx5e_sw_stats, ch_arm) },
@@ -220,6 +221,7 @@ static void mlx5e_grp_sw_update_stats(struct mlx5e_priv=
 *priv)
 		s->rx_cache_waive +=3D rq_stats->cache_waive;
 		s->rx_congst_umr  +=3D rq_stats->congst_umr;
 		s->rx_arfs_err    +=3D rq_stats->arfs_err;
+		s->rx_recover     +=3D rq_stats->recover;
 		s->ch_events      +=3D ch_stats->events;
 		s->ch_poll        +=3D ch_stats->poll;
 		s->ch_arm         +=3D ch_stats->arm;
@@ -1298,6 +1300,7 @@ static const struct counter_desc rq_stats_desc[] =3D =
{
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, cache_waive) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, congst_umr) },
 	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, arfs_err) },
+	{ MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, recover) },
 };
=20
 static const struct counter_desc sq_stats_desc[] =3D {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.h
index bf645d42c833..c281e567711d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.h
@@ -116,6 +116,7 @@ struct mlx5e_sw_stats {
 	u64 rx_cache_waive;
 	u64 rx_congst_umr;
 	u64 rx_arfs_err;
+	u64 rx_recover;
 	u64 ch_events;
 	u64 ch_poll;
 	u64 ch_arm;
@@ -249,6 +250,7 @@ struct mlx5e_rq_stats {
 	u64 cache_waive;
 	u64 congst_umr;
 	u64 arfs_err;
+	u64 recover;
 };
=20
 struct mlx5e_sq_stats {
--=20
2.21.0

