Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA896D4BC8
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 17:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjDCPZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 11:25:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDCPZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 11:25:08 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2044.outbound.protection.outlook.com [40.107.21.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F3F519B4
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 08:25:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBrak9OT5ScEhuxqti2RmEakF6/vkiwQFkbLh5G6fD6gtMYhpCg6ddlQxtSmCp9+cRuvqi8qrHlDyRwym98+sZIiI/ufmhXJ39SKivd7pMGNfEcMAHiL3QJdzMy/zTFpRA9LEdYookWcveYG7W3sUrkcWQfY8EXihMSM6OEqM49CDKAzvDW9vva7pDf224+SSczr7sQFH5vbqn6UtPDDSUW3KhuDLyhwFHjzpcR/AElRTFHhnRe3WleAjFtNXrgYViFCB2MVqeKbAV+VZCWufvRLy9jE5j+3Ke/eLtsmU7UJw9jOvTDZdgRpzjq7oIK1b+7NnpSACzmyhNOAdpI0FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=np2NzjseM3zTUSfAp9YG4eXtEf7ic4w8hcs+Vz+qMaI=;
 b=ZhoVdFnn5A0+eA8IfjmKom41EC6m0fNvu6pvqR2OA/zakZG45dn9DvAiH9b/qJVRXxkNkPdkVJlrgJfStUSfLf/7qT9Ej4Q6gpTWIayJ+WeZWDy40Jv+QNiyPO5neMBc6OXRxNiDOA82kdgEBBIKSw4GWSRunz5ksH03h3adp5JORaEoPUrWb4qjxbFS0tY6tbhrwteuNkSqV4Wv33/2OJqxXhJXn5kKZxePfYh5W4KNLIWsQZ81jhZa7QN2Dfxhfy0Ykvivg573QWhP8n0DUuMLrWFxB/Y4NHFISBmD5Hc7C3iTk7aLmSex0V11N32js9iw19HFrHyoX/MXniawvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=np2NzjseM3zTUSfAp9YG4eXtEf7ic4w8hcs+Vz+qMaI=;
 b=AQb6liTqE2TryVBN6Slc49Addd6FcCJT/nti1sUQ+Iw6h7TbGofI6jZH/S3GhYAR/HB6oPtSa9I0nkrtK6yaQjKzYEvXVIKoO18tC2DnbmblEvaf2jOUWeqDO8fstWO9ll5KIm6F4GOjVlNz5pvC5UzliSZWR/NmRFO6iEDpFFE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by AS5PR04MB10057.eurprd04.prod.outlook.com (2603:10a6:20b:67d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Mon, 3 Apr
 2023 15:25:01 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::28fb:82ec:7a6:62f3%4]) with mapi id 15.20.6254.029; Mon, 3 Apr 2023
 15:25:01 +0000
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
        Kurt Kanzenbach <kurt@linutronix.de>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Andrey Konovalov <andrey.konovalov@linaro.org>,
        Jochen Henneberg <jh@henneberg-systemdesign.com>,
        Tan Tee Min <tee.min.tan@linux.intel.com>,
        Shenwei Wang <shenwei.wang@nxp.com>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, imx@lists.linux.dev
Subject: [PATCH v5 2/2] net: stmmac: dwmac-imx: use platform specific reset for imx93 SoCs
Date:   Mon,  3 Apr 2023 10:24:08 -0500
Message-Id: <20230403152408.238530-2-shenwei.wang@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230403152408.238530-1-shenwei.wang@nxp.com>
References: <20230403152408.238530-1-shenwei.wang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To PAXPR04MB9185.eurprd04.prod.outlook.com
 (2603:10a6:102:231::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PAXPR04MB9185:EE_|AS5PR04MB10057:EE_
X-MS-Office365-Filtering-Correlation-Id: 9489415c-8bec-4af3-74d9-08db345797a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: znF1uoiZFSGG/yycHSL/6HzXy7z+out8QH9CgsFTZFtryuwmThF/4fBxx+KgOhR9nS65eRClDbm+FPF5DaFnemG9mfFJw08R3HMTJSs0Waj8YrTY4QwMr5FtvcP+seQ1gPHE+ZWaBvh0eQyIO74rAu+WXynT90UWRfHyfxlV+cfYFY1sX+yZxCrjDV4fFyLOEW8mYz/rD+VnfJ42uwgBd/LJxalu60WTIa9h85Rga+KaDyZQPuHWmN8+5NHvt25fyJHBMPyj69WuZ9C3jJitFrPR0IN1pf6UWkkLBCHB/8FsIrngyT0tRtF6JAvaAY2J3A1pgYJYd9Lu19NKolz9xQAKWmD4UFEBereSRfTLWYCO7MgI7fHssyuoFfueZrAL4yxHS0KWhOQ422X/5QwlCJ1lmRin3zMUckgC3X+5N7Qb70gAMRYSQ0JZXgFOv4asXYceGEb53NEHj6NBlrGWyQ3NYFAiK+jyxGRmok+KnE7Cq/rdJEt4PE/RKG/pkxliKkSsgqGREPdqn7YI6SAn/zbxbwxb0VqSrUlucbCicbagxThrOLssJ+UUhW0KCaNfZkhbBMoc+Y7j2+VcZpmIVEfVTI9B10/qZHloeLoBj8LwjIoxMK3RvXRcfYNwphlD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199021)(86362001)(36756003)(2906002)(52116002)(2616005)(6486002)(186003)(55236004)(6512007)(26005)(1076003)(6506007)(44832011)(66556008)(8676002)(66946007)(66476007)(478600001)(41300700001)(5660300002)(7416002)(4326008)(38100700002)(38350700002)(316002)(110136005)(54906003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hIK0mfmQ0bi1OeVyLSMLnbD5tamRro1nWdr9M13nNx+4/IqVuxVjmKIY3Ahs?=
 =?us-ascii?Q?vNvTNb6bDX82HZRGl+fdaXUcW0hfn1rhSppfYiwTQuRKdbiz07I53DVERgxV?=
 =?us-ascii?Q?/h3j/Oc7FPKw2WT5dgJ1TEIKiP22p1NBybbw+SjAK9TukUxx4DLBWAzpchhr?=
 =?us-ascii?Q?FCEtByYf/0vVfXXbkVQUNqy0Oo0gJ2B9jH7jccUmQkJuLM8KNYkza78Qzyjz?=
 =?us-ascii?Q?EUQKd4paA2nEE4QXLrGqTuQpg2b4mMkJcjcl7Jst+rkdhfBL3i5OJAMggaZg?=
 =?us-ascii?Q?uCUYDjI8SLXcFZYWBUAotCMTKE53zyCeqEQA7NxYz6i6UgqjbOz2+1998Zh5?=
 =?us-ascii?Q?ralJbzfdKZcosCQRs7LS/Hv5NF91s/aPzeCmsj9YCao7ufzufQ/1RCcz5kfc?=
 =?us-ascii?Q?SQVECFNXoq4giM5iB35YpvdYsg56gBA3HzBaVkVNjzroV6fmQj0RM4VLGPye?=
 =?us-ascii?Q?q5b3WbMhBnLsPGQ1hs2n6WhVfUvXIHfWANVOWp9zWOx9Ydt+A1Ck+80+aJFV?=
 =?us-ascii?Q?oBVK9SHetdQ7KvtIubgv8nIWWjO2ytf1IfwetFbLwJpeYCGLSWxAHmMUlvo3?=
 =?us-ascii?Q?Ts+sjAAa90KiBDHSe/UTxPPVTC5ctruaBEnm50A9gz3S0XeF9xZFdZqIIce4?=
 =?us-ascii?Q?dCjTrpHTxZv4bPLx2KYHEoxIOGiXEXQ0Td1yHSr378TQFIJYRYz3IIx4nQGx?=
 =?us-ascii?Q?NW+qfzhlgKepgkFXJwn+zn9dPlhgciOIwj5IuYvkLXSSvcnGV2Kfv6394O4x?=
 =?us-ascii?Q?fAsX21Z0EZLRXQqnWj000apc25LCvo5ia8VTK7Xc7ecyk+fcaPFqFV6rN8U7?=
 =?us-ascii?Q?pPoVHKBwNHbTWCtVD2idDdssJbEb7PeLTagjzX54qk2X51dXOqde0xXh0vPy?=
 =?us-ascii?Q?+SvN6uXq2FXFrUcvV7u4cVXoE2doWMY2f9HF0hkjQ2vzbvdDi46s9NuIhOQp?=
 =?us-ascii?Q?sMy06Qi/CzkvdAsZwmbInJOKW+Y+v9hwzYJ4qLbLqpHXmgog6fTWu5SVgT9k?=
 =?us-ascii?Q?cWi4+F8rRsJlUMN9ECovSfafQBbw1xLs1XKR+T7/u2jY8VDOrAU66MNc9T9V?=
 =?us-ascii?Q?Nf2sRLbmV5nEN4gDtdtse4ONUZpf3XYAW6cqXnTc2X0pswEF6zvn6+Do79Jw?=
 =?us-ascii?Q?x7RbuHfFJIVqVv+PPt9zE2O07VjVYT7Ib6EXbbtZb/dQtVezg7inKUYNw66X?=
 =?us-ascii?Q?P9zOaA06D5H30YyUvAUKNa7gkX9QybZDNztSVXia/j5+etGXAmn54N0kayss?=
 =?us-ascii?Q?Qp0k9tLaESGt334fjppAorv8Yfzk3jCZd1sD5+w1EHd/PuX9faObQaZy2vya?=
 =?us-ascii?Q?FzTjX6GfZJbyGZohAqPOqgIqRpx/LZJdLCDha3gt0gqPT88101QLX01hNOHs?=
 =?us-ascii?Q?9pove0Q+jJlhfm46W5SN+Q4ev0uIXGs+doa1zSRKhkkJ6uKcBFjMjuxPokFd?=
 =?us-ascii?Q?Bi7h7Z68QSLRYVnz4spdC5ddAM0T7YPZYxSfqkERFnnS+/GQEg7DEyCurXFk?=
 =?us-ascii?Q?DzSYXgpUjzjAaca65Z/1YQp7O08I+M9kKhol8ZW7bx/O62kcffkPgZsLz/6k?=
 =?us-ascii?Q?/s0+At9Rlhr3bNXhSjkAASM5R+NExIme7aTkBdU6?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9489415c-8bec-4af3-74d9-08db345797a6
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2023 15:25:01.6888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aoJbmJ7lX+a2y7mEPiVDW5iI/p5LDpSz/F/shtMMVwMAVv2zeaAQWvNXS5RtDlHmBwIDrILVIyjDoIV3RgSXkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS5PR04MB10057
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
index 2a2be65d65a0..465de3392e4e 100644
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

