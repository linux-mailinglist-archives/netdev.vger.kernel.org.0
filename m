Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3B76562DB
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229762AbiLZN3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 08:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLZN3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 08:29:14 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80CA32700
        for <netdev@vger.kernel.org>; Mon, 26 Dec 2022 05:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1672061353; x=1703597353;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/TRC63uBICSUeXx7DfWVY9Ypr/rc8amPW4OuKHLGw/k=;
  b=KOLDpcaYL7QbaiA56wiaGDA7wtYLJ95AR3G9asH7mcf1ON1EFcWnfCQu
   O9aOB1xa6yUY7b+0H/d8TaMdb3KNtVhx23TsxqKZg66k50W0v7uj2SO/i
   nAIZWtf8Xhf5aLs2qc5gjrJnvQs+OrcgrMlunzWpUAPR3RiY0t0KaIp1Y
   U=;
X-IronPort-AV: E=Sophos;i="5.96,275,1665446400"; 
   d="scan'208";a="282679354"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Dec 2022 13:29:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id A457541704;
        Mon, 26 Dec 2022 13:29:09 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 26 Dec 2022 13:29:08 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.114) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 26 Dec 2022 13:29:05 +0000
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
Subject: [PATCH v1 net 2/2] tcp: Add selftest for bind() and TIME_WAIT.
Date:   Mon, 26 Dec 2022 22:27:53 +0900
Message-ID: <20221226132753.44175-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221226132753.44175-1-kuniyu@amazon.com>
References: <20221226132753.44175-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.114]
X-ClientProxiedBy: EX13D29UWC003.ant.amazon.com (10.43.162.80) To
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
cases.  Let's add a test to catch future regression.

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
 tools/testing/selftests/net/bind_timewait.c | 92 +++++++++++++++++++++
 2 files changed, 93 insertions(+)
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
index 000000000000..cb9fdf51ea59
--- /dev/null
+++ b/tools/testing/selftests/net/bind_timewait.c
@@ -0,0 +1,92 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+
+#include <sys/socket.h>
+#include <netinet/in.h>
+
+#include "../kselftest_harness.h"
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

