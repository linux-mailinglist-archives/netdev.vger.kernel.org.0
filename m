Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD583D7603
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:22:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbhG0NUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:56488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236745AbhG0NTv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9490E61A80;
        Tue, 27 Jul 2021 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627391960;
        bh=4dGRU6wbGefDj45r4umdl1N8zIxJ1aCI5VWDm0LvqpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEQFPJFBVqx+XTqw6ys8894X4VyaMfk0i3DHyxMg7z/MICQJQzIbzNlKRvxP4H3Af
         RgPyE6Q19VSkvjggJcRAcp9HT5ACw8hA66PpjrIqG7h6+xUqsMm8xakKHMkiyGg6N9
         deGDloEhWAvwoQGgNOynuWGYMCoNI/1eIKRy/D0Zf7bDByeE92qNtcAPHV8ljcRpSC
         FEUeLviAHxbJlzaX+yHNJ+bgJWKsRoPauTqrtItmffyHu6y3ID19ouRyZvBQY0BJYf
         NBQi9toH2H7Jv6El8C46NOAhNKiAbfxrluQ/PIWUfgnShonfSNT4IMxU5TYomknTuH
         zCDQVvwo1h03g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 08/21] r8152: Fix a deadlock by doubly PM resume
Date:   Tue, 27 Jul 2021 09:18:55 -0400
Message-Id: <20210727131908.834086-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210727131908.834086-1-sashal@kernel.org>
References: <20210727131908.834086-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 776ac63a986d211286230c4fd70f85390eabedcd ]

r8152 driver sets up the MAC address at reset-resume, while
rtl8152_set_mac_address() has the temporary autopm get/put.  This may
lead to a deadlock as the PM lock has been already taken for the
execution of the runtime PM callback.

This patch adds the workaround to avoid the superfluous autpm when
called from rtl8152_reset_resume().

Link: https://bugzilla.suse.com/show_bug.cgi?id=1186194
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 8dcc55e4a5bc..2cf763b4ea84 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -1550,7 +1550,8 @@ static int
 rtl8152_set_speed(struct r8152 *tp, u8 autoneg, u32 speed, u8 duplex,
 		  u32 advertising);
 
-static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
+static int __rtl8152_set_mac_address(struct net_device *netdev, void *p,
+				     bool in_resume)
 {
 	struct r8152 *tp = netdev_priv(netdev);
 	struct sockaddr *addr = p;
@@ -1559,9 +1560,11 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
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
 
@@ -1573,11 +1576,17 @@ static int rtl8152_set_mac_address(struct net_device *netdev, void *p)
 
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
@@ -1696,7 +1705,7 @@ static int determine_ethernet_addr(struct r8152 *tp, struct sockaddr *sa)
 	return ret;
 }
 
-static int set_ethernet_addr(struct r8152 *tp)
+static int set_ethernet_addr(struct r8152 *tp, bool in_resume)
 {
 	struct net_device *dev = tp->netdev;
 	struct sockaddr sa;
@@ -1709,7 +1718,7 @@ static int set_ethernet_addr(struct r8152 *tp)
 	if (tp->version == RTL_VER_01)
 		ether_addr_copy(dev->dev_addr, sa.sa_data);
 	else
-		ret = rtl8152_set_mac_address(dev, &sa);
+		ret = __rtl8152_set_mac_address(dev, &sa, in_resume);
 
 	return ret;
 }
@@ -8442,7 +8451,7 @@ static int rtl8152_reset_resume(struct usb_interface *intf)
 	clear_bit(SELECTIVE_SUSPEND, &tp->flags);
 	tp->rtl_ops.init(tp);
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	set_ethernet_addr(tp);
+	set_ethernet_addr(tp, true);
 	return rtl8152_resume(intf);
 }
 
@@ -9562,7 +9571,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->rtl_fw.retry = true;
 #endif
 	queue_delayed_work(system_long_wq, &tp->hw_phy_work, 0);
-	set_ethernet_addr(tp);
+	set_ethernet_addr(tp, false);
 
 	usb_set_intfdata(intf, tp);
 
-- 
2.30.2

