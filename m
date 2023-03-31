Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B6D6D29EC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCaVXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCaVXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:23:10 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2069.outbound.protection.outlook.com [40.107.20.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F132221A88
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:23:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Flor+5IANs9d021xg90TnBOAvBbyTM6pOksp//CP8utGXbAdeinc8rZWbLDUDEdoWcvZEhsBFWzXFikJ/GwdaNIp19xXU1ooiIm63N1xuDkN8e1Q9mTv3C2Qr2aLSD03aaKHNaHrruMwWrKwe9EG0DoUo5NuKPxZ3JnCyoD3zDJZkxtMU9kP4Y38kazNl/nxVkpAOWJsTrh5fIfEloP6N5WascurCoI+X59/9SQ4qVc9P+Qdq2l8SChCdoFhb85B7ALCfVNnWNuACKLmYRjpbnvICMUdpU5DYSm1PBFBjPBs8pX75XBTk6Q3YeTe0QrMbmBSNkZ/ww77ANsTft+GtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8f1urwP/JcS7vUjP9999ZWBSe8H6+gdb6huAQDlORvs=;
 b=YAg6g03+5+cbbG8WnVjVKtVRzj9OE6LwRRqH2IPyGzzJQazfzQrjL7l1pE3jI2SvY/oqjFWVGVp7RnM40lW693/oAG0MVCHb9O/5R7Rumf9DX0cg4QnT7pZenGH72NDqV3OJR3xIqooynFODWIcj7QarYybeQS4OHNs6n4lhORQEhZYc5GJE8Qh/OkePoB/KVHK8i41ONqTJyh0/yUD0LkSyrYFFZ7d3ZCdABgytU3niu/mRy6vkc2GwG2PyLVziwzjYXaDO92f4Xq0CXZazILxSLWj+nzwXZvnO6eAo2920PhbaajzEsic2KBfds4kADosdMebNtwVLSGMU3SN8ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8f1urwP/JcS7vUjP9999ZWBSe8H6+gdb6huAQDlORvs=;
 b=KqoKMjIF5lxck7yjQDWCOsr0gToJ6vEt7b6JWPjVoB+jpj6ujD5e+WbN31LQJIfh6xfiogmgMT3o5dErkUfX55BOSiEeCwmL+oz2yPEjYq7B5WsiD/EGRZanr1dEfhdzXBF789eMggHKGeYj6ifg0mcisr2nzK6fUisoXQi2Amk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by DB9PR04MB9992.eurprd04.prod.outlook.com (2603:10a6:10:4c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Fri, 31 Mar
 2023 21:23:06 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 21:23:06 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Wong Vee Khee <veekhee@apple.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, imx@lists.linux.dev
Subject: [PATCH v4 2/2] net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs
Date:   Fri, 31 Mar 2023 16:22:50 -0500
Message-Id: <20230331212250.103017-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230331212250.103017-1-shenwei.wang@nxp.com>
References: <20230331212250.103017-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::19) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|DB9PR04MB9992:EE_
X-MS-Office365-Filtering-Correlation-Id: f6d30dc8-58ef-4840-dbaa-08db322e1e31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HNiwAyiYRL9D+ub3pWcae0ky5uiPEwN8auY5v9MTJtW2KmEsJtwP7giMatGISuccfOHhoyni8d9pfhH+DK9pfOAo07pMvHwXpV46Vl61EV2Vf2aEg+mwFV7uBgZI+LVaigl5DxWV2YHaYQGlYXOlEl5Vv+Lcv5Y0ienRwQa/4ZwAv+feiIoSmBq+lLNFeGo6fNDTHdVTon5hsMtmBmfQr4icGKbD3vFxDmFYx36sfu/HE2ruGyQKRb0WcE9QuDbtgKui+hgZIumJ9TYku5XtkwPhPwAN3EqTJRsLJ6d22NIMqzIEBd29UepIr0J4jM/Nw4FfRMDFB6pZ91UTo5DKjpr51pJMUZE0lPxUH+4QEiSYVwXp7kZ9Xbs3I6oHInmP0qm04flmPqN7mC/P8gUoZ9XtPu1KZ+Xb8zcTY15e6rmzb66lekaq5sOL1kHaHsUYxyNQhuRsl9CgtNImIDeo5PHmXVPsAY1U2JtokD7ypeteXjPGQAu2ZrIKUv7zZL1VEmkJF5bHxw7Q4FoICSx6TbhKYKAuFJWMrL+FKuMmoTwwanEH55hTZzBDafrrh1BLaovWYv8876DaOxHujvdhYNXLeQKqnIwRNMnPrhZAqyDYXKcAINMrjA/eJkQY9xNM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(366004)(346002)(136003)(376002)(396003)(39860400002)(451199021)(110136005)(44832011)(6666004)(316002)(55236004)(6506007)(6512007)(1076003)(54906003)(38100700002)(4326008)(36756003)(66476007)(26005)(8676002)(66556008)(66946007)(186003)(38350700002)(478600001)(2906002)(7416002)(6486002)(41300700001)(5660300002)(86362001)(2616005)(52116002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SH7ZB5LkkrkEs7Z1VGimc+99hbDKTPeTI/0VwZTOcIXosmb7ezjOG2q/Zdzz?=
 =?us-ascii?Q?r6y8/Js1t3DQZwKlJzvEfNms4boqnOo63WEDHlvK2mlADpVxhbB7PxLJF9fm?=
 =?us-ascii?Q?EDa7j1gLEvF2dzwv+EzbEY9AMAU3kN9ysmco1hZPqLGe+vdoOyDPrdG7JeB6?=
 =?us-ascii?Q?924nKw7B9S/0ina0CwTWcezlthMXv6bD3DbQsbSm62WtMBHe28QrTjzMW5Ui?=
 =?us-ascii?Q?KyjDwjqPRcEUKvL9DjMoEHhrvxneNsBvLRjr1BK8lJ8/zeflcAkiLFCUKFa6?=
 =?us-ascii?Q?4F3le15GRx1CQHt8T1czmoYrcgpGExYMwDjHLAZAIdNfN8hTpUZ2G+wU3tMu?=
 =?us-ascii?Q?1jqx4TZTfSHW7+p8z5eX4vbqb1l38AY12Sh1N+WljSn8msPEWLHYNmKewYOE?=
 =?us-ascii?Q?pl+DmMIIhUsdMpRDPcnmD2jgX1ToBT1Ze+6y18RwWvKtmZG2yDHCnygT+W/+?=
 =?us-ascii?Q?XgbH4ot2TOUZ5hm7k2HfdlvU3i64UFUOT36ESOKh6r/hLKGmEdbnL1A3AOl2?=
 =?us-ascii?Q?OH1LuRxBX0HTnB13tkVws1675nX2r1uqppujJgutoqsU5PkSdC4ymrQfJLio?=
 =?us-ascii?Q?neBg/roiiFZZ4Yp94As7v4qeQfN9Vxy1/Rbhu7fHptdqhnY2gk1k93uGTrwR?=
 =?us-ascii?Q?SuDVeQ+HJkinQzubAh9TgUdfktFm/UUGJ9QacW5ISUNrPTTdp59SxdTapKGZ?=
 =?us-ascii?Q?uL5Sm259GnzSZPbwbnbGihWp7A/kV/qztDWBKGdpgNWUqzO/rbVpP7n5NwEX?=
 =?us-ascii?Q?N7X7tnRNXOQ1+LkTDzxhOMhwj9Hjq0O4dB+TbtuRM/7BkgSZ/pqssR+O8GZe?=
 =?us-ascii?Q?yBHOYlsQLKJa2QH23W/vz9aPKFyCUoTrU59yNuUDNe+rwemmMDxzRLIogDAc?=
 =?us-ascii?Q?jI/lVY/L8EW6gGLteLHdXbkKI3a54wwuMYSfetxYyZPCuO87DwY/XLnNmvYS?=
 =?us-ascii?Q?44cvZ5UEkfRXADScXDWiP1Y2/X1hclCHRVs8EHiR8c3yNwDRDpH/2L1YYpy/?=
 =?us-ascii?Q?YN5vgv855eu5bh+agrykpZV8j9oC/+QmPnAtfJPHLcamDxpTHqHaOM4Dif13?=
 =?us-ascii?Q?YPvpgT5YtcvuoTsTuHvxykcFv5d4QRA6SrQVMH27GeAzy4DkkTfJBCmNx6bh?=
 =?us-ascii?Q?GldAvetTe/2PuO6wrceohBob9XtITWnRd3dKhSUpIiDF0IFe3zq/oISHxHuS?=
 =?us-ascii?Q?fpw4MPtHnl05uDmu2KXlFCMzrsAXgrZnfboutzuoqASK0z40S3Y23f8n6Gw5?=
 =?us-ascii?Q?bW1aZDPxbbka0voDt1PPAEYrcmfZvHon4rCwOuuU6wNxWTxhmQvvJNMEdD38?=
 =?us-ascii?Q?EKwa1Sj2UKLPWBMTmoWXoU7wQ/jaIzBvTjM8nAtnwztINlJmTKbMHNXcxHIi?=
 =?us-ascii?Q?qjihvckCHDMsL02DuPBNxk1Agxcw4RW7cAInqpdh5VZyZkZN9Vw5rR1tmXUs?=
 =?us-ascii?Q?tIjGFm2unU9uxI/dFS0gOohny4H+BMLu6Vx48rs5fMfxGzL/jgzhlERPoufn?=
 =?us-ascii?Q?et6DD6z+Blcad5k5eDd3aePYuBQPJ21DquLrx8V/yqqiEovOF+0jLYRc9qo2?=
 =?us-ascii?Q?OqD2Lk6X6DdAO3rcoIXCJXxEMHCidSShh6zfpu+0?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6d30dc8-58ef-4840-dbaa-08db322e1e31
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 21:23:06.3992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UlQ86ioEzNH8EiDfnQX55FbS9bZKi2L0/BFu9knCrE7D5ZLT/hLM2g0XRrBw/w2UipgmKsaYmCOG7DcDzl83rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9992
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

Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index ac8580f501e2..ebab2ced5422 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
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

