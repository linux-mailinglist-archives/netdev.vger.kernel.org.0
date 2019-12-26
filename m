Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D330912AD84
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfLZQkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:40:11 -0500
Received: from correo.us.es ([193.147.175.20]:54776 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726697AbfLZQkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 11:40:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CBDC2E34C1
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BCC93DA707
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 17:40:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B25C3DA701; Thu, 26 Dec 2019 17:40:08 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A915FDA707;
        Thu, 26 Dec 2019 17:40:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Dec 2019 17:40:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 882B14251481;
        Thu, 26 Dec 2019 17:40:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 2/4] selftests: netfilter: extend flowtable test script with dnat rule
Date:   Thu, 26 Dec 2019 17:39:54 +0100
Message-Id: <20191226163956.672174-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191226163956.672174-1-pablo@netfilter.org>
References: <20191226163956.672174-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

NAT test currently covers snat (masquerade) only.

Also add a dnat rule and then check that a connecting to the
to-be-dnated address will work.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 39 +++++++++++++++++++---
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 16571ac1dab4..d3e0809ab368 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -226,17 +226,19 @@ check_transfer()
 	return 0
 }
 
-test_tcp_forwarding()
+test_tcp_forwarding_ip()
 {
 	local nsa=$1
 	local nsb=$2
+	local dstip=$3
+	local dstport=$4
 	local lret=0
 
 	ip netns exec $nsb nc -w 5 -l -p 12345 < "$ns2in" > "$ns2out" &
 	lpid=$!
 
 	sleep 1
-	ip netns exec $nsa nc -w 4 10.0.2.99 12345 < "$ns1in" > "$ns1out" &
+	ip netns exec $nsa nc -w 4 "$dstip" "$dstport" < "$ns1in" > "$ns1out" &
 	cpid=$!
 
 	sleep 3
@@ -258,6 +260,28 @@ test_tcp_forwarding()
 	return $lret
 }
 
+test_tcp_forwarding()
+{
+	test_tcp_forwarding_ip "$1" "$2" 10.0.2.99 12345
+
+	return $?
+}
+
+test_tcp_forwarding_nat()
+{
+	local lret
+
+	test_tcp_forwarding_ip "$1" "$2" 10.0.2.99 12345
+	lret=$?
+
+	if [ $lret -eq 0 ] ; then
+		test_tcp_forwarding_ip "$1" "$2" 10.6.6.6 1666
+		lret=$?
+	fi
+
+	return $lret
+}
+
 make_file "$ns1in" "ns1"
 make_file "$ns2in" "ns2"
 
@@ -283,14 +307,19 @@ ip -net ns2 route add 192.168.10.1 via 10.0.2.1
 # Same, but with NAT enabled.
 ip netns exec nsr1 nft -f - <<EOF
 table ip nat {
+   chain prerouting {
+      type nat hook prerouting priority 0; policy accept;
+      meta iif "veth0" ip daddr 10.6.6.6 tcp dport 1666 counter dnat ip to 10.0.2.99:12345
+   }
+
    chain postrouting {
       type nat hook postrouting priority 0; policy accept;
-      meta oifname "veth1" masquerade
+      meta oifname "veth1" counter masquerade
    }
 }
 EOF
 
-test_tcp_forwarding ns1 ns2
+test_tcp_forwarding_nat ns1 ns2
 
 if [ $? -eq 0 ] ;then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT"
@@ -313,7 +342,7 @@ fi
 ip netns exec ns1 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 ip netns exec ns2 sysctl net.ipv4.ip_no_pmtu_disc=0 > /dev/null
 
-test_tcp_forwarding ns1 ns2
+test_tcp_forwarding_nat ns1 ns2
 if [ $? -eq 0 ] ;then
 	echo "PASS: flow offloaded for ns1/ns2 with NAT and pmtu discovery"
 else
-- 
2.11.0

