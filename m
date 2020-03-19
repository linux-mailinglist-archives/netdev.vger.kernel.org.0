Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB7D18A9CF
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727306AbgCSAaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:30:55 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:54 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 602c7ed0;
        Thu, 19 Mar 2020 00:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=ruK05eyT7l0lU9OFU6TChYOBS
        O4=; b=hirNRV4yphqB0IXYXfo2wJWsW5aAQNi3z4YEN+AdCQJUa0douyyX0BKkJ
        RfKcQku2hj38Skcr8fUcaZIIUv7bSbLDFyNiDFrPThmOs5NkAO7XWi6+4qW+/TAP
        XP9jMyHhvUCQiDwEJLWXBxRYBTzqIv6MMi43NHVpiJfWG81B/O0T+AD59O86M8FN
        Yiz1etH9WIJn98YmX8m18FLdYR9xgNy2dkGzGvCtDPcPExph3gwUNxsqP2CWGp3P
        Plga07NwSg7YazrJfEaoMx7jEXNEUuMna15zzV/jylwb07U2THrH83HEyVNDkmfu
        pli1qPY50NrL8k4pe5Kn9+d03RO8A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 300c626a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 00:24:27 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 3/5] wireguard: queueing: account for skb->protocol==0
Date:   Wed, 18 Mar 2020 18:30:45 -0600
Message-Id: <20200319003047.113501-4-Jason@zx2c4.com>
In-Reply-To: <20200319003047.113501-1-Jason@zx2c4.com>
References: <20200319003047.113501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We carry out checks to the effect of:

  if (skb->protocol != wg_examine_packet_protocol(skb))
    goto err;

By having wg_skb_examine_untrusted_ip_hdr return 0 on failure, this
means that the check above still passes in the case where skb->protocol
is zero, which is possible to hit with AF_PACKET:

  struct sockaddr_pkt saddr = { .spkt_device = "wg0" };
  unsigned char buffer[5] = { 0 };
  sendto(socket(AF_PACKET, SOCK_PACKET, /* skb->protocol = */ 0),
         buffer, sizeof(buffer), 0, (const struct sockaddr *)&saddr, sizeof(saddr));

Additional checks mean that this isn't actually a problem in the code
base, but I could imagine it becoming a problem later if the function is
used more liberally.

I would prefer to fix this by having wg_examine_packet_protocol return a
32-bit ~0 value on failure, which will never match any value of
skb->protocol, which would simply change the generated code from a mov
to a movzx. However, sparse complains, and adding __force casts doesn't
seem like a good idea, so instead we just add a simple helper function
to check for the zero return value. Since wg_examine_packet_protocol
itself gets inlined, this winds up not adding an additional branch to
the generated code, since the 0 return value already happens in a
mergable branch.

Reported-by: Fabian Freyer <fabianfreyer@radicallyopensecurity.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/device.c   | 2 +-
 drivers/net/wireguard/queueing.h | 8 +++++++-
 drivers/net/wireguard/receive.c  | 4 ++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireguard/device.c b/drivers/net/wireguard/device.c
index cdc96968b0f4..3ac3f8570ca1 100644
--- a/drivers/net/wireguard/device.c
+++ b/drivers/net/wireguard/device.c
@@ -122,7 +122,7 @@ static netdev_tx_t wg_xmit(struct sk_buff *skb, struct net_device *dev)
 	u32 mtu;
 	int ret;
 
-	if (unlikely(wg_skb_examine_untrusted_ip_hdr(skb) != skb->protocol)) {
+	if (unlikely(!wg_check_packet_protocol(skb))) {
 		ret = -EPROTONOSUPPORT;
 		net_dbg_ratelimited("%s: Invalid IP packet\n", dev->name);
 		goto err;
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index fecb559cbdb6..cf1e0e2376d8 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -66,7 +66,7 @@ struct packet_cb {
 #define PACKET_PEER(skb) (PACKET_CB(skb)->keypair->entry.peer)
 
 /* Returns either the correct skb->protocol value, or 0 if invalid. */
-static inline __be16 wg_skb_examine_untrusted_ip_hdr(struct sk_buff *skb)
+static inline __be16 wg_examine_packet_protocol(struct sk_buff *skb)
 {
 	if (skb_network_header(skb) >= skb->head &&
 	    (skb_network_header(skb) + sizeof(struct iphdr)) <=
@@ -81,6 +81,12 @@ static inline __be16 wg_skb_examine_untrusted_ip_hdr(struct sk_buff *skb)
 	return 0;
 }
 
+static inline bool wg_check_packet_protocol(struct sk_buff *skb)
+{
+	__be16 real_protocol = wg_examine_packet_protocol(skb);
+	return real_protocol && skb->protocol == real_protocol;
+}
+
 static inline void wg_reset_packet(struct sk_buff *skb)
 {
 	skb_scrub_packet(skb, true);
diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 4a153894cee2..243ed7172dd2 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -56,7 +56,7 @@ static int prepare_skb_header(struct sk_buff *skb, struct wg_device *wg)
 	size_t data_offset, data_len, header_len;
 	struct udphdr *udp;
 
-	if (unlikely(wg_skb_examine_untrusted_ip_hdr(skb) != skb->protocol ||
+	if (unlikely(!wg_check_packet_protocol(skb) ||
 		     skb_transport_header(skb) < skb->head ||
 		     (skb_transport_header(skb) + sizeof(struct udphdr)) >
 			     skb_tail_pointer(skb)))
@@ -388,7 +388,7 @@ static void wg_packet_consume_data_done(struct wg_peer *peer,
 	 */
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	skb->csum_level = ~0; /* All levels */
-	skb->protocol = wg_skb_examine_untrusted_ip_hdr(skb);
+	skb->protocol = wg_examine_packet_protocol(skb);
 	if (skb->protocol == htons(ETH_P_IP)) {
 		len = ntohs(ip_hdr(skb)->tot_len);
 		if (unlikely(len < sizeof(struct iphdr)))
-- 
2.25.1

