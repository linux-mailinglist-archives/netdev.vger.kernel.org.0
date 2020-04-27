Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91ED1BA107
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 12:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgD0KWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 06:22:47 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:54921 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726821AbgD0KWp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 06:22:45 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 3b827a70;
        Mon, 27 Apr 2020 10:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=njyI2fsG6Loo
        I1ywIorzIRnqAX8=; b=1HjM69EHZ95RHoO4/JBEM8zfWl36TsHu2YxFe7jlyiRg
        44z0Xq5w5kBac9VIbEZLcy05NmJD6gxcodO6cEjD1YFJkdIEF0mWq6LnnrS/xStB
        l7O3RTMB++ivvX26AvV50kORti6YHqcAfa2aCPaeYhK6JLRTmmnRSHLLhX/8Tc1x
        1/L/loeHl9zE+RZEygdSubq46ZkXVxV009S8JpHNA9XBHKumDwDmm9do0LXE0Co7
        Z9WcpBfBzkkYv675UmS06Oc+o1DKVcQQbMvfEXOGxWAe1Tecz5eaYrHb+KsS6tqj
        boFi1F4anfWz8o9sqFtMoahsN/kfj0rumqTuQstJyw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ddd6b83c (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 27 Apr 2020 10:11:13 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH RFC v2] net: xdp: allow for layer 3 packets in generic skb handler
Date:   Mon, 27 Apr 2020 04:22:29 -0600
Message-Id: <20200427102229.414644-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
References: <CAHmME9qXrb0ktCTeMJwt6KRsQxOWkiUNL6PNwb1CT7AK4WsVPA@mail.gmail.com>
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
assume that it's a layer 3 packet, and in that case prepend a pseudo
ethhdr to the packet whose h_proto is copied from skb->protocol, which
will have the appropriate v4 or v6 ethertype. This allows us to keep XDP
programs' assumption correct about packets always having that ethernet
header, so that existing code doesn't break, while still allowing layer
3 devices to use the generic XDP handler.

[1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/

Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/core/dev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 522288177bbd..845a7d17abb9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4505,12 +4505,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 				     struct xdp_buff *xdp,
 				     struct bpf_prog *xdp_prog)
 {
+	bool orig_bcast, add_eth_hdr = false;
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
 	u32 metalen, act = XDP_DROP;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
-	bool orig_bcast;
 	int hlen, off;
 	u32 mac_len;
 
@@ -4544,6 +4544,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * header.
 	 */
 	mac_len = skb->data - skb_mac_header(skb);
+	if (!mac_len) {
+		add_eth_hdr = true;
+		mac_len = sizeof(struct ethhdr);
+		*((struct ethhdr *)skb_push(skb, mac_len)) = (struct ethhdr) {
+			.h_proto = skb->protocol
+		};
+	}
 	hlen = skb_headlen(skb) + mac_len;
 	xdp->data = skb->data - mac_len;
 	xdp->data_meta = xdp->data;
@@ -4611,6 +4618,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		kfree_skb(skb);
 		break;
 	}
+	if (add_eth_hdr)
+		skb_pull(skb, sizeof(struct ethhdr));
 
 	return act;
 }
-- 
2.26.2

