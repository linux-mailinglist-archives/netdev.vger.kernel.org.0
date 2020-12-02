Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBAB52CB7F5
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387875AbgLBJBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:01:13 -0500
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:18035
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727006AbgLBJBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:01:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TL9AlFdTd8A9Huyq6IdqUyCH+XlJ4voyqNKgB1GsMMugUbyjGcmeJUThzj3QQ0M81pNgUOPa0dMoNGmWd4r4ziD5fgl585HtkkcRBOYGR67QnU3oRisptbY09ArhK7dTsO27DpTjXwVEsKP9XAwqxwsInbs7eNKvHWpCDJOxCk7qiKLoNmpBWik/PWTzq//y2g02qe2qNKDgjfnatWHdS0LX5CaOLtUjjn+zAHhntwp9z9TDivq+ytRqbLCOJ3COjcscT09zHr2eXPyhDvmEDAa8BhcSuW+q+hkzDvaKG1H/7ecApF8LH4jeucDGsJa4uBVRkTmO8VJLOLXiVS2DDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4JgGxXEmlj4Dk1GJ8RE43o5m5/sOJ/h6qeWUn22rrc=;
 b=M/q5yiOaeXjl17vosfLYDrntjN7qZ0dEnWnWqttcB4uiPTYBr6Q13CoAwJI+aD2Nd7PzE3J6nxVG2qbPDcEvzYxUcc2Clf0Z3irH6Tkh5EweB+9tSuZbiE5ReOTKPILoKvF7hFpLOTkHH3Uh0iXwHVx1qJb0W5iFj4qEf+vT+H/+QcfD9a3nUIQe0yh3ZhF+KcFXoe0K84wq5+36MiidDoTfBG6wiupiKVOfDvb2oKs/MeKpmuyBPHAVm5W8Po85cbcUzGeomnai6HmSfR8WH7AgDAr09Ow41ZeafYsMIRZSk4jG7raW2J+bYnTooLxP+3wTZRyUil2FdiOSj0yaPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R4JgGxXEmlj4Dk1GJ8RE43o5m5/sOJ/h6qeWUn22rrc=;
 b=FHZc7C/7PO6wDAALeFjCvXejjqAPjdGpf0RNvDQBS64vKU5qB63Oa+VgD+oMwueLAzZOR5bHBGqQ+uRwIyY0qumeJeD3DXeNVKuUIOaUCLtULnsJlVUDWLitEUG2qnddV21cELIwCUW6Z+RP0hVgCq4cnZ/aBFl9YO8l2D9AfnY=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 08:59:49 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 08:59:49 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH] LF-2678 net: ethernet: stmmac: delete the eee_ctrl_timer after napi disabled
Date:   Wed,  2 Dec 2020 16:59:45 +0800
Message-Id: <20201202085949.3279-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
References: <20201202085949.3279-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 08:59:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5100cb72-ea88-4bc6-3ae7-08d896a09fa4
X-MS-TrafficTypeDiagnostic: DBAPR04MB7432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7432E3FC7DC4F2FEEDCAD7BFE6F30@DBAPR04MB7432.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cId8KdtdickXfxSt6UBdK5Fe+HnjZw2O33EH1TiCltRK4R6qVWqUdLHv10zLe8KSXUhM7cVXMbP6S3IAjm0w4WKm+EhZPfx/W1+1/oiStPdYgxP62ZwypXJvKNz16JI6jzw7XYM+jAb2BDQTIbe8dpKLvsrlQ8CEZKsglfC8md6nmABIdMlwryaU9NJ9sv2lYQTyUU/EpV6cdNjCleeOswIZ58Hb6IaGQY3nFIiC8ZUfFcsBaL+i6F4k5NIGZsTwFQZtlKFmkmCXi3cWBLogOlONiiD9yCiM+dTKBk1BUZAxHVp7sYh0WBvPu2S3s5kxaTGyFm1sw1fQJHOqWC2ho8wrbwGBCqA8rApJk1zvINm5IAZccPB+ce6jkR/c44BX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(8936002)(16526019)(186003)(8676002)(26005)(6506007)(5660300002)(36756003)(83380400001)(52116002)(478600001)(316002)(86362001)(69590400008)(1076003)(956004)(6512007)(66946007)(4326008)(66556008)(66476007)(2616005)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Pa8VPR9HxzGTVE2nOQ/NA3/Vl/miq4yKdB14xmAXUC+xfD+5Oy0JwQMXPLXj?=
 =?us-ascii?Q?JquVYHirE5iGU3fnYAzX2FCb7d4svQ6ytcuGVS/MIcxLmShfSiT1aiZMar+o?=
 =?us-ascii?Q?psHYdyKwqPqZfWBNkXt9VTjG9Ghh81Z94ZysKSOexNTTk0ik8b9N4koro6Yr?=
 =?us-ascii?Q?W/O7Yjv19UeB2O2FKZmCWS8UPO8qe9yDToXnNbOmU1/XD4VnwkBAVzdUwtoH?=
 =?us-ascii?Q?G0CzifnN49PyH626vvdPdM+iyhjZpyaGZiPS1qS1MnaXnSuefO5/qxL4pBjf?=
 =?us-ascii?Q?wPumPtS616L9nblVmuwi5qSW3v4FJP2WGAJPQ2m7H4hVbKYQGfZO9Bqw8cs1?=
 =?us-ascii?Q?tKxb+M4lyVs9UN5ZqYW5+8VcRQ6/nkj3H4ZZCLcEEjHBFSrHfmsScBpmwaTq?=
 =?us-ascii?Q?tk2qqsOeZUCfr+VfsmQaeswGz5nj/Nqm4xZ34JJdWyeHidiMYi1oJQfr81mN?=
 =?us-ascii?Q?FbjK8qLozgqM8QQPsQn3baDfOGtMPD5BMUyiOnTwdIJsH7jKkLLfCzPfmPBn?=
 =?us-ascii?Q?6D0nDa4lEzalrjqyDAe9lt5wDsUu7GV7pGWoNI3EAB3HK/d3LeddAtCaadfK?=
 =?us-ascii?Q?N13AQThiG7Q5tDNCKxtb3ERzSi7Cryd+qP0wX8uOK22Nn70Kf3IOXUEj5Geg?=
 =?us-ascii?Q?KB5C+FtOnnLKSxWbWGvcyuq8p8OlKivRZKtdi70VTFdQTHavW6FZdUZWm7Ty?=
 =?us-ascii?Q?K/Ff/EQc50VkIWge3aNkcaPO98gdo6CJpKemolRBtZs0JiZTO06ncEm7+FCc?=
 =?us-ascii?Q?HCUY8BbYFLGJ7wop8/PxBairqwl+R80VJnixE5SmtgFpbUX6bQ6RvNGPlxDS?=
 =?us-ascii?Q?MDcTGocKnL/rTyenp/V6iS6lIfKLtvNT5SlFPFOw2sXnmEDz7QuCZxo6WaXj?=
 =?us-ascii?Q?PIh9Lp32VdWHSHcv70cHPPRQrpX583Yy/W9W5SBCtObEfeWirqXEjpUthvN2?=
 =?us-ascii?Q?JBr/zlgZsLTRP9RFdhQY/CqHJq46KN7J6etY7CJ9z04X7GjzwnzFVMFxq1er?=
 =?us-ascii?Q?F0Wu?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5100cb72-ea88-4bc6-3ae7-08d896a09fa4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 08:59:49.2230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbUQCsrqulqNAXoPmKLJ/DceA2BH425MK/aVJsc3u3qcP7xA+jqc7Mc0w0Gj+Lrjym3kEL+Bqw+NxwRLHiGnGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

There have chance to re-enable the eee_ctrl_timer and fire the timer
in napi callback after delete the timer in .stmmac_release(), which
introduces to access eee registers in the timer function after clocks
are disabled then causes system hang.

It is safe to delete the timer after napi disabled and disable lpi mode.

Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Reviewed-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index cc1f17b170f0..7e655fa34589 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2933,9 +2933,6 @@ static int stmmac_release(struct net_device *dev)
 	struct platform_device *pdev = to_platform_device(priv->device);
 	u32 chan;
 
-	if (priv->eee_enabled)
-		del_timer_sync(&priv->eee_ctrl_timer);
-
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -2954,6 +2951,11 @@ static int stmmac_release(struct net_device *dev)
 	if (priv->lpi_irq > 0)
 		free_irq(priv->lpi_irq, dev);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
@@ -5224,6 +5226,11 @@ int stmmac_suspend(struct device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		del_timer_sync(&priv->tx_queue[chan].txtimer);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 
-- 
2.17.1

