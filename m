Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33DEB18441A
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 10:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgCMJuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 05:50:18 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:54207 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbgCMJuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 05:50:13 -0400
X-Originating-IP: 90.89.41.158
Received: from localhost (lfbn-tou-1-1473-158.w90-89.abo.wanadoo.fr [90.89.41.158])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 8CCE71C000F;
        Fri, 13 Mar 2020 09:50:03 +0000 (UTC)
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v3 2/3] net: phy: mscc: split the driver into separate files
Date:   Fri, 13 Mar 2020 10:48:01 +0100
Message-Id: <20200313094802.82863-3-antoine.tenart@bootlin.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200313094802.82863-1-antoine.tenart@bootlin.com>
References: <20200313094802.82863-1-antoine.tenart@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch splits the MSCC driver into separate files, per
functionality, to improve readability and maintenance as the codebase
grew a lot. The MACsec code is moved to a dedicated mscc_macsec.c file,
the mscc.c file is renamed to mscc_main.c to keep the driver binary to
be named mscc and common definition are put into a new mscc.h header.

Most of the code was just moved around, except for a few exceptions:
- Header inclusions were reworked to only keep what's needed.
- Three helpers were created in the MACsec code, to avoid #ifdef's in
  the main C file: vsc8584_macsec_init, vsc8584_handle_macsec_interrupt
  and vsc8584_config_macsec_intr.

The patch should not introduce any functional modification.

Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>
---
 drivers/net/phy/mscc/Makefile                |    7 +-
 drivers/net/phy/mscc/mscc.h                  |  392 +++++
 drivers/net/phy/mscc/mscc_macsec.c           | 1051 +++++++++++++
 drivers/net/phy/mscc/mscc_macsec.h           |   58 +
 drivers/net/phy/mscc/{mscc.c => mscc_main.c} | 1469 +-----------------
 5 files changed, 1515 insertions(+), 1462 deletions(-)
 create mode 100644 drivers/net/phy/mscc/mscc.h
 create mode 100644 drivers/net/phy/mscc/mscc_macsec.c
 rename drivers/net/phy/mscc/{mscc.c => mscc_main.c} (60%)

diff --git a/drivers/net/phy/mscc/Makefile b/drivers/net/phy/mscc/Makefile
index e419ed1a3213..10af42cd9839 100644
--- a/drivers/net/phy/mscc/Makefile
+++ b/drivers/net/phy/mscc/Makefile
@@ -2,4 +2,9 @@
 #
 # Makefile for MSCC networking PHY driver
 
-obj-$(CONFIG_MICROSEMI_PHY) += mscc.o
+obj-$(CONFIG_MICROSEMI_PHY) := mscc.o
+mscc-objs := mscc_main.o
+
+ifdef CONFIG_MACSEC
+mscc-objs += mscc_macsec.o
+endif
diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
new file mode 100644
index 000000000000..29ccb2c9c095
--- /dev/null
+++ b/drivers/net/phy/mscc/mscc.h
@@ -0,0 +1,392 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
+/*
+ * Driver for Microsemi VSC85xx PHYs
+ *
+ * Copyright (c) 2016 Microsemi Corporation
+ */
+
+#ifndef _MSCC_PHY_H_
+#define _MSCC_PHY_H_
+
+#if IS_ENABLED(CONFIG_MACSEC)
+#include "mscc_macsec.h"
+#endif
+
+enum rgmii_rx_clock_delay {
+	RGMII_RX_CLK_DELAY_0_2_NS = 0,
+	RGMII_RX_CLK_DELAY_0_8_NS = 1,
+	RGMII_RX_CLK_DELAY_1_1_NS = 2,
+	RGMII_RX_CLK_DELAY_1_7_NS = 3,
+	RGMII_RX_CLK_DELAY_2_0_NS = 4,
+	RGMII_RX_CLK_DELAY_2_3_NS = 5,
+	RGMII_RX_CLK_DELAY_2_6_NS = 6,
+	RGMII_RX_CLK_DELAY_3_4_NS = 7
+};
+
+/* Microsemi VSC85xx PHY registers */
+/* IEEE 802. Std Registers */
+#define MSCC_PHY_BYPASS_CONTROL		  18
+#define DISABLE_HP_AUTO_MDIX_MASK	  0x0080
+#define DISABLE_PAIR_SWAP_CORR_MASK	  0x0020
+#define DISABLE_POLARITY_CORR_MASK	  0x0010
+#define PARALLEL_DET_IGNORE_ADVERTISED    0x0008
+
+#define MSCC_PHY_EXT_CNTL_STATUS          22
+#define SMI_BROADCAST_WR_EN		  0x0001
+
+#define MSCC_PHY_ERR_RX_CNT		  19
+#define MSCC_PHY_ERR_FALSE_CARRIER_CNT	  20
+#define MSCC_PHY_ERR_LINK_DISCONNECT_CNT  21
+#define ERR_CNT_MASK			  GENMASK(7, 0)
+
+#define MSCC_PHY_EXT_PHY_CNTL_1           23
+#define MAC_IF_SELECTION_MASK             0x1800
+#define MAC_IF_SELECTION_GMII             0
+#define MAC_IF_SELECTION_RMII             1
+#define MAC_IF_SELECTION_RGMII            2
+#define MAC_IF_SELECTION_POS              11
+#define VSC8584_MAC_IF_SELECTION_MASK     0x1000
+#define VSC8584_MAC_IF_SELECTION_SGMII    0
+#define VSC8584_MAC_IF_SELECTION_1000BASEX 1
+#define VSC8584_MAC_IF_SELECTION_POS      12
+#define FAR_END_LOOPBACK_MODE_MASK        0x0008
+#define MEDIA_OP_MODE_MASK		  0x0700
+#define MEDIA_OP_MODE_COPPER		  0
+#define MEDIA_OP_MODE_SERDES		  1
+#define MEDIA_OP_MODE_1000BASEX		  2
+#define MEDIA_OP_MODE_100BASEFX		  3
+#define MEDIA_OP_MODE_AMS_COPPER_SERDES	  5
+#define MEDIA_OP_MODE_AMS_COPPER_1000BASEX	6
+#define MEDIA_OP_MODE_AMS_COPPER_100BASEFX	7
+#define MEDIA_OP_MODE_POS		  8
+
+#define MSCC_PHY_EXT_PHY_CNTL_2		  24
+
+#define MII_VSC85XX_INT_MASK		  25
+#define MII_VSC85XX_INT_MASK_MDINT	  BIT(15)
+#define MII_VSC85XX_INT_MASK_LINK_CHG	  BIT(13)
+#define MII_VSC85XX_INT_MASK_WOL	  BIT(6)
+#define MII_VSC85XX_INT_MASK_EXT	  BIT(5)
+#define MII_VSC85XX_INT_STATUS		  26
+
+#define MII_VSC85XX_INT_MASK_MASK	  (MII_VSC85XX_INT_MASK_MDINT    | \
+					   MII_VSC85XX_INT_MASK_LINK_CHG | \
+					   MII_VSC85XX_INT_MASK_EXT)
+
+#define MSCC_PHY_WOL_MAC_CONTROL          27
+#define EDGE_RATE_CNTL_POS                5
+#define EDGE_RATE_CNTL_MASK               0x00E0
+
+#define MSCC_PHY_DEV_AUX_CNTL		  28
+#define HP_AUTO_MDIX_X_OVER_IND_MASK	  0x2000
+
+#define MSCC_PHY_LED_MODE_SEL		  29
+#define LED_MODE_SEL_POS(x)		  ((x) * 4)
+#define LED_MODE_SEL_MASK(x)		  (GENMASK(3, 0) << LED_MODE_SEL_POS(x))
+#define LED_MODE_SEL(x, mode)		  (((mode) << LED_MODE_SEL_POS(x)) & LED_MODE_SEL_MASK(x))
+
+#define MSCC_EXT_PAGE_CSR_CNTL_17	  17
+#define MSCC_EXT_PAGE_CSR_CNTL_18	  18
+
+#define MSCC_EXT_PAGE_CSR_CNTL_19	  19
+#define MSCC_PHY_CSR_CNTL_19_REG_ADDR(x)  (x)
+#define MSCC_PHY_CSR_CNTL_19_TARGET(x)	  ((x) << 12)
+#define MSCC_PHY_CSR_CNTL_19_READ	  BIT(14)
+#define MSCC_PHY_CSR_CNTL_19_CMD	  BIT(15)
+
+#define MSCC_EXT_PAGE_CSR_CNTL_20	  20
+#define MSCC_PHY_CSR_CNTL_20_TARGET(x)	  (x)
+
+#define PHY_MCB_TARGET			  0x07
+#define PHY_MCB_S6G_WRITE		  BIT(31)
+#define PHY_MCB_S6G_READ		  BIT(30)
+
+#define PHY_S6G_PLL5G_CFG0		  0x06
+#define PHY_S6G_LCPLL_CFG		  0x11
+#define PHY_S6G_PLL_CFG			  0x2b
+#define PHY_S6G_COMMON_CFG		  0x2c
+#define PHY_S6G_GPC_CFG			  0x2e
+#define PHY_S6G_MISC_CFG		  0x3b
+#define PHY_MCB_S6G_CFG			  0x3f
+#define PHY_S6G_DFT_CFG2		  0x3e
+#define PHY_S6G_PLL_STATUS		  0x31
+#define PHY_S6G_IB_STATUS0		  0x2f
+
+#define PHY_S6G_SYS_RST_POS		  31
+#define PHY_S6G_ENA_LANE_POS		  18
+#define PHY_S6G_ENA_LOOP_POS		  8
+#define PHY_S6G_QRATE_POS		  6
+#define PHY_S6G_IF_MODE_POS		  4
+#define PHY_S6G_PLL_ENA_OFFS_POS	  21
+#define PHY_S6G_PLL_FSM_CTRL_DATA_POS	  8
+#define PHY_S6G_PLL_FSM_ENA_POS		  7
+
+#define MSCC_EXT_PAGE_ACCESS		  31
+#define MSCC_PHY_PAGE_STANDARD		  0x0000 /* Standard registers */
+#define MSCC_PHY_PAGE_EXTENDED		  0x0001 /* Extended registers */
+#define MSCC_PHY_PAGE_EXTENDED_2	  0x0002 /* Extended reg - page 2 */
+#define MSCC_PHY_PAGE_EXTENDED_3	  0x0003 /* Extended reg - page 3 */
+#define MSCC_PHY_PAGE_EXTENDED_4	  0x0004 /* Extended reg - page 4 */
+#define MSCC_PHY_PAGE_CSR_CNTL		  MSCC_PHY_PAGE_EXTENDED_4
+#define MSCC_PHY_PAGE_MACSEC		  MSCC_PHY_PAGE_EXTENDED_4
+/* Extended reg - GPIO; this is a bank of registers that are shared for all PHYs
+ * in the same package.
+ */
+#define MSCC_PHY_PAGE_EXTENDED_GPIO	  0x0010 /* Extended reg - GPIO */
+#define MSCC_PHY_PAGE_TEST		  0x2a30 /* Test reg */
+#define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
+
+/* Extended Page 1 Registers */
+#define MSCC_PHY_CU_MEDIA_CRC_VALID_CNT	  18
+#define VALID_CRC_CNT_CRC_MASK		  GENMASK(13, 0)
+
+#define MSCC_PHY_EXT_MODE_CNTL		  19
+#define FORCE_MDI_CROSSOVER_MASK	  0x000C
+#define FORCE_MDI_CROSSOVER_MDIX	  0x000C
+#define FORCE_MDI_CROSSOVER_MDI		  0x0008
+
+#define MSCC_PHY_ACTIPHY_CNTL		  20
+#define PHY_ADDR_REVERSED		  0x0200
+#define DOWNSHIFT_CNTL_MASK		  0x001C
+#define DOWNSHIFT_EN			  0x0010
+#define DOWNSHIFT_CNTL_POS		  2
+
+#define MSCC_PHY_EXT_PHY_CNTL_4		  23
+#define PHY_CNTL_4_ADDR_POS		  11
+
+#define MSCC_PHY_VERIPHY_CNTL_2		  25
+
+#define MSCC_PHY_VERIPHY_CNTL_3		  26
+
+/* Extended Page 2 Registers */
+#define MSCC_PHY_CU_PMD_TX_CNTL		  16
+
+#define MSCC_PHY_RGMII_CNTL		  20
+#define RGMII_RX_CLK_DELAY_MASK		  0x0070
+#define RGMII_RX_CLK_DELAY_POS		  4
+
+#define MSCC_PHY_WOL_LOWER_MAC_ADDR	  21
+#define MSCC_PHY_WOL_MID_MAC_ADDR	  22
+#define MSCC_PHY_WOL_UPPER_MAC_ADDR	  23
+#define MSCC_PHY_WOL_LOWER_PASSWD	  24
+#define MSCC_PHY_WOL_MID_PASSWD		  25
+#define MSCC_PHY_WOL_UPPER_PASSWD	  26
+
+#define MSCC_PHY_WOL_MAC_CONTROL	  27
+#define SECURE_ON_ENABLE		  0x8000
+#define SECURE_ON_PASSWD_LEN_4		  0x4000
+
+#define MSCC_PHY_EXTENDED_INT		  28
+#define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
+
+/* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_TX_VALID_CNT	  21
+#define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
+#define MSCC_PHY_SERDES_RX_VALID_CNT	  28
+#define MSCC_PHY_SERDES_RX_CRC_ERR_CNT	  29
+
+/* Extended page GPIO Registers */
+#define MSCC_DW8051_CNTL_STATUS		  0
+#define MICRO_NSOFT_RESET		  0x8000
+#define RUN_FROM_INT_ROM		  0x4000
+#define AUTOINC_ADDR			  0x2000
+#define PATCH_RAM_CLK			  0x1000
+#define MICRO_PATCH_EN			  0x0080
+#define DW8051_CLK_EN			  0x0010
+#define MICRO_CLK_EN			  0x0008
+#define MICRO_CLK_DIVIDE(x)		  ((x) >> 1)
+#define MSCC_DW8051_VLD_MASK		  0xf1ff
+
+/* x Address in range 1-4 */
+#define MSCC_TRAP_ROM_ADDR(x)		  ((x) * 2 + 1)
+#define MSCC_PATCH_RAM_ADDR(x)		  (((x) + 1) * 2)
+#define MSCC_INT_MEM_ADDR		  11
+
+#define MSCC_INT_MEM_CNTL		  12
+#define READ_SFR			  0x6000
+#define READ_PRAM			  0x4000
+#define READ_ROM			  0x2000
+#define READ_RAM			  0x0000
+#define INT_MEM_WRITE_EN		  0x1000
+#define EN_PATCH_RAM_TRAP_ADDR(x)	  (0x0100 << ((x) - 1))
+#define INT_MEM_DATA_M			  0x00ff
+#define INT_MEM_DATA(x)			  (INT_MEM_DATA_M & (x))
+
+#define MSCC_PHY_PROC_CMD		  18
+#define PROC_CMD_NCOMPLETED		  0x8000
+#define PROC_CMD_FAILED			  0x4000
+#define PROC_CMD_SGMII_PORT(x)		  ((x) << 8)
+#define PROC_CMD_FIBER_PORT(x)		  (0x0100 << (x) % 4)
+#define PROC_CMD_QSGMII_PORT		  0x0c00
+#define PROC_CMD_RST_CONF_PORT		  0x0080
+#define PROC_CMD_RECONF_PORT		  0x0000
+#define PROC_CMD_READ_MOD_WRITE_PORT	  0x0040
+#define PROC_CMD_WRITE			  0x0040
+#define PROC_CMD_READ			  0x0000
+#define PROC_CMD_FIBER_DISABLE		  0x0020
+#define PROC_CMD_FIBER_100BASE_FX	  0x0010
+#define PROC_CMD_FIBER_1000BASE_X	  0x0000
+#define PROC_CMD_SGMII_MAC		  0x0030
+#define PROC_CMD_QSGMII_MAC		  0x0020
+#define PROC_CMD_NO_MAC_CONF		  0x0000
+#define PROC_CMD_1588_DEFAULT_INIT	  0x0010
+#define PROC_CMD_NOP			  0x000f
+#define PROC_CMD_PHY_INIT		  0x000a
+#define PROC_CMD_CRC16			  0x0008
+#define PROC_CMD_FIBER_MEDIA_CONF	  0x0001
+#define PROC_CMD_MCB_ACCESS_MAC_CONF	  0x0000
+#define PROC_CMD_NCOMPLETED_TIMEOUT_MS    500
+
+#define MSCC_PHY_MAC_CFG_FASTLINK	  19
+#define MAC_CFG_MASK			  0xc000
+#define MAC_CFG_SGMII			  0x0000
+#define MAC_CFG_QSGMII			  0x4000
+
+/* Test page Registers */
+#define MSCC_PHY_TEST_PAGE_5		  5
+#define MSCC_PHY_TEST_PAGE_8		  8
+#define MSCC_PHY_TEST_PAGE_9		  9
+#define MSCC_PHY_TEST_PAGE_20		  20
+#define MSCC_PHY_TEST_PAGE_24		  24
+
+/* Token ring page Registers */
+#define MSCC_PHY_TR_CNTL		  16
+#define TR_WRITE			  0x8000
+#define TR_ADDR(x)			  (0x7fff & (x))
+#define MSCC_PHY_TR_LSB			  17
+#define MSCC_PHY_TR_MSB			  18
+
+/* Microsemi PHY ID's
+ *   Code assumes lowest nibble is 0
+ */
+#define PHY_ID_VSC8504			  0x000704c0
+#define PHY_ID_VSC8514			  0x00070670
+#define PHY_ID_VSC8530			  0x00070560
+#define PHY_ID_VSC8531			  0x00070570
+#define PHY_ID_VSC8540			  0x00070760
+#define PHY_ID_VSC8541			  0x00070770
+#define PHY_ID_VSC8552			  0x000704e0
+#define PHY_ID_VSC856X			  0x000707e0
+#define PHY_ID_VSC8572			  0x000704d0
+#define PHY_ID_VSC8574			  0x000704a0
+#define PHY_ID_VSC8575			  0x000707d0
+#define PHY_ID_VSC8582			  0x000707b0
+#define PHY_ID_VSC8584			  0x000707c0
+
+#define MSCC_VDDMAC_1500		  1500
+#define MSCC_VDDMAC_1800		  1800
+#define MSCC_VDDMAC_2500		  2500
+#define MSCC_VDDMAC_3300		  3300
+
+#define DOWNSHIFT_COUNT_MAX		  5
+
+#define MAX_LEDS			  4
+
+#define VSC8584_SUPP_LED_MODES (BIT(VSC8531_LINK_ACTIVITY) | \
+				BIT(VSC8531_LINK_1000_ACTIVITY) | \
+				BIT(VSC8531_LINK_100_ACTIVITY) | \
+				BIT(VSC8531_LINK_10_ACTIVITY) | \
+				BIT(VSC8531_LINK_100_1000_ACTIVITY) | \
+				BIT(VSC8531_LINK_10_1000_ACTIVITY) | \
+				BIT(VSC8531_LINK_10_100_ACTIVITY) | \
+				BIT(VSC8584_LINK_100FX_1000X_ACTIVITY) | \
+				BIT(VSC8531_DUPLEX_COLLISION) | \
+				BIT(VSC8531_COLLISION) | \
+				BIT(VSC8531_ACTIVITY) | \
+				BIT(VSC8584_100FX_1000X_ACTIVITY) | \
+				BIT(VSC8531_AUTONEG_FAULT) | \
+				BIT(VSC8531_SERIAL_MODE) | \
+				BIT(VSC8531_FORCE_LED_OFF) | \
+				BIT(VSC8531_FORCE_LED_ON))
+
+#define VSC85XX_SUPP_LED_MODES (BIT(VSC8531_LINK_ACTIVITY) | \
+				BIT(VSC8531_LINK_1000_ACTIVITY) | \
+				BIT(VSC8531_LINK_100_ACTIVITY) | \
+				BIT(VSC8531_LINK_10_ACTIVITY) | \
+				BIT(VSC8531_LINK_100_1000_ACTIVITY) | \
+				BIT(VSC8531_LINK_10_1000_ACTIVITY) | \
+				BIT(VSC8531_LINK_10_100_ACTIVITY) | \
+				BIT(VSC8531_DUPLEX_COLLISION) | \
+				BIT(VSC8531_COLLISION) | \
+				BIT(VSC8531_ACTIVITY) | \
+				BIT(VSC8531_AUTONEG_FAULT) | \
+				BIT(VSC8531_SERIAL_MODE) | \
+				BIT(VSC8531_FORCE_LED_OFF) | \
+				BIT(VSC8531_FORCE_LED_ON))
+
+#define MSCC_VSC8584_REVB_INT8051_FW		"microchip/mscc_vsc8584_revb_int8051_fb48.bin"
+#define MSCC_VSC8584_REVB_INT8051_FW_START_ADDR	0xe800
+#define MSCC_VSC8584_REVB_INT8051_FW_CRC	0xfb48
+
+#define MSCC_VSC8574_REVB_INT8051_FW		"microchip/mscc_vsc8574_revb_int8051_29e8.bin"
+#define MSCC_VSC8574_REVB_INT8051_FW_START_ADDR	0x4000
+#define MSCC_VSC8574_REVB_INT8051_FW_CRC	0x29e8
+
+#define VSC8584_REVB				0x0001
+#define MSCC_DEV_REV_MASK			GENMASK(3, 0)
+
+struct reg_val {
+	u16	reg;
+	u32	val;
+};
+
+struct vsc85xx_hw_stat {
+	const char *string;
+	u8 reg;
+	u16 page;
+	u16 mask;
+};
+
+struct vsc8531_private {
+	int rate_magic;
+	u16 supp_led_modes;
+	u32 leds_mode[MAX_LEDS];
+	u8 nleds;
+	const struct vsc85xx_hw_stat *hw_stats;
+	u64 *stats;
+	int nstats;
+	bool pkg_init;
+	/* For multiple port PHYs; the MDIO address of the base PHY in the
+	 * package.
+	 */
+	unsigned int base_addr;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	/* MACsec fields:
+	 * - One SecY per device (enforced at the s/w implementation level)
+	 * - macsec_flows: list of h/w flows
+	 * - ingr_flows: bitmap of ingress flows
+	 * - egr_flows: bitmap of egress flows
+	 */
+	struct macsec_secy *secy;
+	struct list_head macsec_flows;
+	unsigned long ingr_flows;
+	unsigned long egr_flows;
+#endif
+};
+
+#ifdef CONFIG_OF_MDIO
+struct vsc8531_edge_rate_table {
+	u32 vddmac;
+	u32 slowdown[8];
+};
+#endif /* CONFIG_OF_MDIO */
+
+#if IS_ENABLED(CONFIG_MACSEC)
+int vsc8584_macsec_init(struct phy_device *phydev);
+void vsc8584_handle_macsec_interrupt(struct phy_device *phydev);
+void vsc8584_config_macsec_intr(struct phy_device *phydev);
+#else
+static inline int vsc8584_macsec_init(struct phy_device *phydev)
+{
+	return 0;
+}
+static inline void vsc8584_handle_macsec_interrupt(struct phy_device *phydev)
+{
+}
+static inline void vsc8584_config_macsec_intr(struct phy_device *phydev)
+{
+}
+#endif
+
+#endif /* _MSCC_PHY_H_ */
diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
new file mode 100644
index 000000000000..e99e2cd72a0c
--- /dev/null
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -0,0 +1,1051 @@
+// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/*
+ * Driver for Microsemi VSC85xx PHYs
+ *
+ * Author: Nagaraju Lakkaraju
+ * License: Dual MIT/GPL
+ * Copyright (c) 2016 Microsemi Corporation
+ */
+
+#include <linux/phy.h>
+#include <dt-bindings/net/mscc-phy-vsc8531.h>
+
+#include <crypto/skcipher.h>
+
+#include <net/macsec.h>
+
+#include "mscc.h"
+#include "mscc_mac.h"
+#include "mscc_macsec.h"
+#include "mscc_fc_buffer.h"
+
+static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
+				   enum macsec_bank bank, u32 reg)
+{
+	u32 val, val_l = 0, val_h = 0;
+	unsigned long deadline;
+	int rc;
+
+	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
+	if (rc < 0)
+		goto failed;
+
+	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_20,
+		    MSCC_PHY_MACSEC_20_TARGET(bank >> 2));
+
+	if (bank >> 2 == 0x1)
+		/* non-MACsec access */
+		bank &= 0x3;
+	else
+		bank = 0;
+
+	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_19,
+		    MSCC_PHY_MACSEC_19_CMD | MSCC_PHY_MACSEC_19_READ |
+		    MSCC_PHY_MACSEC_19_REG_ADDR(reg) |
+		    MSCC_PHY_MACSEC_19_TARGET(bank));
+
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
+	} while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSEC_19_CMD));
+
+	val_l = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_17);
+	val_h = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_18);
+
+failed:
+	phy_restore_page(phydev, rc, rc);
+
+	return (val_h << 16) | val_l;
+}
+
+static void vsc8584_macsec_phy_write(struct phy_device *phydev,
+				     enum macsec_bank bank, u32 reg, u32 val)
+{
+	unsigned long deadline;
+	int rc;
+
+	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
+	if (rc < 0)
+		goto failed;
+
+	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_20,
+		    MSCC_PHY_MACSEC_20_TARGET(bank >> 2));
+
+	if ((bank >> 2 == 0x1) || (bank >> 2 == 0x3))
+		bank &= 0x3;
+	else
+		/* MACsec access */
+		bank = 0;
+
+	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_17, (u16)val);
+	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_18, (u16)(val >> 16));
+
+	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_19,
+		    MSCC_PHY_MACSEC_19_CMD | MSCC_PHY_MACSEC_19_REG_ADDR(reg) |
+		    MSCC_PHY_MACSEC_19_TARGET(bank));
+
+	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
+	do {
+		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
+	} while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSEC_19_CMD));
+
+failed:
+	phy_restore_page(phydev, rc, rc);
+}
+
+static void vsc8584_macsec_classification(struct phy_device *phydev,
+					  enum macsec_bank bank)
+{
+	/* enable VLAN tag parsing */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_CP_TAG,
+				 MSCC_MS_SAM_CP_TAG_PARSE_STAG |
+				 MSCC_MS_SAM_CP_TAG_PARSE_QTAG |
+				 MSCC_MS_SAM_CP_TAG_PARSE_QINQ);
+}
+
+static void vsc8584_macsec_flow_default_action(struct phy_device *phydev,
+					       enum macsec_bank bank,
+					       bool block)
+{
+	u32 port = (bank == MACSEC_INGR) ?
+		    MSCC_MS_PORT_UNCONTROLLED : MSCC_MS_PORT_COMMON;
+	u32 action = MSCC_MS_FLOW_BYPASS;
+
+	if (block)
+		action = MSCC_MS_FLOW_DROP;
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_NM_FLOW_NCP,
+				 /* MACsec untagged */
+				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_DEST_PORT(port) |
+				 /* MACsec tagged */
+				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_DEST_PORT(port) |
+				 /* Bad tag */
+				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_DEST_PORT(port) |
+				 /* Kay tag */
+				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_DEST_PORT(port));
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_NM_FLOW_CP,
+				 /* MACsec untagged */
+				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_CP_UNTAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_CP_UNTAGGED_DEST_PORT(port) |
+				 /* MACsec tagged */
+				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_CP_TAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_CP_TAGGED_DEST_PORT(port) |
+				 /* Bad tag */
+				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_CP_BADTAG_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_CP_BADTAG_DEST_PORT(port) |
+				 /* Kay tag */
+				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_FLOW_TYPE(action) |
+				 MSCC_MS_SAM_NM_FLOW_CP_KAY_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+				 MSCC_MS_SAM_NM_FLOW_CP_KAY_DEST_PORT(port));
+}
+
+static void vsc8584_macsec_integrity_checks(struct phy_device *phydev,
+					    enum macsec_bank bank)
+{
+	u32 val;
+
+	if (bank != MACSEC_INGR)
+		return;
+
+	/* Set default rules to pass unmatched frames */
+	val = vsc8584_macsec_phy_read(phydev, bank,
+				      MSCC_MS_PARAMS2_IG_CC_CONTROL);
+	val |= MSCC_MS_PARAMS2_IG_CC_CONTROL_NON_MATCH_CTRL_ACT |
+	       MSCC_MS_PARAMS2_IG_CC_CONTROL_NON_MATCH_ACT;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_PARAMS2_IG_CC_CONTROL,
+				 val);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_PARAMS2_IG_CP_TAG,
+				 MSCC_MS_PARAMS2_IG_CP_TAG_PARSE_STAG |
+				 MSCC_MS_PARAMS2_IG_CP_TAG_PARSE_QTAG |
+				 MSCC_MS_PARAMS2_IG_CP_TAG_PARSE_QINQ);
+}
+
+static void vsc8584_macsec_block_init(struct phy_device *phydev,
+				      enum macsec_bank bank)
+{
+	u32 val;
+	int i;
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_ENA_CFG,
+				 MSCC_MS_ENA_CFG_SW_RST |
+				 MSCC_MS_ENA_CFG_MACSEC_BYPASS_ENA);
+
+	/* Set the MACsec block out of s/w reset and enable clocks */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_ENA_CFG,
+				 MSCC_MS_ENA_CFG_CLK_ENA);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_STATUS_CONTEXT_CTRL,
+				 bank == MACSEC_INGR ? 0xe5880214 : 0xe5880218);
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_MISC_CONTROL,
+				 MSCC_MS_MISC_CONTROL_MC_LATENCY_FIX(bank == MACSEC_INGR ? 57 : 40) |
+				 MSCC_MS_MISC_CONTROL_XFORM_REC_SIZE(bank == MACSEC_INGR ? 1 : 2));
+
+	/* Clear the counters */
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_COUNT_CONTROL);
+	val |= MSCC_MS_COUNT_CONTROL_AUTO_CNTR_RESET;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_COUNT_CONTROL, val);
+
+	/* Enable octet increment mode */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_PP_CTRL,
+				 MSCC_MS_PP_CTRL_MACSEC_OCTET_INCR_MODE);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_BLOCK_CTX_UPDATE, 0x3);
+
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_COUNT_CONTROL);
+	val |= MSCC_MS_COUNT_CONTROL_RESET_ALL;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_COUNT_CONTROL, val);
+
+	/* Set the MTU */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_NON_VLAN_MTU_CHECK,
+				 MSCC_MS_NON_VLAN_MTU_CHECK_NV_MTU_COMPARE(32761) |
+				 MSCC_MS_NON_VLAN_MTU_CHECK_NV_MTU_COMP_DROP);
+
+	for (i = 0; i < 8; i++)
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_VLAN_MTU_CHECK(i),
+					 MSCC_MS_VLAN_MTU_CHECK_MTU_COMPARE(32761) |
+					 MSCC_MS_VLAN_MTU_CHECK_MTU_COMP_DROP);
+
+	if (bank == MACSEC_EGR) {
+		val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_INTR_CTRL_STATUS);
+		val &= ~MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE_M;
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_INTR_CTRL_STATUS, val);
+
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_FC_CFG,
+					 MSCC_MS_FC_CFG_FCBUF_ENA |
+					 MSCC_MS_FC_CFG_LOW_THRESH(0x1) |
+					 MSCC_MS_FC_CFG_HIGH_THRESH(0x4) |
+					 MSCC_MS_FC_CFG_LOW_BYTES_VAL(0x4) |
+					 MSCC_MS_FC_CFG_HIGH_BYTES_VAL(0x6));
+	}
+
+	vsc8584_macsec_classification(phydev, bank);
+	vsc8584_macsec_flow_default_action(phydev, bank, false);
+	vsc8584_macsec_integrity_checks(phydev, bank);
+
+	/* Enable the MACsec block */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_ENA_CFG,
+				 MSCC_MS_ENA_CFG_CLK_ENA |
+				 MSCC_MS_ENA_CFG_MACSEC_ENA |
+				 MSCC_MS_ENA_CFG_MACSEC_SPEED_MODE(0x5));
+}
+
+static void vsc8584_macsec_mac_init(struct phy_device *phydev,
+				    enum macsec_bank bank)
+{
+	u32 val;
+	int i;
+
+	/* Clear host & line stats */
+	for (i = 0; i < 36; i++)
+		vsc8584_macsec_phy_write(phydev, bank, 0x1c + i, 0);
+
+	val = vsc8584_macsec_phy_read(phydev, bank,
+				      MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL);
+	val &= ~MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_PAUSE_MODE_M;
+	val |= MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_PAUSE_MODE(2) |
+	       MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_PAUSE_VALUE(0xffff);
+	vsc8584_macsec_phy_write(phydev, bank,
+				 MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL, val);
+
+	val = vsc8584_macsec_phy_read(phydev, bank,
+				      MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_2);
+	val |= 0xffff;
+	vsc8584_macsec_phy_write(phydev, bank,
+				 MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_2, val);
+
+	val = vsc8584_macsec_phy_read(phydev, bank,
+				      MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL);
+	if (bank == HOST_MAC)
+		val |= MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_TIMER_ENA |
+		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_FRAME_DROP_ENA;
+	else
+		val |= MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_REACT_ENA |
+		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_FRAME_DROP_ENA |
+		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_MODE |
+		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_EARLY_PAUSE_DETECT_ENA;
+	vsc8584_macsec_phy_write(phydev, bank,
+				 MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL, val);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_PKTINF_CFG,
+				 MSCC_MAC_CFG_PKTINF_CFG_STRIP_FCS_ENA |
+				 MSCC_MAC_CFG_PKTINF_CFG_INSERT_FCS_ENA |
+				 MSCC_MAC_CFG_PKTINF_CFG_LPI_RELAY_ENA |
+				 MSCC_MAC_CFG_PKTINF_CFG_STRIP_PREAMBLE_ENA |
+				 MSCC_MAC_CFG_PKTINF_CFG_INSERT_PREAMBLE_ENA |
+				 (bank == HOST_MAC ?
+				  MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING : 0));
+
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_MODE_CFG);
+	val &= ~MSCC_MAC_CFG_MODE_CFG_DISABLE_DIC;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_MODE_CFG, val);
+
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_MAXLEN_CFG);
+	val &= ~MSCC_MAC_CFG_MAXLEN_CFG_MAX_LEN_M;
+	val |= MSCC_MAC_CFG_MAXLEN_CFG_MAX_LEN(10240);
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_MAXLEN_CFG, val);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_ADV_CHK_CFG,
+				 MSCC_MAC_CFG_ADV_CHK_CFG_SFD_CHK_ENA |
+				 MSCC_MAC_CFG_ADV_CHK_CFG_PRM_CHK_ENA |
+				 MSCC_MAC_CFG_ADV_CHK_CFG_OOR_ERR_ENA |
+				 MSCC_MAC_CFG_ADV_CHK_CFG_INR_ERR_ENA);
+
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_LFS_CFG);
+	val &= ~MSCC_MAC_CFG_LFS_CFG_LFS_MODE_ENA;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_LFS_CFG, val);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_ENA_CFG,
+				 MSCC_MAC_CFG_ENA_CFG_RX_CLK_ENA |
+				 MSCC_MAC_CFG_ENA_CFG_TX_CLK_ENA |
+				 MSCC_MAC_CFG_ENA_CFG_RX_ENA |
+				 MSCC_MAC_CFG_ENA_CFG_TX_ENA);
+}
+
+/* Must be called with mdio_lock taken */
+static int __vsc8584_macsec_init(struct phy_device *phydev)
+{
+	u32 val;
+
+	vsc8584_macsec_block_init(phydev, MACSEC_INGR);
+	vsc8584_macsec_block_init(phydev, MACSEC_EGR);
+	vsc8584_macsec_mac_init(phydev, HOST_MAC);
+	vsc8584_macsec_mac_init(phydev, LINE_MAC);
+
+	vsc8584_macsec_phy_write(phydev, FC_BUFFER,
+				 MSCC_FCBUF_FC_READ_THRESH_CFG,
+				 MSCC_FCBUF_FC_READ_THRESH_CFG_TX_THRESH(4) |
+				 MSCC_FCBUF_FC_READ_THRESH_CFG_RX_THRESH(5));
+
+	val = vsc8584_macsec_phy_read(phydev, FC_BUFFER, MSCC_FCBUF_MODE_CFG);
+	val |= MSCC_FCBUF_MODE_CFG_PAUSE_GEN_ENA |
+	       MSCC_FCBUF_MODE_CFG_RX_PPM_RATE_ADAPT_ENA |
+	       MSCC_FCBUF_MODE_CFG_TX_PPM_RATE_ADAPT_ENA;
+	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_MODE_CFG, val);
+
+	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_PPM_RATE_ADAPT_THRESH_CFG,
+				 MSCC_FCBUF_PPM_RATE_ADAPT_THRESH_CFG_TX_THRESH(8) |
+				 MSCC_FCBUF_PPM_RATE_ADAPT_THRESH_CFG_TX_OFFSET(9));
+
+	val = vsc8584_macsec_phy_read(phydev, FC_BUFFER,
+				      MSCC_FCBUF_TX_DATA_QUEUE_CFG);
+	val &= ~(MSCC_FCBUF_TX_DATA_QUEUE_CFG_START_M |
+		 MSCC_FCBUF_TX_DATA_QUEUE_CFG_END_M);
+	val |= MSCC_FCBUF_TX_DATA_QUEUE_CFG_START(0) |
+		MSCC_FCBUF_TX_DATA_QUEUE_CFG_END(5119);
+	vsc8584_macsec_phy_write(phydev, FC_BUFFER,
+				 MSCC_FCBUF_TX_DATA_QUEUE_CFG, val);
+
+	val = vsc8584_macsec_phy_read(phydev, FC_BUFFER, MSCC_FCBUF_ENA_CFG);
+	val |= MSCC_FCBUF_ENA_CFG_TX_ENA | MSCC_FCBUF_ENA_CFG_RX_ENA;
+	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_ENA_CFG, val);
+
+	val = vsc8584_macsec_phy_read(phydev, IP_1588,
+				      MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL);
+	val &= ~MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M;
+	val |= MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(4);
+	vsc8584_macsec_phy_write(phydev, IP_1588,
+				 MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL, val);
+
+	return 0;
+}
+
+static void vsc8584_macsec_flow(struct phy_device *phydev,
+				struct macsec_flow *flow)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	enum macsec_bank bank = flow->bank;
+	u32 val, match = 0, mask = 0, action = 0, idx = flow->index;
+
+	if (flow->match.tagged)
+		match |= MSCC_MS_SAM_MISC_MATCH_TAGGED;
+	if (flow->match.untagged)
+		match |= MSCC_MS_SAM_MISC_MATCH_UNTAGGED;
+
+	if (bank == MACSEC_INGR && flow->assoc_num >= 0) {
+		match |= MSCC_MS_SAM_MISC_MATCH_AN(flow->assoc_num);
+		mask |= MSCC_MS_SAM_MASK_AN_MASK(0x3);
+	}
+
+	if (bank == MACSEC_INGR && flow->match.sci && flow->rx_sa->sc->sci) {
+		match |= MSCC_MS_SAM_MISC_MATCH_TCI(BIT(3));
+		mask |= MSCC_MS_SAM_MASK_TCI_MASK(BIT(3)) |
+			MSCC_MS_SAM_MASK_SCI_MASK;
+
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_LO(idx),
+					 lower_32_bits(flow->rx_sa->sc->sci));
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_HI(idx),
+					 upper_32_bits(flow->rx_sa->sc->sci));
+	}
+
+	if (flow->match.etype) {
+		mask |= MSCC_MS_SAM_MASK_MAC_ETYPE_MASK;
+
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MAC_SA_MATCH_HI(idx),
+					 MSCC_MS_SAM_MAC_SA_MATCH_HI_ETYPE(htons(flow->etype)));
+	}
+
+	match |= MSCC_MS_SAM_MISC_MATCH_PRIORITY(flow->priority);
+
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MISC_MATCH(idx), match);
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MASK(idx), mask);
+
+	/* Action for matching packets */
+	if (flow->action.drop)
+		action = MSCC_MS_FLOW_DROP;
+	else if (flow->action.bypass || flow->port == MSCC_MS_PORT_UNCONTROLLED)
+		action = MSCC_MS_FLOW_BYPASS;
+	else
+		action = (bank == MACSEC_INGR) ?
+			 MSCC_MS_FLOW_INGRESS : MSCC_MS_FLOW_EGRESS;
+
+	val = MSCC_MS_SAM_FLOW_CTRL_FLOW_TYPE(action) |
+	      MSCC_MS_SAM_FLOW_CTRL_DROP_ACTION(MSCC_MS_ACTION_DROP) |
+	      MSCC_MS_SAM_FLOW_CTRL_DEST_PORT(flow->port);
+
+	if (action == MSCC_MS_FLOW_BYPASS)
+		goto write_ctrl;
+
+	if (bank == MACSEC_INGR) {
+		if (priv->secy->replay_protect)
+			val |= MSCC_MS_SAM_FLOW_CTRL_REPLAY_PROTECT;
+		if (priv->secy->validate_frames == MACSEC_VALIDATE_STRICT)
+			val |= MSCC_MS_SAM_FLOW_CTRL_VALIDATE_FRAMES(MSCC_MS_VALIDATE_STRICT);
+		else if (priv->secy->validate_frames == MACSEC_VALIDATE_CHECK)
+			val |= MSCC_MS_SAM_FLOW_CTRL_VALIDATE_FRAMES(MSCC_MS_VALIDATE_CHECK);
+	} else if (bank == MACSEC_EGR) {
+		if (priv->secy->protect_frames)
+			val |= MSCC_MS_SAM_FLOW_CTRL_PROTECT_FRAME;
+		if (priv->secy->tx_sc.encrypt)
+			val |= MSCC_MS_SAM_FLOW_CTRL_CONF_PROTECT;
+		if (priv->secy->tx_sc.send_sci)
+			val |= MSCC_MS_SAM_FLOW_CTRL_INCLUDE_SCI;
+	}
+
+write_ctrl:
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
+}
+
+static struct macsec_flow *vsc8584_macsec_find_flow(struct macsec_context *ctx,
+						    enum macsec_bank bank)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *pos, *tmp;
+
+	list_for_each_entry_safe(pos, tmp, &priv->macsec_flows, list)
+		if (pos->assoc_num == ctx->sa.assoc_num && pos->bank == bank)
+			return pos;
+
+	return ERR_PTR(-ENOENT);
+}
+
+static void vsc8584_macsec_flow_enable(struct phy_device *phydev,
+				       struct macsec_flow *flow)
+{
+	enum macsec_bank bank = flow->bank;
+	u32 val, idx = flow->index;
+
+	if ((flow->bank == MACSEC_INGR && flow->rx_sa && !flow->rx_sa->active) ||
+	    (flow->bank == MACSEC_EGR && flow->tx_sa && !flow->tx_sa->active))
+		return;
+
+	/* Enable */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_ENTRY_SET1, BIT(idx));
+
+	/* Set in-use */
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx));
+	val |= MSCC_MS_SAM_FLOW_CTRL_SA_IN_USE;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
+}
+
+static void vsc8584_macsec_flow_disable(struct phy_device *phydev,
+					struct macsec_flow *flow)
+{
+	enum macsec_bank bank = flow->bank;
+	u32 val, idx = flow->index;
+
+	/* Disable */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_ENTRY_CLEAR1, BIT(idx));
+
+	/* Clear in-use */
+	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx));
+	val &= ~MSCC_MS_SAM_FLOW_CTRL_SA_IN_USE;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
+}
+
+static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
+{
+	if (flow->bank == MACSEC_INGR)
+		return flow->index + MSCC_MS_MAX_FLOWS;
+
+	return flow->index;
+}
+
+/* Derive the AES key to get a key for the hash autentication */
+static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
+				     u16 key_len, u8 hkey[16])
+{
+	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
+	struct skcipher_request *req = NULL;
+	struct scatterlist src, dst;
+	DECLARE_CRYPTO_WAIT(wait);
+	u32 input[4] = {0};
+	int ret;
+
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	req = skcipher_request_alloc(tfm, GFP_KERNEL);
+	if (!req) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
+				      CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done,
+				      &wait);
+	ret = crypto_skcipher_setkey(tfm, key, key_len);
+	if (ret < 0)
+		goto out;
+
+	sg_init_one(&src, input, 16);
+	sg_init_one(&dst, hkey, 16);
+	skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
+
+	ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
+
+out:
+	skcipher_request_free(req);
+	crypto_free_skcipher(tfm);
+	return ret;
+}
+
+static int vsc8584_macsec_transformation(struct phy_device *phydev,
+					 struct macsec_flow *flow)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	enum macsec_bank bank = flow->bank;
+	int i, ret, index = flow->index;
+	u32 rec = 0, control = 0;
+	u8 hkey[16];
+	sci_t sci;
+
+	ret = vsc8584_macsec_derive_key(flow->key, priv->secy->key_len, hkey);
+	if (ret)
+		return ret;
+
+	switch (priv->secy->key_len) {
+	case 16:
+		control |= CONTROL_CRYPTO_ALG(CTRYPTO_ALG_AES_CTR_128);
+		break;
+	case 32:
+		control |= CONTROL_CRYPTO_ALG(CTRYPTO_ALG_AES_CTR_256);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	control |= (bank == MACSEC_EGR) ?
+		   (CONTROL_TYPE_EGRESS | CONTROL_AN(priv->secy->tx_sc.encoding_sa)) :
+		   (CONTROL_TYPE_INGRESS | CONTROL_SEQ_MASK);
+
+	control |= CONTROL_UPDATE_SEQ | CONTROL_ENCRYPT_AUTH | CONTROL_KEY_IN_CTX |
+		   CONTROL_IV0 | CONTROL_IV1 | CONTROL_IV_IN_SEQ |
+		   CONTROL_DIGEST_TYPE(0x2) | CONTROL_SEQ_TYPE(0x1) |
+		   CONTROL_AUTH_ALG(AUTH_ALG_AES_GHAS) | CONTROL_CONTEXT_ID;
+
+	/* Set the control word */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 control);
+
+	/* Set the context ID. Must be unique. */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 vsc8584_macsec_flow_context_id(flow));
+
+	/* Set the encryption/decryption key */
+	for (i = 0; i < priv->secy->key_len / sizeof(u32); i++)
+		vsc8584_macsec_phy_write(phydev, bank,
+					 MSCC_MS_XFORM_REC(index, rec++),
+					 ((u32 *)flow->key)[i]);
+
+	/* Set the authentication key */
+	for (i = 0; i < 4; i++)
+		vsc8584_macsec_phy_write(phydev, bank,
+					 MSCC_MS_XFORM_REC(index, rec++),
+					 ((u32 *)hkey)[i]);
+
+	/* Initial sequence number */
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 bank == MACSEC_INGR ?
+				 flow->rx_sa->next_pn : flow->tx_sa->next_pn);
+
+	if (bank == MACSEC_INGR)
+		/* Set the mask (replay window size) */
+		vsc8584_macsec_phy_write(phydev, bank,
+					 MSCC_MS_XFORM_REC(index, rec++),
+					 priv->secy->replay_window);
+
+	/* Set the input vectors */
+	sci = bank == MACSEC_INGR ? flow->rx_sa->sc->sci : priv->secy->sci;
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 lower_32_bits(sci));
+	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+				 upper_32_bits(sci));
+
+	while (rec < 20)
+		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
+					 0);
+
+	flow->has_transformation = true;
+	return 0;
+}
+
+static struct macsec_flow *vsc8584_macsec_alloc_flow(struct vsc8531_private *priv,
+						     enum macsec_bank bank)
+{
+	unsigned long *bitmap = bank == MACSEC_INGR ?
+				&priv->ingr_flows : &priv->egr_flows;
+	struct macsec_flow *flow;
+	int index;
+
+	index = find_first_zero_bit(bitmap, MSCC_MS_MAX_FLOWS);
+
+	if (index == MSCC_MS_MAX_FLOWS)
+		return ERR_PTR(-ENOMEM);
+
+	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
+	if (!flow)
+		return ERR_PTR(-ENOMEM);
+
+	set_bit(index, bitmap);
+	flow->index = index;
+	flow->bank = bank;
+	flow->priority = 8;
+	flow->assoc_num = -1;
+
+	list_add_tail(&flow->list, &priv->macsec_flows);
+	return flow;
+}
+
+static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
+				     struct macsec_flow *flow)
+{
+	unsigned long *bitmap = flow->bank == MACSEC_INGR ?
+				&priv->ingr_flows : &priv->egr_flows;
+
+	list_del(&flow->list);
+	clear_bit(flow->index, bitmap);
+	kfree(flow);
+}
+
+static int vsc8584_macsec_add_flow(struct phy_device *phydev,
+				   struct macsec_flow *flow, bool update)
+{
+	int ret;
+
+	flow->port = MSCC_MS_PORT_CONTROLLED;
+	vsc8584_macsec_flow(phydev, flow);
+
+	if (update)
+		return 0;
+
+	ret = vsc8584_macsec_transformation(phydev, flow);
+	if (ret) {
+		vsc8584_macsec_free_flow(phydev->priv, flow);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int vsc8584_macsec_default_flows(struct phy_device *phydev)
+{
+	struct macsec_flow *flow;
+
+	/* Add a rule to let the MKA traffic go through, ingress */
+	flow = vsc8584_macsec_alloc_flow(phydev->priv, MACSEC_INGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	flow->priority = 15;
+	flow->port = MSCC_MS_PORT_UNCONTROLLED;
+	flow->match.tagged = 1;
+	flow->match.untagged = 1;
+	flow->match.etype = 1;
+	flow->etype = ETH_P_PAE;
+	flow->action.bypass = 1;
+
+	vsc8584_macsec_flow(phydev, flow);
+	vsc8584_macsec_flow_enable(phydev, flow);
+
+	/* Add a rule to let the MKA traffic go through, egress */
+	flow = vsc8584_macsec_alloc_flow(phydev->priv, MACSEC_EGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	flow->priority = 15;
+	flow->port = MSCC_MS_PORT_COMMON;
+	flow->match.untagged = 1;
+	flow->match.etype = 1;
+	flow->etype = ETH_P_PAE;
+	flow->action.bypass = 1;
+
+	vsc8584_macsec_flow(phydev, flow);
+	vsc8584_macsec_flow_enable(phydev, flow);
+
+	return 0;
+}
+
+static void vsc8584_macsec_del_flow(struct phy_device *phydev,
+				    struct macsec_flow *flow)
+{
+	vsc8584_macsec_flow_disable(phydev, flow);
+	vsc8584_macsec_free_flow(phydev->priv, flow);
+}
+
+static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
+				     struct macsec_flow *flow, bool update)
+{
+	struct phy_device *phydev = ctx->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+
+	if (!flow) {
+		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_INGR);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
+	}
+
+	flow->assoc_num = ctx->sa.assoc_num;
+	flow->rx_sa = ctx->sa.rx_sa;
+
+	/* Always match tagged packets on ingress */
+	flow->match.tagged = 1;
+	flow->match.sci = 1;
+
+	if (priv->secy->validate_frames != MACSEC_VALIDATE_DISABLED)
+		flow->match.untagged = 1;
+
+	return vsc8584_macsec_add_flow(phydev, flow, update);
+}
+
+static int __vsc8584_macsec_add_txsa(struct macsec_context *ctx,
+				     struct macsec_flow *flow, bool update)
+{
+	struct phy_device *phydev = ctx->phydev;
+	struct vsc8531_private *priv = phydev->priv;
+
+	if (!flow) {
+		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_EGR);
+		if (IS_ERR(flow))
+			return PTR_ERR(flow);
+
+		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
+	}
+
+	flow->assoc_num = ctx->sa.assoc_num;
+	flow->tx_sa = ctx->sa.tx_sa;
+
+	/* Always match untagged packets on egress */
+	flow->match.untagged = 1;
+
+	return vsc8584_macsec_add_flow(phydev, flow, update);
+}
+
+static int vsc8584_macsec_dev_open(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
+		vsc8584_macsec_flow_enable(ctx->phydev, flow);
+
+	return 0;
+}
+
+static int vsc8584_macsec_dev_stop(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
+		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+
+	return 0;
+}
+
+static int vsc8584_macsec_add_secy(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_secy *secy = ctx->secy;
+
+	if (ctx->prepare) {
+		if (priv->secy)
+			return -EEXIST;
+
+		return 0;
+	}
+
+	priv->secy = secy;
+
+	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_EGR,
+					   secy->validate_frames != MACSEC_VALIDATE_DISABLED);
+	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_INGR,
+					   secy->validate_frames != MACSEC_VALIDATE_DISABLED);
+
+	return vsc8584_macsec_default_flows(ctx->phydev);
+}
+
+static int vsc8584_macsec_del_secy(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
+		vsc8584_macsec_del_flow(ctx->phydev, flow);
+
+	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_EGR, false);
+	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_INGR, false);
+
+	priv->secy = NULL;
+	return 0;
+}
+
+static int vsc8584_macsec_upd_secy(struct macsec_context *ctx)
+{
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	vsc8584_macsec_del_secy(ctx);
+	return vsc8584_macsec_add_secy(ctx);
+}
+
+static int vsc8584_macsec_add_rxsc(struct macsec_context *ctx)
+{
+	/* Nothing to do */
+	return 0;
+}
+
+static int vsc8584_macsec_upd_rxsc(struct macsec_context *ctx)
+{
+	return -EOPNOTSUPP;
+}
+
+static int vsc8584_macsec_del_rxsc(struct macsec_context *ctx)
+{
+	struct vsc8531_private *priv = ctx->phydev->priv;
+	struct macsec_flow *flow, *tmp;
+
+	/* No operation to perform before the commit step */
+	if (ctx->prepare)
+		return 0;
+
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
+		if (flow->bank == MACSEC_INGR && flow->rx_sa &&
+		    flow->rx_sa->sc->sci == ctx->rx_sc->sci)
+			vsc8584_macsec_del_flow(ctx->phydev, flow);
+	}
+
+	return 0;
+}
+
+static int vsc8584_macsec_add_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow = NULL;
+
+	if (ctx->prepare)
+		return __vsc8584_macsec_add_rxsa(ctx, flow, false);
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_upd_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	if (ctx->prepare) {
+		/* Make sure the flow is disabled before updating it */
+		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+
+		return __vsc8584_macsec_add_rxsa(ctx, flow, true);
+	}
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_del_rxsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
+
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+	if (ctx->prepare)
+		return 0;
+
+	vsc8584_macsec_del_flow(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_add_txsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow = NULL;
+
+	if (ctx->prepare)
+		return __vsc8584_macsec_add_txsa(ctx, flow, false);
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_upd_txsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+
+	if (ctx->prepare) {
+		/* Make sure the flow is disabled before updating it */
+		vsc8584_macsec_flow_disable(ctx->phydev, flow);
+
+		return __vsc8584_macsec_add_txsa(ctx, flow, true);
+	}
+
+	vsc8584_macsec_flow_enable(ctx->phydev, flow);
+	return 0;
+}
+
+static int vsc8584_macsec_del_txsa(struct macsec_context *ctx)
+{
+	struct macsec_flow *flow;
+
+	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
+
+	if (IS_ERR(flow))
+		return PTR_ERR(flow);
+	if (ctx->prepare)
+		return 0;
+
+	vsc8584_macsec_del_flow(ctx->phydev, flow);
+	return 0;
+}
+
+static struct macsec_ops vsc8584_macsec_ops = {
+	.mdo_dev_open = vsc8584_macsec_dev_open,
+	.mdo_dev_stop = vsc8584_macsec_dev_stop,
+	.mdo_add_secy = vsc8584_macsec_add_secy,
+	.mdo_upd_secy = vsc8584_macsec_upd_secy,
+	.mdo_del_secy = vsc8584_macsec_del_secy,
+	.mdo_add_rxsc = vsc8584_macsec_add_rxsc,
+	.mdo_upd_rxsc = vsc8584_macsec_upd_rxsc,
+	.mdo_del_rxsc = vsc8584_macsec_del_rxsc,
+	.mdo_add_rxsa = vsc8584_macsec_add_rxsa,
+	.mdo_upd_rxsa = vsc8584_macsec_upd_rxsa,
+	.mdo_del_rxsa = vsc8584_macsec_del_rxsa,
+	.mdo_add_txsa = vsc8584_macsec_add_txsa,
+	.mdo_upd_txsa = vsc8584_macsec_upd_txsa,
+	.mdo_del_txsa = vsc8584_macsec_del_txsa,
+};
+
+int vsc8584_macsec_init(struct phy_device *phydev)
+{
+	struct vsc8531_private *vsc8531 = phydev->priv;
+
+	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
+	case PHY_ID_VSC856X:
+	case PHY_ID_VSC8575:
+	case PHY_ID_VSC8582:
+	case PHY_ID_VSC8584:
+		INIT_LIST_HEAD(&vsc8531->macsec_flows);
+		vsc8531->secy = NULL;
+
+		phydev->macsec_ops = &vsc8584_macsec_ops;
+
+		return __vsc8584_macsec_init(phydev);
+	}
+
+	return 0;
+}
+
+void vsc8584_handle_macsec_interrupt(struct phy_device *phydev)
+{
+	struct vsc8531_private *priv = phydev->priv;
+	struct macsec_flow *flow, *tmp;
+	u32 cause, rec;
+
+	/* Check MACsec PN rollover */
+	cause = vsc8584_macsec_phy_read(phydev, MACSEC_EGR,
+					MSCC_MS_INTR_CTRL_STATUS);
+	cause &= MSCC_MS_INTR_CTRL_STATUS_INTR_CLR_STATUS_M;
+	if (!(cause & MACSEC_INTR_CTRL_STATUS_ROLLOVER))
+		return;
+
+	rec = 6 + priv->secy->key_len / sizeof(u32);
+	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
+		u32 val;
+
+		if (flow->bank != MACSEC_EGR || !flow->has_transformation)
+			continue;
+
+		val = vsc8584_macsec_phy_read(phydev, MACSEC_EGR,
+					      MSCC_MS_XFORM_REC(flow->index, rec));
+		if (val == 0xffffffff) {
+			vsc8584_macsec_flow_disable(phydev, flow);
+			macsec_pn_wrapped(priv->secy, flow->tx_sa);
+			return;
+		}
+	}
+}
+
+void vsc8584_config_macsec_intr(struct phy_device *phydev)
+{
+	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_EXTENDED_2);
+	phy_write(phydev, MSCC_PHY_EXTENDED_INT, MSCC_PHY_EXTENDED_INT_MS_EGR);
+	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
+
+	vsc8584_macsec_phy_write(phydev, MACSEC_EGR, MSCC_MS_AIC_CTRL, 0xf);
+	vsc8584_macsec_phy_write(phydev, MACSEC_EGR, MSCC_MS_INTR_CTRL_STATUS,
+				 MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE(MACSEC_INTR_CTRL_STATUS_ROLLOVER));
+}
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index d9ab6aba7482..c606c9a65d2d 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -8,6 +8,8 @@
 #ifndef _MSCC_OCELOT_MACSEC_H_
 #define _MSCC_OCELOT_MACSEC_H_
 
+#include <net/macsec.h>
+
 #define MSCC_MS_MAX_FLOWS		16
 
 #define CONTROL_TYPE_EGRESS		0x6
@@ -58,6 +60,62 @@ enum mscc_macsec_validate_levels {
 	MSCC_MS_VALIDATE_STRICT		= 2,
 };
 
+enum macsec_bank {
+	FC_BUFFER   = 0x04,
+	HOST_MAC    = 0x05,
+	LINE_MAC    = 0x06,
+	IP_1588     = 0x0e,
+	MACSEC_INGR = 0x38,
+	MACSEC_EGR  = 0x3c,
+};
+
+struct macsec_flow {
+	struct list_head list;
+	enum mscc_macsec_destination_ports port;
+	enum macsec_bank bank;
+	u32 index;
+	int assoc_num;
+	bool has_transformation;
+
+	/* Highest takes precedence [0..15] */
+	u8 priority;
+
+	u8 key[MACSEC_KEYID_LEN];
+
+	union {
+		struct macsec_rx_sa *rx_sa;
+		struct macsec_tx_sa *tx_sa;
+	};
+
+	/* Matching */
+	struct {
+		u8 sci:1;
+		u8 tagged:1;
+		u8 untagged:1;
+		u8 etype:1;
+	} match;
+
+	u16 etype;
+
+	/* Action */
+	struct {
+		u8 bypass:1;
+		u8 drop:1;
+	} action;
+};
+
+#define MSCC_EXT_PAGE_MACSEC_17		17
+#define MSCC_EXT_PAGE_MACSEC_18		18
+
+#define MSCC_EXT_PAGE_MACSEC_19		19
+#define MSCC_PHY_MACSEC_19_REG_ADDR(x)	(x)
+#define MSCC_PHY_MACSEC_19_TARGET(x)	((x) << 12)
+#define MSCC_PHY_MACSEC_19_READ		BIT(14)
+#define MSCC_PHY_MACSEC_19_CMD		BIT(15)
+
+#define MSCC_EXT_PAGE_MACSEC_20		20
+#define MSCC_PHY_MACSEC_20_TARGET(x)	(x)
+
 #define MSCC_MS_XFORM_REC(x, y)		(((x) << 5) + (y))
 #define MSCC_MS_ENA_CFG			0x800
 #define MSCC_MS_FC_CFG			0x804
diff --git a/drivers/net/phy/mscc/mscc.c b/drivers/net/phy/mscc/mscc_main.c
similarity index 60%
rename from drivers/net/phy/mscc/mscc.c
rename to drivers/net/phy/mscc/mscc_main.c
index b2eac7ee0288..cb4d65f81095 100644
--- a/drivers/net/phy/mscc/mscc.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -18,361 +18,7 @@
 #include <linux/netdevice.h>
 #include <dt-bindings/net/mscc-phy-vsc8531.h>
 
-#include <linux/scatterlist.h>
-#include <crypto/skcipher.h>
-
-#if IS_ENABLED(CONFIG_MACSEC)
-#include <net/macsec.h>
-#endif
-
-#include "mscc_macsec.h"
-#include "mscc_mac.h"
-#include "mscc_fc_buffer.h"
-
-enum rgmii_rx_clock_delay {
-	RGMII_RX_CLK_DELAY_0_2_NS = 0,
-	RGMII_RX_CLK_DELAY_0_8_NS = 1,
-	RGMII_RX_CLK_DELAY_1_1_NS = 2,
-	RGMII_RX_CLK_DELAY_1_7_NS = 3,
-	RGMII_RX_CLK_DELAY_2_0_NS = 4,
-	RGMII_RX_CLK_DELAY_2_3_NS = 5,
-	RGMII_RX_CLK_DELAY_2_6_NS = 6,
-	RGMII_RX_CLK_DELAY_3_4_NS = 7
-};
-
-/* Microsemi VSC85xx PHY registers */
-/* IEEE 802. Std Registers */
-#define MSCC_PHY_BYPASS_CONTROL		  18
-#define DISABLE_HP_AUTO_MDIX_MASK	  0x0080
-#define DISABLE_PAIR_SWAP_CORR_MASK	  0x0020
-#define DISABLE_POLARITY_CORR_MASK	  0x0010
-#define PARALLEL_DET_IGNORE_ADVERTISED    0x0008
-
-#define MSCC_PHY_EXT_CNTL_STATUS          22
-#define SMI_BROADCAST_WR_EN		  0x0001
-
-#define MSCC_PHY_ERR_RX_CNT		  19
-#define MSCC_PHY_ERR_FALSE_CARRIER_CNT	  20
-#define MSCC_PHY_ERR_LINK_DISCONNECT_CNT  21
-#define ERR_CNT_MASK			  GENMASK(7, 0)
-
-#define MSCC_PHY_EXT_PHY_CNTL_1           23
-#define MAC_IF_SELECTION_MASK             0x1800
-#define MAC_IF_SELECTION_GMII             0
-#define MAC_IF_SELECTION_RMII             1
-#define MAC_IF_SELECTION_RGMII            2
-#define MAC_IF_SELECTION_POS              11
-#define VSC8584_MAC_IF_SELECTION_MASK     0x1000
-#define VSC8584_MAC_IF_SELECTION_SGMII    0
-#define VSC8584_MAC_IF_SELECTION_1000BASEX 1
-#define VSC8584_MAC_IF_SELECTION_POS      12
-#define FAR_END_LOOPBACK_MODE_MASK        0x0008
-#define MEDIA_OP_MODE_MASK		  0x0700
-#define MEDIA_OP_MODE_COPPER		  0
-#define MEDIA_OP_MODE_SERDES		  1
-#define MEDIA_OP_MODE_1000BASEX		  2
-#define MEDIA_OP_MODE_100BASEFX		  3
-#define MEDIA_OP_MODE_AMS_COPPER_SERDES	  5
-#define MEDIA_OP_MODE_AMS_COPPER_1000BASEX	6
-#define MEDIA_OP_MODE_AMS_COPPER_100BASEFX	7
-#define MEDIA_OP_MODE_POS		  8
-
-#define MSCC_PHY_EXT_PHY_CNTL_2		  24
-
-#define MII_VSC85XX_INT_MASK		  25
-#define MII_VSC85XX_INT_MASK_MDINT	  BIT(15)
-#define MII_VSC85XX_INT_MASK_LINK_CHG	  BIT(13)
-#define MII_VSC85XX_INT_MASK_WOL	  BIT(6)
-#define MII_VSC85XX_INT_MASK_EXT	  BIT(5)
-#define MII_VSC85XX_INT_STATUS		  26
-
-#define MII_VSC85XX_INT_MASK_MASK	  (MII_VSC85XX_INT_MASK_MDINT    | \
-					   MII_VSC85XX_INT_MASK_LINK_CHG | \
-					   MII_VSC85XX_INT_MASK_EXT)
-
-#define MSCC_PHY_WOL_MAC_CONTROL          27
-#define EDGE_RATE_CNTL_POS                5
-#define EDGE_RATE_CNTL_MASK               0x00E0
-
-#define MSCC_PHY_DEV_AUX_CNTL		  28
-#define HP_AUTO_MDIX_X_OVER_IND_MASK	  0x2000
-
-#define MSCC_PHY_LED_MODE_SEL		  29
-#define LED_MODE_SEL_POS(x)		  ((x) * 4)
-#define LED_MODE_SEL_MASK(x)		  (GENMASK(3, 0) << LED_MODE_SEL_POS(x))
-#define LED_MODE_SEL(x, mode)		  (((mode) << LED_MODE_SEL_POS(x)) & LED_MODE_SEL_MASK(x))
-
-#define MSCC_EXT_PAGE_CSR_CNTL_17	  17
-#define MSCC_EXT_PAGE_CSR_CNTL_18	  18
-
-#define MSCC_EXT_PAGE_CSR_CNTL_19	  19
-#define MSCC_PHY_CSR_CNTL_19_REG_ADDR(x)  (x)
-#define MSCC_PHY_CSR_CNTL_19_TARGET(x)	  ((x) << 12)
-#define MSCC_PHY_CSR_CNTL_19_READ	  BIT(14)
-#define MSCC_PHY_CSR_CNTL_19_CMD	  BIT(15)
-
-#define MSCC_EXT_PAGE_CSR_CNTL_20	  20
-#define MSCC_PHY_CSR_CNTL_20_TARGET(x)	  (x)
-
-#define PHY_MCB_TARGET			  0x07
-#define PHY_MCB_S6G_WRITE		  BIT(31)
-#define PHY_MCB_S6G_READ		  BIT(30)
-
-#define PHY_S6G_PLL5G_CFG0		  0x06
-#define PHY_S6G_LCPLL_CFG		  0x11
-#define PHY_S6G_PLL_CFG			  0x2b
-#define PHY_S6G_COMMON_CFG		  0x2c
-#define PHY_S6G_GPC_CFG			  0x2e
-#define PHY_S6G_MISC_CFG		  0x3b
-#define PHY_MCB_S6G_CFG			  0x3f
-#define PHY_S6G_DFT_CFG2		  0x3e
-#define PHY_S6G_PLL_STATUS		  0x31
-#define PHY_S6G_IB_STATUS0		  0x2f
-
-#define PHY_S6G_SYS_RST_POS		  31
-#define PHY_S6G_ENA_LANE_POS		  18
-#define PHY_S6G_ENA_LOOP_POS		  8
-#define PHY_S6G_QRATE_POS		  6
-#define PHY_S6G_IF_MODE_POS		  4
-#define PHY_S6G_PLL_ENA_OFFS_POS	  21
-#define PHY_S6G_PLL_FSM_CTRL_DATA_POS	  8
-#define PHY_S6G_PLL_FSM_ENA_POS		  7
-
-#define MSCC_EXT_PAGE_MACSEC_17		  17
-#define MSCC_EXT_PAGE_MACSEC_18		  18
-
-#define MSCC_EXT_PAGE_MACSEC_19		  19
-#define MSCC_PHY_MACSEC_19_REG_ADDR(x)	  (x)
-#define MSCC_PHY_MACSEC_19_TARGET(x)	  ((x) << 12)
-#define MSCC_PHY_MACSEC_19_READ		  BIT(14)
-#define MSCC_PHY_MACSEC_19_CMD		  BIT(15)
-
-#define MSCC_EXT_PAGE_MACSEC_20		  20
-#define MSCC_PHY_MACSEC_20_TARGET(x)	  (x)
-enum macsec_bank {
-	FC_BUFFER   = 0x04,
-	HOST_MAC    = 0x05,
-	LINE_MAC    = 0x06,
-	IP_1588     = 0x0e,
-	MACSEC_INGR = 0x38,
-	MACSEC_EGR  = 0x3c,
-};
-
-#define MSCC_EXT_PAGE_ACCESS		  31
-#define MSCC_PHY_PAGE_STANDARD		  0x0000 /* Standard registers */
-#define MSCC_PHY_PAGE_EXTENDED		  0x0001 /* Extended registers */
-#define MSCC_PHY_PAGE_EXTENDED_2	  0x0002 /* Extended reg - page 2 */
-#define MSCC_PHY_PAGE_EXTENDED_3	  0x0003 /* Extended reg - page 3 */
-#define MSCC_PHY_PAGE_EXTENDED_4	  0x0004 /* Extended reg - page 4 */
-#define MSCC_PHY_PAGE_CSR_CNTL		  MSCC_PHY_PAGE_EXTENDED_4
-#define MSCC_PHY_PAGE_MACSEC		  MSCC_PHY_PAGE_EXTENDED_4
-/* Extended reg - GPIO; this is a bank of registers that are shared for all PHYs
- * in the same package.
- */
-#define MSCC_PHY_PAGE_EXTENDED_GPIO	  0x0010 /* Extended reg - GPIO */
-#define MSCC_PHY_PAGE_TEST		  0x2a30 /* Test reg */
-#define MSCC_PHY_PAGE_TR		  0x52b5 /* Token ring registers */
-
-/* Extended Page 1 Registers */
-#define MSCC_PHY_CU_MEDIA_CRC_VALID_CNT	  18
-#define VALID_CRC_CNT_CRC_MASK		  GENMASK(13, 0)
-
-#define MSCC_PHY_EXT_MODE_CNTL		  19
-#define FORCE_MDI_CROSSOVER_MASK	  0x000C
-#define FORCE_MDI_CROSSOVER_MDIX	  0x000C
-#define FORCE_MDI_CROSSOVER_MDI		  0x0008
-
-#define MSCC_PHY_ACTIPHY_CNTL		  20
-#define PHY_ADDR_REVERSED		  0x0200
-#define DOWNSHIFT_CNTL_MASK		  0x001C
-#define DOWNSHIFT_EN			  0x0010
-#define DOWNSHIFT_CNTL_POS		  2
-
-#define MSCC_PHY_EXT_PHY_CNTL_4		  23
-#define PHY_CNTL_4_ADDR_POS		  11
-
-#define MSCC_PHY_VERIPHY_CNTL_2		  25
-
-#define MSCC_PHY_VERIPHY_CNTL_3		  26
-
-/* Extended Page 2 Registers */
-#define MSCC_PHY_CU_PMD_TX_CNTL		  16
-
-#define MSCC_PHY_RGMII_CNTL		  20
-#define RGMII_RX_CLK_DELAY_MASK		  0x0070
-#define RGMII_RX_CLK_DELAY_POS		  4
-
-#define MSCC_PHY_WOL_LOWER_MAC_ADDR	  21
-#define MSCC_PHY_WOL_MID_MAC_ADDR	  22
-#define MSCC_PHY_WOL_UPPER_MAC_ADDR	  23
-#define MSCC_PHY_WOL_LOWER_PASSWD	  24
-#define MSCC_PHY_WOL_MID_PASSWD		  25
-#define MSCC_PHY_WOL_UPPER_PASSWD	  26
-
-#define MSCC_PHY_WOL_MAC_CONTROL	  27
-#define SECURE_ON_ENABLE		  0x8000
-#define SECURE_ON_PASSWD_LEN_4		  0x4000
-
-#define MSCC_PHY_EXTENDED_INT		  28
-#define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
-
-/* Extended Page 3 Registers */
-#define MSCC_PHY_SERDES_TX_VALID_CNT	  21
-#define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
-#define MSCC_PHY_SERDES_RX_VALID_CNT	  28
-#define MSCC_PHY_SERDES_RX_CRC_ERR_CNT	  29
-
-/* Extended page GPIO Registers */
-#define MSCC_DW8051_CNTL_STATUS		  0
-#define MICRO_NSOFT_RESET		  0x8000
-#define RUN_FROM_INT_ROM		  0x4000
-#define AUTOINC_ADDR			  0x2000
-#define PATCH_RAM_CLK			  0x1000
-#define MICRO_PATCH_EN			  0x0080
-#define DW8051_CLK_EN			  0x0010
-#define MICRO_CLK_EN			  0x0008
-#define MICRO_CLK_DIVIDE(x)		  ((x) >> 1)
-#define MSCC_DW8051_VLD_MASK		  0xf1ff
-
-/* x Address in range 1-4 */
-#define MSCC_TRAP_ROM_ADDR(x)		  ((x) * 2 + 1)
-#define MSCC_PATCH_RAM_ADDR(x)		  (((x) + 1) * 2)
-#define MSCC_INT_MEM_ADDR		  11
-
-#define MSCC_INT_MEM_CNTL		  12
-#define READ_SFR			  0x6000
-#define READ_PRAM			  0x4000
-#define READ_ROM			  0x2000
-#define READ_RAM			  0x0000
-#define INT_MEM_WRITE_EN		  0x1000
-#define EN_PATCH_RAM_TRAP_ADDR(x)	  (0x0100 << ((x) - 1))
-#define INT_MEM_DATA_M			  0x00ff
-#define INT_MEM_DATA(x)			  (INT_MEM_DATA_M & (x))
-
-#define MSCC_PHY_PROC_CMD		  18
-#define PROC_CMD_NCOMPLETED		  0x8000
-#define PROC_CMD_FAILED			  0x4000
-#define PROC_CMD_SGMII_PORT(x)		  ((x) << 8)
-#define PROC_CMD_FIBER_PORT(x)		  (0x0100 << (x) % 4)
-#define PROC_CMD_QSGMII_PORT		  0x0c00
-#define PROC_CMD_RST_CONF_PORT		  0x0080
-#define PROC_CMD_RECONF_PORT		  0x0000
-#define PROC_CMD_READ_MOD_WRITE_PORT	  0x0040
-#define PROC_CMD_WRITE			  0x0040
-#define PROC_CMD_READ			  0x0000
-#define PROC_CMD_FIBER_DISABLE		  0x0020
-#define PROC_CMD_FIBER_100BASE_FX	  0x0010
-#define PROC_CMD_FIBER_1000BASE_X	  0x0000
-#define PROC_CMD_SGMII_MAC		  0x0030
-#define PROC_CMD_QSGMII_MAC		  0x0020
-#define PROC_CMD_NO_MAC_CONF		  0x0000
-#define PROC_CMD_1588_DEFAULT_INIT	  0x0010
-#define PROC_CMD_NOP			  0x000f
-#define PROC_CMD_PHY_INIT		  0x000a
-#define PROC_CMD_CRC16			  0x0008
-#define PROC_CMD_FIBER_MEDIA_CONF	  0x0001
-#define PROC_CMD_MCB_ACCESS_MAC_CONF	  0x0000
-#define PROC_CMD_NCOMPLETED_TIMEOUT_MS    500
-
-#define MSCC_PHY_MAC_CFG_FASTLINK	  19
-#define MAC_CFG_MASK			  0xc000
-#define MAC_CFG_SGMII			  0x0000
-#define MAC_CFG_QSGMII			  0x4000
-
-/* Test page Registers */
-#define MSCC_PHY_TEST_PAGE_5		  5
-#define MSCC_PHY_TEST_PAGE_8		  8
-#define MSCC_PHY_TEST_PAGE_9		  9
-#define MSCC_PHY_TEST_PAGE_20		  20
-#define MSCC_PHY_TEST_PAGE_24		  24
-
-/* Token ring page Registers */
-#define MSCC_PHY_TR_CNTL		  16
-#define TR_WRITE			  0x8000
-#define TR_ADDR(x)			  (0x7fff & (x))
-#define MSCC_PHY_TR_LSB			  17
-#define MSCC_PHY_TR_MSB			  18
-
-/* Microsemi PHY ID's
- *   Code assumes lowest nibble is 0
- */
-#define PHY_ID_VSC8504			  0x000704c0
-#define PHY_ID_VSC8514			  0x00070670
-#define PHY_ID_VSC8530			  0x00070560
-#define PHY_ID_VSC8531			  0x00070570
-#define PHY_ID_VSC8540			  0x00070760
-#define PHY_ID_VSC8541			  0x00070770
-#define PHY_ID_VSC8552			  0x000704e0
-#define PHY_ID_VSC856X			  0x000707e0
-#define PHY_ID_VSC8572			  0x000704d0
-#define PHY_ID_VSC8574			  0x000704a0
-#define PHY_ID_VSC8575			  0x000707d0
-#define PHY_ID_VSC8582			  0x000707b0
-#define PHY_ID_VSC8584			  0x000707c0
-
-#define MSCC_VDDMAC_1500		  1500
-#define MSCC_VDDMAC_1800		  1800
-#define MSCC_VDDMAC_2500		  2500
-#define MSCC_VDDMAC_3300		  3300
-
-#define DOWNSHIFT_COUNT_MAX		  5
-
-#define MAX_LEDS			  4
-
-#define VSC8584_SUPP_LED_MODES (BIT(VSC8531_LINK_ACTIVITY) | \
-				BIT(VSC8531_LINK_1000_ACTIVITY) | \
-				BIT(VSC8531_LINK_100_ACTIVITY) | \
-				BIT(VSC8531_LINK_10_ACTIVITY) | \
-				BIT(VSC8531_LINK_100_1000_ACTIVITY) | \
-				BIT(VSC8531_LINK_10_1000_ACTIVITY) | \
-				BIT(VSC8531_LINK_10_100_ACTIVITY) | \
-				BIT(VSC8584_LINK_100FX_1000X_ACTIVITY) | \
-				BIT(VSC8531_DUPLEX_COLLISION) | \
-				BIT(VSC8531_COLLISION) | \
-				BIT(VSC8531_ACTIVITY) | \
-				BIT(VSC8584_100FX_1000X_ACTIVITY) | \
-				BIT(VSC8531_AUTONEG_FAULT) | \
-				BIT(VSC8531_SERIAL_MODE) | \
-				BIT(VSC8531_FORCE_LED_OFF) | \
-				BIT(VSC8531_FORCE_LED_ON))
-
-#define VSC85XX_SUPP_LED_MODES (BIT(VSC8531_LINK_ACTIVITY) | \
-				BIT(VSC8531_LINK_1000_ACTIVITY) | \
-				BIT(VSC8531_LINK_100_ACTIVITY) | \
-				BIT(VSC8531_LINK_10_ACTIVITY) | \
-				BIT(VSC8531_LINK_100_1000_ACTIVITY) | \
-				BIT(VSC8531_LINK_10_1000_ACTIVITY) | \
-				BIT(VSC8531_LINK_10_100_ACTIVITY) | \
-				BIT(VSC8531_DUPLEX_COLLISION) | \
-				BIT(VSC8531_COLLISION) | \
-				BIT(VSC8531_ACTIVITY) | \
-				BIT(VSC8531_AUTONEG_FAULT) | \
-				BIT(VSC8531_SERIAL_MODE) | \
-				BIT(VSC8531_FORCE_LED_OFF) | \
-				BIT(VSC8531_FORCE_LED_ON))
-
-#define MSCC_VSC8584_REVB_INT8051_FW		"microchip/mscc_vsc8584_revb_int8051_fb48.bin"
-#define MSCC_VSC8584_REVB_INT8051_FW_START_ADDR	0xe800
-#define MSCC_VSC8584_REVB_INT8051_FW_CRC	0xfb48
-
-#define MSCC_VSC8574_REVB_INT8051_FW		"microchip/mscc_vsc8574_revb_int8051_29e8.bin"
-#define MSCC_VSC8574_REVB_INT8051_FW_START_ADDR	0x4000
-#define MSCC_VSC8574_REVB_INT8051_FW_CRC	0x29e8
-
-#define VSC8584_REVB				0x0001
-#define MSCC_DEV_REV_MASK			GENMASK(3, 0)
-
-struct reg_val {
-	u16	reg;
-	u32	val;
-};
-
-struct vsc85xx_hw_stat {
-	const char *string;
-	u8 reg;
-	u16 page;
-	u16 mask;
-};
+#include "mscc.h"
 
 static const struct vsc85xx_hw_stat vsc85xx_hw_stats[] = {
 	{
@@ -452,85 +98,14 @@ static const struct vsc85xx_hw_stat vsc8584_hw_stats[] = {
 	},
 };
 
-#if IS_ENABLED(CONFIG_MACSEC)
-struct macsec_flow {
-	struct list_head list;
-	enum mscc_macsec_destination_ports port;
-	enum macsec_bank bank;
-	u32 index;
-	int assoc_num;
-	bool has_transformation;
-
-	/* Highest takes precedence [0..15] */
-	u8 priority;
-
-	u8 key[MACSEC_KEYID_LEN];
-
-	union {
-		struct macsec_rx_sa *rx_sa;
-		struct macsec_tx_sa *tx_sa;
-	};
-
-	/* Matching */
-	struct {
-		u8 sci:1;
-		u8 tagged:1;
-		u8 untagged:1;
-		u8 etype:1;
-	} match;
-
-	u16 etype;
-
-	/* Action */
-	struct {
-		u8 bypass:1;
-		u8 drop:1;
-	} action;
-
-};
-#endif
-
-struct vsc8531_private {
-	int rate_magic;
-	u16 supp_led_modes;
-	u32 leds_mode[MAX_LEDS];
-	u8 nleds;
-	const struct vsc85xx_hw_stat *hw_stats;
-	u64 *stats;
-	int nstats;
-	bool pkg_init;
-	/* For multiple port PHYs; the MDIO address of the base PHY in the
-	 * package.
-	 */
-	unsigned int base_addr;
-
-#if IS_ENABLED(CONFIG_MACSEC)
-	/* MACsec fields:
-	 * - One SecY per device (enforced at the s/w implementation level)
-	 * - macsec_flows: list of h/w flows
-	 * - ingr_flows: bitmap of ingress flows
-	 * - egr_flows: bitmap of egress flows
-	 */
-	struct macsec_secy *secy;
-	struct list_head macsec_flows;
-	unsigned long ingr_flows;
-	unsigned long egr_flows;
-#endif
-};
-
 #ifdef CONFIG_OF_MDIO
-struct vsc8531_edge_rate_table {
-	u32 vddmac;
-	u32 slowdown[8];
-};
-
 static const struct vsc8531_edge_rate_table edge_table[] = {
 	{MSCC_VDDMAC_3300, { 0, 2,  4,  7, 10, 17, 29, 53} },
 	{MSCC_VDDMAC_2500, { 0, 3,  6, 10, 14, 23, 37, 63} },
 	{MSCC_VDDMAC_1800, { 0, 5,  9, 16, 23, 35, 52, 76} },
 	{MSCC_VDDMAC_1500, { 0, 6, 14, 21, 29, 42, 58, 77} },
 };
-#endif /* CONFIG_OF_MDIO */
+#endif
 
 static int vsc85xx_phy_read_page(struct phy_device *phydev)
 {
@@ -1676,978 +1251,6 @@ static int vsc8584_config_pre_init(struct phy_device *phydev)
 	return ret;
 }
 
-#if IS_ENABLED(CONFIG_MACSEC)
-static u32 vsc8584_macsec_phy_read(struct phy_device *phydev,
-				   enum macsec_bank bank, u32 reg)
-{
-	u32 val, val_l = 0, val_h = 0;
-	unsigned long deadline;
-	int rc;
-
-	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
-	if (rc < 0)
-		goto failed;
-
-	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_20,
-		    MSCC_PHY_MACSEC_20_TARGET(bank >> 2));
-
-	if (bank >> 2 == 0x1)
-		/* non-MACsec access */
-		bank &= 0x3;
-	else
-		bank = 0;
-
-	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_19,
-		    MSCC_PHY_MACSEC_19_CMD | MSCC_PHY_MACSEC_19_READ |
-		    MSCC_PHY_MACSEC_19_REG_ADDR(reg) |
-		    MSCC_PHY_MACSEC_19_TARGET(bank));
-
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
-	} while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSEC_19_CMD));
-
-	val_l = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_17);
-	val_h = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_18);
-
-failed:
-	phy_restore_page(phydev, rc, rc);
-
-	return (val_h << 16) | val_l;
-}
-
-static void vsc8584_macsec_phy_write(struct phy_device *phydev,
-				     enum macsec_bank bank, u32 reg, u32 val)
-{
-	unsigned long deadline;
-	int rc;
-
-	rc = phy_select_page(phydev, MSCC_PHY_PAGE_MACSEC);
-	if (rc < 0)
-		goto failed;
-
-	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_20,
-		    MSCC_PHY_MACSEC_20_TARGET(bank >> 2));
-
-	if ((bank >> 2 == 0x1) || (bank >> 2 == 0x3))
-		bank &= 0x3;
-	else
-		/* MACsec access */
-		bank = 0;
-
-	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_17, (u16)val);
-	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_18, (u16)(val >> 16));
-
-	__phy_write(phydev, MSCC_EXT_PAGE_MACSEC_19,
-		    MSCC_PHY_MACSEC_19_CMD | MSCC_PHY_MACSEC_19_REG_ADDR(reg) |
-		    MSCC_PHY_MACSEC_19_TARGET(bank));
-
-	deadline = jiffies + msecs_to_jiffies(PROC_CMD_NCOMPLETED_TIMEOUT_MS);
-	do {
-		val = __phy_read(phydev, MSCC_EXT_PAGE_MACSEC_19);
-	} while (time_before(jiffies, deadline) && !(val & MSCC_PHY_MACSEC_19_CMD));
-
-failed:
-	phy_restore_page(phydev, rc, rc);
-}
-
-static void vsc8584_macsec_classification(struct phy_device *phydev,
-					  enum macsec_bank bank)
-{
-	/* enable VLAN tag parsing */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_CP_TAG,
-				 MSCC_MS_SAM_CP_TAG_PARSE_STAG |
-				 MSCC_MS_SAM_CP_TAG_PARSE_QTAG |
-				 MSCC_MS_SAM_CP_TAG_PARSE_QINQ);
-}
-
-static void vsc8584_macsec_flow_default_action(struct phy_device *phydev,
-					       enum macsec_bank bank,
-					       bool block)
-{
-	u32 port = (bank == MACSEC_INGR) ?
-		    MSCC_MS_PORT_UNCONTROLLED : MSCC_MS_PORT_COMMON;
-	u32 action = MSCC_MS_FLOW_BYPASS;
-
-	if (block)
-		action = MSCC_MS_FLOW_DROP;
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_NM_FLOW_NCP,
-				 /* MACsec untagged */
-				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_DEST_PORT(port) |
-				 /* MACsec tagged */
-				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_DEST_PORT(port) |
-				 /* Bad tag */
-				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_DEST_PORT(port) |
-				 /* Kay tag */
-				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_DEST_PORT(port));
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_NM_FLOW_CP,
-				 /* MACsec untagged */
-				 MSCC_MS_SAM_NM_FLOW_NCP_UNTAGGED_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_CP_UNTAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_CP_UNTAGGED_DEST_PORT(port) |
-				 /* MACsec tagged */
-				 MSCC_MS_SAM_NM_FLOW_NCP_TAGGED_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_CP_TAGGED_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_CP_TAGGED_DEST_PORT(port) |
-				 /* Bad tag */
-				 MSCC_MS_SAM_NM_FLOW_NCP_BADTAG_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_CP_BADTAG_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_CP_BADTAG_DEST_PORT(port) |
-				 /* Kay tag */
-				 MSCC_MS_SAM_NM_FLOW_NCP_KAY_FLOW_TYPE(action) |
-				 MSCC_MS_SAM_NM_FLOW_CP_KAY_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-				 MSCC_MS_SAM_NM_FLOW_CP_KAY_DEST_PORT(port));
-}
-
-static void vsc8584_macsec_integrity_checks(struct phy_device *phydev,
-					    enum macsec_bank bank)
-{
-	u32 val;
-
-	if (bank != MACSEC_INGR)
-		return;
-
-	/* Set default rules to pass unmatched frames */
-	val = vsc8584_macsec_phy_read(phydev, bank,
-				      MSCC_MS_PARAMS2_IG_CC_CONTROL);
-	val |= MSCC_MS_PARAMS2_IG_CC_CONTROL_NON_MATCH_CTRL_ACT |
-	       MSCC_MS_PARAMS2_IG_CC_CONTROL_NON_MATCH_ACT;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_PARAMS2_IG_CC_CONTROL,
-				 val);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_PARAMS2_IG_CP_TAG,
-				 MSCC_MS_PARAMS2_IG_CP_TAG_PARSE_STAG |
-				 MSCC_MS_PARAMS2_IG_CP_TAG_PARSE_QTAG |
-				 MSCC_MS_PARAMS2_IG_CP_TAG_PARSE_QINQ);
-}
-
-static void vsc8584_macsec_block_init(struct phy_device *phydev,
-				      enum macsec_bank bank)
-{
-	u32 val;
-	int i;
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_ENA_CFG,
-				 MSCC_MS_ENA_CFG_SW_RST |
-				 MSCC_MS_ENA_CFG_MACSEC_BYPASS_ENA);
-
-	/* Set the MACsec block out of s/w reset and enable clocks */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_ENA_CFG,
-				 MSCC_MS_ENA_CFG_CLK_ENA);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_STATUS_CONTEXT_CTRL,
-				 bank == MACSEC_INGR ? 0xe5880214 : 0xe5880218);
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_MISC_CONTROL,
-				 MSCC_MS_MISC_CONTROL_MC_LATENCY_FIX(bank == MACSEC_INGR ? 57 : 40) |
-				 MSCC_MS_MISC_CONTROL_XFORM_REC_SIZE(bank == MACSEC_INGR ? 1 : 2));
-
-	/* Clear the counters */
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_COUNT_CONTROL);
-	val |= MSCC_MS_COUNT_CONTROL_AUTO_CNTR_RESET;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_COUNT_CONTROL, val);
-
-	/* Enable octet increment mode */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_PP_CTRL,
-				 MSCC_MS_PP_CTRL_MACSEC_OCTET_INCR_MODE);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_BLOCK_CTX_UPDATE, 0x3);
-
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_COUNT_CONTROL);
-	val |= MSCC_MS_COUNT_CONTROL_RESET_ALL;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_COUNT_CONTROL, val);
-
-	/* Set the MTU */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_NON_VLAN_MTU_CHECK,
-				 MSCC_MS_NON_VLAN_MTU_CHECK_NV_MTU_COMPARE(32761) |
-				 MSCC_MS_NON_VLAN_MTU_CHECK_NV_MTU_COMP_DROP);
-
-	for (i = 0; i < 8; i++)
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_VLAN_MTU_CHECK(i),
-					 MSCC_MS_VLAN_MTU_CHECK_MTU_COMPARE(32761) |
-					 MSCC_MS_VLAN_MTU_CHECK_MTU_COMP_DROP);
-
-	if (bank == MACSEC_EGR) {
-		val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_INTR_CTRL_STATUS);
-		val &= ~MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE_M;
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_INTR_CTRL_STATUS, val);
-
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_FC_CFG,
-					 MSCC_MS_FC_CFG_FCBUF_ENA |
-					 MSCC_MS_FC_CFG_LOW_THRESH(0x1) |
-					 MSCC_MS_FC_CFG_HIGH_THRESH(0x4) |
-					 MSCC_MS_FC_CFG_LOW_BYTES_VAL(0x4) |
-					 MSCC_MS_FC_CFG_HIGH_BYTES_VAL(0x6));
-	}
-
-	vsc8584_macsec_classification(phydev, bank);
-	vsc8584_macsec_flow_default_action(phydev, bank, false);
-	vsc8584_macsec_integrity_checks(phydev, bank);
-
-	/* Enable the MACsec block */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_ENA_CFG,
-				 MSCC_MS_ENA_CFG_CLK_ENA |
-				 MSCC_MS_ENA_CFG_MACSEC_ENA |
-				 MSCC_MS_ENA_CFG_MACSEC_SPEED_MODE(0x5));
-}
-
-static void vsc8584_macsec_mac_init(struct phy_device *phydev,
-				    enum macsec_bank bank)
-{
-	u32 val;
-	int i;
-
-	/* Clear host & line stats */
-	for (i = 0; i < 36; i++)
-		vsc8584_macsec_phy_write(phydev, bank, 0x1c + i, 0);
-
-	val = vsc8584_macsec_phy_read(phydev, bank,
-				      MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL);
-	val &= ~MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_PAUSE_MODE_M;
-	val |= MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_PAUSE_MODE(2) |
-	       MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_PAUSE_VALUE(0xffff);
-	vsc8584_macsec_phy_write(phydev, bank,
-				 MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL, val);
-
-	val = vsc8584_macsec_phy_read(phydev, bank,
-				      MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_2);
-	val |= 0xffff;
-	vsc8584_macsec_phy_write(phydev, bank,
-				 MSCC_MAC_PAUSE_CFG_TX_FRAME_CTRL_2, val);
-
-	val = vsc8584_macsec_phy_read(phydev, bank,
-				      MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL);
-	if (bank == HOST_MAC)
-		val |= MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_TIMER_ENA |
-		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_FRAME_DROP_ENA;
-	else
-		val |= MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_REACT_ENA |
-		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_FRAME_DROP_ENA |
-		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_PAUSE_MODE |
-		       MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL_EARLY_PAUSE_DETECT_ENA;
-	vsc8584_macsec_phy_write(phydev, bank,
-				 MSCC_MAC_PAUSE_CFG_RX_FRAME_CTRL, val);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_PKTINF_CFG,
-				 MSCC_MAC_CFG_PKTINF_CFG_STRIP_FCS_ENA |
-				 MSCC_MAC_CFG_PKTINF_CFG_INSERT_FCS_ENA |
-				 MSCC_MAC_CFG_PKTINF_CFG_LPI_RELAY_ENA |
-				 MSCC_MAC_CFG_PKTINF_CFG_STRIP_PREAMBLE_ENA |
-				 MSCC_MAC_CFG_PKTINF_CFG_INSERT_PREAMBLE_ENA |
-				 (bank == HOST_MAC ?
-				  MSCC_MAC_CFG_PKTINF_CFG_ENABLE_TX_PADDING : 0));
-
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_MODE_CFG);
-	val &= ~MSCC_MAC_CFG_MODE_CFG_DISABLE_DIC;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_MODE_CFG, val);
-
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_MAXLEN_CFG);
-	val &= ~MSCC_MAC_CFG_MAXLEN_CFG_MAX_LEN_M;
-	val |= MSCC_MAC_CFG_MAXLEN_CFG_MAX_LEN(10240);
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_MAXLEN_CFG, val);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_ADV_CHK_CFG,
-				 MSCC_MAC_CFG_ADV_CHK_CFG_SFD_CHK_ENA |
-				 MSCC_MAC_CFG_ADV_CHK_CFG_PRM_CHK_ENA |
-				 MSCC_MAC_CFG_ADV_CHK_CFG_OOR_ERR_ENA |
-				 MSCC_MAC_CFG_ADV_CHK_CFG_INR_ERR_ENA);
-
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MAC_CFG_LFS_CFG);
-	val &= ~MSCC_MAC_CFG_LFS_CFG_LFS_MODE_ENA;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_LFS_CFG, val);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MAC_CFG_ENA_CFG,
-				 MSCC_MAC_CFG_ENA_CFG_RX_CLK_ENA |
-				 MSCC_MAC_CFG_ENA_CFG_TX_CLK_ENA |
-				 MSCC_MAC_CFG_ENA_CFG_RX_ENA |
-				 MSCC_MAC_CFG_ENA_CFG_TX_ENA);
-}
-
-/* Must be called with mdio_lock taken */
-static int vsc8584_macsec_init(struct phy_device *phydev)
-{
-	u32 val;
-
-	vsc8584_macsec_block_init(phydev, MACSEC_INGR);
-	vsc8584_macsec_block_init(phydev, MACSEC_EGR);
-	vsc8584_macsec_mac_init(phydev, HOST_MAC);
-	vsc8584_macsec_mac_init(phydev, LINE_MAC);
-
-	vsc8584_macsec_phy_write(phydev, FC_BUFFER,
-				 MSCC_FCBUF_FC_READ_THRESH_CFG,
-				 MSCC_FCBUF_FC_READ_THRESH_CFG_TX_THRESH(4) |
-				 MSCC_FCBUF_FC_READ_THRESH_CFG_RX_THRESH(5));
-
-	val = vsc8584_macsec_phy_read(phydev, FC_BUFFER, MSCC_FCBUF_MODE_CFG);
-	val |= MSCC_FCBUF_MODE_CFG_PAUSE_GEN_ENA |
-	       MSCC_FCBUF_MODE_CFG_RX_PPM_RATE_ADAPT_ENA |
-	       MSCC_FCBUF_MODE_CFG_TX_PPM_RATE_ADAPT_ENA;
-	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_MODE_CFG, val);
-
-	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_PPM_RATE_ADAPT_THRESH_CFG,
-				 MSCC_FCBUF_PPM_RATE_ADAPT_THRESH_CFG_TX_THRESH(8) |
-				 MSCC_FCBUF_PPM_RATE_ADAPT_THRESH_CFG_TX_OFFSET(9));
-
-	val = vsc8584_macsec_phy_read(phydev, FC_BUFFER,
-				      MSCC_FCBUF_TX_DATA_QUEUE_CFG);
-	val &= ~(MSCC_FCBUF_TX_DATA_QUEUE_CFG_START_M |
-		 MSCC_FCBUF_TX_DATA_QUEUE_CFG_END_M);
-	val |= MSCC_FCBUF_TX_DATA_QUEUE_CFG_START(0) |
-		MSCC_FCBUF_TX_DATA_QUEUE_CFG_END(5119);
-	vsc8584_macsec_phy_write(phydev, FC_BUFFER,
-				 MSCC_FCBUF_TX_DATA_QUEUE_CFG, val);
-
-	val = vsc8584_macsec_phy_read(phydev, FC_BUFFER, MSCC_FCBUF_ENA_CFG);
-	val |= MSCC_FCBUF_ENA_CFG_TX_ENA | MSCC_FCBUF_ENA_CFG_RX_ENA;
-	vsc8584_macsec_phy_write(phydev, FC_BUFFER, MSCC_FCBUF_ENA_CFG, val);
-
-	val = vsc8584_macsec_phy_read(phydev, IP_1588,
-				      MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL);
-	val &= ~MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE_M;
-	val |= MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL_PROTOCOL_MODE(4);
-	vsc8584_macsec_phy_write(phydev, IP_1588,
-				 MSCC_PROC_0_IP_1588_TOP_CFG_STAT_MODE_CTL, val);
-
-	return 0;
-}
-
-static void vsc8584_macsec_flow(struct phy_device *phydev,
-				struct macsec_flow *flow)
-{
-	struct vsc8531_private *priv = phydev->priv;
-	enum macsec_bank bank = flow->bank;
-	u32 val, match = 0, mask = 0, action = 0, idx = flow->index;
-
-	if (flow->match.tagged)
-		match |= MSCC_MS_SAM_MISC_MATCH_TAGGED;
-	if (flow->match.untagged)
-		match |= MSCC_MS_SAM_MISC_MATCH_UNTAGGED;
-
-	if (bank == MACSEC_INGR && flow->assoc_num >= 0) {
-		match |= MSCC_MS_SAM_MISC_MATCH_AN(flow->assoc_num);
-		mask |= MSCC_MS_SAM_MASK_AN_MASK(0x3);
-	}
-
-	if (bank == MACSEC_INGR && flow->match.sci && flow->rx_sa->sc->sci) {
-		match |= MSCC_MS_SAM_MISC_MATCH_TCI(BIT(3));
-		mask |= MSCC_MS_SAM_MASK_TCI_MASK(BIT(3)) |
-			MSCC_MS_SAM_MASK_SCI_MASK;
-
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_LO(idx),
-					 lower_32_bits(flow->rx_sa->sc->sci));
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MATCH_SCI_HI(idx),
-					 upper_32_bits(flow->rx_sa->sc->sci));
-	}
-
-	if (flow->match.etype) {
-		mask |= MSCC_MS_SAM_MASK_MAC_ETYPE_MASK;
-
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MAC_SA_MATCH_HI(idx),
-					 MSCC_MS_SAM_MAC_SA_MATCH_HI_ETYPE(htons(flow->etype)));
-	}
-
-	match |= MSCC_MS_SAM_MISC_MATCH_PRIORITY(flow->priority);
-
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MISC_MATCH(idx), match);
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_MASK(idx), mask);
-
-	/* Action for matching packets */
-	if (flow->action.drop)
-		action = MSCC_MS_FLOW_DROP;
-	else if (flow->action.bypass || flow->port == MSCC_MS_PORT_UNCONTROLLED)
-		action = MSCC_MS_FLOW_BYPASS;
-	else
-		action = (bank == MACSEC_INGR) ?
-			 MSCC_MS_FLOW_INGRESS : MSCC_MS_FLOW_EGRESS;
-
-	val = MSCC_MS_SAM_FLOW_CTRL_FLOW_TYPE(action) |
-	      MSCC_MS_SAM_FLOW_CTRL_DROP_ACTION(MSCC_MS_ACTION_DROP) |
-	      MSCC_MS_SAM_FLOW_CTRL_DEST_PORT(flow->port);
-
-	if (action == MSCC_MS_FLOW_BYPASS)
-		goto write_ctrl;
-
-	if (bank == MACSEC_INGR) {
-		if (priv->secy->replay_protect)
-			val |= MSCC_MS_SAM_FLOW_CTRL_REPLAY_PROTECT;
-		if (priv->secy->validate_frames == MACSEC_VALIDATE_STRICT)
-			val |= MSCC_MS_SAM_FLOW_CTRL_VALIDATE_FRAMES(MSCC_MS_VALIDATE_STRICT);
-		else if (priv->secy->validate_frames == MACSEC_VALIDATE_CHECK)
-			val |= MSCC_MS_SAM_FLOW_CTRL_VALIDATE_FRAMES(MSCC_MS_VALIDATE_CHECK);
-	} else if (bank == MACSEC_EGR) {
-		if (priv->secy->protect_frames)
-			val |= MSCC_MS_SAM_FLOW_CTRL_PROTECT_FRAME;
-		if (priv->secy->tx_sc.encrypt)
-			val |= MSCC_MS_SAM_FLOW_CTRL_CONF_PROTECT;
-		if (priv->secy->tx_sc.send_sci)
-			val |= MSCC_MS_SAM_FLOW_CTRL_INCLUDE_SCI;
-	}
-
-write_ctrl:
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
-}
-
-static struct macsec_flow *vsc8584_macsec_find_flow(struct macsec_context *ctx,
-						    enum macsec_bank bank)
-{
-	struct vsc8531_private *priv = ctx->phydev->priv;
-	struct macsec_flow *pos, *tmp;
-
-	list_for_each_entry_safe(pos, tmp, &priv->macsec_flows, list)
-		if (pos->assoc_num == ctx->sa.assoc_num && pos->bank == bank)
-			return pos;
-
-	return ERR_PTR(-ENOENT);
-}
-
-static void vsc8584_macsec_flow_enable(struct phy_device *phydev,
-				       struct macsec_flow *flow)
-{
-	enum macsec_bank bank = flow->bank;
-	u32 val, idx = flow->index;
-
-	if ((flow->bank == MACSEC_INGR && flow->rx_sa && !flow->rx_sa->active) ||
-	    (flow->bank == MACSEC_EGR && flow->tx_sa && !flow->tx_sa->active))
-		return;
-
-	/* Enable */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_ENTRY_SET1, BIT(idx));
-
-	/* Set in-use */
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx));
-	val |= MSCC_MS_SAM_FLOW_CTRL_SA_IN_USE;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
-}
-
-static void vsc8584_macsec_flow_disable(struct phy_device *phydev,
-					struct macsec_flow *flow)
-{
-	enum macsec_bank bank = flow->bank;
-	u32 val, idx = flow->index;
-
-	/* Disable */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_ENTRY_CLEAR1, BIT(idx));
-
-	/* Clear in-use */
-	val = vsc8584_macsec_phy_read(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx));
-	val &= ~MSCC_MS_SAM_FLOW_CTRL_SA_IN_USE;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_SAM_FLOW_CTRL(idx), val);
-}
-
-static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
-{
-	if (flow->bank == MACSEC_INGR)
-		return flow->index + MSCC_MS_MAX_FLOWS;
-
-	return flow->index;
-}
-
-/* Derive the AES key to get a key for the hash autentication */
-static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
-				     u16 key_len, u8 hkey[16])
-{
-	struct crypto_skcipher *tfm = crypto_alloc_skcipher("ecb(aes)", 0, 0);
-	struct skcipher_request *req = NULL;
-	struct scatterlist src, dst;
-	DECLARE_CRYPTO_WAIT(wait);
-	u32 input[4] = {0};
-	int ret;
-
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	req = skcipher_request_alloc(tfm, GFP_KERNEL);
-	if (!req) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
-				      CRYPTO_TFM_REQ_MAY_SLEEP, crypto_req_done,
-				      &wait);
-	ret = crypto_skcipher_setkey(tfm, key, key_len);
-	if (ret < 0)
-		goto out;
-
-	sg_init_one(&src, input, 16);
-	sg_init_one(&dst, hkey, 16);
-	skcipher_request_set_crypt(req, &src, &dst, 16, NULL);
-
-	ret = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-
-out:
-	skcipher_request_free(req);
-	crypto_free_skcipher(tfm);
-	return ret;
-}
-
-static int vsc8584_macsec_transformation(struct phy_device *phydev,
-					 struct macsec_flow *flow)
-{
-	struct vsc8531_private *priv = phydev->priv;
-	enum macsec_bank bank = flow->bank;
-	int i, ret, index = flow->index;
-	u32 rec = 0, control = 0;
-	u8 hkey[16];
-	sci_t sci;
-
-	ret = vsc8584_macsec_derive_key(flow->key, priv->secy->key_len, hkey);
-	if (ret)
-		return ret;
-
-	switch (priv->secy->key_len) {
-	case 16:
-		control |= CONTROL_CRYPTO_ALG(CTRYPTO_ALG_AES_CTR_128);
-		break;
-	case 32:
-		control |= CONTROL_CRYPTO_ALG(CTRYPTO_ALG_AES_CTR_256);
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	control |= (bank == MACSEC_EGR) ?
-		   (CONTROL_TYPE_EGRESS | CONTROL_AN(priv->secy->tx_sc.encoding_sa)) :
-		   (CONTROL_TYPE_INGRESS | CONTROL_SEQ_MASK);
-
-	control |= CONTROL_UPDATE_SEQ | CONTROL_ENCRYPT_AUTH | CONTROL_KEY_IN_CTX |
-		   CONTROL_IV0 | CONTROL_IV1 | CONTROL_IV_IN_SEQ |
-		   CONTROL_DIGEST_TYPE(0x2) | CONTROL_SEQ_TYPE(0x1) |
-		   CONTROL_AUTH_ALG(AUTH_ALG_AES_GHAS) | CONTROL_CONTEXT_ID;
-
-	/* Set the control word */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-				 control);
-
-	/* Set the context ID. Must be unique. */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-				 vsc8584_macsec_flow_context_id(flow));
-
-	/* Set the encryption/decryption key */
-	for (i = 0; i < priv->secy->key_len / sizeof(u32); i++)
-		vsc8584_macsec_phy_write(phydev, bank,
-					 MSCC_MS_XFORM_REC(index, rec++),
-					 ((u32 *)flow->key)[i]);
-
-	/* Set the authentication key */
-	for (i = 0; i < 4; i++)
-		vsc8584_macsec_phy_write(phydev, bank,
-					 MSCC_MS_XFORM_REC(index, rec++),
-					 ((u32 *)hkey)[i]);
-
-	/* Initial sequence number */
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-				 bank == MACSEC_INGR ?
-				 flow->rx_sa->next_pn : flow->tx_sa->next_pn);
-
-	if (bank == MACSEC_INGR)
-		/* Set the mask (replay window size) */
-		vsc8584_macsec_phy_write(phydev, bank,
-					 MSCC_MS_XFORM_REC(index, rec++),
-					 priv->secy->replay_window);
-
-	/* Set the input vectors */
-	sci = bank == MACSEC_INGR ? flow->rx_sa->sc->sci : priv->secy->sci;
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-				 lower_32_bits(sci));
-	vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-				 upper_32_bits(sci));
-
-	while (rec < 20)
-		vsc8584_macsec_phy_write(phydev, bank, MSCC_MS_XFORM_REC(index, rec++),
-					 0);
-
-	flow->has_transformation = true;
-	return 0;
-}
-
-static struct macsec_flow *vsc8584_macsec_alloc_flow(struct vsc8531_private *priv,
-						     enum macsec_bank bank)
-{
-	unsigned long *bitmap = bank == MACSEC_INGR ?
-				&priv->ingr_flows : &priv->egr_flows;
-	struct macsec_flow *flow;
-	int index;
-
-	index = find_first_zero_bit(bitmap, MSCC_MS_MAX_FLOWS);
-
-	if (index == MSCC_MS_MAX_FLOWS)
-		return ERR_PTR(-ENOMEM);
-
-	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
-	if (!flow)
-		return ERR_PTR(-ENOMEM);
-
-	set_bit(index, bitmap);
-	flow->index = index;
-	flow->bank = bank;
-	flow->priority = 8;
-	flow->assoc_num = -1;
-
-	list_add_tail(&flow->list, &priv->macsec_flows);
-	return flow;
-}
-
-static void vsc8584_macsec_free_flow(struct vsc8531_private *priv,
-				     struct macsec_flow *flow)
-{
-	unsigned long *bitmap = flow->bank == MACSEC_INGR ?
-				&priv->ingr_flows : &priv->egr_flows;
-
-	list_del(&flow->list);
-	clear_bit(flow->index, bitmap);
-	kfree(flow);
-}
-
-static int vsc8584_macsec_add_flow(struct phy_device *phydev,
-				   struct macsec_flow *flow, bool update)
-{
-	int ret;
-
-	flow->port = MSCC_MS_PORT_CONTROLLED;
-	vsc8584_macsec_flow(phydev, flow);
-
-	if (update)
-		return 0;
-
-	ret = vsc8584_macsec_transformation(phydev, flow);
-	if (ret) {
-		vsc8584_macsec_free_flow(phydev->priv, flow);
-		return ret;
-	}
-
-	return 0;
-}
-
-static int vsc8584_macsec_default_flows(struct phy_device *phydev)
-{
-	struct macsec_flow *flow;
-
-	/* Add a rule to let the MKA traffic go through, ingress */
-	flow = vsc8584_macsec_alloc_flow(phydev->priv, MACSEC_INGR);
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-
-	flow->priority = 15;
-	flow->port = MSCC_MS_PORT_UNCONTROLLED;
-	flow->match.tagged = 1;
-	flow->match.untagged = 1;
-	flow->match.etype = 1;
-	flow->etype = ETH_P_PAE;
-	flow->action.bypass = 1;
-
-	vsc8584_macsec_flow(phydev, flow);
-	vsc8584_macsec_flow_enable(phydev, flow);
-
-	/* Add a rule to let the MKA traffic go through, egress */
-	flow = vsc8584_macsec_alloc_flow(phydev->priv, MACSEC_EGR);
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-
-	flow->priority = 15;
-	flow->port = MSCC_MS_PORT_COMMON;
-	flow->match.untagged = 1;
-	flow->match.etype = 1;
-	flow->etype = ETH_P_PAE;
-	flow->action.bypass = 1;
-
-	vsc8584_macsec_flow(phydev, flow);
-	vsc8584_macsec_flow_enable(phydev, flow);
-
-	return 0;
-}
-
-static void vsc8584_macsec_del_flow(struct phy_device *phydev,
-				    struct macsec_flow *flow)
-{
-	vsc8584_macsec_flow_disable(phydev, flow);
-	vsc8584_macsec_free_flow(phydev->priv, flow);
-}
-
-static int __vsc8584_macsec_add_rxsa(struct macsec_context *ctx,
-				     struct macsec_flow *flow, bool update)
-{
-	struct phy_device *phydev = ctx->phydev;
-	struct vsc8531_private *priv = phydev->priv;
-
-	if (!flow) {
-		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_INGR);
-		if (IS_ERR(flow))
-			return PTR_ERR(flow);
-
-		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
-	}
-
-	flow->assoc_num = ctx->sa.assoc_num;
-	flow->rx_sa = ctx->sa.rx_sa;
-
-	/* Always match tagged packets on ingress */
-	flow->match.tagged = 1;
-	flow->match.sci = 1;
-
-	if (priv->secy->validate_frames != MACSEC_VALIDATE_DISABLED)
-		flow->match.untagged = 1;
-
-	return vsc8584_macsec_add_flow(phydev, flow, update);
-}
-
-static int __vsc8584_macsec_add_txsa(struct macsec_context *ctx,
-				     struct macsec_flow *flow, bool update)
-{
-	struct phy_device *phydev = ctx->phydev;
-	struct vsc8531_private *priv = phydev->priv;
-
-	if (!flow) {
-		flow = vsc8584_macsec_alloc_flow(priv, MACSEC_EGR);
-		if (IS_ERR(flow))
-			return PTR_ERR(flow);
-
-		memcpy(flow->key, ctx->sa.key, priv->secy->key_len);
-	}
-
-	flow->assoc_num = ctx->sa.assoc_num;
-	flow->tx_sa = ctx->sa.tx_sa;
-
-	/* Always match untagged packets on egress */
-	flow->match.untagged = 1;
-
-	return vsc8584_macsec_add_flow(phydev, flow, update);
-}
-
-static int vsc8584_macsec_dev_open(struct macsec_context *ctx)
-{
-	struct vsc8531_private *priv = ctx->phydev->priv;
-	struct macsec_flow *flow, *tmp;
-
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
-	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
-		vsc8584_macsec_flow_enable(ctx->phydev, flow);
-
-	return 0;
-}
-
-static int vsc8584_macsec_dev_stop(struct macsec_context *ctx)
-{
-	struct vsc8531_private *priv = ctx->phydev->priv;
-	struct macsec_flow *flow, *tmp;
-
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
-	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
-		vsc8584_macsec_flow_disable(ctx->phydev, flow);
-
-	return 0;
-}
-
-static int vsc8584_macsec_add_secy(struct macsec_context *ctx)
-{
-	struct vsc8531_private *priv = ctx->phydev->priv;
-	struct macsec_secy *secy = ctx->secy;
-
-	if (ctx->prepare) {
-		if (priv->secy)
-			return -EEXIST;
-
-		return 0;
-	}
-
-	priv->secy = secy;
-
-	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_EGR,
-					   secy->validate_frames != MACSEC_VALIDATE_DISABLED);
-	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_INGR,
-					   secy->validate_frames != MACSEC_VALIDATE_DISABLED);
-
-	return vsc8584_macsec_default_flows(ctx->phydev);
-}
-
-static int vsc8584_macsec_del_secy(struct macsec_context *ctx)
-{
-	struct vsc8531_private *priv = ctx->phydev->priv;
-	struct macsec_flow *flow, *tmp;
-
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
-	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list)
-		vsc8584_macsec_del_flow(ctx->phydev, flow);
-
-	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_EGR, false);
-	vsc8584_macsec_flow_default_action(ctx->phydev, MACSEC_INGR, false);
-
-	priv->secy = NULL;
-	return 0;
-}
-
-static int vsc8584_macsec_upd_secy(struct macsec_context *ctx)
-{
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
-	vsc8584_macsec_del_secy(ctx);
-	return vsc8584_macsec_add_secy(ctx);
-}
-
-static int vsc8584_macsec_add_rxsc(struct macsec_context *ctx)
-{
-	/* Nothing to do */
-	return 0;
-}
-
-static int vsc8584_macsec_upd_rxsc(struct macsec_context *ctx)
-{
-	return -EOPNOTSUPP;
-}
-
-static int vsc8584_macsec_del_rxsc(struct macsec_context *ctx)
-{
-	struct vsc8531_private *priv = ctx->phydev->priv;
-	struct macsec_flow *flow, *tmp;
-
-	/* No operation to perform before the commit step */
-	if (ctx->prepare)
-		return 0;
-
-	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
-		if (flow->bank == MACSEC_INGR && flow->rx_sa &&
-		    flow->rx_sa->sc->sci == ctx->rx_sc->sci)
-			vsc8584_macsec_del_flow(ctx->phydev, flow);
-	}
-
-	return 0;
-}
-
-static int vsc8584_macsec_add_rxsa(struct macsec_context *ctx)
-{
-	struct macsec_flow *flow = NULL;
-
-	if (ctx->prepare)
-		return __vsc8584_macsec_add_rxsa(ctx, flow, false);
-
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-
-	vsc8584_macsec_flow_enable(ctx->phydev, flow);
-	return 0;
-}
-
-static int vsc8584_macsec_upd_rxsa(struct macsec_context *ctx)
-{
-	struct macsec_flow *flow;
-
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-
-	if (ctx->prepare) {
-		/* Make sure the flow is disabled before updating it */
-		vsc8584_macsec_flow_disable(ctx->phydev, flow);
-
-		return __vsc8584_macsec_add_rxsa(ctx, flow, true);
-	}
-
-	vsc8584_macsec_flow_enable(ctx->phydev, flow);
-	return 0;
-}
-
-static int vsc8584_macsec_del_rxsa(struct macsec_context *ctx)
-{
-	struct macsec_flow *flow;
-
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_INGR);
-
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-	if (ctx->prepare)
-		return 0;
-
-	vsc8584_macsec_del_flow(ctx->phydev, flow);
-	return 0;
-}
-
-static int vsc8584_macsec_add_txsa(struct macsec_context *ctx)
-{
-	struct macsec_flow *flow = NULL;
-
-	if (ctx->prepare)
-		return __vsc8584_macsec_add_txsa(ctx, flow, false);
-
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-
-	vsc8584_macsec_flow_enable(ctx->phydev, flow);
-	return 0;
-}
-
-static int vsc8584_macsec_upd_txsa(struct macsec_context *ctx)
-{
-	struct macsec_flow *flow;
-
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-
-	if (ctx->prepare) {
-		/* Make sure the flow is disabled before updating it */
-		vsc8584_macsec_flow_disable(ctx->phydev, flow);
-
-		return __vsc8584_macsec_add_txsa(ctx, flow, true);
-	}
-
-	vsc8584_macsec_flow_enable(ctx->phydev, flow);
-	return 0;
-}
-
-static int vsc8584_macsec_del_txsa(struct macsec_context *ctx)
-{
-	struct macsec_flow *flow;
-
-	flow = vsc8584_macsec_find_flow(ctx, MACSEC_EGR);
-
-	if (IS_ERR(flow))
-		return PTR_ERR(flow);
-	if (ctx->prepare)
-		return 0;
-
-	vsc8584_macsec_del_flow(ctx->phydev, flow);
-	return 0;
-}
-
-static struct macsec_ops vsc8584_macsec_ops = {
-	.mdo_dev_open = vsc8584_macsec_dev_open,
-	.mdo_dev_stop = vsc8584_macsec_dev_stop,
-	.mdo_add_secy = vsc8584_macsec_add_secy,
-	.mdo_upd_secy = vsc8584_macsec_upd_secy,
-	.mdo_del_secy = vsc8584_macsec_del_secy,
-	.mdo_add_rxsc = vsc8584_macsec_add_rxsc,
-	.mdo_upd_rxsc = vsc8584_macsec_upd_rxsc,
-	.mdo_del_rxsc = vsc8584_macsec_del_rxsc,
-	.mdo_add_rxsa = vsc8584_macsec_add_rxsa,
-	.mdo_upd_rxsa = vsc8584_macsec_upd_rxsa,
-	.mdo_del_rxsa = vsc8584_macsec_del_rxsa,
-	.mdo_add_txsa = vsc8584_macsec_add_txsa,
-	.mdo_upd_txsa = vsc8584_macsec_upd_txsa,
-	.mdo_del_txsa = vsc8584_macsec_del_txsa,
-};
-#endif /* CONFIG_MACSEC */
-
 /* Check if one PHY has already done the init of the parts common to all PHYs
  * in the Quad PHY package.
  */
@@ -2797,23 +1400,9 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 	mutex_unlock(&phydev->mdio.bus->mdio_lock);
 
-#if IS_ENABLED(CONFIG_MACSEC)
-	/* MACsec */
-	switch (phydev->phy_id & phydev->drv->phy_id_mask) {
-	case PHY_ID_VSC856X:
-	case PHY_ID_VSC8575:
-	case PHY_ID_VSC8582:
-	case PHY_ID_VSC8584:
-		INIT_LIST_HEAD(&vsc8531->macsec_flows);
-		vsc8531->secy = NULL;
-
-		phydev->macsec_ops = &vsc8584_macsec_ops;
-
-		ret = vsc8584_macsec_init(phydev);
-		if (ret)
-			goto err;
-	}
-#endif
+	ret = vsc8584_macsec_init(phydev);
+	if (ret)
+		return ret;
 
 	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
 
@@ -2842,37 +1431,7 @@ static int vsc8584_config_init(struct phy_device *phydev)
 
 static int vsc8584_handle_interrupt(struct phy_device *phydev)
 {
-#if IS_ENABLED(CONFIG_MACSEC)
-	struct vsc8531_private *priv = phydev->priv;
-	struct macsec_flow *flow, *tmp;
-	u32 cause, rec;
-
-	/* Check MACsec PN rollover */
-	cause = vsc8584_macsec_phy_read(phydev, MACSEC_EGR,
-					MSCC_MS_INTR_CTRL_STATUS);
-	cause &= MSCC_MS_INTR_CTRL_STATUS_INTR_CLR_STATUS_M;
-	if (!(cause & MACSEC_INTR_CTRL_STATUS_ROLLOVER))
-		goto skip_rollover;
-
-	rec = 6 + priv->secy->key_len / sizeof(u32);
-	list_for_each_entry_safe(flow, tmp, &priv->macsec_flows, list) {
-		u32 val;
-
-		if (flow->bank != MACSEC_EGR || !flow->has_transformation)
-			continue;
-
-		val = vsc8584_macsec_phy_read(phydev, MACSEC_EGR,
-					      MSCC_MS_XFORM_REC(flow->index, rec));
-		if (val == 0xffffffff) {
-			vsc8584_macsec_flow_disable(phydev, flow);
-			macsec_pn_wrapped(priv->secy, flow->tx_sa);
-			break;
-		}
-	}
-
-skip_rollover:
-#endif
-
+	vsc8584_handle_macsec_interrupt(phydev);
 	phy_mac_interrupt(phydev);
 	return 0;
 }
@@ -3320,20 +1879,8 @@ static int vsc85xx_config_intr(struct phy_device *phydev)
 	int rc;
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
-#if IS_ENABLED(CONFIG_MACSEC)
-		phy_write(phydev, MSCC_EXT_PAGE_ACCESS,
-			  MSCC_PHY_PAGE_EXTENDED_2);
-		phy_write(phydev, MSCC_PHY_EXTENDED_INT,
-			  MSCC_PHY_EXTENDED_INT_MS_EGR);
-		phy_write(phydev, MSCC_EXT_PAGE_ACCESS,
-			  MSCC_PHY_PAGE_STANDARD);
-
-		vsc8584_macsec_phy_write(phydev, MACSEC_EGR,
-					 MSCC_MS_AIC_CTRL, 0xf);
-		vsc8584_macsec_phy_write(phydev, MACSEC_EGR,
-			MSCC_MS_INTR_CTRL_STATUS,
-			MSCC_MS_INTR_CTRL_STATUS_INTR_ENABLE(MACSEC_INTR_CTRL_STATUS_ROLLOVER));
-#endif
+		vsc8584_config_macsec_intr(phydev);
+
 		rc = phy_write(phydev, MII_VSC85XX_INT_MASK,
 			       MII_VSC85XX_INT_MASK_MASK);
 	} else {
-- 
2.24.1

