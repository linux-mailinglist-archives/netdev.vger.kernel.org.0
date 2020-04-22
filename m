Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393221B3585
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDVD2e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:28:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:24164 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgDVD2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Apr 2020 23:28:34 -0400
IronPort-SDR: TLAQwSVycTOn9IGZ3t6p0192xnI+R3aeY0IGl+dTr7rncs7hBZjwJ81M9+bmQlH9gEITsupvfw
 rlXYi1NibLhw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 20:28:33 -0700
IronPort-SDR: Kgm4GfB/vjdE6ywLMDh8Xh/KM3PVMA2pxPw2mUhmfMlk2vXrvKh9Qe8BGseLISeeGv7CSKytDP
 t7mv5SvgYppQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,412,1580803200"; 
   d="scan'208";a="429759490"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga005.jf.intel.com with ESMTP; 21 Apr 2020 20:28:30 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>
Subject: [PATCH net-next v2 1/1] net: stmmac: Add support for VLAN promiscuous mode
Date:   Wed, 22 Apr 2020 11:31:06 +0800
Message-Id: <20200422033106.25745-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>

For dwmac4, enable VLAN promiscuity when MAC controller is requested to
enter promiscuous mode.

Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h  |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  1 +
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c | 67 +++++++++++++++++++
 3 files changed, 69 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 6208a68a331d..127f75862962 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -473,6 +473,7 @@ struct mac_device_info {
 	unsigned int xlgmac;
 	unsigned int num_vlan;
 	u32 vlan_filter[32];
+	unsigned int promisc;
 };
 
 struct stmmac_rx_routing {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 28cac28253b8..61f3249bd724 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -90,6 +90,7 @@
 #define GMAC_VLAN_CSVL			BIT(19)
 #define GMAC_VLAN_VLC			GENMASK(17, 16)
 #define GMAC_VLAN_VLC_SHIFT		16
+#define GMAC_VLAN_VLHT			GENMASK(15, 0)
 
 /* MAC VLAN Tag */
 #define GMAC_VLAN_TAG_VID		GENMASK(15, 0)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 39692d15d80c..ecd834e0e121 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -450,6 +450,12 @@ static int dwmac4_add_hw_vlan_rx_fltr(struct net_device *dev,
 	if (vid > 4095)
 		return -EINVAL;
 
+	if (hw->promisc) {
+		netdev_err(dev,
+			   "Adding VLAN in promisc mode not supported\n");
+		return -EPERM;
+	}
+
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		/* For single VLAN filter, VID 0 means VLAN promiscuous */
@@ -499,6 +505,12 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 {
 	int i, ret = 0;
 
+	if (hw->promisc) {
+		netdev_err(dev,
+			   "Deleting VLAN in promisc mode not supported\n");
+		return -EPERM;
+	}
+
 	/* Single Rx VLAN Filter */
 	if (hw->num_vlan == 1) {
 		if ((hw->vlan_filter[0] & GMAC_VLAN_TAG_VID) == vid) {
@@ -523,9 +535,45 @@ static int dwmac4_del_hw_vlan_rx_fltr(struct net_device *dev,
 	return ret;
 }
 
+static void dwmac4_vlan_promisc_enable(struct net_device *dev,
+				       struct mac_device_info *hw)
+{
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+	u32 hash;
+	u32 val;
+	int i;
+
+	/* Single Rx VLAN Filter */
+	if (hw->num_vlan == 1) {
+		dwmac4_write_single_vlan(dev, 0);
+		return;
+	}
+
+	/* Extended Rx VLAN Filter Enable */
+	for (i = 0; i < hw->num_vlan; i++) {
+		if (hw->vlan_filter[i] & GMAC_VLAN_TAG_DATA_VEN) {
+			val = hw->vlan_filter[i] & ~GMAC_VLAN_TAG_DATA_VEN;
+			dwmac4_write_vlan_filter(dev, hw, i, val);
+		}
+	}
+
+	hash = readl(ioaddr + GMAC_VLAN_HASH_TABLE);
+	if (hash & GMAC_VLAN_VLHT) {
+		value = readl(ioaddr + GMAC_VLAN_TAG);
+		if (value & GMAC_VLAN_VTHM) {
+			value &= ~GMAC_VLAN_VTHM;
+			writel(value, ioaddr + GMAC_VLAN_TAG);
+		}
+	}
+}
+
 static void dwmac4_restore_hw_vlan_rx_fltr(struct net_device *dev,
 					   struct mac_device_info *hw)
 {
+	void __iomem *ioaddr = hw->pcsr;
+	u32 value;
+	u32 hash;
 	u32 val;
 	int i;
 
@@ -542,6 +590,13 @@ static void dwmac4_restore_hw_vlan_rx_fltr(struct net_device *dev,
 			dwmac4_write_vlan_filter(dev, hw, i, val);
 		}
 	}
+
+	hash = readl(ioaddr + GMAC_VLAN_HASH_TABLE);
+	if (hash & GMAC_VLAN_VLHT) {
+		value = readl(ioaddr + GMAC_VLAN_TAG);
+		value |= GMAC_VLAN_VTHM;
+		writel(value, ioaddr + GMAC_VLAN_TAG);
+	}
 }
 
 static void dwmac4_set_filter(struct mac_device_info *hw,
@@ -624,6 +679,18 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 		value |= GMAC_PACKET_FILTER_VTFE;
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
+
+	if (dev->flags & IFF_PROMISC) {
+		if (!hw->promisc) {
+			hw->promisc = 1;
+			dwmac4_vlan_promisc_enable(dev, hw);
+		}
+	} else {
+		if (hw->promisc) {
+			hw->promisc = 0;
+			dwmac4_restore_hw_vlan_rx_fltr(dev, hw);
+		}
+	}
 }
 
 static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
-- 
2.17.0

