Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F749AD95
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 08:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443458AbiAYH0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 02:26:03 -0500
Received: from mga06.intel.com ([134.134.136.31]:11673 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1324845AbiAYDeN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 22:34:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643081653; x=1674617653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=8ucIpNbwLKGUANZTl44G5Tsgc2DPHdejNQlu4/aegko=;
  b=bIj0+mqFnr8rkpNH+C5RXD3UNTFfYCByL+yTmyju4Dx/p5sZn4LQB1CB
   yukNioJW1AABANiq2eNB6GhbAoytUAdEAI/nUZzFR4i47C3DPSXd4+BWL
   GSst27XbAnRr1+gJQ+ASatID/Z+WuuoHlbJYIxpdpnLboDHE/MQw5Nklu
   tmEkoE3BiUtDrUSGeAWewO32MLZY/Q/vp43YAuCYcngGJNEM0rcbuYPgP
   i4+wOXw5K8blGcEA2Ewo/U3aNhaep5CgYuFLjg2ZCEwOCAXphIbLawyMc
   d5J8HguAdozBeZZzJ1chZEmU/iGCyVpfN1Dg1zY2E0ASVru02eJzkFcuH
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10237"; a="306923149"
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="306923149"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 19:24:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,314,1635231600"; 
   d="scan'208";a="532293091"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jan 2022 19:24:20 -0800
From:   Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, mohammad.athari.ismail@intel.com
Subject: [PATCH net v2 2/2] net: stmmac: skip only stmmac_ptp_register when resume from suspend
Date:   Tue, 25 Jan 2022 11:23:24 +0800
Message-Id: <20220125032324.4055-3-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220125032324.4055-1-mohammad.athari.ismail@intel.com>
References: <20220125032324.4055-1-mohammad.athari.ismail@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When resume from suspend, besides skipping PTP registration, it also
skipping PTP HW initialization. This could cause PTP clock not able to
operate properly when resume from suspend.

To fix this, only stmmac_ptp_register() is skipped when resume from
suspend.

Fixes: fe1319291150 ("stmmac: Don't init ptp again when resume from suspend/hibernation")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>
---
v2 changelog:
- Fix build warning related to "function parameter or member not described".
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7e261768f73..b8e5e19e6f7b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -880,11 +880,12 @@ EXPORT_SYMBOL_GPL(stmmac_init_tstamp_counter);
 /**
  * stmmac_init_ptp - init PTP
  * @priv: driver private structure
+ * @ptp_register: register PTP if set
  * Description: this is to verify if the HW supports the PTPv1 or PTPv2.
  * This is done by looking at the HW cap. register.
  * This function also registers the ptp driver.
  */
-static int stmmac_init_ptp(struct stmmac_priv *priv)
+static int stmmac_init_ptp(struct stmmac_priv *priv, bool ptp_register)
 {
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 	int ret;
@@ -914,7 +915,8 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	priv->hwts_tx_en = 0;
 	priv->hwts_rx_en = 0;
 
-	stmmac_ptp_register(priv);
+	if (ptp_register)
+		stmmac_ptp_register(priv);
 
 	return 0;
 }
@@ -3241,7 +3243,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
- *  @init_ptp: initialize PTP if set
+ *  @ptp_register: register PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -3251,7 +3253,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3308,13 +3310,11 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
 	stmmac_mmc_setup(priv);
 
-	if (init_ptp) {
-		ret = stmmac_init_ptp(priv);
-		if (ret == -EOPNOTSUPP)
-			netdev_warn(priv->dev, "PTP not supported by HW\n");
-		else if (ret)
-			netdev_warn(priv->dev, "PTP init failed\n");
-	}
+	ret = stmmac_init_ptp(priv, ptp_register);
+	if (ret == -EOPNOTSUPP)
+		netdev_warn(priv->dev, "PTP not supported by HW\n");
+	else if (ret)
+		netdev_warn(priv->dev, "PTP init failed\n");
 
 	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
 
-- 
2.17.1

