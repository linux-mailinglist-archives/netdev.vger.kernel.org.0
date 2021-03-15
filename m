Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14DBC33B25E
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:17:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbhCOMRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:17:14 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:58947
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229814AbhCOMQw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 08:16:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e7icFKxvta7jZ8+ouVonZEcMZUSJ81q3yxbhiZUSWpO1h5r31rFf0/Owd7BblUtxVPhFl3kORyUig5WlAGjw8Xs0eYit8ojEAfQMJ7bDChsl7OJNvTWPyvgykN04xuXBCM4aneDHFHlwbjBioK9+glhDPb+yFoAmiyoMTbNF1VrcrzykrX6E8MBtq8d+/d6G2dNQ/fDkpUhbxNUaE4+A9IilSAhfeg1o8SgyJVrZ3hkgbrPRut/6NcaeXRcFtqZZVBxuuEkFYJOMpTFNTRuZgNhbuODSOz9x3hlrBji8ozag821IuonT9tVEu1bGf7TbUxSAdCIQSViYfhrxXUFA1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNBWC0oARNa5FS8KraonBtwqLcIkzolvcXvFT0yuCXM=;
 b=ib2b3resF87/tow0ILIVzwPlDVeuNYpx9myObB8lr5Z7kRfX/qKW3ZsEzZ9QO7urFA+U93JIuc1Yj1CreyCtgrF3uvy61Gakf00Rpr6JM3nKLGSta02ev6R/sVhVlWZ3aaMTwows7PKI9EABexfS1l/wKFCC+qoMmpLfzpMvSPBLHCnyokVsKy8LOFgmWc6dTyYweTeo9MCHxug0DntnI7IiK0jqnBaQaNnUR9OWuW6k0gubjILXVqAUtuVGdnNxAl9Ul4b/xV+KS6JM734ExWyl4odJEVZDSAfoqfdwqP9+hGnsEY6KlzPmz6SAXt9uwJKFUe55N2glSw1mAM2vbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QNBWC0oARNa5FS8KraonBtwqLcIkzolvcXvFT0yuCXM=;
 b=LsJ1HriL3FCKoI6i6EbvwzWkXNxtapujh3H2CBpL2lbiVE2IQF4mqyNVXVu1gQVcx8ia5P5B4pNoI/h89pzDRxBil6OqRuD04Ji8wmEBaBXePJZenqQw0O5c4eqIKRN5IIL3q8CKfMDhlv3NKRe2s+jHTZmArxDNiXGRTrZw7xQ=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3206.eurprd04.prod.outlook.com (2603:10a6:6:d::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 12:16:48 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 12:16:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 repost net-next 3/3] net: stmmac: dwmac-imx: add platform level clocks management for i.MX
Date:   Mon, 15 Mar 2021 20:16:48 +0800
Message-Id: <20210315121648.10408-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210315121648.10408-1-qiangqing.zhang@nxp.com>
References: <20210315121648.10408-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK0PR01CA0058.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::22) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK0PR01CA0058.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 12:16:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f781a889-d50a-4599-f6af-08d8e7ac3531
X-MS-TrafficTypeDiagnostic: DB6PR04MB3206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB320665873B1CBCD7F5C77A4CE66C9@DB6PR04MB3206.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 53CCgySK+cMfQypnqt5+Qx+lMUx8FTnjo8MARW4VRhO0GbAhKd/TO+uZl0Hw8Kpuktb+BfqGSyFrm9CoT3vCSWGPE4TCvIoCYqkKgb4KxQXi4nO0sLX2PqXF/Odv3+ihHQVgfI0htz1d/c6pr0n5wfN3eJ0WIbqiW92jJGPVHhfrPzgFC60bHpfm0CRtehlCcZjU4a7HFaqkmCJ3qV0WTTi6TKZ3GRo2eax7k/jE8NYvC+lDyrVxrkfPrbaZiDwRP3w4jD2iVXtLQ1BPHjTQIQB3O9IWqfYxEiJGBYvWSycCGO7gsAFYqNRws6tXnbXvbYT+veqGJpz3ouJTgYp0rEUE4N0dn/EC3l5YNJbACtzfHk/hg4ofzv8pjb4mEhnwFnlG2JX41JQ5SpA5/H+J1ziUPtdoxY0KrJXrIMlD9T4KZxrc6L+yGqyMUYy/oos2gCLXHgN8XsTvGK4UbJosb/PFzRBN2riuOhCtk8NwPHFi4xS7E4Y36S4ZKyF6a+ZCHL/pn0hI8tYyLQwF0KRlL9yC75jGRfQXQ8eHvL8TGSGvhTWcoNNnP4yD4Xz08oy1hAJyDJLeBd4fGHxzHL/g3h85pHYZmuKyJuBWpcuMoLf6+6xq9AT2/vxeV+yd/J6x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(4326008)(316002)(6486002)(2616005)(5660300002)(8936002)(1076003)(186003)(2906002)(16526019)(6506007)(6512007)(8676002)(478600001)(26005)(956004)(52116002)(66476007)(36756003)(86362001)(83380400001)(66946007)(66556008)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?SZ4K2yihuDsMsYzSojEvVSg2piAqzi8voEtzB0AQiD4GzY6VrT7kPkr72P2q?=
 =?us-ascii?Q?lz+ZrkdT1HAN7nUhmGvvaoBvkubKQsn8t5Hb+k9vJOte+mwL9v9rHnFurI5g?=
 =?us-ascii?Q?p81C2YaTEm8WqPXHnhigla4rWeF1eEkP2Obrm+pyxouGMUP3k055oLpSkysb?=
 =?us-ascii?Q?fFCnXoyHU4AyDbg2HvsIEgTtyVVkKPARIhha9kMEqS9ZSkeUyxYSlAlCir3f?=
 =?us-ascii?Q?8x/VAr71XWkzKbsSj/SEqcr9zk0UkvwK3l95h6x4PQIaCHcbXETzzgOIljnZ?=
 =?us-ascii?Q?71CbWwJvJwe+DvbizGm8aSVjtB/E9TgQOiTdKo4HnnVSBu07FK6zq9sPwJcf?=
 =?us-ascii?Q?unED6WFGJaQ9osdSb9MjKhiprzoGeCqXALWjQgJlp5tZq3wvNAB1XIuddZ0M?=
 =?us-ascii?Q?AEDTmxzGy2ra/87HC7Utujp3wJEPUeYypPb2xYO5y5ep+551jAfp50tipIw+?=
 =?us-ascii?Q?dYT2j+qR3xgFJ8KYRhTeL8iou9Xn1gx/NJzlCWBOjYYkl1HDLdjFPOi/9WlE?=
 =?us-ascii?Q?52sNItGiLUUybSXH2PELalWSfdrSr2ORx8itYx4a5DJMgKk7fsW+R24eHgAA?=
 =?us-ascii?Q?ago/2DcbRBrSIWK9kUEYXsS+FUF4BFf/2J00YTUgZds7F22MURYSVcqYDqwQ?=
 =?us-ascii?Q?PQ8SaN2K/NyNnOwnIlFBLzZ6S6MsXVlBYzODN4q7nLnrBfLIUfsxwp24Y3hS?=
 =?us-ascii?Q?6OBE94P85juKLm68JZKuLvaQJi0jPEKglk+ZKzyv8JnPQEn8Wvq5P9pC4SZ2?=
 =?us-ascii?Q?pMD5Mv332oOnu7JEUlrUCjf7HbtkMkaOjxcrp+sFHjvp6fpWjVzlMu7cocw6?=
 =?us-ascii?Q?+wjR8dc7I7ABIrV9UEc3Y27SWZf3+CvUPpcI7uRN9B+upr0tdeZzwC8AjCHg?=
 =?us-ascii?Q?sbuczuSMFTDlwWk9+goew0B5F0uwSRbpG6eiV59f0fekyxQELZwCAGNNskmV?=
 =?us-ascii?Q?IOpPX2jaNaO3KmffjzoFjtK8nXy8dOV2F+xKowbmT7ovw2Iy7LzIeQKpyWEv?=
 =?us-ascii?Q?BhVVLi6JtFXnuddnQH+YGlG22fPwE/EnBs6ciTUvklQVOJkuqdXScpsCHuMd?=
 =?us-ascii?Q?r8iLWepXBVfVKRxTWvLZAl765Fs7J7GcDI6do8YvKqBFIMF0t0tIVB3yYM8m?=
 =?us-ascii?Q?pVWxsU8O37pKLkJhAKmpjzGX2X2PFp4QlHaEASJhwHx0R1PAaEXdKTNFfZSi?=
 =?us-ascii?Q?KFfVKdTHBbK4l22y829WbL1pE191DW9pnZVkcO2+eOzc7WLeHcieDWtXGKUZ?=
 =?us-ascii?Q?B50OmLn3bK2lUuRFaLAwK4ENsoX6WqwsTS8PqjnCDDzRnKrtSWae/SC64Fx8?=
 =?us-ascii?Q?1NYTEjG5T1NuOIxk0hYmMTQ4?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f781a889-d50a-4599-f6af-08d8e7ac3531
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 12:16:48.6739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MpncXVpNrszpsE9xUzoR++ei+QqBLAPwg/5SDJJ1wTWalmaMOfv8dZsQ7Ew2l3KyLA1hDzkezN199jrCcQ2aVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split clocks settings from init callback into clks_config callback,
which could support platform level clocks management.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 60 +++++++++++--------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 223f69da7e95..c1a361305a5a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -90,6 +90,32 @@ imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
 	return ret;
 }
 
+static int imx_dwmac_clks_config(void *priv, bool enabled)
+{
+	struct imx_priv_data *dwmac = priv;
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(dwmac->clk_mem);
+		if (ret) {
+			dev_err(dwmac->dev, "mem clock enable failed\n");
+			return ret;
+		}
+
+		ret = clk_prepare_enable(dwmac->clk_tx);
+		if (ret) {
+			dev_err(dwmac->dev, "tx clock enable failed\n");
+			clk_disable_unprepare(dwmac->clk_mem);
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(dwmac->clk_tx);
+		clk_disable_unprepare(dwmac->clk_mem);
+	}
+
+	return ret;
+}
+
 static int imx_dwmac_init(struct platform_device *pdev, void *priv)
 {
 	struct plat_stmmacenet_data *plat_dat;
@@ -98,39 +124,18 @@ static int imx_dwmac_init(struct platform_device *pdev, void *priv)
 
 	plat_dat = dwmac->plat_dat;
 
-	ret = clk_prepare_enable(dwmac->clk_mem);
-	if (ret) {
-		dev_err(&pdev->dev, "mem clock enable failed\n");
-		return ret;
-	}
-
-	ret = clk_prepare_enable(dwmac->clk_tx);
-	if (ret) {
-		dev_err(&pdev->dev, "tx clock enable failed\n");
-		goto clk_tx_en_failed;
-	}
-
 	if (dwmac->ops->set_intf_mode) {
 		ret = dwmac->ops->set_intf_mode(plat_dat);
 		if (ret)
-			goto intf_mode_failed;
+			return ret;
 	}
 
 	return 0;
-
-intf_mode_failed:
-	clk_disable_unprepare(dwmac->clk_tx);
-clk_tx_en_failed:
-	clk_disable_unprepare(dwmac->clk_mem);
-	return ret;
 }
 
 static void imx_dwmac_exit(struct platform_device *pdev, void *priv)
 {
-	struct imx_priv_data *dwmac = priv;
-
-	clk_disable_unprepare(dwmac->clk_tx);
-	clk_disable_unprepare(dwmac->clk_mem);
+	/* nothing to do now */
 }
 
 static void imx_dwmac_fix_speed(void *priv, unsigned int speed)
@@ -249,10 +254,15 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 	plat_dat->addr64 = dwmac->ops->addr_width;
 	plat_dat->init = imx_dwmac_init;
 	plat_dat->exit = imx_dwmac_exit;
+	plat_dat->clks_config = imx_dwmac_clks_config;
 	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
 	plat_dat->bsp_priv = dwmac;
 	dwmac->plat_dat = plat_dat;
 
+	ret = imx_dwmac_clks_config(dwmac, true);
+	if (ret)
+		goto err_clks_config;
+
 	ret = imx_dwmac_init(pdev, dwmac);
 	if (ret)
 		goto err_dwmac_init;
@@ -263,9 +273,11 @@ static int imx_dwmac_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_dwmac_init:
 err_drv_probe:
 	imx_dwmac_exit(pdev, plat_dat->bsp_priv);
+err_dwmac_init:
+	imx_dwmac_clks_config(dwmac, false);
+err_clks_config:
 err_parse_dt:
 err_match_data:
 	stmmac_remove_config_dt(pdev, plat_dat);
-- 
2.17.1

