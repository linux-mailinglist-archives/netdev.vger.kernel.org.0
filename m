Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841291BAFA4
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 22:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgD0UmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 16:42:25 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:45011 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgD0UmZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 16:42:25 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id a68bc6a4;
        Mon, 27 Apr 2020 20:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=4E7ThPiSajyQ
        Pyg9U0XG0TFmcvU=; b=AZDwVSM/beq6havfmX2c+1MH6Wgs/fgdEfl5dFUufCTV
        2XtoMXL/nGR5Y5F+LFdl0PU6mO+V9LgMtqRXxLDtuvx/QQJ/4Eb+DNDmabsMLM0S
        IKEi75/JdH/J8goBlmjtY90BhuZGMvQ0sVVSst+aoWwagQxmVqbuizL3ttizZ2zN
        hJcnTFU6gi3luOioWaxjlCyuqScbcopitLOvrAyS2gc0ORxjD+ACJwaScAMktJg8
        rns+eD4Y9IOM176sncaH/3pZIMO46o1R9tIFBk/49Zvb9wTUcJx/Pk3Y1JbN349Q
        ldiBve9PY/ZYTk+ABp+WwWC/vEVoylca5IgDTrEy1g==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a17ca243 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 27 Apr 2020 20:30:51 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH net v3] net: xdp: account for layer 3 packets in generic skb handler
Date:   Mon, 27 Apr 2020 14:42:08 -0600
Message-Id: <20200427204208.2501-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user reported that packets from wireguard were possibly ignored by XDP
[1]. Apparently, the generic skb xdp handler path seems to assume that
packets will always have an ethernet header, which really isn't always
the case for layer 3 packets, which are produced by multiple drivers.
This patch fixes the oversight. If the mac_len is 0, then we assume
that it's a layer 3 packet, and in that case prepend a pseudo ethhdr to
the packet whose h_proto is copied from skb->protocol, which will have
the appropriate v4 or v6 ethertype. This allows us to keep XDP programs'
assumption correct about packets always having that ethernet header, so
that existing code doesn't break, while still allowing layer 3 devices
to use the generic XDP handler.

[1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/

Reported-by: Adhipati Blambangan <adhipati@tuta.io>
Cc: David Ahern <dsahern@gmail.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 net/core/dev.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 77c154107b0d..3bc9a96bc808 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4510,9 +4510,9 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	u32 metalen, act = XDP_DROP;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
+	u32 mac_len = ~0;
 	bool orig_bcast;
 	int hlen, off;
-	u32 mac_len;
 
 	/* Reinjected packets coming from act_mirred or similar should
 	 * not get XDP generic processing.
@@ -4544,6 +4544,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * header.
 	 */
 	mac_len = skb->data - skb_mac_header(skb);
+	if (!mac_len) {
+		eth = skb_push(skb, sizeof(struct ethhdr));
+		eth_zero_addr(eth->h_source);
+		eth_zero_addr(eth->h_dest);
+		eth->h_proto = skb->protocol;
+	}
 	hlen = skb_headlen(skb) + mac_len;
 	xdp->data = skb->data - mac_len;
 	xdp->data_meta = xdp->data;
@@ -4611,6 +4617,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		kfree_skb(skb);
 		break;
 	}
+	if (!mac_len)
+		skb_pull(skb, sizeof(struct ethhdr));
 
 	return act;
 }
-- 
2.26.2

