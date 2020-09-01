Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D325856B
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbgIABuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21136 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727051AbgIABun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:43 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0811oCBo014941
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0WGDoTwtCkfLjfaw3S08TJ1zbZDbtcNaDi58NHF9v44=;
 b=rMJu1ofKX0x6dIX0pioISN8eTwvu45R2PFwmX8DHkNAGhPZqPjkf8XDuNNvUtOFdzPW1
 h/N00qVTok/rNLnvG9ocl90kFDUTRyNaBtLmqGpP3HXmITHYxwdC+6qz//XK9AgcjAIH
 x6RCKbOSS5407eBgXxEUrrHKB+OOLRzgvEc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 337jh03beb-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:40 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:39 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2E3BC2EC663B; Mon, 31 Aug 2020 18:50:36 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 14/14] selftests/bpf: convert cls_redirect selftest to use __noinline
Date:   Mon, 31 Aug 2020 18:50:03 -0700
Message-ID: <20200901015003.2871861-15-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 phishscore=0 suspectscore=0 impostorscore=0 mlxlogscore=999 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As one of the most complicated and close-to-real-world programs, cls_redi=
rect
is a good candidate to excercise libbpf's logic of handling bpf2bpf calls=
. So
convert it to explicit __noinline for majority of functions except few mo=
st
basic ones. If those few functions are inlined, verifier starts to compla=
in
about program instruction limit of 1mln instructions being exceeded, most
probably due to instruction overhead of doing a sub-program call.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/progs/test_cls_redirect.c   | 99 ++++++++++---------
 1 file changed, 50 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tool=
s/testing/selftests/bpf/progs/test_cls_redirect.c
index f0b72e86bee5..c3fc410f7d9c 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -125,7 +125,7 @@ typedef struct buf {
 	uint8_t *const tail;
 } buf_t;
=20
-static size_t buf_off(const buf_t *buf)
+static __always_inline size_t buf_off(const buf_t *buf)
 {
 	/* Clang seems to optimize constructs like
 	 *    a - b + c
@@ -145,7 +145,7 @@ static size_t buf_off(const buf_t *buf)
 	return off;
 }
=20
-static bool buf_copy(buf_t *buf, void *dst, size_t len)
+static __always_inline bool buf_copy(buf_t *buf, void *dst, size_t len)
 {
 	if (bpf_skb_load_bytes(buf->skb, buf_off(buf), dst, len)) {
 		return false;
@@ -155,7 +155,7 @@ static bool buf_copy(buf_t *buf, void *dst, size_t le=
n)
 	return true;
 }
=20
-static bool buf_skip(buf_t *buf, const size_t len)
+static __always_inline bool buf_skip(buf_t *buf, const size_t len)
 {
 	/* Check whether off + len is valid in the non-linear part. */
 	if (buf_off(buf) + len > buf->skb->len) {
@@ -173,7 +173,7 @@ static bool buf_skip(buf_t *buf, const size_t len)
  * If scratch is not NULL, the function will attempt to load non-linear
  * data via bpf_skb_load_bytes. On success, scratch is returned.
  */
-static void *buf_assign(buf_t *buf, const size_t len, void *scratch)
+static __always_inline void *buf_assign(buf_t *buf, const size_t len, vo=
id *scratch)
 {
 	if (buf->head + len > buf->tail) {
 		if (scratch =3D=3D NULL) {
@@ -188,7 +188,7 @@ static void *buf_assign(buf_t *buf, const size_t len,=
 void *scratch)
 	return ptr;
 }
=20
-static bool pkt_skip_ipv4_options(buf_t *buf, const struct iphdr *ipv4)
+static __noinline bool pkt_skip_ipv4_options(buf_t *buf, const struct ip=
hdr *ipv4)
 {
 	if (ipv4->ihl <=3D 5) {
 		return true;
@@ -197,13 +197,13 @@ static bool pkt_skip_ipv4_options(buf_t *buf, const=
 struct iphdr *ipv4)
 	return buf_skip(buf, (ipv4->ihl - 5) * 4);
 }
=20
-static bool ipv4_is_fragment(const struct iphdr *ip)
+static __noinline bool ipv4_is_fragment(const struct iphdr *ip)
 {
 	uint16_t frag_off =3D ip->frag_off & bpf_htons(IP_OFFSET_MASK);
 	return (ip->frag_off & bpf_htons(IP_MF)) !=3D 0 || frag_off > 0;
 }
=20
-static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
+static __always_inline struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct i=
phdr *scratch)
 {
 	struct iphdr *ipv4 =3D buf_assign(pkt, sizeof(*ipv4), scratch);
 	if (ipv4 =3D=3D NULL) {
@@ -222,7 +222,7 @@ static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struc=
t iphdr *scratch)
 }
=20
 /* Parse the L4 ports from a packet, assuming a layout like TCP or UDP. =
*/
-static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *ports)
+static __noinline bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t =
*ports)
 {
 	if (!buf_copy(pkt, ports, sizeof(*ports))) {
 		return false;
@@ -237,7 +237,7 @@ static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_=
ports_t *ports)
 	return true;
 }
=20
-static uint16_t pkt_checksum_fold(uint32_t csum)
+static __noinline uint16_t pkt_checksum_fold(uint32_t csum)
 {
 	/* The highest reasonable value for an IPv4 header
 	 * checksum requires two folds, so we just do that always.
@@ -247,7 +247,7 @@ static uint16_t pkt_checksum_fold(uint32_t csum)
 	return (uint16_t)~csum;
 }
=20
-static void pkt_ipv4_checksum(struct iphdr *iph)
+static __noinline void pkt_ipv4_checksum(struct iphdr *iph)
 {
 	iph->check =3D 0;
=20
@@ -268,10 +268,11 @@ static void pkt_ipv4_checksum(struct iphdr *iph)
 	iph->check =3D pkt_checksum_fold(acc);
 }
=20
-static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
-					    const struct ipv6hdr *ipv6,
-					    uint8_t *upper_proto,
-					    bool *is_fragment)
+static __noinline
+bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
+				     const struct ipv6hdr *ipv6,
+				     uint8_t *upper_proto,
+				     bool *is_fragment)
 {
 	/* We understand five extension headers.
 	 * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
@@ -336,7 +337,7 @@ static bool pkt_skip_ipv6_extension_headers(buf_t *pk=
t,
  * scratch is allocated on the stack. However, this usage should be safe=
 since
  * it's the callers stack after all.
  */
-static inline __attribute__((__always_inline__)) struct ipv6hdr *
+static __always_inline struct ipv6hdr *
 pkt_parse_ipv6(buf_t *pkt, struct ipv6hdr *scratch, uint8_t *proto,
 	       bool *is_fragment)
 {
@@ -354,20 +355,20 @@ pkt_parse_ipv6(buf_t *pkt, struct ipv6hdr *scratch,=
 uint8_t *proto,
=20
 /* Global metrics, per CPU
  */
-struct bpf_map_def metrics_map SEC("maps") =3D {
-	.type =3D BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size =3D sizeof(unsigned int),
-	.value_size =3D sizeof(metrics_t),
-	.max_entries =3D 1,
-};
-
-static metrics_t *get_global_metrics(void)
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, unsigned int);
+	__type(value, metrics_t);
+} metrics_map SEC(".maps");
+
+static __noinline metrics_t *get_global_metrics(void)
 {
 	uint64_t key =3D 0;
 	return bpf_map_lookup_elem(&metrics_map, &key);
 }
=20
-static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *enca=
p)
+static __noinline ret_t accept_locally(struct __sk_buff *skb, encap_head=
ers_t *encap)
 {
 	const int payload_off =3D
 		sizeof(*encap) +
@@ -388,8 +389,8 @@ static ret_t accept_locally(struct __sk_buff *skb, en=
cap_headers_t *encap)
 	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
 }
=20
-static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *en=
cap,
-			      struct in_addr *next_hop, metrics_t *metrics)
+static __noinline ret_t forward_with_gre(struct __sk_buff *skb, encap_he=
aders_t *encap,
+					 struct in_addr *next_hop, metrics_t *metrics)
 {
 	metrics->forwarded_packets_total_gre++;
=20
@@ -509,8 +510,8 @@ static ret_t forward_with_gre(struct __sk_buff *skb, =
encap_headers_t *encap,
 	return bpf_redirect(skb->ifindex, 0);
 }
=20
-static ret_t forward_to_next_hop(struct __sk_buff *skb, encap_headers_t =
*encap,
-				 struct in_addr *next_hop, metrics_t *metrics)
+static __noinline ret_t forward_to_next_hop(struct __sk_buff *skb, encap=
_headers_t *encap,
+					    struct in_addr *next_hop, metrics_t *metrics)
 {
 	/* swap L2 addresses */
 	/* This assumes that packets are received from a router.
@@ -546,7 +547,7 @@ static ret_t forward_to_next_hop(struct __sk_buff *sk=
b, encap_headers_t *encap,
 	return bpf_redirect(skb->ifindex, 0);
 }
=20
-static ret_t skip_next_hops(buf_t *pkt, int n)
+static __noinline ret_t skip_next_hops(buf_t *pkt, int n)
 {
 	switch (n) {
 	case 1:
@@ -566,8 +567,8 @@ static ret_t skip_next_hops(buf_t *pkt, int n)
  * pkt is positioned just after the variable length GLB header
  * iff the call is successful.
  */
-static ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
-			  struct in_addr *next_hop)
+static __noinline ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
+				     struct in_addr *next_hop)
 {
 	if (encap->unigue.next_hop > encap->unigue.hop_count) {
 		return TC_ACT_SHOT;
@@ -601,8 +602,8 @@ static ret_t get_next_hop(buf_t *pkt, encap_headers_t=
 *encap,
  * return value, and calling code works while still being "generic" to
  * IPv4 and IPv6.
  */
-static uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
-			   uint64_t iphlen, uint16_t sport, uint16_t dport)
+static __noinline uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void=
 *iph,
+				      uint64_t iphlen, uint16_t sport, uint16_t dport)
 {
 	switch (iphlen) {
 	case sizeof(struct iphdr): {
@@ -630,9 +631,9 @@ static uint64_t fill_tuple(struct bpf_sock_tuple *tup=
le, void *iph,
 	}
 }
=20
-static verdict_t classify_tcp(struct __sk_buff *skb,
-			      struct bpf_sock_tuple *tuple, uint64_t tuplen,
-			      void *iph, struct tcphdr *tcp)
+static __noinline verdict_t classify_tcp(struct __sk_buff *skb,
+					 struct bpf_sock_tuple *tuple, uint64_t tuplen,
+					 void *iph, struct tcphdr *tcp)
 {
 	struct bpf_sock *sk =3D
 		bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
@@ -663,8 +664,8 @@ static verdict_t classify_tcp(struct __sk_buff *skb,
 	return UNKNOWN;
 }
=20
-static verdict_t classify_udp(struct __sk_buff *skb,
-			      struct bpf_sock_tuple *tuple, uint64_t tuplen)
+static __noinline verdict_t classify_udp(struct __sk_buff *skb,
+					 struct bpf_sock_tuple *tuple, uint64_t tuplen)
 {
 	struct bpf_sock *sk =3D
 		bpf_sk_lookup_udp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
@@ -681,9 +682,9 @@ static verdict_t classify_udp(struct __sk_buff *skb,
 	return UNKNOWN;
 }
=20
-static verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto,
-			       struct bpf_sock_tuple *tuple, uint64_t tuplen,
-			       metrics_t *metrics)
+static __noinline verdict_t classify_icmp(struct __sk_buff *skb, uint8_t=
 proto,
+					  struct bpf_sock_tuple *tuple, uint64_t tuplen,
+					  metrics_t *metrics)
 {
 	switch (proto) {
 	case IPPROTO_TCP:
@@ -698,7 +699,7 @@ static verdict_t classify_icmp(struct __sk_buff *skb,=
 uint8_t proto,
 	}
 }
=20
-static verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
+static __noinline verdict_t process_icmpv4(buf_t *pkt, metrics_t *metric=
s)
 {
 	struct icmphdr icmp;
 	if (!buf_copy(pkt, &icmp, sizeof(icmp))) {
@@ -745,7 +746,7 @@ static verdict_t process_icmpv4(buf_t *pkt, metrics_t=
 *metrics)
 			     sizeof(tuple.ipv4), metrics);
 }
=20
-static verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
+static __noinline verdict_t process_icmpv6(buf_t *pkt, metrics_t *metric=
s)
 {
 	struct icmp6hdr icmp6;
 	if (!buf_copy(pkt, &icmp6, sizeof(icmp6))) {
@@ -797,8 +798,8 @@ static verdict_t process_icmpv6(buf_t *pkt, metrics_t=
 *metrics)
 			     metrics);
 }
=20
-static verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t iphlen,
-			     metrics_t *metrics)
+static __noinline verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t =
iphlen,
+					metrics_t *metrics)
 {
 	metrics->l4_protocol_packets_total_tcp++;
=20
@@ -819,8 +820,8 @@ static verdict_t process_tcp(buf_t *pkt, void *iph, u=
int64_t iphlen,
 	return classify_tcp(pkt->skb, &tuple, tuplen, iph, tcp);
 }
=20
-static verdict_t process_udp(buf_t *pkt, void *iph, uint64_t iphlen,
-			     metrics_t *metrics)
+static __noinline verdict_t process_udp(buf_t *pkt, void *iph, uint64_t =
iphlen,
+					metrics_t *metrics)
 {
 	metrics->l4_protocol_packets_total_udp++;
=20
@@ -837,7 +838,7 @@ static verdict_t process_udp(buf_t *pkt, void *iph, u=
int64_t iphlen,
 	return classify_udp(pkt->skb, &tuple, tuplen);
 }
=20
-static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
+static __noinline verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
 {
 	metrics->l3_protocol_packets_total_ipv4++;
=20
@@ -874,7 +875,7 @@ static verdict_t process_ipv4(buf_t *pkt, metrics_t *=
metrics)
 	}
 }
=20
-static verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
+static __noinline verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
 {
 	metrics->l3_protocol_packets_total_ipv6++;
=20
--=20
2.24.1

