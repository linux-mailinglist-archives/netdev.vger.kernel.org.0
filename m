Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2711C3378B3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhCKQDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:03:40 -0500
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:60949 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234428AbhCKQDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:03:16 -0500
Received: from localhost (unknown [10.16.0.21])
        by proxy.6wind.com (Postfix) with ESMTP id D772290E4EA;
        Thu, 11 Mar 2021 16:53:21 +0100 (CET)
From:   Julien Massonneau <julien.massonneau@6wind.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, dlebrun@google.com
Cc:     Julien Massonneau <julien.massonneau@6wind.com>
Subject: [PATCH net-next 1/2] seg6: add support for IPv4 decapsulation in ipv6_srh_rcv()
Date:   Thu, 11 Mar 2021 16:53:18 +0100
Message-Id: <20210311155319.2280-2-julien.massonneau@6wind.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311155319.2280-1-julien.massonneau@6wind.com>
References: <20210311155319.2280-1-julien.massonneau@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As specified in IETF RFC 8754, section 4.3.1.2, if the upper layer
header is IPv4 or IPv6, perform IPv6 decapsulation and resubmit the
decapsulated packet to the IPv4 or IPv6 module.
Only IPv6 decapsulation was implemented. This patch adds support for IPv4
decapsulation.

Link: https://tools.ietf.org/html/rfc8754#section-4.3.1.2
Signed-off-by: Julien Massonneau <julien.massonneau@6wind.com>
---
 include/net/ipv6.h | 1 +
 net/ipv6/exthdrs.c | 5 +++--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index bd1f396cc9c7..448bf2b34759 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -30,6 +30,7 @@
  */
 
 #define NEXTHDR_HOP		0	/* Hop-by-hop option header. */
+#define NEXTHDR_IPV4		4	/* IPv4 in IPv6 */
 #define NEXTHDR_TCP		6	/* TCP segment. */
 #define NEXTHDR_UDP		17	/* UDP message. */
 #define NEXTHDR_IPV6		41	/* IPv6 in IPv6 */
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 6126f8bf94b3..56e479d158b7 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -381,7 +381,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 
 looped_back:
 	if (hdr->segments_left == 0) {
-		if (hdr->nexthdr == NEXTHDR_IPV6) {
+		if (hdr->nexthdr == NEXTHDR_IPV6 || hdr->nexthdr == NEXTHDR_IPV4) {
 			int offset = (hdr->hdrlen + 1) << 3;
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
@@ -397,7 +397,8 @@ static int ipv6_srh_rcv(struct sk_buff *skb)
 			skb_reset_network_header(skb);
 			skb_reset_transport_header(skb);
 			skb->encapsulation = 0;
-
+			if (hdr->nexthdr == NEXTHDR_IPV4)
+				skb->protocol = htons(ETH_P_IP);
 			__skb_tunnel_rx(skb, skb->dev, net);
 
 			netif_rx(skb);
-- 
2.29.2

