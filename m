Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA6D5FC3FD
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJLKxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJLKxi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:53:38 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2057.outbound.protection.outlook.com [40.107.104.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F6A2AAE;
        Wed, 12 Oct 2022 03:53:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L4RUcsiBExCEyNFOhmGr3JmqqdGwAuH88VcEqE59LAJ5UjSztFQyeLxzjhDdGlS6/t62X8c2m7srcxEt29rpP3FE1oGjv8aDb8ciydhG4WqLMqAUoB49vvk25JmgAxgO18u4t0/1wwn46/SuHJxfgFBoQvARDEmbV/i1V9H9tXNa+HNkBSeW2khiuEUON47bCumHgSMHkwkPLJprM5JuwJpu1AYKQiVgdWFHrR6Ow1wRN30Zt0FJgMlxyzcjGAdcfHU94DRwEniXxdf+DQO7QzNBiqGRZa6F/cn76QMzV4uNDu3AB13eX1ldrOBMu87uuRb/TaXWQDBLHxGTHeN/kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BZZ9k+psyzsTty7d5lR4ahPOC52U0AL/MkPTMFLfX2g=;
 b=GbE8ZJx8F2Sriyl0ndPan3ozoPAvzkrv+lEtYbxZwS2hUUgRmMaEKW+mapMBKDg9bsmuNBwtvFABdfffl/yxOS/4lYeON6PBMuf3o3ky/gtzuZI8tcK+7SO+1HnO2h9DmN0r/q0XQtVWLxT9cXDbiEExLYZtAKOQVRT4Qm89Nm9olzVS7Tlb0N1YuntiAN6OL0aYHf9B4yQJgJyhPmXfW6slII2ED6GFxkwq8Tt3Sgxeglu7XBAqVp/e8odmWv+LtsjLBgzToZ4DG9GbVuIx/9OOMTiSKFT4hg6ExNPpxlxyzc8N6EKppDuKQh7LOYdAOC9UtZPPoPIV+Zne4yI9zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BZZ9k+psyzsTty7d5lR4ahPOC52U0AL/MkPTMFLfX2g=;
 b=IO+i5UugF1a8km8SLXJuT2bx9rjjb8GvDxYg50v05dCsh35LhrbiJKoNQ2rSAt/8U8R6UXra4qx/0co8AxbKHncvt+ONhu5USoscUyhNogmnykFOpvoROiKBIN3fkEL3zNzz06st1EABjslBG/GcPndMh1/qU1KBK1iw502cAMw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by DBBPR04MB7675.eurprd04.prod.outlook.com (2603:10a6:10:207::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15; Wed, 12 Oct
 2022 10:53:34 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::d8b1:a777:e29:7a5a%9]) with mapi id 15.20.5709.021; Wed, 12 Oct 2022
 10:53:34 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de, festevam@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com
Subject: [PATCH 1/3] net: stmmac: add imx93 platform support
Date:   Wed, 12 Oct 2022 18:51:27 +0800
Message-Id: <20221012105129.3706062-2-xiaoning.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
References: <20221012105129.3706062-1-xiaoning.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0107.apcprd03.prod.outlook.com
 (2603:1096:4:7c::35) To HE1PR0402MB2939.eurprd04.prod.outlook.com
 (2603:10a6:3:db::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: HE1PR0402MB2939:EE_|DBBPR04MB7675:EE_
X-MS-Office365-Filtering-Correlation-Id: 169fba44-9c97-4bfe-39c5-08daac400239
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71fiUipPCHNIn5fdP3AAwFV4iJzWtuyfwkfBR0w2SlctFVGP15lGhImrm+3OJhZ6ZEYPeTt1vUn5PJ6FqFm3J1bjJYRDvw9X1M74nMQaYvRO7hcJVmfzIzZCU2l60QP86S53QujPyW5t6g98/cH94sYUZcE40JO2/4erXGon+a8SoE+GXu7/CCXLWXQdKeRaFQIr01FyQUXnvCSL6cQna9avkudR3pLeu5Wdkcj/t8ZaQ5vhBjZy16AA7m4YhPtWMTvN9yrpmWMBnKjXhKtqFuCSomyKtxJsC1sJxEx/ZPcCfqA9ZB9FDV/p6yLmTOPWvV9AU0o+damHYFyDZ5f5WWzEH5fJ38A9LIlhO7Cr1DD1P1oS3DJqd7VaFTDzwKm169CreklLYEnxDXlRvJeSlYgwA2Or1PI3rFpItiGu2Pty7MMkAgjOiGcaBRoJuXqOzTnJTSPSqAWJjIyHkBIwoUZLtuBQvoJAfwG4sapf4Fiq8K/6w1Es/WuL9Fs+ruHz6aiTUBGp/AcyYuT0YkkqdXhH0l3ktFC03ml2cLDqjYcFhmqXuTeSTBX/EVLQuSm9rHydEwPGKbE8Poq2QQOZb9vLgA1NwKdt1eeN8lN3qqo41myRrOUL6IFHjeR20vPkhTR/ZidBM3gBWZd+ukkKzhOmYFvLvOEm8/hTyRJwpbjt5ndq9+FBWx7VBoo1llHwtDTPVFGIrevaxEcFQCttxSJhVEsoGWiyHE8BTcr43glJgOEjR/UButWR/1Zba0fhTkj6T2+JLs/pSEHSOCdAlw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199015)(6666004)(921005)(478600001)(6506007)(36756003)(52116002)(6486002)(86362001)(38100700002)(38350700002)(2616005)(6512007)(186003)(1076003)(83380400001)(4326008)(2906002)(41300700001)(8676002)(316002)(26005)(5660300002)(66946007)(7416002)(66476007)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bmjwrDNNdhTFdzw+0XymRK3Cinw7sF1rRCS0lA+t5ZGK2JgEK1RWxnJZdmoq?=
 =?us-ascii?Q?F4UCGyEQdqnJQGZWkQH7ZUFvRrpG7JBH/IaAkLxfZExBjGlGDSC/804NyDJA?=
 =?us-ascii?Q?Lbl3pWIejVUNP6VifmUdaz1oA0u28Dzjd7Iri1Fn8EiaXjztCU3z7V0k5R+K?=
 =?us-ascii?Q?Qk2eiakslwwUTTjoaHTYZpcJxJwGMHHzL/TdopD3lZ/gixheVB81aLGFJAip?=
 =?us-ascii?Q?592+O5gAq7KFoB2hWp6PxGg7CeIi7JN4LizQizDf3guLPnRQrC0vS185eiec?=
 =?us-ascii?Q?wYGRc8lFzl+zX6uVYOQQzmbZM1MA4o9AjT6UW1mGQS3pJCI1EWRLyZcFpSKZ?=
 =?us-ascii?Q?Htmyb3by2n4vO5PBhtvMljPSWyypeJiU3EyUNylv1uMCm2GCTVRVqnGx2XZf?=
 =?us-ascii?Q?r3lNVHvLLDIG8UGug+WU+52lvWz27UsZZPu5vrJYnSsgdSJ9Yvhbkknzwnll?=
 =?us-ascii?Q?td1xjRrYB3WbaxtgJpuH/UKggZXmbnS+eO+TPQpgZ1rVPl9Rs35Y8U1LuGwa?=
 =?us-ascii?Q?scA/SwLcC/tP2Ruw9eB5cEsZ4IVA/S32d7FelbsbiIVVUvUb63AR0c1uKGuE?=
 =?us-ascii?Q?HY9Ikssc2NTr+WoTew9nHyuwZJ60gLmVX9UoYLtpOWUH+YmnWAnqA2cI6K2d?=
 =?us-ascii?Q?V8LmzcWpzklTXIPkEGt1wHTuLZPzMqD6/xSgWCE+MgYPWi6nWupmsRIqsY63?=
 =?us-ascii?Q?WlM9/gnHK+qR9SduyuXAaFMBi8ERDemuO7Md9+HA5NhT6w6t6vjHGd+OFsgC?=
 =?us-ascii?Q?yznXBCju1t/nmzJZfs0SC9AOXGwi7zFyAceuPrpAH33eP3NJN0PnBoyvsb8l?=
 =?us-ascii?Q?wjXrrPJk3/dRCNB5Q1n0F8hWmWn1FantTMnxim70R3UTldBB9TQOs0Akvl7d?=
 =?us-ascii?Q?035CMZYz85GIE2QcWQzfHSSoP2VUsoDgEXdyr7haIgeeASfy9Uk1JlMqsd0d?=
 =?us-ascii?Q?9yCh3wFM8ThvsJ48BuRFubEjaIk/lxz57uLPj3/hH/9S4VQ552QVBUuXOlA1?=
 =?us-ascii?Q?3sf0coq5f1FAZhXaxREOjlIWrEJn/8fFRtDCvAYXgDiWdgx/Jvjfm9ru5mX2?=
 =?us-ascii?Q?0l3xkzp0onoLIYyrbZ++YjJgJxnuSCW6g5AKsFs3nDbfLu6b0GillIva8S+T?=
 =?us-ascii?Q?RPjvE1UVSqL38xrBb8zrBPGh6xL9QdVVMVaH8ztw3ZzgW5eLqarg04zxAuP+?=
 =?us-ascii?Q?HetRl3+21W+reNoLzS8+cokf+pvadZeRz3N5Eji6yEEGp2AaZHaBRfvmBea3?=
 =?us-ascii?Q?3IcZhmRLqC660DQTDxFKwHBFHrIyXRMxD5piM1yYxzdWuhdEN+tAX/5UXxNr?=
 =?us-ascii?Q?kmB6yLP7qmkMQhYBhSsUv9K0oDJOMbDQRmeL6Ip0lh7CbpN+vF1kNBfHx5zQ?=
 =?us-ascii?Q?htpP47Bdqf6GMguaBPeW3WwzMVUeOpz5F6QMlRtEaXLXl0QIb4lAZ34YnzWd?=
 =?us-ascii?Q?zIp+OjMAnBOCtt9VlapSQY8CKSOQUEgLWG8+7MdcpTuLrtHzzp+c/MJqQymF?=
 =?us-ascii?Q?mbCLAiaS8YclK5JUl0X4Wp4T7e9hzx5MBorEkWJajiKqf0j0fvrcjRxz7PGv?=
 =?us-ascii?Q?A27uDF3WELs66UEKK2Vq5pFV7dfImJD7CpHRjE2v?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169fba44-9c97-4bfe-39c5-08daac400239
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 10:53:34.3879
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8DWFCnKSejdhyo0o0YoBQ6F+JL7zzAU4/vGBrDr/zOwWQ219SaPCmpWZ2NiZIZmMWDFVEyrdP6lTMV7NwHPWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7675
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add imx93 platform support for dwmac-imx driver.

Signed-off-by: Clark Wang <xiaoning.wang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 55 +++++++++++++++++--
 1 file changed, 50 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index bd52fb7cf486..b670f07ea2a9 100644
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
+		pr_debug("imx dwmac doesn't support %d interface\n",
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

