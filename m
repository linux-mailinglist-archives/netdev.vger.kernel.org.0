Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C37F497C96
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 11:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236947AbiAXKBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 05:01:02 -0500
Received: from mga07.intel.com ([134.134.136.100]:24600 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236933AbiAXKAz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 05:00:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643018455; x=1674554455;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fcP5Mi3E+ddUCuSeWk/h23NjNWIPP76BCXW3Nop8uuI=;
  b=azwlsuTMIbyV3ChuHuHZUMD/EwqfL01hhc8zN4+aJkB7+Jl0L02U8o3Y
   VAcsmrYI7t5B/br72blM0ptAVznjNWnukDJaUzwhg9JCSsfqrkl04lcIX
   IFKt8bfOtmCtGoOVErbin49n5BcPlNdoAgkhrwaOdzABxmVuYTCUIyvk5
   RaMkeFyf2O/+PcCR3o4Wiz062G8TiqE/kp5jIGH/lYchWMR7Lfmq0Ev2h
   i/dSJOU0wD89nGL0Vlm0ayjvkI8gIZ6utNLt7nTiqlHSs5Y+7kHfXbitr
   BStRXoJY6d5P0pWyH+/GOKhMc2LENzNzgW/fsN5wvhFa9M4XhXUzB+IGY
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="309331470"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="309331470"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2022 02:00:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="519886979"
Received: from mismail5-ilbpg0.png.intel.com ([10.88.229.13])
  by orsmga007.jf.intel.com with ESMTP; 24 Jan 2022 02:00:43 -0800
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
        Huacai Chen <chenhuacai@kernel.org>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mohammad.athari.ismail@intel.com
Subject: [PATCH net 2/2] net: stmmac: skip only stmmac_ptp_register when resume from suspend
Date:   Mon, 24 Jan 2022 17:59:51 +0800
Message-Id: <20220124095951.23845-3-mohammad.athari.ismail@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
References: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d7e261768f73..cfea38a50a73 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -884,7 +884,7 @@ EXPORT_SYMBOL_GPL(stmmac_init_tstamp_counter);
  * This is done by looking at the HW cap. register.
  * This function also registers the ptp driver.
  */
-static int stmmac_init_ptp(struct stmmac_priv *priv)
+static int stmmac_init_ptp(struct stmmac_priv *priv, bool ptp_register)
 {
 	bool xmac = priv->plat->has_gmac4 || priv->plat->has_xgmac;
 	int ret;
@@ -914,7 +914,8 @@ static int stmmac_init_ptp(struct stmmac_priv *priv)
 	priv->hwts_tx_en = 0;
 	priv->hwts_rx_en = 0;
 
-	stmmac_ptp_register(priv);
+	if (ptp_register)
+		stmmac_ptp_register(priv);
 
 	return 0;
 }
@@ -3251,7 +3252,7 @@ static int stmmac_fpe_start_wq(struct stmmac_priv *priv)
  *  0 on success and an appropriate (-)ve integer as defined in errno.h
  *  file on failure.
  */
-static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
+static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	u32 rx_cnt = priv->plat->rx_queues_to_use;
@@ -3308,13 +3309,11 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 
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

