Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE1949598
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbfFQW71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:27 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728650AbfFQW6y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:51 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 22/33] mptcp: add basic kselftest program
Date:   Mon, 17 Jun 2019 15:57:57 -0700
Message-Id: <20190617225808.665-23-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

create mptcp connection between two processes, xmit data back and
forth.  Data is read from stdin and written (after traversing mtcp
connection twice) to stdout.

Wrapper script tests that data has passed un-altered.

Will run automatically on "make kselftest".

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/net/mptcp/.gitignore  |   1 +
 tools/testing/selftests/net/mptcp/Makefile    |  11 +
 tools/testing/selftests/net/mptcp/config      |   1 +
 .../selftests/net/mptcp/mptcp_connect.c       | 390 ++++++++++++++++++
 .../selftests/net/mptcp/mptcp_connect.sh      |  48 +++
 6 files changed, 452 insertions(+)
 create mode 100644 tools/testing/selftests/net/mptcp/.gitignore
 create mode 100644 tools/testing/selftests/net/mptcp/Makefile
 create mode 100644 tools/testing/selftests/net/mptcp/config
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_connect.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 9781ca79794a..e949f1be6773 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -29,6 +29,7 @@ TARGETS += memory-hotplug
 TARGETS += mount
 TARGETS += mqueue
 TARGETS += net
+TARGETS += net/mptcp
 TARGETS += netfilter
 TARGETS += networking/timestamping
 TARGETS += nsfs
diff --git a/tools/testing/selftests/net/mptcp/.gitignore b/tools/testing/selftests/net/mptcp/.gitignore
new file mode 100644
index 000000000000..3143fb05a511
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/.gitignore
@@ -0,0 +1 @@
+mptcp_connect
diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
new file mode 100644
index 000000000000..0fc5d45055ee
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+
+top_srcdir = ../../../../..
+
+CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g
+
+TEST_PROGS := mptcp_connect.sh
+
+TEST_GEN_FILES = mptcp_connect
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
new file mode 100644
index 000000000000..3bfe60494af8
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/config
@@ -0,0 +1 @@
+CONFIG_MPTCP=y
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
new file mode 100644
index 000000000000..78c43624e84f
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -0,0 +1,390 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <fcntl.h>
+#include <string.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <strings.h>
+#include <unistd.h>
+
+#include <sys/poll.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+
+#include <netdb.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+
+extern int optind;
+
+#ifndef IPPROTO_MPTCP
+#define IPPROTO_MPTCP 262
+#endif
+
+static const char *cfg_host;
+static const char *cfg_port	= "12000";
+static int cfg_server_proto	= IPPROTO_MPTCP;
+static int cfg_client_proto	= IPPROTO_MPTCP;
+
+static void die_usage(void)
+{
+	fprintf(stderr, "Usage: mptcp_connect [-c MPTCP|TCP] [-p port] "
+		"[-s MPTCP|TCP]\n");
+	exit(-1);
+}
+
+static const char *getxinfo_strerr(int err)
+{
+	if (err == EAI_SYSTEM)
+		return strerror(errno);
+
+	return gai_strerror(err);
+}
+
+static void xgetaddrinfo(const char *node, const char *service,
+			 const struct addrinfo *hints,
+			 struct addrinfo **res)
+{
+	int err = getaddrinfo(node, service, hints, res);
+
+	if (err) {
+		const char *errstr = getxinfo_strerr(err);
+
+		fprintf(stderr, "Fatal: getaddrinfo(%s:%s): %s\n",
+			node ? node : "", service ? service : "", errstr);
+		exit(1);
+	}
+}
+
+static int sock_listen_mptcp(const char * const listenaddr,
+			     const char * const port)
+{
+	int sock;
+	struct addrinfo hints = {
+		.ai_protocol = IPPROTO_TCP,
+		.ai_socktype = SOCK_STREAM,
+		.ai_flags = AI_PASSIVE | AI_NUMERICHOST
+	};
+
+	hints.ai_family = AF_INET;
+
+	struct addrinfo *a, *addr;
+	int one = 1;
+
+	xgetaddrinfo(listenaddr, port, &hints, &addr);
+
+	for (a = addr; a; a = a->ai_next) {
+		sock = socket(a->ai_family, a->ai_socktype, cfg_server_proto);
+		if (sock < 0) {
+			perror("socket");
+			continue;
+		}
+
+		if (-1 == setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one,
+				     sizeof(one)))
+			perror("setsockopt");
+
+		if (bind(sock, a->ai_addr, a->ai_addrlen) == 0)
+			break; /* success */
+
+		perror("bind");
+		close(sock);
+		sock = -1;
+	}
+
+	if (sock >= 0 && listen(sock, 20))
+		perror("listen");
+
+	freeaddrinfo(addr);
+	return sock;
+}
+
+static int sock_connect_mptcp(const char * const remoteaddr,
+			      const char * const port, int proto)
+{
+	struct addrinfo hints = {
+		.ai_protocol = IPPROTO_TCP,
+		.ai_socktype = SOCK_STREAM,
+	};
+	struct addrinfo *a, *addr;
+	int sock = -1;
+
+	hints.ai_family = AF_INET;
+
+	xgetaddrinfo(remoteaddr, port, &hints, &addr);
+	for (a = addr; a; a = a->ai_next) {
+		sock = socket(a->ai_family, a->ai_socktype, proto);
+		if (sock < 0) {
+			perror("socket");
+			continue;
+		}
+
+		if (connect(sock, a->ai_addr, a->ai_addrlen) == 0)
+			break; /* success */
+
+		perror("connect()");
+		close(sock);
+		sock = -1;
+	}
+
+	freeaddrinfo(addr);
+	return sock;
+}
+
+static size_t do_write(const int fd, char *buf, const size_t len)
+{
+	size_t offset = 0;
+
+	while (offset < len) {
+		unsigned int do_w;
+		size_t written;
+		ssize_t bw;
+
+		do_w = rand() & 0xffff;
+		if (do_w == 0 || do_w > (len - offset))
+			do_w = len - offset;
+
+		bw = write(fd, buf + offset, do_w);
+		if (bw < 0) {
+			perror("write");
+			return 0;
+		}
+
+		written = (size_t)bw;
+		offset += written;
+	}
+	return offset;
+}
+
+static void copyfd_io(int peerfd)
+{
+	struct pollfd fds = { .events = POLLIN };
+
+	fds.fd = peerfd;
+
+	for (;;) {
+		char buf[4096];
+		ssize_t len;
+
+		switch (poll(&fds, 1, -1)) {
+		case -1:
+			if (errno == EINTR)
+				continue;
+			perror("poll");
+			return;
+		case 0:
+			/* should not happen, we requested infinite wait */
+			fputs("Timed out?!", stderr);
+			return;
+		}
+
+		if ((fds.revents & POLLIN) == 0)
+			return;
+
+		len = read(peerfd, buf, sizeof(buf));
+		if (!len)
+			return;
+		if (len < 0) {
+			if (errno == EINTR)
+				continue;
+
+			perror("read");
+			return;
+		}
+
+		if (!do_write(peerfd, buf, len))
+			return;
+	}
+}
+
+int main_loop_s(int listensock)
+{
+	struct sockaddr_storage ss;
+	socklen_t salen;
+	int remotesock;
+
+	salen = sizeof(ss);
+	while ((remotesock = accept(listensock, (struct sockaddr *)&ss,
+				    &salen)) < 0)
+		perror("accept");
+
+	copyfd_io(remotesock);
+	close(remotesock);
+
+	return 0;
+}
+
+static void init_rng(void)
+{
+	int fd = open("/dev/urandom", O_RDONLY);
+	unsigned int foo;
+
+	if (fd > 0) {
+		read(fd, &foo, sizeof(foo));
+		close(fd);
+	}
+
+	srand(foo);
+}
+
+int main_loop(void)
+{
+	int pollfds = 2, timeout = -1;
+	char start[32];
+	int pipefd[2];
+	ssize_t ret;
+	int fd;
+
+	if (pipe(pipefd)) {
+		perror("pipe");
+		exit(1);
+	}
+
+	switch (fork()) {
+	case 0:
+		close(pipefd[0]);
+
+		init_rng();
+
+		fd = sock_listen_mptcp(NULL, cfg_port);
+		if (fd < 0)
+			return -1;
+
+		write(pipefd[1], "RDY\n", 4);
+		main_loop_s(fd);
+		exit(1);
+	case -1:
+		perror("fork");
+		return -1;
+	default:
+		close(pipefd[1]);
+		break;
+	}
+
+	init_rng();
+	ret = read(pipefd[0], start, (int)sizeof(start));
+	if (ret < 0) {
+		perror("read");
+		return -1;
+	}
+
+	if (ret != 4 || strcmp(start, "RDY\n"))
+		return -1;
+
+	/* listener is ready. */
+	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_client_proto);
+	if (fd < 0)
+		return -1;
+
+	for (;;) {
+		struct pollfd fds[2];
+		char buf[4096];
+		ssize_t len;
+
+		fds[0].fd = fd;
+		fds[0].events = POLLIN;
+		fds[1].fd = 0;
+		fds[1].events = POLLIN;
+		fds[1].revents = 0;
+
+		switch (poll(fds, pollfds, timeout)) {
+		case -1:
+			if (errno == EINTR)
+				continue;
+			perror("poll");
+			return -1;
+		case 0:
+			close(fd);
+			return 0;
+		}
+
+		if (fds[0].revents & POLLIN) {
+			unsigned int blen = rand();
+
+			blen %= sizeof(buf);
+
+			++blen;
+			len = read(fd, buf, blen);
+			if (len < 0) {
+				perror("read");
+				return -1;
+			}
+
+			if (len > blen) {
+				fprintf(stderr, "read returned more data than "
+						"buffer length\n");
+				len = blen;
+			}
+
+			write(1, buf, len);
+		}
+		if (fds[1].revents & POLLIN) {
+			len = read(0, buf, sizeof(buf));
+			if (len == 0) {
+				pollfds = 1;
+				timeout = 1000;
+				continue;
+			}
+
+			if (len < 0) {
+				perror("read");
+				break;
+			}
+
+			do_write(fd, buf, len);
+		}
+	}
+
+	return 1;
+}
+
+int parse_proto(const char *proto)
+{
+	if (!strcasecmp(proto, "MPTCP"))
+		return IPPROTO_MPTCP;
+	if (!strcasecmp(proto, "TCP"))
+		return IPPROTO_TCP;
+	die_usage();
+
+	/* silence compiler warning */
+	return 0;
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "c:p:s:h")) != -1) {
+		switch (c) {
+		case 'c':
+			cfg_client_proto = parse_proto(optarg);
+			break;
+		case 'p':
+			cfg_port = optarg;
+			break;
+		case 's':
+			cfg_server_proto = parse_proto(optarg);
+			break;
+		case 'h':
+			die_usage();
+			break;
+		}
+	}
+
+	if (optind + 1 != argc)
+		die_usage();
+	cfg_host = argv[optind];
+}
+
+int main(int argc, char *argv[])
+{
+	init_rng();
+
+	parse_opts(argc, argv);
+	return main_loop();
+}
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
new file mode 100755
index 000000000000..efcdda84b62a
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -0,0 +1,48 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+tmpin=$(mktemp)
+tmpout=$(mktemp)
+
+cleanup()
+{
+	rm -f "$tmpin" "$tmpout"
+}
+
+check_transfer()
+{
+	cl_proto=${1}
+	srv_proto=${2}
+
+	printf "%-8s -> %-8s socket\t\t" ${cl_proto} ${srv_proto}
+
+	./mptcp_connect -c ${cl_proto} -p 43212 -s ${srv_proto} 127.0.0.1  < "$tmpin" > "$tmpout" 2>/dev/null
+	ret=$?
+	if [ ${ret} -ne 0 ]; then
+		echo "[ FAIL ]"
+		echo " exit code ${ret}"
+		return ${ret}
+	fi
+	cmp "$tmpin" "$tmpout" > /dev/null 2>&1
+	if [ $? -ne 0 ]; then
+		echo "[ FAIL ]"
+		ls -l "$tmpin" "$tmpout" 1>&2
+	else
+		echo "[  OK  ]"
+	fi
+}
+
+trap cleanup EXIT
+
+SIZE=$((RANDOM % (1024 * 1024)))
+if [ $SIZE -eq 0 ]; then
+	SIZE=1
+fi
+
+dd if=/dev/urandom of="$tmpin" bs=1 count=$SIZE 2> /dev/null
+
+check_transfer MPTCP MPTCP
+check_transfer MPTCP TCP
+check_transfer TCP MPTCP
+
+exit 0
-- 
2.22.0

