Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5120E8F432
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 21:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732820AbfHOTKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 15:10:41 -0400
Received: from mail-eopbgr00076.outbound.protection.outlook.com ([40.107.0.76]:17437
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729807AbfHOTKk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 15:10:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b02DXY/woeCj3/BP+QAfsQODfYNjD04cAspClfLWRaVptcd2SyQOrwFRb3zeqIj39IKIZWOf7poFy7LZq2+Ip+LdnD5riNd4E0SEBvLKQFQPfIJKu5kIGbjNx7NBQZ2GqHWo5krmMHrAWFJvo1NOAe6lzM4tU5ypVhmSj5Rwjr3SkZnXrPVrDa+sZSQ31McS33TaLwucE4wdJS8nqoBu1g0p28j4CpiFnvGN4KBTYUxCxY77rlZPun2SIS6Xv2MBt5+Ypx8U3uAoyTuzQNNnnjKK2vjW9OEjuLRXdKuT0PSdmnYrrwMC6mEar/amwOAXJvpZErMmRO5UlI38mGWLJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHkXyt9hsNC7rKCtJlxtztUK0qQEiJbi5p0Fp6xeoNM=;
 b=oFKWxou5Aj/uNB/tOqPkI7bl4PDffXd4lgoJY2N8LHAsUa6mxhcjA6RT+UqKMyuUDI+abb/iSg21pXnm4YjvsHJv3y1Oo87tAnLa9ofBvBddwYZDLDBAtZT1XWrxQfgFT1REOQ08WVSGoSqhpictOnMa0bQb9p+iwbRo8+YGGmNkDOPTYJewiNNr0CR3pqPiKOZvV1VNa/n4nFkn2fLRYejqxXTLa4isMI9JMv+JKpNVy05T1PoH5Aqm6tJqZR72r3f2A6k4Pw/7sse7rDe6T4XHlp+5qJBKC/sfyW+U08WIAM6pq3AsDhpzw1OJQz2I56kE6710XoWjECar9Ccagw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DHkXyt9hsNC7rKCtJlxtztUK0qQEiJbi5p0Fp6xeoNM=;
 b=cyYnoKbijKS6DI6TEH2FM3imyLEO9d1OUCrsx10RWyQtXR8g/30lgand8i0pFd7kAwwEQewkEbChGs9AriIdESpEPE4K/4KK0G6uyVoiRN+M/YNSt2YUQsfdAY3tDZGEozL4f+0EcqseCztKJWZ4gVuSHqGsQ7K+Vxj2iDifCJY=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2440.eurprd05.prod.outlook.com (10.168.71.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 19:10:08 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 19:10:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/16] net/mlx5e: Report and recover from rx timeout
Thread-Topic: [net-next 11/16] net/mlx5e: Report and recover from rx timeout
Thread-Index: AQHVU50NyidyRY4sLUKrDdfP0oBA5w==
Date:   Thu, 15 Aug 2019 19:10:07 +0000
Message-ID: <20190815190911.12050-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5b15f2ce-e848-4085-cd0c-08d721b42fd9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2440;
x-ms-traffictypediagnostic: DB6PR0501MB2440:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB24405890D9E74E49FBF4E98ABEAC0@DB6PR0501MB2440.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(199004)(189003)(6916009)(2616005)(36756003)(446003)(76176011)(186003)(11346002)(52116002)(305945005)(386003)(7736002)(478600001)(476003)(102836004)(6506007)(99286004)(486006)(14454004)(3846002)(6116002)(14444005)(8676002)(8936002)(5660300002)(81156014)(81166006)(66066001)(26005)(256004)(50226002)(6486002)(6436002)(107886003)(71200400001)(6512007)(54906003)(71190400001)(316002)(1076003)(2906002)(66446008)(53936002)(66946007)(66556008)(66476007)(64756008)(25786009)(86362001)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2440;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: jIU11hg9QYjJiAdI9ndMxf9f+BjiV+N9JLZ6BmrO2tYPDwt9tf45X/S4QcQ2HL9EgPzqmCsGgHsKPBc2rpkZaGx5YztYM/yqkxmYjY+NdLywy4s9b8F0FbP2STk93bbt+1Gdm5ZqX0h1lHyFIevRHMYr+Yv7MILz760psb1UTI/LQ33SR5NHcPx/8tmk29bB5B5u17BnoBEMND3xT84fi71Mq9/PHVrvX6XFiqtgm4XNN7+oZxU56Q54v7HJ3upNbWhSFTzi+hHJ+FjJ25nM5XtRYruVa+Wx0vfvDiW+ZX+ITXog41BQ73LDAW9nvpy5JG0FY2MLPhPxz0hi0b3GRKAmbKprWiMwlI0pu7Mbu5nmomti/ZQnuvU9ZCuxliwYE7L+/zux++BhG+VjFCkngQc0P7syzxAiDHEpMWjLtHU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b15f2ce-e848-4085-cd0c-08d721b42fd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 19:10:08.0025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kCvJH+o0JfZ+PXN2v5Ls4JZtoBmIsUi5n3ECHdwR1qy/HprnUhV7KF11NDccJ9pSYWvDjBm9bUoQ4FXqyjZZFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2440
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for report and recovery from rx timeout. On driver open we
post NOP work request on the rx channels to trigger napi in order to
fillup the rx rings. In case napi wasn't scheduled due to a lost
interrupt, perform EQ recovery.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en/health.h   |  1 +
 .../mellanox/mlx5/core/en/reporter_rx.c       | 29 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index 8acd9dc520cf..b4a2d9be17d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -19,6 +19,7 @@ int mlx5e_reporter_named_obj_nest_end(struct devlink_fmsg=
 *fmsg);
 int mlx5e_reporter_rx_create(struct mlx5e_priv *priv);
 void mlx5e_reporter_rx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *icosq);
+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq);
=20
 #define MLX5E_REPORTER_PER_Q_MAX_LEN 256
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 1eec17a36d00..4f5547ac4bee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -111,6 +111,35 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *=
icosq)
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
=20
+static int mlx5e_rx_reporter_timeout_recover(void *ctx)
+{
+	struct mlx5e_rq *rq =3D ctx;
+	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
+	struct mlx5_eq_comp *eq =3D rq->cq.mcq.eq;
+	int err;
+
+	err =3D mlx5e_health_channel_eq_recover(eq, rq->channel);
+	if (err)
+		clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
+
+	return err;
+}
+
+void mlx5e_reporter_rx_timeout(struct mlx5e_rq *rq)
+{
+	struct mlx5e_icosq *icosq =3D &rq->channel->icosq;
+	struct mlx5e_priv *priv =3D rq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {};
+
+	err_ctx.ctx =3D rq;
+	err_ctx.recover =3D mlx5e_rx_reporter_timeout_recover;
+	sprintf(err_str, "RX timeout on channel: %d, ICOSQ: 0x%x RQ: 0x%x, CQ: 0x=
%x\n",
+		icosq->channel->ix, icosq->sqn, rq->rqn, rq->cq.mcq.cqn);
+
+	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
+}
+
 static int mlx5e_rx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ct=
x)
 {
 	return err_ctx->recover(err_ctx->ctx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index db2bcc48cfcc..76845bafd708 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -808,6 +808,7 @@ int mlx5e_wait_for_min_rx_wqes(struct mlx5e_rq *rq, int=
 wait_time)
 	netdev_warn(c->netdev, "Failed to get min RX wqes on Channel[%d] RQN[0x%x=
] wq cur_sz(%d) min_rx_wqes(%d)\n",
 		    c->ix, rq->rqn, mlx5e_rqwq_get_cur_sz(rq), min_wqes);
=20
+	mlx5e_reporter_rx_timeout(rq);
 	return -ETIMEDOUT;
 }
=20
--=20
2.21.0

