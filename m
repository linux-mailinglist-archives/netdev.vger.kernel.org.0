Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03C74F7A82
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243373AbiDGI4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243338AbiDGI4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:56:17 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8947A1B0BC5;
        Thu,  7 Apr 2022 01:54:06 -0700 (PDT)
X-UUID: 9d4593128a1a441ca1faff93d3380491-20220407
X-UUID: 9d4593128a1a441ca1faff93d3380491-20220407
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1652143711; Thu, 07 Apr 2022 16:54:01 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 7 Apr 2022 16:54:01 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Apr
 2022 16:54:00 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Apr 2022 16:53:59 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jesper Dangaard Brouer" <hawk@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        <linux-kernel@vger.kernel.org>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        Lina Wang <lina.wang@mediatek.com>
Subject: [PATCH v5 2/3] selftests net: add UDP GRO fraglist + bpf self-tests
Date:   Thu, 7 Apr 2022 16:47:26 +0800
Message-ID: <20220407084727.10241-2-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20220407084727.10241-1-lina.wang@mediatek.com>
References: <20220407084727.10241-1-lina.wang@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When NETIF_F_GRO_FRAGLIST is enabled and bpf_skb_change_proto is used,
check if udp packets and tcp packets are successfully delivered to user
space. If wrong udp packets are delivered, udpgso_bench_rx will exit
with "initial byte out of range".

Signed-off-by: Lina Wang <lina.wang@mediatek.com>
---
 tools/testing/selftests/net/Makefile          |   1 +
 tools/testing/selftests/net/udpgro_frglist.sh | 101 ++++++++++++++++++
 2 files changed, 102 insertions(+)
 create mode 100755 tools/testing/selftests/net/udpgro_frglist.sh

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3fe2515aa616..0490a14d3b99 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -25,6 +25,7 @@ TEST_PROGS += bareudp.sh
 TEST_PROGS += amt.sh
 TEST_PROGS += unicast_extensions.sh
 TEST_PROGS += udpgro_fwd.sh
+TEST_PROGS += udpgro_frglist.sh
 TEST_PROGS += veth.sh
 TEST_PROGS += ioam6.sh
 TEST_PROGS += gro.sh
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
new file mode 100755
index 000000000000..89bd6abedcf1
--- /dev/null
+++ b/tools/testing/selftests/net/udpgro_frglist.sh
@@ -0,0 +1,101 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Run a series of udpgro benchmarks
+
+readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
+
+cleanup() {
+	local -r jobs="$(jobs -p)"
+	local -r ns="$(ip netns list|grep $PEER_NS)"
+
+	[ -n "${jobs}" ] && kill -INT ${jobs} 2>/dev/null
+	[ -n "$ns" ] && ip netns del $ns 2>/dev/null
+}
+trap cleanup EXIT
+
+run_one() {
+	# use 'rx' as separator between sender args and receiver args
+	local -r all="$@"
+	local -r tx_args=${all%rx*}
+	local rx_args=${all#*rx}
+
+
+
+	ip netns add "${PEER_NS}"
+	ip -netns "${PEER_NS}" link set lo up
+	ip link add type veth
+	ip link set dev veth0 up
+	ip addr add dev veth0 192.168.1.2/24
+	ip addr add dev veth0 2001:db8::2/64 nodad
+
+	ip link set dev veth1 netns "${PEER_NS}"
+	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
+	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
+	ip -netns "${PEER_NS}" link set dev veth1 up
+	ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
+
+
+	ip -n "${PEER_NS}" link set veth1 xdp object ../bpf/xdp_dummy.o section xdp_dummy
+	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
+	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
+	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
+        echo ${rx_args}
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
+
+	# Hack: let bg programs complete the startup
+	sleep 0.1
+	./udpgso_bench_tx ${tx_args}
+}
+
+run_in_netns() {
+	local -r args=$@
+  echo ${args}
+	./in_netns.sh $0 __subprocess ${args}
+}
+
+run_udp() {
+	local -r args=$@
+
+	echo "udp gso - over veth touching data"
+	run_in_netns ${args} -u -S 0 rx -4 -v
+
+	echo "udp gso and gro - over veth touching data"
+	run_in_netns ${args} -S 0 rx -4 -G
+}
+
+run_tcp() {
+	local -r args=$@
+
+	echo "tcp - over veth touching data"
+	run_in_netns ${args} -t rx -4 -t
+}
+
+run_all() {
+	local -r core_args="-l 4"
+	local -r ipv4_args="${core_args} -4  -D 192.168.1.1"
+	local -r ipv6_args="${core_args} -6  -D 2001:db8::1"
+
+	echo "ipv6"
+	run_tcp "${ipv6_args}"
+	run_udp "${ipv6_args}"
+}
+
+if [ ! -f ../bpf/xdp_dummy.o ]; then
+	echo "Missing xdp_dummy helper. Build bpf selftest first"
+	exit -1
+fi
+
+if [ ! -f ../bpf/nat6to4.o ]; then
+	echo "Missing nat6to4 helper. Build bpf selftest first"
+	exit -1
+fi
+
+if [[ $# -eq 0 ]]; then
+	run_all
+elif [[ $1 == "__subprocess" ]]; then
+	shift
+	run_one $@
+else
+	run_in_netns $@
+fi
-- 
2.18.0

