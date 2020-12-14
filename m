Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C402D9CF2
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 17:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389013AbgLNQsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 11:48:39 -0500
Received: from 108.78.124.78.rev.sfr.net ([78.124.78.108]:38270 "EHLO
        legeek.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbgLNQsY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 11:48:24 -0500
From:   sylvain.bertrand@legeek.net
To:     netdev@vger.kernel.org
Subject: [PATCH][c89] wrong usage of compiler constants
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Mutt-Fcc: =mail
message-id: <xxx666hutenoshurhpmr4kmer7notkhoec@freedom>
Date:   Mon, 14 Dec 2020 16:30:01 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sylvain BERTRAND <sylvain.bertrand@legeek.net>

Using a c89 compiler fails due some wrong usage of compiler constants.
Trivial and harmless fixes.

Signed-off-by: Sylvain BERTRAND <sylvain.bertrand@legeek.net>
---
 work based on mainline 9c87c9f41245baa3fc4716cf39141439cf405b01:
 (will enable an IP/USB-ethernet kernel to be compilable and runnable)
 net/ipv4/af_inet.c
 net/ipv6/af_inet6.c
 net/ipv4/arp.c
 net/core/dev.c
 net/ethernet/eth.c
 include/linux/etherdevice.h
 net/core/filter.c 
 net/core/flow_dissector.c
 include/linux/if_vlan.h
 include/net/inet_ecn.h
 net/ipv6/ip6_offload.c
 include/net/ip_tunnels.h
 net/ipv6/ndisc.c
 include/linux/netdevice.h
 net/sched/sch_dsmark.c
 include/linux/sctp.h
 net/core/skbuff.c
 include/net/vxlan.h

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1890,7 +1890,7 @@
  */
 
 static struct packet_offload ip_packet_offload __read_mostly = {
-	.type = cpu_to_be16(ETH_P_IP),
+	.type = __constant_cpu_to_be16(ETH_P_IP),
 	.callbacks = {
 		.gso_segment = inet_gso_segment,
 		.gro_receive = inet_gro_receive,
@@ -1930,7 +1930,7 @@
 fs_initcall(ipv4_offload_init);
 
 static struct packet_type ip_packet_type __read_mostly = {
-	.type = cpu_to_be16(ETH_P_IP),
+	.type = __constant_cpu_to_be16(ETH_P_IP),
 	.func = ip_rcv,
 	.list_func = ip_list_rcv,
 };
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -861,7 +861,7 @@
 EXPORT_SYMBOL_GPL(ipv6_opt_accepted);
 
 static struct packet_type ipv6_packet_type __read_mostly = {
-	.type = cpu_to_be16(ETH_P_IPV6),
+	.type = __constant_cpu_to_be16(ETH_P_IPV6),
 	.func = ipv6_rcv,
 	.list_func = ipv6_list_rcv,
 };
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -151,7 +151,7 @@
 struct neigh_table arp_tbl = {
 	.family		= AF_INET,
 	.key_len	= 4,
-	.protocol	= cpu_to_be16(ETH_P_IP),
+	.protocol	= __constant_cpu_to_be16(ETH_P_IP),
 	.hash		= arp_hash,
 	.key_eq		= arp_key_eq,
 	.constructor	= arp_constructor,
@@ -1280,7 +1280,7 @@
  */
 
 static struct packet_type arp_packet_type __read_mostly = {
-	.type =	cpu_to_be16(ETH_P_ARP),
+	.type =	__constant_cpu_to_be16(ETH_P_ARP),
 	.func =	arp_rcv,
 };
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5070,11 +5070,11 @@
 static bool skb_pfmemalloc_protocol(struct sk_buff *skb)
 {
 	switch (skb->protocol) {
-	case htons(ETH_P_ARP):
-	case htons(ETH_P_IP):
-	case htons(ETH_P_IPV6):
-	case htons(ETH_P_8021Q):
-	case htons(ETH_P_8021AD):
+	case __constant_htons(ETH_P_ARP):
+	case __constant_htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_8021Q):
+	case __constant_htons(ETH_P_8021AD):
 		return true;
 	default:
 		return false;
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -482,7 +482,7 @@
 EXPORT_SYMBOL(eth_gro_complete);
 
 static struct packet_offload eth_packet_offload __read_mostly = {
-	.type = cpu_to_be16(ETH_P_TEB),
+	.type = __constant_cpu_to_be16(ETH_P_TEB),
 	.priority = 10,
 	.callbacks = {
 		.gro_receive = eth_gro_receive,
--- a/include/linux/etherdevice.h
+++ b/include/linux/etherdevice.h
@@ -77,7 +77,7 @@
 {
 	__be16 *a = (__be16 *)addr;
 	static const __be16 *b = (const __be16 *)eth_reserved_addr_base;
-	static const __be16 m = cpu_to_be16(0xfff0);
+	static const __be16 m = __constant_cpu_to_be16(0xfff0);
 
 #if defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
 	return (((*(const u32 *)addr) ^ (*(const u32 *)b)) |
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3396,9 +3396,9 @@
 static u32 bpf_skb_net_base_len(const struct sk_buff *skb)
 {
 	switch (skb->protocol) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		return sizeof(struct iphdr);
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		return sizeof(struct ipv6hdr);
 	default:
 		return ~0U;
@@ -6401,10 +6401,10 @@
 	unsigned int iphdr_len;
 
 	switch (skb_protocol(skb, true)) {
-	case cpu_to_be16(ETH_P_IP):
+	case __constant_cpu_to_be16(ETH_P_IP):
 		iphdr_len = sizeof(struct iphdr);
 		break;
-	case cpu_to_be16(ETH_P_IPV6):
+	case __constant_cpu_to_be16(ETH_P_IPV6):
 		iphdr_len = sizeof(struct ipv6hdr);
 		break;
 	default:
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1025,7 +1025,7 @@
 	fdret = FLOW_DISSECT_RET_CONTINUE;
 
 	switch (proto) {
-	case htons(ETH_P_IP): {
+	case __constant_htons(ETH_P_IP): {
 		const struct iphdr *iph;
 		struct iphdr _iph;
 
@@ -1071,7 +1071,7 @@
 
 		break;
 	}
-	case htons(ETH_P_IPV6): {
+	case __constant_htons(ETH_P_IPV6): {
 		const struct ipv6hdr *iph;
 		struct ipv6hdr _iph;
 
@@ -1119,8 +1119,8 @@
 
 		break;
 	}
-	case htons(ETH_P_8021AD):
-	case htons(ETH_P_8021Q): {
+	case __constant_htons(ETH_P_8021AD):
+	case __constant_htons(ETH_P_8021Q): {
 		const struct vlan_hdr *vlan = NULL;
 		struct vlan_hdr _vlan;
 		__be16 saved_vlan_tpid = proto;
@@ -1170,7 +1170,7 @@
 		fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
 		break;
 	}
-	case htons(ETH_P_PPP_SES): {
+	case __constant_htons(ETH_P_PPP_SES): {
 		struct {
 			struct pppoe_hdr hdr;
 			__be16 proto;
@@ -1184,11 +1184,11 @@
 		proto = hdr->proto;
 		nhoff += PPPOE_SES_HLEN;
 		switch (proto) {
-		case htons(PPP_IP):
+		case __constant_htons(PPP_IP):
 			proto = htons(ETH_P_IP);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
 			break;
-		case htons(PPP_IPV6):
+		case __constant_htons(PPP_IPV6):
 			proto = htons(ETH_P_IPV6);
 			fdret = FLOW_DISSECT_RET_PROTO_AGAIN;
 			break;
@@ -1198,7 +1198,7 @@
 		}
 		break;
 	}
-	case htons(ETH_P_TIPC): {
+	case __constant_htons(ETH_P_TIPC): {
 		struct tipc_basic_hdr *hdr, _hdr;
 
 		hdr = __skb_header_pointer(skb, nhoff, sizeof(_hdr),
@@ -1220,8 +1220,8 @@
 		break;
 	}
 
-	case htons(ETH_P_MPLS_UC):
-	case htons(ETH_P_MPLS_MC):
+	case __constant_htons(ETH_P_MPLS_UC):
+	case __constant_htons(ETH_P_MPLS_MC):
 		fdret = __skb_flow_dissect_mpls(skb, flow_dissector,
 						target_container, data,
 						nhoff, hlen, mpls_lse,
@@ -1229,7 +1229,7 @@
 		nhoff += sizeof(struct mpls_label);
 		mpls_lse++;
 		break;
-	case htons(ETH_P_FCOE):
+	case __constant_htons(ETH_P_FCOE):
 		if ((hlen - nhoff) < FCOE_HEADER_LEN) {
 			fdret = FLOW_DISSECT_RET_OUT_BAD;
 			break;
@@ -1239,14 +1239,14 @@
 		fdret = FLOW_DISSECT_RET_OUT_GOOD;
 		break;
 
-	case htons(ETH_P_ARP):
-	case htons(ETH_P_RARP):
+	case __constant_htons(ETH_P_ARP):
+	case __constant_htons(ETH_P_RARP):
 		fdret = __skb_flow_dissect_arp(skb, flow_dissector,
 					       target_container, data,
 					       nhoff, hlen);
 		break;
 
-	case htons(ETH_P_BATMAN):
+	case __constant_htons(ETH_P_BATMAN):
 		fdret = __skb_flow_dissect_batadv(skb, key_control, data,
 						  &proto, &nhoff, hlen, flags);
 		break;
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -302,8 +302,8 @@
 static inline bool eth_type_vlan(__be16 ethertype)
 {
 	switch (ethertype) {
-	case htons(ETH_P_8021Q):
-	case htons(ETH_P_8021AD):
+	case __constant_htons(ETH_P_8021Q):
+	case __constant_htons(ETH_P_8021AD):
 		return true;
 	default:
 		return false;
--- a/include/net/inet_ecn.h
+++ b/include/net/inet_ecn.h
@@ -174,13 +174,13 @@
 static inline int INET_ECN_set_ce(struct sk_buff *skb)
 {
 	switch (skb_protocol(skb, true)) {
-	case cpu_to_be16(ETH_P_IP):
+	case __constant_cpu_to_be16(ETH_P_IP):
 		if (skb_network_header(skb) + sizeof(struct iphdr) <=
 		    skb_tail_pointer(skb))
 			return IP_ECN_set_ce(ip_hdr(skb));
 		break;
 
-	case cpu_to_be16(ETH_P_IPV6):
+	case __constant_cpu_to_be16(ETH_P_IPV6):
 		if (skb_network_header(skb) + sizeof(struct ipv6hdr) <=
 		    skb_tail_pointer(skb))
 			return IP6_ECN_set_ce(skb, ipv6_hdr(skb));
@@ -193,13 +193,13 @@
 static inline int INET_ECN_set_ect1(struct sk_buff *skb)
 {
 	switch (skb_protocol(skb, true)) {
-	case cpu_to_be16(ETH_P_IP):
+	case __constant_cpu_to_be16(ETH_P_IP):
 		if (skb_network_header(skb) + sizeof(struct iphdr) <=
 		    skb_tail_pointer(skb))
 			return IP_ECN_set_ect1(ip_hdr(skb));
 		break;
 
-	case cpu_to_be16(ETH_P_IPV6):
+	case __constant_cpu_to_be16(ETH_P_IPV6):
 		if (skb_network_header(skb) + sizeof(struct ipv6hdr) <=
 		    skb_tail_pointer(skb))
 			return IP6_ECN_set_ect1(skb, ipv6_hdr(skb));
@@ -274,10 +274,10 @@
 	__u8 inner;
 
 	switch (skb_protocol(skb, true)) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		inner = ip_hdr(skb)->tos;
 		break;
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		inner = ipv6_get_dsfield(ipv6_hdr(skb));
 		break;
 	default:
@@ -293,10 +293,10 @@
 	__u8 inner;
 
 	switch (skb_protocol(skb, true)) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		inner = ip_hdr(skb)->tos;
 		break;
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		inner = ipv6_get_dsfield(ipv6_hdr(skb));
 		break;
 	default:
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -141,7 +141,7 @@
 			fptr = (struct frag_hdr *)((u8 *)ipv6h + err);
 			fptr->frag_off = htons(offset);
 			if (skb->next)
-				fptr->frag_off |= htons(IP6_MF);
+				fptr->frag_off |= __constant_htons(IP6_MF);
 			offset += (ntohs(ipv6h->payload_len) -
 				   sizeof(struct frag_hdr));
 		}
@@ -324,7 +324,7 @@
 	int err = -ENOSYS;
 
 	if (skb->encapsulation) {
-		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
+		skb_set_inner_protocol(skb, __constant_cpu_to_be16(ETH_P_IPV6));
 		skb_set_inner_network_header(skb, nhoff);
 	}
 
@@ -367,7 +367,7 @@
 }
 
 static struct packet_offload ipv6_packet_offload __read_mostly = {
-	.type = cpu_to_be16(ETH_P_IPV6),
+	.type = __constant_cpu_to_be16(ETH_P_IPV6),
 	.callbacks = {
 		.gso_segment = ipv6_gso_segment,
 		.gro_receive = ipv6_gro_receive,
--- a/include/net/ip_tunnels.h
+++ b/include/net/ip_tunnels.h
@@ -319,11 +319,11 @@
 
 	switch (skb->protocol) {
 #if IS_ENABLED(CONFIG_IPV6)
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		nhlen = sizeof(struct ipv6hdr);
 		break;
 #endif
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		nhlen = sizeof(struct iphdr);
 		break;
 	default:
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -108,7 +108,7 @@
 struct neigh_table nd_tbl = {
 	.family =	AF_INET6,
 	.key_len =	sizeof(struct in6_addr),
-	.protocol =	cpu_to_be16(ETH_P_IPV6),
+	.protocol =	__constant_cpu_to_be16(ETH_P_IPV6),
 	.hash =		ndisc_hash,
 	.key_eq =	ndisc_key_eq,
 	.constructor =	ndisc_constructor,
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4683,9 +4683,9 @@
 	}
 
 	switch (protocol) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		return !!(features & NETIF_F_IP_CSUM);
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		return !!(features & NETIF_F_IPV6_CSUM);
 	default:
 		return false;
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -211,7 +211,7 @@
 		int wlen = skb_network_offset(skb);
 
 		switch (skb_protocol(skb, true)) {
-		case htons(ETH_P_IP):
+		case __constant_htons(ETH_P_IP):
 			wlen += sizeof(struct iphdr);
 			if (!pskb_may_pull(skb, wlen) ||
 			    skb_try_make_writable(skb, wlen))
@@ -221,7 +221,7 @@
 				& ~INET_ECN_MASK;
 			break;
 
-		case htons(ETH_P_IPV6):
+		case __constant_htons(ETH_P_IPV6):
 			wlen += sizeof(struct ipv6hdr);
 			if (!pskb_may_pull(skb, wlen) ||
 			    skb_try_make_writable(skb, wlen))
@@ -304,11 +304,11 @@
 	pr_debug("index %d->%d\n", skb->tc_index, index);
 
 	switch (skb_protocol(skb, true)) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		ipv4_change_dsfield(ip_hdr(skb), p->mv[index].mask,
 				    p->mv[index].value);
 			break;
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		ipv6_change_dsfield(ipv6_hdr(skb), p->mv[index].mask,
 				    p->mv[index].value);
 			break;
--- a/include/linux/sctp.h
+++ b/include/linux/sctp.h
@@ -159,43 +159,43 @@
 enum sctp_param {
 
 	/* RFC 2960 Section 3.3.5 */
-	SCTP_PARAM_HEARTBEAT_INFO		= cpu_to_be16(1),
+	SCTP_PARAM_HEARTBEAT_INFO		= __constant_cpu_to_be16(1),
 	/* RFC 2960 Section 3.3.2.1 */
-	SCTP_PARAM_IPV4_ADDRESS			= cpu_to_be16(5),
-	SCTP_PARAM_IPV6_ADDRESS			= cpu_to_be16(6),
-	SCTP_PARAM_STATE_COOKIE			= cpu_to_be16(7),
-	SCTP_PARAM_UNRECOGNIZED_PARAMETERS	= cpu_to_be16(8),
-	SCTP_PARAM_COOKIE_PRESERVATIVE		= cpu_to_be16(9),
-	SCTP_PARAM_HOST_NAME_ADDRESS		= cpu_to_be16(11),
-	SCTP_PARAM_SUPPORTED_ADDRESS_TYPES	= cpu_to_be16(12),
-	SCTP_PARAM_ECN_CAPABLE			= cpu_to_be16(0x8000),
+	SCTP_PARAM_IPV4_ADDRESS			= __constant_cpu_to_be16(5),
+	SCTP_PARAM_IPV6_ADDRESS			= __constant_cpu_to_be16(6),
+	SCTP_PARAM_STATE_COOKIE			= __constant_cpu_to_be16(7),
+	SCTP_PARAM_UNRECOGNIZED_PARAMETERS	= __constant_cpu_to_be16(8),
+	SCTP_PARAM_COOKIE_PRESERVATIVE		= __constant_cpu_to_be16(9),
+	SCTP_PARAM_HOST_NAME_ADDRESS		= __constant_cpu_to_be16(11),
+	SCTP_PARAM_SUPPORTED_ADDRESS_TYPES	= __constant_cpu_to_be16(12),
+	SCTP_PARAM_ECN_CAPABLE			= __constant_cpu_to_be16(0x8000),
 
 	/* AUTH Extension Section 3 */
-	SCTP_PARAM_RANDOM			= cpu_to_be16(0x8002),
-	SCTP_PARAM_CHUNKS			= cpu_to_be16(0x8003),
-	SCTP_PARAM_HMAC_ALGO			= cpu_to_be16(0x8004),
+	SCTP_PARAM_RANDOM			= __constant_cpu_to_be16(0x8002),
+	SCTP_PARAM_CHUNKS			= __constant_cpu_to_be16(0x8003),
+	SCTP_PARAM_HMAC_ALGO			= __constant_cpu_to_be16(0x8004),
 
 	/* Add-IP: Supported Extensions, Section 4.2 */
-	SCTP_PARAM_SUPPORTED_EXT	= cpu_to_be16(0x8008),
+	SCTP_PARAM_SUPPORTED_EXT	= __constant_cpu_to_be16(0x8008),
 
 	/* PR-SCTP Sec 3.1 */
-	SCTP_PARAM_FWD_TSN_SUPPORT	= cpu_to_be16(0xc000),
+	SCTP_PARAM_FWD_TSN_SUPPORT	= __constant_cpu_to_be16(0xc000),
 
 	/* Add-IP Extension. Section 3.2 */
-	SCTP_PARAM_ADD_IP		= cpu_to_be16(0xc001),
-	SCTP_PARAM_DEL_IP		= cpu_to_be16(0xc002),
-	SCTP_PARAM_ERR_CAUSE		= cpu_to_be16(0xc003),
-	SCTP_PARAM_SET_PRIMARY		= cpu_to_be16(0xc004),
-	SCTP_PARAM_SUCCESS_REPORT	= cpu_to_be16(0xc005),
-	SCTP_PARAM_ADAPTATION_LAYER_IND = cpu_to_be16(0xc006),
+	SCTP_PARAM_ADD_IP		= __constant_cpu_to_be16(0xc001),
+	SCTP_PARAM_DEL_IP		= __constant_cpu_to_be16(0xc002),
+	SCTP_PARAM_ERR_CAUSE		= __constant_cpu_to_be16(0xc003),
+	SCTP_PARAM_SET_PRIMARY		= __constant_cpu_to_be16(0xc004),
+	SCTP_PARAM_SUCCESS_REPORT	= __constant_cpu_to_be16(0xc005),
+	SCTP_PARAM_ADAPTATION_LAYER_IND = __constant_cpu_to_be16(0xc006),
 
 	/* RE-CONFIG. Section 4 */
-	SCTP_PARAM_RESET_OUT_REQUEST		= cpu_to_be16(0x000d),
-	SCTP_PARAM_RESET_IN_REQUEST		= cpu_to_be16(0x000e),
-	SCTP_PARAM_RESET_TSN_REQUEST		= cpu_to_be16(0x000f),
-	SCTP_PARAM_RESET_RESPONSE		= cpu_to_be16(0x0010),
-	SCTP_PARAM_RESET_ADD_OUT_STREAMS	= cpu_to_be16(0x0011),
-	SCTP_PARAM_RESET_ADD_IN_STREAMS		= cpu_to_be16(0x0012),
+	SCTP_PARAM_RESET_OUT_REQUEST		= __constant_cpu_to_be16(0x000d),
+	SCTP_PARAM_RESET_IN_REQUEST		= __constant_cpu_to_be16(0x000e),
+	SCTP_PARAM_RESET_TSN_REQUEST		= __constant_cpu_to_be16(0x000f),
+	SCTP_PARAM_RESET_RESPONSE		= __constant_cpu_to_be16(0x0010),
+	SCTP_PARAM_RESET_ADD_OUT_STREAMS	= __constant_cpu_to_be16(0x0011),
+	SCTP_PARAM_RESET_ADD_IN_STREAMS		= __constant_cpu_to_be16(0x0012),
 }; /* enum */
 
 
@@ -206,13 +206,13 @@
  *
  */
 enum {
-	SCTP_PARAM_ACTION_DISCARD     = cpu_to_be16(0x0000),
-	SCTP_PARAM_ACTION_DISCARD_ERR = cpu_to_be16(0x4000),
-	SCTP_PARAM_ACTION_SKIP        = cpu_to_be16(0x8000),
-	SCTP_PARAM_ACTION_SKIP_ERR    = cpu_to_be16(0xc000),
+	SCTP_PARAM_ACTION_DISCARD     = __constant_cpu_to_be16(0x0000),
+	SCTP_PARAM_ACTION_DISCARD_ERR = __constant_cpu_to_be16(0x4000),
+	SCTP_PARAM_ACTION_SKIP        = __constant_cpu_to_be16(0x8000),
+	SCTP_PARAM_ACTION_SKIP_ERR    = __constant_cpu_to_be16(0xc000),
 };
 
-enum { SCTP_PARAM_ACTION_MASK = cpu_to_be16(0xc000), };
+enum { SCTP_PARAM_ACTION_MASK = __constant_cpu_to_be16(0xc000), };
 
 /* RFC 2960 Section 3.3.1 Payload Data (DATA) (0) */
 
@@ -465,17 +465,17 @@
  */
 enum sctp_error {
 
-	SCTP_ERROR_NO_ERROR	   = cpu_to_be16(0x00),
-	SCTP_ERROR_INV_STRM	   = cpu_to_be16(0x01),
-	SCTP_ERROR_MISS_PARAM 	   = cpu_to_be16(0x02),
-	SCTP_ERROR_STALE_COOKIE	   = cpu_to_be16(0x03),
-	SCTP_ERROR_NO_RESOURCE 	   = cpu_to_be16(0x04),
-	SCTP_ERROR_DNS_FAILED      = cpu_to_be16(0x05),
-	SCTP_ERROR_UNKNOWN_CHUNK   = cpu_to_be16(0x06),
-	SCTP_ERROR_INV_PARAM       = cpu_to_be16(0x07),
-	SCTP_ERROR_UNKNOWN_PARAM   = cpu_to_be16(0x08),
-	SCTP_ERROR_NO_DATA         = cpu_to_be16(0x09),
-	SCTP_ERROR_COOKIE_IN_SHUTDOWN = cpu_to_be16(0x0a),
+	SCTP_ERROR_NO_ERROR	   = __constant_cpu_to_be16(0x00),
+	SCTP_ERROR_INV_STRM	   = __constant_cpu_to_be16(0x01),
+	SCTP_ERROR_MISS_PARAM 	   = __constant_cpu_to_be16(0x02),
+	SCTP_ERROR_STALE_COOKIE	   = __constant_cpu_to_be16(0x03),
+	SCTP_ERROR_NO_RESOURCE 	   = __constant_cpu_to_be16(0x04),
+	SCTP_ERROR_DNS_FAILED      = __constant_cpu_to_be16(0x05),
+	SCTP_ERROR_UNKNOWN_CHUNK   = __constant_cpu_to_be16(0x06),
+	SCTP_ERROR_INV_PARAM       = __constant_cpu_to_be16(0x07),
+	SCTP_ERROR_UNKNOWN_PARAM   = __constant_cpu_to_be16(0x08),
+	SCTP_ERROR_NO_DATA         = __constant_cpu_to_be16(0x09),
+	SCTP_ERROR_COOKIE_IN_SHUTDOWN = __constant_cpu_to_be16(0x0a),
 
 
 	/* SCTP Implementation Guide:
@@ -484,9 +484,9 @@
 	 *  13  Protocol Violation
 	 */
 
-	SCTP_ERROR_RESTART         = cpu_to_be16(0x0b),
-	SCTP_ERROR_USER_ABORT      = cpu_to_be16(0x0c),
-	SCTP_ERROR_PROTO_VIOLATION = cpu_to_be16(0x0d),
+	SCTP_ERROR_RESTART         = __constant_cpu_to_be16(0x0b),
+	SCTP_ERROR_USER_ABORT      = __constant_cpu_to_be16(0x0c),
+	SCTP_ERROR_PROTO_VIOLATION = __constant_cpu_to_be16(0x0d),
 
 	/* ADDIP Section 3.3  New Error Causes
 	 *
@@ -501,11 +501,11 @@
 	 * 0x00A3          Association Aborted due to illegal ASCONF-ACK
 	 * 0x00A4          Request refused - no authorization.
 	 */
-	SCTP_ERROR_DEL_LAST_IP	= cpu_to_be16(0x00A0),
-	SCTP_ERROR_RSRC_LOW	= cpu_to_be16(0x00A1),
-	SCTP_ERROR_DEL_SRC_IP	= cpu_to_be16(0x00A2),
-	SCTP_ERROR_ASCONF_ACK   = cpu_to_be16(0x00A3),
-	SCTP_ERROR_REQ_REFUSED	= cpu_to_be16(0x00A4),
+	SCTP_ERROR_DEL_LAST_IP	= __constant_cpu_to_be16(0x00A0),
+	SCTP_ERROR_RSRC_LOW	= __constant_cpu_to_be16(0x00A1),
+	SCTP_ERROR_DEL_SRC_IP	= __constant_cpu_to_be16(0x00A2),
+	SCTP_ERROR_ASCONF_ACK   = __constant_cpu_to_be16(0x00A3),
+	SCTP_ERROR_REQ_REFUSED	= __constant_cpu_to_be16(0x00A4),
 
 	/* AUTH Section 4.  New Error Cause
 	 *
@@ -517,7 +517,7 @@
 	 * --------------------------------------------------------------
 	 * 0x0105          Unsupported HMAC Identifier
 	 */
-	 SCTP_ERROR_UNSUP_HMAC	= cpu_to_be16(0x0105)
+	 SCTP_ERROR_UNSUP_HMAC	= __constant_cpu_to_be16(0x0105)
 };
 
 
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4992,11 +4992,11 @@
 	int err;
 
 	switch (skb->protocol) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		err = skb_checksum_setup_ipv4(skb, recalculate);
 		break;
 
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		err = skb_checksum_setup_ipv6(skb, recalculate);
 		break;
 
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -26,11 +26,11 @@
 };
 
 /* VXLAN header flags. */
-#define VXLAN_HF_VNI	cpu_to_be32(BIT(27))
+#define VXLAN_HF_VNI	__constant_cpu_to_be32(BIT(27))
 
 #define VXLAN_N_VID     (1u << 24)
 #define VXLAN_VID_MASK  (VXLAN_N_VID - 1)
-#define VXLAN_VNI_MASK	cpu_to_be32(VXLAN_VID_MASK << 8)
+#define VXLAN_VNI_MASK	__constant_cpu_to_be32(VXLAN_VID_MASK << 8)
 #define VXLAN_HLEN (sizeof(struct udphdr) + sizeof(struct vxlanhdr))
 
 #define VNI_HASH_BITS	10
@@ -57,11 +57,11 @@
  */
 
 /* VXLAN-RCO header flags. */
-#define VXLAN_HF_RCO	cpu_to_be32(BIT(21))
+#define VXLAN_HF_RCO	__constant_cpu_to_be32(BIT(21))
 
 /* Remote checksum offload header option */
-#define VXLAN_RCO_MASK	cpu_to_be32(0x7f)  /* Last byte of vni field */
-#define VXLAN_RCO_UDP	cpu_to_be32(0x80)  /* Indicate UDP RCO (TCP when not set *) */
+#define VXLAN_RCO_MASK	__constant_cpu_to_be32(0x7f)  /* Last byte of vni field */
+#define VXLAN_RCO_UDP	__constant_cpu_to_be32(0x80)  /* Indicate UDP RCO (TCP when not set *) */
 #define VXLAN_RCO_SHIFT	1		   /* Left shift of start */
 #define VXLAN_RCO_SHIFT_MASK ((1 << VXLAN_RCO_SHIFT) - 1)
 #define VXLAN_MAX_REMCSUM_START (0x7f << VXLAN_RCO_SHIFT)
@@ -107,9 +107,9 @@
 };
 
 /* VXLAN-GBP header flags. */
-#define VXLAN_HF_GBP	cpu_to_be32(BIT(31))
+#define VXLAN_HF_GBP	__constant_cpu_to_be32(BIT(31))
 
-#define VXLAN_GBP_USED_BITS (VXLAN_HF_GBP | cpu_to_be32(0xFFFFFF))
+#define VXLAN_GBP_USED_BITS (VXLAN_HF_GBP | __constant_cpu_to_be32(0xFFFFFF))
 
 /* skb->mark mapping
  *
@@ -169,12 +169,12 @@
 };
 
 /* VXLAN-GPE header flags. */
-#define VXLAN_HF_VER	cpu_to_be32(BIT(29) | BIT(28))
-#define VXLAN_HF_NP	cpu_to_be32(BIT(26))
-#define VXLAN_HF_OAM	cpu_to_be32(BIT(24))
+#define VXLAN_HF_VER	__constant_cpu_to_be32(BIT(29) | BIT(28))
+#define VXLAN_HF_NP	__constant_cpu_to_be32(BIT(26))
+#define VXLAN_HF_OAM	__constant_cpu_to_be32(BIT(24))
 
 #define VXLAN_GPE_USED_BITS (VXLAN_HF_VER | VXLAN_HF_NP | VXLAN_HF_OAM | \
-			     cpu_to_be32(0xff))
+			     __constant_cpu_to_be32(0xff))
 
 struct vxlan_metadata {
 	u32		gbp;
@@ -305,10 +305,10 @@
 		return features;
 
 	switch (vlan_get_protocol(skb)) {
-	case htons(ETH_P_IP):
+	case __constant_htons(ETH_P_IP):
 		l4_hdr = ip_hdr(skb)->protocol;
 		break;
-	case htons(ETH_P_IPV6):
+	case __constant_htons(ETH_P_IPV6):
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:

