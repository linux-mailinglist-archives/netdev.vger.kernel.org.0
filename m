Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9367625CAF9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbgICUhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:37:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39714 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729352AbgICUhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:37:10 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083KXSkU019074
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 13:37:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BTl2Z6Nh9g0TYywbpy53ANVQYzss3NW/ZmUT5lsr1Xc=;
 b=Em+j+leU3m3FNq0/MnGoEkFoTagZGGTcgY0Yl4PGBP2RPkyM3ybFZfZY9wqUc6/7ttCD
 dQxpAStEhfw6ztZ63QCanlJuYx31ui6di/CUTAGJkDwRH41HKKrIZfWVTxD+TgNdPnHF
 AsXxm+iDzWlJxvRtQVXL6MawexrsmXhhj00= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33am8edr0p-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 13:37:07 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 3 Sep 2020 13:36:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CCA6D2EC6814; Thu,  3 Sep 2020 13:36:13 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v3 bpf-next 14/14] selftests/bpf: add __noinline variant of cls_redirect selftest
Date:   Thu, 3 Sep 2020 13:35:42 -0700
Message-ID: <20200903203542.15944-15-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200903203542.15944-1-andriin@fb.com>
References: <20200903203542.15944-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_13:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009030183
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As one of the most complicated and close-to-real-world programs, cls_redi=
rect
is a good candidate to exercise libbpf's logic of handling bpf2bpf calls.=
 So
add variant with using explicit __noinline for majority of functions exce=
pt
few most basic ones. If those few functions are inlined, verifier starts =
to
complain about program instruction limit of 1mln instructions being excee=
ded,
most probably due to instruction overhead of doing a sub-program call.
Convert user-space part of selftest to have to sub-tests: with and withou=
t
inlining.

Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/cls_redirect.c   |  72 +++++++++---
 .../selftests/bpf/progs/test_cls_redirect.c   | 105 ++++++++++--------
 .../bpf/progs/test_cls_redirect_subprogs.c    |   2 +
 3 files changed, 115 insertions(+), 64 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_s=
ubprogs.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c b/tool=
s/testing/selftests/bpf/prog_tests/cls_redirect.c
index f259085cca6a..9781d85cb223 100644
--- a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
+++ b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
@@ -12,10 +12,13 @@
=20
 #include "progs/test_cls_redirect.h"
 #include "test_cls_redirect.skel.h"
+#include "test_cls_redirect_subprogs.skel.h"
=20
 #define ENCAP_IP INADDR_LOOPBACK
 #define ENCAP_PORT (1234)
=20
+static int duration =3D 0;
+
 struct addr_port {
 	in_port_t port;
 	union {
@@ -361,30 +364,18 @@ static void close_fds(int *fds, int n)
 			close(fds[i]);
 }
=20
-void test_cls_redirect(void)
+static void test_cls_redirect_common(struct bpf_program *prog)
 {
-	struct test_cls_redirect *skel =3D NULL;
 	struct bpf_prog_test_run_attr tattr =3D {};
 	int families[] =3D { AF_INET, AF_INET6 };
 	struct sockaddr_storage ss;
 	struct sockaddr *addr;
 	socklen_t slen;
 	int i, j, err;
-
 	int servers[__NR_KIND][ARRAY_SIZE(families)] =3D {};
 	int conns[__NR_KIND][ARRAY_SIZE(families)] =3D {};
 	struct tuple tuples[__NR_KIND][ARRAY_SIZE(families)];
=20
-	skel =3D test_cls_redirect__open();
-	if (CHECK_FAIL(!skel))
-		return;
-
-	skel->rodata->ENCAPSULATION_IP =3D htonl(ENCAP_IP);
-	skel->rodata->ENCAPSULATION_PORT =3D htons(ENCAP_PORT);
-
-	if (CHECK_FAIL(test_cls_redirect__load(skel)))
-		goto cleanup;
-
 	addr =3D (struct sockaddr *)&ss;
 	for (i =3D 0; i < ARRAY_SIZE(families); i++) {
 		slen =3D prepare_addr(&ss, families[i]);
@@ -402,7 +393,7 @@ void test_cls_redirect(void)
 			goto cleanup;
 	}
=20
-	tattr.prog_fd =3D bpf_program__fd(skel->progs.cls_redirect);
+	tattr.prog_fd =3D bpf_program__fd(prog);
 	for (i =3D 0; i < ARRAY_SIZE(tests); i++) {
 		struct test_cfg *test =3D &tests[i];
=20
@@ -450,7 +441,58 @@ void test_cls_redirect(void)
 	}
=20
 cleanup:
-	test_cls_redirect__destroy(skel);
 	close_fds((int *)servers, sizeof(servers) / sizeof(servers[0][0]));
 	close_fds((int *)conns, sizeof(conns) / sizeof(conns[0][0]));
 }
+
+static void test_cls_redirect_inlined(void)
+{
+	struct test_cls_redirect *skel;
+	int err;
+
+	skel =3D test_cls_redirect__open();
+	if (CHECK(!skel, "skel_open", "failed\n"))
+		return;
+
+	skel->rodata->ENCAPSULATION_IP =3D htonl(ENCAP_IP);
+	skel->rodata->ENCAPSULATION_PORT =3D htons(ENCAP_PORT);
+
+	err =3D test_cls_redirect__load(skel);
+	if (CHECK(err, "skel_load", "failed: %d\n", err))
+		goto cleanup;
+
+	test_cls_redirect_common(skel->progs.cls_redirect);
+
+cleanup:
+	test_cls_redirect__destroy(skel);
+}
+
+static void test_cls_redirect_subprogs(void)
+{
+	struct test_cls_redirect_subprogs *skel;
+	int err;
+
+	skel =3D test_cls_redirect_subprogs__open();
+	if (CHECK(!skel, "skel_open", "failed\n"))
+		return;
+
+	skel->rodata->ENCAPSULATION_IP =3D htonl(ENCAP_IP);
+	skel->rodata->ENCAPSULATION_PORT =3D htons(ENCAP_PORT);
+
+	err =3D test_cls_redirect_subprogs__load(skel);
+	if (CHECK(err, "skel_load", "failed: %d\n", err))
+		goto cleanup;
+
+	test_cls_redirect_common(skel->progs.cls_redirect);
+
+cleanup:
+	test_cls_redirect_subprogs__destroy(skel);
+}
+
+void test_cls_redirect(void)
+{
+	if (test__start_subtest("cls_redirect_inlined"))
+		test_cls_redirect_inlined();
+	if (test__start_subtest("cls_redirect_subprogs"))
+		test_cls_redirect_subprogs();
+}
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tool=
s/testing/selftests/bpf/progs/test_cls_redirect.c
index f0b72e86bee5..c9f8464996ea 100644
--- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -22,6 +22,12 @@
=20
 #include "test_cls_redirect.h"
=20
+#ifdef SUBPROGS
+#define INLINING __noinline
+#else
+#define INLINING __always_inline
+#endif
+
 #define offsetofend(TYPE, MEMBER) \
 	(offsetof(TYPE, MEMBER) + sizeof((((TYPE *)0)->MEMBER)))
=20
@@ -125,7 +131,7 @@ typedef struct buf {
 	uint8_t *const tail;
 } buf_t;
=20
-static size_t buf_off(const buf_t *buf)
+static __always_inline size_t buf_off(const buf_t *buf)
 {
 	/* Clang seems to optimize constructs like
 	 *    a - b + c
@@ -145,7 +151,7 @@ static size_t buf_off(const buf_t *buf)
 	return off;
 }
=20
-static bool buf_copy(buf_t *buf, void *dst, size_t len)
+static __always_inline bool buf_copy(buf_t *buf, void *dst, size_t len)
 {
 	if (bpf_skb_load_bytes(buf->skb, buf_off(buf), dst, len)) {
 		return false;
@@ -155,7 +161,7 @@ static bool buf_copy(buf_t *buf, void *dst, size_t le=
n)
 	return true;
 }
=20
-static bool buf_skip(buf_t *buf, const size_t len)
+static __always_inline bool buf_skip(buf_t *buf, const size_t len)
 {
 	/* Check whether off + len is valid in the non-linear part. */
 	if (buf_off(buf) + len > buf->skb->len) {
@@ -173,7 +179,7 @@ static bool buf_skip(buf_t *buf, const size_t len)
  * If scratch is not NULL, the function will attempt to load non-linear
  * data via bpf_skb_load_bytes. On success, scratch is returned.
  */
-static void *buf_assign(buf_t *buf, const size_t len, void *scratch)
+static __always_inline void *buf_assign(buf_t *buf, const size_t len, vo=
id *scratch)
 {
 	if (buf->head + len > buf->tail) {
 		if (scratch =3D=3D NULL) {
@@ -188,7 +194,7 @@ static void *buf_assign(buf_t *buf, const size_t len,=
 void *scratch)
 	return ptr;
 }
=20
-static bool pkt_skip_ipv4_options(buf_t *buf, const struct iphdr *ipv4)
+static INLINING bool pkt_skip_ipv4_options(buf_t *buf, const struct iphd=
r *ipv4)
 {
 	if (ipv4->ihl <=3D 5) {
 		return true;
@@ -197,13 +203,13 @@ static bool pkt_skip_ipv4_options(buf_t *buf, const=
 struct iphdr *ipv4)
 	return buf_skip(buf, (ipv4->ihl - 5) * 4);
 }
=20
-static bool ipv4_is_fragment(const struct iphdr *ip)
+static INLINING bool ipv4_is_fragment(const struct iphdr *ip)
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
@@ -222,7 +228,7 @@ static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struc=
t iphdr *scratch)
 }
=20
 /* Parse the L4 ports from a packet, assuming a layout like TCP or UDP. =
*/
-static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *ports)
+static INLINING bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *p=
orts)
 {
 	if (!buf_copy(pkt, ports, sizeof(*ports))) {
 		return false;
@@ -237,7 +243,7 @@ static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_=
ports_t *ports)
 	return true;
 }
=20
-static uint16_t pkt_checksum_fold(uint32_t csum)
+static INLINING uint16_t pkt_checksum_fold(uint32_t csum)
 {
 	/* The highest reasonable value for an IPv4 header
 	 * checksum requires two folds, so we just do that always.
@@ -247,7 +253,7 @@ static uint16_t pkt_checksum_fold(uint32_t csum)
 	return (uint16_t)~csum;
 }
=20
-static void pkt_ipv4_checksum(struct iphdr *iph)
+static INLINING void pkt_ipv4_checksum(struct iphdr *iph)
 {
 	iph->check =3D 0;
=20
@@ -268,10 +274,11 @@ static void pkt_ipv4_checksum(struct iphdr *iph)
 	iph->check =3D pkt_checksum_fold(acc);
 }
=20
-static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
-					    const struct ipv6hdr *ipv6,
-					    uint8_t *upper_proto,
-					    bool *is_fragment)
+static INLINING
+bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
+				     const struct ipv6hdr *ipv6,
+				     uint8_t *upper_proto,
+				     bool *is_fragment)
 {
 	/* We understand five extension headers.
 	 * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
@@ -336,7 +343,7 @@ static bool pkt_skip_ipv6_extension_headers(buf_t *pk=
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
@@ -354,20 +361,20 @@ pkt_parse_ipv6(buf_t *pkt, struct ipv6hdr *scratch,=
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
+static INLINING metrics_t *get_global_metrics(void)
 {
 	uint64_t key =3D 0;
 	return bpf_map_lookup_elem(&metrics_map, &key);
 }
=20
-static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *enca=
p)
+static INLINING ret_t accept_locally(struct __sk_buff *skb, encap_header=
s_t *encap)
 {
 	const int payload_off =3D
 		sizeof(*encap) +
@@ -388,8 +395,8 @@ static ret_t accept_locally(struct __sk_buff *skb, en=
cap_headers_t *encap)
 	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
 }
=20
-static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *en=
cap,
-			      struct in_addr *next_hop, metrics_t *metrics)
+static INLINING ret_t forward_with_gre(struct __sk_buff *skb, encap_head=
ers_t *encap,
+				       struct in_addr *next_hop, metrics_t *metrics)
 {
 	metrics->forwarded_packets_total_gre++;
=20
@@ -509,8 +516,8 @@ static ret_t forward_with_gre(struct __sk_buff *skb, =
encap_headers_t *encap,
 	return bpf_redirect(skb->ifindex, 0);
 }
=20
-static ret_t forward_to_next_hop(struct __sk_buff *skb, encap_headers_t =
*encap,
-				 struct in_addr *next_hop, metrics_t *metrics)
+static INLINING ret_t forward_to_next_hop(struct __sk_buff *skb, encap_h=
eaders_t *encap,
+					  struct in_addr *next_hop, metrics_t *metrics)
 {
 	/* swap L2 addresses */
 	/* This assumes that packets are received from a router.
@@ -546,7 +553,7 @@ static ret_t forward_to_next_hop(struct __sk_buff *sk=
b, encap_headers_t *encap,
 	return bpf_redirect(skb->ifindex, 0);
 }
=20
-static ret_t skip_next_hops(buf_t *pkt, int n)
+static INLINING ret_t skip_next_hops(buf_t *pkt, int n)
 {
 	switch (n) {
 	case 1:
@@ -566,8 +573,8 @@ static ret_t skip_next_hops(buf_t *pkt, int n)
  * pkt is positioned just after the variable length GLB header
  * iff the call is successful.
  */
-static ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
-			  struct in_addr *next_hop)
+static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
+				   struct in_addr *next_hop)
 {
 	if (encap->unigue.next_hop > encap->unigue.hop_count) {
 		return TC_ACT_SHOT;
@@ -601,8 +608,8 @@ static ret_t get_next_hop(buf_t *pkt, encap_headers_t=
 *encap,
  * return value, and calling code works while still being "generic" to
  * IPv4 and IPv6.
  */
-static uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
-			   uint64_t iphlen, uint16_t sport, uint16_t dport)
+static INLINING uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *=
iph,
+				    uint64_t iphlen, uint16_t sport, uint16_t dport)
 {
 	switch (iphlen) {
 	case sizeof(struct iphdr): {
@@ -630,9 +637,9 @@ static uint64_t fill_tuple(struct bpf_sock_tuple *tup=
le, void *iph,
 	}
 }
=20
-static verdict_t classify_tcp(struct __sk_buff *skb,
-			      struct bpf_sock_tuple *tuple, uint64_t tuplen,
-			      void *iph, struct tcphdr *tcp)
+static INLINING verdict_t classify_tcp(struct __sk_buff *skb,
+				       struct bpf_sock_tuple *tuple, uint64_t tuplen,
+				       void *iph, struct tcphdr *tcp)
 {
 	struct bpf_sock *sk =3D
 		bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
@@ -663,8 +670,8 @@ static verdict_t classify_tcp(struct __sk_buff *skb,
 	return UNKNOWN;
 }
=20
-static verdict_t classify_udp(struct __sk_buff *skb,
-			      struct bpf_sock_tuple *tuple, uint64_t tuplen)
+static INLINING verdict_t classify_udp(struct __sk_buff *skb,
+				       struct bpf_sock_tuple *tuple, uint64_t tuplen)
 {
 	struct bpf_sock *sk =3D
 		bpf_sk_lookup_udp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
@@ -681,9 +688,9 @@ static verdict_t classify_udp(struct __sk_buff *skb,
 	return UNKNOWN;
 }
=20
-static verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto,
-			       struct bpf_sock_tuple *tuple, uint64_t tuplen,
-			       metrics_t *metrics)
+static INLINING verdict_t classify_icmp(struct __sk_buff *skb, uint8_t p=
roto,
+					struct bpf_sock_tuple *tuple, uint64_t tuplen,
+					metrics_t *metrics)
 {
 	switch (proto) {
 	case IPPROTO_TCP:
@@ -698,7 +705,7 @@ static verdict_t classify_icmp(struct __sk_buff *skb,=
 uint8_t proto,
 	}
 }
=20
-static verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
+static INLINING verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
 {
 	struct icmphdr icmp;
 	if (!buf_copy(pkt, &icmp, sizeof(icmp))) {
@@ -745,7 +752,7 @@ static verdict_t process_icmpv4(buf_t *pkt, metrics_t=
 *metrics)
 			     sizeof(tuple.ipv4), metrics);
 }
=20
-static verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
+static INLINING verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
 {
 	struct icmp6hdr icmp6;
 	if (!buf_copy(pkt, &icmp6, sizeof(icmp6))) {
@@ -797,8 +804,8 @@ static verdict_t process_icmpv6(buf_t *pkt, metrics_t=
 *metrics)
 			     metrics);
 }
=20
-static verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t iphlen,
-			     metrics_t *metrics)
+static INLINING verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t ip=
hlen,
+				      metrics_t *metrics)
 {
 	metrics->l4_protocol_packets_total_tcp++;
=20
@@ -819,8 +826,8 @@ static verdict_t process_tcp(buf_t *pkt, void *iph, u=
int64_t iphlen,
 	return classify_tcp(pkt->skb, &tuple, tuplen, iph, tcp);
 }
=20
-static verdict_t process_udp(buf_t *pkt, void *iph, uint64_t iphlen,
-			     metrics_t *metrics)
+static INLINING verdict_t process_udp(buf_t *pkt, void *iph, uint64_t ip=
hlen,
+				      metrics_t *metrics)
 {
 	metrics->l4_protocol_packets_total_udp++;
=20
@@ -837,7 +844,7 @@ static verdict_t process_udp(buf_t *pkt, void *iph, u=
int64_t iphlen,
 	return classify_udp(pkt->skb, &tuple, tuplen);
 }
=20
-static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
+static INLINING verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
 {
 	metrics->l3_protocol_packets_total_ipv4++;
=20
@@ -874,7 +881,7 @@ static verdict_t process_ipv4(buf_t *pkt, metrics_t *=
metrics)
 	}
 }
=20
-static verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
+static INLINING verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
 {
 	metrics->l3_protocol_packets_total_ipv6++;
=20
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs=
.c b/tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c
new file mode 100644
index 000000000000..eed26b70e3a2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c
@@ -0,0 +1,2 @@
+#define SUBPROGS
+#include "test_cls_redirect.c"
--=20
2.24.1

