Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B52444D39E9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:19:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiCITTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238381AbiCITSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:18:30 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB18810F208
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646853441; x=1678389441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pwS+P7GhhUTjI45SEYthGKFuL5gNqe6mm6FuLnmZ+bc=;
  b=b+O+Yonxnj7dNW/beiWvOvmz8TmGoudN+XRC6mMXTf8XoYd7TPBFDqm3
   vomQVuiTjHvZp6fc/FpZpJ/caBrHFWspQQtb6h1kAw+V4kZz2dclq4r+h
   b0uJbf+Y+pjBOVckGgZTBgL1dnAQ6BwHdVzTCqQIBf9ijiNIrS0SQWw6U
   9z0iDR9fbZNZ4DIcAmCuxserOQDohLaClDWF6x6bpuae4jn3e7YfXDiV5
   yvWkg6mTJLK3jbVSyoxx9hS2vxiWwALU8ziVwsBQIaCy6qB8kKdf1EeWw
   2Zzo+z0kOlcNLzQMy24GcUvR2kLgCJebWRXwZfdL2Ht5jiEy0gCGqW0MA
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="237235272"
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="237235272"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
X-IronPort-AV: E=Sophos;i="5.90,168,1643702400"; 
   d="scan'208";a="495957063"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.194.198])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 11:16:46 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        davem@davemloft.net, kuba@kernel.org, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 08/10] selftests: mptcp: join: clarify local/global vars
Date:   Wed,  9 Mar 2022 11:16:34 -0800
Message-Id: <20220309191636.258232-9-mathew.j.martineau@linux.intel.com>
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

Some vars are redefined in different places. Best to avoid this
classical Bash pitfall where variables are accidentally overridden by
other functions because the proper scope has not been defined.

Most issues are with loops: typically 'i' is used in for-loops but if it
is not global, calling a function from a for-loop also doing a for-loop
with the same non local 'i' variable causes troubles because the first
'i' will be assigned to another value. To prevent such issues, the
iterator variable is now declared as local just before the loop. If it
is always done like this, issues are avoided.

To distinct between local and non local variables, all non local ones
are defined at the beginning of the script. The others are now defined
with the "local" keyword.

Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 135 +++++++++++-------
 1 file changed, 83 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 5223f2a752b9..d8dc36fcdb56 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -9,6 +9,9 @@ cin=""
 cinfail=""
 cinsent=""
 cout=""
+capout=""
+ns1=""
+ns2=""
 ksft_skip=4
 timeout_poll=30
 timeout_test=$((timeout_poll * 2 + 1))
@@ -51,12 +54,14 @@ init_partial()
 {
 	capout=$(mktemp)
 
+	local rndh
 	rndh=$(mktemp -u XXXXXX)
 
 	ns1="ns1-$rndh"
 	ns2="ns2-$rndh"
 
-	for netns in "$ns1" "$ns2";do
+	local netns
+	for netns in "$ns1" "$ns2"; do
 		ip netns add $netns || exit $ksft_skip
 		ip -net $netns link set lo up
 		ip netns exec $netns sysctl -q net.mptcp.enabled=1
@@ -77,6 +82,7 @@ init_partial()
 	# ns1eth3    ns2eth3
 	# ns1eth4    ns2eth4
 
+	local i
 	for i in `seq 1 4`; do
 		ip link add ns1eth$i netns "$ns1" type veth peer name ns2eth$i netns "$ns2"
 		ip -net "$ns1" addr add 10.0.$i.1/24 dev ns1eth$i
@@ -95,6 +101,7 @@ init_partial()
 
 init_shapers()
 {
+	local i
 	for i in `seq 1 4`; do
 		tc -n $ns1 qdisc add dev ns1eth$i root netem rate 20mbit delay 1
 		tc -n $ns2 qdisc add dev ns2eth$i root netem rate 20mbit delay 1
@@ -105,6 +112,7 @@ cleanup_partial()
 {
 	rm -f "$capout"
 
+	local netns
 	for netns in "$ns1" "$ns2"; do
 		ip netns del $netns
 		rm -f /tmp/$netns.{nstat,out}
@@ -201,7 +209,8 @@ reset_with_cookies()
 {
 	reset "${1}" || return 1
 
-	for netns in "$ns1" "$ns2";do
+	local netns
+	for netns in "$ns1" "$ns2"; do
 		ip netns exec $netns sysctl -q net.ipv4.tcp_syncookies=2
 	done
 }
@@ -276,10 +285,11 @@ print_file_err()
 
 check_transfer()
 {
-	in=$1
-	out=$2
-	what=$3
+	local in=$1
+	local out=$2
+	local what=$3
 
+	local line
 	cmp -l "$in" "$out" | while read line; do
 		local arr=($line)
 
@@ -301,9 +311,9 @@ check_transfer()
 
 do_ping()
 {
-	listener_ns="$1"
-	connector_ns="$2"
-	connect_addr="$3"
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local connect_addr="$3"
 
 	ip netns exec ${connector_ns} ping -q -c 1 $connect_addr >/dev/null
 	if [ $? -ne 0 ] ; then
@@ -314,15 +324,16 @@ do_ping()
 
 link_failure()
 {
-	ns="$1"
+	local ns="$1"
 
 	if [ -z "$FAILING_LINKS" ]; then
 		l=$((RANDOM%4))
 		FAILING_LINKS=$((l+1))
 	fi
 
+	local l
 	for l in $FAILING_LINKS; do
-		veth="ns1eth$l"
+		local veth="ns1eth$l"
 		ip -net "$ns" link set "$veth" down
 	done
 }
@@ -339,9 +350,10 @@ wait_local_port_listen()
 	local listener_ns="${1}"
 	local port="${2}"
 
-	local port_hex i
-
+	local port_hex
 	port_hex="$(printf "%04X" "${port}")"
+
+	local i
 	for i in $(seq 10); do
 		ip netns exec "${listener_ns}" cat /proc/net/tcp* | \
 			awk "BEGIN {rc=1} {if (\$2 ~ /:${port_hex}\$/ && \$4 ~ /0A/) {rc=0; exit}} END {exit rc}" &&
@@ -352,7 +364,7 @@ wait_local_port_listen()
 
 rm_addr_count()
 {
-	ns=${1}
+	local ns=${1}
 
 	ip netns exec ${ns} nstat -as | grep MPTcpExtRmAddr | awk '{print $2}'
 }
@@ -363,8 +375,8 @@ wait_rm_addr()
 	local ns="${1}"
 	local old_cnt="${2}"
 	local cnt
-	local i
 
+	local i
 	for i in $(seq 10); do
 		cnt=$(rm_addr_count ${ns})
 		[ "$cnt" = "${old_cnt}" ] || break
@@ -404,12 +416,13 @@ pm_nl_add_endpoint()
 {
 	local ns=$1
 	local addr=$2
-	local flags
-	local port
-	local dev
-	local id
+	local flags _flags
+	local port _port
+	local dev _dev
+	local id _id
 	local nr=2
 
+	local p
 	for p in $@
 	do
 		if [ $p = "flags" ]; then
@@ -572,24 +585,26 @@ filter_tcp_from()
 
 do_transfer()
 {
-	listener_ns="$1"
-	connector_ns="$2"
-	cl_proto="$3"
-	srv_proto="$4"
-	connect_addr="$5"
-	test_link_fail="$6"
-	addr_nr_ns1="$7"
-	addr_nr_ns2="$8"
-	speed="$9"
-	sflags="${10}"
-
-	port=$((10000+$TEST_COUNT-1))
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local cl_proto="$3"
+	local srv_proto="$4"
+	local connect_addr="$5"
+	local test_link_fail="$6"
+	local addr_nr_ns1="$7"
+	local addr_nr_ns2="$8"
+	local speed="$9"
+	local sflags="${10}"
+
+	local port=$((10000 + TEST_COUNT - 1))
+	local cappid
 
 	:> "$cout"
 	:> "$sout"
 	:> "$capout"
 
 	if [ $capture -eq 1 ]; then
+		local capuser
 		if [ -z $SUDO_USER ] ; then
 			capuser=""
 		else
@@ -643,7 +658,7 @@ do_transfer()
 				./mptcp_connect -t ${timeout_poll} -l -p $port -s ${srv_proto} \
 					$extra_args ${local_addr} < "$sin" > "$sout" &
 	fi
-	spid=$!
+	local spid=$!
 
 	wait_local_port_listen "${listener_ns}" "${port}"
 
@@ -666,15 +681,16 @@ do_transfer()
 					./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
 						$extra_args $connect_addr > "$cout" &
 	fi
-	cpid=$!
+	local cpid=$!
 
 	# let the mptcp subflow be established in background before
 	# do endpoint manipulation
 	[ $addr_nr_ns1 = "0" -a $addr_nr_ns2 = "0" ] || sleep 1
 
 	if [ $addr_nr_ns1 -gt 0 ]; then
+		local counter=2
+		local add_nr_ns1
 		let add_nr_ns1=addr_nr_ns1
-		counter=2
 		while [ $add_nr_ns1 -gt 0 ]; do
 			local addr
 			if is_v6 "${connect_addr}"; then
@@ -687,13 +703,16 @@ do_transfer()
 			let add_nr_ns1-=1
 		done
 	elif [ $addr_nr_ns1 -lt 0 ]; then
+		local rm_nr_ns1
 		let rm_nr_ns1=-addr_nr_ns1
 		if [ $rm_nr_ns1 -lt 8 ]; then
-			counter=0
+			local counter=0
+			local line
 			pm_nl_show_endpoints ${listener_ns} | while read line; do
 				local arr=($line)
 				local nr=0
 
+				local i
 				for i in ${arr[@]}; do
 					if [ $i = "id" ]; then
 						if [ $counter -eq $rm_nr_ns1 ]; then
@@ -715,7 +734,7 @@ do_transfer()
 		fi
 	fi
 
-	flags="subflow"
+	local flags="subflow"
 	if [[ "${addr_nr_ns2}" = "fullmesh_"* ]]; then
 		flags="${flags},fullmesh"
 		addr_nr_ns2=${addr_nr_ns2:9}
@@ -726,8 +745,9 @@ do_transfer()
 	[ $addr_nr_ns1 -gt 0 -a $addr_nr_ns2 -lt 0 ] && sleep 1
 
 	if [ $addr_nr_ns2 -gt 0 ]; then
+		local add_nr_ns2
 		let add_nr_ns2=addr_nr_ns2
-		counter=3
+		local counter=3
 		while [ $add_nr_ns2 -gt 0 ]; do
 			local addr
 			if is_v6 "${connect_addr}"; then
@@ -740,18 +760,21 @@ do_transfer()
 			let add_nr_ns2-=1
 		done
 	elif [ $addr_nr_ns2 -lt 0 ]; then
-		let rm_nr_ns2=-addr_nr_ns2
+		local rm_nr_ns2
 		if [ $rm_nr_ns2 -lt 8 ]; then
-			counter=0
+			local counter=0
+			local line
 			pm_nl_show_endpoints ${connector_ns} | while read line; do
 				local arr=($line)
 				local nr=0
 
+				local i
 				for i in ${arr[@]}; do
 					if [ $i = "id" ]; then
 						if [ $counter -eq $rm_nr_ns2 ]; then
 							break
 						fi
+						local id rm_addr
 						# rm_addr are serialized, allow the previous one to
 						# complete
 						id=${arr[$nr+1]}
@@ -778,12 +801,16 @@ do_transfer()
 
 	if [ ! -z $sflags ]; then
 		sleep 1
+
+		local netns
 		for netns in "$ns1" "$ns2"; do
+			local line
 			pm_nl_show_endpoints $netns | while read line; do
 				local arr=($line)
 				local nr=0
 				local id
 
+				local i
 				for i in ${arr[@]}; do
 					if [ $i = "id" ]; then
 						id=${arr[$nr+1]}
@@ -796,9 +823,9 @@ do_transfer()
 	fi
 
 	wait $cpid
-	retc=$?
+	local retc=$?
 	wait $spid
-	rets=$?
+	local rets=$?
 
 	if [ $capture -eq 1 ]; then
 	    sleep 1
@@ -848,9 +875,9 @@ do_transfer()
 
 make_file()
 {
-	name=$1
-	who=$2
-	size=$3
+	local name=$1
+	local who=$2
+	local size=$3
 
 	dd if=/dev/urandom of="$name" bs=1024 count=$size 2> /dev/null
 	echo -e "\nMPTCP_TEST_FILE_END_MARKER" >> "$name"
@@ -860,14 +887,16 @@ make_file()
 
 run_tests()
 {
-	listener_ns="$1"
-	connector_ns="$2"
-	connect_addr="$3"
-	test_linkfail="${4:-0}"
-	addr_nr_ns1="${5:-0}"
-	addr_nr_ns2="${6:-0}"
-	speed="${7:-fast}"
-	sflags="${8:-""}"
+	local listener_ns="$1"
+	local connector_ns="$2"
+	local connect_addr="$3"
+	local test_linkfail="${4:-0}"
+	local addr_nr_ns1="${5:-0}"
+	local addr_nr_ns2="${6:-0}"
+	local speed="${7:-fast}"
+	local sflags="${8:-""}"
+
+	local size
 
 	# The values above 2 are reused to make test files
 	# with the given sizes (KB)
@@ -1437,7 +1466,9 @@ wait_attempt_fail()
 	local ns=$1
 
 	while [ $time -lt $timeout_ms ]; do
-		local cnt=$(ip netns exec $ns nstat -as TcpAttemptFails | grep TcpAttemptFails | awk '{print $2}')
+		local cnt
+
+		cnt=$(ip netns exec $ns nstat -as TcpAttemptFails | grep TcpAttemptFails | awk '{print $2}')
 
 		[ "$cnt" = 1 ] && return 1
 		time=$((time + 100))
-- 
2.35.1

