Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630FD668A33
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 04:34:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbjAMDen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 22:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjAMDek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 22:34:40 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2040.outbound.protection.outlook.com [40.107.20.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11211A38A;
        Thu, 12 Jan 2023 19:34:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmL6EWnZOZSSS7dJCFKIDgBr3qthlvD+HxpD7/+UWAjrmdGsY6j16ss/kaP1N01L54rmsFQv10eO0jyKSFdLqxOAvFDz1twNj39VC540icpvXggtCjRIFehD8kYVQGChA61puzt7+g+wmtUVMaGUbIjj0Owwlq/+BcBX4MwOtaJibYTSLI1nzpjar5gIUkeTvoHAhQCB/QPjPkPwOM6ObBYVcnNkDBC1ka2UomRARTjDB3+faP+X1PtzftHfFdnDTjoaS1rfNCzzfR1Xzw1wSpdfhGifJDaOCLEHkx67dD0Cju7j+GbxWgPXd5YNUHcnmUpjhhLAqPHLLTsLZG5Glw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WfwlIPzxhBo4FftP1VTgL6Pxax6cnJ5Xpjbk9za5f/4=;
 b=QM/cXS207HtKerzKaUKSTq/JUMe41w11pr2IXWUNV9RSa2QQN/e0Y773TEiCTWAhvNBZGyGVRjkvRVA3M+8OyutmwkVppj/eOTzPpVxMBqZI+TIYMoQBJll/+3x3ol+nqcLm0otfqQm36WSe+KDHr/fbctypSt+hlv2U+29zjOFEbStr+YZyb7hEmu08sCwHIK7RBjmGiFp6Su5sFOwd8NPzUOG/o1B90bTZsY5pAj2bBn/nJF3rGhWiy9QK0dOwb0SryUWl1Bu6DTNsoeruOqEIMG4l7N7u6kkMFz5Nt0aLR1w1LIO1M3n3x9FYBtq/KY85RmzqozUyy/GXhwS6lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WfwlIPzxhBo4FftP1VTgL6Pxax6cnJ5Xpjbk9za5f/4=;
 b=myHOCtD/PQf3e3kxyDpuPeK1aZBDhGjX3J3+r1TPbw35XNbKjHwXGqTprvFkxKlm9AaHY+BiBoasUjp+0Q7khLIeEpHoENocnSSFoR15hUiBjI1O3o9qu52NZqrzR+VaU4BoZWfmdOK5ZuWC/RDSjyXMAoYLaIXh0bmGwpuhIaY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by AS8PR04MB8247.eurprd04.prod.outlook.com (2603:10a6:20b:3f2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Fri, 13 Jan
 2023 03:34:36 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::76a3:36aa:1144:616c%12]) with mapi id 15.20.5986.019; Fri, 13 Jan
 2023 03:34:36 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     wei.fang@nxp.com, shenwei.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, festevam@gmail.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com
Cc:     linux-imx@nxp.com, kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH V2 1/7] net: stmmac: add imx93 platform support
Date:   Fri, 13 Jan 2023 11:33:41 +0800
Message-Id: <20230113033347.264135-2-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113033347.264135-1-xiaoning.wang@nxp.com>
References: <20230113033347.264135-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|AS8PR04MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: a8f6d421-f85a-4018-2f49-08daf51717f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4RMFIewF9gCG60ud1eGc6u60wk9Nn+W2OgHHJsUY1xH2ixech+iNhwXxp1ygL1AExVY/AcGNtYadJpjmD/jkulwTK4wXLA+b+mvDcEXEBPzwZdqLl7AiI7MdFOEwYWngoVqmIaFpUjQs3QJZYUv4zjCfmy6g8RfRqKTIvdnGlv61R4+Vj0+lL25Cl1CLOGz9YQY+hGoSEml527zIR3/ECL0HtKjgbGnNAOYvb3RUyu8i/579azx0Ohk4b3/dmEtJDkeBh1lgqDCb4EPSEZLb8+JZIArddA5SA1/ihkpTK/kzBqRecYqCZbyH32D+19DCmq8SRAiem9vbRT8d/Zx/EK38+M7i4slWdRbwYMFZDaJxszFpFa6ppNdhNQvrFih/SHY8es0NxLxh2nrWsNXTPouKsE3mn3rdrXhL//9NjJS38TMK7tpo7Q/KEK0+aztqJl5JJqmarzzENOF5s4X8E36BGNEPQd9vu8+uFkx7HAkHtNSlgesxt4zjlhmv8ESVmi4EesrrM7SMIzueAn2Wo5f3rZFhuJaVPY/zSJtV42y2QXzGfA9rB6AhePNcYpsJ365Xb7LGjrecJhMNkViHLbFOHWQsrs+ACh7Vv0pOpnbQhvog7MgU9S1c2iv/f0Tn5h9hwFImaroU9i5jt46A/djtfVEZlhuUhoySfnJ6ooPdc8oNgJnzfsIU6QXKV8/A7F4KpzaQmyS8NmMBxzF4Fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(41300700001)(66556008)(8676002)(66476007)(66946007)(4326008)(5660300002)(7416002)(921005)(316002)(8936002)(2906002)(86362001)(38100700002)(478600001)(6486002)(36756003)(52116002)(38350700002)(6666004)(186003)(26005)(6506007)(1076003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HzDTkk2ZRwXAVfOKtDGkDjUkB2eHB4gkEEPX/g/lrZ01SV6RobSy/LJEqwmc?=
 =?us-ascii?Q?WvSdCU+eCV3KxlHrxQQHj8ppHJyhdUWx5yosvMBNVbB4JLzu/d+2m+fmi0HX?=
 =?us-ascii?Q?KzMogusn83x1lIXkOoGzO/Pfxjqv0KudoL+hf+fowR4Q1ZaYl9+PFgltddew?=
 =?us-ascii?Q?yVJXUTy9Gyi4bBIZW47RbcSznNyjOe2J2eHMHeKEHr9srRE8nYBVKY/Zdt4q?=
 =?us-ascii?Q?i37kxG1vase9HKlpD633k3y0jmhwpAs0whUOP5+5gfg+X8Awx2k4xkCAYpgl?=
 =?us-ascii?Q?CRQ/9PlygujQM78AObs99BjAZfvV6LM0qJAd/L6bvz1Wzg+DAu9EGmjmK4aY?=
 =?us-ascii?Q?NnHhLyZWLur3ep4DzE+8o4iI6fnpcp4DHwzKbe1Nlf32h5mvUR+pvYFbDunf?=
 =?us-ascii?Q?/wLM9GLVm989V72EBw+r0qNw/JaRQTb5Cfe4X5qOUuy4q0dY2BiATgYjO4dc?=
 =?us-ascii?Q?Q6cRRnFcQLZapP6fb4tA3M1ceXY+8FF8uLmXYdRbjgPNdSKaMY7DLIdp9Shs?=
 =?us-ascii?Q?4FYL5ZFHrEN+hgIyJmBNhEFIVL8cV/JfbmKK/mhc/9J1EN1pbD2RqU0upE5F?=
 =?us-ascii?Q?3l/HP8x4517c3P/4YnkGb5LXRhbGgbVr4uS92L6qES7amaqbFhCsPSSg0za0?=
 =?us-ascii?Q?uF4c2LAc4LSvGMBkKZfSZi9mohJc/GHNGIWf5Cb7d2IMNwO5TiejJL6rbXYz?=
 =?us-ascii?Q?ZuBGGbHybscEsVqm2KZBt/5v+Fzw7FChdOErH210Dp1sx94H9zSMZiJAxWsx?=
 =?us-ascii?Q?pan/otYA28F6iLaQsZSVgWQYntVaT1gsyrh5sLh2m3yRqqdCe788K5aZrLyk?=
 =?us-ascii?Q?2PZO5FYRUkh4OR/htouRpWJLfTQpQqNLYlBqEHZNopx1oKqsh8UinDIAKd/U?=
 =?us-ascii?Q?C+NzsXpA+hKnht7Dqwz0ayuMzg779CG3dWnXP2PhteMyPkOKEy/bCk4aMkmr?=
 =?us-ascii?Q?8P6CGbKkdL0RRyZUNVtyiOQPxWAY6W6BWLvl5NBouri43Fpwpa+r+U7xPXec?=
 =?us-ascii?Q?U2S4FOyh6cruX6wYhRGRs+i/LWyCSgln3G5Y/yQKbrAAoiCtXFFPs4LAxGZN?=
 =?us-ascii?Q?d+hNsaH58BclbWpwpSoTquNmRmOlEtfUBYuyHa08331u030JIczi3fFTwH3a?=
 =?us-ascii?Q?4Nmkjcgg489Mfmiqrk0CeLRIoA1Wq1tuv8urtWiGChl3TrcVk/bgJ+5TsPsf?=
 =?us-ascii?Q?bfmRrTLrasB7LCauKJQN18JIbTmI815BT/QNy4SA7DfQhwo79c3Jwe+dhjZl?=
 =?us-ascii?Q?y4g/CQbmYyat8LY1DaqHivDeHcZ6/i9ODAbc5Rn0pGnfpe14R15prqWQ5Ohg?=
 =?us-ascii?Q?1HTXydeFDclpISxkRYvh0FkumPHY/veKS3BQwjsr4ZNox29w+8lXOzBjP8I5?=
 =?us-ascii?Q?/b38DLTP/uVUM96Tgq3kGOEZa0Dxf4bfO3HrOzsmQGae2UdwWqNE7lA8B0ZY?=
 =?us-ascii?Q?4bBwBbMbknjcq73xYXDpE2qaopl/RzpRou4KdJ35JHpwoeoM05JsOsq7Cjn7?=
 =?us-ascii?Q?4rTIDWT4YiUnGJJIqWe2NVgbWy3zS7yu/xHUZWngAcRoL21+qZDFjEvkGE45?=
 =?us-ascii?Q?7EiZdtX68LBXDmm4gYcuYf5GrhXrht14IDvTIUG5?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8f6d421-f85a-4018-2f49-08daf51717f2
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 03:34:36.4115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y3c99ZvMjLuu17MO68m795ifGudu2sydDFjkOOlpGcGwmHA+NJV2hPGujlChPLEjc2ZFH56LAjWLTEntrYPXtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add imx93 platform support for dwmac-imx driver.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
V2 change:
 - change pr_debug() to dev_dbg()
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 55 +++++++++++++++++--
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index bd52fb7cf486..a7ea69d81c11 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -31,6 +31,12 @@
 #define GPR_ENET_QOS_CLK_TX_CLK_SEL	(0x1 << 20)
 #define GPR_ENET_QOS_RGMII_EN		(0x1 << 21)
 
+#define MX93_GPR_ENET_QOS_INTF_MODE_MASK	GENMASK(3, 0)
+#define MX93_GPR_ENET_QOS_INTF_SEL_MII		(0x0 << 1)
+#define MX93_GPR_ENET_QOS_INTF_SEL_RMII		(0x4 << 1)
+#define MX93_GPR_ENET_QOS_INTF_SEL_RGMII	(0x1 << 1)
+#define MX93_GPR_ENET_QOS_CLK_GEN_EN		(0x1 << 0)
+
 struct imx_dwmac_ops {
 	u32 addr_width;
 	bool mac_rgmii_txclk_auto_adj;
@@ -90,6 +96,35 @@ imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
 	return ret;
 }
 
+static int imx93_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
+{
+	struct imx_priv_data *dwmac = plat_dat->bsp_priv;
+	int val;
+
+	switch (plat_dat->interface) {
+	case PHY_INTERFACE_MODE_MII:
+		val = MX93_GPR_ENET_QOS_INTF_SEL_MII;
+		break;
+	case PHY_INTERFACE_MODE_RMII:
+		val = MX93_GPR_ENET_QOS_INTF_SEL_RMII;
+		break;
+	case PHY_INTERFACE_MODE_RGMII:
+	case PHY_INTERFACE_MODE_RGMII_ID:
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = MX93_GPR_ENET_QOS_INTF_SEL_RGMII;
+		break;
+	default:
+		dev_dbg(dwmac->dev, "imx dwmac doesn't support %d interface\n",
+			 plat_dat->interface);
+		return -EINVAL;
+	}
+
+	val |= MX93_GPR_ENET_QOS_CLK_GEN_EN;
+	return regmap_update_bits(dwmac->intf_regmap, dwmac->intf_reg_off,
+				  MX93_GPR_ENET_QOS_INTF_MODE_MASK, val);
+};
+
 static int imx_dwmac_clks_config(void *priv, bool enabled)
 {
 	struct imx_priv_data *dwmac = priv;
@@ -188,7 +223,9 @@ imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 	}
 
 	dwmac->clk_mem = NULL;
-	if (of_machine_is_compatible("fsl,imx8dxl")) {
+
+	if (of_machine_is_compatible("fsl,imx8dxl") ||
+	    of_machine_is_compatible("fsl,imx93")) {
 		dwmac->clk_mem = devm_clk_get(dev, "mem");
 		if (IS_ERR(dwmac->clk_mem)) {
 			dev_err(dev, "failed to get mem clock\n");
@@ -196,10 +233,11 @@ imx_dwmac_parse_dt(struct imx_priv_data *dwmac, struct device *dev)
 		}
 	}
 
-	if (of_machine_is_compatible("fsl,imx8mp")) {
-		/* Binding doc describes the property:
-		   is required by i.MX8MP.
-		   is optional for i.MX8DXL.
+	if (of_machine_is_compatible("fsl,imx8mp") ||
+	    of_machine_is_compatible("fsl,imx93")) {
+		/* Binding doc describes the propety:
+		 * is required by i.MX8MP, i.MX93.
+		 * is optinoal for i.MX8DXL.
 		 */
 		dwmac->intf_regmap = syscon_regmap_lookup_by_phandle(np, "intf_mode");
 		if (IS_ERR(dwmac->intf_regmap))
@@ -296,9 +334,16 @@ static struct imx_dwmac_ops imx8dxl_dwmac_data = {
 	.set_intf_mode = imx8dxl_set_intf_mode,
 };
 
+static struct imx_dwmac_ops imx93_dwmac_data = {
+	.addr_width = 32,
+	.mac_rgmii_txclk_auto_adj = true,
+	.set_intf_mode = imx93_set_intf_mode,
+};
+
 static const struct of_device_id imx_dwmac_match[] = {
 	{ .compatible = "nxp,imx8mp-dwmac-eqos", .data = &imx8mp_dwmac_data },
 	{ .compatible = "nxp,imx8dxl-dwmac-eqos", .data = &imx8dxl_dwmac_data },
+	{ .compatible = "nxp,imx93-dwmac-eqos", .data = &imx93_dwmac_data },
 	{ }
 };
 MODULE_DEVICE_TABLE(of, imx_dwmac_match);
-- 
2.34.1

