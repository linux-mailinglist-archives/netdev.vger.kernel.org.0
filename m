Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 124B12F8BA9
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 06:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbhAPF2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 00:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbhAPF2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 00:28:10 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D1BC06179A
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 21:27:16 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id r9so10751334otk.11
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 21:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MQG99hmEs+jm/LvVCjiZprhkiqjwfzt+Jg3xINgEKjM=;
        b=LiZxsf4OcoSXehQoNzHnUlYjJxMgCQ+3xFvngfwsqKwT7lQizZj1IzW2M1345vvWCb
         sI/JB1jG55Ntixm1svalk1mLKw4m8FFZGRnDpnXOzZD2WHk2i+Iw3L9eUILQzH93vfG3
         OhP5nldvH311qffuxlpI2my3+06D+tvfKT020=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQG99hmEs+jm/LvVCjiZprhkiqjwfzt+Jg3xINgEKjM=;
        b=F5bS176gCAD9BYIpR6wTwHrLcacPEnkWo/IwwslstA0mupr34EJJfTJd9RQN/9vteS
         BXQ8TTZSeq/kJiy9awf6eKVkrmO1uNTYft+O3GVcwtw1nQcYFBLkaklAfJaVetj1oqXr
         ePqEcYYYW9UjP8uL7mN1BklVMAqPopdmQKToHinBG5SRHEX+pzEREPSuTuZ028ytFjC8
         Lx90PkPNQaEbEuRCZhPaFU9rAOVQX6mOVrP96Qx6UhJKS7yJVn7Mdj6NfzlVqvCFZA6c
         PBM8DPb49MBUC08sqe+ktAAXkZt05ZGTS+uFQqOsXcHZH15hRtTAoCfZtkINCIDG7BAZ
         XG4g==
X-Gm-Message-State: AOAM5339K+LiQXt9kejLcD/4+TsQ/fH9/CEiRKiBgZXidXA1AZEbMeGQ
        OLTcYH+2n9ylXXtmBSArYGzKJw==
X-Google-Smtp-Source: ABdhPJxukKQ1dpghDQU4L5E3YI7oypsEzcF9dQOmplV8O2VC++cgA+TXNjwmeGXB4BlVVbqLoxMT8w==
X-Received: by 2002:a05:6830:1605:: with SMTP id g5mr10750341otr.369.1610774834421;
        Fri, 15 Jan 2021 21:27:14 -0800 (PST)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id 94sm2359230otw.41.2021.01.15.21.27.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:27:13 -0800 (PST)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 3/3] net: usb: cdc_ncm: don't spew notifications
Date:   Fri, 15 Jan 2021 21:26:23 -0800
Message-Id: <20210116052623.3196274-3-grundler@chromium.org>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
In-Reply-To: <20210116052623.3196274-1-grundler@chromium.org>
References: <20210116052623.3196274-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTL8156 sends notifications about every 32ms.
Only display/log notifications when something changes.

This issue has been reported by others:
	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1832472
	https://lkml.org/lkml/2020/8/27/1083

...
[785962.779840] usb 1-1: new high-speed USB device number 5 using xhci_hcd
[785962.929944] usb 1-1: New USB device found, idVendor=0bda, idProduct=8156, bcdDevice=30.00
[785962.929949] usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=6
[785962.929952] usb 1-1: Product: USB 10/100/1G/2.5G LAN
[785962.929954] usb 1-1: Manufacturer: Realtek
[785962.929956] usb 1-1: SerialNumber: 000000001
[785962.991755] usbcore: registered new interface driver cdc_ether
[785963.017068] cdc_ncm 1-1:2.0: MAC-Address: 00:24:27:88:08:15
[785963.017072] cdc_ncm 1-1:2.0: setting rx_max = 16384
[785963.017169] cdc_ncm 1-1:2.0: setting tx_max = 16384
[785963.017682] cdc_ncm 1-1:2.0 usb0: register 'cdc_ncm' at usb-0000:00:14.0-1, CDC NCM, 00:24:27:88:08:15
[785963.019211] usbcore: registered new interface driver cdc_ncm
[785963.023856] usbcore: registered new interface driver cdc_wdm
[785963.025461] usbcore: registered new interface driver cdc_mbim
[785963.038824] cdc_ncm 1-1:2.0 enx002427880815: renamed from usb0
[785963.089586] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
[785963.121673] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
[785963.153682] cdc_ncm 1-1:2.0 enx002427880815: network connection: disconnected
...

This is about 2KB per second and will overwrite all contents of a 1MB
dmesg buffer in under 10 minutes rendering them useless for debugging
many kernel problems.

This is also an extra 180 MB/day in /var/logs (or 1GB per week) rendering
the majority of those logs useless too.

When the link is up (expected state), spew amount is >2x higher:
...
[786139.600992] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
[786139.632997] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
[786139.665097] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
[786139.697100] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
[786139.729094] cdc_ncm 2-1:2.0 enx002427880815: network connection: connected
[786139.761108] cdc_ncm 2-1:2.0 enx002427880815: 2500 mbit/s downlink 2500 mbit/s uplink
...

Chrome OS cannot support RTL8156 until this is fixed.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/cdc_ncm.c  | 12 +++++++++++-
 include/linux/usb/usbnet.h |  2 ++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 25498c311551..5de096545b86 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1827,6 +1827,15 @@ cdc_ncm_speed_change(struct usbnet *dev,
 	uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
 	uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
 
+	/* if the speed hasn't changed, don't report it.
+	 * RTL8156 shipped before 2021 sends notification about every 32ms.
+	 */
+	if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
+		return;
+
+	dev->rx_speed = rx_speed;
+	dev->tx_speed = tx_speed;
+
 	/*
 	 * Currently the USB-NET API does not support reporting the actual
 	 * device speed. Do print it instead.
@@ -1867,7 +1876,8 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
-		usbnet_link_change(dev, !!event->wValue, 0);
+		if (netif_carrier_ok(dev->net) != !!event->wValue)
+			usbnet_link_change(dev, !!event->wValue, 0);
 		break;
 
 	case USB_CDC_NOTIFY_SPEED_CHANGE:
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 88a7673894d5..cfbfd6fe01df 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -81,6 +81,8 @@ struct usbnet {
 #		define EVENT_LINK_CHANGE	11
 #		define EVENT_SET_RX_MODE	12
 #		define EVENT_NO_IP_ALIGN	13
+	u32			rx_speed;	/* in bps - NOT Mbps */
+	u32			tx_speed;	/* in bps - NOT Mbps */
 };
 
 static inline struct usb_driver *driver_of(struct usb_interface *intf)
-- 
2.29.2

