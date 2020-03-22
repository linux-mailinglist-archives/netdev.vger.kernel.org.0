Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B718E91D
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 14:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbgCVNXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 09:23:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:6483 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgCVNXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 09:23:49 -0400
IronPort-SDR: jY0uwx+ULyl25fes2SWb/9WOqL7gXdCms7RDawBZ4ys7X+ANRNg6WYte/v+F5IOdp4mdmpKCUJ
 UVm/3NHS3frA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 06:23:49 -0700
IronPort-SDR: k2YqvUqO5wyEZegnntxwspUXiYdUTmCOnc+fmfVj35146RM2KsauJqp1x3bq6MZaeyEc0YO5Mv
 y+gAf85vssyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,292,1580803200"; 
   d="scan'208";a="392639008"
Received: from unknown (HELO climb.png.intel.com) ([10.221.118.165])
  by orsmga004.jf.intel.com with ESMTP; 22 Mar 2020 06:23:46 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [RFC,net-next,v1, 1/1] net: stmmac: Enable SERDES power up/down sequence
Date:   Sun, 22 Mar 2020 21:23:42 +0800
Message-Id: <20200322132342.2687-2-weifeng.voon@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200322132342.2687-1-weifeng.voon@intel.com>
References: <20200322132342.2687-1-weifeng.voon@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to enable Intel SERDES power up/down sequence. The SERDES
converts 8/10 bits data to SGMII signal. Below is an example of
HW configuration for SGMII mode. The SERDES is located in the PHY IF
in the diagram below.

<-----------------GBE Controller---------->|<--External PHY chip-->
+----------+         +----+            +---+           +----------+
|   EQoS   | <-GMII->| DW | < ------ > |PHY| <-SGMII-> | External |
|   MAC    |         |xPCS|            |IF |           | PHY      |
+----------+         +----+            +---+           +----------+
       ^               ^                 ^                ^
       |               |                 |                |
       +---------------------MDIO-------------------------+

PHY IF configuration and status registers are accessible through
mdio address 0x15 which is defined as intel_adhoc_addr. During D0,
The driver will need to power up PHY IF by changing the power state
to P0. Likewise, for D3, the driver sets PHY IF power state to P3.

Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/Makefile  |   2 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   1 +
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |   1 +
 drivers/net/ethernet/stmicro/stmmac/hwif.c    |  44 ++++-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    |  12 ++
 .../ethernet/stmicro/stmmac/intel_serdes.c    | 181 ++++++++++++++++++
 .../ethernet/stmicro/stmmac/intel_serdes.h    |  23 +++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   8 +
 .../net/ethernet/stmicro/stmmac/stmmac_pci.c  |   6 +
 include/linux/stmmac.h                        |   2 +
 10 files changed, 278 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/intel_serdes.c
 create mode 100644 drivers/net/ethernet/stmicro/stmmac/intel_serdes.h

diff --git a/drivers/net/ethernet/stmicro/stmmac/Makefile b/drivers/net/ethernet/stmicro/stmmac/Makefile
index c59926d96bcc..3230d2673cb5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Makefile
+++ b/drivers/net/ethernet/stmicro/stmmac/Makefile
@@ -6,7 +6,7 @@ stmmac-objs:= stmmac_main.o stmmac_ethtool.o stmmac_mdio.o ring_mode.o	\
 	      mmc_core.o stmmac_hwtstamp.o stmmac_ptp.o dwmac4_descs.o	\
 	      dwmac4_dma.o dwmac4_lib.o dwmac4_core.o dwmac5.o hwif.o \
 	      stmmac_tc.o dwxgmac2_core.o dwxgmac2_dma.o dwxgmac2_descs.o \
-	      $(stmmac-y)
+	      intel_serdes.o $(stmmac-y)
 
 stmmac-$(CONFIG_STMMAC_SELFTESTS) += stmmac_selftests.o
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/common.h b/drivers/net/ethernet/stmicro/stmmac/common.h
index 386663208c23..2840867279a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/common.h
+++ b/drivers/net/ethernet/stmicro/stmmac/common.h
@@ -452,6 +452,7 @@ struct mii_regs {
 
 struct mac_device_info {
 	const struct stmmac_ops *mac;
+	const struct stmmac_serdes_ops *serdes;
 	const struct stmmac_desc_ops *desc;
 	const struct stmmac_dma_ops *dma;
 	const struct stmmac_mode_ops *mode;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index dc09d2131e40..8e772fe9d048 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -17,6 +17,7 @@
 #include <net/dsa.h>
 #include "stmmac.h"
 #include "stmmac_pcs.h"
+#include "intel_serdes.h"
 #include "dwmac4.h"
 #include "dwmac5.h"
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.c b/drivers/net/ethernet/stmicro/stmmac/hwif.c
index bb7114f970f8..817c9c1255a5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.c
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.c
@@ -91,12 +91,14 @@ static const struct stmmac_hwif_entry {
 	bool gmac;
 	bool gmac4;
 	bool xgmac;
+	bool has_serdes;
 	u32 min_id;
 	u32 dev_id;
 	const struct stmmac_regs_off regs;
 	const void *desc;
 	const void *dma;
 	const void *mac;
+	const void *serdes;
 	const void *hwtimestamp;
 	const void *mode;
 	const void *tc;
@@ -109,6 +111,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = false,
+		.has_serdes = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC3_X_OFFSET,
@@ -117,6 +120,7 @@ static const struct stmmac_hwif_entry {
 		.desc = NULL,
 		.dma = &dwmac100_dma_ops,
 		.mac = &dwmac100_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = NULL,
@@ -127,6 +131,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = true,
 		.gmac4 = false,
 		.xgmac = false,
+		.has_serdes = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC3_X_OFFSET,
@@ -135,6 +140,7 @@ static const struct stmmac_hwif_entry {
 		.desc = NULL,
 		.dma = &dwmac1000_dma_ops,
 		.mac = &dwmac1000_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = NULL,
@@ -145,6 +151,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_serdes = false,
 		.min_id = 0,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -152,6 +159,7 @@ static const struct stmmac_hwif_entry {
 		},
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac4_dma_ops,
+		.serdes = NULL,
 		.mac = &dwmac4_ops,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
@@ -163,6 +171,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_serdes = false,
 		.min_id = DWMAC_CORE_4_00,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -171,6 +180,7 @@ static const struct stmmac_hwif_entry {
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac4_dma_ops,
 		.mac = &dwmac410_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
@@ -181,6 +191,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_serdes = false,
 		.min_id = DWMAC_CORE_4_10,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -189,6 +200,7 @@ static const struct stmmac_hwif_entry {
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac410_dma_ops,
 		.mac = &dwmac410_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
@@ -199,6 +211,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = true,
 		.xgmac = false,
+		.has_serdes = false,
 		.min_id = DWMAC_CORE_5_10,
 		.regs = {
 			.ptp_off = PTP_GMAC4_OFFSET,
@@ -207,6 +220,7 @@ static const struct stmmac_hwif_entry {
 		.desc = &dwmac4_desc_ops,
 		.dma = &dwmac410_dma_ops,
 		.mac = &dwmac510_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = &dwmac4_ring_mode_ops,
 		.tc = &dwmac510_tc_ops,
@@ -217,6 +231,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = true,
+		.has_serdes = false,
 		.min_id = DWXGMAC_CORE_2_10,
 		.dev_id = DWXGMAC_ID,
 		.regs = {
@@ -226,6 +241,7 @@ static const struct stmmac_hwif_entry {
 		.desc = &dwxgmac210_desc_ops,
 		.dma = &dwxgmac210_dma_ops,
 		.mac = &dwxgmac210_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = &dwmac510_tc_ops,
@@ -236,6 +252,7 @@ static const struct stmmac_hwif_entry {
 		.gmac = false,
 		.gmac4 = false,
 		.xgmac = true,
+		.has_serdes = false,
 		.min_id = DWXLGMAC_CORE_2_00,
 		.dev_id = DWXLGMAC_ID,
 		.regs = {
@@ -245,13 +262,34 @@ static const struct stmmac_hwif_entry {
 		.desc = &dwxgmac210_desc_ops,
 		.dma = &dwxgmac210_dma_ops,
 		.mac = &dwxlgmac2_ops,
+		.serdes = NULL,
 		.hwtimestamp = &stmmac_ptp,
 		.mode = NULL,
 		.tc = &dwmac510_tc_ops,
 		.mmc = &dwxgmac_mmc_ops,
 		.setup = dwxlgmac2_setup,
 		.quirks = stmmac_dwxlgmac_quirks,
-	},
+	}, {
+		.gmac = false,
+		.gmac4 = true,
+		.xgmac = false,
+		.has_serdes = true,
+		.min_id = DWMAC_CORE_5_10,
+		.regs = {
+			.ptp_off = PTP_GMAC4_OFFSET,
+			.mmc_off = MMC_GMAC4_OFFSET,
+		},
+		.desc = &dwmac4_desc_ops,
+		.dma = &dwmac410_dma_ops,
+		.mac = &dwmac510_ops,
+		.serdes = &intel_serdes_ops,
+		.hwtimestamp = &stmmac_ptp,
+		.mode = &dwmac4_ring_mode_ops,
+		.tc = &dwmac510_tc_ops,
+		.mmc = &dwmac_mmc_ops,
+		.setup = dwmac4_setup,
+		.quirks = NULL,
+	}
 };
 
 int stmmac_hwif_init(struct stmmac_priv *priv)
@@ -259,6 +297,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 	bool needs_xgmac = priv->plat->has_xgmac;
 	bool needs_gmac4 = priv->plat->has_gmac4;
 	bool needs_gmac = priv->plat->has_gmac;
+	bool needs_serdes = priv->plat->has_serdes;
 	const struct stmmac_hwif_entry *entry;
 	struct mac_device_info *mac;
 	bool needs_setup = true;
@@ -305,6 +344,8 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 			continue;
 		if (needs_xgmac ^ entry->xgmac)
 			continue;
+		if (needs_serdes ^ entry->has_serdes)
+			continue;
 		/* Use synopsys_id var because some setups can override this */
 		if (priv->synopsys_id < entry->min_id)
 			continue;
@@ -315,6 +356,7 @@ int stmmac_hwif_init(struct stmmac_priv *priv)
 		mac->desc = mac->desc ? : entry->desc;
 		mac->dma = mac->dma ? : entry->dma;
 		mac->mac = mac->mac ? : entry->mac;
+		mac->serdes = mac->serdes ? : entry->serdes;
 		mac->ptp = mac->ptp ? : entry->hwtimestamp;
 		mac->mode = mac->mode ? : entry->mode;
 		mac->tc = mac->tc ? : entry->tc;
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index fc350149ba34..e4c388124561 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -476,6 +476,17 @@ struct stmmac_ops {
 #define stmmac_fpe_configure(__priv, __args...) \
 	stmmac_do_void_callback(__priv, mac, fpe_configure, __args)
 
+/* Helpers for serdes */
+struct stmmac_serdes_ops {
+	int (*serdes_powerup)(struct net_device *ndev);
+	int (*serdes_powerdown)(struct net_device *ndev);
+};
+
+#define stmmac_serdes_powerup(__priv, __args...) \
+	stmmac_do_callback(__priv, serdes, serdes_powerup, __args)
+#define stmmac_serdes_powerdown(__priv, __args...) \
+	stmmac_do_callback(__priv, serdes, serdes_powerdown, __args)
+
 /* PTP and HW Timer helpers */
 struct stmmac_hwtimestamp {
 	void (*config_hw_tstamping) (void __iomem *ioaddr, u32 data);
@@ -595,6 +606,7 @@ struct stmmac_regs_off {
 };
 
 extern const struct stmmac_ops dwmac100_ops;
+extern const struct stmmac_serdes_ops intel_serdes_ops;
 extern const struct stmmac_dma_ops dwmac100_dma_ops;
 extern const struct stmmac_ops dwmac1000_ops;
 extern const struct stmmac_dma_ops dwmac1000_dma_ops;
diff --git a/drivers/net/ethernet/stmicro/stmmac/intel_serdes.c b/drivers/net/ethernet/stmicro/stmmac/intel_serdes.c
new file mode 100644
index 000000000000..47f19e3dcef7
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/intel_serdes.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020, Intel Corporation
+ * Intel Serdes
+ */
+
+#include <linux/bitops.h>
+#include <linux/delay.h>
+#include <linux/mdio.h>
+#include "intel_serdes.h"
+#include "stmmac.h"
+
+static int serdes_status_poll(struct stmmac_priv *priv, int phyaddr,
+			      int phyreg, u32 mask, u32 val)
+{
+	unsigned int retries = 10;
+	int val_rd = 0;
+
+	do {
+		val_rd = mdiobus_read(priv->mii, phyaddr, phyreg);
+		if ((val_rd & mask) == (val & mask))
+			return 0;
+		udelay(POLL_DELAY_US);
+	} while (--retries);
+
+	return -ETIMEDOUT;
+}
+
+static int intel_serdes_powerup(struct net_device *ndev)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	if (!priv->plat->intel_adhoc_addr)
+		return 0;
+
+	serdes_phy_addr = priv->plat->intel_adhoc_addr;
+
+	/* assert clk_req */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data |= SERDES_PLL_CLK;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for clk_ack assertion */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PLL_CLK,
+				  SERDES_PLL_CLK);
+
+	if (data) {
+		dev_err(priv->device, "Serdes PLL clk request timeout\n");
+		return data;
+	}
+
+	/* assert lane reset */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data |= SERDES_RST;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for assert lane reset reflection */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_RST,
+				  SERDES_RST);
+
+	if (data) {
+		dev_err(priv->device, "Serdes assert lane reset timeout\n");
+		return data;
+	}
+
+	/*  move power state to P0 */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_PWR_ST_MASK;
+	data |= SERDES_PWR_ST_P0 << SERDES_PWR_ST_SHIFT;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* Check for P0 state */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PWR_ST_MASK,
+				  SERDES_PWR_ST_P0 << SERDES_PWR_ST_SHIFT);
+
+	if (data) {
+		dev_err(priv->device, "Serdes power state P0 timeout.\n");
+		return data;
+	}
+
+	return 0;
+}
+
+static int intel_serdes_powerdown(struct net_device *ndev)
+{
+	struct stmmac_priv *priv = netdev_priv(ndev);
+	int serdes_phy_addr = 0;
+	u32 data = 0;
+
+	serdes_phy_addr = priv->plat->intel_adhoc_addr;
+
+	if (!priv->plat->intel_adhoc_addr)
+		return 0;
+
+	/*  move power state to P3 */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_PWR_ST_MASK;
+	data |= SERDES_PWR_ST_P3 << SERDES_PWR_ST_SHIFT;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* Check for P3 state */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PWR_ST_MASK,
+				  SERDES_PWR_ST_P3 << SERDES_PWR_ST_SHIFT);
+
+	if (data) {
+		dev_err(priv->device, "Serdes power state P3 timeout\n");
+		return data;
+	}
+
+	/* de-assert clk_req */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_PLL_CLK;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for clk_ack de-assert */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_PLL_CLK,
+				  (u32)~SERDES_PLL_CLK);
+
+	if (data) {
+		dev_err(priv->device, "Serdes PLL clk de-assert timeout\n");
+		return data;
+	}
+
+	/* de-assert lane reset */
+	data = mdiobus_read(priv->mii, serdes_phy_addr,
+			    SERDES_GCR0);
+
+	data &= ~SERDES_RST;
+
+	mdiobus_write(priv->mii, serdes_phy_addr,
+		      SERDES_GCR0, data);
+
+	/* check for de-assert lane reset reflection */
+	data = serdes_status_poll(priv, serdes_phy_addr,
+				  SERDES_GSR0,
+				  SERDES_RST,
+				  (u32)~SERDES_RST);
+
+	if (data) {
+		dev_err(priv->device, "Serdes de-assert lane reset timeout\n");
+		return data;
+	}
+
+	return 0;
+}
+
+const struct stmmac_serdes_ops intel_serdes_ops = {
+	.serdes_powerup = intel_serdes_powerup,
+	.serdes_powerdown = intel_serdes_powerdown,
+};
diff --git a/drivers/net/ethernet/stmicro/stmmac/intel_serdes.h b/drivers/net/ethernet/stmicro/stmmac/intel_serdes.h
new file mode 100644
index 000000000000..bf72d557d0be
--- /dev/null
+++ b/drivers/net/ethernet/stmicro/stmmac/intel_serdes.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020, Intel Corporation
+ * Intel Serdes
+ */
+
+#ifndef __INTEL_SERDES_H__
+#define __INTEL_SERDES_H__
+
+#define POLL_DELAY_US 8
+
+/* SERDES Register */
+#define SERDES_GSR0	0x5	/* Global Status Reg0 */
+#define SERDES_GCR0	0xb	/* Global Configuration Reg0 */
+
+/* SERDES defines */
+#define SERDES_PLL_CLK		BIT(0)		/* PLL clk valid signal */
+#define SERDES_RST		BIT(2)		/* Serdes Reset */
+#define SERDES_PWR_ST_MASK	GENMASK(6, 4)	/* Serdes Power state*/
+#define SERDES_PWR_ST_SHIFT	4
+#define SERDES_PWR_ST_P0	0x0
+#define SERDES_PWR_ST_P3	0x3
+
+#endif /* __INTEL_SERDES_H__ */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 0e8c80f23557..11d4520e5655 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -45,6 +45,7 @@
 #include "dwmac1000.h"
 #include "dwxgmac2.h"
 #include "hwif.h"
+#include "intel_serdes.h"
 
 #define	STMMAC_ALIGN(x)		ALIGN(ALIGN(x, SMP_CACHE_BYTES), 16)
 #define	TSO_MAX_BUFF_SIZE	(SZ_16K - 1)
@@ -2629,6 +2630,10 @@ static int stmmac_hw_setup(struct net_device *dev, bool init_ptp)
 	u32 chan;
 	int ret;
 
+	/* Power up Serdes */
+	if (priv->plat->has_serdes)
+		stmmac_serdes_powerup(priv, dev);
+
 	/* DMA initialization and SW reset */
 	ret = stmmac_init_dma_engine(priv);
 	if (ret < 0) {
@@ -5015,6 +5020,9 @@ int stmmac_dvr_remove(struct device *dev)
 
 	stmmac_stop_all_dma(priv);
 
+	if (priv->plat->has_serdes)
+		stmmac_serdes_powerdown(priv, ndev);
+
 	stmmac_mac_set(priv, priv->ioaddr, false);
 	netif_carrier_off(ndev);
 	unregister_netdev(ndev);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
index 7acbac73c29c..751f138552a6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c
@@ -119,6 +119,9 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	plat->force_sf_dma_mode = 0;
 	plat->tso_en = 1;
 
+	/* intel specific adhoc (mdio) address for serdes & etc */
+	plat->intel_adhoc_addr = 0x15;
+
 	plat->rx_sched_algorithm = MTL_RX_ALGORITHM_SP;
 
 	for (i = 0; i < plat->rx_queues_to_use; i++) {
@@ -194,6 +197,9 @@ static int intel_mgbe_common_data(struct pci_dev *pdev,
 	/* Set the maxmtu to a default of JUMBO_LEN */
 	plat->maxmtu = JUMBO_LEN;
 
+	if (plat->phy_interface == PHY_INTERFACE_MODE_SGMII)
+		plat->has_serdes = 1;
+
 	return 0;
 }
 
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fbafb353e9be..c1289566f4d0 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -146,6 +146,7 @@ struct stmmac_txq_cfg {
 struct plat_stmmacenet_data {
 	int bus_id;
 	int phy_addr;
+	int intel_adhoc_addr;
 	int interface;
 	phy_interface_t phy_interface;
 	struct stmmac_mdio_bus_data *mdio_bus_data;
@@ -190,6 +191,7 @@ struct plat_stmmacenet_data {
 	struct reset_control *stmmac_rst;
 	struct stmmac_axi *axi;
 	int has_gmac4;
+	int has_serdes;
 	bool has_sun8i;
 	bool tso_en;
 	int rss_en;
-- 
2.17.1

