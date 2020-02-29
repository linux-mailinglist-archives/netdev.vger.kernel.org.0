Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE0D17468A
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 12:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgB2LgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 06:36:20 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:9976 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbgB2LgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 06:36:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1582976179; x=1614512179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=i/mp1ppBhdIxBRUVaiauNz+4VxcfYdm4SNHS/tFHoMk=;
  b=ChkeLEkgzqX8wBGD5Ot1L+MXy6XADYkBCohcCYAEAMwwFKRYUYm7DSwc
   dBcrX908LmGOklKlBNOhi8R1fTO+zzG5jloxBHFpv60xYj5bUfP6nfzcA
   4rLbFW9XZ0HkpoUsVUcvJptovgxTjvmBF+No7+pMfqKQTtqS99bc2bPFr
   I=;
IronPort-SDR: 5k56Nk/vMH3nFYCeTr9LTR/Zoh/JK4z3sOUMPqwdDVC7xfetdKEo5d0Vi5ynaCSbTlSE2DsdFf
 i7risIbQjvWg==
X-IronPort-AV: E=Sophos;i="5.70,499,1574121600"; 
   d="scan'208";a="19405127"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 29 Feb 2020 11:36:19 +0000
Received: from EX13MTAUWA001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS id 55230A285A;
        Sat, 29 Feb 2020 11:36:17 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWA001.ant.amazon.com (10.43.160.58) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sat, 29 Feb 2020 11:36:16 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.171) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 29 Feb 2020 11:36:13 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <edumazet@google.com>
CC:     <kuniyu@amazon.co.jp>, <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <osa-contribution-log@amazon.com>
Subject: [PATCH v3 net-next 4/4] selftests: net: Add SO_REUSEADDR test to check if 4-tuples are fully utilized.
Date:   Sat, 29 Feb 2020 20:35:54 +0900
Message-ID: <20200229113554.78338-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20200229113554.78338-1-kuniyu@amazon.co.jp>
References: <20200229113554.78338-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.171]
X-ClientProxiedBy: EX13D23UWA003.ant.amazon.com (10.43.160.194) To
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
 tools/testing/selftests/net/Makefile          |   2 +
 .../selftests/net/reuseaddr_ports_exhausted.c | 162 ++++++++++++++++++
 .../net/reuseaddr_ports_exhausted.sh          |  33 ++++
 3 files changed, 197 insertions(+)
 create mode 100644 tools/testing/selftests/net/reuseaddr_ports_exhausted.c
 create mode 100755 tools/testing/selftests/net/reuseaddr_ports_exhausted.sh

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
index 000000000000..839269b7975a
--- /dev/null
+++ b/tools/testing/selftests/net/reuseaddr_ports_exhausted.sh
@@ -0,0 +1,33 @@
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

