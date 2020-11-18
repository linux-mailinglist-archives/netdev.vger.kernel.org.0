Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7FEC2B7677
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgKRGok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:44:40 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:45799 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgKRGoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 01:44:39 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AI6iQQD1015853, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AI6iQQD1015853
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 18 Nov 2020 14:44:26 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMB04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 18 Nov
 2020 14:44:26 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <m.szyprowski@samsung.com>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2] r8153_ecm: avoid to be prior to r8152 driver
Date:   Wed, 18 Nov 2020 14:43:58 +0800
Message-ID: <1394712342-15778-394-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-393-Taiwan-albertk@realtek.com>
References: <1394712342-15778-393-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMB01.realtek.com.tw (172.21.6.94) To
 RTEXMB04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid r8153_ecm is compiled as built-in, if r8152 driver is compiled
as modules. Otherwise, the r8153_ecm would be used, even though the
device is supported by r8152 driver.

Fixes: c1aedf015ebd ("net/usb/r8153_ecm: support ECM mode for RTL8153")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
v2:
Use a separate Kconfig entry for r8153_ecm with proper dependencies.

 drivers/net/usb/Kconfig  | 9 +++++++++
 drivers/net/usb/Makefile | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/Kconfig b/drivers/net/usb/Kconfig
index b46993d5f997..1e3719028780 100644
--- a/drivers/net/usb/Kconfig
+++ b/drivers/net/usb/Kconfig
@@ -628,4 +628,13 @@ config USB_NET_AQC111
 	  This driver should work with at least the following devices:
 	  * Aquantia AQtion USB to 5GbE
 
+config USB_RTL8153_ECM
+	tristate "RTL8153 ECM support"
+	depends on USB_NET_CDCETHER && (USB_RTL8152 || USB_RTL8152=n)
+	default y
+	help
+	  This option supports ECM mode for RTL8153 ethernet adapter, when
+	  CONFIG_USB_RTL8152 is not set, or the RTL8153 device is not
+	  supported by r8152 driver.
+
 endif # USB_NET_DRIVERS
diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 99381e6bea78..4964f7b326fb 100644
--- a/drivers/net/usb/Makefile
+++ b/drivers/net/usb/Makefile
@@ -13,7 +13,7 @@ obj-$(CONFIG_USB_LAN78XX)	+= lan78xx.o
 obj-$(CONFIG_USB_NET_AX8817X)	+= asix.o
 asix-y := asix_devices.o asix_common.o ax88172a.o
 obj-$(CONFIG_USB_NET_AX88179_178A)      += ax88179_178a.o
-obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o r8153_ecm.o
+obj-$(CONFIG_USB_NET_CDCETHER)	+= cdc_ether.o
 obj-$(CONFIG_USB_NET_CDC_EEM)	+= cdc_eem.o
 obj-$(CONFIG_USB_NET_DM9601)	+= dm9601.o
 obj-$(CONFIG_USB_NET_SR9700)	+= sr9700.o
@@ -41,3 +41,4 @@ obj-$(CONFIG_USB_NET_QMI_WWAN)	+= qmi_wwan.o
 obj-$(CONFIG_USB_NET_CDC_MBIM)	+= cdc_mbim.o
 obj-$(CONFIG_USB_NET_CH9200)	+= ch9200.o
 obj-$(CONFIG_USB_NET_AQC111)	+= aqc111.o
+obj-$(CONFIG_USB_RTL8153_ECM)	+= r8153_ecm.o
-- 
2.26.2

