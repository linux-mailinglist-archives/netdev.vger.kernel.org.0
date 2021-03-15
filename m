Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479A933B25C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 13:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCOMRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 08:17:12 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:2245
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229771AbhCOMQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 08:16:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWPsIZH/03KdHH3daE8hDeWzPiyxfdrpT1B53/Qe79aIRIZLtvT7mZTS2cOs6hIbLfMQGWSC83MVPOxLbue1Nn8K8vuGCbHBfQTJer1KB64litpwGggHiKWzHvjnJWWFND5KSw3IPwoV2glP8ezgl1j48iqF0cDfMbRH1f2PRfmAt22soIuHbEUv7D8QslYJQ6HzPRLNpZvpOcqX6LVeQKg+3RMarfyLn99hNfLXcaivUGwYoCdJNewKwUKppp4i22xgChLelWs+Sh6RdC9z4WG1a7UbDQsd8txGOBp0MlKvmIOHZhfpAsRXfCmTyWFtzHpC64htmjx2mvaAqSNCRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzfg/UNSnjFhftgOgxpoWd3iV0kWspVt5+c0+iPCbSc=;
 b=iqBe3jNhjP5mC+TjdC4hQ8ofDI6QgVEaALcMDBttm380eMJefYqstmtGzVBGZbRHdT4M0zD+9+sI86yCZrcquP5W65mgxFaFr1oDk+s7RjFk9NALOJfEjEGjE9ml+mZoYyqxgDy9I23kKj4TiWzOSZWg+mEFv5uQLDDeds0VjNxYKjwy6l8BqmnEHH5t5r/xVj7XQDL8KuQ/s4eVD4W0WsdE20c4GsCMlu4Rb8ILqqn98Y2nPFozwQmXJ4qAGnrr5dKgfB26g96eA6vsxLJgeeBlUwe7ra96CSQobkyOLYA5h1uuN7abY73mZHyHIxOyurLbRPe7biMPIHAy+QQ4pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzfg/UNSnjFhftgOgxpoWd3iV0kWspVt5+c0+iPCbSc=;
 b=TalbjNHGsUiDIGWECrvdreU7AkjNrjkKPZ/NvVt1K4JVmiKLot9gyi3WQZ7fa1p9ejkIYr4mvPsj+RW/wAC1jdA361XKLxMMp5mD+DUR9MTLebrvazMvzTfet/fdwXmNDViRjnc6U5iwhJS8smm9ZtKe8VlAhAbMIpSjKa3s5EA=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3206.eurprd04.prod.outlook.com (2603:10a6:6:d::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.32; Mon, 15 Mar 2021 12:16:42 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3933.032; Mon, 15 Mar 2021
 12:16:42 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH V3 repost net-next 1/3] net: stmmac: add clocks management for gmac driver
Date:   Mon, 15 Mar 2021 20:16:46 +0800
Message-Id: <20210315121648.10408-2-qiangqing.zhang@nxp.com>
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
Received: from localhost.localdomain (119.31.174.71) by HK0PR01CA0058.apcprd01.prod.exchangelabs.com (2603:1096:203:a6::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31 via Frontend Transport; Mon, 15 Mar 2021 12:16:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5a87abac-3b80-471a-4de3-08d8e7ac3140
X-MS-TrafficTypeDiagnostic: DB6PR04MB3206:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB32065DABAD7E3B93AB458484E66C9@DB6PR04MB3206.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oOIWnGJWaH7wQzUpsmTW0ubuPWjiIODJTQqyUC4dUr/0x0LgrouybzZbU512e35npLqCM07TIfreo9Y1xrjXNfIQ8KXBYoyRNGfMFNHZMEAfwtTV9OpZvBNjuuxrPC/6iQu0iMFfSPC0kHHgu74M48K71t1ntrXDtO0ltMlHkuBhvnY1qvemfMRTejdB6U9nt9QVOa/tdA+5Rs3rWkvQXKSH7o3E76OPoF0ich0vBMGFx0rWjVNWJmC0m5AiJgYNAdvsQ6qT0OMtcjCKcPf2S3+t8NOSvsfYm4WS/9rErY7yzFrgdtD9/OnmsAVI/QgN4yjVJaADf0nfk+cOzzqB0jrFou3D2YCEhZ2KNettGxPYOGwMUeZfU+tQuBZzEc2EIogWuhdMVNwzU8l4DqNP59KhCMmBH7Acwx1qQaCcKkZdD997YK10pVuCYPhihyC6xV4G4BB0RvWipu4hbINvh2/9hB2jCBGe4LAONoCOagoHshuQbqnD6/GNKi6ms6ttW8u6cOSJbsLmJwswssqI1fq2PJ0Qe8oyjxe2yX6/5NEWEfvnGgQWpeQh63tSsKqUqtDciSgutAOjSKoT0G4U50cFLcjOGDJraXpogOEA9FJGU8X8VZ9o9P57oCo+21PQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(4326008)(316002)(6486002)(2616005)(30864003)(5660300002)(8936002)(1076003)(186003)(2906002)(16526019)(6506007)(6512007)(8676002)(478600001)(26005)(956004)(52116002)(66476007)(36756003)(86362001)(83380400001)(66946007)(66556008)(6666004)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8Q1bPxc49RkvNASTMxtV0FoZleg7JfjcVWBFB/ht7bjKon4lBfw72FXV2/VO?=
 =?us-ascii?Q?l6yNRHV/v1RHOdUXCqMIThvkAwQnzcslojC6oCZBrw+ATXp9bmEREzmLDlgP?=
 =?us-ascii?Q?pQQLVFOCuryh9fqCnaC5EZ8lPZY24YoCZ8S/WDz7J6S1htvc0jm5/MJqpaiQ?=
 =?us-ascii?Q?dmeEIiuLQAFvtGu8//GVCp/CdhIVep3hM9hcfCDUmMl3U+y/GSI52hbtEn53?=
 =?us-ascii?Q?JyZVgpD6tBtJG6lXtUudk10OGTTWN2ddci6zuozg36a9yXf4QZaN5HIbbI7+?=
 =?us-ascii?Q?o8eRLL9+COyQuIwosNuEIF79HswlQlVKm6TDs6HiT+OfmsRJWrPBHkjOYCRQ?=
 =?us-ascii?Q?UVoRDrh5tVEtJXHh7Uh3BJ93XW+wH+LhncgndWj0VmXyOTeke5Sw4ELuz3un?=
 =?us-ascii?Q?j+1XPClSbKMvDtwKFDqZotPl4eGQIwLlzWi8WlySEjAklbzwQRpggHaJpOIi?=
 =?us-ascii?Q?52j7q2qqQQn6mmQG20tNUyYegXBZcYOuTfSGVe794Xmqoxp6bZYxrWX6GtE0?=
 =?us-ascii?Q?H7wyRX7duQ13GQWCTR+O+W/fcStwBRPKRWLXdX9QAbriJuCHNwBI3HCbxhhc?=
 =?us-ascii?Q?9fBI29nTclNzdHXM6FuCeRYxnPamvZD/oQlKuUGjDdIu42lfdNc+lofk27jy?=
 =?us-ascii?Q?RYYU9uC3VxMPDm+RGKsK1zk5TAR0mspfduBGJp7dW14F809vlwW1jFAP/DQv?=
 =?us-ascii?Q?CSkMEUfQpjogi64XDi5Yvu1D5X/gDc/l5Nq31IxXldhM+xWc4Ewnba9cGoMB?=
 =?us-ascii?Q?vOrA4/4OpkYHV9Bs9xSiez6aDLbQCetnn8shnutXmyMr8kM/j930ZLrrVDEf?=
 =?us-ascii?Q?XCvXNweBNZHPPsmtvpdp+Fc4mLmTluZk3kc5+k7z71Fq3zWz1aprsrU9ib7c?=
 =?us-ascii?Q?Nqd4wVWhSXt/WqTtm5X7nwglNQTIU4ajc8T7efsafTRZslhC+Hk7Eaqycg5c?=
 =?us-ascii?Q?HTkukwmxnNnIFLdh3v27/pHAkytlj/Ai+BEaq5ZrY4QSXpVM5VPiRif2F76/?=
 =?us-ascii?Q?cYugcu3jr1E61vH1mjbR0d7kJhoIvmzUBM9pFmth34Che/SSkGFqYQMDPnaT?=
 =?us-ascii?Q?gcLUShejbf/akHJDwR0Pf/FqEP5tUelIc5PPU2U/GH2I5m/xOHI1SaDrRGvj?=
 =?us-ascii?Q?FPmg0eXjGf6i5ku+XQb8eYDT4V7caIkvXUPZIx3sTjL0+mMNEvw/X8Aykh3c?=
 =?us-ascii?Q?DKuvfjapS4oqFytNRh4EeEdTb9CNmGB7OAi3qWHuMXEY0RyNgYW73d3aaSps?=
 =?us-ascii?Q?AA3PVftkhn9wVw2TAiR+ftcvLR3qgjqGCNyv0OCf0CmhpvxpYO0oH9NTyczQ?=
 =?us-ascii?Q?K6CnTYEFwuywifoDAggpHpqi?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a87abac-3b80-471a-4de3-08d8e7ac3140
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2021 12:16:42.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cmeAPaXdYXpCY+Sx50eLbmRrA6t0oSpbTeC89H/mG6c+K445z6T300YUFMGQYGoDiepdoNe/FrEoL8wOlJ+x7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3206
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to add clocks management for stmmac driver:

If CONFIG_PM enabled:
1. Keep clocks disabled after driver probed.
2. Enable clocks when up the net device, and disable clocks when down
the net device.

If CONFIG_PM disabled:
Keep clocks always enabled after driver probed.

Note:
1. It is fine for ethtool, since the way of implementing ethtool_ops::begin
in stmmac is only can be accessed when interface is enabled, so the clocks
are ticked.
2. The MDIO bus has a different life cycle to the MAC, need ensure
clocks are enabled when _mdio_read/write() need clocks, because these
functions can be called while the interface it not opened.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  75 ++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 111 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 4 files changed, 174 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index e553b9a1f785..10e8ae8e2d58 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -272,6 +272,7 @@ void stmmac_disable_eee_mode(struct stmmac_priv *priv);
 bool stmmac_eee_init(struct stmmac_priv *priv);
 int stmmac_reinit_queues(struct net_device *dev, u32 rx_cnt, u32 tx_cnt);
 int stmmac_reinit_ringparam(struct net_device *dev, u32 rx_size, u32 tx_size);
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled);
 
 #if IS_ENABLED(CONFIG_STMMAC_SELFTESTS)
 void stmmac_selftest_run(struct net_device *dev,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 208cae344ffa..2a80db92e731 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -28,6 +28,7 @@
 #include <linux/if_vlan.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
 #include <linux/prefetch.h>
 #include <linux/pinctrl/consumer.h>
 #ifdef CONFIG_DEBUG_FS
@@ -113,6 +114,28 @@ static void stmmac_exit_fs(struct net_device *dev);
 
 #define STMMAC_COAL_TIMER(x) (ns_to_ktime((x) * NSEC_PER_USEC))
 
+int stmmac_bus_clks_config(struct stmmac_priv *priv, bool enabled)
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
+EXPORT_SYMBOL_GPL(stmmac_bus_clks_config);
+
 /**
  * stmmac_verify_args - verify the driver parameters.
  * Description: it checks the driver parameters and set a default in case of
@@ -2894,6 +2917,12 @@ static int stmmac_open(struct net_device *dev)
 	u32 chan;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI &&
 	    priv->hw->xpcs == NULL) {
@@ -2902,7 +2931,7 @@ static int stmmac_open(struct net_device *dev)
 			netdev_err(priv->dev,
 				   "%s: Cannot attach to PHY (error: %d)\n",
 				   __func__, ret);
-			return ret;
+			goto init_phy_error;
 		}
 	}
 
@@ -3018,6 +3047,8 @@ static int stmmac_open(struct net_device *dev)
 	free_dma_desc_resources(priv);
 dma_desc_error:
 	phylink_disconnect_phy(priv->phylink);
+init_phy_error:
+	pm_runtime_put(priv->device);
 	return ret;
 }
 
@@ -3068,6 +3099,8 @@ static int stmmac_release(struct net_device *dev)
 
 	stmmac_release_ptp(priv);
 
+	pm_runtime_put(priv->device);
+
 	return 0;
 }
 
@@ -4704,6 +4737,12 @@ static int stmmac_vlan_rx_add_vid(struct net_device *ndev, __be16 proto, u16 vid
 	bool is_double = false;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	if (be16_to_cpu(proto) == ETH_P_8021AD)
 		is_double = true;
 
@@ -4737,10 +4776,15 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
 	if (priv->hw->num_vlan) {
 		ret = stmmac_del_hw_vlan_rx_fltr(priv, ndev, priv->hw, proto, vid);
 		if (ret)
-			return ret;
+			goto del_vlan_error;
 	}
 
-	return stmmac_vlan_update(priv, is_double);
+	ret = stmmac_vlan_update(priv, is_double);
+
+del_vlan_error:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static const struct net_device_ops stmmac_netdev_ops = {
@@ -5179,6 +5223,10 @@ int stmmac_dvr_probe(struct device *device,
 
 	stmmac_check_pcs_mode(priv);
 
+	pm_runtime_get_noresume(device);
+	pm_runtime_set_active(device);
+	pm_runtime_enable(device);
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
@@ -5216,6 +5264,11 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	/* Let pm_runtime_put() disable the clocks.
+	 * If CONFIG_PM is not enabled, the clocks will stay powered.
+	 */
+	pm_runtime_put(device);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5230,6 +5283,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
@@ -5265,8 +5319,8 @@ int stmmac_dvr_remove(struct device *dev)
 	phylink_destroy(priv->phylink);
 	if (priv->plat->stmmac_rst)
 		reset_control_assert(priv->plat->stmmac_rst);
-	clk_disable_unprepare(priv->plat->pclk);
-	clk_disable_unprepare(priv->plat->stmmac_clk);
+	pm_runtime_put(dev);
+	pm_runtime_disable(dev);
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI)
 		stmmac_mdio_unregister(ndev);
@@ -5289,6 +5343,7 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
+	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5332,8 +5387,9 @@ int stmmac_suspend(struct device *dev)
 		pinctrl_pm_select_sleep_state(priv->device);
 		/* Disable clock in case of PWM is off */
 		clk_disable_unprepare(priv->plat->clk_ptp_ref);
-		clk_disable_unprepare(priv->plat->pclk);
-		clk_disable_unprepare(priv->plat->stmmac_clk);
+		ret = pm_runtime_force_suspend(dev);
+		if (ret)
+			return ret;
 	}
 	mutex_unlock(&priv->lock);
 
@@ -5399,8 +5455,9 @@ int stmmac_resume(struct device *dev)
 	} else {
 		pinctrl_pm_select_default_state(priv->device);
 		/* enable the clk previously disabled */
-		clk_prepare_enable(priv->plat->stmmac_clk);
-		clk_prepare_enable(priv->plat->pclk);
+		ret = pm_runtime_force_resume(dev);
+		if (ret)
+			return ret;
 		if (priv->plat->clk_ptp_ref)
 			clk_prepare_enable(priv->plat->clk_ptp_ref);
 		/* reset the phy so that it's ready */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index d64116e0543e..b750074f8f9c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -15,6 +15,7 @@
 #include <linux/iopoll.h>
 #include <linux/mii.h>
 #include <linux/of_mdio.h>
+#include <linux/pm_runtime.h>
 #include <linux/phy.h>
 #include <linux/property.h>
 #include <linux/slab.h>
@@ -87,21 +88,29 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	u32 tmp, addr, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -112,8 +121,10 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to read */
 	writel(addr, priv->ioaddr + mii_address);
@@ -121,11 +132,18 @@ static int stmmac_xgmac2_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
-	return readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+	ret = (int)readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
@@ -138,21 +156,29 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	u32 addr, tmp, value = MII_XGMAC_BUSY;
 	int ret;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	if (phyreg & MII_ADDR_C45) {
 		phyreg &= ~MII_ADDR_C45;
 
 		ret = stmmac_xgmac2_c45_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 	} else {
 		ret = stmmac_xgmac2_c22_format(priv, phyaddr, phyreg, &addr);
 		if (ret)
-			return ret;
+			goto err_disable_clks;
 
 		value |= MII_XGMAC_SADDR;
 	}
@@ -164,16 +190,23 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-			       !(tmp & MII_XGMAC_BUSY), 100, 10000))
-		return -EBUSY;
+			       !(tmp & MII_XGMAC_BUSY), 100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(addr, priv->ioaddr + mii_address);
 	writel(value, priv->ioaddr + mii_data);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_data, tmp,
-				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_data, tmp,
+				 !(tmp & MII_XGMAC_BUSY), 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -196,6 +229,12 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	int data = 0;
 	u32 v;
 
+	data = pm_runtime_get_sync(priv->device);
+	if (data < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return data;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -216,19 +255,26 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		data = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		data = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
 	return data;
 }
 
@@ -247,10 +293,16 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
+	int ret, data = phydata;
 	u32 value = MII_BUSY;
-	int data = phydata;
 	u32 v;
 
+	ret = pm_runtime_get_sync(priv->device);
+	if (ret < 0) {
+		pm_runtime_put_noidle(priv->device);
+		return ret;
+	}
+
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -275,16 +327,23 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
 	/* Wait until any existing MII operation is complete */
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Set the MII address register to write */
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-				  100, 10000);
+	ret = readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
+				 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 6dc9f10414e4..a70b0bc84b2a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -744,10 +744,30 @@ static int stmmac_pltfr_resume(struct device *dev)
 
 	return stmmac_resume(dev);
 }
+
+static int stmmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int stmmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
 #endif /* CONFIG_PM_SLEEP */
 
-SIMPLE_DEV_PM_OPS(stmmac_pltfr_pm_ops, stmmac_pltfr_suspend,
-				       stmmac_pltfr_resume);
+const struct dev_pm_ops stmmac_pltfr_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_pltfr_suspend, stmmac_pltfr_resume)
+	SET_RUNTIME_PM_OPS(stmmac_runtime_suspend, stmmac_runtime_resume, NULL)
+};
 EXPORT_SYMBOL_GPL(stmmac_pltfr_pm_ops);
 
 MODULE_DESCRIPTION("STMMAC 10/100/1000 Ethernet platform support");
-- 
2.17.1

