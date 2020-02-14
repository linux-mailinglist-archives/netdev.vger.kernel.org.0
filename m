Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4829315D88F
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 14:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgBNNeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 08:34:22 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:42097 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728121AbgBNNeV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 08:34:21 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 32532ad3;
        Fri, 14 Feb 2020 13:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=OxMfWCnxBqtU4txFXDXgVupoC
        iY=; b=MaJmuX/SRqv/VySolVNtPZ6CZJ7SpHCVX6R/BckWI5PJvvuX+Xu7tpjHv
        NpepPTD/bl3pnLiRDi4H1T9ycKgOkS1U2XfxL+uttOzkLpHFikgWFFHJGZHptnyP
        ssK24VkySiUDktn8ISqc3vM8b68TI898eHexfztaX0oeGf0ZbsljG67uZI9POpw+
        4QhVZ9lc0HB4ApjkirZaHxzsXRiS895fCrXUky9mf4XUdq25B6006CMBKhpOS6fs
        WedOkcvG4tw29tHlDossR+SitxCDyDjB6jkIr0J62pIMnPFvBvR+5OnJzt7pAHGt
        LSuMoQ5t5l7iKxHu3Kriiv8doHJbA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b2779d5d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 13:32:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/3] wireguard: send: account for mtu=0 devices
Date:   Fri, 14 Feb 2020 14:34:04 +0100
Message-Id: <20200214133404.30643-4-Jason@zx2c4.com>
In-Reply-To: <20200214133404.30643-1-Jason@zx2c4.com>
References: <20200214133404.30643-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It turns out there's an easy way to get packets queued up while still
having an MTU of zero, and that's via persistent keep alive. This commit
makes sure that in whatever condition, we don't wind up dividing by
zero. Note that an MTU of zero for a wireguard interface is something
quasi-valid, so I don't think the correct fix is to limit it via
min_mtu. This can be reproduced easily with:

ip link add wg0 type wireguard
ip link add wg1 type wireguard
ip link set wg0 up mtu 0
ip link set wg1 up
wg set wg0 private-key <(wg genkey)
wg set wg1 listen-port 1 private-key <(wg genkey) peer $(wg show wg0 public-key)
wg set wg0 peer $(wg show wg1 public-key) persistent-keepalive 1 endpoint 127.0.0.1:1

However, while min_mtu=0 seems fine, it makes sense to restrict the
max_mtu. This commit also restricts the maximum MTU to the greatest
number for which rounding up to the padding multiple won't overflow a
signed integer. Packets this large were always rejected anyway
eventually, due to checks deeper in, but it seems more sound not to even
let the administrator configure something that won't work anyway.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c | 7 ++++---
 drivers/net/wireguard/send.c   | 3 ++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index 43db442b1373..cdc96968b0f4 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -258,6 +258,8 @@ static void wg_setup(struct net_device *dev)
 	enum { WG_NETDEV_FEATURES = NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				    NETIF_F_SG | NETIF_F_GSO |
 				    NETIF_F_GSO_SOFTWARE | NETIF_F_HIGHDMA };
+	const int overhead = MESSAGE_MINIMUM_LENGTH + sizeof(struct udphdr) +
+			     max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
 
 	dev->netdev_ops = &netdev_ops;
 	dev->hard_header_len = 0;
@@ -271,9 +273,8 @@ static void wg_setup(struct net_device *dev)
 	dev->features |= WG_NETDEV_FEATURES;
 	dev->hw_features |= WG_NETDEV_FEATURES;
 	dev->hw_enc_features |= WG_NETDEV_FEATURES;
-	dev->mtu = ETH_DATA_LEN - MESSAGE_MINIMUM_LENGTH -
-		   sizeof(struct udphdr) -
-		   max(sizeof(struct ipv6hdr), sizeof(struct iphdr));
+	dev->mtu = ETH_DATA_LEN - overhead;
+	dev->max_mtu = round_down(INT_MAX, MESSAGE_PADDING_MULTIPLE) - overhead;
 
 	SET_NETDEV_DEVTYPE(dev, &device_type);
 
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index c13260563446..ae77474dadeb 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -148,7 +148,8 @@ static unsigned int calculate_skb_padding(struct sk_buff *skb)
 	 * wouldn't want the final subtraction to overflow in the case of the
 	 * padded_size being clamped.
 	 */
-	unsigned int last_unit = skb->len % PACKET_CB(skb)->mtu;
+	unsigned int last_unit = PACKET_CB(skb)->mtu ?
+				 skb->len % PACKET_CB(skb)->mtu : skb->len;
 	unsigned int padded_size = ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE);
 
 	if (padded_size > PACKET_CB(skb)->mtu)
-- 
2.25.0

