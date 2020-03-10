Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D135D17F173
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 09:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgCJIGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 04:06:09 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:11708 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgCJIGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 04:06:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1583827569; x=1615363569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=3mkSj8vWIuyo8kfcrz+ekAJnprGunmVLQ96tqiCY5kg=;
  b=jWlxZ7V5p75oOVcbVXWvS4hRytq6vEeA9FpYqhclw3qwkTdooqq5iL5t
   DFhuGpMQ1UZ24VX8LmBGd2jhi4bdcHA0b4hWi0ZJFHle80H1IvIYzOdfJ
   YdFcDyhOnoPk7JQO4ZGWraS54w+IilSqHOK2lrdsePs1QQT/14R8MKQOp
   o=;
IronPort-SDR: mSQW4W38zdE9Q4lc8LK9LBrSUAFUfYGrqKL6O9fIClaGYNg0Ca7dzPJzvrPD7P0vDT48KGwoVX
 T8/V2zZF22rw==
X-IronPort-AV: E=Sophos;i="5.70,535,1574121600"; 
   d="scan'208";a="21802807"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-f273de60.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 10 Mar 2020 08:06:08 +0000
Received: from EX13MTAUWA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1d-f273de60.us-east-1.amazon.com (Postfix) with ESMTPS id 72606A211D;
        Tue, 10 Mar 2020 08:06:07 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.118) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 10 Mar 2020 08:06:06 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.160.16) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 10 Mar 2020 08:06:03 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v5 net-next 4/4] selftests: net: Add SO_REUSEADDR test to check if 4-tuples are fully utilized.
Date:   Tue, 10 Mar 2020 17:05:27 +0900
Message-ID: <20200310080527.70180-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200310080527.70180-1-kuniyu@amazon.co.jp>
References: <20200310080527.70180-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.16]
X-ClientProxiedBy: EX13D34UWA003.ant.amazon.com (10.43.160.69) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds a test to check if we can fully utilize 4-tuples for
connect() when all ephemeral ports are exhausted.

The test program changes the local port range to use only one port and binds
two sockets with or without SO_REUSEADDR and SO_REUSEPORT, and with the same
EUID or with different EUIDs, then do listen().

We should be able to bind only one socket having both SO_REUSEADDR and
SO_REUSEPORT per EUID, which restriction is to prevent unintentional
listen().

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/reuseaddr_ports_exhausted.c | 162 ++++++++++++++++++
 .../net/reuseaddr_ports_exhausted.sh          |  35 ++++
 4 files changed, 200 insertions(+)
 create mode 100644 tools/testing/selftests/net/reuseaddr_ports_exhausted.c
 create mode 100755 tools/testing/selftests/net/reuseaddr_ports_exhausted.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index ecc52d4c034d..91f9aea853b1 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -23,3 +23,4 @@ so_txtime
 tcp_fastopen_backup_key
 nettest
 fin_ack_lat
+reuseaddr_ports_exhausted
\ No newline at end of file
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index b5694196430a..ded1aa394880 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -12,6 +12,7 @@ TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_a
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
 TEST_PROGS += fin_ack_lat.sh
+TEST_PROGS += reuseaddr_ports_exhausted.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
@@ -22,6 +23,7 @@ TEST_GEN_FILES += tcp_fastopen_backup_key
 TEST_GEN_FILES += fin_ack_lat
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
+TEST_GEN_FILES += reuseaddr_ports_exhausted
 
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
diff --git a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
new file mode 100644
index 000000000000..7b01b7c2ec10
--- /dev/null
+++ b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Check if we can fully utilize 4-tuples for connect().
+ *
+ * Rules to bind sockets to the same port when all ephemeral ports are
+ * exhausted.
+ *
+ *   1. if there are TCP_LISTEN sockets on the port, fail to bind.
+ *   2. if there are sockets without SO_REUSEADDR, fail to bind.
+ *   3. if SO_REUSEADDR is disabled, fail to bind.
+ *   4. if SO_REUSEADDR is enabled and SO_REUSEPORT is disabled,
+ *        succeed to bind.
+ *   5. if SO_REUSEADDR and SO_REUSEPORT are enabled and
+ *        there is no socket having the both options and the same EUID,
+ *        succeed to bind.
+ *   6. fail to bind.
+ *
+ * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
+ */
+#include <arpa/inet.h>
+#include <netinet/in.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <unistd.h>
+#include "../kselftest_harness.h"
+
+struct reuse_opts {
+	int reuseaddr[2];
+	int reuseport[2];
+};
+
+struct reuse_opts unreusable_opts[12] = {
+	{0, 0, 0, 0},
+	{0, 0, 0, 1},
+	{0, 0, 1, 0},
+	{0, 0, 1, 1},
+	{0, 1, 0, 0},
+	{0, 1, 0, 1},
+	{0, 1, 1, 0},
+	{0, 1, 1, 1},
+	{1, 0, 0, 0},
+	{1, 0, 0, 1},
+	{1, 0, 1, 0},
+	{1, 0, 1, 1},
+};
+
+struct reuse_opts reusable_opts[4] = {
+	{1, 1, 0, 0},
+	{1, 1, 0, 1},
+	{1, 1, 1, 0},
+	{1, 1, 1, 1},
+};
+
+int bind_port(struct __test_metadata *_metadata, int reuseaddr, int reuseport)
+{
+	struct sockaddr_in local_addr;
+	int len = sizeof(local_addr);
+	int fd, ret;
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	ASSERT_NE(-1, fd) TH_LOG("failed to open socket.");
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &reuseaddr, sizeof(int));
+	ASSERT_EQ(0, ret) TH_LOG("failed to setsockopt: SO_REUSEADDR.");
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &reuseport, sizeof(int));
+	ASSERT_EQ(0, ret) TH_LOG("failed to setsockopt: SO_REUSEPORT.");
+
+	local_addr.sin_family = AF_INET;
+	local_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
+	local_addr.sin_port = 0;
+
+	if (bind(fd, (struct sockaddr *)&local_addr, len) == -1) {
+		close(fd);
+		return -1;
+	}
+
+	return fd;
+}
+
+TEST(reuseaddr_ports_exhausted_unreusable)
+{
+	struct reuse_opts *opts;
+	int i, j, fd[2];
+
+	for (i = 0; i < 12; i++) {
+		opts = &unreusable_opts[i];
+
+		for (j = 0; j < 2; j++)
+			fd[j] = bind_port(_metadata, opts->reuseaddr[j], opts->reuseport[j]);
+
+		ASSERT_NE(-1, fd[0]) TH_LOG("failed to bind.");
+		EXPECT_EQ(-1, fd[1]) TH_LOG("should fail to bind.");
+
+		for (j = 0; j < 2; j++)
+			if (fd[j] != -1)
+				close(fd[j]);
+	}
+}
+
+TEST(reuseaddr_ports_exhausted_reusable_same_euid)
+{
+	struct reuse_opts *opts;
+	int i, j, fd[2];
+
+	for (i = 0; i < 4; i++) {
+		opts = &reusable_opts[i];
+
+		for (j = 0; j < 2; j++)
+			fd[j] = bind_port(_metadata, opts->reuseaddr[j], opts->reuseport[j]);
+
+		ASSERT_NE(-1, fd[0]) TH_LOG("failed to bind.");
+
+		if (opts->reuseport[0] && opts->reuseport[1]) {
+			EXPECT_EQ(-1, fd[1]) TH_LOG("should fail to bind because both sockets succeed to be listened.");
+		} else {
+			EXPECT_NE(-1, fd[1]) TH_LOG("should succeed to bind to connect to different destinations.");
+		}
+
+		for (j = 0; j < 2; j++)
+			if (fd[j] != -1)
+				close(fd[j]);
+	}
+}
+
+TEST(reuseaddr_ports_exhausted_reusable_different_euid)
+{
+	struct reuse_opts *opts;
+	int i, j, ret, fd[2];
+	uid_t euid[2] = {10, 20};
+
+	for (i = 0; i < 4; i++) {
+		opts = &reusable_opts[i];
+
+		for (j = 0; j < 2; j++) {
+			ret = seteuid(euid[j]);
+			ASSERT_EQ(0, ret) TH_LOG("failed to seteuid: %d.", euid[j]);
+
+			fd[j] = bind_port(_metadata, opts->reuseaddr[j], opts->reuseport[j]);
+
+			ret = seteuid(0);
+			ASSERT_EQ(0, ret) TH_LOG("failed to seteuid: 0.");
+		}
+
+		ASSERT_NE(-1, fd[0]) TH_LOG("failed to bind.");
+		EXPECT_NE(-1, fd[1]) TH_LOG("should succeed to bind because one socket can be bound in each euid.");
+
+		if (fd[1] != -1) {
+			ret = listen(fd[0], 5);
+			ASSERT_EQ(0, ret) TH_LOG("failed to listen.");
+
+			ret = listen(fd[1], 5);
+			EXPECT_EQ(-1, ret) TH_LOG("should fail to listen because only one uid reserves the port in TCP_LISTEN.");
+		}
+
+		for (j = 0; j < 2; j++)
+			if (fd[j] != -1)
+				close(fd[j]);
+	}
+}
+
+TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/net/reuseaddr_ports_exhausted.sh b/tools/testing/selftests/net/reuseaddr_ports_exhausted.sh
new file mode 100755
index 000000000000..20e3a2913d06
--- /dev/null
+++ b/tools/testing/selftests/net/reuseaddr_ports_exhausted.sh
@@ -0,0 +1,35 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Run tests when all ephemeral ports are exhausted.
+#
+# Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
+
+set +x
+set -e
+
+readonly NETNS="ns-$(mktemp -u XXXXXX)"
+
+setup() {
+	ip netns add "${NETNS}"
+	ip -netns "${NETNS}" link set lo up
+	ip netns exec "${NETNS}" \
+		sysctl -w net.ipv4.ip_local_port_range="32768 32768" \
+		> /dev/null 2>&1
+	ip netns exec "${NETNS}" \
+		sysctl -w net.ipv4.ip_autobind_reuse=1 > /dev/null 2>&1
+}
+
+cleanup() {
+	ip netns del "${NETNS}"
+}
+
+trap cleanup EXIT
+setup
+
+do_test() {
+	ip netns exec "${NETNS}" ./reuseaddr_ports_exhausted
+}
+
+do_test
+echo "tests done"
-- 
2.17.2 (Apple Git-113)

