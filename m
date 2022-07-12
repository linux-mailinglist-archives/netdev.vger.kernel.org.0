Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262C657163E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 11:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiGLJz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 05:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbiGLJzz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 05:55:55 -0400
Received: from smtpservice.6wind.com (unknown [185.13.181.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7BF10AA81B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 02:55:54 -0700 (PDT)
Received: from bretzel (bretzel.dev.6wind.com [10.17.1.57])
        by smtpservice.6wind.com (Postfix) with ESMTPS id D9AC7600AB;
        Tue, 12 Jul 2022 11:55:52 +0200 (CEST)
Received: from dichtel by bretzel with local (Exim 4.92)
        (envelope-from <dichtel@6wind.com>)
        id 1oBCcS-0002qv-Pv; Tue, 12 Jul 2022 11:55:52 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net v2 2/2] selftests/net: test nexthop without gw
Date:   Tue, 12 Jul 2022 11:55:45 +0200
Message-Id: <20220712095545.10947-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220712095545.10947-1-nicolas.dichtel@6wind.com>
References: <9fb5e3df069db50396799a250c4db761b1505dd3.camel@redhat.com>
 <20220712095545.10947-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test implement the scenario described in the previous patch.

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---

v1 -> v2:
 - add linux-kselftest@vger.kernel.org
 - clean trailing whitespaces
 - add a 'trap' on exit
 - remove useless sleep
 - remove useless arp off / fixed mac settings

 tools/testing/selftests/net/Makefile          |   2 +-
 .../selftests/net/fib_nexthop_nongw.sh        | 119 ++++++++++++++++++
 2 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/fib_nexthop_nongw.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index ddad703ace34..db05b3764b77 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -11,7 +11,7 @@ TEST_PROGS += udpgso_bench.sh fib_rule_tests.sh msg_zerocopy.sh psock_snd.sh
 TEST_PROGS += udpgro_bench.sh udpgro.sh test_vxlan_under_vrf.sh reuseport_addr_any.sh
 TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
-TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh
+TEST_PROGS += fin_ack_lat.sh fib_nexthop_multiprefix.sh fib_nexthops.sh fib_nexthop_nongw.sh
 TEST_PROGS += altnames.sh icmp.sh icmp_redirect.sh ip6_gre_headroom.sh
 TEST_PROGS += route_localnet.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
diff --git a/tools/testing/selftests/net/fib_nexthop_nongw.sh b/tools/testing/selftests/net/fib_nexthop_nongw.sh
new file mode 100755
index 000000000000..b7b928b38ce4
--- /dev/null
+++ b/tools/testing/selftests/net/fib_nexthop_nongw.sh
@@ -0,0 +1,119 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# ns: h1               | ns: h2
+#   192.168.0.1/24     |
+#            eth0      |
+#                      |       192.168.1.1/32
+#            veth0 <---|---> veth1
+# Validate source address selection for route without gateway
+
+PAUSE_ON_FAIL=no
+VERBOSE=0
+ret=0
+
+################################################################################
+# helpers
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+			echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+}
+
+run_cmd()
+{
+	local cmd="$*"
+	local out
+	local rc
+
+	if [ "$VERBOSE" = "1" ]; then
+		echo "COMMAND: $cmd"
+	fi
+
+	out=$(eval $cmd 2>&1)
+	rc=$?
+	if [ "$VERBOSE" = "1" -a -n "$out" ]; then
+		echo "$out"
+	fi
+
+	[ "$VERBOSE" = "1" ] && echo
+
+	return $rc
+}
+
+################################################################################
+# config
+setup()
+{
+	ip netns add h1
+	ip -n h1 link set lo up
+	ip netns add h2
+	ip -n h2 link set lo up
+
+	# Add a fake eth0 to support an ip address
+	ip -n h1 link add name eth0 type dummy
+	ip -n h1 link set eth0 up
+	ip -n h1 address add 192.168.0.1/24 dev eth0
+
+	# Configure veths (same @mac, arp off)
+	ip -n h1 link add name veth0 type veth peer name veth1 netns h2
+	ip -n h1 link set veth0 up
+
+	ip -n h2 link set veth1 up
+
+	# Configure @IP in the peer netns
+	ip -n h2 address add 192.168.1.1/32 dev veth1
+	ip -n h2 route add default dev veth1
+
+	# Add a nexthop without @gw and use it in a route
+	ip -n h1 nexthop add id 1 dev veth0
+	ip -n h1 route add 192.168.1.1 nhid 1
+}
+
+cleanup()
+{
+	ip netns del h1 2>/dev/null
+	ip netns del h2 2>/dev/null
+}
+
+trap cleanup EXIT
+
+################################################################################
+# main
+
+while getopts :pv o
+do
+	case $o in
+		p) PAUSE_ON_FAIL=yes;;
+		v) VERBOSE=1;;
+	esac
+done
+
+cleanup
+setup
+
+run_cmd ip -netns h1 route get 192.168.1.1
+log_test $? 0 "nexthop: get route with nexthop without gw"
+run_cmd ip netns exec h1 ping -c1 192.168.1.1
+log_test $? 0 "nexthop: ping through nexthop without gw"
+
+exit $ret
-- 
2.33.0

