Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01823ECBF2
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:32:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfKAXcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:32:32 -0400
Received: from mx.aristanetworks.com ([162.210.129.12]:22721 "EHLO
        smtp.aristanetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAXcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:32:32 -0400
Received: from us180.sjc.aristanetworks.com (us180.sjc.aristanetworks.com [172.25.230.4])
        by smtp.aristanetworks.com (Postfix) with ESMTP id E71251E742;
        Fri,  1 Nov 2019 16:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-A; t=1572651150;
        bh=sIOS8yPsHyWJ3F9B/I8OkEJfS0c12w6Iilx6oBAMUX8=;
        h=Date:To:Subject:From:From;
        b=0m3zaYKQSu17jIl+fBmu6VFTQyeZ4oyB2T+QMBhSvY4yxQ7xLz4PHxc5vGgifs1mI
         TcTZOee2yuLXeJ3fUkXeWk/c88/KlBiATqlx64o/DF9xFdyaZEZRiYEmp/HY3UNm31
         aL0I6VGeda0OsGYm70y4E+Q7izaCl3eSr7ZLDD48XnN68X3ssuIu5/vF2FIZzW4unw
         q8nEXyfe2IdWTDVaRe7df6rGtHq3j/Kay717dwYnRFsQ/jDXc2C85awHnVvphCKCbX
         uaN200zhNd2iL8d9HkNWvP+GwwGzv2V6cpYBh/bsOZi0hYiKbjnB6buql99Bbk8XSo
         trIpNpE9371QA==
Received: by us180.sjc.aristanetworks.com (Postfix, from userid 10189)
        id CDDD495C0885; Fri,  1 Nov 2019 16:32:30 -0700 (PDT)
Date:   Fri, 01 Nov 2019 16:32:30 -0700
To:     fruggeri@arista.com, dsahern@gmail.com, davem@davemloft.net,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 1/2] selftest: net: add icmp6 reply address test
User-Agent: Heirloom mailx 12.5 7/5/10
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20191101233230.CDDD495C0885@us180.sjc.aristanetworks.com>
From:   fruggeri@arista.com (Francesco Ruggeri)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Verify that in this scenario

       ------------------------ N2
        |                    |
      ------              ------  N3  ----
      | R1 |              | R2 |------|H2|
      ------              ------      ----
        |                    |
       ------------------------ N1
                 |
                ----
                |H1|
                ----

where H1's default route goes through R1 and R1's default route goes
through R2 over N2, traceroute6 from H1 to H2 reports R2's address
on N2 and not N1.

Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 .../testing/selftests/net/icmp6_reply_addr.sh | 159 ++++++++++++++++++
 2 files changed, 160 insertions(+)
 create mode 100755 tools/testing/selftests/net/icmp6_reply_addr.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 0bd6b23c97ef..daeaeb59d5ca 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -11,6 +11,7 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh
+TEST_PROGS += icmp6_reply_addr.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
diff --git a/tools/testing/selftests/net/icmp6_reply_addr.sh b/tools/testing/selftests/net/icmp6_reply_addr.sh
new file mode 100755
index 000000000000..551834cb9272
--- /dev/null
+++ b/tools/testing/selftests/net/icmp6_reply_addr.sh
@@ -0,0 +1,159 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Verify that in this scenario
+#
+#        ------------------------ N2
+#         |                    |
+#       ------              ------  N3  ----
+#       | R1 |              | R2 |------|H2|
+#       ------              ------      ----
+#         |                    |
+#        ------------------------ N1
+#                  |
+#                 ----
+#                 |H1|
+#                 ----
+#
+# where H1's default route goes through R1 and R1's default route goes
+# through R2 over N2, traceroute6 from H1 to H2 reports R2's address
+# on N2 and not N1.
+#
+# Addresses are assigned as follows:
+#
+# N1: 2000:101::/64
+# N2: 2000:102::/64
+# N3: 2000:103::/64
+#
+# R1's host part of address: 1
+# R2's host part of address: 2
+# H1's host part of address: 3
+# H2's host part of address: 4
+#
+# For example:
+# the IPv6 address of R1's interface on N2 is 2000:102::1/64
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
+create_macvlan_net()
+{
+	net=$1
+	shift
+	nodes=$*
+
+	ip link add ${net} type dummy
+	ip link set ${net} up
+
+	for n in ${nodes}; do
+		ip link add link ${net} dev ${n}${net} type macvlan mode bridge
+		ip link set ${n}${net} netns $n
+		node ${n} ip link set ${n}${net} up
+	done
+}
+
+delete_macvlan_nets()
+{
+	nets=$*
+
+	for n in ${nets}; do
+		ip link del ${n}
+	done
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
+if [ ! -x "$(command -v traceroute6)" ]; then
+        echo "SKIP: Could not run test without traceroute6"
+        exit 0
+fi
+
+create_nodes host1 host2 rtr1 rtr2
+
+create_macvlan_net net1 host1 rtr1 rtr2
+create_veth_net net2 rtr1 rtr2
+create_veth_net net3 rtr2 host2
+
+# Configure interfaces and routes in host1
+node host1 ip -6 addr add 2000:101::3/64 dev host1net1
+node host1 ip -6 route add default via 2000:101::1
+
+# Configure interfaces and routes in rtr1
+node rtr1 ip -6 addr add 2000:101::1/64 dev rtr1net1
+node rtr1 ip -6 addr add 2000:102::1/64 dev rtr1net2
+node rtr1 ip -6 route add default via 2000:102::2
+node rtr1 sysctl net.ipv6.conf.all.forwarding=1 >/dev/null
+
+# Configure interfaces and routes in rtr2
+node rtr2 ip -6 addr add 2000:101::2/64 dev rtr2net1
+node rtr2 ip -6 addr add 2000:102::2/64 dev rtr2net2
+node rtr2 ip -6 addr add 2000:103::2/64 dev rtr2net3
+node rtr2 sysctl net.ipv6.conf.all.forwarding=1 >/dev/null
+
+# Configure interfaces and routes in host2
+node host2 ip -6 addr add 2000:103::4/64 dev host2net3
+node host2 ip -6 route add default via 2000:103::2
+
+# Ping host2 from host1
+echo "Priming the network"
+node host1 ping6 -c5 2000:103::4 >/dev/null
+
+# Traceroute host2 from host1
+echo "Running traceroute6"
+if node host1 traceroute6 2000:103::4 | grep -q 2000:102::2; then
+	ret=0
+	echo "Found 2000:102::2. Test passed."
+else
+	ret=1
+	echo "Did not find 2000:102::2. Test failed."
+fi
+
+delete_macvlan_nets net1
+delete_nodes host1 host2 rtr1 rtr2
+
+exit ${ret}
+
-- 
2.19.1


