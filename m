Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E116D29B2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 22:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231800AbjCaU6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 16:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjCaU6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 16:58:23 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2069.outbound.protection.outlook.com [40.107.21.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C6F51D2E3
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 13:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BNfgOClrHtGH0t9JV799dvDv8OkgtWZw3hlMInnbFTOeIa2+xmgQML+iqPQLQ0eytg6U4WNPRJUJK7hbPFqnD07lFrwCGjF77di6AYuHGKX1MFNBhOeSqizaD2W7/jpA65N3cGbz+guUS8263CJkYWbaqy8KgAgzJ/X1WqoCX3jslFeItPc9uC7oykPry1FG/AT9JuG7ZCnuMV59l3hUn0jjGP/czXKHky5elqYxeavz3xC8K78TlU6wNCYhjtcdmZk2FklsENyFE4xZbiJznDxTpSMyGl5hwsq7xZSdC1u0b6lKGoOi+lE1N6OAz2s5tmqnD26b7lV/7Iw7swv2Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uyE2AZb903607mUK4FwgjrGfuWZxuVGFt4Iogqlv+/E=;
 b=BU+SrvbOYAyt9p2JFI8D9Xlw7T7+2wB/6MFFq78mEsMM9olfNKWTiNeCoIBc8Q0RiJB8ZX/GUQrplKzHrPoGeVjrQNqM8SJAbAEgGBeoaV+YRyHoIvbkKCWc1ch5dZ9gtpBruuFbGAycR1rKU+hQvRX8FRcMDrjuSx8tiMLyUR3UPPCkf2951qofZ7A00lHWrQsfgE4KkDgiWe3qqk8hIAdORSeVd3HBxJi2nwmF05c7F2cWK7i57JdsQdELdFqaQerUBZDXEHnQNmR1eoAut/Tej4yCyh8jK2kJGa5MEiZ960W9AHYMy80ELd+KpjfEEm1MtEJwyCwYOHGJTpG48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uyE2AZb903607mUK4FwgjrGfuWZxuVGFt4Iogqlv+/E=;
 b=d4Pp4WyazKJPLa+s92wv80/p329+/OX4omoKjFBGPG5fKCScolavsXZc9/L9lXR62dazmiY4bpyiqkXoGu1R4/sP38MQlWePM6hw9CNDFcz/AfBPGvafinVlv+nnlaG6CQ3/dT6ZJPGpoEEvFdeQrAgUbRb/wACVKLixbtO2rT0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8205.eurprd04.prod.outlook.com (2603:10a6:102:1c2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.21; Fri, 31 Mar
 2023 20:58:19 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 20:58:19 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev
Subject: [PATCH v3 2/2] net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs
Date:   Fri, 31 Mar 2023 15:57:59 -0500
Message-Id: <20230331205759.92309-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230331205759.92309-1-shenwei.wang@nxp.com>
References: <20230331205759.92309-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0008.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::21) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|PAXPR04MB8205:EE_
X-MS-Office365-Filtering-Correlation-Id: bbc046c4-5c38-455b-6eea-08db322aa81a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGndzs+DvrghLn95gqlTRbSLmZ6tI3b9F7DkNzG/yMO8WULk2e3kso6wgAsef7JXmcwG5PFM/I+6kS4lLYKzAQPL548pJ7Lfous/1Re3W+ibFfXVLjXtfm8ctul3GdjG20/5ep+N5EJulsrmQ5AI7KseAv5tHRI/+EgMX4wnp6vsqYYCjty0xzariMp9kGLZJTW173C7JLJiSo4ocZsW8CkL8yV2kIbJZsniLCXoCaGvDn56RmAnIHUY/lkpCY4arNyPEomMJvo6MxgCuO+eAA8Dm6gDp5e0AxMpnHyNyL0ZzG65MifGfD+T1wMR65LIb3kuJKPY9WYfwzEu/No9ACRI8cOpjvI2NupjYLX8OdQ7X1ajNUgWp/45RmWsrH3HV017W5jEB6ItlWcfOBMTzsxIEtHGWtUfx6+wo9jr+9IdnLV3ej6P3i95fowmSGDK5DfvB4DpfuE6ytrGD+igtJTKM5FF0eLSjWOACr31zEQWjB0dulMWQpDoE5LclgLsgwsPAUVKnzYVDBIJBloWHHVQ2AEqXuXM3bLWnDqLjX355/BMH0xVc0HIGQjuzg1ZZQWTPiCpeGvMFxy4P4Z6RkH/4dxGdq0+52oQ6mRE/S/XhStzlhwvwJVKZF8xsHhy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(2616005)(478600001)(83380400001)(6486002)(52116002)(186003)(110136005)(55236004)(6666004)(26005)(54906003)(1076003)(6512007)(6506007)(316002)(8936002)(41300700001)(38350700002)(4326008)(66946007)(44832011)(66476007)(5660300002)(66556008)(38100700002)(7416002)(8676002)(2906002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+/3naZUJ3hnXfoKlED2fgJy8rmK06yNAkc8rzzGBKEiIKoPZQLpIjfpW0TCy?=
 =?us-ascii?Q?CTiHKH5N2I+wh+J+tlhynBFbai3NgXBrU6HuprnXwNnbeUWEGlSgXPwkEr+g?=
 =?us-ascii?Q?TlexqD+hVhTfwL+IPawY7Z+JsjiEl7Hk5nhv32GXdtDDe88Txn7vfxU8BH14?=
 =?us-ascii?Q?jTYifS+UKMmvCwBBNQnKF++u0lV90LmhDn6Q4uiMW9w9yM1uSJRDq4tvVQWd?=
 =?us-ascii?Q?1E9Caf4XsGw2g3+ORDmna9MIuOUPvUWkArtcs1sDO+pUqCLrvVEN0+z5byMN?=
 =?us-ascii?Q?jcgMszCr7wJEhtvULKsxtXUfrXpfjpPgym3MMgN1r08YfdrgOZpx+8qASlI0?=
 =?us-ascii?Q?cWFkPtnwrt2QoDxro3Nz9FSPTng49GVkUm7SB6vq4pucElRLhYiDGoVwhgTT?=
 =?us-ascii?Q?xVVYqX4Nj6o2xW+/fWntPeaxFiF3ukosBf3EAZX3AKt6hK9eNAhVs0aWBCXv?=
 =?us-ascii?Q?tkss5k0d+vl6jwmOyEe6uxCdgj3HEwAVWlHcD6myHUJafV76gZ1GUo6XDAKN?=
 =?us-ascii?Q?1XYQuB2O273D0RGxC+EmrET/SMtyehRJZroMHydzVZote2D3NouBHdoHW/fY?=
 =?us-ascii?Q?Zlbk74WkF+qyMvwHQ8Z+OaL7P314My469UwmBJsa3uMbEqOJ3gd2zKR5IYd+?=
 =?us-ascii?Q?/8ojsZ1PiVZ6TJhP2XaCjKKyB7bJ6vwGIyyg9tB257X94Xu2cEFyDPydhLKb?=
 =?us-ascii?Q?Fsa3pNyZlZOUJ28kXRzw3fTNdiR9HmN3vAxhJHDyaUdDTYeKY9GT58qMqVyi?=
 =?us-ascii?Q?msAyJuOQuMnPYlUDCwzwFXv2B2gl8e9kOHlIIA9jfpcYPEGzxh1SjVbgWG/j?=
 =?us-ascii?Q?Rll66pecQeTAvAdJBVCRLed1nItLZhMGlMoVl6n1x2C5LbFTm5Trubu9AZAe?=
 =?us-ascii?Q?FgTRdxIFxbZvOrGZy2OneeFGQW4ix23PoyUBYqpBhye05gD0lfLAW9ZoS8N2?=
 =?us-ascii?Q?r+z/g06NsJgF4M7/tyjVZYC//SomSSjJI5D9NZX/9dRJ0XTWhAKXSOzgTDIa?=
 =?us-ascii?Q?RKsnpBBMJ/LBNFFBSLbkADcQR+f6xLk9AFA7ZrE0FTt045Cms3NW3SsFteCu?=
 =?us-ascii?Q?locRX3XnxkC5uayNGRED0luA5Jk5RoAsKiLjWSmM673MRxZLs+zxrc0mqHdE?=
 =?us-ascii?Q?YG5SwXK2r3NllpseVt9atnHnyLGk3UIldJdNPbxyIvP6qmcwjQZzNOwqlbv5?=
 =?us-ascii?Q?6ruFut8A/Ah9E1DQx9bkSc9PB/3J2Jap7kgR72qaoIpbSSwdEQDc+ECYjrt6?=
 =?us-ascii?Q?kK35jEXv4KNLKvTyFlhmGjO/A5bJV0y3wEX4xYm5mLVpdDpfPsWqqcDJI3Fm?=
 =?us-ascii?Q?H2nhr/WXeq2Wq4nt14VReIiV2uhd5aDx2kAQAhObyBAUcBhLWlMqxVpWdmTS?=
 =?us-ascii?Q?AOAHkKVnFsT6Yp9vVi3I/q+W15FeOZo3utuSplmYhc7BM2lcEpgtiTaIvBXl?=
 =?us-ascii?Q?Gpetg7TvJ9VqDJFCIvZkoHXcvizoLOO4OtOKSGX2vJTBatIxnaNIAcplL53Q?=
 =?us-ascii?Q?Mfn7yWG952XaLHI0H56XIp32e78ReFsfDlQTovm7MA4+py7AEa7KZGxA5AqZ?=
 =?us-ascii?Q?vS6DJjFz22Bbeo6Mp2swDYkTuICdy662jv9ytSo7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc046c4-5c38-455b-6eea-08db322aa81a
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 20:58:19.6812
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mk0025b8QZ2t+KEnMZ5onnein/G9QAhE9HEToFZENf/nRZ/iAR9Zid8fsswURVjzs4AwA15Kwgiabw7qIccegQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8205
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
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
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 29 ++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index ac8580f501e2..3dfd13840535 100644
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
@@ -37,10 +37,15 @@
 #define MX93_GPR_ENET_QOS_INTF_SEL_RGMII	(0x1 << 1)
 #define MX93_GPR_ENET_QOS_CLK_GEN_EN		(0x1 << 0)
 
+#define DMA_BUS_MODE			0x00001000
+#define DMA_BUS_MODE_SFT_RESET		(0x1 << 0)
+#define RMII_RESET_SPEED		(0x3 << 14)
+
 struct imx_dwmac_ops {
 	u32 addr_width;
 	bool mac_rgmii_txclk_auto_adj;
 
+	int (*fix_soc_reset)(void *priv, void __iomem *ioaddr);
 	int (*set_intf_mode)(struct plat_stmmacenet_data *plat_dat);
 };
 
@@ -207,6 +212,25 @@ static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
 		dev_err(dwmac->dev, "failed to set tx rate %lu\n", rate);
 }
 
+static int imx_dwmac_mx93_reset(void *priv, void __iomem *ioaddr)
+{
+	u32 value = readl(ioaddr + DMA_BUS_MODE);
+	struct plat_stmmacenet_data *plat_dat = priv;
+
+	/* DMA SW reset */
+	value |= DMA_BUS_MODE_SFT_RESET;
+	writel(value, ioaddr + DMA_BUS_MODE);
+
+	if (plat_dat->interface == PHY_INTERFACE_MODE_RMII) {
+		usleep_range(100, 200);
+		writel(RMII_RESET_SPEED, ioaddr + MAC_CTRL_REG);
+	}
+
+	return readl_poll_timeout(ioaddr + DMA_BUS_MODE, value,
+				 !(value & DMA_BUS_MODE_SFT_RESET),
+				 10000, 1000000);
+}
+
 static int
 imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 {
@@ -305,6 +329,8 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_dwmac_init;
 
+	dwmac->plat_dat->fix_soc_reset = dwmac->ops->fix_soc_reset;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto err_drv_probe;
@@ -338,6 +364,7 @@ static struct imx_dwmac_ops imx93_dwmac_data = {
 	.addr_width = 32,
 	.mac_rgmii_txclk_auto_adj = true,
 	.set_intf_mode = imx93_set_intf_mode,
+	.fix_soc_reset = imx_dwmac_mx93_reset,
 };
 
 static const struct of_device_id imx_dwmac_match[] = {
-- 
2.34.1

