Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E13BD23B4A6
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 07:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgHDFyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 01:54:21 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55318 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729850AbgHDFyV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 01:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596520458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NB7awHKD6WyuOUGax+6p5JR6V6oYi3y8/4C4KX4xDJU=;
        b=aoEPo7TLfosg8jrCIqeG8YetdFv3FieLNN1YKhW1W8XPnS3ykpYCR4wmfHzsg7BkJP2IIN
        jJlfU954vgZEc8DObVFe+eIkDYL2Qk0O0haWnGJWGjJitbGYM7cetmCPeiEW6ClucwJu35
        6rfF0yZYKDqUlgDjDCKM2I9mu/hqLeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-fCUbWnFRP5G0i_4sWOBD_A-1; Tue, 04 Aug 2020 01:54:16 -0400
X-MC-Unique: fCUbWnFRP5G0i_4sWOBD_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E1948014D7;
        Tue,  4 Aug 2020 05:54:15 +0000 (UTC)
Received: from epycfail.redhat.com (unknown [10.36.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 290901002391;
        Tue,  4 Aug 2020 05:54:11 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 2/6] tunnels: PMTU discovery support for directly bridged IP packets
Date:   Tue,  4 Aug 2020 07:53:43 +0200
Message-Id: <83e5876f589b0071638630dd93fbe0fa6b1b257c.1596520062.git.sbrivio@redhat.com>
In-Reply-To: <cover.1596520062.git.sbrivio@redhat.com>
References: <cover.1596520062.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's currently possible to bridge Ethernet tunnels carrying IP
packets directly to external interfaces without assigning them
addresses and routes on the bridged network itself: this is the case
for UDP tunnels bridged with a standard bridge or by Open vSwitch.

PMTU discovery is currently broken with those configurations, because
the encapsulation effectively decreases the MTU of the link, and
while we are able to account for this using PMTU discovery on the
lower layer, we don't have a way to relay ICMP or ICMPv6 messages
needed by the sender, because we don't have valid routes to it.

On the other hand, as a tunnel endpoint, we can't fragment packets
as a general approach: this is for instance clearly forbidden for
VXLAN by RFC 7348, section 4.3:

   VTEPs MUST NOT fragment VXLAN packets.  Intermediate routers may
   fragment encapsulated VXLAN packets due to the larger frame size.
   The destination VTEP MAY silently discard such VXLAN fragments.

The same paragraph recommends that the MTU over the physical network
accomodates for encapsulations, but this isn't a practical option for
complex topologies, especially for typical Open vSwitch use cases.

Further, it states that:

   Other techniques like Path MTU discovery (see [RFC1191] and
   [RFC1981]) MAY be used to address this requirement as well.

Now, PMTU discovery already works for routed interfaces, we get
route exceptions created by the encapsulation device as they receive
ICMP Fragmentation Needed and ICMPv6 Packet Too Big messages, and
we already rebuild those messages with the appropriate MTU and route
them back to the sender.

Add the missing bits for bridged cases:

- checks in skb_tunnel_check_pmtu() to understand if it's appropriate
  to trigger a reply according to RFC 1122 section 3.2.2 for ICMP and
  RFC 4443 section 2.4 for ICMPv6. This function is already called by
  UDP tunnels

- a new function generating those ICMP or ICMPv6 replies. We can't
  reuse icmp_send() and icmp6_send() as we don't see the sender as a
  valid destination. This doesn't need to be generic, as we don't
  cover any other type of ICMP errors given that we only provide an
  encapsulation function to the sender

While at it, make the MTU check in skb_tunnel_check_pmtu() accurate:
we might receive GSO buffers here, and the passed headroom already
includes the inner MAC length, so we don't have to account for it
a second time (that would imply three MAC headers on the wire, but
there are just two).

This issue became visible while bridging IPv6 packets with 4500 bytes
of payload over GENEVE using IPv4 with a PMTU of 4000. Given the 50
bytes of encapsulation headroom, we would advertise MTU as 3950, and
we would reject fragmented IPv6 datagrams of 3958 bytes size on the
wire. We're exclusively dealing with network MTU here, though, so we
could get Ethernet frames up to 3964 octets in that case.

v2:
- moved skb_tunnel_check_pmtu() to ip_tunnel_core.c (David Ahern)
- split IPv4/IPv6 functions (David Ahern)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 drivers/net/bareudp.c     |   5 +-
 drivers/net/geneve.c      |   5 +-
 drivers/net/vxlan.c       |   4 +-
 include/net/dst.h         |  10 --
 include/net/ip_tunnels.h  |   2 +
 net/ipv4/ip_tunnel_core.c | 244 ++++++++++++++++++++++++++++++++++++++
 6 files changed, 254 insertions(+), 16 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 3b6664c7e73c..841910f1db65 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -308,7 +308,7 @@ static int bareudp_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return PTR_ERR(rt);
 
 	skb_tunnel_check_pmtu(skb, &rt->dst,
-			      BAREUDP_IPV4_HLEN + info->options_len);
+			      BAREUDP_IPV4_HLEN + info->options_len, false);
 
 	sport = udp_flow_src_port(bareudp->net, skb,
 				  bareudp->sport_min, USHRT_MAX,
@@ -369,7 +369,8 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
-	skb_tunnel_check_pmtu(skb, dst, BAREUDP_IPV6_HLEN + info->options_len);
+	skb_tunnel_check_pmtu(skb, dst, BAREUDP_IPV6_HLEN + info->options_len,
+			      false);
 
 	sport = udp_flow_src_port(bareudp->net, skb,
 				  bareudp->sport_min, USHRT_MAX,
diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index 017c13acc911..de86b6d82132 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -894,7 +894,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 		return PTR_ERR(rt);
 
 	skb_tunnel_check_pmtu(skb, &rt->dst,
-			      GENEVE_IPV4_HLEN + info->options_len);
+			      GENEVE_IPV4_HLEN + info->options_len, false);
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->cfg.collect_md) {
@@ -955,7 +955,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
 	if (IS_ERR(dst))
 		return PTR_ERR(dst);
 
-	skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_len);
+	skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_len,
+			      false);
 
 	sport = udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true);
 	if (geneve->cfg.collect_md) {
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 77658425db8a..1432544da507 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -2720,7 +2720,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		ndst = &rt->dst;
-		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
+		skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM, false);
 
 		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip4_dst_hoplimit(&rt->dst);
@@ -2760,7 +2760,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				goto out_unlock;
 		}
 
-		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
+		skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM, false);
 
 		tos = ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
 		ttl = ttl ? : ip6_dst_hoplimit(ndst);
diff --git a/include/net/dst.h b/include/net/dst.h
index 852d8fb36ab7..6ae2e625050d 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -535,14 +535,4 @@ static inline void skb_dst_update_pmtu_no_confirm(struct sk_buff *skb, u32 mtu)
 		dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
 }
 
-static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
-					 struct dst_entry *encap_dst,
-					 int headroom)
-{
-	u32 encap_mtu = dst_mtu(encap_dst);
-
-	if (skb->len > encap_mtu - headroom)
-		skb_dst_update_pmtu_no_confirm(skb, encap_mtu - headroom);
-}
-
 #endif /* _NET_DST_H */
diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
index 36025dea7612..02ccd32542d0 100644
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -420,6 +420,8 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt, struct sk_buff *skb,
 		   u8 tos, u8 ttl, __be16 df, bool xnet);
 struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
 					     gfp_t flags);
+int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
+			  int headroom, bool reply);
 
 int iptunnel_handle_offloads(struct sk_buff *skb, int gso_type_mask);
 
diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
index f8b419e2475c..9ddee2a0c66d 100644
--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -184,6 +184,250 @@ int iptunnel_handle_offloads(struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(iptunnel_handle_offloads);
 
+/**
+ * iptunnel_pmtud_build_icmp() - Build ICMP error message for PMTUD
+ * @skb:	Original packet with L2 header
+ * @mtu:	MTU value for ICMP error
+ *
+ * Return: length on success, negative error code if message couldn't be built.
+ */
+static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
+{
+	const struct iphdr *iph = ip_hdr(skb);
+	struct icmphdr *icmph;
+	struct iphdr *niph;
+	struct ethhdr eh;
+	int len, err;
+
+	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr)))
+		return -EINVAL;
+
+	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
+	pskb_pull(skb, ETH_HLEN);
+	skb_reset_network_header(skb);
+
+	err = pskb_trim(skb, 576 - sizeof(*niph) - sizeof(*icmph));
+	if (err)
+		return err;
+
+	len = skb->len + sizeof(*icmph);
+	err = skb_cow(skb, sizeof(*niph) + sizeof(*icmph) + ETH_HLEN);
+	if (err)
+		return err;
+
+	icmph = skb_push(skb, sizeof(*icmph));
+	*icmph = (struct icmphdr) {
+		.type			= ICMP_DEST_UNREACH,
+		.code			= ICMP_FRAG_NEEDED,
+		.checksum		= 0,
+		.un.frag.__unused	= 0,
+		.un.frag.mtu		= ntohs(mtu),
+	};
+	icmph->checksum = ip_compute_csum(icmph, len);
+	skb_reset_transport_header(skb);
+
+	niph = skb_push(skb, sizeof(*niph));
+	*niph = (struct iphdr) {
+		.ihl			= sizeof(*niph) / 4u,
+		.version 		= 4,
+		.tos 			= 0,
+		.tot_len		= htons(len + sizeof(*niph)),
+		.id			= 0,
+		.frag_off		= htons(IP_DF),
+		.ttl			= iph->ttl,
+		.protocol		= IPPROTO_ICMP,
+		.saddr			= iph->daddr,
+		.daddr			= iph->saddr,
+	};
+	ip_send_check(niph);
+	skb_reset_network_header(skb);
+
+	skb->ip_summed = CHECKSUM_NONE;
+
+	eth_header(skb, skb->dev, htons(eh.h_proto), eh.h_source, eh.h_dest, 0);
+	skb_reset_mac_header(skb);
+
+	return skb->len;
+}
+
+/**
+ * iptunnel_pmtud_check_icmp() - Trigger ICMP reply if needed and allowed
+ * @skb:	Buffer being sent by encapsulation, L2 headers expected
+ * @mtu:	Network MTU for path
+ *
+ * Return: 0 for no ICMP reply, length if built, negative value on error.
+ */
+static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
+{
+	const struct icmphdr *icmph = icmp_hdr(skb);
+	const struct iphdr *iph = ip_hdr(skb);
+
+	if (mtu <= 576 || iph->frag_off != htons(IP_DF))
+		return 0;
+
+	if (ipv4_is_lbcast(iph->daddr)  || ipv4_is_multicast(iph->daddr) ||
+	    ipv4_is_zeronet(iph->saddr) || ipv4_is_loopback(iph->saddr)  ||
+	    ipv4_is_lbcast(iph->saddr)  || ipv4_is_multicast(iph->saddr))
+		return 0;
+
+	if (iph->protocol == IPPROTO_ICMP && icmp_is_err(icmph->type))
+		return 0;
+
+	return iptunnel_pmtud_build_icmp(skb, mtu);
+}
+
+#if IS_ENABLED(CONFIG_IPV6)
+/**
+ * iptunnel_pmtud_build_icmpv6() - Build ICMPv6 error message for PMTUD
+ * @skb:	Original packet with L2 header
+ * @mtu:	MTU value for ICMPv6 error
+ *
+ * Return: length on success, negative error code if message couldn't be built.
+ */
+static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	struct icmp6hdr *icmp6h;
+	struct ipv6hdr *nip6h;
+	struct ethhdr eh;
+	int len, err;
+	__wsum csum;
+
+	if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr)))
+		return -EINVAL;
+
+	skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
+	pskb_pull(skb, ETH_HLEN);
+	skb_reset_network_header(skb);
+
+	err = pskb_trim(skb, IPV6_MIN_MTU - sizeof(*nip6h) - sizeof(*icmp6h));
+	if (err)
+		return err;
+
+	len = skb->len + sizeof(*icmp6h);
+	err = skb_cow(skb, sizeof(*nip6h) + sizeof(*icmp6h) + ETH_HLEN);
+	if (err)
+		return err;
+
+	icmp6h = skb_push(skb, sizeof(*icmp6h));
+	*icmp6h = (struct icmp6hdr) {
+		.icmp6_type		= ICMPV6_PKT_TOOBIG,
+		.icmp6_code		= 0,
+		.icmp6_cksum		= 0,
+		.icmp6_mtu		= htonl(mtu),
+	};
+	skb_reset_transport_header(skb);
+
+	nip6h = skb_push(skb, sizeof(*nip6h));
+	*nip6h = (struct ipv6hdr) {
+		.priority		= 0,
+		.version		= 6,
+		.flow_lbl		= { 0 },
+		.payload_len		= htons(len),
+		.nexthdr		= IPPROTO_ICMPV6,
+		.hop_limit		= ip6h->hop_limit,
+		.saddr			= ip6h->daddr,
+		.daddr			= ip6h->saddr,
+	};
+	skb_reset_network_header(skb);
+
+	csum = csum_partial(icmp6h, len, 0);
+	icmp6h->icmp6_cksum = csum_ipv6_magic(&nip6h->saddr, &nip6h->daddr, len,
+					      IPPROTO_ICMPV6, csum);
+
+	skb->ip_summed = CHECKSUM_NONE;
+
+	eth_header(skb, skb->dev, htons(eh.h_proto), eh.h_source, eh.h_dest, 0);
+	skb_reset_mac_header(skb);
+
+	return skb->len;
+}
+
+/**
+ * iptunnel_pmtud_check_icmpv6() - Trigger ICMPv6 reply if needed and allowed
+ * @skb:	Buffer being sent by encapsulation, L2 headers expected
+ * @mtu:	Network MTU for path
+ *
+ * Return: 0 for no ICMPv6 reply, length if built, negative value on error.
+ */
+static int iptunnel_pmtud_check_icmpv6(struct sk_buff *skb, int mtu)
+{
+	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
+	int stype = ipv6_addr_type(&ip6h->saddr);
+	u8 proto = ip6h->nexthdr;
+	__be16 frag_off;
+	int offset;
+
+	if (mtu <= IPV6_MIN_MTU)
+		return 0;
+
+	if (stype == IPV6_ADDR_ANY || stype == IPV6_ADDR_MULTICAST ||
+	    stype == IPV6_ADDR_LOOPBACK)
+		return 0;
+
+	offset = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &proto,
+				  &frag_off);
+	if (offset < 0 || (frag_off & htons(~0x7)))
+		return 0;
+
+	if (proto == IPPROTO_ICMPV6) {
+		struct icmp6hdr *icmp6h;
+
+		if (!pskb_may_pull(skb, skb_network_header(skb) +
+					offset + 1 - skb->data))
+			return 0;
+
+		icmp6h = (struct icmp6hdr *)(skb_network_header(skb) + offset);
+		if (icmpv6_is_err(icmp6h->icmp6_type) ||
+		    icmp6h->icmp6_type == NDISC_REDIRECT)
+			return 0;
+	}
+
+	return iptunnel_pmtud_build_icmpv6(skb, mtu);
+}
+#endif /* IS_ENABLED(CONFIG_IPV6) */
+
+/**
+ * skb_tunnel_check_pmtu() - Check, update PMTU and trigger ICMP reply as needed
+ * @skb:	Buffer being sent by encapsulation, L2 headers expected
+ * @encap_dst:	Destination for tunnel encapsulation (outer IP)
+ * @headroom:	Encapsulation header size, bytes
+ * @reply:	Build matching ICMP or ICMPv6 message as a result
+ *
+ * L2 tunnel implementations that can carry IP and can be directly bridged
+ * (currently UDP tunnels) can't always rely on IP forwarding paths to handle
+ * PMTU discovery. In the bridged case, ICMP or ICMPv6 messages need to be built
+ * based on payload and sent back by the encapsulation itself.
+ *
+ * For routable interfaces, we just need to update the PMTU for the destination.
+ *
+ * Return: 0 if ICMP error not needed, length if built, negative value on error
+ */
+int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_dst,
+			  int headroom, bool reply)
+{
+	u32 mtu = dst_mtu(encap_dst) - headroom;
+
+	if ((skb_is_gso(skb) && skb_gso_validate_network_len(skb, mtu)) ||
+	    (!skb_is_gso(skb) && (skb->len - skb_mac_header_len(skb)) <= mtu))
+		return 0;
+
+	skb_dst_update_pmtu_no_confirm(skb, mtu);
+
+	if (!reply || skb->pkt_type == PACKET_HOST)
+		return 0;
+
+	if (skb->protocol == htons(ETH_P_IP))
+		return iptunnel_pmtud_check_icmp(skb, mtu);
+
+#if IS_ENABLED(CONFIG_IPV6)
+	if (skb->protocol == htons(ETH_P_IPV6))
+		return iptunnel_pmtud_check_icmpv6(skb, mtu);
+#endif
+	return 0;
+}
+EXPORT_SYMBOL(skb_tunnel_check_pmtu);
+
 /* Often modified stats are per cpu, other are shared (netdev->stats) */
 void ip_tunnel_get_stats64(struct net_device *dev,
 			   struct rtnl_link_stats64 *tot)
-- 
2.27.0

