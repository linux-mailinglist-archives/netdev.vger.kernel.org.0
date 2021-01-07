Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2802ECECD
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 12:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbhAGLgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 06:36:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:34778 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbhAGLgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 06:36:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610019332; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TWairs63o8FoidEMAeyc1nuTsFfkhEiBLRPV4UW0Jx0=;
        b=Gwupa0jMKAhrHE7SN8W/S9a1u6jNj0f+z4RzuGg3nCBWTo1PzadGSLLaBNjpQecQJZNT7r
        eXObae/S2T0/SPePBfHNiuqz0SlIqG1XVnaPton1sAkSivkFUT5k170TtcXADT5kt+4EWC
        TbNy5CvW8QrozPur4wu1OMCk6sT1jis=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1D936AFB4;
        Thu,  7 Jan 2021 11:35:32 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, roland@kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 2/3] usbnet: add method for reporting speed without MDIO
Date:   Thu,  7 Jan 2021 12:35:17 +0100
Message-Id: <20210107113518.21322-3-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210107113518.21322-1-oneukum@suse.com>
References: <20210107113518.21322-1-oneukum@suse.com>
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

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/usbnet.c   | 23 +++++++++++++++++++++++
 include/linux/usb/usbnet.h |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index e2ca88259b05..fe702ef32007 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -961,6 +961,27 @@ int usbnet_get_link_ksettings_mdio(struct net_device *net,
 }
 EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mdio);
 
+int usbnet_get_link_ksettings_internal(struct net_device *net,
+					struct ethtool_link_ksettings *cmd)
+{
+	struct usbnet *dev = netdev_priv(net);
+
+	/* the assumption that speed is equal on tx and rx
+	 * is deeply engrained into the networking layer.
+	 * For wireless stuff it is not true.
+	 * We assume that rxspeed matters more.
+	 */
+	if (dev->rxspeed != -1)
+		cmd->base.speed = dev->rxspeed / 1000000;
+	else if (dev->txspeed != -1)
+		cmd->base.speed = dev->txspeed / 1000000;
+	else
+		cmd->base.speed = SPEED_UNKNOWN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);
+
 int usbnet_set_link_ksettings_mdio(struct net_device *net,
 			      const struct ethtool_link_ksettings *cmd)
 {
@@ -1664,6 +1685,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->intf = udev;
 	dev->driver_info = info;
 	dev->driver_name = name;
+	dev->rxspeed = -1; /* unknown or handled by MII */
+	dev->txspeed = -1;
 
 	net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!net->tstats)
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index 407469ee224f..6a3677c0f113 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -53,6 +53,8 @@ struct usbnet {
 	u32			hard_mtu;	/* count any extra framing */
 	size_t			rx_urb_size;	/* size for rx urbs */
 	struct mii_if_info	mii;
+	long			rxspeed;	/* if MII is not used */
+	long			txspeed;	/* if MII is not used */
 
 	/* various kinds of pending driver work */
 	struct sk_buff_head	rxq;
@@ -267,6 +269,8 @@ extern void usbnet_purge_paused_rxq(struct usbnet *);
 
 extern int usbnet_get_link_ksettings_mdio(struct net_device *net,
 				     struct ethtool_link_ksettings *cmd);
+extern int usbnet_get_link_ksettings_internal(struct net_device *net,
+					struct ethtool_link_ksettings *cmd);
 extern int usbnet_set_link_ksettings_mdio(struct net_device *net,
 				     const struct ethtool_link_ksettings *cmd);
 extern u32 usbnet_get_link(struct net_device *net);
-- 
2.26.2

