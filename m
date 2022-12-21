Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1539653304
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 16:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiLUPOP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 10:14:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbiLUPON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 10:14:13 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C999135
        for <netdev@vger.kernel.org>; Wed, 21 Dec 2022 07:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1671635652; x=1703171652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mA2UxPA400FVNdMxqHUUpQJKhCbMX/ujHBrKsddK/fg=;
  b=cvOP3NPBn+qWXA9MsBbOADx3rd2HDdMbc4vOsKqQ5mUfKWrN68S5F0EC
   N5J98tohcNlx6n2xKMEU7zRfVzo9DQ8opl5LK0psrDMdeFjJrPFcjyBav
   om6nVUkgY2mn5oyXURpuMlKyFHn4yKURx8Mn2hV7N1zxAVgEXr+fM4Cfk
   k=;
X-IronPort-AV: E=Sophos;i="5.96,262,1665446400"; 
   d="scan'208";a="163959781"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2022 15:14:08 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-edda28d4.us-east-1.amazon.com (Postfix) with ESMTPS id CC05D81D22;
        Wed, 21 Dec 2022 15:14:05 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Wed, 21 Dec 2022 15:14:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.134) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Wed, 21 Dec 2022 15:14:01 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Slaby <jirislaby@kernel.org>,
        Joanne Koong <joannelkoong@gmail.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH RFC net 2/2] tcp: Add selftest for bind() and TIME_WAIT.
Date:   Thu, 22 Dec 2022 00:12:58 +0900
Message-ID: <20221221151258.25748-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221221151258.25748-1-kuniyu@amazon.com>
References: <20221221151258.25748-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.134]
X-ClientProxiedBy: EX13D27UWA002.ant.amazon.com (10.43.160.30) To
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

bhash2 split the bind() validation logic into wildcard and non-wildcard
cases.  Let's add a test to catch the same regression.

Before the previous patch:

  # ./bind_timewait
  TAP version 13
  1..2
  # Starting 2 tests from 3 test cases.
  #  RUN           bind_timewait.localhost.1 ...
  # bind_timewait.c:87:1:Expected ret (0) == -1 (-1)
  # 1: Test terminated by assertion
  #          FAIL  bind_timewait.localhost.1
  not ok 1 bind_timewait.localhost.1
  #  RUN           bind_timewait.addrany.1 ...
  #            OK  bind_timewait.addrany.1
  ok 2 bind_timewait.addrany.1
  # FAILED: 1 / 2 tests passed.
  # Totals: pass:1 fail:1 xfail:0 xpass:0 skip:0 error:0

After:

  # ./bind_timewait
  TAP version 13
  1..2
  # Starting 2 tests from 3 test cases.
  #  RUN           bind_timewait.localhost.1 ...
  #            OK  bind_timewait.localhost.1
  ok 1 bind_timewait.localhost.1
  #  RUN           bind_timewait.addrany.1 ...
  #            OK  bind_timewait.addrany.1
  ok 2 bind_timewait.addrany.1
  # PASSED: 2 / 2 tests passed.
  # Totals: pass:2 fail:0 xfail:0 xpass:0 skip:0 error:0

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/.gitignore      |  1 +
 tools/testing/selftests/net/bind_timewait.c | 93 +++++++++++++++++++++
 2 files changed, 94 insertions(+)
 create mode 100644 tools/testing/selftests/net/bind_timewait.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 9cc84114741d..a6911cae368c 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -1,5 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 bind_bhash
+bind_timewait
 csum
 cmsg_sender
 diag_uid
diff --git a/tools/testing/selftests/net/bind_timewait.c b/tools/testing/selftests/net/bind_timewait.c
new file mode 100644
index 000000000000..2d40403128ff
--- /dev/null
+++ b/tools/testing/selftests/net/bind_timewait.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+
+#include "../kselftest_harness.h"
+
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+
+FIXTURE(bind_timewait)
+{
+	struct sockaddr_in addr;
+	socklen_t addrlen;
+};
+
+FIXTURE_VARIANT(bind_timewait)
+{
+	__u32 addr_const;
+};
+
+FIXTURE_VARIANT_ADD(bind_timewait, localhost)
+{
+	.addr_const = INADDR_LOOPBACK
+};
+
+FIXTURE_VARIANT_ADD(bind_timewait, addrany)
+{
+	.addr_const = INADDR_ANY
+};
+
+FIXTURE_SETUP(bind_timewait)
+{
+	self->addr.sin_family = AF_INET;
+	self->addr.sin_port = 0;
+	self->addr.sin_addr.s_addr = htonl(variant->addr_const);
+	self->addrlen = sizeof(self->addr);
+}
+
+FIXTURE_TEARDOWN(bind_timewait)
+{
+}
+
+void create_timewait_socket(struct __test_metadata *_metadata,
+			    FIXTURE_DATA(bind_timewait) *self)
+{
+	int server_fd, client_fd, child_fd, ret;
+	struct sockaddr_in addr;
+	socklen_t addrlen;
+
+	server_fd = socket(AF_INET, SOCK_STREAM, 0);
+	ASSERT_GT(server_fd, 0);
+
+	ret = bind(server_fd, (struct sockaddr *)&self->addr, self->addrlen);
+	ASSERT_EQ(ret, 0);
+
+	ret = listen(server_fd, 1);
+	ASSERT_EQ(ret, 0);
+
+	ret = getsockname(server_fd, (struct sockaddr *)&self->addr, &self->addrlen);
+	ASSERT_EQ(ret, 0);
+
+	client_fd = socket(AF_INET, SOCK_STREAM, 0);
+	ASSERT_GT(client_fd, 0);
+
+	ret = connect(client_fd, (struct sockaddr *)&self->addr, self->addrlen);
+	ASSERT_EQ(ret, 0);
+
+	addrlen = sizeof(addr);
+	child_fd = accept(server_fd, (struct sockaddr *)&addr, &addrlen);
+	ASSERT_GT(child_fd, 0);
+
+	close(child_fd);
+	close(client_fd);
+	close(server_fd);
+}
+
+TEST_F(bind_timewait, 1)
+{
+	int fd, ret;
+
+	create_timewait_socket(_metadata, self);
+
+	fd = socket(AF_INET, SOCK_STREAM, 0);
+	ASSERT_GT(fd, 0);
+
+	ret = bind(fd, (struct sockaddr *)&self->addr, self->addrlen);
+	ASSERT_EQ(ret, -1);
+	ASSERT_EQ(errno, EADDRINUSE);
+
+	close(fd);
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

