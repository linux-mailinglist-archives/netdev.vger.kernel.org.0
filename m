Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF732454F4
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 01:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728580AbgHOXlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Aug 2020 19:41:24 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:55225 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726429AbgHOXlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 Aug 2020 19:41:24 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 57e5ed94;
        Sat, 15 Aug 2020 07:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-type:content-transfer-encoding; s=mail; bh=8Qjf+nS4+2iB
        grrnVwyy+Y9pqsY=; b=smtwuOwR5FYc6sJHnacSwvljOMeqrKKkoguT2FImIV8b
        ZcpZA7/BlZWu97gncg9nSWmizUbp9LbTdTYSObGbPZ7xoJ532y9WnFDfiuEKKXAW
        03N//42dcDS8noDzIuC22qG9BS5lcagkkfLrFrSwoH+sNm7V1ueDLAkl0mftfPFk
        6iC+y8t2+aS7pAVhiGSeG5Ly84DRgt+C18njvLiK6Y0OkgYl0ApNSjyZlZds8x3S
        rW7wKIXTDVqOG4K10jfY5abbGCvyf7BrlLKJcT8IKplrdqTiFjrdhXLVMCfJgPvn
        2y14U7uryj9B7MDNOUJVcIGTVj3fKWPeDXICw4S0eQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f925c602 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sat, 15 Aug 2020 07:15:30 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Thomas Ptacek <thomas@sockpuppet.org>,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net v6] net: xdp: account for layer 3 packets in generic skb handler
Date:   Sat, 15 Aug 2020 09:41:02 +0200
Message-Id: <20200815074102.5357-1-Jason@zx2c4.com>
In-Reply-To: <20200814.135546.2266851283177227377.davem@davemloft.net>
References: <20200814.135546.2266851283177227377.davem@davemloft.net>
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
ethernet header just before the data pointer, of size ETH_HLEN.

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

- It's not impossible to imagine layer 3 hardware (e.g. a WireGuard PCIe
  card) including eBPF/XDP functionality built-in. In that case, why
  limit XDP as a technology to only layer 2? Then, having generic XDP
  work for layer 3 would naturally fit as well.

[1] https://lore.kernel.org/wireguard/M5WzVK5--3-2@tuta.io/

Reported-by: Thomas Ptacek <thomas@sockpuppet.org>
Reported-by: Adhipati Blambangan <adhipati@tuta.io>
Cc: David Ahern <dsahern@gmail.com>
Cc: Toke Høiland-Jørgensen <toke@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---

I had originally dropped this patch, but the issue kept coming up in
user reports, so here's a v4 of it. Testing of it is still rather slim,
but hopefully that will change in the coming days.

Changes v5->v6:
- The fix to the skb->protocol changing case is now in a separate
  stand-alone patch, and removed from this one, so that it can be
  evaluated separately.

Changes v4->v5:
- Rather than tracking in a messy manner whether the skb is l3, we just
  do the check once, and then adjust the skb geometry to be identical to
  the l2 case. This simplifies the code quite a bit.
- Fix a preexisting bug where the l2 header remained attached if
  skb->protocol was updated.

Changes v3->v4:
- We now preserve the same logic for XDP_TX/XDP_REDIRECT as before.
- hard_header_len is checked in addition to mac_len.

 net/core/dev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 151f1651439f..79c15f4244e6 100644
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
-- 
2.28.0

