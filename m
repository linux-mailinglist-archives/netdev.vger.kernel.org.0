Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0773D8D25
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbhG1LwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:22 -0400
Received: from mail-vi1eur05on2058.outbound.protection.outlook.com ([40.107.21.58]:21025
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236140AbhG1LwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RWrQRgOuty989/KNRenrc/qWfr0wFdyxgnG2LVcqgh+uqnTBJRzq5Wx8dq7nJoeQrm2pkZIjRqBTCr7TNVy+vfef+aRLL6xfi7kcma9BKPK8jNc62Amas1dYj4EQbQ5/nxQmiMxe1NWARO5RliHffCrsarAPL2tyAqi7T+5n3jigdiQuvvsNYqPscbU5SOupB9yARsn5td8hIUPfRdwX22xtTRDHMoyWPogIo7L7a13H2k5aVI0POZu1fXHhRVY/U8b5j2qCycMdaDYHYNj+98pm+PWXrpkGAXFisWBf5X1/1QAvyh2cvh2Q+Rf5FrOckYyHnOJ64FZgvvE2rsoO4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOxzyij45vJwYLtgwyflOygjh9g41dRwcjVoOV0WDHA=;
 b=WBDH0NqCh/Wgijn3mezhLe6xyC+xc6dOsIp8VPaduTtS1UIsMEtnIoKMvZRE00/MvdAYETioa1ZWWoHmZ+tX9K9moQ74Od8442ev4Zhc5SFrqFUAGM/udM0Kk9j6qd9XkPdNQ3eJAtHHhbKiGuB8cr5xM108dUPJLYoOsFzn1HJle+1FCytJlXWpheb9ZDHVWwXT9BXm2dx0xVOVcX5EtMpeueFQLPqD1anGZY/0ClgFfVgn/N40c4E1EqYJdbnxjUhyz4RD6E7E7ax3Qp9LySOg1fJldAjdVR1p2/tOFUfG1epQbFOsIJ6/1UTLEvBAhYtMVr/skIuQPhxFM0EV/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOxzyij45vJwYLtgwyflOygjh9g41dRwcjVoOV0WDHA=;
 b=S5nxVTM9fEWZ+oB77CYtWlyWN5BUccMJmZ4rd+FdSEEDYAieM1Bdf9/YPHbwkboodPdi1FFFvxXFyDhMeUa3bj0rR8PH5NNWK+EX+Llzvc0Rz56eXunEl/Z8qtgQMdkxgszH00sNBaGh5LHRUp8eprWuzKzUSys/qYh3DCQ3KPQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 11:52:12 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:52:12 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 5/7] net: fec: add MAC internal delayed clock feature support
Date:   Wed, 28 Jul 2021 19:52:01 +0800
Message-Id: <20210728115203.16263-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:52:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9af0d501-ca30-4610-511c-08d951be22fe
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB3094C5E6DA233AD0DBDF5FB4E6EA9@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GW8HWLqRbZw/nR6I6x/Kc9SylrFTLka3TWUiRHDqyecGqoCTrqvUOLTTdhrCtI0xjaurcXZMvrizAY39tVJIHcr7uu36QesbW0Hs1a54gLmcBNGAwPJlCFmBVTxixoFBfm+3GHXafmucKtu6VeTVJF1YhQWuDujYvkO/thjg9D8/+6obTnPtem1mQUc+x82H1Ivb0YVls8+nMW+cvdopM2vrMoV890kuYSYFtu49J6WAAcDto9COt+LZOQugiuxkfISyzT+54i9QxQo+lYluY+rGuxM38E6dVvGcnhKL1kkJ12ce0w27zF1xRsdmR0AaKspcQLjRvThtY27yvnQgILLozYeq6n2HddsIeCKxdNZOAAvPDv9Em3cQpCYsOhwa75pqyR/UYkmuUBV/DCMc6qgKIIIwgaQF15ji0t5cwbmfPuszF81aHVFi0Gp+m/Uwo542z1UlG3dpsiXxLSDpSgYAhY95LidQWVNLwYBCLE33eKhAEwjBtIpctZI9aMU+j+MKxUxcrqvSjyn7KKT1RRsyI47LribtXRY2CHu/NxzVVHvU/9xxZbx/MlkTbVfn3rBJ4MDq0JddWsREUShPRWFF5Ld4IS/z07eDIc8tljYXADDP7nwAe707xUElqjHfUho64cTZt6nhBRt4gHspo9ocKmyWPOKbg84/9y92XpIk3rf+uYdB08mBBMR7m2N2xBcin/oyqGoQXTzkG7nmeQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(6512007)(7416002)(6666004)(26005)(2906002)(6486002)(66946007)(66476007)(66556008)(8676002)(1076003)(6506007)(478600001)(38350700002)(38100700002)(186003)(5660300002)(2616005)(956004)(36756003)(86362001)(316002)(52116002)(83380400001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GFkxElV3+YJsxzM8ogr0inWDUOgm3jq4r9vZ4Z1Ahhg2RWb5GGN+mQiSJN1m?=
 =?us-ascii?Q?ZJZVHtYmqDSvIxsDDjDVKYwxWHyT/Tx+2D0cq+DINiWutOTiwJ5HAhhE+483?=
 =?us-ascii?Q?IMuftSs6sbf1tFXe8d4GZ8Bs3KHgSPLYG40+trxdkIohBurVtDG8s07s1/LK?=
 =?us-ascii?Q?EVXbzbQ/RxMVEJ5+j99PaprUlccMS5i7f+/e3YVF7yO5yOPL/xgPx3qhbvkI?=
 =?us-ascii?Q?jyK1ZXTTMTi7HxYwRav5EZADIMoQDBPRUZibbO8cD8C/9csedKomG7KTRs30?=
 =?us-ascii?Q?yOKqFWVZ4hHIjYLUOAFL5bcN06qMrAUOcCYP/yl96fIX/Q/HgXDYOAoVb5hD?=
 =?us-ascii?Q?iaR41u2hiyfMXmc/eFkeWQbDAuoTttO5cHAn8Ru0ocJ0bI0Vni+RFC21E4C/?=
 =?us-ascii?Q?fCZPoUT6UV74h0xMqajyQUSVvoe95/OwL7LZxvsg+OtGVxfCbJk3JZOsxNea?=
 =?us-ascii?Q?Oo1PiCQOx0kqhqyn2vswjqlKxl7hykIipJWozlYItGtNUK/Ji1pn5ZQuIkd1?=
 =?us-ascii?Q?msCCls8A5tASnjQ07hKW4BAZAQ3lyIQpdkJjuSRyyXhzAu6qkS0eZpMP41VL?=
 =?us-ascii?Q?eb28ExsFFSvoTHSV4n98v+jUOpf7Y/Eo5tXtVFWTbv+4A4SvdO218GnIq+LB?=
 =?us-ascii?Q?jGZDz0egAMKdWiLPEMSscF/xddri/lHaF4zDlH9tGYlhlOFZeIS8ICo89Wvb?=
 =?us-ascii?Q?vYBDmfleR663gkpdBkv4Nbdy3lCxcW1T7yzBguvadXpW+PRGBEyAyZMTE85W?=
 =?us-ascii?Q?GpwhrDUdNPMRX+cWOGQPUlhg0IbVa4voSOR0Uri8Xy++GhDiWpz9gvq8TSTc?=
 =?us-ascii?Q?w0rjdtyGStqtdMI+eWHhFEWeWliZP/8jm/VTVFiY5dKrZZPvnBNnkMdz5U7J?=
 =?us-ascii?Q?oAe7ClSOJqH0dcR5ESXf9p31VN6LmaHMH3kSkyliHv73veYxzQz4LASwBSsw?=
 =?us-ascii?Q?BL75nW6xpl5WKZYwDk2stDPvackPRgTerROyZGZVIfdC98nJuEJQwdwY3Fo6?=
 =?us-ascii?Q?IwdMO2so2kfw3/fZ/Km7Bj5CKR+H9BlTwxZHyTP21YGVCIl9/stnIe3AiKYM?=
 =?us-ascii?Q?QNzQCrT13bWiXAlQNOQNKCQP8iamVEBgPC5j36rB2E3kcTbJL49NH7ZFnyBK?=
 =?us-ascii?Q?6WTSexSbXRPq2butGZMK8tV5cebXrVMl1lMBgiuAdYvcNtGB4hbs93W331Uo?=
 =?us-ascii?Q?h40cgKS7Mp8/0/K3zIm8MhQpICJ901xhVf2U77mJ+7G3YfYOJ7JigPc8FNUG?=
 =?us-ascii?Q?afwpOqNgiBNejiVExVxTmQE3cJ9AcpKyLNOssEWOhT22U+etA2LVhVwhhecE?=
 =?us-ascii?Q?YmUdre/IetPfFQSxSL+GeUFF?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9af0d501-ca30-4610-511c-08d951be22fe
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:52:12.4136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8vbzmMaVZlypADU2iiEClb14FvxCxi4KRXBbvwnCPChVz/Kw/7Q2U4jZZEvVOB7ZPi4WuR2+Mirs7uQIoYLug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
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
 drivers/net/ethernet/freescale/fec.h      |  6 +++++
 drivers/net/ethernet/freescale/fec_main.c | 27 +++++++++++++++++++++++
 2 files changed, 33 insertions(+)

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
index f13a9da180a2..40ea318d7396 100644
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
@@ -3704,6 +3719,7 @@ fec_probe(struct platform_device *pdev)
 	char irq_name[8];
 	int irq_cnt;
 	struct fec_devinfo *dev_info;
+	u32 rgmii_delay;
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3761,6 +3777,12 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_stop_mode;
 
+	/* For rgmii internal delay, valid values are 0ps and 2000ps */
+	if (of_property_read_u32(np, "tx-internal-delay-ps", &rgmii_delay))
+		fep->rgmii_txc_dly = true;
+	if (of_property_read_u32(np, "rx-internal-delay-ps", &rgmii_delay))
+		fep->rgmii_rxc_dly = true;
+
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3812,6 +3834,11 @@ fec_probe(struct platform_device *pdev)
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

