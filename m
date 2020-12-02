Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412E62CB7FA
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388015AbgLBJBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:01:37 -0500
Received: from mail-eopbgr40064.outbound.protection.outlook.com ([40.107.4.64]:18035
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729107AbgLBJBg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 04:01:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nhroqEtV4o1YMrrK9vDHTf5qiJtJYC99o58r42C5Ae/MjOjuhdM0urfVMM5znHhIz8klfj88U2YqOzM1c/q+Kv9MFq/+WiNuTKagWdpNkCbqgtH58mTXQ0f6dQf+FLzcLMdo0BPVdejiMnz6TphWlJ/zRuGgSACD8D+/pSLZv7tEPkiA3+ygxCYcnbkOtEqBRh58U1WaGDzOap+iOGR9dXO6nFYw2OwgiCX0L+r8B5T9fb/Vdv8l2NGabfBrpSi7dB8VkJxBnBpVCOhSLbgSoSi+/YgWosIXpme+xZbFI6ro/pHAa3UE8vM5N0NawvHdySD3Wmx0mA/LC965kAKzNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4e1MiSYCpjkHL0sgIQFQoTplRyIZAJGiDeOpcuXLHNM=;
 b=Q87ir1OmCnBqQpSA/rp8ETjiuVmiTU4xoTdDMomQkUzDrzbVsEFNFx5Lk758kN3eYp5mF4PRZYHS6un7uKHWYucvtKnAde6TEPHFpbTlCnjsO9iPGpBdhiqqy3TASxD6VpIm0KTqIBSeKSVxG9iq4JD6h7wVwgw1aa8E8nVEvVynlQdcUXS9/f5B84q+nv25BiB98j8Relhi7Crz7izOoQ9FS5eSr0LJloTKNb+UwwLEwWbhG+IbMl8wdhXF1mF89id5ptR5l0vhOkYcMX7WTjUyHolnFtg5xDK52eopVpvRbMkQZekNMrE17cmkbIkdluk0xaQr7+INuV7YhqzkAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4e1MiSYCpjkHL0sgIQFQoTplRyIZAJGiDeOpcuXLHNM=;
 b=frg9IJHiBHBlSVgW31i1YaPCIfojLJ8W4WOZplXbNwXwAfSkQj66D2AAMJm50LqEI1SHkHA4brlzsJ7KvYGQ10VaJ+RH6zbYr5xSSvWf/ySqZz5zDFMCEWPaGPikID6ajD7vlAMD54Scai2hsN4YczDRMHwl0qHkJ1Yt9O3836Y=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7432.eurprd04.prod.outlook.com (2603:10a6:10:1a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 2 Dec
 2020 09:00:00 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.017; Wed, 2 Dec 2020
 09:00:00 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH 4/4] net: ethernet: stmmac: delete the eee_ctrl_timer after napi disabled
Date:   Wed,  2 Dec 2020 16:59:49 +0800
Message-Id: <20201202085949.3279-6-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Wed, 2 Dec 2020 08:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 20d1f2e0-b9e8-4e7f-540f-08d896a0a651
X-MS-TrafficTypeDiagnostic: DBAPR04MB7432:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB743235FA224CC914D841C656E6F30@DBAPR04MB7432.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EXNWZx+VXKLue2MwSIOUjq4pD1HT7wD7Fq9HCXYCN/50G3xDfy9g56tnYDWhXf+AhfSFJkvhUl0nPINwv8odXiTuHutwom3CrNdHOn9Y4axDf+B5qT5a1SR48QFDDyB9e0o9cG4mb1USv0Vfzx3arGaRBQwqyOeXrrRZuWL0qChir7delUimbe4bJCnmxQS5HjgggJd4U3Y9rk2dc7U+/vi8XxuG2uMKZm2c8WNKwCesQ0zq2+RuGIkrbfxlDtwG4nv3rkHN9myPRMD5jtsMdQpj6XR48vkcbEL1nm0ELUWfKtnVV8750mH3rO1GMIKt5XzsVqpZJh4JUyVzKHRy4AjV/uWxD1m3uSk+y9/5X0BDp3Yw4VKlC+vd+l8Tcz/V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(8936002)(16526019)(186003)(8676002)(26005)(6506007)(5660300002)(36756003)(83380400001)(52116002)(478600001)(316002)(86362001)(69590400008)(1076003)(956004)(6512007)(66946007)(4326008)(66556008)(66476007)(2616005)(6666004)(2906002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?LMHc/JRvLCY0s8I3GohdWb00pAn+L9nySkSyVCCVjEcVXCEL6QgvCO5XNUi/?=
 =?us-ascii?Q?ys6VSc9fNIYxJJ0w/1Cw5Oaj29e4J7NjLHnc05PaiobXz6zLuAczyHbl1NvT?=
 =?us-ascii?Q?XtQ1wU14Tio5MdSD4FWdeZd/1giSq+yRcpf/SWiY31kclAEuyXdtV5+LaaOh?=
 =?us-ascii?Q?3lGLaigcOZiCDWOVrl0zVtLWSq9tjMe0HvUaLLkdSNjWL1ft4p1cqM3u57tz?=
 =?us-ascii?Q?pNBF+HkLTmUJG+ScRFuKAolA1f/kZLnYXoVcbQAIWpIbknTwrVCrHz96pAcD?=
 =?us-ascii?Q?xnf17sGG8s2w/WqS4RYTn/rBZIHSSG01puK0B4JaA9ehuQJUgWe1T841jVCh?=
 =?us-ascii?Q?MTNFKY+Rw6KG/Sz/fRHoMgahowpyIJgL0QTp1W35JxOxCG0GZgpl/MoKc2rU?=
 =?us-ascii?Q?9BwK5kT6Ox/HEyiZwyse6MFkVxWywZgVybDBDT+c1Rrc/GBmg4GhFlS7Fz/C?=
 =?us-ascii?Q?W55dI4oQjqtLS111sIE3m613YbLlDZnT4w+BnkGozzpCdyxFfmYutcFClyRX?=
 =?us-ascii?Q?tGVWbGSsDnfWjuo6lIRQDMm52/fiUXxdxNPa/sbJ3PTtNUGeTAyOyxWrL4QH?=
 =?us-ascii?Q?cbzuY0N5cQpmHU1supXK/xAZTsbzWOB2BUQZoXkxxGU/WG0k/WbKm0DjBD89?=
 =?us-ascii?Q?fK9XNJl4rlE3EX0htFuYfnpOPBGlSDF9sT0Fy5SxzOhMmLjYqRRohdYnp6Ns?=
 =?us-ascii?Q?9y6myYHKsdljI8kFqh3mAejMHV6G6i4lQsq04LYI89F+Bf8gN0QlzGbxZwt5?=
 =?us-ascii?Q?atyTkQmlL6g6ULPrtceqrRL11edE/8JFnGksRCA/KWbF1nuCRrzkmHScd7+O?=
 =?us-ascii?Q?yN96qZWrfa6jKYqsQ6kQeGleqaU6JQFG702WT2ggqTHByPAYXcryejubkiKM?=
 =?us-ascii?Q?H/ogHnCaPm9xtrz6Dhe2LzQvI3/XBYbVq8aRnIifaFH/ee52HsRfqdX2Y7vE?=
 =?us-ascii?Q?XBNwJvm1fZ1jf6ajbmSagMxaPSqG8BRm77jE6ylCOmSrikCeOVtd+IlGzgVw?=
 =?us-ascii?Q?8Ave?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20d1f2e0-b9e8-4e7f-540f-08d896a0a651
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2020 09:00:00.4267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ddVLPKcZMQMntwrkHg5CNWAcTry93YKW7jVlzPQu3LALPifiydjQsAd/nVFnKJIHPVVjjrJat3n39dAs2iSUBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7432
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

There have chance to re-enable the eee_ctrl_timer and fire the timer
in napi callback after delete the timer in .stmmac_release(), which
introduces to access eee registers in the timer function after clocks
are disabled then causes system hang. Found this issue when do
suspend/resume and reboot stress test.

It is safe to delete the timer after napi disabled and disable lpi mode.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 53c5d77eba57..03c6995d276a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2938,9 +2938,6 @@ static int stmmac_release(struct net_device *dev)
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 chan;
 
-	if (priv->eee_enabled)
-		del_timer_sync(&priv->eee_ctrl_timer);
-
 	if (device_may_wakeup(priv->device))
 		phylink_speed_down(priv->phylink, false);
 	/* Stop and disconnect the PHY */
@@ -2959,6 +2956,11 @@ static int stmmac_release(struct net_device *dev)
 	if (priv->lpi_irq > 0)
 		free_irq(priv->lpi_irq, dev);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA and clear the descriptors */
 	stmmac_stop_all_dma(priv);
 
@@ -5185,6 +5187,11 @@ int stmmac_suspend(struct device *dev)
 	for (chan = 0; chan < priv->plat->tx_queues_to_use; chan++)
 		hrtimer_cancel(&priv->tx_queue[chan].txtimer);
 
+	if (priv->eee_enabled) {
+		priv->tx_path_in_lpi_mode = false;
+		del_timer_sync(&priv->eee_ctrl_timer);
+	}
+
 	/* Stop TX/RX DMA */
 	stmmac_stop_all_dma(priv);
 
-- 
2.17.1

