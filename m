Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8845F3C2052
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 09:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhGIH47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 03:56:59 -0400
Received: from mail-db8eur05on2078.outbound.protection.outlook.com ([40.107.20.78]:37856
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231419AbhGIH46 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 03:56:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5ozBS4WgL+JmhyD/QHUv+03E/TxVCvBQIT0u+WHG8trlI5CVX79S+LqJ6vS3qs0tq5ed1qGYyfnotDld3/mkF+nJHqfdtqWW+RPgf3o245j6WrL05je5bCphDRSGXFvL5x5Gb/Lj4yugCBaHZJu0xyGE+1914eeXHryINcydt5LQ6lVe6USUiP90SWGnF8uWTfY0M8G2aJgYBW+IjvVnsWpKMfgptMLHjhKytVcii6Nzx1UVrfCmHyv6ajTXkCPSQBOI/bpr6TMYMlmi2xIQCW5giCtu3JIxyydJyzytXHen5ArYgFM0J6lSq89NtZNFy3SlezCPuviLkCenTD7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kweURP6Gz/VziteuUY8Ennqc9aDvjbgDQe6WbvrroNY=;
 b=oTQcHYgeCGUAyuBaY/5D/0KEOetqd3+YB/m2+M05az53WwALi3bR5hcFT5yK/iCWw0jCcjrazGKdvQ182YPGutJWILLAqgos8oeY3ZodOnPIFbGfdDUgi7Mp9h/LP9yRwReJPpfIyxCIQiZ6cTI1egEZokKgZKsF5+mHIRCbkFBDnhPpdwQnZLRk89vTINmmaes2ZI8rj77gH0pZBmhlqJYVVfZkg3GP08M0P31+o2tDCoG1uZMvhmhMIIhL5k5HIzt79AXqyT9eelHAQKGJZwOIAD0cwOgEbw6M8P8HpKrMNUzEwm2v4pNnNqF12SgN5GM6DLF/gT320UrKG2kQaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kweURP6Gz/VziteuUY8Ennqc9aDvjbgDQe6WbvrroNY=;
 b=HeVm6nmTP95edUOjTAENCL7FDjEXmuRwi9wXJjPcRGlJRH1BG/517TgPeBUVcTpgG1BK3kTJRC8fQ3iX9iNsQaHhRbP1ePErQDjAsFtrnVWXbbwH3lMer6SCGJoY0SqUfsiKm3BrZHsx2r1OIcctTEYPBHNz3pXk6OaHb9AJYqI=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6793.eurprd04.prod.outlook.com (2603:10a6:10:11a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 9 Jul
 2021 07:54:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%7]) with mapi id 15.20.4308.023; Fri, 9 Jul 2021
 07:54:12 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 5/5] net: fec: add MAC internal delayed clock feature support
Date:   Fri,  9 Jul 2021 15:53:55 +0800
Message-Id: <20210709075355.27218-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
References: <20210709075355.27218-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0147.apcprd06.prod.outlook.com
 (2603:1096:1:1f::25) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR06CA0147.apcprd06.prod.outlook.com (2603:1096:1:1f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Fri, 9 Jul 2021 07:54:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 966ed448-f296-47e3-c2ff-08d942aebde4
X-MS-TrafficTypeDiagnostic: DB8PR04MB6793:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6793CFE543AC4E1EE56865D8E6189@DB8PR04MB6793.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o2WqxCIC+k+94z4W4reO2KH0BsD6G/XEAN5n3hOJgXkoLaPBZcQLjoTcIO1sAkZNvZjXM2F7g4JM92JqE3QKfBN+dK5vciqBowI0Ij7WOPdRoPhNx3+qQtIIx8Ee7YoL2FGZtTl8LClGbRcY/koDJFI6u/0X/M+u2y7Sr3YDs4xb+QVDbhq7hBBNQI8Ko2p6c0hBREtTx7LS1oxBWWAg7VSi6GvbpnE+VRbNvCsv5Tog29L6rGKPTZT5lprv2/yuaGSZXRSJLmFcKP1U2ueEJEXccGX1tbHqG0PbA1t/FcYdNRsypQJ1nWr28JsFXb4AKNvDqjaQjBOM1NKeuaXnpjJjFTkIzTcJRiQcZad2CO/l63tT7P0XckzNy3p4wz8FssI+70JIp5hl6bh96Xsqe9+THL2Wnk7VN1xLkSSHwwLMHUEPHusRproh+RmuMh72rx5XfjLXEwvrRQuvOwPP6G+FUlLt7sPMvTRmzq89gktg9UyQmu4ioMk8eq947UU+eoNwDvQk3A3rvrCokZk4zDcwHZ+8iKv8EjRC1bPVHv+zheMO92ZS2vH9b4UB+eqdXiuTTBUMbP0sI6Dxf8XN4h6IQxJqSERU0gV7Mk+zHYMfQ3P/q+vHSUZnAIuDfS9DJ6zxTSmjnri3G6wj3uL8UerTj1dJoi/N7rB1Dv0IzltnePH2yRDcmKHIReXNvcnDm9nXeTqdBBFdsYigpqbnLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(8936002)(956004)(38350700002)(316002)(6486002)(5660300002)(83380400001)(26005)(4326008)(186003)(36756003)(6506007)(478600001)(1076003)(86362001)(2616005)(66476007)(2906002)(38100700002)(52116002)(8676002)(6512007)(66556008)(66946007)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0EOcp+CpwdGzRLdky1qu94h+REPgZpMZ/JFeI/fkxkcTUII2zO9IJTqc/31P?=
 =?us-ascii?Q?K+6O5rORD2mwZt0jsoV3Hav35yO8JJbcWWU71s/CMHI2PHer/poo50lRPHqY?=
 =?us-ascii?Q?nOKmEagsWI5wCj0+F8ahdGgYl0kpelT2cxSsYpz5s+J4ii9ib6nqt0RsmVCz?=
 =?us-ascii?Q?ZswoVRRRKTL7gT8Nxe+w6MscP8RMHJy4KYezLrrbO7ygiiEu6uAPJvotL4It?=
 =?us-ascii?Q?eNOLB+f75OgLJmaWCgh9lWCExRI5LFlMKXgx74dtxECSUemuwfWjOB0R5xTn?=
 =?us-ascii?Q?VsTzsmGrAdR4Zf+FnPrcyL/9+fg720olDd4f3XaaNQd89My2oVCC6w9zSPR/?=
 =?us-ascii?Q?EKSoyX2QTIWQY/51eQaQLD1COb6mrjzaM7pHL0FwygqX3HiMzwoXneuT7itj?=
 =?us-ascii?Q?d+8KfCflF8PIqQYgFFEi8/CuQkqAFrR1LdDb5xcp3tG181tf4W+pBiQvZKgL?=
 =?us-ascii?Q?rBlf0sAlq6LmFOGT3zg1RyPKfDSH7k41O+PhBo2YoTotCPOphOzoCEkJ2lFD?=
 =?us-ascii?Q?V7uO7vSbprRfXbynPjSMgKd6C7cw87gqKV5p0Yo/6Eu+4/TRWrcr/04rgyQg?=
 =?us-ascii?Q?0hpxhsBIo+Aq9IPasmF1HfkRV4QB2xQvhjZ8EqEkkhfrd4E25uA/jY+mBA3C?=
 =?us-ascii?Q?MEutQl8IOl9KyX4h+OvjGScCgWlmwBxqoWGzzPuer20oowOyPtQw+EMiNzIN?=
 =?us-ascii?Q?1/4d4KJw1DYPqNjFXXPhp8UD5rptX/v7QoG4NKVF6kWmicrZ1kPbjU3sCY75?=
 =?us-ascii?Q?WNp7cL3G23znRaFYJEgUD6xsKRzD45CjmwBzitlS+LcCnX2NeZEsP5d9ERFK?=
 =?us-ascii?Q?fxUQBUE/w0ndspwKRKqBkBgNSwy3uv2pFYEEjP298LsyvcjpIrpBfhGkLZZU?=
 =?us-ascii?Q?fa7czCZi+6oCkQU2j8p8tbPw/TPzABBFvDCT5tZdLZsN/sv8iRSsGMlYe81V?=
 =?us-ascii?Q?0BxkUSKzaDFEwONL9fnk0I6Tp4jpn/Ir41PKk2Fq8XDKgXRptEFrRmSAoYXU?=
 =?us-ascii?Q?GrnZ8UyfQYWCr2A7ARtSxlTllEQFHS8K6pQCIuyZ7Wuw0EFip5k0wdaa/uH5?=
 =?us-ascii?Q?vuM0OabPa8H7RJvVuLoVi2yU78q9ODgEVFJ4s/LL3YNaRpeKBeOqvKYNHMCD?=
 =?us-ascii?Q?p8KeHK+oJF1PIdx0ogmq29utK+tMJJgf5cVR1lBd9KiPLq1TiuUf0aoFyRdT?=
 =?us-ascii?Q?l0ghRS8rjJIfze6LDzaS7nO+PMrByW+QK+2JY26jgV3DSC/Lo4Rjdk0MNTlX?=
 =?us-ascii?Q?HWFsSQYpAjRHHFV3LfsV+cX8TWdILNt1+Iy7xAamnRf560hIkLkbOOsIlBBw?=
 =?us-ascii?Q?MqtVIIIRgb5Z47E5xv6y8tBh?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 966ed448-f296-47e3-c2ff-08d942aebde4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2021 07:54:12.9106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 952fvRCE0P0cviSpP0L3SGmmRIeBrTL14/7rJOedWsR47uJWuYgRKw0M4h43XwRwVozT8NYCd9D8CDmVkSnDNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6793
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

i.MX8QM ENET IP version support timing specification that MAC
integrate clock delay in RGMII mode, the delayed TXC/RXC as an
alternative option to work well with various PHYs.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec.h      |  6 ++++++
 drivers/net/ethernet/freescale/fec_main.c | 26 +++++++++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0a741bc440e4..ae3259164395 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -381,6 +381,9 @@ struct bufdesc_ex {
 #define FEC_DEFAULT_IMASK (FEC_ENET_TXF | FEC_ENET_RXF)
 #define FEC_RX_DISABLED_IMASK (FEC_DEFAULT_IMASK & (~FEC_ENET_RXF))
 
+#define FEC_ENET_TXC_DLY	((uint)0x00010000)
+#define FEC_ENET_RXC_DLY	((uint)0x00020000)
+
 /* ENET interrupt coalescing macro define */
 #define FEC_ITR_CLK_SEL		(0x1 << 30)
 #define FEC_ITR_EN		(0x1 << 31)
@@ -543,6 +546,7 @@ struct fec_enet_private {
 	struct clk *clk_ref;
 	struct clk *clk_enet_out;
 	struct clk *clk_ptp;
+	struct clk *clk_2x_txclk;
 
 	bool ptp_clk_on;
 	struct mutex ptp_clk_mutex;
@@ -565,6 +569,8 @@ struct fec_enet_private {
 	uint	phy_speed;
 	phy_interface_t	phy_interface;
 	struct device_node *phy_node;
+	bool	rgmii_txc_dly;
+	bool	rgmii_rxc_dly;
 	int	link;
 	int	full_duplex;
 	int	speed;
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 24082b3f2118..18ab60322688 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1137,6 +1137,13 @@ fec_restart(struct net_device *ndev)
 	if (fep->bufdesc_ex)
 		ecntl |= (1 << 4);
 
+	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
+	    fep->rgmii_txc_dly)
+		ecntl |= FEC_ENET_TXC_DLY;
+	if (fep->quirks & FEC_QUIRK_DELAYED_CLKS_SUPPORT &&
+	    fep->rgmii_rxc_dly)
+		ecntl |= FEC_ENET_RXC_DLY;
+
 #ifndef CONFIG_M5272
 	/* Enable the MIB statistic event counters */
 	writel(0 << 31, fep->hwp + FEC_MIB_CTRLSTAT);
@@ -2000,6 +2007,10 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 		if (ret)
 			goto failed_clk_ref;
 
+		ret = clk_prepare_enable(fep->clk_2x_txclk);
+		if (ret)
+			goto failed_clk_2x_txclk;
+
 		fec_enet_phy_reset_after_clk_enable(ndev);
 	} else {
 		clk_disable_unprepare(fep->clk_enet_out);
@@ -2010,10 +2021,14 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 			mutex_unlock(&fep->ptp_clk_mutex);
 		}
 		clk_disable_unprepare(fep->clk_ref);
+		clk_disable_unprepare(fep->clk_2x_txclk);
 	}
 
 	return 0;
 
+failed_clk_2x_txclk:
+	if (fep->clk_ref)
+		clk_disable_unprepare(fep->clk_ref);
 failed_clk_ref:
 	if (fep->clk_ptp) {
 		mutex_lock(&fep->ptp_clk_mutex);
@@ -3761,6 +3776,12 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_stop_mode;
 
+	if (of_get_property(np, "fsl,rgmii_txc_dly", NULL))
+		fep->rgmii_txc_dly = true;
+
+	if (of_get_property(np, "fsl,rgmii_rxc_dly", NULL))
+		fep->rgmii_rxc_dly = true;
+
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3812,6 +3833,11 @@ fec_probe(struct platform_device *pdev)
 		fep->clk_ref = NULL;
 	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);
 
+	/* clk_2x_txclk is optional, depends on board */
+	fep->clk_2x_txclk = devm_clk_get(&pdev->dev, "enet_2x_txclk");
+	if (IS_ERR(fep->clk_2x_txclk))
+		fep->clk_2x_txclk = NULL;
+
 	fep->bufdesc_ex = fep->quirks & FEC_QUIRK_HAS_BUFDESC_EX;
 	fep->clk_ptp = devm_clk_get(&pdev->dev, "ptp");
 	if (IS_ERR(fep->clk_ptp)) {
-- 
2.17.1

