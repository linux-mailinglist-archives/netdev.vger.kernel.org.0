Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A882E6DD6B5
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjDKJbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDKJa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:30:29 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE602139;
        Tue, 11 Apr 2023 02:30:16 -0700 (PDT)
X-QQ-mid: bizesmtp91t1681205307tgjc20w4
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 11 Apr 2023 17:28:26 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000000A0000000
X-QQ-FEAT: qOAV9bwDT/nUhpJ2+vAxwoxtj1KcxRDR1lg4F73jSSaq+11ZOdOXPqRb7UPfh
        +s9jlcHulBni1XkuItQd0F29I/LfPJL225c2J1bG4aqBU44jZHz+GaNs+JVDQxkVlbWsKXe
        DqICQFUJmSLwUhsBEMZrF+GyVEWj4aD/Ks5jO3U5Yk/943iIdKc0X+NZmVeFr2UWa/f9RG1
        m4fFj+4G7hWnAzk1FmK7fKmOOdN2WmyLBSMjmJ4Qptfqe6DkGFiVStv4U6tY9oD2I6uIOO2
        cfSgG2uWg8T9qD7L87+akNGh8XGqVLDQqhzcNDpqbanvEJn9AE5RODDvv3BaFrrJ6CoEMVG
        eJHbW/6HYvOcGk7q7zZM0jWXm8SoTXHGXTikXvNN61m48YUNNJVWYuunx0ZADI0QNqniSmv
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 8181199620835839703
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v2 5/6] net: txgbe: Implement phylink pcs
Date:   Tue, 11 Apr 2023 17:27:24 +0800
Message-Id: <20230411092725.104992-6-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230411092725.104992-1-jiawenwu@trustnetic.com>
References: <20230411092725.104992-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 377 ++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  59 +++
 3 files changed, 437 insertions(+)

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
index 42e66db6e9ff..123fa7ed9039 100644
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
 
@@ -74,6 +76,375 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
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
+static int txgbe_pcs_validate(struct phylink_pcs *pcs,
+			      unsigned long *supported,
+			      const struct phylink_link_state *state)
+{
+	/* When in 802.3z mode, we must have AN enabled */
+	if (phy_interface_mode_is_8023z(state->interface) &&
+	    !phylink_test(state->advertising, Autoneg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void txgbe_pma_config_10gbaser(struct txgbe *txgbe)
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
+static void txgbe_pma_config_1000basex(struct txgbe *txgbe)
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
+static void txgbe_set_an37_ability(struct txgbe *txgbe)
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
+		  TXGBE_MII_AN_CTRL_PCS_MODE(0) |
+		  TXGBE_MII_AN_CTRL_INTR_EN);
+	pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_DIG_CTRL1,
+		  TXGBE_MII_DIG_CTRL1_MAC_AUTOSW);
+	val = pcs_read(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1);
+	val |= BMCR_ANRESTART | BMCR_ANENABLE;
+	pcs_write(txgbe, MDIO_MMD_VEND2, MDIO_CTRL1, val);
+}
+
+static void txgbe_setup_adv(struct txgbe *txgbe, phy_interface_t interface,
+			    const unsigned long *advertising)
+{
+	int adv;
+
+	adv = phylink_mii_c22_pcs_encode_advertisement(interface,
+						       advertising);
+	if (adv > 0)
+		mdiodev_c45_modify(txgbe->mdiodev, MDIO_MMD_VEND2, MII_ADVERTISE,
+				   0xffff, adv);
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
+	if (interface == txgbe->interface)
+		goto out;
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
+		txgbe_pma_config_10gbaser(txgbe);
+		break;
+	case PHY_INTERFACE_MODE_1000BASEX:
+		txgbe_pma_config_1000basex(txgbe);
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
+	txgbe->interface = interface;
+
+out:
+	if (interface == PHY_INTERFACE_MODE_1000BASEX) {
+		txgbe_setup_adv(txgbe, interface, advertising);
+		txgbe_set_an37_ability(txgbe);
+	}
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
+	int lpa, bmsr, an_intr;
+
+	/* Reset link state */
+	state->link = false;
+
+	lpa = pcs_read(txgbe, MDIO_MMD_VEND2, MII_LPA);
+	if (lpa < 0 || lpa & LPA_RFAULT) {
+		wx_err(txgbe->wx, "read pcs lpa error: %d\n", lpa);
+		return;
+	}
+
+	bmsr = pcs_read(txgbe, MDIO_MMD_VEND2, MII_BMSR);
+	if (bmsr < 0) {
+		wx_err(txgbe->wx, "read pcs lpa error: %d\n", bmsr);
+		return;
+	}
+
+	/* Clear AN complete interrupt */
+	an_intr = pcs_read(txgbe, MDIO_MMD_VEND2, TXGBE_MII_AN_INTR);
+	if (an_intr & TXGBE_MII_AN_INTR_CL37_CMPLT) {
+		an_intr &= ~TXGBE_MII_AN_INTR_CL37_CMPLT;
+		pcs_write(txgbe, MDIO_MMD_VEND2, TXGBE_MII_AN_INTR, an_intr);
+	}
+
+	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
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
+
+	mdiodev_c45_modify(txgbe->mdiodev, MDIO_MMD_VEND2, MDIO_CTRL1,
+			   BMCR_ANRESTART, BMCR_ANRESTART);
+}
+
+static const struct phylink_pcs_ops txgbe_pcs_ops = {
+	.pcs_validate = txgbe_pcs_validate,
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
@@ -457,6 +828,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
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
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 58b0054ae59c..d83225b4e34e 100644
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
@@ -102,6 +105,59 @@
 #define TXGBE_I2C_SCL_STUCK_TIMEOUT             0x149AC
 #define TXGBE_I2C_SDA_STUCK_TIMEOUT             0x149B0
 
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
+#define TXGBE_MII_AN_CTRL_INTR_EN               BIT(0)
+#define TXGBE_MII_AN_INTR                       0x8002
+#define TXGBE_MII_AN_INTR_CL37_CMPLT            BIT(0)
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
 
@@ -186,9 +242,12 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct mdio_device *mdiodev;
+	struct phylink_pcs pcs;
 	struct i2c_adapter *i2c_adap;
 	struct gpio_chip *gpio;
 	struct platform_device *sfp_dev;
+	phy_interface_t interface;
 	u32 gpio_orig;
 };
 
-- 
2.27.0

