Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826523ADBEE
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhFSWDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Jun 2021 18:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhFSWDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Jun 2021 18:03:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A56C061756
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 15:01:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1luj1q-0005YE-5N
        for netdev@vger.kernel.org; Sun, 20 Jun 2021 00:01:26 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6210063F817
        for <netdev@vger.kernel.org>; Sat, 19 Jun 2021 22:01:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AAC6663F7EA;
        Sat, 19 Jun 2021 22:01:19 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1f9ffb67;
        Sat, 19 Jun 2021 22:01:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Pavel Skripkin <paskripkin@gmail.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 5/5] net: can: ems_usb: fix use-after-free in ems_usb_disconnect()
Date:   Sun, 20 Jun 2021 00:01:15 +0200
Message-Id: <20210619220115.2830761-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210619220115.2830761-1-mkl@pengutronix.de>
References: <20210619220115.2830761-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

In ems_usb_disconnect() dev pointer, which is netdev private data, is
used after free_candev() call:
| 	if (dev) {
| 		unregister_netdev(dev->netdev);
| 		free_candev(dev->netdev);
|
| 		unlink_all_urbs(dev);
|
| 		usb_free_urb(dev->intr_urb);
|
| 		kfree(dev->intr_in_buffer);
| 		kfree(dev->tx_msg_buffer);
| 	}

Fix it by simply moving free_candev() at the end of the block.

Fail log:
| BUG: KASAN: use-after-free in ems_usb_disconnect
| Read of size 8 at addr ffff88804e041008 by task kworker/1:2/2895
|
| CPU: 1 PID: 2895 Comm: kworker/1:2 Not tainted 5.13.0-rc5+ #164
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-0-g155821a-rebuilt.opensuse.4
| Workqueue: usb_hub_wq hub_event
| Call Trace:
|     dump_stack (lib/dump_stack.c:122)
|     print_address_description.constprop.0.cold (mm/kasan/report.c:234)
|     kasan_report.cold (mm/kasan/report.c:420 mm/kasan/report.c:436)
|     ems_usb_disconnect (drivers/net/can/usb/ems_usb.c:683 drivers/net/can/usb/ems_usb.c:1058)

Fixes: 702171adeed3 ("ems_usb: Added support for EMS CPC-USB/ARM7 CAN/USB interface")
Link: https://lore.kernel.org/r/20210617185130.5834-1-paskripkin@gmail.com
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/usb/ems_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/ems_usb.c b/drivers/net/can/usb/ems_usb.c
index 5af69787d9d5..0a37af4a3fa4 100644
--- a/drivers/net/can/usb/ems_usb.c
+++ b/drivers/net/can/usb/ems_usb.c
@@ -1053,7 +1053,6 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 
 	if (dev) {
 		unregister_netdev(dev->netdev);
-		free_candev(dev->netdev);
 
 		unlink_all_urbs(dev);
 
@@ -1061,6 +1060,8 @@ static void ems_usb_disconnect(struct usb_interface *intf)
 
 		kfree(dev->intr_in_buffer);
 		kfree(dev->tx_msg_buffer);
+
+		free_candev(dev->netdev);
 	}
 }
 
-- 
2.30.2


