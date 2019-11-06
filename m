Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D435EF162E
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 13:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbfKFMjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 07:39:35 -0500
Received: from mx2.suse.de ([195.135.220.15]:56464 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727652AbfKFMjf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 07:39:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E0A0B1DF;
        Wed,  6 Nov 2019 12:39:33 +0000 (UTC)
Message-ID: <1573043012.3090.24.camel@suse.com>
Subject: Re: KMSAN: uninit-value in cdc_ncm_set_dgram_size
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+0631d878823ce2411636@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Date:   Wed, 06 Nov 2019 13:23:32 +0100
In-Reply-To: <00000000000013c4c1059625a655@google.com>
References: <00000000000013c4c1059625a655@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mittwoch, den 30.10.2019, 12:22 -0700 schrieb syzbot:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    96c6c319 net: kasan: kmsan: support CONFIG_GENERIC_CSUM on..
#syz test: https://github.com/google/kmsan.git 96c6c319

From 23a6624cf7d8e146c35f2eec135d6c22e24f9a2e Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Tue, 5 Nov 2019 12:04:44 +0100
Subject: [PATCH] CDC-NCM: handle incomplete transfer of MTU

A malicious device may give half an answer when asked
for its MTU. The driver will proceed after this with
a garbage MTU. Anything but a complete answer must be treated
as an error.

V2: used sizeof as request by Alexander

Reported-by: syzbot+0631d878823ce2411636@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/cdc_ncm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 00cab3f43a4c..a245597a3902 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -578,8 +578,8 @@ static void cdc_ncm_set_dgram_size(struct usbnet *dev, int new_size)
 	/* read current mtu value from device */
 	err = usbnet_read_cmd(dev, USB_CDC_GET_MAX_DATAGRAM_SIZE,
 			      USB_TYPE_CLASS | USB_DIR_IN | USB_RECIP_INTERFACE,
-			      0, iface_no, &max_datagram_size, 2);
-	if (err < 0) {
+			      0, iface_no, &max_datagram_size, sizeof(max_datagram_size));
+	if (err < sizeof(max_datagram_size)) {
 		dev_dbg(&dev->intf->dev, "GET_MAX_DATAGRAM_SIZE failed\n");
 		goto out;
 	}
@@ -590,7 +590,7 @@ static void cdc_ncm_set_dgram_size(struct usbnet *dev, int new_size)
 	max_datagram_size = cpu_to_le16(ctx->max_datagram_size);
 	err = usbnet_write_cmd(dev, USB_CDC_SET_MAX_DATAGRAM_SIZE,
 			       USB_TYPE_CLASS | USB_DIR_OUT | USB_RECIP_INTERFACE,
-			       0, iface_no, &max_datagram_size, 2);
+			       0, iface_no, &max_datagram_size, sizeof(max_datagram_size));
 	if (err < 0)
 		dev_dbg(&dev->intf->dev, "SET_MAX_DATAGRAM_SIZE failed\n");
 
-- 
2.16.4

