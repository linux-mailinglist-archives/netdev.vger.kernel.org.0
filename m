Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FA52FEAEA
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731532AbhAUM71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 07:59:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:59720 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731515AbhAUM63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 07:58:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611233861; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EAqAb0c/gKUwR+7CRnnZB9SlYFc+YG+OWUE8tf7gBOg=;
        b=slqDgIQSvYYWUEBQ0cWT/Ml1GnjlSC2bwBXlwdv3PyWPq6Ndii7KBiqrocADpkreBg1bu2
        tjni0IFd+wyEIsTAPXyxIkccRi5W9SCzckbIS/Y7SucW2ek9eWZUAi+eAfTqCxUHJiaP6O
        i5+aPn3B5c8zI+0nOQHxOHkQSUNOe7Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7FCA1AF45;
        Thu, 21 Jan 2021 12:57:41 +0000 (UTC)
From:   Oliver Neukum <oneukum@suse.com>
To:     hayeswang@realtek.com, grundler@chromium.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Oliver Neukum <oneukum@suse.com>, Roland Dreier <roland@kernel.org>
Subject: [PATCHv2 2/3] usbnet: add method for reporting speed without MDIO
Date:   Thu, 21 Jan 2021 13:57:30 +0100
Message-Id: <20210121125731.19425-3-oneukum@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210121125731.19425-1-oneukum@suse.com>
References: <20210121125731.19425-1-oneukum@suse.com>
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

v2: adjusted to recent changes

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
---
 drivers/net/usb/usbnet.c   | 23 +++++++++++++++++++++++
 include/linux/usb/usbnet.h |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index e2ca88259b05..6f8fcc276ca7 100644
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
+	if (dev->rxspeed != SPEED_UNKNOWN)
+		cmd->base.speed = dev->rxspeed / 1000000;
+	else if (dev->txspeed != SPEED_UNKNOWN)
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
+	dev->rxspeed = SPEED_UNKNOWN; /* unknown or handled by MII */
+	dev->txspeed = SPEED_UNKNOWN;
 
 	net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!net->tstats)
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index fd65b7a5ee15..a91c6defb104 100644
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
@@ -269,6 +271,8 @@ extern void usbnet_purge_paused_rxq(struct usbnet *);
 
 extern int usbnet_get_link_ksettings_mdio(struct net_device *net,
 				     struct ethtool_link_ksettings *cmd);
+extern int usbnet_get_link_ksettings_internal(struct net_device *net,
+					struct ethtool_link_ksettings *cmd);
 extern int usbnet_set_link_ksettings_mdio(struct net_device *net,
 				     const struct ethtool_link_ksettings *cmd);
 extern u32 usbnet_get_link(struct net_device *net);
-- 
2.26.2

