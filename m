Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB6021329E
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgGCEKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:10:03 -0400
Received: from mail-eopbgr80059.outbound.protection.outlook.com ([40.107.8.59]:59118
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725960AbgGCEKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:10:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PO+CpIULh41t+XYOLjnW105XYDqvrh2uwb1ioJ6aGPzkblEK1OHiKQkuKWwLBgfzaIkGT1bC3LnrGXw5qQM3mEK5QE7g8S7mQ7CvJf7ACa0iBiunMwD8RJk/2zhemKqKYXYFaoJtOh9Puj5nz1H65TgPvRlRDnuWuqBWUF0vesnBo5MvzLWCyH+2rbWWB2w0LMj8ba5WST3SkqkMeovK4TACeZ8LKcmg3bqTWeFpcKpv0BJS/VF5NKVklgSy+PNWI0J8FXuE0VFPNpZdMgdB93LLaFuKev9DuJbv6a66qelq90cdovv3tDogE56+A9rDT7ShwICI9zqTGqxk0JDQ/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLgEeBOmcib3zBVEonTapZCBreb7k0QARFrRVqQrqGs=;
 b=oKNN7t5chp8m01LboyfjsoHBCxgbt0e7O9NloIMeKk6WAHBNLFK+gJRYCLwzMgVykwpmHpmoGtdqb+zwHgu64VWl/bFd7fFubkkkVc8ElcuLcieyMyzseKOEFE29xywU9mv3IN2KNsPGjUev/RUjWq/za5/57Nqc8tlOCslW6a/fQCzz6D2LCTKfLluwJfGOuJnzqj6Rm0fbiHeH8H4hu0b1mLbec8iFkQqG2/5QF9EsQdpsBgs1ZNNpvA7BQ926fOBZyM6Qgwiw+HdidWM2SSSWZQfKsxYPPzYGstXI7HgKBFEfAFz0KGDCBl5cSZonAsHwzidNHWcQ7NvJuMYvVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eLgEeBOmcib3zBVEonTapZCBreb7k0QARFrRVqQrqGs=;
 b=iYtmNrh1zPr3lZuv2k1QqlpmWRjImHIv24YRhGcqG0S7S9zP8aP/0+ST0R3pE+Fqa3vm8JqDj1Fe62ixlJMXMxDhY0KIE2auHvjM5+quxsC/fXjbfkDoBYd86sGgj0/q1sjtvMPgHM2RIhSgaawN9ft+tpyc1+NrPiuF/z0bzvk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 12/12] net/mlx5e: Enhance TX timeout recovery
Date:   Thu,  2 Jul 2020 21:08:32 -0700
Message-Id: <20200703040832.670860-13-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200703040832.670860-1-saeedm@mellanox.com>
References: <20200703040832.670860-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:26 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6b4dccc8-958e-446d-be2a-08d81f06e0db
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5534E8EC104E1C5F2F0B706CBE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7YZrvVE+NIfQNmnUthyqhrPrrEF/W0X34XAxVTSQycP6pD7r9TJ2qlbPhaW7g50Ihyo6pcLhjwrx96MX984/HI8ggV5+bjH7c6ojOJMgQUWK6MG3ZcW9TWigc+ttK24lQhLTbpI0sRooPIduOv1BCrtZdadZ4af0AkPKjsYAk8dHs+wUP4RjgscXTsJWMiciMzUwvs1NOd6V05vZN54FCMrYfthot4e5Kwbu9+eDxyKXjCOhdwPvUnXISkl0+PCbOKFdPNWf+8NIHeQGrV3obc3jLtZUO3FpOPSKnYyNfKQyWVJFlQx0NxUjhjV/nFU6FX4D9oxEn2gojtaN2amTXLwtV25kB7hzVv4+lh5R7bZl3OGjH2pt5wajIKAdYUxb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(54906003)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 655snHJxBZb7GC+n0i0dWLsAS4DrJP/PC4KE3DSJrzhEN50P48f3fhMMvUvHkTwEbNfir6g/uSirJvJ92dch7w8l89wgZnPIY9si/TuxuPavHrTB+UqDuBGrdpeObkPdHSScNcRq0uHKSG7I4xo73VGjswjY+Ban0UWmM03Vmv7HyJCctc8HrVuZPlmzB58ZNGaEDwplabZ3Rc+GD7jgC/tuGwF23yKht0hS1ZXfyPz2fdOc6jgUfRivUHKeMItihSFCzfQZGEDmzlVs33uQWyjuf65TE6wyl0+lmZ35MtR6ZV4zAWs5mdDZMdzDvK8VMwB1Vs81tHNGtoCYu6cyBgoTUEN+kBlP9G7Ht1uF844bA6nbixXzVE3aeMKS+B0gHk729saIBsCMf2D31YpKWKjWU8QPGfY+uIcwkkE3zUkBpt6vuRc/hQl08QXc5uwRW38Y+CENqi6HaLWWCWrFj5y6Q03GK1rtvIOzEZZTwb4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4dccc8-958e-446d-be2a-08d81f06e0db
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:27.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eQTh8Cv9eM2uFHWUIRD6RIOMgOC4cUTGFuvdqADWrpxLLgxWaIJ1EUf8qIwWhJnhsVFxOhbjA14jIkQ7etPlEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Upon a TX timeout handle, if the TX reporter was not able to recover
from the error, reopen the channels. If tried to reopen channels, do not
loop over TX queues for timeout.

With that, the reporters state and separation will better
expose the driver's state.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/en/reporter_tx.c       | 36 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 14 ++------
 2 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
index 465c7cc8d909..826584380216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -83,17 +83,40 @@ static int mlx5e_tx_reporter_err_cqe_recover(void *ctx)
 	return err;
 }
 
+struct mlx5e_tx_timeout_ctx {
+	struct mlx5e_txqsq *sq;
+	signed int status;
+};
+
 static int mlx5e_tx_reporter_timeout_recover(void *ctx)
 {
+	struct mlx5e_tx_timeout_ctx *to_ctx;
+	struct mlx5e_priv *priv;
 	struct mlx5_eq_comp *eq;
 	struct mlx5e_txqsq *sq;
 	int err;
 
-	sq = ctx;
+	to_ctx = ctx;
+	sq = to_ctx->sq;
 	eq = sq->cq.mcq.eq;
+	priv = sq->channel->priv;
 	err = mlx5e_health_channel_eq_recover(eq, sq->channel);
-	if (err)
-		clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+	if (!err) {
+		to_ctx->status = 0; /* this sq recovered */
+		return err;
+	}
+
+	err = mlx5e_safe_reopen_channels(priv);
+	if (!err) {
+		to_ctx->status = 1; /* all channels recovered */
+		return err;
+	}
+
+	to_ctx->status = err;
+	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
+	netdev_err(priv->netdev,
+		   "mlx5e_safe_reopen_channels failed recovering from a tx_timeout, err(%d).\n",
+		   err);
 
 	return err;
 }
@@ -389,9 +412,11 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_priv *priv = sq->channel->priv;
 	char err_str[MLX5E_REPORTER_PER_Q_MAX_LEN];
+	struct mlx5e_tx_timeout_ctx to_ctx = {};
 	struct mlx5e_err_ctx err_ctx = {};
 
-	err_ctx.ctx = sq;
+	to_ctx.sq = sq;
+	err_ctx.ctx = &to_ctx;
 	err_ctx.recover = mlx5e_tx_reporter_timeout_recover;
 	err_ctx.dump = mlx5e_tx_reporter_dump_sq;
 	snprintf(err_str, sizeof(err_str),
@@ -399,7 +424,8 @@ int mlx5e_reporter_tx_timeout(struct mlx5e_txqsq *sq)
 		 sq->channel->ix, sq->sqn, sq->cq.mcq.cqn, sq->cc, sq->pc,
 		 jiffies_to_usecs(jiffies - sq->txq->trans_start));
 
-	return mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
+	mlx5e_health_report(priv, priv->tx_reporter, err_str, &err_ctx);
+	return to_ctx.status;
 }
 
 static const struct devlink_health_reporter_ops mlx5_tx_reporter_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 046cfb0ea180..b04c8572adea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4367,8 +4367,6 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 {
 	struct mlx5e_priv *priv = container_of(work, struct mlx5e_priv,
 					       tx_timeout_work);
-	bool report_failed = false;
-	int err;
 	int i;
 
 	rtnl_lock();
@@ -4386,18 +4384,10 @@ static void mlx5e_tx_timeout_work(struct work_struct *work)
 			continue;
 
 		if (mlx5e_reporter_tx_timeout(sq))
-			report_failed = true;
+		/* break if tried to reopened channels */
+			break;
 	}
 
-	if (!report_failed)
-		goto unlock;
-
-	err = mlx5e_safe_reopen_channels(priv);
-	if (err)
-		netdev_err(priv->netdev,
-			   "mlx5e_safe_reopen_channels failed recovering from a tx_timeout, err(%d).\n",
-			   err);
-
 unlock:
 	mutex_unlock(&priv->state_lock);
 	rtnl_unlock();
-- 
2.26.2

