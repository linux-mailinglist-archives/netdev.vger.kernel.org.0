Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DF0FC2D4
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfKNJme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 04:42:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:33754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfKNJme (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 04:42:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CFFE2B11B;
        Thu, 14 Nov 2019 09:42:32 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        kai.heng.feng@canonical.com, netdev@vger.kernel.org,
        davem@davemloft.net
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH] rtl8712: fix race between firmware failing to load and disconnect
Date:   Thu, 14 Nov 2019 10:42:21 +0100
Message-Id: <20191114094221.3203-1-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a device is unplugged before the firmware is loaded the
disconnect() has to wait for the firmware load to finish.

The driver does that, but it does so in a racy manner. There are
two races here.
First, the wait is ended before the net device is registered,
which leads to a race between register and deregister.
Second, the wait is eneded before errors in the firmware load
are handled and the error is ignored during disconnect.

The fix is to do the complete() at the end of the handler for firmware
load. That requires splitting it for the normal and the error code
path. Furthermore the result of the firmware load needs to be checked
in the disconnect() method.

This fix was tested by syzbot, but it reported a different crash,
so I cannot claim a successful testing.

Reported-by: syzbot+80899a8a8efe8968cde7@syzkaller.appspotmail.com
Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/staging/rtl8712/hal_init.c | 3 ++-
 drivers/staging/rtl8712/usb_intf.c | 8 ++++++--
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/hal_init.c b/drivers/staging/rtl8712/hal_init.c
index 40145c0338e4..42c0a3c947f1 100644
--- a/drivers/staging/rtl8712/hal_init.c
+++ b/drivers/staging/rtl8712/hal_init.c
@@ -33,7 +33,6 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 {
 	struct _adapter *adapter = context;
 
-	complete(&adapter->rtl8712_fw_ready);
 	if (!firmware) {
 		struct usb_device *udev = adapter->dvobjpriv.pusbdev;
 		struct usb_interface *usb_intf = adapter->pusb_intf;
@@ -41,11 +40,13 @@ static void rtl871x_load_fw_cb(const struct firmware *firmware, void *context)
 		dev_err(&udev->dev, "r8712u: Firmware request failed\n");
 		usb_put_dev(udev);
 		usb_set_intfdata(usb_intf, NULL);
+		complete(&adapter->rtl8712_fw_ready);
 		return;
 	}
 	adapter->fw = firmware;
 	/* firmware available - start netdev */
 	register_netdev(adapter->pnetdev);
+	complete(&adapter->rtl8712_fw_ready);
 }
 
 static const char firmware_file[] = "rtlwifi/rtl8712u.bin";
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index ba1288297ee4..e6137603309c 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -595,10 +595,13 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	if (pnetdev) {
 		struct _adapter *padapter = netdev_priv(pnetdev);
 
-		usb_set_intfdata(pusb_intf, NULL);
-		release_firmware(padapter->fw);
 		/* never exit with a firmware callback pending */
 		wait_for_completion(&padapter->rtl8712_fw_ready);
+		pnetdev = usb_get_intfdata(pusb_intf);
+		usb_set_intfdata(pusb_intf, NULL);
+		if (!pnetdev)
+			goto raced_with_firmware_failure;
+		release_firmware(padapter->fw);
 		if (drvpriv.drv_registered)
 			padapter->surprise_removed = true;
 		unregister_netdev(pnetdev); /* will call netdev_close() */
@@ -609,6 +612,7 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 		r871x_dev_unload(padapter);
 		r8712_free_drv_sw(padapter);
 
+raced_with_firmware_failure:
 		/* decrease the reference count of the usb device structure
 		 * when disconnect
 		 */
-- 
2.16.4

