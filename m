Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CA3223CB
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 17:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729310AbfERPNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 11:13:40 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49361 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728783AbfERPNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 11:13:40 -0400
Received: (qmail 8434 invoked by uid 500); 18 May 2019 11:13:39 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 18 May 2019 11:13:39 -0400
Date:   Sat, 18 May 2019 11:13:39 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>
cc:     andreyknvl@google.com, <chunkeey@gmail.com>,
        <chunkeey@googlemail.com>, <davem@davemloft.net>,
        <kvalo@codeaurora.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        <syzkaller-bugs@googlegroups.com>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
In-Reply-To: <00000000000009fcff05891bae0a@google.com>
Message-ID: <Pine.LNX.4.44L0.1905181045400.7855-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019, syzbot wrote:

> Hello,
> 
> syzbot tried to test the proposed patch but build/boot failed:

Drat.  Mistake in the patch.  Let's try again.

Incidentally, as far as I can tell there's no point in having the
usb_get_dev() in p54u_probe() and usb_put_dev() in p54u_disconnect().  
The device structure is guaranteed not to be deallocated while a driver
is bound to any of its interfaces, so taking an extra reference won't
make any difference.

On the other hand, I do see some problems in the firmware-load
callback.  First, it calls device_release_driver() without first
checking that the interface is still bound to the p54u driver.  
Second, it shouldn't call device_release_driver() at all -- it should
call usb_driver_release_interface().  It doesn't want to unbind the USB
device's driver; it wants to unbind the interface's driver.  And third,
to do this it needs to acquire udev's device lock, not the lock for
udev's parent.

Alan Stern


#syz test: https://github.com/google/kasan.git usb-fuzzer

 drivers/net/wireless/intersil/p54/p54usb.c |    3 +++
 1 file changed, 3 insertions(+)

Index: usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
===================================================================
--- usb-devel.orig/drivers/net/wireless/intersil/p54/p54usb.c
+++ usb-devel/drivers/net/wireless/intersil/p54/p54usb.c
@@ -923,6 +923,7 @@ static void p54u_load_firmware_cb(const
 	struct usb_device *udev = priv->udev;
 	int err;
 
+	pr_info("%s: priv->udev = %px\n", __func__, udev);
 	complete(&priv->fw_wait_load);
 	if (firmware) {
 		priv->fw = firmware;
@@ -969,6 +970,8 @@ static int p54u_load_firmware(struct iee
 	if (i < 0)
 		return i;
 
+	dev_info(&udev->dev, "%s: udev @ %px, dev.parent @ %px\n",
+			__func__, udev, &udev->dev.parent);
 	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
 	       p54u_fwlist[i].fw);

