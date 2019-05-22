Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFA8270EB
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbfEVUlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:41:09 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:42272 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729528AbfEVUlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:41:08 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MKbAEq000874;
        Wed, 22 May 2019 21:41:03 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=XAUsv1SkmBioDO8A+BHV5kBZSgD0oE3aYe0IYBlVDjY=;
 b=mr6+YURmvOAZmraSnYwhkwzrJdycZUIZOQ8biu9mqkATGswGLOOCL4A/9j9VGxyzr/jk
 3VlLsFU5IWhArXh1TvSQcnDyRkI5r4DX6JvTln0gdQMbUqbjaD3KAM0N9zGIc5fKX9s5
 FsMoI7vQgpnY3/cKQkdyjtmRGDqZQgqo9waO6cTAlnf5X5K14Q+H1GEtAEpt66i7g9nA
 OpYXcuppCP9LBauI5O3Hov5s4T4EtyWP5dhKT+3J4bjedW6M6NTewTEoZrq/aa+SASUC
 OSXp92t+Nti1NP8ivk+U7O47j0Xg+FfmQlIjGwfV26ftbk7KLkMxvRpMoVLaJAmRyp2s PQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2smny5q9tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:41:03 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKX5oJ011403;
        Wed, 22 May 2019 16:41:02 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsjuf-5;
        Wed, 22 May 2019 16:41:01 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 7246332A8E;
        Wed, 22 May 2019 20:40:31 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 6/6] selftests/net: add TFO key rotation selftest
Date:   Wed, 22 May 2019 16:39:38 -0400
Message-Id: <d7a5087aee04b912951131d7abf0d3a402336269.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrate how the primary and backup TFO keys can be rotated while
minimizing the number of client cookies that are rejected.

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 tools/testing/selftests/net/.gitignore             |   1 +
 tools/testing/selftests/net/Makefile               |   3 +-
 .../selftests/net/tcp_fastopen_backup_key.c        | 336 +++++++++++++++++++++
 .../selftests/net/tcp_fastopen_backup_key.sh       |  55 ++++
 4 files changed, 394 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/tcp_fastopen_backup_key.c
 create mode 100644 tools/testing/selftests/net/tcp_fastopen_backup_key.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 6f81130..30d9ec1 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -17,3 +17,4 @@ tcp_inq
 tls
 txring_overwrite
 ip_defrag
+tcp_fastopen_backup_key
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 1e6d14d..287cc21 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -9,12 +9,13 @@ TEST_PROGS := run_netsocktests run_afpackettests test_bpf.sh netdevice.sh \
 TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
-TEST_PROGS += test_vxlan_fdb_changelink.sh
+TEST_PROGS += test_vxlan_fdb_changelink.sh tcp_fastopen_backup_key.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
+TEST_GEN_FILES += tcp_fastopen_backup_key
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
 
diff --git a/tools/testing/selftests/net/tcp_fastopen_backup_key.c b/tools/testing/selftests/net/tcp_fastopen_backup_key.c
new file mode 100644
index 0000000..58bb77d
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_fastopen_backup_key.c
@@ -0,0 +1,336 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Test key rotation for TFO.
+ * New keys are 'rotated' in two steps:
+ * 1) Add new key as the 'backup' key 'behind' the primary key
+ * 2) Make new key the primary by swapping the backup and primary keys
+ *
+ * The rotation is done in stages using multiple sockets bound
+ * to the same port via SO_REUSEPORT. This simulates key rotation
+ * behind say a load balancer. We verify that across the rotation
+ * there are no cases in which a cookie is not accepted by verifying
+ * that TcpExtTCPFastOpenPassiveFail remains 0.
+ */
+#define _GNU_SOURCE
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/epoll.h>
+#include <unistd.h>
+#include <netinet/tcp.h>
+#include <fcntl.h>
+#include <time.h>
+
+#ifndef TCP_FASTOPEN_KEY
+#define TCP_FASTOPEN_KEY 33
+#endif
+
+#define N_LISTEN 10
+#define PROC_FASTOPEN_KEY "/proc/sys/net/ipv4/tcp_fastopen_key"
+#define KEY_LENGTH 16
+
+#ifndef ARRAY_SIZE
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+#endif
+
+static bool do_ipv6;
+static bool do_sockopt;
+static bool do_rotate;
+static int key_len = KEY_LENGTH;
+static int rcv_fds[N_LISTEN];
+static int proc_fd;
+static const char *IP4_ADDR = "127.0.0.1";
+static const char *IP6_ADDR = "::1";
+static const int PORT = 8891;
+
+static void get_keys(int fd, uint32_t *keys)
+{
+	char buf[128];
+	int len = KEY_LENGTH * 2;
+
+	if (do_sockopt) {
+		if (getsockopt(fd, SOL_TCP, TCP_FASTOPEN_KEY, keys, &len))
+			error(1, errno, "Unable to get key");
+		return;
+	}
+	lseek(proc_fd, 0, SEEK_SET);
+	if (read(proc_fd, buf, sizeof(buf)) <= 0)
+		error(1, errno, "Unable to read %s", PROC_FASTOPEN_KEY);
+	if (sscanf(buf, "%x-%x-%x-%x,%x-%x-%x-%x", keys, keys + 1, keys + 2,
+	    keys + 3, keys + 4, keys + 5, keys + 6, keys + 7) != 8)
+		error(1, 0, "Unable to parse %s", PROC_FASTOPEN_KEY);
+}
+
+static void set_keys(int fd, uint32_t *keys)
+{
+	char buf[128];
+
+	if (do_sockopt) {
+		if (setsockopt(fd, SOL_TCP, TCP_FASTOPEN_KEY, keys,
+		    key_len))
+			error(1, errno, "Unable to set key");
+		return;
+	}
+	if (do_rotate)
+		snprintf(buf, 128, "%08x-%08x-%08x-%08x,%08x-%08x-%08x-%08x",
+			 keys[0], keys[1], keys[2], keys[3], keys[4], keys[5],
+			 keys[6], keys[7]);
+	else
+		snprintf(buf, 128, "%08x-%08x-%08x-%08x",
+			 keys[0], keys[1], keys[2], keys[3]);
+	lseek(proc_fd, 0, SEEK_SET);
+	if (write(proc_fd, buf, sizeof(buf)) <= 0)
+		error(1, errno, "Unable to write %s", PROC_FASTOPEN_KEY);
+}
+
+static void build_rcv_fd(int family, int proto, int *rcv_fds)
+{
+	struct sockaddr_in  addr4 = {0};
+	struct sockaddr_in6 addr6 = {0};
+	struct sockaddr *addr;
+	int opt = 1, i, sz;
+	int qlen = 100;
+	uint32_t keys[8];
+
+	switch (family) {
+	case AF_INET:
+		addr4.sin_family = family;
+		addr4.sin_addr.s_addr = htonl(INADDR_ANY);
+		addr4.sin_port = htons(PORT);
+		sz = sizeof(addr4);
+		addr = (struct sockaddr *)&addr4;
+		break;
+	case AF_INET6:
+		addr6.sin6_family = AF_INET6;
+		addr6.sin6_addr = in6addr_any;
+		addr6.sin6_port = htons(PORT);
+		sz = sizeof(addr6);
+		addr = (struct sockaddr *)&addr6;
+		break;
+	default:
+		error(1, 0, "Unsupported family %d", family);
+		/* clang does not recognize error() above as terminating
+		 * the program, so it complains that saddr, sz are
+		 * not initialized when this code path is taken. Silence it.
+		 */
+		return;
+	}
+	for (i = 0; i < ARRAY_SIZE(keys); i++)
+		keys[i] = rand();
+	for (i = 0; i < N_LISTEN; i++) {
+		rcv_fds[i] = socket(family, proto, 0);
+		if (rcv_fds[i] < 0)
+			error(1, errno, "failed to create receive socket");
+		if (setsockopt(rcv_fds[i], SOL_SOCKET, SO_REUSEPORT, &opt,
+			       sizeof(opt)))
+			error(1, errno, "failed to set SO_REUSEPORT");
+		if (bind(rcv_fds[i], addr, sz))
+			error(1, errno, "failed to bind receive socket");
+		if (setsockopt(rcv_fds[i], SOL_TCP, TCP_FASTOPEN, &qlen,
+			       sizeof(qlen)))
+			error(1, errno, "failed to set TCP_FASTOPEN");
+		set_keys(rcv_fds[i], keys);
+		if (proto == SOCK_STREAM && listen(rcv_fds[i], 10))
+			error(1, errno, "failed to listen on receive port");
+	}
+}
+
+static int connect_and_send(int family, int proto)
+{
+	struct sockaddr_in  saddr4 = {0};
+	struct sockaddr_in  daddr4 = {0};
+	struct sockaddr_in6 saddr6 = {0};
+	struct sockaddr_in6 daddr6 = {0};
+	struct sockaddr *saddr, *daddr;
+	int fd, sz, ret;
+	char data[1];
+
+	switch (family) {
+	case AF_INET:
+		saddr4.sin_family = AF_INET;
+		saddr4.sin_addr.s_addr = htonl(INADDR_ANY);
+		saddr4.sin_port = 0;
+
+		daddr4.sin_family = AF_INET;
+		if (!inet_pton(family, IP4_ADDR, &daddr4.sin_addr.s_addr))
+			error(1, errno, "inet_pton failed: %s", IP4_ADDR);
+		daddr4.sin_port = htons(PORT);
+
+		sz = sizeof(saddr4);
+		saddr = (struct sockaddr *)&saddr4;
+		daddr = (struct sockaddr *)&daddr4;
+		break;
+	case AF_INET6:
+		saddr6.sin6_family = AF_INET6;
+		saddr6.sin6_addr = in6addr_any;
+
+		daddr6.sin6_family = AF_INET6;
+		if (!inet_pton(family, IP6_ADDR, &daddr6.sin6_addr))
+			error(1, errno, "inet_pton failed: %s", IP6_ADDR);
+		daddr6.sin6_port = htons(PORT);
+
+		sz = sizeof(saddr6);
+		saddr = (struct sockaddr *)&saddr6;
+		daddr = (struct sockaddr *)&daddr6;
+		break;
+	default:
+		error(1, 0, "Unsupported family %d", family);
+		/* clang does not recognize error() above as terminating
+		 * the program, so it complains that saddr, daddr, sz are
+		 * not initialized when this code path is taken. Silence it.
+		 */
+		return -1;
+	}
+	fd = socket(family, proto, 0);
+	if (fd < 0)
+		error(1, errno, "failed to create send socket");
+	if (bind(fd, saddr, sz))
+		error(1, errno, "failed to bind send socket");
+	data[0] = 'a';
+	ret = sendto(fd, data, 1, MSG_FASTOPEN, daddr, sz);
+	if (ret != 1)
+		error(1, errno, "failed to sendto");
+
+	return fd;
+}
+
+static bool is_listen_fd(int fd)
+{
+	int i;
+
+	for (i = 0; i < N_LISTEN; i++) {
+		if (rcv_fds[i] == fd)
+			return true;
+	}
+	return false;
+}
+
+static int rotate_key(int fd)
+{
+	static int iter;
+	static uint32_t new_key[4];
+	uint32_t keys[8];
+	uint32_t tmp_key[4];
+	int i;
+	int len = KEY_LENGTH * 2;
+
+	if (iter < N_LISTEN) {
+		/* first set new key as backups */
+		if (iter == 0) {
+			for (i = 0; i < ARRAY_SIZE(new_key); i++)
+				new_key[i] = rand();
+		}
+		get_keys(fd, keys);
+		memcpy(keys + 4, new_key, KEY_LENGTH);
+		set_keys(fd, keys);
+	} else {
+		/* swap the keys */
+		get_keys(fd, keys);
+		memcpy(tmp_key, keys + 4, KEY_LENGTH);
+		memcpy(keys + 4, keys, KEY_LENGTH);
+		memcpy(keys, tmp_key, KEY_LENGTH);
+		set_keys(fd, keys);
+	}
+	if (++iter >= (N_LISTEN * 2))
+		iter = 0;
+}
+
+static void run_one_test(int family)
+{
+	struct epoll_event ev;
+	int i, send_fd;
+	int n_loops = 10000;
+	int rotate_key_fd = 0;
+	int key_rotate_interval = 50;
+	int fd, epfd;
+	char buf[1];
+
+	build_rcv_fd(family, SOCK_STREAM, rcv_fds);
+	epfd = epoll_create(1);
+	if (epfd < 0)
+		error(1, errno, "failed to create epoll");
+	ev.events = EPOLLIN;
+	for (i = 0; i < N_LISTEN; i++) {
+		ev.data.fd = rcv_fds[i];
+		if (epoll_ctl(epfd, EPOLL_CTL_ADD, rcv_fds[i], &ev))
+			error(1, errno, "failed to register sock epoll");
+	}
+	while (n_loops--) {
+		send_fd = connect_and_send(family, SOCK_STREAM);
+		if (do_rotate && ((n_loops % key_rotate_interval) == 0)) {
+			rotate_key(rcv_fds[rotate_key_fd]);
+			if (++rotate_key_fd >= N_LISTEN)
+				rotate_key_fd = 0;
+		}
+		while (1) {
+			i = epoll_wait(epfd, &ev, 1, -1);
+			if (i < 0)
+				error(1, errno, "epoll_wait failed");
+			if (is_listen_fd(ev.data.fd)) {
+				fd = accept(ev.data.fd, NULL, NULL);
+				if (fd < 0)
+					error(1, errno, "failed to accept");
+				ev.data.fd = fd;
+				if (epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev))
+					error(1, errno, "failed epoll add");
+				continue;
+			}
+			i = recv(ev.data.fd, buf, sizeof(buf), 0);
+			if (i != 1)
+				error(1, errno, "failed recv data");
+			if (epoll_ctl(epfd, EPOLL_CTL_DEL, ev.data.fd, NULL))
+				error(1, errno, "failed epoll del");
+			close(ev.data.fd);
+			break;
+		}
+		close(send_fd);
+	}
+	for (i = 0; i < N_LISTEN; i++)
+		close(rcv_fds[i]);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "46sr")) != -1) {
+		switch (c) {
+		case '4':
+			do_ipv6 = false;
+			break;
+		case '6':
+			do_ipv6 = true;
+			break;
+		case 's':
+			do_sockopt = true;
+			break;
+		case 'r':
+			do_rotate = true;
+			key_len = KEY_LENGTH * 2;
+			break;
+		default:
+			error(1, 0, "%s: parse error", argv[0]);
+		}
+	}
+}
+
+int main(int argc, char **argv)
+{
+	parse_opts(argc, argv);
+	proc_fd = open(PROC_FASTOPEN_KEY, O_RDWR);
+	if (proc_fd < 0)
+		error(1, errno, "Unable to open %s", PROC_FASTOPEN_KEY);
+	srand(time(NULL));
+	if (do_ipv6)
+		run_one_test(AF_INET6);
+	else
+		run_one_test(AF_INET);
+	close(proc_fd);
+	fprintf(stderr, "PASS\n");
+	return 0;
+}
diff --git a/tools/testing/selftests/net/tcp_fastopen_backup_key.sh b/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
new file mode 100644
index 0000000..3d6398f
--- /dev/null
+++ b/tools/testing/selftests/net/tcp_fastopen_backup_key.sh
@@ -0,0 +1,55 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# rotate TFO keys for ipv4/ipv6 and verify that the client does
+# not present an invalid cookie.
+
+set +x
+set -e
+
+readonly NETNS="ns-$(mktemp -u XXXXXX)"
+
+setup() {
+	ip netns add "${NETNS}"
+	ip -netns "${NETNS}" link set lo up
+	ip netns exec "${NETNS}" sysctl -w net.ipv4.tcp_fastopen=3 \
+		>/dev/null 2>&1
+}
+
+cleanup() {
+	ip netns del "${NETNS}"
+}
+
+trap cleanup EXIT
+setup
+
+do_test() {
+	# flush routes before each run, otherwise successive runs can
+	# initially present an old TFO cookie
+	ip netns exec "${NETNS}" ip tcp_metrics flush
+	ip netns exec "${NETNS}" ./tcp_fastopen_backup_key "$1"
+	val=$(ip netns exec "${NETNS}" nstat -az | \
+		grep TcpExtTCPFastOpenPassiveFail | awk '{print $2}')
+	if [ $val -ne 0 ];then
+		echo "FAIL: TcpExtTCPFastOpenPassiveFail non-zero"
+		return 1
+	fi
+}
+
+do_test "-4"
+do_test "-6"
+do_test "-4"
+do_test "-6"
+do_test "-4s"
+do_test "-6s"
+do_test "-4s"
+do_test "-6s"
+do_test "-4r"
+do_test "-6r"
+do_test "-4r"
+do_test "-6r"
+do_test "-4sr"
+do_test "-6sr"
+do_test "-4sr"
+do_test "-6sr"
+echo "all tests done"
-- 
2.7.4

