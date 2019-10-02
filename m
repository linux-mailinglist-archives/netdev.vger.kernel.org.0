Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96232C94F1
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbfJBXhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:47 -0400
Received: from mga04.intel.com ([192.55.52.120]:16479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729157AbfJBXhk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862626"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Florian Westphal <fw@strlen.de>, cpaasch@apple.com,
        pabeni@redhat.com, peter.krystad@linux.intel.com,
        dcaratti@redhat.com, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [RFC PATCH v2 31/45] mptcp: add basic kselftest for mptcp
Date:   Wed,  2 Oct 2019 16:36:41 -0700
Message-Id: <20191002233655.24323-32-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add mpcp_connect tool:
xmit two files back and forth between two processes.
Wrapper script tests that data was transmitted without corruption.

The "-c" command line option for mptcp_connect.sh is there for debugging:

The script will use tcpdump to create one .pcap file per test case, named
according to the namespaces, protocols, and connect address in use.
For example, the first test case writes the capture to
ns1-ns1-MPTCP-MPTCP-10.0.1.1.pcap.

The stderr output from tcpdump is printed after the test completes to
show tcpdump's "packets dropped by kernel" information.

Also check that userspace can't create MPTCP sockets when mptcp.enabled
sysctl is off.

Will run automatically on "make kselftest".

This patch merged following enhancements:
From Mat Martineau:
* mptcp: selftests: Add capture option
From Matthieu Baerts: Add sysctl test
From Paolo Abeni: Use tc/ethtool to test more skb handling code paths

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/net/mptcp/.gitignore  |   2 +
 tools/testing/selftests/net/mptcp/Makefile    |  11 +
 tools/testing/selftests/net/mptcp/config      |   1 +
 .../selftests/net/mptcp/mptcp_connect.c       | 408 ++++++++++++++++++
 .../selftests/net/mptcp/mptcp_connect.sh      | 295 +++++++++++++
 6 files changed, 718 insertions(+)
 create mode 100644 tools/testing/selftests/net/mptcp/.gitignore
 create mode 100644 tools/testing/selftests/net/mptcp/Makefile
 create mode 100644 tools/testing/selftests/net/mptcp/config
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_connect.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect.sh

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index c3feccb99ff5..4a404ee1b980 100644
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
index 000000000000..d72f07642738
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/.gitignore
@@ -0,0 +1,2 @@
+mptcp_connect
+*.pcap
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
index 000000000000..cac71f0ac8f8
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -0,0 +1,408 @@
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
+static bool listen_mode;
+static int  poll_timeout;
+
+static const char *cfg_host;
+static const char *cfg_port	= "12000";
+static int cfg_sock_proto	= IPPROTO_MPTCP;
+
+
+static void die_usage(void)
+{
+	fprintf(stderr, "Usage: mptcp_connect [-s MPTCP|TCP] [-p port] "
+		"[ -l ] [ -t timeout ] connect_address\n");
+	exit(1);
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
+		sock = socket(a->ai_family, a->ai_socktype, cfg_sock_proto);
+		if (sock < 0)
+			continue;
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
+	freeaddrinfo(addr);
+
+	if (sock < 0) {
+		fprintf(stderr, "Could not create listen socket\n");
+		return sock;
+	}
+
+	if (listen(sock, 20)) {
+		perror("listen");
+		close(sock);
+		return -1;
+	}
+
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
+static size_t do_rnd_write(const int fd, char *buf, const size_t len)
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
+static size_t do_write(const int fd, char *buf, const size_t len)
+{
+	size_t offset = 0;
+
+	while (offset < len) {
+		size_t written;
+		ssize_t bw;
+
+		bw = write(fd, buf + offset, len - offset);
+		if (bw < 0) {
+			perror("write");
+			return 0;
+		}
+
+		written = (size_t)bw;
+		offset += written;
+	}
+
+	return offset;
+}
+
+static ssize_t do_rnd_read(const int fd, char *buf, const size_t len)
+{
+	size_t cap = rand();
+
+	cap &= 0xffff;
+
+	if (cap == 0)
+		cap = 1;
+	else if (cap > len)
+		cap = len;
+
+	return read(fd, buf, cap);
+}
+
+static int copyfd_io(int infd, int peerfd, int outfd)
+{
+	struct pollfd fds = {
+		.fd = peerfd,
+		.events = POLLIN | POLLOUT,
+	};
+
+	for (;;) {
+		char buf[8192];
+		ssize_t len;
+
+		if (fds.events == 0)
+			break;
+
+		switch (poll(&fds, 1, poll_timeout)) {
+		case -1:
+			if (errno == EINTR)
+				continue;
+			perror("poll");
+			return 1;
+		case 0:
+			fprintf(stderr, "%s: poll timed out (events: "
+				"POLLIN %u, POLLOUT %u)\n", __func__,
+				fds.events & POLLIN, fds.events & POLLOUT);
+			return 2;
+		}
+
+		if (fds.revents & POLLIN) {
+			len = do_rnd_read(peerfd, buf, sizeof(buf));
+			if (len == 0) {
+				/* no more data to receive:
+				 * peer has closed its write side
+				 */
+				fds.events &= ~POLLIN;
+
+				if ((fds.events & POLLOUT) == 0)
+					/* and nothing more to send */
+					break;
+
+			/* Else, still have data to transmit */
+			} else if (len < 0) {
+				perror("read");
+				return 3;
+			}
+
+			do_write(outfd, buf, len);
+		}
+
+		if (fds.revents & POLLOUT) {
+			len = do_rnd_read(infd, buf, sizeof(buf));
+			if (len > 0) {
+				if (!do_rnd_write(peerfd, buf, len))
+					return 111;
+			} else if (len == 0) {
+				/* We have no more data to send. */
+				fds.events &= ~POLLOUT;
+
+				if ((fds.events & POLLIN) == 0)
+					/* ... and peer also closed already */
+					break;
+
+				/* ... but we still receive.
+				 * Close our write side.
+				 */
+				shutdown(peerfd, SHUT_WR);
+			} else {
+				if (errno == EINTR)
+					continue;
+				perror("read");
+				return 4;
+			}
+		}
+	}
+
+	close(peerfd);
+	return 0;
+}
+
+int main_loop_s(int listensock)
+{
+	struct sockaddr_storage ss;
+	struct pollfd polls;
+	socklen_t salen;
+	int remotesock;
+
+	polls.fd = listensock;
+	polls.events = POLLIN;
+
+	switch (poll(&polls, 1, poll_timeout)) {
+	case -1:
+		perror("poll");
+		return 1;
+	case 0:
+		fprintf(stderr, "%s: timed out\n", __func__);
+		close(listensock);
+		return 2;
+	}
+
+	salen = sizeof(ss);
+	remotesock = accept(listensock, (struct sockaddr *)&ss, &salen);
+	if (remotesock >= 0) {
+		copyfd_io(0, remotesock, 1);
+		return 0;
+	}
+
+	perror("accept");
+
+	return 1;
+}
+
+static void init_rng(void)
+{
+	int fd = open("/dev/urandom", O_RDONLY);
+	unsigned int foo;
+
+	if (fd > 0) {
+		int ret = read(fd, &foo, sizeof(foo));
+
+		if (ret < 0)
+			srand(fd + foo);
+		close(fd);
+	}
+
+	srand(foo);
+}
+
+int main_loop(void)
+{
+	int fd;
+
+	/* listener is ready. */
+	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_sock_proto);
+	if (fd < 0)
+		return 2;
+
+	return copyfd_io(0, fd, 1);
+}
+
+int parse_proto(const char *proto)
+{
+	if (!strcasecmp(proto, "MPTCP"))
+		return IPPROTO_MPTCP;
+	if (!strcasecmp(proto, "TCP"))
+		return IPPROTO_TCP;
+
+	fprintf(stderr, "Unknown protocol: %s.", proto);
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
+	while ((c = getopt(argc, argv, "lp:s:ht:")) != -1) {
+		switch (c) {
+		case 'l':
+			listen_mode = true;
+			break;
+		case 'p':
+			cfg_port = optarg;
+			break;
+		case 's':
+			cfg_sock_proto = parse_proto(optarg);
+			break;
+		case 'h':
+			die_usage();
+			break;
+		case 't':
+			poll_timeout = atoi(optarg) * 1000;
+			if (poll_timeout <= 0)
+				poll_timeout = -1;
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
+
+	if (listen_mode) {
+		int fd = sock_listen_mptcp(cfg_host, cfg_port);
+
+		if (fd < 0)
+			return 1;
+
+		return main_loop_s(fd);
+	}
+
+	return main_loop();
+}
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
new file mode 100755
index 000000000000..d029bdc5946d
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -0,0 +1,295 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ret=0
+sin=""
+sout=""
+cin=""
+cout=""
+ksft_skip=4
+capture=0
+timeout=30
+
+TEST_COUNT=0
+
+cleanup()
+{
+	rm -f "$cin" "$cout"
+	rm -f "$sin" "$sout"
+	rm -f "$capout"
+
+	for i in 1 2 3 4; do
+		ip netns del ns$i
+	done
+}
+
+for arg in "$@"; do
+    if [ "$arg" = "-c" ]; then
+	capture=1
+    fi
+done
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+sin=$(mktemp)
+sout=$(mktemp)
+cin=$(mktemp)
+cout=$(mktemp)
+capout=$(mktemp)
+trap cleanup EXIT
+
+for i in 1 2 3 4;do
+	ip netns add ns$i || exit $ksft_skip
+	ip -net ns$i link set lo up
+	ip netns exec ns$i sysctl -q net.mptcp.enabled=1
+done
+
+#  ns1              ns2                    ns3                     ns4
+# ns1eth2    ns2eth1   ns2eth3      ns3eth2   ns3eth4       ns4eth3
+#                           - drop 1% ->            reorder 25%
+#                           <- TSO off -
+
+ip link add ns1eth2 netns ns1 type veth peer name ns2eth1 netns ns2
+ip link add ns2eth3 netns ns2 type veth peer name ns3eth2 netns ns3
+ip link add ns3eth4 netns ns3 type veth peer name ns4eth3 netns ns4
+
+ip -net ns1 addr add 10.0.1.1/24 dev ns1eth2
+ip -net ns1 link set ns1eth2 up
+ip -net ns1 route add default via 10.0.1.2
+
+ip -net ns2 addr add 10.0.1.2/24 dev ns2eth1
+ip -net ns2 link set ns2eth1 up
+
+ip -net ns2 addr add 10.0.2.1/24 dev ns2eth3
+ip -net ns2 link set ns2eth3 up
+ip -net ns2 route add default via 10.0.2.2
+ip netns exec ns2 sysctl -q net.ipv4.ip_forward=1
+
+ip -net ns3 addr add 10.0.2.2/24 dev ns3eth2
+ip -net ns3 link set ns3eth2 up
+
+ip -net ns3 addr add 10.0.3.2/24 dev ns3eth4
+ip -net ns3 link set ns3eth4 up
+ip -net ns3 route add default via 10.0.2.1
+ip netns exec ns3 ethtool -K ns3eth2 tso off 2>/dev/null
+ip netns exec ns3 sysctl -q net.ipv4.ip_forward=1
+
+ip -net ns4 addr add 10.0.3.1/24 dev ns4eth3
+ip -net ns4 link set ns4eth3 up
+ip -net ns4 route add default via 10.0.3.2
+
+print_file_err()
+{
+	ls -l "$1" 1>&2
+	echo "Trailing bytes are: "
+	tail -c 27 "$1"
+}
+
+check_transfer()
+{
+	in=$1
+	out=$2
+	what=$3
+
+	cmp "$in" "$out" > /dev/null 2>&1
+	if [ $? -ne 0 ] ;then
+		echo "[ FAIL ] $what does not match (in, out):"
+		print_file_err "$in"
+		print_file_err "$out"
+
+		return 1
+	fi
+
+	return 0
+}
+
+check_mptcp_disabled()
+{
+	disabled_ns="ns_disabled"
+	ip netns add ${disabled_ns} || exit $ksft_skip
+	# by default: sysctl net.mptcp.enabled=0
+
+	local err=0
+	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
+		grep -q "^socket: Protocol not available$" && err=1
+	ip netns delete ${disabled_ns}
+
+	if [ ${err} -eq 0 ]; then
+		echo -e "MPTCP is not disabled by default as expected\t[ FAIL ]"
+		ret=1
+		return 1
+	fi
+
+	echo -e "MPTCP is disabled by default as expected\t[ OK ]"
+	return 0
+}
+
+do_ping()
+{
+	listener_ns="$1"
+	connector_ns="$2"
+	connect_addr="$3"
+
+	ip netns exec ${connector_ns} ping -q -c 1 $connect_addr >/dev/null
+	if [ $? -ne 0 ] ; then
+		echo "$listener_ns -> $connect_addr connectivity [ FAIL ]" 1>&2
+		ret=1
+	fi
+}
+
+do_transfer()
+{
+	listener_ns="$1"
+	connector_ns="$2"
+	cl_proto="$3"
+	srv_proto="$4"
+	connect_addr="$5"
+
+	port=$((10000+$TEST_COUNT))
+	TEST_COUNT=$((TEST_COUNT+1))
+
+	:> "$cout"
+	:> "$sout"
+	:> "$capout"
+
+	printf "%-4s %-5s -> %-4s (%s:%d) %-5s\t" ${connector_ns} ${cl_proto} ${listener_ns} ${connect_addr} ${port} ${srv_proto}
+
+	if [ $capture -eq 1 ]; then
+	    if [ -z $SUDO_USER ] ; then
+		capuser=""
+	    else
+		capuser="-Z $SUDO_USER"
+	    fi
+
+	    capfile="${listener_ns}-${connector_ns}-${cl_proto}-${srv_proto}-${connect_addr}.pcap"
+
+	    ip netns exec ${listener_ns} tcpdump -i any -s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
+	    cappid=$!
+
+	    sleep 1
+	fi
+
+	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
+	spid=$!
+
+	sleep 1
+
+	ip netns exec ${connector_ns} ./mptcp_connect -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
+	cpid=$!
+
+	wait $cpid
+	retc=$?
+	wait $spid
+	rets=$?
+
+	if [ $capture -eq 1 ]; then
+	    sleep 1
+	    kill $cappid
+	fi
+
+	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
+		echo "[ FAIL ] client exit code $retc, server $rets" 1>&2
+		echo "\nnetns ${listener_ns} socket stat for $port:" 1>&2
+		ip netns exec ${listener_ns} ss -nita 1>&2 -o "sport = :$port"
+		echo "\nnetns ${connector_ns} socket stat for $port:" 1>&2
+		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
+
+		cat "$capout"
+		return 1
+	fi
+
+	check_transfer $sin $cout "file received by client"
+	retc=$?
+	check_transfer $cin $sout "file received by server"
+	rets=$?
+
+	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
+		echo "[ OK ]"
+		cat "$capout"
+		return 0
+	fi
+
+	cat "$capout"
+	return 1
+}
+
+make_file()
+{
+	name=$1
+	who=$2
+
+	SIZE=$((RANDOM % (1024 * 8)))
+	TSIZE=$((SIZE * 1024))
+
+	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+
+	SIZE=$((RANDOM % 1024))
+	SIZE=$((SIZE + 128))
+	TSIZE=$((TSIZE + SIZE))
+	dd if=/dev/urandom conf=notrunc of="$name" bs=1 count=$SIZE 2> /dev/null
+	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
+
+	echo "Created $name (size $TSIZE) containing data sent by $who"
+}
+
+run_tests()
+{
+	listener_ns="$1"
+	connector_ns="$2"
+	connect_addr="$3"
+	lret=0
+
+	for proto in MPTCP TCP;do
+		do_transfer ${listener_ns} ${connector_ns} MPTCP "$proto" ${connect_addr}
+		lret=$?
+		if [ $lret -ne 0 ]; then
+			ret=$lret
+			return
+		fi
+	done
+
+	do_transfer ${listener_ns} ${connector_ns} TCP MPTCP ${connect_addr}
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		ret=$lret
+		return
+	fi
+}
+
+make_file "$cin" "client"
+make_file "$sin" "server"
+
+check_mptcp_disabled
+
+for sender in 1 2 3 4;do
+	do_ping ns1 ns$sender 10.0.1.1
+
+	do_ping ns2 ns$sender 10.0.1.2
+	do_ping ns2 ns$sender 10.0.2.1
+
+	do_ping ns3 ns$sender 10.0.2.2
+	do_ping ns3 ns$sender 10.0.3.2
+
+	do_ping ns4 ns$sender 10.0.3.1
+done
+
+tc -net ns2 qdisc add dev ns2eth3 root netem loss random 1
+tc -net ns3 qdisc add dev ns3eth4 root netem delay 10ms reorder 25% 50% gap 5
+
+for sender in 1 2 3 4;do
+	run_tests ns1 ns$sender 10.0.1.1
+
+	run_tests ns2 ns$sender 10.0.1.2
+	run_tests ns2 ns$sender 10.0.2.1
+
+	run_tests ns3 ns$sender 10.0.2.2
+	run_tests ns3 ns$sender 10.0.3.2
+
+	run_tests ns4 ns$sender 10.0.3.1
+done
+
+exit $ret
-- 
2.23.0

