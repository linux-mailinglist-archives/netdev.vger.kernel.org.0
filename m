Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC30621F2C
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728958AbfEQUqD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:46:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42384 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728268AbfEQUqC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 16:46:02 -0400
Received: (qmail 7470 invoked by uid 2102); 17 May 2019 16:46:01 -0400
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 17 May 2019 16:46:01 -0400
Date:   Fri, 17 May 2019 16:46:01 -0400 (EDT)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To:     Christian Lamparter <chunkeey@gmail.com>
cc:     Oliver Neukum <oneukum@suse.com>,
        syzbot <syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <andreyknvl@google.com>, <syzkaller-bugs@googlegroups.com>,
        <chunkeey@googlemail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, Michael Wu <flamingice@sourmilk.net>
Subject: Re: KASAN: use-after-free Read in p54u_load_firmware_cb
In-Reply-To: <5014675.0cgHOJIxtM@debian64>
Message-ID: <Pine.LNX.4.44L0.1905171644110.1430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 May 2019, Christian Lamparter wrote:

> On Monday, May 13, 2019 3:28:30 PM CEST Oliver Neukum wrote:
> > On Mo, 2019-05-13 at 03:23 -0700, syzbot wrote:
> > > syzbot has found a reproducer for the following crash on:
> > > 
> > > HEAD commit:    43151d6c usb-fuzzer: main usb gadget fuzzer driver
> > > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=16b64110a00000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=4183eeef650d1234
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=200d4bb11b23d929335f
> > > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1634c900a00000
> > > 
> > > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > > Reported-by: syzbot+200d4bb11b23d929335f@syzkaller.appspotmail.com
> > > 
> > > usb 1-1: config 0 descriptor??
> > > usb 1-1: reset high-speed USB device number 2 using dummy_hcd
> > > usb 1-1: device descriptor read/64, error -71
> > > usb 1-1: Using ep0 maxpacket: 8
> > > usb 1-1: Loading firmware file isl3887usb
> > > usb 1-1: Direct firmware load for isl3887usb failed with error -2
> > > usb 1-1: Firmware not found.
> > > ==================================================================
> > > BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
> > > drivers/net/wireless/intersil/p54/p54usb.c:936
> > > Read of size 8 at addr ffff88809803f588 by task kworker/1:0/17
> > 
> > Hi,
> > 
> > it looks to me as if refcounting is broken.
> > You should have a usb_put_dev() in p54u_load_firmware_cb() or in
> > p54u_disconnect(), but not both.
> 
> There's more to that refcounting that meets the eye. Do you see that
> request_firmware_nowait() in the driver? That's the async firmware
> request call that get's completed by the p54u_load_firmware_cb()
> So what's happening here is that the driver has to be protected
> against rmmod when the driver is waiting for request_firmware_nowait
> to "finally" callback, which depending on the system can be up to 
> 60 seconds.
> 
> Now, what seems to be odd is that it's at line 936
> > > BUG: KASAN: use-after-free in p54u_load_firmware_cb.cold+0x97/0x13a  
> > > drivers/net/wireless/intersil/p54/p54usb.c:936
> 
> because if you put it in context:
> 
> |
> |static void p54u_load_firmware_cb(const struct firmware *firmware,
> |				  void *context)
> |{
> |	struct p54u_priv *priv = context;
> |	struct usb_device *udev = priv->udev;
> |	int err;
> |
> |	complete(&priv->fw_wait_load);
> |	if (firmware) {
> |		priv->fw = firmware;
> |		err = p54u_start_ops(priv);
> |	} else {
> |		err = -ENOENT;
> |		dev_err(&udev->dev, "Firmware not found.\n");
> |	}
> |
> |	if (err) {
> |>>	>>	struct device *parent = priv->udev->dev.parent; <<<<-- 936 is here
> |
> |		dev_err(&udev->dev, "failed to initialize device (%d)\n", err);
> |
> |		if (parent)
> |			device_lock(parent);
> |
> |		device_release_driver(&udev->dev);
> |		/*
> |		 * At this point p54u_disconnect has already freed
> |		 * the "priv" context. Do not use it anymore!
> |		 */
> |		priv = NULL;
> |
> |		if (parent)
> |			device_unlock(parent);
> |	}
> |
> |	usb_put_dev(udev);
> |}
> 
> it seems very out of place, because at that line the device is still bound to
> the driver! Only with device_release_driver in line 942, I could see that
> something woulb be aray... !BUT! that's why we do have the extra
> usb_get_dev(udev) in p54u_load_firmware() so we can do the usb_put_dev(udev) in
> line 953 to ensure that nothing (like the rmmod I talked above) will interfere
> until everything is done.
> 
> I've no idea what's wrong here, is gcc 9.0 aggressivly reording the put? Or is
> something else going on with the sanitizers? Because this report does look
> dogdy there!
> 
> (Note: p54usb has !strategic! dev_err/infos in place right around the
> usb_get_dev/usb_put_dev so we can sort of tell the refvalue of the udev
> and it all seems to be correct from what I can gleam) 

I agree; it doesn't seem to make sense.  The nice thing about syzbot, 
though, is you can ask it to run a debugging test for you.  Let's start 
by making sure that the faulty address really is &udev->dev.parent.

Alan


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
 
+	dev_info(udev, "%s: udev @ %px, dev.parent @ %px\n",
+			__func__, udev, &udev->dev.parent);
 	dev_info(&priv->udev->dev, "Loading firmware file %s\n",
 	       p54u_fwlist[i].fw);
 

