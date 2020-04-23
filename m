Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7178F1B5501
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgDWG5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:57:53 -0400
Received: from mga12.intel.com ([192.55.52.136]:17521 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgDWG5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 02:57:52 -0400
IronPort-SDR: 5CvoguHw9XGMEMKcCr1NXQ4rdA1b5SyCCV7n+4iBzrtVK0ATnOCPnAGIJ1JsRUGj1I13lJVEQm
 o83ZC9NrkdQQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 23:57:52 -0700
IronPort-SDR: 5ulPnrtMfp1BYERyF+Rw1WdpC63D7z9WauseFppZJ6R7UYPhr9lRuXDhv8+5WuiHOGKjV42H9w
 VY9EM/makVnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,306,1583222400"; 
   d="scan'208";a="280295535"
Received: from glass.png.intel.com ([172.30.181.92])
  by fmsmga004.fm.intel.com with ESMTP; 22 Apr 2020 23:57:49 -0700
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
Subject: [PATCH net-next 1/1] net: stmmac: Add option for VLAN filter fail queue enable
Date:   Thu, 23 Apr 2020 15:00:26 +0800
Message-Id: <20200423070026.26200-1-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>

Add option in plat_stmmacenet_data struct to enable VLAN Filter Fail
Queuing. This option allows packets that fail VLAN filter to be routed
to a specific Rx queue when Receive All is also set.

When this option is enabled:
- Enable VFFQ only when entering promiscuous mode, because Receive All
  will pass up all rx packets that failed address filtering (similar to
  promiscuous mode).
- VLAN-promiscuous mode is never entered to allow rx packet to fail VLAN
  filters and get routed to selected VFFQ Rx queue.

Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  2 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 15 +++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h      |  6 ++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +++
 include/linux/stmmac.h                            |  2 ++
 6 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 127f75862962..52e6d1ef7176 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -474,6 +474,8 @@ struct mac_device_info {
 	unsigned int num_vlan;
 	u32 vlan_filter[32];
 	unsigned int promisc;
+	bool vlan_fail_q_en;
+	u8 vlan_fail_q;
 };
 
 struct stmmac_rx_routing {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 61f3249bd724..592b043f9676 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -76,6 +76,7 @@
 #define GMAC_PACKET_FILTER_HPF		BIT(10)
 #define GMAC_PACKET_FILTER_VTFE		BIT(16)
 #define GMAC_PACKET_FILTER_IPFE		BIT(20)
+#define GMAC_PACKET_FILTER_RA		BIT(31)
 
 #define GMAC_MAX_PERFECT_ADDRESSES	128
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index ecd834e0e121..002791b77356 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -618,7 +618,18 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 	value &= ~GMAC_PACKET_FILTER_PM;
 	value &= ~GMAC_PACKET_FILTER_PR;
 	if (dev->flags & IFF_PROMISC) {
-		value = GMAC_PACKET_FILTER_PR | GMAC_PACKET_FILTER_PCF;
+		/* VLAN Tag Filter Fail Packets Queuing */
+		if (hw->vlan_fail_q_en) {
+			value = readl(ioaddr + GMAC_RXQ_CTRL4);
+			value &= ~GMAC_RXQCTRL_VFFQ_MASK;
+			value |= GMAC_RXQCTRL_VFFQE |
+				 (hw->vlan_fail_q << GMAC_RXQCTRL_VFFQ_SHIFT);
+			writel(value, ioaddr + GMAC_RXQ_CTRL4);
+			value = GMAC_PACKET_FILTER_PR | GMAC_PACKET_FILTER_RA;
+		} else {
+			value = GMAC_PACKET_FILTER_PR | GMAC_PACKET_FILTER_PCF;
+		}
+
 	} else if ((dev->flags & IFF_ALLMULTI) ||
 		   (netdev_mc_count(dev) > hw->multicast_filter_bins)) {
 		/* Pass all multi */
@@ -680,7 +691,7 @@ static void dwmac4_set_filter(struct mac_device_info *hw,
 
 	writel(value, ioaddr + GMAC_PACKET_FILTER);
 
-	if (dev->flags & IFF_PROMISC) {
+	if (dev->flags & IFF_PROMISC && !hw->vlan_fail_q_en) {
 		if (!hw->promisc) {
 			hw->promisc = 1;
 			dwmac4_vlan_promisc_enable(dev, hw);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 3e8faa96b4d4..64530deb55ba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -92,6 +92,12 @@
 #define TCEIE				BIT(0)
 #define DMA_ECC_INT_STATUS		0x00001088
 
+/* EQoS version 5.xx VLAN Tag Filter Fail Packets Queuing */
+#define GMAC_RXQ_CTRL4                 0x00000094
+#define GMAC_RXQCTRL_VFFQ_MASK         GENMASK(19, 17)
+#define GMAC_RXQCTRL_VFFQ_SHIFT                17
+#define GMAC_RXQCTRL_VFFQE             BIT(16)
+
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp);
 int dwmac5_safety_feat_irq_status(struct net_device *ndev,
 		void __iomem *ioaddr, unsigned int asp,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e6898fd5223f..27d9bf98c908 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4723,6 +4723,9 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
 
+	priv->hw->vlan_fail_q_en = priv->plat->vlan_fail_q_en;
+	priv->hw->vlan_fail_q = priv->plat->vlan_fail_q;
+
 	/* Run HW quirks, if any */
 	if (priv->hwif_quirks) {
 		ret = priv->hwif_quirks(priv);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fbafb353e9be..f4287f363031 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -196,5 +196,7 @@ struct plat_stmmacenet_data {
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
 	int has_xgmac;
+	bool vlan_fail_q_en;
+	u8 vlan_fail_q;
 };
 #endif
-- 
2.17.0

