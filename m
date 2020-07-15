Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDFA2211B6
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 17:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725973AbgGOPxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 11:53:45 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:42423 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgGOPxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 11:53:45 -0400
Received: from cwh (fob.gandi.net [217.70.181.1])
        (Authenticated sender: wxcafe@wxcafe.net)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 6A6C220000E;
        Wed, 15 Jul 2020 15:53:42 +0000 (UTC)
Message-ID: <06493cccfe5d34f8052050e35073695ea0af6c0a.camel@wxcafe.net>
Subject: [PATCH 1/4] cdc_ether: use dev->intf to get interface information
From:   =?ISO-8859-1?Q?Wxcaf=E9?= <wxcafe@wxcafe.net>
To:     linux-usb@vger.kernel.org
Cc:     Miguel =?ISO-8859-1?Q?Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>, oliver@neukum.org, netdev@vger.kernel.org
Date:   Wed, 15 Jul 2020 11:53:39 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From 0d0f13077e02cf6b54f2a22eb2e5f7d97ac7ee97 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Miguel Rodr=C3=ADguez P=C3=A9rez? <miguel@det.uvigo.gal>
Date: Tue, 14 Jul 2020 18:02:10 -0400
Subject: [PATCH 1/4] cdc_ether: use dev->intf to get interface information

usbnet_cdc_update_filter was getting the interface number from the
usb_interface struct in cdc_state->control. However, cdc_ncm does
not initialize that structure in its bind function, but uses
cdc_ncm_cts instead. Getting intf directly from struct usbnet solves
the problem.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Signed-off-by: Wxcafé <wxcafe@wxcafe.net>
---
 drivers/net/usb/cdc_ether.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index a657943c9f01..2afe258e3648 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -65,8 +65,6 @@ static const u8 mbm_guid[16] = {
 
 static void usbnet_cdc_update_filter(struct usbnet *dev)
 {
-	struct cdc_state	*info = (void *) &dev->data;
-	struct usb_interface	*intf = info->control;
 	struct net_device	*net = dev->net;
 
 	u16 cdc_filter = USB_CDC_PACKET_TYPE_DIRECTED
@@ -86,7 +84,7 @@ static void usbnet_cdc_update_filter(struct usbnet *dev)
 			USB_CDC_SET_ETHERNET_PACKET_FILTER,
 			USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			cdc_filter,
-			intf->cur_altsetting->desc.bInterfaceNumber,
+			dev->intf->cur_altsetting->desc.bInterfaceNumber,
 			NULL,
 			0,
 			USB_CTRL_SET_TIMEOUT
-- 
2.27.0

-- 
Wxcafé <wxcafe@wxcafe.net>

