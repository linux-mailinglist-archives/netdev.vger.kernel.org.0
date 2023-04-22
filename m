Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D3C6EB770
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 06:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjDVE7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 00:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbjDVE7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 00:59:33 -0400
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644AE1BE3;
        Fri, 21 Apr 2023 21:59:30 -0700 (PDT)
X-QQ-mid: bizesmtp66t1682139536tmblnj9b
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 22 Apr 2023 12:58:55 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: p8PN4UZ3LytHY1c9ZSEY1Y3Um3l5OT33oeXZ9cGR4Q1k7d80LWLzckHRY+BgR
        x68aHojT4CwV/B2xVu0GaEMh3iUmEevgVEqw2D/Do3Du3aXTP69hAiVs6ruTFMjaabR6eTw
        mw/UQSVuYJ8yNg0yZLWO3z+2xLxoSoZfnLY/F5orFsa7VjaMjhVoAq6EmphSoEdFzOY9E9O
        vxKUUOadAkLRbW29tltDfR835uiJzT5m0cW2pMgGpMTtjrB113IdZ+mo+rVi2Mu62gtnQ+r
        eTOfTZmkDLlf3fXEpj4eE6F7fGizERCgA8PQ+r0plKFluQMKj3tqLaFWa609ahnKcEaQZqd
        J4EDqux/U8mqelP+oKkq/fpBpfjpwRYb4yPTxwlDH09IYrhQTVt0QCCRvO8l1Shx1Izs6QH
        j97fJDqthXCd2l03v5s55A==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 17808385363380690387
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, andrew@lunn.ch, linux@armlinux.org.uk,
        jarkko.nikula@linux.intel.com, olteanv@gmail.com,
        andriy.shevchenko@linux.intel.com, hkallweit1@gmail.com
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v4 3/8] net: txgbe: Register I2C platform device
Date:   Sat, 22 Apr 2023 12:56:16 +0800
Message-Id: <20230422045621.360918-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230422045621.360918-1-jiawenwu@trustnetic.com>
References: <20230422045621.360918-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Register the platform device to use Designware I2C bus master driver.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 48 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  4 ++
 3 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index c9d88673d306..8acd6a0d84dc 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -40,6 +40,7 @@ config NGBE
 config TXGBE
 	tristate "Wangxun(R) 10GbE PCI Express adapters support"
 	depends on PCI
+	select I2C_DESIGNWARE_PLATFORM
 	select LIBWX
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index 39762c7fc851..d573f77007db 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
+#include <linux/platform_data/i2c-dw.h>
+#include <linux/platform_device.h>
 #include <linux/gpio/property.h>
 #include <linux/i2c.h>
 #include <linux/pci.h>
@@ -69,6 +71,40 @@ static int txgbe_swnodes_register(struct txgbe *txgbe)
 	return software_node_register_node_group(nodes->group);
 }
 
+static int txgbe_i2c_register(struct txgbe *txgbe)
+{
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct dw_i2c_platform_data pdata = {};
+	struct platform_device_info info = {};
+	struct platform_device *i2c_dev;
+	struct resource res = {};
+
+	pdata.base = txgbe->wx->hw_addr + TXGBE_I2C_BASE;
+	pdata.flags = BIT(11); /* MODEL_WANGXUN_SP */
+	pdata.ss_hcnt = 600;
+	pdata.ss_lcnt = 600;
+
+	info.parent = &pdev->dev;
+	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_I2C]);
+	info.name = "i2c_designware";
+	info.id = (pdev->bus->number << 8) | pdev->devfn;
+	info.data = &pdata;
+	info.size_data = sizeof(pdata);
+
+	res.start = pdev->irq;
+	res.end = pdev->irq;
+	res.flags = IORESOURCE_IRQ;
+	info.res = &res;
+	info.num_res = 1;
+	i2c_dev = platform_device_register_full(&info);
+	if (IS_ERR(i2c_dev))
+		return PTR_ERR(i2c_dev);
+
+	txgbe->i2c_dev = i2c_dev;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -79,10 +115,22 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_i2c_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
+		goto err_unregister_swnode;
+	}
+
 	return 0;
+
+err_unregister_swnode:
+	software_node_unregister_node_group(txgbe->nodes.group);
+
+	return ret;
 }
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	platform_device_unregister(txgbe->i2c_dev);
 	software_node_unregister_node_group(txgbe->nodes.group);
 }
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 51bbecb28433..771aefbc7c80 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -55,6 +55,9 @@
 #define TXGBE_TS_CTL                            0x10300
 #define TXGBE_TS_CTL_EVAL_MD                    BIT(31)
 
+/* I2C registers */
+#define TXGBE_I2C_BASE                          0x14900
+
 /* Part Number String Length */
 #define TXGBE_PBANUM_LENGTH                     32
 
@@ -146,6 +149,7 @@ struct txgbe_nodes {
 struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
+	struct platform_device *i2c_dev;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

