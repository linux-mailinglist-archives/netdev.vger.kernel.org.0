Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49E896A49
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfHTUYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:24:49 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731052AbfHTUYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nBAt33zTkZOOizs93nPsaEoh6A0g+CzwBidWVvfkMkCm6cYmDn9CzYXEnJkqwfLLLqj80n9AK/WBWtXdYIbaPwcXUlHunwzEkbSWQB/Uk2Kb30i74w3W66yD0CdrddokgFqLzuNZDUFL7Cu6CQk4LpGsdsjjzTrtF1tzzWHAEXlED8pmlBHcMOIY7QpdRoP7dtyc15d6eyMhP2Y+op3+HZTKgHiJj1Ldoevv1b0vnYDYsd7O1ZW7ULU5/W2fdkJufjiitleLCQfD7WlbY6bzLCdTsWNhZwTPqS5d8YDsHtuVoFyfDZ77n+yihWTGvIVf/WEYIJAEPFeXp6FkAVmntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uERuSavF3Wru3+lhhHiznTgE9wuAPHaK6Oy3VnOGUY=;
 b=Hy593dMFegK/uv+jpVFSo+AFgY5PL4nBUcOShY160u5LoOUJViLR2lIQNhzfx9JD+JPuSdH976ylMxgoABmW8IZLVKHn5eTLaw3Y+QWud45tSgKAXbIrWMPVvCMXYQ6y7rGMeQNThAKX93MOy2sHJdt7VxGN+lg0c4xOtciOCUww1jDuX1jAqIYFixLQG4ecJ4Pqw9O71JH6z/yG+j76n4yL9IvATNmVatAnpsp+CAy+eXvFjR/EDIcHDxiyoyDEPdOY9MYUvSUmT/0Bred56EIlnZ/tZ9MrNBHPpsmFkL0KRzFBbLQZ+v9WDacp9IiWwwdKQVPl9HECKzkDthZM5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uERuSavF3Wru3+lhhHiznTgE9wuAPHaK6Oy3VnOGUY=;
 b=auT6p6qzQlK17U2obzuKwskbwJy6+NlwqL0ofaQxyMgzaBeXBp5HseV1uF95cHz+EKv8xUGFOPQvJ7J9uxE8qhlr2mqgWjjpwBt8wLJmYuuXzSN9n2MpHj+Fe5GrlRa0gYTmdT4OL3juS9BWhZlQMeHAR2SKG3BrRiPasdlSVKU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:32 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 11/16] net/mlx5e: Report and recover from rx timeout
Thread-Topic: [net-next v2 11/16] net/mlx5e: Report and recover from rx
 timeout
Thread-Index: AQHVV5VGupqIgj2nnE65VH50fpRhuw==
Date:   Tue, 20 Aug 2019 20:24:32 +0000
Message-ID: <20190820202352.2995-12-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 328879ca-ef2d-4e2d-73b5-08d725ac68d4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB2680183FB67760C715698DF7BEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SOun6cTHx66SzUd8zPB3wCqJUefN/STNZGAkK199cF25LNqHNwS+51A6BWiK0XflKrlKrPYaInP0clqt7A3LO+VdwfXLsJeHj/1UKCf3cZP+OHlNJvcaltxki6f/93UE2Q1QwDTpG7hicIQGTU4HI2rt5LnlOEh462sUCSUK+rKNDsBXUAdi1JPX4AclSx08530bAqDenXkoPJJ1WiKAMDLSgZDAX9a3Ypr2aB9OEDisJ9sf7iaDstrzezBELj4Im5j8J5B0A5zU1OISQeaeOgzpTbaJWfGqLOKUmyR7hr+XUDYLlaupxABimEQy1tD7cACiasCGJWKtrSuw6+3JvIeQk1rL2TpPVEX4fYUqw5OoPZc15ug9eaKXTNAERuuOEockNnlrkf/nnzWDLZyv8xuGNmROZWPmkyUZ0iuklaA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 328879ca-ef2d-4e2d-73b5-08d725ac68d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:32.1190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kg7vAou7iY1lfpdM17+57hX1aOzzbUwEABZCkjIXk/gmg5F2YpjRWKecJpnfTS4K0T3urSGbFAmnZITRt7Kq3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
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
 .../mellanox/mlx5/core/en/reporter_rx.c       | 32 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 3 files changed, 34 insertions(+)

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
index ff49853b65d2..05450df87554 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -115,6 +115,38 @@ void mlx5e_reporter_icosq_cqe_err(struct mlx5e_icosq *=
icosq)
 	mlx5e_health_report(priv, priv->rx_reporter, err_str, &err_ctx);
 }
=20
+static int mlx5e_rx_reporter_timeout_recover(void *ctx)
+{
+	struct mlx5e_icosq *icosq;
+	struct mlx5_eq_comp *eq;
+	struct mlx5e_rq *rq;
+	int err;
+
+	rq =3D ctx;
+	icosq =3D &rq->channel->icosq;
+	eq =3D rq->cq.mcq.eq;
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
index 0e43ea1c27b0..54f320391f63 100644
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

