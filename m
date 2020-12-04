Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 985C32CE5F2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 03:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgLDCsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 21:48:23 -0500
Received: from mail-eopbgr140081.outbound.protection.outlook.com ([40.107.14.81]:37121
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726780AbgLDCsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 21:48:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcTGCQv+jSnrPWwoOgVG04Jj2Hlf6Z6DgTL3hwwBUaL3K/So0FDHrMqRnybmKgFryWTRO6/nseZZxfUpGt5UugIAP2Am1/sa7ETI4CvEBA3ITmZh4j4go2aYhmX5jFc5nHRgCYc4701CVVGMVt4ZQ70JLy0hcf2TFKHWMYRXZWnPQPKYiHw0aKMJoAVoHv4HXvtfCpIdviVKszSJxJpYxL+xT8DY4alwowkZCmE8AejgTeeTjOBDxIA9NTniWlC4tOXIBOruJoENnDWHv6wYXoB+J3+51eZw7LRUyz3cCZAwDrHVfREu8WRv+ZaAv+3rtjln2LyPUdg38KnWNiNDQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsgz9Jce5dZwZRw/WYKFxWhpQpYwiT7h07GYN3SKBx0=;
 b=a5aNjlm6wtITclrU8dw8VMZWka63m3xp1xjX7s36BVtEM1q3cDKcyPG55Zvf5vaG04r2PPeSLdNEJoR/UaB2R2F5XcaHQ+PBuKRl38TUEh16C2E157FjtVYlVUbDXAsCQbT2hJvuL+d5flQ+jPjJGYtLx7hJQaoR3ETKEWE9/u/4yZAYin1Q2IybgP1qtAmp8Wsv0nb2Gawdim+k57QrGBwRBjfNZwGdEK60Z0iD8BHNGRbl24W7Lwi08q1Ie4JN6GHCf2Zsmn1B51Yo6u7FP5JLkwXNKQ5V/ZWXkM90afXq5YlFJeUylmaFoFVWfvTpbE3a98kpFf7XvY+1U/OM0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dsgz9Jce5dZwZRw/WYKFxWhpQpYwiT7h07GYN3SKBx0=;
 b=pGRwvmm5EPOEJQtsTVuwekQxWid4M6Yxe4gIgFBj4hf2Dfo5wWL45ReoAUZnVZCBHelUJe/Im7jLspGD48dUzTex1T1HjalVxPkYjEhIVz5YV4KeoKOKAJttO9yAdbX5lzRn393KUcBqmrFU8Cqo1troDiMDCB8BpbMXUcDgSA8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3707.eurprd04.prod.outlook.com (2603:10a6:8:2::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 02:46:37 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Fri, 4 Dec 2020
 02:46:37 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V2 5/5] net: stmmac: overwrite the dma_cap.addr64 according to HW design
Date:   Fri,  4 Dec 2020 10:46:38 +0800
Message-Id: <20201204024638.31351-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
References: <20201204024638.31351-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:54::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0052.apcprd02.prod.outlook.com (2603:1096:4:54::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Fri, 4 Dec 2020 02:46:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b61e4407-f273-48a8-a29f-08d897fed22a
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3707:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3707D5EC9E047A5D3FAAF017E6F10@DB3PR0402MB3707.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7OdAdhxhdZv+DtCGHOfddlcJ1PA5q97C0ypwp6ew03fpXXdOVVqYDDWpyESaZRGjFbmgkNsbM3AinZETwu0b91Q/lH/DmFlz6xVkIyr+hiYLeV6WcBsR1DDsm623m+rxTxBCqjsSy4A38+hzOzJVaiFIAft1gNfKg1aFxCoDYrglfEpkGBF74s3Hi+gntRdQhi4K+QINYU7UUleN9gJTOMMaBScnfQoyA5UktnRYz7gON0LgpF0i4NZD5iyH3K2zdS0KHm+lOhzLwO2DE6RJ73Z1Do8K1Re3aquBtVXuF3cGSFTeOzCpdr7uTMSEdX8UApY+vEoryWMN5M4gs1wY2XEBNw20+4V3Fw3nYxhoiIHuBkDMC0QGbo2YkHzV2+8l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(478600001)(69590400008)(1076003)(6512007)(66946007)(2616005)(4326008)(5660300002)(8676002)(956004)(86362001)(66476007)(66556008)(2906002)(316002)(36756003)(83380400001)(6486002)(26005)(6506007)(52116002)(16526019)(8936002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1eqE+B4e9Ug83NqlDzWuKNZB2KWz+NO6xi2bV2+ljW18xq1z1rYcYpyeCQSy?=
 =?us-ascii?Q?LUmOoitcKx2VoCeNz/6/imGeycxhNHck2Obm7vbGe68jRwPMqLsGozaIinYz?=
 =?us-ascii?Q?HGX4Z3vyaMXRID7RM8XOCHrYDLVVw2SmVGYh1lXLAdd8XvY1tpNyoix/H6Lj?=
 =?us-ascii?Q?yR/ybHi2szNxCS7WXKBHkZ/LcSliGwPrdoFa0xJRSumjg06OtcOlQJbYMyCo?=
 =?us-ascii?Q?nwnUpiXbSWT2CpHz3wsAK3tzoXjlRUdAy0VxD5SvOmdxVz3GbQzpI0jeueka?=
 =?us-ascii?Q?XsKCXZLzYp65CJ0wuxZIoo4PG3GT+AbZkl3ILS+sFfOdLWGBBx4yzHe6+Z1q?=
 =?us-ascii?Q?HIFQgG1ljwSqcUeOFctFUgE5EL2bCiblfNL4M759UwSVWurcEB+Dl+b4XYYJ?=
 =?us-ascii?Q?bwaEiHtaoqs53Qg8P5QnCEmrsrxtQJ8BKXNzZYCLNlZvDS/ABPTvnABOHdz7?=
 =?us-ascii?Q?zfiV3TS3V/okSf6iq9VTJ2gKwPUGrpikq5MyzmDenViN8gz/Ko14cWBOOnyC?=
 =?us-ascii?Q?lV1hyPYVM0L8essAhcURkuddjhnUJz51tRqvSI/UDJ9jaFQsCOD+4zdf5QID?=
 =?us-ascii?Q?bjR/NEwRuTrbgHIxb4RTfsFPurfEl+k/LtSmPdwzx092hqhPtt+mGT+JoRew?=
 =?us-ascii?Q?dztLPfKCxcIl+D2Z6dqybSMVNnT2rc1aTBBFplBcisRS9co13fm0UgKu2rS1?=
 =?us-ascii?Q?EWkcRCEeSLFwCUExc8+4UTxywlBCMXg4Y6ad7VZ54x6LoelO0Xox3vEG92VU?=
 =?us-ascii?Q?oYC4C1NiAbCmFfBjo9GltREPo5CkhDIWnmCLHeDhaEdX8p8hEHs7AGK78n3W?=
 =?us-ascii?Q?X8CC2Dur9ecm5AGEn/CKGX/MeMih5p93LbYwci712cBtIHhSyIy+td0RahJJ?=
 =?us-ascii?Q?3blUX4FK+2yjSDjMMlofJHe/K1N8k3qRAYpH7rNdLOPGwIb2S2DkLrGSR8HL?=
 =?us-ascii?Q?87CoKT+Bii2jBHI/Ea0nyNLO1uIjNXXy9ebY730OQvKiIQ906OIshDFlLoXo?=
 =?us-ascii?Q?XF2d?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b61e4407-f273-48a8-a29f-08d897fed22a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2020 02:46:37.8940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sBMtqSKoq0QX1cWJCbVmCOvcKpD/wSjuAqFxACMt94zBBG/tsaQHvLUKCUc5/EkKIjo5XshuMxylExC3tjgcEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3707
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The current IP register MAC_HW_Feature1[ADDR64] only defines
32/40/64 bit width, but some SOCs support others like i.MX8MP
support 34 bits but it maps to 40 bits width in MAC_HW_Feature1[ADDR64].
So overwrite dma_cap.addr64 according to HW real design.

Fixes: 94abdad6974a ("net: ethernet: dwmac: add ethernet glue logic for NXP imx8 chip")
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c   | 9 +--------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 8 ++++++++
 include/linux/stmmac.h                            | 1 +
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index efef5476a577..223f69da7e95 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -246,13 +246,7 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 		goto err_parse_dt;
 	}
 
-	ret = dma_set_mask_and_coherent(&pdev->dev,
-					DMA_BIT_MASK(dwmac->ops->addr_width));
-	if (ret) {
-		dev_err(&pdev->dev, "DMA mask set failed\n");
-		goto err_dma_mask;
-	}
-
+	plat_dat->addr64 = dwmac->ops->addr_width;
 	plat_dat->init = imx_dwmac_init;
 	plat_dat->exit = imx_dwmac_exit;
 	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
@@ -272,7 +266,6 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 err_dwmac_init:
 err_drv_probe:
 	imx_dwmac_exit(pdev, plat_dat->bsp_priv);
-err_dma_mask:
 err_parse_dt:
 err_match_data:
 	stmmac_remove_config_dt(pdev, plat_dat);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 03c6995d276a..5b1c12ff98c0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4975,6 +4975,14 @@ int stmmac_dvr_probe(struct device *device,
 		dev_info(priv->device, "SPH feature enabled\n");
 	}
 
+	/* The current IP register MAC_HW_Feature1[ADDR64] only define
+	 * 32/40/64 bit width, but some SOC support others like i.MX8MP
+	 * support 34 bits but it map to 40 bits width in MAC_HW_Feature1[ADDR64].
+	 * So overwrite dma_cap.addr64 according to HW real design.
+	 */
+	if (priv->plat->addr64)
+		priv->dma_cap.addr64 = priv->plat->addr64;
+
 	if (priv->dma_cap.addr64) {
 		ret = dma_set_mask_and_coherent(device,
 				DMA_BIT_MASK(priv->dma_cap.addr64));
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 628e28903b8b..15ca6b4167cc 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -170,6 +170,7 @@ struct plat_stmmacenet_data {
 	int unicast_filter_entries;
 	int tx_fifo_size;
 	int rx_fifo_size;
+	u32 addr64;
 	u32 rx_queues_to_use;
 	u32 tx_queues_to_use;
 	u8 rx_sched_algorithm;
-- 
2.17.1

