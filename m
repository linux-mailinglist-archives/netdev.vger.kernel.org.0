Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E706F1DA974
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgETEtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:49:43 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:35181 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726764AbgETEtm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 00:49:42 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 02a637dd;
        Wed, 20 May 2020 04:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=KczykilkV6E8
        ewb1qNqr27un2TY=; b=fKtnvF5+7GYwS6UZ+B30NhdabQhLOGZ2h6kuqlqrruqk
        4LXpEP30k87KnzehDfDH4of0vp91TpetPcTo5XPWCGobKsv1rQd4JZ1cXkTK6jxk
        qLCh9PSNA3JLOThyQvJWI6u+DIyrYx81Jtzfo43IDt8DHmY0hzu/0TkowUdwmt4b
        LfNMqN3BqlzVTpzppHf7m6OYbO4DXbeBzEcxGMfqWx9ozlpNpHBfLU6yygQLyloc
        vgxfhMFwhkaMm5HYFBABKQjw1uvvoQyqLC9YO9AaCcMp1l1lA6occPThbu+tFdZ6
        gEpS9DjGymjyBVo+i8ZS1k4OgW+RjRoOhnR8eAJClw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ad92c0ef (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 20 May 2020 04:35:12 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/4] wireguard: queueing: preserve flow hash across packet scrubbing
Date:   Tue, 19 May 2020 22:49:29 -0600
Message-Id: <20200520044930.8131-4-Jason@zx2c4.com>
In-Reply-To: <20200520044930.8131-1-Jason@zx2c4.com>
References: <20200520044930.8131-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's important that we clear most header fields during encapsulation and
decapsulation, because the packet is substantially changed, and we don't
want any info leak or logic bug due to an accidental correlation. But,
for encapsulation, it's wrong to clear skb->hash, since it's used by
fq_codel and flow dissection in general. Without it, classification does
not proceed as usual. This change might make it easier to estimate the
number of innerflows by examining clustering of out of order packets,
but this shouldn't open up anything that can't already be inferred
otherwise (e.g. syn packet size inference), and fq_codel can be disabled
anyway.

Furthermore, it might be the case that the hash isn't used or queried at
all until after wireguard transmits the encrypted UDP packet, which
means skb->hash might still be zero at this point, and thus no hash
taken over the inner packet data. In order to address this situation, we
force a calculation of skb->hash before encrypting packet data.

Of course this means that fq_codel might transmit packets slightly more
out of order than usual. Toke did some testing on beefy machines with
high quantities of parallel flows and found that increasing the
reply-attack counter to 8192 takes care of the most pathological cases
pretty well.

Reported-by: Dave Taht <dave.taht@gmail.com>
Reviewed-and-tested-by: Toke Høiland-Jørgensen <toke@toke.dk>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/messages.h |  2 +-
 drivers/net/wireguard/queueing.h | 10 +++++++++-
 drivers/net/wireguard/receive.c  |  2 +-
 drivers/net/wireguard/send.c     |  7 ++++++-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/messages.h b/drivers/net/wireguard/messages.h
index b8a7b9ce32ba..208da72673fc 100644
--- a/drivers/net/wireguard/messages.h
+++ b/drivers/net/wireguard/messages.h
@@ -32,7 +32,7 @@ enum cookie_values {
 };
 
 enum counter_values {
-	COUNTER_BITS_TOTAL = 2048,
+	COUNTER_BITS_TOTAL = 8192,
 	COUNTER_REDUNDANT_BITS = BITS_PER_LONG,
 	COUNTER_WINDOW_SIZE = COUNTER_BITS_TOTAL - COUNTER_REDUNDANT_BITS
 };
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 3432232afe06..c58df439dbbe 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -87,12 +87,20 @@ static inline bool wg_check_packet_protocol(struct sk_buff *skb)
 	return real_protocol && skb->protocol == real_protocol;
 }
 
-static inline void wg_reset_packet(struct sk_buff *skb)
+static inline void wg_reset_packet(struct sk_buff *skb, bool encapsulating)
 {
+	u8 l4_hash = skb->l4_hash;
+	u8 sw_hash = skb->sw_hash;
+	u32 hash = skb->hash;
 	skb_scrub_packet(skb, true);
 	memset(&skb->headers_start, 0,
 	       offsetof(struct sk_buff, headers_end) -
 		       offsetof(struct sk_buff, headers_start));
+	if (encapsulating) {
+		skb->l4_hash = l4_hash;
+		skb->sw_hash = sw_hash;
+		skb->hash = hash;
+	}
 	skb->queue_mapping = 0;
 	skb->nohdr = 0;
 	skb->peeked = 0;
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 3bb5b9ae7cd1..d0eebd90c9d5 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -484,7 +484,7 @@ int wg_packet_rx_poll(struct napi_struct *napi, int budget)
 		if (unlikely(wg_socket_endpoint_from_skb(&endpoint, skb)))
 			goto next;
 
-		wg_reset_packet(skb);
+		wg_reset_packet(skb, false);
 		wg_packet_consume_data_done(peer, skb, &endpoint);
 		free = false;
 
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 6687db699803..2f5119ff93d8 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -167,6 +167,11 @@ static bool encrypt_packet(struct sk_buff *skb, struct noise_keypair *keypair)
 	struct sk_buff *trailer;
 	int num_frags;
 
+	/* Force hash calculation before encryption so that flow analysis is
+	 * consistent over the inner packet.
+	 */
+	skb_get_hash(skb);
+
 	/* Calculate lengths. */
 	padding_len = calculate_skb_padding(skb);
 	trailer_len = padding_len + noise_encrypted_len(0);
@@ -295,7 +300,7 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 		skb_list_walk_safe(first, skb, next) {
 			if (likely(encrypt_packet(skb,
 					PACKET_CB(first)->keypair))) {
-				wg_reset_packet(skb);
+				wg_reset_packet(skb, true);
 			} else {
 				state = PACKET_STATE_DEAD;
 				break;
-- 
2.26.2

