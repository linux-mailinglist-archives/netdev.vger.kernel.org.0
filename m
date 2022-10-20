Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE207606600
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 18:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiJTQki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 12:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiJTQkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 12:40:36 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4C9107A89
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 09:40:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1666284033; x=1697820033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YXw1b3XgriyD30sSGw9fg7DC0LyysnnVUtjFwOrSxZ4=;
  b=jud9v7CU9Rp3LS/4UISO7teuVfj7oued8/V/NUfprcN1SGD4s8YGapB2
   fu8/cJvvKb1rrRwU00joq7j+/Jx+y5V2no+7r8FFIgXFvuw1yJjxP0rs+
   tnbd9prL26K0tgbyN+M5o5IQ1+iawYkj/RRsNjmlq/dbml1Qqw3vygnGL
   8=;
X-IronPort-AV: E=Sophos;i="5.95,199,1661817600"; 
   d="scan'208";a="254293558"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2022 16:40:32 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id C8824416CC;
        Thu, 20 Oct 2022 16:40:29 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 20 Oct 2022 16:40:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.208) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.15;
 Thu, 20 Oct 2022 16:40:26 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Martin KaFai Lau <martin.lau@kernel.org>,
        Craig Gallek <kraig@google.com>,
        Kazuho Oku <kazuhooku@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 2/2] selftest: Add test for SO_INCOMING_CPU.
Date:   Thu, 20 Oct 2022 09:39:54 -0700
Message-ID: <20221020163954.93618-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221020163954.93618-1-kuniyu@amazon.com>
References: <20221020163954.93618-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.208]
X-ClientProxiedBy: EX13D15UWA003.ant.amazon.com (10.43.160.182) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some highly optimised applications use SO_INCOMING_CPU to make them
efficient, but they didn't test if it's working correctly by getsockopt()
to avoid slowing down.  As a result, no one noticed it had been broken
for years, so it's a good time to add a test to catch future regression.

The test basically does

  1) Create $(nproc) TCP listeners associated with each CPU.

  2) Create 32 child sockets for each listener by calling
     sched_setaffinity() for each CPU.

  3) Check if accept()ed sockets' sk_incoming_cpu matches
     listener's one.

If we see -EAGAIN, SO_INCOMING_CPU is broken.  However, we might not see
any error even if broken; the kernel could miraculously distribute all SYN
to correct listeners.  Not to let that happen, we must increase the number
of clients and CPUs to some extent, so the test requires $(nproc) >= 2 and
creates 64 sockets at least.

Test:
  $ nproc
  96
  $ ./so_incoming_cpu

Before the previous patch:

  # Starting 12 tests from 5 test cases.
  #  RUN           so_incoming_cpu.before_reuseport.test1 ...
  # so_incoming_cpu.c:191:test1:Expected cpu (5) == i (0)
  # test1: Test terminated by assertion
  #          FAIL  so_incoming_cpu.before_reuseport.test1
  not ok 1 so_incoming_cpu.before_reuseport.test1
  ...
  # FAILED: 0 / 12 tests passed.
  # Totals: pass:0 fail:12 xfail:0 xpass:0 skip:0 error:0

After:

  # Starting 12 tests from 5 test cases.
  #  RUN           so_incoming_cpu.before_reuseport.test1 ...
  # so_incoming_cpu.c:199:test1:SO_INCOMING_CPU is very likely to be working correctly with 3072 sockets.
  #            OK  so_incoming_cpu.before_reuseport.test1
  ok 1 so_incoming_cpu.before_reuseport.test1
  ...
  # PASSED: 12 / 12 tests passed.
  # Totals: pass:12 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/so_incoming_cpu.c | 242 ++++++++++++++++++
 3 files changed, 244 insertions(+)
 create mode 100644 tools/testing/selftests/net/so_incoming_cpu.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 3d7adee7a3e6..ff8807cc9c2e 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -25,6 +25,7 @@ rxtimestamp
 sk_bind_sendto_listen
 sk_connect_zero_addr
 socket
+so_incoming_cpu
 so_netns_cookie
 so_txtime
 stress_reuseport_listen
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 2a6b0bc648c4..ba57e7e7dc86 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -70,6 +70,7 @@ TEST_PROGS += io_uring_zerocopy_tx.sh
 TEST_GEN_FILES += bind_bhash
 TEST_GEN_PROGS += sk_bind_sendto_listen
 TEST_GEN_PROGS += sk_connect_zero_addr
+TEST_GEN_PROGS += so_incoming_cpu
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/so_incoming_cpu.c b/tools/testing/selftests/net/so_incoming_cpu.c
new file mode 100644
index 000000000000..0e04f9fef986
--- /dev/null
+++ b/tools/testing/selftests/net/so_incoming_cpu.c
@@ -0,0 +1,242 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+#define _GNU_SOURCE
+#include <sched.h>
+
+#include <netinet/in.h>
+#include <sys/socket.h>
+#include <sys/sysinfo.h>
+
+#include "../kselftest_harness.h"
+
+#define CLIENT_PER_SERVER	32 /* More sockets, more reliable */
+#define NR_SERVER		self->nproc
+#define NR_CLIENT		(CLIENT_PER_SERVER * NR_SERVER)
+
+FIXTURE(so_incoming_cpu)
+{
+	int nproc;
+	int *servers;
+	union {
+		struct sockaddr addr;
+		struct sockaddr_in in_addr;
+	};
+	socklen_t addrlen;
+};
+
+enum when_to_set {
+	BEFORE_REUSEPORT,
+	BEFORE_LISTEN,
+	AFTER_LISTEN,
+	AFTER_ALL_LISTEN,
+};
+
+FIXTURE_VARIANT(so_incoming_cpu)
+{
+	int when_to_set;
+};
+
+FIXTURE_VARIANT_ADD(so_incoming_cpu, before_reuseport)
+{
+	.when_to_set = BEFORE_REUSEPORT,
+};
+
+FIXTURE_VARIANT_ADD(so_incoming_cpu, before_listen)
+{
+	.when_to_set = BEFORE_LISTEN,
+};
+
+FIXTURE_VARIANT_ADD(so_incoming_cpu, after_listen)
+{
+	.when_to_set = AFTER_LISTEN,
+};
+
+FIXTURE_VARIANT_ADD(so_incoming_cpu, after_all_listen)
+{
+	.when_to_set = AFTER_ALL_LISTEN,
+};
+
+FIXTURE_SETUP(so_incoming_cpu)
+{
+	self->nproc = get_nprocs();
+	ASSERT_LE(2, self->nproc);
+
+	self->servers = malloc(sizeof(int) * NR_SERVER);
+	ASSERT_NE(self->servers, NULL);
+
+	self->in_addr.sin_family = AF_INET;
+	self->in_addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
+	self->in_addr.sin_port = htons(0);
+	self->addrlen = sizeof(struct sockaddr_in);
+}
+
+FIXTURE_TEARDOWN(so_incoming_cpu)
+{
+	int i;
+
+	for (i = 0; i < NR_SERVER; i++)
+		close(self->servers[i]);
+
+	free(self->servers);
+}
+
+void set_so_incoming_cpu(struct __test_metadata *_metadata, int fd, int cpu)
+{
+	int ret;
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_INCOMING_CPU, &cpu, sizeof(int));
+	ASSERT_EQ(ret, 0);
+}
+
+int create_server(struct __test_metadata *_metadata,
+		  FIXTURE_DATA(so_incoming_cpu) *self,
+		  const FIXTURE_VARIANT(so_incoming_cpu) *variant,
+		  int cpu)
+{
+	int fd, ret;
+
+	fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
+	ASSERT_NE(fd, -1);
+
+	if (variant->when_to_set == BEFORE_REUSEPORT)
+		set_so_incoming_cpu(_metadata, fd, cpu);
+
+	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &(int){1}, sizeof(int));
+	ASSERT_EQ(ret, 0);
+
+	ret = bind(fd, &self->addr, self->addrlen);
+	ASSERT_EQ(ret, 0);
+
+	if (variant->when_to_set == BEFORE_LISTEN)
+		set_so_incoming_cpu(_metadata, fd, cpu);
+
+	/* We don't use CLIENT_PER_SERVER here not to block
+	 * this test at connect() if SO_INCOMING_CPU is broken.
+	 */
+	ret = listen(fd, NR_CLIENT);
+	ASSERT_EQ(ret, 0);
+
+	if (variant->when_to_set == AFTER_LISTEN)
+		set_so_incoming_cpu(_metadata, fd, cpu);
+
+	return fd;
+}
+
+void create_servers(struct __test_metadata *_metadata,
+		    FIXTURE_DATA(so_incoming_cpu) *self,
+		    const FIXTURE_VARIANT(so_incoming_cpu) *variant)
+{
+	int i, ret;
+
+	for (i = 0; i < NR_SERVER; i++) {
+		self->servers[i] = create_server(_metadata, self, variant, i);
+
+		if (i == 0) {
+			ret = getsockname(self->servers[i], &self->addr, &self->addrlen);
+			ASSERT_EQ(ret, 0);
+		}
+	}
+
+	if (variant->when_to_set == AFTER_ALL_LISTEN) {
+		for (i = 0; i < NR_SERVER; i++)
+			set_so_incoming_cpu(_metadata, self->servers[i], i);
+	}
+}
+
+void create_clients(struct __test_metadata *_metadata,
+		    FIXTURE_DATA(so_incoming_cpu) *self)
+{
+	cpu_set_t cpu_set;
+	int i, j, fd, ret;
+
+	for (i = 0; i < NR_SERVER; i++) {
+		CPU_ZERO(&cpu_set);
+
+		CPU_SET(i, &cpu_set);
+		ASSERT_EQ(CPU_COUNT(&cpu_set), 1);
+		ASSERT_NE(CPU_ISSET(i, &cpu_set), 0);
+
+		/* Make sure SYN will be processed on the i-th CPU
+		 * and finally distributed to the i-th listener.
+		 */
+		sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
+		ASSERT_EQ(ret, 0);
+
+		for (j = 0; j < CLIENT_PER_SERVER; j++) {
+			fd  = socket(AF_INET, SOCK_STREAM, 0);
+			ASSERT_NE(fd, -1);
+
+			ret = connect(fd, &self->addr, self->addrlen);
+			ASSERT_EQ(ret, 0);
+
+			close(fd);
+		}
+	}
+}
+
+void verify_incoming_cpu(struct __test_metadata *_metadata,
+			 FIXTURE_DATA(so_incoming_cpu) *self)
+{
+	int i, j, fd, cpu, ret, total = 0;
+	socklen_t len = sizeof(int);
+
+	for (i = 0; i < NR_SERVER; i++) {
+		for (j = 0; j < CLIENT_PER_SERVER; j++) {
+			/* If we see -EAGAIN here, SO_INCOMING_CPU is broken */
+			fd = accept(self->servers[i], &self->addr, &self->addrlen);
+			ASSERT_NE(fd, -1);
+
+			ret = getsockopt(fd, SOL_SOCKET, SO_INCOMING_CPU, &cpu, &len);
+			ASSERT_EQ(ret, 0);
+			ASSERT_EQ(cpu, i);
+
+			close(fd);
+			total++;
+		}
+	}
+
+	ASSERT_EQ(total, NR_CLIENT);
+	TH_LOG("SO_INCOMING_CPU is very likely to be "
+	       "working correctly with %d sockets.", total);
+}
+
+TEST_F(so_incoming_cpu, test1)
+{
+	create_servers(_metadata, self, variant);
+	create_clients(_metadata, self);
+	verify_incoming_cpu(_metadata, self);
+}
+
+TEST_F(so_incoming_cpu, test2)
+{
+	int server;
+
+	create_servers(_metadata, self, variant);
+
+	/* No CPU specified */
+	server = create_server(_metadata, self, variant, -1);
+	close(server);
+
+	create_clients(_metadata, self);
+	verify_incoming_cpu(_metadata, self);
+}
+
+TEST_F(so_incoming_cpu, test3)
+{
+	int server, client;
+
+	create_servers(_metadata, self, variant);
+
+	/* No CPU specified */
+	server = create_server(_metadata, self, variant, -1);
+
+	create_clients(_metadata, self);
+
+	/* Never receive any requests */
+	client = accept(server, &self->addr, &self->addrlen);
+	ASSERT_EQ(client, -1);
+
+	verify_incoming_cpu(_metadata, self);
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

