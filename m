Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74336602042
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbiJRBO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJRBOY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:14:24 -0400
Received: from out28-75.mail.aliyun.com (out28-75.mail.aliyun.com [115.124.28.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5358D520BA;
        Mon, 17 Oct 2022 18:14:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07436282|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00763646-0.135444-0.85692;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047211;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=14;RT=14;SR=0;TI=SMTPD_---.PfTXBcX_1666055625;
Received: from sunhua.motor-comm.com(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.PfTXBcX_1666055625)
          by smtp.aliyun-inc.com;
          Tue, 18 Oct 2022 09:13:51 +0800
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
Subject: [PATCH net-next v7] net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy
Date:   Tue, 18 Oct 2022 09:14:39 +0800
Message-Id: <20221018011439.1169-1-Frank.Sae@motor-comm.com>
X-Mailer: git-send-email 2.31.0.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
 the driver on StarFive VisionFive development board, which is developed by
 Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
 phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
 wol(magic package).

Signed-off-by: Frank <Frank.Sae@motor-comm.com>
---
patch v7:
 Hi Russell

> As previously pointed out, dropping the MDIO bus lock in a
> phy_select_page()..phy_restore_page() region unsafe. I think you need
> to ensure that yt8521_fiber_config_aneg() is safe to be called under
> the lock, and I suspect having a version of genphy_config_aneg() which
> can be called with the lock held would be a better approach.

 with your suggestion we add yt8521_set_page() which does not hold the lock.


patch v6:
 Hi Andrew

> You appear to only advertise 1G speeds. Does 100M actually work, but
> you don't advertise it?
 yes, surely 100M fibre does work and since Fiber 100M advertise
 bit(ADVERTISE_100FULL) is conflict with ADVERTISE_1000XPSE_ASYM we
 can only advertise the latter.

> This is another place the two line side model falls apart. You should
> not be modifying phydev->supported, because how do you get back the
> bits your cleared when it swaps from one to the other? phylib has no
> concept of phydev->supported changing at run time. It is set when the
> PHY probes, and only changed when the MAC remove what it does not
> support.
> 
> You need yt8521_fiber_config_aneg() to take a copy of
> phydev->advertising, mask out what fibre does not support, and program
> the hardware based on that. You need yt8521_utp_config_aneg() to take
> a copy of phydev->advertising, mask out what copper does not support,
> and program the hardware based on that. phydev->supported and
> phydev->advertising should always be a superset of both copper and
> fibre, if both are available.
> 
> Maybe, in a flow up patch, you can actually look at
> phydev->advertising, see all the fibre modes have been removed, fibre
> will never get link, and so power the fibre off. Or all the copper
> modes have been removed, the copper will never get link, so turn it
> off.
 We add combo_advertising which is used for case of YT8521 in combo mode,
 this means that yt8521 may work in utp or fiber mode which depends
 on which media is connected. Advertising bits will be updated before calling
 yt8521_fiber_config_aneg/genphy_config_aneg.

patch v5:
 Hi Jakub,Andrew,Russell

> The user could of changed the pause settings, which are going to be
> ignored here. Also, you should not assume the MAC can actually do
> asymmetric pause, not all can. phydev->advertising will be set to only
> include what the MAC can actually do.
> 
> The whole concept of having two line sides connected to one MAC and
> seeing which gets link first is unsupported in Linux. In theory, you
> want to be able to configure each line side differently. Maybe you
> want autoneg on copper, but fixed on fibre, asymmetric pause with
> fibre, but symmetric pause on copper, etc. Since there is only one
> instance of phydev here, you don't have anywhere to store two sets of
> configuration, nor any sort of kAPI to deal with two phydev structures
> etc. So the user experience is not so great.
> 
> With the Marvell Switches which also have this capability, i actually
> ignore it, use the phy-mode it decide which should be used, either
> copper or fibre, and leave the other powered off so it can never get
> link. There is at least one Marvell PHY which does however support
> first up wins, so this behaviour is not new. I just don't recommend
> it.
> 
> And it gets even more interesting when the SFP is actually copper. But
> not supported here.
> since the integration with phylink is missing in this driver, that is

1. we changed the codes for getting/advertising of pause and other
 capabilities, the basic mechnism is that the capabilities and
 advertising will changed based on current linkuped media,
 please review.
2. as to the fibre/copper two lines support, this phy driver will
 handle to ensure linkup only on one media and it is transparent
 to MAC and uplayer. in practice, this do help users use the
 feature of the phy device, especially for the combo mode
 design in which customer can switch between fibre and
 copper automatically.  

patch v4.4:
 Hi Jakub
 Fix "warning: variable 'changed'"
 
patch v4.3:
 Hi Jakub
 Kernel 6.0-rc1 is cut on 2022-08-14, we update new patch for Kernel 6.0-rc1.

patch v4.2:
 fix "=0D" and "=20" which in patch v4.1.
 
patch v4.1:
 Hi Andrew
 Thanks very much and based on your comments we modified the patch v4.1 as below.

> You have interrupt bits defined, you enable the WoL interrupt, but you
> don't have an interrupt handler. PHY interrupts are generally level
> interrupts, so on WoL, don't you end up with an interrupt storm,
> because you don't have anything clearing the WoL interrupt?

 in the driver, only the interrupt for WOL is used according to uplayer WOL
 configuration via .set_wol. If WOL is enalbed, then the WOL interrupt is
 enabled accordingly; you know, for a system support WOL, the WOL interrupt
 will be handled by user's WOL circuit, and it will not cause interrupt storm
 to CPU core system.

 for WOL interrupt, by default, we configure to pulse trigger mode, that is a
 pulse from High to low change, and the low level will hold for 672ms.
 user's WOL circuit will detected such volt level change as a WOL event trigger.

patch v4:
 Hi Andrew,Jakub
 Thanks very much and based on your comments we modified the patch v4 as below.

 We evaluated the Marvell 10G driver and at803x you suggested. The 2 drivers
 implement SFP module attach/detach functions and we think these functions do
 not help yt8521 to do UTP/Fiber register space arbitration which you may
 concern in previous patch.

 Yt8521 can detect utp/fiber media link status automatically. For the case of
 both media are connected, driver arbitrates the priority of the media (by
 default, driver takes fiber as higher priority) and report the media status
 to up layer(MAC).

patch v3:
 Hi Andrew
 Thanks and based on your comments we modified the patch as below.

> It is generally not that simple. Fibre, you probably want 1000BaseX,
> unless the fibre module is actually copper, and then you want
> SGMII. So you need something to talk to the fibre module and ask it
> what it is. That something is phylink. Phylink does not support both
> copper and fibre at the same time for one MAC.

 yes, you said it and for MAC, it does not support copper and Fiber at same time.
 but from Physical Layer, you know, sometimes both Copper and Fiber cables are
 connected. in this case, Phy driver should do arbitration and report to MAC
 which media should be used and Link-up.
 This is the reason that the driver has a "polling mode", and by default, also
 this driver takes fiber as first priority which matches phy chip default behavior.

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

Thanks and BR,
Frank


 MAINTAINERS                 |    1 +
 drivers/net/phy/Kconfig     |    2 +-
 drivers/net/phy/motorcomm.c | 1401 ++++++++++++++++++++++++++++++++++-
 3 files changed, 1401 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index a96c60c787af..922cd832eed1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13937,6 +13937,7 @@ F:	include/uapi/linux/meye.h
 
 MOTORCOMM PHY DRIVER
 M:	Peter Geis <pgwipeout@gmail.com>
+M:	Frank <Frank.Sae@motor-comm.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/phy/motorcomm.c
diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index c57a0262fb64..040c8bf6d05b 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -260,7 +260,7 @@ config MOTORCOMM_PHY
 	tristate "Motorcomm PHYs"
 	help
 	  Enables support for Motorcomm network PHYs.
-	  Currently supports the YT8511 gigabit PHY.
+	  Currently supports the YT8511, YT8521 Gigabit Ethernet PHYs.
 
 config NATIONAL_PHY
 	tristate "National Semiconductor PHYs"
diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
index 7e6ac2c5e27e..6792c9fb93fb 100644
--- a/drivers/net/phy/motorcomm.c
+++ b/drivers/net/phy/motorcomm.c
@@ -1,15 +1,106 @@
 // SPDX-License-Identifier: GPL-2.0+
 /*
- * Driver for Motorcomm PHYs
+ * Motorcomm 8511/8521 PHY driver.
  *
  * Author: Peter Geis <pgwipeout@gmail.com>
+ * Author: Frank <Frank.Sae@motor-comm.com>
  */
 
+#include <linux/etherdevice.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/phy.h>
 
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
+#define YTPHY_SSR_SPEED_MODE_MASK		(BIT(15) | BIT(14))
+#define YTPHY_SSR_SPEED_10M			0x0
+#define YTPHY_SSR_SPEED_100M			0x1
+#define YTPHY_SSR_SPEED_1000M			0x2
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
+#define YTPHY_IER_WOL				BIT(6)
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
+
+/* FIBER Auto-Negotiation link partner ability */
+#define YTPHY_FLPA_PAUSE			(0x3 << 7)
+#define YTPHY_FLPA_ASYM_PAUSE			(0x2 << 7)
 
 #define YT8511_PAGE_SELECT	0x1e
 #define YT8511_PAGE		0x1f
@@ -38,6 +129,352 @@
 #define YT8511_DELAY_FE_TX_EN	(0xf << 12)
 #define YT8511_DELAY_FE_TX_DIS	(0x2 << 12)
 
+/* Extended register is different from MMD Register and MII Register.
+ * We can use ytphy_read_ext/ytphy_write_ext/ytphy_modify_ext function to
+ * operate extended register.
+ * Extended Register  start
+ */
+
+/* Phy gmii clock gating Register */
+#define YT8521_CLOCK_GATING_REG			0xC
+#define YT8521_CGR_RX_CLK_EN			BIT(12)
+
+#define YT8521_EXTREG_SLEEP_CONTROL1_REG	0x27
+#define YT8521_ESC1R_SLEEP_SW			BIT(15)
+#define YT8521_ESC1R_PLLON_SLP			BIT(14)
+
+/* Phy fiber Link timer cfg2 Register */
+#define YT8521_LINK_TIMER_CFG2_REG		0xA5
+#define YT8521_LTCR_EN_AUTOSEN			BIT(15)
+
+/* 0xA000, 0xA001, 0xA003 ,and 0xA006 ~ 0xA00A  are common ext registers
+ * of yt8521 phy. There is no need to switch reg space when operating these
+ * registers.
+ */
+
+#define YT8521_REG_SPACE_SELECT_REG		0xA000
+#define YT8521_RSSR_SPACE_MASK			BIT(1)
+#define YT8521_RSSR_FIBER_SPACE			(0x1 << 1)
+#define YT8521_RSSR_UTP_SPACE			(0x0 << 1)
+#define YT8521_RSSR_TO_BE_ARBITRATED		(0xFF)
+
+#define YT8521_CHIP_CONFIG_REG			0xA001
+#define YT8521_CCR_SW_RST			BIT(15)
+
+#define YT8521_CCR_MODE_SEL_MASK		(BIT(2) | BIT(1) | BIT(0))
+#define YT8521_CCR_MODE_UTP_TO_RGMII		0
+#define YT8521_CCR_MODE_FIBER_TO_RGMII		1
+#define YT8521_CCR_MODE_UTP_FIBER_TO_RGMII	2
+#define YT8521_CCR_MODE_UTP_TO_SGMII		3
+#define YT8521_CCR_MODE_SGPHY_TO_RGMAC		4
+#define YT8521_CCR_MODE_SGMAC_TO_RGPHY		5
+#define YT8521_CCR_MODE_UTP_TO_FIBER_AUTO	6
+#define YT8521_CCR_MODE_UTP_TO_FIBER_FORCE	7
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
+#define YTPHY_MISC_CONFIG_REG			0xA006
+#define YTPHY_MCR_FIBER_SPEED_MASK		BIT(0)
+#define YTPHY_MCR_FIBER_1000BX			(0x1 << 0)
+#define YTPHY_MCR_FIBER_100FX			(0x0 << 0)
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
+#define YTPHY_WCR_PULSE_WIDTH_MASK		(BIT(2) | BIT(1))
+#define YTPHY_WCR_PULSE_WIDTH_672MS		(BIT(2) | BIT(1))
+
+/* 1b0 Interrupt and WOL events is level triggered and active LOW  *default*
+ * 1b1 Interrupt and WOL events is pulse triggered and active LOW
+ */
+#define YTPHY_WCR_TYPE_PULSE			BIT(0)
+
+/* Extended Register  end */
+
+struct yt8521_priv {
+	/* combo_advertising is used for case of YT8521 in combo mode,
+	 * this means that yt8521 may work in utp or fiber mode which depends
+	 * on which media is connected (YT8521_RSSR_TO_BE_ARBITRATED).
+	 */
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(combo_advertising);
+
+	/* YT8521_MODE_FIBER / YT8521_MODE_UTP / YT8521_MODE_POLL*/
+	u8 polling_mode;
+	u8 strap_mode; /* 8 working modes  */
+	/* current reg page of yt8521 phy:
+	 * YT8521_RSSR_UTP_SPACE
+	 * YT8521_RSSR_FIBER_SPACE
+	 * YT8521_RSSR_TO_BE_ARBITRATED
+	 */
+	u8 reg_page;
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
+ * ytphy_read_ext_with_lock() - read a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to read
+ *
+ * returns the value of regnum reg or negative error code
+ */
+static int ytphy_read_ext_with_lock(struct phy_device *phydev, u16 regnum)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = ytphy_read_ext(phydev, regnum);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
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
+ * ytphy_write_ext_with_lock() - write a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to write
+ * @val: value to write to @regnum
+ *
+ * returns 0 or negative error code
+ */
+static int ytphy_write_ext_with_lock(struct phy_device *phydev, u16 regnum,
+				     u16 val)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = ytphy_write_ext(phydev, regnum, val);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
+}
+
+/**
+ * ytphy_modify_ext() - bits modify a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * NOTE: Convenience function which allows a PHY's extended register to be
+ * modified as new register value = (old register value & ~mask) | set.
+ * The caller must have taken the MDIO bus lock.
+ *
+ * returns 0 or negative error code
+ */
+static int ytphy_modify_ext(struct phy_device *phydev, u16 regnum, u16 mask,
+			    u16 set)
+{
+	int ret;
+
+	ret = __phy_write(phydev, YTPHY_PAGE_SELECT, regnum);
+	if (ret < 0)
+		return ret;
+
+	return __phy_modify(phydev, YTPHY_PAGE_DATA, mask, set);
+}
+
+/**
+ * ytphy_modify_ext_with_lock() - bits modify a PHY's extended register
+ * @phydev: a pointer to a &struct phy_device
+ * @regnum: register number to write
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * NOTE: Convenience function which allows a PHY's extended register to be
+ * modified as new register value = (old register value & ~mask) | set.
+ *
+ * returns 0 or negative error code
+ */
+static int ytphy_modify_ext_with_lock(struct phy_device *phydev, u16 regnum,
+				      u16 mask, u16 set)
+{
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = ytphy_modify_ext(phydev, regnum, mask, set);
+	phy_unlock_mdio_bus(phydev);
+
+	return ret;
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
+	wol_config = ytphy_read_ext_with_lock(phydev, YTPHY_WOL_CONFIG_REG);
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
+ * and YTPHY_WOL_MACADDR0_REG are common ext reg. The
+ * YTPHY_INTERRUPT_ENABLE_REG of UTP is special, fiber also use this register.
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
+		mask = YTPHY_WCR_PULSE_WIDTH_MASK | YTPHY_WCR_INTR_SEL;
+		val = YTPHY_WCR_ENABLE | YTPHY_WCR_INTR_SEL;
+		val |= YTPHY_WCR_TYPE_PULSE | YTPHY_WCR_PULSE_WIDTH_672MS;
+		ret = ytphy_modify_ext(phydev, YTPHY_WOL_CONFIG_REG, mask, val);
+		if (ret < 0)
+			goto err_restore_page;
+
+		/* Enable WOL interrupt */
+		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG, 0,
+				   YTPHY_IER_WOL);
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
+		ret = __phy_modify(phydev, YTPHY_INTERRUPT_ENABLE_REG,
+				   YTPHY_IER_WOL, 0);
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
@@ -111,6 +548,947 @@ static int yt8511_config_init(struct phy_device *phydev)
 	return phy_restore_page(phydev, oldpage, ret);
 }
 
+/**
+ * yt8521_read_page() - read reg page
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns current reg space of yt8521 (YT8521_RSSR_FIBER_SPACE/
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
+ * yt8521_set_page() - save current page and set to a new page
+ * @phydev: a pointer to a &struct phy_device
+ * @new_page: desired page
+ * @old_page: a pointer to save current page. if it is NULL, don’t save page.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_set_page(struct phy_device *phydev, int new_page,
+			   int *old_page)
+{
+	int read_page;
+	int ret;
+
+	phy_lock_mdio_bus(phydev);
+	ret = yt8521_read_page(phydev);
+	if (ret < 0)
+		goto err_unlock_mdio_bus;
+	read_page = ret;
+
+	ret = 0;
+	if (read_page != new_page) {
+		ret = yt8521_write_page(phydev, new_page);
+		if (ret < 0)
+			goto err_unlock_mdio_bus;
+	}
+
+	if (old_page)
+		*old_page = read_page;
+
+err_unlock_mdio_bus:
+	phy_unlock_mdio_bus(phydev);
+	return ret;
+}
+
+/**
+ * yt8521_probe() - read chip config then set suitable polling_mode
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_probe(struct phy_device *phydev)
+{
+	struct device *dev = &phydev->mdio.dev;
+	struct yt8521_priv *priv;
+	int chip_config;
+	int ret;
+
+	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	phydev->priv = priv;
+
+	chip_config = ytphy_read_ext_with_lock(phydev, YT8521_CHIP_CONFIG_REG);
+	if (chip_config < 0)
+		return chip_config;
+
+	priv->strap_mode = chip_config & YT8521_CCR_MODE_SEL_MASK;
+	switch (priv->strap_mode) {
+	case YT8521_CCR_MODE_FIBER_TO_RGMII:
+	case YT8521_CCR_MODE_SGPHY_TO_RGMAC:
+	case YT8521_CCR_MODE_SGMAC_TO_RGPHY:
+		priv->polling_mode = YT8521_MODE_FIBER;
+		priv->reg_page = YT8521_RSSR_FIBER_SPACE;
+		phydev->port = PORT_FIBRE;
+		break;
+	case YT8521_CCR_MODE_UTP_FIBER_TO_RGMII:
+	case YT8521_CCR_MODE_UTP_TO_FIBER_AUTO:
+	case YT8521_CCR_MODE_UTP_TO_FIBER_FORCE:
+		priv->polling_mode = YT8521_MODE_POLL;
+		priv->reg_page = YT8521_RSSR_TO_BE_ARBITRATED;
+		phydev->port = PORT_NONE;
+		break;
+	case YT8521_CCR_MODE_UTP_TO_SGMII:
+	case YT8521_CCR_MODE_UTP_TO_RGMII:
+		priv->polling_mode = YT8521_MODE_UTP;
+		priv->reg_page = YT8521_RSSR_UTP_SPACE;
+		phydev->port = PORT_TP;
+		break;
+	}
+	/* set default reg space */
+	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
+		ret = ytphy_write_ext_with_lock(phydev,
+						YT8521_REG_SPACE_SELECT_REG,
+						priv->reg_page);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * yt8521_adjust_status() - update speed and duplex to phydev. when in fiber
+ * mode, adjust speed and duplex.
+ *
+ * @phydev: a pointer to a &struct phy_device
+ * @status: yt8521 status read from YTPHY_SPECIFIC_STATUS_REG
+ * @is_utp: false(yt8521 work in fiber mode) or true(yt8521 work in utp mode)
+ *
+ * returns 0
+ */
+static int yt8521_adjust_status(struct phy_device *phydev, int status,
+				bool is_utp)
+{
+	int speed_mode, duplex;
+	int speed;
+	int err;
+	int lpa;
+
+	if (is_utp)
+		duplex = (status & YTPHY_SSR_DUPLEX) >> YTPHY_SSR_DUPLEX_OFFSET;
+	else
+		duplex = DUPLEX_FULL;	/* for fiber, it always DUPLEX_FULL */
+
+	speed_mode = (status & YTPHY_SSR_SPEED_MODE_MASK) >>
+		     YTPHY_SSR_SPEED_MODE_OFFSET;
+
+	switch (speed_mode) {
+	case YTPHY_SSR_SPEED_10M:
+		if (is_utp)
+			speed = SPEED_10;
+		else
+			/* for fiber, it will never run here, default to
+			 * SPEED_UNKNOWN
+			 */
+			speed = SPEED_UNKNOWN;
+		break;
+	case YTPHY_SSR_SPEED_100M:
+		speed = SPEED_100;
+		break;
+	case YTPHY_SSR_SPEED_1000M:
+		speed = SPEED_1000;
+		break;
+	default:
+		speed = SPEED_UNKNOWN;
+		break;
+	}
+
+	phydev->speed = speed;
+	phydev->duplex = duplex;
+
+	if (is_utp) {
+		err = genphy_read_lpa(phydev);
+		if (err < 0)
+			return err;
+
+		phy_resolve_aneg_pause(phydev);
+	} else {
+		lpa = phy_read(phydev, MII_LPA);
+		if (lpa < 0)
+			return lpa;
+
+		/* only support 1000baseX Full */
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT,
+				 phydev->lp_advertising, lpa & LPA_1000XFULL);
+
+		if (!(lpa & YTPHY_FLPA_PAUSE)) {
+			phydev->pause = 0;
+			phydev->asym_pause = 0;
+		} else if ((lpa & YTPHY_FLPA_ASYM_PAUSE)) {
+			phydev->pause = 1;
+			phydev->asym_pause = 1;
+		} else {
+			phydev->pause = 1;
+			phydev->asym_pause = 0;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * yt8521_read_status_paged() -  determines the speed and duplex of one page
+ * @phydev: a pointer to a &struct phy_device
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to
+ * operate.
+ *
+ * returns 1 (utp or fiber link),0 (no link) or negative errno code
+ */
+static int yt8521_read_status_paged(struct phy_device *phydev, int page)
+{
+	int fiber_latch_val;
+	int fiber_curr_val;
+	int old_page;
+	int status;
+	int link;
+	int ret;
+
+	linkmode_zero(phydev->lp_advertising);
+	phydev->duplex = DUPLEX_UNKNOWN;
+	phydev->speed = SPEED_UNKNOWN;
+	phydev->asym_pause = 0;
+	phydev->pause = 0;
+
+	/* YT8521 has two reg space (utp/fiber) for linkup with utp/fiber
+	 * respectively. but for utp/fiber combo mode, reg space should be
+	 * arbitrated based on media priority. by default, utp takes
+	 * priority. reg space should be properly set before read
+	 * YTPHY_SPECIFIC_STATUS_REG.
+	 */
+
+	page &= YT8521_RSSR_SPACE_MASK;
+	ret = yt8521_set_page(phydev, page, &old_page);
+	if (ret < 0)
+		return ret;
+
+	/* Read YTPHY_SPECIFIC_STATUS_REG, which indicates the speed and duplex
+	 * of the PHY is actually using.
+	 */
+	ret = phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
+	if (ret < 0)
+		goto err_restore_page;
+
+	status = ret;
+	link = !!(status & YTPHY_SSR_LINK);
+
+	/* When PHY is in fiber mode, speed transferred from 1000Mbps to
+	 * 100Mbps,there is not link down from YTPHY_SPECIFIC_STATUS_REG, so
+	 * we need check MII_BMSR to identify such case.
+	 */
+	if (page == YT8521_RSSR_FIBER_SPACE) {
+		ret = phy_read(phydev, MII_BMSR);
+		if (ret < 0)
+			goto err_restore_page;
+
+		fiber_latch_val = ret;
+		ret = phy_read(phydev, MII_BMSR);
+		if (ret < 0)
+			goto err_restore_page;
+
+		fiber_curr_val = ret;
+		if (link && fiber_latch_val != fiber_curr_val) {
+			link = 0;
+			phydev_info(phydev,
+				    "%s, fiber link down detect, latch = %04x, curr = %04x\n",
+				    __func__, fiber_latch_val, fiber_curr_val);
+		}
+	} else {
+		/* Read autonegotiation status */
+		ret = phy_read(phydev, MII_BMSR);
+		if (ret < 0)
+			return ret;
+
+		phydev->autoneg_complete = ret & BMSR_ANEGCOMPLETE ? 1 : 0;
+	}
+
+	if (link) {
+		if (page == YT8521_RSSR_UTP_SPACE)
+			yt8521_adjust_status(phydev, status, true);
+		else
+			yt8521_adjust_status(phydev, status, false);
+	}
+
+	ret = yt8521_set_page(phydev, old_page, NULL);
+	if (ret < 0)
+		return ret;
+
+	return link;
+
+err_restore_page:
+	yt8521_set_page(phydev, old_page, NULL);
+	return ret;
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
+	int link_fiber = 0;
+	int link_utp;
+	int link;
+	int ret;
+
+	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
+		link = yt8521_read_status_paged(phydev, priv->reg_page);
+		if (link < 0)
+			return link;
+	} else {
+		/* when page is YT8521_RSSR_TO_BE_ARBITRATED, arbitration is
+		 * needed. by default, utp is higher priority.
+		 */
+
+		link_utp = yt8521_read_status_paged(phydev,
+						    YT8521_RSSR_UTP_SPACE);
+		if (link_utp < 0)
+			return link_utp;
+
+		if (!link_utp) {
+			link_fiber = yt8521_read_status_paged(phydev,
+							      YT8521_RSSR_FIBER_SPACE);
+			if (link_fiber < 0)
+				return link_fiber;
+		}
+
+		link = link_utp || link_fiber;
+	}
+
+	if (link) {
+		if (phydev->link == 0) {
+			/* arbitrate reg space based on linkup media type. */
+			if (priv->polling_mode == YT8521_MODE_POLL &&
+			    priv->reg_page == YT8521_RSSR_TO_BE_ARBITRATED) {
+				if (link_fiber)
+					priv->reg_page =
+						YT8521_RSSR_FIBER_SPACE;
+				else
+					priv->reg_page = YT8521_RSSR_UTP_SPACE;
+
+				ret = ytphy_write_ext_with_lock(phydev,
+								YT8521_REG_SPACE_SELECT_REG,
+								priv->reg_page);
+				if (ret < 0)
+					return ret;
+
+				phydev->port = link_fiber ? PORT_FIBRE : PORT_TP;
+
+				phydev_info(phydev, "%s, link up, media: %s\n",
+					    __func__,
+					    (phydev->port == PORT_TP) ?
+					    "UTP" : "Fiber");
+			}
+		}
+		phydev->link = 1;
+	} else {
+		if (phydev->link == 1) {
+			phydev_info(phydev, "%s, link down, media: %s\n",
+				    __func__, (phydev->port == PORT_TP) ?
+				    "UTP" : "Fiber");
+
+			/* When in YT8521_MODE_POLL mode, need prepare for next
+			 * arbitration.
+			 */
+			if (priv->polling_mode == YT8521_MODE_POLL) {
+				priv->reg_page = YT8521_RSSR_TO_BE_ARBITRATED;
+				phydev->port = PORT_NONE;
+			}
+		}
+
+		phydev->link = 0;
+	}
+
+	return 0;
+}
+
+/**
+ * yt8521_modify_bmcr_paged - bits modify a PHY's BMCR register of one page
+ * @phydev: the phy_device struct
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to operate
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * NOTE: Convenience function which allows a PHY's BMCR register to be
+ * modified as new register value = (old register value & ~mask) | set.
+ * YT8521 has two space (utp/fiber) and three mode (utp/fiber/poll), each space
+ * has MII_BMCR. poll mode combines utp and faber,so need do both.
+ * If it is reset, it will wait for completion.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_modify_bmcr_paged(struct phy_device *phydev, int page,
+				    u16 mask, u16 set)
+{
+	int max_cnt = 500; /* the max wait time of reset ~ 500 ms */
+	int old_page;
+	int ret = 0;
+
+	old_page = phy_select_page(phydev, page & YT8521_RSSR_SPACE_MASK);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	ret = __phy_modify(phydev, MII_BMCR, mask, set);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* If it is reset, need to wait for the reset to complete */
+	if (set == BMCR_RESET) {
+		while (max_cnt--) {
+			usleep_range(1000, 1100);
+			ret = __phy_read(phydev, MII_BMCR);
+			if (ret < 0)
+				goto err_restore_page;
+
+			if (!(ret & BMCR_RESET))
+				return phy_restore_page(phydev, old_page, 0);
+		}
+		if (max_cnt <= 0)
+			ret = -ETIMEDOUT;
+	}
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_modify_utp_fiber_bmcr - bits modify a PHY's BMCR register
+ * @phydev: the phy_device struct
+ * @mask: bit mask of bits to clear
+ * @set: bit mask of bits to set
+ *
+ * NOTE: Convenience function which allows a PHY's BMCR register to be
+ * modified as new register value = (old register value & ~mask) | set.
+ * YT8521 has two space (utp/fiber) and three mode (utp/fiber/poll), each space
+ * has MII_BMCR. poll mode combines utp and faber,so need do both.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_modify_utp_fiber_bmcr(struct phy_device *phydev, u16 mask,
+					u16 set)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	int ret;
+
+	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
+		ret = yt8521_modify_bmcr_paged(phydev, priv->reg_page, mask,
+					       set);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = yt8521_modify_bmcr_paged(phydev, YT8521_RSSR_UTP_SPACE,
+					       mask, set);
+		if (ret < 0)
+			return ret;
+
+		ret = yt8521_modify_bmcr_paged(phydev, YT8521_RSSR_FIBER_SPACE,
+					       mask, set);
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
+static int yt8521_soft_reset(struct phy_device *phydev)
+{
+	return yt8521_modify_utp_fiber_bmcr(phydev, 0, BMCR_RESET);
+}
+
+/**
+ * yt8521_suspend() - suspend the hardware
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_suspend(struct phy_device *phydev)
+{
+	int wol_config;
+
+	/* YTPHY_WOL_CONFIG_REG is common ext reg */
+	wol_config = ytphy_read_ext_with_lock(phydev, YTPHY_WOL_CONFIG_REG);
+	if (wol_config < 0)
+		return wol_config;
+
+	/* if wol enable, do nothing */
+	if (wol_config & YTPHY_WCR_ENABLE)
+		return 0;
+
+	return yt8521_modify_utp_fiber_bmcr(phydev, 0, BMCR_PDOWN);
+}
+
+/**
+ * yt8521_resume() - resume the hardware
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_resume(struct phy_device *phydev)
+{
+	int ret;
+	int wol_config;
+
+	/* disable auto sleep */
+	ret = ytphy_modify_ext_with_lock(phydev,
+					 YT8521_EXTREG_SLEEP_CONTROL1_REG,
+					 YT8521_ESC1R_SLEEP_SW, 0);
+	if (ret < 0)
+		return ret;
+
+	wol_config = ytphy_read_ext_with_lock(phydev, YTPHY_WOL_CONFIG_REG);
+	if (wol_config < 0)
+		return wol_config;
+
+	/* if wol enable, do nothing */
+	if (wol_config & YTPHY_WCR_ENABLE)
+		return 0;
+
+	return yt8521_modify_utp_fiber_bmcr(phydev, BMCR_PDOWN, 0);
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
+	u16 val;
+
+	old_page = phy_select_page(phydev, YT8521_RSSR_UTP_SPACE);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	switch (phydev->interface) {
+	case PHY_INTERFACE_MODE_RGMII:
+		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_GE_TX_DELAY_DIS;
+		val |= YT8521_RC1R_RX_DELAY_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_RXID:
+		val = YT8521_RC1R_GE_TX_DELAY_DIS | YT8521_RC1R_GE_TX_DELAY_DIS;
+		val |= YT8521_RC1R_RX_DELAY_EN;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_TXID:
+		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_GE_TX_DELAY_EN;
+		val |= YT8521_RC1R_RX_DELAY_DIS;
+		break;
+	case PHY_INTERFACE_MODE_RGMII_ID:
+		val = YT8521_RC1R_GE_TX_DELAY_EN | YT8521_RC1R_GE_TX_DELAY_EN;
+		val |= YT8521_RC1R_RX_DELAY_EN;
+		break;
+	case PHY_INTERFACE_MODE_SGMII:
+		break;
+	default: /* do not support other modes */
+		ret = -EOPNOTSUPP;
+		goto err_restore_page;
+	}
+
+	/* set rgmii delay mode */
+	if (phydev->interface != PHY_INTERFACE_MODE_SGMII) {
+		ret = ytphy_modify_ext(phydev, YT8521_RGMII_CONFIG1_REG,
+				       (YT8521_RC1R_RX_DELAY_MASK |
+				       YT8521_RC1R_FE_TX_DELAY_MASK |
+				       YT8521_RC1R_GE_TX_DELAY_MASK),
+				       val);
+		if (ret < 0)
+			goto err_restore_page;
+	}
+
+	/* disable auto sleep */
+	ret = ytphy_modify_ext(phydev, YT8521_EXTREG_SLEEP_CONTROL1_REG,
+			       YT8521_ESC1R_SLEEP_SW, 0);
+	if (ret < 0)
+		goto err_restore_page;
+
+	/* enable RXC clock when no wire plug */
+	ret = ytphy_modify_ext(phydev, YT8521_CLOCK_GATING_REG,
+			       YT8521_CGR_RX_CLK_EN, 0);
+	if (ret < 0)
+		goto err_restore_page;
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_prepare_fiber_features() -  A small helper function that setup
+ * fiber's features.
+ * @phydev: a pointer to a &struct phy_device
+ * @dst: a pointer to store fiber's features
+ */
+static inline void yt8521_prepare_fiber_features(struct phy_device *phydev,
+						 unsigned long *dst)
+{
+	linkmode_set_bit(ETHTOOL_LINK_MODE_100baseFX_Full_BIT, dst);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseX_Full_BIT, dst);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, dst);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_FIBRE_BIT, dst);
+}
+
+/**
+ * yt8521_fiber_setup_forced - configures/forces speed from @phydev
+ * @phydev: target phy_device struct
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_fiber_setup_forced(struct phy_device *phydev)
+{
+	u16 val;
+	int ret;
+
+	if (phydev->speed == SPEED_1000)
+		val = YTPHY_MCR_FIBER_1000BX;
+	else if (phydev->speed == SPEED_100)
+		val = YTPHY_MCR_FIBER_100FX;
+	else
+		return -EINVAL;
+
+	ret =  phy_modify(phydev, MII_BMCR, BMCR_ANENABLE, 0);
+	if (ret < 0)
+		return ret;
+
+	/* disable Fiber auto sensing */
+	ret =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
+					  YT8521_LTCR_EN_AUTOSEN, 0);
+	if (ret < 0)
+		return ret;
+
+	ret =  ytphy_modify_ext_with_lock(phydev, YTPHY_MISC_CONFIG_REG,
+					  YTPHY_MCR_FIBER_SPEED_MASK, val);
+	if (ret < 0)
+		return ret;
+
+	ret =  ytphy_modify_ext_with_lock(phydev, YT8521_CHIP_CONFIG_REG,
+					  YT8521_CCR_SW_RST, 0);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/**
+ * yt8521_fiber_config_aneg - restart auto-negotiation or write
+ * YTPHY_MISC_CONFIG_REG.
+ * @phydev: target phy_device struct
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_fiber_config_aneg(struct phy_device *phydev)
+{
+	int err, changed = 0;
+	int bmcr;
+	u16 adv;
+
+	if (phydev->autoneg != AUTONEG_ENABLE)
+		return yt8521_fiber_setup_forced(phydev);
+
+	/* enable Fiber auto sensing */
+	err =  ytphy_modify_ext_with_lock(phydev, YT8521_LINK_TIMER_CFG2_REG,
+					  0, YT8521_LTCR_EN_AUTOSEN);
+	if (err < 0)
+		return err;
+
+	err =  ytphy_modify_ext_with_lock(phydev, YT8521_CHIP_CONFIG_REG,
+					  YT8521_CCR_SW_RST, 0);
+	if (err < 0)
+		return err;
+
+	bmcr = phy_read(phydev, MII_BMCR);
+	if (bmcr < 0)
+		return bmcr;
+
+	/* When it is coming from fiber forced mode, add bmcr power down
+	 * and power up to let aneg work fine.
+	 */
+	if (!(bmcr & BMCR_ANENABLE)) {
+		phy_modify(phydev, MII_BMCR, 0, BMCR_PDOWN);
+		usleep_range(1000, 1100);
+		phy_modify(phydev, MII_BMCR, BMCR_PDOWN, 0);
+	}
+
+	adv = linkmode_adv_to_mii_adv_x(phydev->advertising,
+					ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
+
+	/* Setup fiber advertisement */
+	err = phy_modify_changed(phydev, MII_ADVERTISE,
+				 ADVERTISE_1000XHALF | ADVERTISE_1000XFULL |
+				 ADVERTISE_1000XPAUSE | ADVERTISE_1000XPSE_ASYM,
+				 adv);
+	if (err < 0)
+		return err;
+
+	if (err > 0)
+		changed = 1;
+
+	return genphy_check_and_restart_aneg(phydev, changed);
+}
+
+/**
+ * yt8521_config_aneg_paged() - switch reg space then call genphy_config_aneg
+ * of one page
+ * @phydev: a pointer to a &struct phy_device
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to
+ * operate.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_config_aneg_paged(struct phy_device *phydev, int page)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(fiber_supported);
+	struct yt8521_priv *priv = phydev->priv;
+	int old_page;
+	int ret;
+
+	page &= YT8521_RSSR_SPACE_MASK;
+
+	ret = yt8521_set_page(phydev, page, &old_page);
+	if (ret < 0)
+		return ret;
+
+	/* If reg_page is YT8521_RSSR_TO_BE_ARBITRATED,
+	 * phydev->advertising should be updated.
+	 */
+	if (priv->reg_page == YT8521_RSSR_TO_BE_ARBITRATED) {
+		linkmode_zero(fiber_supported);
+		yt8521_prepare_fiber_features(phydev, fiber_supported);
+
+		/* prepare fiber_supported, then setup advertising. */
+		if (page == YT8521_RSSR_FIBER_SPACE) {
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Pause_BIT,
+					 fiber_supported);
+			linkmode_set_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+					 fiber_supported);
+			linkmode_and(phydev->advertising,
+				     priv->combo_advertising, fiber_supported);
+		} else {
+			/* ETHTOOL_LINK_MODE_Autoneg_BIT is also used in utp */
+			linkmode_clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+					   fiber_supported);
+			linkmode_andnot(phydev->advertising,
+					priv->combo_advertising,
+					fiber_supported);
+		}
+	}
+	if (page == YT8521_RSSR_FIBER_SPACE)
+		ret = yt8521_fiber_config_aneg(phydev);
+	else
+		ret = genphy_config_aneg(phydev);
+
+	return yt8521_set_page(phydev, old_page, NULL);
+}
+
+/**
+ * yt8521_config_aneg() - change reg space then call genphy_config_aneg
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_config_aneg(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	int ret;
+
+	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
+		ret = yt8521_config_aneg_paged(phydev, priv->reg_page);
+		if (ret < 0)
+			return ret;
+	} else {
+		/* If reg_page is YT8521_RSSR_TO_BE_ARBITRATED,
+		 * phydev->advertising need to be saved at first run.
+		 * Because it contains the advertising which supported by both
+		 * mac and yt8521(utp and fiber).
+		 */
+		if (linkmode_empty(priv->combo_advertising)) {
+			linkmode_copy(priv->combo_advertising,
+				      phydev->advertising);
+		}
+
+		ret = yt8521_config_aneg_paged(phydev, YT8521_RSSR_UTP_SPACE);
+		if (ret < 0)
+			return ret;
+
+		ret = yt8521_config_aneg_paged(phydev, YT8521_RSSR_FIBER_SPACE);
+		if (ret < 0)
+			return ret;
+
+		/* we don't known which will be link, so restore
+		 * phydev->advertising as default value.
+		 */
+		linkmode_copy(phydev->advertising, priv->combo_advertising);
+	}
+	return 0;
+}
+
+/**
+ * yt8521_aneg_done_paged() - determines the auto negotiation result of one
+ * page.
+ * @phydev: a pointer to a &struct phy_device
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to
+ * operate.
+ *
+ * returns 0(no link)or 1(fiber or utp link) or negative errno code
+ */
+static int yt8521_aneg_done_paged(struct phy_device *phydev, int page)
+{
+	int old_page;
+	int ret = 0;
+	int link;
+
+	old_page = phy_select_page(phydev, page & YT8521_RSSR_SPACE_MASK);
+	if (old_page < 0)
+		goto err_restore_page;
+
+	ret = __phy_read(phydev, YTPHY_SPECIFIC_STATUS_REG);
+	if (ret < 0)
+		goto err_restore_page;
+
+	link = !!(ret & YTPHY_SSR_LINK);
+	ret = link;
+
+err_restore_page:
+	return phy_restore_page(phydev, old_page, ret);
+}
+
+/**
+ * yt8521_aneg_done() - determines the auto negotiation result
+ * @phydev: a pointer to a &struct phy_device
+ *
+ * returns 0(no link)or 1(fiber or utp link) or negative errno code
+ */
+static int yt8521_aneg_done(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	int link_fiber = 0;
+	int link_utp;
+	int link;
+
+	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
+		link = yt8521_aneg_done_paged(phydev, priv->reg_page);
+	} else {
+		link_utp = yt8521_aneg_done_paged(phydev,
+						  YT8521_RSSR_UTP_SPACE);
+		if (link_utp < 0)
+			return link_utp;
+
+		if (!link_utp) {
+			link_fiber = yt8521_aneg_done_paged(phydev,
+							    YT8521_RSSR_FIBER_SPACE);
+			if (link_fiber < 0)
+				return link_fiber;
+		}
+		link = link_fiber || link_utp;
+		phydev_info(phydev, "%s, link_fiber: %d, link_utp: %d\n",
+			    __func__, link_fiber, link_utp);
+	}
+
+	return link;
+}
+
+/**
+ * yt8521_get_features_paged() -  read supported link modes for one page
+ * @phydev: a pointer to a &struct phy_device
+ * @page: The reg page(YT8521_RSSR_FIBER_SPACE/YT8521_RSSR_UTP_SPACE) to
+ * operate.
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_get_features_paged(struct phy_device *phydev, int page)
+{
+	int old_page;
+	int ret;
+
+	page &= YT8521_RSSR_SPACE_MASK;
+	ret = yt8521_set_page(phydev, page, &old_page);
+	if (ret < 0)
+		return ret;
+
+	if (page == YT8521_RSSR_FIBER_SPACE) {
+		linkmode_zero(phydev->supported);
+		yt8521_prepare_fiber_features(phydev, phydev->supported);
+	} else {
+		ret = genphy_read_abilities(phydev);
+		if (ret < 0)
+			goto err_restore_page;
+	}
+
+	return yt8521_set_page(phydev, old_page, NULL);
+
+err_restore_page:
+	yt8521_set_page(phydev, old_page, NULL);
+	return ret;
+}
+
+/**
+ * yt8521_get_features - switch reg space then call yt8521_get_features_paged
+ * @phydev: target phy_device struct
+ *
+ * returns 0 or negative errno code
+ */
+static int yt8521_get_features(struct phy_device *phydev)
+{
+	struct yt8521_priv *priv = phydev->priv;
+	int ret;
+
+	if (priv->reg_page != YT8521_RSSR_TO_BE_ARBITRATED) {
+		ret = yt8521_get_features_paged(phydev, priv->reg_page);
+	} else {
+		ret = yt8521_get_features_paged(phydev,
+						YT8521_RSSR_UTP_SPACE);
+		if (ret < 0)
+			return ret;
+
+		/* add fiber's features to phydev->supported */
+		yt8521_prepare_fiber_features(phydev, phydev->supported);
+	}
+	return ret;
+}
+
 static struct phy_driver motorcomm_phy_drvs[] = {
 	{
 		PHY_ID_MATCH_EXACT(PHY_ID_YT8511),
@@ -121,16 +1499,35 @@ static struct phy_driver motorcomm_phy_drvs[] = {
 		.read_page	= yt8511_read_page,
 		.write_page	= yt8511_write_page,
 	},
+	{
+		PHY_ID_MATCH_EXACT(PHY_ID_YT8521),
+		.name		= "YT8521 Gigabit Ethernet",
+		.get_features	= yt8521_get_features,
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

