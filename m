Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9A123AB2
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391962AbfETOoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:44:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58818 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S2388776AbfETOoW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:44:22 -0400
Received: (qmail 2121 invoked by uid 2102); 20 May 2019 10:44:21 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 20 May 2019 10:44:21 -0400
Date:   Mon, 20 May 2019 10:44:21 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Christian Lamparter <chunkeey@gmail.com>
cc:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <andreyknvl@google.com>, <syzkaller-bugs@googlegroups.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: [PATCH] network: wireless: p54u: Fix race between disconnect and
 firmware loading
In-Reply-To: <5014675.0cgHOJIxtM@debian64>
Message-ID: <Pine.LNX.4.44L0.1905201042110.1498-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syzbot fuzzer found a bug in the p54 USB wireless driver.  The
issue involves a race between disconnect and the firmware-loader
callback routine, and it has several aspects.

One big problem is that when the firmware can't be loaded, the
callback routine tries to unbind the driver from the USB _device_ (by
calling device_release_driver) instead of from the USB _interface_ to
which it is actually bound (by calling usb_driver_release_interface).

The race involves access to the private data structure.  The driver's
disconnect handler waits for a completion that is signalled by the
firmware-loader callback routine.  As soon as the completion is
signalled, you have to assume that the private data structure may have
been deallocated by the disconnect handler -- even if the firmware was
loaded without errors.  However, the callback routine does access the
private data several times after that point.

Another problem is that, in order to ensure that the USB device
structure hasn't been freed when the callback routine runs, the driver
takes a reference to it.  This isn't good enough any more, because now
that the callback routine calls usb_driver_release_interface, it has
to ensure that the interface structure hasn't been freed.

Finally, the driver takes an unnecessary reference to the USB device
structure in the probe function and drops the reference in the
disconnect handler.  This extra reference doesn't accomplish anything,
because the USB core already guarantees that a device structure won't
be deallocated while a driver is still bound to any of its interfaces.

To fix these problems, this patch makes the following changes:

	Call usb_driver_release_interface() rather than
	device_release_driver().

	Don't signal the completion until after the important
	information has been copied out of the private data structure,
	and don't refer to the private data at all thereafter.

	Lock udev (the interface's parent) before unbinding the driver
	instead of locking udev->parent.

	During the firmware loading process, take a reference to the
	USB interface instead of the USB device.

	Don't take an unnecessary reference to the device during probe
	(and then don't drop it during disconnect).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
CC: <stable@vger.kernel.org>

---


[as1899]


 drivers/net/wireless/intersil/p54/p54usb.c |   43 ++++++++++++-----------------
 1 file changed, 18 insertions(+), 25 deletions(-)

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
@@ -932,26 +934,22 @@ static void p54u_load_firmware_cb(const
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
+		usb_driver_release_interface(&p54u_driver, intf);
+		usb_unlock_device(udev);
 	}
 
-	usb_put_dev(udev);
+	usb_put_intf(intf);
 }
 
 static int p54u_load_firmware(struct ieee80211_hw *dev,
@@ -972,14 +970,14 @@ static int p54u_load_firmware(struct iee
 	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
 	       p54u_fwlist[i].fw);
 
-	usb_get_dev(udev);
+	usb_get_intf(intf);
 	err = request_firmware_nowait(THIS_MODULE, 1, p54u_fwlist[i].fw,
 				      device, GFP_KERNEL, priv,
 				      p54u_load_firmware_cb);
 	if (err) {
 		dev_err(&priv->udev->dev, "(p54usb) cannot load firmware %s "
 					  "(%d)!\n", p54u_fwlist[i].fw, err);
-		usb_put_dev(udev);
+		usb_put_intf(intf);
 	}
 
 	return err;
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

