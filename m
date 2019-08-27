Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BA89D52C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387486AbfHZRqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:46:14 -0400
Received: from mga06.intel.com ([134.134.136.31]:31907 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387445AbfHZRqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:46:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="264015305"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga001.jf.intel.com with ESMTP; 26 Aug 2019 10:46:10 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [PATCH v1 net-next] net: stmmac: Add support for MDIO interrupts
Date:   Tue, 27 Aug 2019 09:45:20 +0800
Message-Id: <1566870320-9825-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Chuah, Kim Tatt" <kim.tatt.chuah@intel.com>

DW EQoS v5.xx controllers added capability for interrupt generation
when MDIO interface is done (GMII Busy bit is cleared).
This patch adds support for this interrupt on supported HW to avoid
polling on GMII Busy bit.

stmmac_mdio_read() & stmmac_mdio_write() will sleep until wake_up() is
called by the interrupt handler.

Reviewed-by: Voon Weifeng <weifeng.voon@intel.com>
Reviewed-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Chuah, Kim Tatt <kim.tatt.chuah@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 49aa56ca09cc..775a1c114b1a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -448,6 +448,8 @@ struct mac_device_info {
 	unsigned int pcs;
 	unsigned int pmt;
 	unsigned int ps;
+	bool mdio_intr_en;
+	wait_queue_head_t mdio_busy_wait;
 };
 
 struct stmmac_rx_routing {
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
index 2ed11a581d80..1be6a8a88b8f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4.h
@@ -106,6 +106,7 @@ enum dwmac4_irq_status {
 	mmc_irq = 0x00000100,
 	lpi_irq = 0x00000020,
 	pmt_irq = 0x00000010,
+	mdio_irq = 0x00040000,
 };
 
 /* MAC PMT bitmap */
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index fc9954e4a772..54adad616b90 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -59,6 +59,9 @@ static void dwmac4_core_init(struct mac_device_info *hw,
 	if (hw->pcs)
 		value |= GMAC_PCS_IRQ_DEFAULT;
 
+	if (hw->mdio_intr_en)
+		value |= GMAC_INT_MDIO_EN;
+
 	writel(value, ioaddr + GMAC_INT_EN);
 }
 
@@ -629,6 +632,9 @@ static int dwmac4_irq_status(struct mac_device_info *hw,
 			x->irq_rx_path_exit_lpi_mode_n++;
 	}
 
+	if (intr_status & mdio_irq)
+		wake_up(&hw->mdio_busy_wait);
+
 	dwmac_pcs_isr(ioaddr, GMAC_PCS_BASE, intr_status, x);
 	if (intr_status & PCS_RGSMIIIS_IRQ)
 		dwmac4_phystatus(ioaddr, x);
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 775db776b3cc..48550d617b01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -72,6 +72,9 @@
 #define TCEIE				BIT(0)
 #define DMA_ECC_INT_STATUS		0x00001088
 
+/* MDIO interrupt enable in MAC_Interrupt_Enable register */
+#define GMAC_INT_MDIO_EN		BIT(18)
+
 int dwmac5_safety_feat_config(void __iomem *ioaddr, unsigned int asp);
 int dwmac5_safety_feat_irq_status(struct net_device *ndev,
 		void __iomem *ioaddr, unsigned int asp,
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 3af2e5015245..11c7f92e99b4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -73,6 +73,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 	bool gmac;
 	bool gmac4;
 	bool xgmac;
+	bool mdio_intr_en;
 	u32 min_id;
 	const struct stmmac_regs_off regs;
 	const void *desc;
@@ -90,6 +91,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = false,
+		.mdio_intr_en = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC3_X_OFFSET,
@@ -108,6 +110,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = true,
 		.gmac4 = false,
 		.xgmac = false,
+		.mdio_intr_en = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC3_X_OFFSET,
@@ -126,6 +129,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.mdio_intr_en = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -144,6 +148,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.mdio_intr_en = false,
 		.min_id = DWMAC_CORE_4_00,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -162,6 +167,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.mdio_intr_en = false,
 		.min_id = DWMAC_CORE_4_10,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -180,6 +186,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.mdio_intr_en = true,
 		.min_id = DWMAC_CORE_5_10,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -198,6 +205,7 @@ static int stmmac_dwmac4_quirks(struct stmmac_priv *priv)
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = true,
+		.mdio_intr_en = false,
 		.min_id = DWXGMAC_CORE_2_10,
 		.regs = {
 			.ptp_off = PTP_XGMAC_OFFSET,
@@ -276,6 +284,10 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		mac->mode = mac->mode ? : entry->mode;
 		mac->tc = mac->tc ? : entry->tc;
 		mac->mmc = mac->mmc ? : entry->mmc;
+		mac->mdio_intr_en = mac->mdio_intr_en ? : entry->mdio_intr_en;
+
+		if (mac->mdio_intr_en)
+			init_waitqueue_head(&mac->mdio_busy_wait);
 
 		priv->hw = mac;
 		priv->ptpaddr = priv->ioaddr + entry->regs.ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 40c42637ad75..c9a23218307b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -142,6 +142,15 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
 }
 
+static bool stmmac_mdio_intr_done(struct mii_bus *bus)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	unsigned int mii_address = priv->hw->mii.addr;
+
+	return !(readl(priv->ioaddr + mii_address) & MII_BUSY);
+}
+
 /**
  * stmmac_mdio_read
  * @bus: points to the mii_bus structure
@@ -181,16 +190,26 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 		}
 	}
 
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
+	if (priv->hw->mdio_intr_en) {
+		if (!wait_event_timeout(priv->hw->mdio_busy_wait,
+					stmmac_mdio_intr_done(bus), HZ / 100))
+			return -EBUSY;
+	} else if (readl_poll_timeout(priv->ioaddr + mii_address, v,
+				      !(v & MII_BUSY), 100, 10000)) {
 		return -EBUSY;
+	}
 
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
+	if (priv->hw->mdio_intr_en) {
+		if (!wait_event_timeout(priv->hw->mdio_busy_wait,
+					stmmac_mdio_intr_done(bus), HZ / 100))
+			return -EBUSY;
+	} else if (readl_poll_timeout(priv->ioaddr + mii_address, v,
+				      !(v & MII_BUSY), 100, 10000)) {
 		return -EBUSY;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
@@ -240,17 +259,30 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	}
 
 	/* Wait until any existing MII operation is complete */
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
+	if (priv->hw->mdio_intr_en) {
+		if (!wait_event_timeout(priv->hw->mdio_busy_wait,
+					stmmac_mdio_intr_done(bus), HZ / 100))
+			return -EBUSY;
+	} else if (readl_poll_timeout(priv->ioaddr + mii_address, v,
+				      !(v & MII_BUSY), 100, 10000)) {
 		return -EBUSY;
+	}
 
 	/* Set the MII address register to write */
 	writel(data, priv->ioaddr + mii_data);
 	writel(value, priv->ioaddr + mii_address);
 
 	/* Wait until any existing MII operation is complete */
-	return readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-				  100, 10000);
+	if (priv->hw->mdio_intr_en) {
+		if (!wait_event_timeout(priv->hw->mdio_busy_wait,
+					stmmac_mdio_intr_done(bus), HZ / 100))
+			return -EBUSY;
+	} else if (readl_poll_timeout(priv->ioaddr + mii_address, v,
+				      !(v & MII_BUSY), 100, 10000)) {
+		return -EBUSY;
+	}
+
+	return 0;
 }
 
 /**
-- 
1.9.1

