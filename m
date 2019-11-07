Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5AEF2A14
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 10:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387718AbfKGJEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 04:04:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:53340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbfKGJEN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 04:04:13 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE61EAF86;
        Thu,  7 Nov 2019 09:04:12 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] CDC-NCM: handle incomplete transfer of MTU
Date:   Thu,  7 Nov 2019 09:48:02 +0100
Message-Id: <20191107084802.10289-2-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191107084802.10289-1-oneukum@suse.com>
References: <20191107084802.10289-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A malicious device may give half an answer when asked
for its MTU. The driver will proceed after this with
a garbage MTU. Anything but a complete answer must be treated
as an error.

V2: used sizeof as request by Alexander

Reported-and-tested-by: syzbot+0631d878823ce2411636@syzkaller.appspotmail.com
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

