Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CCA22146B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGOSl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726698AbgGOSlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:41:25 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A305C08C5CE;
        Wed, 15 Jul 2020 11:41:24 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06FIfIbD016688
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 15 Jul 2020 20:41:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594838479; bh=kSgqavwRNLEb1UNcIY5GIGyMmUtam4Z6MFOTH4C9oJE=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=JeAzyrZOvlx/Myi51x8qhSU2paFuZmDGa2y8sCbEgUDBZm9kzIxV2vmuIg/l/Dyh7
         V4ggATygS+z40e9d1sSDsAzzkqmuQ0FGpnrWd7BSKfF+vEblNNRgMTeAglPYE+AThI
         wbV7BpzuODHSXqYBNdZGE2B/PxBKz/ZLziL5inFM=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jvmLG-000SST-6O; Wed, 15 Jul 2020 20:41:18 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net, oliver@neukum.org,
        =?UTF-8?q?Miguel=20Rodr=C3=ADguez=20P=C3=A9rez?= 
        <miguel@det.uvigo.gal>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net-next 1/5] net: cdc_ether: use dev->intf to get interface information
Date:   Wed, 15 Jul 2020 20:40:56 +0200
Message-Id: <20200715184100.109349-2-bjorn@mork.no>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200715184100.109349-1-bjorn@mork.no>
References: <20200715184100.109349-1-bjorn@mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>

usbnet_cdc_update_filter was getting the interface number from the
usb_interface struct in cdc_state->control. However, cdc_ncm does
not initialize that structure in its bind function, but uses
cdc_ncm_ctx instead. Getting intf directly from struct usbnet solves
the problem.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
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

