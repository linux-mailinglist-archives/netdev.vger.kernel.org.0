Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808E85FA2D9
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 19:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJJRpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 13:45:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiJJRpH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 13:45:07 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344ED303C4;
        Mon, 10 Oct 2022 10:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1665423900; x=1696959900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yrpzirdanUNo3Rmou8WpWaygcBk7dngXfmcIA6gRLIw=;
  b=tJwBb3B5Dw+gO2oraGcqVxn4oJcJKT8H2GZiZ72ljo2aPY0NS2+sJLGc
   H7922ESmKkVqPJgNHUfBH/uKMnBluNrzlPbDTBApl9+C4d7FeOlLW4IjP
   uOAo95IufKfDrroG9s8rOT4CWRlpjiYmbbPPNO3j3pZjAMFN4PuvyQv0N
   Y=;
X-IronPort-AV: E=Sophos;i="5.95,173,1661817600"; 
   d="scan'208";a="253833959"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2022 17:44:59 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1d-b48bc93b.us-east-1.amazon.com (Postfix) with ESMTPS id 1C4C6C08B5;
        Mon, 10 Oct 2022 17:44:56 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 10 Oct 2022 17:44:55 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.124) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Mon, 10 Oct 2022 17:44:49 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>
CC:     Craig Gallek <kraig@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 3/3] selftest: Add test for SO_INCOMING_CPU.
Date:   Mon, 10 Oct 2022 10:43:51 -0700
Message-ID: <20221010174351.11024-4-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221010174351.11024-1-kuniyu@amazon.com>
References: <20221010174351.11024-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.124]
X-ClientProxiedBy: EX13D22UWC002.ant.amazon.com (10.43.162.29) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some highly optimised applications use SO_INCOMING_CPU to make them
efficient, but they didn't test if it's working correctly by getsockopt()
to avoid slowing down.  As a result, no one noticed it had been broken
for years, so it's a good time to add a test to catch future regression.

The test does

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

  # Starting 1 tests from 2 test cases.
  #  RUN           so_incoming_cpu.test1 ...
  # so_incoming_cpu.c:129:test1:Expected cpu (82) == i (0)
  # test1: Test terminated by assertion
  #          FAIL  so_incoming_cpu.test1
  not ok 1 so_incoming_cpu.test1
  # FAILED: 0 / 1 tests passed.
  # Totals: pass:0 fail:1 xfail:0 xpass:0 skip:0 error:0

After:

  # Starting 1 tests from 2 test cases.
  #  RUN           so_incoming_cpu.test1 ...
  # so_incoming_cpu.c:137:test1:SO_INCOMING_CPU is very likely to be working correctly with 3072 sockets.
  #            OK  so_incoming_cpu.test1
  ok 1 so_incoming_cpu.test1
  # PASSED: 1 / 1 tests passed.
  # Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/so_incoming_cpu.c | 148 ++++++++++++++++++
 3 files changed, 150 insertions(+)
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
index 000000000000..0ee0f2e393eb
--- /dev/null
+++ b/tools/testing/selftests/net/so_incoming_cpu.c
@@ -0,0 +1,148 @@
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
+void create_servers(struct __test_metadata *_metadata,
+		    FIXTURE_DATA(so_incoming_cpu) *self)
+{
+	int i, fd, ret;
+
+	for (i = 0; i < NR_SERVER; i++) {
+		fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
+		ASSERT_NE(fd, -1);
+
+		ret = setsockopt(fd, SOL_SOCKET, SO_INCOMING_CPU, &i, sizeof(int));
+		ASSERT_EQ(ret, 0);
+
+		ret = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &(int){1}, sizeof(int));
+		ASSERT_EQ(ret, 0);
+
+		ret = bind(fd, &self->addr, self->addrlen);
+		ASSERT_EQ(ret, 0);
+
+		if (i == 0) {
+			ret = getsockname(fd, &self->addr, &self->addrlen);
+			ASSERT_EQ(ret, 0);
+		}
+
+		/* We don't use CLIENT_PER_SERVER here not to block
+		 * this test at connect() if SO_INCOMING_CPU is broken.
+		 */
+		ret = listen(fd, NR_CLIENT);
+		ASSERT_EQ(ret, 0);
+
+		self->servers[i] = fd;
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
+	create_servers(_metadata, self);
+	create_clients(_metadata, self);
+	verify_incoming_cpu(_metadata, self);
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

