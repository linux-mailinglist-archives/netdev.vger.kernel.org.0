Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF536486CC7
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 22:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244644AbiAFVvx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 16:51:53 -0500
Received: from mail.netfilter.org ([217.70.188.207]:36148 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239596AbiAFVvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 16:51:51 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2FA266428C;
        Thu,  6 Jan 2022 22:49:03 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/4] selftests: netfilter: switch to socat for tests using -q option
Date:   Thu,  6 Jan 2022 22:51:37 +0100
Message-Id: <20220106215139.170824-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220106215139.170824-1-pablo@netfilter.org>
References: <20220106215139.170824-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

The nc cmd(nmap-ncat) that distributed with Fedora/Red Hat does not have
option -q. This make some tests failed with:

	nc: invalid option -- 'q'

Let's switch to socat which is far more dependable.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../testing/selftests/netfilter/ipip-conntrack-mtu.sh  |  9 +++++----
 tools/testing/selftests/netfilter/nf_nat_edemux.sh     | 10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh b/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
index 4a6f5c3b3215..eb9553e4986b 100755
--- a/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
+++ b/tools/testing/selftests/netfilter/ipip-conntrack-mtu.sh
@@ -41,7 +41,7 @@ checktool (){
 
 checktool "iptables --version" "run test without iptables"
 checktool "ip -Version" "run test without ip tool"
-checktool "which nc" "run test without nc (netcat)"
+checktool "which socat" "run test without socat"
 checktool "ip netns add ${r_a}" "create net namespace"
 
 for n in ${r_b} ${r_w} ${c_a} ${c_b};do
@@ -60,11 +60,12 @@ trap cleanup EXIT
 test_path() {
 	msg="$1"
 
-	ip netns exec ${c_b} nc -n -w 3 -q 3 -u -l -p 5000 > ${rx} < /dev/null &
+	ip netns exec ${c_b} socat -t 3 - udp4-listen:5000,reuseaddr > ${rx} < /dev/null &
 
 	sleep 1
 	for i in 1 2 3; do
-		head -c1400 /dev/zero | tr "\000" "a" | ip netns exec ${c_a} nc -n -w 1 -u 192.168.20.2 5000
+		head -c1400 /dev/zero | tr "\000" "a" | \
+			ip netns exec ${c_a} socat -t 1 -u STDIN UDP:192.168.20.2:5000
 	done
 
 	wait
@@ -189,7 +190,7 @@ ip netns exec ${r_w} sysctl -q net.ipv4.conf.all.forwarding=1 > /dev/null
 #---------------------
 #Now we send a 1400 bytes UDP packet from Client A to Client B:
 
-# clienta:~# head -c1400 /dev/zero | tr "\000" "a" | nc -u 192.168.20.2 5000
+# clienta:~# head -c1400 /dev/zero | tr "\000" "a" | socat -u STDIN UDP:192.168.20.2:5000
 test_path "without"
 
 # The IPv4 stack on Client A already knows the PMTU to Client B, so the
diff --git a/tools/testing/selftests/netfilter/nf_nat_edemux.sh b/tools/testing/selftests/netfilter/nf_nat_edemux.sh
index cfee3b65be0f..1092bbcb1fba 100755
--- a/tools/testing/selftests/netfilter/nf_nat_edemux.sh
+++ b/tools/testing/selftests/netfilter/nf_nat_edemux.sh
@@ -76,23 +76,23 @@ ip netns exec $ns2 ip route add 10.96.0.1 via 192.168.1.1
 sleep 1
 
 # add a persistent connection from the other namespace
-ip netns exec $ns2 nc -q 10 -w 10 192.168.1.1 5201 > /dev/null &
+ip netns exec $ns2 socat -t 10 - TCP:192.168.1.1:5201 > /dev/null &
 
 sleep 1
 
 # ip daddr:dport will be rewritten to 192.168.1.1 5201
 # NAT must reallocate source port 10000 because
 # 192.168.1.2:10000 -> 192.168.1.1:5201 is already in use
-echo test | ip netns exec $ns2 nc -w 3 -q 3 10.96.0.1 443 >/dev/null
+echo test | ip netns exec $ns2 socat -t 3 -u STDIN TCP:10.96.0.1:443 >/dev/null
 ret=$?
 
 kill $iperfs
 
-# Check nc can connect to 10.96.0.1:443 (aka 192.168.1.1:5201).
+# Check socat can connect to 10.96.0.1:443 (aka 192.168.1.1:5201).
 if [ $ret -eq 0 ]; then
-	echo "PASS: nc can connect via NAT'd address"
+	echo "PASS: socat can connect via NAT'd address"
 else
-	echo "FAIL: nc cannot connect via NAT'd address"
+	echo "FAIL: socat cannot connect via NAT'd address"
 	exit 1
 fi
 
-- 
2.30.2

