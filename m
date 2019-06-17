Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFE994958B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728835AbfFQW7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:59:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:10995 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728689AbfFQW6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 18:58:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:58:52 -0700
X-ExtLoop1: 1
Received: from mjmartin-nuc01.amr.corp.intel.com (HELO mjmartin-nuc01.sea.intel.com) ([10.241.98.42])
  by orsmga002.jf.intel.com with ESMTP; 17 Jun 2019 15:58:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     edumazet@google.com, netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH net-next 24/33] mptcp: selftests: Add capture option
Date:   Mon, 17 Jun 2019 15:57:59 -0700
Message-Id: <20190617225808.665-25-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
References: <20190617225808.665-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added a "-c" command line option for mptcp_connect.sh to make it easier
to capture packets from each test. The script will use tcpdump to create
one .pcap file per test case, named according to the namespaces,
protocols, and connect address in use. For example, the first test case
writes the capture to ns1-ns1-MPTCP-MPTCP-10.0.1.1.pcap

The stderr output from tcpdump is printed after the test completes to
show tcpdump's "packets dropped by kernel" information.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index e694dc9d312c..4418163af001 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -7,6 +7,7 @@ sout=""
 cin=""
 cout=""
 ksft_skip=4
+capture=0
 timeout=30
 
 TEST_COUNT=0
@@ -15,12 +16,19 @@ cleanup()
 {
 	rm -f "$cin" "$cout"
 	rm -f "$sin" "$sout"
+	rm -f "$capout"
 
 	for i in 1 2 3 4; do
 		ip netns del ns$i
 	done
 }
 
+for arg in "$@"; do
+    if [ "$arg" = "-c" ]; then
+	capture=1
+    fi
+done
+
 ip -Version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without ip tool"
@@ -31,6 +39,7 @@ sin=$(mktemp)
 sout=$(mktemp)
 cin=$(mktemp)
 cout=$(mktemp)
+capout=$(mktemp)
 trap cleanup EXIT
 
 for i in 1 2 3 4;do
@@ -123,9 +132,25 @@ do_transfer()
 
 	:> "$cout"
 	:> "$sout"
+	:> "$capout"
 
 	printf "%-4s %-5s -> %-4s (%s:%d) %-5s\t" ${connector_ns} ${cl_proto} ${listener_ns} ${connect_addr} ${port} ${srv_proto}
 
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
 	ip netns exec ${listener_ns} ./mptcp_connect -t $timeout -l -p $port -s ${srv_proto} 0.0.0.0 < "$sin" > "$sout" &
 	spid=$!
 
@@ -139,6 +164,11 @@ do_transfer()
 	wait $spid
 	rets=$?
 
+	if [ $capture -eq 1 ]; then
+	    sleep 1
+	    kill $cappid
+	fi
+
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ]; then
 		echo "[ FAIL ] client exit code $retc, server $rets" 1>&2
 		echo "\nnetns ${listener_ns} socket stat for $port:" 1>&2
@@ -146,6 +176,7 @@ do_transfer()
 		echo "\nnetns ${connector_ns} socket stat for $port:" 1>&2
 		ip netns exec ${connector_ns} ss -nita 1>&2 -o "dport = :$port"
 
+		cat "$capout"
 		return 1
 	fi
 
@@ -156,9 +187,11 @@ do_transfer()
 
 	if [ $retc -eq 0 ] && [ $rets -eq 0 ];then
 		echo "[ OK ]"
+		cat "$capout"
 		return 0
 	fi
 
+	cat "$capout"
 	return 1
 }
 
-- 
2.22.0

