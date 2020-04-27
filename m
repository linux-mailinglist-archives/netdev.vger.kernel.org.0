Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC971B94D5
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 03:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgD0BOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 21:14:00 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:52877 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbgD0BOA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 21:14:00 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 17a70005;
        Mon, 27 Apr 2020 00:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=WuJHIN6MQ+tAfQw0mT+WBzJwK
        j0=; b=gbSETdyyTf9HsDVHytdWY82UkdQfXWyletKWxx50wevMEsZqYlt5M34pg
        7L12IXZoO3NxexO++3QiDnwUOCJPjWB2RRZcfiXPjl/V3AXQQouSOyFQ9qz1FXfT
        8UVsLVy3YkgYAYm6sNKFQXkOdiW6dzOdU2duHmgaIXlFbMvbfIQt3QEG0H1B+Ek0
        NRgR5eZm8Yleg4YoyUTTlB5XjH13WBfgPq01EgHWEOaNvAERBjkh1uG2zZ0tao5e
        u3AF84JkyjaZU1xXmc1Z/5YNGIqj0ATNwSjnPbz4Zq0BP2bDWMwHdEmx3ZfVKAsE
        /0jYlwi0djYuod/ZjuY/jgGKkYBww==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id fdacbbcd (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 27 Apr 2020 00:58:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH RFC v1] net: xdp: allow for layer 3 packets in generic skb handler
Date:   Sun, 26 Apr 2020 19:10:02 -0600
Message-Id: <20200427011002.320081-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user reported a few days ago that packets from wireguard were possibly
ignored by XDP [1]. We haven't heard back from the original reporter to
receive more info, so this here is mostly speculative. Successfully nerd
sniped, Toke and I started poking around. Toke noticed that the generic
skb xdp handler path seems to assume that packets will always have an
ethernet header, which really isn't always the case for layer 3 packets,
which are produced by multiple drivers. This patch is untested, but I
wanted to gauge interest in this approach: if the mac_len is 0, then we
assume that it's a layer 3 packet, and figure out skb->protocol from
looking at the IP header. This patch also adds some stricter testing
around mac_len before we assume that it's an ethhdr.

[1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/

Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/core/dev.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..1c4b0af09be2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4551,9 +4551,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	xdp->data_hard_start = skb->data - skb_headroom(skb);
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
-	eth = (struct ethhdr *)xdp->data;
-	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
-	orig_eth_type = eth->h_proto;
+	if (mac_len == sizeof(struct ethhdr)) {
+		eth = (struct ethhdr *)xdp->data;
+		orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
+		orig_eth_type = eth->h_proto;
+	}
 
 	rxqueue = netif_get_rxqueue(skb);
 	xdp->rxq = &rxqueue->xdp_rxq;
@@ -4583,11 +4585,24 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	}
 
 	/* check if XDP changed eth hdr such SKB needs update */
-	eth = (struct ethhdr *)xdp->data;
-	if ((orig_eth_type != eth->h_proto) ||
-	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
-		__skb_push(skb, ETH_HLEN);
-		skb->protocol = eth_type_trans(skb, skb->dev);
+	if (mac_len == 0) {
+		switch (ip_hdr(skb)->version) {
+		case 4:
+			skb->protocol = htons(ETH_P_IP);
+			break;
+		case 6:
+			skb->protocol = htons(ETH_P_IPV6);
+			break;
+		default:
+			goto do_drop;
+		}
+	} else if (mac_len == sizeof(struct ethhdr)) {
+		eth = (struct ethhdr *)xdp->data;
+		if ((orig_eth_type != eth->h_proto) ||
+		    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
+			__skb_push(skb, ETH_HLEN);
+			skb->protocol = eth_type_trans(skb, skb->dev);
+		}
 	}
 
 	switch (act) {
-- 
2.26.2

