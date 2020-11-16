Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CAD2B3D55
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 07:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgKPGxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 01:53:13 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:52815 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgKPGxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 01:53:13 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 0AG6r9DM1027092, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmb04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 0AG6r9DM1027092
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Nov 2020 14:53:09 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMB04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 16 Nov
 2020 14:53:09 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>, <m.szyprowski@samsung.com>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8153_ecm: avoid to be prior to r8152 driver
Date:   Mon, 16 Nov 2020 14:52:39 +0800
Message-ID: <1394712342-15778-393-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
References: <7fd014f2-c9a5-e7ec-f1c6-b3e4bb0f6eb6@samsung.com>
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
 drivers/net/usb/Makefile | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/Makefile b/drivers/net/usb/Makefile
index 99381e6bea78..98f4c100955e 100644
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
@@ -41,3 +41,11 @@ obj-$(CONFIG_USB_NET_QMI_WWAN)	+= qmi_wwan.o
 obj-$(CONFIG_USB_NET_CDC_MBIM)	+= cdc_mbim.o
 obj-$(CONFIG_USB_NET_CH9200)	+= ch9200.o
 obj-$(CONFIG_USB_NET_AQC111)	+= aqc111.o
+
+ifdef CONFIG_USB_NET_CDCETHER
+ifeq ($(CONFIG_USB_RTL8152), m)
+obj-$(CONFIG_USB_RTL8152)	+= r8153_ecm.o
+else
+obj-$(CONFIG_USB_NET_CDCETHER)	+= r8153_ecm.o
+endif
+endif
-- 
2.26.2

