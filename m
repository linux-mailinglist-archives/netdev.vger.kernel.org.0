Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466FE5ABED9
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 14:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiICMFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 08:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiICMFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 08:05:04 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC03275C8;
        Sat,  3 Sep 2022 05:05:00 -0700 (PDT)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 8850440737B2;
        Sat,  3 Sep 2022 12:04:54 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] ath9k: verify the expected usb_endpoints are present
Date:   Sat,  3 Sep 2022 15:04:24 +0300
Message-Id: <20220903120424.12472-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug arises when a USB device claims to be an ATH9K but doesn't
have the expected endpoints. (In this case there was an interrupt
endpoint where the driver expected a bulk endpoint.) The kernel
needs to be able to handle such devices without getting an internal error.

usb 1-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 3 PID: 500 at drivers/usb/core/urb.c:493 usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
Modules linked in:
CPU: 3 PID: 500 Comm: kworker/3:2 Not tainted 5.10.135-syzkaller #0
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
Workqueue: events request_firmware_work_func
RIP: 0010:usb_submit_urb+0xce2/0x1430 drivers/usb/core/urb.c:493
Call Trace:
 ath9k_hif_usb_alloc_rx_urbs drivers/net/wireless/ath/ath9k/hif_usb.c:908 [inline]
 ath9k_hif_usb_alloc_urbs+0x75e/0x1010 drivers/net/wireless/ath/ath9k/hif_usb.c:1019
 ath9k_hif_usb_dev_init drivers/net/wireless/ath/ath9k/hif_usb.c:1109 [inline]
 ath9k_hif_usb_firmware_cb+0x142/0x530 drivers/net/wireless/ath/ath9k/hif_usb.c:1242
 request_firmware_work_func+0x12e/0x240 drivers/base/firmware_loader/main.c:1097
 process_one_work+0x9af/0x1600 kernel/workqueue.c:2279
 worker_thread+0x61d/0x12f0 kernel/workqueue.c:2425
 kthread+0x3b4/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:299

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 4d9002a9d082..2b26acf409fc 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1332,6 +1332,20 @@ static int ath9k_hif_usb_probe(struct usb_interface *interface,
 	struct usb_device *udev = interface_to_usbdev(interface);
 	struct hif_device_usb *hif_dev;
 	int ret = 0;
+	struct usb_host_interface *alt;
+	struct usb_endpoint_descriptor *bulk_in, *bulk_out, *int_in, *int_out;
+
+	/* Verify the expected endpoints are present */
+	alt = interface->cur_altsetting;
+	if (usb_find_common_endpoints(alt, &bulk_in, &bulk_out, &int_in, &int_out) < 0 ||
+			usb_endpoint_num(bulk_in) != USB_WLAN_RX_PIPE ||
+			usb_endpoint_num(bulk_out) != USB_WLAN_TX_PIPE ||
+			usb_endpoint_num(int_in) != USB_REG_IN_PIPE ||
+			usb_endpoint_num(int_out) != USB_REG_OUT_PIPE) {
+		dev_err(&udev->dev,
+				"ath9k_htc: Device endpoint numbers are not the expected ones\n");
+		return -ENODEV;
+	}
 
 	if (id->driver_info == STORAGE_DEVICE)
 		return send_eject_command(interface);
-- 
2.25.1

