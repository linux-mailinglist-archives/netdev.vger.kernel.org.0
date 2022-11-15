Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B25C3629530
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:03:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiKOKDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:03:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiKOKDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:03:15 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AC424081;
        Tue, 15 Nov 2022 02:03:13 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBM8r5nBwzqSRb;
        Tue, 15 Nov 2022 17:59:24 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 18:03:11 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <andrii@kernel.org>,
        <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, Wang Yufen <wangyufen@huawei.com>,
        =?UTF-8?q?Daniel=20M=C3=BCller?= <deso@posteo.net>
Subject: [PATCH v2 1/2] selftests/net: fix missing xdp_dummy
Date:   Tue, 15 Nov 2022 18:23:19 +0800
Message-ID: <1668507800-45450-2-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After commit afef88e65554 ("selftests/bpf: Store BPF object files with
.bpf.o extension"), we should use xdp_dummy.bpf.o instade of xdp_dummy.o.

In addition, use the BPF_FILE variable to save the BPF object file name,
which can be better identified and modified.

Fixes: afef88e65554 ("selftests/bpf: Store BPF object files with .bpf.o extension")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Cc: Daniel Müller <deso@posteo.net>
---
 tools/testing/selftests/net/udpgro.sh         | 6 ++++--
 tools/testing/selftests/net/udpgro_bench.sh   | 6 ++++--
 tools/testing/selftests/net/udpgro_frglist.sh | 6 ++++--
 tools/testing/selftests/net/udpgro_fwd.sh     | 3 ++-
 tools/testing/selftests/net/veth.sh           | 9 +++++----
 5 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/net/udpgro.sh b/tools/testing/selftests/net/udpgro.sh
index 6a443ca..a66d62e 100755
--- a/tools/testing/selftests/net/udpgro.sh
+++ b/tools/testing/selftests/net/udpgro.sh
@@ -5,6 +5,8 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
+BPF_FILE="../bpf/xdp_dummy.bpf.o"
+
 # set global exit status, but never reset nonzero one.
 check_err()
 {
@@ -34,7 +36,7 @@ cfg_veth() {
 	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
+	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
 }
 
 run_one() {
@@ -195,7 +197,7 @@ run_all() {
 	return $ret
 }
 
-if [ ! -f ../bpf/xdp_dummy.o ]; then
+if [ ! -f ${BPF_FILE} ]; then
 	echo "Missing xdp_dummy helper. Build bpf selftest first"
 	exit -1
 fi
diff --git a/tools/testing/selftests/net/udpgro_bench.sh b/tools/testing/selftests/net/udpgro_bench.sh
index 8a1109a..09c4934 100755
--- a/tools/testing/selftests/net/udpgro_bench.sh
+++ b/tools/testing/selftests/net/udpgro_bench.sh
@@ -5,6 +5,8 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
+BPF_FILE="../bpf/xdp_dummy.bpf.o"
+
 cleanup() {
 	local -r jobs="$(jobs -p)"
 	local -r ns="$(ip netns list|grep $PEER_NS)"
@@ -34,7 +36,7 @@ run_one() {
 	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
 	ip -netns "${PEER_NS}" link set dev veth1 up
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
+	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
 	ip netns exec "${PEER_NS}" ./udpgso_bench_rx -t ${rx_args} -r &
 
@@ -80,7 +82,7 @@ run_all() {
 	run_udp "${ipv6_args}"
 }
 
-if [ ! -f ../bpf/xdp_dummy.o ]; then
+if [ ! -f ${BPF_FILE} ]; then
 	echo "Missing xdp_dummy helper. Build bpf selftest first"
 	exit -1
 fi
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
index 7fe85ba..7f94175 100755
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -5,6 +5,8 @@
 
 readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
 
+BPF_FILE="../bpf/xdp_dummy.bpf.o"
+
 cleanup() {
 	local -r jobs="$(jobs -p)"
 	local -r ns="$(ip netns list|grep $PEER_NS)"
@@ -36,7 +38,7 @@ run_one() {
 	ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
 
 
-	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp
+	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
 	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
 	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
 	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
@@ -81,7 +83,7 @@ run_all() {
 	run_udp "${ipv6_args}"
 }
 
-if [ ! -f ../bpf/xdp_dummy.o ]; then
+if [ ! -f ${BPF_FILE} ]; then
 	echo "Missing xdp_dummy helper. Build bpf selftest first"
 	exit -1
 fi
diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 1bcd82e..c079565 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -1,6 +1,7 @@
 #!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
+BPF_FILE="../bpf/xdp_dummy.bpf.o"
 readonly BASE="ns-$(mktemp -u XXXXXX)"
 readonly SRC=2
 readonly DST=1
@@ -46,7 +47,7 @@ create_ns() {
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V4$ns/24
 		ip -n $BASE$ns addr add dev veth$ns $BM_NET_V6$ns/64 nodad
 	done
-	ip -n $NS_DST link set veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
+	ip -n $NS_DST link set veth$DST xdp object ${BPF_FILE} section xdp 2>/dev/null
 }
 
 create_vxlan_endpoint() {
diff --git a/tools/testing/selftests/net/veth.sh b/tools/testing/selftests/net/veth.sh
index 430895d..c9732f7 100755
--- a/tools/testing/selftests/net/veth.sh
+++ b/tools/testing/selftests/net/veth.sh
@@ -1,6 +1,7 @@
 #!/bin/sh
 # SPDX-License-Identifier: GPL-2.0
 
+BPF_FILE="../bpf/xdp_dummy.bpf.o"
 readonly STATS="$(mktemp -p /tmp ns-XXXXXX)"
 readonly BASE=`basename $STATS`
 readonly SRC=2
@@ -216,7 +217,7 @@ while getopts "hs:" option; do
 	esac
 done
 
-if [ ! -f ../bpf/xdp_dummy.o ]; then
+if [ ! -f ${BPF_FILE} ]; then
 	echo "Missing xdp_dummy helper. Build bpf selftest first"
 	exit 1
 fi
@@ -288,14 +289,14 @@ if [ $CPUS -gt 1 ]; then
 	ip netns exec $NS_DST ethtool -L veth$DST rx 1 tx 2 2>/dev/null
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 1 tx 2 2>/dev/null
 	printf "%-60s" "bad setting: XDP with RX nr less than TX"
-	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
+	ip -n $NS_DST link set dev veth$DST xdp object ${BPF_FILE} \
 		section xdp 2>/dev/null &&\
 		echo "fail - set operation successful ?!?" || echo " ok "
 
 	# the following tests will run with multiple channels active
 	ip netns exec $NS_SRC ethtool -L veth$SRC rx 2
 	ip netns exec $NS_DST ethtool -L veth$DST rx 2
-	ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o \
+	ip -n $NS_DST link set dev veth$DST xdp object ${BPF_FILE} \
 		section xdp 2>/dev/null
 	printf "%-60s" "bad setting: reducing RX nr below peer TX with XDP set"
 	ip netns exec $NS_DST ethtool -L veth$DST rx 1 2>/dev/null &&\
@@ -311,7 +312,7 @@ if [ $CPUS -gt 2 ]; then
 	chk_channels "setting invalid channels nr" $DST 2 2
 fi
 
-ip -n $NS_DST link set dev veth$DST xdp object ../bpf/xdp_dummy.o section xdp 2>/dev/null
+ip -n $NS_DST link set dev veth$DST xdp object ${BPF_FILE} section xdp 2>/dev/null
 chk_gro_flag "with xdp attached - gro flag" $DST on
 chk_gro_flag "        - peer gro flag" $SRC off
 chk_tso_flag "        - tso flag" $SRC off
-- 
1.8.3.1

