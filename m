Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF572F1E8C
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390709AbhAKTF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbhAKTF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:05:28 -0500
Received: from ficht.host.rs.currently.online (ficht.host.rs.currently.online [IPv6:2a01:4f8:120:614b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7744DC061786;
        Mon, 11 Jan 2021 11:04:47 -0800 (PST)
Received: from carbon.srv.schuermann.io (carbon.srv.schuermann.io [IPv6:2a01:4f8:120:614b:2::1])
        by ficht.host.rs.currently.online (Postfix) with ESMTPS id 0B5771FC6E;
        Mon, 11 Jan 2021 19:04:46 +0000 (UTC)
From:   Leon Schuermann <leon@is.currently.online>
To:     kuba@kernel.org, oliver@neukum.org, davem@davemloft.net
Cc:     hayeswang@realtek.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, Leon Schuermann <leon@is.currently.online>
Subject: [PATCH 2/2] r8153_ecm: Add Lenovo Powered USB-C Hub as a fallback of r8152
Date:   Mon, 11 Jan 2021 20:03:15 +0100
Message-Id: <20210111190312.12589-3-leon@is.currently.online>
In-Reply-To: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210109144311.47760f7e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables the use of the r8153_ecm driver, introduced with
commit c1aedf015ebdd0 ("net/usb/r8153_ecm: support ECM mode for
RTL8153") for the Lenovo Powered USB-C Hub (17ef:721e) based on the
Realtek RTL8153B chip.

This results in the following driver preference:

- if r8152 is available, use the r8152 driver
- if r8152 is not available, use the r8153_ecm driver

This is done to prevent the NIC from constantly sending pause frames
when the host system enters standby (fixed by using the r8152 driver
in "r8152: Add Lenovo Powered USB-C Travel Hub"), while still allowing
the device to work with the r8153_ecm driver as a fallback.

Signed-off-by: Leon Schuermann <leon@is.currently.online>
Tested-by: Leon Schuermann <leon@is.currently.online>
---
 drivers/net/usb/r8153_ecm.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/usb/r8153_ecm.c b/drivers/net/usb/r8153_ecm.c
index 2c3fabd38b16..20b2df8d74ae 100644
--- a/drivers/net/usb/r8153_ecm.c
+++ b/drivers/net/usb/r8153_ecm.c
@@ -122,12 +122,20 @@ static const struct driver_info r8153_info = {
 };
 
 static const struct usb_device_id products[] = {
+/* Realtek RTL8153 Based USB 3.0 Ethernet Adapters */
 {
 	USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID_REALTEK, 0x8153, USB_CLASS_COMM,
 				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long)&r8153_info,
 },
 
+/* Lenovo Powered USB-C Travel Hub (4X90S92381, based on Realtek RTL8153) */
+{
+	USB_DEVICE_AND_INTERFACE_INFO(VENDOR_ID_LENOVO, 0x721e, USB_CLASS_COMM,
+				      USB_CDC_SUBCLASS_ETHERNET, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long)&r8153_info,
+},
+
 	{ },		/* END */
 };
 MODULE_DEVICE_TABLE(usb, products);
-- 
2.29.2

