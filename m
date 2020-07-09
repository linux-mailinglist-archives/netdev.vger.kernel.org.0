Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD09921A094
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 15:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgGINNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 09:13:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54701 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726768AbgGINNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 09:13:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594300393;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x77Ep7G2PFmADvB+1MZ29ho8XM+6bAAuD5zU0fkGyoY=;
        b=MIZ4DnbF20yaPtwAutee0LTrBBRxXRrfiqleVY7WEzdAvUWNAqEiBBGtCgr20BgWMudSwZ
        cwLDVTiKdbt4pMwH8fwfxe1GsMyIrl0FIB7autmjctQRt264Gwtpol9deXDoCCG5KqQ+Ve
        3gy/e/Cd2h+NVAB//dooc8oeGx3pdRM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-pUcnpJzROW-gCTKV-Qzezg-1; Thu, 09 Jul 2020 09:13:06 -0400
X-MC-Unique: pUcnpJzROW-gCTKV-Qzezg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18C39107B7F0;
        Thu,  9 Jul 2020 13:13:04 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-239.ams2.redhat.com [10.36.113.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E42B22B6DD;
        Thu,  9 Jul 2020 13:13:02 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: [PATCH net-next 4/4] selftests/mptcp: add diag interface tests
Date:   Thu,  9 Jul 2020 15:12:42 +0200
Message-Id: <cbaa69a08c809543b1647919687a300a297e0752.1594292774.git.pabeni@redhat.com>
In-Reply-To: <cover.1594292774.git.pabeni@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

basic functional test, triggering the msk diag interface
code. Require appropriate iproute2 support, skip elsewhere.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 tools/testing/selftests/net/mptcp/Makefile    |   2 +-
 tools/testing/selftests/net/mptcp/diag.sh     | 122 ++++++++++++++++++
 .../selftests/net/mptcp/mptcp_connect.c       |  22 +++-
 3 files changed, 141 insertions(+), 5 deletions(-)
 create mode 100755 tools/testing/selftests/net/mptcp/diag.sh

diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
index f50976ee7d44..aa254aefc2c3 100644
--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -5,7 +5,7 @@ KSFT_KHDR_INSTALL := 1
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
 
-TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh
+TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl
 
diff --git a/tools/testing/selftests/net/mptcp/diag.sh b/tools/testing/selftests/net/mptcp/diag.sh
new file mode 100755
index 000000000000..b3eee7ede18a
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -0,0 +1,122 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
+ns="ns1-$rndh"
+ksft_skip=4
+test_cnt=1
+ret=0
+pids=()
+
+flush_pids()
+{
+	# mptcp_connect in join mode will sleep a bit before completing,
+	# give it some time
+	sleep 1.1
+
+	for pid in ${pids[@]}; do
+		[ -d /proc/$pid ] && kill -SIGUSR1 $pid >/dev/null 2>&1
+	done
+	pids=()
+}
+
+cleanup()
+{
+	ip netns del $ns
+	for pid in ${pids[@]}; do
+		[ -d /proc/$pid ] && kill -9 $pid >/dev/null 2>&1
+	done
+}
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+ss -h | grep -q MPTCP
+if [ $? -ne 0 ];then
+	echo "SKIP: ss tool does not support MPTCP"
+	exit $ksft_skip
+fi
+
+__chk_nr()
+{
+	local condition="$1"
+	local expected=$2
+	local msg nr
+
+	shift 2
+	msg=$*
+	nr=$(ss -inmHMN $ns | $condition)
+
+	printf "%-50s" "$msg"
+	if [ $nr != $expected ]; then
+		echo "[ fail ] expected $expected found $nr"
+		ret=$test_cnt
+	else
+		echo "[  ok  ]"
+	fi
+	test_cnt=$((test_cnt+1))
+}
+
+chk_msk_nr()
+{
+	__chk_nr "grep -c token:" $*
+}
+
+chk_msk_fallback_nr()
+{
+		__chk_nr "grep -c fallback" $*
+}
+
+chk_msk_remote_key_nr()
+{
+		__chk_nr "grep -c remote_key" $*
+}
+
+
+trap cleanup EXIT
+ip netns add $ns
+ip -n $ns link set dev lo up
+
+echo "a" | ip netns exec $ns ./mptcp_connect -p 10000 -l 0.0.0.0 -t 100 >/dev/null &
+sleep 0.1
+pids[0]=$!
+chk_msk_nr 0 "no msk on netns creation"
+
+echo "b" | ip netns exec $ns ./mptcp_connect -p 10000 127.0.0.1 -j -t 100 >/dev/null &
+sleep 0.1
+pids[1]=$!
+chk_msk_nr 2 "after MPC handshake "
+chk_msk_remote_key_nr 2 "....chk remote_key"
+chk_msk_fallback_nr 0 "....chk no fallback"
+flush_pids
+
+
+echo "a" | ip netns exec $ns ./mptcp_connect -p 10001 -s TCP -l 0.0.0.0 -t 100 >/dev/null &
+pids[0]=$!
+sleep 0.1
+echo "b" | ip netns exec $ns ./mptcp_connect -p 10001 127.0.0.1 -j -t 100 >/dev/null &
+pids[1]=$!
+sleep 0.1
+chk_msk_fallback_nr 1 "check fallback"
+flush_pids
+
+NR_CLIENTS=100
+for I in `seq 1 $NR_CLIENTS`; do
+	echo "a" | ip netns exec $ns ./mptcp_connect -p $((I+10001)) -l 0.0.0.0 -t 100 -w 10 >/dev/null  &
+	pids[$((I*2))]=$!
+done
+sleep 0.1
+
+for I in `seq 1 $NR_CLIENTS`; do
+	echo "b" | ip netns exec $ns ./mptcp_connect -p $((I+10001)) 127.0.0.1 -t 100 -w 10 >/dev/null &
+	pids[$((I*2 + 1))]=$!
+done
+sleep 1.5
+
+chk_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
+flush_pids
+
+exit $ret
+
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index cedee5b952ba..cad6f73a5fd0 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -11,6 +11,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <strings.h>
+#include <signal.h>
 #include <unistd.h>
 
 #include <sys/poll.h>
@@ -36,6 +37,7 @@ extern int optind;
 
 static int  poll_timeout = 10 * 1000;
 static bool listen_mode;
+static bool quit;
 
 enum cfg_mode {
 	CFG_MODE_POLL,
@@ -52,11 +54,12 @@ static int pf = AF_INET;
 static int cfg_sndbuf;
 static int cfg_rcvbuf;
 static bool cfg_join;
+static int cfg_wait;
 
 static void die_usage(void)
 {
 	fprintf(stderr, "Usage: mptcp_connect [-6] [-u] [-s MPTCP|TCP] [-p port] [-m mode]"
-		"[-l] connect_address\n");
+		"[-l] [-w sec] connect_address\n");
 	fprintf(stderr, "\t-6 use ipv6\n");
 	fprintf(stderr, "\t-t num -- set poll timeout to num\n");
 	fprintf(stderr, "\t-S num -- set SO_SNDBUF to num\n");
@@ -65,9 +68,15 @@ static void die_usage(void)
 	fprintf(stderr, "\t-m [MPTCP|TCP] -- use tcp or mptcp sockets\n");
 	fprintf(stderr, "\t-s [mmap|poll] -- use poll (default) or mmap\n");
 	fprintf(stderr, "\t-u -- check mptcp ulp\n");
+	fprintf(stderr, "\t-w num -- wait num sec before closing the socket\n");
 	exit(1);
 }
 
+static void handle_signal(int nr)
+{
+	quit = true;
+}
+
 static const char *getxinfo_strerr(int err)
 {
 	if (err == EAI_SYSTEM)
@@ -418,8 +427,8 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 	}
 
 	/* leave some time for late join/announce */
-	if (cfg_join)
-		usleep(400000);
+	if (cfg_wait)
+		usleep(cfg_wait);
 
 	close(peerfd);
 	return 0;
@@ -812,11 +821,12 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6jlp:s:hut:m:S:R:")) != -1) {
+	while ((c = getopt(argc, argv, "6jlp:s:hut:m:S:R:w:")) != -1) {
 		switch (c) {
 		case 'j':
 			cfg_join = true;
 			cfg_mode = CFG_MODE_POLL;
+			cfg_wait = 400000;
 			break;
 		case 'l':
 			listen_mode = true;
@@ -850,6 +860,9 @@ static void parse_opts(int argc, char **argv)
 		case 'R':
 			cfg_rcvbuf = parse_int(optarg);
 			break;
+		case 'w':
+			cfg_wait = atoi(optarg)*1000000;
+			break;
 		}
 	}
 
@@ -865,6 +878,7 @@ int main(int argc, char *argv[])
 {
 	init_rng();
 
+	signal(SIGUSR1, handle_signal);
 	parse_opts(argc, argv);
 
 	if (tcpulp_audit)
-- 
2.26.2

