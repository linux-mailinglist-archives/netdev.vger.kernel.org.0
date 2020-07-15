Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D064B221468
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgGOSlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726977AbgGOSl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 14:41:26 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A664C061755;
        Wed, 15 Jul 2020 11:41:25 -0700 (PDT)
Received: from miraculix.mork.no (miraculix.mork.no [IPv6:2001:4641:0:2:7627:374e:db74:e353])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06FIfJf0016696
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 15 Jul 2020 20:41:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1594838479; bh=soqXKIMV4UybpZPLXSB5tX+7JJCEadqZphhOw22tfYI=;
        h=From:To:Cc:Subject:Date:Message-Id:References:From;
        b=AfpWHi7+dCpHnCB4QKGz3dI184INXcEDqyVABdsFvXHMwxBQ9uVntUTwNx6H7Iu25
         2D1o+R/s7uPsul9szXtp2PJztBZkJj+2alM9sFNMUXungDuWbPlxFR78Vd1PXXOJ1r
         f+hjvQ8yF7VuvGDbvsK/S+r32QAVmhgukiEAVqN4=
Received: from bjorn by miraculix.mork.no with local (Exim 4.94)
        (envelope-from <bjorn@miraculix.mork.no>)
        id 1jvmLG-000SSW-R1; Wed, 15 Jul 2020 20:41:18 +0200
From:   =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net, oliver@neukum.org,
        =?UTF-8?q?Miguel=20Rodr=C3=ADguez=20P=C3=A9rez?= 
        <miguel@det.uvigo.gal>, Oliver Neukum <oneukum@suse.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH v5 net-next 2/5] net: cdc_ether: export usbnet_cdc_update_filter
Date:   Wed, 15 Jul 2020 20:40:57 +0200
Message-Id: <20200715184100.109349-3-bjorn@mork.no>
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

This makes the function available to other drivers, like cdc_ncm.

Signed-off-by: Miguel Rodríguez Pérez <miguel@det.uvigo.gal>
Acked-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 drivers/net/usb/cdc_ether.c | 3 ++-
 include/linux/usb/usbnet.h  | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
index 2afe258e3648..8c1d61c2cbac 100644
--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -63,7 +63,7 @@ static const u8 mbm_guid[16] = {
 	0xa6, 0x07, 0xc0, 0xff, 0xcb, 0x7e, 0x39, 0x2a,
 };
 
-static void usbnet_cdc_update_filter(struct usbnet *dev)
+void usbnet_cdc_update_filter(struct usbnet *dev)
 {
 	struct net_device	*net = dev->net;
 
@@ -90,6 +90,7 @@ static void usbnet_cdc_update_filter(struct usbnet *dev)
 			USB_CTRL_SET_TIMEOUT
 		);
 }
+EXPORT_SYMBOL_GPL(usbnet_cdc_update_filter);
 
 /* probes control interface, claims data interface, collects the bulk
  * endpoints, activates data interface (if needed), maybe sets MTU.
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index b0bff3083278..3a856963a363 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -207,6 +207,7 @@ struct cdc_state {
 	struct usb_interface		*data;
 };
 
+extern void usbnet_cdc_update_filter(struct usbnet *dev);
 extern int usbnet_generic_cdc_bind(struct usbnet *, struct usb_interface *);
 extern int usbnet_ether_cdc_bind(struct usbnet *dev, struct usb_interface *intf);
 extern int usbnet_cdc_bind(struct usbnet *, struct usb_interface *);
-- 
2.27.0

