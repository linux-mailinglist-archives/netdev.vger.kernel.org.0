Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DABE49585
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbfFQW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:10994 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbfFQW6y (ORCPT <rfc822;netdev@vger.kernel.org>);
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
Subject: [RFC PATCH net-next 23/33] mptcp: selftests: switch to netns+veth based tests
Date:   Mon, 17 Jun 2019 15:57:58 -0700
Message-Id: <20190617225808.665-24-mathew.j.martineau@linux.intel.com>
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

... so we can exercise PMTU and MSS handling.
MTU on lo is 64k, so we never had to deal with segmentation either.

This also avoids problems with timewait state in inet_ns,
all net namespaces are torn down before script exits.

This uncovers several bugs:
1. mptcp_init_sock() passes init_net instead of sock_net(sk), i.e.
   network namespaces are not supported
2. We corrupt tcp option space, I can see invalid tcp headers (too
   short) in tcpdump, and receiver process hangs without getting the
   data (poll timeout).
   Seems to be gone after adding

    if (size == MAX_TCP_OPTION_SPACE)
          return size;

    BUG(size > MAX_TCP_OPTION_SPACE);

    in tcp_established_options() after writing mptcp options.
    SACK writing doesn't handle 'no option space left' case.
3. Several WARN_ON from networking core are triggered, e.g. due
   to mem accounting being off.  Maybe fixed already with pending
   locking fix in mptcp_recv.
4. "Replaced mapping before it was done" in dmesg.
5. receiver blocking in read(), while TCP socket is in CLOSE-WAIT.
   wait_woken+0xd6/0x170
   sk_wait_data+0x248/0x270
   mptcp_recvmsg+0x5c0/0xd50
6. kmemleak gets noisy, we probably leak a refcount somewhere (iirc
   Davide is already working on this).
7. crash on connect completion, probably same bug that Paolo reported
   already.

As the script did not yet turn up any problem when using only
tcp, it appears these are MPTCP related bugs rather than with script
or mptcp_connect.c .

Once above issues are fixed, this will be extended again to
set different/varying MTU in ns1 and ns4.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 310 +++++++++---------
 .../selftests/net/mptcp/mptcp_connect.sh      | 246 ++++++++++++--
 2 files changed, 382 insertions(+), 174 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 78c43624e84f..cac71f0ac8f8 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -26,16 +26,19 @@ extern int optind;
 #define IPPROTO_MPTCP 262
 #endif
 
+static bool listen_mode;
+static int  poll_timeout;
+
 static const char *cfg_host;
 static const char *cfg_port	= "12000";
-static int cfg_server_proto	= IPPROTO_MPTCP;
-static int cfg_client_proto	= IPPROTO_MPTCP;
+static int cfg_sock_proto	= IPPROTO_MPTCP;
+
 
 static void die_usage(void)
 {
-	fprintf(stderr, "Usage: mptcp_connect [-c MPTCP|TCP] [-p port] "
-		"[-s MPTCP|TCP]\n");
-	exit(-1);
+	fprintf(stderr, "Usage: mptcp_connect [-s MPTCP|TCP] [-p port] "
+		"[ -l ] [ -t timeout ] connect_address\n");
+	exit(1);
 }
 
 static const char *getxinfo_strerr(int err)
@@ -79,11 +82,9 @@ static int sock_listen_mptcp(const char * const listenaddr,
 	xgetaddrinfo(listenaddr, port, &hints, &addr);
 
 	for (a = addr; a; a = a->ai_next) {
-		sock = socket(a->ai_family, a->ai_socktype, cfg_server_proto);
-		if (sock < 0) {
-			perror("socket");
+		sock = socket(a->ai_family, a->ai_socktype, cfg_sock_proto);
+		if (sock < 0)
 			continue;
-		}
 
 		if (-1 == setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one,
 				     sizeof(one)))
@@ -97,10 +98,19 @@ static int sock_listen_mptcp(const char * const listenaddr,
 		sock = -1;
 	}
 
-	if (sock >= 0 && listen(sock, 20))
+	freeaddrinfo(addr);
+
+	if (sock < 0) {
+		fprintf(stderr, "Could not create listen socket\n");
+		return sock;
+	}
+
+	if (listen(sock, 20)) {
 		perror("listen");
+		close(sock);
+		return -1;
+	}
 
-	freeaddrinfo(addr);
 	return sock;
 }
 
@@ -136,7 +146,7 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 	return sock;
 }
 
-static size_t do_write(const int fd, char *buf, const size_t len)
+static size_t do_rnd_write(const int fd, char *buf, const size_t len)
 {
 	size_t offset = 0;
 
@@ -161,62 +171,149 @@ static size_t do_write(const int fd, char *buf, const size_t len)
 	return offset;
 }
 
-static void copyfd_io(int peerfd)
+static size_t do_write(const int fd, char *buf, const size_t len)
 {
-	struct pollfd fds = { .events = POLLIN };
+	size_t offset = 0;
 
-	fds.fd = peerfd;
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
 
 	for (;;) {
-		char buf[4096];
+		char buf[8192];
 		ssize_t len;
 
-		switch (poll(&fds, 1, -1)) {
+		if (fds.events == 0)
+			break;
+
+		switch (poll(&fds, 1, poll_timeout)) {
 		case -1:
 			if (errno == EINTR)
 				continue;
 			perror("poll");
-			return;
+			return 1;
 		case 0:
-			/* should not happen, we requested infinite wait */
-			fputs("Timed out?!", stderr);
-			return;
+			fprintf(stderr, "%s: poll timed out (events: "
+				"POLLIN %u, POLLOUT %u)\n", __func__,
+				fds.events & POLLIN, fds.events & POLLOUT);
+			return 2;
 		}
 
-		if ((fds.revents & POLLIN) == 0)
-			return;
+		if (fds.revents & POLLIN) {
+			len = do_rnd_read(peerfd, buf, sizeof(buf));
+			if (len == 0) {
+				/* no more data to receive:
+				 * peer has closed its write side
+				 */
+				fds.events &= ~POLLIN;
 
-		len = read(peerfd, buf, sizeof(buf));
-		if (!len)
-			return;
-		if (len < 0) {
-			if (errno == EINTR)
-				continue;
+				if ((fds.events & POLLOUT) == 0)
+					/* and nothing more to send */
+					break;
+
+			/* Else, still have data to transmit */
+			} else if (len < 0) {
+				perror("read");
+				return 3;
+			}
 
-			perror("read");
-			return;
+			do_write(outfd, buf, len);
 		}
 
-		if (!do_write(peerfd, buf, len))
-			return;
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
 	}
+
+	close(peerfd);
+	return 0;
 }
 
 int main_loop_s(int listensock)
 {
 	struct sockaddr_storage ss;
+	struct pollfd polls;
 	socklen_t salen;
 	int remotesock;
 
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
 	salen = sizeof(ss);
-	while ((remotesock = accept(listensock, (struct sockaddr *)&ss,
-				    &salen)) < 0)
-		perror("accept");
+	remotesock = accept(listensock, (struct sockaddr *)&ss, &salen);
+	if (remotesock >= 0) {
+		copyfd_io(0, remotesock, 1);
+		return 0;
+	}
 
-	copyfd_io(remotesock);
-	close(remotesock);
+	perror("accept");
 
-	return 0;
+	return 1;
 }
 
 static void init_rng(void)
@@ -225,7 +322,10 @@ static void init_rng(void)
 	unsigned int foo;
 
 	if (fd > 0) {
-		read(fd, &foo, sizeof(foo));
+		int ret = read(fd, &foo, sizeof(foo));
+
+		if (ret < 0)
+			srand(fd + foo);
 		close(fd);
 	}
 
@@ -234,113 +334,14 @@ static void init_rng(void)
 
 int main_loop(void)
 {
-	int pollfds = 2, timeout = -1;
-	char start[32];
-	int pipefd[2];
-	ssize_t ret;
 	int fd;
 
-	if (pipe(pipefd)) {
-		perror("pipe");
-		exit(1);
-	}
-
-	switch (fork()) {
-	case 0:
-		close(pipefd[0]);
-
-		init_rng();
-
-		fd = sock_listen_mptcp(NULL, cfg_port);
-		if (fd < 0)
-			return -1;
-
-		write(pipefd[1], "RDY\n", 4);
-		main_loop_s(fd);
-		exit(1);
-	case -1:
-		perror("fork");
-		return -1;
-	default:
-		close(pipefd[1]);
-		break;
-	}
-
-	init_rng();
-	ret = read(pipefd[0], start, (int)sizeof(start));
-	if (ret < 0) {
-		perror("read");
-		return -1;
-	}
-
-	if (ret != 4 || strcmp(start, "RDY\n"))
-		return -1;
-
 	/* listener is ready. */
-	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_client_proto);
+	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_sock_proto);
 	if (fd < 0)
-		return -1;
-
-	for (;;) {
-		struct pollfd fds[2];
-		char buf[4096];
-		ssize_t len;
-
-		fds[0].fd = fd;
-		fds[0].events = POLLIN;
-		fds[1].fd = 0;
-		fds[1].events = POLLIN;
-		fds[1].revents = 0;
-
-		switch (poll(fds, pollfds, timeout)) {
-		case -1:
-			if (errno == EINTR)
-				continue;
-			perror("poll");
-			return -1;
-		case 0:
-			close(fd);
-			return 0;
-		}
-
-		if (fds[0].revents & POLLIN) {
-			unsigned int blen = rand();
-
-			blen %= sizeof(buf);
-
-			++blen;
-			len = read(fd, buf, blen);
-			if (len < 0) {
-				perror("read");
-				return -1;
-			}
-
-			if (len > blen) {
-				fprintf(stderr, "read returned more data than "
-						"buffer length\n");
-				len = blen;
-			}
-
-			write(1, buf, len);
-		}
-		if (fds[1].revents & POLLIN) {
-			len = read(0, buf, sizeof(buf));
-			if (len == 0) {
-				pollfds = 1;
-				timeout = 1000;
-				continue;
-			}
+		return 2;
 
-			if (len < 0) {
-				perror("read");
-				break;
-			}
-
-			do_write(fd, buf, len);
-		}
-	}
-
-	return 1;
+	return copyfd_io(0, fd, 1);
 }
 
 int parse_proto(const char *proto)
@@ -349,6 +350,8 @@ int parse_proto(const char *proto)
 		return IPPROTO_MPTCP;
 	if (!strcasecmp(proto, "TCP"))
 		return IPPROTO_TCP;
+
+	fprintf(stderr, "Unknown protocol: %s.", proto);
 	die_usage();
 
 	/* silence compiler warning */
@@ -359,20 +362,25 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "c:p:s:h")) != -1) {
+	while ((c = getopt(argc, argv, "lp:s:ht:")) != -1) {
 		switch (c) {
-		case 'c':
-			cfg_client_proto = parse_proto(optarg);
+		case 'l':
+			listen_mode = true;
 			break;
 		case 'p':
 			cfg_port = optarg;
 			break;
 		case 's':
-			cfg_server_proto = parse_proto(optarg);
+			cfg_sock_proto = parse_proto(optarg);
 			break;
 		case 'h':
 			die_usage();
 			break;
+		case 't':
+			poll_timeout = atoi(optarg) * 1000;
+			if (poll_timeout <= 0)
+				poll_timeout = -1;
+			break;
 		}
 	}
 
@@ -386,5 +394,15 @@ int main(int argc, char *argv[])
 	init_rng();
 
 	parse_opts(argc, argv);
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
 	return main_loop();
 }
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index efcdda84b62a..e694dc9d312c 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -1,48 +1,238 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
-tmpin=$(mktemp)
-tmpout=$(mktemp)
+ret=0
+sin=""
+sout=""
+cin=""
+cout=""
+ksft_skip=4
+timeout=30
+
+TEST_COUNT=0
 
 cleanup()
 {
-	rm -f "$tmpin" "$tmpout"
+	rm -f "$cin" "$cout"
+	rm -f "$sin" "$sout"
+
+	for i in 1 2 3 4; do
+		ip netns del ns$i
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
+trap cleanup EXIT
+
+for i in 1 2 3 4;do
+	ip netns add ns$i || exit $ksft_skip
+	ip -net ns$i link set lo up
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
 }
 
 check_transfer()
 {
-	cl_proto=${1}
-	srv_proto=${2}
+	in=$1
+	out=$2
+	what=$3
 
-	printf "%-8s -> %-8s socket\t\t" ${cl_proto} ${srv_proto}
+	cmp "$in" "$out" > /dev/null 2>&1
+	if [ $? -ne 0 ] ;then
+		echo "[ FAIL ] $what does not match (in, out):"
+		print_file_err "$in"
+		print_file_err "$out"
 
-	./mptcp_connect -c ${cl_proto} -p 43212 -s ${srv_proto} 127.0.0.1  < "$tmpin" > "$tmpout" 2>/dev/null
-	ret=$?
-	if [ ${ret} -ne 0 ]; then
-		echo "[ FAIL ]"
-		echo " exit code ${ret}"
-		return ${ret}
+		return 1
 	fi
-	cmp "$tmpin" "$tmpout" > /dev/null 2>&1
-	if [ $? -ne 0 ]; then
-		echo "[ FAIL ]"
-		ls -l "$tmpin" "$tmpout" 1>&2
-	else
-		echo "[  OK  ]"
+
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
 	fi
 }
 
-trap cleanup EXIT
+do_transfer()
+{
+	listener_ns="$1"
+	connector_ns="$2"
+	cl_proto="$3"
+	srv_proto="$4"
+	connect_addr="$5"
 
-SIZE=$((RANDOM % (1024 * 1024)))
-if [ $SIZE -eq 0 ]; then
-	SIZE=1
-fi
+	port=$((10000+$TEST_COUNT))
+	TEST_COUNT=$((TEST_COUNT+1))
+
+	:> "$cout"
+	:> "$sout"
+
+	printf "%-4s %-5s -> %-4s (%s:%d) %-5s\t" ${connector_ns} ${cl_proto} ${listener_ns} ${connect_addr} ${port} ${srv_proto}
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
+	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
+		echo "[ FAIL ] client exit code $retc, server $rets" 1>&2
+		echo "\nnetns ${listener_ns} socket stat for $port:" 1>&2
+		ip netns exec ${listener_ns} ss -nita 1>&2 -o "sport = :$port"
+		echo "\nnetns ${connector_ns} socket stat for $port:" 1>&2
+		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
+
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
+		return 0
+	fi
+
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
 
-dd if=/dev/urandom of="$tmpin" bs=1 count=$SIZE 2> /dev/null
+	run_tests ns3 ns$sender 10.0.2.2
+	run_tests ns3 ns$sender 10.0.3.2
 
-check_transfer MPTCP MPTCP
-check_transfer MPTCP TCP
-check_transfer TCP MPTCP
+	run_tests ns4 ns$sender 10.0.3.1
+done
 
-exit 0
+exit $ret
-- 
2.22.0

