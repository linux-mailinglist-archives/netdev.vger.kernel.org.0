Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFC8D3C893D
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 19:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237291AbhGNRDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 13:03:22 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:36288 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236757AbhGNRDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 13:03:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 18E9C1FD81;
        Wed, 14 Jul 2021 17:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1626282028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uK1jDWvfp4o3gXMAOL964WiWQKouHwsE0yAiJdG9uqM=;
        b=b4GFVqGcRJxz0Q5bV0bX8bqHjtMzMT3ajAshuusxbPup3eyRQlEmKX2tW5D1Md1xPDJzfG
        srXF2FNPaeo333u5Dt8r152e7xANciwq7XpPaT1qgtEr+JOTwd4wqVFkD5v3q/I4LVyOdr
        93CI9uzj/PYi8/r2CPAB2DyB9tp80/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1626282028;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uK1jDWvfp4o3gXMAOL964WiWQKouHwsE0yAiJdG9uqM=;
        b=c9l2q1C6eOaMd/DNI7AmIteL0U3O263KI3wD7rm7UmjhzDWAqVE2TOiDshcXnFflxVK11D
        R7Efiid7DwpJxUAg==
Received: from alsa1.nue.suse.com (alsa1.suse.de [10.160.4.42])
        by relay2.suse.de (Postfix) with ESMTP id 12846A3B88;
        Wed, 14 Jul 2021 17:00:28 +0000 (UTC)
From:   Takashi Iwai <tiwai@suse.de>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 2/2] r8152: Fix a deadlock by doubly PM resume
Date:   Wed, 14 Jul 2021 19:00:22 +0200
Message-Id: <20210714170022.8162-3-tiwai@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210714170022.8162-1-tiwai@suse.de>
References: <20210714170022.8162-1-tiwai@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

r8152 driver sets up the MAC address at reset-resume, while
rtl8152_set_mac_address() has the temporary autopm get/put.  This may
lead to a deadlock as the PM lock has been already taken for the
execution of the runtime PM callback.

This patch adds the workaround to avoid the superfluous autpm when
called from rtl8152_reset_resume().

Link: https://bugzilla.suse.com/show_bug.cgi?id=1186194
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/net/usb/r8152.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4096e20e9725..e09b107b5c99 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1552,7 +1552,8 @@ static int
 rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
 		  u32 advertising);
 
-static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
+static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
+				     bool in_resume)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	struct sockaddr *addr = p;
@@ -1561,9 +1562,11 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 	if (!is_valid_ether_addr(addr->sa_data))
 		goto out1;
 
-	ret = usb_autopm_get_interface(tp->intf);
-	if (ret < 0)
-		goto out1;
+	if (!in_resume) {
+		ret = usb_autopm_get_interface(tp->intf);
+		if (ret < 0)
+			goto out1;
+	}
 
 	mutex_lock(&tp->control);
 
@@ -1575,11 +1578,17 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 
 	mutex_unlock(&tp->control);
 
-	usb_autopm_put_interface(tp->intf);
+	if (!in_resume)
+		usb_autopm_put_interface(tp->intf);
 out1:
 	return ret;
 }
 
+static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
+{
+	return __rtl8152_set_mac_address(netdev, p, false);
+}
+
 /* Devices containing proper chips can support a persistent
  * host system provided MAC address.
  * Examples of this are Dell TB15 and Dell WD15 docks
@@ -1698,7 +1707,7 @@ static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 	return ret;
 }
 
-static int set_ethernet_addr(struct r8152 *tp)
+static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 {
 	struct net_device *dev = tp->netdev;
 	struct sockaddr sa;
@@ -1711,7 +1720,7 @@ static int set_ethernet_addr(struct r8152 *tp)
 	if (tp->version == RTL_VER_01)
 		ether_addr_copy(dev->dev_addr, sa.sa_data);
 	else
-		ret = rtl8152_set_mac_address(dev, &sa);
+		ret = __rtl8152_set_mac_address(dev, &sa, in_resume);
 
 	return ret;
 }
@@ -8444,7 +8453,7 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	set_ethernet_addr(tp);
+	set_ethernet_addr(tp, true);
 	return rtl8152_resume(intf);
 }
 
@@ -9645,7 +9654,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->rtl_fw.retry = true;
 #endif
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	set_ethernet_addr(tp);
+	set_ethernet_addr(tp, false);
 
 	usb_set_intfdata(intf, tp);
 
-- 
2.26.2

