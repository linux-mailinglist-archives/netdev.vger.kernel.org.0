Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF5C6D3D8F
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjDCGsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbjDCGsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:48:05 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824C74206
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:48:01 -0700 (PDT)
X-QQ-mid: bizesmtp63t1680504436ts163cfa
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 03 Apr 2023 14:47:15 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000B00A0000000
X-QQ-FEAT: jXjag1m6xl62P+H16ZOwvK6Fo047nLvUr41A7ZnWCnawuFiZCaZYdf1a5847x
        DlJjUOyIQTEUCa1FsAqWok6GzCuWiOhxoLfeIDxxV0j7iqOQtIHJORdzq8EA1gMZinb9G6L
        rtC/soowTe+7rJNwIDO3iOk1ivOlAjDQ2TZfdaynY0dYbTWHsa9IVzSJSwBYqc4Rc9XxG1w
        vtWUs5ukzhEpMO6BmgbqBZRd2dckZb4/xaT+IWlOgrsNqdZVoVEcBkj69pEgsTjTGgT4Q6K
        kQCR1W9Ds7VPD9FfiTYgP10UNQ/poBR6P1TJGBal0XdVmdjKghTb+tlpCWHHtElPiTluEas
        6Hykog8xt4YmIzlte83jqQLJGoTigHluLDt7EmijLJWewlEhazsxiIoJ03IUYJLQIH3WeFX
        Az2dTi3wtdg=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 16965943134361158160
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 5/6] net: txgbe: Implement phylink pcs
Date:   Mon,  3 Apr 2023 14:45:27 +0800
Message-Id: <20230403064528.343866-6-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230403064528.343866-1-jiawenwu@trustnetic.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register MDIO bus for PCS layer, support 10GBASE-R and 1000BASE-X
interfaces to the controller.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 371 +++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  56 +++
 3 files changed, 423 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index d9cccdad8a53..9e374e9c3d9c 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -42,6 +42,7 @@ config TXGBE
 	depends on PCI
 	select GPIOLIB_IRQCHIP
 	select GPIOLIB
+	select PHYLINK
 	select LIBWX
 	select I2C
 	select SFP
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index fe51485a9b68..a00651ba021f 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -6,7 +6,9 @@
 #include <linux/gpio/machine.h>
 #include <linux/gpio/driver.h>
 #include <linux/gpio/property.h>
+#include <linux/phylink.h>
 #include <linux/iopoll.h>
+#include <linux/mdio.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
 
@@ -67,6 +69,344 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
 }
 
+static int pcs_read(struct txgbe *txgbe, int dev, u32 reg)
+{
+	return mdiodev_c45_read(txgbe->mdiodev, dev, reg);
+}
+
+static int pcs_write(struct txgbe *txgbe, int dev, u32 reg, u16 val)
+{
+	return mdiodev_c45_write(txgbe->mdiodev, dev, reg, val);
+}
+
+static int pma_read(struct txgbe *txgbe, u32 reg)
+{
+	return pcs_read(txgbe, MDIO_MMD_PMAPMD, TXGBE_PMA_MMD + reg);
+}
+
+static int pma_write(struct txgbe *txgbe, u32 reg, u16 val)
+{
+	return pcs_write(txgbe, MDIO_MMD_PMAPMD, TXGBE_PMA_MMD + reg, val);
+}
+
+static int txgbe_pcs_read(struct mii_bus *bus, int addr, int devnum, int regnum)
+{
+	struct wx *wx  = bus->priv;
+	u32 offset, val;
+
+	offset = devnum << 16 | regnum;
+
+	/* Set the LAN port indicator to IDA_ADDR */
+	wr32(wx, TXGBE_XPCS_IDA_ADDR, offset);
+
+	/* Read the data from IDA_DATA register */
+	val = rd32(wx, TXGBE_XPCS_IDA_DATA);
+
+	return (u16)val;
+}
+
+static int txgbe_pcs_write(struct mii_bus *bus, int addr, int devnum, int regnum, u16 val)
+{
+	struct wx *wx = bus->priv;
+	u32 offset;
+
+	offset = devnum << 16 | regnum;
+
+	/* Set the LAN port indicator to IDA_ADDR */
+	wr32(wx, TXGBE_XPCS_IDA_ADDR, offset);
+
+	/* Write the data to IDA_DATA register */
+	wr32(wx, TXGBE_XPCS_IDA_DATA, val);
+
+	return 0;
+}
+
+static void txgbe_ephy_write(struct txgbe *txgbe, u32 addr, u32 data)
+{
+	struct wx *wx = txgbe->wx;
+
+	/* Set the LAN port indicator to IDA_ADDR */
+	wr32(wx, TXGBE_ETHPHY_IDA_ADDR, addr);
+
+	/* Write the data to IDA_DATA register */
+	wr32(wx, TXGBE_ETHPHY_IDA_DATA, data);
+}
+
+static void txgbe_pma_config_10gbr(struct txgbe *txgbe)
+{
+	u16 val;
+
+	pcs_write(txgbe, MDIO_MMD_PCS, MDIO_CTRL2, MDIO_PCS_CTRL2_10GBR);
+	val = pcs_read(txgbe, MDIO_MMD_PMAPMD, MDIO_CTRL1);
+	val |= MDIO_CTRL1_SPEED10G;
+	pcs_write(txgbe, MDIO_MMD_PMAPMD, MDIO_CTRL1, val);
+
+	pma_write(txgbe, TXGBE_MPLLA_CTL0, 0x21);
+	pma_write(txgbe, TXGBE_MPLLA_CTL3, 0);
+	val = pma_read(txgbe, TXGBE_TX_GENCTRL1);
+	val = u16_replace_bits(val, 0x5, TXGBE_TX_GENCTRL1_VBOOST_LVL);
+	pma_write(txgbe, TXGBE_TX_GENCTRL1, val);
+	pma_write(txgbe, TXGBE_MISC_CTL0, 0xCF00);
+	pma_write(txgbe, TXGBE_VCO_CAL_LD0, 0x549);
+	pma_write(txgbe, TXGBE_VCO_CAL_REF0, 0x29);
+	pma_write(txgbe, TXGBE_TX_RATE_CTL, 0);
+	pma_write(txgbe, TXGBE_RX_RATE_CTL, 0);
+	pma_write(txgbe, TXGBE_TX_GEN_CTL2, 0x300);
+	pma_write(txgbe, TXGBE_RX_GEN_CTL2, 0x300);
+	pma_write(txgbe, TXGBE_MPLLA_CTL2, 0x600);
+
+	pma_write(txgbe, TXGBE_RX_EQ_CTL0, 0x45);
+	val = pma_read(txgbe, TXGBE_RX_EQ_ATTN_CTL);
+	val &= ~TXGBE_RX_EQ_ATTN_LVL0;
+	pma_write(txgbe, TXGBE_RX_EQ_ATTN_CTL, val);
+	pma_write(txgbe, TXGBE_DFE_TAP_CTL0, 0xBE);
+	val = pma_read(txgbe, TXGBE_AFE_DFE_ENABLE);
+	val &= ~(TXGBE_DFE_EN_0 | TXGBE_AFE_EN_0);
+	pma_write(txgbe, TXGBE_AFE_DFE_ENABLE, val);
+	val = pma_read(txgbe, TXGBE_RX_EQ_CTL4);
+	val &= ~TXGBE_RX_EQ_CTL4_CONT_ADAPT0;
+	pma_write(txgbe, TXGBE_RX_EQ_CTL4, val);
+}
+
+static void txgbe_pma_config_1000bx(struct txgbe *txgbe)
+{
+	u16 val;
+
+	pcs_write(txgbe, MDIO_MMD_PCS, MDIO_CTRL2, MDIO_PCS_CTRL2_10GBX);
+	pcs_write(txgbe, MDIO_MMD_PMAPMD, MDIO_CTRL1, 0);
+	pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1,
+		  MDIO_PMA_CTRL1_SPEED1000 | MDIO_CTRL1_FULLDPLX);
+
+	val = pma_read(txgbe, TXGBE_TX_GENCTRL1);
+	val = u16_replace_bits(val, 0x5, TXGBE_TX_GENCTRL1_VBOOST_LVL);
+	val &= ~TXGBE_TX_GENCTRL1_VBOOST_EN0;
+	pma_write(txgbe, TXGBE_TX_GENCTRL1, val);
+	pma_write(txgbe, TXGBE_MISC_CTL0, 0xCF00);
+
+	pma_write(txgbe, TXGBE_RX_EQ_CTL0, 0x7706);
+	val = pma_read(txgbe, TXGBE_RX_EQ_ATTN_CTL);
+	val &= ~TXGBE_RX_EQ_ATTN_LVL0;
+	pma_write(txgbe, TXGBE_RX_EQ_ATTN_CTL, val);
+	pma_write(txgbe, TXGBE_DFE_TAP_CTL0, 0);
+	val = pma_read(txgbe, TXGBE_RX_GEN_CTL3);
+	val = u16_replace_bits(val, 0x4, TXGBE_RX_GEN_CTL3_LOS_TRSHLD0);
+	pma_write(txgbe, TXGBE_RX_EQ_ATTN_CTL, val);
+
+	pma_write(txgbe, TXGBE_MPLLA_CTL0, 0x20);
+	pma_write(txgbe, TXGBE_MPLLA_CTL3, 0x46);
+	pma_write(txgbe, TXGBE_VCO_CAL_LD0, 0x540);
+	pma_write(txgbe, TXGBE_VCO_CAL_REF0, 0x2A);
+	pma_write(txgbe, TXGBE_AFE_DFE_ENABLE, 0);
+	pma_write(txgbe, TXGBE_RX_EQ_CTL4, 0x10);
+	pma_write(txgbe, TXGBE_TX_RATE_CTL, 0x3);
+	pma_write(txgbe, TXGBE_RX_RATE_CTL, 0x3);
+	pma_write(txgbe, TXGBE_TX_GEN_CTL2, 0x100);
+	pma_write(txgbe, TXGBE_RX_GEN_CTL2, 0x100);
+	pma_write(txgbe, TXGBE_MPLLA_CTL2, 0x200);
+	pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_AN_CTRL, TXGBE_MII_AN_CTRL_MII);
+}
+
+static void txgbe_set_sgmii_an37_ability(struct txgbe *txgbe)
+{
+	u16 val;
+
+	pcs_write(txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1,
+		  TXGBE_PCS_DIG_CTRL1_EN_VSMMD1 |
+		  TXGBE_PCS_DIG_CTRL1_CLS7_BP |
+		  TXGBE_PCS_DIG_CTRL1_BYP_PWRUP);
+	pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_AN_CTRL,
+		  TXGBE_MII_AN_CTRL_MII |
+		  TXGBE_MII_AN_CTRL_TXCFG |
+		  TXGBE_MII_AN_CTRL_PCS_MODE(2));
+	pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_DIG_CTRL1,
+		  TXGBE_MII_DIG_CTRL1_MAC_AUTOSW);
+	val = pcs_read(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1);
+	val |= BMCR_ANRESTART | BMCR_ANENABLE;
+	pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1, val);
+}
+
+static int txgbe_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
+			    phy_interface_t interface,
+			    const unsigned long *advertising,
+			    bool permit_pause_to_mac)
+{
+	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
+	struct wx *wx = txgbe->wx;
+	int ret, val;
+
+	/* Wait xpcs power-up good */
+	ret = read_poll_timeout(pcs_read, val,
+				(val & TXGBE_PCS_DIG_STS_PSEQ_ST) ==
+				TXGBE_PCS_DIG_STS_PSEQ_ST_GOOD,
+				10000, 1000000, false,
+				txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_STS);
+	if (ret < 0) {
+		wx_err(wx, "xpcs power-up timeout.\n");
+		return ret;
+	}
+
+	/* Disable xpcs AN-73 */
+	pcs_write(txgbe, MDIO_MMD_AN, MDIO_CTRL1, 0);
+
+	/* Disable PHY MPLLA for eth mode change(after ECO) */
+	txgbe_ephy_write(txgbe, TXGBE_SUP_DIG_MPLLA_OVRD_IN_0, 0x243A);
+	WX_WRITE_FLUSH(wx);
+	usleep_range(1000, 2000);
+
+	/* Set the eth change_mode bit first in mis_rst register
+	 * for corresponding LAN port
+	 */
+	wr32(wx, TXGBE_MIS_RST, TXGBE_MIS_RST_LAN_ETH_MODE(wx->bus.func));
+
+	switch (interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		txgbe_pma_config_10gbr(txgbe);
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		txgbe_pma_config_1000bx(txgbe);
+		txgbe_set_sgmii_an37_ability(txgbe);
+		break;
+	default:
+		break;
+	}
+
+	pcs_write(txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1,
+		  TXGBE_PCS_DIG_CTRL1_VR_RST | TXGBE_PCS_DIG_CTRL1_EN_VSMMD1);
+	/* wait phy initialization done */
+	ret = read_poll_timeout(pcs_read, val,
+				!(val & TXGBE_PCS_DIG_CTRL1_VR_RST),
+				100000, 10000000, false,
+				txgbe, MDIO_MMD_PCS, TXGBE_PCS_DIG_CTRL1);
+	if (ret < 0)
+		wx_err(wx, "PHY initialization timeout.\n");
+
+	return ret;
+}
+
+static void txgbe_pcs_get_state_10gbr(struct txgbe *txgbe,
+				      struct phylink_link_state *state)
+{
+	int ret;
+
+	state->link = false;
+
+	ret = pcs_read(txgbe, MDIO_MMD_PCS, MDIO_STAT1);
+	if (ret < 0)
+		return;
+
+	if (ret & MDIO_STAT1_LSTATUS)
+		state->link = true;
+
+	if (state->link) {
+		state->pause = MLO_PAUSE_TX | MLO_PAUSE_RX;
+		state->duplex = DUPLEX_FULL;
+		state->speed = SPEED_10000;
+	}
+}
+
+static void txgbe_pcs_get_state_1000bx(struct txgbe *txgbe,
+				       struct phylink_link_state *state)
+{
+	int lpa, bmsr;
+
+	/* For C37 1000BASEX mode */
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			      state->advertising)) {
+		/* Reset link state */
+		state->link = false;
+
+		/* Poll for link jitter */
+		read_poll_timeout(pcs_read, lpa, lpa,
+				  100, 50000, false, txgbe,
+				  MDIO_MMD_VEND2, MII_LPA);
+
+		if (lpa < 0 || lpa & LPA_RFAULT) {
+			wx_err(txgbe->wx, "read pcs lpa error: %d\n", lpa);
+			return;
+		}
+
+		bmsr = pcs_read(txgbe, MDIO_MMD_VEND2, MII_BMSR);
+		if (bmsr < 0) {
+			wx_err(txgbe->wx, "read pcs lpa error: %d\n", bmsr);
+			return;
+		}
+
+		phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
+	}
+}
+
+static void txgbe_pcs_get_state(struct phylink_pcs *pcs,
+				struct phylink_link_state *state)
+{
+	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
+
+	switch (state->interface) {
+	case PHY_INTERFACE_MODE_10GBASER:
+		txgbe_pcs_get_state_10gbr(txgbe, state);
+		return;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		txgbe_pcs_get_state_1000bx(txgbe, state);
+		return;
+	default:
+		return;
+	}
+}
+
+static void txgbe_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct txgbe *txgbe = container_of(pcs, struct txgbe, pcs);
+	int ret;
+
+	ret = pcs_read(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1);
+	if (ret >= 0) {
+		ret |= BMCR_ANRESTART;
+		pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1, ret);
+	}
+}
+
+static const struct phylink_pcs_ops txgbe_pcs_ops = {
+	.pcs_config = txgbe_pcs_config,
+	.pcs_get_state = txgbe_pcs_get_state,
+	.pcs_an_restart = txgbe_pcs_an_restart,
+};
+
+static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
+{
+	struct mdio_device *mdiodev;
+	struct wx *wx = txgbe->wx;
+	struct mii_bus *mii_bus;
+	struct pci_dev *pdev;
+	int ret = 0;
+
+	pdev = wx->pdev;
+
+	mii_bus = devm_mdiobus_alloc(&pdev->dev);
+	if (!mii_bus)
+		return -ENOMEM;
+
+	mii_bus->name = "txgbe_pcs_mdio_bus";
+	mii_bus->read_c45 = &txgbe_pcs_read;
+	mii_bus->write_c45 = &txgbe_pcs_write;
+	mii_bus->parent = &pdev->dev;
+	mii_bus->phy_mask = ~0;
+	mii_bus->priv = wx;
+	snprintf(mii_bus->id, MII_BUS_ID_SIZE, "txgbe_pcs-%x",
+		 (pdev->bus->number << 8) | pdev->devfn);
+
+	ret = devm_mdiobus_register(&pdev->dev, mii_bus);
+	if (ret)
+		return ret;
+
+	mdiodev = mdio_device_create(mii_bus, 0);
+	if (IS_ERR(mdiodev))
+		return PTR_ERR(mdiodev);
+
+	txgbe->mdiodev = mdiodev;
+	txgbe->pcs.ops = &txgbe_pcs_ops;
+
+	return 0;
+}
+
 static void txgbe_i2c_start(struct wx *wx, u16 dev_addr)
 {
 	wr32(wx, TXGBE_I2C_ENABLE, 0);
@@ -197,10 +537,15 @@ static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
 	int val, dir;
 
 	dir = chip->get_direction(chip, offset);
-	if (dir == GPIO_LINE_DIRECTION_IN)
+	if (dir == GPIO_LINE_DIRECTION_IN) {
+		struct txgbe *txgbe = (struct txgbe *)wx->priv;
+
 		val = rd32m(wx, WX_GPIO_EXT, BIT(offset));
-	else
+		txgbe->gpio_orig &= ~BIT(offset);
+		txgbe->gpio_orig |= val;
+	} else {
 		val = rd32m(wx, WX_GPIO_DR, BIT(offset));
+	}
 
 	return !!(val & BIT(offset));
 }
@@ -334,12 +679,19 @@ static void txgbe_irq_handler(struct irq_desc *desc)
 	struct txgbe *txgbe = (struct txgbe *)wx->priv;
 	struct gpio_chip *gc = txgbe->gpio;
 	irq_hw_number_t hwirq;
-	unsigned long val;
+	unsigned long gpioirq;
+	u32 gpio;
 
 	chained_irq_enter(chip, desc);
 
-	val = rd32(wx, WX_GPIO_INTSTATUS);
-	for_each_set_bit(hwirq, &val, gc->ngpio)
+	gpioirq = rd32(wx, WX_GPIO_INTSTATUS);
+
+	/* workaround for hysteretic gpio interrupts */
+	gpio = rd32(wx, WX_GPIO_EXT);
+	if (!gpioirq)
+		gpioirq = txgbe->gpio_orig ^ gpio;
+
+	for_each_set_bit(hwirq, &gpioirq, gc->ngpio)
 		generic_handle_domain_irq(gc->irq.domain, hwirq);
 
 	chained_irq_exit(chip, desc);
@@ -358,6 +710,7 @@ static int txgbe_gpio_init(struct txgbe *txgbe)
 	int ret;
 
 	pdev = wx->pdev;
+	txgbe->gpio_orig = 0;
 
 	gc = devm_kzalloc(&pdev->dev, sizeof(*gc), GFP_KERNEL);
 	if (!gc)
@@ -428,6 +781,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_mdio_pcs_init(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init mdio pcs: %d\n", ret);
+		goto err;
+	}
+
 	ret = txgbe_i2c_adapter_add(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
@@ -456,6 +815,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	if (txgbe->mdiodev)
+		mdio_device_free(txgbe->mdiodev);
 	if (txgbe->sfp_dev)
 		platform_device_unregister(txgbe->sfp_dev);
 	if (txgbe->i2c_adap)
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index ea2b39252edf..d121edadfd09 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -5,6 +5,7 @@
 #define _TXGBE_TYPE_H_
 
 #include <linux/property.h>
+#include <linux/phylink.h>
 
 /* Device IDs */
 #define TXGBE_DEV_ID_SP1000                     0x1001
@@ -43,6 +44,8 @@
 
 /**************** SP Registers ****************************/
 /* chip control Registers */
+#define TXGBE_MIS_RST                           0x1000C
+#define TXGBE_MIS_RST_LAN_ETH_MODE(_i)          BIT((_i) + 29)
 #define TXGBE_MIS_PRB_CTL                       0x10010
 #define TXGBE_MIS_PRB_CTL_LAN_UP(_i)            BIT(1 - (_i))
 /* FMGR Registers */
@@ -105,6 +108,56 @@
 #define TXGBE_I2C_SLAVE_ADDR                    (0xA0 >> 1)
 #define TXGBE_I2C_EEPROM_DEV_ADDR               0xA0
 
+/************************************** ETH PHY ******************************/
+#define TXGBE_XPCS_IDA_ADDR                     0x13000
+#define TXGBE_XPCS_IDA_DATA                     0x13004
+#define TXGBE_ETHPHY_IDA_ADDR                   0x13008
+#define TXGBE_ETHPHY_IDA_DATA                   0x1300C
+/* PHY Registers */
+#define TXGBE_SUP_DIG_MPLLA_OVRD_IN_0           0x4
+/* Vendor Specific PCS MMD Registers */
+#define TXGBE_PCS_DIG_CTRL1                     0x8000
+#define TXGBE_PCS_DIG_CTRL1_VR_RST              BIT(15)
+#define TXGBE_PCS_DIG_CTRL1_EN_VSMMD1           BIT(13)
+#define TXGBE_PCS_DIG_CTRL1_CLS7_BP             BIT(12)
+#define TXGBE_PCS_DIG_CTRL1_BYP_PWRUP           BIT(1)
+#define TXGBE_PCS_DIG_STS                       0x8010
+#define TXGBE_PCS_DIG_STS_PSEQ_ST               GENMASK(4, 2)
+#define TXGBE_PCS_DIG_STS_PSEQ_ST_GOOD          FIELD_PREP(GENMASK(4, 2), 0x4)
+/* Vendor Specific MII MMD Standard Registers */
+#define TXGBE_MII_DIG_CTRL1                     0x8000
+#define TXGBE_MII_DIG_CTRL1_MAC_AUTOSW          BIT(9)
+#define TXGBE_MII_AN_CTRL                       0x8001
+#define TXGBE_MII_AN_CTRL_MII                   BIT(8)
+#define TXGBE_MII_AN_CTRL_TXCFG                 BIT(3)
+#define TXGBE_MII_AN_CTRL_PCS_MODE(_v)          FIELD_PREP(GENMASK(2, 1), _v)
+/* Vendor Specific PMA MMD Registers */
+#define TXGBE_PMA_MMD                           0x8020
+#define TXGBE_TX_GENCTRL1                       0x11
+#define TXGBE_TX_GENCTRL1_VBOOST_LVL            GENMASK(10, 8)
+#define TXGBE_TX_GENCTRL1_VBOOST_EN0            BIT(4)
+#define TXGBE_TX_GEN_CTL2                       0x12
+#define TXGBE_TX_RATE_CTL                       0x14
+#define TXGBE_RX_GEN_CTL2                       0x32
+#define TXGBE_RX_GEN_CTL3                       0x33
+#define TXGBE_RX_GEN_CTL3_LOS_TRSHLD0           GENMASK(2, 0)
+#define TXGBE_RX_RATE_CTL                       0x34
+#define TXGBE_RX_EQ_ATTN_CTL                    0x37
+#define TXGBE_RX_EQ_ATTN_LVL0                   GENMASK(2, 0)
+#define TXGBE_RX_EQ_CTL0                        0x38
+#define TXGBE_RX_EQ_CTL4                        0x3C
+#define TXGBE_RX_EQ_CTL4_CONT_ADAPT0            BIT(0)
+#define TXGBE_AFE_DFE_ENABLE                    0x3D
+#define TXGBE_DFE_EN_0                          BIT(4)
+#define TXGBE_AFE_EN_0                          BIT(0)
+#define TXGBE_DFE_TAP_CTL0                      0x3E
+#define TXGBE_MPLLA_CTL0                        0x51
+#define TXGBE_MPLLA_CTL2                        0x53
+#define TXGBE_MPLLA_CTL3                        0x57
+#define TXGBE_MISC_CTL0                         0x70
+#define TXGBE_VCO_CAL_LD0                       0x72
+#define TXGBE_VCO_CAL_REF0                      0x76
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -189,9 +242,12 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct mdio_device *mdiodev;
+	struct phylink_pcs pcs;
 	struct i2c_adapter *i2c_adap;
 	struct gpio_chip *gpio;
 	struct platform_device *sfp_dev;
+	u32 gpio_orig;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

