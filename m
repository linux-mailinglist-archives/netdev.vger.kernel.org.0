Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9050422419
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 18:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbfERQcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 12:32:11 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45935 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729552AbfERQcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 12:32:10 -0400
Received: (qmail 10095 invoked by uid 500); 18 May 2019 12:32:09 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 18 May 2019 12:32:09 -0400
Date:   Sat, 18 May 2019 12:32:09 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>
cc:     andreyknvl@google.com, <chunkeey@gmail.com>,
        <chunkeey@googlemail.com>, <davem@davemloft.net>,
        <kvalo@codeaurora.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <oneukum@suse.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
In-Reply-To: <000000000000add98105892b73ec@google.com>
Message-ID: <Pine.LNX.4.44L0.1905181202500.7855-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 May 2019, syzbot wrote:

> Hello,
> 
> syzbot has tested the proposed patch but the reproducer still triggered  
> crash:
> KASAN: slab-out-of-bounds Read in p54u_load_firmware_cb
> 
> usb 6-1: Direct firmware load for isl3887usb failed with error -2
> p54u_load_firmware_cb: priv->udev = ffff88809ad5bb80
> usb 6-1: Firmware not found.
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in p54u_load_firmware_cb+0x3c9/0x45f  
> drivers/net/wireless/intersil/p54/p54usb.c:937
> Read of size 8 at addr ffff88809abab588 by task kworker/1:8/5526

If you look at the full console log, you'll see that this address is 
different from all the addresses printed out earlier.  Not what you 
would expect.

Which makes me wonder: Suppose a disconnect occurs before the firmware 
loader callback runs?  p54_disconnect() will get stuck waiting for the 
priv->fw_load_wait completion to fire.  But when the callback runs, the 
first thing it does is activate the completion.

So now p54_disconnect() can finish doing its thing, including 
deallocating all the private data structures.  Then when 
p54u_load_firmware_cb() tries to read the contents of priv, it ends up 
accessing deallocated memory!

The patch below tries to do things the right way.

Alan Stern


#syz test: https://github.com/google/kasan.git usb-fuzzer

 drivers/net/wireless/intersil/p54/p54usb.c |   37 +++++++++++------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

Index: usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
===================================================================
--- usb-devel.orig/drivers/net/wireless/intersil/p54/p54usb.c
+++ usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
@@ -33,6 +33,8 @@ MODULE_ALIAS("prism54usb");
 MODULE_FIRMWARE("isl3886usb");
 MODULE_FIRMWARE("isl3887usb");
 
+static struct usb_driver p54u_driver;
+
 /*
  * Note:
  *
@@ -921,9 +923,9 @@ static void p54u_load_firmware_cb(const
 {
 	struct p54u_priv *priv = context;
 	struct usb_device *udev = priv->udev;
+	struct usb_interface *intf = priv->intf;
 	int err;
 
-	complete(&priv->fw_wait_load);
 	if (firmware) {
 		priv->fw = firmware;
 		err = p54u_start_ops(priv);
@@ -932,23 +934,19 @@ static void p54u_load_firmware_cb(const
 		dev_err(&udev->dev, "Firmware not found.\n");
 	}
 
-	if (err) {
-		struct device *parent = priv->udev->dev.parent;
-
-		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
-
-		if (parent)
-			device_lock(parent);
+	complete(&priv->fw_wait_load);
+	/*
+	 * At this point p54u_disconnect may have already freed
+	 * the "priv" context. Do not use it anymore!
+	 */
+	priv = NULL;
 
-		device_release_driver(&udev->dev);
-		/*
-		 * At this point p54u_disconnect has already freed
-		 * the "priv" context. Do not use it anymore!
-		 */
-		priv = NULL;
+	if (err) {
+		dev_err(&intf->dev, "failed to initialize device (%d)\n", err);
 
-		if (parent)
-			device_unlock(parent);
+		usb_lock_device(udev);
+		usb_driver_release_interface(intf, &p54u_driver);
+		usb_unlock_device(udev);
 	}
 
 	usb_put_dev(udev);
@@ -1011,8 +1009,6 @@ static int p54u_probe(struct usb_interfa
 	skb_queue_head_init(&priv->rx_queue);
 	init_usb_anchor(&priv->submitted);
 
-	usb_get_dev(udev);
-
 	/* really lazy and simple way of figuring out if we're a 3887 */
 	/* TODO: should just stick the identification in the device table */
 	i = intf->altsetting->desc.bNumEndpoints;
@@ -1053,10 +1049,8 @@ static int p54u_probe(struct usb_interfa
 		priv->upload_fw = p54u_upload_firmware_net2280;
 	}
 	err = p54u_load_firmware(dev, intf);
-	if (err) {
-		usb_put_dev(udev);
+	if (err)
 		p54_free_common(dev);
-	}
 	return err;
 }
 
@@ -1072,7 +1066,6 @@ static void p54u_disconnect(struct usb_i
 	wait_for_completion(&priv->fw_wait_load);
 	p54_unregister_common(dev);
 
-	usb_put_dev(interface_to_usbdev(intf));
 	release_firmware(priv->fw);
 	p54_free_common(dev);
 }

