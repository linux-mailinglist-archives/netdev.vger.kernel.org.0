Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2EE2A6617
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 15:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbgKDOMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 09:12:22 -0500
Received: from correo.us.es ([193.147.175.20]:35734 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgKDOME (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 09:12:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E4A0BB60C4
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:11:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C8BABDA84D
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 15:11:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C71E9DA84B; Wed,  4 Nov 2020 15:11:59 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A1AFDA73F;
        Wed,  4 Nov 2020 15:11:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Nov 2020 15:11:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id CB19A42EF9E0;
        Wed,  4 Nov 2020 15:11:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/8] netfilter: nf_reject: add reject skbuff creation helpers
Date:   Wed,  4 Nov 2020 15:11:42 +0100
Message-Id: <20201104141149.30082-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201104141149.30082-1-pablo@netfilter.org>
References: <20201104141149.30082-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jose M. Guisado Gomez" <guigom@riseup.net>

Adds reject skbuff creation helper functions to ipv4/6 nf_reject
infrastructure. Use these functions for reject verdict in bridge
family.

Can be reused by all different families that support reject and
will not inject the reject packet through ip local out.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/ipv4/nf_reject.h   |  10 ++
 include/net/netfilter/ipv6/nf_reject.h   |   9 ++
 net/bridge/netfilter/Kconfig             |   2 +-
 net/bridge/netfilter/nft_reject_bridge.c | 195 +----------------------
 net/ipv4/netfilter/nf_reject_ipv4.c      | 122 ++++++++++++++
 net/ipv6/netfilter/nf_reject_ipv6.c      | 134 ++++++++++++++++
 6 files changed, 280 insertions(+), 192 deletions(-)

diff --git a/include/net/netfilter/ipv4/nf_reject.h b/include/net/netfilter/ipv4/nf_reject.h
index 40e0e0623f46..0d8ff84a2588 100644
--- a/include/net/netfilter/ipv4/nf_reject.h
+++ b/include/net/netfilter/ipv4/nf_reject.h
@@ -18,4 +18,14 @@ struct iphdr *nf_reject_iphdr_put(struct sk_buff *nskb,
 void nf_reject_ip_tcphdr_put(struct sk_buff *nskb, const struct sk_buff *oldskb,
 			     const struct tcphdr *oth);
 
+struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
+                                         struct sk_buff *oldskb,
+                                         const struct net_device *dev,
+                                         int hook, u8 code);
+struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
+					   struct sk_buff *oldskb,
+					   const struct net_device *dev,
+					   int hook);
+
+
 #endif /* _IPV4_NF_REJECT_H */
diff --git a/include/net/netfilter/ipv6/nf_reject.h b/include/net/netfilter/ipv6/nf_reject.h
index 4a3ef9ebdf6f..edcf6d1cd316 100644
--- a/include/net/netfilter/ipv6/nf_reject.h
+++ b/include/net/netfilter/ipv6/nf_reject.h
@@ -20,4 +20,13 @@ void nf_reject_ip6_tcphdr_put(struct sk_buff *nskb,
 			      const struct sk_buff *oldskb,
 			      const struct tcphdr *oth, unsigned int otcplen);
 
+struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
+					   struct sk_buff *oldskb,
+					   const struct net_device *dev,
+					   int hook);
+struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
+					 struct sk_buff *oldskb,
+					 const struct net_device *dev,
+					 int hook, u8 code);
+
 #endif /* _IPV6_NF_REJECT_H */
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 5040fe43f4b4..e4d287afc2c9 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -17,7 +17,7 @@ config NFT_BRIDGE_META
 
 config NFT_BRIDGE_REJECT
 	tristate "Netfilter nf_tables bridge reject support"
-	depends on NFT_REJECT && NFT_REJECT_IPV4 && NFT_REJECT_IPV6
+	depends on NFT_REJECT
 	help
 	  Add support to reject packets.
 
diff --git a/net/bridge/netfilter/nft_reject_bridge.c b/net/bridge/netfilter/nft_reject_bridge.c
index deae2c9a0f69..25ca7723c6c2 100644
--- a/net/bridge/netfilter/nft_reject_bridge.c
+++ b/net/bridge/netfilter/nft_reject_bridge.c
@@ -39,30 +39,6 @@ static void nft_reject_br_push_etherhdr(struct sk_buff *oldskb,
 	}
 }
 
-static int nft_bridge_iphdr_validate(struct sk_buff *skb)
-{
-	struct iphdr *iph;
-	u32 len;
-
-	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
-		return 0;
-
-	iph = ip_hdr(skb);
-	if (iph->ihl < 5 || iph->version != 4)
-		return 0;
-
-	len = ntohs(iph->tot_len);
-	if (skb->len < len)
-		return 0;
-	else if (len < (iph->ihl*4))
-		return 0;
-
-	if (!pskb_may_pull(skb, iph->ihl*4))
-		return 0;
-
-	return 1;
-}
-
 /* We cannot use oldskb->dev, it can be either bridge device (NF_BRIDGE INPUT)
  * or the bridge port (NF_BRIDGE PREROUTING).
  */
@@ -72,29 +48,11 @@ static void nft_reject_br_send_v4_tcp_reset(struct net *net,
 					    int hook)
 {
 	struct sk_buff *nskb;
-	struct iphdr *niph;
-	const struct tcphdr *oth;
-	struct tcphdr _oth;
 
-	if (!nft_bridge_iphdr_validate(oldskb))
-		return;
-
-	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
-	if (!oth)
-		return;
-
-	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +
-			 LL_MAX_HEADER, GFP_ATOMIC);
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
 	if (!nskb)
 		return;
 
-	skb_reserve(nskb, LL_MAX_HEADER);
-	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   net->ipv4.sysctl_ip_default_ttl);
-	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
-	niph->tot_len = htons(nskb->len);
-	ip_send_check(niph);
-
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
 	br_forward(br_port_get_rcu(dev), nskb, false, true);
@@ -106,139 +64,32 @@ static void nft_reject_br_send_v4_unreach(struct net *net,
 					  int hook, u8 code)
 {
 	struct sk_buff *nskb;
-	struct iphdr *niph;
-	struct icmphdr *icmph;
-	unsigned int len;
-	__wsum csum;
-	u8 proto;
-
-	if (!nft_bridge_iphdr_validate(oldskb))
-		return;
 
-	/* IP header checks: fragment. */
-	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
-		return;
-
-	/* RFC says return as much as we can without exceeding 576 bytes. */
-	len = min_t(unsigned int, 536, oldskb->len);
-
-	if (!pskb_may_pull(oldskb, len))
-		return;
-
-	if (pskb_trim_rcsum(oldskb, ntohs(ip_hdr(oldskb)->tot_len)))
-		return;
-
-	proto = ip_hdr(oldskb)->protocol;
-
-	if (!skb_csum_unnecessary(oldskb) &&
-	    nf_reject_verify_csum(proto) &&
-	    nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), proto))
-		return;
-
-	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmphdr) +
-			 LL_MAX_HEADER + len, GFP_ATOMIC);
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
 	if (!nskb)
 		return;
 
-	skb_reserve(nskb, LL_MAX_HEADER);
-	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_ICMP,
-				   net->ipv4.sysctl_ip_default_ttl);
-
-	skb_reset_transport_header(nskb);
-	icmph = skb_put_zero(nskb, sizeof(struct icmphdr));
-	icmph->type     = ICMP_DEST_UNREACH;
-	icmph->code	= code;
-
-	skb_put_data(nskb, skb_network_header(oldskb), len);
-
-	csum = csum_partial((void *)icmph, len + sizeof(struct icmphdr), 0);
-	icmph->checksum = csum_fold(csum);
-
-	niph->tot_len	= htons(nskb->len);
-	ip_send_check(niph);
-
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
 	br_forward(br_port_get_rcu(dev), nskb, false, true);
 }
 
-static int nft_bridge_ip6hdr_validate(struct sk_buff *skb)
-{
-	struct ipv6hdr *hdr;
-	u32 pkt_len;
-
-	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
-		return 0;
-
-	hdr = ipv6_hdr(skb);
-	if (hdr->version != 6)
-		return 0;
-
-	pkt_len = ntohs(hdr->payload_len);
-	if (pkt_len + sizeof(struct ipv6hdr) > skb->len)
-		return 0;
-
-	return 1;
-}
-
 static void nft_reject_br_send_v6_tcp_reset(struct net *net,
 					    struct sk_buff *oldskb,
 					    const struct net_device *dev,
 					    int hook)
 {
 	struct sk_buff *nskb;
-	const struct tcphdr *oth;
-	struct tcphdr _oth;
-	unsigned int otcplen;
-	struct ipv6hdr *nip6h;
-
-	if (!nft_bridge_ip6hdr_validate(oldskb))
-		return;
 
-	oth = nf_reject_ip6_tcphdr_get(oldskb, &_oth, &otcplen, hook);
-	if (!oth)
-		return;
-
-	nskb = alloc_skb(sizeof(struct ipv6hdr) + sizeof(struct tcphdr) +
-			 LL_MAX_HEADER, GFP_ATOMIC);
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
 	if (!nskb)
 		return;
 
-	skb_reserve(nskb, LL_MAX_HEADER);
-	nip6h = nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP,
-				     net->ipv6.devconf_all->hop_limit);
-	nf_reject_ip6_tcphdr_put(nskb, oldskb, oth, otcplen);
-	nip6h->payload_len = htons(nskb->len - sizeof(struct ipv6hdr));
-
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
 	br_forward(br_port_get_rcu(dev), nskb, false, true);
 }
 
-static bool reject6_br_csum_ok(struct sk_buff *skb, int hook)
-{
-	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
-	int thoff;
-	__be16 fo;
-	u8 proto = ip6h->nexthdr;
-
-	if (skb_csum_unnecessary(skb))
-		return true;
-
-	if (ip6h->payload_len &&
-	    pskb_trim_rcsum(skb, ntohs(ip6h->payload_len) + sizeof(*ip6h)))
-		return false;
-
-	ip6h = ipv6_hdr(skb);
-	thoff = ipv6_skip_exthdr(skb, ((u8*)(ip6h+1) - skb->data), &proto, &fo);
-	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
-		return false;
-
-	if (!nf_reject_verify_csum(proto))
-		return true;
-
-	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
-}
 
 static void nft_reject_br_send_v6_unreach(struct net *net,
 					  struct sk_buff *oldskb,
@@ -246,49 +97,11 @@ static void nft_reject_br_send_v6_unreach(struct net *net,
 					  int hook, u8 code)
 {
 	struct sk_buff *nskb;
-	struct ipv6hdr *nip6h;
-	struct icmp6hdr *icmp6h;
-	unsigned int len;
-
-	if (!nft_bridge_ip6hdr_validate(oldskb))
-		return;
-
-	/* Include "As much of invoking packet as possible without the ICMPv6
-	 * packet exceeding the minimum IPv6 MTU" in the ICMP payload.
-	 */
-	len = min_t(unsigned int, 1220, oldskb->len);
-
-	if (!pskb_may_pull(oldskb, len))
-		return;
 
-	if (!reject6_br_csum_ok(oldskb, hook))
-		return;
-
-	nskb = alloc_skb(sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr) +
-			 LL_MAX_HEADER + len, GFP_ATOMIC);
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
 	if (!nskb)
 		return;
 
-	skb_reserve(nskb, LL_MAX_HEADER);
-	nip6h = nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_ICMPV6,
-				     net->ipv6.devconf_all->hop_limit);
-
-	skb_reset_transport_header(nskb);
-	icmp6h = skb_put_zero(nskb, sizeof(struct icmp6hdr));
-	icmp6h->icmp6_type = ICMPV6_DEST_UNREACH;
-	icmp6h->icmp6_code = code;
-
-	skb_put_data(nskb, skb_network_header(oldskb), len);
-	nip6h->payload_len = htons(nskb->len - sizeof(struct ipv6hdr));
-
-	icmp6h->icmp6_cksum =
-		csum_ipv6_magic(&nip6h->saddr, &nip6h->daddr,
-				nskb->len - sizeof(struct ipv6hdr),
-				IPPROTO_ICMPV6,
-				csum_partial(icmp6h,
-					     nskb->len - sizeof(struct ipv6hdr),
-					     0));
-
 	nft_reject_br_push_etherhdr(oldskb, nskb);
 
 	br_forward(br_port_get_rcu(dev), nskb, false, true);
diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 9dcfa4e461b6..8ca99342879c 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -12,6 +12,128 @@
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_bridge.h>
 
+static int nf_reject_iphdr_validate(struct sk_buff *skb)
+{
+	struct iphdr *iph;
+	u32 len;
+
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		return 0;
+
+	iph = ip_hdr(skb);
+	if (iph->ihl < 5 || iph->version != 4)
+		return 0;
+
+	len = ntohs(iph->tot_len);
+	if (skb->len < len)
+		return 0;
+	else if (len < (iph->ihl*4))
+		return 0;
+
+	if (!pskb_may_pull(skb, iph->ihl*4))
+		return 0;
+
+	return 1;
+}
+
+struct sk_buff *nf_reject_skb_v4_tcp_reset(struct net *net,
+					   struct sk_buff *oldskb,
+					   const struct net_device *dev,
+					   int hook)
+{
+	const struct tcphdr *oth;
+	struct sk_buff *nskb;
+	struct iphdr *niph;
+	struct tcphdr _oth;
+
+	if (!nf_reject_iphdr_validate(oldskb))
+		return NULL;
+
+	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
+	if (!oth)
+		return NULL;
+
+	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct tcphdr) +
+			 LL_MAX_HEADER, GFP_ATOMIC);
+	if (!nskb)
+		return NULL;
+
+	nskb->dev = (struct net_device *)dev;
+
+	skb_reserve(nskb, LL_MAX_HEADER);
+	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
+				   net->ipv4.sysctl_ip_default_ttl);
+	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
+	niph->tot_len = htons(nskb->len);
+	ip_send_check(niph);
+
+	return nskb;
+}
+EXPORT_SYMBOL_GPL(nf_reject_skb_v4_tcp_reset);
+
+struct sk_buff *nf_reject_skb_v4_unreach(struct net *net,
+					 struct sk_buff *oldskb,
+					 const struct net_device *dev,
+					 int hook, u8 code)
+{
+	struct sk_buff *nskb;
+	struct iphdr *niph;
+	struct icmphdr *icmph;
+	unsigned int len;
+	__wsum csum;
+	u8 proto;
+
+	if (!nf_reject_iphdr_validate(oldskb))
+		return NULL;
+
+	/* IP header checks: fragment. */
+	if (ip_hdr(oldskb)->frag_off & htons(IP_OFFSET))
+		return NULL;
+
+	/* RFC says return as much as we can without exceeding 576 bytes. */
+	len = min_t(unsigned int, 536, oldskb->len);
+
+	if (!pskb_may_pull(oldskb, len))
+		return NULL;
+
+	if (pskb_trim_rcsum(oldskb, ntohs(ip_hdr(oldskb)->tot_len)))
+		return NULL;
+
+	proto = ip_hdr(oldskb)->protocol;
+
+	if (!skb_csum_unnecessary(oldskb) &&
+	    nf_reject_verify_csum(proto) &&
+	    nf_ip_checksum(oldskb, hook, ip_hdrlen(oldskb), proto))
+		return NULL;
+
+	nskb = alloc_skb(sizeof(struct iphdr) + sizeof(struct icmphdr) +
+			 LL_MAX_HEADER + len, GFP_ATOMIC);
+	if (!nskb)
+		return NULL;
+
+	nskb->dev = (struct net_device *)dev;
+
+	skb_reserve(nskb, LL_MAX_HEADER);
+	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_ICMP,
+				   net->ipv4.sysctl_ip_default_ttl);
+
+	skb_reset_transport_header(nskb);
+	icmph = skb_put_zero(nskb, sizeof(struct icmphdr));
+	icmph->type     = ICMP_DEST_UNREACH;
+	icmph->code	= code;
+
+	skb_put_data(nskb, skb_network_header(oldskb), len);
+
+	csum = csum_partial((void *)icmph, len + sizeof(struct icmphdr), 0);
+	icmph->checksum = csum_fold(csum);
+
+	niph->tot_len	= htons(nskb->len);
+	ip_send_check(niph);
+
+	return nskb;
+}
+EXPORT_SYMBOL_GPL(nf_reject_skb_v4_unreach);
+
 const struct tcphdr *nf_reject_ip_tcphdr_get(struct sk_buff *oldskb,
 					     struct tcphdr *_oth, int hook)
 {
diff --git a/net/ipv6/netfilter/nf_reject_ipv6.c b/net/ipv6/netfilter/nf_reject_ipv6.c
index 4aef6baaa55e..8dcceda6c32a 100644
--- a/net/ipv6/netfilter/nf_reject_ipv6.c
+++ b/net/ipv6/netfilter/nf_reject_ipv6.c
@@ -12,6 +12,140 @@
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter_bridge.h>
 
+static bool nf_reject_v6_csum_ok(struct sk_buff *skb, int hook)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	int thoff;
+	__be16 fo;
+	u8 proto = ip6h->nexthdr;
+
+	if (skb_csum_unnecessary(skb))
+		return true;
+
+	if (ip6h->payload_len &&
+	    pskb_trim_rcsum(skb, ntohs(ip6h->payload_len) + sizeof(*ip6h)))
+		return false;
+
+	ip6h = ipv6_hdr(skb);
+	thoff = ipv6_skip_exthdr(skb, ((u8*)(ip6h+1) - skb->data), &proto, &fo);
+	if (thoff < 0 || thoff >= skb->len || (fo & htons(~0x7)) != 0)
+		return false;
+
+	if (!nf_reject_verify_csum(proto))
+		return true;
+
+	return nf_ip6_checksum(skb, hook, thoff, proto) == 0;
+}
+
+static int nf_reject_ip6hdr_validate(struct sk_buff *skb)
+{
+	struct ipv6hdr *hdr;
+	u32 pkt_len;
+
+	if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
+		return 0;
+
+	hdr = ipv6_hdr(skb);
+	if (hdr->version != 6)
+		return 0;
+
+	pkt_len = ntohs(hdr->payload_len);
+	if (pkt_len + sizeof(struct ipv6hdr) > skb->len)
+		return 0;
+
+	return 1;
+}
+
+struct sk_buff *nf_reject_skb_v6_tcp_reset(struct net *net,
+					   struct sk_buff *oldskb,
+					   const struct net_device *dev,
+					   int hook)
+{
+	struct sk_buff *nskb;
+	const struct tcphdr *oth;
+	struct tcphdr _oth;
+	unsigned int otcplen;
+	struct ipv6hdr *nip6h;
+
+	if (!nf_reject_ip6hdr_validate(oldskb))
+		return NULL;
+
+	oth = nf_reject_ip6_tcphdr_get(oldskb, &_oth, &otcplen, hook);
+	if (!oth)
+		return NULL;
+
+	nskb = alloc_skb(sizeof(struct ipv6hdr) + sizeof(struct tcphdr) +
+			 LL_MAX_HEADER, GFP_ATOMIC);
+	if (!nskb)
+		return NULL;
+
+	nskb->dev = (struct net_device *)dev;
+
+	skb_reserve(nskb, LL_MAX_HEADER);
+	nip6h = nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_TCP,
+				     net->ipv6.devconf_all->hop_limit);
+	nf_reject_ip6_tcphdr_put(nskb, oldskb, oth, otcplen);
+	nip6h->payload_len = htons(nskb->len - sizeof(struct ipv6hdr));
+
+	return nskb;
+}
+EXPORT_SYMBOL_GPL(nf_reject_skb_v6_tcp_reset);
+
+struct sk_buff *nf_reject_skb_v6_unreach(struct net *net,
+					 struct sk_buff *oldskb,
+					 const struct net_device *dev,
+					 int hook, u8 code)
+{
+	struct sk_buff *nskb;
+	struct ipv6hdr *nip6h;
+	struct icmp6hdr *icmp6h;
+	unsigned int len;
+
+	if (!nf_reject_ip6hdr_validate(oldskb))
+		return NULL;
+
+	/* Include "As much of invoking packet as possible without the ICMPv6
+	 * packet exceeding the minimum IPv6 MTU" in the ICMP payload.
+	 */
+	len = min_t(unsigned int, 1220, oldskb->len);
+
+	if (!pskb_may_pull(oldskb, len))
+		return NULL;
+
+	if (!nf_reject_v6_csum_ok(oldskb, hook))
+		return NULL;
+
+	nskb = alloc_skb(sizeof(struct ipv6hdr) + sizeof(struct icmp6hdr) +
+			 LL_MAX_HEADER + len, GFP_ATOMIC);
+	if (!nskb)
+		return NULL;
+
+	nskb->dev = (struct net_device *)dev;
+
+	skb_reserve(nskb, LL_MAX_HEADER);
+	nip6h = nf_reject_ip6hdr_put(nskb, oldskb, IPPROTO_ICMPV6,
+				     net->ipv6.devconf_all->hop_limit);
+
+	skb_reset_transport_header(nskb);
+	icmp6h = skb_put_zero(nskb, sizeof(struct icmp6hdr));
+	icmp6h->icmp6_type = ICMPV6_DEST_UNREACH;
+	icmp6h->icmp6_code = code;
+
+	skb_put_data(nskb, skb_network_header(oldskb), len);
+	nip6h->payload_len = htons(nskb->len - sizeof(struct ipv6hdr));
+
+	icmp6h->icmp6_cksum =
+		csum_ipv6_magic(&nip6h->saddr, &nip6h->daddr,
+				nskb->len - sizeof(struct ipv6hdr),
+				IPPROTO_ICMPV6,
+				csum_partial(icmp6h,
+					     nskb->len - sizeof(struct ipv6hdr),
+					     0));
+
+	return nskb;
+}
+EXPORT_SYMBOL_GPL(nf_reject_skb_v6_unreach);
+
 const struct tcphdr *nf_reject_ip6_tcphdr_get(struct sk_buff *oldskb,
 					      struct tcphdr *otcph,
 					      unsigned int *otcplen, int hook)
-- 
2.20.1

