Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D4317C711
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 21:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgCFUaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 15:30:02 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:59400 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgCFUaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 15:30:02 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jAJbc-0002c8-OA; Fri, 06 Mar 2020 21:30:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/2] mptcp: selftests: add rcvbuf set option
Date:   Fri,  6 Mar 2020 21:29:45 +0100
Message-Id: <20200306202946.8285-2-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200306202946.8285-1-fw@strlen.de>
References: <20200306202946.8285-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

allows to run the tests with fixed receive buffer by passing
"-R <value>" to mptcp_connect.sh.

While at it, add a default 10 second poll timeout so the "-t"
becomes optional -- this makes mptcp_connect simpler to use
during manual testing.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.c       | 45 ++++++++++++++-----
 .../selftests/net/mptcp/mptcp_connect.sh      | 24 +++++++---
 2 files changed, 54 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 99579c0223c1..702bab2c12da 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -34,8 +34,8 @@ extern int optind;
 #define TCP_ULP 31
 #endif
 
+static int  poll_timeout = 10 * 1000;
 static bool listen_mode;
-static int  poll_timeout;
 
 enum cfg_mode {
 	CFG_MODE_POLL,
@@ -50,11 +50,20 @@ static int cfg_sock_proto	= IPPROTO_MPTCP;
 static bool tcpulp_audit;
 static int pf = AF_INET;
 static int cfg_sndbuf;
+static int cfg_rcvbuf;
 
 static void die_usage(void)
 {
-	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] -m mode]"
-		"[ -l ] [ -t timeout ] connect_address\n");
+	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] [-m mode]"
+		"[-l] connect_address\n");
+	fprintf(stderr, "\t-6 use ipv6\n");
+	fprintf(stderr, "\t-t num -- set poll timeout to num\n");
+	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
+	fprintf(stderr, "\t-R num -- set SO_RCVBUF to num\n");
+	fprintf(stderr, "\t-p num -- use port num\n");
+	fprintf(stderr, "\t-m [MPTCP|TCP] -- use tcp or mptcp sockets\n");
+	fprintf(stderr, "\t-s [mmap|poll] -- use poll (default) or mmap\n");
+	fprintf(stderr, "\t-u -- check mptcp ulp\n");
 	exit(1);
 }
 
@@ -97,6 +106,17 @@ static void xgetaddrinfo(const char *node, const char *service,
 	}
 }
 
+static void set_rcvbuf(int fd, unsigned int size)
+{
+	int err;
+
+	err = setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &size, sizeof(size));
+	if (err) {
+		perror("set SO_RCVBUF");
+		exit(1);
+	}
+}
+
 static void set_sndbuf(int fd, unsigned int size)
 {
 	int err;
@@ -704,6 +724,8 @@ int main_loop(void)
 
 	check_getpeername_connect(fd);
 
+	if (cfg_rcvbuf)
+		set_rcvbuf(fd, cfg_rcvbuf);
 	if (cfg_sndbuf)
 		set_sndbuf(fd, cfg_sndbuf);
 
@@ -745,7 +767,7 @@ int parse_mode(const char *mode)
 	return 0;
 }
 
-int parse_sndbuf(const char *size)
+static int parse_int(const char *size)
 {
 	unsigned long s;
 
@@ -765,16 +787,14 @@ int parse_sndbuf(const char *size)
 		die_usage();
 	}
 
-	cfg_sndbuf = s;
-
-	return 0;
+	return (int)s;
 }
 
 static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6lp:s:hut:m:b:")) != -1) {
+	while ((c = getopt(argc, argv, "6lp:s:hut:m:S:R:")) != -1) {
 		switch (c) {
 		case 'l':
 			listen_mode = true;
@@ -802,8 +822,11 @@ static void parse_opts(int argc, char **argv)
 		case 'm':
 			cfg_mode = parse_mode(optarg);
 			break;
-		case 'b':
-			cfg_sndbuf = parse_sndbuf(optarg);
+		case 'S':
+			cfg_sndbuf = parse_int(optarg);
+			break;
+		case 'R':
+			cfg_rcvbuf = parse_int(optarg);
 			break;
 		}
 	}
@@ -831,6 +854,8 @@ int main(int argc, char *argv[])
 		if (fd < 0)
 			return 1;
 
+		if (cfg_rcvbuf)
+			set_rcvbuf(fd, cfg_rcvbuf);
 		if (cfg_sndbuf)
 			set_sndbuf(fd, cfg_sndbuf);
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index d573a0feb98d..acf02e156d20 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -3,7 +3,7 @@
 
 time_start=$(date +%s)
 
-optstring="b:d:e:l:r:h4cm:"
+optstring="S:R:d:e:l:r:h4cm:"
 ret=0
 sin=""
 sout=""
@@ -19,6 +19,7 @@ tc_loss=$((RANDOM%101))
 tc_reorder=""
 testmode=""
 sndbuf=0
+rcvbuf=0
 options_log=true
 
 if [ $tc_loss -eq 100 ];then
@@ -39,7 +40,8 @@ usage() {
 	echo -e "\t-e: ethtool features to disable, e.g.: \"-e tso -e gso\" (default: randomly disable any of tso/gso/gro)"
 	echo -e "\t-4: IPv4 only: disable IPv6 tests (default: test both IPv4 and IPv6)"
 	echo -e "\t-c: capture packets for each test using tcpdump (default: no capture)"
-	echo -e "\t-b: set sndbuf value (default: use kernel default)"
+	echo -e "\t-S: set sndbuf value (default: use kernel default)"
+	echo -e "\t-R: set rcvbuf value (default: use kernel default)"
 	echo -e "\t-m: test mode (poll, sendfile; default: poll)"
 }
 
@@ -73,11 +75,19 @@ while getopts "$optstring" option;do
 	"c")
 		capture=true
 		;;
-	"b")
+	"S")
 		if [ $OPTARG -ge 0 ];then
 			sndbuf="$OPTARG"
 		else
-			echo "-s requires numeric argument, got \"$OPTARG\"" 1>&2
+			echo "-S requires numeric argument, got \"$OPTARG\"" 1>&2
+			exit 1
+		fi
+		;;
+	"R")
+		if [ $OPTARG -ge 0 ];then
+			rcvbuf="$OPTARG"
+		else
+			echo "-R requires numeric argument, got \"$OPTARG\"" 1>&2
 			exit 1
 		fi
 		;;
@@ -342,8 +352,12 @@ do_transfer()
 	port=$((10000+$TEST_COUNT))
 	TEST_COUNT=$((TEST_COUNT+1))
 
+	if [ "$rcvbuf" -gt 0 ]; then
+		extra_args="$extra_args -R $rcvbuf"
+	fi
+
 	if [ "$sndbuf" -gt 0 ]; then
-		extra_args="$extra_args -b $sndbuf"
+		extra_args="$extra_args -S $sndbuf"
 	fi
 
 	if [ -n "$testmode" ]; then
-- 
2.24.1

