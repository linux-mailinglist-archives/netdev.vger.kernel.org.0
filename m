Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C68562EE3E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 08:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241139AbiKRHVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 02:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiKRHVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 02:21:33 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15187CB85;
        Thu, 17 Nov 2022 23:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668756092; x=1700292092;
  h=from:to:cc:subject:date:message-id;
  bh=yVx7b9riDY5Xky/FC/Uq65fzL5vq5lBWcvMLLJea91s=;
  b=FQWvikmSQBeBEH5OnHHkHMhKxjAYW724jyrpLBGzqGuTvsYx6fxgfr8p
   vAxE9bSPuFUdclGn6l1E7ww9e3XQ6SmnNePp8rgaobwFBIBN6iLFDLOii
   4PvVfojwcXrB59zipRPal94eAcQMwu8E8zz18+GGRZnkmJMK6+LAC0tox
   PM6Z7ZYuLNNyJ+zpbf9azmw1C24sP3b8QO/tCEZ5uCWjSddUNDEtGov/k
   a998U6BwXy/UXno+1QWkzAqKZ4lXU7G6w4S5Ua9g9JYZlaxiGlDqhzNOm
   hxqFiNwHVOpYnPHts9adC8xz+O3+4nuC1VhiVGv+75RFUXbxvkanC3Y5x
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="339912044"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="339912044"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2022 23:21:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10534"; a="782550203"
X-IronPort-AV: E=Sophos;i="5.96,173,1665471600"; 
   d="scan'208";a="782550203"
Received: from p12ill01gohweish.png.intel.com ([10.88.229.16])
  by fmsmga001.fm.intel.com with ESMTP; 17 Nov 2022 23:21:28 -0800
From:   "Goh, Wei Sheng" <wei.sheng.goh@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Ahmad Tarmizi Noor Azura <noor.azura.ahmad.tarmizi@intel.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Goh Wei Sheng <wei.sheng.goh@intel.com>
Subject: [PATCH net] net: stmmac: Set MAC's flow control register to reflect current settings
Date:   Fri, 18 Nov 2022 15:20:51 +0800
Message-Id: <20221118072051.31313-1-wei.sheng.goh@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, pause frame register GMAC_RX_FLOW_CTRL_RFE is not updated
correctly when 'ethtool -A <IFACE> autoneg off rx off tx off' command
is issued. This fix ensures the flow control change is reflected directly
in the GMAC_RX_FLOW_CTRL_RFE register.

Fixes: 46f69ded988d ("net: stmmac: Use resolved link config in mac_link_up()")
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: Goh, Wei Sheng <wei.sheng.goh@intel.com>
Signed-off-by: Noor Azura Ahmad Tarmizi <noor.azura.ahmad.tarmizi@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  3 +++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index c25bfecb4a2d..369db308b1dd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -748,6 +748,9 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
+	} else {
+		pr_debug("\tReceive Flow-Control OFF\n");
+		flow &= ~GMAC_RX_FLOW_CTRL_RFE;
 	}
 	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8273e6a175c8..ab7f48f32f5b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1061,8 +1061,16 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (tx_pause && rx_pause)
-		stmmac_mac_flow_ctrl(priv, duplex);
+	if (rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_AUTO;
+	else if (rx_pause && !tx_pause)
+		priv->flow_ctrl = FLOW_RX;
+	else if (!rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_TX;
+	else if (!rx_pause && !tx_pause)
+		priv->flow_ctrl = FLOW_OFF;
+
+	stmmac_mac_flow_ctrl(priv, duplex);
 
 	if (ctrl != old_ctrl)
 		writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
-- 
2.17.1

