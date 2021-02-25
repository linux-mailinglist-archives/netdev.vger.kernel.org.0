Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6B3324F81
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 12:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhBYLwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 06:52:44 -0500
Received: from mail-am6eur05on2064.outbound.protection.outlook.com ([40.107.22.64]:65377
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233896AbhBYLvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 06:51:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc3mj6suLGQ9CIQoUG+6W646URMM+ZWWEbvsexqx8sFcKGHR74/oV99KboXuSvmbqgML0kuBxGo4SPzKLILkNrmj6SYccID5CihD27Qrj1CMVv4H+n8C0pfs3y/SDcJ/LTh5/irN9GES/QtQEC3tcVaYX92jHjKz0xdVRz+DXaEKYXgyAfDMiVJ4rXd1TT+7+EZURAJnSmaJDUzXsbSYOE23jkLP4nZUsB4Ki+Yp0+toni+stchgcQ+nQyNiYHWbd9H29KQt2r5SWvM1crz6SXDrsAVWxrPRpHKRDFUgwRPZ9m6K7OK8V81kEgBJe5PgT4YeBAUpFU6O1EXlt4REaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=or3rIzBzVoJ3BWjjobptFZanjRgYnHlvgfjdOWSsqfE=;
 b=U3Cgv9XzREVZg/VeqBP5Z3ulbi/wEnaRUZn1fEPmiduVTtE3I0Uy5+cykzfrQf3VDRfkEtBeiQd24qxzVtK/cqUZ2Ho+66IawUWWEydOQqJFZNmZAASOG+F2izRRWhKXNJF9uBCnCGykWgWkIwn2FdcK5tLaIRBGPYgW6qum7QM6iPg57p9jWzXq6+MgOo7ZWJS8VligVMkUqu1YjukvlBEo4Y0t0kQvny+aYPAa7bFXraLy/mtvI5UviX3k22ffa1EGho4CO7VL93IKq8OBQVtZN3l86dywiC6PFAz3ec9s2VciAaagnC3/xDI2HmJ1rzEjc0w9KPQagsWp7HYUzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=or3rIzBzVoJ3BWjjobptFZanjRgYnHlvgfjdOWSsqfE=;
 b=kXeaMa6nFdCIA1GNy+1dSyjTW/1tgD+hcmU/2e+corS0gMl+z7/6oPDQPX6q+CxYsaak0my6Lyhoez/flSEa6MRiiXRbO6bNalL0jGxo/l2tCpFyEn+MGfy1B2uiKlgSyzUP4GWeE0QRf573ZsnCPD5+kYPs/u/PDu3v8NEHoqs=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB5132.eurprd04.prod.outlook.com (2603:10a6:10:15::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.31; Thu, 25 Feb
 2021 11:50:30 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3846.045; Thu, 25 Feb 2021
 11:50:30 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org
Subject: [RFC V2 net-next 1/3] net: stmmac: add clocks management for gmac driver
Date:   Thu, 25 Feb 2021 19:50:48 +0800
Message-Id: <20210225115050.23971-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
References: <20210225115050.23971-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR04CA0132.apcprd04.prod.outlook.com
 (2603:1096:3:16::16) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR04CA0132.apcprd04.prod.outlook.com (2603:1096:3:16::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20 via Frontend Transport; Thu, 25 Feb 2021 11:50:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a22677c6-d6ad-48f2-2d96-08d8d9838cc6
X-MS-TrafficTypeDiagnostic: DB7PR04MB5132:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5132B8E9F861CBC2CF402B24E69E9@DB7PR04MB5132.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0TUEHIBPeNGkUYqit1l87uufluRyTPhl2COFcNMOqmGXxqP6MJPXHijQw/Pp/c4ynxUBNoCRooAhuA8wNdQxWpgPWuqKMeYjFThtEKvmHDcoLL7zrnTGwVBspfAkT6ZrbK7SpPWQdCd3Jkt9iEjtc+BpChjkhkvnkWlv4xGg7RWbKdzx0CecRUaAWOfn7t7vqG2wniFKlhwFPBG5bKIkYQcZG7TW+6RK1txV5vw6H8Z+wLPBmHuUDGSCZ+EhehyxQt50MK9tx3OYZOHDCx4zmBj8P+3JOk6ikZneRFl9rIalkSWn79tfazu8iwfS4VVVvYZzD6dFbI6knNSEztK87uucpO3IVwPvUpritBWZEIohaptkCVc1+kn8HcCrwVkyC7vMU/3ZgXVin3J2/7GimFQntrSlrS4YqGYNBO2Z8HY1IM+SXf5W9GYzBhAmGwRgVdLwkqor5ONgXqdci+6rGNA0GCnNjswCm6mfLKrJPyeW2O/atKsh6bOgXiMvtk/0KWu2YitC/a3XAvR1LjGB5cch5VL1HJHkYyg/v7F5iBYldxeIFPsjiMDP001IckPgfM3hV9QjOfJ/OoJes2uloA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(366004)(39860400002)(346002)(8676002)(6486002)(6512007)(186003)(26005)(316002)(5660300002)(69590400012)(1076003)(52116002)(36756003)(16526019)(8936002)(478600001)(30864003)(6666004)(83380400001)(956004)(6506007)(2906002)(86362001)(66946007)(4326008)(2616005)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?eC+LynmQ4e0drw+BtDLPrLv3XFuHpjdAt2samM31sP68zVGXmyKuK3AumTo2?=
 =?us-ascii?Q?d+HooqRRZPu73Djkc0pLNAzhtJ2qK3TomXRsWyoUZYi/h/+sQM6nKXiUINSM?=
 =?us-ascii?Q?TlBPg2O+rn9tY+IXwBwLTyReRdhbf4ACMHUpOF82CsoBDyl2yaGypMHBWdpb?=
 =?us-ascii?Q?8me1Scd9IL6NKNOrMr/dONw3PycCIEQ9u2pO+jAIZbbayX7VJKs/KYFwZnOu?=
 =?us-ascii?Q?CB/NFyzabX1gr5bGC8ttIIqgDUxqztk2hCLm1BBn8kZ5Hl8eAoxWjN4IyB3f?=
 =?us-ascii?Q?wjXR6o6liMv2Lf8IWQQLO3ALBJ3uMgeQXEL+L6/rZP7iB3ZN7e/jsGECwsma?=
 =?us-ascii?Q?lzeBRJVBGMpY4Q6gFQrG/na9zQfFSNMwjrex1ximywK5TCFQWHyTDlcgKpvP?=
 =?us-ascii?Q?m7kYF+sFt9hDXCcDwleZhh/ksEkww2/FWRMmXGSQSiFIT5UUW2FsKKUnBz5g?=
 =?us-ascii?Q?jK0JIWTjUjcepPcKImjq9TslFawSiZ6hem9OLRI64V/2m9KMDHIclQYojuxO?=
 =?us-ascii?Q?pF4dBf2liIz3bcJeMaAqBW02o8ut53n9G6y0d4CaYm1oYK0QBPuPTwkV7OvR?=
 =?us-ascii?Q?eRlwrj82AkEtqg+3bIbh305wJAl+On3jlZt1E/B3jIuGT6Azy3LuvP1ejS8R?=
 =?us-ascii?Q?XtVgaEyr/kfkjWgNG39ta7T5Ia9tIOJ+QBF6FvKNSblhy6j0EQ18S1lvxEMg?=
 =?us-ascii?Q?1akveOdvqrTzPOPPZXEkUjVx8XXBjOzHzQr1P8kwAmb8QXSTlVl4wE/ZLSUV?=
 =?us-ascii?Q?j7CPuJ5OADPleVdgeNKntf2bpe5rJZQkbbr15+u16qNeAIerXso1O+TAigwf?=
 =?us-ascii?Q?KR6l8rzZUlkCSTzwK51jZWqagTc3w/BKfxHebTQL/yh3v3Y917B5lBkr0hQU?=
 =?us-ascii?Q?g7173S6CNHfGdgrwsRz1hK52dWuSeeE9vXsAnkZSuZjfKCiFLRXpSzY7zWJg?=
 =?us-ascii?Q?PwdWT7QC1wUsjSo4vyCspTt1w30i320FVZ45giLJVqmQkJ0woKuUZrYR14x6?=
 =?us-ascii?Q?Za/4yOZLBqRPxw4DJ0pcdtM8jEKcdJsauyn5cU0f+/Xf2PlQMHlaS0d+WuF8?=
 =?us-ascii?Q?NXflS43bMwhpljCgRcYLvPd2DXOFIjqRp5eUDoClQ2iBOj7iRi7IZcz46Rkv?=
 =?us-ascii?Q?JS2cJdVdvutMkShGHRT4TaOjqCT+WbMCYNwCPAF8tetMbCpNch8W/OPUxaNE?=
 =?us-ascii?Q?patiO51vUzSi/xBXlENb5LC9n+392xh/xWkjmd10pBg70f3BnLTwzqvSfjUb?=
 =?us-ascii?Q?U+SHUBL+Sv1HT0Dau7r0YaQ+RFofMm3PQLqvVkj6znNjmMubM87RaY0ykK5q?=
 =?us-ascii?Q?4crSXl8hvf1BzE7odUQM25YH?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22677c6-d6ad-48f2-2d96-08d8d9838cc6
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2021 11:50:30.1235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WU2jR5Hbtl0LR/fN3OFPRvTGcr+icCJ1y2PvXVLzfXm3nyCg+jo1OyS1cG8AksCqjQqQdPTxVHJfw6wK0meyaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5132
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

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |   1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  74 ++++++++++--
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c | 105 ++++++++++++++----
 .../ethernet/stmicro/stmmac/stmmac_platform.c |  24 +++-
 4 files changed, 171 insertions(+), 33 deletions(-)

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
index 26b971cd4da5..291f530abada 100644
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
@@ -2800,6 +2823,12 @@ static int stmmac_open(struct net_device *dev)
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
@@ -2808,7 +2837,7 @@ static int stmmac_open(struct net_device *dev)
 			netdev_err(priv->dev,
 				   "%s: Cannot attach to PHY (error: %d)\n",
 				   __func__, ret);
-			return ret;
+			goto init_phy_error;
 		}
 	}
 
@@ -2924,6 +2953,8 @@ static int stmmac_open(struct net_device *dev)
 	free_dma_desc_resources(priv);
 dma_desc_error:
 	phylink_disconnect_phy(priv->phylink);
+init_phy_error:
+	pm_runtime_put(priv->device);
 	return ret;
 }
 
@@ -2974,6 +3005,8 @@ static int stmmac_release(struct net_device *dev)
 
 	stmmac_release_ptp(priv);
 
+	pm_runtime_put(priv->device);
+
 	return 0;
 }
 
@@ -4624,6 +4657,12 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
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
 
@@ -4632,10 +4671,15 @@ static int stmmac_vlan_rx_kill_vid(struct net_device *ndev, __be16 proto, u16 vi
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
@@ -5111,6 +5155,14 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	pm_runtime_get_noresume(device);
+	pm_runtime_set_active(device);
+	pm_runtime_enable(device);
+	/* Let pm_runtime_put() disable the clocks.
+	 * If CONFIG_PM is not enabled, the clocks will stay powered.
+	 */
+	pm_runtime_put(device);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5125,6 +5177,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
@@ -5157,8 +5210,8 @@ int stmmac_dvr_remove(struct device *dev)
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
@@ -5181,6 +5234,7 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
+	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5224,8 +5278,9 @@ int stmmac_suspend(struct device *dev)
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
 
@@ -5289,8 +5344,9 @@ int stmmac_resume(struct device *dev)
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
index d64116e0543e..f68adca7db6b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -17,6 +17,7 @@
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
 #include <linux/property.h>
+#include <linux/pm_runtime.h>
 #include <linux/slab.h>
 
 #include "dwxgmac2.h"
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
 	return readl(priv->ioaddr + mii_data) & GENMASK(15, 0);
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
@@ -164,8 +190,10 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 
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
@@ -174,6 +202,11 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 	/* Wait until any existing MII operation is complete */
 	return readl_poll_timeout(priv->ioaddr + mii_data, tmp,
 				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -193,9 +226,15 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
 	u32 value = MII_BUSY;
-	int data = 0;
+	int ret, data = 0;
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
@@ -216,20 +255,29 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	}
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
-		return -EBUSY;
+			       100, 10000)) {
+		ret = -EBUSY;
+		goto err_disable_clks;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
 
 	return data;
+
+err_disable_clks:
+	pm_runtime_put(priv->device);
+
+	return ret;
 }
 
 /**
@@ -248,9 +296,15 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
 	u32 value = MII_BUSY;
-	int data = phydata;
+	int ret, data = phydata;
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
@@ -275,8 +329,10 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 
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
@@ -285,6 +341,11 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	/* Wait until any existing MII operation is complete */
 	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
 				  100, 10000);
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

