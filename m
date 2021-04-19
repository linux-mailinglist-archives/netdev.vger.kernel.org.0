Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A633D3645ED
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 16:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239296AbhDSOXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 10:23:01 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:53452 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238543AbhDSOXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 10:23:01 -0400
X-Greylist: delayed 375 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Apr 2021 10:23:00 EDT
Received: from think.home (224.110.78.83.dynamic.wline.res.cust.swisscom.ch [83.78.110.224])
        by mail.strongswan.org (Postfix) with ESMTPSA id C8029401B1;
        Mon, 19 Apr 2021 16:16:14 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net-next] net: xdp: Update pkt_type if generic XDP changes unicast MAC
Date:   Mon, 19 Apr 2021 16:15:59 +0200
Message-Id: <20210419141559.8611-1-martin@strongswan.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a generic XDP program changes the destination MAC address from/to
multicast/broadcast, the skb->pkt_type is updated to properly handle
the packet when passed up the stack. When changing the MAC from/to
the NICs MAC, PACKET_HOST/OTHERHOST is not updated, though, making
the behavior different from that of native XDP.

Remember the PACKET_HOST/OTHERHOST state before calling the program
in generic XDP, and update pkt_type accordingly if the destination
MAC address has changed. As eth_type_trans() assumes a default
pkt_type of PACKET_HOST, restore that before calling it.

The use case for this is when a XDP program wants to push received
packets up the stack by rewriting the MAC to the NICs MAC, for
example by cluster nodes sharing MAC addresses.

Fixes: 297249569932 ("net: fix generic XDP to handle if eth header was mangled")
Signed-off-by: Martin Willi <martin@strongswan.org>
---
 net/core/dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d9bf63dbe4fd..eed028aec6a4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4723,10 +4723,10 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	void *orig_data, *orig_data_end, *hard_start;
 	struct netdev_rx_queue *rxqueue;
 	u32 metalen, act = XDP_DROP;
+	bool orig_bcast, orig_host;
 	u32 mac_len, frame_sz;
 	__be16 orig_eth_type;
 	struct ethhdr *eth;
-	bool orig_bcast;
 	int off;
 
 	/* Reinjected packets coming from act_mirred or similar should
@@ -4773,6 +4773,7 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	orig_data_end = xdp->data_end;
 	orig_data = xdp->data;
 	eth = (struct ethhdr *)xdp->data;
+	orig_host = ether_addr_equal_64bits(eth->h_dest, skb->dev->dev_addr);
 	orig_bcast = is_multicast_ether_addr_64bits(eth->h_dest);
 	orig_eth_type = eth->h_proto;
 
@@ -4800,8 +4801,11 @@ static u32 netif_receive_generic_xdp(struct sk_buff *skb,
 	/* check if XDP changed eth hdr such SKB needs update */
 	eth = (struct ethhdr *)xdp->data;
 	if ((orig_eth_type != eth->h_proto) ||
+	    (orig_host != ether_addr_equal_64bits(eth->h_dest,
+						  skb->dev->dev_addr)) ||
 	    (orig_bcast != is_multicast_ether_addr_64bits(eth->h_dest))) {
 		__skb_push(skb, ETH_HLEN);
+		skb->pkt_type = PACKET_HOST;
 		skb->protocol = eth_type_trans(skb, skb->dev);
 	}
 
-- 
2.25.1

