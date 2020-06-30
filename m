Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A7020EAA6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgF3BGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:06:48 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:60171 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgF3BGo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 21:06:44 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bef50b85;
        Tue, 30 Jun 2020 00:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=wplZDiGCa+tCNFlT7tJltU1KK
        XA=; b=ZLiZhqeFSg8qWscgoLPL/k+jTUteh5vV7+UPEnqrHZr7uz/OrMHHQQ4on
        GR8XUG3avxiLesNm797RrjS96R3lpLOMoUVEqoEJb6H1QoFolyXZaD/jUPqI1SQA
        dAtH3J89EV00cHIiUiHAfJIGG+lwTMBNcLCWQpEn2f0v8N54tfgXQ1jCtVYIXvVD
        aN5HsSvj3z1c4y9N7i8FIx1iBaUWOxrQDTtANB0Ty/BFxdRyTfPHnmR/yAsH5MQj
        4SMvDTqwcwqf854fca8SO6hG9jrD6F4uwsdfMmGo6ExUQu4FeiF6oFUD9SmUfmk5
        6fVP/KI6RO+kfoOMpZqoLGbQhUzSQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1ffb52d8 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Tue, 30 Jun 2020 00:46:58 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Hans Wippel <ndev@hwipl.net>
Subject: [PATCH net v2 4/8] wireguard: queueing: make use of ip_tunnel_parse_protocol
Date:   Mon, 29 Jun 2020 19:06:21 -0600
Message-Id: <20200630010625.469202-5-Jason@zx2c4.com>
In-Reply-To: <20200630010625.469202-1-Jason@zx2c4.com>
References: <20200630010625.469202-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that wg_examine_packet_protocol has been added for general
consumption as ip_tunnel_parse_protocol, it's possible to remove
wg_examine_packet_protocol and simply use the new
ip_tunnel_parse_protocol function directly.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/queueing.h | 19 ++-----------------
 drivers/net/wireguard/receive.c  |  2 +-
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index c58df439dbbe..dfb674e03076 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -11,6 +11,7 @@
 #include <linux/skbuff.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/ip_tunnels.h>
 
 struct wg_device;
 struct wg_peer;
@@ -65,25 +66,9 @@ struct packet_cb {
 #define PACKET_CB(skb) ((struct packet_cb *)((skb)->cb))
 #define PACKET_PEER(skb) (PACKET_CB(skb)->keypair->entry.peer)
 
-/* Returns either the correct skb->protocol value, or 0 if invalid. */
-static inline __be16 wg_examine_packet_protocol(struct sk_buff *skb)
-{
-	if (skb_network_header(skb) >= skb->head &&
-	    (skb_network_header(skb) + sizeof(struct iphdr)) <=
-		    skb_tail_pointer(skb) &&
-	    ip_hdr(skb)->version == 4)
-		return htons(ETH_P_IP);
-	if (skb_network_header(skb) >= skb->head &&
-	    (skb_network_header(skb) + sizeof(struct ipv6hdr)) <=
-		    skb_tail_pointer(skb) &&
-	    ipv6_hdr(skb)->version == 6)
-		return htons(ETH_P_IPV6);
-	return 0;
-}
-
 static inline bool wg_check_packet_protocol(struct sk_buff *skb)
 {
-	__be16 real_protocol = wg_examine_packet_protocol(skb);
+	__be16 real_protocol = ip_tunnel_parse_protocol(skb);
 	return real_protocol && skb->protocol == real_protocol;
 }
 
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 9b2ab6fc91cd..2c9551ea6dc7 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -387,7 +387,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	 */
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->csum_level = ~0; /* All levels */
-	skb->protocol = wg_examine_packet_protocol(skb);
+	skb->protocol = ip_tunnel_parse_protocol(skb);
 	if (skb->protocol == htons(ETH_P_IP)) {
 		len = ntohs(ip_hdr(skb)->tot_len);
 		if (unlikely(len < sizeof(struct iphdr)))
-- 
2.27.0

