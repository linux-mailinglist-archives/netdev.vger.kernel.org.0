Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF4E48CFB4
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 01:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiAMAaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 19:30:14 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:19069 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiAMAaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 19:30:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1642033807; x=1673569807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZfrycL8r9fMrOodAPEym9Kb2IRU+SsYATBGC0aJYQ5s=;
  b=oEc7Osr0glxk3BZf/eJ+bIys/sQc8uOCEhAwkESb+bM7/jt3NjATB5ZL
   mdpMKGH+ywwUKayzPYAz0EV8wqQbMKXjXosYDB8FifkwlnnlGJ7C8zJeP
   R72+/cOnmhqpw21RBEQMJy0+V+oAwQ3Le5uogEHsi5BwFq3+h9DFxsD6Q
   M=;
X-IronPort-AV: E=Sophos;i="5.88,284,1635206400"; 
   d="scan'208";a="186988301"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9102.sea19.amazon.com with ESMTP; 13 Jan 2022 00:30:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-8691d7ea.us-east-1.amazon.com (Postfix) with ESMTPS id 554DCC0904;
        Thu, 13 Jan 2022 00:30:05 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.28; Thu, 13 Jan 2022 00:30:04 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.142) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Thu, 13 Jan 2022 00:30:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 4/5] selftest/bpf: Test batching and bpf_(get|set)sockopt in bpf unix iter.
Date:   Thu, 13 Jan 2022 09:28:48 +0900
Message-ID: <20220113002849.4384-5-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220113002849.4384-1-kuniyu@amazon.co.jp>
References: <20220113002849.4384-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.142]
X-ClientProxiedBy: EX13D04UWB001.ant.amazon.com (10.43.161.46) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test for the batching and bpf_(get|set)sockopt in bpf
unix iter.

It does the following.

  1. Creates an abstract UNIX domain socket
  2. Call bpf_setsockopt()
  3. Call bpf_getsockopt() and save the value
  4. Call setsockopt()
  5. Call getsockopt() and save the value
  6. Compare the saved values

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 .../bpf/prog_tests/bpf_iter_setsockopt_unix.c | 100 ++++++++++++++++++
 .../bpf/progs/bpf_iter_setsockopt_unix.c      |  60 +++++++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   2 +
 3 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c b/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
new file mode 100644
index 000000000000..ee725d4d98a5
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt_unix.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+#include <sys/socket.h>
+#include <sys/un.h>
+#include <test_progs.h>
+#include "bpf_iter_setsockopt_unix.skel.h"
+
+#define NR_CASES 5
+
+static int create_unix_socket(struct bpf_iter_setsockopt_unix *skel)
+{
+	struct sockaddr_un addr = {
+		.sun_family = AF_UNIX,
+		.sun_path = "",
+	};
+	socklen_t len;
+	int fd, err;
+
+	fd = socket(AF_UNIX, SOCK_STREAM, 0);
+	if (!ASSERT_NEQ(fd, -1, "socket"))
+		return -1;
+
+	len = offsetof(struct sockaddr_un, sun_path);
+	err = bind(fd, (struct sockaddr *)&addr, len);
+	if (!ASSERT_OK(err, "bind"))
+		return -1;
+
+	len = sizeof(addr);
+	err = getsockname(fd, (struct sockaddr *)&addr, &len);
+	if (!ASSERT_OK(err, "getsockname"))
+		return -1;
+
+	memcpy(&skel->bss->sun_path, &addr.sun_path,
+	       len - offsetof(struct sockaddr_un, sun_path));
+
+	return fd;
+}
+
+static void test_sndbuf(struct bpf_iter_setsockopt_unix *skel, int fd)
+{
+	socklen_t optlen;
+	int i, err;
+
+	for (i = 0; i < NR_CASES; i++) {
+		if (!ASSERT_NEQ(skel->data->sndbuf_getsockopt[i], -1,
+				"bpf_(get|set)sockopt"))
+			return;
+
+		err = setsockopt(fd, SOL_SOCKET, SO_SNDBUF,
+				 &(skel->data->sndbuf_setsockopt[i]),
+				 sizeof(skel->data->sndbuf_setsockopt[i]));
+		if (!ASSERT_OK(err, "setsockopt"))
+			return;
+
+		optlen = sizeof(skel->bss->sndbuf_getsockopt_expected[i]);
+		err = getsockopt(fd, SOL_SOCKET, SO_SNDBUF,
+				 &(skel->bss->sndbuf_getsockopt_expected[i]),
+				 &optlen);
+		if (!ASSERT_OK(err, "getsockopt"))
+			return;
+
+		if (!ASSERT_EQ(skel->data->sndbuf_getsockopt[i],
+			       skel->bss->sndbuf_getsockopt_expected[i],
+			       "bpf_(get|set)sockopt"))
+			return;
+	}
+}
+
+void test_bpf_iter_setsockopt_unix(void)
+{
+	struct bpf_iter_setsockopt_unix *skel;
+	int err, unix_fd, iter_fd;
+	char buf;
+
+	skel = bpf_iter_setsockopt_unix__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	unix_fd = create_unix_socket(skel);
+	if (!ASSERT_NEQ(unix_fd, -1, "create_unix_server"))
+		goto destroy;
+
+	skel->links.change_sndbuf = bpf_program__attach_iter(skel->progs.change_sndbuf, NULL);
+	if (!ASSERT_OK_PTR(skel->links.change_sndbuf, "bpf_program__attach_iter"))
+		goto destroy;
+
+	iter_fd = bpf_iter_create(bpf_link__fd(skel->links.change_sndbuf));
+	if (!ASSERT_GE(iter_fd, 0, "bpf_iter_create"))
+		goto destroy;
+
+	while ((err = read(iter_fd, &buf, sizeof(buf))) == -1 &&
+	       errno == EAGAIN)
+		;
+	if (!ASSERT_OK(err, "read iter error"))
+		goto destroy;
+
+	test_sndbuf(skel, unix_fd);
+destroy:
+	bpf_iter_setsockopt_unix__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c b/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c
new file mode 100644
index 000000000000..eafc877ea460
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt_unix.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright Amazon.com Inc. or its affiliates. */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <limits.h>
+
+#define AUTOBIND_LEN 6
+char sun_path[AUTOBIND_LEN];
+
+#define NR_CASES 5
+int sndbuf_setsockopt[NR_CASES] = {-1, 0, 8192, INT_MAX / 2, INT_MAX};
+int sndbuf_getsockopt[NR_CASES] = {-1, -1, -1, -1, -1};
+int sndbuf_getsockopt_expected[NR_CASES];
+
+static inline int cmpname(struct unix_sock *unix_sk)
+{
+	int i;
+
+	for (i = 0; i < AUTOBIND_LEN; i++) {
+		if (unix_sk->addr->name->sun_path[i] != sun_path[i])
+			return -1;
+	}
+
+	return 0;
+}
+
+SEC("iter/unix")
+int change_sndbuf(struct bpf_iter__unix *ctx)
+{
+	struct unix_sock *unix_sk = ctx->unix_sk;
+	int i, err;
+
+	if (!unix_sk || !unix_sk->addr)
+		return 0;
+
+	if (unix_sk->addr->name->sun_path[0])
+		return 0;
+
+	if (cmpname(unix_sk))
+		return 0;
+
+	for (i = 0; i < NR_CASES; i++) {
+		err = bpf_setsockopt(unix_sk, SOL_SOCKET, SO_SNDBUF,
+				     &sndbuf_setsockopt[i],
+				     sizeof(sndbuf_setsockopt[i]));
+		if (err)
+			break;
+
+		err = bpf_getsockopt(unix_sk, SOL_SOCKET, SO_SNDBUF,
+				     &sndbuf_getsockopt[i],
+				     sizeof(sndbuf_getsockopt[i]));
+		if (err)
+			break;
+	}
+
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
index e0f42601be9b..1c1289ba5fc5 100644
--- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
+++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
@@ -5,6 +5,8 @@
 #define AF_INET			2
 #define AF_INET6		10
 
+#define SOL_SOCKET		1
+#define SO_SNDBUF		7
 #define __SO_ACCEPTCON		(1 << 16)
 
 #define SOL_TCP			6
-- 
2.30.2

