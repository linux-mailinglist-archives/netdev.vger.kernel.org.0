Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2698115ED83
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390637AbgBNReZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:34:25 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52863 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390331AbgBNReW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 12:34:22 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 57d1e613;
        Fri, 14 Feb 2020 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=vm6a9/E6LFoGRv3B58XZuRK2v
        P8=; b=lXxOhTWaoiZkHHjbbLIgw1vV8DMCsfqZVveJb30uCgC1TuinHRFOB/f+w
        nBxcBYcl9A7APL8tKShjZVq3j6A01KXXomiiKtMoWC8BhCw024OgCvmsxmzSTJS8
        YI2mZZeXKODPFtW8iQKW5DCDFnPRoj0ivcj9dIBzPbPyzlQ0kIQ+hzL3Jh2ycYTC
        w+iGA8VInJmWn2IM/a6PwJVco8lQOPgupdk3wFtEbFJZajv8WvYbwJZ2MreYvifB
        qQDUOv8E6JgfwzZMHVLBa5lJlu8eFF38UzDH7z5DYgXT8Q2bBlt8GZ53Tvek3/pb
        pHkMdzhqF+4abMR7J07WP/GfYfjSA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b0ddefbf (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Fri, 14 Feb 2020 17:32:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
Date:   Fri, 14 Feb 2020 18:34:07 +0100
Message-Id: <20200214173407.52521-4-Jason@zx2c4.com>
In-Reply-To: <20200214173407.52521-1-Jason@zx2c4.com>
References: <20200214173407.52521-1-Jason@zx2c4.com>
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

We use this opportunity to clean up this function a bit so that it's
clear which paths we're expecting.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Eric Dumazet <edumazet@google.com>
---
 drivers/net/wireguard/device.c |  7 ++++---
 drivers/net/wireguard/send.c   | 16 +++++++++++-----
 2 files changed, 15 insertions(+), 8 deletions(-)

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
index c13260563446..2a9990ab66cd 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -143,16 +143,22 @@ static void keep_key_fresh(struct wg_peer *peer)
 
 static unsigned int calculate_skb_padding(struct sk_buff *skb)
 {
+	unsigned int padded_size, last_unit = skb->len;
+
+	if (unlikely(!PACKET_CB(skb)->mtu))
+		return -last_unit % MESSAGE_PADDING_MULTIPLE;
+
 	/* We do this modulo business with the MTU, just in case the networking
 	 * layer gives us a packet that's bigger than the MTU. In that case, we
 	 * wouldn't want the final subtraction to overflow in the case of the
-	 * padded_size being clamped.
+	 * padded_size being clamped. Fortunately, that's very rarely the case,
+	 * so we optimize for that not happening.
 	 */
-	unsigned int last_unit = skb->len % PACKET_CB(skb)->mtu;
-	unsigned int padded_size = ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE);
+	if (unlikely(last_unit > PACKET_CB(skb)->mtu))
+		last_unit %= PACKET_CB(skb)->mtu;
 
-	if (padded_size > PACKET_CB(skb)->mtu)
-		padded_size = PACKET_CB(skb)->mtu;
+	padded_size = min(PACKET_CB(skb)->mtu,
+			  ALIGN(last_unit, MESSAGE_PADDING_MULTIPLE));
 	return padded_size - last_unit;
 }
 
-- 
2.25.0

