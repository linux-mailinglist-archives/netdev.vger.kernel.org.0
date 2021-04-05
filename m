Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D47354539
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242413AbhDEQeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 12:34:10 -0400
Received: from mga04.intel.com ([192.55.52.120]:57217 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242379AbhDEQeJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 12:34:09 -0400
IronPort-SDR: LDx/x2FlNKcJpYVLGW0m1qdMJnTFCEBBpCNB1Msmt0srZHx/aGUP/dk15e29Rj/ogJLmJdehLQ
 oD3DNb9Y+NfQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9945"; a="190703885"
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="190703885"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2021 09:34:01 -0700
IronPort-SDR: qrZggW1wuGgXboJhW4PVAuqiPs1PMOZsICrSO1BpPpXNTL9B3/KYDgzLEcgC9jz8pRc++nyiDq
 vCdbH4607gfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,307,1610438400"; 
   d="scan'208";a="612200825"
Received: from climb.png.intel.com ([10.221.118.165])
  by fmsmga005.fm.intel.com with ESMTP; 05 Apr 2021 09:33:58 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next] net: intel: Enable SERDES PHY rx clk for PSE
Date:   Tue,  6 Apr 2021 00:33:57 +0800
Message-Id: <20210405163357.30902-1-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EHL PSE SGMII mode requires to ungate the SERDES PHY rx clk for power up
sequence and vice versa.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 10 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index add95e20548d..a4fec5fe0779 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -153,6 +153,11 @@ static int intel_serdes_powerup(struct net_device *ndev, void *priv_data)
 		return data;
 	}
 
+	/* PSE only - ungate SGMII PHY Rx Clock */
+	if (intel_priv->is_pse)
+		mdiobus_modify(priv->mii, serdes_phy_addr, SERDES_GCR0,
+			       0, SERDES_PHY_RX_CLK);
+
 	return 0;
 }
 
@@ -168,6 +173,11 @@ static void intel_serdes_powerdown(struct net_device *ndev, void *intel_data)
 
 	serdes_phy_addr = intel_priv->mdio_adhoc_addr;
 
+	/* PSE only - gate SGMII PHY Rx Clock */
+	if (intel_priv->is_pse)
+		mdiobus_modify(priv->mii, serdes_phy_addr, SERDES_GCR0,
+			       SERDES_PHY_RX_CLK, 0);
+
 	/*  move power state to P3 */
 	data = mdiobus_read(priv->mii, serdes_phy_addr, SERDES_GCR0);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
index e723096c0b15..542acb8ce467 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.h
@@ -14,6 +14,7 @@
 
 /* SERDES defines */
 #define SERDES_PLL_CLK		BIT(0)		/* PLL clk valid signal */
+#define SERDES_PHY_RX_CLK	BIT(1)		/* PSE SGMII PHY rx clk */
 #define SERDES_RST		BIT(2)		/* Serdes Reset */
 #define SERDES_PWR_ST_MASK	GENMASK(6, 4)	/* Serdes Power state*/
 #define SERDES_PWR_ST_SHIFT	4
-- 
2.17.1

