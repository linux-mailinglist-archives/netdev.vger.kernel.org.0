Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA4C696A6C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730937AbfHTU0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 16:26:00 -0400
Received: from mail-eopbgr50051.outbound.protection.outlook.com ([40.107.5.51]:14918
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730845AbfHTUY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSo4BNjlgRAqm1+iGVdQTDVxXoLEj/NqSFrqu5WGGoWTF5Uf1x6om1J3kI+pxnYZ3k641ZfXowENAtC4X7yZwTgNKD7N7qLwichZn3rtu4Kj2eFsOihB4IWWOB1GW345uXZIIpaFSkt08o6UaVdfxaWCfI85d6DwOjPo6pbRSg2TqAnzge1LVVomy9i1yFsDNo5kQ3ometKDZ77ZOFognJskxGlruQEwLoqADyyarhnxjkXjJdSLFpBsP9YXwtctk9QkM4Owp5JNrLUlAcWlmjqJMITY5xI7VUF09Vmsf004FqyFG5Luv8nb07D/2t55KO5nJ6GUo8Phn6Ff9rPf7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUm/heiEvDlBBtzcaWlXKXusiJL9wln28zzuovErXYk=;
 b=ao/8vaj6kP6sv7Moj60tv/03sN+0CxWWRyhkXMASK7jH8pm4GP7s+3xxqmnX5XgCpzB7BuHJD4WB4zbMnMSJr3B++yNBKDEyUii+XAxiiCKzqQkUpTnjampXWnZzwM1SmgIM5c6d2mME477pbYyh2YaWINVeWO5x+/3oU1+lRwDUKN2xbpBqHGni+l9bUC0aVKpyfhxb76dgxEvSlHixZCjbcDgB65teolw7eDQT67el2LUXKJhI8NfFv5fpfDuHCvd2j1Fk94aqQlzNxFB7OrnbAbibrV1XHZt4o4oyvlUW3eKMhDgbB64nHOjjAIj+WeGwvvHItrpLcJk4E0fGTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FUm/heiEvDlBBtzcaWlXKXusiJL9wln28zzuovErXYk=;
 b=U8hrOjLgBRv0he+ek2noiiXG1BpIhTG5yPSc3hYaCslRxlHMTfD5C95UXQv9qPN1NNnrweL45XlxUDtfWoVyy9vsKXcxLsOabdZl4sxRznbBayeJL0Xs48JvTRRynWkE14RbhJjUz8xwuSu6Owd5TBzg15wpehenQEq3Fx0wgvk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2680.eurprd05.prod.outlook.com (10.172.226.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Tue, 20 Aug 2019 20:24:16 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.018; Tue, 20 Aug 2019
 20:24:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 03/16] net/mlx5e: Generalize tx reporter's functionality
Thread-Topic: [net-next v2 03/16] net/mlx5e: Generalize tx reporter's
 functionality
Thread-Index: AQHVV5U9XvjZoo0mlU2sny2fkU8DQA==
Date:   Tue, 20 Aug 2019 20:24:16 +0000
Message-ID: <20190820202352.2995-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 889df8d7-bad4-45e5-6e2f-08d725ac5f82
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2680;
x-ms-traffictypediagnostic: DB6PR0501MB2680:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB26806B1DD9FB965B385CD113BEAB0@DB6PR0501MB2680.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 013568035E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(199004)(189003)(51234002)(446003)(11346002)(486006)(86362001)(476003)(8676002)(14454004)(81156014)(8936002)(25786009)(26005)(6486002)(102836004)(386003)(53936002)(6506007)(5660300002)(36756003)(6436002)(478600001)(7736002)(186003)(52116002)(99286004)(76176011)(6512007)(81166006)(66066001)(2906002)(2616005)(50226002)(4326008)(14444005)(1076003)(64756008)(66556008)(256004)(66446008)(6116002)(66946007)(3846002)(6916009)(66476007)(30864003)(316002)(71190400001)(71200400001)(107886003)(305945005)(54906003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2680;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0UqwcU7/4ZHPrCWKHtJMZkGaiy4DStM9Yam9GScYhtLamwTmMLI9f8heHFqjFBmkT9LE6HSbJ/JKIv4Lk9/2K6YreyGsDYKT1nKW8rQ/QeSU4sf9x4Cq8+m3AJkZY5NZgZP4TzuqFrzABsrRFCKea4dbKGi+kiRMzzTONneQs9jXdTI5I+MVQribqrj65F/IWvDWObvIfl0aCDfTgiFEEsEn8mZPqrhF4nor2lnAxqQl56JBh5ybdVP2M/UGZ/tePMJjhmW2s/qyRa+XtTD3On4eA/clqBcb7qrKGHQA6tKmAy6DUxl9Rs7kEfYTnndauPWTa8pOJQlJ4NuML7CCOixxtvzZLZNMmBUEPVbx2ZswWwpnx+bVjlYps4gW2ijkW72AAkAFKAZg7RsjNnpOp3N3wbPwiVXe5rn8prlyAMA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 889df8d7-bad4-45e5-6e2f-08d725ac5f82
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2019 20:24:16.5789
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9KL9I+U/JF5yb6nTrZkwJn3yYM8y12q1u8ZoucwdHBuD8FhYfi7t43xoYfri6IXFW9GGKFuGA8ggcYHA2sAmag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2680
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Prepare for code sharing with rx reporter, which is added in the
following patches in the set. Introduce a generic error_ctx for
agnostic recovery despatch.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   5 +-
 .../ethernet/mellanox/mlx5/core/en/health.c   |  82 ++++++++++
 .../ethernet/mellanox/mlx5/core/en/health.h   |  14 ++
 .../mellanox/mlx5/core/en/reporter_tx.c       | 140 +++++-------------
 4 files changed, 137 insertions(+), 104 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/health.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Makefile b/drivers/net=
/ethernet/mellanox/mlx5/core/Makefile
index 57d2cc666fe3..23d566a45a30 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Makefile
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Makefile
@@ -23,8 +23,9 @@ mlx5_core-y :=3D	main.o cmd.o debugfs.o fw.o eq.o uar.o p=
agealloc.o \
 #
 mlx5_core-$(CONFIG_MLX5_CORE_EN) +=3D en_main.o en_common.o en_fs.o en_eth=
tool.o \
 		en_tx.o en_rx.o en_dim.o en_txrx.o en/xdp.o en_stats.o \
-		en_selftest.o en/port.o en/monitor_stats.o en/reporter_tx.o \
-		en/params.o en/xsk/umem.o en/xsk/setup.o en/xsk/rx.o en/xsk/tx.o
+		en_selftest.o en/port.o en/monitor_stats.o en/health.o \
+		en/reporter_tx.o en/params.o en/xsk/umem.o en/xsk/setup.o \
+		en/xsk/rx.o en/xsk/tx.o
=20
 #
 # Netdev extra
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.c
new file mode 100644
index 000000000000..fc3112921bd3
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+// Copyright (c) 2019 Mellanox Technologies.
+
+#include "health.h"
+#include "lib/eq.h"
+
+int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn)
+{
+	struct mlx5_core_dev *mdev =3D channel->mdev;
+	struct net_device *dev =3D channel->netdev;
+	struct mlx5e_modify_sq_param msp =3D {};
+	int err;
+
+	msp.curr_state =3D MLX5_SQC_STATE_ERR;
+	msp.next_state =3D MLX5_SQC_STATE_RST;
+
+	err =3D mlx5e_modify_sq(mdev, sqn, &msp);
+	if (err) {
+		netdev_err(dev, "Failed to move sq 0x%x to reset\n", sqn);
+		return err;
+	}
+
+	memset(&msp, 0, sizeof(msp));
+	msp.curr_state =3D MLX5_SQC_STATE_RST;
+	msp.next_state =3D MLX5_SQC_STATE_RDY;
+
+	err =3D mlx5e_modify_sq(mdev, sqn, &msp);
+	if (err) {
+		netdev_err(dev, "Failed to move sq 0x%x to ready\n", sqn);
+		return err;
+	}
+
+	return 0;
+}
+
+int mlx5e_health_recover_channels(struct mlx5e_priv *priv)
+{
+	int err =3D 0;
+
+	rtnl_lock();
+	mutex_lock(&priv->state_lock);
+
+	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
+		goto out;
+
+	err =3D mlx5e_safe_reopen_channels(priv);
+
+out:
+	mutex_unlock(&priv->state_lock);
+	rtnl_unlock();
+
+	return err;
+}
+
+int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_=
channel *channel)
+{
+	u32 eqe_count;
+
+	netdev_err(channel->netdev, "EQ 0x%x: Cons =3D 0x%x, irqn =3D 0x%x\n",
+		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
+
+	eqe_count =3D mlx5_eq_poll_irq_disabled(eq);
+	if (!eqe_count)
+		return -EIO;
+
+	netdev_err(channel->netdev, "Recovered %d eqes on EQ 0x%x\n",
+		   eqe_count, eq->core.eqn);
+
+	channel->stats->eq_rearm++;
+	return 0;
+}
+
+int mlx5e_health_report(struct mlx5e_priv *priv,
+			struct devlink_health_reporter *reporter, char *err_str,
+			struct mlx5e_err_ctx *err_ctx)
+{
+	if (!reporter) {
+		netdev_err(priv->netdev, err_str);
+		return err_ctx->recover(&err_ctx->ctx);
+	}
+	return devlink_health_report(reporter, err_str, err_ctx);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index c7a5a149011e..386bda6104aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -11,4 +11,18 @@ void mlx5e_reporter_tx_destroy(struct mlx5e_priv *priv);
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq);
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq);
=20
+#define MLX5E_REPORTER_PER_Q_MAX_LEN 256
+
+struct mlx5e_err_ctx {
+	int (*recover)(void *ctx);
+	void *ctx;
+};
+
+int mlx5e_health_sq_to_ready(struct mlx5e_channel *channel, u32 sqn);
+int mlx5e_health_channel_eq_recover(struct mlx5_eq_comp *eq, struct mlx5e_=
channel *channel);
+int mlx5e_health_recover_channels(struct mlx5e_priv *priv);
+int mlx5e_health_report(struct mlx5e_priv *priv,
+			struct devlink_health_reporter *reporter, char *err_str,
+			struct mlx5e_err_ctx *err_ctx);
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 62b95f62e4dc..6f9f42ab3005 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -2,14 +2,6 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
 #include "health.h"
-#include "lib/eq.h"
-
-#define MLX5E_TX_REPORTER_PER_SQ_MAX_LEN 256
-
-struct mlx5e_tx_err_ctx {
-	int (*recover)(struct mlx5e_txqsq *sq);
-	struct mlx5e_txqsq *sq;
-};
=20
 static int mlx5e_wait_for_sq_flush(struct mlx5e_txqsq *sq)
 {
@@ -39,41 +31,20 @@ static void mlx5e_reset_txqsq_cc_pc(struct mlx5e_txqsq =
*sq)
 	sq->pc =3D 0;
 }
=20
-static int mlx5e_sq_to_ready(struct mlx5e_txqsq *sq, int curr_state)
+static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 {
-	struct mlx5_core_dev *mdev =3D sq->channel->mdev;
-	struct net_device *dev =3D sq->channel->netdev;
-	struct mlx5e_modify_sq_param msp =3D {0};
+	struct mlx5_core_dev *mdev;
+	struct net_device *dev;
+	struct mlx5e_txqsq *sq;
+	u8 state;
 	int err;
=20
-	msp.curr_state =3D curr_state;
-	msp.next_state =3D MLX5_SQC_STATE_RST;
-
-	err =3D mlx5e_modify_sq(mdev, sq->sqn, &msp);
-	if (err) {
-		netdev_err(dev, "Failed to move sq 0x%x to reset\n", sq->sqn);
-		return err;
-	}
-
-	memset(&msp, 0, sizeof(msp));
-	msp.curr_state =3D MLX5_SQC_STATE_RST;
-	msp.next_state =3D MLX5_SQC_STATE_RDY;
-
-	err =3D mlx5e_modify_sq(mdev, sq->sqn, &msp);
-	if (err) {
-		netdev_err(dev, "Failed to move sq 0x%x to ready\n", sq->sqn);
-		return err;
-	}
-
-	return 0;
-}
+	sq =3D ctx;
+	mdev =3D sq->channel->mdev;
+	dev =3D sq->channel->netdev;
=20
-static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e_txqsq *sq)
-{
-	struct mlx5_core_dev *mdev =3D sq->channel->mdev;
-	struct net_device *dev =3D sq->channel->netdev;
-	u8 state;
-	int err;
+	if (!test_bit(MLX5E_SQ_STATE_RECOVERING, &sq->state))
+		return 0;
=20
 	err =3D mlx5_core_query_sq_state(mdev, sq->sqn, &state);
 	if (err) {
@@ -96,7 +67,7 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct mlx5e=
_txqsq *sq)
 	 * pending WQEs. SQ can safely reset the SQ.
 	 */
=20
-	err =3D mlx5e_sq_to_ready(sq, state);
+	err =3D mlx5e_health_sq_to_ready(sq->channel, sq->sqn);
 	if (err)
 		goto out;
=20
@@ -111,102 +82,66 @@ static int mlx5e_tx_reporter_err_cqe_recover(struct m=
lx5e_txqsq *sq)
 	return err;
 }
=20
-static int mlx5_tx_health_report(struct devlink_health_reporter *tx_report=
er,
-				 char *err_str,
-				 struct mlx5e_tx_err_ctx *err_ctx)
-{
-	if (!tx_reporter) {
-		netdev_err(err_ctx->sq->channel->netdev, err_str);
-		return err_ctx->recover(err_ctx->sq);
-	}
-
-	return devlink_health_report(tx_reporter, err_str, err_ctx);
-}
-
 void mlx5e_reporter_tx_err_cqe(struct mlx5e_txqsq *sq)
 {
-	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
-	struct mlx5e_tx_err_ctx err_ctx =3D {0};
+	struct mlx5e_priv *priv =3D sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx =3D {0};
=20
-	err_ctx.sq       =3D sq;
-	err_ctx.recover  =3D mlx5e_tx_reporter_err_cqe_recover;
+	err_ctx.ctx =3D sq;
+	err_ctx.recover =3D mlx5e_tx_reporter_err_cqe_recover;
 	sprintf(err_str, "ERR CQE on SQ: 0x%x", sq->sqn);
=20
-	mlx5_tx_health_report(sq->channel->priv->tx_reporter, err_str,
-			      &err_ctx);
+	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
=20
-static int mlx5e_tx_reporter_timeout_recover(struct mlx5e_txqsq *sq)
+static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 {
-	struct mlx5_eq_comp *eq =3D sq->cq.mcq.eq;
-	u32 eqe_count;
-
-	netdev_err(sq->channel->netdev, "EQ 0x%x: Cons =3D 0x%x, irqn =3D 0x%x\n"=
,
-		   eq->core.eqn, eq->core.cons_index, eq->core.irqn);
+	struct mlx5_eq_comp *eq;
+	struct mlx5e_txqsq *sq;
+	int err;
=20
-	eqe_count =3D mlx5_eq_poll_irq_disabled(eq);
-	if (!eqe_count) {
+	sq =3D ctx;
+	eq =3D sq->cq.mcq.eq;
+	err =3D mlx5e_health_channel_eq_recover(eq, sq->channel);
+	if (err)
 		clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-		return -EIO;
-	}
=20
-	netdev_err(sq->channel->netdev, "Recover %d eqes on EQ 0x%x\n",
-		   eqe_count, eq->core.eqn);
-	sq->channel->stats->eq_rearm++;
-	return 0;
+	return err;
 }
=20
 int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
-	char err_str[MLX5E_TX_REPORTER_PER_SQ_MAX_LEN];
-	struct mlx5e_tx_err_ctx err_ctx;
+	struct mlx5e_priv *priv =3D sq->channel->priv;
+	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_err_ctx err_ctx;
=20
-	err_ctx.sq       =3D sq;
-	err_ctx.recover  =3D mlx5e_tx_reporter_timeout_recover;
+	err_ctx.ctx =3D sq;
+	err_ctx.recover =3D mlx5e_tx_reporter_timeout_recover;
 	sprintf(err_str,
 		"TX timeout on queue: %d, SQ: 0x%x, CQ: 0x%x, SQ Cons: 0x%x SQ Prod: 0x%=
x, usecs since last trans: %u\n",
 		sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
 		jiffies_to_usecs(jiffies - sq->txq->trans_start));
=20
-	return mlx5_tx_health_report(sq->channel->priv->tx_reporter, err_str,
-				     &err_ctx);
+	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
 }
=20
 /* state lock cannot be grabbed within this function.
  * It can cause a dead lock or a read-after-free.
  */
-static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_tx_err_ctx *err=
_ctx)
-{
-	return err_ctx->recover(err_ctx->sq);
-}
-
-static int mlx5e_tx_reporter_recover_all(struct mlx5e_priv *priv)
+static int mlx5e_tx_reporter_recover_from_ctx(struct mlx5e_err_ctx *err_ct=
x)
 {
-	int err =3D 0;
-
-	rtnl_lock();
-	mutex_lock(&priv->state_lock);
-
-	if (!test_bit(MLX5E_STATE_OPENED, &priv->state))
-		goto out;
-
-	err =3D mlx5e_safe_reopen_channels(priv);
-
-out:
-	mutex_unlock(&priv->state_lock);
-	rtnl_unlock();
-
-	return err;
+	return err_ctx->recover(err_ctx->ctx);
 }
=20
 static int mlx5e_tx_reporter_recover(struct devlink_health_reporter *repor=
ter,
 				     void *context)
 {
 	struct mlx5e_priv *priv =3D devlink_health_reporter_priv(reporter);
-	struct mlx5e_tx_err_ctx *err_ctx =3D context;
+	struct mlx5e_err_ctx *err_ctx =3D context;
=20
 	return err_ctx ? mlx5e_tx_reporter_recover_from_ctx(err_ctx) :
-			 mlx5e_tx_reporter_recover_all(priv);
+			 mlx5e_health_recover_channels(priv);
 }
=20
 static int
@@ -289,8 +224,9 @@ int mlx5e_reporter_tx_create(struct mlx5e_priv *priv)
 {
 	struct devlink_health_reporter *reporter;
 	struct mlx5_core_dev *mdev =3D priv->mdev;
-	struct devlink *devlink =3D priv_to_devlink(mdev);
+	struct devlink *devlink;
=20
+	devlink =3D priv_to_devlink(mdev);
 	reporter =3D
 		devlink_health_reporter_create(devlink, &mlx5_tx_reporter_ops,
 					       MLX5_REPORTER_TX_GRACEFUL_PERIOD,
--=20
2.21.0

