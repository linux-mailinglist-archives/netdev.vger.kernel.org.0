Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EE920A4EF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406255AbgFYS04 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:26:56 -0400
Received: from correo.us.es ([193.147.175.20]:33510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406216AbgFYS0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 14:26:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F3CD8FC607
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 20:26:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E309DDA844
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 20:26:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D8975DA722; Thu, 25 Jun 2020 20:26:47 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-106.7 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        LOTS_OF_MONEY,SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 949F0DA78E;
        Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 631AE42EE38F;
        Thu, 25 Jun 2020 20:26:45 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 7/7] selftests: netfilter: add test case for conntrack helper assignment
Date:   Thu, 25 Jun 2020 20:26:35 +0200
Message-Id: <20200625182635.1958-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200625182635.1958-1-pablo@netfilter.org>
References: <20200625182635.1958-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

check that 'nft ... ct helper set <foo>' works:
 1. configure ftp helper via nft and assign it to
    connections on port 2121
 2. check with 'conntrack -L' that the next connection
    has the ftp helper attached to it.

Also add a test for auto-assign (old behaviour).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/Makefile    |   2 +-
 .../netfilter/nft_conntrack_helper.sh         | 175 ++++++++++++++++++
 2 files changed, 176 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/nft_conntrack_helper.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 9c0f758310fe..a179f0dca8ce 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -3,7 +3,7 @@
 
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
 	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh \
-	nft_concat_range.sh \
+	nft_concat_range.sh nft_conntrack_helper.sh \
 	nft_queue.sh
 
 LDLIBS = -lmnl
diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
new file mode 100755
index 000000000000..edf0a48da6bf
--- /dev/null
+++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
@@ -0,0 +1,175 @@
+#!/bin/bash
+#
+# This tests connection tracking helper assignment:
+# 1. can attach ftp helper to a connection from nft ruleset.
+# 2. auto-assign still works.
+#
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+
+sfx=$(mktemp -u "XXXXXXXX")
+ns1="ns1-$sfx"
+ns2="ns2-$sfx"
+testipv6=1
+
+cleanup()
+{
+	ip netns del ${ns1}
+	ip netns del ${ns2}
+}
+
+nft --version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without nft tool"
+	exit $ksft_skip
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+conntrack -V > /dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without conntrack tool"
+	exit $ksft_skip
+fi
+
+which nc >/dev/null 2>&1
+if [ $? -ne 0 ];then
+	echo "SKIP: Could not run test without netcat tool"
+	exit $ksft_skip
+fi
+
+trap cleanup EXIT
+
+ip netns add ${ns1}
+ip netns add ${ns2}
+
+ip link add veth0 netns ${ns1} type veth peer name veth0 netns ${ns2} > /dev/null 2>&1
+if [ $? -ne 0 ];then
+    echo "SKIP: No virtual ethernet pair device support in kernel"
+    exit $ksft_skip
+fi
+
+ip -net ${ns1} link set lo up
+ip -net ${ns1} link set veth0 up
+
+ip -net ${ns2} link set lo up
+ip -net ${ns2} link set veth0 up
+
+ip -net ${ns1} addr add 10.0.1.1/24 dev veth0
+ip -net ${ns1} addr add dead:1::1/64 dev veth0
+
+ip -net ${ns2} addr add 10.0.1.2/24 dev veth0
+ip -net ${ns2} addr add dead:1::2/64 dev veth0
+
+load_ruleset_family() {
+	local family=$1
+	local ns=$2
+
+ip netns exec ${ns} nft -f - <<EOF
+table $family raw {
+	ct helper ftp {
+             type "ftp" protocol tcp
+        }
+	chain pre {
+		type filter hook prerouting priority 0; policy accept;
+		tcp dport 2121 ct helper set "ftp"
+	}
+	chain output {
+		type filter hook output priority 0; policy accept;
+		tcp dport 2121 ct helper set "ftp"
+	}
+}
+EOF
+	return $?
+}
+
+check_for_helper()
+{
+	local netns=$1
+	local message=$2
+	local port=$3
+
+	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
+	if [ $? -ne 0 ] ; then
+		echo "FAIL: ${netns} did not show attached helper $message" 1>&2
+		ret=1
+	fi
+
+	echo "PASS: ${netns} connection on port $port has ftp helper attached" 1>&2
+	return 0
+}
+
+test_helper()
+{
+	local port=$1
+	local msg=$2
+
+	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
+
+	sleep 1
+	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
+
+	check_for_helper "$ns1" "ip $msg" $port
+	check_for_helper "$ns2" "ip $msg" $port
+
+	wait
+
+	if [ $testipv6 -eq 0 ] ;then
+		return 0
+	fi
+
+	ip netns exec ${ns1} conntrack -F 2> /dev/null
+	ip netns exec ${ns2} conntrack -F 2> /dev/null
+
+	sleep 3 | ip netns exec ${ns2} nc -w 2 -6 -l -p $port > /dev/null &
+
+	sleep 1
+	sleep 1 | ip netns exec ${ns1} nc -w 2 -6 dead:1::2 $port > /dev/null &
+
+	check_for_helper "$ns1" "ipv6 $msg" $port
+	check_for_helper "$ns2" "ipv6 $msg" $port
+
+	wait
+}
+
+load_ruleset_family ip ${ns1}
+if [ $? -ne 0 ];then
+	echo "FAIL: ${ns1} cannot load ip ruleset" 1>&2
+	exit 1
+fi
+
+load_ruleset_family ip6 ${ns1}
+if [ $? -ne 0 ];then
+	echo "SKIP: ${ns1} cannot load ip6 ruleset" 1>&2
+	testipv6=0
+fi
+
+load_ruleset_family inet ${ns2}
+if [ $? -ne 0 ];then
+	echo "SKIP: ${ns1} cannot load inet ruleset" 1>&2
+	load_ruleset_family ip ${ns2}
+	if [ $? -ne 0 ];then
+		echo "FAIL: ${ns2} cannot load ip ruleset" 1>&2
+		exit 1
+	fi
+
+	if [ $testipv6 -eq 1 ] ;then
+		load_ruleset_family ip6 ${ns2}
+		if [ $? -ne 0 ];then
+			echo "FAIL: ${ns2} cannot load ip6 ruleset" 1>&2
+			exit 1
+		fi
+	fi
+fi
+
+test_helper 2121 "set via ruleset"
+ip netns exec ${ns1} sysctl -q 'net.netfilter.nf_conntrack_helper=1'
+ip netns exec ${ns2} sysctl -q 'net.netfilter.nf_conntrack_helper=1'
+test_helper 21 "auto-assign"
+
+exit $ret
-- 
2.20.1

