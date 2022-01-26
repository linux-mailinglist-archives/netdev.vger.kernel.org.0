Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63DFC49C6D7
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239371AbiAZJsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:48:24 -0500
Received: from mga18.intel.com ([134.134.136.126]:4595 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239366AbiAZJsW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 04:48:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643190502; x=1674726502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=MpWSglKXQYEeeqqBjrw+ec+l47eU3cuban3iOotIK3s=;
  b=LiX7XRbMTt/5ixoeYiYu8iJxHtvO4B7FvFc7Nxgds6rJn1QBesJXp9Uw
   2HQNr4Mo412gRLibO9YHw8TkXKHCGdqLl+rM3YGQtTERcgziiUXWl1B//
   P+eq/1FEyonwmFMZT3jtwbEE5vY5NLfwytE9frlGLLs1TQnTO/30TD5FQ
   T1ffmhI8YF7h4Smvp7mu2XmtWJ3qTPRmrOqSjO0nAX/CrYUH9851ZCoOT
   hcWwohaIEslV3sxmmgMxXwnlDiaTt5agNiNiLfUpGnUb8yTOKZUVdw8IN
   5q7IBETfHGnQ5S5JJFBK188/iiWDwKRfb3mDOJ/3T6CPdMYMZdPpALHtn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="230090791"
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="230090791"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 01:48:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,317,1635231600"; 
   d="scan'208";a="617918605"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Jan 2022 01:48:17 -0800
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
Subject: [PATCH net v3 2/2] net: stmmac: skip only stmmac_ptp_register when resume from suspend
Date:   Wed, 26 Jan 2022 17:47:23 +0800
Message-Id: <20220126094723.11849-3-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220126094723.11849-1-mohammad.athari.ismail@intel.com>
References: <20220126094723.11849-1-mohammad.athari.ismail@intel.com>
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
v3 changelog:
- Move the stmmac_ptp_register() call out to stmmac_hw_setup().
Commented by Jakub Kicinski <kuba@kernel.org>.

v2 changelog:
- Fix build warning related to "function parameter or member not described".
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 +++++++++----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7e261768f73..dfda1cbf81ae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -914,8 +914,6 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	priv->hwts_tx_en = 0;
 	priv->hwts_rx_en = 0;
 
-	stmmac_ptp_register(priv);
-
 	return 0;
 }
 
@@ -3241,7 +3239,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
- *  @init_ptp: initialize PTP if set
+ *  @ptp_register: register PTP if set
  *  Description:
  *  this is the main function to setup the HW in a usable state because the
  *  dma engine is reset, the core registers are configured (e.g. AXI,
@@ -3251,7 +3249,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3308,13 +3306,13 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
 	stmmac_mmc_setup(priv);
 
-	if (init_ptp) {
-		ret = stmmac_init_ptp(priv);
-		if (ret == -EOPNOTSUPP)
-			netdev_warn(priv->dev, "PTP not supported by HW\n");
-		else if (ret)
-			netdev_warn(priv->dev, "PTP init failed\n");
-	}
+	ret = stmmac_init_ptp(priv);
+	if (ret == -EOPNOTSUPP)
+		netdev_warn(priv->dev, "PTP not supported by HW\n");
+	else if (ret)
+		netdev_warn(priv->dev, "PTP init failed\n");
+	else if (ptp_register)
+		stmmac_ptp_register(priv);
 
 	priv->eee_tw_timer = STMMAC_DEFAULT_TWT_LS;
 
-- 
2.17.1

