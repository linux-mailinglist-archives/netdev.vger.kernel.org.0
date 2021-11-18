Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1F7455A17
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbhKRLZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:25:26 -0500
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:5693 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343894AbhKRLYq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:24:46 -0500
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 99B6322950;
        Thu, 18 Nov 2021 11:02:12 +0000 (UTC)
Received: from ares.krystal.co.uk (100-96-17-73.trex.outbound.svc.cluster.local [100.96.17.73])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id 3E9CD21A58;
        Thu, 18 Nov 2021 11:02:11 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk (ares.krystal.co.uk [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.96.17.73 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:12 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Gusty-Robust: 1edaa19c175ce809_1637233332301_1856016050
X-MC-Loop-Signature: 1637233332301:2294268420
X-MC-Ingress-Time: 1637233332301
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7BLHWVr00uH9R+/LGevPPyHXc15GJJlC9w5+i7/9UeU=; b=TPNhMUw+0Fz7jA7qm8QSrZbrrd
        x1XFlt2d0piXs2s5WyQZgZ0Bb3EYsIgm67cYFYaEFPDETxTBJebWWw7H0Gf5fpp8ekPNzfHPOY1Fn
        XobFOcePRcYjLZ38VesyMXyXqqm+JycT5j9G7KuIXfUaOVmyEDloZw3sHGiVasprHxZcxOsIR4moX
        2znrm1r1aF7wQrarRNNSVMuCNdFawLGZnPbxK6aT3LAMjRXSBQHUkpAzMj7FNZh/QGqORSQaj3bN8
        +lwmIiFkiL1Q7dQOYmr69SNXL0Unz9ztx5mXJOfV4m2WBYsYhA2oMtjyHWlcIv+YyvhTQIK741wZb
        OwoGzP7w==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBC-004NG9-Vf; Thu, 18 Nov 2021 11:02:08 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 1/6] lan78xx: Fix memory allocation bug
Date:   Thu, 18 Nov 2021 11:01:34 +0000
Message-Id: <20211118110139.7321-2-john.efstathiades@pebblebay.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
References: <20211118110139.7321-1-john.efstathiades@pebblebay.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AuthUser: john.efstathiades@pebblebay.com
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memory allocation that fails to check for NULL return.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 38 +++++++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index f20376c1ef3f..3ddacc6239a3 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4106,18 +4106,20 @@ static int lan78xx_probe(struct usb_interface *intf,
 	period = ep_intr->desc.bInterval;
 	maxp = usb_maxpacket(dev->udev, dev->pipe_intr, 0);
 	buf = kmalloc(maxp, GFP_KERNEL);
-	if (buf) {
-		dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
-		if (!dev->urb_intr) {
-			ret = -ENOMEM;
-			kfree(buf);
-			goto out3;
-		} else {
-			usb_fill_int_urb(dev->urb_intr, dev->udev,
-					 dev->pipe_intr, buf, maxp,
-					 intr_complete, dev, period);
-			dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
-		}
+	if (!buf) {
+		ret = -ENOMEM;
+		goto out3;
+	}
+
+	dev->urb_intr = usb_alloc_urb(0, GFP_KERNEL);
+	if (!dev->urb_intr) {
+		ret = -ENOMEM;
+		goto out4;
+	} else {
+		usb_fill_int_urb(dev->urb_intr, dev->udev,
+				 dev->pipe_intr, buf, maxp,
+				 intr_complete, dev, period);
+		dev->urb_intr->transfer_flags |= URB_FREE_BUFFER;
 	}
 
 	dev->maxpacket = usb_maxpacket(dev->udev, dev->pipe_out, 1);
@@ -4125,7 +4127,7 @@ static int lan78xx_probe(struct usb_interface *intf,
 	/* Reject broken descriptors. */
 	if (dev->maxpacket == 0) {
 		ret = -ENODEV;
-		goto out4;
+		goto out5;
 	}
 
 	/* driver requires remote-wakeup capability during autosuspend. */
@@ -4133,12 +4135,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	ret = lan78xx_phy_init(dev);
 	if (ret < 0)
-		goto out4;
+		goto out5;
 
 	ret = register_netdev(netdev);
 	if (ret != 0) {
 		netif_err(dev, probe, netdev, "couldn't register the device\n");
-		goto out5;
+		goto out6;
 	}
 
 	usb_set_intfdata(intf, dev);
@@ -4153,10 +4155,12 @@ static int lan78xx_probe(struct usb_interface *intf,
 
 	return 0;
 
-out5:
+out6:
 	phy_disconnect(netdev->phydev);
-out4:
+out5:
 	usb_free_urb(dev->urb_intr);
+out4:
+	kfree(buf);
 out3:
 	lan78xx_unbind(dev, intf);
 out2:
-- 
2.25.1

