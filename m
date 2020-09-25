Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 974DB27844B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727966AbgIYJox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:44:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:10124 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727426AbgIYJox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:44:53 -0400
IronPort-SDR: OVcEp/i5YO4Eawd76A6zQhMK53cg+tTyS54NNj7X1XEuBP64t6t4WOgWWuuWL6C0F8nOInNMii
 z/5zQdWCt1ww==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="179567464"
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="179567464"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2020 02:38:51 -0700
IronPort-SDR: eV+/YiIAkDRI3ZDR9Hxg7gZbi4xwiNuT34tLU6fzHO7DgD+SpAE9zsP5jRV+W0gScE8GRzyqx1
 lDuBr5VmJMoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,301,1596524400"; 
   d="scan'208";a="455752657"
Received: from glass.png.intel.com ([172.30.181.92])
  by orsmga004.jf.intel.com with ESMTP; 25 Sep 2020 02:38:47 -0700
From:   Wong Vee Khee <vee.khee.wong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Vijaya Balan Sadhishkhanna 
        <sadhishkhanna.vijaya.balan@intel.com>,
        Seow Chen Yong <chen.yong.seow@intel.com>,
        Mark Gross <mgross@linux.intel.com>
Subject: [PATCH net-next 1/1] net: stmmac: Add option for VLAN filter fail queue enable
Date:   Fri, 25 Sep 2020 17:40:41 +0800
Message-Id: <20200925094041.12038-2-vee.khee.wong@intel.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20200925094041.12038-1-vee.khee.wong@intel.com>
References: <20200925094041.12038-1-vee.khee.wong@intel.com>
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
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c |  5 +++++
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c | 15 +++++++++++++--
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h      |  6 ++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  3 +++
 include/linux/stmmac.h                            |  2 ++
 7 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index cafa8e3c3573..df7de50497a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -481,6 +481,8 @@ struct mac_device_info {
 	unsigned int num_vlan;
 	u32 vlan_filter[32];
 	unsigned int promisc;
+	bool vlan_fail_q_en;
+	u8 vlan_fail_q;
 };
 
 struct stmmac_rx_routing {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 2ac9dfb3462c..ab0a81e0fea1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -321,6 +321,11 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	/* Set the maxmtu to a default of JUMBO_LEN */
 	plat->maxmtu = JUMBO_LEN;
 
+	plat->vlan_fail_q_en = true;
+
+	/* Use the last Rx queue */
+	plat->vlan_fail_q = plat->rx_queues_to_use - 1;
+
 	return 0;
 }
 
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
index 3e8faa96b4d4..56b0762c1276 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -92,6 +92,12 @@
 #define TCEIE				BIT(0)
 #define DMA_ECC_INT_STATUS		0x00001088
 
+/* EQoS version 5.xx VLAN Tag Filter Fail Packets Queuing */
+#define GMAC_RXQ_CTRL4			0x00000094
+#define GMAC_RXQCTRL_VFFQ_MASK		GENMASK(19, 17)
+#define GMAC_RXQCTRL_VFFQ_SHIFT		17
+#define GMAC_RXQCTRL_VFFQE		BIT(16)
+
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp);
 int dwmac5_safety_feat_irq_status(struct net_device *ndev,
 		void __iomem *ioaddr, unsigned int asp,
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index df2c74bbfcff..269da57c99f6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4709,6 +4709,9 @@ static int stmmac_hw_init(struct stmmac_priv *priv)
 	if (priv->dma_cap.tsoen)
 		dev_info(priv->device, "TSO supported\n");
 
+	priv->hw->vlan_fail_q_en = priv->plat->vlan_fail_q_en;
+	priv->hw->vlan_fail_q = priv->plat->vlan_fail_q;
+
 	/* Run HW quirks, if any */
 	if (priv->hwif_quirks) {
 		ret = priv->hwif_quirks(priv);
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index bd964c31d333..00e83c877496 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -198,5 +198,7 @@ struct plat_stmmacenet_data {
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
 	int has_xgmac;
+	bool vlan_fail_q_en;
+	u8 vlan_fail_q;
 };
 #endif
-- 
2.17.0

