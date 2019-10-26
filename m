Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07EE5BD4
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729361AbfJZN0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:26:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727629AbfJZNWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:22:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C980D222C4;
        Sat, 26 Oct 2019 13:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096128;
        bh=xda9XpkUkZwWDLO5iVEbaFaS5X5Lcy4XE84oFQtMlGg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJhAg0FzsDNOxEPWMizmBs/OKW/wxPZ39I/hvjXYSRBRejwfHdIVZobugboNdvFVH
         MeFSVFgn0EQGcOA6ZPahk8m+8TPJmo0JMJlO6aueqAos3g532Ts/GQCfThpOU+3ovF
         fnUh19JVCQ0nCmgbrMhT777FUZh25mgYTot/YGL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Daniel Wagner <dwagner@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 30/33] net: usb: lan78xx: Connect PHY before registering MAC
Date:   Sat, 26 Oct 2019 09:21:07 -0400
Message-Id: <20191026132110.4026-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132110.4026-1-sashal@kernel.org>
References: <20191026132110.4026-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 38b4fe320119859c11b1dc06f6b4987a16344fa1 ]

As soon as the netdev is registers, the kernel can start using the
interface. If the driver connects the MAC to the PHY after the netdev
is registered, there is a race condition where the interface can be
opened without having the PHY connected.

Change the order to close this race condition.

Fixes: 92571a1aae40 ("lan78xx: Connect phy early")
Reported-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 24b994c68bccd..78a12d7b96e86 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3642,10 +3642,14 @@ static int lan78xx_probe(struct usb_interface *intf,
 	/* driver requires remote-wakeup capability during autosuspend. */
 	intf->needs_remote_wakeup = 1;
 
+	ret = lan78xx_phy_init(dev);
+	if (ret < 0)
+		goto out4;
+
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out4;
+		goto out5;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -3658,14 +3662,10 @@ static int lan78xx_probe(struct usb_interface *intf,
 	pm_runtime_set_autosuspend_delay(&udev->dev,
 					 DEFAULT_AUTOSUSPEND_DELAY);
 
-	ret = lan78xx_phy_init(dev);
-	if (ret < 0)
-		goto out5;
-
 	return 0;
 
 out5:
-	unregister_netdev(netdev);
+	phy_disconnect(netdev->phydev);
 out4:
 	usb_free_urb(dev->urb_intr);
 out3:
-- 
2.20.1

