Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9CD65F5C4
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 11:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbfGDJhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 05:37:54 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:48562 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727256AbfGDJhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 05:37:54 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x649bpkH028627, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x649bpkH028627
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Thu, 4 Jul 2019 17:37:52 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.439.0; Thu, 4 Jul 2019
 17:37:50 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: set RTL8152_UNPLUG only for real disconnection
Date:   Thu, 4 Jul 2019 17:36:32 +0800
Message-ID: <1394712342-15778-288-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the flag of RTL8152_UNPLUG if and only if the device is unplugged.
Some error codes sometimes don't mean the real disconnection of usb device.
For those situations, set the flag of RTL8152_UNPLUG causes the driver skips
some flows of disabling the device, and it let the device stay at incorrect
state.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e887ac86fbef..39e0768d734d 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -28,7 +28,7 @@
 #define NETNEXT_VERSION		"09"
 
 /* Information for net */
-#define NET_VERSION		"9"
+#define NET_VERSION		"10"
 
 #define DRIVER_VERSION		"v1." NETNEXT_VERSION "." NET_VERSION
 #define DRIVER_AUTHOR "Realtek linux nic maintainers <nic_swsd@realtek.com>"
@@ -825,6 +825,14 @@ int set_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 	return ret;
 }
 
+static void rtl_set_unplug(struct r8152 *tp)
+{
+	if (tp->udev->state == USB_STATE_NOTATTACHED) {
+		set_bit(RTL8152_UNPLUG, &tp->flags);
+		smp_mb__after_atomic();
+	}
+}
+
 static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
 			    void *data, u16 type)
 {
@@ -863,7 +871,7 @@ static int generic_ocp_read(struct r8152 *tp, u16 index, u16 size,
 	}
 
 	if (ret == -ENODEV)
-		set_bit(RTL8152_UNPLUG, &tp->flags);
+		rtl_set_unplug(tp);
 
 	return ret;
 }
@@ -933,7 +941,7 @@ static int generic_ocp_write(struct r8152 *tp, u16 index, u16 byteen,
 
 error1:
 	if (ret == -ENODEV)
-		set_bit(RTL8152_UNPLUG, &tp->flags);
+		rtl_set_unplug(tp);
 
 	return ret;
 }
@@ -1321,7 +1329,7 @@ static void read_bulk_callback(struct urb *urb)
 		napi_schedule(&tp->napi);
 		return;
 	case -ESHUTDOWN:
-		set_bit(RTL8152_UNPLUG, &tp->flags);
+		rtl_set_unplug(tp);
 		netif_device_detach(tp->netdev);
 		return;
 	case -ENOENT:
@@ -1441,7 +1449,7 @@ static void intr_callback(struct urb *urb)
 resubmit:
 	res = usb_submit_urb(urb, GFP_ATOMIC);
 	if (res == -ENODEV) {
-		set_bit(RTL8152_UNPLUG, &tp->flags);
+		rtl_set_unplug(tp);
 		netif_device_detach(tp->netdev);
 	} else if (res) {
 		netif_err(tp, intr, tp->netdev,
@@ -2036,7 +2044,7 @@ static void tx_bottom(struct r8152 *tp)
 			struct net_device *netdev = tp->netdev;
 
 			if (res == -ENODEV) {
-				set_bit(RTL8152_UNPLUG, &tp->flags);
+				rtl_set_unplug(tp);
 				netif_device_detach(netdev);
 			} else {
 				struct net_device_stats *stats = &netdev->stats;
@@ -2110,7 +2118,7 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 
 	ret = usb_submit_urb(agg->urb, mem_flags);
 	if (ret == -ENODEV) {
-		set_bit(RTL8152_UNPLUG, &tp->flags);
+		rtl_set_unplug(tp);
 		netif_device_detach(tp->netdev);
 	} else if (ret) {
 		struct urb *urb = agg->urb;
@@ -5355,10 +5363,7 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 
 	usb_set_intfdata(intf, NULL);
 	if (tp) {
-		struct usb_device *udev = tp->udev;
-
-		if (udev->state == USB_STATE_NOTATTACHED)
-			set_bit(RTL8152_UNPLUG, &tp->flags);
+		rtl_set_unplug(tp);
 
 		netif_napi_del(&tp->napi);
 		unregister_netdev(tp->netdev);
-- 
2.21.0

