Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB41332C41E
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354849AbhCDALV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:11:21 -0500
Received: from mail-vi1eur05on2085.outbound.protection.outlook.com ([40.107.21.85]:18433
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1356737AbhCCKsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 05:48:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k/XEk4TK6zytUvblHE3XayE0OWF0i/yXvcpVeNcolJGvWSnl5SgZdp4r7ow969a/WnAu/yztTgj3d5mMnkPziY1ujMS5MGLB+mRC8YbTHtF4UOI9WMjyjkiP9u/XOzG+Y0OKAEqy7a6za1CRvpcvuJIsr7bsyfjP5S+jcqxNvFovCCpKD2ki7s53CP+3R2pWHltcKxrtOxVnXmgUsR03Ld1Hzcy+jUll6UxHZZ9DYAXNx6qBGLrtfHhfcki/CkqVXmAVh9z59w/TuflgKiXhKn1HTVbJ0jD7KNxspki1CWAZOhLC8jtf7OKyzY+fPffla39vnhDg3iVJWDPZ1zVnrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkCYo4fKjpVgt9zLTiIz1JcvJNOPRBQxq2Y7oszUX9s=;
 b=O+O1npKFNDJPL4iUm77Pk9doXsAmY7rtWa38gdtrGtVJePeZfy8bDbV82dIYESJMwYSraQv/j8r8lPjccWwOTpHcNQCSwlt+/BbmREysE8cb35vdWl2Z1d6nWrizTo9+bbw8GF7atlGOZlbsk3gThEFI6WFdUjpMU0iMvJieRSccn1CRSDPG6cPAuO94MQMGAJ/Fx96bGPIZfs4O93NoFbT5WX1NuE1goUlMK7yj5czrW11/Em/X+EniZ4ixf7zHWM5I83nirga9WaeXyHIfdxfeOJrw+BQKifBqjHeTIPUlCAWHw7BC/SuzEHjcIckDQWxQrRGLaMJjhvBgYwZ38A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mkCYo4fKjpVgt9zLTiIz1JcvJNOPRBQxq2Y7oszUX9s=;
 b=dBjlqrrvIXX8UOGIL6Bv+Zkc+DsPfIt4QygftdL2q2c+jtVUDNaW3YPIDAAbqjokAQii7hFiSS+rXA9tX244hwDooOCpwFUuYkkNbPgMScuuLodP2U+ScxHiHtFn7akT1SCDPLGcJPVUmeov0QgL8glowJVckOIbeBLUmLEXau0=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB6252.eurprd04.prod.outlook.com (2603:10a6:10:c8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Wed, 3 Mar
 2021 10:47:26 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::7d13:2d65:d6f7:b978%4]) with mapi id 15.20.3890.029; Wed, 3 Mar 2021
 10:47:26 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
Subject: [RFC V3 net-next 1/3] net: stmmac: add clocks management for gmac driver
Date:   Wed,  3 Mar 2021 18:47:22 +0800
Message-Id: <20210303104724.1316-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
References: <20210303104724.1316-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: HK2PR04CA0068.apcprd04.prod.outlook.com
 (2603:1096:202:15::12) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by HK2PR04CA0068.apcprd04.prod.outlook.com (2603:1096:202:15::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 3 Mar 2021 10:47:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48ae5358-44b7-4b77-d0ad-08d8de31bbd7
X-MS-TrafficTypeDiagnostic: DBBPR04MB6252:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB625204F3E08BA7FAB45A417FE6989@DBBPR04MB6252.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V7Jz5ksbS81lYZNf10o1szXOe2XBXcGSohj03f1j7acpD5CDljQya33jY4/VRKCcWaGXgOLoTNAQOtXIeSE1PrfM+r9fENsmdRvFFtwLVcWG8ZB3big7yL9JoQ7LhSS310NCjNacxcrh5xGF7DkhdGLA9SJvtDE42PAHddUJYf+kOZH16s/mgf9FpC2yKXvCzcjXSZOW5YrvUZ2SWUUHPIhDdT+ikUZ1xO2zSQgTFX5TAV0y/+ZxyYeaqHTu9uueUtefIp2rx6DLTH7szkDcNXIrzrpPSEYVK93i3FOO4cBySd0uD7XW6qC6GrbuAJn3bsuE9FGiO/mNQV6cn1KyAEefQNdzenQ8mJe8bIIHEKZZFnh9FLHxTHejW3brVXrmW7lGvroqSAEDkslyCZcawrmxfNqXTshOsminsQi0PyoEJ89c89MMiMf+ypeSw2FnffIkD+E9h2FbPewSzBH0YvqaQBbqO0LkSY6NfZVZZ0oE3e+tyqzdbvDrrBumXaUeawJXuZrpEOKHWefVvNarYG4uMGApE7VP+h1QrC32gWB7qzcXTFMVgOY62LR+n59dTk2X5og+Qz+5kH4iG4CgWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(478600001)(956004)(316002)(6486002)(66946007)(66556008)(16526019)(186003)(2616005)(26005)(66476007)(8936002)(2906002)(4326008)(8676002)(52116002)(30864003)(5660300002)(36756003)(6512007)(83380400001)(86362001)(1076003)(6506007)(69590400012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?dOkCNeCDxDeH90uk9DyxJEdHRlD9bS+QwSpus42Dd+dx0ygYA6o5EkqfSp9t?=
 =?us-ascii?Q?HDyAHidZfYw5wzbiAwEYglBhee7rI0H4F7Iqj17SQQFHIM8sa+KGuD2uPKyT?=
 =?us-ascii?Q?lH+I078BJKRk85iZjqGOgzpnas4jxPrbvmBq0bMxVTk5EQVvQDcx6gITVgCD?=
 =?us-ascii?Q?STmqFE0v+fDLiUWGveUkRhr2aH2ZtEGwzWvjDHlVAdO7vGfmibzxcOXaBvTx?=
 =?us-ascii?Q?BLN/PFaCpiQMxMf7E53xjl2bjvaq6wvpg0CTClKbBVhST6kdVJaTtZdolwm7?=
 =?us-ascii?Q?15gIE0lQqfb1jyJNjeLTyinbW0eub2U2NaOONq2XxnT2HVpGRZjpuBZ5GpZJ?=
 =?us-ascii?Q?2RMqIdg+8YG5nzaNyXfqOO/RziKYmv7HrPmqHhOzm24j3PXSMN8Jy0SOwr5j?=
 =?us-ascii?Q?cXYKUpRwhtgrEGpGUKYcI9fjIy58iMoK2PTOuYGU+cIvoC6PrA0ybumvr4XI?=
 =?us-ascii?Q?KVNXUmV/oQYET0IcoN6eRtzczNx0ENT765rvdKokvBlYapd0o1d0L4xqCI21?=
 =?us-ascii?Q?JxbjrSNYY8VHMJslWwXh/4qPspP4DQYyK9i+4to7Yjb2qqlNpMfXSjjk3gLU?=
 =?us-ascii?Q?aEbk7EwCtbHgFb/AKccBFdGpi7QYtlYR6vFbR3urpJQnAnmdBtqJMhgmDIIm?=
 =?us-ascii?Q?Q7iU5x7Ufz+SXz2azX03BFdhvBvj/CFqcRMPrL69Xbw2L5I7ZsXfpnrehC/X?=
 =?us-ascii?Q?4N7xZSggIvvseAtr/ZF2JNiVoldXczzPgVHwfM8nFzaKdP4Kmw3wmurIdzL9?=
 =?us-ascii?Q?VX9m3kBn+OBWxzB0NMy16PL3hfeuB3N7DOvQfQh+2VruKBm0kECXmyuBVXMA?=
 =?us-ascii?Q?UkafD424f/BT243MdCXo1rDrjVHfvPfOsnpeYZsmgYtovMWnPs/8gvKwX1Nm?=
 =?us-ascii?Q?r5AG4yrP19OSl3WT+ovuc83Q5z9q9LoJvSRGc9JV3pvxZ3w6WhjSZ/VF6si3?=
 =?us-ascii?Q?ZcZOLENwxSBQ9vZDhysLcPertaXoR50PrYI8WBeH7kC1Cs8qT2/iEF/AZT1R?=
 =?us-ascii?Q?P+XL99k9uu1LMuJK1EpZUy2CSxfZoIUY2OYastA7Whx6fcFvMi0++ylMRmg2?=
 =?us-ascii?Q?PIcjRNefRC5ZECpXPc3ryFXh/sWWAUgxJTrB2qZxlviU+W2wT7HoYkamn1X5?=
 =?us-ascii?Q?PaLovSJs5YV4WYpmMMnT/xnXfete21Xia2zUVuRK+9HHC6v05ty8/cDn+Zut?=
 =?us-ascii?Q?FmEFrkO+j6MT9+Y8IJgo7Kp5iBg392W4LgE99Y2nedubISW8U+HDmx4laXaO?=
 =?us-ascii?Q?rHmVuWPN7ewK9Tq8ZEduxCWIPr2XxuymwHcYHeKGZbbJayCApbgPZAWmcN6o?=
 =?us-ascii?Q?JZER8EHyQEvqZTd/C7q9KfLD?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ae5358-44b7-4b77-d0ad-08d8de31bbd7
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2021 10:47:26.3094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SoERdlTujh+goLeHVNEAVPXjM4zhKImxqbYFLPw9MnmWaSWGgMeSmAhi/k5XvImW8CmgR1rjhh2mL2o7BEl7xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6252
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
index 26b971cd4da5..b4bc1c2104df 100644
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
@@ -5074,6 +5118,10 @@ int stmmac_dvr_probe(struct device *device,
 
 	stmmac_check_pcs_mode(priv);
 
+	pm_runtime_get_noresume(device);
+	pm_runtime_set_active(device);
+	pm_runtime_enable(device);
+
 	if (priv->hw->pcs != STMMAC_PCS_TBI &&
 	    priv->hw->pcs != STMMAC_PCS_RTBI) {
 		/* MDIO bus Registration */
@@ -5111,6 +5159,11 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_init_fs(ndev);
 #endif
 
+	/* Let pm_runtime_put() disable the clocks.
+	 * If CONFIG_PM is not enabled, the clocks will stay powered.
+	 */
+	pm_runtime_put(device);
+
 	return ret;
 
 error_serdes_powerup:
@@ -5125,6 +5178,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_del(ndev);
 error_hw_init:
 	destroy_workqueue(priv->wq);
+	stmmac_bus_clks_config(priv, false);
 
 	return ret;
 }
@@ -5157,8 +5211,8 @@ int stmmac_dvr_remove(struct device *dev)
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
@@ -5181,6 +5235,7 @@ int stmmac_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct stmmac_priv *priv = netdev_priv(ndev);
 	u32 chan;
+	int ret;
 
 	if (!ndev || !netif_running(ndev))
 		return 0;
@@ -5224,8 +5279,9 @@ int stmmac_suspend(struct device *dev)
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
 
@@ -5289,8 +5345,9 @@ int stmmac_resume(struct device *dev)
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

