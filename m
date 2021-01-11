Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7D92F1E84
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:05:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390700AbhAKTFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:05:10 -0500
Received: from ficht.host.rs.currently.online ([178.63.44.182]:56288 "EHLO
        ficht.host.rs.currently.online" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390253AbhAKTFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:05:10 -0500
Received: from carbon.srv.schuermann.io (carbon.srv.schuermann.io [178.63.44.188])
        by ficht.host.rs.currently.online (Postfix) with ESMTPS id 5151B1FBC1;
        Mon, 11 Jan 2021 19:04:28 +0000 (UTC)
From:   Leon Schuermann <leon@is.currently.online>
To:     kuba@kernel.org, oliver@neukum.org, davem@davemloft.net
Cc:     hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Leon Schuermann <leon@is.currently.online>
Subject: [PATCH 1/2] r8152: Add Lenovo Powered USB-C Travel Hub
Date:   Mon, 11 Jan 2021 20:03:13 +0100
Message-Id: <20210111190312.12589-2-leon@is.currently.online>
In-Reply-To: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This USB-C Hub (17ef:721e) based on the Realtek RTL8153B chip used to
use the cdc_ether driver. However, using this driver, with the system
suspended the device constantly sends pause-frames as soon as the
receive buffer fills up. This causes issues with other devices, where
some Ethernet switches stop forwarding packets altogether.

Using the Realtek driver (r8152) fixes this issue. Pause frames are no
longer sent while the host system is suspended.

Signed-off-by: Leon Schuermann <leon@is.currently.online>
Tested-by: Leon Schuermann <leon@is.currently.online>
---
 drivers/net/usb/cdc_ether.c | 7 +++++++
 drivers/net/usb/r8152.c     | 1 +
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 8c1d61c2cbac..6aaa0675c28a 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -793,6 +793,13 @@ static const struct usb_device_id	products[] = {
 	.driver_info = 0,
 },
 
+/* Lenovo Powered USB-C Travel Hub (4X90S92381, based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0x721e, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = 0,
+},
+
 /* ThinkPad USB-C Dock Gen 2 (based on Realtek RTL8153) */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(LENOVO_VENDOR_ID, 0xa387, USB_CLASS_COMM,
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index c448d6089821..67cd6986634f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6877,6 +6877,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7205)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x720c)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x7214)},
+	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0x721e)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LENOVO,  0xa387)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_LINKSYS, 0x0041)},
 	{REALTEK_USB_DEVICE(VENDOR_ID_NVIDIA,  0x09ff)},
-- 
2.29.2

