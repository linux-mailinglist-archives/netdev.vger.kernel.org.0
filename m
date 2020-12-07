Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDA32D0E76
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 11:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgLGKxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 05:53:06 -0500
Received: from mail-db8eur05on2057.outbound.protection.outlook.com ([40.107.20.57]:27758
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726480AbgLGKxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 05:53:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QoqOVLrUgZTbpSVjLcrM/lKNiKecEPmJ2fRIkUYBx3C3ZCH3tZtpf9yS3KkGJzhtdp9Eay7oWw2UYDnhK30R2UCaITILJ6FbQDg3DMJE3IT1XZ4mxYEkLa93Jfb8RZGIm/e3y13FTIkFgW3w5hhbriEKpm8tQavk4F4G85j0OwMWi2kKuluAIJ6AVa1ASyapjxPJMKMLYK5K6Piy8p0lGB0nTvg7TDkQeW3NWg7pLliANw4+UTjdQW2q5tG9wUV479dn9jPlfF+UxjWMvCkHFnt809MphGdFdK6vsoATmAxWt6ShLylVLI93YMzCT4j8yHQtXoWiFvEFvQEBocT9PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78exCnGjJAAEKlouXkm7QU3nrpOEJkK++3fT/BbDEj4=;
 b=kQ7rigJDiECMyUP16Jss/mWpGEe1RNEwyr8AzogEVVBmKcL6q279xRNVFIa13s2JtYqT4XEvyzDN3AOB6NYpXnLX0M65SQtR8gR41UUB1A49/FLBpBPTTOLSaOXpGAvIhBkZ2r45OpV73IrQ9QzT8bEyn+vhRPcAf9I9qKsbQp78Ibl3P5Qy2ZoIjeG0YdoCuB4fQXkluxAJ67l9Gl03aQrSMQi0ZNbz+OPqvRKf+7cDMAWzjRDBb1P4DnwkD25z9Kb5BAdn0xm86NSb0FZX0JsC3RLmEmvsLgf5Qje21A/4tAyVZlK7cJFhy4wO94haZ4vZckN8jcoiF93M2FBaCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78exCnGjJAAEKlouXkm7QU3nrpOEJkK++3fT/BbDEj4=;
 b=N13FL6VHyov/Sd4Hxd3Kb67gdRYcdz9IrMTlQEzvCcTpVOZHAPBfcFFHU1NNyzOgDIXnX81rMk/GY9dEe4ngNNFrcq6Jag3oqvwFJBrIe4naL2ZWPGVcq+wsk52B9sxsQgPaq5oB48pXfEqJGEhPbdeiKJqr+dofM0TNkZJeMVI=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0401MB2328.eurprd04.prod.outlook.com (2603:10a6:4:46::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Mon, 7 Dec
 2020 10:51:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.023; Mon, 7 Dec 2020
 10:51:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 5/5] net: stmmac: overwrite the dma_cap.addr64 according to HW design
Date:   Mon,  7 Dec 2020 18:51:41 +0800
Message-Id: <20201207105141.12550-6-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
References: <20201207105141.12550-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR0601CA0018.apcprd06.prod.outlook.com (2603:1096:3::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Mon, 7 Dec 2020 10:51:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 92aadb24-1f1a-4071-2474-08d89a9e14c8
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2328:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2328015EDEA69FB4F2B6796BE6CE0@DB6PR0401MB2328.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4u7jRM4I5ZHd/wtB1zfpgZTIYJl733w2Tr++jgypXUBYTOpYhaLgzrU/mZnEcmt/NIISpw8qxr1EQm1ThXy2F/1lvfqkfvf8yJGlWhych7x4OAoFTCxUtDHHzC/VdnCbt9dhW5pPQmN7l3zivxrObUvBN3vIxc90nubEv/NzZI7ip8OxtrW2pbt62xnFA5HmcgIDbN5vdHMYnIKeq94cHPdeneU6jKr0EboO6uqctyKpzirxOF+bbAIKaFgIr7suBZo0z6OdEANblHDVoRuyh+9dGKxqSTAWclvBBUacMMcKxGcOzDEr3PHMrYzFIVJLIGNElpVh6tZfY2giTT9cvqICG1lnQFAVlyPMX5mjz6vXpCneeh77RhBRx4IcagQ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(66556008)(66476007)(6486002)(186003)(956004)(16526019)(6506007)(8936002)(1076003)(86362001)(26005)(4326008)(8676002)(66946007)(316002)(83380400001)(2906002)(52116002)(478600001)(69590400008)(5660300002)(6512007)(6666004)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nu9aA+CEdEict4Sycz2tSooaxfz6WlIH0/f6H/RCfRlV8iLuhr/jAlTOZ018?=
 =?us-ascii?Q?FRH3vcPzqp6/kObVS1mFsf+gb46z8nCPTgrBr3Ic5CmNcB3eOjm6dmkeYmTo?=
 =?us-ascii?Q?DOffliBaYLvMAnVI/ovEllXa3PNRBFA75gY6qhPhhRDYkT/UhKlKYKCGferM?=
 =?us-ascii?Q?J5KZjUXS8aWH3UendjJiZH7RAIA1zW8Hh+q8Z2mz4HEcgkJ4AkoM3Syx9TlT?=
 =?us-ascii?Q?WHITf9F3lGm4iF4f1s2+5qg9fNMq1JcieVZvuPp1QiD0n22l9y9Jt3B99rqJ?=
 =?us-ascii?Q?EicGQ/FEEw5fU6Pb5jvdLAUOcFpBTYGBebR3sAxq+19qo1uUCZ2o3mdHSZaU?=
 =?us-ascii?Q?KTvWHg6zlXDwjLhlMNcyLdvl/oOaQ7m1jXFimKZWl4qcBlU4Ca/BHszWz6NH?=
 =?us-ascii?Q?7PBmObZjgcGO+bsEAyOz46OauaDE/o35oL2g8uB1TShSdLUICMZgsXvgPFtW?=
 =?us-ascii?Q?dJoLWjYdfKk00z1gwdJxttkPMz6a6+bPs0r7Z38jd1dD7+3nj2ompZ/SkWKa?=
 =?us-ascii?Q?xXGsEsBKHaP2bOocAM7Ou7wMJYdsB06WISFsNebZKyd1DBadPMwsncUMNMSn?=
 =?us-ascii?Q?+mR5Xm6widywTyyYb7D+VacbtMY7VrYn1L5nsHaexHarSaopyTjg/inlwM6Q?=
 =?us-ascii?Q?sZbPYoGowoAJ/xJVX/wZPlKIBSNupmJR5BkiZ70qvOtudGfmRwGjYR3TzOVr?=
 =?us-ascii?Q?PzK0PRJTTSXM918EU8QuAnKwfW0AQfZR91EXfakJyDkowCM89uynyFnFGtXb?=
 =?us-ascii?Q?h7GvBsqOgF7R3EBvetes2wUTdVf3URhErzsNx3ahNRrX0FDFyOAW6fYoVp+s?=
 =?us-ascii?Q?FAcHNSeQ7v2pTIFapgb4brGEk4BedHhHHzAGv3HG2WL9muj+BigZL4MCdxfc?=
 =?us-ascii?Q?OCMKt5/AcQiFI6nHYWLzGlGlo4HxVtqwOqk35V7T0UgCOKr8Tc+j0Ojo6xj3?=
 =?us-ascii?Q?s6hlzWv5C/c+WslTNX1APxAbiwLpu9ZJukORIffO3Pe1/lI+DesM0nfQmRYN?=
 =?us-ascii?Q?Vi7B?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92aadb24-1f1a-4071-2474-08d89a9e14c8
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2020 10:51:41.8968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MjrBmoXf47/4sCAWx0OoddmoHlRAKIqHevSv41W127V1Aryvim3RFjfjOVdycHGofc8uWhglcdUClcM8gQDz2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2328
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
index d2521ebb8217..c33db79cdd0a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4945,6 +4945,14 @@ int stmmac_dvr_probe(struct device *device,
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

