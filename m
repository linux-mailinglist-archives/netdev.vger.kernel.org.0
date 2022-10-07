Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED3D5F7FD8
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 23:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiJGVY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 17:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiJGVY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 17:24:58 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9772F62F2;
        Fri,  7 Oct 2022 14:24:38 -0700 (PDT)
Received: from localhost.localdomain (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 103BF40786D7;
        Fri,  7 Oct 2022 21:24:35 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 103BF40786D7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1665177875;
        bh=FPLAsDXSrJKXKzu7XVJBAupHoVIjUYLA9XU1WyROiy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YyBO/mBLBpQRe6SOLc/qpcWBC418xZZRnE/hdhyedvo+1971OKb2LT195forLfw+6
         J+h4AqNp0hYQqecjwY+7/0k2t8FmNMbFG5CncEhY4cof8TcmQpfnu1B+gkctufRi5R
         xR6PtXMfRj19cgQod2JOIRfe/V5Jfu8OZxLHaSsI=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] ath9k: verify the expected usb_endpoints are present
Date:   Sat,  8 Oct 2022 00:24:13 +0300
Message-Id: <20221007212413.266531-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <87o7unczd4.fsf@toke.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
v1->v2: use reverse x-mas tree ordering of the variable definitions

 drivers/net/wireless/ath/ath9k/hif_usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 4d9002a9d082..7bbbeb411056 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1329,10 +1329,24 @@ static int send_eject_command(struct usb_interface *interface)
 static int ath9k_hif_usb_probe(struct usb_interface *interface,
 			       const struct usb_device_id *id)
 {
+	struct usb_endpoint_descriptor *bulk_in, *bulk_out, *int_in, *int_out;
 	struct usb_device *udev = interface_to_usbdev(interface);
+	struct usb_host_interface *alt;
 	struct hif_device_usb *hif_dev;
 	int ret = 0;
    
+	/* Verify the expected endpoints are present */
+	alt = interface->cur_altsetting;
+	if (usb_find_common_endpoints(alt, &bulk_in, &bulk_out, &int_in, &int_out) < 0 ||
+			usb_endpoint_num(bulk_in) != USB_WLAN_RX_PIPE ||
+			usb_endpoint_num(bulk_out) != USB_WLAN_TX_PIPE ||
+			usb_endpoint_num(int_in) != USB_REG_IN_PIPE ||
+			usb_endpoint_num(int_out) != USB_REG_OUT_PIPE) {
+		dev_err(&udev->dev,
+						"ath9k_htc: Device endpoint numbers are not the expected ones\n");
+		return -ENODEV;
+	}
+
 	if (id->driver_info == STORAGE_DEVICE)
 		return send_eject_command(interface);
 
-- 
2.25.1

