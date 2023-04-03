Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0835B6D3D8E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 08:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231552AbjDCGsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 02:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbjDCGsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 02:48:03 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2F82727
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 23:47:58 -0700 (PDT)
X-QQ-mid: bizesmtp63t1680504430twv508bj
Received: from wxdbg.localdomain.com ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 03 Apr 2023 14:47:09 +0800 (CST)
X-QQ-SSF: 01400000000000H0Z000B00A0000000
X-QQ-FEAT: znfcQSa1hKZK20aq+z/+RddqGsJFHBxejDwrkK+reTZkVpIja3/52cGPw0up4
        /7JXO0W4ZeQgXHhUZjJFR3XMYbWVbXuFt8dr0MUd3GFXMBY3Ucf7xSRTLPRGq1XG+RpJcns
        pLq31nr3wflACHXPtx0oS79WPzkZsMosWxgiQVHqRS064Cfw/KKQ8kw6DPbsPZS7quk55KY
        iZ1qRkBwTRXX1VZva/AYPx+oIqCHTj33Q0tEvNwDjW9PjbnjxJ60GyvmQLKoD+e49acRG5p
        R6z7aU8pWqXXdGH4/V0fHcOydsswCubxpAB6qyA/aBIp+Cg7w+cRYgMzpBK8uEEgAlfSb09
        VeQwn/874Zm/M1G1WJHia8XuPiy62/ArE9/NcdoYkFChxFSyS4WHv8WjHOKdk2e+bzH6apr
        O39OWFwF6CAI/zlttKhrzg==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4876250889537453862
From:   Jiawen Wu <jiawenwu@trustnetic.com>
To:     netdev@vger.kernel.org, linux@armlinux.org.uk
Cc:     mengyuanlou@net-swift.com, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: [PATCH net-next 3/6] net: txgbe: Add SFP module identify
Date:   Mon,  3 Apr 2023 14:45:25 +0800
Message-Id: <20230403064528.343866-4-jiawenwu@trustnetic.com>
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

Register SFP platform device to get modules information.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
---
 .../device_drivers/ethernet/wangxun/txgbe.rst | 47 +++++++++++++++++++
 drivers/net/ethernet/wangxun/Kconfig          |  1 +
 .../net/ethernet/wangxun/txgbe/txgbe_phy.c    | 29 ++++++++++++
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  1 +
 4 files changed, 78 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
index d052ef40fe36..9eb05a2ef110 100644
--- a/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
+++ b/Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
@@ -11,9 +11,56 @@ Copyright (c) 2015 - 2022 Beijing WangXun Technology Co., Ltd.
 Contents
 ========
 
+- Identifying Adapter
 - Support
 
 
+Identifying Adapter
+===================
+The driver is compatible with WangXun Sapphire Dual ports Ethernet Adapters.
+
+SFP+ Devices with Pluggable Optics
+----------------------------------
+The following is a list of 3rd party SFP+ modules that have been tested and verified.
+
++----------+----------------------+----------------------+
+| Supplier | Type                 | Part Numbers         |
++==========+======================+======================+
+| ACCELINK | SFP+                 | RTXM228-551          |
++----------+----------------------+----------------------+
+| Avago	   | SFP+                 | SFBR-7701SDZ         |
++----------+----------------------+----------------------+
+| BOYANG   | SFP+                 | OMXD30000            |
++----------+----------------------+----------------------+
+| F-tone   | SFP+                 | FTCS-851X-02D        |
++----------+----------------------+----------------------+
+| FS       | SFP+                 | SFP-10GSR-85         |
++----------+----------------------+----------------------+
+| Finisar  | SFP+                 | FTLX8574D3BCL        |
++----------+----------------------+----------------------+
+| Hisense  | SFP+                 | LTF8502-BC+          |
++----------+----------------------+----------------------+
+| HGTECH   | SFP+                 | MTRS-01X11-G         |
++----------+----------------------+----------------------+
+| HP       | SFP+                 | SR SFP+ 456096-001   |
++----------+----------------------+----------------------+
+| Huawei   | SFP+                 | AFBR-709SMZ          |
++----------+----------------------+----------------------+
+| Intel    | SFP+                 | FTLX8571D3BCV-IT     |
++----------+----------------------+----------------------+
+| JDSU     | SFP+                 | PLRXPL-SC-S43        |
++----------+----------------------+----------------------+
+| SONT     | SFP+                 | XP-8G10-01           |
++----------+----------------------+----------------------+
+| Trixon   | SFP+                 | TPS-TGM3-85DCR       |
++----------+----------------------+----------------------+
+
+Laser turns off for SFP+ when ifconfig ethX down
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+"ifconfig ethX down" turns off the laser for SFP+ fiber adapters.
+"ifconfig ethX up" turns on the laser.
+
+
 Support
 =======
 If you got any problem, contact Wangxun support team via nic-support@net-swift.com
diff --git a/drivers/net/ethernet/wangxun/Kconfig b/drivers/net/ethernet/wangxun/Kconfig
index 8cbf0dd48a2c..c5b62918db78 100644
--- a/drivers/net/ethernet/wangxun/Kconfig
+++ b/drivers/net/ethernet/wangxun/Kconfig
@@ -42,6 +42,7 @@ config TXGBE
 	depends on PCI
 	select LIBWX
 	select I2C
+	select SFP
 	help
 	  This driver supports Wangxun(R) 10GbE PCI Express family of
 	  adapters.
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
index f8a4b211f4e8..dac9dfd001f0 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_phy.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2015 - 2023 Beijing WangXun Technology Co., Ltd. */
 
+#include <linux/platform_device.h>
 #include <linux/gpio/property.h>
 #include <linux/iopoll.h>
 #include <linux/i2c.h>
@@ -187,6 +188,26 @@ static int txgbe_i2c_adapter_add(struct txgbe *txgbe)
 	return 0;
 }
 
+static int txgbe_sfp_register(struct txgbe *txgbe)
+{
+	struct pci_dev *pdev = txgbe->wx->pdev;
+	struct platform_device_info info;
+	struct platform_device *sfp_dev;
+
+	memset(&info, 0, sizeof(info));
+	info.parent = &pdev->dev;
+	info.fwnode = software_node_fwnode(txgbe->nodes.group[SWNODE_SFP]);
+	info.name = "sfp";
+	info.id = (pdev->bus->number << 8) | pdev->devfn;
+	sfp_dev = platform_device_register_full(&info);
+	if (IS_ERR(sfp_dev))
+		return PTR_ERR(sfp_dev);
+
+	txgbe->sfp_dev = sfp_dev;
+
+	return 0;
+}
+
 int txgbe_init_phy(struct txgbe *txgbe)
 {
 	int ret;
@@ -203,6 +224,12 @@ int txgbe_init_phy(struct txgbe *txgbe)
 		goto err;
 	}
 
+	ret = txgbe_sfp_register(txgbe);
+	if (ret) {
+		wx_err(txgbe->wx, "failed to register sfp\n");
+		goto err;
+	}
+
 	return 0;
 
 err:
@@ -213,6 +240,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
 
 void txgbe_remove_phy(struct txgbe *txgbe)
 {
+	if (txgbe->sfp_dev)
+		platform_device_unregister(txgbe->sfp_dev);
 	if (txgbe->i2c_adap)
 		i2c_del_adapter(txgbe->i2c_adap);
 
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index de488609f713..75a4e7b8cc51 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -165,6 +165,7 @@ struct txgbe {
 	struct wx *wx;
 	struct txgbe_nodes nodes;
 	struct i2c_adapter *i2c_adap;
+	struct platform_device *sfp_dev;
 };
 
 #endif /* _TXGBE_TYPE_H_ */
-- 
2.27.0

