Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F172445D8
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 09:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgHNHbB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 03:31:01 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:47619 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgHNHbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 03:31:01 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 806e3fcd;
        Fri, 14 Aug 2020 07:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=rfLwmOjk2tYm
        2/AsGhKDhEikx2w=; b=uMAvjW4+5NUxxqtndmjbqPAvW+JQFpNrAfZinlkphign
        kGNdxVhXh+805SfywPBJqR+OqWLLXx5LmysJUhQjrF8l+NovYV9n/h9Sw5S+lWnm
        YxMbbCdGaw6ysfSySKCwPydwe3n8x6sANNKiQ3m9j+g9MR1dRulMeVu6c2deN44B
        uVmWBN9PCxq9QfAzr+EEaocHV3PIB9QjCixuRPYpDz+m4eFNDo4XwxHfUMViq+D4
        F6492YPPxfMGwXRj5aTufpp2+rg2IX17vRl6xGu0lrzvnz2AKM7J00zxUVO7NXbi
        UzZLLEThcJgGBbdgJISacJBVtsCwwdMS3bqy3b7sig==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 26a68a7e (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Fri, 14 Aug 2020 07:05:21 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH net v5] net: xdp: account for layer 3 packets in generic skb handler
Date:   Fri, 14 Aug 2020 09:30:48 +0200
Message-Id: <20200814073048.30291-1-Jason@zx2c4.com>
In-Reply-To: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
References: <CAHmME9rbRrdV0ePxT0DgurGdEKOWiEi5mH5Wtg=aJwSA6fxwMg@mail.gmail.com>
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

We push on the ethernet header and then pull it right off and set
mac_len to the ethernet header size, so that the rest of the XDP code
does not need any changes. That is, it makes it so that the skb has its
ethernet header just before the data pointer, of size ETH_HLEN. While
we're at it, this also fixes a small inconsistency from the prior code,
in which an XDP program that changes skb->protocol would wind up pushing
the ethernet header back on but would forget to take it back off
following the h_proto parsing.

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

Changes v4->v5:
- Rather than tracking in a messy manner whether the skb is l3, we just
  do the check once, and then adjust the skb geometry to be identical to
  the l2 case. This simplifies the code quite a bit.
- Fix a preexisting bug where the l2 header remained attached if
  skb->protocol was updated.

Changes v3->v4:
- We now preserve the same logic for XDP_TX/XDP_REDIRECT as before.
- hard_header_len is checked in addition to mac_len.

 net/core/dev.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..79c15f4244e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4630,6 +4630,18 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	 * header.
 	 */
 	mac_len = skb->data - skb_mac_header(skb);
+	if (!mac_len && !skb->dev->hard_header_len) {
+		/* For l3 packets, we push on a fake mac header, and then
+		 * pull it off again, so that it has the same skb geometry
+		 * as for the l2 case.
+		 */
+		eth = skb_push(skb, ETH_HLEN);
+		eth_zero_addr(eth->h_source);
+		eth_zero_addr(eth->h_dest);
+		eth->h_proto = skb->protocol;
+		__skb_pull(skb, ETH_HLEN);
+		mac_len = ETH_HLEN;
+	}
 	hlen = skb_headlen(skb) + mac_len;
 	xdp->data = skb->data - mac_len;
 	xdp->data_meta = xdp->data;
@@ -4676,6 +4688,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
 		__skb_push(skb, ETH_HLEN);
 		skb->protocol = eth_type_trans(skb, skb->dev);
+		__skb_pull(skb, ETH_HLEN);
 	}
 
 	switch (act) {
-- 
2.28.0

