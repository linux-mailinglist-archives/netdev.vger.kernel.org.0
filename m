Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0D616D25C1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 18:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231661AbjCaQgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 12:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjCaQfq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 12:35:46 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372032B0D9;
        Fri, 31 Mar 2023 09:32:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XC+bWzJheY6fLsXN3i/jkUoWhFh/c2e62lvwGqbR1VOJqJ9Rc6dKlF06Bv55JBpZJKoN7djF4W18THQZqWaxScMQOwXRXrKCe0mA26xSWR0lAcCHJtAv9aziGzPQKbM6QLS5finOdc38RXiH/gHp46+0iF5viQylASidcISmZ12FJi71wYOoBsOWMYMlpVeQQjTLlB4IqebUEOdaHmgeEo72pwTvdDjrCa5iYwTrL5lsyBt8ULTpyeBDOmZF27ZNFjYHEI9Fd941K7jqxJ9oiApBxEq9Z7DNRy1X/j5vXgbvEyKNCF9B/R7CiAyvWt8WOe+lyeGAWU7/XkHN1ElrEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yl/Nal0PpgBFmmyQJ3enEWiLymBs3mGdmq4D2SJEd18=;
 b=EWtmecqJNQTDIpGphJpj/71iR/WW4kzCFY18Cm3caERuN5JyIYon2bc53by/BXAwwYGJdBqGttl75r122HFiHKNzAn4uEJamSzq3mrQnVsgUo5ycOFEp9u/hHYhTTinizzqGkQlfZyHQa7ZxvCqUfxh5jbFD1+ffdh6SSWCClmg2AgyxUynlSnJ6Ve3uS1m/cyBttpo7ZGgi1Ct9igrohsiFHu1OhI00C3E4MDl6xlce154WXPMWL1TkeBvOrGAULJKS2CnCVJjMv7xD1JY7d3CjCrJPt01JeRfm0IbUC3CYynYdNwXV/W3cLku6vEoYUIf2M4v7yDB0T5zglkVhEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yl/Nal0PpgBFmmyQJ3enEWiLymBs3mGdmq4D2SJEd18=;
 b=cPPzTDKn0S3T9h3wN2rPPZ/5YMB68EoUUHPhDRjA+M7Kob/5wKUI4XQV+tLu7EXkBkiO6bXgOVDkCoSQzYaPT7FlFF1dE1vetQAOkT8xqlfNAeYACHm1nysF/0ov712eNzlQtFkNeTwdxoMytBHb4+vp3wN/+3hIzpBKGN5xBaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by VE1PR04MB7213.eurprd04.prod.outlook.com (2603:10a6:800:1b3::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 16:32:15 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 16:32:15 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, imx@lists.linux.dev
Subject: [PATCH v2 2/2] net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs
Date:   Fri, 31 Mar 2023 11:31:43 -0500
Message-Id: <20230331163143.52506-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230331163143.52506-1-shenwei.wang@nxp.com>
References: <20230331163143.52506-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0072.namprd03.prod.outlook.com
 (2603:10b6:a03:331::17) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|VE1PR04MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: 6085b80a-0fc0-42f9-5485-08db32057cb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KSngqAfrtdTNPxEGLcOv6rJjVinEGuUlZQwej9l4RgDEmE0MhD7F8bV02jtRZmTcRzWvZ1LSBt34c1lBOnM9aPlv/Lu9BPm4us23M7VSPl/RA+bgvzA9jPXmf1UHM6fa69GxLJhBxLJge1xFmRil29SCJzWeqy7DMAeRnDpuObPZJ2FLpf7PGdY0tYu/jYYLSehD+0o7wiuXFgyqC6QhjUgCq6mYGM+yOD/TP6gblvqLWUjOCxMUc6Fsrik0uWo6/4r2AtD+2WHohQlzW3YEyoVjwoNZWAA7/7hekKQHwvzvxVfeK5xWHtNtXI8UY4fMSa08g5+IhqtR7pIiK/dLc/NXzp9qqM3dQ4A8MI3LS1kTX0fJ4+LE7QTG2/j0ml5c80+buw+Z0RfbifdayuvKzbOfnaa2u95G5zyiEQEmUitsR+xGQQFlnRT7uMM34AMlSDjHsd2y1+OcbQFRyjKgtzlhqO5Qax5qrpdl5iXCXPDvO6DlytejyZB70e4beOUhiltnbtyAq8q/X5HnoSsr99JunrfqB+sHuvPuKMSnSsM3DVKINXr3U44nn776ldC5HMEGycJ54BA+mYg2sr/+DMMSngfw8c3o6SLOdK7HdCTJsKF2rANbjI/mXPAjBVae
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199021)(7416002)(44832011)(1076003)(2616005)(83380400001)(6666004)(86362001)(55236004)(6506007)(26005)(6512007)(38100700002)(38350700002)(186003)(8936002)(5660300002)(478600001)(41300700001)(66946007)(54906003)(6486002)(36756003)(8676002)(66476007)(110136005)(4326008)(52116002)(66556008)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ctEejenVZTfXBszv3jfNayeF+9GK52tYGydXY7fSet3KMP1/YZU5bVIRrV6r?=
 =?us-ascii?Q?5n8oW0Ugvb+CAfzE7VPqTxbU5UIXJOVuM3DyVoi2MIJgxRj0rCmhHfszS2wz?=
 =?us-ascii?Q?Za4YH2ViSS5RJ2QD8WeT9XN392RQ1DaB1tjqyWaKAPDs8DEZ6PfuisSF04kS?=
 =?us-ascii?Q?m85CHpGoSqIQwWdhuDM7ZrESOlzufCAlngUQL9Yde3lEArTpdqexJ/ihTUvV?=
 =?us-ascii?Q?MqVdi6SFiRwVnpWULFP3odu0uSnWeTmgkFIEcE3TzxuzaEbiMbLLOJuSJltl?=
 =?us-ascii?Q?voGH5TMu1817MXVJx7ChvYgPGTWR9HBGx+G52yEjcRmmoxTN3ZwJqYjsBcvW?=
 =?us-ascii?Q?7ffElldWzN3znmHBii7JzoOji/xQ+W8mOcyr5kEh6jsBPWjmDlmMeS2z4kIn?=
 =?us-ascii?Q?EWK/pzbNmfw62pmlNNo2XW1sm4OzDukt+uoFP8PEfymn3eBam2hi1grG3CuJ?=
 =?us-ascii?Q?ViiW/b6ttNEh02E2uOVaIDMFikITMbhguhVJlnqcbcRWoFlbauy3WkWK2gi+?=
 =?us-ascii?Q?zWU4OJamisDq80PG430MbxKmI/W/98yYMPG9Czqiqgf8k1EcOLatCUaLPLIF?=
 =?us-ascii?Q?Toq+rlcRfM3Cl5oaQnCdHg6yj51vFOKhQUlQF9FHSX8wATQDDkY8HUbuU/TV?=
 =?us-ascii?Q?fixPadlkAOenbkIVO9SaFYjMNmriiTixBQe46NQj5H9kQj+6tPu0Q3fdGpaI?=
 =?us-ascii?Q?i5G3R8Gg6uOFbUxglDOKBmOtHMZFC93pqmpgqW5clnfcHvgDy0L44o186fN5?=
 =?us-ascii?Q?FdZbOLahsbyq0sk8cjBjBVvksxGNows08/6tGxTQKvxwdWD6cU7Di3Y9u8Eh?=
 =?us-ascii?Q?nb7vWMiVfgDPsetz7/Cy7l20+GZDAiuuOnzNwfMDdOWE+yiHHxU/4SeiGhfF?=
 =?us-ascii?Q?uSzb9IrpIKkHvyEAc9hIGf+qtuX18zkQzUIYglhKosug9C+DPkfrM6dge5MR?=
 =?us-ascii?Q?WqtF8VecWDXZUZDo1PNCHaVslkbCYBc++APSUYezLc2JFR08k+tulGhL2FSm?=
 =?us-ascii?Q?FE8zCswj1ObMkZ/eHv84nlw4lBuedVGW1F0NEhrPXRzYA46Otf1JFgBx/Zfy?=
 =?us-ascii?Q?hFTLtiBFN3yvSB/rlh4y5jmNvcDtzePpencD2b8od3w3hbcRZcO+Wmqc8dzH?=
 =?us-ascii?Q?bMaPdP2MaKfQ/Wi8h7mpn31dBTsQrmOMGnUQPil/EwT1A95W8V8WPt6z/1tq?=
 =?us-ascii?Q?EwU5LrnkX4jUDVsQ3SJ2Zt6X8sB/RaKHDEkBQ+WT9b6tTmh77KKbMpn0BgHK?=
 =?us-ascii?Q?1fGgSDUIUzKrGxIvyXwnQYUkEJWLtqDFlONXo37CgH3vch8jgnS5JL1Kghdb?=
 =?us-ascii?Q?UprPKu4dABX10mrqOU0E+3jCKvi30FC/PupDGK2I4eNHpGBaV0nvMiCJkavW?=
 =?us-ascii?Q?+bk/Jj+6T1IiJ7aDCtY99vFctOQYtrhbZkn1DcTqQfXQfF/Vp7G2m1zszx/7?=
 =?us-ascii?Q?mcgsfLzOIhyjLAw0Crq4EdTY3FMHHiOIRE3Hl3Kdwq8ViBZf0UqNE5mXW7x4?=
 =?us-ascii?Q?4nfbJb7zQrf8c3Px+/Wc1z3KCLaUlsCsu0Fb4wp7ZMN/7gepOtaPSvYEZ2im?=
 =?us-ascii?Q?tfqDfIWq+ex1nAzueVVOUdcskwKUEx19hrzLfwZE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6085b80a-0fc0-42f9-5485-08db32057cb7
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 16:32:15.8120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a260/fwpc5w+ble64BZURkjSbqKqiAo8Ol76SpVZQKDRgNsVMlt6biV2E0cnfJpV0Y8Bu3DYGKVtH51f6A2pqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7213
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch addresses an issue with the reset logic on the i.MX93 SoC, which
requires configuration of the correct interface speed under RMII mode to
complete the reset. The patch implements a fix_soc_reset function and uses
it specifically for the i.MX93 SoCs.

Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index ac8580f501e2..3329150010ce 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -19,9 +19,9 @@
 #include <linux/pm_wakeirq.h>
 #include <linux/regmap.h>
 #include <linux/slab.h>
-#include <linux/stmmac.h>
 
 #include "stmmac_platform.h"
+#include "common.h"
 
 #define GPR_ENET_QOS_INTF_MODE_MASK	GENMASK(21, 16)
 #define GPR_ENET_QOS_INTF_SEL_MII	(0x0 << 16)
@@ -37,6 +37,10 @@
 #define MX93_GPR_ENET_QOS_INTF_SEL_RGMII	(0x1 << 1)
 #define MX93_GPR_ENET_QOS_CLK_GEN_EN		(0x1 << 0)
 
+#define DMA_BUS_MODE			0x00001000
+#define DMA_BUS_MODE_SFT_RESET		(0x1 << 0)
+#define RMII_RESET_SPEED		(0x3 << 14)
+
 struct imx_dwmac_ops {
 	u32 addr_width;
 	bool mac_rgmii_txclk_auto_adj;
@@ -207,6 +211,24 @@ static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
 		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
 }
 
+static int imx_dwmac_mx93_reset(void *priv, void __iomem *ioaddr)
+{
+	struct plat_stmmacenet_data *plat_dat = priv;
+	u32 value = readl(ioaddr + DMA_BUS_MODE);
+
+	/* DMA SW reset */
+	value |= DMA_BUS_MODE_SFT_RESET;
+	writel(value, ioaddr + DMA_BUS_MODE);
+
+	usleep_range(100, 200);
+	if (plat_dat->interface == PHY_INTERFACE_MODE_RMII)
+		writel(RMII_RESET_SPEED, ioaddr + MAC_CTRL_REG);
+
+	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+				 !(value & DMA_BUS_MODE_SFT_RESET),
+				 10000, 1000000);
+}
+
 static int
 imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 {
@@ -305,6 +327,9 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_dwmac_init;
 
+	if (of_machine_is_compatible("fsl,imx93"))
+		dwmac->plat_dat->fix_soc_reset = imx_dwmac_mx93_reset;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto err_drv_probe;
-- 
2.34.1

