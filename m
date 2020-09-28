Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE78C27B01F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgI1OjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:39:20 -0400
Received: from www62.your-server.de ([213.133.104.62]:59248 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgI1OjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:39:08 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kMuIy-0002e5-8c; Mon, 28 Sep 2020 16:39:04 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 6/6] bpf, selftests: add redirect_neigh selftest
Date:   Mon, 28 Sep 2020 16:38:57 +0200
Message-Id: <ec55cfe8d484fd37b42b8cd8684f3214643ae4fe.1601303057.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1601303057.git.daniel@iogearbox.net>
References: <cover.1601303057.git.daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25940/Sun Sep 27 15:51:36 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a small test that excercises the new redirect_neigh() helper for the
IPv4 and IPv6 case.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 .../selftests/bpf/progs/test_tc_neigh.c       | 144 +++++++++++++++
 tools/testing/selftests/bpf/test_tc_neigh.sh  | 168 ++++++++++++++++++
 2 files changed, 312 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_neigh.c
 create mode 100755 tools/testing/selftests/bpf/test_tc_neigh.sh

diff --git a/tools/testing/selftests/bpf/progs/test_tc_neigh.c b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
new file mode 100644
index 000000000000..889a72c3024f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
@@ -0,0 +1,144 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdint.h>
+#include <stdbool.h>
+
+#include <linux/bpf.h>
+#include <linux/stddef.h>
+#include <linux/pkt_cls.h>
+#include <linux/if_ether.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#ifndef barrier_data
+# define barrier_data(ptr)	asm volatile("": :"r"(ptr) :"memory")
+#endif
+
+#ifndef ctx_ptr
+# define ctx_ptr(field)		(void *)(long)(field)
+#endif
+
+#define dst_to_src_tmp		0xeeddddeeU
+#define src_to_dst_tmp		0xeeffffeeU
+
+#define ip4_src			0xac100164 /* 172.16.1.100 */
+#define ip4_dst			0xac100264 /* 172.16.2.100 */
+
+#define ip6_src			{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+				  0x00, 0x01, 0xde, 0xad, 0xbe, 0xef, 0xca, 0xfe }
+#define ip6_dst			{ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, \
+				  0x00, 0x02, 0xde, 0xad, 0xbe, 0xef, 0xca, 0xfe }
+
+#ifndef v6_equal
+# define v6_equal(a, b)		(a.s6_addr32[0] == b.s6_addr32[0] && \
+				 a.s6_addr32[1] == b.s6_addr32[1] && \
+				 a.s6_addr32[2] == b.s6_addr32[2] && \
+				 a.s6_addr32[3] == b.s6_addr32[3])
+#endif
+
+static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
+					    __be32 addr)
+{
+	void *data_end = ctx_ptr(skb->data_end);
+	void *data = ctx_ptr(skb->data);
+	struct iphdr *ip4h;
+
+	if (data + sizeof(struct ethhdr) > data_end)
+		return false;
+
+	ip4h = (struct iphdr *)(data + sizeof(struct ethhdr));
+	if ((void *)(ip4h + 1) > data_end)
+		return false;
+
+	return ip4h->daddr == addr;
+}
+
+static __always_inline bool is_remote_ep_v6(struct __sk_buff *skb,
+					    struct in6_addr addr)
+{
+	void *data_end = ctx_ptr(skb->data_end);
+	void *data = ctx_ptr(skb->data);
+	struct ipv6hdr *ip6h;
+
+	if (data + sizeof(struct ethhdr) > data_end)
+		return false;
+
+	ip6h = (struct ipv6hdr *)(data + sizeof(struct ethhdr));
+	if ((void *)(ip6h + 1) > data_end)
+		return false;
+
+	return v6_equal(ip6h->daddr, addr);
+}
+
+SEC("chk_neigh") int tc_chk(struct __sk_buff *skb)
+{
+	void *data_end = ctx_ptr(skb->data_end);
+	void *data = ctx_ptr(skb->data);
+	__u32 *raw = data;
+
+	if (data + sizeof(struct ethhdr) > data_end)
+		return TC_ACT_SHOT;
+
+	return !raw[0] && !raw[1] && !raw[2] ? TC_ACT_SHOT : TC_ACT_OK;
+}
+
+SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
+{
+	int idx = dst_to_src_tmp;
+	__u8 zero[ETH_ALEN * 2];
+	bool redirect = false;
+
+	switch (skb->protocol) {
+	case __bpf_constant_htons(ETH_P_IP):
+		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_src));
+		break;
+	case __bpf_constant_htons(ETH_P_IPV6):
+		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_src);
+		break;
+	}
+
+	if (!redirect)
+		return TC_ACT_OK;
+
+	barrier_data(&idx);
+	idx = bpf_ntohl(idx);
+
+	__builtin_memset(&zero, 0, sizeof(zero));
+	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
+		return TC_ACT_SHOT;
+
+	return bpf_redirect_neigh(idx, 0);
+}
+
+SEC("src_ingress") int tc_src(struct __sk_buff *skb)
+{
+	int idx = src_to_dst_tmp;
+	__u8 zero[ETH_ALEN * 2];
+	bool redirect = false;
+
+	switch (skb->protocol) {
+	case __bpf_constant_htons(ETH_P_IP):
+		redirect = is_remote_ep_v4(skb, __bpf_constant_htonl(ip4_dst));
+		break;
+	case __bpf_constant_htons(ETH_P_IPV6):
+		redirect = is_remote_ep_v6(skb, (struct in6_addr)ip6_dst);
+		break;
+	}
+
+	if (!redirect)
+		return TC_ACT_OK;
+
+	barrier_data(&idx);
+	idx = bpf_ntohl(idx);
+
+	__builtin_memset(&zero, 0, sizeof(zero));
+	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
+		return TC_ACT_SHOT;
+
+	return bpf_redirect_neigh(idx, 0);
+}
+
+char __license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_tc_neigh.sh b/tools/testing/selftests/bpf/test_tc_neigh.sh
new file mode 100755
index 000000000000..31d8c3df8b24
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_tc_neigh.sh
@@ -0,0 +1,168 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# This test sets up 3 netns (src <-> fwd <-> dst). There is no direct veth link
+# between src and dst. The netns fwd has veth links to each src and dst. The
+# client is in src and server in dst. The test installs a TC BPF program to each
+# host facing veth in fwd which calls into bpf_redirect_peer() to perform the
+# neigh addr population and redirect; it also installs a dropper prog on the
+# egress side to drop skbs if neigh addrs were not populated.
+
+if [[ $EUID -ne 0 ]]; then
+	echo "This script must be run as root"
+	echo "FAIL"
+	exit 1
+fi
+
+# check that nc, dd, ping, ping6 and timeout are present
+command -v nc >/dev/null 2>&1 || \
+	{ echo >&2 "nc is not available"; exit 1; }
+command -v dd >/dev/null 2>&1 || \
+	{ echo >&2 "dd is not available"; exit 1; }
+command -v timeout >/dev/null 2>&1 || \
+	{ echo >&2 "timeout is not available"; exit 1; }
+command -v ping >/dev/null 2>&1 || \
+	{ echo >&2 "ping is not available"; exit 1; }
+command -v ping6 >/dev/null 2>&1 || \
+	{ echo >&2 "ping6 is not available"; exit 1; }
+
+readonly GREEN='\033[0;92m'
+readonly RED='\033[0;31m'
+readonly NC='\033[0m' # No Color
+
+readonly PING_ARG="-c 3 -w 10 -q"
+
+readonly TIMEOUT=10
+
+readonly NS_SRC="ns-src-$(mktemp -u XXXXXX)"
+readonly NS_FWD="ns-fwd-$(mktemp -u XXXXXX)"
+readonly NS_DST="ns-dst-$(mktemp -u XXXXXX)"
+
+readonly IP4_SRC="172.16.1.100"
+readonly IP4_DST="172.16.2.100"
+
+readonly IP6_SRC="::1:dead:beef:cafe"
+readonly IP6_DST="::2:dead:beef:cafe"
+
+readonly IP4_SLL="169.254.0.1"
+readonly IP4_DLL="169.254.0.2"
+readonly IP4_NET="169.254.0.0"
+
+cleanup()
+{
+	ip netns del ${NS_SRC}
+	ip netns del ${NS_FWD}
+	ip netns del ${NS_DST}
+}
+
+trap cleanup EXIT
+
+set -e
+
+ip netns add "${NS_SRC}"
+ip netns add "${NS_FWD}"
+ip netns add "${NS_DST}"
+
+ip link add veth_src type veth peer name veth_src_fwd
+ip link add veth_dst type veth peer name veth_dst_fwd
+
+ip link set veth_src netns ${NS_SRC}
+ip link set veth_src_fwd netns ${NS_FWD}
+
+ip link set veth_dst netns ${NS_DST}
+ip link set veth_dst_fwd netns ${NS_FWD}
+
+ip -netns ${NS_SRC} addr add ${IP4_SRC}/32 dev veth_src
+ip -netns ${NS_DST} addr add ${IP4_DST}/32 dev veth_dst
+
+# The fwd netns automatically get a v6 LL address / routes, but also needs v4
+# one in order to start ARP probing. IP4_NET route is added to the endpoints
+# so that the ARP processing will reply.
+
+ip -netns ${NS_FWD} addr add ${IP4_SLL}/32 dev veth_src_fwd
+ip -netns ${NS_FWD} addr add ${IP4_DLL}/32 dev veth_dst_fwd
+
+ip -netns ${NS_SRC} addr add ${IP6_SRC}/128 dev veth_src nodad
+ip -netns ${NS_DST} addr add ${IP6_DST}/128 dev veth_dst nodad
+
+ip -netns ${NS_SRC} link set dev veth_src up
+ip -netns ${NS_FWD} link set dev veth_src_fwd up
+
+ip -netns ${NS_DST} link set dev veth_dst up
+ip -netns ${NS_FWD} link set dev veth_dst_fwd up
+
+ip -netns ${NS_SRC} route add ${IP4_DST}/32 dev veth_src scope global
+ip -netns ${NS_SRC} route add ${IP4_NET}/16 dev veth_src scope global
+ip -netns ${NS_FWD} route add ${IP4_SRC}/32 dev veth_src_fwd scope global
+
+ip -netns ${NS_SRC} route add ${IP6_DST}/128 dev veth_src scope global
+ip -netns ${NS_FWD} route add ${IP6_SRC}/128 dev veth_src_fwd scope global
+
+ip -netns ${NS_DST} route add ${IP4_SRC}/32 dev veth_dst scope global
+ip -netns ${NS_DST} route add ${IP4_NET}/16 dev veth_dst scope global
+ip -netns ${NS_FWD} route add ${IP4_DST}/32 dev veth_dst_fwd scope global
+
+ip -netns ${NS_DST} route add ${IP6_SRC}/128 dev veth_dst scope global
+ip -netns ${NS_FWD} route add ${IP6_DST}/128 dev veth_dst_fwd scope global
+
+fmac_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/address)
+fmac_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/address)
+
+ip -netns ${NS_SRC} neigh add ${IP4_DST} dev veth_src lladdr $fmac_src
+ip -netns ${NS_DST} neigh add ${IP4_SRC} dev veth_dst lladdr $fmac_dst
+
+ip -netns ${NS_SRC} neigh add ${IP6_DST} dev veth_src lladdr $fmac_src
+ip -netns ${NS_DST} neigh add ${IP6_SRC} dev veth_dst lladdr $fmac_dst
+
+veth_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/ifindex | awk '{printf "%08x\n", $1}')
+veth_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/ifindex | awk '{printf "%08x\n", $1}')
+
+xxd -p < test_tc_neigh.o   | sed "s/eeddddee/$veth_src/g" | xxd -r -p > test_tc_neigh.x.o
+xxd -p < test_tc_neigh.x.o | sed "s/eeffffee/$veth_dst/g" | xxd -r -p > test_tc_neigh.y.o
+
+ip netns exec ${NS_FWD} tc qdisc add dev veth_src_fwd clsact
+ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd ingress bpf da obj test_tc_neigh.y.o sec src_ingress
+ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd egress  bpf da obj test_tc_neigh.y.o sec chk_neigh
+
+ip netns exec ${NS_FWD} tc qdisc add dev veth_dst_fwd clsact
+ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd ingress bpf da obj test_tc_neigh.y.o sec dst_ingress
+ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd egress  bpf da obj test_tc_neigh.y.o sec chk_neigh
+
+rm -f test_tc_neigh.x.o test_tc_neigh.y.o
+
+ip netns exec ${NS_DST} bash -c "nc -4 -l -p 9004 &"
+ip netns exec ${NS_DST} bash -c "nc -6 -l -p 9006 &"
+
+set +e
+
+TEST="TCPv4 connectivity test"
+ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP4_DST}/9004"
+if [ $? -ne 0 ]; then
+	echo -e "${TEST}: ${RED}FAIL${NC}"
+	exit 1
+fi
+echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+TEST="TCPv6 connectivity test"
+ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP6_DST}/9006"
+if [ $? -ne 0 ]; then
+	echo -e "${TEST}: ${RED}FAIL${NC}"
+	exit 1
+fi
+echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+TEST="ICMPv4 connectivity test"
+ip netns exec ${NS_SRC} ping  $PING_ARG ${IP4_DST}
+if [ $? -ne 0 ]; then
+	echo -e "${TEST}: ${RED}FAIL${NC}"
+	exit 1
+fi
+echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+TEST="ICMPv6 connectivity test"
+ip netns exec ${NS_SRC} ping6 $PING_ARG ${IP6_DST}
+if [ $? -ne 0 ]; then
+	echo -e "${TEST}: ${RED}FAIL${NC}"
+	exit 1
+fi
+echo -e "${TEST}: ${GREEN}PASS${NC}"
-- 
2.21.0

