Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709EF2A4092
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 10:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgKCJrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 04:47:15 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38573 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727955AbgKCJrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 04:47:14 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0A39kwXdB013834, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0A39kwXdB013834
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 3 Nov 2020 17:46:58 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMB04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 3 Nov 2020
 17:46:58 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <oliver@neukum.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v3 2/2] net/usb/r8153_ecm: support ECM mode for RTL8153
Date:   Tue, 3 Nov 2020 17:46:38 +0800
Message-ID: <1394712342-15778-391-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-389-Taiwan-albertk@realtek.com>
References: <1394712342-15778-387-Taiwan-albertk@realtek.com>
 <1394712342-15778-389-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support ECM mode based on cdc_ether with relative mii
functions, when CONFIG_USB_RTL8152 is not set, or the
device is not supported by r8152 driver.

Both r8152 and r8153_ecm would check the return value of
rtl8152_get_version() in porbe(). If rtl8152_get_version()
return none zero value, the r8152 is used for the device
with vendor mode. Otherwise, the r8153_ecm is used for the
device with ECM mode.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/Makefile    |   2 +-
 drivers/net/usb/r8152.c     |  22 +----
 drivers/net/usb/r8153_ecm.c | 162 ++++++++++++++++++++++++++++++++++++
 include/linux/usb/r8152.h   |  30 +++++++
 4 files changed, 197 insertions(+), 19 deletions(-)
 create mode 100644 drivers/net/usb/r8153_ecm.c
 create mode 100644 include/linux/usb/r8152.h

diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 99fd12be2111..99381e6bea78 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_USB_LAN78XX)	+= lan78xx.o
 obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
 asix-y := asix_devices.o asix_common.o ax88172a.o
 obj-$(CONFIG_USB_NET_AX88179_178A)      += ax88179_178a.o
-obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o
+obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o r8153_ecm.o
 obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
 obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
 obj-$(CONFIG_USB_NET_SR9700)	+= sr9700.o
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index d8ae89aa470c..41b803729996 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -26,7 +26,7 @@
 #include <linux/acpi.h>
 #include <linux/firmware.h>
 #include <crypto/hash.h>
-#include <linux/usb/usb_vendor_id.h>
+#include <linux/usb/r8152.h>
 
 /* Information for net-next */
 #define NETNEXT_VERSION		"11"
@@ -654,18 +654,6 @@ enum rtl_register_content {
 
 #define INTR_LINK		0x0004
 
-#define RTL8152_REQT_READ	0xc0
-#define RTL8152_REQT_WRITE	0x40
-#define RTL8152_REQ_GET_REGS	0x05
-#define RTL8152_REQ_SET_REGS	0x05
-
-#define BYTE_EN_DWORD		0xff
-#define BYTE_EN_WORD		0x33
-#define BYTE_EN_BYTE		0x11
-#define BYTE_EN_SIX_BYTES	0x3f
-#define BYTE_EN_START_MASK	0x0f
-#define BYTE_EN_END_MASK	0xf0
-
 #define RTL8153_MAX_PACKET	9216 /* 9K */
 #define RTL8153_MAX_MTU		(RTL8153_MAX_PACKET - VLAN_ETH_HLEN - \
 				 ETH_FCS_LEN)
@@ -693,9 +681,6 @@ enum rtl8152_flags {
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
 #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
 
-#define MCU_TYPE_PLA			0x0100
-#define MCU_TYPE_USB			0x0000
-
 struct tally_counter {
 	__le64	tx_packets;
 	__le64	rx_packets;
@@ -6607,7 +6592,7 @@ static int rtl_fw_init(struct r8152 *tp)
 	return 0;
 }
 
-static u8 rtl_get_version(struct usb_interface *intf)
+u8 rtl8152_get_version(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	u32 ocp_data = 0;
@@ -6665,12 +6650,13 @@ static u8 rtl_get_version(struct usb_interface *intf)
 
 	return version;
 }
+EXPORT_SYMBOL_GPL(rtl8152_get_version);
 
 static int rtl8152_probe(struct usb_interface *intf,
 			 const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
-	u8 version = rtl_get_version(intf);
+	u8 version = rtl8152_get_version(intf);
 	struct r8152 *tp;
 	struct net_device *netdev;
 	int ret;
diff --git a/drivers/net/usb/r8153_ecm.c b/drivers/net/usb/r8153_ecm.c
new file mode 100644
index 000000000000..13eba7a72633
--- /dev/null
+++ b/drivers/net/usb/r8153_ecm.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/mii.h>
+#include <linux/usb.h>
+#include <linux/usb/cdc.h>
+#include <linux/usb/usbnet.h>
+#include <linux/usb/r8152.h>
+
+#define OCP_BASE		0xe86c
+
+static int pla_read_word(struct usbnet *dev, u16 index)
+{
+	u16 byen = BYTE_EN_WORD;
+	u8 shift = index & 2;
+	__le32 tmp;
+	int ret;
+
+	if (shift)
+		byen <<= shift;
+
+	index &= ~3;
+
+	ret = usbnet_read_cmd(dev, RTL8152_REQ_GET_REGS, RTL8152_REQT_READ, index,
+			      MCU_TYPE_PLA | byen, &tmp, sizeof(tmp));
+	if (ret < 0)
+		goto out;
+
+	ret = __le32_to_cpu(tmp);
+	ret >>= (shift * 8);
+	ret &= 0xffff;
+
+out:
+	return ret;
+}
+
+static int pla_write_word(struct usbnet *dev, u16 index, u32 data)
+{
+	u32 mask = 0xffff;
+	u16 byen = BYTE_EN_WORD;
+	u8 shift = index & 2;
+	__le32 tmp;
+	int ret;
+
+	data &= mask;
+
+	if (shift) {
+		byen <<= shift;
+		mask <<= (shift * 8);
+		data <<= (shift * 8);
+	}
+
+	index &= ~3;
+
+	ret = usbnet_read_cmd(dev, RTL8152_REQ_GET_REGS, RTL8152_REQT_READ, index,
+			      MCU_TYPE_PLA | byen, &tmp, sizeof(tmp));
+
+	if (ret < 0)
+		goto out;
+
+	data |= __le32_to_cpu(tmp) & ~mask;
+	tmp = __cpu_to_le32(data);
+
+	ret = usbnet_write_cmd(dev, RTL8152_REQ_SET_REGS, RTL8152_REQT_WRITE, index,
+			       MCU_TYPE_PLA | byen, &tmp, sizeof(tmp));
+
+out:
+	return ret;
+}
+
+static int r8153_ecm_mdio_read(struct net_device *netdev, int phy_id, int reg)
+{
+	struct usbnet *dev = netdev_priv(netdev);
+	int ret;
+
+	ret = pla_write_word(dev, OCP_BASE, 0xa000);
+	if (ret < 0)
+		goto out;
+
+	ret = pla_read_word(dev, 0xb400 + reg * 2);
+
+out:
+	return ret;
+}
+
+static void r8153_ecm_mdio_write(struct net_device *netdev, int phy_id, int reg, int val)
+{
+	struct usbnet *dev = netdev_priv(netdev);
+	int ret;
+
+	ret = pla_write_word(dev, OCP_BASE, 0xa000);
+	if (ret < 0)
+		return;
+
+	ret = pla_write_word(dev, 0xb400 + reg * 2, val);
+}
+
+static int r8153_bind(struct usbnet *dev, struct usb_interface *intf)
+{
+	int status;
+
+	status = usbnet_cdc_bind(dev, intf);
+	if (status < 0)
+		return status;
+
+	dev->mii.dev = dev->net;
+	dev->mii.mdio_read = r8153_ecm_mdio_read;
+	dev->mii.mdio_write = r8153_ecm_mdio_write;
+	dev->mii.reg_num_mask = 0x1f;
+	dev->mii.supports_gmii = 1;
+
+	return status;
+}
+
+static const struct driver_info r8153_info = {
+	.description =	"RTL8153 ECM Device",
+	.flags =	FLAG_ETHER,
+	.bind =		r8153_bind,
+	.unbind =	usbnet_cdc_unbind,
+	.status =	usbnet_cdc_status,
+	.manage_power =	usbnet_manage_power,
+};
+
+static const struct usb_device_id products[] = {
+{
+	USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8153, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&r8153_info,
+},
+
+	{ },		/* END */
+};
+MODULE_DEVICE_TABLE(usb, products);
+
+static int rtl8153_ecm_probe(struct usb_interface *intf,
+			     const struct usb_device_id *id)
+{
+#if IS_REACHABLE(CONFIG_USB_RTL8152)
+	if (rtl8152_get_version(intf))
+		return -ENODEV;
+#endif
+
+	return usbnet_probe(intf, id);
+}
+
+static struct usb_driver r8153_ecm_driver = {
+	.name =		"r8153_ecm",
+	.id_table =	products,
+	.probe =	rtl8153_ecm_probe,
+	.disconnect =	usbnet_disconnect,
+	.suspend =	usbnet_suspend,
+	.resume =	usbnet_resume,
+	.reset_resume =	usbnet_resume,
+	.supports_autosuspend = 1,
+	.disable_hub_initiated_lpm = 1,
+};
+
+module_usb_driver(r8153_ecm_driver);
+
+MODULE_AUTHOR("Hayes Wang");
+MODULE_DESCRIPTION("Realtek USB ECM device");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/r8152.h b/include/linux/usb/r8152.h
new file mode 100644
index 000000000000..663e694c9513
--- /dev/null
+++ b/include/linux/usb/r8152.h
@@ -0,0 +1,30 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ *  Copyright (c) 2020 Realtek Semiconductor Corp. All rights reserved.
+ */
+
+#ifndef	__LINUX_R8152_H
+#define __LINUX_R8152_H
+
+#include <linux/usb/usb_vendor_id.h>
+
+#define RTL8152_REQT_READ		0xc0
+#define RTL8152_REQT_WRITE		0x40
+#define RTL8152_REQ_GET_REGS		0x05
+#define RTL8152_REQ_SET_REGS		0x05
+
+#define BYTE_EN_DWORD			0xff
+#define BYTE_EN_WORD			0x33
+#define BYTE_EN_BYTE			0x11
+#define BYTE_EN_SIX_BYTES		0x3f
+#define BYTE_EN_START_MASK		0x0f
+#define BYTE_EN_END_MASK		0xf0
+
+#define MCU_TYPE_PLA			0x0100
+#define MCU_TYPE_USB			0x0000
+
+#if IS_REACHABLE(CONFIG_USB_RTL8152)
+extern u8 rtl8152_get_version(struct usb_interface *intf);
+#endif
+
+#endif /* __LINUX_R8152_H */
-- 
2.26.2

