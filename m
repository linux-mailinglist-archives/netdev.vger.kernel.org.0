Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931496E7538
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbjDSIba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbjDSIbT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:31:19 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8FAF13850;
        Wed, 19 Apr 2023 01:31:00 -0700 (PDT)
X-QQ-mid: bizesmtp68t1681892937t2sp517a
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 19 Apr 2023 16:28:56 +0800 (CST)
X-QQ-SSF: 01400000000000I0Z000000A0000000
X-QQ-FEAT: +ynUkgUhZJkkYNemyT7RdcnZJZZckYb3XQBLCTUNBoi2QsttCEP7STTpijkkU
        ESZOqbAdqkAbDDJD1XqSEykhzcKrF7L/XqFgLSwaUCqfNQGirbUlBJZTb0vk8W/bBFH8nKT
        9ockpQzxSMwmGscMjWslQLAsJ09oaglXzvcA2MMhzQeRu53fiJX1Vpzn7Lnrk2S6Q8Fw+0O
        UymZ/bzC8FFr2hziYzzk/ZBs7de+vAzWub1ukX2Z3Qa9wkarUGlDgF+Vp32Lu3Wfrfin4nc
        djTCCEusPSTfeciyvK/2GJAPSIGYGXrko0xLVahrufhcmwDZChe8m7nRHGLta+/KgyS1Ghf
        aFz1Qm39IxBqNtWGkugJbDzHJXtBI7JJtWrwbr8oUydwJF5P09Or8Cb+3htfDVb7avGAdoE
        9fFSwve1JvXWQv31r3zlzQ==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4816393218096079182
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        olteanv@gmail.com, mengyuanlou@net-swift.com,
        Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next v3 3/8] net: txgbe: Register I2C platform device
Date:   Wed, 19 Apr 2023 16:27:34 +0800
Message-Id: <20230419082739.295180-4-jiawenwu@trustnetic.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230419082739.295180-1-jiawenwu@trustnetic.com>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
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
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 50 +++++++++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  4 ++
 3 files changed, 55 insertions(+)

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
index 39762c7fc851..8bb7f1d9acc7 100644
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
@@ -79,10 +115,24 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		return ret;
 	}
 
+	ret = txgbe_i2c_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to init i2c interface: %d\n", ret);
+		goto err;
+	}
+
 	return 0;
+
+err:
+	txgbe_remove_phy(txgbe);
+
+	return ret;
 }
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	if (txgbe->i2c_dev)
+		platform_device_unregister(txgbe->i2c_dev);
+
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

