Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEFD2ECECB
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbhAGLgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:36:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:34794 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbhAGLgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 06:36:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610019332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SDwI1kyBVHZ2zJEGUiRkCfyCZxvAc4e5w8SOBN3YjMg=;
        b=rqvOCyiYrr4An+MKmomznWpebcv4LexT9ZpiDK03N4iVQh4Zj+rdu80Xu3FUJmN1nmMG13
        SPBKJgtygUKwap98xI7Z6e7zY3x5lkkzjVcaU0Q0Li3X+KSGfNv+ex8P6GeKzyHgFFnsOM
        TNOeHQcvWt0ta9Vm4tTc879t1ptLMc4=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 575A0B278;
        Thu,  7 Jan 2021 11:35:32 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 3/3] CDC-NCM: record speed in status method
Date:   Thu,  7 Jan 2021 12:35:18 +0100
Message-Id: <20210107113518.21322-4-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107113518.21322-1-oneukum@suse.com>
References: <20210107113518.21322-1-oneukum@suse.com>
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

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 3f90b2840b9c..50d3a4e6d445 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -142,7 +142,7 @@ static const struct ethtool_ops cdc_ncm_ethtool_ops = {
 	.get_sset_count    = cdc_ncm_get_sset_count,
 	.get_strings       = cdc_ncm_get_strings,
 	.get_ethtool_stats = cdc_ncm_get_ethtool_stats,
-	.get_link_ksettings      = usbnet_get_link_ksettings_mdio,
+	.get_link_ksettings      = usbnet_get_link_ksettings_internal,
 	.set_link_ksettings      = usbnet_set_link_ksettings_mdio,
 };
 
@@ -1823,21 +1823,8 @@ cdc_ncm_speed_change(struct usbnet *dev,
 	uint32_t rx_speed = le32_to_cpu(data->DLBitRRate);
 	uint32_t tx_speed = le32_to_cpu(data->ULBitRate);
 
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
+	dev->rxspeed = rx_speed;
+	dev->txspeed = tx_speed;
 }
 
 static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
-- 
2.26.2

