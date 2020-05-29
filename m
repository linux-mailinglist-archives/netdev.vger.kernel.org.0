Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2437B1E8820
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 21:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbgE2TrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 15:47:16 -0400
Received: from mail-eopbgr20072.outbound.protection.outlook.com ([40.107.2.72]:57981
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726077AbgE2TrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 15:47:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4M61BHKe22IO2x+dQ9zTwJ7PUCWdHWC0mNPg8j+wxa6EORhbzP5nmvsRieUTE1o+WxwDR5K3OI3CxUBf3/qe1Yd/Y8OtaYx7+WxmosKSP/Pt4ZaPICkMD+xscqCPkT80VMcFmPDzN8g4NGHJGrR5jQjvpi6uDUFG5qZKWkyH7v/CcAxdDNhxSvDSH1veGmCBOms6f7mg3StGIa7iwdas1xsHScV/s7leyn9IdaA11h48l/RZMqz5cgFxvtVQwJiezlphGq4y/5Rc0BXNbocOkj18iTAFLTzD+79MvRmJA1f5nzcfs6ELjOsZpFHrG2vPJkPpBxWcP9zTxvEvN6pUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KmutmDuu+bJoQoIsb/Uqi8/1Ak/yV3x8jYShDGwk9A=;
 b=jG4QdU7L0AVlbjoWG54WHJh5IUTqehqGgLPozys284R8JnP/f0VH/RFFVsR/Y1O3Q7sIBEbGUHOuEthhiYaKK+blqBecNdzm5BVK58aqmmU0hqY4Egkba52Dkpfo1Q/mTPvnAlzrSl9IHxq3cWJUHANNY+wWN/nSLT4Dp5BBmZsi5qnsmedwnzAY/ZugvXpSw6RMpC+QeiCFv07JcmuiIKk9kdCAFBAU3kGu9lrwC5hyfyOU61xKWmvc705r0IGla05GIyfogDClXQrbb6KJksQbORrWevz0SJuh3R0PWPa6FNNGZtOSTwnRzeVrU5QdakdvzImPDRxa6aKYHLvEtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0KmutmDuu+bJoQoIsb/Uqi8/1Ak/yV3x8jYShDGwk9A=;
 b=q0PnHyWBLcush+61zZy5KIw+SCNwUHAXW51J5UrqdpXlUluPAQTTgPlinAhm5AXcW9zI+pS4Snl/87ie4qrWNZoE+hVRP93BZ7i+zjgaxJYGquX6Rri+U0BZBwlrm7/fd/PIMSkAOm4KRl9gQvfIkqlmMxyyZriK23D+XdFlc64=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6589.eurprd05.prod.outlook.com (2603:10a6:803:f7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.19; Fri, 29 May
 2020 19:47:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 19:47:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/11] net/mlx5e: Turn XSK ICOSQ into a general asynchronous one
Date:   Fri, 29 May 2020 12:46:32 -0700
Message-Id: <20200529194641.243989-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529194641.243989-1-saeedm@mellanox.com>
References: <20200529194641.243989-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR16CA0010.namprd16.prod.outlook.com (2603:10b6:a03:1a0::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 19:47:04 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 204ed659-c561-4358-632c-08d804091115
X-MS-TrafficTypeDiagnostic: VI1PR05MB6589:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB658954CC7BD4F7044B026209BE8F0@VI1PR05MB6589.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qw2zXQ6LBI1G+eufmY2FO3mm/1+8ob72v14EzcjkjiPCcdJtQIlPlO4Q1cmPZJEtiS4vZrHd9Yu3M769zj4lUQ4wROle/PBXRh9MCe/fSS7NSsq/dwAhVIxsNG8hmc+BF5HWHr55m1W1LIsYByWwJF6M2rmny6i2N2piD/nrE2Sva5K4X2nOC1YG7TQdVa13jMQnghtX8dgv9HjjGABvrtPVDaxqcbOVcn5fi6AQNL4H4ZclodnKyth9lPpvF5Pc5BNDXvvRc0seWik+68R8iMFg55mApmvJrY0VH7XNPab7fyd26YQnUo2Yc4zQrN/4NZxDseMzgZEHI9HQZSMwS005dmTqJA23OSFyEUepcKzGoYaF8P832QElbCQxaOow
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(376002)(39860400002)(136003)(366004)(6512007)(83380400001)(36756003)(186003)(4326008)(86362001)(8936002)(26005)(107886003)(16526019)(6506007)(316002)(52116002)(8676002)(2616005)(956004)(54906003)(6666004)(478600001)(66556008)(5660300002)(2906002)(6486002)(1076003)(30864003)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5l0jSPis/fty+A5f5xzptySMA2Xzc6J4JjryolDLACEPBsq4FdWhgfIdUKYm9Ms9Z+IMNcSQPX9y6DE/zC8+sFRMaGiZ7Rt8ZnwkY/bRVhxcFpGSbCqYA86tfPEo4VBQBbjvXbxcuskf2WWMEIdLAGPzZl0JEmgrOwRxjOMyJYV3xb7mK/4M+ZB6IQnuZMQutMUGVVCPiyoQIXrzmCsr2G1B/fQYtYWd2DbZIB2Ra+CvaOvya+wRWzp1WQn+JBaPfbLXVmiXOKiLP5fgMLVVlN2T/a/iXU0ybi4J6qMdtBKYT+m+mBVgbd+LoChahswr90vE5Y3d4mUGQSnbeoRJB7BRacf27gvjPpPAqokQfSTl21xQHPzgqblZjoWL323NpkK66SdCVXisBTYYgw+XaD4n1NaH0nLXgV8aFubXdbY3/JClORbOiuc6EnU7yqR3YLSLiV5S4Oj4AD3/OAQ/5ST6F778Al/Tj+XH7m1ggpc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204ed659-c561-4358-632c-08d804091115
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 19:47:06.3554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LcOdzuahtW7KEiR85QduWLaXPeQrfObaWtFun4eS3yONMq+cKzeBuJxvjY5xWjsqjJjcFrG0bBg3sypWxo+IUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6589
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

There is an upcoming demand (in downstream patches) for
an ICOSQ to be populated out of the NAPI context, asynchronously.

There is already an existing one serving XSK-related use case.
In this patch, promote this ICOSQ to serve as general async ICOSQ,
to be used for XSK and non-XSK flows.

As part of this, the reg_umr bit of the SQ context is now set
(if capable), as the general async ICOSQ should support possible
posts of UMR WQEs.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  8 ++--
 .../mellanox/mlx5/core/en/xsk/setup.c         | 46 ++-----------------
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   | 12 ++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 12 ++---
 5 files changed, 42 insertions(+), 60 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c5f8a3925b168..6937aaf24235b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -651,9 +651,11 @@ struct mlx5e_channel {
 	/* AF_XDP zero-copy */
 	struct mlx5e_rq            xskrq;
 	struct mlx5e_xdpsq         xsksq;
-	struct mlx5e_icosq         xskicosq;
-	/* xskicosq can be accessed from any CPU - the spinlock protects it. */
-	spinlock_t                 xskicosq_lock;
+
+	/* Async ICOSQ */
+	struct mlx5e_icosq         async_icosq;
+	/* async_icosq can be accessed from any CPU - the spinlock protects it. */
+	spinlock_t                 async_icosq_lock;
 
 	/* data path - accessed per napi poll */
 	struct irq_desc *irq_desc;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index c28cbae423310..8532e4302c9b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -34,31 +34,15 @@ bool mlx5e_validate_xsk_param(struct mlx5e_params *params,
 	}
 }
 
-static void mlx5e_build_xskicosq_param(struct mlx5e_priv *priv,
-				       u8 log_wq_size,
-				       struct mlx5e_sq_param *param)
-{
-	void *sqc = param->sqc;
-	void *wq = MLX5_ADDR_OF(sqc, sqc, wq);
-
-	mlx5e_build_sq_param_common(priv, param);
-
-	MLX5_SET(wq, wq, log_wq_sz, log_wq_size);
-}
-
 static void mlx5e_build_xsk_cparam(struct mlx5e_priv *priv,
 				   struct mlx5e_params *params,
 				   struct mlx5e_xsk_param *xsk,
 				   struct mlx5e_channel_param *cparam)
 {
-	const u8 xskicosq_size = MLX5E_PARAMS_MINIMUM_LOG_SQ_SIZE;
-
 	mlx5e_build_rq_param(priv, params, xsk, &cparam->rq);
 	mlx5e_build_xdpsq_param(priv, params, &cparam->xdp_sq);
-	mlx5e_build_xskicosq_param(priv, xskicosq_size, &cparam->icosq);
 	mlx5e_build_rx_cq_param(priv, params, xsk, &cparam->rx_cq);
 	mlx5e_build_tx_cq_param(priv, params, &cparam->tx_cq);
-	mlx5e_build_ico_cq_param(priv, xskicosq_size, &cparam->icosq_cq);
 }
 
 int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
@@ -66,7 +50,6 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 		   struct mlx5e_channel *c)
 {
 	struct mlx5e_channel_param *cparam;
-	struct dim_cq_moder icocq_moder = {};
 	int err;
 
 	if (!mlx5e_validate_xsk_param(params, xsk, priv->mdev))
@@ -100,31 +83,12 @@ int mlx5e_open_xsk(struct mlx5e_priv *priv, struct mlx5e_params *params,
 	if (unlikely(err))
 		goto err_close_tx_cq;
 
-	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->xskicosq.cq);
-	if (unlikely(err))
-		goto err_close_sq;
-
-	/* Create a dedicated SQ for posting NOPs whenever we need an IRQ to be
-	 * triggered and NAPI to be called on the correct CPU.
-	 */
-	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->xskicosq);
-	if (unlikely(err))
-		goto err_close_icocq;
-
 	kvfree(cparam);
 
-	spin_lock_init(&c->xskicosq_lock);
-
 	set_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 
 	return 0;
 
-err_close_icocq:
-	mlx5e_close_cq(&c->xskicosq.cq);
-
-err_close_sq:
-	mlx5e_close_xdpsq(&c->xsksq);
-
 err_close_tx_cq:
 	mlx5e_close_cq(&c->xsksq.cq);
 
@@ -148,28 +112,24 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
-	mlx5e_close_icosq(&c->xskicosq);
-	mlx5e_close_cq(&c->xskicosq.cq);
 	mlx5e_close_xdpsq(&c->xsksq);
 	mlx5e_close_cq(&c->xsksq.cq);
 }
 
 void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
-	mlx5e_activate_icosq(&c->xskicosq);
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	/* TX queue is created active. */
 
-	spin_lock(&c->xskicosq_lock);
-	mlx5e_trigger_irq(&c->xskicosq);
-	spin_unlock(&c->xskicosq_lock);
+	spin_lock(&c->async_icosq_lock);
+	mlx5e_trigger_irq(&c->async_icosq);
+	spin_unlock(&c->async_icosq_lock);
 }
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
 {
 	mlx5e_deactivate_rq(&c->xskrq);
 	/* TX queue is disabled on close. */
-	mlx5e_deactivate_icosq(&c->xskicosq);
 }
 
 static int mlx5e_redirect_xsk_rqt(struct mlx5e_priv *priv, u16 ix, u32 rqn)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
index 83dce9cdb8c2f..e0b3c61af93ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/tx.c
@@ -26,19 +26,19 @@ int mlx5e_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags)
 		return -ENXIO;
 
 	if (!napi_if_scheduled_mark_missed(&c->napi)) {
-		/* To avoid WQE overrun, don't post a NOP if XSKICOSQ is not
+		/* To avoid WQE overrun, don't post a NOP if async_icosq is not
 		 * active and not polled by NAPI. Return 0, because the upcoming
 		 * activate will trigger the IRQ for us.
 		 */
-		if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &c->xskicosq.state)))
+		if (unlikely(!test_bit(MLX5E_SQ_STATE_ENABLED, &c->async_icosq.state)))
 			return 0;
 
-		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state))
+		if (test_and_set_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state))
 			return 0;
 
-		spin_lock(&c->xskicosq_lock);
-		mlx5e_trigger_irq(&c->xskicosq);
-		spin_unlock(&c->xskicosq_lock);
+		spin_lock(&c->async_icosq_lock);
+		mlx5e_trigger_irq(&c->async_icosq);
+		spin_unlock(&c->async_icosq_lock);
 	}
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 2c36a04181b84..db18f602cdb2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1817,10 +1817,14 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 	struct dim_cq_moder icocq_moder = {0, 0};
 	int err;
 
-	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->icosq.cq);
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->async_icosq.cq);
 	if (err)
 		return err;
 
+	err = mlx5e_open_cq(c, icocq_moder, &cparam->icosq_cq, &c->icosq.cq);
+	if (err)
+		goto err_close_async_icosq_cq;
+
 	err = mlx5e_open_tx_cqs(c, params, cparam);
 	if (err)
 		goto err_close_icosq_cq;
@@ -1841,10 +1845,16 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 
 	napi_enable(&c->napi);
 
-	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq);
+	spin_lock_init(&c->async_icosq_lock);
+
+	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->async_icosq);
 	if (err)
 		goto err_disable_napi;
 
+	err = mlx5e_open_icosq(c, params, &cparam->icosq, &c->icosq);
+	if (err)
+		goto err_close_async_icosq;
+
 	err = mlx5e_open_sqs(c, params, cparam);
 	if (err)
 		goto err_close_icosq;
@@ -1879,6 +1889,9 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 err_close_icosq:
 	mlx5e_close_icosq(&c->icosq);
 
+err_close_async_icosq:
+	mlx5e_close_icosq(&c->async_icosq);
+
 err_disable_napi:
 	napi_disable(&c->napi);
 
@@ -1897,6 +1910,9 @@ static int mlx5e_open_queues(struct mlx5e_channel *c,
 err_close_icosq_cq:
 	mlx5e_close_cq(&c->icosq.cq);
 
+err_close_async_icosq_cq:
+	mlx5e_close_cq(&c->async_icosq.cq);
+
 	return err;
 }
 
@@ -1908,6 +1924,7 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 		mlx5e_close_xdpsq(&c->rq_xdpsq);
 	mlx5e_close_sqs(c);
 	mlx5e_close_icosq(&c->icosq);
+	mlx5e_close_icosq(&c->async_icosq);
 	napi_disable(&c->napi);
 	if (c->xdp)
 		mlx5e_close_cq(&c->rq_xdpsq.cq);
@@ -1915,6 +1932,7 @@ static void mlx5e_close_queues(struct mlx5e_channel *c)
 	mlx5e_close_cq(&c->xdpsq.cq);
 	mlx5e_close_tx_cqs(c);
 	mlx5e_close_cq(&c->icosq.cq);
+	mlx5e_close_cq(&c->async_icosq.cq);
 }
 
 static u8 mlx5e_enumerate_lag_port(struct mlx5_core_dev *mdev, int ix)
@@ -1995,6 +2013,7 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_activate_txqsq(&c->sq[tc]);
 	mlx5e_activate_icosq(&c->icosq);
+	mlx5e_activate_icosq(&c->async_icosq);
 	mlx5e_activate_rq(&c->rq);
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
@@ -2009,6 +2028,7 @@ static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
 		mlx5e_deactivate_xsk(c);
 
 	mlx5e_deactivate_rq(&c->rq);
+	mlx5e_deactivate_icosq(&c->async_icosq);
 	mlx5e_deactivate_icosq(&c->icosq);
 	for (tc = 0; tc < c->num_tc; tc++)
 		mlx5e_deactivate_txqsq(&c->sq[tc]);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 8480278f2ee20..ad99f270efb5e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -149,17 +149,17 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	}
 
 	mlx5e_poll_ico_cq(&c->icosq.cq);
+	if (mlx5e_poll_ico_cq(&c->async_icosq.cq))
+		/* Don't clear the flag if nothing was polled to prevent
+		 * queueing more WQEs and overflowing XSKICOSQ.
+		 */
+		clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->async_icosq.state);
 
 	busy |= INDIRECT_CALL_2(rq->post_wqes,
 				mlx5e_post_rx_mpwqes,
 				mlx5e_post_rx_wqes,
 				rq);
 	if (xsk_open) {
-		if (mlx5e_poll_ico_cq(&c->xskicosq.cq))
-			/* Don't clear the flag if nothing was polled to prevent
-			 * queueing more WQEs and overflowing XSKICOSQ.
-			 */
-			clear_bit(MLX5E_SQ_STATE_PENDING_XSK_TX, &c->xskicosq.state);
 		busy |= mlx5e_poll_xdpsq_cq(&xsksq->cq);
 		busy_xsk |= mlx5e_napi_xsk_post(xsksq, xskrq);
 	}
@@ -189,11 +189,11 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 
 	mlx5e_cq_arm(&rq->cq);
 	mlx5e_cq_arm(&c->icosq.cq);
+	mlx5e_cq_arm(&c->async_icosq.cq);
 	mlx5e_cq_arm(&c->xdpsq.cq);
 
 	if (xsk_open) {
 		mlx5e_handle_rx_dim(xskrq);
-		mlx5e_cq_arm(&c->xskicosq.cq);
 		mlx5e_cq_arm(&xsksq->cq);
 		mlx5e_cq_arm(&xskrq->cq);
 	}
-- 
2.26.2

