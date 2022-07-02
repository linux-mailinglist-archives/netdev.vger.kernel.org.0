Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23208563D98
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 03:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiGBBpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 21:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiGBBpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 21:45:43 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D30377C5
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 18:45:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1656726342; x=1688262342;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xMCAG4dzCjz29sXvMKFApbVQ5AZWdJptzT7elTrcP7w=;
  b=ozMCsOLlpJmbFaAius1x5TEaeYIoHK/kS7RLFSK4GlQZZNDi4nLOOejR
   hPOgn/vPb8S6ho1EX1zWNg06v0F4SEhOGviYDy+9L+0YIYGqmyt5hUxuO
   L9QCU3AiyKdi+567vdsaQULFyLX1ykUJBPX/B3O1eVthlH0sb/jPW5XHF
   I=;
X-IronPort-AV: E=Sophos;i="5.92,238,1650931200"; 
   d="scan'208";a="214096112"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 02 Jul 2022 01:45:31 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id 65DE4C09E1;
        Sat,  2 Jul 2022 01:45:30 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 2 Jul 2022 01:45:29 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.135) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sat, 2 Jul 2022 01:45:27 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Sachin Sant <sachinp@linux.ibm.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Kuniyuki Iwashima" <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 net-next 2/2] selftests: net: af_unix: Test connect() with different netns.
Date:   Fri, 1 Jul 2022 18:44:47 -0700
Message-ID: <20220702014447.93746-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220702014447.93746-1-kuniyu@amazon.com>
References: <20220702014447.93746-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.135]
X-ClientProxiedBy: EX13D13UWA003.ant.amazon.com (10.43.160.181) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add a test that checks connect()ivity between two sockets:

    unnamed socket -> bound socket
                      * SOCK_STREAM or SOCK_DGRAM
                      * pathname or abstract
                      * same or different netns

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../selftests/net/af_unix/unix_connect.c      | 149 ++++++++++++++++++
 3 files changed, 152 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/af_unix/unix_connect.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index a29f79618934..1257baa79286 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -37,3 +37,4 @@ gro
 ioam6_parser
 toeplitz
 cmsg_sender
+unix_connect
\ No newline at end of file
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index df341648f818..969620ae9928 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -1,2 +1,3 @@
-TEST_GEN_PROGS := test_unix_oob
+TEST_GEN_PROGS := test_unix_oob unix_connect
+
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/af_unix/unix_connect.c b/tools/testing/selftests/net/af_unix/unix_connect.c
new file mode 100644
index 000000000000..5b231d8c4683
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/unix_connect.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+#include <sched.h>
+
+#include <stdio.h>
+#include <unistd.h>
+
+#include <sys/socket.h>
+#include <sys/un.h>
+
+#include "../../kselftest_harness.h"
+
+FIXTURE(unix_connect)
+{
+	int server, client;
+	int family;
+};
+
+FIXTURE_VARIANT(unix_connect)
+{
+	int type;
+	char sun_path[8];
+	int len;
+	int flags;
+	int err;
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, stream_pathname)
+{
+	.type = SOCK_STREAM,
+	.sun_path = "test",
+	.len = 4 + 1,
+	.flags = 0,
+	.err = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, stream_abstract)
+{
+	.type = SOCK_STREAM,
+	.sun_path = "\0test",
+	.len = 5,
+	.flags = 0,
+	.err = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, stream_pathname_netns)
+{
+	.type = SOCK_STREAM,
+	.sun_path = "test",
+	.len = 4 + 1,
+	.flags = CLONE_NEWNET,
+	.err = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, stream_abstract_netns)
+{
+	.type = SOCK_STREAM,
+	.sun_path = "\0test",
+	.len = 5,
+	.flags = CLONE_NEWNET,
+	.err = ECONNREFUSED,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, dgram_pathname)
+{
+	.type = SOCK_DGRAM,
+	.sun_path = "test",
+	.len = 4 + 1,
+	.flags = 0,
+	.err = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, dgram_abstract)
+{
+	.type = SOCK_DGRAM,
+	.sun_path = "\0test",
+	.len = 5,
+	.flags = 0,
+	.err = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, dgram_pathname_netns)
+{
+	.type = SOCK_DGRAM,
+	.sun_path = "test",
+	.len = 4 + 1,
+	.flags = CLONE_NEWNET,
+	.err = 0,
+};
+
+FIXTURE_VARIANT_ADD(unix_connect, dgram_abstract_netns)
+{
+	.type = SOCK_DGRAM,
+	.sun_path = "\0test",
+	.len = 5,
+	.flags = CLONE_NEWNET,
+	.err = ECONNREFUSED,
+};
+
+FIXTURE_SETUP(unix_connect)
+{
+	self->family = AF_UNIX;
+}
+
+FIXTURE_TEARDOWN(unix_connect)
+{
+	close(self->server);
+	close(self->client);
+
+	if (variant->sun_path[0])
+		remove("test");
+}
+
+#define offsetof(type, member) ((size_t)&((type *)0)->member)
+
+TEST_F(unix_connect, test)
+{
+	socklen_t addrlen;
+	struct sockaddr_un addr = {
+		.sun_family = self->family,
+	};
+	int err;
+
+	self->server = socket(self->family, variant->type, 0);
+	ASSERT_NE(-1, self->server);
+
+	addrlen = offsetof(struct sockaddr_un, sun_path) + variant->len;
+	memcpy(&addr.sun_path, variant->sun_path, variant->len);
+
+	err = bind(self->server, (struct sockaddr *)&addr, addrlen);
+	ASSERT_EQ(0, err);
+
+	if (variant->type == SOCK_STREAM) {
+		err = listen(self->server, 32);
+		ASSERT_EQ(0, err);
+	}
+
+	err = unshare(variant->flags);
+	ASSERT_EQ(0, err);
+
+	self->client = socket(self->family, variant->type, 0);
+	ASSERT_LT(0, self->client);
+
+	err = connect(self->client, (struct sockaddr *)&addr, addrlen);
+	ASSERT_EQ(variant->err, err == -1 ? errno : 0);
+}
+
+TEST_HARNESS_MAIN
-- 
2.30.2

