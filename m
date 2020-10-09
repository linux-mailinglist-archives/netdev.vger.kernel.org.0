Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F1B2899E8
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390885AbgJIUnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:43:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:39486 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390510AbgJIUmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:42:54 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzE2-00085H-Qi; Fri, 09 Oct 2020 22:42:50 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 5/6] bpf, selftests: make redirect_neigh test more extensible
Date:   Fri,  9 Oct 2020 22:42:44 +0200
Message-Id: <20201009204245.27905-6-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20201009204245.27905-1-daniel@iogearbox.net>
References: <20201009204245.27905-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25952/Fri Oct  9 15:52:40 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename into test_tc_redirect.sh and move setup and test code into separate
functions so they can be reused for newly added tests in here. Also remove
the crude hack to override ifindex inside the object file via xxd and sed
and just use a simple map instead. Map given iproute2 does not support BTF
fully and therefore neither global data at this point.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/progs/test_tc_neigh.c       |  40 ++--
 tools/testing/selftests/bpf/test_tc_neigh.sh  | 168 ---------------
 .../testing/selftests/bpf/test_tc_redirect.sh | 197 ++++++++++++++++++
 3 files changed, 219 insertions(+), 186 deletions(-)
 delete mode 100755 tools/testing/selftests/bpf/test_tc_neigh.sh
 create mode 100755 tools/testing/selftests/bpf/test_tc_redirect.sh

diff --git a/tools/testing/selftests/bpf/progs/test_tc_neigh.c b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
index 889a72c3024f..fe182616b112 100644
--- a/tools/testing/selftests/bpf/progs/test_tc_neigh.c
+++ b/tools/testing/selftests/bpf/progs/test_tc_neigh.c
@@ -13,17 +13,10 @@
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_endian.h>
 
-#ifndef barrier_data
-# define barrier_data(ptr)	asm volatile("": :"r"(ptr) :"memory")
-#endif
-
 #ifndef ctx_ptr
 # define ctx_ptr(field)		(void *)(long)(field)
 #endif
 
-#define dst_to_src_tmp		0xeeddddeeU
-#define src_to_dst_tmp		0xeeffffeeU
-
 #define ip4_src			0xac100164 /* 172.16.1.100 */
 #define ip4_dst			0xac100264 /* 172.16.2.100 */
 
@@ -39,6 +32,18 @@
 				 a.s6_addr32[3] == b.s6_addr32[3])
 #endif
 
+enum {
+	dev_src,
+	dev_dst,
+};
+
+struct bpf_map_def SEC("maps") ifindex_map = {
+	.type		= BPF_MAP_TYPE_ARRAY,
+	.key_size	= sizeof(int),
+	.value_size	= sizeof(int),
+	.max_entries	= 2,
+};
+
 static __always_inline bool is_remote_ep_v4(struct __sk_buff *skb,
 					    __be32 addr)
 {
@@ -73,7 +78,14 @@ static __always_inline bool is_remote_ep_v6(struct __sk_buff *skb,
 	return v6_equal(ip6h->daddr, addr);
 }
 
-SEC("chk_neigh") int tc_chk(struct __sk_buff *skb)
+static __always_inline int get_dev_ifindex(int which)
+{
+	int *ifindex = bpf_map_lookup_elem(&ifindex_map, &which);
+
+	return ifindex ? *ifindex : 0;
+}
+
+SEC("chk_egress") int tc_chk(struct __sk_buff *skb)
 {
 	void *data_end = ctx_ptr(skb->data_end);
 	void *data = ctx_ptr(skb->data);
@@ -87,7 +99,6 @@ SEC("chk_neigh") int tc_chk(struct __sk_buff *skb)
 
 SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
 {
-	int idx = dst_to_src_tmp;
 	__u8 zero[ETH_ALEN * 2];
 	bool redirect = false;
 
@@ -103,19 +114,15 @@ SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
 	if (!redirect)
 		return TC_ACT_OK;
 
-	barrier_data(&idx);
-	idx = bpf_ntohl(idx);
-
 	__builtin_memset(&zero, 0, sizeof(zero));
 	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
 		return TC_ACT_SHOT;
 
-	return bpf_redirect_neigh(idx, 0);
+	return bpf_redirect_neigh(get_dev_ifindex(dev_src), 0);
 }
 
 SEC("src_ingress") int tc_src(struct __sk_buff *skb)
 {
-	int idx = src_to_dst_tmp;
 	__u8 zero[ETH_ALEN * 2];
 	bool redirect = false;
 
@@ -131,14 +138,11 @@ SEC("src_ingress") int tc_src(struct __sk_buff *skb)
 	if (!redirect)
 		return TC_ACT_OK;
 
-	barrier_data(&idx);
-	idx = bpf_ntohl(idx);
-
 	__builtin_memset(&zero, 0, sizeof(zero));
 	if (bpf_skb_store_bytes(skb, 0, &zero, sizeof(zero), 0) < 0)
 		return TC_ACT_SHOT;
 
-	return bpf_redirect_neigh(idx, 0);
+	return bpf_redirect_neigh(get_dev_ifindex(dev_dst), 0);
 }
 
 char __license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_tc_neigh.sh b/tools/testing/selftests/bpf/test_tc_neigh.sh
deleted file mode 100755
index 31d8c3df8b24..000000000000
--- a/tools/testing/selftests/bpf/test_tc_neigh.sh
+++ /dev/null
@@ -1,168 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#
-# This test sets up 3 netns (src <-> fwd <-> dst). There is no direct veth link
-# between src and dst. The netns fwd has veth links to each src and dst. The
-# client is in src and server in dst. The test installs a TC BPF program to each
-# host facing veth in fwd which calls into bpf_redirect_peer() to perform the
-# neigh addr population and redirect; it also installs a dropper prog on the
-# egress side to drop skbs if neigh addrs were not populated.
-
-if [[ $EUID -ne 0 ]]; then
-	echo "This script must be run as root"
-	echo "FAIL"
-	exit 1
-fi
-
-# check that nc, dd, ping, ping6 and timeout are present
-command -v nc >/dev/null 2>&1 || \
-	{ echo >&2 "nc is not available"; exit 1; }
-command -v dd >/dev/null 2>&1 || \
-	{ echo >&2 "dd is not available"; exit 1; }
-command -v timeout >/dev/null 2>&1 || \
-	{ echo >&2 "timeout is not available"; exit 1; }
-command -v ping >/dev/null 2>&1 || \
-	{ echo >&2 "ping is not available"; exit 1; }
-command -v ping6 >/dev/null 2>&1 || \
-	{ echo >&2 "ping6 is not available"; exit 1; }
-
-readonly GREEN='\033[0;92m'
-readonly RED='\033[0;31m'
-readonly NC='\033[0m' # No Color
-
-readonly PING_ARG="-c 3 -w 10 -q"
-
-readonly TIMEOUT=10
-
-readonly NS_SRC="ns-src-$(mktemp -u XXXXXX)"
-readonly NS_FWD="ns-fwd-$(mktemp -u XXXXXX)"
-readonly NS_DST="ns-dst-$(mktemp -u XXXXXX)"
-
-readonly IP4_SRC="172.16.1.100"
-readonly IP4_DST="172.16.2.100"
-
-readonly IP6_SRC="::1:dead:beef:cafe"
-readonly IP6_DST="::2:dead:beef:cafe"
-
-readonly IP4_SLL="169.254.0.1"
-readonly IP4_DLL="169.254.0.2"
-readonly IP4_NET="169.254.0.0"
-
-cleanup()
-{
-	ip netns del ${NS_SRC}
-	ip netns del ${NS_FWD}
-	ip netns del ${NS_DST}
-}
-
-trap cleanup EXIT
-
-set -e
-
-ip netns add "${NS_SRC}"
-ip netns add "${NS_FWD}"
-ip netns add "${NS_DST}"
-
-ip link add veth_src type veth peer name veth_src_fwd
-ip link add veth_dst type veth peer name veth_dst_fwd
-
-ip link set veth_src netns ${NS_SRC}
-ip link set veth_src_fwd netns ${NS_FWD}
-
-ip link set veth_dst netns ${NS_DST}
-ip link set veth_dst_fwd netns ${NS_FWD}
-
-ip -netns ${NS_SRC} addr add ${IP4_SRC}/32 dev veth_src
-ip -netns ${NS_DST} addr add ${IP4_DST}/32 dev veth_dst
-
-# The fwd netns automatically get a v6 LL address / routes, but also needs v4
-# one in order to start ARP probing. IP4_NET route is added to the endpoints
-# so that the ARP processing will reply.
-
-ip -netns ${NS_FWD} addr add ${IP4_SLL}/32 dev veth_src_fwd
-ip -netns ${NS_FWD} addr add ${IP4_DLL}/32 dev veth_dst_fwd
-
-ip -netns ${NS_SRC} addr add ${IP6_SRC}/128 dev veth_src nodad
-ip -netns ${NS_DST} addr add ${IP6_DST}/128 dev veth_dst nodad
-
-ip -netns ${NS_SRC} link set dev veth_src up
-ip -netns ${NS_FWD} link set dev veth_src_fwd up
-
-ip -netns ${NS_DST} link set dev veth_dst up
-ip -netns ${NS_FWD} link set dev veth_dst_fwd up
-
-ip -netns ${NS_SRC} route add ${IP4_DST}/32 dev veth_src scope global
-ip -netns ${NS_SRC} route add ${IP4_NET}/16 dev veth_src scope global
-ip -netns ${NS_FWD} route add ${IP4_SRC}/32 dev veth_src_fwd scope global
-
-ip -netns ${NS_SRC} route add ${IP6_DST}/128 dev veth_src scope global
-ip -netns ${NS_FWD} route add ${IP6_SRC}/128 dev veth_src_fwd scope global
-
-ip -netns ${NS_DST} route add ${IP4_SRC}/32 dev veth_dst scope global
-ip -netns ${NS_DST} route add ${IP4_NET}/16 dev veth_dst scope global
-ip -netns ${NS_FWD} route add ${IP4_DST}/32 dev veth_dst_fwd scope global
-
-ip -netns ${NS_DST} route add ${IP6_SRC}/128 dev veth_dst scope global
-ip -netns ${NS_FWD} route add ${IP6_DST}/128 dev veth_dst_fwd scope global
-
-fmac_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/address)
-fmac_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/address)
-
-ip -netns ${NS_SRC} neigh add ${IP4_DST} dev veth_src lladdr $fmac_src
-ip -netns ${NS_DST} neigh add ${IP4_SRC} dev veth_dst lladdr $fmac_dst
-
-ip -netns ${NS_SRC} neigh add ${IP6_DST} dev veth_src lladdr $fmac_src
-ip -netns ${NS_DST} neigh add ${IP6_SRC} dev veth_dst lladdr $fmac_dst
-
-veth_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/ifindex | awk '{printf "%08x\n", $1}')
-veth_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/ifindex | awk '{printf "%08x\n", $1}')
-
-xxd -p < test_tc_neigh.o   | sed "s/eeddddee/$veth_src/g" | xxd -r -p > test_tc_neigh.x.o
-xxd -p < test_tc_neigh.x.o | sed "s/eeffffee/$veth_dst/g" | xxd -r -p > test_tc_neigh.y.o
-
-ip netns exec ${NS_FWD} tc qdisc add dev veth_src_fwd clsact
-ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd ingress bpf da obj test_tc_neigh.y.o sec src_ingress
-ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd egress  bpf da obj test_tc_neigh.y.o sec chk_neigh
-
-ip netns exec ${NS_FWD} tc qdisc add dev veth_dst_fwd clsact
-ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd ingress bpf da obj test_tc_neigh.y.o sec dst_ingress
-ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd egress  bpf da obj test_tc_neigh.y.o sec chk_neigh
-
-rm -f test_tc_neigh.x.o test_tc_neigh.y.o
-
-ip netns exec ${NS_DST} bash -c "nc -4 -l -p 9004 &"
-ip netns exec ${NS_DST} bash -c "nc -6 -l -p 9006 &"
-
-set +e
-
-TEST="TCPv4 connectivity test"
-ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP4_DST}/9004"
-if [ $? -ne 0 ]; then
-	echo -e "${TEST}: ${RED}FAIL${NC}"
-	exit 1
-fi
-echo -e "${TEST}: ${GREEN}PASS${NC}"
-
-TEST="TCPv6 connectivity test"
-ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP6_DST}/9006"
-if [ $? -ne 0 ]; then
-	echo -e "${TEST}: ${RED}FAIL${NC}"
-	exit 1
-fi
-echo -e "${TEST}: ${GREEN}PASS${NC}"
-
-TEST="ICMPv4 connectivity test"
-ip netns exec ${NS_SRC} ping  $PING_ARG ${IP4_DST}
-if [ $? -ne 0 ]; then
-	echo -e "${TEST}: ${RED}FAIL${NC}"
-	exit 1
-fi
-echo -e "${TEST}: ${GREEN}PASS${NC}"
-
-TEST="ICMPv6 connectivity test"
-ip netns exec ${NS_SRC} ping6 $PING_ARG ${IP6_DST}
-if [ $? -ne 0 ]; then
-	echo -e "${TEST}: ${RED}FAIL${NC}"
-	exit 1
-fi
-echo -e "${TEST}: ${GREEN}PASS${NC}"
diff --git a/tools/testing/selftests/bpf/test_tc_redirect.sh b/tools/testing/selftests/bpf/test_tc_redirect.sh
new file mode 100755
index 000000000000..6ad441405132
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_tc_redirect.sh
@@ -0,0 +1,197 @@
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
+# check that needed tools are present
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
+command -v perl >/dev/null 2>&1 || \
+	{ echo >&2 "perl is not available"; exit 1; }
+command -v jq >/dev/null 2>&1 || \
+	{ echo >&2 "jq is not available"; exit 1; }
+command -v bpftool >/dev/null 2>&1 || \
+	{ echo >&2 "bpftool is not available"; exit 1; }
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
+netns_cleanup()
+{
+	ip netns del ${NS_SRC}
+	ip netns del ${NS_FWD}
+	ip netns del ${NS_DST}
+}
+
+netns_setup()
+{
+	ip netns add "${NS_SRC}"
+	ip netns add "${NS_FWD}"
+	ip netns add "${NS_DST}"
+
+	ip link add veth_src type veth peer name veth_src_fwd
+	ip link add veth_dst type veth peer name veth_dst_fwd
+
+	ip link set veth_src netns ${NS_SRC}
+	ip link set veth_src_fwd netns ${NS_FWD}
+
+	ip link set veth_dst netns ${NS_DST}
+	ip link set veth_dst_fwd netns ${NS_FWD}
+
+	ip -netns ${NS_SRC} addr add ${IP4_SRC}/32 dev veth_src
+	ip -netns ${NS_DST} addr add ${IP4_DST}/32 dev veth_dst
+
+	# The fwd netns automatically get a v6 LL address / routes, but also
+	# needs v4 one in order to start ARP probing. IP4_NET route is added
+	# to the endpoints so that the ARP processing will reply.
+
+	ip -netns ${NS_FWD} addr add ${IP4_SLL}/32 dev veth_src_fwd
+	ip -netns ${NS_FWD} addr add ${IP4_DLL}/32 dev veth_dst_fwd
+
+	ip -netns ${NS_SRC} addr add ${IP6_SRC}/128 dev veth_src nodad
+	ip -netns ${NS_DST} addr add ${IP6_DST}/128 dev veth_dst nodad
+
+	ip -netns ${NS_SRC} link set dev veth_src up
+	ip -netns ${NS_FWD} link set dev veth_src_fwd up
+
+	ip -netns ${NS_DST} link set dev veth_dst up
+	ip -netns ${NS_FWD} link set dev veth_dst_fwd up
+
+	ip -netns ${NS_SRC} route add ${IP4_DST}/32 dev veth_src scope global
+	ip -netns ${NS_SRC} route add ${IP4_NET}/16 dev veth_src scope global
+	ip -netns ${NS_FWD} route add ${IP4_SRC}/32 dev veth_src_fwd scope global
+
+	ip -netns ${NS_SRC} route add ${IP6_DST}/128 dev veth_src scope global
+	ip -netns ${NS_FWD} route add ${IP6_SRC}/128 dev veth_src_fwd scope global
+
+	ip -netns ${NS_DST} route add ${IP4_SRC}/32 dev veth_dst scope global
+	ip -netns ${NS_DST} route add ${IP4_NET}/16 dev veth_dst scope global
+	ip -netns ${NS_FWD} route add ${IP4_DST}/32 dev veth_dst_fwd scope global
+
+	ip -netns ${NS_DST} route add ${IP6_SRC}/128 dev veth_dst scope global
+	ip -netns ${NS_FWD} route add ${IP6_DST}/128 dev veth_dst_fwd scope global
+
+	fmac_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/address)
+	fmac_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/address)
+
+	ip -netns ${NS_SRC} neigh add ${IP4_DST} dev veth_src lladdr $fmac_src
+	ip -netns ${NS_DST} neigh add ${IP4_SRC} dev veth_dst lladdr $fmac_dst
+
+	ip -netns ${NS_SRC} neigh add ${IP6_DST} dev veth_src lladdr $fmac_src
+	ip -netns ${NS_DST} neigh add ${IP6_SRC} dev veth_dst lladdr $fmac_dst
+}
+
+netns_test_connectivity()
+{
+	set +e
+
+	ip netns exec ${NS_DST} bash -c "nc -4 -l -p 9004 &"
+	ip netns exec ${NS_DST} bash -c "nc -6 -l -p 9006 &"
+
+	TEST="TCPv4 connectivity test"
+	ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP4_DST}/9004"
+	if [ $? -ne 0 ]; then
+		echo -e "${TEST}: ${RED}FAIL${NC}"
+		exit 1
+	fi
+	echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+	TEST="TCPv6 connectivity test"
+	ip netns exec ${NS_SRC} bash -c "timeout ${TIMEOUT} dd if=/dev/zero bs=1000 count=100 > /dev/tcp/${IP6_DST}/9006"
+	if [ $? -ne 0 ]; then
+		echo -e "${TEST}: ${RED}FAIL${NC}"
+		exit 1
+	fi
+	echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+	TEST="ICMPv4 connectivity test"
+	ip netns exec ${NS_SRC} ping  $PING_ARG ${IP4_DST}
+	if [ $? -ne 0 ]; then
+		echo -e "${TEST}: ${RED}FAIL${NC}"
+		exit 1
+	fi
+	echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+	TEST="ICMPv6 connectivity test"
+	ip netns exec ${NS_SRC} ping6 $PING_ARG ${IP6_DST}
+	if [ $? -ne 0 ]; then
+		echo -e "${TEST}: ${RED}FAIL${NC}"
+		exit 1
+	fi
+	echo -e "${TEST}: ${GREEN}PASS${NC}"
+
+	set -e
+}
+
+hex_mem_str()
+{
+	perl -e 'print join(" ", unpack("(H2)8", pack("L", @ARGV)))' $1
+}
+
+netns_setup_neigh()
+{
+	ip netns exec ${NS_FWD} tc qdisc add dev veth_src_fwd clsact
+	ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd ingress bpf da obj test_tc_neigh.o sec src_ingress
+	ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd egress  bpf da obj test_tc_neigh.o sec chk_egress
+
+	ip netns exec ${NS_FWD} tc qdisc add dev veth_dst_fwd clsact
+	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd ingress bpf da obj test_tc_neigh.o sec dst_ingress
+	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd egress  bpf da obj test_tc_neigh.o sec chk_egress
+
+	veth_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/ifindex)
+	veth_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/ifindex)
+
+	progs=$(ip netns exec ${NS_FWD} bpftool net --json | jq -r '.[] | .tc | map(.id) | .[]')
+	for prog in $progs; do
+		map=$(bpftool prog show id $prog --json | jq -r '.map_ids | .? | .[]')
+		if [ ! -z "$map" ]; then
+			bpftool map update id $map key hex $(hex_mem_str 0) value hex $(hex_mem_str $veth_src)
+			bpftool map update id $map key hex $(hex_mem_str 1) value hex $(hex_mem_str $veth_dst)
+		fi
+	done
+}
+
+trap netns_cleanup EXIT
+set -e
+
+netns_setup
+netns_setup_neigh
+netns_test_connectivity
-- 
2.17.1

