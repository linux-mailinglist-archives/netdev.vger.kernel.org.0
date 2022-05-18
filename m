Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8587F52B4B0
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiERIX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233057AbiERIXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:23:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5B410788C
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:23:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExn-0004R8-CB; Wed, 18 May 2022 10:23:23 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExn-0032pW-LK; Wed, 18 May 2022 10:23:22 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExk-00GXTv-3L; Wed, 18 May 2022 10:23:20 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 09/10] rtw88: Add rtw8822bu chipset support
Date:   Wed, 18 May 2022 10:23:17 +0200
Message-Id: <20220518082318.3898514-10-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220518082318.3898514-1-s.hauer@pengutronix.de>
References: <20220518082318.3898514-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the rtw8822bu chipset based on
https://github.com/ulli-kroll/rtw88-usb.git

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 +
 drivers/net/wireless/realtek/rtw88/rtw8822b.c | 19 ++++++
 .../net/wireless/realtek/rtw88/rtw8822bu.c    | 62 +++++++++++++++++++
 .../net/wireless/realtek/rtw88/rtw8822bu.h    | 15 +++++
 5 files changed, 110 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822bu.h

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 5b1bafccd3d4c..e4c60f1449ec8 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -42,6 +42,17 @@ config RTW88_8822BE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8822BU
+	tristate "Realtek 8822BU USB wireless network adapter"
+	depends on USB
+	select RTW88_CORE
+	select RTW88_USB
+	select RTW88_8822B
+	help
+	  Select this option will enable support for 8822BU chipset
+
+	  802.11ac USB wireless network adapter
+
 config RTW88_8822CE
 	tristate "Realtek 8822CE PCI wireless network adapter"
 	depends on PCI
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 5498e8bbcbf17..e4126ddf7d659 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -26,6 +26,9 @@ rtw88_8822b-objs		:= rtw8822b.o rtw8822b_table.o
 obj-$(CONFIG_RTW88_8822BE)	+= rtw88_8822be.o
 rtw88_8822be-objs		:= rtw8822be.o
 
+obj-$(CONFIG_RTW88_8822BU)	+= rtw88_8822bu.o
+rtw88_8822bu-objs		:= rtw8822bu.o
+
 obj-$(CONFIG_RTW88_8822C)	+= rtw88_8822c.o
 rtw88_8822c-objs		:= rtw8822c.o rtw8822c_table.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822b.c b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
index eee7bf0354030..10497d351f229 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822b.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822b.c
@@ -26,6 +26,12 @@ static void rtw8822be_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8822bu_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822b_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->u.mac_addr);
+}
+
 static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -56,6 +62,9 @@ static int rtw8822b_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8822be_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_USB:
+		rtw8822bu_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
@@ -1588,6 +1597,15 @@ static void rtw8822b_adaptivity(struct rtw_dev *rtwdev)
 	rtw_phy_set_edcca_th(rtwdev, l2h, h2l);
 }
 
+static void rtw8822b_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					  struct rtw_tx_pkt_info *pkt_info,
+					  u8 *txdesc)
+{
+	size_t words = 32 / 2; /* calculate the first 32 bytes (16 words) */
+
+	fill_txdesc_checksum_common(txdesc, words);
+}
+
 static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822b[] = {
 	{0x0086,
 	 RTW_PWR_CUT_ALL_MSK,
@@ -2163,6 +2181,7 @@ static struct rtw_chip_ops rtw8822b_ops = {
 	.cfg_csi_rate		= rtw_bf_cfg_csi_rate,
 	.adaptivity_init	= rtw8822b_adaptivity_init,
 	.adaptivity		= rtw8822b_adaptivity,
+	.fill_txdesc_checksum	= rtw8822b_fill_txdesc_checksum,
 
 	.coex_set_init		= rtw8822b_coex_cfg_init,
 	.coex_set_ant_switch	= rtw8822b_coex_cfg_ant_switch,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822bu.c b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
new file mode 100644
index 0000000000000..5becebdc32471
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bu.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include "main.h"
+#include "rtw8822bu.h"
+#include "usb.h"
+
+#define RTW_USB_VENDER_ID_EDIMAX	0x7392
+
+static const struct usb_device_id rtw_8822bu_id_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK,
+				       RTW_USB_PRODUCT_ID_REALTEK_8812B,
+				       0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK,
+				       RTW_USB_PRODUCT_ID_REALTEK_8822B,
+				       0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDER_ID_EDIMAX,
+					0xB822,
+					0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDER_ID_EDIMAX,
+					0xC822,
+					0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE(0x0b05, 0x184c),	/* ASUS AC53 Nano */
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE(0x0b05, 0x1841),	/* ASUS AC55 B1 */
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE(0x2001, 0x331c),	/* D-Link DWA-182 rev D1 */
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE(0x13b1, 0x0043),	/* Linksys WUSB6400M */
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE(0x2357, 0x012D),	/* TP-Link AC1300 T3U */
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{ USB_DEVICE(0x2357, 0x0138),	/* TP-Link AC1300 T3U */
+	  .driver_info = (kernel_ulong_t)&(rtw8822b_hw_spec) },
+	{},
+};
+MODULE_DEVICE_TABLE(usb, rtw_8822bu_id_table);
+
+static int rtw8822bu_probe(struct usb_interface *intf,
+			    const struct usb_device_id *id)
+{
+	return rtw_usb_probe(intf, id);
+}
+
+static struct usb_driver rtw_8822bu_driver = {
+	.name = "rtw_8822bu",
+	.id_table = rtw_8822bu_id_table,
+	.probe = rtw8822bu_probe,
+	.disconnect = rtw_usb_disconnect,
+};
+module_usb_driver(rtw_8822bu_driver);
+
+MODULE_AUTHOR("Realtek Corporation");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822bu driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822bu.h b/drivers/net/wireless/realtek/rtw88/rtw8822bu.h
new file mode 100644
index 0000000000000..20f01ecd74415
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822bu.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#ifndef __RTW_8822BU_H_
+#define __RTW_8822BU_H_
+
+/* USB Vendor/Product IDs */
+#define RTW_USB_VENDOR_ID_REALTEK		0x0BDA
+#define RTW_USB_PRODUCT_ID_REALTEK_8812B	0xB812
+#define RTW_USB_PRODUCT_ID_REALTEK_8822B	0xB82C
+
+extern struct rtw_chip_info rtw8822b_hw_spec;
+
+#endif
-- 
2.30.2

