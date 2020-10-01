Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC0128034C
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 17:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732631AbgJAP4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 11:56:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:54370 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732287AbgJAP4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 11:56:20 -0400
IronPort-SDR: VgPARqbVx28XWXH/wexLPJfZhX86Z8m5uUbo+wDky2raOd8qsn2sL+tEhpwok6UhN2ybmgbd6/
 YmmN7HPTZe2w==
X-IronPort-AV: E=McAfee;i="6000,8403,9761"; a="180915113"
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="180915113"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2020 08:56:15 -0700
IronPort-SDR: 0FGR+hSArpUOyW+LXKW7FMaIaUwL+MEEAmsgyrDgdLSri9udMoTNR9NShGDFyX5UwmSEqNbHr7
 TXYQNqFFwapQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,323,1596524400"; 
   d="scan'208";a="351182288"
Received: from climb.png.intel.com ([10.221.118.165])
  by FMSMGA003.fm.intel.com with ESMTP; 01 Oct 2020 08:56:10 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH v2 net] net: stmmac: Modify configuration method of EEE timers
Date:   Thu,  1 Oct 2020 23:56:09 +0800
Message-Id: <20201001155609.5372-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>

Ethtool manual stated that the tx-timer is the "the amount of time the
device should stay in idle mode prior to asserting its Tx LPI". The
previous implementation for "ethtool --set-eee tx-timer" sets the LPI TW
timer duration which is not correct. Hence, this patch fixes the
"ethtool --set-eee tx-timer" to configure the EEE LPI timer.

The LPI TW Timer will be using the defined default value instead of
"ethtool --set-eee tx-timer" which follows the EEE LS timer implementation.

Fixes: d765955d2ae0 ("stmmac: add the Energy Efficient Ethernet support")
Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

Changelog V2
*Not removing/modifying the eee_timer.
*EEE LPI timer can be configured through ethtool and also the eee_timer
module param.
*EEE TW Timer will be configured with default value only, not able to be
configured through ethtool or module param. This follows the implementation
of the EEE LS Timer.
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  2 ++
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 12 +++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 23 ++++++++++++-------
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 9c02fc754bf1..545696971f65 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -203,6 +203,8 @@ struct stmmac_priv {
 	int eee_enabled;
 	int eee_active;
 	int tx_lpi_timer;
+	int tx_lpi_enabled;
+	int eee_tw_timer;
 	unsigned int mode;
 	unsigned int chain_mode;
 	int extend_desc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 430a4b32ec1e..814879f91f76 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -665,6 +665,7 @@ static int stmmac_ethtool_op_get_eee(struct net_device *dev,
 	edata->eee_enabled = priv->eee_enabled;
 	edata->eee_active = priv->eee_active;
 	edata->tx_lpi_timer = priv->tx_lpi_timer;
+	edata->tx_lpi_enabled = priv->tx_lpi_enabled;
 
 	return phylink_ethtool_get_eee(priv->phylink, edata);
 }
@@ -678,6 +679,10 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	if (!priv->dma_cap.eee)
 		return -EOPNOTSUPP;
 
+	if (priv->tx_lpi_enabled != edata->tx_lpi_enabled)
+		netdev_warn(priv->dev,
+			    "Setting EEE tx-lpi is not supported\n");
+
 	if (!edata->eee_enabled)
 		stmmac_disable_eee_mode(priv);
 
@@ -685,7 +690,12 @@ static int stmmac_ethtool_op_set_eee(struct net_device *dev,
 	if (ret)
 		return ret;
 
-	priv->tx_lpi_timer = edata->tx_lpi_timer;
+	if (edata->eee_enabled &&
+	    priv->tx_lpi_timer != edata->tx_lpi_timer) {
+		priv->tx_lpi_timer = edata->tx_lpi_timer;
+		stmmac_eee_init(priv);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89b2b3472852..b56b13d64ab4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -94,7 +94,7 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 static int eee_timer = STMMAC_DEFAULT_LPI_TIMER;
 module_param(eee_timer, int, 0644);
 MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
-#define STMMAC_LPI_T(x) (jiffies + msecs_to_jiffies(x))
+#define STMMAC_LPI_T(x) (jiffies + usecs_to_jiffies(x))
 
 /* By default the driver will use the ring mode to manage tx and rx descriptors,
  * but allow user to force to use the chain instead of the ring
@@ -370,7 +370,7 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 	struct stmmac_priv *priv = from_timer(priv, t, eee_ctrl_timer);
 
 	stmmac_enable_eee_mode(priv);
-	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 }
 
 /**
@@ -383,7 +383,7 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
  */
 bool stmmac_eee_init(struct stmmac_priv *priv)
 {
-	int tx_lpi_timer = priv->tx_lpi_timer;
+	int eee_tw_timer = priv->eee_tw_timer;
 
 	/* Using PCS we cannot dial with the phy registers at this stage
 	 * so we do not support extra feature like EEE.
@@ -403,7 +403,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 		if (priv->eee_enabled) {
 			netdev_dbg(priv->dev, "disable EEE\n");
 			del_timer_sync(&priv->eee_ctrl_timer);
-			stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+			stmmac_set_eee_timer(priv, priv->hw, 0, eee_tw_timer);
 		}
 		mutex_unlock(&priv->lock);
 		return false;
@@ -411,11 +411,12 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 
 	if (priv->eee_active && !priv->eee_enabled) {
 		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
 		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
-				     tx_lpi_timer);
+				     eee_tw_timer);
 	}
 
+	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
+
 	mutex_unlock(&priv->lock);
 	netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
 	return true;
@@ -930,6 +931,7 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	priv->eee_active = false;
+	priv->tx_lpi_enabled = false;
 	stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
 }
@@ -1027,6 +1029,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
+		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
 	}
 }
@@ -2061,7 +2064,7 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
 		stmmac_enable_eee_mode(priv);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 	}
 
 	/* We still have pending packets, let's call for a new scheduling */
@@ -2694,7 +2697,11 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			netdev_warn(priv->dev, "PTP init failed\n");
 	}
 
-	priv->tx_lpi_timer = STMMAC_DEFAULT_TWT_LS;
+	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
+
+	/* Convert the timer from msec to usec */
+	if (!priv->tx_lpi_timer)
+		priv->tx_lpi_timer = eee_timer * 1000;
 
 	if (priv->use_riwt) {
 		if (!priv->rx_riwt)
-- 
2.17.1

