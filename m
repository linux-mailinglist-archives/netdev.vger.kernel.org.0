Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF4DE3DB807
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 13:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238659AbhG3Lrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 07:47:52 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:19214
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230353AbhG3Lrv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 07:47:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3ihI3JR9rdVUa+b0VhH8Wu60htwNYmueTif6TnvmB7NJNc+03fqNZh6nUFxtlG8arcDocUtagUtdsRy66TWK3kO0rVBpL54EQU4nNSTcr1hyp5lfXKzgYeSvBJYoZd7N/brTgJaJYpq8v0ZtxRYLYFhrzHD8FlhB4GynKXQvHsxLITCaZR3p988XenLIMY/2SCH6ErK+2Gj8nzoLaNTjeOQTd9rBu5u0TvQNKwz+x+ruAI/aOToSoqjb64uV86/sCmUp90gA9vMaONlCYDKtaGPDC7ZxysPfS7hWJp2YR7wOBLIMvJ0Y9m4G8QAXtT7erkPwcXB3lHMrmLYItEXdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPWOohLkv221xv5qWRexntRBDcYzyOERKfBoKhN0FKQ=;
 b=hOSjxHIqX+kr/IujbL6utSBzjXhi3procwP/AX70cG+nK+EMr//OhcIoqSk+Vpi/oCNxUaAhcwUDvHfE4Zk3U2/ZXik/ZqFqQdrYe+oegaNG0TvGSUosIcF+pyj0cBK1FmPf9Kuq0UrW5a9NhZ0JE87DhKFhNP1b4CufYzT1D15QYc9NcVgAiwyttGKDwv59rCkBz2SG1nzIF2SzDc1tdDVXwv654MP48hVmKLo6TnsItf2pm6Kt0qRCrXowhId/P4KZ4Cm/UjQjeHZ7z6fbFUy9zBmm32LbEhJdeuhtWwbtFYs0CpqFzdmz/uHwpb2ENdvvqFOaw5Vgl2HTCrfaNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VPWOohLkv221xv5qWRexntRBDcYzyOERKfBoKhN0FKQ=;
 b=Tcaz31xdos9SWfb8p+wWOdrs4wZgIr+cJf1Te0Pr0dW+QDwSamT62WNPuTbAEtTBDx+Vw0kJ0K8fC5VOZGKLS8DZpyWLzFKx6EUfl+127IH8LIreEX32g04+THaUKgG5Kx/c79abgA450QQBshHoP+HPFrLZib+BxkbcNZ2R0Dk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7400.eurprd04.prod.outlook.com (2603:10a6:10:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.31; Fri, 30 Jul
 2021 11:47:44 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 11:47:44 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: fec: fix MAC internal delay doesn't work
Date:   Fri, 30 Jul 2021 19:47:09 +0800
Message-Id: <20210730114709.12385-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::10)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.3 via Frontend Transport; Fri, 30 Jul 2021 11:47:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e39c8271-eaa9-4b49-dbca-08d9534fd7fe
X-MS-TrafficTypeDiagnostic: DBAPR04MB7400:
X-Microsoft-Antispam-PRVS: <DBAPR04MB740038FD6936A12E07BCA6B8E6EC9@DBAPR04MB7400.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hw4ubdVgNAR5+/B0XB1IxCXKlh0JTQkHWOmzQHdrJpixUPIcmgiJxOmQJZhnZepa/qaoN6/FI05Lt/Or7Vy07fB8xelmHJWQCGKYwLt9sYBsSWrxBjNuYO6JbYE6de42ZEutmfAeVL4IbM7a5KO7gMlTPl55mSPzVn16Fs9vKFy2XzpQ0ebXqVGdmbev/VHGA++h9T4uKIF5xC8D/U8JpY0PfI1W+KsY2thdNNtsTNKQbf2P3cG5hiTLlg48i5Skwr5t0Xl966K8zJY9BlAPobajX41UGYZmj03eZ+YSC1+d6tvNtPx+6qPxV+AqUJ84ZedZtb9rn/cCG40/Jnijlhz0JPFbJdKLhd4adJcrePgtt7QIClUi1tigktgcxmmjQp5bga7LFIikrgAh5bVf028qwlX1x7Skii2DMvRowCLXHUDqxDjHQzmrmvpU1h4Gexa01gJYii39gY7O2osJdhfcngufuCYLZv4sHhaqAakBCS1qjW4dnAI917p/hbcq2+qDlyJN0/bIdj8Qf1cLCGybGtSE9O6vIhX/2uUD/GCX2VOTQ1CKpPYbZH8czYmc9Wnlrw5A4WETFPF+jqXz9fUFJjcNSLFo3GjU+i6nuqmLULMfX0lZzMTpLVm6hgvmq16QGHYCSC456bm2g5x69BzFCMx2lF/QLkWdZk3Dv8a54wpsp0jUfi2xiFydXBWyuD8yJfyzb1u5kdOxICuXVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39850400004)(346002)(376002)(956004)(5660300002)(26005)(86362001)(6666004)(6506007)(66556008)(66946007)(66476007)(83380400001)(186003)(8676002)(38350700002)(1076003)(2616005)(2906002)(478600001)(52116002)(36756003)(38100700002)(316002)(6486002)(8936002)(6512007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FpM23rdgIJLKDq8+H498ekgJ7x2XohI9Joc/ObihHK5Sv83CH67r0wFBaxBW?=
 =?us-ascii?Q?PS1FGXylWVk12MNDnQEIaVYP9XCwLh+n9Hu71NW9nu2/Yj/UVeq1+fzAXuoN?=
 =?us-ascii?Q?fjQXNmEt6Q4vZ1bPbAxSeHoM2Gc4u4KrkzMgn4EiCp6OzKD/6Ee0BDPtPN2+?=
 =?us-ascii?Q?7okTLpzXeO556USDRCYZ0TTbN9PpfrvVH2RFNxZxfscgZTVng/ldZkNUUXL7?=
 =?us-ascii?Q?w8kJWKFo2+kpiJVQhRVfAVnrfRir36cGujZeTUD7hCwpNZSauiZrzQIqe8Mm?=
 =?us-ascii?Q?EuTtSLrJWNDzZAyNXdcZrYzofLnIxfaJJURDuNhXMkWO7y08e30xops+e0t4?=
 =?us-ascii?Q?rGDNQ5K5xPwXEq3Mzcw0+VGxlQh68m3jHcb+GHvTwR42wFvCVnt0TVOt3E6v?=
 =?us-ascii?Q?zfiPngkwhKoAd081HqKhZ3/RcglWaSMrse39o7f9zu/r+GSLaewq/vF4QMHr?=
 =?us-ascii?Q?4zQCiSdPDD87Rw4kqabRE4ornBtCWdcGBhZzznIZIzOyJbCfieuSU3NdGwP+?=
 =?us-ascii?Q?p1VjIj3AmCvjM9jHnjmxLscal00ZHLF4hgvGtJp0io3TwjVcSPOkTg/4m3/y?=
 =?us-ascii?Q?0cqDCoWZ5fqJGddrcM8iy5VTzRm3uQJpLhAEex48ig30TJ/rUKZlXv+jxsRZ?=
 =?us-ascii?Q?UbCEK//FIqYaaYVixfcauJYE7Z7o4f5V39djRNhWgJzA6sPkh6uPa7fS0SwE?=
 =?us-ascii?Q?7yZ/Z9ntM2yw0QJyQd3RY5EY6YeiGVIpUnRgXaBBUVG+6BGJHjxAZa7a+CEx?=
 =?us-ascii?Q?v4VVdkMZCbtVhUDD8LJmA4hOzOFxOxAjjTRYeZMML348vR4OQewiEGGxmDnk?=
 =?us-ascii?Q?4B1bFneYD7UiUYtWZI18g6op5RLEnHH0w30+KzJOC7sGnwMecwMPoECtT69c?=
 =?us-ascii?Q?DF9uazAURwE9hkzvO4q6+6X5Gn0Am6S+mGNPVAWCy45Mlb9c1yKDMOXpjDVJ?=
 =?us-ascii?Q?AptfG13TCJR8tlcN81guf4JHR8ylZsGcva1W7NnO49T0bopUh9p068PM1eqH?=
 =?us-ascii?Q?l4BCNQt/qFuS8QD94JG9blK0amK9ocD5S3Jj99cOo6s08LiE1dCfp+uzF4+A?=
 =?us-ascii?Q?fRuv3w//vSq9PjhJ3E4aGg1okQdAZgPFI2Wzf3cm454hRiHx4U/k/qqIVNr3?=
 =?us-ascii?Q?t02yliXDEoSb+agKCPJDME1CPh1+VpvhtvzSlXm5d6iIFxKpkdJnooWouk7r?=
 =?us-ascii?Q?3t/aI2MyuLY9d6v3nQYsOYV1g7Ho444OYRccdofpIOTD2m8UL4cdPZAhzJKu?=
 =?us-ascii?Q?N1aAkoRGqFzw1uzq9loRKDCgwzMb38OuH7Qr3CdKTHruZZm9wb70+UxMuUKS?=
 =?us-ascii?Q?cj2LvZS4b0MKMzkY0GzpTcDc?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e39c8271-eaa9-4b49-dbca-08d9534fd7fe
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 11:47:44.3261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i1oJoVcuBH7BOX0si4MaokMAKUm/lLZopNu1EXPfHkfQVm4pz0ETi0GJfL2ekGRyp2HUTtIZ9UbucRFNjo/iBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7400
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to fix MAC internal delay doesn't work, due to use
of_property_read_u32() incorrectly, and improve this feature a bit:
1) check the delay value if valid.
2) only enable "enet_2x_txclk" clock when require MAC internal delay.

Fixes: fc539459e900 ("net: fec: add MAC internal delayed clock feature support")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
Hi Andrew,

This fix targes to net-next as this is where the offending patch was applied.

When refine Andy Duan's patch to generic MAC internal delay property, I
did make a mistake, and didn't find it during test on i.MX8MM, since the
lack of chips which support this feature at my side. I am so sorry about this.
Please help review if there is some flaw in the logic.

Joakim
---
 drivers/net/ethernet/freescale/fec_main.c | 47 ++++++++++++++++++-----
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 40ea318d7396..a9b889bf375a 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2042,6 +2042,34 @@ static int fec_enet_clk_enable(struct net_device *ndev, bool enable)
 	return ret;
 }
 
+static int fec_enet_parse_rgmii_delay(struct fec_enet_private *fep,
+				      struct device_node *np)
+{
+	u32 rgmii_tx_delay, rgmii_rx_delay;
+
+	/* For rgmii tx internal delay, valid values are 0ps and 2000ps */
+	if (!of_property_read_u32(np, "tx-internal-delay-ps", &rgmii_tx_delay)) {
+		if (rgmii_tx_delay != 0 && rgmii_tx_delay != 2000) {
+			dev_err(&fep->pdev->dev, "The only allowed RGMII TX delay values are: 0ps, 2000ps");
+			return -EINVAL;
+		} else if (rgmii_tx_delay == 2000) {
+			fep->rgmii_txc_dly = true;
+		}
+	}
+
+	/* For rgmii rx internal delay, valid values are 0ps and 2000ps */
+	if (!of_property_read_u32(np, "rx-internal-delay-ps", &rgmii_rx_delay)) {
+		if (rgmii_rx_delay != 0 && rgmii_rx_delay != 2000) {
+			dev_err(&fep->pdev->dev, "The only allowed RGMII RX delay values are: 0ps, 2000ps");
+			return -EINVAL;
+		} else if (rgmii_rx_delay == 2000) {
+			fep->rgmii_rxc_dly = true;
+		}
+	}
+
+	return 0;
+}
+
 static int fec_enet_mii_probe(struct net_device *ndev)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
@@ -3719,7 +3747,6 @@ fec_probe(struct platform_device *pdev)
 	char irq_name[8];
 	int irq_cnt;
 	struct fec_devinfo *dev_info;
-	u32 rgmii_delay;
 
 	fec_enet_get_queue_num(pdev, &num_tx_qs, &num_rx_qs);
 
@@ -3777,12 +3804,6 @@ fec_probe(struct platform_device *pdev)
 	if (ret)
 		goto failed_stop_mode;
 
-	/* For rgmii internal delay, valid values are 0ps and 2000ps */
-	if (of_property_read_u32(np, "tx-internal-delay-ps", &rgmii_delay))
-		fep->rgmii_txc_dly = true;
-	if (of_property_read_u32(np, "rx-internal-delay-ps", &rgmii_delay))
-		fep->rgmii_rxc_dly = true;
-
 	phy_node = of_parse_phandle(np, "phy-handle", 0);
 	if (!phy_node && of_phy_is_fixed_link(np)) {
 		ret = of_phy_register_fixed_link(np);
@@ -3806,6 +3827,10 @@ fec_probe(struct platform_device *pdev)
 		fep->phy_interface = interface;
 	}
 
+	ret = fec_enet_parse_rgmii_delay(fep, np);
+	if (ret)
+		goto failed_phy;
+
 	fep->clk_ipg = devm_clk_get(&pdev->dev, "ipg");
 	if (IS_ERR(fep->clk_ipg)) {
 		ret = PTR_ERR(fep->clk_ipg);
@@ -3835,9 +3860,11 @@ fec_probe(struct platform_device *pdev)
 	fep->clk_ref_rate = clk_get_rate(fep->clk_ref);
 
 	/* clk_2x_txclk is optional, depends on board */
-	fep->clk_2x_txclk = devm_clk_get(&pdev->dev, "enet_2x_txclk");
-	if (IS_ERR(fep->clk_2x_txclk))
-		fep->clk_2x_txclk = NULL;
+	if (fep->rgmii_txc_dly || fep->rgmii_rxc_dly) {
+		fep->clk_2x_txclk = devm_clk_get(&pdev->dev, "enet_2x_txclk");
+		if (IS_ERR(fep->clk_2x_txclk))
+			fep->clk_2x_txclk = NULL;
+	}
 
 	fep->bufdesc_ex = fep->quirks & FEC_QUIRK_HAS_BUFDESC_EX;
 	fep->clk_ptp = devm_clk_get(&pdev->dev, "ptp");
-- 
2.17.1

