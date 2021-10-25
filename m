Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C822A439836
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbhJYONs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:13:48 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:49856 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbhJYONr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:13:47 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B09CD2193C;
        Mon, 25 Oct 2021 14:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1635171084; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=OTjSY7GSGw0G3NioSQABoRLAMGiPnBKkRoos8pwLTqc=;
        b=kiuorOvH9YQGwEpt5DZ2I/rRf3/sB3+Zyrlf1dm9zZxWCtXjAGcLAub6ReU0t8ULp4sxry
        2vsPdeRIrbb70ZzJhm1L+z0gIBbChLxXEdkOKTkNhBXQImZhtxHvqOKhrAOac+WSdLNnwl
        jTtvNJWvkJrXNWgni7A2jVf9J6bN34g=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6F04C13C0B;
        Mon, 25 Oct 2021 14:11:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OjXyGAy7dmG6cgAAMHmgww
        (envelope-from <oneukum@suse.com>); Mon, 25 Oct 2021 14:11:24 +0000
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] usbb: catc: use correct API for MAC addresses
Date:   Mon, 25 Oct 2021 16:11:21 +0200
Message-Id: <20211025141121.14828-1-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
of VLANs...") introduced a rbtree for faster Ethernet address look
up. To maintain netdev->dev_addr in this tree we need to make all
the writes to it got through appropriate helpers.

In the case of catc we need a new temporary buffer to conform
to the rules for DMA coherency. That in turn necessitates
a reworking of error handling in probe().

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/catc.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/catc.c b/drivers/net/usb/catc.c
index 24db5768a3c0..e7fe9c0f63a9 100644
--- a/drivers/net/usb/catc.c
+++ b/drivers/net/usb/catc.c
@@ -770,17 +770,23 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	struct net_device *netdev;
 	struct catc *catc;
 	u8 broadcast[ETH_ALEN];
-	int pktsz, ret;
+	u8 *macbuf;
+	int pktsz, ret = -ENOMEM;
+
+	macbuf = kmalloc(ETH_ALEN, GFP_KERNEL);
+	if (!macbuf)
+		goto error;
 
 	if (usb_set_interface(usbdev,
 			intf->altsetting->desc.bInterfaceNumber, 1)) {
 		dev_err(dev, "Can't set altsetting 1.\n");
-		return -EIO;
+		ret = -EIO;
+		goto fail_mem;;
 	}
 
 	netdev = alloc_etherdev(sizeof(struct catc));
 	if (!netdev)
-		return -ENOMEM;
+		goto fail_mem;
 
 	catc = netdev_priv(netdev);
 
@@ -870,7 +876,8 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	  
 		dev_dbg(dev, "Getting MAC from SEEROM.\n");
 	  
-		catc_get_mac(catc, netdev->dev_addr);
+		catc_get_mac(catc, macbuf);
+		eth_hw_addr_set(netdev, macbuf);
 		
 		dev_dbg(dev, "Setting MAC into registers.\n");
 	  
@@ -899,7 +906,8 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	} else {
 		dev_dbg(dev, "Performing reset\n");
 		catc_reset(catc);
-		catc_get_mac(catc, netdev->dev_addr);
+		catc_get_mac(catc, macbuf);
+		eth_hw_addr_set(netdev, macbuf);
 		
 		dev_dbg(dev, "Setting RX Mode\n");
 		catc->rxmode[0] = RxEnable | RxPolarity | RxMultiCast;
@@ -917,6 +925,7 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	if (ret)
 		goto fail_clear_intfdata;
 
+	kfree(macbuf);
 	return 0;
 
 fail_clear_intfdata:
@@ -927,6 +936,9 @@ static int catc_probe(struct usb_interface *intf, const struct usb_device_id *id
 	usb_free_urb(catc->rx_urb);
 	usb_free_urb(catc->irq_urb);
 	free_netdev(netdev);
+fail_mem:
+	kfree(macbuf);
+error:
 	return ret;
 }
 
-- 
2.26.2

