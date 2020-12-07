Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF482D120F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 14:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgLGN3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 08:29:47 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:9822 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgLGN3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 08:29:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1607347785; x=1638883785;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=1uyj+ON56WptrF13KwZJtXh7i/q+PlixzaIrrXNzRjs=;
  b=FN5YI/LKZ4tWcixIiLFn8TeySO6PezzSzri9R4ohvvByEY+GsbVKxUAD
   vzOq2wBSp40yVUWrA6hY5XTH9+JPdjfRbYAD9FYQRpWpYNkEk+/EAwvSo
   MueOZG6KnxMBRnM2E+iLlENGXUvoO6xHWZ2XnC397CipdDwPYUtNIq09T
   8=;
X-IronPort-AV: E=Sophos;i="5.78,399,1599523200"; 
   d="scan'208";a="67966404"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 07 Dec 2020 13:29:06 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id 127B4A1BFC;
        Mon,  7 Dec 2020 13:29:03 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:29:02 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.161.43) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 13:28:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 bpf-next 13/13] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Mon, 7 Dec 2020 22:24:56 +0900
Message-ID: <20201207132456.65472-14-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201207132456.65472-1-kuniyu@amazon.co.jp>
References: <20201207132456.65472-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D37UWC002.ant.amazon.com (10.43.162.123) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 .../bpf/prog_tests/select_reuseport_migrate.c | 173 ++++++++++++++++++
 .../bpf/progs/test_select_reuseport_migrate.c |  53 ++++++
 2 files changed, 226 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/select_reuseport_migrate.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_select_reuseport_migrate.c

diff --git a/tools/testing/selftests/bpf/prog_tests/select_reuseport_migrate.c b/tools/testing/selftests/bpf/prog_tests/select_reuseport_migrate.c
new file mode 100644
index 000000000000..814b1e3a4c56
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/select_reuseport_migrate.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check if we can migrate child sockets.
+ *
+ *   1. call listen() for 5 server sockets.
+ *   2. update a map to migrate all child socket
+ *        to the last server socket (migrate_map[cookie] = 4)
+ *   3. call connect() for 25 client sockets.
+ *   4. call close() for first 4 server sockets.
+ *   5. call accept() for the last server socket.
+ *
+ * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
+ */
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "test_progs.h"
+#include "test_select_reuseport_migrate.skel.h"
+
+#define ADDRESS "127.0.0.1"
+#define PORT 80
+#define NUM_SERVERS 5
+#define NUM_CLIENTS (NUM_SERVERS * 5)
+
+
+static int test_listen(struct test_select_reuseport_migrate *skel, int server_fds[])
+{
+	int i, err, optval = 1, migrated_to = NUM_SERVERS - 1;
+	int prog_fd, reuseport_map_fd, migrate_map_fd;
+	struct sockaddr_in addr;
+	socklen_t addr_len;
+	__u64 value;
+
+	prog_fd = bpf_program__fd(skel->progs.prog_select_reuseport_migrate);
+	reuseport_map_fd = bpf_map__fd(skel->maps.reuseport_map);
+	migrate_map_fd = bpf_map__fd(skel->maps.migrate_map);
+
+	addr_len = sizeof(addr);
+	addr.sin_family = AF_INET;
+	addr.sin_port = htons(PORT);
+	inet_pton(AF_INET, ADDRESS, &addr.sin_addr.s_addr);
+
+	for (i = 0; i < NUM_SERVERS; i++) {
+		server_fds[i] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+		if (CHECK_FAIL(server_fds[i] == -1))
+			return -1;
+
+		err = setsockopt(server_fds[i], SOL_SOCKET, SO_REUSEPORT,
+				 &optval, sizeof(optval));
+		if (CHECK_FAIL(err == -1))
+			return -1;
+
+		if (i == 0) {
+			err = setsockopt(server_fds[i], SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+					 &prog_fd, sizeof(prog_fd));
+			if (CHECK_FAIL(err == -1))
+				return -1;
+		}
+
+		err = bind(server_fds[i], (struct sockaddr *)&addr, addr_len);
+		if (CHECK_FAIL(err == -1))
+			return -1;
+
+		err = listen(server_fds[i], 32);
+		if (CHECK_FAIL(err == -1))
+			return -1;
+
+		err = bpf_map_update_elem(reuseport_map_fd, &i, &server_fds[i], BPF_NOEXIST);
+		if (CHECK_FAIL(err == -1))
+			return -1;
+
+		err = bpf_map_lookup_elem(reuseport_map_fd, &i, &value);
+		if (CHECK_FAIL(err == -1))
+			return -1;
+
+		err = bpf_map_update_elem(migrate_map_fd, &value, &migrated_to, BPF_NOEXIST);
+		if (CHECK_FAIL(err == -1))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int test_connect(int client_fds[])
+{
+	struct sockaddr_in addr;
+	socklen_t addr_len;
+	int i, err;
+
+	addr_len = sizeof(addr);
+	addr.sin_family = AF_INET;
+	addr.sin_port = htons(PORT);
+	inet_pton(AF_INET, ADDRESS, &addr.sin_addr.s_addr);
+
+	for (i = 0; i < NUM_CLIENTS; i++) {
+		client_fds[i] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+		if (CHECK_FAIL(client_fds[i] == -1))
+			return -1;
+
+		err = connect(client_fds[i], (struct sockaddr *)&addr, addr_len);
+		if (CHECK_FAIL(err == -1))
+			return -1;
+	}
+
+	return 0;
+}
+
+static void test_close(int server_fds[], int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++)
+		if (server_fds[i] > 0)
+			close(server_fds[i]);
+}
+
+static int test_accept(int server_fd)
+{
+	struct sockaddr_in addr;
+	socklen_t addr_len;
+	int cnt, client_fd;
+
+	fcntl(server_fd, F_SETFL, O_NONBLOCK);
+	addr_len = sizeof(addr);
+
+	for (cnt = 0; cnt < NUM_CLIENTS; cnt++) {
+		client_fd = accept(server_fd, (struct sockaddr *)&addr, &addr_len);
+		if (CHECK_FAIL(client_fd == -1))
+			return -1;
+	}
+
+	return cnt;
+}
+
+
+void test_select_reuseport_migrate(void)
+{
+	struct test_select_reuseport_migrate *skel;
+	int server_fds[NUM_SERVERS] = {0};
+	int client_fds[NUM_CLIENTS] = {0};
+	__u32 duration = 0;
+	int err;
+
+	skel = test_select_reuseport_migrate__open_and_load();
+	if (CHECK_FAIL(!skel))
+		goto destroy;
+
+	err = test_listen(skel, server_fds);
+	if (err)
+		goto close_server;
+
+	err = test_connect(client_fds);
+	if (err)
+		goto close_client;
+
+	test_close(server_fds, NUM_SERVERS - 1);
+
+	err = test_accept(server_fds[NUM_SERVERS - 1]);
+	CHECK(err != NUM_CLIENTS,
+	      "accept",
+	      "expected (%d) != actual (%d)\n",
+	      NUM_CLIENTS, err);
+
+close_client:
+	test_close(client_fds, NUM_CLIENTS);
+
+close_server:
+	test_close(server_fds, NUM_SERVERS);
+
+destroy:
+	test_select_reuseport_migrate__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_select_reuseport_migrate.c b/tools/testing/selftests/bpf/progs/test_select_reuseport_migrate.c
new file mode 100644
index 000000000000..f1ac07bb2c03
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_select_reuseport_migrate.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check if we can migrate child sockets.
+ *
+ *   1. If reuse_md->migration is 0 (SYN packet),
+ *        return SK_PASS without selecting a listener.
+ *   2. If reuse_md->migration is not 0 (socket migration),
+ *        select a listener (reuseport_map[migrate_map[cookie]])
+ *
+ * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
+ */
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+
+#define NULL ((void *)0)
+
+struct bpf_map_def SEC("maps") reuseport_map = {
+	.type = BPF_MAP_TYPE_REUSEPORT_SOCKARRAY,
+	.key_size = sizeof(int),
+	.value_size = sizeof(__u64),
+	.max_entries = 256,
+};
+
+struct bpf_map_def SEC("maps") migrate_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(__u64),
+	.value_size = sizeof(int),
+	.max_entries = 256,
+};
+
+SEC("sk_reuseport/migrate")
+int prog_select_reuseport_migrate(struct sk_reuseport_md *reuse_md)
+{
+	int *key, flags = 0;
+	__u64 cookie;
+
+	if (!reuse_md->migration)
+		return SK_PASS;
+
+	cookie = bpf_get_socket_cookie(reuse_md->sk);
+
+	key = bpf_map_lookup_elem(&migrate_map, &cookie);
+	if (key == NULL)
+		return SK_DROP;
+
+	bpf_sk_select_reuseport(reuse_md, &reuseport_map, key, flags);
+
+	return SK_PASS;
+}
+
+int _version SEC("version") = 1;
+char _license[] SEC("license") = "GPL";
-- 
2.17.2 (Apple Git-113)

