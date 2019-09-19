Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05CEFB7544
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 10:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388500AbfISIi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 04:38:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:56232 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388008AbfISIi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 04:38:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CD99CACC2;
        Thu, 19 Sep 2019 08:38:24 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] usbnet: sanity checking of packet sizes and device mtu
Date:   Thu, 19 Sep 2019 10:23:08 +0200
Message-Id: <20190919082309.23365-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a reset packet sizes and device mtu can change and need
to be reevaluated to calculate queue sizes.
Malicious devices can set this to zero and we divide by it.
Introduce sanity checking.

Reported-and-tested-by:  syzbot+6102c120be558c885f04@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/usbnet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 58952a79b05f..e44849499b89 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -339,6 +339,8 @@ void usbnet_update_max_qlen(struct usbnet *dev)
 {
 	enum usb_device_speed speed = dev->udev->speed;
 
+	if (!dev->rx_urb_size || !dev->hard_mtu)
+		goto insanity;
 	switch (speed) {
 	case USB_SPEED_HIGH:
 		dev->rx_qlen = MAX_QUEUE_MEMORY / dev->rx_urb_size;
@@ -355,6 +357,7 @@ void usbnet_update_max_qlen(struct usbnet *dev)
 		dev->tx_qlen = 5 * MAX_QUEUE_MEMORY / dev->hard_mtu;
 		break;
 	default:
+insanity:
 		dev->rx_qlen = dev->tx_qlen = 4;
 	}
 }
-- 
2.16.4

