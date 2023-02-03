Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A803E68A30C
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 20:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbjBCTcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 14:32:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjBCTcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 14:32:13 -0500
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id A03CA1C7C1
        for <netdev@vger.kernel.org>; Fri,  3 Feb 2023 11:32:11 -0800 (PST)
Received: (qmail 573286 invoked by uid 1000); 3 Feb 2023 14:32:09 -0500
Date:   Fri, 3 Feb 2023 14:32:09 -0500
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     syzbot <syzbot+2a0e7abd24f1eb90ce25@syzkaller.appspotmail.com>,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        mailhol.vincent@wanadoo.fr, mkl@pengutronix.de, oneukum@suse.com,
        syzkaller-bugs@googlegroups.com
Subject: [PATCH] net: USB: Fix wrong-direction WARNING in plusb.c
Message-ID: <Y91hOew3nW56Ki4O@rowland.harvard.edu>
References: <Y9wh8dGK6oHSjJQl@rowland.harvard.edu>
 <00000000000003e49a05f3be1479@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000000000003e49a05f3be1479@google.com>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The syzbot fuzzer detected a bug in the plusb network driver: A
zero-length control-OUT transfer was treated as a read instead of a
write.  In modern kernels this error provokes a WARNING:

usb 1-1: BOGUS control dir, pipe 80000280 doesn't match bRequestType c0
WARNING: CPU: 0 PID: 4645 at drivers/usb/core/urb.c:411
usb_submit_urb+0x14a7/0x1880 drivers/usb/core/urb.c:411
Modules linked in:
CPU: 1 PID: 4645 Comm: dhcpcd Not tainted
6.2.0-rc6-syzkaller-00050-g9f266ccaa2f5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google
01/12/2023
RIP: 0010:usb_submit_urb+0x14a7/0x1880 drivers/usb/core/urb.c:411
...
Call Trace:
 <TASK>
 usb_start_wait_urb+0x101/0x4b0 drivers/usb/core/message.c:58
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x320/0x4a0 drivers/usb/core/message.c:153
 __usbnet_read_cmd+0xb9/0x390 drivers/net/usb/usbnet.c:2010
 usbnet_read_cmd+0x96/0xf0 drivers/net/usb/usbnet.c:2068
 pl_vendor_req drivers/net/usb/plusb.c:60 [inline]
 pl_set_QuickLink_features drivers/net/usb/plusb.c:75 [inline]
 pl_reset+0x2f/0xf0 drivers/net/usb/plusb.c:85
 usbnet_open+0xcc/0x5d0 drivers/net/usb/usbnet.c:889
 __dev_open+0x297/0x4d0 net/core/dev.c:1417
 __dev_change_flags+0x587/0x750 net/core/dev.c:8530
 dev_change_flags+0x97/0x170 net/core/dev.c:8602
 devinet_ioctl+0x15a2/0x1d70 net/ipv4/devinet.c:1147
 inet_ioctl+0x33f/0x380 net/ipv4/af_inet.c:979
 sock_do_ioctl+0xcc/0x230 net/socket.c:1169
 sock_ioctl+0x1f8/0x680 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x197/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

The fix is to call usbnet_write_cmd() instead of usbnet_read_cmd() and
remove the USB_DIR_IN flag.

Reported-and-tested-by: syzbot+2a0e7abd24f1eb90ce25@syzkaller.appspotmail.com
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: 090ffa9d0e90 ("[PATCH] USB: usbnet (9/9) module for pl2301/2302 cables")
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/00000000000052099f05f3b3e298@google.com/

---


[as1991]


Index: usb-devel/drivers/net/usb/plusb.c
===================================================================
--- usb-devel.orig/drivers/net/usb/plusb.c
+++ usb-devel/drivers/net/usb/plusb.c
@@ -57,9 +57,7 @@
 static inline int
 pl_vendor_req(struct usbnet *dev, u8 req, u8 val, u8 index)
 {
-	return usbnet_read_cmd(dev, req,
-				USB_DIR_IN | USB_TYPE_VENDOR |
-				USB_RECIP_DEVICE,
+	return usbnet_write_cmd(dev, req, USB_TYPE_VENDOR | USB_RECIP_DEVICE,
 				val, index, NULL, 0);
 }
 
