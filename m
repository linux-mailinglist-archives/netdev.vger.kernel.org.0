Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13DE6401B9
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232757AbiLBIMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232681AbiLBIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:12:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E1626F3
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:12:36 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p119p-0005An-Vh; Fri, 02 Dec 2022 09:12:30 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119o-001lGy-Gz; Fri, 02 Dec 2022 09:12:29 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119n-00BfE4-2J; Fri, 02 Dec 2022 09:12:27 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v5 11/11] wifi: rtw88: Add rtw8723du chipset support
Date:   Fri,  2 Dec 2022 09:12:24 +0100
Message-Id: <20221202081224.2779981-12-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202081224.2779981-1-s.hauer@pengutronix.de>
References: <20221202081224.2779981-1-s.hauer@pengutronix.de>
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

Add support for the rtw8723du chipset based on
https://github.com/ulli-kroll/rtw88-usb.git

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---

Notes:
    Changes since v4:
    - Add Edimax EW-7611ULB V2 to id table
    
    Changes since v3:
    - drop unnecessary rtw8723du.h
    
    Changes since v2:
    - Re-add this patch, tested on hardware now
    
    Changes since v1:
    - Fix txdesc checksum calculation: Unlike other chips this one needs
      a chksum = ~chksum at the end
    - Fix efuse layout (struct rtw8723de_efuse and struct rtw8723du_efuse need
      to be in a union as they are used alternatively)

 drivers/net/wireless/realtek/rtw88/Kconfig    | 11 ++++++
 drivers/net/wireless/realtek/rtw88/Makefile   |  3 ++
 drivers/net/wireless/realtek/rtw88/rtw8723d.c | 28 +++++++++++++++
 drivers/net/wireless/realtek/rtw88/rtw8723d.h | 13 ++++++-
 .../net/wireless/realtek/rtw88/rtw8723du.c    | 36 +++++++++++++++++++
 5 files changed, 90 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/rtw8723du.c

diff --git a/drivers/net/wireless/realtek/rtw88/Kconfig b/drivers/net/wireless/realtek/rtw88/Kconfig
index 138289bc5ad0c..651ab56d9c6bd 100644
--- a/drivers/net/wireless/realtek/rtw88/Kconfig
+++ b/drivers/net/wireless/realtek/rtw88/Kconfig
@@ -86,6 +86,17 @@ config RTW88_8723DE
 
 	  802.11n PCIe wireless network adapter
 
+config RTW88_8723DU
+	tristate "Realtek 8723DU USB wireless network adapter"
+	depends on USB
+	select RTW88_CORE
+	select RTW88_USB
+	select RTW88_8723D
+	help
+	  Select this option will enable support for 8723DU chipset
+
+	  802.11n USB wireless network adapter
+
 config RTW88_8821CE
 	tristate "Realtek 8821CE PCI wireless network adapter"
 	depends on PCI
diff --git a/drivers/net/wireless/realtek/rtw88/Makefile b/drivers/net/wireless/realtek/rtw88/Makefile
index fe2dd90204a78..fe7293ee87b45 100644
--- a/drivers/net/wireless/realtek/rtw88/Makefile
+++ b/drivers/net/wireless/realtek/rtw88/Makefile
@@ -44,6 +44,9 @@ rtw88_8723d-objs		:= rtw8723d.o rtw8723d_table.o
 obj-$(CONFIG_RTW88_8723DE)	+= rtw88_8723de.o
 rtw88_8723de-objs		:= rtw8723de.o
 
+obj-$(CONFIG_RTW88_8723DU)	+= rtw88_8723du.o
+rtw88_8723du-objs		:= rtw8723du.o
+
 obj-$(CONFIG_RTW88_8821C)	+= rtw88_8821c.o
 rtw88_8821c-objs		:= rtw8821c.o rtw8821c_table.o
 
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.c b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
index 0a4f770fcbb7e..2d2f768bae2ea 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.c
@@ -210,6 +210,12 @@ static void rtw8723de_efuse_parsing(struct rtw_efuse *efuse,
 	ether_addr_copy(efuse->addr, map->e.mac_addr);
 }
 
+static void rtw8723du_efuse_parsing(struct rtw_efuse *efuse,
+				    struct rtw8723d_efuse *map)
+{
+	ether_addr_copy(efuse->addr, map->u.mac_addr);
+}
+
 static int rtw8723d_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 {
 	struct rtw_efuse *efuse = &rtwdev->efuse;
@@ -239,6 +245,9 @@ static int rtw8723d_read_efuse(struct rtw_dev *rtwdev, u8 *log_map)
 	case RTW_HCI_TYPE_PCIE:
 		rtw8723de_efuse_parsing(efuse, map);
 		break;
+	case RTW_HCI_TYPE_USB:
+		rtw8723du_efuse_parsing(efuse, map);
+		break;
 	default:
 		/* unsupported now */
 		return -ENOTSUPP;
@@ -1945,6 +1954,24 @@ static void rtw8723d_pwr_track(struct rtw_dev *rtwdev)
 	dm_info->pwr_trk_triggered = false;
 }
 
+static void rtw8723d_fill_txdesc_checksum(struct rtw_dev *rtwdev,
+					  struct rtw_tx_pkt_info *pkt_info,
+					  u8 *txdesc)
+{
+	size_t words = 32 / 2; /* calculate the first 32 bytes (16 words) */
+	__le16 chksum = 0;
+	__le16 *data = (__le16 *)(txdesc);
+
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, 0x0000);
+
+	while (words--)
+		chksum ^= *data++;
+
+	chksum = ~chksum;
+
+	SET_TX_DESC_TXDESC_CHECKSUM(txdesc, __le16_to_cpu(chksum));
+}
+
 static struct rtw_chip_ops rtw8723d_ops = {
 	.phy_set_param		= rtw8723d_phy_set_param,
 	.read_efuse		= rtw8723d_read_efuse,
@@ -1965,6 +1992,7 @@ static struct rtw_chip_ops rtw8723d_ops = {
 	.config_bfee		= NULL,
 	.set_gid_table		= NULL,
 	.cfg_csi_rate		= NULL,
+	.fill_txdesc_checksum	= rtw8723d_fill_txdesc_checksum,
 
 	.coex_set_init		= rtw8723d_coex_cfg_init,
 	.coex_set_ant_switch	= NULL,
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723d.h b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
index 4641f6e047b41..a356318a5c15b 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8723d.h
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723d.h
@@ -41,6 +41,14 @@ struct rtw8723de_efuse {
 	u8 sub_device_id[2];
 };
 
+struct rtw8723du_efuse {
+	u8 res4[48];                    /* 0xd0 */
+	u8 vender_id[2];                /* 0x100 */
+	u8 product_id[2];               /* 0x102 */
+	u8 usb_option;                  /* 0x104 */
+	u8 mac_addr[ETH_ALEN];          /* 0x107 */
+};
+
 struct rtw8723d_efuse {
 	__le16 rtl_id;
 	u8 rsvd[2];
@@ -69,7 +77,10 @@ struct rtw8723d_efuse {
 	u8 rfe_option;
 	u8 country_code[2];
 	u8 res[3];
-	struct rtw8723de_efuse e;
+	union {
+		struct rtw8723de_efuse e;
+		struct rtw8723du_efuse u;
+	};
 };
 
 extern const struct rtw_chip_info rtw8723d_hw_spec;
diff --git a/drivers/net/wireless/realtek/rtw88/rtw8723du.c b/drivers/net/wireless/realtek/rtw88/rtw8723du.c
new file mode 100644
index 0000000000000..322a805da76b0
--- /dev/null
+++ b/drivers/net/wireless/realtek/rtw88/rtw8723du.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+/* Copyright(c) 2018-2019  Realtek Corporation
+ */
+
+#include <linux/module.h>
+#include <linux/usb.h>
+#include "main.h"
+#include "rtw8723d.h"
+#include "usb.h"
+
+static const struct usb_device_id rtw_8723du_id_table[] = {
+	{ USB_DEVICE_AND_INTERFACE_INFO(RTW_USB_VENDOR_ID_REALTEK, 0xd723, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8723d_hw_spec) }, /* 8723DU 1*1 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0xd611, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&(rtw8723d_hw_spec) }, /* Edimax EW-7611ULB V2 */
+	{ },
+};
+MODULE_DEVICE_TABLE(usb, rtw_8723du_id_table);
+
+static int rtw8723du_probe(struct usb_interface *intf,
+			   const struct usb_device_id *id)
+{
+	return rtw_usb_probe(intf, id);
+}
+
+static struct usb_driver rtw_8723du_driver = {
+	.name = "rtw_8723du",
+	.id_table = rtw_8723du_id_table,
+	.probe = rtw8723du_probe,
+	.disconnect = rtw_usb_disconnect,
+};
+module_usb_driver(rtw_8723du_driver);
+
+MODULE_AUTHOR("Hans Ulli Kroll <linux@ulli-kroll.de>");
+MODULE_DESCRIPTION("Realtek 802.11n wireless 8723du driver");
+MODULE_LICENSE("Dual BSD/GPL");
-- 
2.30.2

