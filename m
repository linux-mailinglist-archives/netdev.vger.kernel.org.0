Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2BCC322905
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhBWKtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:49:35 -0500
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:28228
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232097AbhBWKt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 05:49:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cf+kj8a359nvONYGc3NK6z6s48hEVTVq9Z3YMHB7DkkwEsBFjphpa8sbmdKbuEl6fdJ8jh/EMnNzFQcQmJH8CVd7d9DxTzCTPj0WWFUn8uvAH3K2Ada7Tj/7K+uD20bZr33qi/pCM/uevIoONtWJxdm9hqRnnzWIfth2eFI4B8fz6U6Ma8DKNEBUGuAlUIP6QkdjqwRz5Jni7ax+55IAtzQ2FyrtjR6FM0WURfw2vjpJeB3G1hGiysyFYbHqwDAezqlPQds01WvoXO4991b9trfGYzyYY+b/eZe3gdQszFO4NzJ1Uy3C43Z8YK8av8RsyhQDZ4W99IF+sok36JsY9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIOm956COZLZB993jgcx3wshbaqJI0VPEozZzYojefc=;
 b=XHiiZFz2TE2x2rflPS0cTVVICfqA1UEt2VqbdWVbLGK+0K0UCNSZlETUf2yMQwIuVR8FudsXHyw4jYOT974eWZ5tNXOHsXL06tZfZTHIlwTCeo/CZ+GUf78jCW6AEWsmpyL4o66FV+Cs2yEki9/5RXc7UAgdgsBCdpvwl3pvSQOs71+7OQBeKZscE0qL3xpxj6JuWURoNXBm/4KgVwzDYyyoejjp418xuaRV1+yUvjfEGN7t2cwE/CCTN1i7+Hn24FeGprha6SVr7uRSp+fZy4uU38Jgb/sHhub2SELQPs6FNjpEwtg4UoCBTo7ndYfVrg+i2QBCHax/auzf63NakQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIOm956COZLZB993jgcx3wshbaqJI0VPEozZzYojefc=;
 b=dnkxSfFipdWPCa/NNKnd/Qsfb4Ts3vbrQqCrVhBKUv3FaQpp5ShicjROv+zMWicfZRj4BHPTsSq0O5ohVFs+pA5y5hXTlKmjMHkXSK7cN3pUsYzxpe5iomJCVqVC4lIjjjrGCMOVTKv7cuwtkFGYMKzmLJqHaTnjzvfxxqtF7Dk=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7705.eurprd04.prod.outlook.com (2603:10a6:10:209::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 10:48:15 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Tue, 23 Feb 2021
 10:48:15 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 3/3] net: stmmac: add platform level clocks management for i.MX
Date:   Tue, 23 Feb 2021 18:48:18 +0800
Message-Id: <20210223104818.1933-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
References: <20210223104818.1933-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 10:48:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 00abd28f-5757-4a9a-9b09-08d8d7e88633
X-MS-TrafficTypeDiagnostic: DBBPR04MB7705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7705D7D5E473747D07B53CCDE6809@DBBPR04MB7705.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:632;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VyWj2tyjYOlgdIpmliK3BZDv34K/23Nz0FfLTIPYb80OB3G7EyNBemgqFtYgc/WvpZILs8sZuJmaGU/hGen25my67ZYkmf+ZJBGfi4YTfhixO/La9iu0GYO0YJIGiwcg+BSpM3nyRbEqR/mmcN/xCxAIeJ/8oWz+O6/+WFfQBEYRNI1fFI+VpDJKQBbcd/R81G8RPqjKKizj8v0yW3UKnifJ2qObejKqr8ApAXkmJM7EjSrn6gYU7MfIIi4Yz7L4XmYTJAkY6BBIeWxDzGgssPhQZ+rwiRHDpT4qTT7JADbQR25l4lrHSTXKAKdr97Np/6CuxkpUQEwX02sWOU0xOp4hWS5NPvV9WtmLd5sJ73MQI/JenWGEM7yCSPMKXzuMTCm8xcj3vRUg3h7MY0QiPFDMjhW0PwuHeJhoSbzKMSymub3SS55hO9vXHkB1hDpZ4UWP8WD0EH2JN14ICgMWQVoINti7nN3ufvzGMlNRrqBvs+C5njrXv0iFgUqdCwdLdd83UMqseaz8Ny2nlxNAiZYRtKpifU07v65PmGYUzRDTeYIGMsH5kVaFVjziJGx6Rx6nOtdvNK7/07my6nv71A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(186003)(956004)(66556008)(1076003)(2616005)(5660300002)(83380400001)(36756003)(6506007)(26005)(16526019)(8676002)(478600001)(66476007)(4326008)(6512007)(69590400012)(2906002)(6486002)(8936002)(316002)(52116002)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6mzBYQtZwoZsD7abTF0mFarlMwvuzyID2XqirvInO9qPvojO7E8gYtcpf7qQQk7Y3CyRAeREYMNKcsmmIY00rVDO1bIkQt73KJgKsFJEucXwYCc0W1+g59Ekxax3ciZtVP1DOmp6RxiYfRmCeRU4acIUrAP23OLYS0TJ5j+y1njMKYCXfSMCdK/9JIUbWl74VGqmVglwf4BSqlRZpdhQzcL/OC8BcE6JWTxrs9ltwFH98v8ikdJUcenFbG8kr7ma9A7Zy2Otzq8OpTtxsewo/h95t99g8BnSpGAvChLuhOl0iZaZWs4o/CnpoXgC2NzaaTjF+B1F/Pvr23enZBQ9MCvbVrf6QlQGhRSUT2ndRAO5hPWnVryY+KNAxEHuWJ2JtLj526ds5tcUu6KBuNHP3636LA9JKT2+5Zb7qBrFOAtt6PnGQ/hgw6+oQzxxorBtoOO+0gDB7KZdOH8hQrVcRAYSd1W9sbw13ZApS5Fr21+sPqsHKtphvRaJHS4/NqaPJ68ubXvTog+cmBhMnCiAMqC6sp5qGkba+eE1koGl/w+KmLC6e/PByT+LoryEHdWtGWFvaZM8OEg63eCorPvOYv+JFeAXSp3qYe66rl/in7gM7idrzJG5RpdtAbfmOKx9NJVYN70jpSVMxdLWiTKbtpX3iIzuj2E+7X6hSaPvTCBhuAkSnXp8rwiBGG2wjA/tFvJV+6eQV+4rrVxsATDmfBxYwQM5qsx0qMEu+Mr4YQO7E11agnVyJa9ov4uPmUv0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00abd28f-5757-4a9a-9b09-08d8d7e88633
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 10:48:15.8780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4IYSepvwbv6uHu0V9ekWjEei0rh7lJyYdUPSwz1JJNFaG+AAiWz5Ezf5oIKFQSmjIGy+U6Xpu4xBPBh33c0UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split clocks settings from init callback into clks_enable callback,
which could support platform level clocks management.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/dwmac-imx.c   | 60 +++++++++++--------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
index 223f69da7e95..9cd4dde716f0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-imx.c
@@ -90,6 +90,32 @@ imx8dxl_set_intf_mode(struct plat_stmmacenet_data *plat_dat)
 	return ret;
 }
 
+static int imx_dwmac_clks_enable(void *priv, bool enabled)
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
+	plat_dat->clks_enable = imx_dwmac_clks_enable;
 	plat_dat->fix_mac_speed = imx_dwmac_fix_speed;
 	plat_dat->bsp_priv = dwmac;
 	dwmac->plat_dat = plat_dat;
 
+	ret = imx_dwmac_clks_enable(dwmac, true);
+	if (ret)
+		goto err_clks_enable;
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
+	imx_dwmac_clks_enable(dwmac, false);
+err_clks_enable:
 err_parse_dt:
 err_match_data:
 	stmmac_remove_config_dt(pdev, plat_dat);
-- 
2.17.1

