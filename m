Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8345B18770
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 11:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbfEIJIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 05:08:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:46124 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725872AbfEIJIv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 May 2019 05:08:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 78A1CB7B3;
        Thu,  9 May 2019 09:08:50 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     dmitry.bezrukov@aquantia.com, igor.russkikh@aquantia.com,
        netdev@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 3/3] aqc111: fix double endianness swap on BE
Date:   Thu,  9 May 2019 11:08:18 +0200
Message-Id: <20190509090818.9257-3-oneukum@suse.com>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190509090818.9257-1-oneukum@suse.com>
References: <20190509090818.9257-1-oneukum@suse.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you are using a function that does a swap in place,
you cannot just reuse the buffer on the assumption that it has
not been changed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/usb/aqc111.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 599d560a8450..b86c5ce9a92a 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -1428,7 +1428,7 @@ static int aqc111_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
-	u16 reg16;
+	u16 reg16, oldreg16;
 	u8 reg8;
 
 	netif_carrier_off(dev->net);
@@ -1444,9 +1444,11 @@ static int aqc111_resume(struct usb_interface *intf)
 	/* Configure RX control register => start operation */
 	reg16 = aqc111_data->rxctl;
 	reg16 &= ~SFR_RX_CTL_START;
+	/* needs to be saved in case endianness is swapped */
+	oldreg16 = reg16;
 	aqc111_write16_cmd_nopm(dev, AQ_ACCESS_MAC, SFR_RX_CTL, 2, &reg16);
 
-	reg16 |= SFR_RX_CTL_START;
+	reg16 = oldreg16 | SFR_RX_CTL_START;
 	aqc111_write16_cmd_nopm(dev, AQ_ACCESS_MAC, SFR_RX_CTL, 2, &reg16);
 
 	aqc111_set_phy_speed(dev, aqc111_data->autoneg,
-- 
2.16.4

