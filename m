Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3C2A20FCB7
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 21:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgF3TZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 15:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgF3TY7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 15:24:59 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B4C6C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 12:24:59 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jqLsI-0001j6-4m; Tue, 30 Jun 2020 21:24:58 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     <mptcp@lists.01.org>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/2] selftests: mptcp: add option to specify size of file to transfer
Date:   Tue, 30 Jun 2020 21:24:44 +0200
Message-Id: <20200630192445.18333-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200630192445.18333-1-fw@strlen.de>
References: <20200630192445.18333-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The script generates two random files that are then sent via tcp and
mptcp connections.

In order to compare throughput over consecutive runs add an option
to provide the file size on the command line: "-f 128000".

Also add an option, -t, to enable tcp tests. This is useful to
compare throughput of mptcp connections and tcp connections.

Example: run tests with a 4mb file size, 300ms delay 0.01% loss,
default gso/tso/gro settings and with large write/blocking io:

mptcp_connect.sh -t -f $((4 * 1024 * 1024)) -d 300 -l 0.01%  -r 0 -e "" -m mmap

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../selftests/net/mptcp/mptcp_connect.sh      | 52 ++++++++++++++-----
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_connect.sh b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
index acf02e156d20..8f7145c413b9 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -3,7 +3,7 @@
 
 time_start=$(date +%s)
 
-optstring="S:R:d:e:l:r:h4cm:"
+optstring="S:R:d:e:l:r:h4cm:f:t"
 ret=0
 sin=""
 sout=""
@@ -21,6 +21,8 @@ testmode=""
 sndbuf=0
 rcvbuf=0
 options_log=true
+do_tcp=0
+filesize=0
 
 if [ $tc_loss -eq 100 ];then
 	tc_loss=1%
@@ -40,9 +42,11 @@ usage() {
 	echo -e "\t-e: ethtool features to disable, e.g.: \"-e tso -e gso\" (default: randomly disable any of tso/gso/gro)"
 	echo -e "\t-4: IPv4 only: disable IPv6 tests (default: test both IPv4 and IPv6)"
 	echo -e "\t-c: capture packets for each test using tcpdump (default: no capture)"
+	echo -e "\t-f: size of file to transfer in bytes (default random)"
 	echo -e "\t-S: set sndbuf value (default: use kernel default)"
 	echo -e "\t-R: set rcvbuf value (default: use kernel default)"
 	echo -e "\t-m: test mode (poll, sendfile; default: poll)"
+	echo -e "\t-t: also run tests with TCP (use twice to non-fallback tcp)"
 }
 
 while getopts "$optstring" option;do
@@ -94,6 +98,12 @@ while getopts "$optstring" option;do
 	"m")
 		testmode="$OPTARG"
 		;;
+	"f")
+		filesize="$OPTARG"
+		;;
+	"t")
+		do_tcp=$((do_tcp+1))
+		;;
 	"?")
 		usage $0
 		exit 1
@@ -449,20 +459,25 @@ make_file()
 {
 	local name=$1
 	local who=$2
+	local SIZE=$filesize
+	local ksize
+	local rem
 
-	local SIZE TSIZE
-	SIZE=$((RANDOM % (1024 * 8)))
-	TSIZE=$((SIZE * 1024))
+	if [ $SIZE -eq 0 ]; then
+		local MAXSIZE=$((1024 * 1024 * 8))
+		local MINSIZE=$((1024 * 256))
 
-	dd if=/dev/urandom of="$name" bs=1024 count=$SIZE 2> /dev/null
+		SIZE=$(((RANDOM * RANDOM + MINSIZE) % MAXSIZE))
+	fi
 
-	SIZE=$((RANDOM % 1024))
-	SIZE=$((SIZE + 128))
-	TSIZE=$((TSIZE + SIZE))
-	dd if=/dev/urandom conv=notrunc of="$name" bs=1 count=$SIZE 2> /dev/null
+	ksize=$((SIZE / 1024))
+	rem=$((SIZE - (ksize * 1024)))
+
+	dd if=/dev/urandom of="$name" bs=1024 count=$ksize 2> /dev/null
+	dd if=/dev/urandom conv=notrunc of="$name" bs=1 count=$rem 2> /dev/null
 	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
 
-	echo "Created $name (size $TSIZE) containing data sent by $who"
+	echo "Created $name (size $(du -b "$name")) containing data sent by $who"
 }
 
 run_tests_lo()
@@ -497,9 +512,11 @@ run_tests_lo()
 		return 1
 	fi
 
-	# don't bother testing fallback tcp except for loopback case.
-	if [ ${listener_ns} != ${connector_ns} ]; then
-		return 0
+	if [ $do_tcp -eq 0 ]; then
+		# don't bother testing fallback tcp except for loopback case.
+		if [ ${listener_ns} != ${connector_ns} ]; then
+			return 0
+		fi
 	fi
 
 	do_transfer ${listener_ns} ${connector_ns} MPTCP TCP ${connect_addr} ${local_addr}
@@ -516,6 +533,15 @@ run_tests_lo()
 		return 1
 	fi
 
+	if [ $do_tcp -gt 1 ] ;then
+		do_transfer ${listener_ns} ${connector_ns} TCP TCP ${connect_addr} ${local_addr}
+		lret=$?
+		if [ $lret -ne 0 ]; then
+			ret=$lret
+			return 1
+		fi
+	fi
+
 	return 0
 }
 
-- 
2.26.2

