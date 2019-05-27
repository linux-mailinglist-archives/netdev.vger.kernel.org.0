Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5022BB86
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 22:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbfE0Ur4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 16:47:56 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46770 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727103AbfE0Ur4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 16:47:56 -0400
Received: by mail-ua1-f66.google.com with SMTP id a95so6945085uaa.13
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 13:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NHX+kL7EY4iloI7diQJ1yXH749aKrxTAxYbMeAfU1qs=;
        b=PkOZB4D70K02R4GF+uTkid3g8xFb3cJtTau7nRf9Kcw88iYhGclmNlnRcYJIerVxcv
         n74dEdAhlWia7SYaFFYXnRQ8TYPIDK+KU0C5Ox2KJdOy2nel6whiZ+Zj2Z5B4EIqgGpl
         2xN1qF7XFJIyoURDThg6W2vjpoVjtEA21mtivCRoW0D/M462eprigX/Q6p95FtoDuHPI
         0a/rmZd8nGQeBmQz/ztNPkX62tA4y81xU5y0syLhd58WIhouaFbgNhzOj8ESbFiHzWAn
         dm1iSbOYQq+tt0FhDYGfCKogOIk4YId4K2FJ0lL7or76vWAHvyB+6gwQrPE8BiU73PJB
         /tkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NHX+kL7EY4iloI7diQJ1yXH749aKrxTAxYbMeAfU1qs=;
        b=gkLh1l5sGf5AeeZanxdd14P3XX5La55w5GO/EC5B+ADhKLLeQVlQkTl1qVFvrjHZWY
         /wcFaJogOiqIBZPGbeaKBecYnCqs3B3mnRP9WvZ6mwQISQZWk5vPft2t7AfTOMFlbacu
         GLtrcwfvv8673iNftMvi5q5MNs9aBSB2Gb+J1PNx3Z1YSpKo+7NhtcoissuB8gWI89/T
         nTzIpg6zueSLa0dkEMfx6MiaZ1KkO3d9+q/yllvGnf6qTi9FmXTFJYaxMJA20yBthI/n
         MFLhnhCodKryJYN9ZkyASMje3abvWUNJZvkuOmvWsw0tz2a8RwILsBP+bwIJODpUmhqk
         R9QA==
X-Gm-Message-State: APjAAAU/duMO2vI5ZJ0bQsX5FbjZ/GVc0gyHaN1hVp069PASWXyAEv69
        sUPE4k4zYcSLFrOEs2oeOUi+Uo/t
X-Google-Smtp-Source: APXvYqyi0S8V0/b9yCvu5OaSR3wE6ZZUPzWEjtI3SkgcM8fSpnKgKkiN/+sUavbckDZ0BadkWRhUOQ==
X-Received: by 2002:ab0:4147:: with SMTP id j65mr20964492uad.142.1558990074863;
        Mon, 27 May 2019 13:47:54 -0700 (PDT)
Received: from willemb1.nyc.corp.google.com ([2620:0:1003:315:3fa1:a34c:1128:1d39])
        by smtp.gmail.com with ESMTPSA id x19sm4171960vsq.9.2019.05.27.13.47.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 May 2019 13:47:53 -0700 (PDT)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Willem de Bruijn <willemb@google.com>
Subject: [PATCH net-next] selftests/net: ipv6 flowlabel
Date:   Mon, 27 May 2019 16:47:51 -0400
Message-Id: <20190527204751.47643-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Test the IPv6 flowlabel control and datapath interfaces:

Acquire and release the right to use flowlabels with socket option
IPV6_FLOWLABEL_MGR.

Then configure flowlabels on send and read them on recv with cmsg
IPV6_FLOWINFO. Also verify auto-flowlabel if not explicitly set.

This helped identify the issue fixed in commit 95c169251bf73 ("ipv6:
invert flowlabel sharing check in process and user mode")

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/net/.gitignore        |   2 +
 tools/testing/selftests/net/Makefile          |   4 +-
 tools/testing/selftests/net/ipv6_flowlabel.c  | 230 ++++++++++++++++++
 tools/testing/selftests/net/ipv6_flowlabel.sh |  22 ++
 .../selftests/net/ipv6_flowlabel_mgr.c        | 200 +++++++++++++++
 5 files changed, 456 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/net/ipv6_flowlabel.c
 create mode 100755 tools/testing/selftests/net/ipv6_flowlabel.sh
 create mode 100644 tools/testing/selftests/net/ipv6_flowlabel_mgr.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 27ef4d07ac915..99a4e41d52499 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -18,3 +18,5 @@ tls
 txring_overwrite
 ip_defrag
 so_txtime
+flowlabel
+flowlabel_mgr
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8af7869e0f1c8..8343fb9d8a463 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -9,13 +9,13 @@ TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
 TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
-TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh
+TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
-TEST_GEN_FILES += so_txtime
+TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/ipv6_flowlabel.c b/tools/testing/selftests/net/ipv6_flowlabel.c
new file mode 100644
index 0000000000000..7b1cf51084a62
--- /dev/null
+++ b/tools/testing/selftests/net/ipv6_flowlabel.c
@@ -0,0 +1,230 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Test IPV6_FLOWINFO cmsg on send and recv */
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <asm/byteorder.h>
+#include <error.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <limits.h>
+#include <linux/in6.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+/* uapi/glibc weirdness may leave this undefined */
+#ifndef IPV6_FLOWINFO
+#define IPV6_FLOWINFO 11
+#endif
+
+#ifndef IPV6_FLOWLABEL_MGR
+#define IPV6_FLOWLABEL_MGR 32
+#endif
+
+#define FLOWLABEL_WILDCARD	((uint32_t) -1)
+
+static const char cfg_data[]	= "a";
+static uint32_t cfg_label	= 1;
+
+static void do_send(int fd, bool with_flowlabel, uint32_t flowlabel)
+{
+	char control[CMSG_SPACE(sizeof(flowlabel))] = {0};
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	int ret;
+
+	iov.iov_base = (char *)cfg_data;
+	iov.iov_len = sizeof(cfg_data);
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	if (with_flowlabel) {
+		struct cmsghdr *cm;
+
+		cm = (void *)control;
+		cm->cmsg_len = CMSG_LEN(sizeof(flowlabel));
+		cm->cmsg_level = SOL_IPV6;
+		cm->cmsg_type = IPV6_FLOWINFO;
+		*(uint32_t *)CMSG_DATA(cm) = htonl(flowlabel);
+
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
+	}
+
+	ret = sendmsg(fd, &msg, 0);
+	if (ret == -1)
+		error(1, errno, "send");
+
+	if (with_flowlabel)
+		fprintf(stderr, "sent with label %u\n", flowlabel);
+	else
+		fprintf(stderr, "sent without label\n");
+}
+
+static void do_recv(int fd, bool with_flowlabel, uint32_t expect)
+{
+	char control[CMSG_SPACE(sizeof(expect))];
+	char data[sizeof(cfg_data)];
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	struct cmsghdr *cm;
+	uint32_t flowlabel;
+	int ret;
+
+	iov.iov_base = data;
+	iov.iov_len = sizeof(data);
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	memset(control, 0, sizeof(control));
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+
+	ret = recvmsg(fd, &msg, 0);
+	if (ret == -1)
+		error(1, errno, "recv");
+	if (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))
+		error(1, 0, "recv: truncated");
+	if (ret != sizeof(cfg_data))
+		error(1, 0, "recv: length mismatch");
+	if (memcmp(data, cfg_data, sizeof(data)))
+		error(1, 0, "recv: data mismatch");
+
+	cm = CMSG_FIRSTHDR(&msg);
+	if (with_flowlabel) {
+		if (!cm)
+			error(1, 0, "recv: missing cmsg");
+		if (CMSG_NXTHDR(&msg, cm))
+			error(1, 0, "recv: too many cmsg");
+		if (cm->cmsg_level != SOL_IPV6 ||
+		    cm->cmsg_type != IPV6_FLOWINFO)
+			error(1, 0, "recv: unexpected cmsg level or type");
+
+		flowlabel = ntohl(*(uint32_t *)CMSG_DATA(cm));
+		fprintf(stderr, "recv with label %u\n", flowlabel);
+
+		if (expect != FLOWLABEL_WILDCARD && expect != flowlabel)
+			fprintf(stderr, "recv: incorrect flowlabel %u != %u\n",
+					flowlabel, expect);
+
+	} else {
+		fprintf(stderr, "recv without label\n");
+	}
+}
+
+static bool get_autoflowlabel_enabled(void)
+{
+	int fd, ret;
+	char val;
+
+	fd = open("/proc/sys/net/ipv6/auto_flowlabels", O_RDONLY);
+	if (fd == -1)
+		error(1, errno, "open sysctl");
+
+	ret = read(fd, &val, 1);
+	if (ret == -1)
+		error(1, errno, "read sysctl");
+	if (ret == 0)
+		error(1, 0, "read sysctl: 0");
+
+	if (close(fd))
+		error(1, errno, "close sysctl");
+
+	return val == '1';
+}
+
+static void flowlabel_get(int fd, uint32_t label, uint8_t share, uint16_t flags)
+{
+	struct in6_flowlabel_req req = {
+		.flr_action = IPV6_FL_A_GET,
+		.flr_label = htonl(label),
+		.flr_flags = flags,
+		.flr_share = share,
+	};
+
+	/* do not pass IPV6_ADDR_ANY or IPV6_ADDR_MAPPED */
+	req.flr_dst.s6_addr[0] = 0xfd;
+	req.flr_dst.s6_addr[15] = 0x1;
+
+	if (setsockopt(fd, SOL_IPV6, IPV6_FLOWLABEL_MGR, &req, sizeof(req)))
+		error(1, errno, "setsockopt flowlabel get");
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "l:")) != -1) {
+		switch (c) {
+		case 'l':
+			cfg_label = strtoul(optarg, NULL, 0);
+			break;
+		default:
+			error(1, 0, "%s: parse error", argv[0]);
+		}
+	}
+}
+
+int main(int argc, char **argv)
+{
+	struct sockaddr_in6 addr = {
+		.sin6_family = AF_INET6,
+		.sin6_port = htons(8000),
+		.sin6_addr = IN6ADDR_LOOPBACK_INIT,
+	};
+	const int one = 1;
+	int fdt, fdr;
+
+	parse_opts(argc, argv);
+
+	fdt = socket(PF_INET6, SOCK_DGRAM, 0);
+	if (fdt == -1)
+		error(1, errno, "socket t");
+
+	fdr = socket(PF_INET6, SOCK_DGRAM, 0);
+	if (fdr == -1)
+		error(1, errno, "socket r");
+
+	if (connect(fdt, (void *)&addr, sizeof(addr)))
+		error(1, errno, "connect");
+	if (bind(fdr, (void *)&addr, sizeof(addr)))
+		error(1, errno, "bind");
+
+	flowlabel_get(fdt, cfg_label, IPV6_FL_S_EXCL, IPV6_FL_F_CREATE);
+
+	if (setsockopt(fdr, SOL_IPV6, IPV6_FLOWINFO, &one, sizeof(one)))
+		error(1, errno, "setsockopt flowinfo");
+
+	if (get_autoflowlabel_enabled()) {
+		fprintf(stderr, "send no label: recv auto flowlabel\n");
+		do_send(fdt, false, 0);
+		do_recv(fdr, true, FLOWLABEL_WILDCARD);
+	} else {
+		fprintf(stderr, "send no label: recv no label (auto off)\n");
+		do_send(fdt, false, 0);
+		do_recv(fdr, false, 0);
+	}
+
+	fprintf(stderr, "send label\n");
+	do_send(fdt, true, cfg_label);
+	do_recv(fdr, true, cfg_label);
+
+	if (close(fdr))
+		error(1, errno, "close r");
+	if (close(fdt))
+		error(1, errno, "close t");
+
+	return 0;
+}
+
diff --git a/tools/testing/selftests/net/ipv6_flowlabel.sh b/tools/testing/selftests/net/ipv6_flowlabel.sh
new file mode 100755
index 0000000000000..5d89fd8dbfc7d
--- /dev/null
+++ b/tools/testing/selftests/net/ipv6_flowlabel.sh
@@ -0,0 +1,22 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Regression tests for IPv6 flowlabels
+#
+# run in separate namespaces to avoid mgmt db conflicts betweent tests
+
+set -e
+
+echo "TEST management"
+./in_netns.sh ./ipv6_flowlabel_mgr
+
+echo "TEST datapath"
+./in_netns.sh \
+  sh -c 'sysctl -q -w net.ipv6.auto_flowlabels=0 && ./ipv6_flowlabel -l 1'
+
+echo "TEST datapath (with auto-flowlabels)"
+./in_netns.sh \
+  sh -c 'sysctl -q -w net.ipv6.auto_flowlabels=1 && ./ipv6_flowlabel -l 1'
+
+echo OK. All tests passed
+
diff --git a/tools/testing/selftests/net/ipv6_flowlabel_mgr.c b/tools/testing/selftests/net/ipv6_flowlabel_mgr.c
new file mode 100644
index 0000000000000..153ba6aad81f4
--- /dev/null
+++ b/tools/testing/selftests/net/ipv6_flowlabel_mgr.c
@@ -0,0 +1,200 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Test IPV6_FLOWINFO_MGR */
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <error.h>
+#include <errno.h>
+#include <limits.h>
+#include <linux/in6.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+/* uapi/glibc weirdness may leave this undefined */
+#ifndef IPV6_FLOWLABEL_MGR
+#define IPV6_FLOWLABEL_MGR	32
+#endif
+
+/* from net/ipv6/ip6_flowlabel.c */
+#define FL_MIN_LINGER		6
+
+#define explain(x)							\
+	do { if (cfg_verbose) fprintf(stderr, "       " x "\n"); } while (0)
+
+#define __expect(x)							\
+	do {								\
+		if (!(x))						\
+			fprintf(stderr, "[OK]   " #x "\n");		\
+		else							\
+			error(1, 0, "[ERR]  " #x " (line %d)", __LINE__); \
+	} while (0)
+
+#define expect_pass(x)	__expect(x)
+#define expect_fail(x)	__expect(!(x))
+
+static bool cfg_long_running;
+static bool cfg_verbose;
+
+static int flowlabel_get(int fd, uint32_t label, uint8_t share, uint16_t flags)
+{
+	struct in6_flowlabel_req req = {
+		.flr_action = IPV6_FL_A_GET,
+		.flr_label = htonl(label),
+		.flr_flags = flags,
+		.flr_share = share,
+	};
+
+	/* do not pass IPV6_ADDR_ANY or IPV6_ADDR_MAPPED */
+	req.flr_dst.s6_addr[0] = 0xfd;
+	req.flr_dst.s6_addr[15] = 0x1;
+
+	return setsockopt(fd, SOL_IPV6, IPV6_FLOWLABEL_MGR, &req, sizeof(req));
+}
+
+static int flowlabel_put(int fd, uint32_t label)
+{
+	struct in6_flowlabel_req req = {
+		.flr_action = IPV6_FL_A_PUT,
+		.flr_label = htonl(label),
+	};
+
+	return setsockopt(fd, SOL_IPV6, IPV6_FLOWLABEL_MGR, &req, sizeof(req));
+}
+
+static void run_tests(int fd)
+{
+	int wstatus;
+	pid_t pid;
+
+	explain("cannot get non-existent label");
+	expect_fail(flowlabel_get(fd, 1, IPV6_FL_S_ANY, 0));
+
+	explain("cannot put non-existent label");
+	expect_fail(flowlabel_put(fd, 1));
+
+	explain("cannot create label greater than 20 bits");
+	expect_fail(flowlabel_get(fd, 0x1FFFFF, IPV6_FL_S_ANY,
+				  IPV6_FL_F_CREATE));
+
+	explain("create a new label (FL_F_CREATE)");
+	expect_pass(flowlabel_get(fd, 1, IPV6_FL_S_ANY, IPV6_FL_F_CREATE));
+	explain("can get the label (without FL_F_CREATE)");
+	expect_pass(flowlabel_get(fd, 1, IPV6_FL_S_ANY, 0));
+	explain("can get it again with create flag set, too");
+	expect_pass(flowlabel_get(fd, 1, IPV6_FL_S_ANY, IPV6_FL_F_CREATE));
+	explain("cannot get it again with the exclusive (FL_FL_EXCL) flag");
+	expect_fail(flowlabel_get(fd, 1, IPV6_FL_S_ANY,
+					 IPV6_FL_F_CREATE | IPV6_FL_F_EXCL));
+	explain("can now put exactly three references");
+	expect_pass(flowlabel_put(fd, 1));
+	expect_pass(flowlabel_put(fd, 1));
+	expect_pass(flowlabel_put(fd, 1));
+	expect_fail(flowlabel_put(fd, 1));
+
+	explain("create a new exclusive label (FL_S_EXCL)");
+	expect_pass(flowlabel_get(fd, 2, IPV6_FL_S_EXCL, IPV6_FL_F_CREATE));
+	explain("cannot get it again in non-exclusive mode");
+	expect_fail(flowlabel_get(fd, 2, IPV6_FL_S_ANY,  IPV6_FL_F_CREATE));
+	explain("cannot get it again in exclusive mode either");
+	expect_fail(flowlabel_get(fd, 2, IPV6_FL_S_EXCL, IPV6_FL_F_CREATE));
+	expect_pass(flowlabel_put(fd, 2));
+
+	if (cfg_long_running) {
+		explain("cannot reuse the label, due to linger");
+		expect_fail(flowlabel_get(fd, 2, IPV6_FL_S_ANY,
+					  IPV6_FL_F_CREATE));
+		explain("after sleep, can reuse");
+		sleep(FL_MIN_LINGER * 2 + 1);
+		expect_pass(flowlabel_get(fd, 2, IPV6_FL_S_ANY,
+					  IPV6_FL_F_CREATE));
+	}
+
+	explain("create a new user-private label (FL_S_USER)");
+	expect_pass(flowlabel_get(fd, 3, IPV6_FL_S_USER, IPV6_FL_F_CREATE));
+	explain("cannot get it again in non-exclusive mode");
+	expect_fail(flowlabel_get(fd, 3, IPV6_FL_S_ANY, 0));
+	explain("cannot get it again in exclusive mode");
+	expect_fail(flowlabel_get(fd, 3, IPV6_FL_S_EXCL, 0));
+	explain("can get it again in user mode");
+	expect_pass(flowlabel_get(fd, 3, IPV6_FL_S_USER, 0));
+	explain("child process can get it too, but not after setuid(nobody)");
+	pid = fork();
+	if (pid == -1)
+		error(1, errno, "fork");
+	if (!pid) {
+		expect_pass(flowlabel_get(fd, 3, IPV6_FL_S_USER, 0));
+		if (setuid(USHRT_MAX))
+			fprintf(stderr, "[INFO] skip setuid child test\n");
+		else
+			expect_fail(flowlabel_get(fd, 3, IPV6_FL_S_USER, 0));
+		exit(0);
+	}
+	if (wait(&wstatus) == -1)
+		error(1, errno, "wait");
+	if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus) != 0)
+		error(1, errno, "wait: unexpected child result");
+
+	explain("create a new process-private label (FL_S_PROCESS)");
+	expect_pass(flowlabel_get(fd, 4, IPV6_FL_S_PROCESS, IPV6_FL_F_CREATE));
+	explain("can get it again");
+	expect_pass(flowlabel_get(fd, 4, IPV6_FL_S_PROCESS, 0));
+	explain("child process cannot can get it");
+	pid = fork();
+	if (pid == -1)
+		error(1, errno, "fork");
+	if (!pid) {
+		expect_fail(flowlabel_get(fd, 4, IPV6_FL_S_PROCESS, 0));
+		exit(0);
+	}
+	if (wait(&wstatus) == -1)
+		error(1, errno, "wait");
+	if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus) != 0)
+		error(1, errno, "wait: unexpected child result");
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "lv")) != -1) {
+		switch (c) {
+		case 'l':
+			cfg_long_running = true;
+			break;
+		case 'v':
+			cfg_verbose = true;
+			break;
+		default:
+			error(1, 0, "%s: parse error", argv[0]);
+		}
+	}
+}
+
+int main(int argc, char **argv)
+{
+	int fd;
+
+	parse_opts(argc, argv);
+
+	fd = socket(PF_INET6, SOCK_DGRAM, 0);
+	if (fd == -1)
+		error(1, errno, "socket");
+
+	run_tests(fd);
+
+	if (close(fd))
+		error(1, errno, "close");
+
+	return 0;
+}
+
-- 
2.22.0.rc1.257.g3120a18244-goog

