Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DA925769F
	for <lists+netdev@lfdr.de>; Mon, 31 Aug 2020 11:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHaJhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 05:37:14 -0400
Received: from correo.us.es ([193.147.175.20]:40446 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgHaJhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Aug 2020 05:37:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A382915AEB9
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95CD0DA792
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 11:36:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88941DA78C; Mon, 31 Aug 2020 11:36:58 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F391DA844;
        Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 24D2F42EF4E0;
        Mon, 31 Aug 2020 11:36:56 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 6/8] selftests: netfilter: simplify command testing
Date:   Mon, 31 Aug 2020 11:36:46 +0200
Message-Id: <20200831093648.20765-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200831093648.20765-1-pablo@netfilter.org>
References: <20200831093648.20765-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Fix some shellcheck SC2181 warnings:
"Check exit code directly with e.g. 'if mycmd;', not indirectly with
$?." as suggested by Stefano Brivio.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../selftests/netfilter/nft_flowtable.sh      | 34 ++++++-------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 1058952d1b36..44a879826236 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -27,8 +27,7 @@ ns2out=""
 log_netns=$(sysctl -n net.netfilter.nf_log_all_netns)
 
 checktool (){
-	$1 > /dev/null 2>&1
-	if [ $? -ne 0 ];then
+	if ! $1 > /dev/null 2>&1; then
 		echo "SKIP: Could not $2"
 		exit $ksft_skip
 	fi
@@ -187,15 +186,13 @@ if [ $? -ne 0 ]; then
 fi
 
 # test basic connectivity
-ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null
-if [ $? -ne 0 ];then
+if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: ns1 cannot reach ns2" 1>&2
   bash
   exit 1
 fi
 
-ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null
-if [ $? -ne 0 ];then
+if ! ip netns exec ns2 ping -c 1 -q 10.0.1.99 > /dev/null; then
   echo "ERROR: ns2 cannot reach ns1" 1>&2
   exit 1
 fi
@@ -230,8 +227,7 @@ check_transfer()
 	out=$2
 	what=$3
 
-	cmp "$in" "$out" > /dev/null 2>&1
-	if [ $? -ne 0 ] ;then
+	if ! cmp "$in" "$out" > /dev/null 2>&1; then
 		echo "FAIL: file mismatch for $what" 1>&2
 		ls -l "$in"
 		ls -l "$out"
@@ -268,13 +264,11 @@ test_tcp_forwarding_ip()
 
 	wait
 
-	check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"
-	if [ $? -ne 0 ];then
+	if ! check_transfer "$ns1in" "$ns2out" "ns1 -> ns2"; then
 		lret=1
 	fi
 
-	check_transfer "$ns2in" "$ns1out" "ns1 <- ns2"
-	if [ $? -ne 0 ];then
+	if ! check_transfer "$ns2in" "$ns1out" "ns1 <- ns2"; then
 		lret=1
 	fi
 
@@ -308,8 +302,7 @@ make_file "$ns2in"
 
 # First test:
 # No PMTU discovery, nsr1 is expected to fragment packets from ns1 to ns2 as needed.
-test_tcp_forwarding ns1 ns2
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding ns1 ns2; then
 	echo "PASS: flow offloaded for ns1/ns2"
 else
 	echo "FAIL: flow offload for ns1/ns2:" 1>&2
@@ -340,9 +333,7 @@ table ip nat {
 }
 EOF
 
-test_tcp_forwarding_nat ns1 ns2
-
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding_nat ns1 ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT" 1>&2
@@ -354,8 +345,7 @@ fi
 # Same as second test, but with PMTU discovery enabled.
 handle=$(ip netns exec nsr1 nft -a list table inet filter | grep something-to-grep-for | cut -d \# -f 2)
 
-ip netns exec nsr1 nft delete rule inet filter forward $handle
-if [ $? -ne 0 ] ;then
+if ! ip netns exec nsr1 nft delete rule inet filter forward $handle; then
 	echo "FAIL: Could not delete large-packet accept rule"
 	exit 1
 fi
@@ -363,8 +353,7 @@ fi
 ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-test_tcp_forwarding_nat ns1 ns2
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding_nat ns1 ns2; then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
 else
 	echo "FAIL: flow offload for ns1/ns2 with NAT and pmtu discovery" 1>&2
@@ -410,8 +399,7 @@ ip -net ns2 route del 192.168.10.1 via 10.0.2.1
 ip -net ns2 route add default via 10.0.2.1
 ip -net ns2 route add default via dead:2::1
 
-test_tcp_forwarding ns1 ns2
-if [ $? -eq 0 ] ;then
+if test_tcp_forwarding ns1 ns2; then
 	echo "PASS: ipsec tunnel mode for ns1/ns2"
 else
 	echo "FAIL: ipsec tunnel mode for ns1/ns2"
-- 
2.20.1

