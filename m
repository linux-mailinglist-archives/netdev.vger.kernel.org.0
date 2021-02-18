Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A5031E8F1
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 12:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhBRLE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 06:04:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:52026 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232295AbhBRKVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 05:21:47 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1613643659; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8r4tolwZyVfbvMCX5pXmHREFtlQ2Ugkrpn7Tjvt9lq4=;
        b=Ryvi9YvMWXd4FUZC6xptQp5WJJd8zwTlrcqKKAbrQl3OnRS6b8s64Jd31NFeoEvpXP+NGN
        53V1ZM/nGqqjWUFaADltJIPmtqjt2XLgyB7Vg0YPOtnY3X71kF7F6BY5DH6bqj+NyIZR4A
        sCd7JXORR8R8XBzxV/POZHkEYb5b6Yk=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CCC40AE05;
        Thu, 18 Feb 2021 10:20:59 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, grundler@chromium.org, andrew@lunn.ch,
        davem@devemloft.org, hayeswang@realtek.com, kuba@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>, Roland Dreier <roland@kernel.org>
Subject: [PATCHv3 2/3] usbnet: add method for reporting speed without MDIO
Date:   Thu, 18 Feb 2021 11:20:37 +0100
Message-Id: <20210218102038.2996-3-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210218102038.2996-1-oneukum@suse.com>
References: <20210218102038.2996-1-oneukum@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The old method for reporting network speed upwards
assumed that a device uses MDIO and uses the generic phy
functions based on that.
Add a a primitive internal version not making the assumption
reporting back directly what the status operations record.

v2: rebased on upstream
v3: changed names and made clear which units are used

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/usbnet.c   | 11 +++++++----
 include/linux/usb/usbnet.h |  6 ++++--
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index f3e5ad9befd0..368428a4290b 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -971,10 +971,10 @@ int usbnet_get_link_ksettings_internal(struct net_device *net,
 	 * For wireless stuff it is not true.
 	 * We assume that rxspeed matters more.
 	 */
-	if (dev->rxspeed != SPEED_UNKNOWN)
-		cmd->base.speed = dev->rxspeed / 1000000;
-	else if (dev->txspeed != SPEED_UNKNOWN)
-		cmd->base.speed = dev->txspeed / 1000000;
+	if (dev->rx_speed != SPEED_UNSET)
+		cmd->base.speed = dev->rx_speed / 1000000;
+	else if (dev->tx_speed != SPEED_UNSET)
+		cmd->base.speed = dev->tx_speed / 1000000;
 	else
 		cmd->base.speed = SPEED_UNKNOWN;
 
@@ -1685,6 +1685,9 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->intf = udev;
 	dev->driver_info = info;
 	dev->driver_name = name;
+	/* cannot use 0, as simplex devices may exist */
+	dev->rx_speed = SPEED_UNSET; /* unknown or handled by MII */
+	dev->tx_speed = SPEED_UNSET; 
 
 	net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!net->tstats)
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 132c1b5e14bb..7f445c1e0003 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -53,6 +53,10 @@ struct usbnet {
 	u32			hard_mtu;	/* count any extra framing */
 	size_t			rx_urb_size;	/* size for rx urbs */
 	struct mii_if_info	mii;
+	/* These are bits per second unlike what ethernet uses */
+	long			rx_speed;	/* if MII is not used */
+	long			tx_speed;	/* if MII is not used */
+#		define SPEED_UNSET	-1
 
 	/* various kinds of pending driver work */
 	struct sk_buff_head	rxq;
@@ -81,8 +85,6 @@ struct usbnet {
 #		define EVENT_LINK_CHANGE	11
 #		define EVENT_SET_RX_MODE	12
 #		define EVENT_NO_IP_ALIGN	13
-	u32			rx_speed;	/* in bps - NOT Mbps */
-	u32			tx_speed;	/* in bps - NOT Mbps */
 };
 
 static inline struct usb_driver *driver_of(struct usb_interface *intf)
-- 
2.26.2

