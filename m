Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4919004B
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727163AbgCWV3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:43 -0400
Received: from mga05.intel.com ([192.55.52.43]:18840 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727149AbgCWV3l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:41 -0400
IronPort-SDR: RLc0chEH9jb45vlNPh/HCoT6QFsqCi8N+WHtG5J+n00dW8enoYN1i5W2gTiITnz4P3xS/z/iJO
 wU+7cERuQ4pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:40 -0700
IronPort-SDR: 47vmkg+4glyrsc9dcfBUvQKl3dcQe4zUgfVvCXJTLd8zD5D+hzqQSzw9AolI8j/r6nxp05n6rW
 SxU905x6X3VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960441"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:39 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, eric.dumazet@gmail.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 17/17] selftests: add test-cases for MPTCP MP_JOIN
Date:   Mon, 23 Mar 2020 14:26:42 -0700
Message-Id: <20200323212642.34104-18-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Use the pm netlink to configure the creation of several
subflows, and verify that via MIB counters.

Update the mptcp_connect program to allow reliable MP_JOIN
handshake even on small data file

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 tools/testing/selftests/net/mptcp/Makefile    |   2 +-
 .../selftests/net/mptcp/mptcp_connect.c       |  28 +-
 .../testing/selftests/net/mptcp/mptcp_join.sh | 357 ++++++++++++++++++
 3 files changed, 383 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_join.sh

diff --git a/tools/testing/selftests/net/mptcp/Makefile b/tools/testing/selftests/net/mptcp/Makefile
index 70c831fcaf70..f50976ee7d44 100644
--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -5,7 +5,7 @@ KSFT_KHDR_INSTALL := 1
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
 
-TEST_PROGS := mptcp_connect.sh pm_netlink.sh
+TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl
 
diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.c b/tools/testing/selftests/net/mptcp/mptcp_connect.c
index 702bab2c12da..cedee5b952ba 100644
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.c
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.c
@@ -51,6 +51,7 @@ static bool tcpulp_audit;
 static int pf = AF_INET;
 static int cfg_sndbuf;
 static int cfg_rcvbuf;
+static bool cfg_join;
 
 static void die_usage(void)
 {
@@ -250,6 +251,7 @@ static int sock_connect_mptcp(const char * const remoteaddr,
 
 static size_t do_rnd_write(const int fd, char *buf, const size_t len)
 {
+	static bool first = true;
 	unsigned int do_w;
 	ssize_t bw;
 
@@ -257,10 +259,19 @@ static size_t do_rnd_write(const int fd, char *buf, const size_t len)
 	if (do_w == 0 || do_w > len)
 		do_w = len;
 
+	if (cfg_join && first && do_w > 100)
+		do_w = 100;
+
 	bw = write(fd, buf, do_w);
 	if (bw < 0)
 		perror("write");
 
+	/* let the join handshake complete, before going on */
+	if (cfg_join && first) {
+		usleep(200000);
+		first = false;
+	}
+
 	return bw;
 }
 
@@ -385,8 +396,11 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 					break;
 
 				/* ... but we still receive.
-				 * Close our write side.
+				 * Close our write side, ev. give some time
+				 * for address notification
 				 */
+				if (cfg_join)
+					usleep(400000);
 				shutdown(peerfd, SHUT_WR);
 			} else {
 				if (errno == EINTR)
@@ -403,6 +417,10 @@ static int copyfd_io_poll(int infd, int peerfd, int outfd)
 		}
 	}
 
+	/* leave some time for late join/announce */
+	if (cfg_join)
+		usleep(400000);
+
 	close(peerfd);
 	return 0;
 }
@@ -658,7 +676,7 @@ static void maybe_close(int fd)
 {
 	unsigned int r = rand();
 
-	if (r & 1)
+	if (!cfg_join && (r & 1))
 		close(fd);
 }
 
@@ -794,8 +812,12 @@ static void parse_opts(int argc, char **argv)
 {
 	int c;
 
-	while ((c = getopt(argc, argv, "6lp:s:hut:m:S:R:")) != -1) {
+	while ((c = getopt(argc, argv, "6jlp:s:hut:m:S:R:")) != -1) {
 		switch (c) {
+		case 'j':
+			cfg_join = true;
+			cfg_mode = CFG_MODE_POLL;
+			break;
 		case 'l':
 			listen_mode = true;
 			break;
diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
new file mode 100755
index 000000000000..dd42c2f692d0
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -0,0 +1,357 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+ret=0
+sin=""
+sout=""
+cin=""
+cout=""
+ksft_skip=4
+timeout=30
+capture=0
+
+TEST_COUNT=0
+
+init()
+{
+	capout=$(mktemp)
+
+	rndh=$(printf %x $sec)-$(mktemp -u XXXXXX)
+
+	ns1="ns1-$rndh"
+	ns2="ns2-$rndh"
+
+	for netns in "$ns1" "$ns2";do
+		ip netns add $netns || exit $ksft_skip
+		ip -net $netns link set lo up
+		ip netns exec $netns sysctl -q net.mptcp.enabled=1
+		ip netns exec $netns sysctl -q net.ipv4.conf.all.rp_filter=0
+		ip netns exec $netns sysctl -q net.ipv4.conf.default.rp_filter=0
+	done
+
+	#  ns1              ns2
+	# ns1eth1    ns2eth1
+	# ns1eth2    ns2eth2
+	# ns1eth3    ns2eth3
+	# ns1eth4    ns2eth4
+
+	for i in `seq 1 4`; do
+		ip link add ns1eth$i netns "$ns1" type veth peer name ns2eth$i netns "$ns2"
+		ip -net "$ns1" addr add 10.0.$i.1/24 dev ns1eth$i
+		ip -net "$ns1" addr add dead:beef:$i::1/64 dev ns1eth$i nodad
+		ip -net "$ns1" link set ns1eth$i up
+
+		ip -net "$ns2" addr add 10.0.$i.2/24 dev ns2eth$i
+		ip -net "$ns2" addr add dead:beef:$i::2/64 dev ns2eth$i nodad
+		ip -net "$ns2" link set ns2eth$i up
+
+		# let $ns2 reach any $ns1 address from any interface
+		ip -net "$ns2" route add default via 10.0.$i.1 dev ns2eth$i metric 10$i
+	done
+}
+
+cleanup_partial()
+{
+	rm -f "$capout"
+
+	for netns in "$ns1" "$ns2"; do
+		ip netns del $netns
+	done
+}
+
+cleanup()
+{
+	rm -f "$cin" "$cout"
+	rm -f "$sin" "$sout"
+	cleanup_partial
+}
+
+reset()
+{
+	cleanup_partial
+	init
+}
+
+for arg in "$@"; do
+	if [ "$arg" = "-c" ]; then
+		capture=1
+	fi
+done
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
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
+	if [ $capture -eq 1 ]; then
+		if [ -z $SUDO_USER ] ; then
+			capuser=""
+		else
+			capuser="-Z $SUDO_USER"
+		fi
+
+		capfile="mp_join-${listener_ns}.pcap"
+
+		echo "Capturing traffic for test $TEST_COUNT into $capfile"
+		ip netns exec ${listener_ns} tcpdump -i any -s 65535 -B 32768 $capuser -w $capfile > "$capout" 2>&1 &
+		cappid=$!
+
+		sleep 1
+	fi
+
+	ip netns exec ${listener_ns} ./mptcp_connect -j -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
+	spid=$!
+
+	sleep 1
+
+	ip netns exec ${connector_ns} ./mptcp_connect -j -t $timeout -p $port -s ${cl_proto} $connect_addr < "$cin" > "$cout" &
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
+		echo " client exit code $retc, server $rets" 1>&2
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
+	SIZE=1
+
+	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
+
+	echo "Created $name (size $SIZE KB) containing data sent by $who"
+}
+
+run_tests()
+{
+	listener_ns="$1"
+	connector_ns="$2"
+	connect_addr="$3"
+	lret=0
+
+	do_transfer ${listener_ns} ${connector_ns} MPTCP MPTCP ${connect_addr}
+	lret=$?
+	if [ $lret -ne 0 ]; then
+		ret=$lret
+		return
+	fi
+}
+
+chk_join_nr()
+{
+	local msg="$1"
+	local syn_nr=$2
+	local syn_ack_nr=$3
+	local ack_nr=$4
+	local count
+	local dump_stats
+
+	printf "%-36s %s" "$msg" "syn"
+	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinSynRx | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$syn_nr" ]; then
+		echo "[fail] got $count JOIN[s] syn expected $syn_nr"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - synack"
+	count=`ip netns exec $ns2 nstat -as | grep MPTcpExtMPJoinSynAckRx | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$syn_ack_nr" ]; then
+		echo "[fail] got $count JOIN[s] synack expected $syn_ack_nr"
+		ret=1
+		dump_stats=1
+	else
+		echo -n "[ ok ]"
+	fi
+
+	echo -n " - ack"
+	count=`ip netns exec $ns1 nstat -as | grep MPTcpExtMPJoinAckRx | awk '{print $2}'`
+	[ -z "$count" ] && count=0
+	if [ "$count" != "$ack_nr" ]; then
+		echo "[fail] got $count JOIN[s] ack expected $ack_nr"
+		ret=1
+		dump_stats=1
+	else
+		echo "[ ok ]"
+	fi
+	if [ "${dump_stats}" = 1 ]; then
+		echo Server ns stats
+		ip netns exec $ns1 nstat -as | grep MPTcp
+		echo Client ns stats
+		ip netns exec $ns2 nstat -as | grep MPTcp
+	fi
+}
+
+sin=$(mktemp)
+sout=$(mktemp)
+cin=$(mktemp)
+cout=$(mktemp)
+init
+make_file "$cin" "client"
+make_file "$sin" "server"
+trap cleanup EXIT
+
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "no JOIN" "0" "0" "0"
+
+# subflow limted by client
+reset
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "single subflow, limited by client" 0 0 0
+
+# subflow limted by server
+reset
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "single subflow, limited by server" 1 1 0
+
+# subflow
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "single subflow" 1 1 1
+
+# multiple subflows
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "multiple subflows" 2 2 2
+
+# multiple subflows limited by serverf
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.2.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "multiple subflows, limited by server" 2 2 1
+
+# add_address, unused
+reset
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "unused signal address" 0 0 0
+
+# accept and use add_addr
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 1
+ip netns exec $ns2 ./pm_nl_ctl limits 1 1
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "signal address" 1 1 1
+
+# accept and use add_addr with an additional subflow
+# note: signal address in server ns and local addresses in client ns must
+# belong to different subnets or one of the listed local address could be
+# used for 'add_addr' subflow
+reset
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+ip netns exec $ns2 ./pm_nl_ctl limits 1 2
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "subflow and signal" 2 2 2
+
+# accept and use add_addr with additional subflows
+reset
+ip netns exec $ns1 ./pm_nl_ctl limits 0 3
+ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+ip netns exec $ns2 ./pm_nl_ctl limits 1 3
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+run_tests $ns1 $ns2 10.0.1.1
+chk_join_nr "multiple subflows and signal" 3 3 3
+
+exit $ret
-- 
2.26.0

