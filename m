Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437626B6307
	for <lists+netdev@lfdr.de>; Sun, 12 Mar 2023 04:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjCLDUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 22:20:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCLDUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 22:20:33 -0500
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6EB2BEC3
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 19:20:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678591223; x=1710127223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LaxoN6BUASlt2pjy7pM9hHuVQ67zwBQWjyfS4QWyduk=;
  b=Tm7XWEUXSAcZNNdpvx+8THlBA+ee6HZAVzMPUjtXRaHhVuqQw9wtw3/B
   lfW+Ftss+VuY8ONqiWB83gT2u2l0Z3hldJQKsI7UCqTqThFoVgNkYemnl
   tErYuZhUOOjevSAYWjjKX8uoPR2uk5cxu2rBkvw+mkAiRLaVvMi4jfUhj
   0=;
X-IronPort-AV: E=Sophos;i="5.98,253,1673913600"; 
   d="scan'208";a="1111726796"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 03:20:23 +0000
Received: from EX19MTAUWB002.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-m6i4x-af372327.us-west-2.amazon.com (Postfix) with ESMTPS id D5B4160BA8;
        Sun, 12 Mar 2023 03:20:22 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Sun, 12 Mar 2023 03:20:22 +0000
Received: from 88665a182662.ant.amazon.com (10.119.80.90) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Sun, 12 Mar 2023 03:20:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 2/2] selftest: Add test for bind() conflicts.
Date:   Sat, 11 Mar 2023 19:19:04 -0800
Message-ID: <20230312031904.4674-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230312031904.4674-1-kuniyu@amazon.com>
References: <20230312031904.4674-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.119.80.90]
X-ClientProxiedBy: EX19D044UWB004.ant.amazon.com (10.13.139.134) To
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

The test checks if (IPv4, IPv6) address pair properly conflict or not.

  * IPv4
    * 0.0.0.0
    * 127.0.0.1

  * IPv6
    * ::
    * ::1

If the IPv6 address is [::], the second bind() always fails.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/.gitignore      |   1 +
 tools/testing/selftests/net/Makefile        |   1 +
 tools/testing/selftests/net/bind_wildcard.c | 114 ++++++++++++++++++++
 3 files changed, 116 insertions(+)
 create mode 100644 tools/testing/selftests/net/bind_wildcard.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index a6911cae368c..80f06aa62034 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 bind_bhash
 bind_timewait
+bind_wildcard
 csum
 cmsg_sender
 diag_uid
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 6cd8993454d7..80fbfe0330f6 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -80,6 +80,7 @@ TEST_GEN_FILES += sctp_hello
 TEST_GEN_FILES += csum
 TEST_GEN_FILES += nat6to4.o
 TEST_GEN_FILES += ip_local_port_range
+TEST_GEN_FILES += bind_wildcard
 
 TEST_FILES := settings
 
diff --git a/tools/testing/selftests/net/bind_wildcard.c b/tools/testing/selftests/net/bind_wildcard.c
new file mode 100644
index 000000000000..58edfc15d28b
--- /dev/null
+++ b/tools/testing/selftests/net/bind_wildcard.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+
+#include <sys/socket.h>
+#include <netinet/in.h>
+
+#include "../kselftest_harness.h"
+
+FIXTURE(bind_wildcard)
+{
+	struct sockaddr_in addr4;
+	struct sockaddr_in6 addr6;
+	int expected_errno;
+};
+
+FIXTURE_VARIANT(bind_wildcard)
+{
+	const __u32 addr4_const;
+	const struct in6_addr *addr6_const;
+};
+
+FIXTURE_VARIANT_ADD(bind_wildcard, v4_any_v6_any)
+{
+	.addr4_const = INADDR_ANY,
+	.addr6_const = &in6addr_any,
+};
+
+FIXTURE_VARIANT_ADD(bind_wildcard, v4_any_v6_local)
+{
+	.addr4_const = INADDR_ANY,
+	.addr6_const = &in6addr_loopback,
+};
+
+FIXTURE_VARIANT_ADD(bind_wildcard, v4_local_v6_any)
+{
+	.addr4_const = INADDR_LOOPBACK,
+	.addr6_const = &in6addr_any,
+};
+
+FIXTURE_VARIANT_ADD(bind_wildcard, v4_local_v6_local)
+{
+	.addr4_const = INADDR_LOOPBACK,
+	.addr6_const = &in6addr_loopback,
+};
+
+FIXTURE_SETUP(bind_wildcard)
+{
+	self->addr4.sin_family = AF_INET;
+	self->addr4.sin_port = htons(0);
+	self->addr4.sin_addr.s_addr = htonl(variant->addr4_const);
+
+	self->addr6.sin6_family = AF_INET6;
+	self->addr6.sin6_port = htons(0);
+	self->addr6.sin6_addr = *variant->addr6_const;
+
+	if (variant->addr6_const == &in6addr_any)
+		self->expected_errno = EADDRINUSE;
+	else
+		self->expected_errno = 0;
+}
+
+FIXTURE_TEARDOWN(bind_wildcard)
+{
+}
+
+void bind_sockets(struct __test_metadata *_metadata,
+		  FIXTURE_DATA(bind_wildcard) *self,
+		  struct sockaddr *addr1, socklen_t addrlen1,
+		  struct sockaddr *addr2, socklen_t addrlen2)
+{
+	int fd[2];
+	int ret;
+
+	fd[0] = socket(addr1->sa_family, SOCK_STREAM, 0);
+	ASSERT_GT(fd[0], 0);
+
+	ret = bind(fd[0], addr1, addrlen1);
+	ASSERT_EQ(ret, 0);
+
+	ret = getsockname(fd[0], addr1, &addrlen1);
+	ASSERT_EQ(ret, 0);
+
+	((struct sockaddr_in *)addr2)->sin_port = ((struct sockaddr_in *)addr1)->sin_port;
+
+	fd[1] = socket(addr2->sa_family, SOCK_STREAM, 0);
+	ASSERT_GT(fd[1], 0);
+
+	ret = bind(fd[1], addr2, addrlen2);
+	if (self->expected_errno) {
+		ASSERT_EQ(ret, -1);
+		ASSERT_EQ(errno, self->expected_errno);
+	} else {
+		ASSERT_EQ(ret, 0);
+	}
+
+	close(fd[1]);
+	close(fd[0]);
+}
+
+TEST_F(bind_wildcard, v4_v6)
+{
+	bind_sockets(_metadata, self,
+		     (struct sockaddr *)&self->addr4, sizeof(self->addr6),
+		     (struct sockaddr *)&self->addr6, sizeof(self->addr6));
+}
+
+TEST_F(bind_wildcard, v6_v4)
+{
+	bind_sockets(_metadata, self,
+		     (struct sockaddr *)&self->addr6, sizeof(self->addr6),
+		     (struct sockaddr *)&self->addr4, sizeof(self->addr4));
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

