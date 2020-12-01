Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01AD2CA644
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404037AbgLAOsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 09:48:04 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:51644 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404026AbgLAOsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 09:48:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1606834080; x=1638370080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=PfwueMD1yNf+zcMEg3MW90GiebWy2GJDZGjeZTQJa5M=;
  b=ca0KbJdC0l2tKx5UGNCxiFGke9LAbF3MR21tSg8Yrsn2qnu+vvQLG41x
   VlOb101LWJMPxqvEAhmb4O+tZ7FHF/wvdKjRQbURkoJA2niISUyx4vdvw
   oRsiR0wrCusDMCcOspeZE0f35yQ+jgJDai5gH1IyzQlLvCv7A8sl0Sdhj
   E=;
X-IronPort-AV: E=Sophos;i="5.78,384,1599523200"; 
   d="scan'208";a="92542747"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 01 Dec 2020 14:47:44 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 2EE14A21DF;
        Tue,  1 Dec 2020 14:47:43 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:47:42 +0000
Received: from 38f9d3582de7.ant.amazon.com (10.43.162.146) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 1 Dec 2020 14:47:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <osa-contribution-log@amazon.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Tue, 1 Dec 2020 23:44:18 +0900
Message-ID: <20201201144418.35045-12-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201201144418.35045-1-kuniyu@amazon.co.jp>
References: <20201201144418.35045-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D36UWA004.ant.amazon.com (10.43.160.175) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 .../bpf/prog_tests/migrate_reuseport.c        | 164 ++++++++++++++++++
 .../bpf/progs/test_migrate_reuseport_kern.c   |  54 ++++++
 2 files changed, 218 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
new file mode 100644
index 000000000000..87c72d9ccadd
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -0,0 +1,164 @@
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
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <linux/bpf.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define NUM_SOCKS 5
+#define LOCALHOST "127.0.0.1"
+#define err_exit(condition, message)			      \
+	do {						      \
+		if (condition) {			      \
+			perror("ERROR: " message " ");	      \
+			exit(1);			      \
+		}					      \
+	} while (0)
+
+__u64 server_fds[NUM_SOCKS];
+int prog_fd, reuseport_map_fd, migrate_map_fd;
+
+
+void setup_bpf(void)
+{
+	struct bpf_object *obj;
+	struct bpf_program *prog;
+	struct bpf_map *reuseport_map, *migrate_map;
+	int err;
+
+	obj = bpf_object__open("test_migrate_reuseport_kern.o");
+	err_exit(libbpf_get_error(obj), "opening BPF object file failed");
+
+	err = bpf_object__load(obj);
+	err_exit(err, "loading BPF object failed");
+
+	prog = bpf_program__next(NULL, obj);
+	err_exit(!prog, "loading BPF program failed");
+
+	reuseport_map = bpf_object__find_map_by_name(obj, "reuseport_map");
+	err_exit(!reuseport_map, "loading BPF reuseport_map failed");
+
+	migrate_map = bpf_object__find_map_by_name(obj, "migrate_map");
+	err_exit(!migrate_map, "loading BPF migrate_map failed");
+
+	prog_fd = bpf_program__fd(prog);
+	reuseport_map_fd = bpf_map__fd(reuseport_map);
+	migrate_map_fd = bpf_map__fd(migrate_map);
+}
+
+void test_listen(void)
+{
+	struct sockaddr_in addr;
+	socklen_t addr_len = sizeof(addr);
+	int i, err, optval = 1, migrated_to = NUM_SOCKS - 1;
+	__u64 value;
+
+	addr.sin_family = AF_INET;
+	addr.sin_port = htons(80);
+	inet_pton(AF_INET, LOCALHOST, &addr.sin_addr.s_addr);
+
+	for (i = 0; i < NUM_SOCKS; i++) {
+		server_fds[i] = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+		err_exit(server_fds[i] == -1, "socket() for listener sockets failed");
+
+		err = setsockopt(server_fds[i], SOL_SOCKET, SO_REUSEPORT,
+				 &optval, sizeof(optval));
+		err_exit(err == -1, "setsockopt() for SO_REUSEPORT failed");
+
+		if (i == 0) {
+			err = setsockopt(server_fds[i], SOL_SOCKET, SO_ATTACH_REUSEPORT_EBPF,
+					 &prog_fd, sizeof(prog_fd));
+			err_exit(err == -1, "setsockopt() for SO_ATTACH_REUSEPORT_EBPF failed");
+		}
+
+		err = bind(server_fds[i], (struct sockaddr *)&addr, addr_len);
+		err_exit(err == -1, "bind() failed");
+
+		err = listen(server_fds[i], 32);
+		err_exit(err == -1, "listen() failed");
+
+		err = bpf_map_update_elem(reuseport_map_fd, &i, &server_fds[i], BPF_NOEXIST);
+		err_exit(err == -1, "updating BPF reuseport_map failed");
+
+		err = bpf_map_lookup_elem(reuseport_map_fd, &i, &value);
+		err_exit(err == -1, "looking up BPF reuseport_map failed");
+
+		printf("fd[%d] (cookie: %llu) -> fd[%d]\n", i, value, migrated_to);
+		err = bpf_map_update_elem(migrate_map_fd, &value, &migrated_to, BPF_NOEXIST);
+		err_exit(err == -1, "updating BPF migrate_map failed");
+	}
+}
+
+void test_connect(void)
+{
+	struct sockaddr_in addr;
+	socklen_t addr_len = sizeof(addr);
+	int i, err, client_fd;
+
+	addr.sin_family = AF_INET;
+	addr.sin_port = htons(80);
+	inet_pton(AF_INET, LOCALHOST, &addr.sin_addr.s_addr);
+
+	for (i = 0; i < NUM_SOCKS * 5; i++) {
+		client_fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+		err_exit(client_fd == -1, "socket() for listener sockets failed");
+
+		err = connect(client_fd, (struct sockaddr *)&addr, addr_len);
+		err_exit(err == -1, "connect() failed");
+
+		close(client_fd);
+	}
+}
+
+void test_close(void)
+{
+	int i;
+
+	for (i = 0; i < NUM_SOCKS - 1; i++)
+		close(server_fds[i]);
+}
+
+void test_accept(void)
+{
+	struct sockaddr_in addr;
+	socklen_t addr_len = sizeof(addr);
+	int cnt, client_fd;
+
+	fcntl(server_fds[NUM_SOCKS - 1], F_SETFL, O_NONBLOCK);
+
+	for (cnt = 0; cnt < NUM_SOCKS * 5; cnt++) {
+		client_fd = accept(server_fds[NUM_SOCKS - 1], (struct sockaddr *)&addr, &addr_len);
+		err_exit(client_fd == -1, "accept() failed");
+	}
+
+	printf("%d accepted, %d is expected\n", cnt, NUM_SOCKS * 5);
+}
+
+int main(void)
+{
+	setup_bpf();
+	test_listen();
+	test_connect();
+	test_close();
+	test_accept();
+	close(server_fds[NUM_SOCKS - 1]);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c
new file mode 100644
index 000000000000..28d007b3a7a7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c
@@ -0,0 +1,54 @@
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
+int _version SEC("version") = 1;
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
+int select_by_skb_data(struct sk_reuseport_md *reuse_md)
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
+char _license[] SEC("license") = "GPL";
-- 
2.17.2 (Apple Git-113)

