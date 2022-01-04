Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9D4839E3
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 02:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiADBe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 20:34:27 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:18402 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiADBe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 20:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1641260067; x=1672796067;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZfrycL8r9fMrOodAPEym9Kb2IRU+SsYATBGC0aJYQ5s=;
  b=enySjSofPB5PqZ/IU5ETK7FR+F0hCbQREDbasNfH5iFk5LZwSRje1oSP
   UgmJNS+an9C64IizmNpc6zh/IQbzjJ9dQMZ8R7Q/PQULzxSovygmbjZgi
   +HWITPm0U1ZIGPfJtsCXmg5z6xmWzcId9X6PtT8OA/h2I/6yfU6MdPWpr
   c=;
X-IronPort-AV: E=Sophos;i="5.88,258,1635206400"; 
   d="scan'208";a="167488319"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-05e8af15.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 04 Jan 2022 01:34:26 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-05e8af15.us-west-2.amazon.com (Postfix) with ESMTPS id BF760A284D;
        Tue,  4 Jan 2022 01:34:24 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:34:23 +0000
Received: from 88665a182662.ant.amazon.com (10.43.161.97) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.26; Tue, 4 Jan 2022 01:34:19 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>,
        Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next 5/6] selftest/bpf: Test batching and bpf_(get|set)sockopt in bpf unix iter.
Date:   Tue, 4 Jan 2022 10:31:52 +0900
Message-ID: <20220104013153.97906-6-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220104013153.97906-1-kuniyu@amazon.co.jp>
References: <20220104013153.97906-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.97]
X-ClientProxiedBy: EX13D19UWA004.ant.amazon.com (10.43.160.102) To
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

