Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E76696A4A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731082AbfHTUYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:53 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731074AbfHTUYw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lv+saxJ9KKct4kg+7s6RsOFIxGrPKqWTieN6xp3udaecbnS66CWdkpGAlJxvZZWNrzcPbdBKlX4DQMt+X9s/dAuAQOfbo9NVRd7HRe/5XVZPh1+jpizIre+BpUEsES2PUf5+HtVD43V0HgCJpWDJfSFeRCE+v3PoiYU275QvpJqB5ifDGFOfNj3ybtZIyinBPwEgRVUJGo2YdabBTtLJQ3KvXbl3vP46BsMlgs7+dd3PRItf6d7m6fwAB6ddeqqj83im5Lv4lwbg6cCS3iORHD4fQkMpQKplFl06s+8mF4ghyJ5gv8gglqrL/pci+g44Wf/qbtprv84YEvV0GI+gVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgW3lw2ynbZZp98jFfb/+v4woJLJ4aLv3tnicg40ykg=;
 b=VHXUJerrKBaWJA4/iweAT93sLethbHpoidW/tjJEA35DHS6k5z1kVcGwN4jBKVetJkZIZDaYmSiKZIRuRkJ7bt5ph+jySrTkf7oADm3KMNd9oFMHtO4VyRiODkroxP0QcV1jIPxOXYWSM8En667zUtgRXSf6Ho9jNJTbJhtYbON5Q0m31O2UmVYOOzlSIoq6f5zEjoxLlkXankZ4UFT6ba+KhmXCEykwBpzudZ/bjDQtujbfHvl8lJobwanhJIk3mh5i7RT3GWKCKOasbZxZrJYA/W6J5JS+wvEaKZ1xxQ/QKbniLQSEv6S7z+UWRMs/6o4u/rlJ17JqO8f8OhNPjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EgW3lw2ynbZZp98jFfb/+v4woJLJ4aLv3tnicg40ykg=;
 b=VUTein1A0rI0pUCkSTjAXQ21K7g8+3xJdWYkYyuQ3N7i/CnGPpy0qqFiXEiQVI7g/15oeFJWG6h7geO2Z5xy5+dbE6MzPf+67v4msPOlTy2OZ2m/+OHslCTQqrdSJxHshm1Leu/8PzgxlGfiH6nads52HhtcW9hBGACS4VLroVc=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:36 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:36 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 13/16] net/mlx5e: Report and recover from CQE with error
 on RQ
Thread-Topic: [net-next v2 13/16] net/mlx5e: Report and recover from CQE with
 error on RQ
Thread-Index: AQHVV5VI2ODg5B7bJUGaHqtVIZEohQ==
Date:   Tue, 20 Aug 2019 20:24:35 +0000
Message-ID: <20190820202352.2995-14-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0fb6d842-10e1-48d6-32dd-08d725ac6b0d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB26803BE8555F3593CA1CDC52BEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Dpxw/7Lx3IHhLtR+sgrxGb4yp19tV72Xo89CByfIo+m30hRu/DEm8RSf8z2/4/kO2vHq6YzAT71rSK4Cv15zs2eWyGTwGF7Xn9DAnvYSwKbLvh8nD1FI7D9jWOuulyjbDeqQkwi1UAeK5uLQuOZQKxixhKbYWxRY8q6WHzZkgQzXifo1HNCtaAmdZ2vi1JSy40VlMLYCv12Fo3M2XTY6+JDzluFYGwf1twQIltTEkdsQIwZQq8Hk42HjkFYBkEwINerIbW+A1hNEG/X3GdDN3GwfySWPzIvsfxPVtFqOTRWKFZOTAg7HvoqDBx1+2bOdW2CM5CYcUaI4VENylJF0Yu0Rfh78zY08i44tTT1gwrJ3j9afLyPIs8QRdbNEpCAUxEG3tjktALP0vW2uqnKJZVlWbb/P2QrUANCpBOkU0aA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fb6d842-10e1-48d6-32dd-08d725ac6b0d
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:35.8823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1w7Bnht6GZethRUI/tkPUTwapqq26XbuF4TiUdxjkn5/NHctkIA5iNIw0C1Pv5JnSq+pHlc4BGwyxtKG+gIAiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for report and recovery from error on completion on RQ by
setting the queue back to ready state. Handle only errors with a
syndrome indicating the RQ might enter error state and could be
recovered.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  3 +
 .../ethernet/mellanox/mlx5/core/en/health.h   |  9 +++
 .../mellanox/mlx5/core/en/reporter_rx.c       | 69 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  9 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 11 +++
 5 files changed, 101 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 842adf3719ff..7316571a4df5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -300,6 +300,7 @@ struct mlx5e_dcbx_dp {
=20
 enum {
 	MLX5E_RQ_STATE_ENABLED,
+	MLX5E_RQ_STATE_RECOVERING,
 	MLX5E_RQ_STATE_AM,
 	MLX5E_RQ_STATE_NO_CSUM_COMPLETE,
 	MLX5E_RQ_STATE_CSUM_FULL, /* cqe_csum_full hw bit is set */
@@ -672,6 +673,8 @@ struct mlx5e_rq {
 	struct zero_copy_allocator zca;
 	struct xdp_umem       *umem;
=20
+	struct work_struct     recover_work;
+
 	/* control */
 	struct mlx5_wq_ctrl    wq_ctrl;
 	__be32                 mkey_be;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index 52e9ca37cf46..d3693fa547ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -8,6 +8,14 @@
=20
 #define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND=
)
=20
+static inline bool cqe_syndrome_needs_recover(u8 syndrome)
+{
+	return syndrome =3D=3D MLX5_CQE_SYNDROME_LOCAL_LENGTH_ERR ||
+	       syndrome =3D=3D MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR ||
+	       syndrome =3D=3D MLX5_CQE_SYNDROME_LOCAL_PROT_ERR ||
+	       syndrome =3D=3D MLX5_CQE_SYNDROME_WR_FLUSH_ERR;
+}
+
 int mlx5e_reporter_tx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
@@ -21,6 +29,7 @@ int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg=
 *fmsg);
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
+void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq);
 void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
=20
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 05450df87554..b860569d4247 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -115,6 +115,75 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *=
icosq)
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
=20
+static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
+{
+	struct net_device *dev =3D rq->netdev;
+	int err;
+
+	err =3D mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
+		return err;
+	}
+	err =3D mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY)=
;
+	if (err) {
+		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
+		return err;
+	}
+
+	return 0;
+}
+
+static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
+{
+	struct mlx5_core_dev *mdev;
+	struct net_device *dev;
+	struct mlx5e_rq *rq;
+	u8 state;
+	int err;
+
+	rq =3D ctx;
+	mdev =3D rq->mdev;
+	dev =3D rq->netdev;
+	err =3D mlx5e_query_rq_state(mdev, rq->rqn, &state);
+	if (err) {
+		netdev_err(dev, "Failed to query RQ 0x%x state. err =3D %d\n",
+			   rq->rqn, err);
+		goto out;
+	}
+
+	if (state !=3D MLX5_RQC_STATE_ERR)
+		goto out;
+
+	mlx5e_deactivate_rq(rq);
+	mlx5e_free_rx_descs(rq);
+
+	err =3D mlx5e_rq_to_ready(rq, MLX5_RQC_STATE_ERR);
+	if (err)
+		goto out;
+
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
+	mlx5e_activate_rq(rq);
+	rq->stats->recover++;
+	return 0;
+out:
+	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
+	return err;
+}
+
+void mlx5e_reporter_rq_cqe_err(struct mlx5e_rq *rq)
+{
+	struct mlx5e_priv *priv =3D rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D rq;
+	err_ctx.recover =3D mlx5e_rx_reporter_err_rq_cqe_recover;
+	sprintf(err_str, "ERR CQE on RQ: 0x%x", rq->rqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
 static int mlx5e_rx_reporter_timeout_recover(void *ctx)
 {
 	struct mlx5e_icosq *icosq;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index 54f320391f63..7fdea6479ff6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -362,6 +362,13 @@ static void mlx5e_free_di_list(struct mlx5e_rq *rq)
 	kvfree(rq->wqe.di);
 }
=20
+static void mlx5e_rq_err_cqe_work(struct work_struct *recover_work)
+{
+	struct mlx5e_rq *rq =3D container_of(recover_work, struct mlx5e_rq, recov=
er_work);
+
+	mlx5e_reporter_rq_cqe_err(rq);
+}
+
 static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			  struct mlx5e_params *params,
 			  struct mlx5e_xsk_param *xsk,
@@ -398,6 +405,7 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->stats =3D &c->priv->channel_stats[c->ix].xskrq;
 	else
 		rq->stats =3D &c->priv->channel_stats[c->ix].rq;
+	INIT_WORK(&rq->recover_work, mlx5e_rq_err_cqe_work);
=20
 	rq->xdp_prog =3D params->xdp_prog ? bpf_prog_inc(params->xdp_prog) : NULL=
;
 	if (IS_ERR(rq->xdp_prog)) {
@@ -907,6 +915,7 @@ void mlx5e_close_rq(struct mlx5e_rq *rq)
 {
 	cancel_work_sync(&rq->dim.work);
 	cancel_work_sync(&rq->channel->icosq.recover_work);
+	cancel_work_sync(&rq->recover_work);
 	mlx5e_destroy_rq(rq);
 	mlx5e_free_rx_descs(rq);
 	mlx5e_free_rq(rq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 43d790b7d4ec..2fd2760d0bb7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1130,6 +1130,15 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, st=
ruct mlx5_cqe64 *cqe,
 	return skb;
 }
=20
+static void trigger_report(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
+{
+	struct mlx5_err_cqe *err_cqe =3D (struct mlx5_err_cqe *)cqe;
+
+	if (cqe_syndrome_needs_recover(err_cqe->syndrome) &&
+	    !test_and_set_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state))
+		queue_work(rq->channel->priv->wq, &rq->recover_work);
+}
+
 void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 {
 	struct mlx5_wq_cyc *wq =3D &rq->wqe.wq;
@@ -1143,6 +1152,7 @@ void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct =
mlx5_cqe64 *cqe)
 	cqe_bcnt =3D be32_to_cpu(cqe->byte_cnt);
=20
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		trigger_report(rq, cqe);
 		rq->stats->wqe_err++;
 		goto free_wqe;
 	}
@@ -1328,6 +1338,7 @@ void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, s=
truct mlx5_cqe64 *cqe)
 	wi->consumed_strides +=3D cstrides;
=20
 	if (unlikely(MLX5E_RX_ERR_CQE(cqe))) {
+		trigger_report(rq, cqe);
 		rq->stats->wqe_err++;
 		goto mpwrq_cqe_out;
 	}
--=20
2.21.0

