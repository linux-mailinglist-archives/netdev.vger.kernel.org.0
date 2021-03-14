Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB52133A42D
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhCNKbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 06:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230265AbhCNKbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 06:31:16 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A21C061574;
        Sun, 14 Mar 2021 03:31:16 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id u18so13888125plc.12;
        Sun, 14 Mar 2021 03:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sGsgx5lItdpsm8V+9ERiYzuHPqJCAN3gYhOnOr9sdcw=;
        b=OqMC6mJdcDBX+Nq9dTpDAQ0gw5q8HqOYtNpRyYJ6OWIw7Wd5Nc/9QFCOEy4VLAQi0E
         Nl15WAEnoz59uw9aQDwQajdOhLIMHq8MyXuwjqGm+Ubx+dHHUHIkGUrd2KlBOR1OgXtP
         8N+bJKTjpvnthdthIziiKkjus39Ku2upwodilcQGfePlR3pyoNtmRBJkvoSqSdFhxMmh
         f3BQ2k8Tz80EsFZRZ3xGXICefJyPrvVCE8me7AmHQjViCvFp2ZIvMlAA6UT3R1DY6NrK
         H589QGALYBNCmcj8KitVlEuRxrRWM2TPmZxANir9QSX1NfPQEawHTCBH56x5Tmc2Ad2K
         PT/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sGsgx5lItdpsm8V+9ERiYzuHPqJCAN3gYhOnOr9sdcw=;
        b=A06wjhGvqJj2KmJIqJWCjJ7gK/HkJlXv3VxB86O51w2wVHig2FrJiZft0YsCEPJyNM
         O/vEqMiocn8rxalkpl4nS/CHaWDHkB3GuNwp5p2gsupdmVxDSCatCRuteqloNiVYVWrr
         VCG/PerY+1fMKoZQLDWPO8uDxBV5TkD3xVZ3vgFW5yMU709bjglpDpYnR6pkbUDiOqVr
         ZUalSN9CIAotUsXNHbrBwuqAaP3vT59j2D70CZWpNWQYojSUMP+f6uPvctqqYRLelneK
         1reP0ETYH8AuJCwxDM4WVkmF2WMQTXoVZxjXuk/gu/B/Ntxo0rLSRiMbHXuX57oAOJq9
         QwCQ==
X-Gm-Message-State: AOAM5300v6VWpgvdt1xlDL/goI2ABgxD2G2pyDrTat4K1yleAFc1mt0n
        Q6fdd5SwKDuI8qMXeYBZ6JA=
X-Google-Smtp-Source: ABdhPJwS8CEInbp8+m1mgmKalGcQYqUiX3GhFgjcxEwHqtASkF7AP63sjO754btL6xuiTG3Sei4sYQ==
X-Received: by 2002:a17:902:d4cb:b029:e5:f608:6d5e with SMTP id o11-20020a170902d4cbb02900e5f6086d5emr6534745plg.20.1615717871399;
        Sun, 14 Mar 2021 03:31:11 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:352e:895f:60e:9463])
        by smtp.gmail.com with ESMTPSA id b3sm9993761pgd.48.2021.03.14.03.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 03:31:11 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Martin Schiller <ms@dev.tdt.de>, Krzysztof Halasa <khc@pm.waw.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Xie He <xie.he.0141@gmail.com>
Subject: [PATCH net] net: hdlc_x25: Prevent racing between "x25_close" and "x25_xmit"/"x25_rx"
Date:   Sun, 14 Mar 2021 03:31:04 -0700
Message-Id: <20210314103104.43679-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"x25_close" is called by "hdlc_close" in "hdlc.c", which is called by
hardware drivers' "ndo_stop" function.
"x25_xmit" is called by "hdlc_start_xmit" in "hdlc.c", which is hardware
drivers' "ndo_start_xmit" function.
"x25_rx" is called by "hdlc_rcv" in "hdlc.c", which receives HDLC frames
from "net/core/dev.c".

"x25_close" races with "x25_xmit" and "x25_rx" because their callers race.

However, we need to ensure that the LAPB APIs called in "x25_xmit" and
"x25_rx" are called before "lapb_unregister" is called in "x25_close".

This patch adds locking to ensure when "x25_xmit" and "x25_rx" are doing
their work, "lapb_unregister" is not yet called in "x25_close".

Reasons for not solving the racing between "x25_close" and "x25_xmit" by
calling "netif_tx_disable" in "x25_close":
1. We still need to solve the racing between "x25_close" and "x25_rx";
2. The design of the HDLC subsystem assumes the HDLC hardware drivers
have full control over the TX queue, and the HDLC protocol drivers (like
this driver) have no control. Controlling the queue here in the protocol
driver may interfere with hardware drivers' control of the queue.

Signed-off-by: Xie He <xie.he.0141@gmail.com>
---
 drivers/net/wan/hdlc_x25.c | 42 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/hdlc_x25.c b/drivers/net/wan/hdlc_x25.c
index 4aaa6388b9ee..5a6a945f6c81 100644
--- a/drivers/net/wan/hdlc_x25.c
+++ b/drivers/net/wan/hdlc_x25.c
@@ -23,6 +23,8 @@
 
 struct x25_state {
 	x25_hdlc_proto settings;
+	bool up;
+	spinlock_t up_lock; /* Protects "up" */
 };
 
 static int x25_ioctl(struct net_device *dev, struct ifreq *ifr);
@@ -104,6 +106,8 @@ static void x25_data_transmit(struct net_device *dev, struct sk_buff *skb)
 
 static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
 	int result;
 
 	/* There should be a pseudo header of 1 byte added by upper layers.
@@ -114,11 +118,19 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 
+	spin_lock_bh(&x25st->up_lock);
+	if (!x25st->up) {
+		spin_unlock_bh(&x25st->up_lock);
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+
 	switch (skb->data[0]) {
 	case X25_IFACE_DATA:	/* Data to be transmitted */
 		skb_pull(skb, 1);
 		if ((result = lapb_data_request(dev, skb)) != LAPB_OK)
 			dev_kfree_skb(skb);
+		spin_unlock_bh(&x25st->up_lock);
 		return NETDEV_TX_OK;
 
 	case X25_IFACE_CONNECT:
@@ -147,6 +159,7 @@ static netdev_tx_t x25_xmit(struct sk_buff *skb, struct net_device *dev)
 		break;
 	}
 
+	spin_unlock_bh(&x25st->up_lock);
 	dev_kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
@@ -164,6 +177,7 @@ static int x25_open(struct net_device *dev)
 		.data_transmit = x25_data_transmit,
 	};
 	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
 	struct lapb_parms_struct params;
 	int result;
 
@@ -190,6 +204,10 @@ static int x25_open(struct net_device *dev)
 	if (result != LAPB_OK)
 		return -EINVAL;
 
+	spin_lock_bh(&x25st->up_lock);
+	x25st->up = true;
+	spin_unlock_bh(&x25st->up_lock);
+
 	return 0;
 }
 
@@ -197,6 +215,13 @@ static int x25_open(struct net_device *dev)
 
 static void x25_close(struct net_device *dev)
 {
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
+
+	spin_lock_bh(&x25st->up_lock);
+	x25st->up = false;
+	spin_unlock_bh(&x25st->up_lock);
+
 	lapb_unregister(dev);
 }
 
@@ -205,15 +230,28 @@ static void x25_close(struct net_device *dev)
 static int x25_rx(struct sk_buff *skb)
 {
 	struct net_device *dev = skb->dev;
+	hdlc_device *hdlc = dev_to_hdlc(dev);
+	struct x25_state *x25st = state(hdlc);
 
 	if ((skb = skb_share_check(skb, GFP_ATOMIC)) == NULL) {
 		dev->stats.rx_dropped++;
 		return NET_RX_DROP;
 	}
 
-	if (lapb_data_received(dev, skb) == LAPB_OK)
+	spin_lock_bh(&x25st->up_lock);
+	if (!x25st->up) {
+		spin_unlock_bh(&x25st->up_lock);
+		kfree_skb(skb);
+		dev->stats.rx_dropped++;
+		return NET_RX_DROP;
+	}
+
+	if (lapb_data_received(dev, skb) == LAPB_OK) {
+		spin_unlock_bh(&x25st->up_lock);
 		return NET_RX_SUCCESS;
+	}
 
+	spin_unlock_bh(&x25st->up_lock);
 	dev->stats.rx_errors++;
 	dev_kfree_skb_any(skb);
 	return NET_RX_DROP;
@@ -298,6 +336,8 @@ static int x25_ioctl(struct net_device *dev, struct ifreq *ifr)
 			return result;
 
 		memcpy(&state(hdlc)->settings, &new_settings, size);
+		state(hdlc)->up = false;
+		spin_lock_init(&state(hdlc)->up_lock);
 
 		/* There's no header_ops so hard_header_len should be 0. */
 		dev->hard_header_len = 0;
-- 
2.27.0

