Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1D64D39ED
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237530AbiCITTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238391AbiCITSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FCE1107E6
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853444; x=1678389444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qgDroA6PbGxxKnlAPCWhF66zQby2AoXXcUxynVGQhBQ=;
  b=VA13Ujsbzq0yA0MkOZqcGgGluvRQwFVML9/gPkwMXx9kN6e3O4rYwwY9
   W4gsAUyXD3aUBYNr5gmGmnXf7lTWCfeO14b8N/jwgZ9sS2mTp1pSHf/Li
   S8Pe8Bi0aNc4bwv6rzWp6/UyXp9SzerR9uGPperll7GMoqlmY4BYGdSTn
   ZKodeF3sO/OiOqCU6Hhs8MyyrID7gyitZxTsVUDE88cyUpmu9JJ7B7oG4
   y0qZCze88lWtfyz6fDhga+COAi592T+ZFigs7/BlpbVId2+k7c28T58AT
   GXUN661RqaTOm5Lpwfql90wxvSE3D7vZs2MpTzTlrt8DwhskssZYEPGmq
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235276"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235276"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:47 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957069"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 10/10] selftests: mptcp: join: make it shellcheck compliant
Date:   Wed,  9 Mar 2022 11:16:36 -0800
Message-Id: <20220309191636.258232-11-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
References: <20220309191636.258232-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

This fixes a few issues reported by ShellCheck:

- SC2068: Double quote array expansions to avoid re-splitting elements.
- SC2206: Quote to prevent word splitting/globbing, or split robustly
          with mapfile or read -a.
- SC2166: Prefer [ p ] && [ q ] as [ p -a q ] is not well defined.
- SC2155: Declare and assign separately to avoid masking return values.
- SC2162: read without -r will mangle backslashes.
- SC2219: Instead of 'let expr', prefer (( expr )) .
- SC2181: Check exit code directly with e.g. 'if mycmd;', not indirectly
          with $?.
- SC2236: Use -n instead of ! -z.
- SC2004: $/${} is unnecessary on arithmetic variables.
- SC2012: Use find instead of ls to better handle non-alphanumeric
          filenames.
- SC2002: Useless cat. Consider 'cmd < file | ..' or 'cmd file | ..'
          instead.

SC2086 (Double quotes to prevent globbing and word splitting) is ignored
because it is controlled for the moment and there are too many to
change.

While at it, also fixed the alignment in one comment.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 126 +++++++++---------
 1 file changed, 66 insertions(+), 60 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f5391d027af2..7314257d248a 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1,6 +1,11 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+# Double quotes to prevent globbing and word splitting is recommended in new
+# code but we accept it, especially because there were too many before having
+# address all other issues detected by shellcheck.
+#shellcheck disable=SC2086
+
 ret=0
 sin=""
 sinfail=""
@@ -76,7 +81,7 @@ init_partial()
 	validate_checksum=$checksum
 	FAILING_LINKS=""
 
-	#  ns1              ns2
+	#  ns1         ns2
 	# ns1eth1    ns2eth1
 	# ns1eth2    ns2eth2
 	# ns1eth3    ns2eth3
@@ -288,12 +293,11 @@ check_transfer()
 	local in=$1
 	local out=$2
 	local what=$3
+	local i a b
 
 	local line
-	cmp -l "$in" "$out" | while read line; do
-		local arr=($line)
-
-		let sum=0${arr[1]}+0${arr[2]}
+	cmp -l "$in" "$out" | while read -r i a b; do
+		local sum=$((0${a} + 0${b}))
 		if [ $check_invert -eq 0 ] || [ $sum -ne $((0xff)) ]; then
 			echo "[ FAIL ] $what does not match (in, out):"
 			print_file_err "$in"
@@ -302,7 +306,7 @@ check_transfer()
 
 			return 1
 		else
-			echo "$what has inverted byte at ${arr[0]}"
+			echo "$what has inverted byte at ${i}"
 		fi
 	done
 
@@ -315,8 +319,7 @@ do_ping()
 	local connector_ns="$2"
 	local connect_addr="$3"
 
-	ip netns exec ${connector_ns} ping -q -c 1 $connect_addr >/dev/null
-	if [ $? -ne 0 ] ; then
+	if ! ip netns exec ${connector_ns} ping -q -c 1 $connect_addr >/dev/null; then
 		echo "$listener_ns -> $connect_addr connectivity [ FAIL ]" 1>&2
 		fail_test
 	fi
@@ -423,26 +426,26 @@ pm_nl_add_endpoint()
 	local nr=2
 
 	local p
-	for p in $@
+	for p in "${@}"
 	do
 		if [ $p = "flags" ]; then
 			eval _flags=\$"$nr"
-			[ ! -z $_flags ]; flags="flags $_flags"
+			[ -n "$_flags" ]; flags="flags $_flags"
 		fi
 		if [ $p = "dev" ]; then
 			eval _dev=\$"$nr"
-			[ ! -z $_dev ]; dev="dev $_dev"
+			[ -n "$_dev" ]; dev="dev $_dev"
 		fi
 		if [ $p = "id" ]; then
 			eval _id=\$"$nr"
-			[ ! -z $_id ]; id="id $_id"
+			[ -n "$_id" ]; id="id $_id"
 		fi
 		if [ $p = "port" ]; then
 			eval _port=\$"$nr"
-			[ ! -z $_port ]; port="port $_port"
+			[ -n "$_port" ]; port="port $_port"
 		fi
 
-		let nr+=1
+		nr=$((nr + 1))
 	done
 
 	if [ $ip_mptcp -eq 1 ]; then
@@ -525,18 +528,18 @@ pm_nl_check_endpoint()
 	while [ -n "$1" ]; do
 		if [ $1 = "flags" ]; then
 			_flags=$2
-			[ ! -z $_flags ]; flags="flags $_flags"
+			[ -n "$_flags" ]; flags="flags $_flags"
 			shift
 		elif [ $1 = "dev" ]; then
-			[ ! -z $2 ]; dev="dev $1"
+			[ -n "$2" ]; dev="dev $1"
 			shift
 		elif [ $1 = "id" ]; then
 			_id=$2
-			[ ! -z $_id ]; id="id $_id"
+			[ -n "$_id" ]; id="id $_id"
 			shift
 		elif [ $1 = "port" ]; then
 			_port=$2
-			[ ! -z $_port ]; port=" port $_port"
+			[ -n "$_port" ]; port=" port $_port"
 			shift
 		fi
 
@@ -675,7 +678,7 @@ do_transfer()
 					./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
 						$extra_args $connect_addr > "$cout" &
 	else
-		cat "$cinfail" | tee "$cinsent" | \
+		tee "$cinsent" < "$cinfail" | \
 			timeout ${timeout_test} \
 				ip netns exec ${connector_ns} \
 					./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
@@ -685,12 +688,13 @@ do_transfer()
 
 	# let the mptcp subflow be established in background before
 	# do endpoint manipulation
-	[ $addr_nr_ns1 = "0" -a $addr_nr_ns2 = "0" ] || sleep 1
+	if [ $addr_nr_ns1 != "0" ] || [ $addr_nr_ns2 != "0" ]; then
+		sleep 1
+	fi
 
 	if [ $addr_nr_ns1 -gt 0 ]; then
 		local counter=2
-		local add_nr_ns1
-		let add_nr_ns1=addr_nr_ns1
+		local add_nr_ns1=${addr_nr_ns1}
 		while [ $add_nr_ns1 -gt 0 ]; do
 			local addr
 			if is_v6 "${connect_addr}"; then
@@ -699,21 +703,21 @@ do_transfer()
 				addr="10.0.$counter.1"
 			fi
 			pm_nl_add_endpoint $ns1 $addr flags signal
-			let counter+=1
-			let add_nr_ns1-=1
+			counter=$((counter + 1))
+			add_nr_ns1=$((add_nr_ns1 - 1))
 		done
 	elif [ $addr_nr_ns1 -lt 0 ]; then
-		local rm_nr_ns1
-		let rm_nr_ns1=-addr_nr_ns1
+		local rm_nr_ns1=$((-addr_nr_ns1))
 		if [ $rm_nr_ns1 -lt 8 ]; then
 			local counter=0
 			local line
-			pm_nl_show_endpoints ${listener_ns} | while read line; do
+			pm_nl_show_endpoints ${listener_ns} | while read -r line; do
+				# shellcheck disable=SC2206 # we do want to split per word
 				local arr=($line)
 				local nr=0
 
 				local i
-				for i in ${arr[@]}; do
+				for i in "${arr[@]}"; do
 					if [ $i = "id" ]; then
 						if [ $counter -eq $rm_nr_ns1 ]; then
 							break
@@ -722,9 +726,9 @@ do_transfer()
 						rm_addr=$(rm_addr_count ${connector_ns})
 						pm_nl_del_endpoint ${listener_ns} $id
 						wait_rm_addr ${connector_ns} ${rm_addr}
-						let counter+=1
+						counter=$((counter + 1))
 					fi
-					let nr+=1
+					nr=$((nr + 1))
 				done
 			done
 		elif [ $rm_nr_ns1 -eq 8 ]; then
@@ -742,11 +746,10 @@ do_transfer()
 
 	# if newly added endpoints must be deleted, give the background msk
 	# some time to created them
-	[ $addr_nr_ns1 -gt 0 -a $addr_nr_ns2 -lt 0 ] && sleep 1
+	[ $addr_nr_ns1 -gt 0 ] && [ $addr_nr_ns2 -lt 0 ] && sleep 1
 
 	if [ $addr_nr_ns2 -gt 0 ]; then
-		local add_nr_ns2
-		let add_nr_ns2=addr_nr_ns2
+		local add_nr_ns2=${addr_nr_ns2}
 		local counter=3
 		while [ $add_nr_ns2 -gt 0 ]; do
 			local addr
@@ -756,20 +759,21 @@ do_transfer()
 				addr="10.0.$counter.2"
 			fi
 			pm_nl_add_endpoint $ns2 $addr flags $flags
-			let counter+=1
-			let add_nr_ns2-=1
+			counter=$((counter + 1))
+			add_nr_ns2=$((add_nr_ns2 - 1))
 		done
 	elif [ $addr_nr_ns2 -lt 0 ]; then
-		local rm_nr_ns2
+		local rm_nr_ns2=$((-addr_nr_ns2))
 		if [ $rm_nr_ns2 -lt 8 ]; then
 			local counter=0
 			local line
-			pm_nl_show_endpoints ${connector_ns} | while read line; do
+			pm_nl_show_endpoints ${connector_ns} | while read -r line; do
+				# shellcheck disable=SC2206 # we do want to split per word
 				local arr=($line)
 				local nr=0
 
 				local i
-				for i in ${arr[@]}; do
+				for i in "${arr[@]}"; do
 					if [ $i = "id" ]; then
 						if [ $counter -eq $rm_nr_ns2 ]; then
 							break
@@ -781,9 +785,9 @@ do_transfer()
 						rm_addr=$(rm_addr_count ${listener_ns})
 						pm_nl_del_endpoint ${connector_ns} $id
 						wait_rm_addr ${listener_ns} ${rm_addr}
-						let counter+=1
+						counter=$((counter + 1))
 					fi
-					let nr+=1
+					nr=$((nr + 1))
 				done
 			done
 		elif [ $rm_nr_ns2 -eq 8 ]; then
@@ -799,23 +803,24 @@ do_transfer()
 		fi
 	fi
 
-	if [ ! -z $sflags ]; then
+	if [ -n "${sflags}" ]; then
 		sleep 1
 
 		local netns
 		for netns in "$ns1" "$ns2"; do
 			local line
-			pm_nl_show_endpoints $netns | while read line; do
+			pm_nl_show_endpoints $netns | while read -r line; do
+				# shellcheck disable=SC2206 # we do want to split per word
 				local arr=($line)
 				local nr=0
 				local id
 
 				local i
-				for i in ${arr[@]}; do
+				for i in "${arr[@]}"; do
 					if [ $i = "id" ]; then
 						id=${arr[$nr+1]}
 					fi
-					let nr+=1
+					nr=$((nr + 1))
 				done
 				pm_nl_change_endpoint $netns $id $sflags
 			done
@@ -909,14 +914,14 @@ run_tests()
 		make_file "$cinfail" "client" $size
 	# create the input file for the failure test when
 	# the first failure test run
-	elif [ "$test_linkfail" -ne 0 -a -z "$cinfail" ]; then
+	elif [ "$test_linkfail" -ne 0 ] && [ -z "$cinfail" ]; then
 		# the client file must be considerably larger
 		# of the maximum expected cwin value, or the
 		# link utilization will be not predicable
 		size=$((RANDOM%2))
 		size=$((size+1))
 		size=$((size*8192))
-		size=$((size + ( $RANDOM % 8192) ))
+		size=$((size + ( RANDOM % 8192) ))
 
 		cinfail=$(mktemp)
 		make_file "$cinfail" "client" $size
@@ -929,7 +934,7 @@ run_tests()
 			sinfail=$(mktemp)
 		fi
 		make_file "$sinfail" "server" $size
-	elif [ "$test_linkfail" -eq 2 -a -z "$sinfail" ]; then
+	elif [ "$test_linkfail" -eq 2 ] && [ -z "$sinfail" ]; then
 		size=$((RANDOM%16))
 		size=$((size+1))
 		size=$((size*2048))
@@ -971,8 +976,8 @@ chk_csum_nr()
 	printf "%-${nr_blank}s %s" " " "sum"
 	count=$(ip netns exec $ns1 nstat -as | grep MPTcpExtDataCsumErr | awk '{print $2}')
 	[ -z "$count" ] && count=0
-	if [ "$count" != $csum_ns1 -a $allow_multi_errors_ns1 -eq 0 ] ||
-	   [ "$count" -lt $csum_ns1 -a $allow_multi_errors_ns1 -eq 1 ]; then
+	if { [ "$count" != $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 0 ]; } ||
+	   { [ "$count" -lt $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 1 ]; }; then
 		echo "[fail] got $count data checksum error[s] expected $csum_ns1"
 		fail_test
 		dump_stats=1
@@ -982,8 +987,8 @@ chk_csum_nr()
 	echo -n " - csum  "
 	count=$(ip netns exec $ns2 nstat -as | grep MPTcpExtDataCsumErr | awk '{print $2}')
 	[ -z "$count" ] && count=0
-	if [ "$count" != $csum_ns2 -a $allow_multi_errors_ns2 -eq 0 ] ||
-	   [ "$count" -lt $csum_ns2 -a $allow_multi_errors_ns2 -eq 1 ]; then
+	if { [ "$count" != $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 0 ]; } ||
+	   { [ "$count" -lt $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 1 ]; }; then
 		echo "[fail] got $count data checksum error[s] expected $csum_ns2"
 		fail_test
 		dump_stats=1
@@ -1190,8 +1195,8 @@ chk_stale_nr()
 	[ -z "$recover_nr" ] && recover_nr=0
 
 	if [ $stale_nr -lt $stale_min ] ||
-	   [ $stale_max -gt 0 -a $stale_nr -gt $stale_max ] ||
-	   [ $((stale_nr - $recover_nr)) -ne $stale_delta ]; then
+	   { [ $stale_max -gt 0 ] && [ $stale_nr -gt $stale_max ]; } ||
+	   [ $((stale_nr - recover_nr)) -ne $stale_delta ]; then
 		echo "[fail] got $stale_nr stale[s] $recover_nr recover[s], " \
 		     " expected stale in range [$stale_min..$stale_max]," \
 		     " stale-recover delta $stale_delta "
@@ -1230,7 +1235,7 @@ chk_add_nr()
 
 	# if the test configured a short timeout tolerate greater then expected
 	# add addrs options, due to retransmissions
-	if [ "$count" != "$add_nr" ] && [ "$timeout" -gt 1 -o "$count" -lt "$add_nr" ]; then
+	if [ "$count" != "$add_nr" ] && { [ "$timeout" -gt 1 ] || [ "$count" -lt "$add_nr" ]; }; then
 		echo "[fail] got $count ADD_ADDR[s] expected $add_nr"
 		fail_test
 		dump_stats=1
@@ -1375,8 +1380,9 @@ chk_rm_nr()
 	count=$(ip netns exec $subflow_ns nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}')
 	[ -z "$count" ] && count=0
 	if [ -n "$simult" ]; then
-		local cnt=$(ip netns exec $addr_ns nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}')
-		local suffix
+		local cnt suffix
+
+		cnt=$(ip netns exec $addr_ns nstat -as | grep MPTcpExtRmSubflow | awk '{print $2}')
 
 		# in case of simult flush, the subflow removal count on each side is
 		# unreliable
@@ -1447,13 +1453,13 @@ chk_link_usage()
 
 	local tx_link tx_total
 	tx_link=$(ip netns exec $ns cat /sys/class/net/$link/statistics/tx_bytes)
-	tx_total=$(ls -l $out | awk '{print $5}')
-	local tx_rate=$((tx_link * 100 / $tx_total))
+	tx_total=$(stat --format=%s $out)
+	local tx_rate=$((tx_link * 100 / tx_total))
 	local tolerance=5
 
 	printf "%-${nr_blank}s %-18s" " " "link usage"
-	if [ $tx_rate -lt $((expected_rate - $tolerance)) -o \
-	     $tx_rate -gt $((expected_rate + $tolerance)) ]; then
+	if [ $tx_rate -lt $((expected_rate - tolerance)) ] || \
+	   [ $tx_rate -gt $((expected_rate + tolerance)) ]; then
 		echo "[fail] got $tx_rate% usage, expected $expected_rate%"
 		fail_test
 	else
-- 
2.35.1

