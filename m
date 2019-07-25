Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10603752B8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 17:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389204AbfGYPeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 11:34:02 -0400
Received: from mail-qt1-f202.google.com ([209.85.160.202]:37099 "EHLO
        mail-qt1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389125AbfGYPd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 11:33:59 -0400
Received: by mail-qt1-f202.google.com with SMTP id 41so38938873qtm.4
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 08:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Fq6IZgW4iOignB5P3NDDYUqS650/L2ZWasm6xkd4wQI=;
        b=r5kb15TxNspk5pTGy0JZeAumNmle01ejUcMAQjKiQxg1xN7QvTX2MJW5aHm49u7X2Z
         Mh6OeTrsW4bSmuBRpyINHj9bE/7NutGmT76yNyDCz0IGCNKuOtLoRDuXFsPRbYfb7D+x
         pBF+LS7GTTYkh+2LPLRtsEUdyePdYQPLH6dCfbFhvG8prnWhgE/KShizYPF5u1czQr5+
         +pY1D+pPysQ2VFxMx+uyw9x7jmNTSpwIr6EewpjWcgWbBssNIF/704KCewibfrPwsoYa
         lfZ92PYveB10vpFiknbspznULh+/euWSTCGdaj/AuLPX198Rqy6U9JvXGn34xiKGIVj4
         E+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Fq6IZgW4iOignB5P3NDDYUqS650/L2ZWasm6xkd4wQI=;
        b=DKQRf6GatIkIj2fPzUbxdOP6+yz6sUVOT2HbY/O0pFLrHFXmOO10gIIl3W59vMHlbF
         n6GId8bS5YStTvF7dj59pkrjT+c9SorJDlW/oBro6QJeMegRZgOYfbpoOeZvA+ecV5Li
         QDPzflYhZEMeOg7bPPdbLMGEFIpKDqvgvxE2I8GNSbaSzS/I+b9jUdnzOD/mWk6vMQO6
         R8UvjJM2cauNE6gpdd1QlZAi74XH7Xdi5jL93k64tHlHRyfp6WjxhPn2KYqErA3AtpRS
         GM53NGi+DiS7vOxnHF2JI/27zvgRGHDsMnaKZ4tL7OnR/n6kT0bgaIMma32P9SkdtlJt
         Gcxw==
X-Gm-Message-State: APjAAAUHrcjedCS/ViTIDRLtsu80kXxlICMoeLKaz2N1PCRKnaSU702W
        pg7aJeyPxgP5QzzRDZakNl/T2i4hSy2wJ5vycpqe5tZijc9DQhkhvoyD/bJfQiJgSlewy++dxEM
        FWNDqMg14iGtuwK6IGCceb++xtiHBRvdz7vr3Ti75Vmbd9Gq5j2dDDw==
X-Google-Smtp-Source: APXvYqwDKwqRzE9v9RUJzcj/K/w9EIFKEtuCpO0u5/zvR3exREZZ2yrLLLGj2SB/WXv6Zcw+Ncl5JJA=
X-Received: by 2002:a05:620a:4:: with SMTP id j4mr58927359qki.269.1564068838815;
 Thu, 25 Jul 2019 08:33:58 -0700 (PDT)
Date:   Thu, 25 Jul 2019 08:33:40 -0700
In-Reply-To: <20190725153342.3571-1-sdf@google.com>
Message-Id: <20190725153342.3571-6-sdf@google.com>
Mime-Version: 1.0
References: <20190725153342.3571-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next v2 5/7] selftests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Song Liu <songliubraving@fb.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_flow.c: exit early unless FLOW_DISSECTOR_F_PARSE_1ST_FRAG is passed
in flags. Also, set ip_proto earlier, this makes sure we have correct
value with fragmented packets.

Add selftest cases to test ipv4/ipv6 fragments and skip eth_get_headlen
tests that don't have FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag.

eth_get_headlen calls flow dissector with
FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag so we can't run tests that
have different set of input flags against it.

v2:
 * sefltests -> selftests (Willem de Bruijn)
 * Reword a comment about eth_get_headlen flags (Song Liu)

Acked-by: Willem de Bruijn <willemb@google.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/flow_dissector.c | 132 +++++++++++++++++-
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 +++-
 2 files changed, 153 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index c938283ac232..f93a115db650 100644
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -5,6 +5,10 @@
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 
+#ifndef IP_MF
+#define IP_MF 0x2000
+#endif
+
 #define CHECK_FLOW_KEYS(desc, got, expected)				\
 	CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) != 0,		\
 	      desc,							\
@@ -49,6 +53,18 @@ struct ipv6_pkt {
 	struct tcphdr tcp;
 } __packed;
 
+struct ipv6_frag_pkt {
+	struct ethhdr eth;
+	struct ipv6hdr iph;
+	struct frag_hdr {
+		__u8 nexthdr;
+		__u8 reserved;
+		__be16 frag_off;
+		__be32 identification;
+	} ipf;
+	struct tcphdr tcp;
+} __packed;
+
 struct dvlan_ipv6_pkt {
 	struct ethhdr eth;
 	__u16 vlan_tci;
@@ -65,9 +81,11 @@ struct test {
 		struct ipv4_pkt ipv4;
 		struct svlan_ipv4_pkt svlan_ipv4;
 		struct ipv6_pkt ipv6;
+		struct ipv6_frag_pkt ipv6_frag;
 		struct dvlan_ipv6_pkt dvlan_ipv6;
 	} pkt;
 	struct bpf_flow_keys keys;
+	__u32 flags;
 };
 
 #define VLAN_HLEN	4
@@ -143,6 +161,102 @@ struct test tests[] = {
 			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
 		},
 	},
+	{
+		.name = "ipv4-frag",
+		.pkt.ipv4 = {
+			.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
+			.iph.ihl = 5,
+			.iph.protocol = IPPROTO_TCP,
+			.iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
+			.iph.frag_off = __bpf_constant_htons(IP_MF),
+			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
+		},
+		.keys = {
+			.flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
+			.nhoff = ETH_HLEN,
+			.thoff = ETH_HLEN + sizeof(struct iphdr),
+			.addr_proto = ETH_P_IP,
+			.ip_proto = IPPROTO_TCP,
+			.n_proto = __bpf_constant_htons(ETH_P_IP),
+			.is_frag = true,
+			.is_first_frag = true,
+			.sport = 80,
+			.dport = 8080,
+		},
+		.flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
+	},
+	{
+		.name = "ipv4-no-frag",
+		.pkt.ipv4 = {
+			.eth.h_proto = __bpf_constant_htons(ETH_P_IP),
+			.iph.ihl = 5,
+			.iph.protocol = IPPROTO_TCP,
+			.iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
+			.iph.frag_off = __bpf_constant_htons(IP_MF),
+			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
+		},
+		.keys = {
+			.nhoff = ETH_HLEN,
+			.thoff = ETH_HLEN + sizeof(struct iphdr),
+			.addr_proto = ETH_P_IP,
+			.ip_proto = IPPROTO_TCP,
+			.n_proto = __bpf_constant_htons(ETH_P_IP),
+			.is_frag = true,
+			.is_first_frag = true,
+		},
+	},
+	{
+		.name = "ipv6-frag",
+		.pkt.ipv6_frag = {
+			.eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.iph.nexthdr = IPPROTO_FRAGMENT,
+			.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
+			.ipf.nexthdr = IPPROTO_TCP,
+			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
+		},
+		.keys = {
+			.flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
+			.nhoff = ETH_HLEN,
+			.thoff = ETH_HLEN + sizeof(struct ipv6hdr) +
+				sizeof(struct frag_hdr),
+			.addr_proto = ETH_P_IPV6,
+			.ip_proto = IPPROTO_TCP,
+			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.is_frag = true,
+			.is_first_frag = true,
+			.sport = 80,
+			.dport = 8080,
+		},
+		.flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
+	},
+	{
+		.name = "ipv6-no-frag",
+		.pkt.ipv6_frag = {
+			.eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.iph.nexthdr = IPPROTO_FRAGMENT,
+			.iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
+			.ipf.nexthdr = IPPROTO_TCP,
+			.tcp.doff = 5,
+			.tcp.source = 80,
+			.tcp.dest = 8080,
+		},
+		.keys = {
+			.nhoff = ETH_HLEN,
+			.thoff = ETH_HLEN + sizeof(struct ipv6hdr) +
+				sizeof(struct frag_hdr),
+			.addr_proto = ETH_P_IPV6,
+			.ip_proto = IPPROTO_TCP,
+			.n_proto = __bpf_constant_htons(ETH_P_IPV6),
+			.is_frag = true,
+			.is_first_frag = true,
+		},
+	},
 };
 
 static int create_tap(const char *ifname)
@@ -225,6 +339,13 @@ void test_flow_dissector(void)
 			.data_size_in = sizeof(tests[i].pkt),
 			.data_out = &flow_keys,
 		};
+		static struct bpf_flow_keys ctx = {};
+
+		if (tests[i].flags) {
+			tattr.ctx_in = &ctx;
+			tattr.ctx_size_in = sizeof(ctx);
+			ctx.flags = tests[i].flags;
+		}
 
 		err = bpf_prog_test_run_xattr(&tattr);
 		CHECK_ATTR(tattr.data_size_out != sizeof(flow_keys) ||
@@ -251,10 +372,19 @@ void test_flow_dissector(void)
 	CHECK(err, "ifup", "err %d errno %d\n", err, errno);
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
-		struct bpf_flow_keys flow_keys = {};
+		/* Keep in sync with 'flags' from eth_get_headlen. */
+		__u32 eth_get_headlen_flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG;
 		struct bpf_prog_test_run_attr tattr = {};
+		struct bpf_flow_keys flow_keys = {};
 		__u32 key = 0;
 
+		/* For skb-less case we can't pass input flags; run
+		 * only the tests that have a matching set of flags.
+		 */
+
+		if (tests[i].flags != eth_get_headlen_flags)
+			continue;
+
 		err = tx_tap(tap_fd, &tests[i].pkt, sizeof(tests[i].pkt));
 		CHECK(err < 0, "tx_tap", "err %d errno %d\n", err, errno);
 
diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
index 5ae485a6af3f..0eabe5e57944 100644
--- a/tools/testing/selftests/bpf/progs/bpf_flow.c
+++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
@@ -153,7 +153,6 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
 	struct tcphdr *tcp, _tcp;
 	struct udphdr *udp, _udp;
 
-	keys->ip_proto = proto;
 	switch (proto) {
 	case IPPROTO_ICMP:
 		icmp = bpf_flow_dissect_get_header(skb, sizeof(*icmp), &_icmp);
@@ -231,7 +230,6 @@ static __always_inline int parse_ipv6_proto(struct __sk_buff *skb, __u8 nexthdr)
 {
 	struct bpf_flow_keys *keys = skb->flow_keys;
 
-	keys->ip_proto = nexthdr;
 	switch (nexthdr) {
 	case IPPROTO_HOPOPTS:
 	case IPPROTO_DSTOPTS:
@@ -266,6 +264,7 @@ PROG(IP)(struct __sk_buff *skb)
 	keys->addr_proto = ETH_P_IP;
 	keys->ipv4_src = iph->saddr;
 	keys->ipv4_dst = iph->daddr;
+	keys->ip_proto = iph->protocol;
 
 	keys->thoff += iph->ihl << 2;
 	if (data + keys->thoff > data_end)
@@ -273,13 +272,19 @@ PROG(IP)(struct __sk_buff *skb)
 
 	if (iph->frag_off & bpf_htons(IP_MF | IP_OFFSET)) {
 		keys->is_frag = true;
-		if (iph->frag_off & bpf_htons(IP_OFFSET))
+		if (iph->frag_off & bpf_htons(IP_OFFSET)) {
 			/* From second fragment on, packets do not have headers
 			 * we can parse.
 			 */
 			done = true;
-		else
+		} else {
 			keys->is_first_frag = true;
+			/* No need to parse fragmented packet unless
+			 * explicitly asked for.
+			 */
+			if (!(keys->flags & FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
+				done = true;
+		}
 	}
 
 	if (done)
@@ -301,6 +306,7 @@ PROG(IPV6)(struct __sk_buff *skb)
 	memcpy(&keys->ipv6_src, &ip6h->saddr, 2*sizeof(ip6h->saddr));
 
 	keys->thoff += sizeof(struct ipv6hdr);
+	keys->ip_proto = ip6h->nexthdr;
 
 	return parse_ipv6_proto(skb, ip6h->nexthdr);
 }
@@ -317,7 +323,8 @@ PROG(IPV6OP)(struct __sk_buff *skb)
 	/* hlen is in 8-octets and does not include the first 8 bytes
 	 * of the header
 	 */
-	skb->flow_keys->thoff += (1 + ip6h->hdrlen) << 3;
+	keys->thoff += (1 + ip6h->hdrlen) << 3;
+	keys->ip_proto = ip6h->nexthdr;
 
 	return parse_ipv6_proto(skb, ip6h->nexthdr);
 }
@@ -333,9 +340,18 @@ PROG(IPV6FR)(struct __sk_buff *skb)
 
 	keys->thoff += sizeof(*fragh);
 	keys->is_frag = true;
-	if (!(fragh->frag_off & bpf_htons(IP6_OFFSET)))
+	keys->ip_proto = fragh->nexthdr;
+
+	if (!(fragh->frag_off & bpf_htons(IP6_OFFSET))) {
 		keys->is_first_frag = true;
 
+		/* No need to parse fragmented packet unless
+		 * explicitly asked for.
+		 */
+		if (!(keys->flags & FLOW_DISSECTOR_F_PARSE_1ST_FRAG))
+			return export_flow_keys(keys, BPF_OK);
+	}
+
 	return parse_ipv6_proto(skb, fragh->nexthdr);
 }
 
-- 
2.22.0.657.g960e92d24f-goog

