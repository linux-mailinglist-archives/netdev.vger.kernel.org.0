Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1EECBF3
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:34:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfKAXeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:34:09 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:27072 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAXeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:34:09 -0400
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [172.25.230.4])
        by smtp.aristanetworks.com (Postfix) with ESMTP id CC8EC1E742;
        Fri,  1 Nov 2019 16:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1572651248;
        bh=2XCvakWmESeZHxE1C5rWSzip2TUf8ygBqL9J00vt+x8=;
        h=Date:To:Subject:From:From;
        b=bCS26NdFIoBH1Al3ZOBk5nanmlWphPSGrv+ef60zvrqC+yIGY9rZExefsfmDQty/R
         6wg5N6wFQNF7+X2FCmHd4kydo1/bhLQ0ejTq9uHBxcjTeP4+7lAnOsxeNafL/zL05Z
         BXqMYewN7pHHwFnPjAvhFoeEitKcBPav7F6tjppCVWj6mog7xWklCjIiQwZ8d4Y0T6
         e9XE0f8M815+G0BCTD/VXh60Vd98OfA/Lo1luAoYTuJy4RE2KtNk9wBRjJcmNrmY5b
         FsZ39HGobpFSguzxjFZt7IhcKBGVo/6ZyMl9dOHlyT87/2oYm0zScWCpHrEjRZiJ7n
         hSf+gjhNjn52A==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id BC15495C0902; Fri,  1 Nov 2019 16:34:08 -0700 (PDT)
Date:   Fri, 01 Nov 2019 16:34:08 -0700
To:     fruggeri@arista.com, dsahern@gmail.com, davem@davemloft.net,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 2/2] selftest: net: add icmp reply address test
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20191101233408.BC15495C0902@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that in this scenario

                   1.0.3.1/24
---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
|H1|--------------------------|R1|--------------------------|H2|
----            N1            ----            N2            ----

where 1.0.3.1/24 and 1.0.1.1/24 are respectively R1's primary and
secondary address on N1, traceroute from H1 to H2 show 1.0.1.1

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 tools/testing/selftests/net/Makefile          |   2 +-
 .../testing/selftests/net/icmp_reply_addr.sh  | 106 ++++++++++++++++++
 2 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/icmp_reply_addr.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index daeaeb59d5ca..3a90084feee4 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -11,7 +11,7 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh
-TEST_PROGS += icmp6_reply_addr.sh
+TEST_PROGS += icmp6_reply_addr.sh icmp_reply_addr.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/icmp_reply_addr.sh b/tools/testing/selftests/net/icmp_reply_addr.sh
new file mode 100755
index 000000000000..3c0ff3c26c07
--- /dev/null
+++ b/tools/testing/selftests/net/icmp_reply_addr.sh
@@ -0,0 +1,106 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify that in this scenario
+#
+#                    1.0.3.1/24
+# ---- 1.0.1.3/24    1.0.1.1/24 ---- 1.0.2.1/24    1.0.2.4/24 ----
+# |H1|--------------------------|R1|--------------------------|H2|
+# ----            N1            ----            N2            ----
+#
+# where 1.0.3.1/24 and 1.0.1.1/24 are respectively R1's primary and
+# secondary address on N1, traceroute from H1 to H2 show 1.0.1.1
+#
+
+####################################################################
+# helpers
+# 
+# Interface on network <net> in node <node> is called <node><net>
+#
+
+node()
+{
+	host=$1
+	shift
+	ip netns exec ${host} $*
+}
+
+create_nodes()
+{
+	for n in $*; do
+		ip netns add $n
+		node $n ip link set lo up
+	done
+}
+
+delete_nodes()
+{
+	for n in $*; do
+		ip netns del $n
+	done
+}
+
+create_veth_net()
+{
+	net=$1
+	h1=$2
+	h2=$3
+
+	ip link add ${h1}${net} type veth peer name ${h2}${net}
+	ip link set ${h1}${net} netns ${h1}
+	node ${h1} ip link set ${h1}${net} up
+	ip link set ${h2}${net} netns ${h2}
+	node ${h2} ip link set ${h2}${net} up
+}
+
+# end helpers
+####################################################################
+
+if [ "$(id -u)" -ne 0 ]; then
+        echo "SKIP: Need root privileges"
+        exit 0
+fi
+
+if [ ! -x "$(command -v traceroute)" ]; then
+        echo "SKIP: Could not run test without traceroute"
+        exit 0
+fi
+
+create_nodes host1 rtr1 host2
+
+create_veth_net net1 host1 rtr1
+create_veth_net net2 rtr1 host2
+
+# Configure interfaces and routes in host1
+node host1 ip addr add 1.0.1.3/24 dev host1net1
+node host1 ip route add default via 1.0.1.1
+
+# Configure interfaces and routes in rtr1
+node rtr1 ip addr add 1.0.3.1/24 dev rtr1net1
+node rtr1 ip addr add 1.0.1.1/24 dev rtr1net1
+node rtr1 ip addr add 1.0.2.1/24 dev rtr1net2
+node rtr1 sysctl net.ipv4.ip_forward=1 >/dev/null
+node rtr1 sysctl net.ipv4.icmp_errors_use_inbound_ifaddr=1 >/dev/null
+
+# Configure interfaces and routes in host2
+node host2 ip addr add 1.0.2.4/24 dev host2net2
+node host2 ip route add default via 1.0.2.1
+
+# Ping host2 from host1
+echo "Priming the network"
+node host1 ping -c5 1.0.2.4 >/dev/null
+
+# Traceroute host2 from host1
+echo "Running traceroute (will take a while)"
+if node host1 traceroute 1.0.2.4 | grep -q 1.0.1.1; then
+	ret=0
+	echo "Found 1.0.1.1. Test passed."
+else
+	ret=1
+	echo "Did not find 1.0.1.1. Test failed."
+fi
+
+delete_nodes host1 rtr1 host2
+
+exit ${ret}
+
-- 
2.19.1


