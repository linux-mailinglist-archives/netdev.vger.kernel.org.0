Return-Path: <netdev+bounces-7839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7931A721C56
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 04:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3530928114D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 02:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA6415B7;
	Mon,  5 Jun 2023 02:57:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011FC2581
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 02:57:09 +0000 (UTC)
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2896FFF
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 19:56:58 -0700 (PDT)
X-QQ-mid: bizesmtp91t1685933708tgc6ro4s
Received: from wxdbg.localdomain.com ( [60.177.99.31])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 05 Jun 2023 10:55:06 +0800 (CST)
X-QQ-SSF: 01400000000000J0Z000000A0000000
X-QQ-FEAT: eTp2eCgHrZnRhISs609JJ8SiDq1mxYvCXHgJyUW8sRCQXfjigWw44nBKUGjwT
	JuGojg0GhED+ZFYlQkEoxPs3+2GZ83hxOk6kUO5CJA6UQflPKdKr8bYxCyh/n63q8ebd9HR
	g4rTylp2akI9gap6gS/qT0QZX1oN79Cqr+5RgaVY//4BbwSJ1W+Qa7NVsKdvZuZfFTyoG2y
	/1UlmFCoEFMBqwU1UvPxdlTEEhUPQRKxD55rCZkDtUWXmh4Tzfaln3XrQmWhJ3f3lITx7U3
	vSb6RKsbUPq0Gsf72KeorOvqIv1SJiM4OFyQmIpeuxg+J40nszfNM9g8U5USxMZFGHHLTe0
	yklpdPzZ3+eOL8BxEr5NohD1/OdhW8dv1l1+Ivk1BmFsOmaP8jPYanU5mX++3WSGYANK2Fk
	AZqoQ1rwhs//JtGJ9L07uA==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 6019423721679261292
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
Subject: [PATCH net-next v11 8/9] net: txgbe: Implement phylink pcs
Date: Mon,  5 Jun 2023 10:52:10 +0800
Message-Id: <20230605025211.743823-9-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230605025211.743823-1-jiawenwu@trustnetic.com>
References: <20230605025211.743823-1-jiawenwu@trustnetic.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvrgz:qybglogicsvrgz5a-1
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Register MDIO bus for PCS layer to use Synopsys designware XPCS, support
10GBASE-R interface to the controller.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 89 ++++++++++++++++++-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  5 ++
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 3744735fa708..39596cd13539 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -49,6 +49,7 @@ config TXGBE
 	select SFP
 	select GPIOLIB
 	select GPIOLIB_IRQCHIP
+	select PCS_XPCS
 	select LIBWX
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 97c018a10c39..58e12c35627a 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -10,6 +10,7 @@
 #include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <linux/pcs/pcs-xpcs.h>
 
 #include "../libwx/wx_type.h"
 #include "../libwx/wx_hw.h"
@@ -77,6 +78,81 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
 }
 
+static int txgbe_pcs_read(struct mii_bus *bus, int addr, int devnum, int regnum)
+{
+	struct wx *wx  = bus->priv;
+	u32 offset, val;
+
+	if (addr)
+		return -EOPNOTSUPP;
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
+	if (addr)
+		return -EOPNOTSUPP;
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
+	struct mii_bus *mii_bus;
+	struct dw_xpcs *xpcs;
+	struct pci_dev *pdev;
+	struct wx *wx;
+	int ret = 0;
+
+	wx = txgbe->wx;
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
+	xpcs = xpcs_create_mdiodev(mii_bus, 0, PHY_INTERFACE_MODE_10GBASER);
+	if (IS_ERR(xpcs))
+		return PTR_ERR(xpcs);
+
+	txgbe->xpcs = xpcs;
+
+	return 0;
+}
+
 static int txgbe_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	struct wx *wx = gpiochip_get_data(chip);
@@ -432,16 +508,22 @@ int txgbe_init_phy(struct txgbe *txgbe)
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
@@ -463,6 +545,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 err_unregister_clk:
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+err_destroy_xpcs:
+	xpcs_destroy(txgbe->xpcs);
 err_unregister_swnode:
 	software_node_unregister_node_group(txgbe->nodes.group);
 
@@ -475,5 +559,6 @@ void txgbe_remove_phy(struct txgbe *txgbe)
 	platform_device_unregister(txgbe->i2c_dev);
 	clkdev_drop(txgbe->clock);
 	clk_unregister(txgbe->clk);
+	xpcs_destroy(txgbe->xpcs);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 60ecc5a90203..76470582ba1e 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -80,6 +80,10 @@
 /* I2C registers */
 #define TXGBE_I2C_BASE                          0x14900
 
+/************************************** ETH PHY ******************************/
+#define TXGBE_XPCS_IDA_ADDR                     0x13000
+#define TXGBE_XPCS_IDA_DATA                     0x13004
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -172,6 +176,7 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct dw_xpcs *xpcs;
 	struct platform_device *sfp_dev;
 	struct platform_device *i2c_dev;
 	struct clk_lookup *clock;
-- 
2.27.0


