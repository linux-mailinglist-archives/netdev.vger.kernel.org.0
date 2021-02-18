Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA0A31E8F2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhBRLFU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 06:05:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:52048 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232778AbhBRKVs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 05:21:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613643660; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l/x4iMlDggMnBUsdHEaDEDcMBmkUbSP0bJrsIMgL6aw=;
        b=iu1XhflfJtUP76iKKP/Nwgto4j6KDDmLJCyRyvzP496qtC6NZTjgR+2Jd3RnKZA06BRMKS
        Q/WoMgaA0P4pSf1OdV9ZRS/jv4nxfotj0PQUM03m0dZA1uo44fmN/sXYDwudXKy1+01tK2
        Z3sIZIVZtuwOGzMQdu/7mR02uRysbU8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2268BAE12;
        Thu, 18 Feb 2021 10:21:00 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, grundler@chromium.org, andrew@lunn.ch,
        davem@devemloft.org, hayeswang@realtek.com, kuba@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>, Roland Dreier <roland@kernel.org>
Subject: [PATCHv3 3/3] CDC-NCM: record speed in status method
Date:   Thu, 18 Feb 2021 11:20:38 +0100
Message-Id: <20210218102038.2996-4-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218102038.2996-1-oneukum@suse.com>
References: <20210218102038.2996-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver has a status method for receiving speed updates.
The framework, however, had support functions only for devices
that reported their speed upon an explicit query over a MDIO
interface.
CDC_NCM however gets direct notifications from the device.
As new support functions have become available, we shall now
record such notifications and tell the usbnet framework
to make direct use of them without going through the PHY layer.

v2: rebased on upstream
v3: changed variable names

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 0d26cbeb6e04..74c1a86b1a71 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1829,30 +1829,9 @@ cdc_ncm_speed_change(struct usbnet *dev,
 	uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
 	uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
 
-	/* if the speed hasn't changed, don't report it.
-	 * RTL8156 shipped before 2021 sends notification about every 32ms.
-	 */
-	if (dev->rx_speed == rx_speed && dev->tx_speed == tx_speed)
-		return;
-
+	 /* RTL8156 shipped before 2021 sends notification about every 32ms. */
 	dev->rx_speed = rx_speed;
 	dev->tx_speed = tx_speed;
-
-	/*
-	 * Currently the USB-NET API does not support reporting the actual
-	 * device speed. Do print it instead.
-	 */
-	if ((tx_speed > 1000000) && (rx_speed > 1000000)) {
-		netif_info(dev, link, dev->net,
-			   "%u mbit/s downlink %u mbit/s uplink\n",
-			   (unsigned int)(rx_speed / 1000000U),
-			   (unsigned int)(tx_speed / 1000000U));
-	} else {
-		netif_info(dev, link, dev->net,
-			   "%u kbit/s downlink %u kbit/s uplink\n",
-			   (unsigned int)(rx_speed / 1000U),
-			   (unsigned int)(tx_speed / 1000U));
-	}
 }
 
 static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
-- 
2.26.2

