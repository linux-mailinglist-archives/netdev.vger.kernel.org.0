Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD80E3B2964
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhFXHhm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:37:42 -0400
Received: from out0.migadu.com ([94.23.1.103]:25753 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231638AbhFXHhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 03:37:41 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1624520121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WtRNll+ZJ6pXyBsiyWqUKQEx5bX3swnM8hdPj0hfXss=;
        b=lErlhr+TcTRagg7IABfZGUyPVw+Qi/P5cwBaUzq1w8Ct35xluH5GLEl/L/VU8ixUjWmUoO
        FLOcvBhaT2rDq9At38K8HWD+vtbm7khOA0nX+S8F+owBg8VTu9MtkuPEy2DUU5DafNysS8
        vUu5tFCcXAPHhghkdQKONVnYMMXhN9M=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     oneukum@suse.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH] usbnet: add usbnet_event_names[] for kevent
Date:   Thu, 24 Jun 2021 15:35:08 +0800
Message-Id: <20210624073508.10094-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify the netdev_dbg content from int to char * in usbnet_defer_kevent(),
this looks more readable.

Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 drivers/net/usb/usbnet.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 57a5a025255c..264b5048d0fb 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -74,6 +74,23 @@ MODULE_PARM_DESC (msg_level, "Override default message level");
 
 /*-------------------------------------------------------------------------*/
 
+static const char * const usbnet_event_names[] = {
+	[EVENT_TX_HALT]		   = "EVENT_TX_HALT",
+	[EVENT_RX_HALT]		   = "EVENT_RX_HALT",
+	[EVENT_RX_MEMORY]	   = "EVENT_RX_MEMORY",
+	[EVENT_STS_SPLIT]	   = "EVENT_STS_SPLIT",
+	[EVENT_LINK_RESET]	   = "EVENT_LINK_RESET",
+	[EVENT_RX_PAUSED]	   = "EVENT_RX_PAUSED",
+	[EVENT_DEV_ASLEEP]	   = "EVENT_DEV_ASLEEP",
+	[EVENT_DEV_OPEN]	   = "EVENT_DEV_OPEN",
+	[EVENT_DEVICE_REPORT_IDLE] = "EVENT_DEVICE_REPORT_IDLE",
+	[EVENT_NO_RUNTIME_PM]	   = "EVENT_NO_RUNTIME_PM",
+	[EVENT_RX_KILL]		   = "EVENT_RX_KILL",
+	[EVENT_LINK_CHANGE]	   = "EVENT_LINK_CHANGE",
+	[EVENT_SET_RX_MODE]	   = "EVENT_SET_RX_MODE",
+	[EVENT_NO_IP_ALIGN]	   = "EVENT_NO_IP_ALIGN",
+};
+
 /* handles CDC Ethernet and many other network "bulk data" interfaces */
 int usbnet_get_endpoints(struct usbnet *dev, struct usb_interface *intf)
 {
@@ -452,9 +469,9 @@ void usbnet_defer_kevent (struct usbnet *dev, int work)
 {
 	set_bit (work, &dev->flags);
 	if (!schedule_work (&dev->kevent))
-		netdev_dbg(dev->net, "kevent %d may have been dropped\n", work);
+		netdev_dbg(dev->net, "kevent %s may have been dropped\n", usbnet_event_names[work]);
 	else
-		netdev_dbg(dev->net, "kevent %d scheduled\n", work);
+		netdev_dbg(dev->net, "kevent %s scheduled\n", usbnet_event_names[work]);
 }
 EXPORT_SYMBOL_GPL(usbnet_defer_kevent);
 
-- 
2.32.0

