Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D94DC125261
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 20:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727630AbfLRTz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 14:55:27 -0500
Received: from mga05.intel.com ([192.55.52.43]:2229 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727577AbfLRTzT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 14:55:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 11:55:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="213019975"
Received: from mjmartin-nuc01.amr.corp.intel.com ([10.241.98.42])
  by fmsmga008.fm.intel.com with ESMTP; 18 Dec 2019 11:55:17 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, mptcp@lists.01.org
Cc:     Florian Westphal <fw@strlen.de>, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Davide Caratti <dcaratti@redhat.com>
Subject: [PATCH net-next v2 15/15] mptcp: add basic kselftest for mptcp
Date:   Wed, 18 Dec 2019 11:55:10 -0800
Message-Id: <20191218195510.7782-16-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
References: <20191218195510.7782-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Add mptcp_connect tool:
xmit two files back and forth between two processes, several net
namespaces including some adding delays, losses and reordering.
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

The "-b" option allows to tune/lower send buffer size.
"-m mmap" can be used to test blocking io.  Default is non-blocking
io using read/write/poll.

Will run automatically on "make kselftest".

Note that the default timeout of 45 seconds is used even if there is a
"settings" changing it to 450. 45 seconds should be enough in most cases
but this depends on the machine running the tests.

A fix to correctly read the "settings" file has been proposed upstream
but not applied yet. It is not blocking the execution of these new tests
but it would be nice to have it:

  https://patchwork.kernel.org/patch/11204935/

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Co-developed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Co-developed-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 MAINTAINERS                                   |   1 +
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/net/mptcp/.gitignore  |   2 +
 tools/testing/selftests/net/mptcp/Makefile    |  13 +
 tools/testing/selftests/net/mptcp/config      |   2 +
 .../selftests/net/mptcp/mptcp_connect.c       | 832 ++++++++++++++++++
 .../selftests/net/mptcp/mptcp_connect.sh      | 595 +++++++++++++
 tools/testing/selftests/net/mptcp/settings    |   1 +
 8 files changed, 1447 insertions(+)
 create mode 100644 tools/testing/selftests/net/mptcp/.gitignore
 create mode 100644 tools/testing/selftests/net/mptcp/Makefile
 create mode 100644 tools/testing/selftests/net/mptcp/config
 create mode 100644 tools/testing/selftests/net/mptcp/mptcp_connect.c
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect.sh
 create mode 100644 tools/testing/selftests/net/mptcp/settings

diff --git a/MAINTAINERS b/MAINTAINERS
index b11e234dc833..97d3683b92d7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11578,6 +11578,7 @@ B:	https://github.com/multipath-tcp/mptcp_net-next/issues
 S:	Maintained
 F:	include/net/mptcp.h
 F:	net/mptcp/
+F:	tools/testing/selftests/net/mptcp/
 
 NETWORKING [TCP]
 M:	Eric Dumazet <edumazet@google.com>
diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index b001c602414b..b45a8f77ee24 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -32,6 +32,7 @@ TARGETS += memory-hotplug
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
index 000000000000..93de52016dde
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -0,0 +1,13 @@
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
+EXTRA_CLEAN := *.pcap
+
+include ../../lib.mk
diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
new file mode 100644
index 000000000000..463f0514577d
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/config
@@ -0,0 +1,2 @@
+CONFIG_MPTCP=y
+CONFIG_MPTCP_IPV6=y
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
new file mode 100644
index 000000000000..a3dccd816ae4
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -0,0 +1,832 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <limits.h>
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
+#include <sys/sendfile.h>
+#include <sys/stat.h>
+#include <sys/socket.h>
+#include <sys/types.h>
+#include <sys/mman.h>
+
+#include <netdb.h>
+#include <netinet/in.h>
+
+#include <linux/tcp.h>
+
+extern int optind;
+
+#ifndef IPPROTO_MPTCP
+#define IPPROTO_MPTCP 262
+#endif
+#ifndef TCP_ULP
+#define TCP_ULP 31
+#endif
+
+static bool listen_mode;
+static int  poll_timeout;
+
+enum cfg_mode {
+	CFG_MODE_POLL,
+	CFG_MODE_MMAP,
+	CFG_MODE_SENDFILE,
+};
+
+static enum cfg_mode cfg_mode = CFG_MODE_POLL;
+static const char *cfg_host;
+static const char *cfg_port	= "12000";
+static int cfg_sock_proto	= IPPROTO_MPTCP;
+static bool tcpulp_audit;
+static int pf = AF_INET;
+static int cfg_sndbuf;
+
+static void die_usage(void)
+{
+	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] -m mode]"
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
+static void xgetnameinfo(const struct sockaddr *addr, socklen_t addrlen,
+			 char *host, socklen_t hostlen,
+			 char *serv, socklen_t servlen)
+{
+	int flags = NI_NUMERICHOST | NI_NUMERICSERV;
+	int err = getnameinfo(addr, addrlen, host, hostlen, serv, servlen,
+			      flags);
+
+	if (err) {
+		const char *errstr = getxinfo_strerr(err);
+
+		fprintf(stderr, "Fatal: getnameinfo: %s\n", errstr);
+		exit(1);
+	}
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
+static void set_sndbuf(int fd, unsigned int size)
+{
+	int err;
+
+	err = setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &size, sizeof(size));
+	if (err) {
+		perror("set SO_SNDBUF");
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
+	hints.ai_family = pf;
+
+	struct addrinfo *a, *addr;
+	int one = 1;
+
+	xgetaddrinfo(listenaddr, port, &hints, &addr);
+	hints.ai_family = pf;
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
+static bool sock_test_tcpulp(const char * const remoteaddr,
+			     const char * const port)
+{
+	struct addrinfo hints = {
+		.ai_protocol = IPPROTO_TCP,
+		.ai_socktype = SOCK_STREAM,
+	};
+	struct addrinfo *a, *addr;
+	int sock = -1, ret = 0;
+	bool test_pass = false;
+
+	hints.ai_family = AF_INET;
+
+	xgetaddrinfo(remoteaddr, port, &hints, &addr);
+	for (a = addr; a; a = a->ai_next) {
+		sock = socket(a->ai_family, a->ai_socktype, IPPROTO_TCP);
+		if (sock < 0) {
+			perror("socket");
+			continue;
+		}
+		ret = setsockopt(sock, IPPROTO_TCP, TCP_ULP, "mptcp",
+				 sizeof("mptcp"));
+		if (ret == -1 && errno == EOPNOTSUPP)
+			test_pass = true;
+		close(sock);
+
+		if (test_pass)
+			break;
+		if (!ret)
+			fprintf(stderr,
+				"setsockopt(TCP_ULP) returned 0\n");
+		else
+			perror("setsockopt(TCP_ULP)");
+	}
+	return test_pass;
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
+	hints.ai_family = pf;
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
+	unsigned int do_w;
+	ssize_t bw;
+
+	do_w = rand() & 0xffff;
+	if (do_w == 0 || do_w > len)
+		do_w = len;
+
+	bw = write(fd, buf, do_w);
+	if (bw < 0)
+		perror("write");
+
+	return bw;
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
+static void set_nonblock(int fd)
+{
+	int flags = fcntl(fd, F_GETFL);
+
+	if (flags == -1)
+		return;
+
+	fcntl(fd, F_SETFL, flags | O_NONBLOCK);
+}
+
+static int copyfd_io_poll(int infd, int peerfd, int outfd)
+{
+	struct pollfd fds = {
+		.fd = peerfd,
+		.events = POLLIN | POLLOUT,
+	};
+	unsigned int woff = 0, wlen = 0;
+	char wbuf[8192];
+
+	set_nonblock(peerfd);
+
+	for (;;) {
+		char rbuf[8192];
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
+			len = do_rnd_read(peerfd, rbuf, sizeof(rbuf));
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
+			do_write(outfd, rbuf, len);
+		}
+
+		if (fds.revents & POLLOUT) {
+			if (wlen == 0) {
+				woff = 0;
+				wlen = read(infd, wbuf, sizeof(wbuf));
+			}
+
+			if (wlen > 0) {
+				ssize_t bw;
+
+				bw = do_rnd_write(peerfd, wbuf + woff, wlen);
+				if (bw < 0)
+					return 111;
+
+				woff += bw;
+				wlen -= bw;
+			} else if (wlen == 0) {
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
+
+		if (fds.revents & (POLLERR | POLLNVAL)) {
+			fprintf(stderr, "Unexpected revents: "
+				"POLLERR/POLLNVAL(%x)\n", fds.revents);
+			return 5;
+		}
+	}
+
+	close(peerfd);
+	return 0;
+}
+
+static int do_recvfile(int infd, int outfd)
+{
+	ssize_t r;
+
+	do {
+		char buf[16384];
+
+		r = do_rnd_read(infd, buf, sizeof(buf));
+		if (r > 0) {
+			if (write(outfd, buf, r) != r)
+				break;
+		} else if (r < 0) {
+			perror("read");
+		}
+	} while (r > 0);
+
+	return (int)r;
+}
+
+static int do_mmap(int infd, int outfd, unsigned int size)
+{
+	char *inbuf = mmap(NULL, size, PROT_READ, MAP_SHARED, infd, 0);
+	ssize_t ret = 0, off = 0;
+	size_t rem;
+
+	if (inbuf == MAP_FAILED) {
+		perror("mmap");
+		return 1;
+	}
+
+	rem = size;
+
+	while (rem > 0) {
+		ret = write(outfd, inbuf + off, rem);
+
+		if (ret < 0) {
+			perror("write");
+			break;
+		}
+
+		off += ret;
+		rem -= ret;
+	}
+
+	munmap(inbuf, size);
+	return rem;
+}
+
+static int get_infd_size(int fd)
+{
+	struct stat sb;
+	ssize_t count;
+	int err;
+
+	err = fstat(fd, &sb);
+	if (err < 0) {
+		perror("fstat");
+		return -1;
+	}
+
+	if ((sb.st_mode & S_IFMT) != S_IFREG) {
+		fprintf(stderr, "%s: stdin is not a regular file\n", __func__);
+		return -2;
+	}
+
+	count = sb.st_size;
+	if (count > INT_MAX) {
+		fprintf(stderr, "File too large: %zu\n", count);
+		return -3;
+	}
+
+	return (int)count;
+}
+
+static int do_sendfile(int infd, int outfd, unsigned int count)
+{
+	while (count > 0) {
+		ssize_t r;
+
+		r = sendfile(outfd, infd, NULL, count);
+		if (r < 0) {
+			perror("sendfile");
+			return 3;
+		}
+
+		count -= r;
+	}
+
+	return 0;
+}
+
+static int copyfd_io_mmap(int infd, int peerfd, int outfd,
+			  unsigned int size)
+{
+	int err;
+
+	if (listen_mode) {
+		err = do_recvfile(peerfd, outfd);
+		if (err)
+			return err;
+
+		err = do_mmap(infd, peerfd, size);
+	} else {
+		err = do_mmap(infd, peerfd, size);
+		if (err)
+			return err;
+
+		shutdown(peerfd, SHUT_WR);
+
+		err = do_recvfile(peerfd, outfd);
+	}
+
+	return err;
+}
+
+static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
+			      unsigned int size)
+{
+	int err;
+
+	if (listen_mode) {
+		err = do_recvfile(peerfd, outfd);
+		if (err)
+			return err;
+
+		err = do_sendfile(infd, peerfd, size);
+	} else {
+		err = do_sendfile(infd, peerfd, size);
+		if (err)
+			return err;
+		err = do_recvfile(peerfd, outfd);
+	}
+
+	return err;
+}
+
+static int copyfd_io(int infd, int peerfd, int outfd)
+{
+	int file_size;
+
+	switch (cfg_mode) {
+	case CFG_MODE_POLL:
+		return copyfd_io_poll(infd, peerfd, outfd);
+	case CFG_MODE_MMAP:
+		file_size = get_infd_size(infd);
+		if (file_size < 0)
+			return file_size;
+		return copyfd_io_mmap(infd, peerfd, outfd, file_size);
+	case CFG_MODE_SENDFILE:
+		file_size = get_infd_size(infd);
+		if (file_size < 0)
+			return file_size;
+		return copyfd_io_sendfile(infd, peerfd, outfd, file_size);
+	}
+
+	fprintf(stderr, "Invalid mode %d\n", cfg_mode);
+
+	die_usage();
+	return 1;
+}
+
+static void check_sockaddr(int pf, struct sockaddr_storage *ss,
+			   socklen_t salen)
+{
+	struct sockaddr_in6 *sin6;
+	struct sockaddr_in *sin;
+	socklen_t wanted_size = 0;
+
+	switch (pf) {
+	case AF_INET:
+		wanted_size = sizeof(*sin);
+		sin = (void *)ss;
+		if (!sin->sin_port)
+			fprintf(stderr, "accept: something wrong: ip connection from port 0");
+		break;
+	case AF_INET6:
+		wanted_size = sizeof(*sin6);
+		sin6 = (void *)ss;
+		if (!sin6->sin6_port)
+			fprintf(stderr, "accept: something wrong: ipv6 connection from port 0");
+		break;
+	default:
+		fprintf(stderr, "accept: Unknown pf %d, salen %u\n", pf, salen);
+		return;
+	}
+
+	if (salen != wanted_size)
+		fprintf(stderr, "accept: size mismatch, got %d expected %d\n",
+			(int)salen, wanted_size);
+
+	if (ss->ss_family != pf)
+		fprintf(stderr, "accept: pf mismatch, expect %d, ss_family is %d\n",
+			(int)ss->ss_family, pf);
+}
+
+static void check_getpeername(int fd, struct sockaddr_storage *ss, socklen_t salen)
+{
+	struct sockaddr_storage peerss;
+	socklen_t peersalen = sizeof(peerss);
+
+	if (getpeername(fd, (struct sockaddr *)&peerss, &peersalen) < 0) {
+		perror("getpeername");
+		return;
+	}
+
+	if (peersalen != salen) {
+		fprintf(stderr, "%s: %d vs %d\n", __func__, peersalen, salen);
+		return;
+	}
+
+	if (memcmp(ss, &peerss, peersalen)) {
+		char a[INET6_ADDRSTRLEN];
+		char b[INET6_ADDRSTRLEN];
+		char c[INET6_ADDRSTRLEN];
+		char d[INET6_ADDRSTRLEN];
+
+		xgetnameinfo((struct sockaddr *)ss, salen,
+			     a, sizeof(a), b, sizeof(b));
+
+		xgetnameinfo((struct sockaddr *)&peerss, peersalen,
+			     c, sizeof(c), d, sizeof(d));
+
+		fprintf(stderr, "%s: memcmp failure: accept %s vs peername %s, %s vs %s salen %d vs %d\n",
+			__func__, a, c, b, d, peersalen, salen);
+	}
+}
+
+static void check_getpeername_connect(int fd)
+{
+	struct sockaddr_storage ss;
+	socklen_t salen = sizeof(ss);
+	char a[INET6_ADDRSTRLEN];
+	char b[INET6_ADDRSTRLEN];
+
+	if (getpeername(fd, (struct sockaddr *)&ss, &salen) < 0) {
+		perror("getpeername");
+		return;
+	}
+
+	xgetnameinfo((struct sockaddr *)&ss, salen,
+		     a, sizeof(a), b, sizeof(b));
+
+	if (strcmp(cfg_host, a) || strcmp(cfg_port, b))
+		fprintf(stderr, "%s: %s vs %s, %s vs %s\n", __func__,
+			cfg_host, a, cfg_port, b);
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
+		check_sockaddr(pf, &ss, salen);
+		check_getpeername(remotesock, &ss, salen);
+
+		return copyfd_io(0, remotesock, 1);
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
+	check_getpeername_connect(fd);
+
+	if (cfg_sndbuf)
+		set_sndbuf(fd, cfg_sndbuf);
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
+	fprintf(stderr, "Unknown protocol: %s\n.", proto);
+	die_usage();
+
+	/* silence compiler warning */
+	return 0;
+}
+
+int parse_mode(const char *mode)
+{
+	if (!strcasecmp(mode, "poll"))
+		return CFG_MODE_POLL;
+	if (!strcasecmp(mode, "mmap"))
+		return CFG_MODE_MMAP;
+	if (!strcasecmp(mode, "sendfile"))
+		return CFG_MODE_SENDFILE;
+
+	fprintf(stderr, "Unknown test mode: %s\n", mode);
+	fprintf(stderr, "Supported modes are:\n");
+	fprintf(stderr, "\t\t\"poll\" - interleaved read/write using poll()\n");
+	fprintf(stderr, "\t\t\"mmap\" - send entire input file (mmap+write), then read response (-l will read input first)\n");
+	fprintf(stderr, "\t\t\"sendfile\" - send entire input file (sendfile), then read response (-l will read input first)\n");
+
+	die_usage();
+
+	/* silence compiler warning */
+	return 0;
+}
+
+int parse_sndbuf(const char *size)
+{
+	unsigned long s;
+
+	errno = 0;
+
+	s = strtoul(size, NULL, 0);
+
+	if (errno) {
+		fprintf(stderr, "Invalid sndbuf size %s (%s)\n",
+			size, strerror(errno));
+		die_usage();
+	}
+
+	if (s > INT_MAX) {
+		fprintf(stderr, "Invalid sndbuf size %s (%s)\n",
+			size, strerror(ERANGE));
+		die_usage();
+	}
+
+	cfg_sndbuf = s;
+
+	return 0;
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	int c;
+
+	while ((c = getopt(argc, argv, "6lp:s:hut:m:b:")) != -1) {
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
+		case 'u':
+			tcpulp_audit = true;
+			break;
+		case '6':
+			pf = AF_INET6;
+			break;
+		case 't':
+			poll_timeout = atoi(optarg) * 1000;
+			if (poll_timeout <= 0)
+				poll_timeout = -1;
+			break;
+		case 'm':
+			cfg_mode = parse_mode(optarg);
+			break;
+		case 'b':
+			cfg_sndbuf = parse_sndbuf(optarg);
+			break;
+		}
+	}
+
+	if (optind + 1 != argc)
+		die_usage();
+	cfg_host = argv[optind];
+
+	if (strchr(cfg_host, ':'))
+		pf = AF_INET6;
+}
+
+int main(int argc, char *argv[])
+{
+	init_rng();
+
+	parse_opts(argc, argv);
+
+	if (tcpulp_audit)
+		return sock_test_tcpulp(cfg_host, cfg_port) ? 0 : 1;
+
+	if (listen_mode) {
+		int fd = sock_listen_mptcp(cfg_host, cfg_port);
+
+		if (fd < 0)
+			return 1;
+
+		if (cfg_sndbuf)
+			set_sndbuf(fd, cfg_sndbuf);
+
+		return main_loop_s(fd);
+	}
+
+	return main_loop();
+}
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
new file mode 100755
index 000000000000..d573a0feb98d
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -0,0 +1,595 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+time_start=$(date +%s)
+
+optstring="b:d:e:l:r:h4cm:"
+ret=0
+sin=""
+sout=""
+cin=""
+cout=""
+ksft_skip=4
+capture=false
+timeout=30
+ipv6=true
+ethtool_random_on=true
+tc_delay="$((RANDOM%400))"
+tc_loss=$((RANDOM%101))
+tc_reorder=""
+testmode=""
+sndbuf=0
+options_log=true
+
+if [ $tc_loss -eq 100 ];then
+	tc_loss=1%
+elif [ $tc_loss -ge 10 ]; then
+	tc_loss=0.$tc_loss%
+elif [ $tc_loss -ge 1 ]; then
+	tc_loss=0.0$tc_loss%
+else
+	tc_loss=""
+fi
+
+usage() {
+	echo "Usage: $0 [ -a ]"
+	echo -e "\t-d: tc/netem delay in milliseconds, e.g. \"-d 10\" (default random)"
+	echo -e "\t-l: tc/netem loss percentage, e.g. \"-l 0.02\" (default random)"
+	echo -e "\t-r: tc/netem reorder mode, e.g. \"-r 25% 50% gap 5\", use "-r 0" to disable reordering (default random)"
+	echo -e "\t-e: ethtool features to disable, e.g.: \"-e tso -e gso\" (default: randomly disable any of tso/gso/gro)"
+	echo -e "\t-4: IPv4 only: disable IPv6 tests (default: test both IPv4 and IPv6)"
+	echo -e "\t-c: capture packets for each test using tcpdump (default: no capture)"
+	echo -e "\t-b: set sndbuf value (default: use kernel default)"
+	echo -e "\t-m: test mode (poll, sendfile; default: poll)"
+}
+
+while getopts "$optstring" option;do
+	case "$option" in
+	"h")
+		usage $0
+		exit 0
+		;;
+	"d")
+		if [ $OPTARG -ge 0 ];then
+			tc_delay="$OPTARG"
+		else
+			echo "-d requires numeric argument, got \"$OPTARG\"" 1>&2
+			exit 1
+		fi
+		;;
+	"e")
+		ethtool_args="$ethtool_args $OPTARG off"
+		ethtool_random_on=false
+		;;
+	"l")
+		tc_loss="$OPTARG"
+		;;
+	"r")
+		tc_reorder="$OPTARG"
+		;;
+	"4")
+		ipv6=false
+		;;
+	"c")
+		capture=true
+		;;
+	"b")
+		if [ $OPTARG -ge 0 ];then
+			sndbuf="$OPTARG"
+		else
+			echo "-s requires numeric argument, got \"$OPTARG\"" 1>&2
+			exit 1
+		fi
+		;;
+	"m")
+		testmode="$OPTARG"
+		;;
+	"?")
+		usage $0
+		exit 1
+		;;
+	esac
+done
+
+sec=$(date +%s)
+rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
+ns1="ns1-$rndh"
+ns2="ns2-$rndh"
+ns3="ns3-$rndh"
+ns4="ns4-$rndh"
+
+TEST_COUNT=0
+
+cleanup()
+{
+	rm -f "$cin" "$cout"
+	rm -f "$sin" "$sout"
+	rm -f "$capout"
+
+	local netns
+	for netns in "$ns1" "$ns2" "$ns3" "$ns4";do
+		ip netns del $netns
+	done
+}
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
+for i in "$ns1" "$ns2" "$ns3" "$ns4";do
+	ip netns add $i || exit $ksft_skip
+	ip -net $i link set lo up
+done
+
+#  "$ns1"              ns2                    ns3                     ns4
+# ns1eth2    ns2eth1   ns2eth3      ns3eth2   ns3eth4       ns4eth3
+#                           - drop 1% ->            reorder 25%
+#                           <- TSO off -
+
+ip link add ns1eth2 netns "$ns1" type veth peer name ns2eth1 netns "$ns2"
+ip link add ns2eth3 netns "$ns2" type veth peer name ns3eth2 netns "$ns3"
+ip link add ns3eth4 netns "$ns3" type veth peer name ns4eth3 netns "$ns4"
+
+ip -net "$ns1" addr add 10.0.1.1/24 dev ns1eth2
+ip -net "$ns1" addr add dead:beef:1::1/64 dev ns1eth2 nodad
+
+ip -net "$ns1" link set ns1eth2 up
+ip -net "$ns1" route add default via 10.0.1.2
+ip -net "$ns1" route add default via dead:beef:1::2
+
+ip -net "$ns2" addr add 10.0.1.2/24 dev ns2eth1
+ip -net "$ns2" addr add dead:beef:1::2/64 dev ns2eth1 nodad
+ip -net "$ns2" link set ns2eth1 up
+
+ip -net "$ns2" addr add 10.0.2.1/24 dev ns2eth3
+ip -net "$ns2" addr add dead:beef:2::1/64 dev ns2eth3 nodad
+ip -net "$ns2" link set ns2eth3 up
+ip -net "$ns2" route add default via 10.0.2.2
+ip -net "$ns2" route add default via dead:beef:2::2
+ip netns exec "$ns2" sysctl -q net.ipv4.ip_forward=1
+ip netns exec "$ns2" sysctl -q net.ipv6.conf.all.forwarding=1
+
+ip -net "$ns3" addr add 10.0.2.2/24 dev ns3eth2
+ip -net "$ns3" addr add dead:beef:2::2/64 dev ns3eth2 nodad
+ip -net "$ns3" link set ns3eth2 up
+
+ip -net "$ns3" addr add 10.0.3.2/24 dev ns3eth4
+ip -net "$ns3" addr add dead:beef:3::2/64 dev ns3eth4 nodad
+ip -net "$ns3" link set ns3eth4 up
+ip -net "$ns3" route add default via 10.0.2.1
+ip -net "$ns3" route add default via dead:beef:2::1
+ip netns exec "$ns3" sysctl -q net.ipv4.ip_forward=1
+ip netns exec "$ns3" sysctl -q net.ipv6.conf.all.forwarding=1
+
+ip -net "$ns4" addr add 10.0.3.1/24 dev ns4eth3
+ip -net "$ns4" addr add dead:beef:3::1/64 dev ns4eth3 nodad
+ip -net "$ns4" link set ns4eth3 up
+ip -net "$ns4" route add default via 10.0.3.2
+ip -net "$ns4" route add default via dead:beef:3::2
+
+set_ethtool_flags() {
+	local ns="$1"
+	local dev="$2"
+	local flags="$3"
+
+	ip netns exec $ns ethtool -K $dev $flags 2>/dev/null
+	[ $? -eq 0 ] && echo "INFO: set $ns dev $dev: ethtool -K $flags"
+}
+
+set_random_ethtool_flags() {
+	local flags=""
+	local r=$RANDOM
+
+	local pick1=$((r & 1))
+	local pick2=$((r & 2))
+	local pick3=$((r & 4))
+
+	[ $pick1 -ne 0 ] && flags="tso off"
+	[ $pick2 -ne 0 ] && flags="$flags gso off"
+	[ $pick3 -ne 0 ] && flags="$flags gro off"
+
+	[ -z "$flags" ] && return
+
+	set_ethtool_flags "$1" "$2" "$flags"
+}
+
+if $ethtool_random_on;then
+	set_random_ethtool_flags "$ns3" ns3eth2
+	set_random_ethtool_flags "$ns4" ns4eth3
+else
+	set_ethtool_flags "$ns3" ns3eth2 "$ethtool_args"
+	set_ethtool_flags "$ns4" ns4eth3 "$ethtool_args"
+fi
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
+	local in=$1
+	local out=$2
+	local what=$3
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
+	local disabled_ns
+	disabled_ns="ns_disabled-$sech-$(mktemp -u XXXXXX)"
+	ip netns add ${disabled_ns} || exit $ksft_skip
+
+	# net.mptcp.enabled should be enabled by default
+	if [ "$(ip netns exec ${disabled_ns} sysctl net.mptcp.enabled | awk '{ print $3 }')" -ne 1 ]; then
+		echo -e "net.mptcp.enabled sysctl is not 1 by default\t\t[ FAIL ]"
+		ret=1
+		return 1
+	fi
+	ip netns exec ${disabled_ns} sysctl -q net.mptcp.enabled=0
+
+	local err=0
+	LANG=C ip netns exec ${disabled_ns} ./mptcp_connect -t $timeout -p 10000 -s MPTCP 127.0.0.1 < "$cin" 2>&1 | \
+		grep -q "^socket: Protocol not available$" && err=1
+	ip netns delete ${disabled_ns}
+
+	if [ ${err} -eq 0 ]; then
+		echo -e "New MPTCP socket cannot be blocked via sysctl\t\t[ FAIL ]"
+		ret=1
+		return 1
+	fi
+
+	echo -e "New MPTCP socket can be blocked via sysctl\t\t[ OK ]"
+	return 0
+}
+
+check_mptcp_ulp_setsockopt()
+{
+	local t retval
+	t="ns_ulp-$sech-$(mktemp -u XXXXXX)"
+
+	ip netns add ${t} || exit $ksft_skip
+	if ! ip netns exec ${t} ./mptcp_connect -u -p 10000 -s TCP 127.0.0.1 2>&1; then
+		printf "setsockopt(..., TCP_ULP, \"mptcp\", ...) allowed\t[ FAIL ]\n"
+		retval=1
+		ret=$retval
+	else
+		printf "setsockopt(..., TCP_ULP, \"mptcp\", ...) blocked\t[ OK ]\n"
+		retval=0
+	fi
+	ip netns del ${t}
+	return $retval
+}
+
+# $1: IP address
+is_v6()
+{
+	[ -z "${1##*:*}" ]
+}
+
+do_ping()
+{
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local connect_addr="$3"
+	local ping_args="-q -c 1"
+
+	if is_v6 "${connect_addr}"; then
+		$ipv6 || return 0
+		ping_args="${ping_args} -6"
+	fi
+
+	ip netns exec ${connector_ns} ping ${ping_args} $connect_addr >/dev/null
+	if [ $? -ne 0 ] ; then
+		echo "$listener_ns -> $connect_addr connectivity [ FAIL ]" 1>&2
+		ret=1
+
+		return 1
+	fi
+
+	return 0
+}
+
+# $1: ns, $2: port
+wait_local_port_listen()
+{
+	local listener_ns="${1}"
+	local port="${2}"
+
+	local port_hex i
+
+	port_hex="$(printf "%04X" "${port}")"
+	for i in $(seq 10); do
+		ip netns exec "${listener_ns}" cat /proc/net/tcp* | \
+			awk "BEGIN {rc=1} {if (\$2 ~ /:${port_hex}\$/ && \$4 ~ /0A/) {rc=0; exit}} END {exit rc}" &&
+			break
+		sleep 0.1
+	done
+}
+
+do_transfer()
+{
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local cl_proto="$3"
+	local srv_proto="$4"
+	local connect_addr="$5"
+	local local_addr="$6"
+	local extra_args=""
+
+	local port
+	port=$((10000+$TEST_COUNT))
+	TEST_COUNT=$((TEST_COUNT+1))
+
+	if [ "$sndbuf" -gt 0 ]; then
+		extra_args="$extra_args -b $sndbuf"
+	fi
+
+	if [ -n "$testmode" ]; then
+		extra_args="$extra_args -m $testmode"
+	fi
+
+	if [ -n "$extra_args" ] && $options_log; then
+		options_log=false
+		echo "INFO: extra options: $extra_args"
+	fi
+
+	:> "$cout"
+	:> "$sout"
+	:> "$capout"
+
+	local addr_port
+	addr_port=$(printf "%s:%d" ${connect_addr} ${port})
+	printf "%.3s %-5s -> %.3s (%-20s) %-5s\t" ${connector_ns} ${cl_proto} ${listener_ns} ${addr_port} ${srv_proto}
+
+	if $capture; then
+		local capuser
+		if [ -z $SUDO_USER ] ; then
+			capuser=""
+		else
+			capuser="-Z $SUDO_USER"
+		fi
+
+		local capfile="${listener_ns}-${connector_ns}-${cl_proto}-${srv_proto}-${connect_addr}.pcap"
+
+		ip netns exec ${listener_ns} tcpdump -i any -s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
+		local cappid=$!
+
+		sleep 1
+	fi
+
+	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} $extra_args $local_addr < "$sin" > "$sout" &
+	local spid=$!
+
+	wait_local_port_listen "${listener_ns}" "${port}"
+
+	local start
+	start=$(date +%s%3N)
+	ip netns exec ${connector_ns} ./mptcp_connect -t $timeout -p $port -s ${cl_proto} $extra_args $connect_addr < "$cin" > "$cout" &
+	local cpid=$!
+
+	wait $cpid
+	local retc=$?
+	wait $spid
+	local rets=$?
+
+	local stop
+	stop=$(date +%s%3N)
+
+	if $capture; then
+		sleep 1
+		kill $cappid
+	fi
+
+	local duration
+	duration=$((stop-start))
+	duration=$(printf "(duration %05sms)" $duration)
+	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
+		echo "$duration [ FAIL ] client exit code $retc, server $rets" 1>&2
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
+		echo "$duration [ OK ]"
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
+	local name=$1
+	local who=$2
+
+	local SIZE TSIZE
+	SIZE=$((RANDOM % (1024 * 8)))
+	TSIZE=$((SIZE * 1024))
+
+	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+
+	SIZE=$((RANDOM % 1024))
+	SIZE=$((SIZE + 128))
+	TSIZE=$((TSIZE + SIZE))
+	dd if=/dev/urandom conv=notrunc of="$name" bs=1 count=$SIZE 2> /dev/null
+	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
+
+	echo "Created $name (size $TSIZE) containing data sent by $who"
+}
+
+run_tests_lo()
+{
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local connect_addr="$3"
+	local loopback="$4"
+	local lret=0
+
+	# skip if test programs are running inside same netns for subsequent runs.
+	if [ $loopback -eq 0 ] && [ ${listener_ns} = ${connector_ns} ]; then
+		return 0
+	fi
+
+	# skip if we don't want v6
+	if ! $ipv6 && is_v6 "${connect_addr}"; then
+		return 0
+	fi
+
+	local local_addr
+	if is_v6 "${connect_addr}"; then
+		local_addr="::"
+	else
+		local_addr="0.0.0.0"
+	fi
+
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr} ${local_addr}
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		ret=$lret
+		return 1
+	fi
+
+	# don't bother testing fallback tcp except for loopback case.
+	if [ ${listener_ns} != ${connector_ns} ]; then
+		return 0
+	fi
+
+	do_transfer ${listener_ns} ${connector_ns} MPTCP TCP ${connect_addr} ${local_addr}
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		ret=$lret
+		return 1
+	fi
+
+	do_transfer ${listener_ns} ${connector_ns} TCP MPTCP ${connect_addr} ${local_addr}
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		ret=$lret
+		return 1
+	fi
+
+	return 0
+}
+
+run_tests()
+{
+	run_tests_lo $1 $2 $3 0
+}
+
+make_file "$cin" "client"
+make_file "$sin" "server"
+
+check_mptcp_disabled
+
+check_mptcp_ulp_setsockopt
+
+echo "INFO: validating network environment with pings"
+for sender in "$ns1" "$ns2" "$ns3" "$ns4";do
+	do_ping "$ns1" $sender 10.0.1.1
+	do_ping "$ns1" $sender dead:beef:1::1
+
+	do_ping "$ns2" $sender 10.0.1.2
+	do_ping "$ns2" $sender dead:beef:1::2
+	do_ping "$ns2" $sender 10.0.2.1
+	do_ping "$ns2" $sender dead:beef:2::1
+
+	do_ping "$ns3" $sender 10.0.2.2
+	do_ping "$ns3" $sender dead:beef:2::2
+	do_ping "$ns3" $sender 10.0.3.2
+	do_ping "$ns3" $sender dead:beef:3::2
+
+	do_ping "$ns4" $sender 10.0.3.1
+	do_ping "$ns4" $sender dead:beef:3::1
+done
+
+[ -n "$tc_loss" ] && tc -net "$ns2" qdisc add dev ns2eth3 root netem loss random $tc_loss
+echo -n "INFO: Using loss of $tc_loss "
+test "$tc_delay" -gt 0 && echo -n "delay $tc_delay ms "
+
+if [ -z "${tc_reorder}" ]; then
+	reorder1=$((RANDOM%10))
+	reorder1=$((100 - reorder1))
+	reorder2=$((RANDOM%100))
+
+	if [ $tc_delay -gt 0 ] && [ $reorder1 -lt 100 ] && [ $reorder2 -gt 0 ]; then
+		tc_reorder="reorder ${reorder1}% ${reorder2}%"
+		echo -n "$tc_reorder "
+	fi
+elif [ "$tc_reorder" = "0" ];then
+	tc_reorder=""
+elif [ "$tc_delay" -gt 0 ];then
+	# reordering requires some delay
+	tc_reorder="reorder $tc_reorder"
+	echo -n "$tc_reorder "
+fi
+
+echo "on ns3eth4"
+
+tc -net "$ns3" qdisc add dev ns3eth4 root netem delay ${tc_delay}ms $tc_reorder
+
+for sender in $ns1 $ns2 $ns3 $ns4;do
+	run_tests_lo "$ns1" "$sender" 10.0.1.1 1
+	if [ $ret -ne 0 ] ;then
+		echo "FAIL: Could not even run loopback test" 1>&2
+		exit $ret
+	fi
+	run_tests_lo "$ns1" $sender dead:beef:1::1 1
+	if [ $ret -ne 0 ] ;then
+		echo "FAIL: Could not even run loopback v6 test" 2>&1
+		exit $ret
+	fi
+
+	run_tests "$ns2" $sender 10.0.1.2
+	run_tests "$ns2" $sender dead:beef:1::2
+	run_tests "$ns2" $sender 10.0.2.1
+	run_tests "$ns2" $sender dead:beef:2::1
+
+	run_tests "$ns3" $sender 10.0.2.2
+	run_tests "$ns3" $sender dead:beef:2::2
+	run_tests "$ns3" $sender 10.0.3.2
+	run_tests "$ns3" $sender dead:beef:3::2
+
+	run_tests "$ns4" $sender 10.0.3.1
+	run_tests "$ns4" $sender dead:beef:3::1
+done
+
+time_end=$(date +%s)
+time_run=$((time_end-time_start))
+
+echo "Time: ${time_run} seconds"
+
+exit $ret
diff --git a/tools/testing/selftests/net/mptcp/settings b/tools/testing/selftests/net/mptcp/settings
new file mode 100644
index 000000000000..026384c189c9
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/settings
@@ -0,0 +1 @@
+timeout=450
-- 
2.24.1

