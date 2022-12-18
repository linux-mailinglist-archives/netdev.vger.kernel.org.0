Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11A1650335
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiLRQ7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232764AbiLRQ5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:57:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B24120AA;
        Sun, 18 Dec 2022 08:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E94660DB4;
        Sun, 18 Dec 2022 16:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1B7C433D2;
        Sun, 18 Dec 2022 16:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380420;
        bh=4xmynnMz3+JjRHot5r8wn2MX123cygI6NTvhMupfm0k=;
        h=From:To:Cc:Subject:Date:From;
        b=d0TJHzM2TIMNGEqMLr6XSvycRPi7rsiw2I066+Kel0WbbcEFqU0UEoX9jo1fRvDDc
         tQboEu30oGoxiR90UPX9++2PTO42rOwgVdg/Vnv9VDbCjnmoA5DlbGC97aguC+kOcp
         ixOsOcBGne4wD+ONVzr3tyaZeD9SOCTZjSNDLS7LkHsm/Imh0PdDzymJHlxjzCai3Y
         NNuE+a7ON9xBGwJXluDOH4zMq0iXLqnxrTi2VeMZqJz7e2a7tCMDJH42DRuoNTVxC5
         xymnq0PMUcJ76WxjPb+KGogZNOJP6jEptKmKMBgYgzQsYfOpTvTN0yyEJyg9lh2xiq
         /CfqciMtNs/1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Alan Stern <stern@rowland.harvard.edu>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 01/26] wifi: ath9k: verify the expected usb_endpoints are present
Date:   Sun, 18 Dec 2022 11:19:51 -0500
Message-Id: <20221218162016.934280-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 16ef02bad239f11f322df8425d302be62f0443ce ]

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
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221008211532.74583-1-pchelkin@ispras.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index c8c7afe0e343..fddfab6b35da 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1330,10 +1330,24 @@ static int send_eject_command(struct usb_interface *interface)
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
+	    usb_endpoint_num(bulk_in) != USB_WLAN_RX_PIPE ||
+	    usb_endpoint_num(bulk_out) != USB_WLAN_TX_PIPE ||
+	    usb_endpoint_num(int_in) != USB_REG_IN_PIPE ||
+	    usb_endpoint_num(int_out) != USB_REG_OUT_PIPE) {
+		dev_err(&udev->dev,
+			"ath9k_htc: Device endpoint numbers are not the expected ones\n");
+		return -ENODEV;
+	}
+
 	if (id->driver_info == STORAGE_DEVICE)
 		return send_eject_command(interface);
 
-- 
2.35.1

