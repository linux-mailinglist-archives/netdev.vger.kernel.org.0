Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAEB52B50F
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 10:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbiERIXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 04:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiERIXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 04:23:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661F81078AD
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 01:23:34 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExn-0004R7-CA; Wed, 18 May 2022 10:23:23 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExn-0032pU-KR; Wed, 18 May 2022 10:23:22 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nrExk-00GXTy-4G; Wed, 18 May 2022 10:23:20 +0200
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
Subject: [PATCH 10/10] rtw88: Add rtw8822cu chipset support
Date:   Wed, 18 May 2022 10:23:18 +0200
Message-Id: <20220518082318.3898514-11-s.hauer@pengutronix.de>
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

Add support for the rtw8822cu chipset based on
https://github.com/ulli-kroll/rtw88-usb.git

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 +++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 24 +++++++++++
 .../net/wireless/realtek/rtw88/rtw8822cu.c    | 40 +++++++++++++++++++
 .../net/wireless/realtek/rtw88/rtw8822cu.h    | 15 +++++++
 5 files changed, 93 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8822cu.h

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index e4c60f1449ec8..651ab56d9c6bd 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -64,6 +64,17 @@ config RTW88_8822CE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8822CU
+	tristate "Realtek 8822CU USB wireless network adapter"
+	depends on USB
+	select RTW88_CORE
+	select RTW88_USB
+	select RTW88_8822C
+	help
+	  Select this option will enable support for 8822CU chipset
+
+	  802.11ac USB wireless network adapter
+
 config RTW88_8723DE
 	tristate "Realtek 8723DE PCI wireless network adapter"
 	depends on PCI
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index e4126ddf7d659..e0950dbc2565a 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -35,6 +35,9 @@ rtw88_8822c-objs		:= rtw8822c.o rtw8822c_table.o
 obj-$(CONFIG_RTW88_8822CE)	+= rtw88_8822ce.o
 rtw88_8822ce-objs		:= rtw8822ce.o
 
+obj-$(CONFIG_RTW88_8822CU)	+= rtw88_8822cu.o
+rtw88_8822cu-objs		:= rtw8822cu.o
+
 obj-$(CONFIG_RTW88_8723D)	+= rtw88_8723d.o
 rtw88_8723d-objs		:= rtw8723d.o rtw8723d_table.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index cd74607a61a28..51c90ef20c456 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -29,6 +29,12 @@ static void rtw8822ce_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8822cu_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8822c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->u.mac_addr);
+}
+
 static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -58,6 +64,9 @@ static int rtw8822c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8822ce_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_USB:
+		rtw8822cu_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
@@ -4557,6 +4566,18 @@ static void rtw8822c_adaptivity(struct rtw_dev *rtwdev)
 	rtw_phy_set_edcca_th(rtwdev, l2h, h2l);
 }
 
+static void rtw8822c_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					  struct rtw_tx_pkt_info *pkt_info,
+					  u8 *txdesc)
+{
+	struct rtw_chip_info *chip = rtwdev->chip;
+	size_t words;
+
+	words = (pkt_info->pkt_offset * 8 + chip->tx_pkt_desc_sz) / 2;
+
+	fill_txdesc_checksum_common(txdesc, words);
+}
+
 static const struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8822c[] = {
 	{0x0086,
 	 RTW_PWR_CUT_ALL_MSK,
@@ -4895,6 +4916,8 @@ static const struct rtw_rfe_def rtw8822c_rfe_defs[] = {
 	[0] = RTW_DEF_RFE(8822c, 0, 0),
 	[1] = RTW_DEF_RFE(8822c, 0, 0),
 	[2] = RTW_DEF_RFE(8822c, 0, 0),
+	[3] = RTW_DEF_RFE(8822c, 0, 0),
+	[4] = RTW_DEF_RFE(8822c, 0, 0),
 	[5] = RTW_DEF_RFE(8822c, 0, 5),
 	[6] = RTW_DEF_RFE(8822c, 0, 0),
 };
@@ -4978,6 +5001,7 @@ static struct rtw_chip_ops rtw8822c_ops = {
 	.cfo_track		= rtw8822c_cfo_track,
 	.config_tx_path		= rtw8822c_config_tx_path,
 	.config_txrx_mode	= rtw8822c_config_trx_mode,
+	.fill_txdesc_checksum	= rtw8822c_fill_txdesc_checksum,
 
 	.coex_set_init		= rtw8822c_coex_cfg_init,
 	.coex_set_ant_switch	= NULL,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822cu.c b/drivers/net/wireless/realtek/rtw88/rtw8822cu.c
new file mode 100644
index 0000000000000..36dc734f76eb3
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cu.c
@@ -0,0 +1,40 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include "main.h"
+#include "rtw8822cu.h"
+#include "usb.h"
+
+static const struct usb_device_id rtw_8822cu_id_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK,
+					RTW_USB_PRODUCT_ID_REALTEK_8822C,
+					0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) },
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK,
+					RTW_USB_PRODUCT_ID_REALTEK_8812C,
+					0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8822c_hw_spec) },
+	{},
+};
+MODULE_DEVICE_TABLE(usb, rtw_8822cu_id_table);
+
+static int rtw8822bu_probe(struct usb_interface *intf,
+			    const struct usb_device_id *id)
+{
+	return rtw_usb_probe(intf, id);
+}
+
+static struct usb_driver rtw_8822cu_driver = {
+	.name = "rtw_8822cu",
+	.id_table = rtw_8822cu_id_table,
+	.probe = rtw8822bu_probe,
+	.disconnect = rtw_usb_disconnect,
+};
+module_usb_driver(rtw_8822cu_driver);
+
+MODULE_AUTHOR("Realtek Corporation");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8822cu driver");
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822cu.h b/drivers/net/wireless/realtek/rtw88/rtw8822cu.h
new file mode 100644
index 0000000000000..16afe22a8216c
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822cu.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#ifndef __RTW_8822CU_H_
+#define __RTW_8822CU_H_
+
+/* USB Vendor/Product IDs */
+#define RTW_USB_VENDOR_ID_REALTEK		0x0BDA
+#define RTW_USB_PRODUCT_ID_REALTEK_8812C	0xC812
+#define RTW_USB_PRODUCT_ID_REALTEK_8822C	0xC82C
+
+extern struct rtw_chip_info rtw8822c_hw_spec;
+
+#endif
-- 
2.30.2

