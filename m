Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FF11B7E6B
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 20:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729067AbgDXS4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 14:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbgDXS4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 14:56:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F187DC09B048
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 11:56:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g12so12116451wmh.3
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 11:56:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eMIdez9NA4MQxqrL7/+ldqb4t5Y4bdW3NZ9rgnqYLiI=;
        b=mCK1UtkJAjx0SbU24yK/8t2qTheAZhEK5bJ1fEWTCJbczzyU3mGh7psUPDxHbTiUxg
         abhL8HSOACX53TF16emHLsVoHhVG7Lr73hwwxVB1QgurTDOqkOykvZyUCuVJzqlQQMSw
         ImGYHc96YttwbxpYOJ+EpJkmeSMj0e9FBV0pw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eMIdez9NA4MQxqrL7/+ldqb4t5Y4bdW3NZ9rgnqYLiI=;
        b=VulWxjgUY3fIK5zDJyNmM5IholV9vb7IFZ09j9hHu7Nlcz6I6+3FONRkoUypYAWlgG
         zdTNRedKfMezLWGZJnplmRZBb2HiE4fCb2cADHTU8KbWa65Ako3hLk7gmbq3bVeeIFO4
         VAsxQJMByL1WIc1mRHpN1a5/lKqwc9pRPFsrju6dc/c0+SCkjy6geM1CQnZHUq5Y+TTQ
         MT1XEJ7A2X7Mtj1zMKHV+d1VjMsNapLkTeYdlytZOdh1cCfsscO3oFdcxyQX0KPbqKAe
         Yay7e3eoPnctA4LaQdZzORHkZpF1phNGKic20xIxjh59q5F9rW9SlEfi5qM7BduPDlyT
         p9oA==
X-Gm-Message-State: AGi0PuZwuEfUJNR6BU/W2tVdGj3Wvj/NvnnPUWLoSzKV/EkpGjmP9ZJB
        iPmxYRA5f8cBw86aafoA327zBg==
X-Google-Smtp-Source: APiQypINVerJ6iSu4+D4P2inrHmqIs2i3Q3p5XxaKXfC/YBqeW7WD24Xj1/HvpgnQ75eTIqfNew75w==
X-Received: by 2002:a1c:2383:: with SMTP id j125mr11524363wmj.6.1587754566863;
        Fri, 24 Apr 2020 11:56:06 -0700 (PDT)
Received: from antares.lan (111.253.187.81.in-addr.arpa. [81.187.253.111])
        by smtp.gmail.com with ESMTPSA id r17sm9263875wrn.43.2020.04.24.11.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 11:56:05 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     theojulienne@github.com, Lorenz Bauer <lmb@cloudflare.com>,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH 1/1] selftests/bpf: add cls_redirect classifier
Date:   Fri, 24 Apr 2020 19:55:55 +0100
Message-Id: <20200424185556.7358-2-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424185556.7358-1-lmb@cloudflare.com>
References: <20200424185556.7358-1-lmb@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cls_redirect is a TC clsact based replacement for the glb-redirect iptables
module available at [1]. It enables what GitHub calls "second chance"
flows [2], similarly proposed by the Beamer paper [3]. In contrast to
glb-redirect, it also supports migrating UDP flows as long as connected
sockets are used. cls_redirect is in production at Cloudflare, as part of
our own L4 load balancer.

We have modified the encapsulation format slightly from glb-redirect:
glbgue_chained_routing.private_data_type has been repurposed to form a
version field and several flags. Both have been arranged in a way that
a private_data_type value of zero matches the current glb-redirect
behaviour. This means that cls_redirect will understand packets in
glb-redirect format, but not vice versa.

The test suite only covers basic features. For example, cls_redirect will
correctly forward path MTU discovery packets, but this is not exercised.
It is also possible to switch the encapsulation format to GRE on the last
hop, which is also not tested.

There are two major distinctions from glb-redirect: first, cls_redirect
relies on receiving encapsulated packets directly from a router. This is
because we don't have access to the neighbour tables from BPF, yet. See
forward_to_next_hop for details. Second, cls_redirect performs decapsulation
instead of using separate ipip and sit tunnel devices. This
avoids issues with the sit tunnel [4] and makes deploying the classifier
easier: decapsulated packets appear on the same interface, so existing
firewall rules continue to work as expected.

The code base started it's life on v4.19, so there are most likely still
hold overs from old workarounds. In no particular order:

- The function buf_off is required to defeat a clang optimization
  that leads to the verifier rejecting the program due to pointer
  arithmetic in the wrong order.

- The function pkt_parse_ipv6 is force inlined, because it would
  otherwise be rejected due to returning a pointer to stack memory.

- The functions fill_tuple and classify_tcp contain kludges, because
  we've run out of function arguments.

- The logic in general is rather nested, due to verifier restrictions.
  I think this is either because the verifier loses track of constants
  on the stack, or because it can't track enum like variables.

1: https://github.com/github/glb-director/tree/master/src/glb-redirect
2: https://github.com/github/glb-director/blob/master/docs/development/second-chance-design.md
3: https://www.usenix.org/conference/nsdi18/presentation/olteanu
4: https://github.com/github/glb-director/issues/64

Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
---
 .../selftests/bpf/prog_tests/cls_redirect.c   |  456 +++++++
 .../selftests/bpf/progs/test_cls_redirect.c   | 1058 +++++++++++++++++
 .../selftests/bpf/progs/test_cls_redirect.h   |   54 +
 tools/testing/selftests/bpf/test_progs.h      |    7 +
 4 files changed, 1575 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect.h

diff --git a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
new file mode 100644
index 000000000000..f259085cca6a
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
@@ -0,0 +1,456 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2020 Cloudflare
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <string.h>
+
+#include <linux/pkt_cls.h>
+
+#include <test_progs.h>
+
+#include "progs/test_cls_redirect.h"
+#include "test_cls_redirect.skel.h"
+
+#define ENCAP_IP INADDR_LOOPBACK
+#define ENCAP_PORT (1234)
+
+struct addr_port {
+	in_port_t port;
+	union {
+		struct in_addr in_addr;
+		struct in6_addr in6_addr;
+	};
+};
+
+struct tuple {
+	int family;
+	struct addr_port src;
+	struct addr_port dst;
+};
+
+static int start_server(const struct sockaddr *addr, socklen_t len, int type)
+{
+	int fd = socket(addr->sa_family, type, 0);
+	if (CHECK_FAIL(fd == -1))
+		return -1;
+	if (CHECK_FAIL(bind(fd, addr, len) == -1))
+		goto err;
+	if (type == SOCK_STREAM && CHECK_FAIL(listen(fd, 128) == -1))
+		goto err;
+
+	return fd;
+
+err:
+	close(fd);
+	return -1;
+}
+
+static int connect_to_server(const struct sockaddr *addr, socklen_t len,
+			     int type)
+{
+	int fd = socket(addr->sa_family, type, 0);
+	if (CHECK_FAIL(fd == -1))
+		return -1;
+	if (CHECK_FAIL(connect(fd, addr, len)))
+		goto err;
+
+	return fd;
+
+err:
+	close(fd);
+	return -1;
+}
+
+static bool fill_addr_port(const struct sockaddr *sa, struct addr_port *ap)
+{
+	const struct sockaddr_in6 *in6;
+	const struct sockaddr_in *in;
+
+	switch (sa->sa_family) {
+	case AF_INET:
+		in = (const struct sockaddr_in *)sa;
+		ap->in_addr = in->sin_addr;
+		ap->port = in->sin_port;
+		return true;
+
+	case AF_INET6:
+		in6 = (const struct sockaddr_in6 *)sa;
+		ap->in6_addr = in6->sin6_addr;
+		ap->port = in6->sin6_port;
+		return true;
+
+	default:
+		return false;
+	}
+}
+
+static bool set_up_conn(const struct sockaddr *addr, socklen_t len, int type,
+			int *server, int *conn, struct tuple *tuple)
+{
+	struct sockaddr_storage ss;
+	socklen_t slen = sizeof(ss);
+	struct sockaddr *sa = (struct sockaddr *)&ss;
+
+	*server = start_server(addr, len, type);
+	if (*server < 0)
+		return false;
+
+	if (CHECK_FAIL(getsockname(*server, sa, &slen)))
+		goto close_server;
+
+	*conn = connect_to_server(sa, slen, type);
+	if (*conn < 0)
+		goto close_server;
+
+	/* We want to simulate packets arriving at conn, so we have to
+	 * swap src and dst.
+	 */
+	slen = sizeof(ss);
+	if (CHECK_FAIL(getsockname(*conn, sa, &slen)))
+		goto close_conn;
+
+	if (CHECK_FAIL(!fill_addr_port(sa, &tuple->dst)))
+		goto close_conn;
+
+	slen = sizeof(ss);
+	if (CHECK_FAIL(getpeername(*conn, sa, &slen)))
+		goto close_conn;
+
+	if (CHECK_FAIL(!fill_addr_port(sa, &tuple->src)))
+		goto close_conn;
+
+	tuple->family = ss.ss_family;
+	return true;
+
+close_conn:
+	close(*conn);
+	*conn = -1;
+close_server:
+	close(*server);
+	*server = -1;
+	return false;
+}
+
+static socklen_t prepare_addr(struct sockaddr_storage *addr, int family)
+{
+	struct sockaddr_in *addr4;
+	struct sockaddr_in6 *addr6;
+
+	switch (family) {
+	case AF_INET:
+		addr4 = (struct sockaddr_in *)addr;
+		memset(addr4, 0, sizeof(*addr4));
+		addr4->sin_family = family;
+		addr4->sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+		return sizeof(*addr4);
+	case AF_INET6:
+		addr6 = (struct sockaddr_in6 *)addr;
+		memset(addr6, 0, sizeof(*addr6));
+		addr6->sin6_family = family;
+		addr6->sin6_addr = in6addr_loopback;
+		return sizeof(*addr6);
+	default:
+		fprintf(stderr, "Invalid family %d", family);
+		return 0;
+	}
+}
+
+static bool was_decapsulated(struct bpf_prog_test_run_attr *tattr)
+{
+	return tattr->data_size_out < tattr->data_size_in;
+}
+
+enum type {
+	UDP,
+	TCP,
+	__NR_KIND,
+};
+
+enum hops {
+	NO_HOPS,
+	ONE_HOP,
+};
+
+enum flags {
+	NONE,
+	SYN,
+	ACK,
+};
+
+enum conn {
+	KNOWN_CONN,
+	UNKNOWN_CONN,
+};
+
+enum result {
+	ACCEPT,
+	FORWARD,
+};
+
+struct test_cfg {
+	enum type type;
+	enum result result;
+	enum conn conn;
+	enum hops hops;
+	enum flags flags;
+};
+
+static int test_str(void *buf, size_t len, const struct test_cfg *test,
+		    int family)
+{
+	const char *family_str, *type, *conn, *hops, *result, *flags;
+
+	family_str = "IPv4";
+	if (family == AF_INET6)
+		family_str = "IPv6";
+
+	type = "TCP";
+	if (test->type == UDP)
+		type = "UDP";
+
+	conn = "known";
+	if (test->conn == UNKNOWN_CONN)
+		conn = "unknown";
+
+	hops = "no hops";
+	if (test->hops == ONE_HOP)
+		hops = "one hop";
+
+	result = "accept";
+	if (test->result == FORWARD)
+		result = "forward";
+
+	flags = "none";
+	if (test->flags == SYN)
+		flags = "SYN";
+	else if (test->flags == ACK)
+		flags = "ACK";
+
+	return snprintf(buf, len, "%s %s %s %s (%s, flags: %s)", family_str,
+			type, result, conn, hops, flags);
+}
+
+static struct test_cfg tests[] = {
+	{ TCP, ACCEPT, UNKNOWN_CONN, NO_HOPS, SYN },
+	{ TCP, ACCEPT, UNKNOWN_CONN, NO_HOPS, ACK },
+	{ TCP, FORWARD, UNKNOWN_CONN, ONE_HOP, ACK },
+	{ TCP, ACCEPT, KNOWN_CONN, ONE_HOP, ACK },
+	{ UDP, ACCEPT, UNKNOWN_CONN, NO_HOPS, NONE },
+	{ UDP, FORWARD, UNKNOWN_CONN, ONE_HOP, NONE },
+	{ UDP, ACCEPT, KNOWN_CONN, ONE_HOP, NONE },
+};
+
+static void encap_init(encap_headers_t *encap, uint8_t hop_count, uint8_t proto)
+{
+	const uint8_t hlen =
+		(sizeof(struct guehdr) / sizeof(uint32_t)) + hop_count;
+	*encap = (encap_headers_t){
+		.eth = { .h_proto = htons(ETH_P_IP) },
+		.ip = {
+			.ihl = 5,
+			.version = 4,
+			.ttl = IPDEFTTL,
+			.protocol = IPPROTO_UDP,
+			.daddr = htonl(ENCAP_IP)
+		},
+		.udp = {
+			.dest = htons(ENCAP_PORT),
+		},
+		.gue = {
+			.hlen = hlen,
+			.proto_ctype = proto
+		},
+		.unigue = {
+			.hop_count = hop_count
+		},
+	};
+}
+
+static size_t build_input(const struct test_cfg *test, void *const buf,
+			  const struct tuple *tuple)
+{
+	in_port_t sport = tuple->src.port;
+	encap_headers_t encap;
+	struct iphdr ip;
+	struct ipv6hdr ipv6;
+	struct tcphdr tcp;
+	struct udphdr udp;
+	struct in_addr next_hop;
+	uint8_t *p = buf;
+	int proto;
+
+	proto = IPPROTO_IPIP;
+	if (tuple->family == AF_INET6)
+		proto = IPPROTO_IPV6;
+
+	encap_init(&encap, test->hops == ONE_HOP ? 1 : 0, proto);
+	p = mempcpy(p, &encap, sizeof(encap));
+
+	if (test->hops == ONE_HOP) {
+		next_hop = (struct in_addr){ .s_addr = htonl(0x7f000002) };
+		p = mempcpy(p, &next_hop, sizeof(next_hop));
+	}
+
+	proto = IPPROTO_TCP;
+	if (test->type == UDP)
+		proto = IPPROTO_UDP;
+
+	switch (tuple->family) {
+	case AF_INET:
+		ip = (struct iphdr){
+			.ihl = 5,
+			.version = 4,
+			.ttl = IPDEFTTL,
+			.protocol = proto,
+			.saddr = tuple->src.in_addr.s_addr,
+			.daddr = tuple->dst.in_addr.s_addr,
+		};
+		p = mempcpy(p, &ip, sizeof(ip));
+		break;
+	case AF_INET6:
+		ipv6 = (struct ipv6hdr){
+			.version = 6,
+			.hop_limit = IPDEFTTL,
+			.nexthdr = proto,
+			.saddr = tuple->src.in6_addr,
+			.daddr = tuple->dst.in6_addr,
+		};
+		p = mempcpy(p, &ipv6, sizeof(ipv6));
+		break;
+	default:
+		return 0;
+	}
+
+	if (test->conn == UNKNOWN_CONN)
+		sport--;
+
+	switch (test->type) {
+	case TCP:
+		tcp = (struct tcphdr){
+			.source = sport,
+			.dest = tuple->dst.port,
+		};
+		if (test->flags == SYN)
+			tcp.syn = true;
+		if (test->flags == ACK)
+			tcp.ack = true;
+		p = mempcpy(p, &tcp, sizeof(tcp));
+		break;
+	case UDP:
+		udp = (struct udphdr){
+			.source = sport,
+			.dest = tuple->dst.port,
+		};
+		p = mempcpy(p, &udp, sizeof(udp));
+		break;
+	default:
+		return 0;
+	}
+
+	return (void *)p - buf;
+}
+
+static void close_fds(int *fds, int n)
+{
+	int i;
+
+	for (i = 0; i < n; i++)
+		if (fds[i] > 0)
+			close(fds[i]);
+}
+
+void test_cls_redirect(void)
+{
+	struct test_cls_redirect *skel = NULL;
+	struct bpf_prog_test_run_attr tattr = {};
+	int families[] = { AF_INET, AF_INET6 };
+	struct sockaddr_storage ss;
+	struct sockaddr *addr;
+	socklen_t slen;
+	int i, j, err;
+
+	int servers[__NR_KIND][ARRAY_SIZE(families)] = {};
+	int conns[__NR_KIND][ARRAY_SIZE(families)] = {};
+	struct tuple tuples[__NR_KIND][ARRAY_SIZE(families)];
+
+	skel = test_cls_redirect__open();
+	if (CHECK_FAIL(!skel))
+		return;
+
+	skel->rodata->ENCAPSULATION_IP = htonl(ENCAP_IP);
+	skel->rodata->ENCAPSULATION_PORT = htons(ENCAP_PORT);
+
+	if (CHECK_FAIL(test_cls_redirect__load(skel)))
+		goto cleanup;
+
+	addr = (struct sockaddr *)&ss;
+	for (i = 0; i < ARRAY_SIZE(families); i++) {
+		slen = prepare_addr(&ss, families[i]);
+		if (CHECK_FAIL(!slen))
+			goto cleanup;
+
+		if (CHECK_FAIL(!set_up_conn(addr, slen, SOCK_DGRAM,
+					    &servers[UDP][i], &conns[UDP][i],
+					    &tuples[UDP][i])))
+			goto cleanup;
+
+		if (CHECK_FAIL(!set_up_conn(addr, slen, SOCK_STREAM,
+					    &servers[TCP][i], &conns[TCP][i],
+					    &tuples[TCP][i])))
+			goto cleanup;
+	}
+
+	tattr.prog_fd = bpf_program__fd(skel->progs.cls_redirect);
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		struct test_cfg *test = &tests[i];
+
+		for (j = 0; j < ARRAY_SIZE(families); j++) {
+			struct tuple *tuple = &tuples[test->type][j];
+			char input[256];
+			char tmp[256];
+
+			test_str(tmp, sizeof(tmp), test, tuple->family);
+			if (!test__start_subtest(tmp))
+				continue;
+
+			tattr.data_out = tmp;
+			tattr.data_size_out = sizeof(tmp);
+
+			tattr.data_in = input;
+			tattr.data_size_in = build_input(test, input, tuple);
+			if (CHECK_FAIL(!tattr.data_size_in))
+				continue;
+
+			err = bpf_prog_test_run_xattr(&tattr);
+			if (CHECK_FAIL(err))
+				continue;
+
+			if (tattr.retval != TC_ACT_REDIRECT) {
+				PRINT_FAIL("expected TC_ACT_REDIRECT, got %d\n",
+					   tattr.retval);
+				continue;
+			}
+
+			switch (test->result) {
+			case ACCEPT:
+				if (CHECK_FAIL(!was_decapsulated(&tattr)))
+					continue;
+				break;
+			case FORWARD:
+				if (CHECK_FAIL(was_decapsulated(&tattr)))
+					continue;
+				break;
+			default:
+				PRINT_FAIL("unknown result %d\n", test->result);
+				continue;
+			}
+		}
+	}
+
+cleanup:
+	test_cls_redirect__destroy(skel);
+	close_fds((int *)servers, sizeof(servers) / sizeof(servers[0][0]));
+	close_fds((int *)conns, sizeof(conns) / sizeof(conns[0][0]));
+}
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
new file mode 100644
index 000000000000..1668b993eb86
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
@@ -0,0 +1,1058 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+// Copyright (c) 2019, 2020 Cloudflare
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <string.h>
+
+#include <linux/bpf.h>
+#include <linux/icmp.h>
+#include <linux/icmpv6.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#include "test_cls_redirect.h"
+
+#define offsetofend(TYPE, MEMBER) \
+	(offsetof(TYPE, MEMBER) + sizeof((((TYPE *)0)->MEMBER)))
+
+#define IP_OFFSET_MASK (0x1FFF)
+#define IP_MF (0x2000)
+
+char _license[] SEC("license") = "Dual BSD/GPL";
+
+/**
+ * Destination port and IP used for UDP encapsulation.
+ */
+static volatile const __be16 ENCAPSULATION_PORT;
+static volatile const __be32 ENCAPSULATION_IP;
+
+typedef struct {
+	uint64_t processed_packets_total;
+	uint64_t l3_protocol_packets_total_ipv4;
+	uint64_t l3_protocol_packets_total_ipv6;
+	uint64_t l4_protocol_packets_total_tcp;
+	uint64_t l4_protocol_packets_total_udp;
+	uint64_t accepted_packets_total_syn;
+	uint64_t accepted_packets_total_syn_cookies;
+	uint64_t accepted_packets_total_last_hop;
+	uint64_t accepted_packets_total_icmp_echo_request;
+	uint64_t accepted_packets_total_established;
+	uint64_t forwarded_packets_total_gue;
+	uint64_t forwarded_packets_total_gre;
+
+	uint64_t errors_total_unknown_l3_proto;
+	uint64_t errors_total_unknown_l4_proto;
+	uint64_t errors_total_malformed_ip;
+	uint64_t errors_total_fragmented_ip;
+	uint64_t errors_total_malformed_icmp;
+	uint64_t errors_total_unwanted_icmp;
+	uint64_t errors_total_malformed_icmp_pkt_too_big;
+	uint64_t errors_total_malformed_tcp;
+	uint64_t errors_total_malformed_udp;
+	uint64_t errors_total_icmp_echo_replies;
+	uint64_t errors_total_malformed_encapsulation;
+	uint64_t errors_total_encap_adjust_failed;
+	uint64_t errors_total_encap_buffer_too_small;
+	uint64_t errors_total_redirect_loop;
+} metrics_t;
+
+typedef enum {
+	INVALID = 0,
+	UNKNOWN,
+	ECHO_REQUEST,
+	SYN,
+	SYN_COOKIE,
+	ESTABLISHED,
+} verdict_t;
+
+typedef struct {
+	uint16_t src, dst;
+} flow_ports_t;
+
+_Static_assert(
+	sizeof(flow_ports_t) !=
+		offsetofend(struct bpf_sock_tuple, ipv4.dport) -
+			offsetof(struct bpf_sock_tuple, ipv4.sport) - 1,
+	"flow_ports_t must match sport and dport in struct bpf_sock_tuple");
+_Static_assert(
+	sizeof(flow_ports_t) !=
+		offsetofend(struct bpf_sock_tuple, ipv6.dport) -
+			offsetof(struct bpf_sock_tuple, ipv6.sport) - 1,
+	"flow_ports_t must match sport and dport in struct bpf_sock_tuple");
+
+typedef int ret_t;
+
+/* This is a bit of a hack. We need a return value which allows us to
+ * indicate that the regular flow of the program should continue,
+ * while allowing functions to use XDP_PASS and XDP_DROP, etc.
+ */
+static const ret_t CONTINUE_PROCESSING = -1;
+
+/* Convenience macro to call functions which return ret_t.
+ */
+#define MAYBE_RETURN(x)                           \
+	do {                                      \
+		ret_t __ret = x;                  \
+		if (__ret != CONTINUE_PROCESSING) \
+			return __ret;             \
+	} while (0)
+
+/* Linux packet pointers are either aligned to NET_IP_ALIGN (aka 2 bytes),
+ * or not aligned if the arch supports efficient unaligned access.
+ *
+ * Since the verifier ensures that eBPF packet accesses follow these rules,
+ * we can tell LLVM to emit code as if we always had a larger alignment.
+ * It will yell at us if we end up on a platform where this is not valid.
+ */
+typedef uint8_t *net_ptr __attribute__((align_value(8)));
+
+typedef struct buf {
+	struct __sk_buff *skb;
+	net_ptr head;
+	/* NB: tail musn't have alignment other than 1, otherwise
+	* LLVM will go and eliminate code, e.g. when checking packet lengths.
+	*/
+	uint8_t *const tail;
+} buf_t;
+
+static size_t buf_off(const buf_t *buf)
+{
+	/* Clang seems to optimize constructs like
+	 *    a - b + c
+	 * if c is known:
+	 *    r? = c
+	 *    r? -= b
+	 *    r? += a
+	 *
+	 * This is a problem if a and b are packet pointers,
+	 * since the verifier allows subtracting two pointers to
+	 * get a scalar, but not a scalar and a pointer.
+	 *
+	 * Use inline asm to break this optimization.
+	 */
+	size_t off = (size_t)buf->head;
+	asm("%0 -= %1" : "+r"(off) : "r"(buf->skb->data));
+	return off;
+}
+
+static bool buf_copy(buf_t *buf, void *dst, size_t len)
+{
+	if (bpf_skb_load_bytes(buf->skb, buf_off(buf), dst, len)) {
+		return false;
+	}
+
+	buf->head += len;
+	return true;
+}
+
+static bool buf_skip(buf_t *buf, const size_t len)
+{
+	/* Check whether off + len is valid in the non-linear part. */
+	if (buf_off(buf) + len > buf->skb->len) {
+		return false;
+	}
+
+	buf->head += len;
+	return true;
+}
+
+/* Returns a pointer to the start of buf, or NULL if len is
+ * larger than the remaining data. Consumes len bytes on a successful
+ * call.
+ *
+ * If scratch is not NULL, the function will attempt to load non-linear
+ * data via bpf_skb_load_bytes. On success, scratch is returned.
+ */
+static void *buf_assign(buf_t *buf, const size_t len, void *scratch)
+{
+	if (buf->head + len > buf->tail) {
+		if (scratch == NULL) {
+			return NULL;
+		}
+
+		return buf_copy(buf, scratch, len) ? scratch : NULL;
+	}
+
+	void *ptr = buf->head;
+	buf->head += len;
+	return ptr;
+}
+
+static bool pkt_skip_ipv4_options(buf_t *buf, const struct iphdr *ipv4)
+{
+	if (ipv4->ihl <= 5) {
+		return true;
+	}
+
+	return buf_skip(buf, (ipv4->ihl - 5) * 4);
+}
+
+static bool ipv4_is_fragment(const struct iphdr *ip)
+{
+	uint16_t frag_off = ip->frag_off & bpf_htons(IP_OFFSET_MASK);
+	return (ip->frag_off & bpf_htons(IP_MF)) != 0 || frag_off > 0;
+}
+
+static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
+{
+	struct iphdr *ipv4 = buf_assign(pkt, sizeof(*ipv4), scratch);
+	if (ipv4 == NULL) {
+		return NULL;
+	}
+
+	if (ipv4->ihl < 5) {
+		return NULL;
+	}
+
+	if (!pkt_skip_ipv4_options(pkt, ipv4)) {
+		return NULL;
+	}
+
+	return ipv4;
+}
+
+/* Parse the L4 ports from a packet, assuming a layout like TCP or UDP. */
+static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *ports)
+{
+	if (!buf_copy(pkt, ports, sizeof(*ports))) {
+		return false;
+	}
+
+	/* Ports in the L4 headers are reversed, since we are parsing an ICMP
+	 * payload which is going towards the eyeball.
+	 */
+	uint16_t dst = ports->src;
+	ports->src = ports->dst;
+	ports->dst = dst;
+	return true;
+}
+
+static uint16_t pkt_checksum_fold(uint32_t csum)
+{
+	/* The highest reasonable value for an IPv4 header
+	 * checksum requires two folds, so we just do that always.
+	 */
+	csum = (csum & 0xffff) + (csum >> 16);
+	csum = (csum & 0xffff) + (csum >> 16);
+	return (uint16_t)~csum;
+}
+
+static void pkt_ipv4_checksum(struct iphdr *iph)
+{
+	iph->check = 0;
+
+	/* An IP header without options is 20 bytes. Two of those
+	 * are the checksum, which we always set to zero. Hence,
+	 * the maximum accumulated value is 18 / 2 * 0xffff = 0x8fff7,
+	 * which fits in 32 bit.
+	 */
+	_Static_assert(sizeof(struct iphdr) == 20, "iphdr must be 20 bytes");
+	uint32_t acc = 0;
+	uint16_t *ipw = (uint16_t *)iph;
+
+#pragma clang loop unroll(full)
+	for (size_t i = 0; i < sizeof(struct iphdr) / 2; i++) {
+		acc += ipw[i];
+	}
+
+	iph->check = pkt_checksum_fold(acc);
+}
+
+static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
+					    const struct ipv6hdr *ipv6,
+					    uint8_t *upper_proto,
+					    bool *is_fragment)
+{
+	/* We understand five extension headers.
+	 * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
+	 * headers should occur once, except Destination Options, which may
+	 * occur twice. Hence we give up after 6 headers.
+	 */
+	struct {
+		uint8_t next;
+		uint8_t len;
+	} exthdr = {
+		.next = ipv6->nexthdr,
+	};
+	*is_fragment = false;
+
+#pragma clang loop unroll(full)
+	for (int i = 0; i < 6; i++) {
+		switch (exthdr.next) {
+		case IPPROTO_FRAGMENT:
+			*is_fragment = true;
+			/* NB: We don't check that hdrlen == 0 as per spec. */
+			/* fallthrough; */
+
+		case IPPROTO_HOPOPTS:
+		case IPPROTO_ROUTING:
+		case IPPROTO_DSTOPTS:
+		case IPPROTO_MH:
+			if (!buf_copy(pkt, &exthdr, sizeof(exthdr))) {
+				return false;
+			}
+
+			/* hdrlen is in 8-octet units, and excludes the first 8 octets. */
+			if (!buf_skip(pkt,
+				      (exthdr.len + 1) * 8 - sizeof(exthdr))) {
+				return false;
+			}
+
+			/* Decode next header */
+			break;
+
+		default:
+			/* The next header is not one of the known extension
+			 * headers, treat it as the upper layer header.
+			 *
+			 * This handles IPPROTO_NONE.
+			 *
+			 * Encapsulating Security Payload (50) and Authentication
+			 * Header (51) also end up here (and will trigger an
+			 * unknown proto error later). They have a custom header
+			 * format and seem too esoteric to care about.
+			 */
+			*upper_proto = exthdr.next;
+			return true;
+		}
+	}
+
+	/* We never found an upper layer header. */
+	return false;
+}
+
+/* This function has to be inlined, because the verifier otherwise rejects it
+ * due to returning a pointer to the stack. This is technically correct, since
+ * scratch is allocated on the stack. However, this usage should be safe since
+ * it's the callers stack after all.
+ */
+static inline __attribute__((__always_inline__)) struct ipv6hdr *
+pkt_parse_ipv6(buf_t *pkt, struct ipv6hdr *scratch, uint8_t *proto,
+	       bool *is_fragment)
+{
+	struct ipv6hdr *ipv6 = buf_assign(pkt, sizeof(*ipv6), scratch);
+	if (ipv6 == NULL) {
+		return NULL;
+	}
+
+	if (!pkt_skip_ipv6_extension_headers(pkt, ipv6, proto, is_fragment)) {
+		return NULL;
+	}
+
+	return ipv6;
+}
+
+/* Global metrics, per CPU
+ */
+struct bpf_map_def metrics_map SEC("maps") = {
+	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
+	.key_size = sizeof(unsigned int),
+	.value_size = sizeof(metrics_t),
+	.max_entries = 1,
+};
+
+static metrics_t *get_global_metrics(void)
+{
+	uint64_t key = 0;
+	return bpf_map_lookup_elem(&metrics_map, &key);
+}
+
+static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
+{
+	const int payload_off =
+		sizeof(*encap) +
+		sizeof(struct in_addr) * encap->unigue.hop_count;
+	int32_t encap_overhead = payload_off - sizeof(struct ethhdr);
+
+	// Changing the ethertype if the encapsulated packet is ipv6
+	if (encap->gue.proto_ctype == IPPROTO_IPV6) {
+		encap->eth.h_proto = bpf_htons(ETH_P_IPV6);
+	}
+
+	if (bpf_skb_adjust_room(skb, -encap_overhead, BPF_ADJ_ROOM_MAC,
+				BPF_F_ADJ_ROOM_FIXED_GSO)) {
+		return TC_ACT_SHOT;
+	}
+
+	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
+}
+
+static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *encap,
+			      struct in_addr *next_hop, metrics_t *metrics)
+{
+	metrics->forwarded_packets_total_gre++;
+
+	const int payload_off =
+		sizeof(*encap) +
+		sizeof(struct in_addr) * encap->unigue.hop_count;
+	int32_t encap_overhead =
+		payload_off - sizeof(struct ethhdr) - sizeof(struct iphdr);
+	int32_t delta = sizeof(struct gre_base_hdr) - encap_overhead;
+	uint16_t proto = ETH_P_IP;
+
+	/* Loop protection: the inner packet's TTL is decremented as a safeguard
+	 * against any forwarding loop. As the only interesting field is the TTL
+	 * hop limit for IPv6, it is easier to use bpf_skb_load_bytes/bpf_skb_store_bytes
+	 * as they handle the split packets if needed (no need for the data to be
+	 * in the linear section).
+	 */
+	if (encap->gue.proto_ctype == IPPROTO_IPV6) {
+		proto = ETH_P_IPV6;
+		uint8_t ttl;
+		int rc;
+
+		rc = bpf_skb_load_bytes(
+			skb, payload_off + offsetof(struct ipv6hdr, hop_limit),
+			&ttl, 1);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+
+		if (ttl == 0) {
+			metrics->errors_total_redirect_loop++;
+			return TC_ACT_SHOT;
+		}
+
+		ttl--;
+		rc = bpf_skb_store_bytes(
+			skb, payload_off + offsetof(struct ipv6hdr, hop_limit),
+			&ttl, 1, 0);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+	} else {
+		uint8_t ttl;
+		int rc;
+
+		rc = bpf_skb_load_bytes(
+			skb, payload_off + offsetof(struct iphdr, ttl), &ttl,
+			1);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+
+		if (ttl == 0) {
+			metrics->errors_total_redirect_loop++;
+			return TC_ACT_SHOT;
+		}
+
+		/* IPv4 also has a checksum to patch. While the TTL is only one byte,
+		 * this function only works for 2 and 4 bytes arguments (the result is
+		 * the same).
+		 */
+		rc = bpf_l3_csum_replace(
+			skb, payload_off + offsetof(struct iphdr, check), ttl,
+			ttl - 1, 2);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+
+		ttl--;
+		rc = bpf_skb_store_bytes(
+			skb, payload_off + offsetof(struct iphdr, ttl), &ttl, 1,
+			0);
+		if (rc != 0) {
+			metrics->errors_total_malformed_encapsulation++;
+			return TC_ACT_SHOT;
+		}
+	}
+
+	if (bpf_skb_adjust_room(skb, delta, BPF_ADJ_ROOM_NET,
+				BPF_F_ADJ_ROOM_FIXED_GSO)) {
+		metrics->errors_total_encap_adjust_failed++;
+		return TC_ACT_SHOT;
+	}
+
+	if (bpf_skb_pull_data(skb, sizeof(encap_gre_t))) {
+		metrics->errors_total_encap_buffer_too_small++;
+		return TC_ACT_SHOT;
+	}
+
+	buf_t pkt = {
+		.skb = skb,
+		.head = (uint8_t *)(long)skb->data,
+		.tail = (uint8_t *)(long)skb->data_end,
+	};
+
+	encap_gre_t *encap_gre = buf_assign(&pkt, sizeof(encap_gre_t), NULL);
+	if (encap_gre == NULL) {
+		metrics->errors_total_encap_buffer_too_small++;
+		return TC_ACT_SHOT;
+	}
+
+	encap_gre->ip.protocol = IPPROTO_GRE;
+	encap_gre->ip.daddr = next_hop->s_addr;
+	encap_gre->ip.saddr = ENCAPSULATION_IP;
+	encap_gre->ip.tot_len =
+		bpf_htons(bpf_ntohs(encap_gre->ip.tot_len) + delta);
+	encap_gre->gre.flags = 0;
+	encap_gre->gre.protocol = bpf_htons(proto);
+	pkt_ipv4_checksum((void *)&encap_gre->ip);
+
+	return bpf_redirect(skb->ifindex, 0);
+}
+
+static ret_t forward_to_next_hop(struct __sk_buff *skb, encap_headers_t *encap,
+				 struct in_addr *next_hop, metrics_t *metrics)
+{
+	/* swap L2 addresses */
+	/* This assumes that packets are received from a router.
+	 * So just swapping the MAC addresses here will make the packet go back to
+	 * the router, which will send it to the appropriate machine.
+	 */
+	unsigned char temp[ETH_ALEN];
+	memcpy(temp, encap->eth.h_dest, sizeof(temp));
+	memcpy(encap->eth.h_dest, encap->eth.h_source,
+	       sizeof(encap->eth.h_dest));
+	memcpy(encap->eth.h_source, temp, sizeof(encap->eth.h_source));
+
+	if (encap->unigue.next_hop == encap->unigue.hop_count - 1 &&
+	    encap->unigue.last_hop_gre) {
+		return forward_with_gre(skb, encap, next_hop, metrics);
+	}
+
+	metrics->forwarded_packets_total_gue++;
+	uint32_t old_saddr = encap->ip.saddr;
+	encap->ip.saddr = encap->ip.daddr;
+	encap->ip.daddr = next_hop->s_addr;
+	if (encap->unigue.next_hop < encap->unigue.hop_count) {
+		encap->unigue.next_hop++;
+	}
+
+	/* Remove ip->saddr, add next_hop->s_addr */
+	const uint64_t off = offsetof(typeof(*encap), ip.check);
+	int ret = bpf_l3_csum_replace(skb, off, old_saddr, next_hop->s_addr, 4);
+	if (ret < 0) {
+		return TC_ACT_SHOT;
+	}
+
+	return bpf_redirect(skb->ifindex, 0);
+}
+
+static ret_t skip_next_hops(buf_t *pkt, int n)
+{
+	switch (n) {
+	case 1:
+		if (!buf_skip(pkt, sizeof(struct in_addr)))
+			return TC_ACT_SHOT;
+	case 0:
+		return CONTINUE_PROCESSING;
+
+	default:
+		return TC_ACT_SHOT;
+	}
+}
+
+/* Get the next hop from the GLB header.
+ *
+ * Sets next_hop->s_addr to 0 if there are no more hops left.
+ * pkt is positioned just after the variable length GLB header
+ * iff the call is successful.
+ */
+static ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
+			  struct in_addr *next_hop)
+{
+	if (encap->unigue.next_hop > encap->unigue.hop_count) {
+		return TC_ACT_SHOT;
+	}
+
+	/* Skip "used" next hops. */
+	MAYBE_RETURN(skip_next_hops(pkt, encap->unigue.next_hop));
+
+	if (encap->unigue.next_hop == encap->unigue.hop_count) {
+		/* No more next hops, we are at the end of the GLB header. */
+		next_hop->s_addr = 0;
+		return CONTINUE_PROCESSING;
+	}
+
+	if (!buf_copy(pkt, next_hop, sizeof(*next_hop))) {
+		return TC_ACT_SHOT;
+	}
+
+	/* Skip the remainig next hops (may be zero). */
+	return skip_next_hops(pkt, encap->unigue.hop_count -
+					   encap->unigue.next_hop - 1);
+}
+
+/* Fill a bpf_sock_tuple to be used with the socket lookup functions.
+ * This is a kludge that let's us work around verifier limitations:
+ *
+ *    fill_tuple(&t, foo, sizeof(struct iphdr), 123, 321)
+ *
+ * clang will substitue a costant for sizeof, which allows the verifier
+ * to track it's value. Based on this, it can figure out the constant
+ * return value, and calling code works while still being "generic" to
+ * IPv4 and IPv6.
+ */
+static uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
+			   uint64_t iphlen, uint16_t sport, uint16_t dport)
+{
+	switch (iphlen) {
+	case sizeof(struct iphdr): {
+		struct iphdr *ipv4 = (struct iphdr *)iph;
+		tuple->ipv4.daddr = ipv4->daddr;
+		tuple->ipv4.saddr = ipv4->saddr;
+		tuple->ipv4.sport = sport;
+		tuple->ipv4.dport = dport;
+		return sizeof(tuple->ipv4);
+	}
+
+	case sizeof(struct ipv6hdr): {
+		struct ipv6hdr *ipv6 = (struct ipv6hdr *)iph;
+		memcpy(&tuple->ipv6.daddr, &ipv6->daddr,
+		       sizeof(tuple->ipv6.daddr));
+		memcpy(&tuple->ipv6.saddr, &ipv6->saddr,
+		       sizeof(tuple->ipv6.saddr));
+		tuple->ipv6.sport = sport;
+		tuple->ipv6.dport = dport;
+		return sizeof(tuple->ipv6);
+	}
+
+	default:
+		return 0;
+	}
+}
+
+static verdict_t classify_tcp(struct __sk_buff *skb,
+			      struct bpf_sock_tuple *tuple, uint64_t tuplen,
+			      void *iph, struct tcphdr *tcp)
+{
+	struct bpf_sock *sk =
+		bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
+	if (sk == NULL) {
+		return UNKNOWN;
+	}
+
+	if (sk->state != BPF_TCP_LISTEN) {
+		bpf_sk_release(sk);
+		return ESTABLISHED;
+	}
+
+	if (iph != NULL && tcp != NULL) {
+		/* Kludge: we've run out of arguments, but need the length of the ip header. */
+		uint64_t iphlen = sizeof(struct iphdr);
+		if (tuplen == sizeof(tuple->ipv6)) {
+			iphlen = sizeof(struct ipv6hdr);
+		}
+
+		if (bpf_tcp_check_syncookie(sk, iph, iphlen, tcp,
+					    sizeof(*tcp)) == 0) {
+			bpf_sk_release(sk);
+			return SYN_COOKIE;
+		}
+	}
+
+	bpf_sk_release(sk);
+	return UNKNOWN;
+}
+
+static verdict_t classify_udp(struct __sk_buff *skb,
+			      struct bpf_sock_tuple *tuple, uint64_t tuplen)
+{
+	struct bpf_sock *sk =
+		bpf_sk_lookup_udp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
+	if (sk == NULL) {
+		return UNKNOWN;
+	}
+
+	if (sk->state == BPF_TCP_ESTABLISHED) {
+		bpf_sk_release(sk);
+		return ESTABLISHED;
+	}
+
+	bpf_sk_release(sk);
+	return UNKNOWN;
+}
+
+static verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto,
+			       struct bpf_sock_tuple *tuple, uint64_t tuplen,
+			       metrics_t *metrics)
+{
+	switch (proto) {
+	case IPPROTO_TCP:
+		return classify_tcp(skb, tuple, tuplen, NULL, NULL);
+
+	case IPPROTO_UDP:
+		return classify_udp(skb, tuple, tuplen);
+
+	default:
+		metrics->errors_total_malformed_icmp++;
+		return INVALID;
+	}
+}
+
+static verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
+{
+	struct icmphdr icmp;
+	if (!buf_copy(pkt, &icmp, sizeof(icmp))) {
+		metrics->errors_total_malformed_icmp++;
+		return INVALID;
+	}
+
+	/* We should never receive encapsulated echo replies. */
+	if (icmp.type == ICMP_ECHOREPLY) {
+		metrics->errors_total_icmp_echo_replies++;
+		return INVALID;
+	}
+
+	if (icmp.type == ICMP_ECHO) {
+		return ECHO_REQUEST;
+	}
+
+	if (icmp.type != ICMP_DEST_UNREACH || icmp.code != ICMP_FRAG_NEEDED) {
+		metrics->errors_total_unwanted_icmp++;
+		return INVALID;
+	}
+
+	struct iphdr _ip4;
+	const struct iphdr *ipv4 = pkt_parse_ipv4(pkt, &_ip4);
+	if (ipv4 == NULL) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	/* The source address in the outer IP header is from the entity that
+	 * originated the ICMP message. Use the original IP header to restore
+	 * the correct flow tuple.
+	 */
+	struct bpf_sock_tuple tuple;
+	tuple.ipv4.saddr = ipv4->daddr;
+	tuple.ipv4.daddr = ipv4->saddr;
+
+	if (!pkt_parse_icmp_l4_ports(pkt, (flow_ports_t *)&tuple.ipv4.sport)) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	return classify_icmp(pkt->skb, ipv4->protocol, &tuple,
+			     sizeof(tuple.ipv4), metrics);
+}
+
+static verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
+{
+	struct icmp6hdr icmp6;
+	if (!buf_copy(pkt, &icmp6, sizeof(icmp6))) {
+		metrics->errors_total_malformed_icmp++;
+		return INVALID;
+	}
+
+	/* We should never receive encapsulated echo replies. */
+	if (icmp6.icmp6_type == ICMPV6_ECHO_REPLY) {
+		metrics->errors_total_icmp_echo_replies++;
+		return INVALID;
+	}
+
+	if (icmp6.icmp6_type == ICMPV6_ECHO_REQUEST) {
+		return ECHO_REQUEST;
+	}
+
+	if (icmp6.icmp6_type != ICMPV6_PKT_TOOBIG) {
+		metrics->errors_total_unwanted_icmp++;
+		return INVALID;
+	}
+
+	bool is_fragment;
+	uint8_t l4_proto;
+	struct ipv6hdr _ipv6;
+	const struct ipv6hdr *ipv6 =
+		pkt_parse_ipv6(pkt, &_ipv6, &l4_proto, &is_fragment);
+	if (ipv6 == NULL) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	if (is_fragment) {
+		metrics->errors_total_fragmented_ip++;
+		return INVALID;
+	}
+
+	/* Swap source and dest addresses. */
+	struct bpf_sock_tuple tuple;
+	memcpy(&tuple.ipv6.saddr, &ipv6->daddr, sizeof(tuple.ipv6.saddr));
+	memcpy(&tuple.ipv6.daddr, &ipv6->saddr, sizeof(tuple.ipv6.daddr));
+
+	if (!pkt_parse_icmp_l4_ports(pkt, (flow_ports_t *)&tuple.ipv6.sport)) {
+		metrics->errors_total_malformed_icmp_pkt_too_big++;
+		return INVALID;
+	}
+
+	return classify_icmp(pkt->skb, l4_proto, &tuple, sizeof(tuple.ipv6),
+			     metrics);
+}
+
+static verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t iphlen,
+			     metrics_t *metrics)
+{
+	metrics->l4_protocol_packets_total_tcp++;
+
+	struct tcphdr _tcp;
+	struct tcphdr *tcp = buf_assign(pkt, sizeof(_tcp), &_tcp);
+	if (tcp == NULL) {
+		metrics->errors_total_malformed_tcp++;
+		return INVALID;
+	}
+
+	if (tcp->syn) {
+		return SYN;
+	}
+
+	struct bpf_sock_tuple tuple;
+	uint64_t tuplen =
+		fill_tuple(&tuple, iph, iphlen, tcp->source, tcp->dest);
+	return classify_tcp(pkt->skb, &tuple, tuplen, iph, tcp);
+}
+
+static verdict_t process_udp(buf_t *pkt, void *iph, uint64_t iphlen,
+			     metrics_t *metrics)
+{
+	metrics->l4_protocol_packets_total_udp++;
+
+	struct udphdr _udp;
+	struct udphdr *udph = buf_assign(pkt, sizeof(_udp), &_udp);
+	if (udph == NULL) {
+		metrics->errors_total_malformed_udp++;
+		return INVALID;
+	}
+
+	struct bpf_sock_tuple tuple;
+	uint64_t tuplen =
+		fill_tuple(&tuple, iph, iphlen, udph->source, udph->dest);
+	return classify_udp(pkt->skb, &tuple, tuplen);
+}
+
+static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
+{
+	metrics->l3_protocol_packets_total_ipv4++;
+
+	struct iphdr _ip4;
+	struct iphdr *ipv4 = pkt_parse_ipv4(pkt, &_ip4);
+	if (ipv4 == NULL) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (ipv4->version != 4) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (ipv4_is_fragment(ipv4)) {
+		metrics->errors_total_fragmented_ip++;
+		return INVALID;
+	}
+
+	switch (ipv4->protocol) {
+	case IPPROTO_ICMP:
+		return process_icmpv4(pkt, metrics);
+
+	case IPPROTO_TCP:
+		return process_tcp(pkt, ipv4, sizeof(*ipv4), metrics);
+
+	case IPPROTO_UDP:
+		return process_udp(pkt, ipv4, sizeof(*ipv4), metrics);
+
+	default:
+		metrics->errors_total_unknown_l4_proto++;
+		return INVALID;
+	}
+}
+
+static verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
+{
+	metrics->l3_protocol_packets_total_ipv6++;
+
+	uint8_t l4_proto;
+	bool is_fragment;
+	struct ipv6hdr _ipv6;
+	struct ipv6hdr *ipv6 =
+		pkt_parse_ipv6(pkt, &_ipv6, &l4_proto, &is_fragment);
+	if (ipv6 == NULL) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (ipv6->version != 6) {
+		metrics->errors_total_malformed_ip++;
+		return INVALID;
+	}
+
+	if (is_fragment) {
+		metrics->errors_total_fragmented_ip++;
+		return INVALID;
+	}
+
+	switch (l4_proto) {
+	case IPPROTO_ICMPV6:
+		return process_icmpv6(pkt, metrics);
+
+	case IPPROTO_TCP:
+		return process_tcp(pkt, ipv6, sizeof(*ipv6), metrics);
+
+	case IPPROTO_UDP:
+		return process_udp(pkt, ipv6, sizeof(*ipv6), metrics);
+
+	default:
+		metrics->errors_total_unknown_l4_proto++;
+		return INVALID;
+	}
+}
+
+SEC("classifier/cls_redirect")
+int cls_redirect(struct __sk_buff *skb)
+{
+	metrics_t *metrics = get_global_metrics();
+	if (metrics == NULL) {
+		return TC_ACT_SHOT;
+	}
+
+	metrics->processed_packets_total++;
+
+	/* Pass bogus packets as long as we're not sure they're
+	 * destined for us.
+	 */
+	if (skb->protocol != bpf_htons(ETH_P_IP)) {
+		return TC_ACT_OK;
+	}
+
+	encap_headers_t *encap;
+
+	/* Make sure that all encapsulation headers are available in
+	 * the linear portion of the skb. This makes it easy to manipulate them.
+	 */
+	if (bpf_skb_pull_data(skb, sizeof(*encap))) {
+		return TC_ACT_OK;
+	}
+
+	buf_t pkt = {
+		.skb = skb,
+		.head = (uint8_t *)(long)skb->data,
+		.tail = (uint8_t *)(long)skb->data_end,
+	};
+
+	encap = buf_assign(&pkt, sizeof(*encap), NULL);
+	if (encap == NULL) {
+		return TC_ACT_OK;
+	}
+
+	if (encap->ip.ihl != 5) {
+		/* We never have any options. */
+		return TC_ACT_OK;
+	}
+
+	if (encap->ip.daddr != ENCAPSULATION_IP ||
+	    encap->ip.protocol != IPPROTO_UDP) {
+		return TC_ACT_OK;
+	}
+
+	/* TODO Check UDP length? */
+	if (encap->udp.dest != ENCAPSULATION_PORT) {
+		return TC_ACT_OK;
+	}
+
+	/* We now know that the packet is destined to us, we can
+	 * drop bogus ones.
+	 */
+	if (ipv4_is_fragment((void *)&encap->ip)) {
+		metrics->errors_total_fragmented_ip++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.variant != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.control != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.flags != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->gue.hlen !=
+	    sizeof(encap->unigue) / 4 + encap->unigue.hop_count) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->unigue.version != 0) {
+		metrics->errors_total_malformed_encapsulation++;
+		return TC_ACT_SHOT;
+	}
+
+	if (encap->unigue.reserved != 0) {
+		return TC_ACT_SHOT;
+	}
+
+	struct in_addr next_hop;
+	MAYBE_RETURN(get_next_hop(&pkt, encap, &next_hop));
+
+	if (next_hop.s_addr == 0) {
+		metrics->accepted_packets_total_last_hop++;
+		return accept_locally(skb, encap);
+	}
+
+	verdict_t verdict;
+	switch (encap->gue.proto_ctype) {
+	case IPPROTO_IPIP:
+		verdict = process_ipv4(&pkt, metrics);
+		break;
+
+	case IPPROTO_IPV6:
+		verdict = process_ipv6(&pkt, metrics);
+		break;
+
+	default:
+		metrics->errors_total_unknown_l3_proto++;
+		return TC_ACT_SHOT;
+	}
+
+	switch (verdict) {
+	case INVALID:
+		/* metrics have already been bumped */
+		return TC_ACT_SHOT;
+
+	case UNKNOWN:
+		return forward_to_next_hop(skb, encap, &next_hop, metrics);
+
+	case ECHO_REQUEST:
+		metrics->accepted_packets_total_icmp_echo_request++;
+		break;
+
+	case SYN:
+		if (encap->unigue.forward_syn) {
+			return forward_to_next_hop(skb, encap, &next_hop,
+						   metrics);
+		}
+
+		metrics->accepted_packets_total_syn++;
+		break;
+
+	case SYN_COOKIE:
+		metrics->accepted_packets_total_syn_cookies++;
+		break;
+
+	case ESTABLISHED:
+		metrics->accepted_packets_total_established++;
+		break;
+	}
+
+	return accept_locally(skb, encap);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.h b/tools/testing/selftests/bpf/progs/test_cls_redirect.h
new file mode 100644
index 000000000000..76eab0aacba0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/* Copyright 2019, 2020 Cloudflare */
+
+#include <stdbool.h>
+#include <stddef.h>
+#include <stdint.h>
+#include <string.h>
+
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/udp.h>
+
+struct gre_base_hdr {
+	uint16_t flags;
+	uint16_t protocol;
+} __attribute__((packed));
+
+struct guehdr {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	uint8_t hlen : 5, control : 1, variant : 2;
+#else
+	uint8_t variant : 2, control : 1, hlen : 5;
+#endif
+	uint8_t proto_ctype;
+	uint16_t flags;
+};
+
+struct unigue {
+#if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+	uint8_t _r : 2, last_hop_gre : 1, forward_syn : 1, version : 4;
+#else
+	uint8_t version : 4, forward_syn : 1, last_hop_gre : 1, _r : 2;
+#endif
+	uint8_t reserved;
+	uint8_t next_hop;
+	uint8_t hop_count;
+	// Next hops go here
+} __attribute__((packed));
+
+typedef struct {
+	struct ethhdr eth;
+	struct iphdr ip;
+	struct gre_base_hdr gre;
+} __attribute__((packed)) encap_gre_t;
+
+typedef struct {
+	struct ethhdr eth;
+	struct iphdr ip;
+	struct udphdr udp;
+	struct guehdr gue;
+	struct unigue unigue;
+} __attribute__((packed)) encap_headers_t;
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index f4aff6b8284b..10188cc8e9e0 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -105,6 +105,13 @@ struct ipv6_packet {
 } __packed;
 extern struct ipv6_packet pkt_v6;
 
+#define PRINT_FAIL(format...)                                                  \
+	({                                                                     \
+		test__fail();                                                  \
+		fprintf(stdout, "%s:FAIL:%d ", __func__, __LINE__);            \
+		fprintf(stdout, ##format);                                     \
+	})
+
 #define _CHECK(condition, tag, duration, format...) ({			\
 	int __ret = !!(condition);					\
 	int __save_errno = errno;					\
-- 
2.20.1

