Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD1727AD09
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 13:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgI1LoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 07:44:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:46587 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgI1LoG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Sep 2020 07:44:06 -0400
IronPort-SDR: RMBD5nS0uleBtOknPzxnjYOV52RPE+9ZTTxzRTgNNxYeWiDl/ivdjwvO3pcO/tHRvuP53Pm4lJ
 Jo17rPUK99OQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="161199267"
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="161199267"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2020 03:02:47 -0700
IronPort-SDR: wbQmmKheg/+0oMywBwwSEEZ1od9vO4aLwFCz9BUBu96o70II0gbT+1lC3283PUT0QG3y3R559e
 iqd+DbK55cZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,313,1596524400"; 
   d="scan'208";a="307275535"
Received: from climb.png.intel.com ([10.221.118.165])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2020 03:02:42 -0700
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
Subject: [PATCH v1 net] net: stmmac: Modify configuration method of EEE timers
Date:   Mon, 28 Sep 2020 18:02:41 +0800
Message-Id: <20200928100241.7673-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Vineetha G. Jaya Kumaran" <vineetha.g.jaya.kumaran@intel.com>

Ethtool manual stated that the tx-timer is the "the amount of time the
device should stay in idle mode prior to asserting its Tx LPI". The
previous implementation for "ethtool --set-eee tx-timer" sets the LPI TW
timer duration which is not correct.

Hence, this patch fixes the the configuration of LPI TW timer via
module parameters instead of ethtool. And, "ethtool --set-eee tx-timer"
should configure EEE LPI timer.

Fixes: d765955d2ae0 ("stmmac: add the Energy Efficient Ethernet support")
Signed-off-by: Vineetha G. Jaya Kumaran <vineetha.g.jaya.kumaran@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 12 ++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 35 +++++++++++--------
 4 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 127f75862962..7338babfebad 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -395,6 +395,7 @@ struct dma_features {
 /* Default LPI timers */
 #define STMMAC_DEFAULT_LIT_LS	0x3E8
 #define STMMAC_DEFAULT_TWT_LS	0x1E
+#define STMMAC_TWT_MAX		0xFFFF
 
 #define STMMAC_CHAIN_MODE	0x1
 #define STMMAC_RING_MODE	0x2
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 9c02fc754bf1..d5a83c45510e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -203,6 +203,7 @@ struct stmmac_priv {
 	int eee_enabled;
 	int eee_active;
 	int tx_lpi_timer;
+	int tx_lpi_enabled;
 	unsigned int mode;
 	unsigned int chain_mode;
 	int extend_desc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 430a4b32ec1e..348bb8a9cf7f 100644
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
+	if (edata->eee_enabled && priv->tx_lpi_enabled &&
+	    priv->tx_lpi_timer != edata->tx_lpi_timer) {
+		priv->tx_lpi_timer = edata->tx_lpi_timer;
+		stmmac_eee_init(priv);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 89b2b3472852..2d1b9b76d678 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -90,11 +90,12 @@ static const u32 default_msg_level = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 				      NETIF_MSG_LINK | NETIF_MSG_IFUP |
 				      NETIF_MSG_IFDOWN | NETIF_MSG_TIMER);
 
-#define STMMAC_DEFAULT_LPI_TIMER	1000
-static int eee_timer = STMMAC_DEFAULT_LPI_TIMER;
-module_param(eee_timer, int, 0644);
-MODULE_PARM_DESC(eee_timer, "LPI tx expiration time in msec");
-#define STMMAC_LPI_T(x) (jiffies + msecs_to_jiffies(x))
+#define STMMAC_DEFAULT_LPI_TIMER	1000000
+#define STMMAC_LPI_T(x)	(jiffies + usecs_to_jiffies(x))
+
+static int tw_timer = STMMAC_DEFAULT_TWT_LS;
+module_param(tw_timer, int, 0644);
+MODULE_PARM_DESC(tw_timer, "LPI TW timer value in msec");
 
 /* By default the driver will use the ring mode to manage tx and rx descriptors,
  * but allow user to force to use the chain instead of the ring
@@ -130,8 +131,8 @@ static void stmmac_verify_args(void)
 		flow_ctrl = FLOW_OFF;
 	if (unlikely((pause < 0) || (pause > 0xffff)))
 		pause = PAUSE_TIME;
-	if (eee_timer < 0)
-		eee_timer = STMMAC_DEFAULT_LPI_TIMER;
+	if (tw_timer < 0 || tw_timer > STMMAC_TWT_MAX)
+		tw_timer = STMMAC_DEFAULT_TWT_LS;
 }
 
 /**
@@ -370,7 +371,7 @@ static void stmmac_eee_ctrl_timer(struct timer_list *t)
 	struct stmmac_priv *priv = from_timer(priv, t, eee_ctrl_timer);
 
 	stmmac_enable_eee_mode(priv);
-	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(priv->tx_lpi_timer));
 }
 
 /**
@@ -403,7 +404,7 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 		if (priv->eee_enabled) {
 			netdev_dbg(priv->dev, "disable EEE\n");
 			del_timer_sync(&priv->eee_ctrl_timer);
-			stmmac_set_eee_timer(priv, priv->hw, 0, tx_lpi_timer);
+			stmmac_set_eee_timer(priv, priv->hw, 0, tw_timer);
 		}
 		mutex_unlock(&priv->lock);
 		return false;
@@ -411,11 +412,12 @@ bool stmmac_eee_init(struct stmmac_priv *priv)
 
 	if (priv->eee_active && !priv->eee_enabled) {
 		timer_setup(&priv->eee_ctrl_timer, stmmac_eee_ctrl_timer, 0);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
 		stmmac_set_eee_timer(priv, priv->hw, STMMAC_DEFAULT_LIT_LS,
-				     tx_lpi_timer);
+				     tw_timer);
 	}
 
+	mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(tx_lpi_timer));
+
 	mutex_unlock(&priv->lock);
 	netdev_dbg(priv->dev, "Energy-Efficient Ethernet initialized\n");
 	return true;
@@ -930,6 +932,7 @@ static void stmmac_mac_link_down(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	priv->eee_active = false;
+	priv->tx_lpi_enabled = false;
 	stmmac_eee_init(priv);
 	stmmac_set_eee_pls(priv, priv->hw, false);
 }
@@ -1027,6 +1030,7 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 	if (phy && priv->dma_cap.eee) {
 		priv->eee_active = phy_init_eee(phy, 1) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
+		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
 	}
 }
@@ -2061,7 +2065,8 @@ static int stmmac_tx_clean(struct stmmac_priv *priv, int budget, u32 queue)
 
 	if ((priv->eee_enabled) && (!priv->tx_path_in_lpi_mode)) {
 		stmmac_enable_eee_mode(priv);
-		mod_timer(&priv->eee_ctrl_timer, STMMAC_LPI_T(eee_timer));
+		mod_timer(&priv->eee_ctrl_timer,
+			  STMMAC_LPI_T(priv->tx_lpi_timer));
 	}
 
 	/* We still have pending packets, let's call for a new scheduling */
@@ -2694,7 +2699,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 			netdev_warn(priv->dev, "PTP init failed\n");
 	}
 
-	priv->tx_lpi_timer = STMMAC_DEFAULT_TWT_LS;
+	priv->tx_lpi_timer = STMMAC_DEFAULT_LPI_TIMER;
 
 	if (priv->use_riwt) {
 		if (!priv->rx_riwt)
@@ -5255,8 +5260,8 @@ static int __init stmmac_cmdline_opt(char *str)
 		} else if (!strncmp(opt, "pause:", 6)) {
 			if (kstrtoint(opt + 6, 0, &pause))
 				goto err;
-		} else if (!strncmp(opt, "eee_timer:", 10)) {
-			if (kstrtoint(opt + 10, 0, &eee_timer))
+		} else if (!strncmp(opt, "tw_timer:", 10)) {
+			if (kstrtoint(opt + 10, 0, &tw_timer))
 				goto err;
 		} else if (!strncmp(opt, "chain_mode:", 11)) {
 			if (kstrtoint(opt + 11, 0, &chain_mode))
-- 
2.17.1

