Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBAB207C3D
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406190AbgFXTdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:33:20 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:46267 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405864AbgFXTdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 15:33:17 -0400
Received: from ubuntu18.lan (unknown [109.129.49.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 29935200CCFD;
        Wed, 24 Jun 2020 21:24:25 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 29935200CCFD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593026665;
        bh=AG9GC5e8CFukOwFrUbH01AtmaswJf1IlCmK91l3bF1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOVk2/qZ72Bosq0Vf7Hg2iVRol56Dq3r2Bgbck5nPx8v7NcxwHCgJyrZdsmPjWuWJ
         4/Xw+xWXe1r9EKpfpMAbkgWBonXr4nlkPrq9Vxli1goLz/vF0YuB/AwF5dPc+iMP6w
         X5O6DfIpFuuUfmzFuer4TI7i0PwiNxsXiVue4nlQengpGxtnXyl3EMwH3kL+VsIAqB
         wTlLSTVtkXxki4Ntdz8vGj9GaXnwYuRtYjyiMRc0sFxoCbrJqiDmHOVvQMXFfM8pTy
         EtAttwmNHQyzdcmGCMYEO/v4rrBAwP+1D7Uw8Cj5k11rIyQUPwDNINIm17OJ7qe41e
         N6WXLJM6Uw5OA==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, justin.iurman@uliege.be
Subject: [PATCH net-next 2/5] ipv6: IOAM tunnel decapsulation
Date:   Wed, 24 Jun 2020 21:23:07 +0200
Message-Id: <20200624192310.16923-3-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200624192310.16923-1-justin.iurman@uliege.be>
References: <20200624192310.16923-1-justin.iurman@uliege.be>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement the IOAM egress behavior.

According to RFC 8200:
"Extension headers (except for the Hop-by-Hop Options header) are not
 processed, inserted, or deleted by any node along a packet's delivery
 path, until the packet reaches the node (or each of the set of nodes,
 in the case of multicast) identified in the Destination Address field
 of the IPv6 header."

Therefore, an ingress node (an IOAM domain border) must encapsulate an
incoming IPv6 packet with another similar IPv6 header that will contain
IOAM data while it traverses the domain. When leaving, the egress node,
another IOAM domain border which is also the tunnel destination, must
decapsulate the packet.

Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
---
 include/linux/ipv6.h |  1 +
 net/ipv6/ip6_input.c | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 2cb445a8fc9e..5312a718bc7a 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -138,6 +138,7 @@ struct inet6_skb_parm {
 #define IP6SKB_HOPBYHOP        32
 #define IP6SKB_L3SLAVE         64
 #define IP6SKB_JUMBOGRAM      128
+#define IP6SKB_IOAM           256
 };
 
 #if defined(CONFIG_NET_L3_MASTER_DEV)
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e96304d8a4a7..8cf75cc5e806 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -361,9 +361,11 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *));
 void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			      bool have_final)
 {
+	struct inet6_skb_parm *opt = IP6CB(skb);
 	const struct inet6_protocol *ipprot;
 	struct inet6_dev *idev;
 	unsigned int nhoff;
+	u8 hop_limit;
 	bool raw;
 
 	/*
@@ -450,6 +452,25 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 	} else {
 		if (!raw) {
 			if (xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+				/* IOAM Tunnel Decapsulation
+				 * Packet is going to re-enter the stack
+				 */
+				if (nexthdr == NEXTHDR_IPV6 &&
+				    (opt->flags & IP6SKB_IOAM)) {
+					hop_limit = ipv6_hdr(skb)->hop_limit;
+
+					skb_reset_network_header(skb);
+					skb_reset_transport_header(skb);
+					skb->encapsulation = 0;
+
+					ipv6_hdr(skb)->hop_limit = hop_limit;
+					__skb_tunnel_rx(skb, skb->dev,
+							dev_net(skb->dev));
+
+					netif_rx(skb);
+					goto out;
+				}
+
 				__IP6_INC_STATS(net, idev,
 						IPSTATS_MIB_INUNKNOWNPROTOS);
 				icmpv6_send(skb, ICMPV6_PARAMPROB,
@@ -461,6 +482,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			consume_skb(skb);
 		}
 	}
+out:
 	return;
 
 discard:
-- 
2.17.1

