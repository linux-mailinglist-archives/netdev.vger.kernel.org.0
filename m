Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3652938224C
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 02:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235072AbhEQA10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 20:27:26 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:38360 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232331AbhEQA1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 20:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.jp; i=@amazon.co.jp; q=dns/txt;
  s=amazon201209; t=1621211171; x=1652747171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r+n+Dm2LDVa/iRNKG29e6zTHlcP2T4WRZzLpJDy3euE=;
  b=DmIbpI0izBWFuQUXsc9CLHKfpP6PVVVHFmLtI8VCAuRMfMQJjvy9wu/e
   /yBY9iLPc+Z6OF0yb3udmEe2/FVZ3dYJXShu9yQYohwXJ8GXnLygalLtU
   OhIK0jVykF11SuSeiO0SQ8Hx8gkC0VVj5m0uLChBdnlxqfzM9YRGQYFDu
   4=;
X-IronPort-AV: E=Sophos;i="5.82,306,1613433600"; 
   d="scan'208";a="113938432"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 17 May 2021 00:26:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 3B072A17FF;
        Mon, 17 May 2021 00:26:06 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:26:06 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.28) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 17 May 2021 00:26:01 +0000
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
Subject: [PATCH v6 bpf-next 11/11] bpf: Test BPF_SK_REUSEPORT_SELECT_OR_MIGRATE.
Date:   Mon, 17 May 2021 09:22:58 +0900
Message-ID: <20210517002258.75019-12-kuniyu@amazon.co.jp>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210517002258.75019-1-kuniyu@amazon.co.jp>
References: <20210517002258.75019-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.28]
X-ClientProxiedBy: EX13D21UWA004.ant.amazon.com (10.43.160.252) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a test for BPF_SK_REUSEPORT_SELECT_OR_MIGRATE and
removes 'static' from settimeo() in network_helpers.c.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
---
 tools/testing/selftests/bpf/network_helpers.c |   2 +-
 tools/testing/selftests/bpf/network_helpers.h |   1 +
 .../bpf/prog_tests/migrate_reuseport.c        | 553 ++++++++++++++++++
 .../bpf/progs/test_migrate_reuseport.c        | 135 +++++
 4 files changed, 690 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_migrate_reuseport.c

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testing/selftests/bpf/network_helpers.c
index 12ee40284da0..2060bc122c53 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -40,7 +40,7 @@ struct ipv6_packet pkt_v6 = {
 	.tcp.doff = 5,
 };
 
-static int settimeo(int fd, int timeout_ms)
+int settimeo(int fd, int timeout_ms)
 {
 	struct timeval timeout = { .tv_sec = 3 };
 
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testing/selftests/bpf/network_helpers.h
index 7205f8afdba1..5e0d51c07b63 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -33,6 +33,7 @@ struct ipv6_packet {
 } __packed;
 extern struct ipv6_packet pkt_v6;
 
+int settimeo(int fd, int timeout_ms);
 int start_server(int family, int type, const char *addr, __u16 port,
 		 int timeout_ms);
 int connect_to_fd(int server_fd, int timeout_ms);
diff --git a/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
new file mode 100644
index 000000000000..2804c0c55154
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/migrate_reuseport.c
@@ -0,0 +1,553 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check if we can migrate child sockets.
+ *
+ *   1. call listen() for 4 server sockets.
+ *   2. call connect() for 25 client sockets.
+ *   3. call listen() for 1 server socket. (migration target)
+ *   4. update a map to migrate all child sockets
+ *        to the last server socket (migrate_map[cookie] = 4)
+ *   5. call shutdown() for first 4 server sockets
+ *        and migrate the requests in the accept queue
+ *        to the last server socket.
+ *   6. call listen() for the second server socket.
+ *   7. call shutdown() for the last server
+ *        and migrate the requests in the accept queue
+ *        to the second server socket.
+ *   8. call listen() for the last server.
+ *   9. call shutdown() for the second server
+ *        and migrate the requests in the accept queue
+ *        to the last server socket.
+ *  10. call accept() for the last server socket.
+ *
+ * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
+ */
+
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#include "test_progs.h"
+#include "test_migrate_reuseport.skel.h"
+#include "network_helpers.h"
+
+#define IFINDEX_LO 1
+
+#define NR_SERVERS 5
+#define NR_CLIENTS (NR_SERVERS * 5)
+#define MIGRATED_TO (NR_SERVERS - 1)
+
+/* fastopenq->max_qlen and sk->sk_max_ack_backlog */
+#define QLEN (NR_CLIENTS * 5)
+
+#define MSG "Hello World\0"
+#define MSGLEN 12
+
+static struct migrate_reuseport_test_case {
+	const char *name;
+	__s64 servers[NR_SERVERS];
+	__s64 clients[NR_CLIENTS];
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+	int family;
+	int state;
+	bool drop_ack;
+	bool expire_synack_timer;
+	bool fastopen;
+	struct bpf_link *link;
+} test_cases[] = {
+	{
+		.name = "IPv4 - TCP_ESTABLISHED - inet_csk_listen_stop",
+		.family = AF_INET,
+		.state = BPF_TCP_ESTABLISHED,
+		.drop_ack = false,
+		.expire_synack_timer = false,
+		.fastopen = false,
+	},
+	{
+		.name = "IPv4 - TCP_SYN_RECV - inet_csk_listen_stop",
+		.family = AF_INET,
+		.state = BPF_TCP_SYN_RECV,
+		.drop_ack = true,
+		.expire_synack_timer = false,
+		.fastopen = true,
+	},
+	{
+		.name = "IPv4 - TCP_NEW_SYN_RECV - reqsk_timer_handler",
+		.family = AF_INET,
+		.state = BPF_TCP_NEW_SYN_RECV,
+		.drop_ack = true,
+		.expire_synack_timer = true,
+		.fastopen = false,
+	},
+	{
+		.name = "IPv4 - TCP_NEW_SYN_RECV - inet_csk_complete_hashdance",
+		.family = AF_INET,
+		.state = BPF_TCP_NEW_SYN_RECV,
+		.drop_ack = true,
+		.expire_synack_timer = false,
+		.fastopen = false,
+	},
+	{
+		.name = "IPv6 - TCP_ESTABLISHED - inet_csk_listen_stop",
+		.family = AF_INET6,
+		.state = BPF_TCP_ESTABLISHED,
+		.drop_ack = false,
+		.expire_synack_timer = false,
+		.fastopen = false,
+	},
+	{
+		.name = "IPv6 - TCP_SYN_RECV - inet_csk_listen_stop",
+		.family = AF_INET6,
+		.state = BPF_TCP_SYN_RECV,
+		.drop_ack = true,
+		.expire_synack_timer = false,
+		.fastopen = true,
+	},
+	{
+		.name = "IPv6 - TCP_NEW_SYN_RECV - reqsk_timer_handler",
+		.family = AF_INET6,
+		.state = BPF_TCP_NEW_SYN_RECV,
+		.drop_ack = true,
+		.expire_synack_timer = true,
+		.fastopen = false,
+	},
+	{
+		.name = "IPv6 - TCP_NEW_SYN_RECV - inet_csk_complete_hashdance",
+		.family = AF_INET6,
+		.state = BPF_TCP_NEW_SYN_RECV,
+		.drop_ack = true,
+		.expire_synack_timer = false,
+		.fastopen = false,
+	}
+};
+
+static void init_fds(__s64 fds[], int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++)
+		fds[i] = -1;
+}
+
+static void close_fds(__s64 fds[], int len)
+{
+	int i;
+
+	for (i = 0; i < len; i++) {
+		if (fds[i] != -1) {
+			close(fds[i]);
+			fds[i] = -1;
+		}
+	}
+}
+
+static int setup_fastopen(char *buf, int size, int *saved_len, bool restore)
+{
+	int err = 0, fd, len;
+
+	fd = open("/proc/sys/net/ipv4/tcp_fastopen", O_RDWR);
+	if (!ASSERT_NEQ(fd, -1, "open"))
+		return -1;
+
+	if (restore) {
+		len = write(fd, buf, *saved_len);
+		if (!ASSERT_EQ(len, *saved_len, "write - restore"))
+			err = -1;
+	} else {
+		*saved_len = read(fd, buf, size);
+		if (!ASSERT_GE(*saved_len, 1, "read")) {
+			err = -1;
+			goto close;
+		}
+
+		err = lseek(fd, 0, SEEK_SET);
+		if (!ASSERT_OK(err, "lseek"))
+			goto close;
+
+		/* (TFO_CLIENT_ENABLE | TFO_SERVER_ENABLE |
+		 *  TFO_CLIENT_NO_COOKIE | TFO_SERVER_COOKIE_NOT_REQD)
+		 */
+		len = write(fd, "519", 3);
+		if (!ASSERT_EQ(len, 3, "write - setup"))
+			err = -1;
+	}
+
+close:
+	close(fd);
+
+	return err;
+}
+
+static int drop_ack(struct migrate_reuseport_test_case *test_case,
+		    struct test_migrate_reuseport *skel)
+{
+	if (test_case->family == AF_INET)
+		skel->bss->server_port = ((struct sockaddr_in *)
+					  &test_case->addr)->sin_port;
+	else
+		skel->bss->server_port = ((struct sockaddr_in6 *)
+					  &test_case->addr)->sin6_port;
+
+	test_case->link = bpf_program__attach_xdp(skel->progs.drop_ack,
+						  IFINDEX_LO);
+	if (!ASSERT_OK_PTR(test_case->link, "bpf_program__attach_xdp"))
+		return -1;
+
+	return 0;
+}
+
+static int pass_ack(struct migrate_reuseport_test_case *test_case)
+{
+	int err;
+
+	err = bpf_link__detach(test_case->link);
+	if (!ASSERT_OK(err, "bpf_link__detach"))
+		return -1;
+
+	test_case->link = NULL;
+
+	return 0;
+}
+
+static int start_servers(struct migrate_reuseport_test_case *test_case,
+			 struct test_migrate_reuseport *skel)
+{
+	int i, err, prog_fd, reuseport = 1, qlen = QLEN;
+
+	prog_fd = bpf_program__fd(skel->progs.migrate_reuseport);
+
+	make_sockaddr(test_case->family,
+		      test_case->family == AF_INET ? "127.0.0.1" : "::1", 0,
+		      &test_case->addr, &test_case->addrlen);
+
+	for (i = 0; i < NR_SERVERS; i++) {
+		test_case->servers[i] = socket(test_case->family, SOCK_STREAM,
+					       IPPROTO_TCP);
+		if (!ASSERT_NEQ(test_case->servers[i], -1, "socket"))
+			return -1;
+
+		err = setsockopt(test_case->servers[i], SOL_SOCKET,
+				 SO_REUSEPORT, &reuseport, sizeof(reuseport));
+		if (!ASSERT_OK(err, "setsockopt - SO_REUSEPORT"))
+			return -1;
+
+		err = bind(test_case->servers[i],
+			   (struct sockaddr *)&test_case->addr,
+			   test_case->addrlen);
+		if (!ASSERT_OK(err, "bind"))
+			return -1;
+
+		if (i == 0) {
+			err = setsockopt(test_case->servers[i], SOL_SOCKET,
+					 SO_ATTACH_REUSEPORT_EBPF,
+					 &prog_fd, sizeof(prog_fd));
+			if (!ASSERT_OK(err,
+				       "setsockopt - SO_ATTACH_REUSEPORT_EBPF"))
+				return -1;
+
+			err = getsockname(test_case->servers[i],
+					  (struct sockaddr *)&test_case->addr,
+					  &test_case->addrlen);
+			if (!ASSERT_OK(err, "getsockname"))
+				return -1;
+		}
+
+		if (test_case->fastopen) {
+			err = setsockopt(test_case->servers[i],
+					 SOL_TCP, TCP_FASTOPEN,
+					 &qlen, sizeof(qlen));
+			if (!ASSERT_OK(err, "setsockopt - TCP_FASTOPEN"))
+				return -1;
+		}
+
+		/* All requests will be tied to the first four listeners */
+		if (i != MIGRATED_TO) {
+			err = listen(test_case->servers[i], qlen);
+			if (!ASSERT_OK(err, "listen"))
+				return -1;
+		}
+	}
+
+	return 0;
+}
+
+static int start_clients(struct migrate_reuseport_test_case *test_case)
+{
+	char buf[MSGLEN] = MSG;
+	int i, err;
+
+	for (i = 0; i < NR_CLIENTS; i++) {
+		test_case->clients[i] = socket(test_case->family, SOCK_STREAM,
+					       IPPROTO_TCP);
+		if (!ASSERT_NEQ(test_case->clients[i], -1, "socket"))
+			return -1;
+
+		/* The attached XDP program drops only the final ACK, so
+		 * clients will transition to TCP_ESTABLISHED immediately.
+		 */
+		err = settimeo(test_case->clients[i], 100);
+		if (!ASSERT_OK(err, "settimeo"))
+			return -1;
+
+		if (test_case->fastopen) {
+			int fastopen = 1;
+
+			err = setsockopt(test_case->clients[i], IPPROTO_TCP,
+					 TCP_FASTOPEN_CONNECT, &fastopen,
+					 sizeof(fastopen));
+			if (!ASSERT_OK(err,
+				       "setsockopt - TCP_FASTOPEN_CONNECT"))
+				return -1;
+		}
+
+		err = connect(test_case->clients[i],
+			      (struct sockaddr *)&test_case->addr,
+			      test_case->addrlen);
+		if (!ASSERT_OK(err, "connect"))
+			return -1;
+
+		err = write(test_case->clients[i], buf, MSGLEN);
+		if (!ASSERT_EQ(err, MSGLEN, "write"))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int update_maps(struct migrate_reuseport_test_case *test_case,
+		       struct test_migrate_reuseport *skel)
+{
+	int i, err, migrated_to = MIGRATED_TO;
+	int reuseport_map_fd, migrate_map_fd;
+	__u64 value;
+
+	reuseport_map_fd = bpf_map__fd(skel->maps.reuseport_map);
+	migrate_map_fd = bpf_map__fd(skel->maps.migrate_map);
+
+	for (i = 0; i < NR_SERVERS; i++) {
+		value = (__u64)test_case->servers[i];
+		err = bpf_map_update_elem(reuseport_map_fd, &i, &value,
+					  BPF_NOEXIST);
+		if (!ASSERT_OK(err, "bpf_map_update_elem - reuseport_map"))
+			return -1;
+
+		err = bpf_map_lookup_elem(reuseport_map_fd, &i, &value);
+		if (!ASSERT_OK(err, "bpf_map_lookup_elem - reuseport_map"))
+			return -1;
+
+		err = bpf_map_update_elem(migrate_map_fd, &value, &migrated_to,
+					  BPF_NOEXIST);
+		if (!ASSERT_OK(err, "bpf_map_update_elem - migrate_map"))
+			return -1;
+	}
+
+	return 0;
+}
+
+static int migrate_dance(struct migrate_reuseport_test_case *test_case)
+{
+	int i, err;
+
+	/* Migrate TCP_ESTABLISHED and TCP_SYN_RECV requests
+	 * to the last listener based on eBPF.
+	 */
+	for (i = 0; i < MIGRATED_TO; i++) {
+		err = shutdown(test_case->servers[i], SHUT_RDWR);
+		if (!ASSERT_OK(err, "shutdown"))
+			return -1;
+	}
+
+	/* No dance for TCP_NEW_SYN_RECV to migrate based on eBPF */
+	if (test_case->state == BPF_TCP_NEW_SYN_RECV)
+		return 0;
+
+	/* Note that we use the second listener instead of the
+	 * first one here.
+	 *
+	 * The fist listener is bind()ed with port 0 and,
+	 * SOCK_BINDPORT_LOCK is not set to sk_userlocks, so
+	 * calling listen() again will bind() the first listener
+	 * on a new ephemeral port and detach it from the existing
+	 * reuseport group.  (See: __inet_bind(), tcp_set_state())
+	 *
+	 * OTOH, the second one is bind()ed with a specific port,
+	 * and SOCK_BINDPORT_LOCK is set. Thus, re-listen() will
+	 * resurrect the listener on the existing reuseport group.
+	 */
+	err = listen(test_case->servers[1], QLEN);
+	if (!ASSERT_OK(err, "listen"))
+		return -1;
+
+	/* Migrate from the last listener to the second one.
+	 *
+	 * All listeners were detached out of the reuseport_map,
+	 * so migration will be done by kernel random pick from here.
+	 */
+	err = shutdown(test_case->servers[MIGRATED_TO], SHUT_RDWR);
+	if (!ASSERT_OK(err, "shutdown"))
+		return -1;
+
+	/* Back to the existing reuseport group */
+	err = listen(test_case->servers[MIGRATED_TO], QLEN);
+	if (!ASSERT_OK(err, "listen"))
+		return -1;
+
+	/* Migrate back to the last one from the second one */
+	err = shutdown(test_case->servers[1], SHUT_RDWR);
+	if (!ASSERT_OK(err, "shutdown"))
+		return -1;
+
+	return 0;
+}
+
+static void count_requests(struct migrate_reuseport_test_case *test_case,
+			   struct test_migrate_reuseport *skel)
+{
+	struct sockaddr_storage addr;
+	socklen_t len = sizeof(addr);
+	int err, cnt = 0, client;
+	char buf[MSGLEN];
+
+	err = settimeo(test_case->servers[MIGRATED_TO], 4000);
+	if (!ASSERT_OK(err, "settimeo"))
+		goto out;
+
+	for (; cnt < NR_CLIENTS; cnt++) {
+		client = accept(test_case->servers[MIGRATED_TO],
+				(struct sockaddr *)&addr, &len);
+		if (!ASSERT_NEQ(client, -1, "accept"))
+			goto out;
+
+		memset(buf, 0, MSGLEN);
+		read(client, &buf, MSGLEN);
+		close(client);
+
+		if (!ASSERT_STREQ(buf, MSG, "read"))
+			goto out;
+	}
+
+out:
+	ASSERT_EQ(cnt, NR_CLIENTS, test_case->name);
+
+	switch (test_case->state) {
+	case BPF_TCP_ESTABLISHED:
+		cnt = skel->bss->migrated_at_close;
+		break;
+	case BPF_TCP_SYN_RECV:
+		cnt = skel->bss->migrated_at_close_fastopen;
+		break;
+	case BPF_TCP_NEW_SYN_RECV:
+		if (test_case->expire_synack_timer)
+			cnt = skel->bss->migrated_at_send_synack;
+		else
+			cnt = skel->bss->migrated_at_recv_ack;
+		break;
+	default:
+		cnt = 0;
+	}
+
+	ASSERT_EQ(cnt, NR_CLIENTS, test_case->name);
+}
+
+static void run_test(struct migrate_reuseport_test_case *test_case,
+		     struct test_migrate_reuseport *skel)
+{
+	int err, saved_len;
+	char buf[16];
+
+	skel->bss->migrated_at_close = 0;
+	skel->bss->migrated_at_close_fastopen = 0;
+	skel->bss->migrated_at_send_synack = 0;
+	skel->bss->migrated_at_recv_ack = 0;
+
+	init_fds(test_case->servers, NR_SERVERS);
+	init_fds(test_case->clients, NR_CLIENTS);
+
+	if (test_case->fastopen) {
+		memset(buf, 0, sizeof(buf));
+
+		err = setup_fastopen(buf, sizeof(buf), &saved_len, false);
+		if (!ASSERT_OK(err, "setup_fastopen - setup"))
+			return;
+	}
+
+	err = start_servers(test_case, skel);
+	if (!ASSERT_OK(err, "start_servers"))
+		goto close_servers;
+
+	if (test_case->drop_ack) {
+		/* Drop the final ACK of the 3-way handshake and stick the
+		 * in-flight requests on TCP_SYN_RECV or TCP_NEW_SYN_RECV.
+		 */
+		err = drop_ack(test_case, skel);
+		if (!ASSERT_OK(err, "drop_ack"))
+			goto close_servers;
+	}
+
+	/* Tie requests to the first four listners */
+	err = start_clients(test_case);
+	if (!ASSERT_OK(err, "start_clients"))
+		goto close_clients;
+
+	err = listen(test_case->servers[MIGRATED_TO], QLEN);
+	if (!ASSERT_OK(err, "listen"))
+		goto close_clients;
+
+	err = update_maps(test_case, skel);
+	if (!ASSERT_OK(err, "fill_maps"))
+		goto close_clients;
+
+	/* Migrate the requests in the accept queue only.
+	 * TCP_NEW_SYN_RECV requests are not migrated at this point.
+	 */
+	err = migrate_dance(test_case);
+	if (!ASSERT_OK(err, "migrate_dance"))
+		goto close_clients;
+
+	if (test_case->expire_synack_timer) {
+		/* Wait for SYN+ACK timers to expire so that
+		 * reqsk_timer_handler() migrates TCP_NEW_SYN_RECV requests.
+		 */
+		sleep(1);
+	}
+
+	if (test_case->link) {
+		/* Resume 3WHS and migrate TCP_NEW_SYN_RECV requests */
+		err = pass_ack(test_case);
+		if (!ASSERT_OK(err, "pass_ack"))
+			goto close_clients;
+	}
+
+	count_requests(test_case, skel);
+
+close_clients:
+	close_fds(test_case->clients, NR_CLIENTS);
+
+	if (test_case->link) {
+		err = pass_ack(test_case);
+		ASSERT_OK(err, "pass_ack - clean up");
+	}
+
+close_servers:
+	close_fds(test_case->servers, NR_SERVERS);
+
+	if (test_case->fastopen) {
+		err = setup_fastopen(buf, sizeof(buf), &saved_len, true);
+		ASSERT_OK(err, "setup_fastopen - restore");
+	}
+}
+
+void test_migrate_reuseport(void)
+{
+	struct test_migrate_reuseport *skel;
+	int i;
+
+	skel = test_migrate_reuseport__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++)
+		run_test(&test_cases[i], skel);
+
+	test_migrate_reuseport__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
new file mode 100644
index 000000000000..27df571abf5b
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_migrate_reuseport.c
@@ -0,0 +1,135 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Check if we can migrate child sockets.
+ *
+ *   1. If reuse_md->migrating_sk is NULL (SYN packet),
+ *        return SK_PASS without selecting a listener.
+ *   2. If reuse_md->migrating_sk is not NULL (socket migration),
+ *        select a listener (reuseport_map[migrate_map[cookie]])
+ *
+ * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
+ */
+
+#include <stddef.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/tcp.h>
+#include <linux/in.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_helpers.h>
+
+struct {
+	__uint(type, BPF_MAP_TYPE_REUSEPORT_SOCKARRAY);
+	__uint(max_entries, 256);
+	__type(key, int);
+	__type(value, __u64);
+} reuseport_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 256);
+	__type(key, __u64);
+	__type(value, int);
+} migrate_map SEC(".maps");
+
+int migrated_at_close = 0;
+int migrated_at_close_fastopen = 0;
+int migrated_at_send_synack = 0;
+int migrated_at_recv_ack = 0;
+__be16 server_port;
+
+SEC("xdp")
+int drop_ack(struct xdp_md *xdp)
+{
+	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(long)xdp->data;
+	struct ethhdr *eth = data;
+	struct tcphdr *tcp = NULL;
+
+	if (eth + 1 > data_end)
+		goto pass;
+
+	switch (bpf_ntohs(eth->h_proto)) {
+	case ETH_P_IP: {
+		struct iphdr *ip = (struct iphdr *)(eth + 1);
+
+		if (ip + 1 > data_end)
+			goto pass;
+
+		if (ip->protocol != IPPROTO_TCP)
+			goto pass;
+
+		tcp = (struct tcphdr *)((void *)ip + ip->ihl * 4);
+		break;
+	}
+	case ETH_P_IPV6: {
+		struct ipv6hdr *ipv6 = (struct ipv6hdr *)(eth + 1);
+
+		if (ipv6 + 1 > data_end)
+			goto pass;
+
+		if (ipv6->nexthdr != IPPROTO_TCP)
+			goto pass;
+
+		tcp = (struct tcphdr *)(ipv6 + 1);
+		break;
+	}
+	default:
+		goto pass;
+	}
+
+	if (tcp + 1 > data_end)
+		goto pass;
+
+	if (tcp->dest != server_port)
+		goto pass;
+
+	if (!tcp->syn && tcp->ack)
+		return XDP_DROP;
+
+pass:
+	return XDP_PASS;
+}
+
+SEC("sk_reuseport/migrate")
+int migrate_reuseport(struct sk_reuseport_md *reuse_md)
+{
+	int *key, flags = 0, state, err;
+	__u64 cookie;
+
+	if (!reuse_md->migrating_sk)
+		return SK_PASS;
+
+	state = reuse_md->migrating_sk->state;
+	cookie = bpf_get_socket_cookie(reuse_md->sk);
+
+	key = bpf_map_lookup_elem(&migrate_map, &cookie);
+	if (!key)
+		return SK_DROP;
+
+	err = bpf_sk_select_reuseport(reuse_md, &reuseport_map, key, flags);
+	if (err)
+		return SK_PASS;
+
+	switch (state) {
+	case BPF_TCP_ESTABLISHED:
+		__sync_fetch_and_add(&migrated_at_close, 1);
+		break;
+	case BPF_TCP_SYN_RECV:
+		__sync_fetch_and_add(&migrated_at_close_fastopen, 1);
+		break;
+	case BPF_TCP_NEW_SYN_RECV:
+		if (!reuse_md->len)
+			__sync_fetch_and_add(&migrated_at_send_synack, 1);
+		else
+			__sync_fetch_and_add(&migrated_at_recv_ack, 1);
+		break;
+	}
+
+	return SK_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.30.2

