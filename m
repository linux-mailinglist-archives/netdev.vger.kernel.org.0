Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301622CCCC7
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgLCCpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:45:43 -0500
Received: from mail-eopbgr70052.outbound.protection.outlook.com ([40.107.7.52]:60646
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725893AbgLCCpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:45:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYzA0KyBO9ynY+TpvB1snLiEYdqibVMTmkS37xhXrUEoiVKhPPgAhdZ6tqTxbdxMf7Alfpy/0yK85xmUit0PTfnQfwRDCcG5DEjGtNmIUf1fklOpDWBYLHqebfT4EoyetUBc9eg9tYkjHozNBIQhVvRZHElDZRbUVh1+yd7GR2h/r64V22gtrp8FKwxSGV7XBOb7ZimeT9Gm7ieJ40EqyRSAtQhY0Yui5d6kY1of/g+yuEnUuCAbgh16ceIQ/01jNWdLvj4tqutg+551rd2aujXl+z8eyaA03BgXxjnzffzPlg8MZrVuBJYCdkUObzfUoVYXmnQre856wyFVQTQNFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7izeMfdcUE5/UxF7NiGPmX3O/XKHADkGCjycgb10Rg=;
 b=ANTBK4S0+0RqwRQUmY1v6G9RBBDnTaxqPLdlV5J/rKJdAqLZDkqbLpBr3nwkf7RzUG69Paxayr5HA0zG+yWsu+1lnQx6rz4Ualc5J/QOkvhXtobks67LkgDXe8HxRFTH/TovzT6M1cRo9BoQwdd4JUluCU39uUl78tIFlZw/xrjAke8XRGiXi4kIbR+oawpOTHqjuP1le9u2FpBgUZQ4WHH7LDLIGuv4LfVlK/WrW74WXVxUVvqc7asd0dHy23lVzbJASMLtcldGvuCmfHTrT/YBNbNc9dD4sE80zbuvz6MZeqdmJozZHYdeiwQUhMmpF6zCIQ+ttgqB8rgf7I9mXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B7izeMfdcUE5/UxF7NiGPmX3O/XKHADkGCjycgb10Rg=;
 b=Vx7bHDQRIHiHciZHpjzAJecwFoybsMdoKGcew3hVyLAXW7yJA1tvT6uZStdUUMwV/0Y2WjKxPcYQw84R0KwHHGDuj1gWFZ/uXdselR9me8dPLXU/YNDX09GgOC1q7Axp1hZZPoBUVWUvvtq5+xVjsy29e1g1mstbwVAEQqopO1o=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5497.eurprd04.prod.outlook.com (2603:10a6:10:8a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.18; Thu, 3 Dec
 2020 02:44:53 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::b83c:2edc:17e8:2666%4]) with mapi id 15.20.3632.021; Thu, 3 Dec 2020
 02:44:53 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [PATCH] net: stmmac: overwrite the dma_cap.addr64 according to HW design
Date:   Thu,  3 Dec 2020 10:44:23 +0800
Message-Id: <20201203024423.23764-1-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0110.apcprd02.prod.outlook.com (2603:1096:4:92::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Thu, 3 Dec 2020 02:44:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7499f7bc-3057-428e-ba2a-08d897356961
X-MS-TrafficTypeDiagnostic: DB7PR04MB5497:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5497B51803A6E583005A294AE6F20@DB7PR04MB5497.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AhZyxTCyxeLbXjt6VBtR1tfjX+L3lLPnSDPa/BdjxlEBm4ekfgPlCI0TV1ue6oP+cQ/rT39D44N4HAE7DyOIi8OYX0FVTWgj6z5Nn51en8J0gbw3P9yyPbrdGreMADp6JcQDLOpED1JF/vHJ0o8a/gDc49jz1WVy1vFBeR/9rGuf5WRJcxsncGtghdaQyu2bLbKiITgn4s/DhVukzVg/O8vG2YGyRl7jFGw6dnT+3JqTCXHdXw/plM/p6GnxQdV7fkxDL/H7pfH7fuxvz/Qs78gDOj71kPTYG+SiKVbMpaNIUqQUL9o8EGjXmPUMyVdZbXS/GIiKuhRGhVHhvwtgXm/ARJfq5oU/9vTHjWVwucq3AYghrumpsDzXpP9eSnJp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(366004)(376002)(396003)(1076003)(52116002)(2906002)(6666004)(26005)(2616005)(956004)(6506007)(86362001)(186003)(16526019)(69590400008)(83380400001)(316002)(36756003)(4326008)(8936002)(5660300002)(8676002)(6512007)(66946007)(66476007)(6486002)(66556008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+u9PHC4DpPEdao8+x6all8J44O2UtBCSIg+T0NS4ASKVQOjIt3Dsou99HdCI?=
 =?us-ascii?Q?PJGFrey2Anr0G0hQLd4YrJijY+Osa99jCTvc0lZLpgZC0L07Xx8Njl48kQZX?=
 =?us-ascii?Q?46ji0ZSHb5hi+c5d75MPx+gATOmJQ1X7e6KD09u9cSZl2Y2XOpbiXTyTo3WF?=
 =?us-ascii?Q?5LSXNCrpxZjnoMCrNQpm7b+qp2z9//lOB3PNdhGkL0aun8KiIUw0Da+emFKb?=
 =?us-ascii?Q?wPubOEb4xQ7NczreonC1Gs1P8oM3j0dQ4S3L3z6ICv0oVn00D+m4kSVoZ0Q9?=
 =?us-ascii?Q?jdc+i6bSJ+Ta4MsxA5gGuO4hAPc9OeugVoFno564JqzP2sSO0AZjnEBLtiRn?=
 =?us-ascii?Q?On9y2ypocH/IBDKFZGYp/dmYYMkGKyJJVuMGoFwSm3JHGMS4oMRtjYJBOvK8?=
 =?us-ascii?Q?7qnGLgJW6YiLXufqbj/FWMs0Dn/9wNB4E6J2BuZh7EOC1I3kBjeAmz7gOXlR?=
 =?us-ascii?Q?3IR2lRsuQ3hPHrG1Pn9dw9eGL8Aujw4Od2oLosYJCFmz+uy7hX7AQuelyAgw?=
 =?us-ascii?Q?zXZVtoylkdDZ+/i5F6JOxIPZ8fFb/wdiCBfk9yCzD42g0FkLTXSBSt/faevC?=
 =?us-ascii?Q?1NYVWsJXrSGDIREWuU8XExlcXXPOzKSvcSYYtNx3mhmXvVpaTm6EhoxnbqY3?=
 =?us-ascii?Q?hMW/sCPrkqHUsvPn80doT8W3fy8jVsFPYdBel66vGrKYHO/G1R1VLs8ohg5R?=
 =?us-ascii?Q?K4Gfzq9JO/133rkAdXH9XXUwQN+ZFnt9tPceTIqxFnQm+w34DgLvKZBXZxvx?=
 =?us-ascii?Q?l3qFxuVB/Maosx/O6/6uwtmAJHbDNryuX7gnfLtZn7oSgKQpgR4RPmXRXK/h?=
 =?us-ascii?Q?jxSBrioHtnoXNs9ODxV8NmpQDyl+H0nSOGF1fQhrZ/75ufhly4YxgKg/0SZU?=
 =?us-ascii?Q?qvSrDM89V99XkwAuOlYSAfKTmb0jLRuPEgnSMmDpaYhOhbrFxyLTaNzPNL0n?=
 =?us-ascii?Q?9NvzRZbJeBHYRV0sHYGYPmI5vWoH7jNxnFo7rDqVzAwKzf+Ou54bO0c4p1GF?=
 =?us-ascii?Q?3cQ7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7499f7bc-3057-428e-ba2a-08d897356961
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2020 02:44:53.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aJCU6QeNscCmS/zctxDo56WgiiVR+XAFiGZjy7mlFljuwy7mwV3n+Ai9snzS92MUcF/b8CsObDV4pPm8IOpZFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5497
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

The current IP register MAC_HW_Feature1[ADDR64] only defines
32/40/64 bit width, but some SOCs support others like i.MX8MP
support 34 bits but it maps to 40 bits width in MAC_HW_Feature1[ADDR64].
So overwrite dma_cap.addr64 according to HW real design.

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

