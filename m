Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF18B73479
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfGXRAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:00:35 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:37025 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbfGXRAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 13:00:35 -0400
Received: by mail-pf1-f201.google.com with SMTP id x18so28917668pfj.4
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 10:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WzUKL43PtR3kawunxRxpZ6BQdnRq3E6WalU2t+7zPeA=;
        b=YL7vEhYiQrhncmQPkVY8yoCCVUEkIruZSD3GzhdNf1r/MAw0/TCidL5m0xRrypaUb8
         zVSMC0rTBWSzhQF2vKBTz3GkT8nedkxdphmLIxB6SbJ5iZ0+t7s5KsKSOZ+sGuC6QOGN
         6JJWuxghUxNdafGZSn5GuwEanXr6Y5hYHK1GSt1riIV9uBEOlHOBUGJLDo16zOB/iGYb
         oo7EApjsG0Hlv5XfPm88hLHsuTWlthk7grg7RDnZEkF5PHhx+mVe3cs9W3gqGTEp0CtN
         TAEUBFfMugUL+ZbErtD96HK0NEnpjubhhRifFLQ8EZX1sqqaRaB4RESz0Nsg0cMNW7pZ
         PyCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WzUKL43PtR3kawunxRxpZ6BQdnRq3E6WalU2t+7zPeA=;
        b=TlXz0B5L1SoPPx8aaFgUAU2/PlJNlTRTgKU9dQrPDKkZl/2h14NtQUey8TGpOhBzWx
         /Ws5MAfkcSyIgA11gczkHyfPNJ0+sZynPyN6/GKTZrR7uYOUkPgVeQM6/A8I3NiTfBwa
         ThCF/uiGP5OIY5RmTxOlTEBJo66qlCWH2xSKqlaVIN1Dm0HnamLq/i0mz/g/QbquFbNd
         KP/U+tPEB457og6fHDixkZ6BxBE8IhjpSTtzFA8qmvc8WPO5mh7flvtjUkvHe8aX7Ec6
         lyRmV37b09ClcD49R4LXTebwxfA+nYIDWn1+IPc21W85cigQDzgnKgiY9HMp9v/VX3Zl
         f4Xg==
X-Gm-Message-State: APjAAAVWChSD9y/wIbWDb5mlHi1GHiqY7VDW5K1yJ7so1pCgx7ygiSum
        SauQ1XdfF+XD943KqJuugVNThBL80XMqIbnyg3UKcJPAktXIEFnXsF5yTOeqrUphIITyfOzqNUl
        3koL1OM+DudyrzswfA5JrX5jitt6vpnR1ejmt0EMaFr5XfeD2dFTAeQ==
X-Google-Smtp-Source: APXvYqzpH/AOC1ONnPfAydA57Rw5d2usWoJ5bbr3of7K9snhg+ihye37eXywlkrRHQSHzhPhku8S1Y4=
X-Received: by 2002:a63:2bd2:: with SMTP id r201mr81004299pgr.193.1563987633597;
 Wed, 24 Jul 2019 10:00:33 -0700 (PDT)
Date:   Wed, 24 Jul 2019 10:00:16 -0700
In-Reply-To: <20190724170018.96659-1-sdf@google.com>
Message-Id: <20190724170018.96659-6-sdf@google.com>
Mime-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 5/7] sefltests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
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

Cc: Willem de Bruijn <willemb@google.com>
Cc: Petar Penkov <ppenkov@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 .../selftests/bpf/prog_tests/flow_dissector.c | 129 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 +++-
 2 files changed, 151 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
index c938283ac232..966cb3b06870 100644
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
@@ -255,6 +376,14 @@ void test_flow_dissector(void)
 		struct bpf_prog_test_run_attr tattr = {};
 		__u32 key = 0;
 
+		/* Don't run tests that are not marked as
+		 * FLOW_DISSECTOR_F_PARSE_1ST_FRAG; eth_get_headlen
+		 * sets this flag.
+		 */
+
+		if (tests[i].flags != FLOW_DISSECTOR_F_PARSE_1ST_FRAG)
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

