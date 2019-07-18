Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF366CCB6
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 12:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389689AbfGRKY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 06:24:58 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39156 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbfGRKY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 06:24:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1ho3ap-0001te-US; Thu, 18 Jul 2019 12:24:56 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>,
        Jason Muskat <jason@metalcastle.ca>
Subject: [RFC net] net: generate icmp redirects after netfilter forward hook
Date:   Thu, 18 Jul 2019 12:24:40 +0200
Message-Id: <20190718102440.8355-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting from
https://bugzilla.kernel.org/show_bug.cgi?id=204155

 ----
1. Configure an PPPoE interface (e.g., ppp0) with an IPv6 address and
   a prefixlen of 64; e.g., 2001:0DB8::1/64.
2. Configure a Netfilter ip6table rule to drop IN to OUT forwarding of traffic
   across the PPP interface: ip6tables -A FORWARD -i ppp+ -o ppp+ -j DROP
3. Create a Netfilter NFLOG rule to log all outbound traffic.
4. From an Internet IPv6 Address initiate TCP traffic to an IPv6 address
   within the /64 IPv6 address space from step 1, but an IPv6 address that
   is NOT configured on that interface; e.g., ` nc 2001:0DB8::2 80`
5. Observe the NFLOG showing the Netfilter ip6table filter FORWARD rule
   is matched and therefore the traffic should be dropped.
6. Observe the traffic from step 4, that should have been dropped,
   resulted in an outbound ICMPv6 Redirect with a source IPv6 address of
   the PPP interface’s Local Link to the Internet IPv6 Address.
 ----

Problem is that we emit the redirect before passing the packet to the
netfilter FORWARD hook.   The same "problem" exists in ipv4.

There are various counter-arguments to changing this, e.g.  we would
still emit such redirect when packet is dropped later in the stack
(e.g. in POSTROUTING or qdisc).

We will also still emit e.g. ICMPV6 PKTTOOBIG error, as that occurs
before FORWARD as well, and moving that seems wrong (packet
has to be dropped).

The only argument that I can think of in favor of this change
is the lack of a proper alternative to filtering such traffic.

PREROUTING would work, but at that point we lack the
"packet will be forwarded from ppp0 to ppp0" information that
we only have available in FORWARD.

Compile tested only.

Cc: Jason Muskat <jason@metalcastle.ca>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/ip_forward.c | 16 +++++------
 net/ipv6/ip6_output.c | 63 ++++++++++++++++++++++++-------------------
 2 files changed, 44 insertions(+), 35 deletions(-)

diff --git a/net/ipv4/ip_forward.c b/net/ipv4/ip_forward.c
index 06f6f280b9ff..33c46470c966 100644
--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -69,6 +69,14 @@ static int ip_forward_finish(struct net *net, struct sock *sk, struct sk_buff *s
 	__IP_INC_STATS(net, IPSTATS_MIB_OUTFORWDATAGRAMS);
 	__IP_ADD_STATS(net, IPSTATS_MIB_OUTOCTETS, skb->len);
 
+	/*
+	 *	We now generate an ICMP HOST REDIRECT giving the route
+	 *	we calculated.
+	 */
+	if (IPCB(skb)->flags & IPSKB_DOREDIRECT && !opt->srr &&
+	    !skb_sec_path(skb))
+		ip_rt_send_redirect(skb);
+
 #ifdef CONFIG_NET_SWITCHDEV
 	if (skb->offload_l3_fwd_mark) {
 		consume_skb(skb);
@@ -143,14 +151,6 @@ int ip_forward(struct sk_buff *skb)
 	/* Decrease ttl after skb cow done */
 	ip_decrease_ttl(iph);
 
-	/*
-	 *	We now generate an ICMP HOST REDIRECT giving the route
-	 *	we calculated.
-	 */
-	if (IPCB(skb)->flags & IPSKB_DOREDIRECT && !opt->srr &&
-	    !skb_sec_path(skb))
-		ip_rt_send_redirect(skb);
-
 	if (net->ipv4.sysctl_ip_fwd_update_priority)
 		skb->priority = rt_tos2priority(iph->tos);
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8e49fd62eea9..2dafd2da2926 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -383,11 +383,45 @@ static int ip6_forward_proxy_check(struct sk_buff *skb)
 static inline int ip6_forward_finish(struct net *net, struct sock *sk,
 				     struct sk_buff *skb)
 {
+	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct dst_entry *dst = skb_dst(skb);
 
 	__IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTFORWDATAGRAMS);
 	__IP6_ADD_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTOCTETS, skb->len);
 
+	/* IPv6 specs say nothing about it, but it is clear that we cannot
+	   send redirects to source routed frames.
+	   We don't send redirects to frames decapsulated from IPsec.
+	 */
+	if (IP6CB(skb)->iif == dst->dev->ifindex &&
+	    opt->srcrt == 0 && !skb_sec_path(skb)) {
+		struct ipv6hdr *hdr = ipv6_hdr(skb);
+		struct in6_addr *target = NULL;
+		struct inet_peer *peer;
+		struct rt6_info *rt;
+
+		/*
+		 *	incoming and outgoing devices are the same
+		 *	send a redirect.
+		 */
+
+		rt = (struct rt6_info *) dst;
+		if (rt->rt6i_flags & RTF_GATEWAY)
+			target = &rt->rt6i_gateway;
+		else
+			target = &hdr->daddr;
+
+		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr, 1);
+
+		/* Limit redirects both by destination (here)
+		   and by source (inside ndisc_send_redirect)
+		 */
+		if (inet_peer_xrlim_allow(peer, 1*HZ))
+			ndisc_send_redirect(skb, target);
+		if (peer)
+			inet_putpeer(peer);
+	}
+
 #ifdef CONFIG_NET_SWITCHDEV
 	if (skb->offload_l3_fwd_mark) {
 		consume_skb(skb);
@@ -498,33 +532,8 @@ int ip6_forward(struct sk_buff *skb)
 	   send redirects to source routed frames.
 	   We don't send redirects to frames decapsulated from IPsec.
 	 */
-	if (IP6CB(skb)->iif == dst->dev->ifindex &&
-	    opt->srcrt == 0 && !skb_sec_path(skb)) {
-		struct in6_addr *target = NULL;
-		struct inet_peer *peer;
-		struct rt6_info *rt;
-
-		/*
-		 *	incoming and outgoing devices are the same
-		 *	send a redirect.
-		 */
-
-		rt = (struct rt6_info *) dst;
-		if (rt->rt6i_flags & RTF_GATEWAY)
-			target = &rt->rt6i_gateway;
-		else
-			target = &hdr->daddr;
-
-		peer = inet_getpeer_v6(net->ipv6.peers, &hdr->daddr, 1);
-
-		/* Limit redirects both by destination (here)
-		   and by source (inside ndisc_send_redirect)
-		 */
-		if (inet_peer_xrlim_allow(peer, 1*HZ))
-			ndisc_send_redirect(skb, target);
-		if (peer)
-			inet_putpeer(peer);
-	} else {
+	if (IP6CB(skb)->iif != dst->dev->ifindex ||
+	    opt->srcrt || skb_sec_path(skb)) {
 		int addrtype = ipv6_addr_type(&hdr->saddr);
 
 		/* This check is security critical. */
-- 
2.21.0

