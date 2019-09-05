Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2998AA2A3
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbfIEMFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:05:38 -0400
Received: from mga06.intel.com ([134.134.136.31]:3161 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731568AbfIEMFi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 08:05:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 05:05:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="185424430"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga003.jf.intel.com with ESMTP; 05 Sep 2019 05:05:32 -0700
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
Subject: [PATCH v3 net-next] net: stmmac: Add support for MDIO interrupts
Date:   Thu,  5 Sep 2019 20:05:30 +0800
Message-Id: <1567685130-8153-1-git-send-email-weifeng.voon@intel.com>
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

Changelog v3
*Move the changelog to before the --- marker line
Changelog v2
*mdio interrupt mode or polling mode will depends on mdio interrupt
 enable bit
*Disable the mdio interrupt enable bit in stmmac_release
*Remove the condition for initialize wait queues
*Applied reverse Christmas tree
---
 drivers/net/ethernet/stmicro/stmmac/common.h      |  2 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h      |  1 +
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c |  7 +++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.c      |  8 ++++
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h      |  4 ++
 drivers/net/ethernet/stmicro/stmmac/hwif.c        |  9 ++++
 drivers/net/ethernet/stmicro/stmmac/hwif.h        |  4 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  5 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 57 +++++++++++++++++++----
 9 files changed, 89 insertions(+), 8 deletions(-)

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
index fc9954e4a772..97fca6d65141 100644
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
@@ -836,6 +842,7 @@ static void dwmac4_set_mac_loopback(void __iomem *ioaddr, bool enable)
 	.rxp_config = dwmac5_rxp_config,
 	.flex_pps_config = dwmac5_flex_pps_config,
 	.set_mac_loopback = dwmac4_set_mac_loopback,
+	.mdio_intr_dis = dwmac5_mdio_intr_dis,
 };
 
 int dwmac4_setup(struct stmmac_priv *priv)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 3f4f3132e16b..c58751e1dcb6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -549,3 +549,11 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 	writel(val, ioaddr + MAC_PPS_CONTROL);
 	return 0;
 }
+
+void dwmac5_mdio_intr_dis(void __iomem *ioaddr)
+{
+	u32 val = readl(ioaddr + GMAC_INT_EN);
+
+	val &= ~GMAC_INT_MDIO_EN;
+	writel(val, ioaddr + GMAC_INT_EN);
+}
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 775db776b3cc..a56511a4c97d 100644
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
@@ -83,5 +86,6 @@ int dwmac5_rxp_config(void __iomem *ioaddr, struct stmmac_tc_entry *entries,
 int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 			   struct stmmac_pps_cfg *cfg, bool enable,
 			   u32 sub_second_inc, u32 systime_flags);
+void dwmac5_mdio_intr_dis(void __iomem *ioaddr);
 
 #endif /* __DWMAC5_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index 3af2e5015245..7127efe652db 100644
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
@@ -276,6 +284,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		mac->mode = mac->mode ? : entry->mode;
 		mac->tc = mac->tc ? : entry->tc;
 		mac->mmc = mac->mmc ? : entry->mmc;
+		mac->mdio_intr_en = mac->mdio_intr_en ? : entry->mdio_intr_en;
 
 		priv->hw = mac;
 		priv->ptpaddr = priv->ioaddr + entry->regs.ptp_off;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 9435b312495d..d42885426e78 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -363,6 +363,8 @@ struct stmmac_ops {
 	int (*get_mac_tx_timestamp)(struct mac_device_info *hw, u64 *ts);
 	/* Source Address Insertion / Replacement */
 	void (*sarc_configure)(void __iomem *ioaddr, int val);
+	/* Disable mdio interrupt */
+	void (*mdio_intr_dis)(void __iomem *ioaddr);
 };
 
 #define stmmac_core_init(__priv, __args...) \
@@ -443,6 +445,8 @@ struct stmmac_ops {
 	stmmac_do_callback(__priv, mac, get_mac_tx_timestamp, __args)
 #define stmmac_sarc_configure(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, sarc_configure, __args)
+#define stmmac_mdio_intr_dis(__priv, __args...) \
+	stmmac_do_void_callback(__priv, mac, mdio_intr_dis, __args)
 
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06ccd216ae90..2557a2beb03d 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2768,6 +2768,8 @@ static int stmmac_release(struct net_device *dev)
 	phylink_stop(priv->phylink);
 	phylink_disconnect_phy(priv->phylink);
 
+	stmmac_mdio_intr_dis(priv, priv->ioaddr);
+
 	stmmac_stop_all_queues(priv);
 
 	stmmac_disable_all_queues(priv);
@@ -4463,6 +4465,9 @@ int stmmac_dvr_probe(struct device *device,
 	if (ret)
 		goto error_hw_init;
 
+	/* mdio intr wait queue */
+	init_waitqueue_head(&priv->hw->mdio_busy_wait);
+
 	stmmac_check_ether_addr(priv);
 
 	/* Configure real RX and TX queues */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 40c42637ad75..625e1fde0c86 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -19,6 +19,8 @@
 #include <linux/property.h>
 #include <linux/slab.h>
 
+#include "dwmac4.h"
+#include "dwmac5.h"
 #include "dwxgmac2.h"
 #include "stmmac.h"
 
@@ -142,6 +144,18 @@ static int stmmac_xgmac2_mdio_write(struct mii_bus *bus, int phyaddr,
 				  !(tmp & MII_XGMAC_BUSY), 100, 10000);
 }
 
+static bool stmmac_mdio_intr_done(struct mii_bus *bus)
+{
+	struct net_device *ndev = bus->priv;
+	struct stmmac_priv *priv;
+	unsigned int mii_address;
+
+	priv = netdev_priv(ndev);
+	mii_address = priv->hw->mii.addr;
+
+	return !(readl(priv->ioaddr + mii_address) & MII_BUSY);
+}
+
 /**
  * stmmac_mdio_read
  * @bus: points to the mii_bus structure
@@ -159,9 +173,11 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
 	u32 value = MII_BUSY;
+	u32 mdio_intr_en = 0;
 	int data = 0;
 	u32 v;
 
+	mdio_intr_en = readl(priv->ioaddr + GMAC_INT_EN) & GMAC_INT_MDIO_EN;
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -181,16 +197,26 @@ static int stmmac_mdio_read(struct mii_bus *bus, int phyaddr, int phyreg)
 		}
 	}
 
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
+	if (mdio_intr_en) {
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
+	if (mdio_intr_en) {
+		if (!wait_event_timeout(priv->hw->mdio_busy_wait,
+					stmmac_mdio_intr_done(bus), HZ / 100))
+			return -EBUSY;
+	} else if (readl_poll_timeout(priv->ioaddr + mii_address, v,
+				      !(v & MII_BUSY), 100, 10000)) {
 		return -EBUSY;
+	}
 
 	/* Read the data from the MII data register */
 	data = (int)readl(priv->ioaddr + mii_data) & MII_DATA_MASK;
@@ -214,9 +240,11 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	unsigned int mii_address = priv->hw->mii.addr;
 	unsigned int mii_data = priv->hw->mii.data;
 	u32 value = MII_BUSY;
+	u32 mdio_intr_en = 0;
 	int data = phydata;
 	u32 v;
 
+	mdio_intr_en = readl(priv->ioaddr + GMAC_INT_EN) & GMAC_INT_MDIO_EN;
 	value |= (phyaddr << priv->hw->mii.addr_shift)
 		& priv->hw->mii.addr_mask;
 	value |= (phyreg << priv->hw->mii.reg_shift) & priv->hw->mii.reg_mask;
@@ -240,17 +268,30 @@ static int stmmac_mdio_write(struct mii_bus *bus, int phyaddr, int phyreg,
 	}
 
 	/* Wait until any existing MII operation is complete */
-	if (readl_poll_timeout(priv->ioaddr + mii_address, v, !(v & MII_BUSY),
-			       100, 10000))
+	if (mdio_intr_en) {
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
+	if (mdio_intr_en) {
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

