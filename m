Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFB33C7F36
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 09:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238248AbhGNHTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 03:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238079AbhGNHS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 03:18:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59F8C061574;
        Wed, 14 Jul 2021 00:16:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w15so1438584pgk.13;
        Wed, 14 Jul 2021 00:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s/vkP9zFndS5QwsUYMs5xfsGi1o0m0PYYdR1BcFKwpo=;
        b=bMNor0f4H8tDE4My6LHw4hzzoIUzfV7llzMR1Q0gOQJAET+cB7UD1sJdoNvnloc5HU
         2ibTcUT3QvKDAl1HkDwxjxG7i0Uw75Z53PK6at85fCpLE9hGdRm+F69XdjPLjyKTDArI
         l4FrfLUh38PuByNSZAigCVh7XUPXaE4+YUbtyYz/ca9eU1MSGbG3LAQ3BM1qAUU4mlpb
         WGgnMMG7qjf9pS4Lu4t8KxFnIDVK+TaEXn9py6jm8SizYqHIerGcy0OudVKLWuYXD9jG
         idLOKtAYci/YaMyc8TvZnc8z7zli+m14zsjedYw28kO/wgxVxRvrbruowNbtPzTtSYS9
         pm3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s/vkP9zFndS5QwsUYMs5xfsGi1o0m0PYYdR1BcFKwpo=;
        b=Z8vaGRE0N9ovBPTTUh+R9SrjMHcKwf/mw+uk6/HKsdrxnSjTFAoiE9O8dlsQSXPR9n
         G5euksnKwJ0DIXP46iwoH3Ly7rvqTbn9of2k8mfwEOF3FVWlgOr3WAtBwTXngi0XoSx4
         r40ziVEh+0TLTtZ/ST+UzKYnRTrPADkt0h1UVRQ6bOLwl1eTaiN1JueKapEkpJifs5Am
         aZzoam4V86NC6/IwYsvnQbPUPuzUcs1//JTbuso6GuylRXNgRXfp4iiFMZxbDqHrtNRx
         pc6ZcivfuWY3mo44NTZ9qfBuQZVZaitXDYsv0AYxkhI5/FwJxD6Q9z3pxaEwIkmfy2Pa
         LykQ==
X-Gm-Message-State: AOAM532jom0N+1MYOhnLtXmga5wYiBiQec0BG+ZZT/jZ+GCMvbxjZrh+
        zkU6Fwd2S6jQb0JwZxWW2KFkaxpK/Y2Qht9O
X-Google-Smtp-Source: ABdhPJzQxbAoDoXMzDygeSjb6OQcENI2/DntUCEC7TQqNH462/RjrCftOUVn/NBJ26aROqluYXtnrA==
X-Received: by 2002:aa7:84c1:0:b029:32d:6bbf:b788 with SMTP id x1-20020aa784c10000b029032d6bbfb788mr8690211pfn.38.1626246968311;
        Wed, 14 Jul 2021 00:16:08 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id 133sm1583623pfx.39.2021.07.14.00.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 00:16:07 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] usb: hso: fix error handling code of hso_create_net_device
Date:   Wed, 14 Jul 2021 15:15:32 +0800
Message-Id: <20210714071547.656587-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current error handling code of hso_create_net_device is
hso_free_net_device, no matter which errors lead to. For example,
WARNING in hso_free_net_device [1].

Fix this by refactoring the error handling code of
hso_create_net_device by handling different errors by different code.

[1] https://syzkaller.appspot.com/bug?id=66eff8d49af1b28370ad342787413e35bbe76efe

Reported-by: syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com
Fixes: 5fcfb6d0bfcd ("hso: fix bailout in error case of probe")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/usb/hso.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 54ef8492ca01..90fa4d9fa119 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2495,7 +2495,9 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		kfree(hso_dev);
+	usb_free_urb(hso_net->mux_bulk_tx_urb);
+		return NULL;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2508,13 +2510,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 				      USB_DIR_IN);
 	if (!hso_net->in_endp) {
 		dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
-		goto exit;
+		goto err_get_ep;
 	}
 	hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
 				       USB_DIR_OUT);
 	if (!hso_net->out_endp) {
 		dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
-		goto exit;
+		goto err_get_ep;
 	}
 	SET_NETDEV_DEV(net, &interface->dev);
 	SET_NETDEV_DEVTYPE(net, &hso_type);
@@ -2523,18 +2525,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_urb_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
 							   GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_buf_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_urb)
-		goto exit;
+		goto err_mux_bulk_tx;
 	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_buf)
-		goto exit;
+		goto err_mux_bulk_tx;
 
 	add_net_device(hso_dev);
 
@@ -2542,7 +2544,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_register;
 	}
 
 	hso_log_port(hso_dev);
@@ -2550,8 +2552,23 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	hso_create_rfkill(hso_dev, interface);
 
 	return hso_dev;
-exit:
-	hso_free_net_device(hso_dev, true);
+
+err_register:
+	unregister_netdev(net);
+	remove_net_device(hso_dev);
+err_mux_bulk_tx:
+	kfree(hso_net->mux_bulk_tx_buf);
+	hso_net->mux_bulk_tx_buf = NULL;
+	usb_free_urb(hso_net->mux_bulk_tx_urb);
+err_mux_bulk_rx:
+	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
+		usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
+		kfree(hso_net->mux_bulk_rx_buf_pool[i]);
+		hso_net->mux_bulk_rx_buf_pool[i] = NULL;
+	}
+err_get_ep:
+	free_netdev(net);
+	kfree(hso_dev);
 	return NULL;
 }
 
-- 
2.25.1

