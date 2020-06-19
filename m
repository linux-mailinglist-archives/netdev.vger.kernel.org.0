Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FF120089E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 14:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730998AbgFSM0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 08:26:11 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:59043 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732987AbgFSMZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 08:25:33 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 444AE200009;
        Fri, 19 Jun 2020 12:25:16 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net, antoine.tenart@bootlin.com
Subject: [PATCH net-next v3 5/8] net: phy: mscc: 1588 block initialization
Date:   Fri, 19 Jun 2020 14:22:57 +0200
Message-Id: <20200619122300.2510533-6-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
References: <20200619122300.2510533-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Quentin Schulz <quentin.schulz@bootlin.com>

This patch adds the first parts of the 1588 support in the MSCC PHY,
with registers definition and the 1588 block initialization.

Those PHYs are distributed in hardware packages containing multiple
times the PHY. The VSC8584 for example is composed of 4 PHYs. With
hardware packages, parts of the logic is usually common and one of the
PHY has to be used for some parts of the initialization. Following this
logic, the 1588 blocks of those PHYs are shared between two PHYs and
accessing the registers has to be done using the "base" PHY of the
group. This is handled thanks to helpers in the PTP code (and locks).
We also need the MDIO bus lock while performing a single read or write
to the 1588 registers as the read/write are composed of multiple MDIO
transactions (and we don't want other threads updating the page).

Co-developed-by: Antoine Tenart <antoine.tenart@bootlin.com>
Signed-off-by: Quentin Schulz <quentin.schulz@bootlin.com>
Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/Makefile    |    4 +
 drivers/net/phy/mscc/mscc.h      |   34 +
 drivers/net/phy/mscc/mscc_main.c |   32 +-
 drivers/net/phy/mscc/mscc_ptp.c  | 1007 ++++++++++++++++++++++++++++++
 drivers/net/phy/mscc/mscc_ptp.h  |  477 ++++++++++++++
 5 files changed, 1552 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/phy/mscc/mscc_ptp.c
 create mode 100644 drivers/net/phy/mscc/mscc_ptp.h

diff --git a/drivers/net/phy/mscc/Makefile b/drivers/net/phy/mscc/Makefile
index 10af42cd9839..d8e22a4eeeff 100644
--- a/drivers/net/phy/mscc/Makefile
+++ b/drivers/net/phy/mscc/Makefile
@@ -8,3 +8,7 @@ mscc-objs := mscc_main.o
 ifdef CONFIG_MACSEC
 mscc-objs += mscc_macsec.o
 endif
+
+ifdef CONFIG_NETWORK_PHY_TIMESTAMPING
+mscc-objs += mscc_ptp.o
+endif
diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 756ec418f4f8..0881b22dbdac 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -133,6 +133,7 @@ enum rgmii_clock_delay {
  * in the same package.
  */
 #define MSCC_PHY_PAGE_EXTENDED_GPIO	  0x0010 /* Extended reg - GPIO */
+#define MSCC_PHY_PAGE_1588		  0x1588 /* PTP (1588) */
 #define MSCC_PHY_PAGE_TEST		  0x2a30 /* Test reg */
 #define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
 
@@ -373,6 +374,21 @@ struct vsc8531_private {
 	unsigned long ingr_flows;
 	unsigned long egr_flows;
 #endif
+
+	bool input_clk_init;
+	struct vsc85xx_ptp *ptp;
+
+	/* For multiple port PHYs; the MDIO address of the base PHY in the
+	 * pair of two PHYs that share a 1588 engine. PHY0 and PHY2 are coupled.
+	 * PHY1 and PHY3 as well. PHY0 and PHY1 are base PHYs for their
+	 * respective pair.
+	 */
+	unsigned int ts_base_addr;
+	u8 ts_base_phy;
+
+	/* ts_lock: used for per-PHY timestamping operations.
+	 */
+	struct mutex ts_lock;
 };
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
@@ -399,4 +415,22 @@ static inline void vsc8584_config_macsec_intr(struct phy_device *phydev)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_NETWORK_PHY_TIMESTAMPING)
+void vsc85xx_link_change_notify(struct phy_device *phydev);
+int vsc8584_ptp_init(struct phy_device *phydev);
+int vsc8584_ptp_probe(struct phy_device *phydev);
+#else
+static inline void vsc85xx_link_change_notify(struct phy_device *phydev)
+{
+}
+static inline int vsc8584_ptp_init(struct phy_device *phydev)
+{
+	return 0;
+}
+static inline int vsc8584_ptp_probe(struct phy_device *phydev)
+{
+	return 0;
+}
+#endif
+
 #endif /* _MSCC_PHY_H_ */
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 052a0def6e83..87ddae514627 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1299,11 +1299,29 @@ static void vsc8584_get_base_addr(struct phy_device *phydev)
 	__phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 	mutex_unlock(&phydev->mdio.bus->mdio_lock);
 
-	if (val & PHY_ADDR_REVERSED)
+	/* In the package, there are two pairs of PHYs (PHY0 + PHY2 and
+	 * PHY1 + PHY3). The first PHY of each pair (PHY0 and PHY1) is
+	 * the base PHY for timestamping operations.
+	 */
+	if (val & PHY_ADDR_REVERSED) {
 		vsc8531->base_addr = phydev->mdio.addr + addr;
-	else
+		vsc8531->ts_base_addr = phydev->mdio.addr;
+		vsc8531->ts_base_phy = addr;
+		if (addr > 1) {
+			vsc8531->ts_base_addr += 2;
+			vsc8531->ts_base_phy += 2;
+		}
+	} else {
 		vsc8531->base_addr = phydev->mdio.addr - addr;
 
+		vsc8531->ts_base_addr = phydev->mdio.addr;
+		vsc8531->ts_base_phy = addr;
+		if (addr > 1) {
+			vsc8531->ts_base_addr -= 2;
+			vsc8531->ts_base_phy -= 2;
+		}
+	}
+
 	vsc8531->addr = addr;
 }
 
@@ -1418,6 +1436,10 @@ static int vsc8584_config_init(struct phy_device *phydev)
 	if (ret)
 		return ret;
 
+	ret = vsc8584_ptp_init(phydev);
+	if (ret)
+		goto err;
+
 	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
 	val = phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_1);
@@ -1999,6 +2021,7 @@ static int vsc8584_probe(struct phy_device *phydev)
 	u32 default_mode[4] = {VSC8531_LINK_1000_ACTIVITY,
 	   VSC8531_LINK_100_ACTIVITY, VSC8531_LINK_ACTIVITY,
 	   VSC8531_DUPLEX_COLLISION};
+	int ret;
 
 	if ((phydev->phy_id & MSCC_DEV_REV_MASK) != VSC8584_REVB) {
 		dev_err(&phydev->mdio.dev, "Only VSC8584 revB is supported.\n");
@@ -2024,6 +2047,10 @@ static int vsc8584_probe(struct phy_device *phydev)
 	if (!vsc8531->stats)
 		return -ENOMEM;
 
+	ret = vsc8584_ptp_probe(phydev);
+	if (ret)
+		return ret;
+
 	return vsc85xx_dt_led_modes_get(phydev, default_mode);
 }
 
@@ -2403,6 +2430,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.get_sset_count = &vsc85xx_get_sset_count,
 	.get_strings    = &vsc85xx_get_strings,
 	.get_stats      = &vsc85xx_get_stats,
+	.link_change_notify = &vsc85xx_link_change_notify,
 }
 
 };
diff --git a/drivers/net/phy/mscc/mscc_ptp.c b/drivers/net/phy/mscc/mscc_ptp.c
new file mode 100644
index 000000000000..f964567fe662
--- /dev/null
+++ b/drivers/net/phy/mscc/mscc_ptp.c
@@ -0,0 +1,1007 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Driver for Microsemi VSC85xx PHYs - timestamping and PHC support
+ *
+ * Authors: Quentin Schulz & Antoine Tenart
+ * License: Dual MIT/GPL
+ * Copyright (c) 2020 Microsemi Corporation
+ */
+
+#include <linux/gpio/consumer.h>
+#include <linux/ip.h>
+#include <linux/net_tstamp.h>
+#include <linux/mii.h>
+#include <linux/phy.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/udp.h>
+#include <asm/unaligned.h>
+
+#include "mscc.h"
+#include "mscc_ptp.h"
+
+/* Two PHYs share the same 1588 processor and it's to be entirely configured
+ * through the base PHY of this processor.
+ */
+/* phydev->bus->mdio_lock should be locked when using this function */
+static int phy_ts_base_write(struct phy_device *phydev, u32 regnum, u16 val)
+{
+	struct vsc8531_private *priv = phydev->priv;
+
+	WARN_ON_ONCE(!mutex_is_locked(&phydev->mdio.bus->mdio_lock));
+	return __mdiobus_write(phydev->mdio.bus, priv->ts_base_addr, regnum,
+			       val);
+}
+
+/* phydev->bus->mdio_lock should be locked when using this function */
+static int phy_ts_base_read(struct phy_device *phydev, u32 regnum)
+{
+	struct vsc8531_private *priv = phydev->priv;
+
+	WARN_ON_ONCE(!mutex_is_locked(&phydev->mdio.bus->mdio_lock));
+	return __mdiobus_read(phydev->mdio.bus, priv->ts_base_addr, regnum);
+}
+
+enum ts_blk_hw {
+	INGRESS_ENGINE_0,
+	EGRESS_ENGINE_0,
+	INGRESS_ENGINE_1,
+	EGRESS_ENGINE_1,
+	INGRESS_ENGINE_2,
+	EGRESS_ENGINE_2,
+	PROCESSOR_0,
+	PROCESSOR_1,
+};
+
+enum ts_blk {
+	INGRESS,
+	EGRESS,
+	PROCESSOR,
+};
+
+static u32 vsc85xx_ts_read_csr(struct phy_device *phydev, enum ts_blk blk,
+			       u16 addr)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	bool base_port = phydev->mdio.addr == priv->ts_base_addr;
+	u32 val, cnt = 0;
+	enum ts_blk_hw blk_hw;
+
+	switch (blk) {
+	case INGRESS:
+		blk_hw = base_port ? INGRESS_ENGINE_0 : INGRESS_ENGINE_1;
+		break;
+	case EGRESS:
+		blk_hw = base_port ? EGRESS_ENGINE_0 : EGRESS_ENGINE_1;
+		break;
+	case PROCESSOR:
+		blk_hw = base_port ? PROCESSOR_0 : PROCESSOR_1;
+		break;
+	}
+
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+
+	phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_1588);
+
+	phy_ts_base_write(phydev, MSCC_PHY_TS_BIU_ADDR_CNTL, BIU_ADDR_EXE |
+			  BIU_ADDR_READ | BIU_BLK_ID(blk_hw) |
+			  BIU_CSR_ADDR(addr));
+
+	do {
+		val = phy_ts_base_read(phydev, MSCC_PHY_TS_BIU_ADDR_CNTL);
+	} while (!(val & BIU_ADDR_EXE) && cnt++ < BIU_ADDR_CNT_MAX);
+
+	val = phy_ts_base_read(phydev, MSCC_PHY_TS_CSR_DATA_MSB);
+	val <<= 16;
+	val |= phy_ts_base_read(phydev, MSCC_PHY_TS_CSR_DATA_LSB);
+
+	phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+
+	return val;
+}
+
+static void vsc85xx_ts_write_csr(struct phy_device *phydev, enum ts_blk blk,
+				 u16 addr, u32 val)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	bool base_port = phydev->mdio.addr == priv->ts_base_addr;
+	u32 reg, bypass, cnt = 0, lower = val & 0xffff, upper = val >> 16;
+	bool cond = (addr == MSCC_PHY_PTP_LTC_CTRL ||
+		     addr == MSCC_PHY_1588_INGR_VSC85XX_INT_MASK ||
+		     addr == MSCC_PHY_1588_VSC85XX_INT_MASK ||
+		     addr == MSCC_PHY_1588_INGR_VSC85XX_INT_STATUS ||
+		     addr == MSCC_PHY_1588_VSC85XX_INT_STATUS) &&
+		    blk == PROCESSOR;
+	enum ts_blk_hw blk_hw;
+
+	switch (blk) {
+	case INGRESS:
+		blk_hw = base_port ? INGRESS_ENGINE_0 : INGRESS_ENGINE_1;
+		break;
+	case EGRESS:
+		blk_hw = base_port ? EGRESS_ENGINE_0 : EGRESS_ENGINE_1;
+		break;
+	case PROCESSOR:
+	default:
+		blk_hw = base_port ? PROCESSOR_0 : PROCESSOR_1;
+		break;
+	}
+
+	mutex_lock(&phydev->mdio.bus->mdio_lock);
+
+	bypass = phy_ts_base_read(phydev, MSCC_PHY_BYPASS_CONTROL);
+
+	phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_1588);
+
+	if (!cond || (cond && upper))
+		phy_ts_base_write(phydev, MSCC_PHY_TS_CSR_DATA_MSB, upper);
+
+	phy_ts_base_write(phydev, MSCC_PHY_TS_CSR_DATA_LSB, lower);
+
+	phy_ts_base_write(phydev, MSCC_PHY_TS_BIU_ADDR_CNTL, BIU_ADDR_EXE |
+			  BIU_ADDR_WRITE | BIU_BLK_ID(blk_hw) |
+			  BIU_CSR_ADDR(addr));
+
+	do {
+		reg = phy_ts_base_read(phydev, MSCC_PHY_TS_BIU_ADDR_CNTL);
+	} while (!(reg & BIU_ADDR_EXE) && cnt++ < BIU_ADDR_CNT_MAX);
+
+	phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+
+	if (cond && upper)
+		phy_ts_base_write(phydev, MSCC_PHY_BYPASS_CONTROL, bypass);
+
+	mutex_unlock(&phydev->mdio.bus->mdio_lock);
+}
+
+/* Pick bytes from PTP header */
+#define PTP_HEADER_TRNSP_MSG		26
+#define PTP_HEADER_DOMAIN_NUM		25
+#define PTP_HEADER_BYTE_8_31(x)		(31 - (x))
+#define MAC_ADDRESS_BYTE(x)		((x) + (35 - ETH_ALEN + 1))
+
+static int vsc85xx_ts_fsb_init(struct phy_device *phydev)
+{
+	u8 sig_sel[16] = {};
+	signed char i, pos = 0;
+
+	/* Seq ID is 2B long and starts at 30th byte */
+	for (i = 1; i >= 0; i--)
+		sig_sel[pos++] = PTP_HEADER_BYTE_8_31(30 + i);
+
+	/* DomainNum */
+	sig_sel[pos++] = PTP_HEADER_DOMAIN_NUM;
+
+	/* MsgType */
+	sig_sel[pos++] = PTP_HEADER_TRNSP_MSG;
+
+	/* MAC address is 6B long */
+	for (i = ETH_ALEN - 1; i >= 0; i--)
+		sig_sel[pos++] = MAC_ADDRESS_BYTE(i);
+
+	/* Fill the last bytes of the signature to reach a 16B signature */
+	for (; pos < ARRAY_SIZE(sig_sel); pos++)
+		sig_sel[pos] = PTP_HEADER_TRNSP_MSG;
+
+	for (i = 0; i <= 2; i++) {
+		u32 val = 0;
+
+		for (pos = i * 5 + 4; pos >= i * 5; pos--)
+			val = (val << 6) | sig_sel[pos];
+
+		vsc85xx_ts_write_csr(phydev, EGRESS, MSCC_PHY_ANA_FSB_REG(i),
+				     val);
+	}
+
+	vsc85xx_ts_write_csr(phydev, EGRESS, MSCC_PHY_ANA_FSB_REG(3),
+			     sig_sel[15]);
+
+	return 0;
+}
+
+static const u32 vsc85xx_egr_latency[] = {
+	/* Copper Egress */
+	1272, /* 1000Mbps */
+	12516, /* 100Mbps */
+	125444, /* 10Mbps */
+	/* Fiber Egress */
+	1277, /* 1000Mbps */
+	12537, /* 100Mbps */
+	/* Copper Egress when MACsec ON */
+	3496, /* 1000Mbps */
+	34760, /* 100Mbps */
+	347844, /* 10Mbps */
+	/* Fiber Egress when MACsec ON */
+	3502, /* 1000Mbps */
+	34780, /* 100Mbps */
+};
+
+static const u32 vsc85xx_ingr_latency[] = {
+	/* Copper Ingress */
+	208, /* 1000Mbps */
+	304, /* 100Mbps */
+	2023, /* 10Mbps */
+	/* Fiber Ingress */
+	98, /* 1000Mbps */
+	197, /* 100Mbps */
+	/* Copper Ingress when MACsec ON */
+	2408, /* 1000Mbps */
+	22300, /* 100Mbps */
+	222009, /* 10Mbps */
+	/* Fiber Ingress when MACsec ON */
+	2299, /* 1000Mbps */
+	22192, /* 100Mbps */
+};
+
+static void vsc85xx_ts_set_latencies(struct phy_device *phydev)
+{
+	u32 val;
+	u8 idx;
+
+	/* No need to set latencies of packets if the PHY is not connected */
+	if (!phydev->link)
+		return;
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_STALL_LATENCY,
+			     STALL_EGR_LATENCY(phydev->speed));
+
+	switch (phydev->speed) {
+	case SPEED_100:
+		idx = 1;
+		break;
+	case SPEED_1000:
+		idx = 0;
+		break;
+	default:
+		idx = 2;
+		break;
+	}
+
+	if (IS_ENABLED(CONFIG_MACSEC))
+		idx += 5;
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_LOCAL_LATENCY,
+			     PTP_INGR_LOCAL_LATENCY(vsc85xx_ingr_latency[idx]));
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_TSP_CTRL);
+	val |= PHY_PTP_INGR_TSP_CTRL_LOAD_DELAYS;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_TSP_CTRL,
+			     val);
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_LOCAL_LATENCY,
+			     PTP_EGR_LOCAL_LATENCY(vsc85xx_egr_latency[idx]));
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TSP_CTRL);
+	val |= PHY_PTP_EGR_TSP_CTRL_LOAD_DELAYS;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TSP_CTRL, val);
+}
+
+static int vsc85xx_ts_disable_flows(struct phy_device *phydev, enum ts_blk blk)
+{
+	u8 i;
+
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_NXT_COMP, 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_UDP_CHKSUM,
+			     IP1_NXT_PROT_UDP_CHKSUM_WIDTH(2));
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP2_NXT_PROT_NXT_COMP, 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP2_NXT_PROT_UDP_CHKSUM,
+			     IP2_NXT_PROT_UDP_CHKSUM_WIDTH(2));
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_PHY_ANA_MPLS_COMP_NXT_COMP, 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_PHY_ANA_ETH1_NTX_PROT, 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_PHY_ANA_ETH2_NTX_PROT, 0);
+
+	for (i = 0; i < COMP_MAX_FLOWS; i++) {
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_ENA(i),
+				     IP1_FLOW_VALID_CH0 | IP1_FLOW_VALID_CH1);
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP2_FLOW_ENA(i),
+				     IP2_FLOW_VALID_CH0 | IP2_FLOW_VALID_CH1);
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_ENA(i),
+				     ETH1_FLOW_VALID_CH0 | ETH1_FLOW_VALID_CH1);
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH2_FLOW_ENA(i),
+				     ETH2_FLOW_VALID_CH0 | ETH2_FLOW_VALID_CH1);
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_MPLS_FLOW_CTRL(i),
+				     MPLS_FLOW_VALID_CH0 | MPLS_FLOW_VALID_CH1);
+
+		if (i >= PTP_COMP_MAX_FLOWS)
+			continue;
+
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_PTP_FLOW_ENA(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_DOMAIN_RANGE(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_MASK_UPPER(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_MASK_LOWER(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_MATCH_UPPER(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_MATCH_LOWER(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_PTP_ACTION(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_PTP_ACTION2(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_PTP_0_FIELD(i), 0);
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_OAM_PTP_FLOW_ENA(i),
+				     0);
+	}
+
+	return 0;
+}
+
+static int vsc85xx_ts_eth_cmp1_sig(struct phy_device *phydev)
+{
+	u32 val;
+
+	val = vsc85xx_ts_read_csr(phydev, EGRESS, MSCC_PHY_ANA_ETH1_NTX_PROT);
+	val &= ~ANA_ETH1_NTX_PROT_SIG_OFF_MASK;
+	val |= ANA_ETH1_NTX_PROT_SIG_OFF(0);
+	vsc85xx_ts_write_csr(phydev, EGRESS, MSCC_PHY_ANA_ETH1_NTX_PROT, val);
+
+	val = vsc85xx_ts_read_csr(phydev, EGRESS, MSCC_PHY_ANA_FSB_CFG);
+	val &= ~ANA_FSB_ADDR_FROM_BLOCK_SEL_MASK;
+	val |= ANA_FSB_ADDR_FROM_ETH1;
+	vsc85xx_ts_write_csr(phydev, EGRESS, MSCC_PHY_ANA_FSB_CFG, val);
+
+	return 0;
+}
+
+static int vsc85xx_ptp_cmp_init(struct phy_device *phydev, enum ts_blk blk)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	bool base = phydev->mdio.addr == vsc8531->ts_base_addr;
+	enum vsc85xx_ptp_msg_type msgs[] = {
+		PTP_MSG_TYPE_SYNC,
+		PTP_MSG_TYPE_DELAY_REQ
+	};
+	u32 val;
+	u8 i;
+
+	for (i = 0; i < ARRAY_SIZE(msgs); i++) {
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_PTP_FLOW_ENA(i),
+				     base ? PTP_FLOW_VALID_CH0 :
+				     PTP_FLOW_VALID_CH1);
+
+		val = vsc85xx_ts_read_csr(phydev, blk,
+					  MSCC_ANA_PTP_FLOW_DOMAIN_RANGE(i));
+		val &= ~PTP_FLOW_DOMAIN_RANGE_ENA;
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_DOMAIN_RANGE(i), val);
+
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_MATCH_UPPER(i),
+				     msgs[i] << 24);
+
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_PTP_FLOW_MASK_UPPER(i),
+				     PTP_FLOW_MSG_TYPE_MASK);
+	}
+
+	return 0;
+}
+
+static int vsc85xx_eth_cmp1_init(struct phy_device *phydev, enum ts_blk blk)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	bool base = phydev->mdio.addr == vsc8531->ts_base_addr;
+	u32 val;
+
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_PHY_ANA_ETH1_NXT_PROT_TAG, 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_PHY_ANA_ETH1_NTX_PROT_VLAN_TPID,
+			     ANA_ETH1_NTX_PROT_VLAN_TPID(ETH_P_8021AD));
+
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_ENA(0),
+			     base ? ETH1_FLOW_VALID_CH0 : ETH1_FLOW_VALID_CH1);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_MATCH_MODE(0),
+			     ANA_ETH1_FLOW_MATCH_VLAN_TAG2);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_ADDR_MATCH1(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_ADDR_MATCH2(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk,
+			     MSCC_ANA_ETH1_FLOW_VLAN_RANGE_I_TAG(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_VLAN_TAG1(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk,
+			     MSCC_ANA_ETH1_FLOW_VLAN_TAG2_I_TAG(0), 0);
+
+	val = vsc85xx_ts_read_csr(phydev, blk,
+				  MSCC_ANA_ETH1_FLOW_MATCH_MODE(0));
+	val &= ~ANA_ETH1_FLOW_MATCH_VLAN_TAG_MASK;
+	val |= ANA_ETH1_FLOW_MATCH_VLAN_VERIFY;
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_MATCH_MODE(0),
+			     val);
+
+	return 0;
+}
+
+static int vsc85xx_ip_cmp1_init(struct phy_device *phydev, enum ts_blk blk)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	bool base = phydev->mdio.addr == vsc8531->ts_base_addr;
+	u32 val;
+
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_MATCH2_UPPER,
+			     PTP_EV_PORT);
+	/* Match on dest port only, ignore src */
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_MASK2_UPPER,
+			     0xffff);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_MATCH2_LOWER,
+			     0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_MASK2_LOWER, 0);
+
+	val = vsc85xx_ts_read_csr(phydev, blk, MSCC_ANA_IP1_FLOW_ENA(0));
+	val &= ~IP1_FLOW_ENA_CHANNEL_MASK_MASK;
+	val |= base ? IP1_FLOW_VALID_CH0 : IP1_FLOW_VALID_CH1;
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_ENA(0), val);
+
+	/* Match all IPs */
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MATCH_UPPER(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MASK_UPPER(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MATCH_UPPER_MID(0),
+			     0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MASK_UPPER_MID(0),
+			     0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MATCH_LOWER_MID(0),
+			     0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MASK_LOWER_MID(0),
+			     0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MATCH_LOWER(0), 0);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_MASK_LOWER(0), 0);
+
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_PTP_IP_CHKSUM_SEL, 0);
+
+	return 0;
+}
+
+static int vsc85xx_eth1_next_comp(struct phy_device *phydev, enum ts_blk blk,
+				  u32 next_comp, u32 etype)
+{
+	u32 val;
+
+	val = vsc85xx_ts_read_csr(phydev, blk, MSCC_PHY_ANA_ETH1_NTX_PROT);
+	val &= ~ANA_ETH1_NTX_PROT_COMPARATOR_MASK;
+	val |= next_comp;
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_PHY_ANA_ETH1_NTX_PROT, val);
+
+	val = ANA_ETH1_NXT_PROT_ETYPE_MATCH(etype) |
+		ANA_ETH1_NXT_PROT_ETYPE_MATCH_ENA;
+	vsc85xx_ts_write_csr(phydev, blk,
+			     MSCC_PHY_ANA_ETH1_NXT_PROT_ETYPE_MATCH, val);
+
+	return 0;
+}
+
+static int vsc85xx_ip1_next_comp(struct phy_device *phydev, enum ts_blk blk,
+				 u32 next_comp, u32 header)
+{
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_NXT_COMP,
+			     ANA_IP1_NXT_PROT_NXT_COMP_BYTES_HDR(header) |
+			     next_comp);
+
+	return 0;
+}
+
+static int vsc85xx_ts_ptp_action_flow(struct phy_device *phydev, enum ts_blk blk, u8 flow, enum ptp_cmd cmd)
+{
+	u32 val;
+
+	/* Check non-zero reserved field */
+	val = PTP_FLOW_PTP_0_FIELD_PTP_FRAME | PTP_FLOW_PTP_0_FIELD_RSVRD_CHECK;
+	vsc85xx_ts_write_csr(phydev, blk,
+			     MSCC_ANA_PTP_FLOW_PTP_0_FIELD(flow), val);
+
+	val = PTP_FLOW_PTP_ACTION_CORR_OFFSET(8) |
+	      PTP_FLOW_PTP_ACTION_TIME_OFFSET(8) |
+	      PTP_FLOW_PTP_ACTION_PTP_CMD(cmd == PTP_SAVE_IN_TS_FIFO ?
+					  PTP_NOP : cmd);
+	if (cmd == PTP_SAVE_IN_TS_FIFO)
+		val |= PTP_FLOW_PTP_ACTION_SAVE_LOCAL_TIME;
+	else if (cmd == PTP_WRITE_NS)
+		val |= PTP_FLOW_PTP_ACTION_MOD_FRAME_STATUS_UPDATE |
+		       PTP_FLOW_PTP_ACTION_MOD_FRAME_STATUS_BYTE_OFFSET(6);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_PTP_FLOW_PTP_ACTION(flow),
+			     val);
+
+	if (cmd == PTP_WRITE_1588)
+		/* Rewrite timestamp directly in frame */
+		val = PTP_FLOW_PTP_ACTION2_REWRITE_OFFSET(34) |
+		      PTP_FLOW_PTP_ACTION2_REWRITE_BYTES(10);
+	else if (cmd == PTP_SAVE_IN_TS_FIFO)
+		/* no rewrite */
+		val = PTP_FLOW_PTP_ACTION2_REWRITE_OFFSET(0) |
+		      PTP_FLOW_PTP_ACTION2_REWRITE_BYTES(0);
+	else
+		/* Write in reserved field */
+		val = PTP_FLOW_PTP_ACTION2_REWRITE_OFFSET(16) |
+		      PTP_FLOW_PTP_ACTION2_REWRITE_BYTES(4);
+	vsc85xx_ts_write_csr(phydev, blk,
+			     MSCC_ANA_PTP_FLOW_PTP_ACTION2(flow), val);
+
+	return 0;
+}
+
+static int vsc85xx_ptp_conf(struct phy_device *phydev, enum ts_blk blk,
+			    bool one_step, bool enable)
+{
+	enum vsc85xx_ptp_msg_type msgs[] = {
+		PTP_MSG_TYPE_SYNC,
+		PTP_MSG_TYPE_DELAY_REQ
+	};
+	u32 val;
+	u8 i;
+
+	for (i = 0; i < ARRAY_SIZE(msgs); i++) {
+		if (blk == INGRESS)
+			vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
+						   PTP_WRITE_NS);
+		else if (msgs[i] == PTP_MSG_TYPE_SYNC && one_step)
+			/* no need to know Sync t when sending in one_step */
+			vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
+						   PTP_WRITE_1588);
+		else
+			vsc85xx_ts_ptp_action_flow(phydev, blk, msgs[i],
+						   PTP_SAVE_IN_TS_FIFO);
+
+		val = vsc85xx_ts_read_csr(phydev, blk,
+					  MSCC_ANA_PTP_FLOW_ENA(i));
+		val &= ~PTP_FLOW_ENA;
+		if (enable)
+			val |= PTP_FLOW_ENA;
+		vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_PTP_FLOW_ENA(i),
+				     val);
+	}
+
+	return 0;
+}
+
+static int vsc85xx_eth1_conf(struct phy_device *phydev, enum ts_blk blk,
+			     bool enable)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	u32 val = ANA_ETH1_FLOW_ADDR_MATCH2_DEST;
+
+	if (vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_PTP_V2_L2_EVENT) {
+		/* PTP over Ethernet multicast address for SYNC and DELAY msg */
+		u8 ptp_multicast[6] = {0x01, 0x1b, 0x19, 0x00, 0x00, 0x00};
+
+		val |= ANA_ETH1_FLOW_ADDR_MATCH2_FULL_ADDR |
+		       get_unaligned_be16(&ptp_multicast[4]);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_ETH1_FLOW_ADDR_MATCH2(0), val);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_ETH1_FLOW_ADDR_MATCH1(0),
+				     get_unaligned_be32(ptp_multicast));
+	} else {
+		val |= ANA_ETH1_FLOW_ADDR_MATCH2_ANY_MULTICAST;
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_ETH1_FLOW_ADDR_MATCH2(0), val);
+		vsc85xx_ts_write_csr(phydev, blk,
+				     MSCC_ANA_ETH1_FLOW_ADDR_MATCH1(0), 0);
+	}
+
+	val = vsc85xx_ts_read_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_ENA(0));
+	val &= ~ETH1_FLOW_ENA;
+	if (enable)
+		val |= ETH1_FLOW_ENA;
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_ETH1_FLOW_ENA(0), val);
+
+	return 0;
+}
+
+static int vsc85xx_ip1_conf(struct phy_device *phydev, enum ts_blk blk,
+			    bool enable)
+{
+	u32 val;
+
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_IP1_MODE,
+			     ANA_IP1_NXT_PROT_IPV4 |
+			     ANA_IP1_NXT_PROT_FLOW_OFFSET_IPV4);
+
+	/* Matching UDP protocol number */
+	val = ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MASK(0xff) |
+	      ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MATCH(IPPROTO_UDP) |
+	      ANA_IP1_NXT_PROT_IP_MATCH1_PROT_OFF(9);
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_IP_MATCH1,
+			     val);
+
+	/* End of IP protocol, start of next protocol (UDP) */
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_OFFSET2,
+			     ANA_IP1_NXT_PROT_OFFSET2(20));
+
+	val = vsc85xx_ts_read_csr(phydev, blk,
+				  MSCC_ANA_IP1_NXT_PROT_UDP_CHKSUM);
+	val &= ~(IP1_NXT_PROT_UDP_CHKSUM_OFF_MASK |
+		 IP1_NXT_PROT_UDP_CHKSUM_WIDTH_MASK);
+	val |= IP1_NXT_PROT_UDP_CHKSUM_WIDTH(2);
+
+	val &= ~(IP1_NXT_PROT_UDP_CHKSUM_UPDATE |
+		 IP1_NXT_PROT_UDP_CHKSUM_CLEAR);
+	/* UDP checksum offset in IPv4 packet
+	 * according to: https://tools.ietf.org/html/rfc768
+	 */
+	val |= IP1_NXT_PROT_UDP_CHKSUM_OFF(26) | IP1_NXT_PROT_UDP_CHKSUM_CLEAR;
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_NXT_PROT_UDP_CHKSUM,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, blk, MSCC_ANA_IP1_FLOW_ENA(0));
+	val &= ~(IP1_FLOW_MATCH_ADDR_MASK | IP1_FLOW_ENA);
+	val |= IP1_FLOW_MATCH_DEST_SRC_ADDR;
+	if (enable)
+		val |= IP1_FLOW_ENA;
+	vsc85xx_ts_write_csr(phydev, blk, MSCC_ANA_IP1_FLOW_ENA(0), val);
+
+	return 0;
+}
+
+static int vsc85xx_ts_engine_init(struct phy_device *phydev, bool one_step)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+	bool ptp_l4, base = phydev->mdio.addr == vsc8531->ts_base_addr;
+	u8 eng_id = base ? 0 : 1;
+	u32 val;
+
+	ptp_l4 = vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_PTP_V2_L4_EVENT;
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ANALYZER_MODE);
+	/* Disable INGRESS and EGRESS so engine eng_id can be reconfigured */
+	val &= ~(PTP_ANALYZER_MODE_EGR_ENA(BIT(eng_id)) |
+		 PTP_ANALYZER_MODE_INGR_ENA(BIT(eng_id)));
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ANALYZER_MODE,
+			     val);
+
+	if (vsc8531->ptp->rx_filter == HWTSTAMP_FILTER_PTP_V2_L2_EVENT) {
+		vsc85xx_eth1_next_comp(phydev, INGRESS,
+				       ANA_ETH1_NTX_PROT_PTP_OAM, ETH_P_1588);
+		vsc85xx_eth1_next_comp(phydev, EGRESS,
+				       ANA_ETH1_NTX_PROT_PTP_OAM, ETH_P_1588);
+	} else {
+		vsc85xx_eth1_next_comp(phydev, INGRESS,
+				       ANA_ETH1_NTX_PROT_IP_UDP_ACH_1,
+				       ETH_P_IP);
+		vsc85xx_eth1_next_comp(phydev, EGRESS,
+				       ANA_ETH1_NTX_PROT_IP_UDP_ACH_1,
+				       ETH_P_IP);
+		/* Header length of IPv[4/6] + UDP */
+		vsc85xx_ip1_next_comp(phydev, INGRESS,
+				      ANA_ETH1_NTX_PROT_PTP_OAM, 28);
+		vsc85xx_ip1_next_comp(phydev, EGRESS,
+				      ANA_ETH1_NTX_PROT_PTP_OAM, 28);
+	}
+
+	vsc85xx_eth1_conf(phydev, INGRESS,
+			  vsc8531->ptp->rx_filter != HWTSTAMP_FILTER_NONE);
+	vsc85xx_ip1_conf(phydev, INGRESS,
+			 ptp_l4 && vsc8531->ptp->rx_filter != HWTSTAMP_FILTER_NONE);
+	vsc85xx_ptp_conf(phydev, INGRESS, one_step,
+			 vsc8531->ptp->rx_filter != HWTSTAMP_FILTER_NONE);
+
+	vsc85xx_eth1_conf(phydev, EGRESS,
+			  vsc8531->ptp->tx_type != HWTSTAMP_TX_OFF);
+	vsc85xx_ip1_conf(phydev, EGRESS,
+			 ptp_l4 && vsc8531->ptp->tx_type != HWTSTAMP_TX_OFF);
+	vsc85xx_ptp_conf(phydev, EGRESS, one_step,
+			 vsc8531->ptp->tx_type != HWTSTAMP_TX_OFF);
+
+	val &= ~PTP_ANALYZER_MODE_EGR_ENA(BIT(eng_id));
+	if (vsc8531->ptp->tx_type != HWTSTAMP_TX_OFF)
+		val |= PTP_ANALYZER_MODE_EGR_ENA(BIT(eng_id));
+
+	val &= ~PTP_ANALYZER_MODE_INGR_ENA(BIT(eng_id));
+	if (vsc8531->ptp->rx_filter != HWTSTAMP_FILTER_NONE)
+		val |= PTP_ANALYZER_MODE_INGR_ENA(BIT(eng_id));
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ANALYZER_MODE,
+			     val);
+
+	return 0;
+}
+
+void vsc85xx_link_change_notify(struct phy_device *phydev)
+{
+	struct vsc8531_private *priv = phydev->priv;
+
+	mutex_lock(&priv->ts_lock);
+	vsc85xx_ts_set_latencies(phydev);
+	mutex_unlock(&priv->ts_lock);
+}
+
+static void vsc85xx_ts_reset_fifo(struct phy_device *phydev)
+{
+	u32 val;
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_TS_FIFO_CTRL);
+	val |= PTP_EGR_TS_FIFO_RESET;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TS_FIFO_CTRL,
+			     val);
+
+	val &= ~PTP_EGR_TS_FIFO_RESET;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TS_FIFO_CTRL,
+			     val);
+}
+
+static bool vsc8584_is_1588_input_clk_configured(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+
+	if (vsc8531->ts_base_addr != phydev->mdio.addr) {
+		struct mdio_device *dev;
+
+		dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
+		phydev = container_of(dev, struct phy_device, mdio);
+		vsc8531 = phydev->priv;
+	}
+
+	return vsc8531->input_clk_init;
+}
+
+static void vsc8584_set_input_clk_configured(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+
+	if (vsc8531->ts_base_addr != phydev->mdio.addr) {
+		struct mdio_device *dev;
+
+		dev = phydev->mdio.bus->mdio_map[vsc8531->ts_base_addr];
+		phydev = container_of(dev, struct phy_device, mdio);
+		vsc8531 = phydev->priv;
+	}
+
+	vsc8531->input_clk_init = true;
+}
+
+static int __vsc8584_init_ptp(struct phy_device *phydev)
+{
+	u32 ltc_seq_e[] = { 0, 400000, 0, 0, 0 };
+	u8  ltc_seq_a[] = { 8, 6, 5, 4, 2 };
+	u32 val;
+
+	if (!vsc8584_is_1588_input_clk_configured(phydev)) {
+		mutex_lock(&phydev->mdio.bus->mdio_lock);
+
+		/* 1588_DIFF_INPUT_CLK configuration: Use an external clock for
+		 * the LTC, as per 3.13.29 in the VSC8584 datasheet.
+		 */
+		phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+				  MSCC_PHY_PAGE_1588);
+		phy_ts_base_write(phydev, 29, 0x7ae0);
+		phy_ts_base_write(phydev, 30, 0xb71c);
+		phy_ts_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
+				  MSCC_PHY_PAGE_STANDARD);
+
+		mutex_unlock(&phydev->mdio.bus->mdio_lock);
+
+		vsc8584_set_input_clk_configured(phydev);
+	}
+
+	/* Disable predictor before configuring the 1588 block */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_PREDICTOR);
+	val &= ~PTP_INGR_PREDICTOR_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_PREDICTOR,
+			     val);
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_PREDICTOR);
+	val &= ~PTP_EGR_PREDICTOR_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_PREDICTOR,
+			     val);
+
+	/* By default, the internal clock of fixed rate 250MHz is used */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL);
+	val &= ~PTP_LTC_CTRL_CLK_SEL_MASK;
+	val |= PTP_LTC_CTRL_CLK_SEL_INTERNAL_250;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_CTRL, val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_SEQUENCE);
+	val &= ~PTP_LTC_SEQUENCE_A_MASK;
+	val |= PTP_LTC_SEQUENCE_A(ltc_seq_a[PHC_CLK_250MHZ]);
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_SEQUENCE, val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_SEQ);
+	val &= ~(PTP_LTC_SEQ_ERR_MASK | PTP_LTC_SEQ_ADD_SUB);
+	if (ltc_seq_e[PHC_CLK_250MHZ])
+		val |= PTP_LTC_SEQ_ADD_SUB;
+	val |= PTP_LTC_SEQ_ERR(ltc_seq_e[PHC_CLK_250MHZ]);
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_SEQ, val);
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_LTC_1PPS_WIDTH_ADJ,
+			     PPS_WIDTH_ADJ);
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_DELAY_FIFO,
+			     IS_ENABLED(CONFIG_MACSEC) ?
+			     PTP_INGR_DELAY_FIFO_DEPTH_MACSEC :
+			     PTP_INGR_DELAY_FIFO_DEPTH_DEFAULT);
+
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_DELAY_FIFO,
+			     IS_ENABLED(CONFIG_MACSEC) ?
+			     PTP_EGR_DELAY_FIFO_DEPTH_MACSEC :
+			     PTP_EGR_DELAY_FIFO_DEPTH_DEFAULT);
+
+	/* Enable n-phase sampler for Viper Rev-B */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ACCUR_CFG_STATUS);
+	val &= ~(PTP_ACCUR_PPS_OUT_BYPASS | PTP_ACCUR_PPS_IN_BYPASS |
+		 PTP_ACCUR_EGR_SOF_BYPASS | PTP_ACCUR_INGR_SOF_BYPASS |
+		 PTP_ACCUR_LOAD_SAVE_BYPASS);
+	val |= PTP_ACCUR_PPS_OUT_CALIB_ERR | PTP_ACCUR_PPS_OUT_CALIB_DONE |
+	       PTP_ACCUR_PPS_IN_CALIB_ERR | PTP_ACCUR_PPS_IN_CALIB_DONE |
+	       PTP_ACCUR_EGR_SOF_CALIB_ERR | PTP_ACCUR_EGR_SOF_CALIB_DONE |
+	       PTP_ACCUR_INGR_SOF_CALIB_ERR | PTP_ACCUR_INGR_SOF_CALIB_DONE |
+	       PTP_ACCUR_LOAD_SAVE_CALIB_ERR | PTP_ACCUR_LOAD_SAVE_CALIB_DONE;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ACCUR_CFG_STATUS,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ACCUR_CFG_STATUS);
+	val |= PTP_ACCUR_CALIB_TRIGG;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ACCUR_CFG_STATUS,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ACCUR_CFG_STATUS);
+	val &= ~PTP_ACCUR_CALIB_TRIGG;
+	val |= PTP_ACCUR_PPS_OUT_CALIB_ERR | PTP_ACCUR_PPS_OUT_CALIB_DONE |
+	       PTP_ACCUR_PPS_IN_CALIB_ERR | PTP_ACCUR_PPS_IN_CALIB_DONE |
+	       PTP_ACCUR_EGR_SOF_CALIB_ERR | PTP_ACCUR_EGR_SOF_CALIB_DONE |
+	       PTP_ACCUR_INGR_SOF_CALIB_ERR | PTP_ACCUR_INGR_SOF_CALIB_DONE |
+	       PTP_ACCUR_LOAD_SAVE_CALIB_ERR | PTP_ACCUR_LOAD_SAVE_CALIB_DONE;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ACCUR_CFG_STATUS,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ACCUR_CFG_STATUS);
+	val |= PTP_ACCUR_CALIB_TRIGG;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ACCUR_CFG_STATUS,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ACCUR_CFG_STATUS);
+	val &= ~PTP_ACCUR_CALIB_TRIGG;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ACCUR_CFG_STATUS,
+			     val);
+
+	/* Do not access FIFO via SI */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_TSTAMP_FIFO_SI);
+	val &= ~PTP_TSTAMP_FIFO_SI_EN;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_TSTAMP_FIFO_SI,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_REWRITER_CTRL);
+	val &= ~PTP_INGR_REWRITER_REDUCE_PREAMBLE;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_REWRITER_CTRL,
+			     val);
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_REWRITER_CTRL);
+	val &= ~PTP_EGR_REWRITER_REDUCE_PREAMBLE;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_REWRITER_CTRL,
+			     val);
+
+	/* Put the flag that indicates the frame has been modified to bit 7 */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_REWRITER_CTRL);
+	val |= PTP_INGR_REWRITER_FLAG_BIT_OFF(7) | PTP_INGR_REWRITER_FLAG_VAL;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_REWRITER_CTRL,
+			     val);
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_REWRITER_CTRL);
+	val |= PTP_EGR_REWRITER_FLAG_BIT_OFF(7);
+	val &= ~PTP_EGR_REWRITER_FLAG_VAL;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_REWRITER_CTRL,
+			     val);
+
+	/* 30bit mode for RX timestamp, only the nanoseconds are kept in
+	 * reserved field.
+	 */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_INGR_TSP_CTRL);
+	val |= PHY_PTP_INGR_TSP_CTRL_FRACT_NS;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_INGR_TSP_CTRL,
+			     val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TSP_CTRL);
+	val |= PHY_PTP_EGR_TSP_CTRL_FRACT_NS;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TSP_CTRL, val);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_SERIAL_TOD_IFACE);
+	val |= PTP_SERIAL_TOD_IFACE_LS_AUTO_CLR;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_SERIAL_TOD_IFACE,
+			     val);
+
+	vsc85xx_ts_fsb_init(phydev);
+
+	/* Set the Egress timestamp FIFO configuration and status register */
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_EGR_TS_FIFO_CTRL);
+	val &= ~(PTP_EGR_TS_FIFO_SIG_BYTES_MASK | PTP_EGR_TS_FIFO_THRESH_MASK);
+	/* 16 bytes for the signature, 10 for the timestamp in the TS FIFO */
+	val |= PTP_EGR_TS_FIFO_SIG_BYTES(16) | PTP_EGR_TS_FIFO_THRESH(7);
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_EGR_TS_FIFO_CTRL,
+			     val);
+
+	vsc85xx_ts_reset_fifo(phydev);
+
+	val = PTP_IFACE_CTRL_CLK_ENA;
+	if (!IS_ENABLED(CONFIG_MACSEC))
+		val |= PTP_IFACE_CTRL_GMII_PROT;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_IFACE_CTRL, val);
+
+	vsc85xx_ts_set_latencies(phydev);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_VERSION_CODE);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR, MSCC_PHY_PTP_IFACE_CTRL);
+	val |= PTP_IFACE_CTRL_EGR_BYPASS;
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_IFACE_CTRL, val);
+
+	vsc85xx_ts_disable_flows(phydev, EGRESS);
+	vsc85xx_ts_disable_flows(phydev, INGRESS);
+
+	val = vsc85xx_ts_read_csr(phydev, PROCESSOR,
+				  MSCC_PHY_PTP_ANALYZER_MODE);
+	/* Disable INGRESS and EGRESS so engine eng_id can be reconfigured */
+	val &= ~(PTP_ANALYZER_MODE_EGR_ENA_MASK |
+		 PTP_ANALYZER_MODE_INGR_ENA_MASK |
+		 PTP_ANA_INGR_ENCAP_FLOW_MODE_MASK |
+		 PTP_ANA_EGR_ENCAP_FLOW_MODE_MASK);
+	/* Strict matching in flow (packets should match flows from the same
+	 * index in all enabled comparators (except PTP)).
+	 */
+	val |= PTP_ANA_SPLIT_ENCAP_FLOW | PTP_ANA_INGR_ENCAP_FLOW_MODE(0x7) |
+	       PTP_ANA_EGR_ENCAP_FLOW_MODE(0x7);
+	vsc85xx_ts_write_csr(phydev, PROCESSOR, MSCC_PHY_PTP_ANALYZER_MODE,
+			     val);
+
+	/* Initialized for ingress and egress flows:
+	 * - The Ethernet comparator.
+	 * - The IP comparator.
+	 * - The PTP comparator.
+	 */
+	vsc85xx_eth_cmp1_init(phydev, INGRESS);
+	vsc85xx_ip_cmp1_init(phydev, INGRESS);
+	vsc85xx_ptp_cmp_init(phydev, INGRESS);
+	vsc85xx_eth_cmp1_init(phydev, EGRESS);
+	vsc85xx_ip_cmp1_init(phydev, EGRESS);
+	vsc85xx_ptp_cmp_init(phydev, EGRESS);
+
+	vsc85xx_ts_eth_cmp1_sig(phydev);
+
+	return 0;
+}
+
+int vsc8584_ptp_init(struct phy_device *phydev)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	int ret = 0;
+
+	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
+	case PHY_ID_VSC8575:
+	case PHY_ID_VSC8582:
+	case PHY_ID_VSC8584:
+		mutex_lock(&priv->ts_lock);
+		ret = __vsc8584_init_ptp(phydev);
+		mutex_unlock(&priv->ts_lock);
+	}
+
+	return ret;
+}
+
+int vsc8584_ptp_probe(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+
+	vsc8531->ptp = devm_kzalloc(&phydev->mdio.dev, sizeof(*vsc8531->ptp),
+				    GFP_KERNEL);
+	if (!vsc8531->ptp)
+		return -ENOMEM;
+
+	mutex_init(&vsc8531->ts_lock);
+
+	vsc8531->ptp->phydev = phydev;
+
+	return 0;
+}
diff --git a/drivers/net/phy/mscc/mscc_ptp.h b/drivers/net/phy/mscc/mscc_ptp.h
new file mode 100644
index 000000000000..3ea163af0f4f
--- /dev/null
+++ b/drivers/net/phy/mscc/mscc_ptp.h
@@ -0,0 +1,477 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Driver for Microsemi VSC85xx PHYs
+ *
+ * Copyright (c) 2020 Microsemi Corporation
+ */
+
+#ifndef _MSCC_PHY_PTP_H_
+#define _MSCC_PHY_PTP_H_
+
+/* 1588 page Registers */
+#define MSCC_PHY_TS_BIU_ADDR_CNTL	  16
+#define BIU_ADDR_EXE			  0x8000
+#define BIU_ADDR_READ			  0x4000
+#define BIU_ADDR_WRITE			  0x0000
+#define BIU_BLK_ID(x)			  ((x) << 11)
+#define BIU_CSR_ADDR(x)			  (x)
+#define BIU_ADDR_CNT_MAX		  8
+
+#define MSCC_PHY_TS_CSR_DATA_LSB	  17
+#define MSCC_PHY_TS_CSR_DATA_MSB	  18
+
+#define MSCC_PHY_1588_INGR_VSC85XX_INT_STATUS  0x002d
+#define MSCC_PHY_1588_VSC85XX_INT_STATUS  0x004d
+#define VSC85XX_1588_INT_FIFO_ADD	  0x0004
+#define VSC85XX_1588_INT_FIFO_OVERFLOW	  0x0001
+
+#define MSCC_PHY_1588_INGR_VSC85XX_INT_MASK	  0x002e
+#define MSCC_PHY_1588_VSC85XX_INT_MASK	  0x004e
+#define VSC85XX_1588_INT_MASK_MASK	  (VSC85XX_1588_INT_FIFO_ADD | \
+					   VSC85XX_1588_INT_FIFO_OVERFLOW)
+
+/* TS CSR addresses */
+#define MSCC_PHY_ANA_ETH1_NTX_PROT	  0x0000
+#define ANA_ETH1_NTX_PROT_SIG_OFF_MASK	  GENMASK(20, 16)
+#define ANA_ETH1_NTX_PROT_SIG_OFF(x)	  (((x) << 16) & ANA_ETH1_NTX_PROT_SIG_OFF_MASK)
+#define ANA_ETH1_NTX_PROT_COMPARATOR_MASK GENMASK(2, 0)
+#define ANA_ETH1_NTX_PROT_PTP_OAM	  0x0005
+#define ANA_ETH1_NTX_PROT_MPLS		  0x0004
+#define ANA_ETH1_NTX_PROT_IP_UDP_ACH_2	  0x0003
+#define ANA_ETH1_NTX_PROT_IP_UDP_ACH_1	  0x0002
+#define ANA_ETH1_NTX_PROT_ETH2		  0x0001
+
+#define MSCC_PHY_PTP_IFACE_CTRL		  0x0000
+#define PTP_IFACE_CTRL_CLK_ENA		  0x0040
+#define PTP_IFACE_CTRL_INGR_BYPASS	  0x0008
+#define PTP_IFACE_CTRL_EGR_BYPASS	  0x0004
+#define PTP_IFACE_CTRL_MII_PROT		  0x0003
+#define PTP_IFACE_CTRL_GMII_PROT	  0x0002
+#define PTP_IFACE_CTRL_XGMII_64_PROT	  0x0000
+
+#define MSCC_PHY_ANA_ETH1_NTX_PROT_VLAN_TPID	0x0001
+#define ANA_ETH1_NTX_PROT_VLAN_TPID_MASK  GENMASK(31, 16)
+#define ANA_ETH1_NTX_PROT_VLAN_TPID(x)	  (((x) << 16) & ANA_ETH1_NTX_PROT_VLAN_TPID_MASK)
+
+#define MSCC_PHY_PTP_ANALYZER_MODE	  0x0001
+#define PTP_ANA_SPLIT_ENCAP_FLOW	  0x1000000
+#define PTP_ANA_EGR_ENCAP_FLOW_MODE_MASK  GENMASK(22, 20)
+#define PTP_ANA_EGR_ENCAP_FLOW_MODE(x)	  (((x) << 20) & PTP_ANA_EGR_ENCAP_FLOW_MODE_MASK)
+#define PTP_ANA_INGR_ENCAP_FLOW_MODE_MASK GENMASK(18, 16)
+#define PTP_ANA_INGR_ENCAP_FLOW_MODE(x)	  (((x) << 16) & PTP_ANA_INGR_ENCAP_FLOW_MODE_MASK)
+#define PTP_ANALYZER_MODE_EGR_ENA_MASK	  GENMASK(6, 4)
+#define PTP_ANALYZER_MODE_EGR_ENA(x)	  (((x) << 4) & PTP_ANALYZER_MODE_EGR_ENA_MASK)
+#define PTP_ANALYZER_MODE_INGR_ENA_MASK	  GENMASK(2, 0)
+#define PTP_ANALYZER_MODE_INGR_ENA(x)	  ((x) & PTP_ANALYZER_MODE_INGR_ENA_MASK)
+
+#define MSCC_PHY_ANA_ETH1_NXT_PROT_TAG	  0x0002
+#define ANA_ETH1_NXT_PROT_TAG_ENA	  0x0001
+
+#define MSCC_PHY_PTP_MODE_CTRL		  0x0002
+#define PTP_MODE_CTRL_MODE_MASK		  GENMASK(2, 0)
+#define PTP_MODE_CTRL_PKT_MODE		  0x0004
+
+#define MSCC_PHY_ANA_ETH1_NXT_PROT_ETYPE_MATCH	0x0003
+#define ANA_ETH1_NXT_PROT_ETYPE_MATCH_ENA 0x10000
+#define ANA_ETH1_NXT_PROT_ETYPE_MATCH_MASK	GENMASK(15, 0)
+#define ANA_ETH1_NXT_PROT_ETYPE_MATCH(x)  ((x) & ANA_ETH1_NXT_PROT_ETYPE_MATCH_MASK)
+
+#define MSCC_PHY_PTP_VERSION_CODE	  0x0003
+#define PTP_IP_VERSION_MASK		  GENMASK(7, 0)
+#define PTP_IP_VERSION_2_1		  0x0021
+
+#define MSCC_ANA_ETH1_FLOW_ENA(x)	  (0x0010 + ((x) << 4))
+#define ETH1_FLOW_ENA_CHANNEL_MASK_MASK	  GENMASK(9, 8)
+#define ETH1_FLOW_ENA_CHANNEL_MASK(x)	  (((x) << 8) & ETH1_FLOW_ENA_CHANNEL_MASK_MASK)
+#define ETH1_FLOW_VALID_CH1	  ETH1_FLOW_ENA_CHANNEL_MASK(2)
+#define ETH1_FLOW_VALID_CH0	  ETH1_FLOW_ENA_CHANNEL_MASK(1)
+#define ETH1_FLOW_ENA			  0x0001
+
+#define MSCC_ANA_ETH1_FLOW_MATCH_MODE(x)  (MSCC_ANA_ETH1_FLOW_ENA(x) + 1)
+#define ANA_ETH1_FLOW_MATCH_VLAN_TAG_MASK GENMASK(7, 6)
+#define ANA_ETH1_FLOW_MATCH_VLAN_TAG(x)	  (((x) << 6) & ANA_ETH1_FLOW_MATCH_VLAN_TAG_MASK)
+#define ANA_ETH1_FLOW_MATCH_VLAN_TAG2	  0x0200
+#define ANA_ETH1_FLOW_MATCH_VLAN_VERIFY	  0x0010
+
+#define MSCC_ANA_ETH1_FLOW_ADDR_MATCH1(x) (MSCC_ANA_ETH1_FLOW_ENA(x) + 2)
+
+#define MSCC_ANA_ETH1_FLOW_ADDR_MATCH2(x) (MSCC_ANA_ETH1_FLOW_ENA(x) + 3)
+#define ANA_ETH1_FLOW_ADDR_MATCH2_MASK_MASK	GENMASK(22, 20)
+#define ANA_ETH1_FLOW_ADDR_MATCH2_ANY_MULTICAST	0x400000
+#define ANA_ETH1_FLOW_ADDR_MATCH2_FULL_ADDR	0x100000
+#define ANA_ETH1_FLOW_ADDR_MATCH2_SRC_DEST_MASK	GENMASK(17, 16)
+#define ANA_ETH1_FLOW_ADDR_MATCH2_SRC_DEST	0x020000
+#define ANA_ETH1_FLOW_ADDR_MATCH2_SRC	  0x010000
+#define ANA_ETH1_FLOW_ADDR_MATCH2_DEST	  0x000000
+
+#define MSCC_ANA_ETH1_FLOW_VLAN_RANGE_I_TAG(x)	(MSCC_ANA_ETH1_FLOW_ENA(x) + 4)
+#define MSCC_ANA_ETH1_FLOW_VLAN_TAG1(x)	  (MSCC_ANA_ETH1_FLOW_ENA(x) + 5)
+#define MSCC_ANA_ETH1_FLOW_VLAN_TAG2_I_TAG(x)	(MSCC_ANA_ETH1_FLOW_ENA(x) + 6)
+
+#define MSCC_PHY_PTP_LTC_CTRL		  0x0010
+#define PTP_LTC_CTRL_CLK_SEL_MASK	  GENMASK(14, 12)
+#define PTP_LTC_CTRL_CLK_SEL(x)		  (((x) << 12) & PTP_LTC_CTRL_CLK_SEL_MASK)
+#define PTP_LTC_CTRL_CLK_SEL_INTERNAL_250 PTP_LTC_CTRL_CLK_SEL(5)
+#define PTP_LTC_CTRL_AUTO_ADJ_UPDATE	  0x0010
+#define PTP_LTC_CTRL_ADD_SUB_1NS_REQ	  0x0008
+#define PTP_LTC_CTRL_ADD_1NS		  0x0004
+#define PTP_LTC_CTRL_SAVE_ENA		  0x0002
+#define PTP_LTC_CTRL_LOAD_ENA		  0x0001
+
+#define MSCC_PHY_PTP_LTC_LOAD_SEC_MSB	  0x0011
+#define PTP_LTC_LOAD_SEC_MSB(x)		  (((x) & GENMASK_ULL(47, 32)) >> 32)
+
+#define MSCC_PHY_PTP_LTC_LOAD_SEC_LSB	  0x0012
+#define PTP_LTC_LOAD_SEC_LSB(x)		  ((x) & GENMASK(31, 0))
+
+#define MSCC_PHY_PTP_LTC_LOAD_NS	  0x0013
+#define PTP_LTC_LOAD_NS(x)		  ((x) & GENMASK(31, 0))
+
+#define MSCC_PHY_PTP_LTC_SAVED_SEC_MSB	  0x0014
+#define MSCC_PHY_PTP_LTC_SAVED_SEC_LSB	  0x0015
+#define MSCC_PHY_PTP_LTC_SAVED_NS	  0x0016
+
+#define MSCC_PHY_PTP_LTC_SEQUENCE	  0x0017
+#define PTP_LTC_SEQUENCE_A_MASK		  GENMASK(3, 0)
+#define PTP_LTC_SEQUENCE_A(x)		  ((x) & PTP_LTC_SEQUENCE_A_MASK)
+
+#define MSCC_PHY_PTP_LTC_SEQ		  0x0018
+#define PTP_LTC_SEQ_ADD_SUB		  0x80000
+#define PTP_LTC_SEQ_ERR_MASK		  GENMASK(18, 0)
+#define PTP_LTC_SEQ_ERR(x)		  ((x) & PTP_LTC_SEQ_ERR_MASK)
+
+#define MSCC_PHY_PTP_LTC_AUTO_ADJ	  0x001a
+#define PTP_AUTO_ADJ_NS_ROLLOVER(x)	  ((x) & GENMASK(29, 0))
+#define PTP_AUTO_ADJ_ADD_SUB_1NS_MASK	  GENMASK(31, 30)
+#define PTP_AUTO_ADJ_SUB_1NS		  0x80000000
+#define PTP_AUTO_ADJ_ADD_1NS		  0x40000000
+
+#define MSCC_PHY_PTP_LTC_1PPS_WIDTH_ADJ	  0x001b
+#define PTP_LTC_1PPS_WIDTH_ADJ_MASK	  GENMASK(29, 0)
+
+#define MSCC_PHY_PTP_TSTAMP_FIFO_SI	  0x0020
+#define PTP_TSTAMP_FIFO_SI_EN		  0x0001
+
+#define MSCC_PHY_PTP_INGR_PREDICTOR	  0x0022
+#define PTP_INGR_PREDICTOR_EN		  0x0001
+
+#define MSCC_PHY_PTP_EGR_PREDICTOR	  0x0026
+#define PTP_EGR_PREDICTOR_EN		  0x0001
+
+#define MSCC_PHY_PTP_INGR_TSP_CTRL	  0x0035
+#define PHY_PTP_INGR_TSP_CTRL_FRACT_NS	  0x0004
+#define PHY_PTP_INGR_TSP_CTRL_LOAD_DELAYS 0x0001
+
+#define MSCC_PHY_PTP_INGR_LOCAL_LATENCY	  0x0037
+#define PTP_INGR_LOCAL_LATENCY_MASK	  GENMASK(22, 0)
+#define PTP_INGR_LOCAL_LATENCY(x)	  ((x) & PTP_INGR_LOCAL_LATENCY_MASK)
+
+#define MSCC_PHY_PTP_INGR_DELAY_FIFO	  0x003a
+#define PTP_INGR_DELAY_FIFO_DEPTH_MACSEC  0x0013
+#define PTP_INGR_DELAY_FIFO_DEPTH_DEFAULT 0x000f
+
+#define MSCC_PHY_PTP_INGR_TS_FIFO(x)	  (0x005c + (x))
+#define PTP_INGR_TS_FIFO_EMPTY		  0x80000000
+
+#define MSCC_PHY_PTP_INGR_REWRITER_CTRL	  0x0044
+#define PTP_INGR_REWRITER_REDUCE_PREAMBLE 0x0010
+#define PTP_INGR_REWRITER_FLAG_VAL	  0x0008
+#define PTP_INGR_REWRITER_FLAG_BIT_OFF_M  GENMASK(2, 0)
+#define PTP_INGR_REWRITER_FLAG_BIT_OFF(x) ((x) & PTP_INGR_REWRITER_FLAG_BIT_OFF_M)
+
+#define MSCC_PHY_PTP_EGR_STALL_LATENCY	  0x004f
+
+#define MSCC_PHY_PTP_EGR_TSP_CTRL	  0x0055
+#define PHY_PTP_EGR_TSP_CTRL_FRACT_NS	  0x0004
+#define PHY_PTP_EGR_TSP_CTRL_LOAD_DELAYS  0x0001
+
+#define MSCC_PHY_PTP_EGR_LOCAL_LATENCY	  0x0057
+#define PTP_EGR_LOCAL_LATENCY_MASK	  GENMASK(22, 0)
+#define PTP_EGR_LOCAL_LATENCY(x)	  ((x) & PTP_EGR_LOCAL_LATENCY_MASK)
+
+#define MSCC_PHY_PTP_EGR_DELAY_FIFO	  0x005a
+#define PTP_EGR_DELAY_FIFO_DEPTH_MACSEC	  0x0013
+#define PTP_EGR_DELAY_FIFO_DEPTH_DEFAULT  0x000f
+
+#define MSCC_PHY_PTP_EGR_TS_FIFO_CTRL	  0x005b
+#define PTP_EGR_TS_FIFO_RESET		  0x10000
+#define PTP_EGR_FIFO_LEVEL_LAST_READ_MASK GENMASK(15, 12)
+#define PTP_EGR_FIFO_LEVEL_LAST_READ(x)	  (((x) & PTP_EGR_FIFO_LEVEL_LAST_READ_MASK) >> 12)
+#define PTP_EGR_TS_FIFO_THRESH_MASK	  GENMASK(11, 8)
+#define PTP_EGR_TS_FIFO_THRESH(x)	  (((x) << 8) & PTP_EGR_TS_FIFO_THRESH_MASK)
+#define PTP_EGR_TS_FIFO_SIG_BYTES_MASK	  GENMASK(4, 0)
+#define PTP_EGR_TS_FIFO_SIG_BYTES(x)	  ((x) & PTP_EGR_TS_FIFO_SIG_BYTES_MASK)
+
+#define MSCC_PHY_PTP_EGR_TS_FIFO(x)	  (0x005c + (x))
+#define PTP_EGR_TS_FIFO_EMPTY		  0x80000000
+#define PTP_EGR_TS_FIFO_0_MASK		  GENMASK(15, 0)
+
+#define MSCC_PHY_PTP_EGR_REWRITER_CTRL	  0x0064
+#define PTP_EGR_REWRITER_REDUCE_PREAMBLE  0x0010
+#define PTP_EGR_REWRITER_FLAG_VAL	  0x0008
+#define PTP_EGR_REWRITER_FLAG_BIT_OFF_M   GENMASK(2, 0)
+#define PTP_EGR_REWRITER_FLAG_BIT_OFF(x)  ((x) & PTP_EGR_REWRITER_FLAG_BIT_OFF_M)
+
+#define MSCC_PHY_PTP_SERIAL_TOD_IFACE	  0x006e
+#define PTP_SERIAL_TOD_IFACE_LS_AUTO_CLR  0x0004
+
+#define MSCC_PHY_PTP_LTC_OFFSET		  0x0070
+#define PTP_LTC_OFFSET_ADJ		  BIT(31)
+#define PTP_LTC_OFFSET_ADD		  BIT(30)
+#define PTP_LTC_OFFSET_VAL(x)		  (x)
+
+#define MSCC_PHY_PTP_ACCUR_CFG_STATUS	  0x0074
+#define PTP_ACCUR_PPS_OUT_CALIB_ERR	  0x20000
+#define PTP_ACCUR_PPS_OUT_CALIB_DONE	  0x10000
+#define PTP_ACCUR_PPS_IN_CALIB_ERR	  0x4000
+#define PTP_ACCUR_PPS_IN_CALIB_DONE	  0x2000
+#define PTP_ACCUR_EGR_SOF_CALIB_ERR	  0x1000
+#define PTP_ACCUR_EGR_SOF_CALIB_DONE	  0x0800
+#define PTP_ACCUR_INGR_SOF_CALIB_ERR	  0x0400
+#define PTP_ACCUR_INGR_SOF_CALIB_DONE	  0x0200
+#define PTP_ACCUR_LOAD_SAVE_CALIB_ERR	  0x0100
+#define PTP_ACCUR_LOAD_SAVE_CALIB_DONE	  0x0080
+#define PTP_ACCUR_CALIB_TRIGG		  0x0040
+#define PTP_ACCUR_PPS_OUT_BYPASS	  0x0010
+#define PTP_ACCUR_PPS_IN_BYPASS		  0x0008
+#define PTP_ACCUR_EGR_SOF_BYPASS	  0x0004
+#define PTP_ACCUR_INGR_SOF_BYPASS	  0x0002
+#define PTP_ACCUR_LOAD_SAVE_BYPASS	  0x0001
+
+#define MSCC_PHY_ANA_ETH2_NTX_PROT	  0x0090
+#define ANA_ETH2_NTX_PROT_COMPARATOR_MASK GENMASK(2, 0)
+#define ANA_ETH2_NTX_PROT_PTP_OAM	  0x0005
+#define ANA_ETH2_NTX_PROT_MPLS		  0x0004
+#define ANA_ETH2_NTX_PROT_IP_UDP_ACH_2	  0x0003
+#define ANA_ETH2_NTX_PROT_IP_UDP_ACH_1	  0x0002
+#define ANA_ETH2_NTX_PROT_ETH2		  0x0001
+
+#define MSCC_PHY_ANA_ETH2_NXT_PROT_ETYPE_MATCH	0x0003
+#define ANA_ETH2_NXT_PROT_ETYPE_MATCH_ENA 0x10000
+#define ANA_ETH2_NXT_PROT_ETYPE_MATCH_MASK	GENMASK(15, 0)
+#define ANA_ETH2_NXT_PROT_ETYPE_MATCH(x)  ((x) & ANA_ETH2_NXT_PROT_ETYPE_MATCH_MASK)
+
+#define MSCC_ANA_ETH2_FLOW_ENA(x)	  (0x00a0 + ((x) << 4))
+#define ETH2_FLOW_ENA_CHANNEL_MASK_MASK	  GENMASK(9, 8)
+#define ETH2_FLOW_ENA_CHANNEL_MASK(x)	  (((x) << 8) & ETH2_FLOW_ENA_CHANNEL_MASK_MASK)
+#define ETH2_FLOW_VALID_CH1	  ETH2_FLOW_ENA_CHANNEL_MASK(2)
+#define ETH2_FLOW_VALID_CH0	  ETH2_FLOW_ENA_CHANNEL_MASK(1)
+
+#define MSCC_PHY_ANA_MPLS_COMP_NXT_COMP	  0x0120
+#define ANA_MPLS_NTX_PROT_COMPARATOR_MASK GENMASK(2, 0)
+#define ANA_MPLS_NTX_PROT_PTP_OAM	  0x0005
+#define ANA_MPLS_NTX_PROT_MPLS		  0x0004
+#define ANA_MPLS_NTX_PROT_IP_UDP_ACH_2	  0x0003
+#define ANA_MPLS_NTX_PROT_IP_UDP_ACH_1	  0x0002
+#define ANA_MPLS_NTX_PROT_ETH2		  0x0001
+
+#define MSCC_ANA_MPLS_FLOW_CTRL(x)	  (0x0130 + ((x) << 4))
+#define MPLS_FLOW_CTRL_CHANNEL_MASK_MASK  GENMASK(25, 24)
+#define MPLS_FLOW_CTRL_CHANNEL_MASK(x)	  (((x) << 24) & MPLS_FLOW_CTRL_CHANNEL_MASK_MASK)
+#define MPLS_FLOW_VALID_CH1		  MPLS_FLOW_CTRL_CHANNEL_MASK(2)
+#define MPLS_FLOW_VALID_CH0		  MPLS_FLOW_CTRL_CHANNEL_MASK(1)
+
+#define MSCC_ANA_IP1_NXT_PROT_NXT_COMP	  0x01b0
+#define ANA_IP1_NXT_PROT_NXT_COMP_BYTES_HDR_MASK	GENMASK(15, 8)
+#define ANA_IP1_NXT_PROT_NXT_COMP_BYTES_HDR(x)	(((x) << 8) & ANA_IP1_NXT_PROT_NXT_COMP_BYTES_HDR_MASK)
+#define ANA_IP1_NXT_PROT_NXT_COMP_PTP_OAM	0x0005
+#define ANA_IP1_NXT_PROT_NXT_COMP_IP_UDP_ACH2	0x0003
+
+#define MSCC_ANA_IP1_NXT_PROT_IP1_MODE	  0x01b1
+#define ANA_IP1_NXT_PROT_FLOW_OFFSET_IPV4 0x0c00
+#define ANA_IP1_NXT_PROT_FLOW_OFFSET_IPV6 0x0800
+#define ANA_IP1_NXT_PROT_IPV6		  0x0001
+#define ANA_IP1_NXT_PROT_IPV4		  0x0000
+
+#define MSCC_ANA_IP1_NXT_PROT_IP_MATCH1	  0x01b2
+#define ANA_IP1_NXT_PROT_IP_MATCH1_PROT_OFF_MASK	GENMASK(20, 16)
+#define ANA_IP1_NXT_PROT_IP_MATCH1_PROT_OFF(x)	(((x) << 16) & ANA_IP1_NXT_PROT_IP_MATCH1_PROT_OFF_MASK)
+#define ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MASK_MASK	GENMASK(15, 8)
+#define ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MASK(x)	(((x) << 15) & ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MASK_MASK)
+#define ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MATCH_MASK	GENMASK(7, 0)
+#define ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MATCH(x)	((x) & ANA_IP1_NXT_PROT_IP_MATCH1_PROT_MATCH_MASK)
+
+#define MSCC_ANA_IP1_NXT_PROT_MATCH2_UPPER	0x01b3
+#define MSCC_ANA_IP1_NXT_PROT_MATCH2_LOWER	0x01b4
+#define MSCC_ANA_IP1_NXT_PROT_MASK2_UPPER	0x01b5
+#define MSCC_ANA_IP1_NXT_PROT_MASK2_LOWER	0x01b6
+
+#define MSCC_ANA_IP1_NXT_PROT_OFFSET2	  0x01b7
+#define ANA_IP1_NXT_PROT_OFFSET2_MASK	  GENMASK(6, 0)
+#define ANA_IP1_NXT_PROT_OFFSET2(x)	  ((x) & ANA_IP1_NXT_PROT_OFFSET2_MASK)
+
+#define MSCC_ANA_IP1_NXT_PROT_UDP_CHKSUM  0x01b8
+#define IP1_NXT_PROT_UDP_CHKSUM_OFF_MASK  GENMASK(15, 8)
+#define IP1_NXT_PROT_UDP_CHKSUM_OFF(x)	  (((x) << 8) & IP1_NXT_PROT_UDP_CHKSUM_OFF_MASK)
+#define IP1_NXT_PROT_UDP_CHKSUM_WIDTH_MASK	GENMASK(5, 4)
+#define IP1_NXT_PROT_UDP_CHKSUM_WIDTH(x)  (((x) << 4) & IP1_NXT_PROT_UDP_CHKSUM_WIDTH_MASK)
+#define IP1_NXT_PROT_UDP_CHKSUM_UPDATE	  0x0002
+#define IP1_NXT_PROT_UDP_CHKSUM_CLEAR	  0x0001
+
+#define MSCC_ANA_IP1_FLOW_ENA(x)	  (0x01c0 + ((x) << 4))
+#define IP1_FLOW_MATCH_ADDR_MASK	  GENMASK(9, 8)
+#define IP1_FLOW_MATCH_DEST_SRC_ADDR	  0x0200
+#define IP1_FLOW_MATCH_DEST_ADDR	  0x0100
+#define IP1_FLOW_MATCH_SRC_ADDR		  0x0000
+#define IP1_FLOW_ENA_CHANNEL_MASK_MASK	  GENMASK(5, 4)
+#define IP1_FLOW_ENA_CHANNEL_MASK(x)	  (((x) << 4) & IP1_FLOW_ENA_CHANNEL_MASK_MASK)
+#define IP1_FLOW_VALID_CH1		  IP1_FLOW_ENA_CHANNEL_MASK(2)
+#define IP1_FLOW_VALID_CH0		  IP1_FLOW_ENA_CHANNEL_MASK(1)
+#define IP1_FLOW_ENA			  0x0001
+
+#define MSCC_ANA_OAM_PTP_FLOW_ENA(x)	  (0x1e0 + ((x) << 4))
+#define MSCC_ANA_OAM_PTP_FLOW_MATCH_LOWER(x)	(MSCC_ANA_OAM_PTP_FLOW_ENA(x) + 2)
+#define MSCC_ANA_OAM_PTP_FLOW_MASK_LOWER(x)	(MSCC_ANA_OAM_PTP_FLOW_ENA(x) + 4)
+
+#define MSCC_ANA_OAM_PTP_FLOW_PTP_0_FIELD(x)	(MSCC_ANA_OAM_PTP_FLOW_ENA(x) + 8)
+
+#define MSCC_ANA_IP1_FLOW_MATCH_UPPER(x)  (MSCC_ANA_IP1_FLOW_ENA(x) + 1)
+#define MSCC_ANA_IP1_FLOW_MATCH_UPPER_MID(x)  (MSCC_ANA_IP1_FLOW_ENA(x) + 2)
+#define MSCC_ANA_IP1_FLOW_MATCH_LOWER_MID(x)  (MSCC_ANA_IP1_FLOW_ENA(x) + 3)
+#define MSCC_ANA_IP1_FLOW_MATCH_LOWER(x)  (MSCC_ANA_IP1_FLOW_ENA(x) + 4)
+#define MSCC_ANA_IP1_FLOW_MASK_UPPER(x)	  (MSCC_ANA_IP1_FLOW_ENA(x) + 5)
+#define MSCC_ANA_IP1_FLOW_MASK_UPPER_MID(x)	  (MSCC_ANA_IP1_FLOW_ENA(x) + 6)
+#define MSCC_ANA_IP1_FLOW_MASK_LOWER_MID(x)	  (MSCC_ANA_IP1_FLOW_ENA(x) + 7)
+#define MSCC_ANA_IP1_FLOW_MASK_LOWER(x)	  (MSCC_ANA_IP1_FLOW_ENA(x) + 8)
+
+#define MSCC_ANA_IP2_NXT_PROT_NXT_COMP	  0x0240
+#define ANA_IP2_NXT_PROT_NXT_COMP_BYTES_HDR_MASK	GENMASK(15, 8)
+#define ANA_IP2_NXT_PROT_NXT_COMP_BYTES_HDR(x)	(((x) << 8) & ANA_IP2_NXT_PROT_NXT_COMP_BYTES_HDR_MASK)
+#define ANA_IP2_NXT_PROT_NXT_COMP_PTP_OAM	0x0005
+#define ANA_IP2_NXT_PROT_NXT_COMP_IP_UDP_ACH2	0x0003
+
+#define MSCC_ANA_IP2_NXT_PROT_UDP_CHKSUM  0x0248
+#define IP2_NXT_PROT_UDP_CHKSUM_OFF_MASK  GENMASK(15, 8)
+#define IP2_NXT_PROT_UDP_CHKSUM_OFF(x)	  (((x) << 8) & IP2_NXT_PROT_UDP_CHKSUM_OFF_MASK)
+#define IP2_NXT_PROT_UDP_CHKSUM_WIDTH_MASK  GENMASK(5, 4)
+#define IP2_NXT_PROT_UDP_CHKSUM_WIDTH(x)  (((x) << 4) & IP2_NXT_PROT_UDP_CHKSUM_WIDTH_MASK)
+
+#define MSCC_ANA_IP2_FLOW_ENA(x)	  (0x0250 + ((x) << 4))
+#define IP2_FLOW_ENA_CHANNEL_MASK_MASK	  GENMASK(5, 4)
+#define IP2_FLOW_ENA_CHANNEL_MASK(x)	  (((x) << 4) & IP2_FLOW_ENA_CHANNEL_MASK_MASK)
+#define IP2_FLOW_VALID_CH1	  IP2_FLOW_ENA_CHANNEL_MASK(2)
+#define IP2_FLOW_VALID_CH0	  IP2_FLOW_ENA_CHANNEL_MASK(1)
+
+#define MSCC_ANA_PTP_FLOW_ENA(x)	  (0x02d0 + ((x) << 4))
+#define PTP_FLOW_ENA_CHANNEL_MASK_MASK	  GENMASK(5, 4)
+#define PTP_FLOW_ENA_CHANNEL_MASK(x)	  (((x) << 4) & PTP_FLOW_ENA_CHANNEL_MASK_MASK)
+#define PTP_FLOW_VALID_CH1	  PTP_FLOW_ENA_CHANNEL_MASK(2)
+#define PTP_FLOW_VALID_CH0	  PTP_FLOW_ENA_CHANNEL_MASK(1)
+#define PTP_FLOW_ENA			  0x0001
+
+#define MSCC_ANA_PTP_FLOW_MATCH_UPPER(x)  (MSCC_ANA_PTP_FLOW_ENA(x) + 1)
+#define PTP_FLOW_MSG_TYPE_MASK		  0x0F000000
+#define PTP_FLOW_MSG_PDELAY_RESP	  0x04000000
+#define PTP_FLOW_MSG_PDELAY_REQ		  0x02000000
+#define PTP_FLOW_MSG_DELAY_REQ		  0x01000000
+#define PTP_FLOW_MSG_SYNC		  0x00000000
+
+#define MSCC_ANA_PTP_FLOW_MATCH_LOWER(x)  (MSCC_ANA_PTP_FLOW_ENA(x) + 2)
+#define MSCC_ANA_PTP_FLOW_MASK_UPPER(x)	  (MSCC_ANA_PTP_FLOW_ENA(x) + 3)
+#define MSCC_ANA_PTP_FLOW_MASK_LOWER(x)	  (MSCC_ANA_PTP_FLOW_ENA(x) + 4)
+
+#define MSCC_ANA_PTP_FLOW_DOMAIN_RANGE(x) (MSCC_ANA_PTP_FLOW_ENA(x) + 5)
+#define PTP_FLOW_DOMAIN_RANGE_ENA	   0x0001
+
+#define MSCC_ANA_PTP_FLOW_PTP_ACTION(x)	  (MSCC_ANA_PTP_FLOW_ENA(x) + 6)
+#define PTP_FLOW_PTP_ACTION_MOD_FRAME_STATUS_UPDATE	0x10000000
+#define PTP_FLOW_PTP_ACTION_MOD_FRAME_STATUS_BYTE_OFFSET_MASK	GENMASK(26, 24)
+#define PTP_FLOW_PTP_ACTION_MOD_FRAME_STATUS_BYTE_OFFSET(x)	(((x) << 24) & PTP_FLOW_PTP_ACTION_MOD_FRAME_STATUS_BYTE_OFFSET_MASK)
+#define PTP_FLOW_PTP_ACTION_PTP_CMD_MASK  GENMASK(3, 0)
+#define PTP_FLOW_PTP_ACTION_PTP_CMD(x)	  ((x) & PTP_FLOW_PTP_ACTION_PTP_CMD_MASK)
+#define PTP_FLOW_PTP_ACTION_SUB_DELAY_ASYM	0x00200000
+#define PTP_FLOW_PTP_ACTION_ADD_DELAY_ASYM	0x00100000
+#define PTP_FLOW_PTP_ACTION_TIME_OFFSET_MASK	GENMASK(15, 10)
+#define PTP_FLOW_PTP_ACTION_TIME_OFFSET(x)	(((x) << 10) & PTP_FLOW_PTP_ACTION_TIME_OFFSET_MASK)
+#define PTP_FLOW_PTP_ACTION_CORR_OFFSET_MASK	GENMASK(9, 5)
+#define PTP_FLOW_PTP_ACTION_CORR_OFFSET(x)	(((x) << 5) & PTP_FLOW_PTP_ACTION_CORR_OFFSET_MASK)
+#define PTP_FLOW_PTP_ACTION_SAVE_LOCAL_TIME 0x00000010
+
+#define MSCC_ANA_PTP_FLOW_PTP_ACTION2(x)  (MSCC_ANA_PTP_FLOW_ENA(x) + 7)
+#define PTP_FLOW_PTP_ACTION2_REWRITE_OFFSET_MASK	GENMASK(15, 8)
+#define PTP_FLOW_PTP_ACTION2_REWRITE_OFFSET(x)	(((x) << 8) & PTP_FLOW_PTP_ACTION2_REWRITE_OFFSET_MASK)
+#define PTP_FLOW_PTP_ACTION2_REWRITE_BYTES_MASK	GENMASK(3, 0)
+#define PTP_FLOW_PTP_ACTION2_REWRITE_BYTES(x)	((x) & PTP_FLOW_PTP_ACTION2_REWRITE_BYTES_MASK)
+
+#define MSCC_ANA_PTP_FLOW_PTP_0_FIELD(x)  (MSCC_ANA_PTP_FLOW_ENA(x) + 8)
+#define PTP_FLOW_PTP_0_FIELD_PTP_FRAME	  0x8000
+#define PTP_FLOW_PTP_0_FIELD_RSVRD_CHECK  0x4000
+#define PTP_FLOW_PTP_0_FIELD_OFFSET_MASK  GENMASK(13, 8)
+#define PTP_FLOW_PTP_0_FIELD_OFFSET(x)	  (((x) << 8) & PTP_FLOW_PTP_0_FIELD_OFFSET_MASK)
+#define PTP_FLOW_PTP_0_FIELD_BYTES_MASK	  GENMASK(3, 0)
+#define PTP_FLOW_PTP_0_FIELD_BYTES(x)	  ((x) & PTP_FLOW_PTP_0_FIELD_BYTES_MASK)
+
+#define MSCC_ANA_PTP_IP_CHKSUM_SEL	  0x0330
+#define ANA_PTP_IP_CHKSUM_SEL_IP_COMP_2   0x0001
+#define ANA_PTP_IP_CHKSUM_SEL_IP_COMP_1	  0x0000
+
+#define MSCC_PHY_ANA_FSB_CFG		  0x331
+#define ANA_FSB_ADDR_FROM_BLOCK_SEL_MASK  GENMASK(1, 0)
+#define ANA_FSB_ADDR_FROM_IP2		  0x0003
+#define ANA_FSB_ADDR_FROM_IP1		  0x0002
+#define ANA_FSB_ADDR_FROM_ETH2		  0x0001
+#define ANA_FSB_ADDR_FROM_ETH1		  0x0000
+
+#define MSCC_PHY_ANA_FSB_REG(x)		  (0x332 + (x))
+
+#define COMP_MAX_FLOWS			  8
+#define PTP_COMP_MAX_FLOWS		  6
+
+#define PPS_WIDTH_ADJ			  0x1dcd6500
+#define STALL_EGR_LATENCY(x)		  (1536000 / (x))
+
+/* PHC clock available frequencies. */
+enum {
+	PHC_CLK_125MHZ,
+	PHC_CLK_156_25MHZ,
+	PHC_CLK_200MHZ,
+	PHC_CLK_250MHZ,
+	PHC_CLK_500MHZ,
+};
+
+enum ptp_cmd {
+	PTP_NOP = 0,
+	PTP_WRITE_1588 = 5,
+	PTP_WRITE_NS = 7,
+	PTP_SAVE_IN_TS_FIFO = 11, /* invalid when writing in reg */
+};
+
+enum vsc85xx_ptp_msg_type {
+	PTP_MSG_TYPE_SYNC,
+	PTP_MSG_TYPE_DELAY_REQ,
+};
+
+struct vsc85xx_ptphdr {
+	u8 tsmt; /* transportSpecific | messageType */
+	u8 ver;  /* reserved0 | versionPTP */
+	__be16 msglen;
+	u8 domain;
+	u8 rsrvd1;
+	__be16 flags;
+	__be64 correction;
+	__be32 rsrvd2;
+	__be64 clk_identity;
+	__be16 src_port_id;
+	__be16 seq_id;
+	u8 ctrl;
+	u8 log_interval;
+} __attribute__((__packed__));
+
+/* Represents an entry in the timestamping FIFO */
+struct vsc85xx_ts_fifo {
+	u32 ns;
+	u64 secs:48;
+	u8 sig[16];
+} __attribute__((__packed__));
+
+struct vsc85xx_ptp {
+	struct phy_device *phydev;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info caps;
+	struct sk_buff_head tx_queue;
+	enum hwtstamp_tx_types tx_type;
+	enum hwtstamp_rx_filters rx_filter;
+	u8 configured:1;
+};
+
+#endif /* _MSCC_PHY_PTP_H_ */
-- 
2.26.2

