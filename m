Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D20F3A72D0
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhFOAOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:14:31 -0400
Received: from mail-qk1-f170.google.com ([209.85.222.170]:38487 "EHLO
        mail-qk1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbhFOAO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:14:27 -0400
Received: by mail-qk1-f170.google.com with SMTP id c138so27438898qkg.5
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tc11Y8AN/8ptR9qdRKlFM1yspR9TTsgipn5GdavdNvE=;
        b=aw3oq8U6pLFO90BEIVUoL5ohfN3nQW+o72hOIR9ndzCZ58rn7o/vCPfJEOqufykXwm
         SYXHz3z2gFKs5wzJY8DejAp0BjvxntV24YRDo0hc8+UL0RfDpZWdPiu03+xun6JvpVtK
         TpeEnLy9o2IaodqQgo3NHIbQKrGaqEUGQPOwpXR17y2TcYwpTTJ0NKM0JjO44TG50+6K
         Avm8VGU8vPLarJv/qLc9dRf2Ff7Bzx5Rcck+U3Rw4mH4duQ03+yO4HLMnG3DP//b+yW1
         gE/vEzrvdXE8J65g3HBkjR/MGFLkgYdtRglo6fDxT17IccDlls6KihZ2Hl3aLlfWCnsT
         qdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tc11Y8AN/8ptR9qdRKlFM1yspR9TTsgipn5GdavdNvE=;
        b=fRHwk/ZMoykyQVS0e0Xnj1Ea1xTM2AIxu90b9xA3tx32e8713VJ1pEnCnEf4tBgxPY
         3UCxxeIMJwoIgWt4/1b7hlAyUzhX5qqhj/09Y1PYKDJL/XEm4ey2F6v5HuIhoJe58sqo
         PzoIL3t1oOIL09A6J52HpEMW2fUFLD8BpShQ76zjAdjzE4WriJtfdWtjJbs79K3AF61I
         xIX1RoPQMCOUOWwxV/RhlZ//WCC/B9rbaY0DhAekYBtV29dXQjkCZE0ECMPuizJjXYaS
         l9wcEID6x5w6EzaFep3O75OKnv4E+oBOwXmv6cjO+zj7zU1KYPrerWJ4vNnMaXsopOLD
         ePcQ==
X-Gm-Message-State: AOAM532vl18h9V8pGaG9oOXeoMVEDF24pZKGXITEBFs6KcMFVUf/iXZn
        uaucQIn4G7EoLHtB1P5Ix0r0dTUsXXE=
X-Google-Smtp-Source: ABdhPJzPKnjTF2cr8YT1GZLLGBI4zRgIlB7Vf7GKZJe0ceeeHkgTGWlnVp6I8mwL7VSm0yOnbHXY3Q==
X-Received: by 2002:ae9:e601:: with SMTP id z1mr19380876qkf.369.1623715868544;
        Mon, 14 Jun 2021 17:11:08 -0700 (PDT)
Received: from tannerlove.nyc.corp.google.com ([2620:0:1003:1000:592b:4d3c:3a31:b1fe])
        by smtp.gmail.com with ESMTPSA id e1sm11153087qti.27.2021.06.14.17.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:11:08 -0700 (PDT)
From:   Tanner Love <tannerlove.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Tanner Love <tannerlove@google.com>
Subject: [PATCH net-next v6 3/3] selftests/net: amend bpf flow dissector prog to do vnet hdr validation
Date:   Mon, 14 Jun 2021 20:11:00 -0400
Message-Id: <20210615001100.1008325-4-tannerlove.kernel@gmail.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
In-Reply-To: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
References: <20210615001100.1008325-1-tannerlove.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tanner Love <tannerlove@google.com>

Change the BPF flow dissector program to perform various checks on the
virtio_net_hdr fields after doing flow dissection.

Amend test_flow_dissector.(c|sh) to add test cases that inject packets
with reasonable or unreasonable virtio-net headers and assert that bad
packets are dropped and good packets are not. Do this via packet
socket; the kernel executes tpacket_snd, which enters
virtio_net_hdr_to_skb, where flow dissection / vnet header validation
occurs.

Changes
v4:
  - Read virtio_net_hdr pointer from struct bpf_flow_keys
  - Add vnet header endianness logic to BPF program

Signed-off-by: Tanner Love <tannerlove@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/bpf/progs/bpf_flow.c  | 209 ++++++++++++++----
 .../selftests/bpf/test_flow_dissector.c       | 181 +++++++++++++--
 .../selftests/bpf/test_flow_dissector.sh      |  19 ++
 3 files changed, 342 insertions(+), 67 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 95a5a0778ed7..a846ff7e6331 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -13,6 +13,7 @@
 #include <linux/tcp.h>
 #include <linux/udp.h>
 #include <linux/if_packet.h>
+#include <linux/virtio_net.h>
 #include <sys/socket.h>
 #include <linux/if_tunnel.h>
 #include <linux/mpls.h>
@@ -71,15 +72,140 @@ struct {
 	__type(value, struct bpf_flow_keys);
 } last_dissection SEC(".maps");
 
-static __always_inline int export_flow_keys(struct bpf_flow_keys *keys,
-					    int ret)
+static __always_inline __u16 __virtio16_to_cpu(bool little_endian,
+					       __virtio16 val)
 {
+	if (little_endian)
+		return __le16_to_cpu((__le16)val);
+	else
+		return __be16_to_cpu((__be16)val);
+}
+
+/* Drops invalid virtio-net headers */
+static __always_inline int validate_vnet_hdr(const struct bpf_flow_keys *keys,
+					     __u32 skb_len)
+{
+	__u16 gso_type, hdr_len, gso_size, csum_start, csum_offset;
+	const struct virtio_net_hdr *vhdr = keys->vhdr;
+
+	if (!vhdr)
+		return BPF_OK;
+
+	gso_type = __virtio16_to_cpu(keys->vhdr_is_little_endian,
+				     vhdr->gso_type);
+	hdr_len = __virtio16_to_cpu(keys->vhdr_is_little_endian,
+				    vhdr->hdr_len);
+	gso_size = __virtio16_to_cpu(keys->vhdr_is_little_endian,
+				     vhdr->gso_size);
+	csum_start = __virtio16_to_cpu(keys->vhdr_is_little_endian,
+				       vhdr->csum_start);
+	csum_offset = __virtio16_to_cpu(keys->vhdr_is_little_endian,
+					vhdr->csum_offset);
+
+	/* Check gso */
+	if (gso_type != VIRTIO_NET_HDR_GSO_NONE) {
+		if (!(vhdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM))
+			return BPF_DROP;
+
+		if (keys->is_encap)
+			return BPF_DROP;
+
+		switch (gso_type & ~VIRTIO_NET_HDR_GSO_ECN) {
+		case VIRTIO_NET_HDR_GSO_TCPV4:
+			if (keys->addr_proto != ETH_P_IP ||
+			    keys->ip_proto != IPPROTO_TCP)
+				return BPF_DROP;
+
+			if (gso_size >= skb_len - keys->thoff -
+					sizeof(struct tcphdr))
+				return BPF_DROP;
+
+			break;
+		case VIRTIO_NET_HDR_GSO_TCPV6:
+			if (keys->addr_proto != ETH_P_IPV6 ||
+			    keys->ip_proto != IPPROTO_TCP)
+				return BPF_DROP;
+
+			if (gso_size >= skb_len - keys->thoff -
+					sizeof(struct tcphdr))
+				return BPF_DROP;
+
+			break;
+		case VIRTIO_NET_HDR_GSO_UDP:
+			if (keys->ip_proto != IPPROTO_UDP)
+				return BPF_DROP;
+
+			if (gso_size >= skb_len - keys->thoff -
+					sizeof(struct udphdr))
+				return BPF_DROP;
+
+			break;
+		default:
+			return BPF_DROP;
+		}
+	}
+
+	/* Check hdr_len */
+	if (hdr_len) {
+		switch (keys->ip_proto) {
+		case IPPROTO_TCP:
+			if (hdr_len != keys->thoff + sizeof(struct tcphdr))
+				return BPF_DROP;
+
+			break;
+		case IPPROTO_UDP:
+			if (hdr_len != keys->thoff + sizeof(struct udphdr))
+				return BPF_DROP;
+
+			break;
+		}
+	}
+
+	/* Check csum */
+	if (vhdr->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) {
+		if (keys->addr_proto != ETH_P_IP &&
+		    keys->addr_proto != ETH_P_IPV6)
+			return BPF_DROP;
+
+		if (csum_start != keys->thoff)
+			return BPF_DROP;
+
+		switch (keys->ip_proto) {
+		case IPPROTO_TCP:
+			if (csum_offset != offsetof(struct tcphdr, check))
+				return BPF_DROP;
+
+			break;
+		case IPPROTO_UDP:
+			if (csum_offset != offsetof(struct udphdr, check))
+				return BPF_DROP;
+
+			break;
+		default:
+			return BPF_DROP;
+		}
+	}
+
+	return BPF_OK;
+}
+
+/* Common steps to perform regardless of where protocol parsing finishes:
+ * 1. store flow keys in map
+ * 2. if parse result is BPF_OK, parse the vnet hdr if present
+ * 3. return the parse result
+ */
+static __always_inline int parse_epilogue(struct __sk_buff *skb, int ret)
+{
+	const struct bpf_flow_keys *keys = skb->flow_keys;
 	__u32 key = (__u32)(keys->sport) << 16 | keys->dport;
 	struct bpf_flow_keys val;
 
 	memcpy(&val, keys, sizeof(val));
 	bpf_map_update_elem(&last_dissection, &key, &val, BPF_ANY);
-	return ret;
+
+	if (ret != BPF_OK)
+		return ret;
+	return validate_vnet_hdr(keys, skb->len);
 }
 
 #define IPV6_FLOWLABEL_MASK		__bpf_constant_htonl(0x000FFFFF)
@@ -114,8 +240,6 @@ static __always_inline void *bpf_flow_dissect_get_header(struct __sk_buff *skb,
 /* Dispatches on ETHERTYPE */
 static __always_inline int parse_eth_proto(struct __sk_buff *skb, __be16 proto)
 {
-	struct bpf_flow_keys *keys = skb->flow_keys;
-
 	switch (proto) {
 	case bpf_htons(ETH_P_IP):
 		bpf_tail_call_static(skb, &jmp_table, IP);
@@ -131,12 +255,10 @@ static __always_inline int parse_eth_proto(struct __sk_buff *skb, __be16 proto)
 	case bpf_htons(ETH_P_8021AD):
 		bpf_tail_call_static(skb, &jmp_table, VLAN);
 		break;
-	default:
-		/* Protocol not supported */
-		return export_flow_keys(keys, BPF_DROP);
 	}
 
-	return export_flow_keys(keys, BPF_DROP);
+	/* Protocol not supported */
+	return parse_epilogue(skb, BPF_DROP);
 }
 
 SEC("flow_dissector")
@@ -162,28 +284,28 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
 	case IPPROTO_ICMP:
 		icmp = bpf_flow_dissect_get_header(skb, sizeof(*icmp), &_icmp);
 		if (!icmp)
-			return export_flow_keys(keys, BPF_DROP);
-		return export_flow_keys(keys, BPF_OK);
+			return parse_epilogue(skb, BPF_DROP);
+		return parse_epilogue(skb, BPF_OK);
 	case IPPROTO_IPIP:
 		keys->is_encap = true;
 		if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP)
-			return export_flow_keys(keys, BPF_OK);
+			return parse_epilogue(skb, BPF_OK);
 
 		return parse_eth_proto(skb, bpf_htons(ETH_P_IP));
 	case IPPROTO_IPV6:
 		keys->is_encap = true;
 		if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP)
-			return export_flow_keys(keys, BPF_OK);
+			return parse_epilogue(skb, BPF_OK);
 
 		return parse_eth_proto(skb, bpf_htons(ETH_P_IPV6));
 	case IPPROTO_GRE:
 		gre = bpf_flow_dissect_get_header(skb, sizeof(*gre), &_gre);
 		if (!gre)
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		if (bpf_htons(gre->flags & GRE_VERSION))
 			/* Only inspect standard GRE packets with version 0 */
-			return export_flow_keys(keys, BPF_OK);
+			return parse_epilogue(skb, BPF_OK);
 
 		keys->thoff += sizeof(*gre); /* Step over GRE Flags and Proto */
 		if (GRE_IS_CSUM(gre->flags))
@@ -195,13 +317,13 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
 
 		keys->is_encap = true;
 		if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_ENCAP)
-			return export_flow_keys(keys, BPF_OK);
+			return parse_epilogue(skb, BPF_OK);
 
 		if (gre->proto == bpf_htons(ETH_P_TEB)) {
 			eth = bpf_flow_dissect_get_header(skb, sizeof(*eth),
 							  &_eth);
 			if (!eth)
-				return export_flow_keys(keys, BPF_DROP);
+				return parse_epilogue(skb, BPF_DROP);
 
 			keys->thoff += sizeof(*eth);
 
@@ -212,37 +334,35 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
 	case IPPROTO_TCP:
 		tcp = bpf_flow_dissect_get_header(skb, sizeof(*tcp), &_tcp);
 		if (!tcp)
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		if (tcp->doff < 5)
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		if ((__u8 *)tcp + (tcp->doff << 2) > data_end)
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		keys->sport = tcp->source;
 		keys->dport = tcp->dest;
-		return export_flow_keys(keys, BPF_OK);
+		return parse_epilogue(skb, BPF_OK);
 	case IPPROTO_UDP:
 	case IPPROTO_UDPLITE:
 		udp = bpf_flow_dissect_get_header(skb, sizeof(*udp), &_udp);
 		if (!udp)
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		keys->sport = udp->source;
 		keys->dport = udp->dest;
-		return export_flow_keys(keys, BPF_OK);
+		return parse_epilogue(skb, BPF_OK);
 	default:
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 	}
 
-	return export_flow_keys(keys, BPF_DROP);
+	return parse_epilogue(skb, BPF_DROP);
 }
 
 static __always_inline int parse_ipv6_proto(struct __sk_buff *skb, __u8 nexthdr)
 {
-	struct bpf_flow_keys *keys = skb->flow_keys;
-
 	switch (nexthdr) {
 	case IPPROTO_HOPOPTS:
 	case IPPROTO_DSTOPTS:
@@ -255,7 +375,7 @@ static __always_inline int parse_ipv6_proto(struct __sk_buff *skb, __u8 nexthdr)
 		return parse_ip_proto(skb, nexthdr);
 	}
 
-	return export_flow_keys(keys, BPF_DROP);
+	return parse_epilogue(skb, BPF_DROP);
 }
 
 PROG(IP)(struct __sk_buff *skb)
@@ -268,11 +388,11 @@ PROG(IP)(struct __sk_buff *skb)
 
 	iph = bpf_flow_dissect_get_header(skb, sizeof(*iph), &_iph);
 	if (!iph)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	/* IP header cannot be smaller than 20 bytes */
 	if (iph->ihl < 5)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	keys->addr_proto = ETH_P_IP;
 	keys->ipv4_src = iph->saddr;
@@ -281,7 +401,7 @@ PROG(IP)(struct __sk_buff *skb)
 
 	keys->thoff += iph->ihl << 2;
 	if (data + keys->thoff > data_end)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	if (iph->frag_off & bpf_htons(IP_MF | IP_OFFSET)) {
 		keys->is_frag = true;
@@ -302,7 +422,7 @@ PROG(IP)(struct __sk_buff *skb)
 	}
 
 	if (done)
-		return export_flow_keys(keys, BPF_OK);
+		return parse_epilogue(skb, BPF_OK);
 
 	return parse_ip_proto(skb, iph->protocol);
 }
@@ -314,7 +434,7 @@ PROG(IPV6)(struct __sk_buff *skb)
 
 	ip6h = bpf_flow_dissect_get_header(skb, sizeof(*ip6h), &_ip6h);
 	if (!ip6h)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	keys->addr_proto = ETH_P_IPV6;
 	memcpy(&keys->ipv6_src, &ip6h->saddr, 2*sizeof(ip6h->saddr));
@@ -324,7 +444,7 @@ PROG(IPV6)(struct __sk_buff *skb)
 	keys->flow_label = ip6_flowlabel(ip6h);
 
 	if (keys->flags & BPF_FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL)
-		return export_flow_keys(keys, BPF_OK);
+		return parse_epilogue(skb, BPF_OK);
 
 	return parse_ipv6_proto(skb, ip6h->nexthdr);
 }
@@ -336,7 +456,7 @@ PROG(IPV6OP)(struct __sk_buff *skb)
 
 	ip6h = bpf_flow_dissect_get_header(skb, sizeof(*ip6h), &_ip6h);
 	if (!ip6h)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	/* hlen is in 8-octets and does not include the first 8 bytes
 	 * of the header
@@ -354,7 +474,7 @@ PROG(IPV6FR)(struct __sk_buff *skb)
 
 	fragh = bpf_flow_dissect_get_header(skb, sizeof(*fragh), &_fragh);
 	if (!fragh)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	keys->thoff += sizeof(*fragh);
 	keys->is_frag = true;
@@ -367,9 +487,9 @@ PROG(IPV6FR)(struct __sk_buff *skb)
 		 * explicitly asked for.
 		 */
 		if (!(keys->flags & BPF_FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
-			return export_flow_keys(keys, BPF_OK);
+			return parse_epilogue(skb, BPF_OK);
 	} else {
-		return export_flow_keys(keys, BPF_OK);
+		return parse_epilogue(skb, BPF_OK);
 	}
 
 	return parse_ipv6_proto(skb, fragh->nexthdr);
@@ -377,14 +497,13 @@ PROG(IPV6FR)(struct __sk_buff *skb)
 
 PROG(MPLS)(struct __sk_buff *skb)
 {
-	struct bpf_flow_keys *keys = skb->flow_keys;
 	struct mpls_label *mpls, _mpls;
 
 	mpls = bpf_flow_dissect_get_header(skb, sizeof(*mpls), &_mpls);
 	if (!mpls)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
-	return export_flow_keys(keys, BPF_OK);
+	return parse_epilogue(skb, BPF_OK);
 }
 
 PROG(VLAN)(struct __sk_buff *skb)
@@ -396,10 +515,10 @@ PROG(VLAN)(struct __sk_buff *skb)
 	if (keys->n_proto == bpf_htons(ETH_P_8021AD)) {
 		vlan = bpf_flow_dissect_get_header(skb, sizeof(*vlan), &_vlan);
 		if (!vlan)
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		if (vlan->h_vlan_encapsulated_proto != bpf_htons(ETH_P_8021Q))
-			return export_flow_keys(keys, BPF_DROP);
+			return parse_epilogue(skb, BPF_DROP);
 
 		keys->nhoff += sizeof(*vlan);
 		keys->thoff += sizeof(*vlan);
@@ -407,14 +526,14 @@ PROG(VLAN)(struct __sk_buff *skb)
 
 	vlan = bpf_flow_dissect_get_header(skb, sizeof(*vlan), &_vlan);
 	if (!vlan)
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	keys->nhoff += sizeof(*vlan);
 	keys->thoff += sizeof(*vlan);
 	/* Only allow 8021AD + 8021Q double tagging and no triple tagging.*/
 	if (vlan->h_vlan_encapsulated_proto == bpf_htons(ETH_P_8021AD) ||
 	    vlan->h_vlan_encapsulated_proto == bpf_htons(ETH_P_8021Q))
-		return export_flow_keys(keys, BPF_DROP);
+		return parse_epilogue(skb, BPF_DROP);
 
 	keys->n_proto = vlan->h_vlan_encapsulated_proto;
 	return parse_eth_proto(skb, vlan->h_vlan_encapsulated_proto);
diff --git a/tools/testing/selftests/bpf/test_flow_dissector.c b/tools/testing/selftests/bpf/test_flow_dissector.c
index 571cc076dd7d..aa80055a5518 100644
--- a/tools/testing/selftests/bpf/test_flow_dissector.c
+++ b/tools/testing/selftests/bpf/test_flow_dissector.c
@@ -17,6 +17,8 @@
 #include <linux/if_packet.h>
 #include <linux/if_ether.h>
 #include <linux/ipv6.h>
+#include <linux/virtio_net.h>
+#include <net/if.h>
 #include <netinet/ip.h>
 #include <netinet/in.h>
 #include <netinet/udp.h>
@@ -65,7 +67,8 @@ struct guehdr {
 static uint8_t	cfg_dsfield_inner;
 static uint8_t	cfg_dsfield_outer;
 static uint8_t	cfg_encap_proto;
-static bool	cfg_expect_failure = false;
+static bool	cfg_expect_norx;
+static bool	cfg_expect_snd_failure;
 static int	cfg_l3_extra = AF_UNSPEC;	/* optional SIT prefix */
 static int	cfg_l3_inner = AF_UNSPEC;
 static int	cfg_l3_outer = AF_UNSPEC;
@@ -77,8 +80,14 @@ static int	cfg_port_gue = 6080;
 static bool	cfg_only_rx;
 static bool	cfg_only_tx;
 static int	cfg_src_port = 9;
+static bool	cfg_tx_pf_packet;
+static bool	cfg_use_vnet;
+static bool	cfg_vnet_use_hdr_len_bad;
+static bool	cfg_vnet_use_gso;
+static bool	cfg_vnet_use_csum_off;
+static bool	cfg_partial_udp_hdr;
 
-static char	buf[ETH_DATA_LEN];
+static char	buf[ETH_MAX_MTU];
 
 #define INIT_ADDR4(name, addr4, port)				\
 	static struct sockaddr_in name = {			\
@@ -273,8 +282,48 @@ static int l3_length(int family)
 		return sizeof(struct ipv6hdr);
 }
 
+static int build_vnet_header(void *header, int il3_len)
+{
+	struct virtio_net_hdr *vh = header;
+
+	vh->hdr_len = ETH_HLEN + il3_len + sizeof(struct udphdr);
+
+	if (cfg_partial_udp_hdr) {
+		vh->hdr_len -= (sizeof(struct udphdr) >> 1);
+		return sizeof(*vh);
+	}
+
+	/* Alteration must increase hdr_len; if not, kernel overwrites it */
+	if (cfg_vnet_use_hdr_len_bad)
+		vh->hdr_len++;
+
+	if (cfg_vnet_use_csum_off) {
+		vh->flags |= VIRTIO_NET_HDR_F_NEEDS_CSUM;
+		vh->csum_start = ETH_HLEN + il3_len;
+		vh->csum_offset = __builtin_offsetof(struct udphdr, check);
+	}
+
+	if (cfg_vnet_use_gso) {
+		vh->gso_type = VIRTIO_NET_HDR_GSO_UDP;
+		vh->gso_size = ETH_DATA_LEN - il3_len;
+	}
+
+	return sizeof(*vh);
+}
+
+static int build_eth_header(void *header)
+{
+	struct ethhdr *eth = header;
+	uint16_t proto = cfg_l3_inner == PF_INET ? ETH_P_IP : ETH_P_IPV6;
+
+	eth->h_proto = htons(proto);
+
+	return ETH_HLEN;
+}
+
 static int build_packet(void)
 {
+	int l2_len = 0;
 	int ol3_len = 0, ol4_len = 0, il3_len = 0, il4_len = 0;
 	int el3_len = 0;
 
@@ -294,23 +343,29 @@ static int build_packet(void)
 	il3_len = l3_length(cfg_l3_inner);
 	il4_len = sizeof(struct udphdr);
 
-	if (el3_len + ol3_len + ol4_len + il3_len + il4_len + cfg_payload_len >=
-	    sizeof(buf))
+	if (cfg_use_vnet)
+		l2_len += build_vnet_header(buf, il3_len);
+	if (cfg_tx_pf_packet)
+		l2_len += build_eth_header(buf + l2_len);
+
+	if (l2_len + el3_len + ol3_len + ol4_len + il3_len + il4_len +
+	    cfg_payload_len >= sizeof(buf))
 		error(1, 0, "packet too large\n");
 
 	/*
 	 * Fill packet from inside out, to calculate correct checksums.
 	 * But create ip before udp headers, as udp uses ip for pseudo-sum.
 	 */
-	memset(buf + el3_len + ol3_len + ol4_len + il3_len + il4_len,
+	memset(buf + l2_len + el3_len + ol3_len + ol4_len + il3_len + il4_len,
 	       cfg_payload_char, cfg_payload_len);
 
 	/* add zero byte for udp csum padding */
-	buf[el3_len + ol3_len + ol4_len + il3_len + il4_len + cfg_payload_len] = 0;
+	buf[l2_len + el3_len + ol3_len + ol4_len + il3_len + il4_len +
+	    cfg_payload_len] = 0;
 
 	switch (cfg_l3_inner) {
 	case PF_INET:
-		build_ipv4_header(buf + el3_len + ol3_len + ol4_len,
+		build_ipv4_header(buf + l2_len + el3_len + ol3_len + ol4_len,
 				  IPPROTO_UDP,
 				  in_saddr4.sin_addr.s_addr,
 				  in_daddr4.sin_addr.s_addr,
@@ -318,7 +373,7 @@ static int build_packet(void)
 				  cfg_dsfield_inner);
 		break;
 	case PF_INET6:
-		build_ipv6_header(buf + el3_len + ol3_len + ol4_len,
+		build_ipv6_header(buf + l2_len + el3_len + ol3_len + ol4_len,
 				  IPPROTO_UDP,
 				  &in_saddr6, &in_daddr6,
 				  il4_len + cfg_payload_len,
@@ -326,22 +381,25 @@ static int build_packet(void)
 		break;
 	}
 
-	build_udp_header(buf + el3_len + ol3_len + ol4_len + il3_len,
+	build_udp_header(buf + l2_len + el3_len + ol3_len + ol4_len + il3_len,
 			 cfg_payload_len, CFG_PORT_INNER, cfg_l3_inner);
 
+	if (cfg_partial_udp_hdr)
+		return l2_len + il3_len + (il4_len >> 1);
+
 	if (!cfg_encap_proto)
-		return il3_len + il4_len + cfg_payload_len;
+		return l2_len + il3_len + il4_len + cfg_payload_len;
 
 	switch (cfg_l3_outer) {
 	case PF_INET:
-		build_ipv4_header(buf + el3_len, cfg_encap_proto,
+		build_ipv4_header(buf + l2_len + el3_len, cfg_encap_proto,
 				  out_saddr4.sin_addr.s_addr,
 				  out_daddr4.sin_addr.s_addr,
 				  ol4_len + il3_len + il4_len + cfg_payload_len,
 				  cfg_dsfield_outer);
 		break;
 	case PF_INET6:
-		build_ipv6_header(buf + el3_len, cfg_encap_proto,
+		build_ipv6_header(buf + l2_len + el3_len, cfg_encap_proto,
 				  &out_saddr6, &out_daddr6,
 				  ol4_len + il3_len + il4_len + cfg_payload_len,
 				  cfg_dsfield_outer);
@@ -350,17 +408,17 @@ static int build_packet(void)
 
 	switch (cfg_encap_proto) {
 	case IPPROTO_UDP:
-		build_gue_header(buf + el3_len + ol3_len + ol4_len -
+		build_gue_header(buf + l2_len + el3_len + ol3_len + ol4_len -
 				 sizeof(struct guehdr),
 				 cfg_l3_inner == PF_INET ? IPPROTO_IPIP
 							 : IPPROTO_IPV6);
-		build_udp_header(buf + el3_len + ol3_len,
+		build_udp_header(buf + l2_len + el3_len + ol3_len,
 				 sizeof(struct guehdr) + il3_len + il4_len +
 				 cfg_payload_len,
 				 cfg_port_gue, cfg_l3_outer);
 		break;
 	case IPPROTO_GRE:
-		build_gre_header(buf + el3_len + ol3_len,
+		build_gre_header(buf + l2_len + el3_len + ol3_len,
 				 cfg_l3_inner == PF_INET ? ETH_P_IP
 							 : ETH_P_IPV6);
 		break;
@@ -368,7 +426,7 @@ static int build_packet(void)
 
 	switch (cfg_l3_extra) {
 	case PF_INET:
-		build_ipv4_header(buf,
+		build_ipv4_header(buf + l2_len,
 				  cfg_l3_outer == PF_INET ? IPPROTO_IPIP
 							  : IPPROTO_IPV6,
 				  extra_saddr4.sin_addr.s_addr,
@@ -377,7 +435,7 @@ static int build_packet(void)
 				  cfg_payload_len, 0);
 		break;
 	case PF_INET6:
-		build_ipv6_header(buf,
+		build_ipv6_header(buf + l2_len,
 				  cfg_l3_outer == PF_INET ? IPPROTO_IPIP
 							  : IPPROTO_IPV6,
 				  &extra_saddr6, &extra_daddr6,
@@ -386,15 +444,46 @@ static int build_packet(void)
 		break;
 	}
 
-	return el3_len + ol3_len + ol4_len + il3_len + il4_len +
+	return l2_len + el3_len + ol3_len + ol4_len + il3_len + il4_len +
 	       cfg_payload_len;
 }
 
+static int setup_tx_pfpacket(void)
+{
+	struct sockaddr_ll laddr = {0};
+	const int one = 1;
+	uint16_t proto;
+	int fd;
+
+	fd = socket(PF_PACKET, SOCK_RAW, 0);
+	if (fd == -1)
+		error(1, errno, "socket tx");
+
+	if (cfg_use_vnet &&
+	    setsockopt(fd, SOL_PACKET, PACKET_VNET_HDR, &one, sizeof(one)))
+		error(1, errno, "setsockopt vnet");
+
+	proto = cfg_l3_inner == PF_INET ? ETH_P_IP : ETH_P_IPV6;
+	laddr.sll_family = AF_PACKET;
+	laddr.sll_protocol = htons(proto);
+	laddr.sll_ifindex = if_nametoindex("lo");
+	if (!laddr.sll_ifindex)
+		error(1, errno, "if_nametoindex");
+
+	if (bind(fd, (void *)&laddr, sizeof(laddr)))
+		error(1, errno, "bind");
+
+	return fd;
+}
+
 /* sender transmits encapsulated over RAW or unencap'd over UDP */
 static int setup_tx(void)
 {
 	int family, fd, ret;
 
+	if (cfg_tx_pf_packet)
+		return setup_tx_pfpacket();
+
 	if (cfg_l3_extra)
 		family = cfg_l3_extra;
 	else if (cfg_l3_outer)
@@ -464,6 +553,13 @@ static int do_tx(int fd, const char *pkt, int len)
 	int ret;
 
 	ret = write(fd, pkt, len);
+
+	if (cfg_expect_snd_failure) {
+		if (ret == -1)
+			return 0;
+		error(1, 0, "expected tx to fail but it did not");
+	}
+
 	if (ret == -1)
 		error(1, errno, "send");
 	if (ret != len)
@@ -571,7 +667,7 @@ static int do_main(void)
 	 * success (== 0) only if received all packets
 	 * unless failure is expected, in which case none must arrive.
 	 */
-	if (cfg_expect_failure)
+	if (cfg_expect_norx || cfg_expect_snd_failure)
 		return rx != 0;
 	else
 		return rx != tx;
@@ -623,8 +719,12 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "d:D:e:f:Fhi:l:n:o:O:Rs:S:t:Tx:X:")) != -1) {
+	while ((c = getopt(argc, argv,
+			   "cd:D:e:Ef:FGghi:l:Ln:o:O:pRs:S:t:TUvx:X:")) != -1) {
 		switch (c) {
+		case 'c':
+			cfg_vnet_use_csum_off = true;
+			break;
 		case 'd':
 			if (cfg_l3_outer == AF_UNSPEC)
 				error(1, 0, "-d must be preceded by -o");
@@ -653,11 +753,17 @@ static void parse_opts(int argc, char **argv)
 			else
 				usage(argv[0]);
 			break;
+		case 'E':
+			cfg_expect_snd_failure = true;
+			break;
 		case 'f':
 			cfg_src_port = strtol(optarg, NULL, 0);
 			break;
 		case 'F':
-			cfg_expect_failure = true;
+			cfg_expect_norx = true;
+			break;
+		case 'g':
+			cfg_vnet_use_gso = true;
 			break;
 		case 'h':
 			usage(argv[0]);
@@ -673,6 +779,9 @@ static void parse_opts(int argc, char **argv)
 		case 'l':
 			cfg_payload_len = strtol(optarg, NULL, 0);
 			break;
+		case 'L':
+			cfg_vnet_use_hdr_len_bad = true;
+			break;
 		case 'n':
 			cfg_num_pkt = strtol(optarg, NULL, 0);
 			break;
@@ -682,6 +791,9 @@ static void parse_opts(int argc, char **argv)
 		case 'O':
 			cfg_l3_extra = parse_protocol_family(argv[0], optarg);
 			break;
+		case 'p':
+			cfg_tx_pf_packet = true;
+			break;
 		case 'R':
 			cfg_only_rx = true;
 			break;
@@ -703,6 +815,12 @@ static void parse_opts(int argc, char **argv)
 		case 'T':
 			cfg_only_tx = true;
 			break;
+		case 'U':
+			cfg_partial_udp_hdr = true;
+			break;
+		case 'v':
+			cfg_use_vnet = true;
+			break;
 		case 'x':
 			cfg_dsfield_outer = strtol(optarg, NULL, 0);
 			break;
@@ -733,7 +851,26 @@ static void parse_opts(int argc, char **argv)
 	 */
 	if (((cfg_dsfield_outer & 0x3) == 0x3) &&
 	    ((cfg_dsfield_inner & 0x3) == 0x0))
-		cfg_expect_failure = true;
+		cfg_expect_norx = true;
+
+	/* Don't wait around for packets that we expect to fail to send */
+	if (cfg_expect_snd_failure && !cfg_num_secs)
+		cfg_num_secs = 3;
+
+	if (cfg_partial_udp_hdr && cfg_encap_proto)
+		error(1, 0,
+		      "ops: can't specify partial UDP hdr (-U) and encap (-e)");
+
+	if (cfg_use_vnet && cfg_encap_proto)
+		error(1, 0, "options: cannot specify encap (-e) with vnet (-v)");
+	if (cfg_use_vnet && !cfg_tx_pf_packet)
+		error(1, 0, "options: vnet (-v) requires psock for tx (-p)");
+	if (cfg_vnet_use_gso && !cfg_use_vnet)
+		error(1, 0, "options: gso (-g) requires vnet (-v)");
+	if (cfg_vnet_use_csum_off && !cfg_use_vnet)
+		error(1, 0, "options: vnet csum (-c) requires vnet (-v)");
+	if (cfg_vnet_use_hdr_len_bad && !cfg_use_vnet)
+		error(1, 0, "options: bad vnet hdrlen (-L) requires vnet (-v)");
 }
 
 static void print_opts(void)
diff --git a/tools/testing/selftests/bpf/test_flow_dissector.sh b/tools/testing/selftests/bpf/test_flow_dissector.sh
index 174b72a64a4c..5852cf815eeb 100755
--- a/tools/testing/selftests/bpf/test_flow_dissector.sh
+++ b/tools/testing/selftests/bpf/test_flow_dissector.sh
@@ -51,6 +51,9 @@ if [[ -z $(ip netns identify $$) ]]; then
 		echo "Skipping root flow dissector test, bpftool not found" >&2
 	fi
 
+	orig_flow_dissect_sysctl=$(</proc/sys/net/core/flow_dissect_vnet_hdr)
+	sysctl net.core.flow_dissect_vnet_hdr=1
+
 	# Run the rest of the tests in a net namespace.
 	../net/in_netns.sh "$0" "$@"
 	err=$(( $err + $? ))
@@ -61,6 +64,7 @@ if [[ -z $(ip netns identify $$) ]]; then
 		echo "selftests: $TESTNAME [FAILED]";
 	fi
 
+	sysctl net.core.flow_dissect_vnet_hdr=$orig_flow_dissect_sysctl
 	exit $err
 fi
 
@@ -165,4 +169,19 @@ tc filter add dev lo parent ffff: protocol ipv6 pref 1337 flower ip_proto \
 # Send 10 IPv6/UDP packets from port 10. Filter should not drop any.
 ./test_flow_dissector -i 6 -f 10
 
+
+echo "Testing virtio-net header validation..."
+echo "Testing valid vnet headers. Should *not* be dropped."
+./with_addr.sh ./test_flow_dissector -i 4 -D 192.168.0.1 -S 1.1.1.1 -p -v
+echo "Testing partial transport header. Should be dropped."
+./with_addr.sh ./test_flow_dissector -i 4 -D 192.168.0.1 -S 1.1.1.1 -p -v -U -E
+echo "Testing valid vnet gso spec. Should *not* be dropped."
+./with_addr.sh ./test_flow_dissector -i 4 -D 192.168.0.1 -S 1.1.1.1 -p -v -g -c -l 8000
+echo "Testing invalid vnet gso size. Should be dropped."
+./with_addr.sh ./test_flow_dissector -i 4 -D 192.168.0.1 -S 1.1.1.1 -p -v -g -c -l 100 -E
+echo "Testing invalid vnet header len. Should be dropped."
+./with_addr.sh ./test_flow_dissector -i 4 -D 192.168.0.1 -S 1.1.1.1 -p -v -L -E
+echo "Testing vnet gso without csum. Should be dropped."
+./with_addr.sh ./test_flow_dissector -i 4 -D 192.168.0.1 -S 1.1.1.1 -p -v -g -l 8000 -E
+
 exit 0
-- 
2.32.0.272.g935e593368-goog

