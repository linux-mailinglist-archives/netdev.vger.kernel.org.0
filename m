Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8AE2B5C08
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 10:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727672AbgKQJmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 04:42:55 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:35428 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgKQJmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 04:42:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1605606174; x=1637142174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=Yjg2cIeTqSYiEXQDPPifY0mk/C3SRGVuvOtSIHcTkFM=;
  b=jyjnfL105HTlvx6ebZWV4FAbDUirHMejMk0fPEDFkFu2zyQ+MxfidKHP
   zCaDRM/VX4URcPpfEvy8Ic1twVm13GWfNAACqlFkXL1JyBKzXNjp9VV+c
   ZOtI1nGULon0bTM0ftcejgRa+bRJJ1QBydiCX74JLn6G4gkbVH/w4l1Ge
   8=;
X-IronPort-AV: E=Sophos;i="5.77,485,1596499200"; 
   d="scan'208";a="96088626"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-af6a10df.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Nov 2020 09:42:53 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-af6a10df.us-east-1.amazon.com (Postfix) with ESMTPS id 44CE1A0201;
        Tue, 17 Nov 2020 09:42:52 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:51 +0000
Received: from 38f9d3582de7.ant.amazon.com.com (10.43.161.237) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 17 Nov 2020 09:42:47 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.co.jp>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH bpf-next 8/8] bpf: Test BPF_PROG_TYPE_SK_REUSEPORT for socket migration.
Date:   Tue, 17 Nov 2020 18:40:23 +0900
Message-ID: <20201117094023.3685-9-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.17.2 (Apple Git-113)
In-Reply-To: <20201117094023.3685-1-kuniyu@amazon.co.jp>
References: <20201117094023.3685-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.237]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test for net.ipv4.tcp_migrate_req with eBPF.

Reviewed-by: Benjamin Herrenschmidt <benh@amazon.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 .../bpf/prog_tests/migrate_reuseport.c        | 175 ++++++++++++++++++
 .../bpf/progs/test_migrate_reuseport_kern.c   |  53 ++++++
 2 files changed, 228 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c

diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
new file mode 100644
index 000000000000..fb182e575371
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -0,0 +1,175 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check if we can migrate child sockets.
+ *
+ *   1. call listen() for 5 server sockets.
+ *   2. update a map to migrate all child socket
+ *        to the last server socket (map[cookie] = 4)
+ *   3. call connect() for 25 client sockets.
+ *   4. call close() first 4 server sockets.
+ *   5. call receive() for the last server socket.
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
+			setup_sysctl(0);		      \
+			exit(1);			      \
+		}					      \
+	} while (0)
+
+__u64 server_fds[NUM_SOCKS];
+int prog_fd, map_fd, migrate_map_fd;
+
+void setup_sysctl(int value)
+{
+	FILE *file;
+
+	file = fopen("/proc/sys/net/ipv4/tcp_migrate_req", "w");
+	fprintf(file, "%d", value);
+	fclose(file);
+}
+
+void setup_bpf(void)
+{
+	struct bpf_object *obj;
+	struct bpf_program *prog;
+	struct bpf_map *map, *migrate_map;
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
+	map = bpf_object__find_map_by_name(obj, "reuseport_map");
+	err_exit(!map, "loading BPF reuseport_map failed");
+
+	migrate_map = bpf_object__find_map_by_name(obj, "migrate_map");
+	err_exit(!map, "loading BPF migrate_map failed");
+
+	prog_fd = bpf_program__fd(prog);
+	map_fd = bpf_map__fd(map);
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
+		err = bpf_map_update_elem(map_fd, &i, &server_fds[i], BPF_NOEXIST);
+		err_exit(err == -1, "updating BPF reuseport_map failed");
+
+		err = bpf_map_lookup_elem(map_fd, &i, &value);
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
+void test_receive(void)
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
+	setup_sysctl(1);
+	setup_bpf();
+	test_listen();
+	test_connect();
+	test_close();
+	test_receive();
+	close(server_fds[NUM_SOCKS - 1]);
+	setup_sysctl(0);
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c
new file mode 100644
index 000000000000..79f8a3465c20
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport_kern.c
@@ -0,0 +1,53 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check if we can migrate child sockets.
+ *
+ *   1. If data is not NULL (SYN packet),
+ *        return SK_PASS without selecting a listener.
+ *   2. If data is NULL (socket migration),
+ *        select a listener (reuseport_map[map[cookie]])
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
+SEC("sk_reuseport")
+int select_by_skb_data(struct sk_reuseport_md *reuse_md)
+{
+	int *key, flags = 0;
+	void *data = reuse_md->data;
+	__u64 cookie = reuse_md->cookie;
+
+	if (data)
+		return SK_PASS;
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

