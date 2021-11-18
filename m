Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33C5C4565B4
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbhKRW3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:43 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58282 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232292AbhKRW3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:37 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A6DCE64B41;
        Thu, 18 Nov 2021 23:24:28 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 11/11] selftests: nft_nat: switch port shadow test cases to socat
Date:   Thu, 18 Nov 2021 23:26:18 +0100
Message-Id: <20211118222618.433273-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

There are now at least three distinct flavours of netcat/nc tool:
'original' version, one version ported from openbsd and nmap-ncat.

The script only works with original because it sets SOREUSEPORT option.

Other nc versions return 'port already in use' error and port shadow test fails:

PASS: inet IPv6 redirection for ns2-hMHcaRvx
nc: bind failed: Address already in use
ERROR: portshadow test default: got reply from "ROUTER", not CLIENT as intended

Switch to socat instead.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_nat.sh | 26 ++++++++++++++------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index c62e4e26252c..d88867d2fed7 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -760,20 +760,20 @@ test_port_shadow()
 	local logmsg=""
 
 	# make shadow entry, from client (ns2), going to (ns1), port 41404, sport 1405.
-	echo "fake-entry" | ip netns exec "$ns2" nc -w 1 -p 1405 -u "$daddrc" 41404 > /dev/null
+	echo "fake-entry" | ip netns exec "$ns2" timeout 1 socat -u STDIN UDP:"$daddrc":41404,sourceport=1405
 
-	echo ROUTER | ip netns exec "$ns0" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
-	nc_r=$!
+	echo ROUTER | ip netns exec "$ns0" timeout 5 socat -u STDIN UDP4-LISTEN:1405 &
+	sc_r=$!
 
-	echo CLIENT | ip netns exec "$ns2" nc -w 5 -u -l -p 1405 >/dev/null 2>&1 &
-	nc_c=$!
+	echo CLIENT | ip netns exec "$ns2" timeout 5 socat -u STDIN UDP4-LISTEN:1405,reuseport &
+	sc_c=$!
 
 	sleep 0.3
 
 	# ns1 tries to connect to ns0:1405.  With default settings this should connect
 	# to client, it matches the conntrack entry created above.
 
-	result=$(echo "" | ip netns exec "$ns1" nc -w 1 -p 41404 -u "$daddrs" 1405)
+	result=$(echo "data" | ip netns exec "$ns1" timeout 1 socat - UDP:"$daddrs":1405,sourceport=41404)
 
 	if [ "$result" = "$expect" ] ;then
 		echo "PASS: portshadow test $test: got reply from ${expect}${logmsg}"
@@ -782,7 +782,7 @@ test_port_shadow()
 		ret=1
 	fi
 
-	kill $nc_r $nc_c 2>/dev/null
+	kill $sc_r $sc_c 2>/dev/null
 
 	# flush udp entries for next test round, if any
 	ip netns exec "$ns0" conntrack -F >/dev/null 2>&1
@@ -852,6 +852,18 @@ test_port_shadowing()
 {
 	local family="ip"
 
+	conntrack -h >/dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run nat port shadowing test without conntrack tool"
+		return
+	fi
+
+	socat -h > /dev/null 2>&1
+	if [ $? -ne 0 ];then
+		echo "SKIP: Could not run nat port shadowing test without socat tool"
+		return
+	fi
+
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 	ip netns exec "$ns0" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
 
-- 
2.30.2

