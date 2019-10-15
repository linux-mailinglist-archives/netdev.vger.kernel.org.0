Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B106DD702D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 09:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727800AbfJOHdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 03:33:02 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42146 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJOHdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 03:33:01 -0400
Received: from penelope.horms.nl (ip4dab7138.direct-adsl.nl [77.171.113.56])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 76BC425B830;
        Tue, 15 Oct 2019 18:32:54 +1100 (AEDT)
Received: by penelope.horms.nl (Postfix, from userid 7100)
        id 7E739E207B5; Tue, 15 Oct 2019 09:32:52 +0200 (CEST)
From:   Simon Horman <horms@verge.net.au>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     lvs-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Wensong Zhang <wensong@linux-vs.org>,
        Julian Anastasov <ja@ssi.bg>,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>,
        Simon Horman <horms@verge.net.au>
Subject: [PATCH 4/6] selftests: netfilter: add ipvs test script
Date:   Tue, 15 Oct 2019 09:32:10 +0200
Message-Id: <20191015073212.19394-5-horms@verge.net.au>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191015073212.19394-1-horms@verge.net.au>
References: <20191015073212.19394-1-horms@verge.net.au>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Test virutal server via directing routing for IPv4.

Tested:

# selftests: netfilter: ipvs.sh
# Testing DR mode...
# ipvs.sh: PASS
ok 6 selftests: netfilter: ipvs.sh

Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Simon Horman <horms@verge.net.au>
---
 tools/testing/selftests/netfilter/Makefile |   2 +-
 tools/testing/selftests/netfilter/ipvs.sh  | 178 +++++++++++++++++++++++++++++
 2 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/netfilter/ipvs.sh

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 4144984ebee5..de1032b5ddea 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -2,6 +2,6 @@
 # Makefile for netfilter selftests
 
 TEST_PROGS := nft_trans_stress.sh nft_nat.sh bridge_brouter.sh \
-	conntrack_icmp_related.sh nft_flowtable.sh
+	conntrack_icmp_related.sh nft_flowtable.sh ipvs.sh
 
 include ../lib.mk
diff --git a/tools/testing/selftests/netfilter/ipvs.sh b/tools/testing/selftests/netfilter/ipvs.sh
new file mode 100755
index 000000000000..3d11d87f3e84
--- /dev/null
+++ b/tools/testing/selftests/netfilter/ipvs.sh
@@ -0,0 +1,178 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# End-to-end ipvs test suite
+# Topology:
+#--------------------------------------------------------------+
+#                      |                                       |
+#         ns0          |         ns1                           |
+#      -----------     |     -----------    -----------        |
+#      | veth01  | --------- | veth10  |    | veth12  |        |
+#      -----------    peer   -----------    -----------        |
+#           |          |                        |              |
+#      -----------     |                        |              |
+#      |  br0    |     |-----------------  peer |--------------|
+#      -----------     |                        |              |
+#           |          |                        |              |
+#      ----------     peer   ----------      -----------       |
+#      |  veth02 | --------- |  veth20 |     | veth21  |       |
+#      ----------      |     ----------      -----------       |
+#                      |         ns2                           |
+#                      |                                       |
+#--------------------------------------------------------------+
+#
+# We assume that all network driver are loaded
+#
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+ret=0
+GREEN='\033[0;92m'
+RED='\033[0;31m'
+NC='\033[0m' # No Color
+
+readonly port=8080
+
+readonly vip_v4=207.175.44.110
+readonly cip_v4=10.0.0.2
+readonly gip_v4=10.0.0.1
+readonly dip_v4=172.16.0.1
+readonly rip_v4=172.16.0.2
+readonly sip_v4=10.0.0.3
+
+readonly infile="$(mktemp)"
+readonly outfile="$(mktemp)"
+readonly datalen=32
+
+sysipvsnet="/proc/sys/net/ipv4/vs/"
+if [ ! -d $sysipvsnet ]; then
+	modprobe -q ip_vs
+	if [ $? -ne 0 ]; then
+		echo "skip: could not run test without ipvs module"
+		exit $ksft_skip
+	fi
+fi
+
+ip -Version > /dev/null 2>&1
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+ipvsadm -v > /dev/null 2>&1
+if [ $? -ne 0 ]; then
+	echo "SKIP: Could not run test without ipvsadm"
+	exit $ksft_skip
+fi
+
+setup() {
+	ip netns add ns0
+	ip netns add ns1
+	ip netns add ns2
+
+	ip link add veth01 netns ns0 type veth peer name veth10 netns ns1
+	ip link add veth02 netns ns0 type veth peer name veth20 netns ns2
+	ip link add veth12 netns ns1 type veth peer name veth21 netns ns2
+
+	ip netns exec ns0 ip link set veth01 up
+	ip netns exec ns0 ip link set veth02 up
+	ip netns exec ns0 ip link add br0 type bridge
+	ip netns exec ns0 ip link set veth01 master br0
+	ip netns exec ns0 ip link set veth02 master br0
+	ip netns exec ns0 ip link set br0 up
+	ip netns exec ns0 ip addr add ${cip_v4}/24 dev br0
+
+	ip netns exec ns1 ip link set lo up
+	ip netns exec ns1 ip link set veth10 up
+	ip netns exec ns1 ip addr add ${gip_v4}/24 dev veth10
+	ip netns exec ns1 ip link set veth12 up
+	ip netns exec ns1 ip addr add ${dip_v4}/24 dev veth12
+
+	ip netns exec ns2 ip link set lo up
+	ip netns exec ns2 ip link set veth21 up
+	ip netns exec ns2 ip addr add ${rip_v4}/24 dev veth21
+	ip netns exec ns2 ip link set veth20 up
+	ip netns exec ns2 ip addr add ${sip_v4}/24 dev veth20
+
+	sleep 1
+
+	dd if=/dev/urandom of="${infile}" bs="${datalen}" count=1 status=none
+}
+
+cleanup() {
+	for i in 0 1 2
+	do
+		ip netns del ns$i > /dev/null 2>&1
+	done
+
+	if [ -f "${outfile}" ]; then
+		rm "${outfile}"
+	fi
+	if [ -f "${infile}" ]; then
+		rm "${infile}"
+	fi
+}
+
+server_listen() {
+	ip netns exec ns2 nc -l -p 8080 > "${outfile}" &
+	server_pid=$!
+	sleep 0.2
+}
+
+client_connect() {
+	ip netns exec ns0 timeout 2 nc -w 1 ${vip_v4} ${port} < "${infile}"
+}
+
+verify_data() {
+	wait "${server_pid}"
+	cmp "$infile" "$outfile" 2>/dev/null
+}
+
+test_service() {
+	server_listen
+	client_connect
+	verify_data
+}
+
+
+test_dr() {
+	ip netns exec ns0 ip route add ${vip_v4} via ${gip_v4} dev br0
+
+	ip netns exec ns1 sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec ns1 ipvsadm -A -t ${vip_v4}:${port} -s rr
+	ip netns exec ns1 ipvsadm -a -t ${vip_v4}:${port} -r ${rip_v4}:${port}
+	ip netns exec ns1 ip addr add ${vip_v4}/32 dev lo:1
+
+	# avoid incorrect arp response
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_ignore=1
+	ip netns exec ns2 sysctl -qw net.ipv4.conf.all.arp_announce=2
+	# avoid reverse route lookup
+	ip netns exec ns2 sysctl -qw  net.ipv4.conf.all.rp_filter=0
+	ip netns exec ns2 sysctl -qw  net.ipv4.conf.veth21.rp_filter=0
+	ip netns exec ns2 ip addr add ${vip_v4}/32 dev lo:1
+
+	test_service
+}
+
+run_tests() {
+	local errors=
+
+	echo "Testing DR mode..."
+	setup
+	test_dr
+	errors=$(( $errors + $? ))
+
+	return $errors
+}
+
+trap cleanup EXIT
+
+cleanup
+run_tests
+
+if [ $? -ne 0 ]; then
+	echo -e "$(basename $0): ${RED}FAIL${NC}"
+	exit 1
+fi
+echo -e "$(basename $0): ${GREEN}PASS${NC}"
+exit 0
-- 
2.11.0

