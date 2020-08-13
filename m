Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5707C243F86
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 21:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHMT6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 15:58:36 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:38313 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726384AbgHMT6g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Aug 2020 15:58:36 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id bd5d17d2;
        Thu, 13 Aug 2020 19:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-type
        :content-transfer-encoding; s=mail; bh=HYbo3euRJSGqbqX7zObL7K88r
        wo=; b=tXfXl3WDPWA776FfPcQapGOKwycCL8XxX90wRdqBXUUdc13yUrNrYo+yK
        Wm1CyNqSV8RKPGPhK8Kkj+VkFZCJK7xaK2TBgOszeDzo/u/hAFuBN78sWUXu+wTz
        XEK1YGdrIiPxCgYeTXqpaRx1g1QT/1WgW/b6eZqt0dpQn7cUYrZ+XZgcSliivyoD
        A9RVh81JDBvSb88a22fcgOdgU8svDGlxBqfX5gC7+0KsJvnwxjWjyzTPl59Z9Y7p
        pyGlGP0t93w/ANZxh3Gc+VyRujIhFe74eSS7D/LaHcqDHX+iRppP2cbT2Ykw2RIY
        F3DiBmlS/9zsuOmOE7AZd8mKg8fhw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 50a7f946 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 13 Aug 2020 19:33:00 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH net v4] net: xdp: account for layer 3 packets in generic skb handler
Date:   Thu, 13 Aug 2020 21:58:16 +0200
Message-Id: <20200813195816.67222-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A user reported that packets from wireguard were possibly ignored by XDP
[1]. Another user reported that modifying packets from layer 3
interfaces results in impossible to diagnose drops.

Apparently, the generic skb xdp handler path seems to assume that
packets will always have an ethernet header, which really isn't always
the case for layer 3 packets, which are produced by multiple drivers.
This patch fixes the oversight. If the mac_len is 0 and so is
hard_header_len, then we know that the skb is a layer 3 packet, and in
that case prepend a pseudo ethhdr to the packet whose h_proto is copied
from skb->protocol, which will have the appropriate v4 or v6 ethertype.
This allows us to keep XDP programs' assumption correct about packets
always having that ethernet header, so that existing code doesn't break,
while still allowing layer 3 devices to use the generic XDP handler.

For the XDP_PASS case, we remove the added ethernet header after the
program runs. And for the XDP_REDIRECT or XDP_TX cases, we leave it on.
This mirrors the logic for layer 2 packets, where mac_len is part of the
buffer given to xdp, and then is pushed for the XDP_REDIRECT or XDP_TX
cases, while it has already been naturally removed for the XDP_PASS
case, since it always existed in the head space. This should preserve
semantics for both cases.

Previous discussions have included the point that maybe XDP should just
be intentionally broken on layer 3 interfaces, by design, and that layer
3 people should be using cls_bpf. However, I think there are good
grounds to reconsider this perspective:

- Complicated deployments wind up applying XDP modifications to a
  variety of different devices on a given host, some of which are using
  specialized ethernet cards and other ones using virtual layer 3
  interfaces, such as WireGuard. Being able to apply one codebase to
  each of these winds up being essential.

- cls_bpf does not support the same feature set as XDP, and operates at
  a slightly different stage in the networking stack. You may reply,
  "then add all the features you want to cls_bpf", but that seems to be
  missing the point, and would still result in there being two ways to
  do everything, which is not desirable for anyone actually _using_ this
  code.

- While XDP was originally made for hardware offloading, and while many
  look disdainfully upon the generic mode, it nevertheless remains a
  highly useful and popular way of adding bespoke packet
  transformations, and from that perspective, a difference between layer
  2 and layer 3 packets is immaterial if the user is primarily concerned
  with transformations to layer 3 and beyond.

[1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/

Reported-by: Thomas Ptacek <thomas@sockpuppet.org>
Reported-by: Adhipati Blambangan <adhipati@tuta.io>
Cc: David Ahern <dsahern@gmail.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
I had originally dropped this patch, but the issue kept coming up in
user reports, so here's a v4 of it. Testing of it is still rather slim,
but hopefully that will change in the coming days.

Changes v3->v4:
- We now preserve the same logic for XDP_TX/XDP_REDIRECT as before.
- hard_header_len is checked in addition to mac_len.

 net/core/dev.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..e6403e74a6aa 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4591,12 +4591,12 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 				     struct xdp_buff *xdp,
 				     struct bpf_prog *xdp_prog)
 {
+	bool orig_bcast, skb_is_l3 = false;
 	struct netdev_rx_queue *rxqueue;
 	void *orig_data, *orig_data_end;
 	u32 metalen, act = XDP_DROP;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
-	bool orig_bcast;
 	int hlen, off;
 	u32 mac_len;
 
@@ -4630,6 +4630,13 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * header.
 	 */
 	mac_len = skb->data - skb_mac_header(skb);
+	skb_is_l3 = !mac_len && !skb->dev->hard_header_len;
+	if (skb_is_l3) {
+		eth = skb_push(skb, sizeof(struct ethhdr));
+		eth_zero_addr(eth->h_source);
+		eth_zero_addr(eth->h_dest);
+		eth->h_proto = skb->protocol;
+	}
 	hlen = skb_headlen(skb) + mac_len;
 	xdp->data = skb->data - mac_len;
 	xdp->data_meta = xdp->data;
@@ -4684,6 +4691,8 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 		__skb_push(skb, mac_len);
 		break;
 	case XDP_PASS:
+		if (skb_is_l3)
+			skb_pull(skb, sizeof(struct ethhdr));
 		metalen = xdp->data - xdp->data_meta;
 		if (metalen)
 			skb_metadata_set(skb, metalen);
-- 
2.28.0

