Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25CF479793
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 00:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhLQXhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 18:37:08 -0500
Received: from mga05.intel.com ([192.55.52.43]:5665 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231372AbhLQXhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 18:37:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="326146289"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="326146289"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="683556054"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.7.225])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 15:37:07 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 2/3] selftests: mptcp: try to set mptcp ulp mode in different sk states
Date:   Fri, 17 Dec 2021 15:37:01 -0800
Message-Id: <20211217233702.299461-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
References: <20211217233702.299461-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The kernel will crash without
'mptcp: clear 'kern' flag from fallback sockets' change.

Since this doesn't slow down testing in a noticeable way,
run this unconditionally.

The explicit test did not catch this, because the check was done
for tcp socket returned by 'socket(.. IPPROTO_TCP) rather than a
tcp socket returned by accept() on a mptcp listen fd.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 97 ++++++++++---------
 .../selftests/net/mptcp/mptcp_connect.sh      | 20 ----
 2 files changed, 51 insertions(+), 66 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 98de28ac3ba8..a30e93c5c549 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -59,7 +59,6 @@ static enum cfg_peek cfg_peek = CFG_NONE_PEEK;
 static const char *cfg_host;
 static const char *cfg_port	= "12000";
 static int cfg_sock_proto	= IPPROTO_MPTCP;
-static bool tcpulp_audit;
 static int pf = AF_INET;
 static int cfg_sndbuf;
 static int cfg_rcvbuf;
@@ -103,7 +102,6 @@ static void die_usage(void)
 	fprintf(stderr, "\t-s [MPTCP|TCP] -- use mptcp(default) or tcp sockets\n");
 	fprintf(stderr, "\t-m [poll|mmap|sendfile] -- use poll(default)/mmap+write/sendfile\n");
 	fprintf(stderr, "\t-M mark -- set socket packet mark\n");
-	fprintf(stderr, "\t-u -- check mptcp ulp\n");
 	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
 	fprintf(stderr, "\t-c cmsg -- test cmsg type <cmsg>\n");
 	fprintf(stderr, "\t-o option -- test sockopt <option>\n");
@@ -215,6 +213,42 @@ static void set_transparent(int fd, int pf)
 	}
 }
 
+static int do_ulp_so(int sock, const char *name)
+{
+	return setsockopt(sock, IPPROTO_TCP, TCP_ULP, name, strlen(name));
+}
+
+#define X(m)	xerror("%s:%u: %s: failed for proto %d at line %u", __FILE__, __LINE__, (m), proto, line)
+static void sock_test_tcpulp(int sock, int proto, unsigned int line)
+{
+	socklen_t buflen = 8;
+	char buf[8] = "";
+	int ret = getsockopt(sock, IPPROTO_TCP, TCP_ULP, buf, &buflen);
+
+	if (ret != 0)
+		X("getsockopt");
+
+	if (buflen > 0) {
+		if (strcmp(buf, "mptcp") != 0)
+			xerror("unexpected ULP '%s' for proto %d at line %u", buf, proto, line);
+		ret = do_ulp_so(sock, "tls");
+		if (ret == 0)
+			X("setsockopt");
+	} else if (proto == IPPROTO_MPTCP) {
+		ret = do_ulp_so(sock, "tls");
+		if (ret != -1)
+			X("setsockopt");
+	}
+
+	ret = do_ulp_so(sock, "mptcp");
+	if (ret != -1)
+		X("setsockopt");
+
+#undef X
+}
+
+#define SOCK_TEST_TCPULP(s, p) sock_test_tcpulp((s), (p), __LINE__)
+
 static int sock_listen_mptcp(const char * const listenaddr,
 			     const char * const port)
 {
@@ -238,6 +272,8 @@ static int sock_listen_mptcp(const char * const listenaddr,
 		if (sock < 0)
 			continue;
 
+		SOCK_TEST_TCPULP(sock, cfg_sock_proto);
+
 		if (-1 == setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &one,
 				     sizeof(one)))
 			perror("setsockopt");
@@ -260,50 +296,17 @@ static int sock_listen_mptcp(const char * const listenaddr,
 		return sock;
 	}
 
+	SOCK_TEST_TCPULP(sock, cfg_sock_proto);
+
 	if (listen(sock, 20)) {
 		perror("listen");
 		close(sock);
 		return -1;
 	}
 
-	return sock;
-}
+	SOCK_TEST_TCPULP(sock, cfg_sock_proto);
 
-static bool sock_test_tcpulp(const char * const remoteaddr,
-			     const char * const port)
-{
-	struct addrinfo hints = {
-		.ai_protocol = IPPROTO_TCP,
-		.ai_socktype = SOCK_STREAM,
-	};
-	struct addrinfo *a, *addr;
-	int sock = -1, ret = 0;
-	bool test_pass = false;
-
-	hints.ai_family = AF_INET;
-
-	xgetaddrinfo(remoteaddr, port, &hints, &addr);
-	for (a = addr; a; a = a->ai_next) {
-		sock = socket(a->ai_family, a->ai_socktype, IPPROTO_TCP);
-		if (sock < 0) {
-			perror("socket");
-			continue;
-		}
-		ret = setsockopt(sock, IPPROTO_TCP, TCP_ULP, "mptcp",
-				 sizeof("mptcp"));
-		if (ret == -1 && errno == EOPNOTSUPP)
-			test_pass = true;
-		close(sock);
-
-		if (test_pass)
-			break;
-		if (!ret)
-			fprintf(stderr,
-				"setsockopt(TCP_ULP) returned 0\n");
-		else
-			perror("setsockopt(TCP_ULP)");
-	}
-	return test_pass;
+	return sock;
 }
 
 static int sock_connect_mptcp(const char * const remoteaddr,
@@ -326,6 +329,8 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 			continue;
 		}
 
+		SOCK_TEST_TCPULP(sock, proto);
+
 		if (cfg_mark)
 			set_mark(sock, cfg_mark);
 
@@ -338,6 +343,8 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 	}
 
 	freeaddrinfo(addr);
+	if (sock != -1)
+		SOCK_TEST_TCPULP(sock, proto);
 	return sock;
 }
 
@@ -954,6 +961,8 @@ int main_loop_s(int listensock)
 		check_sockaddr(pf, &ss, salen);
 		check_getpeername(remotesock, &ss, salen);
 
+		SOCK_TEST_TCPULP(remotesock, 0);
+
 		return copyfd_io(0, remotesock, 1);
 	}
 
@@ -1059,6 +1068,8 @@ int main_loop(void)
 
 	check_getpeername_connect(fd);
 
+	SOCK_TEST_TCPULP(fd, cfg_sock_proto);
+
 	if (cfg_rcvbuf)
 		set_rcvbuf(fd, cfg_rcvbuf);
 	if (cfg_sndbuf)
@@ -1151,7 +1162,7 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jr:lp:s:hut:T:m:S:R:w:M:P:c:o:")) != -1) {
+	while ((c = getopt(argc, argv, "6jr:lp:s:ht:T:m:S:R:w:M:P:c:o:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
@@ -1177,9 +1188,6 @@ static void parse_opts(int argc, char **argv)
 		case 'h':
 			die_usage();
 			break;
-		case 'u':
-			tcpulp_audit = true;
-			break;
 		case '6':
 			pf = AF_INET6;
 			break;
@@ -1233,9 +1241,6 @@ int main(int argc, char *argv[])
 	signal(SIGUSR1, handle_signal);
 	parse_opts(argc, argv);
 
-	if (tcpulp_audit)
-		return sock_test_tcpulp(cfg_host, cfg_port) ? 0 : 1;
-
 	if (listen_mode) {
 		int fd = sock_listen_mptcp(cfg_host, cfg_port);
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index a4226b608c68..ee28f82a6c89 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -296,24 +296,6 @@ check_mptcp_disabled()
 	return 0
 }
 
-check_mptcp_ulp_setsockopt()
-{
-	local t retval
-	t="ns_ulp-$sech-$(mktemp -u XXXXXX)"
-
-	ip netns add ${t} || exit $ksft_skip
-	if ! ip netns exec ${t} ./mptcp_connect -u -p 10000 -s TCP 127.0.0.1 2>&1; then
-		printf "setsockopt(..., TCP_ULP, \"mptcp\", ...) allowed\t[ FAIL ]\n"
-		retval=1
-		ret=$retval
-	else
-		printf "setsockopt(..., TCP_ULP, \"mptcp\", ...) blocked\t[ OK ]\n"
-		retval=0
-	fi
-	ip netns del ${t}
-	return $retval
-}
-
 # $1: IP address
 is_v6()
 {
@@ -780,8 +762,6 @@ make_file "$sin" "server"
 
 check_mptcp_disabled
 
-check_mptcp_ulp_setsockopt
-
 stop_if_error "The kernel configuration is not valid for MPTCP"
 
 echo "INFO: validating network environment with pings"
-- 
2.34.1

