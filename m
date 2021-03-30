Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DEC34DE24
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 04:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhC3CSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 22:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbhC3CR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 22:17:57 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24CBAC061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:57 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id c3so14521759qkc.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 19:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BrKJq+y1GuzRwfKPTCvE+h8pj1S9+lGN2zn6+F+gTD0=;
        b=RgaXnkoyiz9Kv5mSthUwx7jaTmw5Cd2y2v4qktPE7hSXwUEaK5vdu5ZiTXzOWIGHx+
         /8nzbhOL6BMJIk93RQmgi0mb4+TKNGWtkHXy8uX5jeHwQJrpjLbDLD1NGQdmggEa59pH
         7JxTAukmP7UO6pj8zoSvmzgw1+2E5uHfriags=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BrKJq+y1GuzRwfKPTCvE+h8pj1S9+lGN2zn6+F+gTD0=;
        b=B94zI03dL0YxgWGn2/eGuyDMavw8naJsMZWDEugi6Yp9W5e3TDNSe9KEZ6f2G4DdZ/
         j0gAM1J2wL43NACTrfOYBwx7wYi0DUSOwq+i+SNB82OWtAYOTRQnOA/VXzrtJfcrEj5Q
         5Mmsgn948kBw6yU6gbW5LDPoMlLZge3CeQpeSob3lsj1ea56vF5ROFL81r4cGGBSjdXD
         QhYJJ42HH696At9ufZ+b/qDNETgFO7YEyPyQuEfss8jmO3+OiAbB9HQVjUO8KM8zR5Xa
         7hF070iDHBwWCqlzCg3Cb4YMuIs/bxIMWvYnDaRsrVNPDUEBDIgnwMuCCWrQysrkTs6B
         azVw==
X-Gm-Message-State: AOAM531oGAapt+yZwaevZU/9x2gIsgAQN02e+T836e7dpjeFbxp5ITRB
        sOvtqOv0eClSLzV+IIryG+H9jw==
X-Google-Smtp-Source: ABdhPJzjBf4u008tnjanJIgqSreQm2rbNiVZJTlGJVO3M99eOIY6v7OeOT5y3zcmeOTT77jgUOTchQ==
X-Received: by 2002:a05:620a:a8b:: with SMTP id v11mr27007279qkg.414.1617070676435;
        Mon, 29 Mar 2021 19:17:56 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id j30sm12433067qtv.90.2021.03.29.19.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 19:17:56 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oneukum@suse.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     Roland Dreier <roland@kernel.org>, nic_swsd <nic_swsd@realtek.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCHv4 2/4] usbnet: add method for reporting speed without MII
Date:   Mon, 29 Mar 2021 19:16:49 -0700
Message-Id: <20210330021651.30906-3-grundler@chromium.org>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210330021651.30906-1-grundler@chromium.org>
References: <20210330021651.30906-1-grundler@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

The old method for reporting link speed assumed a driver uses the
generic phy (mii) MDIO read/write functions. CDC devices don't
expose the phy.

Add a primitive internal version reporting back directly what
the CDC notification/status operations recorded.

v2: rebased on upstream
v3: changed names and made clear which units are used
v4: moved hunks to correct patch; rewrote commmit messages

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Tested-by: Roland Dreier <roland@kernel.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Tested-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/usbnet.c   | 23 +++++++++++++++++++++++
 include/linux/usb/usbnet.h |  7 +++++--
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 5b4629c80b4b..ecf62849f4c1 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -961,6 +961,27 @@ int usbnet_get_link_ksettings_mii(struct net_device *net,
 }
 EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_mii);
 
+int usbnet_get_link_ksettings_internal(struct net_device *net,
+					struct ethtool_link_ksettings *cmd)
+{
+	struct usbnet *dev = netdev_priv(net);
+
+	/* the assumption that speed is equal on tx and rx
+	 * is deeply engrained into the networking layer.
+	 * For wireless stuff it is not true.
+	 * We assume that rx_speed matters more.
+	 */
+	if (dev->rx_speed != SPEED_UNSET)
+		cmd->base.speed = dev->rx_speed / 1000000;
+	else if (dev->tx_speed != SPEED_UNSET)
+		cmd->base.speed = dev->tx_speed / 1000000;
+	else
+		cmd->base.speed = SPEED_UNKNOWN;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(usbnet_get_link_ksettings_internal);
+
 int usbnet_set_link_ksettings_mii(struct net_device *net,
 			      const struct ethtool_link_ksettings *cmd)
 {
@@ -1664,6 +1685,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	dev->intf = udev;
 	dev->driver_info = info;
 	dev->driver_name = name;
+	dev->rx_speed = SPEED_UNSET;
+	dev->tx_speed = SPEED_UNSET;
 
 	net->tstats = netdev_alloc_pcpu_stats(struct pcpu_sw_netstats);
 	if (!net->tstats)
diff --git a/include/linux/usb/usbnet.h b/include/linux/usb/usbnet.h
index a89e1452107d..8336e86ce606 100644
--- a/include/linux/usb/usbnet.h
+++ b/include/linux/usb/usbnet.h
@@ -53,6 +53,9 @@ struct usbnet {
 	u32			hard_mtu;	/* count any extra framing */
 	size_t			rx_urb_size;	/* size for rx urbs */
 	struct mii_if_info	mii;
+	long			rx_speed;	/* If MII not used */
+	long			tx_speed;	/* If MII not used */
+#		define SPEED_UNSET	-1
 
 	/* various kinds of pending driver work */
 	struct sk_buff_head	rxq;
@@ -81,8 +84,6 @@ struct usbnet {
 #		define EVENT_LINK_CHANGE	11
 #		define EVENT_SET_RX_MODE	12
 #		define EVENT_NO_IP_ALIGN	13
-	u32			rx_speed;	/* in bps - NOT Mbps */
-	u32			tx_speed;	/* in bps - NOT Mbps */
 };
 
 static inline struct usb_driver *driver_of(struct usb_interface *intf)
@@ -271,6 +272,8 @@ extern int usbnet_get_link_ksettings_mii(struct net_device *net,
 				     struct ethtool_link_ksettings *cmd);
 extern int usbnet_set_link_ksettings_mii(struct net_device *net,
 				     const struct ethtool_link_ksettings *cmd);
+extern int usbnet_get_link_ksettings_internal(struct net_device *net,
+				     struct ethtool_link_ksettings *cmd);
 extern u32 usbnet_get_link(struct net_device *net);
 extern u32 usbnet_get_msglevel(struct net_device *);
 extern void usbnet_set_msglevel(struct net_device *, u32);
-- 
2.30.1

