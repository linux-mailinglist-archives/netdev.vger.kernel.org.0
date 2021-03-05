Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD2D32E1CF
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 06:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEFqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 00:46:42 -0500
Received: from mga18.intel.com ([134.134.136.126]:26224 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbhCEFqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 00:46:42 -0500
IronPort-SDR: ypad0dxyxDX8W1Z+bCxda6scOYrdaYTJAyE70bWSdSUdDeHeofBMOVHPBsnViitnb5s5N2HOQd
 Q96cC8Cyvpvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="175205370"
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="175205370"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 21:46:33 -0800
IronPort-SDR: 2oWlfv1RIMS0G3hZt0P+/X/dqBMO+h83Ek/AfL+kLozvNggpjXeGNFtR32vYnA1/B6RCuf+v8I
 VWoCrYH5BfZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,224,1610438400"; 
   d="scan'208";a="446070894"
Received: from glass.png.intel.com ([10.158.65.59])
  by orsmga001.jf.intel.com with ESMTP; 04 Mar 2021 21:46:30 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net 1/1] net: stmmac: Fix VLAN filter delete timeout issue in Intel mGBE SGMII
Date:   Fri,  5 Mar 2021 13:49:30 +0800
Message-Id: <20210305054930.7434-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.17.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For Intel mGbE controller, MAC VLAN filter delete operation will time-out
if serdes power-down sequence happened first during driver remove() with
below message.

[82294.764958] intel-eth-pci 0000:00:1e.4 eth2: stmmac_dvr_remove: removing driver
[82294.778677] intel-eth-pci 0000:00:1e.4 eth2: Timeout accessing MAC_VLAN_Tag_Filter
[82294.779997] intel-eth-pci 0000:00:1e.4 eth2: failed to kill vid 0081/0
[82294.947053] intel-eth-pci 0000:00:1d.2 eth1: stmmac_dvr_remove: removing driver
[82295.002091] intel-eth-pci 0000:00:1d.1 eth0: stmmac_dvr_remove: removing driver

Therefore, we delay the serdes power-down to be after unregister_netdev()
which triggers the VLAN filter delete.

Fixes: b9663b7ca6ff ("net: stmmac: Enable SERDES power up/down sequence")
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0eba44e9c1f8..208cae344ffa 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5249,13 +5249,16 @@ int stmmac_dvr_remove(struct device *dev)
 	netdev_info(priv->dev, "%s: removing driver", __func__);
 
 	stmmac_stop_all_dma(priv);
+	stmmac_mac_set(priv, priv->ioaddr, false);
+	netif_carrier_off(ndev);
+	unregister_netdev(ndev);
 
+	/* Serdes power down needs to happen after VLAN filter
+	 * is deleted that is triggered by unregister_netdev().
+	 */
 	if (priv->plat->serdes_powerdown)
 		priv->plat->serdes_powerdown(ndev, priv->plat->bsp_priv);
 
-	stmmac_mac_set(priv, priv->ioaddr, false);
-	netif_carrier_off(ndev);
-	unregister_netdev(ndev);
 #ifdef CONFIG_DEBUG_FS
 	stmmac_exit_fs(ndev);
 #endif
-- 
2.17.0

