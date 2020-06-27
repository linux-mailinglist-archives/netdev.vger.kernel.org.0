Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36F1C20C43E
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 23:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgF0VSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 17:18:46 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:16519
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725912AbgF0VSq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 17:18:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AspD5riCKMJFyJ5Z4CkDMADxDKhy1rD30f+ngFjMIboI+eCj40jpk0+JC6AIla3AYkwAtD1Nmc8fptk7zD/iVnm27rumDOC7R7D2rSdOZ9sbnETJtfNzH/iqoyopxk/bs52I1eWSomENLSJs+UnHVB0bcIhAUFb6di++y5Da2KXGpGHMzRmJHdW94yERvPEB+z5RHoYiXexuxrtQkGzIBsaSwFwyUrEGOcv6Pnq5exiQ2YTZaZgA8w9bCrbin6M7elVAoFKbXpSONvw0kqJHjtLkyt6wMb82EHRT+GbVB+uXZEEK18L01pYLMa8XQoPQTq0jLNB2UbagsefxDypHcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgYhxh/c2KLaU7FwXqTLT6T3GOfNhEpIgRin46BOajU=;
 b=TXHQC6oe88+VIM8gTLouWKH2I12qG3n1tTt5YKlA2YMDOSQgXQZtVC3JxIJm7JLvR73rGmeyAnmfzxfYVT2C/4tkx9XTnk8gXFCFMp3o8M6pRh2lZcqc32remw66esqqiCOB3+2Ul3upmkge9pLpibQMX/ob/xrTD5ETybdO95xQ2DFmMRlKPOChxlNa2Cfe/Z2dl3WQqSdPERPU6fI29H/hS5kJ0DDB4DlcQNzQ6e4APa++nSFyPON7dzSpZzH19oVDMpnUqIqv5xK0gOsseBgAzdx0hvPHmiVqh8tsegwOe8kdqs5Avnwpe8MGm8R6HW4mPAYms7BhB3vBMz/lGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CgYhxh/c2KLaU7FwXqTLT6T3GOfNhEpIgRin46BOajU=;
 b=fIMxU/WouPZKloVy99g6dQY/QxN15sz/2i1MgHU6DGhpEqjblJu4/IGORYCBlj8lDgR0D0VKBGOQiwwzbay4Vc8EzYrJzJSTfxtT+bsk7qagv6CX62u78fDNoafJ5ZP3JyX+wvUerAvhauFE8uiGIyA0F1cVJnWGV9tgUBJ/S/U=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5134.eurprd05.prod.outlook.com (2603:10a6:803:ad::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Sat, 27 Jun
 2020 21:18:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.026; Sat, 27 Jun 2020
 21:18:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 01/15] net/mlx5e: Turn XSK ICOSQ into a general asynchronous one
Date:   Sat, 27 Jun 2020 14:17:13 -0700
Message-Id: <20200627211727.259569-2-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200627211727.259569-1-saeedm@mellanox.com>
References: <20200627211727.259569-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0017.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0017.namprd03.prod.outlook.com (2603:10b6:a03:1e0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21 via Frontend Transport; Sat, 27 Jun 2020 21:18:35 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe28a2c7-ece3-418d-42ab-08d81adfa7f0
X-MS-TrafficTypeDiagnostic: VI1PR05MB5134:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51347467F596DAB5E97285D5BE900@VI1PR05MB5134.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0447DB1C71
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QojwTwuhY6W72P0+COgLFfW+Z7AEDQ07f/54LDfwbCwcqxNQDxmE0xrh903YM0tPx+4+uQxU/TqSUud+dR/gDIkGtk1npiJZkXFAByUNc+oxSfro1KGf3gapaeIxiAeozHGVOBGR73IGO/LLvI/Ll3EmxZLVoIpUxwklsT8KtLMBq1eWwJkV6WTncjfAW23wLkNBYfDGbmTmyrjSQXF9ukrNQIDgboMPS+z3nG7cPyDE2WtofP2BQ9zs/WH8lbrRiK9rgV31+PQY3T8+GVWJ8J8bLJhaO7WD9le4Cqzlv7BADXKLjPzv7p8nsmBaF6OsqrhrQM0fpFpnKpa8bFRJ52YpHkVHWpDkN6oiB4oF/yau3VBQ3ELEYkSPGZlTneW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(39850400004)(346002)(396003)(66476007)(107886003)(54906003)(478600001)(30864003)(4326008)(316002)(6512007)(16526019)(6506007)(2616005)(1076003)(6486002)(956004)(6666004)(66556008)(8936002)(52116002)(86362001)(36756003)(5660300002)(66946007)(26005)(8676002)(83380400001)(2906002)(186003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: t6vwFmESaS2OviTeYrdI//JN++A15SGkMzS7cBcVkpLOM2L7eSd4GGcXC7TQ9JPlSrgIvgWMz8scb2fMuh89OhWRKKBJGXyduc6rv0RxP9RiZB9nPccxH+r9VJLZZusu3o5oHIrON126sniMJfCF2toB6Vl8+ilj75tmDrwLAHaTkfkzS0Rbf/duePPM1YGgEJEgQfx7JGLzFwcAp9a3hndD6ckyrySGuk83UfdA6hFUssM+P/CvWmbqWUiLdzSpmB2+a2WJGxdFDJHQbVs92iDqsExtImeGvPZM9OaroPze+vNC4L3DadxqhBAfovezCb7+FMyVTOGVvRDG6C6TDi9dQSy9pa1s8pr6zGNB1snpAJ6wefxYoRGskPwencYEdZ5L1unXAZApFNGqNDoTaXSiOPSc3+ufa2pUAAN8HT3BJlEDKeY+c5tCTr8AqYVKJ/Su1sG2MPnt8Gd1L/7R80pHKasqwp2LdYtfNR7JJrg=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe28a2c7-ece3-418d-42ab-08d81adfa7f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2020 21:18:37.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lYXucCAJv3XY6LlLrMTPn2u6CIrlluA7Vdg5ele+khCdhFdijo67PvDcmKN/EmPs5+JxQfzYqud76JpwgOVfEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5134
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
 .../mellanox/mlx5/core/en/xsk/setup.c         | 47 ++-----------------
 .../ethernet/mellanox/mlx5/core/en/xsk/tx.c   | 12 ++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 24 +++++++++-
 .../net/ethernet/mellanox/mlx5/core/en_txrx.c | 12 ++---
 5 files changed, 42 insertions(+), 61 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 842db20493df..29265ca6050c 100644
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
index 2c80205dc939..1eb817e62830 100644
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
 
@@ -148,32 +112,27 @@ void mlx5e_close_xsk(struct mlx5e_channel *c)
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
-	mlx5e_close_icosq(&c->xskicosq);
-	mlx5e_close_cq(&c->xskicosq.cq);
 	mlx5e_close_xdpsq(&c->xsksq);
 	mlx5e_close_cq(&c->xsksq.cq);
 
 	memset(&c->xskrq, 0, sizeof(c->xskrq));
 	memset(&c->xsksq, 0, sizeof(c->xsksq));
-	memset(&c->xskicosq, 0, sizeof(c->xskicosq));
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
index 83dce9cdb8c2..e0b3c61af93e 100644
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
index a836a02a2116..72ce5808d583 100644
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
index 8480278f2ee2..e3dbab2a294c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -149,17 +149,17 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	}
 
 	mlx5e_poll_ico_cq(&c->icosq.cq);
+	if (mlx5e_poll_ico_cq(&c->async_icosq.cq))
+		/* Don't clear the flag if nothing was polled to prevent
+		 * queueing more WQEs and overflowing the async ICOSQ.
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

