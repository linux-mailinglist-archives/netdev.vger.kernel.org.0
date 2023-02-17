Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81D8069B443
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbjBQUz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:55:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjBQUz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:55:26 -0500
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F995F838;
        Fri, 17 Feb 2023 12:55:25 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676667323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d8JlGmWjaBW0PigtuTiH40RnVXnYnrh8/QivQsx3kI4=;
        b=Ip2LCsPfUOA4McaCRybtZ8R6V/eqBQ7HRuenO7a9uqk5XDtQZo5/9ugkTeKmFjkwP26wdV
        IpjS1iWCf1320Gnhon6A/eQf5FcD1FBUNMKc78ehgG1Wiyk5eE7tElaJSKSMjCvvB+XEVc
        mGzv6BkPDO0OCpUj0nT4VD5LTqatpYk=
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     bpf@vger.kernel.org
Cc:     'Alexei Starovoitov ' <ast@kernel.org>,
        'Andrii Nakryiko ' <andrii@kernel.org>,
        'Daniel Borkmann ' <daniel@iogearbox.net>,
        netdev@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v3 bpf-next 2/2] selftests/bpf: Add bpf_fib_lookup test
Date:   Fri, 17 Feb 2023 12:55:15 -0800
Message-Id: <20230217205515.3583372-2-martin.lau@linux.dev>
In-Reply-To: <20230217205515.3583372-1-martin.lau@linux.dev>
References: <20230217205515.3583372-1-martin.lau@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau <martin.lau@kernel.org>

This patch tests the bpf_fib_lookup helper when looking up
a neigh in NUD_FAILED and NUD_STALE state. It also adds test
for the new BPF_FIB_LOOKUP_SKIP_NEIGH flag.

Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
---
 .../selftests/bpf/prog_tests/fib_lookup.c     | 187 ++++++++++++++++++
 .../testing/selftests/bpf/progs/fib_lookup.c  |  22 +++
 2 files changed, 209 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/fib_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/fib_lookup.c

diff --git a/tools/testing/selftests/bpf/prog_tests/fib_lookup.c b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
new file mode 100644
index 000000000000..61ccddccf485
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/fib_lookup.c
@@ -0,0 +1,187 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Meta Platforms, Inc. and affiliates. */
+
+#include <sys/types.h>
+#include <net/if.h>
+
+#include "test_progs.h"
+#include "network_helpers.h"
+#include "fib_lookup.skel.h"
+
+#define SYS(fmt, ...)						\
+	({							\
+		char cmd[1024];					\
+		snprintf(cmd, sizeof(cmd), fmt, ##__VA_ARGS__);	\
+		if (!ASSERT_OK(system(cmd), cmd))		\
+			goto fail;				\
+	})
+
+#define NS_TEST			"fib_lookup_ns"
+#define IPV6_IFACE_ADDR		"face::face"
+#define IPV6_NUD_FAILED_ADDR	"face::1"
+#define IPV6_NUD_STALE_ADDR	"face::2"
+#define IPV4_IFACE_ADDR		"10.0.0.254"
+#define IPV4_NUD_FAILED_ADDR	"10.0.0.1"
+#define IPV4_NUD_STALE_ADDR	"10.0.0.2"
+#define DMAC			"11:11:11:11:11:11"
+#define DMAC_INIT { 0x11, 0x11, 0x11, 0x11, 0x11, 0x11, }
+
+struct fib_lookup_test {
+	const char *desc;
+	const char *daddr;
+	int expected_ret;
+	int lookup_flags;
+	__u8 dmac[6];
+};
+
+static const struct fib_lookup_test tests[] = {
+	{ .desc = "IPv6 failed neigh",
+	  .daddr = IPV6_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_NO_NEIGH, },
+	{ .desc = "IPv6 stale neigh",
+	  .daddr = IPV6_NUD_STALE_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
+	  .dmac = DMAC_INIT, },
+	{ .desc = "IPv6 skip neigh",
+	  .daddr = IPV6_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
+	  .lookup_flags = BPF_FIB_LOOKUP_SKIP_NEIGH, },
+	{ .desc = "IPv4 failed neigh",
+	  .daddr = IPV4_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_NO_NEIGH, },
+	{ .desc = "IPv4 stale neigh",
+	  .daddr = IPV4_NUD_STALE_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
+	  .dmac = DMAC_INIT, },
+	{ .desc = "IPv4 skip neigh",
+	  .daddr = IPV4_NUD_FAILED_ADDR, .expected_ret = BPF_FIB_LKUP_RET_SUCCESS,
+	  .lookup_flags = BPF_FIB_LOOKUP_SKIP_NEIGH, },
+};
+
+static int ifindex;
+
+static int setup_netns(void)
+{
+	int err;
+
+	SYS("ip link add veth1 type veth peer name veth2");
+	SYS("ip link set dev veth1 up");
+
+	SYS("ip addr add %s/64 dev veth1 nodad", IPV6_IFACE_ADDR);
+	SYS("ip neigh add %s dev veth1 nud failed", IPV6_NUD_FAILED_ADDR);
+	SYS("ip neigh add %s dev veth1 lladdr %s nud stale", IPV6_NUD_STALE_ADDR, DMAC);
+
+	SYS("ip addr add %s/24 dev veth1 nodad", IPV4_IFACE_ADDR);
+	SYS("ip neigh add %s dev veth1 nud failed", IPV4_NUD_FAILED_ADDR);
+	SYS("ip neigh add %s dev veth1 lladdr %s nud stale", IPV4_NUD_STALE_ADDR, DMAC);
+
+	err = write_sysctl("/proc/sys/net/ipv4/conf/veth1/forwarding", "1");
+	if (!ASSERT_OK(err, "write_sysctl(net.ipv4.conf.veth1.forwarding)"))
+		goto fail;
+
+	err = write_sysctl("/proc/sys/net/ipv6/conf/veth1/forwarding", "1");
+	if (!ASSERT_OK(err, "write_sysctl(net.ipv6.conf.veth1.forwarding)"))
+		goto fail;
+
+	return 0;
+fail:
+	return -1;
+}
+
+static int set_lookup_params(struct bpf_fib_lookup *params, const char *daddr)
+{
+	int ret;
+
+	memset(params, 0, sizeof(*params));
+
+	params->l4_protocol = IPPROTO_TCP;
+	params->ifindex = ifindex;
+
+	if (inet_pton(AF_INET6, daddr, params->ipv6_dst) == 1) {
+		params->family = AF_INET6;
+		ret = inet_pton(AF_INET6, IPV6_IFACE_ADDR, params->ipv6_src);
+		if (!ASSERT_EQ(ret, 1, "inet_pton(IPV6_IFACE_ADDR)"))
+			return -1;
+		return 0;
+	}
+
+	ret = inet_pton(AF_INET, daddr, &params->ipv4_dst);
+	if (!ASSERT_EQ(ret, 1, "convert IP[46] address"))
+		return -1;
+	params->family = AF_INET;
+	ret = inet_pton(AF_INET, IPV4_IFACE_ADDR, &params->ipv4_src);
+	if (!ASSERT_EQ(ret, 1, "inet_pton(IPV4_IFACE_ADDR)"))
+		return -1;
+
+	return 0;
+}
+
+static void mac_str(char *b, const __u8 *mac)
+{
+	sprintf(b, "%02X:%02X:%02X:%02X:%02X:%02X",
+		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
+}
+
+void test_fib_lookup(void)
+{
+	struct bpf_fib_lookup *fib_params;
+	struct nstoken *nstoken = NULL;
+	struct __sk_buff skb = { };
+	struct fib_lookup *skel;
+	int prog_fd, err, ret, i;
+
+	/* The test does not use the skb->data, so
+	 * use pkt_v6 for both v6 and v4 test.
+	 */
+	LIBBPF_OPTS(bpf_test_run_opts, run_opts,
+		    .data_in = &pkt_v6,
+		    .data_size_in = sizeof(pkt_v6),
+		    .ctx_in = &skb,
+		    .ctx_size_in = sizeof(skb),
+	);
+
+	skel = fib_lookup__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel open_and_load"))
+		return;
+	prog_fd = bpf_program__fd(skel->progs.fib_lookup);
+
+	SYS("ip netns add %s", NS_TEST);
+
+	nstoken = open_netns(NS_TEST);
+	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
+		goto fail;
+
+	if (setup_netns())
+		goto fail;
+
+	ifindex = if_nametoindex("veth1");
+	skb.ifindex = ifindex;
+	fib_params = &skel->bss->fib_params;
+
+	for (i = 0; i < ARRAY_SIZE(tests); i++) {
+		printf("Testing %s\n", tests[i].desc);
+
+		if (set_lookup_params(fib_params, tests[i].daddr))
+			continue;
+		skel->bss->fib_lookup_ret = -1;
+		skel->bss->lookup_flags = BPF_FIB_LOOKUP_OUTPUT |
+			tests[i].lookup_flags;
+
+		err = bpf_prog_test_run_opts(prog_fd, &run_opts);
+		if (!ASSERT_OK(err, "bpf_prog_test_run_opts"))
+			continue;
+
+		ASSERT_EQ(tests[i].expected_ret, skel->bss->fib_lookup_ret,
+			  "fib_lookup_ret");
+
+		ret = memcmp(tests[i].dmac, fib_params->dmac, sizeof(tests[i].dmac));
+		if (!ASSERT_EQ(ret, 0, "dmac not match")) {
+			char expected[18], actual[18];
+
+			mac_str(expected, tests[i].dmac);
+			mac_str(actual, fib_params->dmac);
+			printf("dmac expected %s actual %s\n", expected, actual);
+		}
+	}
+
+fail:
+	if (nstoken)
+		close_netns(nstoken);
+	system("ip netns del " NS_TEST " &> /dev/null");
+	fib_lookup__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/fib_lookup.c b/tools/testing/selftests/bpf/progs/fib_lookup.c
new file mode 100644
index 000000000000..c4514dd58c62
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/fib_lookup.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2023 Meta Platforms, Inc. and affiliates. */
+
+#include <linux/types.h>
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_tracing_net.h"
+
+struct bpf_fib_lookup fib_params = {};
+int fib_lookup_ret = 0;
+int lookup_flags = 0;
+
+SEC("tc")
+int fib_lookup(struct __sk_buff *skb)
+{
+	fib_lookup_ret = bpf_fib_lookup(skb, &fib_params, sizeof(fib_params),
+					lookup_flags);
+
+	return TC_ACT_SHOT;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.30.2

