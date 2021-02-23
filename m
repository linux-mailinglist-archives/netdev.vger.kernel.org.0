Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF21322903
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 11:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhBWKtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 05:49:06 -0500
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:28228
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232064AbhBWKs7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 05:48:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVCD44Or7Xm6a0687zn2Lf7pPPp+lm1vKyR6ETyanf87ZLpQ5uo21k2HxZ4l/vJlxxRCWFDCEkcxZWk2dsqNmw0d1nKnlN6ATgHOpUWOgM29umXcmm9xmjAo/v12vLPc/cO+OYU4Og5P/noF5IvxVOBNMdzOdu/Rxzz5a/LI+0zZZ0s1U4VfENVEAJLtUAaRAsi33/xyh04AKhkoyrk/fwZiyXSyU31+fG7PnrlDkCMHpZagCjC5vRq2DCJvKH+gI3zAXIvBU+U3R6U4PEoXMGoseMdomlCbQldw/0o6o5dxgYymVji4Tb/ZrzQuP4SFgDtSZRlIk0e8wy7wuzsULg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+xbNsSvoRwtwzNpeZ4PvGs6Fqx46Pg6tgIzmIOA9gk=;
 b=bS+Q7LVFebnJHf9ryLmZG3+nlfBbcMHOMjEm4pDIhnuaWzVE/KKNB6Czaw3kR60HWid0KDVWfiY57WB9KKF9PryYcPc6JFfYnAfuiVroX0TmKfV5xFTr+IQTevmDPRpMQ8XaAfVJFiHJy+LqSkCz33A3gDBhkcPLmxVM643Argfu+qgcYyMur/Gl10VMmFVZ41ARNLocmY65Ll7iwYCeLd+bmC60rvVDmNLtTr+N6K3TKn7hZfWiszRJhU4cI170FZvrniaGAroQuRlgFJDKD+8nLCI6mFv1a7RKjwNrSIk7ozudBYUjLek5s0mkWjSeT1YKOzDvv/5pNwEcWBK5xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+xbNsSvoRwtwzNpeZ4PvGs6Fqx46Pg6tgIzmIOA9gk=;
 b=nM0tXtJNYNaC4eg3pP1/gMyPVFgH/ixtRY5XqqoHmnHuLxBIrRjNE6mqLNicHp28t+OsXQYZhotgOz4t4/mxhppFg9RVE0+/TAzYF311CTi6SZpNTuaTPkb6Sp9IOeaydAKfNcYPuO2qiEnzYBdAuFyHVaeXM9I6DtPrCuWscbY=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7705.eurprd04.prod.outlook.com (2603:10a6:10:209::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Tue, 23 Feb
 2021 10:48:10 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Tue, 23 Feb 2021
 10:48:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V1 net-next 1/3] net: stmmac: add clocks management for gmac driver
Date:   Tue, 23 Feb 2021 18:48:16 +0800
Message-Id: <20210223104818.1933-2-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by MA1PR01CA0162.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Tue, 23 Feb 2021 10:48:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 77a432a9-fa52-4f44-2958-08d8d7e8829e
X-MS-TrafficTypeDiagnostic: DBBPR04MB7705:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB770571FA97DD9F115169F4E3E6809@DBBPR04MB7705.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:221;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lqqjqXWNsVlvH+5aGgmPvtUQy3mlw/XGnVLwLYP4HePnEtzYkSOhBqws1hAZ2xD6DHV0ACnm5+Ufj7RBft22J00OiaKkweqMMlZE3yT8paLgpajEPlSnTTp/w0ewqZaaBfP1FAueV9lDBSNaxD35LOX5gLvJXXNn0wIa06OKnMX9pWk0HT9lFs6bjgjwVWE6zHjxGILTmYxuYs0m9EKKRryUdDA2jZYA90lnKogrx8v2zVEP3ERMJr6yfd/AaYpruqXr7q/n4aStk5I5rgPZuzVR+mOi7AITopQHPpKqSUDdNTu09/z+2fwltmxQaPoIna/0LGQlu6sWJHOx/044yCIRdBIGZ2g995gT7oTnNx8O+yQ/2DU+jO4cdsv12NcVzPJLUpkiSoTNjMee1QwITr6adYnU/u/q95ShFH+cVFwKTFX+gRfIjcjytUDnyJqB0i8ZlGzmpzWK5LN2uGcTvVO1SR7s5ND+nzTePgIj46/WqRx38F7+9+ex/ugFsG+5g6uzwups5+nvIHzxMDPnY6HWn/O0MXuKpT1gxrsuYEGlDfdq3bA5EWg3ESaVraD+46iSMcrL/GTTK7JqjW7tfg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(186003)(956004)(66556008)(1076003)(2616005)(5660300002)(83380400001)(6666004)(36756003)(6506007)(26005)(16526019)(8676002)(478600001)(66476007)(4326008)(6512007)(69590400012)(2906002)(6486002)(8936002)(316002)(52116002)(66946007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: p3xBjswNAKVl+823VJwg9Z3krTYuXY5tsvlFYR3zVNDzCgTIP1PAamZhfBExhCTs8whbL3ZRosrMCC3Nr9wbiyZFDa1BrVgidHVgXF95H49ypqEROuDJTyDN2urKhyjTPUW3gje19KIZXcJouNUZmjjRivrZZY+oeOXmpjbSkpuRaIVpCpKTWgRkwwGm4bYalC5zgRaaAr+XZqesu4PaQbMMX5SYBYxCxGvwZPtt312G/knPCc6DNS87Ercr4RBwHEJh0MGwgI4tn/TlSKc2mFaK8x3C+kqBcPswykQCz+1eEBLYMqNus154DXYoYywTN2hmpdlZLbrC3Q/Do5AnFnfeA7nF6TCQ5WhLsgGspBcs5xapwfEkTHryNh643KXAQIzob/KRMUJRN3010ZPyZM/iVKFHQef0o26uAAD/VmFBqApLyIZdOfxEB8G/ug833iwxNirOOfafC6PUKQRE5OtdJxRC/GEQ162m1bP/GT/hsur3CbI8hbRSI4Epyij7FkS8HuBTX1tXuSwNcOwlfGqhZrq6FURgSGmAOLklSaDZ0F4wVOKnOLj9+Ewg4AOyS71nIFK8D+wn9mF1V3iymrkl6sVI+k3+66tYZGC82g0FjKXlS9M8LING8/C9xFxJy66aqJ2eMbQuRuadGwfHSJDd0XdOQP8Xu/YXWTda3zvrqd7FPSFZLap4Bq3G0FncsL1T2Nhu4iO5CdhGVEMa8Zj4uVvMk6YvMMijpcgGwbkAvz57Ctyctav+6jevywYB
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77a432a9-fa52-4f44-2958-08d8d7e8829e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 10:48:09.8634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYzkewKlQpf7Q8J2ReEzLx8eD5VB7KyzJxuXgJW7qxtXBRrilkBPeJJaUJ1f9I4OB02U/XJ0sT53mUBbgVOb4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7705
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add clocks management for stmmac driver:
1. Keep clocks disabled after probe stage.
2. Enable clocks when up the net device, and disable clocks when down
   the net device.
3. If the driver is built as module, it also keeps clocks disabled when
   the module is removed.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 60 ++++++++++++++++---
 1 file changed, 51 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 26b971cd4da5..35a79c00a477 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -113,6 +113,27 @@ static void stmmac_exit_fs(struct net_device *dev);
 
 #define STMMAC_COAL_TIMER(x) (ns_to_ktime((x) * NSEC_PER_USEC))
 
+static int stmmac_bus_clks_enable(struct stmmac_priv *priv, bool enabled)
+{
+	int ret = 0;
+
+	if (enabled) {
+		ret = clk_prepare_enable(priv->plat->stmmac_clk);
+		if (ret)
+			return ret;
+		ret = clk_prepare_enable(priv->plat->pclk);
+		if (ret) {
+			clk_disable_unprepare(priv->plat->stmmac_clk);
+			return ret;
+		}
+	} else {
+		clk_disable_unprepare(priv->plat->stmmac_clk);
+		clk_disable_unprepare(priv->plat->pclk);
+	}
+
+	return ret;
+}
+
 /**
  * stmmac_verify_args - verify the driver parameters.
  * Description: it checks the driver parameters and set a default in case of
@@ -2800,6 +2821,10 @@ static int stmmac_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
+	ret = stmmac_bus_clks_enable(priv, true);
+	if (ret)
+		return ret;
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    priv->hw->xpcs == NULL) {
@@ -2808,7 +2833,7 @@ static int stmmac_open(struct net_device *dev)
 			netdev_err(priv->dev,
 				   "%s: Cannot attach to PHY (error: %d)\n",
 				   __func__, ret);
-			return ret;
+			goto clk_enable_error;
 		}
 	}
 
@@ -2924,6 +2949,8 @@ static int stmmac_open(struct net_device *dev)
 	free_dma_desc_resources(priv);
 dma_desc_error:
 	phylink_disconnect_phy(priv->phylink);
+clk_enable_error:
+	stmmac_bus_clks_enable(priv, false);
 	return ret;
 }
 
@@ -2974,6 +3001,8 @@ static int stmmac_release(struct net_device *dev)
 
 	stmmac_release_ptp(priv);
 
+	stmmac_bus_clks_enable(priv, false);
+
 	return 0;
 }
 
@@ -4624,6 +4653,10 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	bool is_double = false;
 	int ret;
 
+	ret = stmmac_bus_clks_enable(priv, true);
+	if (ret)
+		return ret;
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -4632,10 +4665,15 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	if (priv->hw->num_vlan) {
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto clk_enable_error;
 	}
 
-	return stmmac_vlan_update(priv, is_double);
+	ret = stmmac_vlan_update(priv, is_double);
+
+clk_enable_error:
+	stmmac_bus_clks_enable(priv, false);
+
+	return ret;
 }
 
 static const struct net_device_ops stmmac_netdev_ops = {
@@ -5111,6 +5149,8 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	stmmac_bus_clks_enable(priv, false);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5125,6 +5165,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_enable(priv, false);
 
 	return ret;
 }
@@ -5140,6 +5181,7 @@ int stmmac_dvr_remove(struct device *dev)
 {
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
+	bool netif_status = netif_running(ndev);
 
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
@@ -5157,8 +5199,8 @@ int stmmac_dvr_remove(struct device *dev)
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
-	clk_disable_unprepare(priv->plat->pclk);
-	clk_disable_unprepare(priv->plat->stmmac_clk);
+	if (netif_status)
+		stmmac_bus_clks_enable(priv, false);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
@@ -5224,8 +5266,7 @@ int stmmac_suspend(struct device *dev)
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		clk_disable_unprepare(priv->plat->pclk);
-		clk_disable_unprepare(priv->plat->stmmac_clk);
+		stmmac_bus_clks_enable(priv, false);
 	}
 	mutex_unlock(&priv->lock);
 
@@ -5289,8 +5330,9 @@ int stmmac_resume(struct device *dev)
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk previously disabled */
-		clk_prepare_enable(priv->plat->stmmac_clk);
-		clk_prepare_enable(priv->plat->pclk);
+		ret = stmmac_bus_clks_enable(priv, true);
+		if (ret)
+			return ret;
 		if (priv->plat->clk_ptp_ref)
 			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
-- 
2.17.1

