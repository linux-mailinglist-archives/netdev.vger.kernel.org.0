Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8DCD6C5885
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 22:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjCVVI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 17:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbjCVVIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 17:08:38 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008EC132E9;
        Wed, 22 Mar 2023 14:08:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pf5h4-00043M-PF; Wed, 22 Mar 2023 22:08:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>,
        Madhu Koriginja <madhu.koriginja@nxp.com>
Subject: [PATCH net-next 5/5] netfilter: keep conntrack reference until IPsecv6 policy checks are done
Date:   Wed, 22 Mar 2023 22:08:02 +0100
Message-Id: <20230322210802.6743-6-fw@strlen.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322210802.6743-1-fw@strlen.de>
References: <20230322210802.6743-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhu Koriginja <madhu.koriginja@nxp.com>

Keep the conntrack reference until policy checks have been performed for
IPsec V6 NAT support, just like ipv4.

The reference needs to be dropped before a packet is
queued to avoid having the conntrack module unloadable.

Fixes: 58a317f1061c ("netfilter: ipv6: add IPv6 NAT support")
Signed-off-by: Madhu Koriginja <madhu.koriginja@nxp.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/dccp/ipv6.c      |  1 +
 net/ipv6/ip6_input.c | 14 ++++++--------
 net/ipv6/raw.c       |  5 ++---
 net/ipv6/tcp_ipv6.c  |  2 ++
 net/ipv6/udp.c       |  2 ++
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 47fb10834223..93c98990d726 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -784,6 +784,7 @@ static int dccp_v6_rcv(struct sk_buff *skb)
 
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
+	nf_reset_ct(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4,
 				refcounted) ? -1 : 0;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index e1ebf5e42ebe..d94041bb4287 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -404,10 +404,6 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			/* Only do this once for first final protocol */
 			have_final = true;
 
-			/* Free reference early: we don't need it any more,
-			   and it may hold ip_conntrack module loaded
-			   indefinitely. */
-			nf_reset_ct(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
@@ -430,10 +426,12 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 				goto discard;
 			}
 		}
-		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
-			SKB_DR_SET(reason, XFRM_POLICY);
-			goto discard;
+		if (!(ipprot->flags & INET6_PROTO_NOPOLICY)) {
+			if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+				SKB_DR_SET(reason, XFRM_POLICY);
+				goto discard;
+			}
+			nf_reset_ct(skb);
 		}
 
 		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6ac2f2690c44..4ab62a9c5c8e 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -194,10 +194,8 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 			struct sk_buff *clone = skb_clone(skb, GFP_ATOMIC);
 
 			/* Not releasing hash table! */
-			if (clone) {
-				nf_reset_ct(clone);
+			if (clone)
 				rawv6_rcv(sk, clone);
-			}
 		}
 	}
 	rcu_read_unlock();
@@ -391,6 +389,7 @@ int rawv6_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb_reason(skb, SKB_DROP_REASON_XFRM_POLICY);
 		return NET_RX_DROP;
 	}
+	nf_reset_ct(skb);
 
 	if (!rp->checksum)
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 35cf523c9efd..244cf86c4cbb 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1723,6 +1723,8 @@ INDIRECT_CALLABLE_SCOPE int tcp_v6_rcv(struct sk_buff *skb)
 	if (drop_reason)
 		goto discard_and_relse;
 
+	nf_reset_ct(skb);
+
 	if (tcp_filter(sk, skb)) {
 		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto discard_and_relse;
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d350e57c4792..4caa70a1b871 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -704,6 +704,7 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
 	}
+	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -1027,6 +1028,7 @@ int __udp6_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto discard;
+	nf_reset_ct(skb);
 
 	if (udp_lib_checksum_complete(skb))
 		goto csum_error;
-- 
2.39.2

