Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6248322543
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 23:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfERVi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 17:38:29 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:52616 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726671AbfERVi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 17:38:29 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hS72A-0000d6-M6; Sat, 18 May 2019 23:38:26 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pablo@netfilter.org, Florian Westphal <fw@strlen.de>
Subject: [PATCH net] kselftests: netfilter: fix leftover net/net-next merge conflict
Date:   Sat, 18 May 2019 23:33:35 +0200
Message-Id: <20190518213335.8115-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nf-next, I had extended this script to also cover NAT support for the
inet family.

In nf, I extended it to cover a regression with 'fully-random' masquerade.

Make this script work again by resolving the conflicts as needed.

Fixes: 8b4483658364f0 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 David, could you please take this directly?

 Thanks!

 tools/testing/selftests/netfilter/nft_nat.sh | 77 +++++++-------------
 1 file changed, 26 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index 21159f5f3362..14fcf3104c77 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -8,6 +8,11 @@ ksft_skip=4
 ret=0
 test_inet_nat=true
 
+cleanup()
+{
+	for i in 0 1 2; do ip netns del ns$i;done
+}
+
 nft --version > /dev/null 2>&1
 if [ $? -ne 0 ];then
 	echo "SKIP: Could not run test without nft tool"
@@ -21,6 +26,13 @@ if [ $? -ne 0 ];then
 fi
 
 ip netns add ns0
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not create net namespace"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
 ip netns add ns1
 ip netns add ns2
 
@@ -347,7 +359,7 @@ EOF
 test_masquerade6()
 {
 	local family=$1
-	local natflags=$1
+	local natflags=$2
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -392,18 +404,13 @@ EOF
 
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-<<<<<<< HEAD
-		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerading"
-=======
-		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags"
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $natflags"
 		lret=1
 	fi
 
 	# ns1 should have seen packets from ns0, due to masquerade
 	expect="packets 1 bytes 104"
 	for dir in "in6" "out6" ; do
-
 		cnt=$(ip netns exec ns1 nft list counter inet filter ns0${dir} | grep -q "$expect")
 		if [ $? -ne 0 ]; then
 			bad_counter ns1 ns0$dir "$expect"
@@ -433,38 +440,27 @@ EOF
 		fi
 	done
 
-<<<<<<< HEAD
-	ip netns exec ns0 nft flush chain $family nat postrouting
-=======
 	ip netns exec ns2 ping -q -c 1 dead:1::99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
 		echo "ERROR: cannot ping ns1 from ns2 with active ipv6 masquerade $natflags (attempt 2)"
 		lret=1
 	fi
 
-	ip netns exec ns0 nft flush chain ip6 nat postrouting
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+	ip netns exec ns0 nft flush chain $family nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
 
-<<<<<<< HEAD
-	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade for ns2"
-=======
-	test $lret -eq 0 && echo "PASS: IPv6 masquerade $natflags for ns2"
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+	test $lret -eq 0 && echo "PASS: $family IPv6 masquerade $natflags for ns2"
 
 	return $lret
 }
 
 test_masquerade()
 {
-<<<<<<< HEAD
 	local family=$1
-=======
-	local natflags=$1
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+	local natflags=$2
 	local lret=0
 
 	ip netns exec ns0 sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
@@ -509,11 +505,7 @@ EOF
 
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
-<<<<<<< HEAD
-		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerading"
-=======
-		echo "ERROR: cannot ping ns1 from ns2 with active ip masquere $natflags"
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+		echo "ERROR: cannot ping ns1 from ns2 with active $family masquerade $natflags"
 		lret=1
 	fi
 
@@ -549,27 +541,19 @@ EOF
 		fi
 	done
 
-<<<<<<< HEAD
-	ip netns exec ns0 nft flush chain $family nat postrouting
-=======
 	ip netns exec ns2 ping -q -c 1 10.0.1.99 > /dev/null # ping ns2->ns1
 	if [ $? -ne 0 ] ; then
 		echo "ERROR: cannot ping ns1 from ns2 with active ip masquerade $natflags (attempt 2)"
 		lret=1
 	fi
 
-	ip netns exec ns0 nft flush chain ip nat postrouting
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+	ip netns exec ns0 nft flush chain $family nat postrouting
 	if [ $? -ne 0 ]; then
 		echo "ERROR: Could not flush $family nat postrouting" 1>&2
 		lret=1
 	fi
 
-<<<<<<< HEAD
-	test $lret -eq 0 && echo "PASS: $family IP masquerade for ns2"
-=======
-	test $lret -eq 0 && echo "PASS: IP masquerade $natflags for ns2"
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+	test $lret -eq 0 && echo "PASS: $family IP masquerade $natflags for ns2"
 
 	return $lret
 }
@@ -842,21 +826,14 @@ reset_counters
 $test_inet_nat && test_local_dnat inet
 $test_inet_nat && test_local_dnat6 inet
 
+for flags in "" "fully-random"; do
 reset_counters
-<<<<<<< HEAD
-test_masquerade ip
-test_masquerade6 ip6
+test_masquerade ip $flags
+test_masquerade6 ip6 $flags
 reset_counters
-$test_inet_nat && test_masquerade inet
-$test_inet_nat && test_masquerade6 inet
-=======
-test_masquerade ""
-test_masquerade6 ""
-
-reset_counters
-test_masquerade "fully-random"
-test_masquerade6 "fully-random"
->>>>>>> cd8dead0c39457e58ec1d36db93aedca811d48f1
+$test_inet_nat && test_masquerade inet $flags
+$test_inet_nat && test_masquerade6 inet $flags
+done
 
 reset_counters
 test_redirect ip
@@ -865,6 +842,4 @@ reset_counters
 $test_inet_nat && test_redirect inet
 $test_inet_nat && test_redirect6 inet
 
-for i in 0 1 2; do ip netns del ns$i;done
-
 exit $ret
-- 
2.21.0

