Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A583486EAD
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344203AbiAGAUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:54 -0500
Received: from mga03.intel.com ([134.134.136.65]:47987 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343995AbiAGAUo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514844; x=1673050844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GEiziFj9hLtn+hCNdBI0ex/Bw2NH7MM12Q0R7f04+7w=;
  b=R+Z3+TWrijMy6VIQBppgByIhSaqSHo0k9QLCDrnjEHsyq4WxiiI/MDVq
   2To6XFJyQoVkwctzCEHdWXJ91RoHvgCNoiKQpajQPoz0gDbYrOaBERbO1
   AE4JUMp+7prPO1ssdDrd15JLKdOuuRCgFrRpS2ly3POm8sVSGK26IK2ps
   hXw7WUpvPw9oE4PlycT8EtqS+ArVc7SH0qRZY7DzYY97ky9tor+BoVnab
   FmyJ90JIlMKhHBbKN14ccSoHf5N6pbtq0kIyRzhkJtLdoSEofEsKGWsAQ
   9xdBQUTmjdockW27+D9peleHNLc+5oN0rJvTfcwOi/ACQ9H21B4u6aIjZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721309"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721309"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508505"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:35 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 06/13] selftests: mptcp: add disconnect tests
Date:   Thu,  6 Jan 2022 16:20:19 -0800
Message-Id: <20220107002026.375427-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Performs several disconnect/reconnect on the same socket,
ensuring the overall transfer is succesful.

The new test leverages ioctl(SIOCOUTQ) to ensure all the
pending data is acked before disconnecting.

Additionally order alphabetically the test program arguments list
for better maintainability.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 148 +++++++++++++++---
 .../selftests/net/mptcp/mptcp_connect.sh      |  39 ++++-
 2 files changed, 160 insertions(+), 27 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index a30e93c5c549..8628aa61b763 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -16,6 +16,7 @@
 #include <unistd.h>
 #include <time.h>
 
+#include <sys/ioctl.h>
 #include <sys/poll.h>
 #include <sys/sendfile.h>
 #include <sys/stat.h>
@@ -28,6 +29,7 @@
 
 #include <linux/tcp.h>
 #include <linux/time_types.h>
+#include <linux/sockios.h>
 
 extern int optind;
 
@@ -68,6 +70,8 @@ static unsigned int cfg_time;
 static unsigned int cfg_do_w;
 static int cfg_wait;
 static uint32_t cfg_mark;
+static char *cfg_input;
+static int cfg_repeat = 1;
 
 struct cfg_cmsg_types {
 	unsigned int cmsg_enabled:1;
@@ -91,22 +95,31 @@ static struct cfg_sockopt_types cfg_sockopt_types;
 
 static void die_usage(void)
 {
-	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] [-m mode]"
-		"[-l] [-w sec] [-t num] [-T num] connect_address\n");
+	fprintf(stderr, "Usage: mptcp_connect [-6] [-c cmsg] [-i file] [-I num] [-j] [-l] "
+		"[-m mode] [-M mark] [-o option] [-p port] [-P mode] [-j] [-l] [-r num] "
+		"[-s MPTCP|TCP] [-S num] [-r num] [-t num] [-T num] [-u] [-w sec] connect_address\n");
 	fprintf(stderr, "\t-6 use ipv6\n");
-	fprintf(stderr, "\t-t num -- set poll timeout to num\n");
-	fprintf(stderr, "\t-T num -- set expected runtime to num ms\n");
-	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
-	fprintf(stderr, "\t-R num -- set SO_RCVBUF to num\n");
-	fprintf(stderr, "\t-p num -- use port num\n");
-	fprintf(stderr, "\t-s [MPTCP|TCP] -- use mptcp(default) or tcp sockets\n");
+	fprintf(stderr, "\t-c cmsg -- test cmsg type <cmsg>\n");
+	fprintf(stderr, "\t-i file -- read the data to send from the given file instead of stdin");
+	fprintf(stderr, "\t-I num -- repeat the transfer 'num' times. In listen mode accepts num "
+		"incoming connections, in client mode, disconnect and reconnect to the server\n");
+	fprintf(stderr, "\t-j     -- add additional sleep at connection start and tear down "
+		"-- for MPJ tests\n");
+	fprintf(stderr, "\t-l     -- listens mode, accepts incoming connection\n");
 	fprintf(stderr, "\t-m [poll|mmap|sendfile] -- use poll(default)/mmap+write/sendfile\n");
 	fprintf(stderr, "\t-M mark -- set socket packet mark\n");
-	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
-	fprintf(stderr, "\t-c cmsg -- test cmsg type <cmsg>\n");
 	fprintf(stderr, "\t-o option -- test sockopt <option>\n");
+	fprintf(stderr, "\t-p num -- use port num\n");
 	fprintf(stderr,
 		"\t-P [saveWithPeek|saveAfterPeek] -- save data with/after MSG_PEEK form tcp socket\n");
+	fprintf(stderr, "\t-t num -- set poll timeout to num\n");
+	fprintf(stderr, "\t-T num -- set expected runtime to num ms\n");
+	fprintf(stderr, "\t-r num -- enable slow mode, limiting each write to num bytes "
+		"-- for remove addr tests\n");
+	fprintf(stderr, "\t-R num -- set SO_RCVBUF to num\n");
+	fprintf(stderr, "\t-s [MPTCP|TCP] -- use mptcp(default) or tcp sockets\n");
+	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
+	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
 	exit(1);
 }
 
@@ -310,7 +323,8 @@ static int sock_listen_mptcp(const char * const listenaddr,
 }
 
 static int sock_connect_mptcp(const char * const remoteaddr,
-			      const char * const port, int proto)
+			      const char * const port, int proto,
+			      struct addrinfo **peer)
 {
 	struct addrinfo hints = {
 		.ai_protocol = IPPROTO_TCP,
@@ -334,8 +348,10 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 		if (cfg_mark)
 			set_mark(sock, cfg_mark);
 
-		if (connect(sock, a->ai_addr, a->ai_addrlen) == 0)
+		if (connect(sock, a->ai_addr, a->ai_addrlen) == 0) {
+			*peer = a;
 			break; /* success */
+		}
 
 		perror("connect()");
 		close(sock);
@@ -524,14 +540,17 @@ static ssize_t do_rnd_read(const int fd, char *buf, const size_t len)
 	return ret;
 }
 
-static void set_nonblock(int fd)
+static void set_nonblock(int fd, bool nonblock)
 {
 	int flags = fcntl(fd, F_GETFL);
 
 	if (flags == -1)
 		return;
 
-	fcntl(fd, F_SETFL, flags | O_NONBLOCK);
+	if (nonblock)
+		fcntl(fd, F_SETFL, flags | O_NONBLOCK);
+	else
+		fcntl(fd, F_SETFL, flags & ~O_NONBLOCK);
 }
 
 static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after_out)
@@ -543,7 +562,7 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after
 	unsigned int woff = 0, wlen = 0;
 	char wbuf[8192];
 
-	set_nonblock(peerfd);
+	set_nonblock(peerfd, true);
 
 	for (;;) {
 		char rbuf[8192];
@@ -638,7 +657,6 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd, bool *in_closed_after
 	if (cfg_remove)
 		usleep(cfg_wait);
 
-	close(peerfd);
 	return 0;
 }
 
@@ -780,7 +798,7 @@ static int copyfd_io_sendfile(int infd, int peerfd, int outfd,
 	return err;
 }
 
-static int copyfd_io(int infd, int peerfd, int outfd)
+static int copyfd_io(int infd, int peerfd, int outfd, bool close_peerfd)
 {
 	bool in_closed_after_out = false;
 	struct timespec start, end;
@@ -819,6 +837,9 @@ static int copyfd_io(int infd, int peerfd, int outfd)
 	if (ret)
 		return ret;
 
+	if (close_peerfd)
+		close(peerfd);
+
 	if (cfg_time) {
 		unsigned int delta_ms;
 
@@ -930,7 +951,7 @@ static void maybe_close(int fd)
 {
 	unsigned int r = rand();
 
-	if (!(cfg_join || cfg_remove) && (r & 1))
+	if (!(cfg_join || cfg_remove || cfg_repeat > 1) && (r & 1))
 		close(fd);
 }
 
@@ -940,7 +961,9 @@ int main_loop_s(int listensock)
 	struct pollfd polls;
 	socklen_t salen;
 	int remotesock;
+	int fd = 0;
 
+again:
 	polls.fd = listensock;
 	polls.events = POLLIN;
 
@@ -961,14 +984,27 @@ int main_loop_s(int listensock)
 		check_sockaddr(pf, &ss, salen);
 		check_getpeername(remotesock, &ss, salen);
 
+		if (cfg_input) {
+			fd = open(cfg_input, O_RDONLY);
+			if (fd < 0)
+				xerror("can't open %s: %d", cfg_input, errno);
+		}
+
 		SOCK_TEST_TCPULP(remotesock, 0);
 
-		return copyfd_io(0, remotesock, 1);
+		copyfd_io(fd, remotesock, 1, true);
+	} else {
+		perror("accept");
+		return 1;
 	}
 
-	perror("accept");
+	if (--cfg_repeat > 0) {
+		if (cfg_input)
+			close(fd);
+		goto again;
+	}
 
-	return 1;
+	return 0;
 }
 
 static void init_rng(void)
@@ -1057,15 +1093,47 @@ static void parse_setsock_options(const char *name)
 	exit(1);
 }
 
+void xdisconnect(int fd, int addrlen)
+{
+	struct sockaddr_storage empty;
+	int msec_sleep = 10;
+	int queued = 1;
+	int i;
+
+	shutdown(fd, SHUT_WR);
+
+	/* while until the pending data is completely flushed, the later
+	 * disconnect will bypass/ignore/drop any pending data.
+	 */
+	for (i = 0; ; i += msec_sleep) {
+		if (ioctl(fd, SIOCOUTQ, &queued) < 0)
+			xerror("can't query out socket queue: %d", errno);
+
+		if (!queued)
+			break;
+
+		if (i > poll_timeout)
+			xerror("timeout while waiting for spool to complete");
+		usleep(msec_sleep * 1000);
+	}
+
+	memset(&empty, 0, sizeof(empty));
+	empty.ss_family = AF_UNSPEC;
+	if (connect(fd, (struct sockaddr *)&empty, addrlen) < 0)
+		xerror("can't disconnect: %d", errno);
+}
+
 int main_loop(void)
 {
-	int fd;
+	int fd, ret, fd_in = 0;
+	struct addrinfo *peer;
 
 	/* listener is ready. */
-	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_sock_proto);
+	fd = sock_connect_mptcp(cfg_host, cfg_port, cfg_sock_proto, &peer);
 	if (fd < 0)
 		return 2;
 
+again:
 	check_getpeername_connect(fd);
 
 	SOCK_TEST_TCPULP(fd, cfg_sock_proto);
@@ -1077,7 +1145,31 @@ int main_loop(void)
 	if (cfg_cmsg_types.cmsg_enabled)
 		apply_cmsg_types(fd, &cfg_cmsg_types);
 
-	return copyfd_io(0, fd, 1);
+	if (cfg_input) {
+		fd_in = open(cfg_input, O_RDONLY);
+		if (fd < 0)
+			xerror("can't open %s:%d", cfg_input, errno);
+	}
+
+	/* close the client socket open only if we are not going to reconnect */
+	ret = copyfd_io(fd_in, fd, 1, cfg_repeat == 1);
+	if (ret)
+		return ret;
+
+	if (--cfg_repeat > 0) {
+		xdisconnect(fd, peer->ai_addrlen);
+
+		/* the socket could be unblocking at this point, we need the
+		 * connect to be blocking
+		 */
+		set_nonblock(fd, false);
+		if (connect(fd, peer->ai_addr, peer->ai_addrlen))
+			xerror("can't reconnect: %d", errno);
+		if (cfg_input)
+			close(fd_in);
+		goto again;
+	}
+	return 0;
 }
 
 int parse_proto(const char *proto)
@@ -1162,7 +1254,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:ht:T:m:S:R:w:M:P:c:o:")) != -1) {
+	while ((c = getopt(argc, argv, "6c:hi:I:jlm:M:o:p:P:r:R:s:S:t:T:w:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
@@ -1176,6 +1268,12 @@ static void parse_opts(int argc, char **argv)
 			if (cfg_do_w <= 0)
 				cfg_do_w = 50;
 			break;
+		case 'i':
+			cfg_input = optarg;
+			break;
+		case 'I':
+			cfg_repeat = atoi(optarg);
+			break;
 		case 'l':
 			listen_mode = true;
 			break;
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index ee28f82a6c89..cb5809b89081 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -7,6 +7,7 @@ optstring="S:R:d:e:l:r:h4cm:f:tC"
 ret=0
 sin=""
 sout=""
+cin_disconnect=""
 cin=""
 cout=""
 ksft_skip=4
@@ -24,6 +25,7 @@ options_log=true
 do_tcp=0
 checksum=false
 filesize=0
+connect_per_transfer=1
 
 if [ $tc_loss -eq 100 ];then
 	tc_loss=1%
@@ -127,6 +129,7 @@ TEST_COUNT=0
 
 cleanup()
 {
+	rm -f "$cin_disconnect" "$cout_disconnect"
 	rm -f "$cin" "$cout"
 	rm -f "$sin" "$sout"
 	rm -f "$capout"
@@ -149,6 +152,8 @@ sout=$(mktemp)
 cin=$(mktemp)
 cout=$(mktemp)
 capout=$(mktemp)
+cin_disconnect="$cin".disconnect
+cout_disconnect="$cout".disconnect
 trap cleanup EXIT
 
 for i in "$ns1" "$ns2" "$ns3" "$ns4";do
@@ -500,8 +505,8 @@ do_transfer()
 	cookies=${cookies##*=}
 
 	if [ ${cl_proto} = "MPTCP" ] && [ ${srv_proto} = "MPTCP" ]; then
-		expect_synrx=$((stat_synrx_last_l+1))
-		expect_ackrx=$((stat_ackrx_last_l+1))
+		expect_synrx=$((stat_synrx_last_l+$connect_per_transfer))
+		expect_ackrx=$((stat_ackrx_last_l+$connect_per_transfer))
 	fi
 
 	if [ ${stat_synrx_now_l} -lt ${expect_synrx} ]; then
@@ -738,6 +743,33 @@ run_tests_peekmode()
 	run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1 "-P ${peekmode}"
 }
 
+run_tests_disconnect()
+{
+	local peekmode="$1"
+	local old_cin=$cin
+	local old_sin=$sin
+
+	cat $cin $cin $cin > "$cin".disconnect
+
+	# force do_transfer to cope with the multiple tranmissions
+	sin="$cin.disconnect"
+	sin_disconnect=$old_sin
+	cin="$cin.disconnect"
+	cin_disconnect="$old_cin"
+	connect_per_transfer=3
+
+	echo "INFO: disconnect"
+	run_tests_lo "$ns1" "$ns1" 10.0.1.1 1 "-I 3 -i $old_cin"
+	run_tests_lo "$ns1" "$ns1" dead:beef:1::1 1 "-I 3 -i $old_cin"
+
+	# restore previous status
+	cout=$old_cout
+	cout_disconnect="$cout".disconnect
+	cin=$old_cin
+	cin_disconnect="$cin".disconnect
+	connect_per_transfer=1
+}
+
 display_time()
 {
 	time_end=$(date +%s)
@@ -853,6 +885,9 @@ stop_if_error "Tests with peek mode have failed"
 # connect to ns4 ip address, ns2 should intercept/proxy
 run_test_transparent 10.0.3.1 "tproxy ipv4"
 run_test_transparent dead:beef:3::1 "tproxy ipv6"
+stop_if_error "Tests with tproxy have failed"
+
+run_tests_disconnect
 
 display_time
 exit $ret
-- 
2.34.1

