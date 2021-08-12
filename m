Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD43E9F41
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 09:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbhHLHKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 03:10:20 -0400
Received: from mail-eopbgr80045.outbound.protection.outlook.com ([40.107.8.45]:3100
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230147AbhHLHKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Aug 2021 03:10:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7MC5qrPdlfoysUY2AIczbnERhMapPWe1kD9Aiy1SSQjpPHGKZkvzr9r+uyfTBXJRHDl3VkAb3tF3EccygJpCA94QQ8wTli4GVwAV5eX7XnrXPLKnD1cu4njVBb0pNmL3nD54ZQPUvrm2z6IKDzpgHGXJvLf/bgr7ktgkewEnlA2y+HfACvgt12/SbqbiX1eA/Hb/YYVwwJyEG80GjnnCaRvQw3R2wXWcFnodvLSzAIRbQrW4+RXTUCZV5/4z92QMyHWj/vJcEMePeQJDofUvZ3bCkwH+XFtBr3KldyBi8V/GBYg2YY2GhjcEV9gXvM18hsW09hq8IdzI/2sIPa9pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeFiwcqR1LKPAZm2moAWCjKldJj5j4/qPuQouh3vo7U=;
 b=cjgQBIrJzOFbTAh7WGWFD0cRqvsUVYeT+zCgfdCzvVfATGxOH/Q8MzjV7PZO7Ng6c/jhLTRu0lI+5Sduu8y5uyz1LfjVqSOVg+e1fDXzZo5yE97g2BY/Ct8S+1awwMOL0udLY1reiKY466V2bl0s6wrFvbLPFx/ogl0TD9r09wNCnGCtE6NFjL4aXGai0ZNZUCA0fH8m69Y6k54ukdOYUHd2SOLdF0gb88B02DpUURoHygl5ZLPVNGYi9CUp0c0GI2wb2ZHtZaR+kdidGyu0GoMG85ZTAUbNDaBUWUZQuG41l/shPnB3S5nakgleGzez9ObBB8Q0IJ6iEx3tc5/mNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeFiwcqR1LKPAZm2moAWCjKldJj5j4/qPuQouh3vo7U=;
 b=R1zAANoRumoK89wYPeP8MqGjFkeSUFhG2+7ZG3yqVWT3d2cuYHMVoaLZeP00pVbxQTG0OCs1bDVZKH4BQhGF3u2yiazvpza4UmWYJQ/hzuJS2ROUG6BAXfHSJQgjpc5KYZlW02zqb7dL9wEAVqRHcbQE0BZYxaU/93GdEsTk+xo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Thu, 12 Aug
 2021 07:09:52 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::6969:eadc:6001:c0d%6]) with mapi id 15.20.4415.017; Thu, 12 Aug 2021
 07:09:52 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V2 net-next] net: fec: add WoL support for i.MX8MQ
Date:   Thu, 12 Aug 2021 15:09:48 +0800
Message-Id: <20210812070948.25797-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0151.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::31) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0151.apcprd01.prod.exchangelabs.com (2603:1096:4:8f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Thu, 12 Aug 2021 07:09:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0621cd4c-b46e-45f0-0307-08d95d602e0a
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB30940A15B02007E3C34FEAC4E6F99@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tZv3y7Axtu9mICblYQm4OBIw8NFCxqdJFxaZ4XV/MNaoByinjIVaYZIFWs7HYtdpaWjwEorgRhCqTwGCUh4ELjCTY96MuXgu4zLbihBDBWhIQgURua1jBfjBKkdrOyvDO/IEJ4EReRi3CzKVNEsUgszx1uqMEm0wkr2Z6SKAWzZJnvRBlxsJg+US2swdWErlYFJTWOLycYyCPUW2hFlic5BpWV/LQYeSpuuu7tg4k92DiBcJ/7gsERNXJnMwmJ4g0a6JtSVqIUbZNpecCsZdiFeL0vCotfikDnYNiFDzellObIC1JeO/KNPivRRALNNCHFAWj/CA6YlyNGsIA89Wr9dPM90RORCU481OZtFeZe0UVMW0aCTMKXoAoDl/X5/mCjpjakmOZzz/HcM/IGL9WTHTbhH8Aakss6CEV4+fn0TIH9ykdWigwj0l+33/f8N3TJXNEMUCTg2gwd5WrV7vY1avPI1U664i4C0msJkDYaHG9dOd5eyiItb0unWVeCcI8LFZb9KHms4KZhyHqHB9r+tEKz+7yj140w7DBIoUjowhWYy1R5ag7PIejzqcndyf51traO+B02hfoPdkOdlTmYqhdvAT1stVOiitGL9IyqrJA2KdMrZihGTDuqBtokHvAkDs7QZ/rEnRpCpJDpmHham0cnRY+65xYVP0SoqKU2dsZN0xdxeGk8jNbOsmMPgmRF9Zsj26XV5fC7MokGwMWg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(136003)(396003)(366004)(316002)(478600001)(5660300002)(83380400001)(38100700002)(38350700002)(4326008)(2616005)(66476007)(52116002)(66556008)(956004)(36756003)(1076003)(6506007)(66946007)(6486002)(26005)(86362001)(8676002)(186003)(8936002)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?svyc4DhNKRVmBT6smEkVR/U91koy5IYRWaNRRdXh359AghnTxBebyvv1bo+q?=
 =?us-ascii?Q?tbHxQh/ftR2+obksA1obNVXoub4kaTijaHbwwbdekDS6PibivUgsStD+DBGU?=
 =?us-ascii?Q?P7E0bWZzRSCFJ1Yqwm/cuiQOk1N9k1q8qL/DFKBtSSD6SY28rS+UQyUCmR8s?=
 =?us-ascii?Q?j/SXdBKX+HgGb0ImifyIYcsLSk8ovHlBUkk9liQNaZKqj6kepIMFgoeO0ZoX?=
 =?us-ascii?Q?Q35dYaUigGQDfdvT5GqgCpHjNLMLdYfFHoSJXq1CLvTkk17bHRFwSyji8Fl0?=
 =?us-ascii?Q?7/XrQjr3mckCZfnnc9VJup64Z4zn7tIRMj06Di0cfrRg+O/UWu24j3R9kh0v?=
 =?us-ascii?Q?/0uflDtVYGC6FmGiukzLOv+Ga6EtxvHRPlO5CZS9neQi6REiHXOfCChgD6oj?=
 =?us-ascii?Q?56lVi6X/6WC0Bv2hL7GqXsPbKOmhdp7fveOkLlRXxxeGw1VHHLTxZUvAKDa5?=
 =?us-ascii?Q?AK2xWbtBPm7qHnncAuC+3jmhkHgHBoTiUj5J9aMVIa85EpPz+GBtuXQ6L/fB?=
 =?us-ascii?Q?iniQEUIRWycx7dsfBIiW7dEdmBpX/3eZqS2G+ByoCJ0EX+StlmG7Iy5UtQZw?=
 =?us-ascii?Q?QDbrLZuI1T5yAVfwzJe3fvzohAcn0Ofc/kAO+9YB1GyKw4w0rBOjcj9yb8d1?=
 =?us-ascii?Q?5Jz1EoqbRMAd9T3N71+7PkGhzA3H1ekC/j6RVKX7Si5RT1HOotz7x9qmd5BD?=
 =?us-ascii?Q?JPAIAF4WI/raX3HsRnkRBez2TjOZZC8oQoSAlwR01MDXTSELgkH0/7iHlt7J?=
 =?us-ascii?Q?Wm+ev33rezBKNQI3Sttmayw16hmDJr+NJluLlBeu24DNOG4eHSKR0otBzJCy?=
 =?us-ascii?Q?af2NFykYLVYlrHJTCCANPqGaPYkA2eQWyGCDQOjKHp8xZLtIAl2vfVApGUlA?=
 =?us-ascii?Q?iWGEkv8ZCSLJNRHYngN3P0xEuLQR4C8uyQI7i5NJVfftswh1aHO8jkxHYInF?=
 =?us-ascii?Q?e+lyMdzyLuW6/5ZgpZAU4OGWLFKjT9VKAuwFVbqfHjgELL0GDzCg6SWdkyZ6?=
 =?us-ascii?Q?/6dnuMhYDW17QuFx5WfDENFkn7L3kHuc5SzAsrtsAfQTse2Z6hb0YVtm5PH2?=
 =?us-ascii?Q?JiggpmhjRLWBYkI8znC88MBe+IgDUwVkZQtvAs9HZqit/FcT0kD3L8Q6ZrP+?=
 =?us-ascii?Q?hWD/2DVG+58s2vtTbXnJn7vV69vaCCQuOVlihwQvuki7RR0tc1JK7DflKZOH?=
 =?us-ascii?Q?oa4vQ0fKUB0fROiqEh/iBUjfDlydXe69VfsIsaZp+fZnxE+MLLjmEND/Ug0r?=
 =?us-ascii?Q?zlgxg/xSQeaG9rwhKOI4vMgnuWSRbh8OZBQ8mrOInTJ/Q/yP1TDbhiOEZ8wZ?=
 =?us-ascii?Q?kctZFQUWbgrRt/JFscGilsah?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0621cd4c-b46e-45f0-0307-08d95d602e0a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 07:09:52.3164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0jF+d2OYuYW2BcjB5eoct+Px6elkBbTkWKIxO6UlQ9IRjCBrt4Yp7GNfFNIF3XlxgRi1jCZukaRisIM4J5arAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default FEC driver treat irq[0] (i.e. int0 described in dt-binding) as
wakeup interrupt, but this situation changed on i.MX8M serials, SoC
integration guys mix wakeup interrupt signal into int2 interrupt line.
This patch introduces FEC_QUIRK_WAKEUP_FROM_INT2 to indicate int2 as wakeup
interrupt for i.MX8MQ.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
ChangeLogs:
V1->V2:
	* Add a quirk to indicate wakeup interrupt, instead of add
	custom property 'fsl,wakeup-irq'.
---
 drivers/net/ethernet/freescale/fec.h      |  4 ++++
 drivers/net/ethernet/freescale/fec_main.c | 24 ++++++++++++++++++-----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index d2e9a6c02d1e..7b4961daa254 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -492,6 +492,9 @@ struct bufdesc_ex {
  */
 #define FEC_QUIRK_DELAYED_CLKS_SUPPORT	(1 << 21)
 
+/* i.MX8MQ SoC integration mix wakeup interrupt signal into "int2" interrupt line. */
+#define FEC_QUIRK_WAKEUP_FROM_INT2	(1 << 22)
+
 struct bufdesc_prop {
 	int qid;
 	/* Address of Rx and Tx buffers */
@@ -580,6 +583,7 @@ struct fec_enet_private {
 	bool	bufdesc_ex;
 	int	pause_flag;
 	int	wol_flag;
+	int	wake_irq;
 	u32	quirks;
 
 	struct	napi_struct napi;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index fdff37b87de7..83ab34b1d735 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -142,7 +142,7 @@ static const struct fec_devinfo fec_imx8mq_info = {
 		  FEC_QUIRK_ERR007885 | FEC_QUIRK_BUG_CAPTURE |
 		  FEC_QUIRK_HAS_RACC | FEC_QUIRK_HAS_COALESCE |
 		  FEC_QUIRK_CLEAR_SETUP_MII | FEC_QUIRK_HAS_MULTI_QUEUES |
-		  FEC_QUIRK_HAS_EEE,
+		  FEC_QUIRK_HAS_EEE | FEC_QUIRK_WAKEUP_FROM_INT2,
 };
 
 static const struct fec_devinfo fec_imx8qm_info = {
@@ -2878,12 +2878,12 @@ fec_enet_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 	device_set_wakeup_enable(&ndev->dev, wol->wolopts & WAKE_MAGIC);
 	if (device_may_wakeup(&ndev->dev)) {
 		fep->wol_flag |= FEC_WOL_FLAG_ENABLE;
-		if (fep->irq[0] > 0)
-			enable_irq_wake(fep->irq[0]);
+		if (fep->wake_irq > 0)
+			enable_irq_wake(fep->wake_irq);
 	} else {
 		fep->wol_flag &= (~FEC_WOL_FLAG_ENABLE);
-		if (fep->irq[0] > 0)
-			disable_irq_wake(fep->irq[0]);
+		if (fep->wake_irq > 0)
+			disable_irq_wake(fep->wake_irq);
 	}
 
 	return 0;
@@ -3696,6 +3696,17 @@ static int fec_enet_get_irq_cnt(struct platform_device *pdev)
 	return irq_cnt;
 }
 
+static void fec_enet_get_wakeup_irq(struct platform_device *pdev)
+{
+	struct net_device *ndev = platform_get_drvdata(pdev);
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	if (fep->quirks & FEC_QUIRK_WAKEUP_FROM_INT2)
+		fep->wake_irq = fep->irq[2];
+	else
+		fep->wake_irq = fep->irq[0];
+}
+
 static int fec_enet_init_stop_mode(struct fec_enet_private *fep,
 				   struct device_node *np)
 {
@@ -3935,6 +3946,9 @@ fec_probe(struct platform_device *pdev)
 		fep->irq[i] = irq;
 	}
 
+	/* Decide which interrupt line is wakeup capable */
+	fec_enet_get_wakeup_irq(pdev);
+
 	ret = fec_enet_mii_init(pdev);
 	if (ret)
 		goto failed_mii_init;
-- 
2.17.1

