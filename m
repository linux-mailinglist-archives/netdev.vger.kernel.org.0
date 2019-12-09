Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5041175B1
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 20:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfLIT07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 14:26:59 -0500
Received: from correo.us.es ([193.147.175.20]:58474 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726884AbfLIT06 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 14:26:58 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 304A4120840
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:52 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A4D6DA717
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 20:26:52 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 19A32DA715; Mon,  9 Dec 2019 20:26:52 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29799DA702;
        Mon,  9 Dec 2019 20:26:49 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 20:26:49 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 8B3E041E4800;
        Mon,  9 Dec 2019 20:26:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 08/17] selftests: netfilter: use randomized netns names
Date:   Mon,  9 Dec 2019 20:26:29 +0100
Message-Id: <20191209192638.71184-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191209192638.71184-1-pablo@netfilter.org>
References: <20191209192638.71184-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Using ns0, ns1, etc. isn't a good idea, they might exist already.
Use a random suffix.

Also, older nft versions don't support "-" as alias for stdin, so
use /dev/stdin instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 332 ++++++++++++++-------------
 1 file changed, 176 insertions(+), 156 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 1be55e705780..d7e07f4c3d7f 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -8,9 +8,14 @@ ksft_skip=4
 ret=0
 test_inet_nat=true
 
+sfx=$(mktemp -u "XXXXXXXX")
+ns0="ns0-$sfx"
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+
 cleanup()
 {
-	for i in 0 1 2; do ip netns del ns$i;done
+	for i in 0 1 2; do ip netns del ns$i-"$sfx";done
 }
 
 nft --version > /dev/null 2>&1
@@ -25,40 +30,49 @@ if [ $? -ne 0 ];then
 	exit $ksft_skip
 fi
 
-ip netns add ns0
+ip netns add "$ns0"
 if [ $? -ne 0 ];then
-	echo "SKIP: Could not create net namespace"
+	echo "SKIP: Could not create net namespace $ns0"
 	exit $ksft_skip
 fi
 
 trap cleanup EXIT
 
-ip netns add ns1
-ip netns add ns2
+ip netns add "$ns1"
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace $ns1"
+	exit $ksft_skip
+fi
+
+ip netns add "$ns2"
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace $ns2"
+	exit $ksft_skip
+fi
 
-ip link add veth0 netns ns0 type veth peer name eth0 netns ns1 > /dev/null 2>&1
+ip link add veth0 netns "$ns0" type veth peer name eth0 netns "$ns1" > /dev/null 2>&1
 if [ $? -ne 0 ];then
     echo "SKIP: No virtual ethernet pair device support in kernel"
     exit $ksft_skip
 fi
-ip link add veth1 netns ns0 type veth peer name eth0 netns ns2
+ip link add veth1 netns "$ns0" type veth peer name eth0 netns "$ns2"
 
-ip -net ns0 link set lo up
-ip -net ns0 link set veth0 up
-ip -net ns0 addr add 10.0.1.1/24 dev veth0
-ip -net ns0 addr add dead:1::1/64 dev veth0
+ip -net "$ns0" link set lo up
+ip -net "$ns0" link set veth0 up
+ip -net "$ns0" addr add 10.0.1.1/24 dev veth0
+ip -net "$ns0" addr add dead:1::1/64 dev veth0
 
-ip -net ns0 link set veth1 up
-ip -net ns0 addr add 10.0.2.1/24 dev veth1
-ip -net ns0 addr add dead:2::1/64 dev veth1
+ip -net "$ns0" link set veth1 up
+ip -net "$ns0" addr add 10.0.2.1/24 dev veth1
+ip -net "$ns0" addr add dead:2::1/64 dev veth1
 
 for i in 1 2; do
-  ip -net ns$i link set lo up
-  ip -net ns$i link set eth0 up
-  ip -net ns$i addr add 10.0.$i.99/24 dev eth0
-  ip -net ns$i route add default via 10.0.$i.1
-  ip -net ns$i addr add dead:$i::99/64 dev eth0
-  ip -net ns$i route add default via dead:$i::1
+  ip -net ns$i-$sfx link set lo up
+  ip -net ns$i-$sfx link set eth0 up
+  ip -net ns$i-$sfx addr add 10.0.$i.99/24 dev eth0
+  ip -net ns$i-$sfx route add default via 10.0.$i.1
+  ip -net ns$i-$sfx addr add dead:$i::99/64 dev eth0
+  ip -net ns$i-$sfx route add default via dead:$i::1
 done
 
 bad_counter()
@@ -66,8 +80,9 @@ bad_counter()
 	local ns=$1
 	local counter=$2
 	local expect=$3
+	local tag=$4
 
-	echo "ERROR: $counter counter in $ns has unexpected value (expected $expect)" 1>&2
+	echo "ERROR: $counter counter in $ns has unexpected value (expected $expect) at $tag" 1>&2
 	ip netns exec $ns nft list counter inet filter $counter 1>&2
 }
 
@@ -78,24 +93,24 @@ check_counters()
 
 	cnt=$(ip netns exec $ns nft list counter inet filter ns0in | grep -q "packets 1 bytes 84")
 	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0in "packets 1 bytes 84"
+		bad_counter $ns ns0in "packets 1 bytes 84" "check_counters 1"
 		lret=1
 	fi
 	cnt=$(ip netns exec $ns nft list counter inet filter ns0out | grep -q "packets 1 bytes 84")
 	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0out "packets 1 bytes 84"
+		bad_counter $ns ns0out "packets 1 bytes 84" "check_counters 2"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 104"
 	cnt=$(ip netns exec $ns nft list counter inet filter ns0in6 | grep -q "$expect")
 	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0in6 "$expect"
+		bad_counter $ns ns0in6 "$expect" "check_counters 3"
 		lret=1
 	fi
 	cnt=$(ip netns exec $ns nft list counter inet filter ns0out6 | grep -q "$expect")
 	if [ $? -ne 0 ]; then
-		bad_counter $ns ns0out6 "$expect"
+		bad_counter $ns ns0out6 "$expect" "check_counters 4"
 		lret=1
 	fi
 
@@ -107,41 +122,41 @@ check_ns0_counters()
 	local ns=$1
 	local lret=0
 
-	cnt=$(ip netns exec ns0 nft list counter inet filter ns0in | grep -q "packets 0 bytes 0")
+	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0in | grep -q "packets 0 bytes 0")
 	if [ $? -ne 0 ]; then
-		bad_counter ns0 ns0in "packets 0 bytes 0"
+		bad_counter "$ns0" ns0in "packets 0 bytes 0" "check_ns0_counters 1"
 		lret=1
 	fi
 
-	cnt=$(ip netns exec ns0 nft list counter inet filter ns0in6 | grep -q "packets 0 bytes 0")
+	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0in6 | grep -q "packets 0 bytes 0")
 	if [ $? -ne 0 ]; then
-		bad_counter ns0 ns0in6 "packets 0 bytes 0"
+		bad_counter "$ns0" ns0in6 "packets 0 bytes 0"
 		lret=1
 	fi
 
-	cnt=$(ip netns exec ns0 nft list counter inet filter ns0out | grep -q "packets 0 bytes 0")
+	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0out | grep -q "packets 0 bytes 0")
 	if [ $? -ne 0 ]; then
-		bad_counter ns0 ns0out "packets 0 bytes 0"
+		bad_counter "$ns0" ns0out "packets 0 bytes 0" "check_ns0_counters 2"
 		lret=1
 	fi
-	cnt=$(ip netns exec ns0 nft list counter inet filter ns0out6 | grep -q "packets 0 bytes 0")
+	cnt=$(ip netns exec "$ns0" nft list counter inet filter ns0out6 | grep -q "packets 0 bytes 0")
 	if [ $? -ne 0 ]; then
-		bad_counter ns0 ns0out6 "packets 0 bytes 0"
+		bad_counter "$ns0" ns0out6 "packets 0 bytes 0" "check_ns0_counters3 "
 		lret=1
 	fi
 
 	for dir in "in" "out" ; do
 		expect="packets 1 bytes 84"
-		cnt=$(ip netns exec ns0 nft list counter inet filter ${ns}${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ${ns}${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 $ns$dir "$expect"
+			bad_counter "$ns0" $ns$dir "$expect" "check_ns0_counters 4"
 			lret=1
 		fi
 
 		expect="packets 1 bytes 104"
-		cnt=$(ip netns exec ns0 nft list counter inet filter ${ns}${dir}6 | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ${ns}${dir}6 | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 $ns$dir6 "$expect"
+			bad_counter "$ns0" $ns$dir6 "$expect" "check_ns0_counters 5"
 			lret=1
 		fi
 	done
@@ -152,7 +167,7 @@ check_ns0_counters()
 reset_counters()
 {
 	for i in 0 1 2;do
-		ip netns exec ns$i nft reset counters inet > /dev/null
+		ip netns exec ns$i-$sfx nft reset counters inet > /dev/null
 	done
 }
 
@@ -166,7 +181,7 @@ test_local_dnat6()
 		IPF="ip6"
 	fi
 
-ip netns exec ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table $family nat {
 	chain output {
 		type nat hook output priority 0; policy accept;
@@ -180,7 +195,7 @@ EOF
 	fi
 
 	# ping netns1, expect rewrite to netns2
-	ip netns exec ns0 ping -q -c 1 dead:1::99 > /dev/null
+	ip netns exec "$ns0" ping -q -c 1 dead:1::99 > /dev/null
 	if [ $? -ne 0 ]; then
 		lret=1
 		echo "ERROR: ping6 failed"
@@ -189,18 +204,18 @@ EOF
 
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 ns1$dir "$expect"
+			bad_counter "$ns0" ns1$dir "$expect" "test_local_dnat6 1"
 			lret=1
 		fi
 	done
 
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 ns2$dir "$expect"
+			bad_counter "$ns0" ns2$dir "$expect" "test_local_dnat6 2"
 			lret=1
 		fi
 	done
@@ -208,9 +223,9 @@ EOF
 	# expect 0 count in ns1
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_local_dnat6 3"
 			lret=1
 		fi
 	done
@@ -218,15 +233,15 @@ EOF
 	# expect 1 packet in ns2
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns0$dir "$expect"
+			bad_counter "$ns2" ns0$dir "$expect" "test_local_dnat6 4"
 			lret=1
 		fi
 	done
 
-	test $lret -eq 0 && echo "PASS: ipv6 ping to ns1 was $family NATted to ns2"
-	ip netns exec ns0 nft flush chain ip6 nat output
+	test $lret -eq 0 && echo "PASS: ipv6 ping to $ns1 was $family NATted to $ns2"
+	ip netns exec "$ns0" nft flush chain ip6 nat output
 
 	return $lret
 }
@@ -241,7 +256,7 @@ test_local_dnat()
 		IPF="ip"
 	fi
 
-ip netns exec ns0 nft -f - <<EOF 2>/dev/null
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF 2>/dev/null
 table $family nat {
 	chain output {
 		type nat hook output priority 0; policy accept;
@@ -260,7 +275,7 @@ EOF
 	fi
 
 	# ping netns1, expect rewrite to netns2
-	ip netns exec ns0 ping -q -c 1 10.0.1.99 > /dev/null
+	ip netns exec "$ns0" ping -q -c 1 10.0.1.99 > /dev/null
 	if [ $? -ne 0 ]; then
 		lret=1
 		echo "ERROR: ping failed"
@@ -269,18 +284,18 @@ EOF
 
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 ns1$dir "$expect"
+			bad_counter "$ns0" ns1$dir "$expect" "test_local_dnat 1"
 			lret=1
 		fi
 	done
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 ns2$dir "$expect"
+			bad_counter "$ns0" ns2$dir "$expect" "test_local_dnat 2"
 			lret=1
 		fi
 	done
@@ -288,9 +303,9 @@ EOF
 	# expect 0 count in ns1
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_local_dnat 3"
 			lret=1
 		fi
 	done
@@ -298,19 +313,19 @@ EOF
 	# expect 1 packet in ns2
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns0$dir "$expect"
+			bad_counter "$ns2" ns0$dir "$expect" "test_local_dnat 4"
 			lret=1
 		fi
 	done
 
-	test $lret -eq 0 && echo "PASS: ping to ns1 was $family NATted to ns2"
+	test $lret -eq 0 && echo "PASS: ping to $ns1 was $family NATted to $ns2"
 
-	ip netns exec ns0 nft flush chain $family nat output
+	ip netns exec "$ns0" nft flush chain $family nat output
 
 	reset_counters
-	ip netns exec ns0 ping -q -c 1 10.0.1.99 > /dev/null
+	ip netns exec "$ns0" ping -q -c 1 10.0.1.99 > /dev/null
 	if [ $? -ne 0 ]; then
 		lret=1
 		echo "ERROR: ping failed"
@@ -319,17 +334,17 @@ EOF
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns1$dir "$expect"
+			bad_counter "$ns1" ns1$dir "$expect" "test_local_dnat 5"
 			lret=1
 		fi
 	done
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 ns2$dir "$expect"
+			bad_counter "$ns0" ns2$dir "$expect" "test_local_dnat 6"
 			lret=1
 		fi
 	done
@@ -337,9 +352,9 @@ EOF
 	# expect 1 count in ns1
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns0 ns0$dir "$expect"
+			bad_counter "$ns0" ns0$dir "$expect" "test_local_dnat 7"
 			lret=1
 		fi
 	done
@@ -347,14 +362,14 @@ EOF
 	# expect 0 packet in ns2
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns2$dir "$expect"
+			bad_counter "$ns2" ns0$dir "$expect" "test_local_dnat 8"
 			lret=1
 		fi
 	done
 
-	test $lret -eq 0 && echo "PASS: ping to ns1 OK after $family nat output chain flush"
+	test $lret -eq 0 && echo "PASS: ping to $ns1 OK after $family nat output chain flush"
 
 	return $lret
 }
@@ -366,26 +381,26 @@ test_masquerade6()
 	local natflags=$2
 	local lret=0
 
-	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 
-	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 via ipv6"
+		echo "ERROR: cannot ping $ns1 from $ns2 via ipv6"
 		return 1
 		lret=1
 	fi
 
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns2$dir "$expect"
+			bad_counter "$ns1" ns2$dir "$expect" "test_masquerade6 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade6 2"
 			lret=1
 		fi
 	done
@@ -393,7 +408,7 @@ test_masquerade6()
 	reset_counters
 
 # add masquerading rule
-ip netns exec ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table $family nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
@@ -406,24 +421,24 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $natflags"
+		echo "ERROR: cannot ping $ns1 from $ns2 with active $family masquerade $natflags"
 		lret=1
 	fi
 
 	# ns1 should have seen packets from ns0, due to masquerade
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade6 3"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade6 4"
 			lret=1
 		fi
 	done
@@ -431,32 +446,32 @@ EOF
 	# ns1 should not have seen packets from ns2, due to masquerade
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade6 5"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns0" ns1$dir "$expect" "test_masquerade6 6"
 			lret=1
 		fi
 	done
 
-	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags (attempt 2)"
+		echo "ERROR: cannot ping $ns1 from $ns2 with active ipv6 masquerade $natflags (attempt 2)"
 		lret=1
 	fi
 
-	ip netns exec ns0 nft flush chain $family nat postrouting
+	ip netns exec "$ns0" nft flush chain $family nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade $natflags for ns2"
+	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade $natflags for $ns2"
 
 	return $lret
 }
@@ -467,26 +482,26 @@ test_masquerade()
 	local natflags=$2
 	local lret=0
 
-	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
-	ip netns exec ns0 sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 $natflags"
+		echo "ERROR: cannot ping $ns1 from "$ns2" $natflags"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns2$dir "$expect"
+			bad_counter "$ns1" ns2$dir "$expect" "test_masquerade 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade 2"
 			lret=1
 		fi
 	done
@@ -494,7 +509,7 @@ test_masquerade()
 	reset_counters
 
 # add masquerading rule
-ip netns exec ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table $family nat {
 	chain postrouting {
 		type nat hook postrouting priority 0; policy accept;
@@ -507,24 +522,24 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $natflags"
+		echo "ERROR: cannot ping $ns1 from $ns2 with active $family masquerade $natflags"
 		lret=1
 	fi
 
 	# ns1 should have seen packets from ns0, due to masquerade
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns0${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade 3"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns2" ns1$dir "$expect" "test_masquerade 4"
 			lret=1
 		fi
 	done
@@ -532,32 +547,32 @@ EOF
 	# ns1 should not have seen packets from ns2, due to masquerade
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade 5"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns0" ns1$dir "$expect" "test_masquerade 6"
 			lret=1
 		fi
 	done
 
-	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerade $natflags (attempt 2)"
+		echo "ERROR: cannot ping $ns1 from $ns2 with active ip masquerade $natflags (attempt 2)"
 		lret=1
 	fi
 
-	ip netns exec ns0 nft flush chain $family nat postrouting
+	ip netns exec "$ns0" nft flush chain $family nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: $family IP masquerade $natflags for ns2"
+	test $lret -eq 0 && echo "PASS: $family IP masquerade $natflags for $ns2"
 
 	return $lret
 }
@@ -567,25 +582,25 @@ test_redirect6()
 	local family=$1
 	local lret=0
 
-	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 
-	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannnot ping ns1 from ns2 via ipv6"
+		echo "ERROR: cannnot ping $ns1 from $ns2 via ipv6"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns2$dir "$expect"
+			bad_counter "$ns1" ns2$dir "$expect" "test_redirect6 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns2" ns1$dir "$expect" "test_redirect6 2"
 			lret=1
 		fi
 	done
@@ -593,7 +608,7 @@ test_redirect6()
 	reset_counters
 
 # add redirect rule
-ip netns exec ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table $family nat {
 	chain prerouting {
 		type nat hook prerouting priority 0; policy accept;
@@ -606,18 +621,18 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 via ipv6 with active $family redirect"
+		echo "ERROR: cannot ping $ns1 from $ns2 via ipv6 with active $family redirect"
 		lret=1
 	fi
 
 	# ns1 should have seen no packets from ns2, due to redirection
 	expect="packets 0 bytes 0"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_redirect6 3"
 			lret=1
 		fi
 	done
@@ -625,20 +640,20 @@ EOF
 	# ns0 should have seen packets from ns2, due to masquerade
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_redirect6 4"
 			lret=1
 		fi
 	done
 
-	ip netns exec ns0 nft delete table $family nat
+	ip netns exec "$ns0" nft delete table $family nat
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not delete $family nat table" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: $family IPv6 redirection for ns2"
+	test $lret -eq 0 && echo "PASS: $family IPv6 redirection for $ns2"
 
 	return $lret
 }
@@ -648,26 +663,26 @@ test_redirect()
 	local family=$1
 	local lret=0
 
-	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
-	ip netns exec ns0 sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
+	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2"
+		echo "ERROR: cannot ping $ns1 from $ns2"
 		lret=1
 	fi
 
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns2$dir "$expect"
+			bad_counter "$ns1" $ns2$dir "$expect" "test_redirect 1"
 			lret=1
 		fi
 
-		cnt=$(ip netns exec ns2 nft list counter inet filter ns1${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns2" nft list counter inet filter ns1${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns2 ns1$dir "$expect"
+			bad_counter "$ns2" ns1$dir "$expect" "test_redirect 2"
 			lret=1
 		fi
 	done
@@ -675,7 +690,7 @@ test_redirect()
 	reset_counters
 
 # add redirect rule
-ip netns exec ns0 nft -f - <<EOF
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table $family nat {
 	chain prerouting {
 		type nat hook prerouting priority 0; policy accept;
@@ -688,9 +703,9 @@ EOF
 		return $ksft_skip
 	fi
 
-	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
+	ip netns exec "$ns2" ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-		echo "ERROR: cannot ping ns1 from ns2 with active $family ip redirect"
+		echo "ERROR: cannot ping $ns1 from $ns2 with active $family ip redirect"
 		lret=1
 	fi
 
@@ -698,9 +713,9 @@ EOF
 	expect="packets 0 bytes 0"
 	for dir in "in" "out" ; do
 
-		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns1" ns0$dir "$expect" "test_redirect 3"
 			lret=1
 		fi
 	done
@@ -708,28 +723,28 @@ EOF
 	# ns0 should have seen packets from ns2, due to masquerade
 	expect="packets 1 bytes 84"
 	for dir in "in" "out" ; do
-		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
+		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
-			bad_counter ns1 ns0$dir "$expect"
+			bad_counter "$ns0" ns0$dir "$expect" "test_redirect 4"
 			lret=1
 		fi
 	done
 
-	ip netns exec ns0 nft delete table $family nat
+	ip netns exec "$ns0" nft delete table $family nat
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not delete $family nat table" 1>&2
 		lret=1
 	fi
 
-	test $lret -eq 0 && echo "PASS: $family IP redirection for ns2"
+	test $lret -eq 0 && echo "PASS: $family IP redirection for $ns2"
 
 	return $lret
 }
 
 
-# ip netns exec ns0 ping -c 1 -q 10.0.$i.99
+# ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99
 for i in 0 1 2; do
-ip netns exec ns$i nft -f - <<EOF
+ip netns exec ns$i-$sfx nft -f /dev/stdin <<EOF
 table inet filter {
 	counter ns0in {}
 	counter ns1in {}
@@ -796,18 +811,18 @@ done
 sleep 3
 # test basic connectivity
 for i in 1 2; do
-  ip netns exec ns0 ping -c 1 -q 10.0.$i.99 > /dev/null
+  ip netns exec "$ns0" ping -c 1 -q 10.0.$i.99 > /dev/null
   if [ $? -ne 0 ];then
   	echo "ERROR: Could not reach other namespace(s)" 1>&2
 	ret=1
   fi
 
-  ip netns exec ns0 ping -c 1 -q dead:$i::99 > /dev/null
+  ip netns exec "$ns0" ping -c 1 -q dead:$i::99 > /dev/null
   if [ $? -ne 0 ];then
 	echo "ERROR: Could not reach other namespace(s) via ipv6" 1>&2
 	ret=1
   fi
-  check_counters ns$i
+  check_counters ns$i-$sfx
   if [ $? -ne 0 ]; then
 	ret=1
   fi
@@ -820,7 +835,7 @@ for i in 1 2; do
 done
 
 if [ $ret -eq 0 ];then
-	echo "PASS: netns routing/connectivity: ns0 can reach ns1 and ns2"
+	echo "PASS: netns routing/connectivity: $ns0 can reach $ns1 and $ns2"
 fi
 
 reset_counters
@@ -846,4 +861,9 @@ reset_counters
 $test_inet_nat && test_redirect inet
 $test_inet_nat && test_redirect6 inet
 
+if [ $ret -ne 0 ];then
+	echo -n "FAIL: "
+	nft --version
+fi
+
 exit $ret
-- 
2.11.0

