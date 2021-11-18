Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4218945598F
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:02:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343566AbhKRLF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:05:28 -0500
Received: from beige.elm.relay.mailchannels.net ([23.83.212.16]:45301 "EHLO
        beige.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343501AbhKRLFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:05:24 -0500
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 1D9EC46123E;
        Thu, 18 Nov 2021 11:02:16 +0000 (UTC)
Received: from ares.krystal.co.uk (unknown [127.0.0.6])
        (Authenticated sender: 9wt3zsp42r)
        by relay.mailchannels.net (Postfix) with ESMTPA id B7F40461224;
        Thu, 18 Nov 2021 11:02:14 +0000 (UTC)
X-Sender-Id: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
Received: from ares.krystal.co.uk ([TEMPUNAVAIL]. [77.72.0.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.109.250.31 (trex/6.4.3);
        Thu, 18 Nov 2021 11:02:15 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: 9wt3zsp42r|x-authuser|john.efstathiades@pebblebay.com
X-MailChannels-Auth-Id: 9wt3zsp42r
X-Coil-Eight: 1d5f687114ab837a_1637233335796_2723188507
X-MC-Loop-Signature: 1637233335796:3587451021
X-MC-Ingress-Time: 1637233335795
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=pebblebay.com; s=default; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SLHWtUNWNuHyoLNkQ5u9QfBSP3r1bJ+drbR8FUtdhzU=; b=irP88rzC904b/+kFzqbkBUEH3D
        xLV1XksZ9HaZXMYioYk8IzJuOurf0EnIHsBJkWaIzYBnBNZvLAtgJAlzWIkpzJQmMKXR3gTCBmmg6
        VdHqdk+5LbOGjNymN3fmX+j9GtXn9rfzt3qaTq42Wkf69ciB2AHRGgTSlrT954D2E3MAvWHmlab9c
        HdY63+2aZD3Xv4UpX+D5uI+49gTopV9eC2JjW9Bwe0rJ4g2NBvKso4QkqpsikPAmAtemitr1aOWdJ
        0argqEPemSmqJcaTgSSm7PloUh0S9BepKCshSYoTbayBIXjFco1L9JPsM2cDg0kYM3KPoE+EHpfY3
        +M2AWRlg==;
Received: from cpc160185-warw19-2-0-cust743.3-2.cable.virginm.net ([82.21.62.232]:46024 helo=pbcl-dsk9.pebblebay.com)
        by ares.krystal.co.uk with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <john.efstathiades@pebblebay.com>)
        id 1mnfBD-004NG9-IP; Thu, 18 Nov 2021 11:02:09 +0000
From:   John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        john.efstathiades@pebblebay.com
Subject: [PATCH net-next 4/6] lan78xx: Re-order rx_submit() to remove forward declaration
Date:   Thu, 18 Nov 2021 11:01:37 +0000
Message-Id: <20211118110139.7321-5-john.efstathiades@pebblebay.com>
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

Move position of rx_submit() to remove forward declaration of
rx_complete() which is now no longer required.

Signed-off-by: John Efstathiades <john.efstathiades@pebblebay.com>
---
 drivers/net/usb/lan78xx.c | 106 +++++++++++++++++++-------------------
 1 file changed, 52 insertions(+), 54 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 3dfd46c91093..ebd3d9fc5c41 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3680,60 +3680,6 @@ static inline void rx_process(struct lan78xx_net *dev, struct sk_buff *skb)
 	dev->net->stats.rx_errors++;
 }
 
-static void rx_complete(struct urb *urb);
-
-static int rx_submit(struct lan78xx_net *dev, struct sk_buff *skb, gfp_t flags)
-{
-	struct skb_data	*entry = (struct skb_data *)skb->cb;
-	size_t size = dev->rx_urb_size;
-	struct urb *urb = entry->urb;
-	unsigned long lockflags;
-	int ret = 0;
-
-	usb_fill_bulk_urb(urb, dev->udev, dev->pipe_in,
-			  skb->data, size, rx_complete, skb);
-
-	spin_lock_irqsave(&dev->rxq.lock, lockflags);
-
-	if (netif_device_present(dev->net) &&
-	    netif_running(dev->net) &&
-	    !test_bit(EVENT_RX_HALT, &dev->flags) &&
-	    !test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
-		ret = usb_submit_urb(urb, flags);
-		switch (ret) {
-		case 0:
-			lan78xx_queue_skb(&dev->rxq, skb, rx_start);
-			break;
-		case -EPIPE:
-			lan78xx_defer_kevent(dev, EVENT_RX_HALT);
-			break;
-		case -ENODEV:
-		case -ENOENT:
-			netif_dbg(dev, ifdown, dev->net, "device gone\n");
-			netif_device_detach(dev->net);
-			break;
-		case -EHOSTUNREACH:
-			ret = -ENOLINK;
-			tasklet_schedule(&dev->bh);
-			break;
-		default:
-			netif_dbg(dev, rx_err, dev->net,
-				  "rx submit, %d\n", ret);
-			tasklet_schedule(&dev->bh);
-			break;
-		}
-	} else {
-		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
-		ret = -ENOLINK;
-	}
-	spin_unlock_irqrestore(&dev->rxq.lock, lockflags);
-
-	if (ret)
-		lan78xx_release_rx_buf(dev, skb);
-
-	return ret;
-}
-
 static void rx_complete(struct urb *urb)
 {
 	struct sk_buff	*skb = (struct sk_buff *)urb->context;
@@ -3794,6 +3740,58 @@ static void rx_complete(struct urb *urb)
 	state = defer_bh(dev, skb, &dev->rxq, state);
 }
 
+static int rx_submit(struct lan78xx_net *dev, struct sk_buff *skb, gfp_t flags)
+{
+	struct skb_data	*entry = (struct skb_data *)skb->cb;
+	size_t size = dev->rx_urb_size;
+	struct urb *urb = entry->urb;
+	unsigned long lockflags;
+	int ret = 0;
+
+	usb_fill_bulk_urb(urb, dev->udev, dev->pipe_in,
+			  skb->data, size, rx_complete, skb);
+
+	spin_lock_irqsave(&dev->rxq.lock, lockflags);
+
+	if (netif_device_present(dev->net) &&
+	    netif_running(dev->net) &&
+	    !test_bit(EVENT_RX_HALT, &dev->flags) &&
+	    !test_bit(EVENT_DEV_ASLEEP, &dev->flags)) {
+		ret = usb_submit_urb(urb, flags);
+		switch (ret) {
+		case 0:
+			lan78xx_queue_skb(&dev->rxq, skb, rx_start);
+			break;
+		case -EPIPE:
+			lan78xx_defer_kevent(dev, EVENT_RX_HALT);
+			break;
+		case -ENODEV:
+		case -ENOENT:
+			netif_dbg(dev, ifdown, dev->net, "device gone\n");
+			netif_device_detach(dev->net);
+			break;
+		case -EHOSTUNREACH:
+			ret = -ENOLINK;
+			tasklet_schedule(&dev->bh);
+			break;
+		default:
+			netif_dbg(dev, rx_err, dev->net,
+				  "rx submit, %d\n", ret);
+			tasklet_schedule(&dev->bh);
+			break;
+		}
+	} else {
+		netif_dbg(dev, ifdown, dev->net, "rx: stopped\n");
+		ret = -ENOLINK;
+	}
+	spin_unlock_irqrestore(&dev->rxq.lock, lockflags);
+
+	if (ret)
+		lan78xx_release_rx_buf(dev, skb);
+
+	return ret;
+}
+
 static void lan78xx_rx_urb_submit_all(struct lan78xx_net *dev)
 {
 	struct sk_buff *rx_buf;
-- 
2.25.1

