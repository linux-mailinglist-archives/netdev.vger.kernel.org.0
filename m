Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1623155DF2F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344063AbiF1Knh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 06:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241795AbiF1Kng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 06:43:36 -0400
Received: from out28-169.mail.aliyun.com (out28-169.mail.aliyun.com [115.124.28.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4893230F5C;
        Tue, 28 Jun 2022 03:43:29 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00894276-0.168413-0.822644;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.OEhjmVu_1656412996;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.OEhjmVu_1656412996)
          by smtp.aliyun-inc.com;
          Tue, 28 Jun 2022 18:43:25 +0800
From:   Frank <Frank.Sae@motor-comm.com>
To:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     yinghong.zhang@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Frank <Frank.Sae@motor-comm.com>
Subject: [PATCH v2] net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy
Date:   Tue, 28 Jun 2022 18:42:45 +0800
Message-Id: <20220628104245.35-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.31.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

patch v2:
 Hi Andrew, Russell King, Peter,
 Thanks and based on your comments we modified the patch as below.
 
> So there's only two possible pages that can be used in the extended
>register space?
 
 Yes,there is only two register space (utp and fiber).
 
> > +/* Extended Register's Data Register */
> > +#define YTPHY_PAGE_DATA                                0x1F
>
> These are defined exactly the same way as below. Please reuse code
> where possible.
 
 Yes, code will be reuse, but "YT8511_PAGE" need to be rename like
 "YTPHY_PAGE_DATA",as it is common register for yt phys.
 

patch v1:
 Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
 the driver on StarFive VisionFive development board, which is developed by
 Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
 phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
 wol(magic package).

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
 MAINTAINERS                 |   1 +
 drivers/net/phy/Kconfig     |   2 +-
 drivers/net/phy/motorcomm.c | 950 +++++++++++++++++++++++++++++++++++-
 3 files changed, 950 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6d3bd9..59813c5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13437,6 +13437,7 @@ F:	include/uapi/linux/meye.h
 
 MOTORCOMM PHY DRIVER
 M:	Peter Geis <pgwipeout@gmail.com>
+M:	Frank <Frank.Sae@motor-comm.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/motorcomm.c
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 9fee639..9061c76 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -253,7 +253,7 @@ config MOTORCOMM_PHY
 	tristate "Motorcomm PHYs"
 	help
 	  Enables support for Motorcomm network PHYs.
-	  Currently supports the YT8511 gigabit PHY.
+	  Currently supports the YT8511, YT8521 Gigabit Ethernet PHYs.
 
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 7e6ac2c..fd756c2 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1,15 +1,115 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * Driver for Motorcomm PHYs
+ * motorcomm.c: Motorcomm 8511/8521 PHY driver.
  *
  * Author: Peter Geis <pgwipeout@gmail.com>
+ * Author: Frank <Frank.Sae@motor-comm.com>
  */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
+#include <linux/etherdevice.h>
 
 #define PHY_ID_YT8511		0x0000010a
+#define PHY_ID_YT8521				0x0000011A
+
+/* YT8521 Register Overview
+ *	UTP Register space	|	FIBER Register space
+ *  ------------------------------------------------------------
+ * |	UTP MII			|	FIBER MII		|
+ * |	UTP MMD			|				|
+ * |	UTP Extended		|	FIBER Extended		|
+ *  ------------------------------------------------------------
+ * |			Common Extended				|
+ *  ------------------------------------------------------------
+ */
+
+/* 0x10 ~ 0x15 , 0x1E and 0x1F are common MII registers of yt phy */
+
+/* Specific Function Control Register */
+#define YTPHY_SPECIFIC_FUNCTION_CONTROL_REG	0x10
+
+/* 2b00 Manual MDI configuration
+ * 2b01 Manual MDIX configuration
+ * 2b10 Reserved
+ * 2b11 Enable automatic crossover for all modes  *default*
+ */
+#define YTPHY_SFCR_MDI_CROSSOVER_MODE_MASK	(BIT(6) | BIT(5))
+#define YTPHY_SFCR_CROSSOVER_EN			BIT(3)
+#define YTPHY_SFCR_SQE_TEST_EN			BIT(2)
+#define YTPHY_SFCR_POLARITY_REVERSAL_EN		BIT(1)
+#define YTPHY_SFCR_JABBER_DIS			BIT(0)
+
+/* Specific Status Register */
+#define YTPHY_SPECIFIC_STATUS_REG		0x11
+#define YTPHY_SSR_SPEED_MODE_OFFSET		14
+
+/* 2b00 10 Mbps
+ * 2b01 100 Mbps
+ * 2b10 1000 Mbps
+ * 2b11 Reserved
+ */
+#define YTPHY_SSR_SPEED_MODE_MASK		(BIT(15) | BIT(14))
+#define YTPHY_SSR_DUPLEX_OFFSET			13
+#define YTPHY_SSR_DUPLEX			BIT(13)
+#define YTPHY_SSR_PAGE_RECEIVED			BIT(12)
+#define YTPHY_SSR_SPEED_DUPLEX_RESOLVED		BIT(11)
+#define YTPHY_SSR_LINK				BIT(10)
+#define YTPHY_SSR_MDIX_CROSSOVER		BIT(6)
+#define YTPHY_SSR_DOWNGRADE			BIT(5)
+#define YTPHY_SSR_TRANSMIT_PAUSE		BIT(3)
+#define YTPHY_SSR_RECEIVE_PAUSE			BIT(2)
+#define YTPHY_SSR_POLARITY			BIT(1)
+#define YTPHY_SSR_JABBER			BIT(0)
+
+/* Interrupt enable Register */
+#define YTPHY_INTERRUPT_ENABLE_REG		0x12
+#define YTPHY_IER_AUTONEG_ERR			BIT(15)
+#define YTPHY_IER_SPEED_CHANGED			BIT(14)
+#define YTPHY_IER_DUPLEX_CHANGED		BIT(13)
+#define YTPHY_IER_PAGE_RECEIVED			BIT(12)
+#define YTPHY_IER_LINK_FAILED			BIT(11)
+#define YTPHY_IER_LINK_SUCCESSED		BIT(10)
+#define YTPHY_IER_WOL				BIT(6)
+#define YTPHY_IER_WIRESPEED_DOWNGRADE		BIT(5)
+#define YTPHY_IER_SERDES_LINK_FAILED		BIT(3)
+#define YTPHY_IER_SERDES_LINK_SUCCESSED		BIT(2)
+#define YTPHY_IER_POLARITY_CHANGED		BIT(1)
+#define YTPHY_IER_JABBER_HAPPENED		BIT(0)
+
+/* Interrupt Status Register */
+#define YTPHY_INTERRUPT_STATUS_REG		0x13
+#define YTPHY_ISR_AUTONEG_ERR			BIT(15)
+#define YTPHY_ISR_SPEED_CHANGED			BIT(14)
+#define YTPHY_ISR_DUPLEX_CHANGED		BIT(13)
+#define YTPHY_ISR_PAGE_RECEIVED			BIT(12)
+#define YTPHY_ISR_LINK_FAILED			BIT(11)
+#define YTPHY_ISR_LINK_SUCCESSED		BIT(10)
+#define YTPHY_ISR_WOL				BIT(6)
+#define YTPHY_ISR_WIRESPEED_DOWNGRADE		BIT(5)
+#define YTPHY_ISR_SERDES_LINK_FAILED		BIT(3)
+#define YTPHY_ISR_SERDES_LINK_SUCCESSED		BIT(2)
+#define YTPHY_ISR_POLARITY_CHANGED		BIT(1)
+#define YTPHY_ISR_JABBER_HAPPENED		BIT(0)
+
+/* Speed Auto Downgrade Control Register */
+#define YTPHY_SPEED_AUTO_DOWNGRADE_CONTROL_REG	0x14
+#define YTPHY_SADCR_SPEED_DOWNGRADE_EN		BIT(5)
+
+/* If these bits are set to 3, the PHY attempts five times ( 3(set value) +
+ * additional 2) before downgrading, default 0x3
+ */
+#define YTPHY_SADCR_SPEED_RETRY_LIMIT		(0x3 << 2)
+
+/* Rx Error Counter Register */
+#define YTPHY_RX_ERROR_COUNTER_REG		0x15
+
+/* Extended Register's Address Offset Register */
+#define YTPHY_PAGE_SELECT			0x1E
+
+/* Extended Register's Data Register */
+#define YTPHY_PAGE_DATA				0x1F
 
 #define YT8511_PAGE_SELECT	0x1e
 #define YT8511_PAGE		0x1f
@@ -38,6 +138,272 @@
 #define YT8511_DELAY_FE_TX_EN	(0xf << 12)
 #define YT8511_DELAY_FE_TX_DIS	(0x2 << 12)
 
+/* Extended register is different from MMD Register and MII Register.
+ * We can use ytphy_read_ext/ytphy_write_ext/ytphy_modify_ext function to
+ * operate extended register.
+ * Extended Register  start
+ */
+
+#define YT8521_EXTREG_SLEEP_CONTROL1_REG	0x27
+#define YT8521_ESC1R_SLEEP_SW			BIT(15)
+#define YT8521_ESC1R_PLLON_SLP			BIT(14)
+
+/* 0xA000, 0xA001, 0xA003 and 0xA007 ~ 0xA00A  are common ext registers
+ * of yt8521 phy. There is no need to switch reg space when operating these
+ * registers.
+ */
+
+#define YT8521_REG_SPACE_SELECT_REG		0xA000
+#define YT8521_RSSR_SPACE_MASK			BIT(1)
+#define YT8521_RSSR_FIBER_SPACE			0x2
+#define YT8521_RSSR_UTP_SPACE			0x0
+
+#define YT8521_CHIP_CONFIG_REG			0xA001
+#define YT8521_CCR_SW_RST			BIT(15)
+
+/* 8 working modes:
+ * 3b000 UTP_TO_RGMII  *default*
+ * 3b001 FIBER_TO_RGMII
+ * 3b010 UTP_FIBER_TO_RGMII
+ * 3b011 UTP_TO_SGMII
+ * 3b100 SGPHY_TO_RGMAC
+ * 3b101 SGMAC_TO_RGPHY
+ * 3b110 UTP_TO_FIBER_AUTO
+ * 3b111 UTP_TO_FIBER_FORCE
+ */
+#define YT8521_CCR_MODE_SEL_MASK		(BIT(2) | BIT(1) | BIT(0))
+
+/* 3 phy polling modes,poll mode combines utp and fiber mode*/
+#define YT8521_MODE_FIBER			0x1
+#define YT8521_MODE_UTP				0x2
+#define YT8521_MODE_POLL			0x3
+
+#define YT8521_RGMII_CONFIG1_REG		0xA003
+
+/* TX Gig-E Delay is bits 3:0, default 0x1
+ * TX Fast-E Delay is bits 7:4, default 0xf
+ * RX Delay is bits 13:10, default 0x0
+ * Delay = 150ps * N
+ * On = 2250ps, off = 0ps
+ */
+#define YT8521_RC1R_RX_DELAY_MASK		(0xF << 10)
+#define YT8521_RC1R_RX_DELAY_EN			(0xF << 10)
+#define YT8521_RC1R_RX_DELAY_DIS		(0x0 << 10)
+#define YT8521_RC1R_FE_TX_DELAY_MASK		(0xF << 4)
+#define YT8521_RC1R_FE_TX_DELAY_EN		(0xF << 4)
+#define YT8521_RC1R_FE_TX_DELAY_DIS		(0x0 << 4)
+#define YT8521_RC1R_GE_TX_DELAY_MASK		(0xF << 0)
+#define YT8521_RC1R_GE_TX_DELAY_EN		(0xF << 0)
+#define YT8521_RC1R_GE_TX_DELAY_DIS		(0x0 << 0)
+
+/* WOL MAC ADDR: MACADDR2(highest), MACADDR1(middle), MACADDR0(lowest) */
+#define YTPHY_WOL_MACADDR2_REG			0xA007
+#define YTPHY_WOL_MACADDR1_REG			0xA008
+#define YTPHY_WOL_MACADDR0_REG			0xA009
+
+#define YTPHY_WOL_CONFIG_REG			0xA00A
+#define YTPHY_WCR_INTR_SEL			BIT(6)
+#define YTPHY_WCR_ENABLE			BIT(3)
+
+/* 2b00 84ms
+ * 2b01 168ms  *default*
+ * 2b10 336ms
+ * 2b11 672ms
+ */
+#define YTPHY_WCR_PUSEL_WIDTH_MASK		(BIT(2) | BIT(1))
+#define YTPHY_WCR_PUSEL_WIDTH_672MS		(BIT(2) | BIT(1))
+
+/* 1b0 Interrupt and WOL events is level triggered and active LOW  *default*
+ * 1b1 Interrupt and WOL events is pulse triggered and active LOW
+ */
+#define YTPHY_WCR_TYPE_PULSE			BIT(0)
+
+/* Extended Register  end */
+
+struct yt8521_priv {
+	u8 polling_mode; /* YT8521_MODE_FIBER / YT8521_MODE_UTP / YT8521_MODE_POLL*/
+	u8 strap_mode; /* 8 working modes  */
+};
+
+/**
+ * ytphy_read_ext() - read a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to read
+ *
+ * NOTE:The caller must have taken the MDIO bus lock.
+ *
+ * returns the value of regnum reg or negative error code
+ */
+static int ytphy_read_ext(struct phy_device *phydev, u16 regnum)
+{
+	int ret;
+
+	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
+	if (ret < 0)
+		return ret;
+
+	return __phy_read(phydev, YTPHY_PAGE_DATA);
+}
+
+/**
+ * ytphy_write_ext() - write a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * NOTE:The caller must have taken the MDIO bus lock.
+ *
+ * returns 0 or negative error code
+ */
+static int ytphy_write_ext(struct phy_device *phydev, u16 regnum, u16 val)
+{
+	int ret;
+
+	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
+	if (ret < 0)
+		return ret;
+
+	return __phy_write(phydev, YTPHY_PAGE_DATA, val);
+}
+
+/**
+ * ytphy_modify_ext() - bits modify a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * NOTE: Convenience function which allows a PHY‘s extended register to be
+ * modified as new register value = (old register value & ~mask) | set.
+ * The caller must have taken the MDIO bus lock.
+ *
+ * returns 0 or negative error code
+ */
+static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 mask,
+			    u16 set)
+{
+	u16 val;
+	int ret;
+
+	ret = ytphy_read_ext(phydev, regnum);
+	if (ret < 0)
+		return ret;
+
+	val = ret & 0xffff;
+	val &= ~mask;
+	val |= set;
+
+	return ytphy_write_ext(phydev, regnum, val);
+}
+
+/**
+ * ytphy_get_wol() - report whether wake-on-lan is enabled
+ * @phydev: a pointer to a &struct phy_device
+ * @wol: a pointer to a &struct ethtool_wolinfo
+ *
+ * NOTE: YTPHY_WOL_CONFIG_REG is common ext reg.
+ */
+static void ytphy_get_wol(struct phy_device *phydev,
+			  struct ethtool_wolinfo *wol)
+{
+	int wol_config;
+
+	wol->supported = WAKE_MAGIC;
+	wol->wolopts = 0;
+
+	phy_lock_mdio_bus(phydev);
+	wol_config = ytphy_read_ext(phydev, YTPHY_WOL_CONFIG_REG);
+	phy_unlock_mdio_bus(phydev);
+
+	if (wol_config < 0)
+		return;
+
+	if (wol_config & YTPHY_WCR_ENABLE)
+		wol->wolopts |= WAKE_MAGIC;
+}
+
+/**
+ * ytphy_set_wol() - turn wake-on-lan on or off
+ * @phydev: a pointer to a &struct phy_device
+ * @wol: a pointer to a &struct ethtool_wolinfo
+ *
+ * NOTE: YTPHY_WOL_CONFIG_REG, YTPHY_WOL_MACADDR2_REG, YTPHY_WOL_MACADDR1_REG
+ * and YTPHY_WOL_MACADDR0_REG are common ext reg. the YTPHY_INTERRUPT_ENABLE_REG
+ * of UTP is special, fiber also use this register.
+ *
+ * returns 0 or negative errno code
+ */
+static int ytphy_set_wol(struct phy_device *phydev, struct ethtool_wolinfo *wol)
+{
+	struct net_device *p_attached_dev;
+	const u16 mac_addr_reg[] = {
+		YTPHY_WOL_MACADDR2_REG,
+		YTPHY_WOL_MACADDR1_REG,
+		YTPHY_WOL_MACADDR0_REG,
+	};
+	const u8 *mac_addr;
+	int old_page;
+	int ret = 0;
+	u16 mask;
+	u16 val;
+	u8 i;
+
+	if (wol->wolopts & WAKE_MAGIC) {
+		p_attached_dev = phydev->attached_dev;
+		if (!p_attached_dev)
+			return -ENODEV;
+
+		mac_addr = (const u8 *)p_attached_dev->dev_addr;
+		if (!is_valid_ether_addr(mac_addr))
+			return -EINVAL;
+
+		/* lock mdio bus then switch to utp reg space */
+		old_page = phy_select_page(phydev, YT8521_RSSR_UTP_SPACE);
+		if (old_page < 0)
+			goto err_restore_page;
+
+		/* Store the device address for the magic packet */
+		for (i = 0; i < 3; i++) {
+			ret = ytphy_write_ext(phydev, mac_addr_reg[i],
+					      ((mac_addr[i * 2] << 8)) |
+						      (mac_addr[i * 2 + 1]));
+			if (ret < 0)
+				goto err_restore_page;
+		}
+
+		/* Enable WOL feature */
+		mask = YTPHY_WCR_PUSEL_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
+		val = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		val |= YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PUSEL_WIDTH_672MS;
+		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, val);
+		if (ret < 0)
+			goto err_restore_page;
+
+		/* Enable WOL interrupt */
+		ret = __phy_set_bits(phydev, YTPHY_INTERRUPT_ENABLE_REG,
+				     YTPHY_IER_WOL);
+		if (ret < 0)
+			goto err_restore_page;
+
+	} else {
+		old_page = phy_select_page(phydev, YT8521_RSSR_UTP_SPACE);
+		if (old_page < 0)
+			goto err_restore_page;
+
+		/* Disable WOL feature */
+		mask = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, 0);
+
+		/* Disable WOL interrupt */
+		ret = __phy_set_bits(phydev, YTPHY_INTERRUPT_ENABLE_REG, 0);
+		if (ret < 0)
+			goto err_restore_page;
+	}
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
 static int yt8511_read_page(struct phy_device *phydev)
 {
 	return __phy_read(phydev, YT8511_PAGE_SELECT);
@@ -111,6 +477,568 @@ err_restore_page:
 	return phy_restore_page(phydev, oldpage, ret);
 }
 
+/**
+ * yt8521_read_page() - read reg page
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns current reg space of yt8521 (YT8521_RSSR_FIBER_SPACE /
+ * YT8521_RSSR_UTP_SPACE) or negative errno code
+ */
+static int yt8521_read_page(struct phy_device *phydev)
+{
+	int old_page;
+
+	old_page = ytphy_read_ext(phydev, YT8521_REG_SPACE_SELECT_REG);
+	if (old_page < 0)
+		return old_page;
+
+	if ((old_page & YT8521_RSSR_SPACE_MASK) == YT8521_RSSR_FIBER_SPACE)
+		return YT8521_RSSR_FIBER_SPACE;
+
+	return YT8521_RSSR_UTP_SPACE;
+};
+
+/**
+ * yt8521_write_page() - write reg page
+ * @phydev: a pointer to a &struct phy_device
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to write.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_write_page(struct phy_device *phydev, int page)
+{
+	int mask = YT8521_RSSR_SPACE_MASK;
+	int set;
+
+	if ((page & YT8521_RSSR_SPACE_MASK) == YT8521_RSSR_FIBER_SPACE)
+		set = YT8521_RSSR_FIBER_SPACE;
+	else
+		set = YT8521_RSSR_UTP_SPACE;
+
+	return ytphy_modify_ext(phydev, YT8521_REG_SPACE_SELECT_REG, mask, set);
+};
+
+/**
+ * yt8521_read_page_with_lock() - read reg page
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns current reg space of yt8521 (YT8521_RSSR_FIBER_SPACE /
+ * YT8521_RSSR_UTP_SPACE) or negative errno code
+ */
+static int yt8521_read_page_with_lock(struct phy_device *phydev)
+{
+	int old_page;
+
+	phy_lock_mdio_bus(phydev);
+	old_page = yt8521_read_page(phydev);
+	phy_unlock_mdio_bus(phydev);
+
+	return old_page;
+};
+
+/**
+ * yt8521_write_page_with_lock() - write reg page
+ * @phydev: a pointer to a &struct phy_device
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to write.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_write_page_with_lock(struct phy_device *phydev, int page)
+{
+	int old_page;
+	int ret = 0;
+
+	phy_lock_mdio_bus(phydev);
+	old_page = yt8521_read_page(phydev);
+	if (old_page < 0) {
+		ret = old_page;
+		goto err_handle;
+	}
+
+	if (old_page != (page & YT8521_RSSR_SPACE_MASK))
+		ret = yt8521_write_page(phydev, page);
+
+err_handle:
+	phy_unlock_mdio_bus(phydev);
+	return ret;
+};
+
+static int yt8521_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct yt8521_priv *priv;
+	int chip_config;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phy_lock_mdio_bus(phydev);
+	chip_config = ytphy_read_ext(phydev, YT8521_CHIP_CONFIG_REG);
+	phy_unlock_mdio_bus(phydev);
+	if (chip_config < 0)
+		return chip_config;
+
+	priv->strap_mode = chip_config & YT8521_CCR_MODE_SEL_MASK;
+	switch (priv->strap_mode) {
+	case 1:
+	case 4:
+	case 5:
+		priv->polling_mode = YT8521_MODE_FIBER;
+		break;
+	case 2:
+	case 6:
+	case 7:
+		priv->polling_mode = YT8521_MODE_POLL;
+		break;
+	case 3:
+	case 0:
+		priv->polling_mode = YT8521_MODE_UTP;
+		break;
+	}
+
+	phydev->priv = priv;
+
+	return 0;
+}
+
+/**
+ * yt8521_adjust_status() - adjust speed and duplex according to is_utp, then
+ * update speed and duplex to phydev
+ *
+ * @phydev: a pointer to a &struct phy_device
+ * @status: yt8521 status read from YTPHY_SPECIFIC_STATUS_REG
+ * @is_utp: false(yt8521 work in fiber mode) or true(yt8521 work in utp mode)
+ *
+ * NOTE: there is no 10M speed mode in fiber mode, so need adjust.
+ *
+ * returns 0
+ */
+static int yt8521_adjust_status(struct phy_device *phydev, int status,
+				bool is_utp)
+{
+	int speed_mode, duplex;
+	int speed;
+
+	if (is_utp)
+		duplex = (status & YTPHY_SSR_DUPLEX) >> YTPHY_SSR_DUPLEX_OFFSET;
+	else
+		duplex = 1;
+
+	speed_mode = (status & YTPHY_SSR_SPEED_MODE_MASK) >>
+		     YTPHY_SSR_SPEED_MODE_OFFSET;
+	switch (speed_mode) {
+	case 0:
+		if (is_utp)
+			speed = SPEED_10;
+		else
+			speed = SPEED_UNKNOWN;
+		break;
+	case 1:
+		speed = SPEED_100;
+		break;
+	case 2:
+		speed = SPEED_1000;
+		break;
+	default:
+		speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	phydev->speed = speed;
+	phydev->duplex = duplex;
+	phydev->port = is_utp ? PORT_TP : PORT_FIBRE;
+
+	return 0;
+}
+
+/**
+ * yt8521_read_status() -  determines the negotiated speed and duplex
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_read_status(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u8 polling_mode = priv->polling_mode;
+	int old_link = phydev->link;
+	int old_page;
+	int status;
+	int ret;
+
+	old_page = yt8521_read_page_with_lock(phydev);
+	if (old_page)
+		return old_page;
+
+	/* YT8521 has two reg space (utp/fiber) and three work mode (utp/fiber/poll),
+	 * each reg space has MII standard regs. reg space should be properly set
+	 * before read link status. Poll mode combines utp and faber mode,so
+	 * need check both.
+	 */
+
+	if (polling_mode == YT8521_MODE_UTP ||
+	    polling_mode == YT8521_MODE_POLL) {
+		ret = yt8521_write_page_with_lock(phydev,
+						  YT8521_RSSR_UTP_SPACE);
+		if (ret < 0)
+			goto err_restore_page;
+
+		/* Update the link, but return if there was an error */
+		ret = genphy_update_link(phydev);
+		if (ret)
+			goto err_restore_page;
+
+		/* why bother the PHY if nothing can have changed */
+		if (phydev->autoneg == AUTONEG_ENABLE && old_link &&
+		    phydev->link)
+			return yt8521_write_page_with_lock(phydev, old_page);
+
+		phydev->speed = SPEED_UNKNOWN;
+		phydev->duplex = DUPLEX_UNKNOWN;
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
+
+		/* Read YTPHY_SPECIFIC_STATUS_REG, which indicates the
+		 * speed and duplex of the PHY is actually using.
+		 */
+		status = phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
+		if (status < 0)
+			goto err_restore_page;
+
+		/* check Link status real-time ,if linked then adjust the status*/
+		if (status & YTPHY_SSR_LINK) {
+			ret = yt8521_adjust_status(phydev, status, true);
+			if (ret < 0)
+				goto err_restore_page;
+		}
+		if (phydev->autoneg == AUTONEG_ENABLE &&
+		    phydev->autoneg_complete)
+			phy_resolve_aneg_pause(phydev);
+	}
+
+	if (polling_mode == YT8521_MODE_FIBER ||
+	    polling_mode == YT8521_MODE_POLL) {
+		ret = yt8521_write_page_with_lock(phydev,
+						  YT8521_RSSR_FIBER_SPACE);
+		if (ret < 0)
+			return ret;
+
+		/* Update the link, but return if there was an error */
+		ret = genphy_update_link(phydev);
+		if (ret)
+			goto err_restore_page;
+
+		/* why bother the PHY if nothing can have changed */
+		if (phydev->autoneg == AUTONEG_ENABLE && old_link &&
+		    phydev->link)
+			return yt8521_write_page_with_lock(phydev, old_page);
+
+		phydev->speed = SPEED_UNKNOWN;
+		phydev->duplex = DUPLEX_UNKNOWN;
+		phydev->pause = 0;
+		phydev->asym_pause = 0;
+
+		/* Read YTPHY_SPECIFIC_STATUS_REG, which indicates the
+		 * speed and duplex of the PHY is actually using.
+		 */
+		status = phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
+		if (status < 0)
+			goto err_restore_page;
+
+		/* check Link status real-time ,if linked then adjust the status*/
+		if (status & YTPHY_SSR_LINK) {
+			ret = yt8521_adjust_status(phydev, status, false);
+			if (ret < 0)
+				goto err_restore_page;
+		}
+		if (phydev->autoneg == AUTONEG_ENABLE &&
+		    phydev->autoneg_complete)
+			phy_resolve_aneg_pause(phydev);
+	}
+
+	return yt8521_write_page_with_lock(phydev, old_page);
+
+err_restore_page:
+	yt8521_write_page_with_lock(phydev, old_page);
+	return ret;
+}
+
+/**
+ * yt8521_modify_UTP_FIBER_BMCR - bits modify a PHY's BMCR register according to the
+ * current mode
+ * @phydev: the phy_device struct
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * NOTE: Convenience function which allows a PHY‘s BMCR register to be
+ * modified as new register value = (old register value & ~mask) | set.
+ * YT8521 has two space (utp/fiber) and three mode (utp/fiber/poll), each space
+ * has MII_BMCR. poll mode combines utp and faber,so need do both.
+ * The caller must have taken the MDIO bus lock.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_modify_UTP_FIBER_BMCR(struct phy_device *phydev, u16 mask,
+					u16 set)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u8 polling_mode = priv->polling_mode;
+	int ret;
+
+	if (polling_mode == YT8521_MODE_UTP ||
+	    polling_mode == YT8521_MODE_POLL) {
+		ret = yt8521_write_page(phydev, YT8521_RSSR_UTP_SPACE);
+		if (ret < 0)
+			return ret;
+
+		ret = __phy_modify(phydev, MII_BMCR, mask, set);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (polling_mode == YT8521_MODE_FIBER ||
+	    polling_mode == YT8521_MODE_POLL) {
+		ret = yt8521_write_page(phydev, YT8521_RSSR_FIBER_SPACE);
+		if (ret < 0)
+			return ret;
+
+		ret = __phy_modify(phydev, MII_BMCR, mask, set);
+		if (ret < 0)
+			return ret;
+	}
+	return 0;
+}
+
+/**
+ * yt8521_soft_reset() - called to issue a PHY software reset
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+int yt8521_soft_reset(struct phy_device *phydev)
+{
+	int old_page;
+	int ret = 0;
+
+	old_page = phy_save_page(phydev);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	ret = yt8521_modify_UTP_FIBER_BMCR(phydev, 0, BMCR_RESET);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_suspend() - suspend the hardware
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+int yt8521_suspend(struct phy_device *phydev)
+{
+	int old_page;
+	int ret = 0;
+	int wol_config;
+
+	phy_lock_mdio_bus(phydev);
+	/* YTPHY_WOL_CONFIG_REG is common ext reg */
+	wol_config = ytphy_read_ext(phydev, YTPHY_WOL_CONFIG_REG);
+	phy_unlock_mdio_bus(phydev);
+	if (wol_config < 0)
+		return wol_config;
+
+	/* if wol enable, do nothing */
+	if (wol_config & YTPHY_WCR_ENABLE)
+		return 0;
+
+	old_page = phy_save_page(phydev);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	ret = yt8521_modify_UTP_FIBER_BMCR(phydev, 0, BMCR_PDOWN);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_resume() - resume the hardware
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+int yt8521_resume(struct phy_device *phydev)
+{
+	int old_page;
+	int ret = 0;
+	int wol_config;
+
+	old_page = phy_save_page(phydev);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	/* disable auto sleep */
+	ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
+			       YT8521_ESC1R_SLEEP_SW, 0);
+	if (ret < 0)
+		goto err_restore_page;
+
+	wol_config = ytphy_read_ext(phydev, YTPHY_WOL_CONFIG_REG);
+	if (wol_config < 0) {
+		ret = wol_config;
+		goto err_restore_page;
+	}
+
+	/* if wol enable, do nothing */
+	if (wol_config & YTPHY_WCR_ENABLE)
+		return phy_restore_page(phydev, old_page, ret);
+
+	ret = yt8521_modify_UTP_FIBER_BMCR(phydev, BMCR_PDOWN, 0);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_config_init() - called to initialize the PHY
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_config_init(struct phy_device *phydev)
+{
+	int old_page;
+	int ret = 0;
+
+	old_page = phy_select_page(phydev, YT8521_RSSR_UTP_SPACE);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	/* disable auto sleep */
+	ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
+			       YT8521_ESC1R_SLEEP_SW, 0);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* enable RXC clock when no wire plug */
+	ret = ytphy_modify_ext(phydev, 0xc, BIT(12), 0);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_config_aneg() - change reg space then call genphy_config_aneg
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+int yt8521_config_aneg(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u8 polling_mode = priv->polling_mode;
+	int old_page;
+	int ret;
+
+	old_page = yt8521_read_page_with_lock(phydev);
+	if (old_page)
+		return old_page;
+
+	if (polling_mode == YT8521_MODE_FIBER ||
+	    polling_mode == YT8521_MODE_POLL) {
+		ret = yt8521_write_page_with_lock(phydev,
+						  YT8521_RSSR_FIBER_SPACE);
+		if (ret < 0)
+			goto err_restore_page;
+
+		ret = genphy_config_aneg(phydev);
+		if (ret < 0)
+			goto err_restore_page;
+	}
+
+	if (polling_mode == YT8521_MODE_UTP ||
+	    polling_mode == YT8521_MODE_POLL) {
+		ret = yt8521_write_page_with_lock(phydev,
+						  YT8521_RSSR_UTP_SPACE);
+		if (ret < 0)
+			goto err_restore_page;
+
+		ret = genphy_config_aneg(phydev);
+		if (ret < 0)
+			goto err_restore_page;
+	}
+
+	return yt8521_write_page_with_lock(phydev, old_page);
+
+err_restore_page:
+	yt8521_write_page_with_lock(phydev, old_page);
+	return ret;
+}
+
+/**
+ * yt8521_aneg_done() - determines the auto negotiation result
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0(no link)or 1( fiber or utp link) or negative errno code
+ */
+int yt8521_aneg_done(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	u8 polling_mode = priv->polling_mode;
+	int link_fiber = 0;
+	int link_utp = 0;
+	int old_page;
+	int ret = 0;
+
+	old_page = phy_save_page(phydev);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	if (polling_mode == YT8521_MODE_FIBER ||
+	    polling_mode == YT8521_MODE_POLL) {
+		/* switch to FIBER reg space*/
+		ret = yt8521_write_page(phydev, YT8521_RSSR_FIBER_SPACE);
+		if (ret < 0)
+			goto err_restore_page;
+
+		ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
+		if (ret < 0)
+			goto err_restore_page;
+
+		link_fiber = !!(ret & YTPHY_SSR_LINK);
+	}
+
+	if (polling_mode == YT8521_MODE_UTP ||
+	    polling_mode == YT8521_MODE_POLL) {
+		/* switch to UTP reg space */
+		ret = yt8521_write_page(phydev, YT8521_RSSR_UTP_SPACE);
+		if (ret < 0)
+			goto err_restore_page;
+
+		ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
+		if (ret < 0)
+			goto err_restore_page;
+
+		link_utp = !!(ret & YTPHY_SSR_LINK);
+	}
+
+	ret = !!(link_fiber | link_utp);
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
 static struct phy_driver motorcomm_phy_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
@@ -121,16 +1049,34 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		.read_page	= yt8511_read_page,
 		.write_page	= yt8511_write_page,
 	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8521),
+		.name		= "YT8521 Gigabit Ethernet",
+		.probe		= yt8521_probe,
+		.read_page	= yt8521_read_page,
+		.write_page	= yt8521_write_page,
+		.get_wol	= ytphy_get_wol,
+		.set_wol	= ytphy_set_wol,
+		.config_aneg	= yt8521_config_aneg,
+		.aneg_done	= yt8521_aneg_done,
+		.config_init	= yt8521_config_init,
+		.read_status	= yt8521_read_status,
+		.soft_reset	= yt8521_soft_reset,
+		.suspend	= yt8521_suspend,
+		.resume		= yt8521_resume,
+	},
 };
 
 module_phy_driver(motorcomm_phy_drvs);
 
-MODULE_DESCRIPTION("Motorcomm PHY driver");
+MODULE_DESCRIPTION("Motorcomm 8511/8521 PHY driver");
 MODULE_AUTHOR("Peter Geis");
+MODULE_AUTHOR("Frank");
 MODULE_LICENSE("GPL");
 
 static const struct mdio_device_id __maybe_unused motorcomm_tbl[] = {
 	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8511) },
+	{ PHY_ID_MATCH_EXACT(PHY_ID_YT8521) },
 	{ /* sentinal */ }
 };
 
-- 
2.31.0.windows.1

