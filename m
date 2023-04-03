Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC53D6D54B2
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 00:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbjDCWXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 18:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232662AbjDCWXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 18:23:34 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2071.outbound.protection.outlook.com [40.107.104.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D621731
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 15:23:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UsVGeIEGkzFslno3mkTNMowKl0/b+N3kPwn7ZaU2JpFfH7GE55RIBqwMj9TzC0KCAkA7qcYmO5LuIrRuD/UlNyy/BzP0MZehzlq3rP4haj0tSuC6ou+Q4wi+WMft+ZUAVLJvYUoSEUVBl8BIxDV8vF72pApcWCs3Y9itVRFRd9fLQwgKLne9WvZIydkt+PDgpcRdbDkfXLPFl6C8PqTpnXYIqm0rlmDRWFJin4YY8kIGob2eJt44h08zBmKRgiiKSm8Zy4+qoOnZosuc+dFI8tEXeXl1i+9zoxnsnLML8MLtgMSJ/OJFMod7NgNGLUllIUygM/AX/h76/fjsVnAAdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o81d9OLZfKVmku6/qpZ/vR600tz2JIN45TckwK6f7tc=;
 b=H2J4gEP9i7j8MvgJiYqYrWd2F6nIpd6PjOCY48kV3sL4SdFSsD7bvoV0FZWjTaopWfTavKn2oR4hAg7gGMVReXlsZi/+4Wpq/vwtBjyCVisXHiIZAsfXWNP4lUmRzuTu43toORLurS2XSRY6RQRvgy+WYJQ3QmElSwh+/O2ho7aw87Ow8s13MOdQ7P0GQwBEwXGI3X+VV7coL33DSv70msRx4PDX70Fk1Egh5FVJe6feE6GvYqaIzYWcVywNyxxeskwAeFRDfXK6TWfnOXK7iRtZ22QVI99mlc/BjR7eyH8FAlBJrumiElXv3Cft2xVlZCEd2QbiqGvtcxFXQvmVYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o81d9OLZfKVmku6/qpZ/vR600tz2JIN45TckwK6f7tc=;
 b=Sv5UJ9nqM2108x/D0WGny1a4S4okx/W3UgVMecq4JiCDfAGL6YWlR32HcZH1cURALilQVF/BaFJRb+uSglm+dfjiX5Jd+tf5Yo0r1HFCrY7uq4t6dVJ190C4/UfZhed6AGgxwB2Qftth/UlaKr+be/vSML5XCpxmqPd3glVOSI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com (2603:10a6:20b:44b::7)
 by DBBPR04MB7786.eurprd04.prod.outlook.com (2603:10a6:10:1e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Mon, 3 Apr
 2023 22:23:31 +0000
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::f829:2515:23f4:87b5]) by AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::f829:2515:23f4:87b5%9]) with mapi id 15.20.6254.035; Mon, 3 Apr 2023
 22:23:31 +0000
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
        Shenwei Wang <shenwei.wang@nxp.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Revanth Kumar Uppala <ruppala@nvidia.com>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        imx@lists.linux.dev
Subject: [PATCH v6 2/2] net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs
Date:   Mon,  3 Apr 2023 17:23:02 -0500
Message-Id: <20230403222302.328262-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403222302.328262-1-shenwei.wang@nxp.com>
References: <20230403222302.328262-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0019.prod.exchangelabs.com (2603:10b6:a02:80::32)
 To AS8PR04MB9176.eurprd04.prod.outlook.com (2603:10a6:20b:44b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9176:EE_|DBBPR04MB7786:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d59673-b7d1-4714-daed-08db34920df2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ujjqWSMu8PUcUa4tbgXBe0dj18Wuh6Jp5q8dkrBFoXel28VP+3kri78K9GyXjqM7uS79Id60y/ttwswR6Y7b9/gYJOJDkcJ8H9FbVSXImkK/KMU0fzNP0ShqwJCNRzElqRGamWHyovFVcOf28xNmG9SOtPhcdrXCIucqCq4aFry2f8M4fJmb3gpGDAiWL1cUbfBDiKyjxIksA1yROlruUN4fY36ECjNp3zN2aCUM1HxqAqa20tYeEqqb2C+d9svOz8fmlCHeI1vGLgiQ9chN3JoWegbkhhZLNrgARDzcwvs32mcglVe5L+R8gr6JZw/KmpXQvxdw3y/khzQKniyY6XMwbIVbIc5dJsEtKRNbfxglFoWlUIbrQwC9v3oZch2/xnAydjfBHuRjSDSigFOZb5d149pRYTz/YcNuvyvAHgW4/yj9rdiUWxC+ndgWKZsr1ooxw1AdaOryAr1SK/9PUAPKYJWAJV1ZhnemBAdHQPTzvPnEtBNA58xJdxGegzaRgcDKn57AossTMl0LHv0wZ33b6ce+ZnZw1VubfUsFRMndrBHqJSYph2sJmUSI4Ku5XK5MsPeUCShvXQy/lTm9jW9JP2+6EIMOQtLQrkxuoGRxc9Jth5VvdzM7Ekrstdvl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9176.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(376002)(346002)(396003)(39860400002)(136003)(366004)(451199021)(36756003)(38350700002)(38100700002)(86362001)(2906002)(52116002)(6486002)(6506007)(26005)(6512007)(1076003)(55236004)(6666004)(66946007)(66476007)(8676002)(4326008)(66556008)(41300700001)(44832011)(54906003)(478600001)(7416002)(316002)(8936002)(5660300002)(110136005)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xuqPQkCe1JqlokTM8GZqbHZb/gKTJLnyf+7/dJMG5MkPynkH49szcLYa7Z7f?=
 =?us-ascii?Q?uOXM4gDl/KorEqkK3pKDmceae4zOjw/rMvyn+ukFsN/xoKbauS16dzpl0EFZ?=
 =?us-ascii?Q?dFmrMgtx30RXsPLJ3GxTfoHWC5JAJn1eE7K+8CXBYNfkso8mYK5J+pqjaG9G?=
 =?us-ascii?Q?zWZVIM93sWr+orYFJcDrNA/lN1BR7D4+DE5jLADiicTjIAv9xR85PZmMhTVt?=
 =?us-ascii?Q?n4/U32kliiEKuzyBmDir3fzX9uyB8th8QUrUOv3zx3fN8HfcjdRxMGNiDTT3?=
 =?us-ascii?Q?p1Xd3Ve4sLYt1DjFa/XtTc6m9hZk+hosU9vYvuxs01nSXg6JKidRzt/OcmvO?=
 =?us-ascii?Q?CjXLsRdC8z9SavlfnCkTwTvqoOL+hYTe/FG67Nb8vHkfOGh6gEZrVzyULuFz?=
 =?us-ascii?Q?g+febtQ0grS6f+5REajV2d1K0+Qx8FuADKeDusFoe9HkBo2s6Uh+KhJHmyDV?=
 =?us-ascii?Q?2R2zudvNjnuE4bJO2J4hLOK3z90LLVIUgMJ9q/8VkWgGQgpr0DI/+4KVfS5C?=
 =?us-ascii?Q?GCLvZBZfG4Gw4EuYN90eS7zxxy2BzTKRFDoHz1VS/urVOsxgsq83U8cKxBXR?=
 =?us-ascii?Q?LtkcvPoJWk6kCWjGEXt4QFwf9stWQ0Eh/p6PAhbAJxoB3widRweqaV/WNodh?=
 =?us-ascii?Q?GM5JbSmwT3ozUH1G+DPlzGsPYpLcSLYGHNivWtUXSAPU4ScexJHJlIEZBGts?=
 =?us-ascii?Q?xkkriQ920iNaUG85JLDTYm3GC3Zd123XlIVhInUKXx1iMzYmm270dbpPyBAC?=
 =?us-ascii?Q?dxv5lp/etEhZfm9TCfFKgorg5JjAnsHNTDDtXJ8G0fThrMXVwfB10+SMW/3k?=
 =?us-ascii?Q?kkfCTG+bpFyOsWboLvxQweNqZ+uc6XLxCdA1fzHzW/N7h5Xw9QJq4CfaFed4?=
 =?us-ascii?Q?CA3gnn3I/ZbWGHfYHxtXAGcN/ejEz+J8vO74asjO5dV/LVbkPLoNSmWAL63x?=
 =?us-ascii?Q?ho9TWehAep5MkzcJD/hFhnZJYJF34JpsJD188jVgzlW0YyTeDlCR9vPOTIz9?=
 =?us-ascii?Q?1TM59fv9sQBdkClq9mfNeGpLI16umu0xVWCT59KNqNooAXn2ZlyKTw8auioW?=
 =?us-ascii?Q?7hbCTm8vLRNKNCv0R5j2GElJ5i6nvsGgCbgcLtEl+Bj5H4eV09jLAhB0Srdt?=
 =?us-ascii?Q?ZBB1K0PiEZ3dlQuetvc2NasL6xNHVSnEFJt5CmD8wI8CBvMjAAnWRDaVgSZq?=
 =?us-ascii?Q?4nncPiyVpux+VknA7CniU3728h2iNX/WoivGvfTY0Krg0hlOI+zxfEES2mzn?=
 =?us-ascii?Q?MVQ618Ee3B3R+lB0SiBzwr9ma2kz/FV5Igf75YXa7+stzxfMp/LUjLpDa+TT?=
 =?us-ascii?Q?GNr9PQKXVkR4KzU6yTbhDQOnv2BV46dILkv/0uM7Y86bU5R2d/9RN2ZRn1BY?=
 =?us-ascii?Q?qRMCuZvlPpEPtOLd1QwF+Kn0UOo7f+CqjVq+5eC7ucSFbZCk/bRCN+0HMjE4?=
 =?us-ascii?Q?tOZy56qYGFe3jsRErRYq8/7HCUHesuzw9Pwv49qUN8qvqvoOXLsmc7khQcuV?=
 =?us-ascii?Q?5stJSo91vJe0Io7NkUIGKFgLDBPtmfWS33RsJhBuM8ynT33RP0Z9N8qcCZK2?=
 =?us-ascii?Q?75PzUln0Lxi8Y7TUN8O5AdKFRxpOOFcSxxakiN+G?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d59673-b7d1-4714-daed-08db34920df2
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9176.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 22:23:30.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WVB8cVWB7GffZUYYSQgKQlL5rTVB3oqjoK28Q2D2J/Qa+Bs5Y+5oOYB7HeButieYI7rvM2xd9IcssQ9ZAX6Gxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7786
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

Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 2a2be65d65a0..7c228bd0d099 100644
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
+	struct plat_stmmacenet_data *plat_dat = priv;
+	u32 value = readl(ioaddr + DMA_BUS_MODE);
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
@@ -304,6 +328,8 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_dwmac_init;
 
+	dwmac->plat_dat->fix_soc_reset = dwmac->ops->fix_soc_reset;
+
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
 		goto err_drv_probe;
@@ -337,6 +363,7 @@ static struct imx_dwmac_ops imx93_dwmac_data = {
 	.addr_width = 32,
 	.mac_rgmii_txclk_auto_adj = true,
 	.set_intf_mode = imx93_set_intf_mode,
+	.fix_soc_reset = imx_dwmac_mx93_reset,
 };
 
 static const struct of_device_id imx_dwmac_match[] = {
-- 
2.34.1

