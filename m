Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAAE5C9E
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfJZNSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:40606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbfJZNSp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B53C21D7F;
        Sat, 26 Oct 2019 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095925;
        bh=FcMVpQ26nkDAtWrLDpRcqXgDlBIy/wLe2kqnIpqccCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I04KtHFxQLCXTA4q/LdVPAf4adnOUTQD260rGmLwf/lW2Rxrg1pMIrr+FWkycm+/s
         EkMgYgvRvHygWa9d71v5EEk5bjcFRWiS8Q+gDadK3ctq0zt0w2Ju17EJLWLgZXQ/Dz
         t+g9bVoCXyuR0fXVWeN87pY4xpmx2Hv6sZC6QUM4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Daniel Wagner <dwagner@suse.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 93/99] net: usb: lan78xx: Connect PHY before registering MAC
Date:   Sat, 26 Oct 2019 09:15:54 -0400
Message-Id: <20191026131600.2507-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
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
index f033fee225a11..4c6c8013f99fb 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3789,10 +3789,14 @@ static int lan78xx_probe(struct usb_interface *intf,
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
@@ -3805,14 +3809,10 @@ static int lan78xx_probe(struct usb_interface *intf,
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

