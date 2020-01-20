Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFA1428FC
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 12:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgATLNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 06:13:40 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54524 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgATLNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 06:13:39 -0500
Received: by mail-wm1-f68.google.com with SMTP id b19so14016842wmj.4
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 03:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=HJDcD9HL3ESH9H2CHd66UlgSWMhY2fsVHeLtWAeHBH8=;
        b=WXtvfxqU+pRkL5pvB6RbycQpP2FNKBv6lewtul9jdDd+SN/TQ9qFg4xWw7RvBoNIsW
         eEPNG3reI2/mSOKyzHrnBV2drDZzSG6j6mnHtpDjrx0T3RSouCzRIuusLRnnhLA5wkc9
         WfRHF6hVM1ZYPHnlPvG29HvUyCFeIBjx26xOd6i2QTSlWIkEylEeKLNmbwsq58rRC/On
         ZSNivmhulmCEbvk+z6ZgQXX3m3xb3GSaHz5abUoyD3qfNO7VYvOirrajAdtwzBeWAzSj
         d97z/z6ErJR/2pm7++JMypMqQHvHUY5rH5GHqoND2SkbBFLmrwL/ecdgmoOHz4kzOIu6
         qYpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HJDcD9HL3ESH9H2CHd66UlgSWMhY2fsVHeLtWAeHBH8=;
        b=ukIOPwSVAWbL77cLQHLPBxl1ngqjSAuHTW1vFGale7vUUW3/WKyL+JwjnZx/rbDixx
         k/0D7xNK6EW3E8wwIVPWkDijw7/cxAUlsHAr3qhE5fuqrlai5Dco8Q8ZGLhLJjGdmMIL
         tvUPF0mMucPeUZhQxHFmWHQjNaJWChHiD6XIC7UvyE7W0254lU52fsuFdoskqXmi9R7w
         KeeJYsDrDk9u8bSRMul6jQRHv14D86eoyjtSK8hTLorCHQ9uGbwgNTuIAOXSmJUo8ir2
         Lwch/1AJBH6hu5KH0/AOvxuTH/3fRIr5peN8bm2mLF4xq3TTCymAyUSqE/UPQk+QSLeF
         OB0A==
X-Gm-Message-State: APjAAAXg5kTywgXeMX+TuJunvxXXZFSSqP6Bnxy8GYRf/vnnRdBvL5ZD
        ZwgTao6NXaVgx4dCRHjbPYST8elvhXA=
X-Google-Smtp-Source: APXvYqzqy4rO/EplIsglAqXPG3MZC+42EJzk4/4fPLQpoKEHUagj8gUjatqFsWBubtuFJycRMQc6zg==
X-Received: by 2002:a1c:4004:: with SMTP id n4mr17857323wma.153.1579518817404;
        Mon, 20 Jan 2020 03:13:37 -0800 (PST)
Received: from jamesh-VirtualBox.pitowers.org ([2a00:1098:3142:14:9260:684f:13fd:35ee])
        by smtp.gmail.com with ESMTPSA id m126sm8442041wmf.7.2020.01.20.03.13.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jan 2020 03:13:36 -0800 (PST)
From:   James Hughes <james.hughes@raspberrypi.org>
To:     netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     James Hughes <james.hughes@raspberrypi.org>
Subject: [PATCH] net: usb: lan78xx: Add .ndo_features_check
Date:   Mon, 20 Jan 2020 11:12:40 +0000
Message-Id: <20200120111240.9690-1-james.hughes@raspberrypi.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As reported by Eric Dumazet, there are still some outstanding
cases where the driver does not handle TSO correctly when skb's
are over a certain size. Most cases have been fixed, this patch
should ensure that forwarded SKB's that are greater than
MAX_SINGLE_PACKET_SIZE - TX_OVERHEAD are software segmented
and handled correctly.

Signed-off-by: James Hughes <james.hughes@raspberrypi.org>
---
 drivers/net/usb/lan78xx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index bc572b921fe1..a01c78d8b9a3 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -31,6 +31,7 @@
 #include <linux/mdio.h>
 #include <linux/phy.h>
 #include <net/ip6_checksum.h>
+#include <net/vxlan.h>
 #include <linux/interrupt.h>
 #include <linux/irqdomain.h>
 #include <linux/irq.h>
@@ -3733,6 +3734,19 @@ static void lan78xx_tx_timeout(struct net_device *net)
 	tasklet_schedule(&dev->bh);
 }
 
+static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
+						struct net_device *netdev,
+						netdev_features_t features)
+{
+	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
+		features &= ~NETIF_F_GSO_MASK;
+
+	features = vlan_features_check(skb, features);
+	features = vxlan_features_check(skb, features);
+
+	return features;
+}
+
 static const struct net_device_ops lan78xx_netdev_ops = {
 	.ndo_open		= lan78xx_open,
 	.ndo_stop		= lan78xx_stop,
@@ -3746,6 +3760,7 @@ static const struct net_device_ops lan78xx_netdev_ops = {
 	.ndo_set_features	= lan78xx_set_features,
 	.ndo_vlan_rx_add_vid	= lan78xx_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= lan78xx_vlan_rx_kill_vid,
+	.ndo_features_check	= lan78xx_features_check,
 };
 
 static void lan78xx_stat_monitor(struct timer_list *t)
-- 
2.17.1

