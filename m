Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A1EC0558
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 14:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727385AbfI0Mki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 08:40:38 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:38830 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727296AbfI0Mkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 08:40:37 -0400
Received: by mail-lf1-f68.google.com with SMTP id u28so1811992lfc.5
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 05:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FcAkLaroHL3Nhx7jYkNQSDeXkQ7r7C9tj+/fbc4DHNE=;
        b=KA/WiI3nLvT7C1pVshpTs/fw7jyYosejjTGzYRqdBIzSwxPpYryQRIotVe6FC5PTUE
         dB5Q3DzRbsYM+Eg4FkuLLm0EFr2W3WQ4J/xWZuKTOCVBqAYAu8pkVLGS0jdD4mnSPNmw
         edInwpn2IBzQenWV86Df6E7Ogc1aUpvi5q8DU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FcAkLaroHL3Nhx7jYkNQSDeXkQ7r7C9tj+/fbc4DHNE=;
        b=CA25WVi+Lx8LSAexIPjD4y3aR4iAOSRpue+BYpjMgf133A7X6ty3B0EYe6UGMNP2nx
         xFQZyX1Ecy7dNeBsgDeg7yvAqHwmJhEYiyIPzwVwWvwuEM6EUI8IaM/EiGRFSvl5lfL4
         ixiMr2sfjOCF0m2jQOkkeUumiQMS2O4JlicCXSDHnss9w7MikUYDWgYwoAtOlR8u/JdV
         HZ9LOb8jiRiYUpK70iK4YPo2kqCplm8z+3phd0u08TtGNQpCTWruUJ5jL+CV7JmtUkcn
         ppyD/AsV88ioUAoQagHZBvyV9JOYZ9fLDSVUJD3Ldm7PQIELuzLt4IZbrTHw0Y8eQP1z
         qDmQ==
X-Gm-Message-State: APjAAAVzpmvAuOszbjqb+T+lDnaHJmFPovtbBXwvPWsvlxyvfswQMjWR
        1IpyalucSOEp5ZTCyLnWeEjlWg==
X-Google-Smtp-Source: APXvYqz4vnyiBUt5WAmUdWRQLwQYA4j0qhreS/f9VGxLA9Rw9/obnqJSXhd3K+hkueYLiTu18Jy6CQ==
X-Received: by 2002:a19:90:: with SMTP id 138mr2525976lfa.111.1569588033432;
        Fri, 27 Sep 2019 05:40:33 -0700 (PDT)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id b19sm438723lji.41.2019.09.27.05.40.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 05:40:32 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     edumazet@google.com
Cc:     davem@davemloft.net, jmaxwell37@gmail.com, eric.dumazet@gmail.com,
        marek@cloudflare.com, netdev@vger.kernel.org, ycheng@google.com,
        kernel-team@cloudflare.com
Subject: Re: [PATCH net] tcp: better handle TCP_USER_TIMEOUT in SYN_SENT state
Date:   Fri, 27 Sep 2019 14:40:17 +0200
Message-Id: <20190927124017.26996-1-marek@cloudflare.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAGHK07B9E0AOBNtqVqKyJQOdU7ijdVi-7jLwnH+=S7ZgG5kpeA@mail.gmail.com>
References: <CAGHK07B9E0AOBNtqVqKyJQOdU7ijdVi-7jLwnH+=S7ZgG5kpeA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/19 10:25 AM, Jonathan Maxwell wrote:
> Acked-by: Jon Maxwell <jmaxwell37@gmail.com>
>
> Thanks for fixing that Eric.
>

The patch seems to do the job.

Tested-by: Marek Majkowski <marek@cloudflare.com>

Here's a selftest:

---8<---
From: Marek Majkowski <marek@cloudflare.com>
Date: Fri, 27 Sep 2019 13:37:52 +0200
Subject: [PATCH] selftests/net: TCP_USER_TIMEOUT in SYN-SENT state

Test the TCP_USER_TIMEOUT behavior, overriding TCP_SYNCNT
when socket is in SYN-SENT state.

Signed-off-by: Marek Majkowski <marek@cloudflare.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   3 +-
 .../selftests/net/tcp_user_timeout_syn_sent.c | 322 ++++++++++++++++++
 .../net/tcp_user_timeout_syn_sent.sh          |   4 +
 4 files changed, 329 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_user_timeout_syn_sent.c
 create mode 100755 tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index c7cced739c34..bc6a2b7199b6 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -21,3 +21,4 @@ ipv6_flowlabel
 ipv6_flowlabel_mgr
 so_txtime
 tcp_fastopen_backup_key
+tcp_user_timeout_syn_sent
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 0bd6b23c97ef..065a171b8834 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -11,13 +11,14 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh
+TEST_PROGS += tcp_user_timeout_syn_sent.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
 TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
-TEST_GEN_FILES += tcp_fastopen_backup_key
+TEST_GEN_FILES += tcp_fastopen_backup_key tcp_user_timeout_syn_sent
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/tcp_user_timeout_syn_sent.c b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.c
new file mode 100644
index 000000000000..1c9ec582359a
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.c
@@ -0,0 +1,322 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Testing if TCP_USER_TIMEOUT on SYN-SENT state overides TCP_SYNCNT.
+ *
+ * Historically, TCP_USER_TIMEOUT made only sense on synchronized TCP
+ * states, like ESTABLISHED. There was a bug on SYN-SENT state: with
+ * TCP_USER_TIMEOUT set, the connect() would ETIMEDOUT after given
+ * time, but near the end of the timer would flood SYN packets to
+ * fulfill the TCP_SYNCNT counter. For example for 2000ms user
+ * timeout and default TCP_SYNCNT=6, the tcpdump would look like:
+ *
+ * 00:00.000000 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ * 00:01.029452 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ * 00:02.021354 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ * 00:02.033419 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ * 00:02.041633 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ * 00:02.049263 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ * 00:02.057264 IP 127.0.0.1.1 > 127.0.0.1.2: Flags [S]
+ *
+ * Notice, 5 out of 6 retransmissions are aligned to 2s. We fixed
+ * that, and this code tests for the regression. We do this by
+ * actively dropping SYN packets on listen socket with ebpf
+ * SOCKET_FILTER, and counting how many packets did we drop.
+ *
+ * See: https://blog.cloudflare.com/when-tcp-sockets-refuse-to-die/
+ */
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <linux/bpf.h>
+#include <linux/tcp.h>
+#include <linux/unistd.h>
+#include <netinet/in.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <unistd.h>
+
+int bpf_create_map(enum bpf_map_type map_type, int key_size, int value_size,
+		   int max_entries, uint32_t map_flags)
+{
+	union bpf_attr attr = {};
+
+	attr.map_type = map_type;
+	attr.key_size = key_size;
+	attr.value_size = value_size;
+	attr.max_entries = max_entries;
+	attr.map_flags = map_flags;
+	return syscall(__NR_bpf, BPF_MAP_CREATE, &attr, sizeof(attr));
+}
+
+int bpf_load_program(enum bpf_prog_type prog_type, const struct bpf_insn *insns,
+		     size_t insns_cnt, const char *license,
+		     uint32_t kern_version)
+{
+	union bpf_attr attr = {};
+
+	attr.prog_type = prog_type;
+	attr.insns = (long)insns;
+	attr.insn_cnt = insns_cnt;
+	attr.license = (long)license;
+	attr.log_buf = (long)NULL;
+	attr.log_size = 0;
+	attr.log_level = 0;
+	attr.kern_version = kern_version;
+
+	int fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, sizeof(attr));
+	return fd;
+}
+
+int bpf_map_update_elem(int fd, const void *key, const void *value,
+			uint64_t flags)
+{
+	union bpf_attr attr = {};
+
+	attr.map_fd = fd;
+	attr.key = (long)key;
+	attr.value = (long)value;
+	attr.flags = flags;
+
+	return syscall(__NR_bpf, BPF_MAP_UPDATE_ELEM, &attr, sizeof(attr));
+}
+
+int bpf_map_lookup_elem(int fd, const void *key, void *value)
+{
+	union bpf_attr attr = {};
+
+	attr.map_fd = fd;
+	attr.key = (long)key;
+	attr.value = (long)value;
+
+	return syscall(__NR_bpf, BPF_MAP_LOOKUP_ELEM, &attr, sizeof(attr));
+}
+
+/*
+struct bpf_map_def SEC("maps") stats_map = {
+	.type = BPF_MAP_TYPE_ARRAY,
+	.key_size = sizeof(uint32_t),
+	.value_size = sizeof(uint64_t),
+	.max_entries = 2,
+};
+
+SEC("socket_filter")
+int _socket_filter(struct __sk_buff *skb)
+{
+	(void)skb;
+
+	uint32_t no = 0;
+	uint64_t *value = bpf_map_lookup_elem(&stats_map, &no);
+	if (value) {
+		__sync_fetch_and_add(value, 1);
+	}
+	return 0; // DROP inbound SYN packets
+}
+ */
+
+size_t bpf_insn_socket_filter_cnt = 12;
+struct bpf_insn bpf_insn_socket_filter[] = {
+	{
+		.code = 0xb7,
+		.dst_reg = BPF_REG_1,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0x63,
+		.dst_reg = BPF_REG_10,
+		.src_reg = BPF_REG_1,
+		.off = -4,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0xbf,
+		.dst_reg = BPF_REG_2,
+		.src_reg = BPF_REG_10,
+		.off = 0,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0x7,
+		.dst_reg = BPF_REG_2,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = -4 /**/
+	},
+	{
+		.code = 0x18,
+		.dst_reg = BPF_REG_1,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 0 /* relocation for stats_map */
+	},
+	{
+		.code = 0x0,
+		.dst_reg = BPF_REG_0,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0x85,
+		.dst_reg = BPF_REG_0,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 1 /**/
+	},
+	{
+		.code = 0x15,
+		.dst_reg = BPF_REG_0,
+		.src_reg = BPF_REG_0,
+		.off = 2,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0xb7,
+		.dst_reg = BPF_REG_1,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 1 /**/
+	},
+	{
+		.code = 0xdb,
+		.dst_reg = BPF_REG_0,
+		.src_reg = BPF_REG_1,
+		.off = 0,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0xb7,
+		.dst_reg = BPF_REG_0,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 0 /**/
+	},
+	{
+		.code = 0x95,
+		.dst_reg = BPF_REG_0,
+		.src_reg = BPF_REG_0,
+		.off = 0,
+		.imm = 0 /**/
+	}
+};
+
+void socket_filter_fill_stats_map(int fd)
+{
+	bpf_insn_socket_filter[4].src_reg = BPF_REG_1;
+	bpf_insn_socket_filter[4].imm = fd;
+}
+
+static int net_setup_ebpf(int sd)
+{
+	int stats_map, bpf, r;
+
+	stats_map = bpf_create_map(BPF_MAP_TYPE_ARRAY, sizeof(uint32_t),
+				   sizeof(uint64_t), 2, 0);
+	if (stats_map < 0)
+		error(1, errno, "bpf");
+
+	socket_filter_fill_stats_map(stats_map);
+
+	bpf = bpf_load_program(BPF_PROG_TYPE_SOCKET_FILTER,
+			       bpf_insn_socket_filter,
+			       bpf_insn_socket_filter_cnt, "Dual BSD/GPL", 0);
+	if (bpf < 0)
+		error(1, errno, "bpf");
+
+	r = setsockopt(sd, SOL_SOCKET, SO_ATTACH_BPF, &bpf, sizeof(bpf));
+	if (r < 0)
+		error(1, errno, "setsockopt(SO_ATTACH_FILTER)");
+
+	return stats_map;
+}
+
+static int setup_server(struct sockaddr_in *addr)
+{
+	int sd, r;
+	socklen_t addr_sz;
+
+	sd = socket(AF_INET, SOCK_STREAM, 0);
+	if (sd < 0)
+		error(1, errno, "socket()");
+
+	r = bind(sd, (struct sockaddr *)addr, sizeof(*addr));
+	if (r != 0)
+		error(1, errno, "bind()");
+
+	r = listen(sd, 16);
+	if (r != 0)
+		error(1, errno, "listen()");
+
+	addr_sz = sizeof(*addr);
+	r = getsockname(sd, (struct sockaddr *)addr, &addr_sz);
+	if (r != 0)
+		error(1, errno, "getsockname()");
+
+	return sd;
+}
+
+int main(void)
+{
+	struct sockaddr_in addr = {
+		.sin_family = AF_INET,
+		.sin_addr = { inet_addr("127.0.0.1") },
+	};
+
+	int sd = setup_server(&addr);
+	int stats_map = net_setup_ebpf(sd);
+	struct {
+		int user_timeout;
+		int expected_counter;
+	} tests[] = {
+		{ 200, 2 }, // TCP_USER_TIMEOUT kicks in on first retranmission
+		{ 1500, 2 },
+		{ 3500, 3 },
+		{ -1, -1 },
+	};
+
+	int failed = 0, i;
+
+	for (i = 0; tests[i].user_timeout >= 0; i++) {
+		int r, cd, v;
+		uint32_t k = 0;
+		uint64_t counter = 0;
+
+		r = bpf_map_update_elem(stats_map, &k, &counter, 0);
+
+		cd = socket(AF_INET, SOCK_STREAM, 0);
+		if (cd < 0)
+			error(1, errno, "socket()");
+
+		v = tests[i].user_timeout;
+		r = setsockopt(cd, IPPROTO_TCP, TCP_USER_TIMEOUT, &v,
+			       sizeof(v));
+		if (r != 0)
+			error(1, errno, "setsockopt()");
+
+		r = connect(cd, (struct sockaddr *)&addr, sizeof(addr));
+		if (r != -1 && errno != ETIMEDOUT)
+			error(1, errno, "connect()");
+
+		r = bpf_map_lookup_elem(stats_map, &k, &counter);
+		if (r != 0)
+			error(1, errno, "bpf_map_lookup_elem()");
+
+		if ((int)counter != tests[i].expected_counter) {
+			failed += 1;
+			printf("[!] Expecting %d SYN packets on "
+			       "TCP_USER_TIMEOUT=%d, got %d\n",
+			       tests[i].expected_counter, tests[i].user_timeout,
+			       (int)counter);
+		}
+		close(cd);
+	}
+	close(sd);
+	close(stats_map);
+	if (failed == 0)
+		fprintf(stderr, "PASSED\n");
+	return failed;
+}
diff --git a/tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh
new file mode 100755
index 000000000000..26765f3a92c6
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_user_timeout_syn_sent.sh
@@ -0,0 +1,4 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+
+./in_netns.sh ./tcp_user_timeout_syn_sent
-- 
2.17.1

