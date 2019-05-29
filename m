Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B62922E256
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbfE2Qfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:32 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:55252 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfE2Qfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:35:30 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x4TGW8sL032062;
        Wed, 29 May 2019 17:35:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=Le0hVEZwqYzFWoFvQcWgVJvMsbqCPPa5p9acQgaVSvo=;
 b=CYxUPJ9N0iYAqzzkMX5xvN42YqETr41HTe482QBU5OGjbFtzGcy+OF6XxR8etF48S1ZF
 ms2kP9P2eUbX2qJ856MF+elrrdPoWum6N0XcAFV9JHdGjswOwXL8wwf4ubS82WSp+n2d
 b1tMaYwF8aXcJvGWCU9mNo7rKGRKEX6mKbgwRHbQ9HN8zC5iBj8gahNzcLduE3LrDiir
 74yar0HUVG/jPWyE8zexuf9WIydq/4Z1feyXm7/M/j6iYyQSRfHQZ8D7aRvp8ANX0Qwk
 akOO8D1Nw2A0/8QPQZKjoHcTj+GGieqjX2c5/5RxVJK5ytNoCC1UZ4PB5RvsJeuo1adw BA== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2ss7jcvpdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 May 2019 17:35:21 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW0WU009212;
        Wed, 29 May 2019 12:35:20 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2sq11vu8fg-1;
        Wed, 29 May 2019 12:35:19 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 3C85A1FC6C;
        Wed, 29 May 2019 16:35:19 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com, ycheng@google.com
Cc:     cpaasch@apple.com, ilubashe@akamai.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 6/6] selftests/net: add TFO key rotation selftest
Date:   Wed, 29 May 2019 12:34:01 -0400
Message-Id: <176d334dd6b6fdc826625480b0b55d3b9cc7ad90.1559146812.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290108
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Demonstrate how the primary and backup TFO keys can be rotated while
minimizing the number of client cookies that are rejected.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
---
 tools/testing/selftests/net/.gitignore             |   1 +
 tools/testing/selftests/net/Makefile               |   2 +
 .../selftests/net/tcp_fastopen_backup_key.c        | 336 +++++++++++++++++++++
 .../selftests/net/tcp_fastopen_backup_key.sh       |  55 ++++
 4 files changed, 394 insertions(+)
 create mode 100644 tools/testing/selftests/net/tcp_fastopen_backup_key.c
 create mode 100755 tools/testing/selftests/net/tcp_fastopen_backup_key.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 99a4e41..4ce0bc1 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -20,3 +20,4 @@ ip_defrag
 so_txtime
 flowlabel
 flowlabel_mgr
+tcp_fastopen_backup_key
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 8343fb9..9a275d9 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -10,12 +10,14 @@ TEST_PROGS += fib_tests.sh fib-onlink-tests.sh pmtu.sh udpgso.sh ip_defrag.sh
 TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
+TEST_PROGS += tcp_fastopen_backup_key.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
 TEST_GEN_FILES += tcp_mmap tcp_inq psock_snd txring_overwrite
 TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
 TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
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
new file mode 100755
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
+	if [ $val -ne 0 ]; then
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

