Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AAB63BD87
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 11:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiK2KIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 05:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbiK2KIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 05:08:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 419F215A0A
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:08:09 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxX1-0006yB-N6; Tue, 29 Nov 2022 11:08:03 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWy-0012i3-Fn; Tue, 29 Nov 2022 11:08:01 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1ozxWx-00BYH9-Ix; Tue, 29 Nov 2022 11:07:59 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
Date:   Tue, 29 Nov 2022 11:07:51 +0100
Message-Id: <20221129100754.2753237-9-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221129100754.2753237-1-s.hauer@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the rtw8821cu chipset based on
https://github.com/ulli-kroll/rtw88-usb.git

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Notes:
    Changes since v3:
    - drop unnecessary rtw8821cu.h
    
    Changes since v2:
    - Fix txdesc checksum calculation. The checksum must be calculated over
      a fixed number of words.

 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 drivers/net/wireless/realtek/rtw88/rtw8821c.c | 18 +++++++
 drivers/net/wireless/realtek/rtw88/rtw8821c.h | 21 ++++++++
 .../net/wireless/realtek/rtw88/rtw8821cu.c    | 50 +++++++++++++++++++
 5 files changed, 103 insertions(+)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8821cu.c

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 1624c5db69bac..2b500dbefbc2d 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -75,6 +75,17 @@ config RTW88_8821CE
 
 	  802.11ac PCIe wireless network adapter
 
+config RTW88_8821CU
+	tristate "Realtek 8821CU USB wireless network adapter"
+	depends on USB
+	select RTW88_CORE
+	select RTW88_USB
+	select RTW88_8821C
+	help
+	  Select this option will enable support for 8821CU chipset
+
+	  802.11ac USB wireless network adapter
+
 config RTW88_DEBUG
 	bool "Realtek rtw88 debug support"
 	depends on RTW88_CORE
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index 2c2b0e5133cdf..552661a638def 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -44,6 +44,9 @@ rtw88_8821c-objs		:= rtw8821c.o rtw8821c_table.o
 obj-$(CONFIG_RTW88_8821CE)	+= rtw88_8821ce.o
 rtw88_8821ce-objs		:= rtw8821ce.o
 
+obj-$(CONFIG_RTW88_8821CU)	+= rtw88_8821cu.o
+rtw88_8821cu-objs		:= rtw8821cu.o
+
 obj-$(CONFIG_RTW88_PCI)		+= rtw88_pci.o
 rtw88_pci-objs			:= pci.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.c b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
index 9afdc5ce86b43..17f800f6efbd0 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.c
@@ -26,6 +26,12 @@ static void rtw8821ce_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8821cu_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8821c_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->u.mac_addr);
+}
+
 enum rtw8821ce_rf_set {
 	SWITCH_TO_BTG,
 	SWITCH_TO_WLG,
@@ -68,6 +74,9 @@ static int rtw8821c_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8821ce_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_USB:
+		rtw8821cu_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
@@ -1148,6 +1157,13 @@ static void rtw8821c_phy_cck_pd_set(struct rtw_dev *rtwdev, u8 new_lvl)
 			 dm_info->cck_pd_default + new_lvl * 2);
 }
 
+static void rtw8821c_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					  struct rtw_tx_pkt_info *pkt_info,
+					  u8 *txdesc)
+{
+	fill_txdesc_checksum_common(txdesc, 16);
+}
+
 static struct rtw_pwr_seq_cmd trans_carddis_to_cardemu_8821c[] = {
 	{0x0086,
 	 RTW_PWR_CUT_ALL_MSK,
@@ -1521,6 +1537,7 @@ static const struct rtw_rfe_def rtw8821c_rfe_defs[] = {
 	[2] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[4] = RTW_DEF_RFE_EXT(8821c, 0, 0, 2),
 	[6] = RTW_DEF_RFE(8821c, 0, 0),
+	[34] = RTW_DEF_RFE(8821c, 0, 0),
 };
 
 static struct rtw_hw_reg rtw8821c_dig[] = {
@@ -1595,6 +1612,7 @@ static struct rtw_chip_ops rtw8821c_ops = {
 	.config_bfee		= rtw8821c_bf_config_bfee,
 	.set_gid_table		= rtw_bf_set_gid_table,
 	.cfg_csi_rate		= rtw_bf_cfg_csi_rate,
+	.fill_txdesc_checksum	= rtw8821c_fill_txdesc_checksum,
 
 	.coex_set_init		= rtw8821c_coex_cfg_init,
 	.coex_set_ant_switch	= rtw8821c_coex_cfg_ant_switch,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821c.h b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
index 2698801fc35d5..1c81260f3a542 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8821c.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821c.h
@@ -9,6 +9,26 @@
 
 #define RCR_VHT_ACK		BIT(26)
 
+struct rtw8821cu_efuse {
+	u8 res4[4];			/* 0xd0 */
+	u8 usb_optional_function;
+	u8 res5[0x1e];
+	u8 res6[2];
+	u8 serial[0x0b];		/* 0xf5 */
+	u8 vid;				/* 0x100 */
+	u8 res7;
+	u8 pid;
+	u8 res8[4];
+	u8 mac_addr[ETH_ALEN];		/* 0x107 */
+	u8 res9[2];
+	u8 vendor_name[0x07];
+	u8 res10[2];
+	u8 device_name[0x14];
+	u8 res11[0xcf];
+	u8 package_type;		/* 0x1fb */
+	u8 res12[0x4];
+};
+
 struct rtw8821ce_efuse {
 	u8 mac_addr[ETH_ALEN];		/* 0xd0 */
 	u8 vender_id[2];
@@ -73,6 +93,7 @@ struct rtw8821c_efuse {
 	u8 res[3];
 	union {
 		struct rtw8821ce_efuse e;
+		struct rtw8821cu_efuse u;
 	};
 };
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8821cu.c b/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
new file mode 100644
index 0000000000000..7a5cbdc31ef79
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8821cu.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include "main.h"
+#include "rtw8821c.h"
+#include "usb.h"
+
+static const struct usb_device_id rtw_8821cu_id_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xb82b, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8821CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xb820, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8821CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc821, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8821CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc820, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8821CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc82a, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8821CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc82b, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8821CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xc811, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8811CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0x8811, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* 8811CU */
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0x2006, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8821c_hw_spec) }, /* TOTOLINK A650UA v3 */
+	{},
+};
+MODULE_DEVICE_TABLE(usb, rtw_8821cu_id_table);
+
+static int rtw_8821cu_probe(struct usb_interface *intf,
+			    const struct usb_device_id *id)
+{
+	return rtw_usb_probe(intf, id);
+}
+
+static struct usb_driver rtw_8821cu_driver = {
+	.name = "rtw_8821cu",
+	.id_table = rtw_8821cu_id_table,
+	.probe = rtw_8821cu_probe,
+	.disconnect = rtw_usb_disconnect,
+};
+module_usb_driver(rtw_8821cu_driver);
+
+MODULE_AUTHOR("Hans Ulli Kroll <linux@ulli-kroll.de>");
+MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821cu driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.30.2

