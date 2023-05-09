Return-Path: <netdev+bounces-1018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E856FBD4C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3335281267
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 02:33:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA1ED5675;
	Tue,  9 May 2023 02:31:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A9417AA5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:31:17 +0000 (UTC)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51609EF2
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 19:31:09 -0700 (PDT)
X-QQ-mid: bizesmtp78t1683599366tkmkkysz
Received: from wxdbg.localdomain.com ( [125.119.253.217])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 09 May 2023 10:29:25 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: dcYQFNbI8vEQKyhGZeHVEPDr+1CP2vxPk4Nbk2dTDFcEJX3z6anEIEGsWnNSj
	3npSZQeGk1v9hKAHOZWpM23yzDc08x7puPdYeSbPN6TC3QJTU3tTvVMLxT/ENJVkd4EYgvr
	a/nTtr99rl6Uzu0pWYucy2n7W3cdTbPwBNEhZvl4kkn4HpB/4yFFZx1IZHb1Iht8gzxljyX
	WvHBJoWJMGGs/fRWHEZOGY4Gs2OvHxJ0yuwplWPoNfuFgPEErKYjwpRSoF/w9XVvGOZ+0mn
	Ejlrz60t9N+pW6q/WLs3CwPFp5s5fAA4Z3TvaUNJ8NU7WtgT53QwDydhNZgTxSZ1RQqrkG9
	KxiIcaiNL+g8BRdAyvuxorimrHVzRfp7jyQzY9GB2ouffm2dmStqLl9JTNIX/CV47QveS1j
	cNfA/fFjGnk=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 3264187204425161388
From: Jiawen Wu <jiawenwu@trustnetic.com>
To: netdev@vger.kernel.org,
	jarkko.nikula@linux.intel.com,
	andriy.shevchenko@linux.intel.com,
	mika.westerberg@linux.intel.com,
	jsd@semihalf.com,
	Jose.Abreu@synopsys.com,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	linux@armlinux.org.uk
Cc: linux-i2c@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	mengyuanlou@net-swift.com,
	Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v7 8/9] net: txgbe: Implement phylink pcs
Date: Tue,  9 May 2023 10:27:33 +0800
Message-Id: <20230509022734.148970-9-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230509022734.148970-1-jiawenwu@trustnetic.com>
References: <20230509022734.148970-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Register MDIO bus for PCS layer to use Synopsys designware XPCS, support
10GBASE-R interface to the controller.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 91 ++++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  6 ++
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 73f4492928c0..f3fb273e6fd0 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -45,6 +45,7 @@ config TXGBE
 	select GPIOLIB
 	select REGMAP
 	select COMMON_CLK
+	select PCS_XPCS
 	select LIBWX
 	select SFP
 	help
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 8085616a9146..0ab2898e764a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -9,6 +9,8 @@
 #include <linux/regmap.h>
 #include <linux/clkdev.h>
 #include <linux/clk-provider.h>
+#include <linux/pcs/pcs-xpcs.h>
+#include <linux/mdio.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
 
@@ -78,6 +80,82 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
 }
 
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
+static int txgbe_mdio_pcs_init(struct txgbe *txgbe)
+{
+	struct mdio_device *mdiodev;
+	struct wx *wx = txgbe->wx;
+	struct mii_bus *mii_bus;
+	struct dw_xpcs *xpcs;
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
+	xpcs = xpcs_create(mdiodev, PHY_INTERFACE_MODE_10GBASER);
+	if (IS_ERR_OR_NULL(xpcs)) {
+		mdio_device_free(mdiodev);
+		return PTR_ERR(xpcs);
+	}
+
+	txgbe->mdiodev = mdiodev;
+	txgbe->xpcs = xpcs;
+
+	return 0;
+}
+
 static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct wx *wx = gpiochip_get_data(chip);
@@ -410,16 +488,22 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_mdio_pcs_init(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init mdio pcs: %d\n", ret);
+		goto err_unregister_swnode;
+	}
+
 	ret = txgbe_gpio_init(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to init gpio\n");
-		goto err_unregister_swnode;
+		goto err_destroy_xpcs;
 	}
 
 	ret = txgbe_clock_register(txgbe);
 	if (ret) {
 		wx_err(txgbe->wx, "failed to register clock: %d\n", ret);
-		goto err_unregister_swnode;
+		goto err_destroy_xpcs;
 	}
 
 	ret = txgbe_i2c_register(txgbe);
@@ -441,6 +525,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 err_unregister_clk:
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+err_destroy_xpcs:
+	xpcs_destroy(txgbe->xpcs);
 err_unregister_swnode:
 	software_node_unregister_node_group(txgbe->nodes.group);
 
@@ -453,5 +539,6 @@ void txgbe_remove_phy(struct txgbe *txgbe)
 	platform_device_unregister(txgbe->i2c_dev);
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+	xpcs_destroy(txgbe->xpcs);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 796f33fe3016..75b9c7ae3c21 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -83,6 +83,10 @@
 /* I2C registers */
 #define TXGBE_I2C_BASE                          0x14900
 
+/************************************** ETH PHY ******************************/
+#define TXGBE_XPCS_IDA_ADDR                     0x13000
+#define TXGBE_XPCS_IDA_DATA                     0x13004
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -174,6 +178,8 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct mdio_device *mdiodev;
+	struct dw_xpcs *xpcs;
 	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
-- 
2.27.0


