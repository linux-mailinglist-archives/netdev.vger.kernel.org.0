Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1C2167F87A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 15:07:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbjA1OHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 09:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234682AbjA1OHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 09:07:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95FBB518DD;
        Sat, 28 Jan 2023 06:07:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2436B60BB8;
        Sat, 28 Jan 2023 14:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEEBDC433EF;
        Sat, 28 Jan 2023 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674914833;
        bh=rNKhBgBRjvIPe7CLLQhb+D26KqyJAWlKwV/g8nFDMz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6q+UCr2CKV1WRhHtVa5piI6g8gQZ392938Qr1UqtCTz94hZpdjFIVI4k8Y6bk46K
         lf7ysqOgfnCnvM1WTteQysQwx/PzTxIn6LcHH9CHs10r5S59oQe1QWpFuhvItIyLE3
         SPMiqoYW7BsjpGZPqAseBdJxfXY2vcQNoujXd5NqDPLCdzjET6xmkEgyWE+BwbUPaq
         //KzX1y+bmIwsDsB0E8XmygVxYt8NLupQnQcU/oyFaia4KnGHxYKzy3nsNrRBqSgGu
         DXpjV3vqgA4JlrUsJ5r2InOrpdCbZ6e6CVRtJMYniDTi381AuQm181G220tUK3OE2L
         0hjhJLJkMUnAA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, hawk@kernel.org,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev, sdf@google.com
Subject: [PATCH v4 bpf-next 8/8] selftests/bpf: introduce XDP compliance test tool
Date:   Sat, 28 Jan 2023 15:06:19 +0100
Message-Id: <a7eaa7e3e4c0a7e70f68c32314a7f75c9bba4465.1674913191.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674913191.git.lorenzo@kernel.org>
References: <cover.1674913191.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce xdp_features tool in order to test XDP features supported by
the NIC and match them against advertised ones.
In order to test supported/advertised XDP features, xdp_features must
run on the Device Under Test (DUT) and on a Tester device.
xdp_features opens a control TCP channel between DUT and Tester devices
to send control commands from Tester to the DUT and a UDP data channel
where the Tester sends UDP 'echo' packets and the DUT is expected to
reply back with the same packet. DUT installs multiple XDP programs on the
NIC to test XDP capabilities and reports back to the Tester some XDP stats.
Currently xdp_features supports the following XDP features:
- XDP_DROP
- XDP_PASS
- XDP_TX
- XDP_REDIRECT
- XDP_REDIRECT_TARGET

Co-developed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |  11 +-
 .../selftests/bpf/progs/xdp_features.c        | 275 +++++++
 .../selftests/bpf/test_xdp_features.sh        | 100 +++
 tools/testing/selftests/bpf/xdp_features.c    | 731 ++++++++++++++++++
 tools/testing/selftests/bpf/xdp_features.h    |  33 +
 6 files changed, 1149 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_features.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_features.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_features.c
 create mode 100644 tools/testing/selftests/bpf/xdp_features.h

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 4aa5bba956ff..116fecf80ca1 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -48,3 +48,4 @@ xskxceiver
 xdp_redirect_multi
 xdp_synproxy
 xdp_hw_metadata
+xdp_features
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 53eae7be8dff..6f06b03d93cd 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -73,7 +73,8 @@ TEST_PROGS := test_kmod.sh \
 	test_bpftool.sh \
 	test_bpftool_metadata.sh \
 	test_doc_build.sh \
-	test_xsk.sh
+	test_xsk.sh \
+	test_xdp_features.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh ima_setup.sh verify_sig_setup.sh \
@@ -83,7 +84,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata
+	xskxceiver xdp_redirect_multi xdp_synproxy veristat xdp_hw_metadata \
+	xdp_features
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read $(OUTPUT)/sign-file
 TEST_GEN_FILES += liburandom_read.so
@@ -385,6 +387,7 @@ test_subskeleton_lib.skel.h-deps := test_subskeleton_lib2.bpf.o test_subskeleton
 test_usdt.skel.h-deps := test_usdt.bpf.o test_usdt_multispec.bpf.o
 xsk_xdp_progs.skel.h-deps := xsk_xdp_progs.bpf.o
 xdp_hw_metadata.skel.h-deps := xdp_hw_metadata.bpf.o
+xdp_features.skel.h-deps := xdp_features.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
@@ -586,6 +589,10 @@ $(OUTPUT)/xdp_hw_metadata: xdp_hw_metadata.c $(OUTPUT)/network_helpers.o $(OUTPU
 	$(call msg,BINARY,,$@)
 	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
 
+$(OUTPUT)/xdp_features: xdp_features.c $(OUTPUT)/network_helpers.o $(OUTPUT)/xdp_features.skel.h | $(OUTPUT)
+	$(call msg,BINARY,,$@)
+	$(Q)$(CC) $(CFLAGS) $(filter %.a %.o %.c,$^) $(LDLIBS) -o $@
+
 # Make sure we are able to include and link libbpf against c++.
 $(OUTPUT)/test_cpp: test_cpp.cpp $(OUTPUT)/test_core_extern.skel.h $(BPFOBJ)
 	$(call msg,CXX,,$@)
diff --git a/tools/testing/selftests/bpf/progs/xdp_features.c b/tools/testing/selftests/bpf/progs/xdp_features.c
new file mode 100644
index 000000000000..205a4526ea68
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_features.c
@@ -0,0 +1,275 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <stdbool.h>
+#include <linux/bpf.h>
+#include <linux/netdev.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+#include <bpf/bpf_tracing.h>
+#include <linux/if_ether.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/udp.h>
+#include <asm-generic/errno-base.h>
+
+#include "xdp_features.h"
+
+#define ipv6_addr_equal(a, b)	((a).s6_addr32[0] == (b).s6_addr32[0] &&	\
+				 (a).s6_addr32[1] == (b).s6_addr32[1] &&	\
+				 (a).s6_addr32[2] == (b).s6_addr32[2] &&	\
+				 (a).s6_addr32[3] == (b).s6_addr32[3])
+
+struct net_device;
+struct bpf_prog;
+
+struct xdp_cpumap_stats {
+	unsigned int redirect;
+	unsigned int pass;
+	unsigned int drop;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, __u32);
+	__type(value, __u32);
+	__uint(max_entries, 1);
+} stats SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__type(key, __u32);
+	__type(value, __u32);
+	__uint(max_entries, 1);
+} dut_stats SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_CPUMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_cpumap_val));
+	__uint(max_entries, 1);
+} cpu_map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
+	__uint(max_entries, 1);
+} dev_map SEC(".maps");
+
+const volatile __u32 expected_feature = XDP_FEATURE_PASS;
+const volatile union {
+	struct in_addr ip;
+	struct in6_addr ip6;
+} tester_addr;
+const volatile union {
+	struct in_addr ip;
+	struct in6_addr ip6;
+} dut_addr;
+
+static __always_inline int xdp_process_echo_packet(struct xdp_md *xdp, bool dut)
+{
+	void *data_end = (void *)(long)xdp->data_end;
+	void *data = (void *)(long)xdp->data;
+	struct ethhdr *eh = data;
+	struct tlv_hdr *tlv;
+	struct udphdr *uh;
+	__be16 port;
+	__u8 *cmd;
+
+	if (eh + 1 > (struct ethhdr *)data_end)
+		return -EINVAL;
+
+	if (eh->h_proto == bpf_htons(ETH_P_IP)) {
+		struct iphdr *ih = (struct iphdr *)(eh + 1);
+		__be32 saddr = dut ? tester_addr.ip.s_addr : dut_addr.ip.s_addr;
+		__be32 daddr = dut ? dut_addr.ip.s_addr : tester_addr.ip.s_addr;
+
+		ih = (struct iphdr *)(eh + 1);
+		if (ih + 1 > (struct iphdr *)data_end)
+			return -EINVAL;
+
+		if (saddr != ih->saddr)
+			return -EINVAL;
+
+		if (daddr != ih->daddr)
+			return -EINVAL;
+
+		if (ih->protocol != IPPROTO_UDP)
+			return -EINVAL;
+
+		uh = (struct udphdr *)(ih + 1);
+	} else if (eh->h_proto == bpf_htons(ETH_P_IPV6)) {
+		struct in6_addr saddr = dut ? tester_addr.ip6 : dut_addr.ip6;
+		struct in6_addr daddr = dut ? dut_addr.ip6 : tester_addr.ip6;
+		struct ipv6hdr *ih6 = (struct ipv6hdr *)(eh + 1);
+
+		if (ih6 + 1 > (struct ipv6hdr *)data_end)
+			return -EINVAL;
+
+		if (!ipv6_addr_equal(saddr, ih6->saddr))
+			return -EINVAL;
+
+		if (!ipv6_addr_equal(daddr, ih6->daddr))
+			return -EINVAL;
+
+		if (ih6->nexthdr != IPPROTO_UDP)
+			return -EINVAL;
+
+		uh = (struct udphdr *)(ih6 + 1);
+	} else {
+		return -EINVAL;
+	}
+
+	if (uh + 1 > (struct udphdr *)data_end)
+		return -EINVAL;
+
+	port = dut ? uh->dest : uh->source;
+	if (port != bpf_htons(DUT_ECHO_PORT))
+		return -EINVAL;
+
+	tlv = (struct tlv_hdr *)(uh + 1);
+	if (tlv + 1 > data_end)
+		return -EINVAL;
+
+	return bpf_htons(tlv->type) == CMD_ECHO ? 0 : -EINVAL;
+}
+
+SEC("xdp")
+int xdp_tester(struct xdp_md *xdp)
+{
+	__u32 *val, key = 0;
+
+	switch (expected_feature) {
+	case XDP_FEATURE_NDO_XMIT:
+	case XDP_FEATURE_TX:
+		if (xdp_process_echo_packet(xdp, true))
+			goto out;
+		break;
+	case XDP_FEATURE_DROP:
+	case XDP_FEATURE_PASS:
+	case XDP_FEATURE_REDIRECT:
+		if (xdp_process_echo_packet(xdp, false))
+			goto out;
+		break;
+	default:
+		goto out;
+	}
+
+	val = bpf_map_lookup_elem(&stats, &key);
+	if (val)
+		__sync_add_and_fetch(val, 1);
+
+out:
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int xdp_do_pass(struct xdp_md *xdp)
+{
+	__u32 *val, key = 0;
+
+	val = bpf_map_lookup_elem(&dut_stats, &key);
+	if (val)
+		__sync_add_and_fetch(val, 1);
+
+	return XDP_PASS;
+}
+
+SEC("xdp")
+int xdp_do_drop(struct xdp_md *xdp)
+{
+	__u32 *val, key = 0;
+
+	if (xdp_process_echo_packet(xdp, true))
+		return XDP_PASS;
+
+	val = bpf_map_lookup_elem(&dut_stats, &key);
+	if (val)
+		__sync_add_and_fetch(val, 1);
+
+	return XDP_DROP;
+}
+
+SEC("xdp")
+int xdp_do_aborted(struct xdp_md *xdp)
+{
+	return xdp_process_echo_packet(xdp, true) ? XDP_PASS : XDP_ABORTED;
+}
+
+SEC("xdp")
+int xdp_do_tx(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	struct ethhdr *eh = data;
+	__u8 tmp_mac[ETH_ALEN];
+	__u32 *val, key = 0;
+
+	if (xdp_process_echo_packet(xdp, true))
+		return XDP_PASS;
+
+	__builtin_memcpy(tmp_mac, eh->h_source, ETH_ALEN);
+	__builtin_memcpy(eh->h_source, eh->h_dest, ETH_ALEN);
+	__builtin_memcpy(eh->h_dest, tmp_mac, ETH_ALEN);
+
+	val = bpf_map_lookup_elem(&dut_stats, &key);
+	if (val)
+		__sync_add_and_fetch(val, 1);
+
+	return XDP_TX;
+}
+
+SEC("xdp")
+int xdp_do_redirect(struct xdp_md *xdp)
+{
+	if (xdp_process_echo_packet(xdp, true))
+		return XDP_PASS;
+
+	return bpf_redirect_map(&cpu_map, 0, 0);
+}
+
+SEC("tp_btf/xdp_exception")
+int BPF_PROG(xdp_exception, const struct net_device *dev,
+	     const struct bpf_prog *xdp, __u32 act)
+{
+	__u32 *val, key = 0;
+
+	val = bpf_map_lookup_elem(&dut_stats, &key);
+	if (val)
+		__sync_add_and_fetch(val, 1);
+
+	return 0;
+}
+
+SEC("tp_btf/xdp_cpumap_kthread")
+int BPF_PROG(tp_xdp_cpumap_kthread, int map_id, unsigned int processed,
+	     unsigned int drops, int sched, struct xdp_cpumap_stats *xdp_stats)
+{
+	__u32 *val, key = 0;
+
+	val = bpf_map_lookup_elem(&dut_stats, &key);
+	if (val)
+		__sync_add_and_fetch(val, 1);
+
+	return 0;
+}
+
+SEC("xdp/cpumap")
+int xdp_do_redirect_cpumap(struct xdp_md *xdp)
+{
+	void *data = (void *)(long)xdp->data;
+	struct ethhdr *eh = data;
+	__u8 tmp_mac[ETH_ALEN];
+
+	if (xdp_process_echo_packet(xdp, true))
+		return XDP_PASS;
+
+	__builtin_memcpy(tmp_mac, eh->h_source, ETH_ALEN);
+	__builtin_memcpy(eh->h_source, eh->h_dest, ETH_ALEN);
+	__builtin_memcpy(eh->h_dest, tmp_mac, ETH_ALEN);
+
+	return bpf_redirect_map(&dev_map, 0, 0);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdp_features.sh b/tools/testing/selftests/bpf/test_xdp_features.sh
new file mode 100755
index 000000000000..987845e18ea7
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_features.sh
@@ -0,0 +1,100 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+readonly NS="ns1-$(mktemp -u XXXXXX)"
+readonly V0_IP=10.10.0.11
+readonly V1_IP=10.10.0.1
+readonly V0_IP6=2001:db8::11
+readonly V1_IP6=2001:db8::1
+
+ret=1
+
+setup() {
+	{
+		ip netns add ${NS}
+
+		ip link add v1 type veth peer name v0 netns ${NS}
+
+		ip link set v1 up
+		ip addr add $V1_IP/24 dev v1
+		ip addr add $V1_IP6/64 nodad dev v1
+		ip -n ${NS} link set dev v0 up
+		ip -n ${NS} addr add $V0_IP/24 dev v0
+		ip -n ${NS} addr add $V0_IP6/64 nodad dev v0
+
+		sysctl -w net.ipv4.ip_forward=1
+
+		# Enable XDP mode and disable checksum offload
+		ethtool -K v1 gro on
+		ethtool -K v1 tx-checksumming off
+		ip netns exec ${NS} ethtool -K v0 gro on
+		ip netns exec ${NS} ethtool -K v0 tx-checksumming off
+	} > /dev/null 2>&1
+}
+
+cleanup() {
+	ip link del v1 2> /dev/null
+	ip netns del ${NS} 2> /dev/null
+	[ "$(pidof xdp_features)" = "" ] || kill $(pidof xdp_features) 2> /dev/null
+}
+
+wait_for_dut_server() {
+	while sleep 1; do
+		ss -tlp | grep -q xdp_features
+		[ $? -eq 0 ] && break
+	done
+}
+
+test_xdp_features() {
+	setup
+
+	## XDP_PASS
+	./xdp_features -6 -f XDP_PASS -D $V1_IP6 -T $V0_IP6 v1 &
+	wait_for_dut_server
+	ip netns exec ${NS} ./xdp_features -6 -t -f XDP_PASS -D $V1_IP6 -C $V1_IP6 -T $V0_IP6 v0
+
+	[ $? -ne 0 ] && exit
+
+	## XDP_DROP
+	./xdp_features -f XDP_DROP -D $V1_IP -T $V0_IP v1 &
+	wait_for_dut_server
+	ip netns exec ${NS} ./xdp_features -t -f XDP_DROP -D $V1_IP -C $V1_IP -T $V0_IP v0
+
+	[ $? -ne 0 ] && exit
+
+	## XDP_ABORTED
+	./xdp_features -6 -f XDP_ABORTED -D $V1_IP6 -T $V0_IP6 v1 &
+	wait_for_dut_server
+	ip netns exec ${NS} ./xdp_features -6 -t -f XDP_ABORTED -D $V1_IP6 -C $V1_IP6 -T $V0_IP6 v0
+
+	[ $? -ne 0 ] && exit
+
+	## XDP_TX
+	./xdp_features -f XDP_TX -D $V1_IP -T $V0_IP v1 &
+	wait_for_dut_server
+	ip netns exec ${NS} ./xdp_features -t -f XDP_TX -D $V1_IP -C $V1_IP -T $V0_IP v0
+
+	[ $? -ne 0 ] && exit
+
+	## XDP_REDIRECT
+	./xdp_features -6 -f XDP_REDIRECT -D $V1_IP6 -T $V0_IP6 v1 &
+	wait_for_dut_server
+	ip netns exec ${NS} ./xdp_features -6 -t -f XDP_REDIRECT -D $V1_IP6 -C $V1_IP6 -T $V0_IP6 v0
+
+	[ $? -ne 0 ] && exit
+
+	## XDP_NDO_XMIT
+	./xdp_features -f XDP_NDO_XMIT -D $V1_IP -T $V0_IP v1 &
+	wait_for_dut_server
+	ip netns exec ${NS} ./xdp_features -t -f XDP_NDO_XMIT -D $V1_IP -C $V1_IP -T $V0_IP v0
+
+	ret=$?
+	cleanup
+}
+
+set -e
+trap cleanup 2 3 6 9
+
+test_xdp_features
+
+exit $ret
diff --git a/tools/testing/selftests/bpf/xdp_features.c b/tools/testing/selftests/bpf/xdp_features.c
new file mode 100644
index 000000000000..9b94d5cdf654
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_features.c
@@ -0,0 +1,731 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <uapi/linux/bpf.h>
+#include <uapi/linux/netdev.h>
+#include <linux/if_link.h>
+#include <signal.h>
+#include <argp.h>
+#include <net/if.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <netinet/tcp.h>
+#include <unistd.h>
+#include <arpa/inet.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <pthread.h>
+
+#include <network_helpers.h>
+
+#include "xdp_features.skel.h"
+#include "xdp_features.h"
+
+#define RED(str)	"\033[0;31m" str "\033[0m"
+#define GREEN(str)	"\033[0;32m" str "\033[0m"
+#define YELLOW(str)	"\033[0;33m" str "\033[0m"
+
+static struct env {
+	bool verbosity;
+	int ifindex;
+	unsigned int feature;
+	bool is_tester;
+	int family;
+	struct {
+		struct sockaddr_storage addr;
+		socklen_t addrlen;
+	} dut_ctrl;
+	struct {
+		struct sockaddr_storage addr;
+		socklen_t addrlen;
+	} dut;
+	struct {
+		struct sockaddr_storage addr;
+		socklen_t addrlen;
+	} tester;
+} env;
+
+#define BUFSIZE		128
+
+void test__fail(void) { /* for network_helpers.c */ }
+
+static int libbpf_print_fn(enum libbpf_print_level level,
+			   const char *format, va_list args)
+{
+	if (level == LIBBPF_DEBUG && !env.verbosity)
+		return 0;
+	return vfprintf(stderr, format, args);
+}
+
+static volatile bool exiting;
+
+static void sig_handler(int sig)
+{
+	exiting = true;
+}
+
+const char *argp_program_version = "xdp-features 0.0";
+const char argp_program_doc[] =
+"XDP features detecion application.\n"
+"\n"
+"XDP features application checks the XDP advertised features match detected ones.\n"
+"\n"
+"USAGE: ./xdp-features [-6vt] [-f <xdp-feature>] [-D <dut-data-ip>] [-T <tester-data-ip>] [-C <dut-ctrl-ip>] <iface-name>\n"
+"\n"
+"XDP features\n:"
+"- XDP_PASS\n"
+"- XDP_DROP\n"
+"- XDP_ABORTED\n"
+"- XDP_REDIRECT\n"
+"- XDP_NDO_XMIT\n"
+"- XDP_TX\n";
+
+static const struct argp_option opts[] = {
+	{ "ipv6", '6', NULL, 0, "Use IPv6 network stack" },
+	{ "verbose", 'v', NULL, 0, "Verbose debug output" },
+	{ "tester", 't', NULL, 0, "Tester mode" },
+	{ "feature", 'f', "XDP-FEATURE", 0, "XDP feature to test" },
+	{ "dut_data_ip", 'D', "DUT-DATA-IP", 0, "DUT IP data channel" },
+	{ "dut_ctrl_ip", 'C', "DUT-CTRL-IP", 0, "DUT IP control channel" },
+	{ "tester_data_ip", 'T', "TESTER-DATA-IP", 0, "Tester IP data channel" },
+	{},
+};
+
+static int get_xdp_feature(const char *arg)
+{
+	if (!strcmp(arg, "XDP_PASS"))
+		return XDP_FEATURE_PASS;
+	else if (!strcmp(arg, "XDP_DROP"))
+		return XDP_FEATURE_DROP;
+	else if (!strcmp(arg, "XDP_ABORTED"))
+		return XDP_FEATURE_ABORTED;
+	else if (!strcmp(arg, "XDP_REDIRECT"))
+		return XDP_FEATURE_REDIRECT;
+	else if (!strcmp(arg, "XDP_NDO_XMIT"))
+		return XDP_FEATURE_NDO_XMIT;
+	else if (!strcmp(arg, "XDP_TX"))
+		return XDP_FEATURE_TX;
+
+	return -EINVAL;
+}
+
+static char *get_xdp_feature_str(int feature)
+{
+	switch (feature) {
+	case XDP_FEATURE_PASS:
+		return YELLOW("XDP_PASS");
+	case XDP_FEATURE_DROP:
+		return YELLOW("XDP_DROP");
+	case XDP_FEATURE_ABORTED:
+		return YELLOW("XDP_ABORTED");
+	case XDP_FEATURE_TX:
+		return YELLOW("XDP_TX");
+	case XDP_FEATURE_REDIRECT:
+		return YELLOW("XDP_REDIRECT");
+	case XDP_FEATURE_NDO_XMIT:
+		return YELLOW("XDP_NDO_XMIT");
+	default:
+		return "";
+	}
+}
+
+static error_t parse_arg(int key, char *arg, struct argp_state *state)
+{
+	switch (key) {
+	case '6':
+		env.family = AF_INET6;
+		break;
+	case 'v':
+		env.verbosity = true;
+		break;
+	case 't':
+		env.is_tester = true;
+		break;
+	case 'f':
+		env.feature = get_xdp_feature(arg);
+		if (env.feature < 0) {
+			fprintf(stderr, "Invalid xdp feature: %s\n", arg);
+			argp_usage(state);
+			return ARGP_ERR_UNKNOWN;
+		}
+		break;
+	case 'D':
+		if (make_sockaddr(env.family, arg, DUT_ECHO_PORT,
+				  &env.dut.addr, &env.dut.addrlen)) {
+			fprintf(stderr, "Invalid DUT address: %s\n", arg);
+			return ARGP_ERR_UNKNOWN;
+		}
+		break;
+	case 'C':
+		if (make_sockaddr(env.family, arg, DUT_CTRL_PORT,
+				  &env.dut_ctrl.addr, &env.dut_ctrl.addrlen)) {
+			fprintf(stderr, "Invalid DUT CTRL address: %s\n", arg);
+			return ARGP_ERR_UNKNOWN;
+		}
+		break;
+	case 'T':
+		if (make_sockaddr(env.family, arg, 0, &env.tester.addr,
+				  &env.tester.addrlen)) {
+			fprintf(stderr, "Invalid Tester address: %s\n", arg);
+			return ARGP_ERR_UNKNOWN;
+		}
+		break;
+	case ARGP_KEY_ARG:
+		errno = 0;
+		if (strlen(arg) >= IF_NAMESIZE) {
+			fprintf(stderr, "Invalid device name: %s\n", arg);
+			argp_usage(state);
+			return ARGP_ERR_UNKNOWN;
+		}
+
+		env.ifindex = if_nametoindex(arg);
+		if (!env.ifindex)
+			env.ifindex = strtoul(arg, NULL, 0);
+		if (!env.ifindex) {
+			fprintf(stderr,
+				"Bad interface index or name (%d): %s\n",
+				errno, strerror(errno));
+			argp_usage(state);
+			return ARGP_ERR_UNKNOWN;
+		}
+		break;
+	default:
+		return ARGP_ERR_UNKNOWN;
+	}
+
+	return 0;
+}
+
+static const struct argp argp = {
+	.options = opts,
+	.parser = parse_arg,
+	.doc = argp_program_doc,
+};
+
+static void set_env_defaul(void)
+{
+	env.feature = XDP_FEATURE_PASS;
+	env.ifindex = -ENODEV;
+	env.family = AF_INET;
+	make_sockaddr(AF_INET, "127.0.0.1", DUT_CTRL_PORT, &env.dut_ctrl.addr,
+		      &env.dut_ctrl.addrlen);
+	make_sockaddr(AF_INET, "127.0.0.1", DUT_ECHO_PORT, &env.dut.addr,
+		      &env.dut.addrlen);
+	make_sockaddr(AF_INET, "127.0.0.1", 0, &env.tester.addr,
+		      &env.tester.addrlen);
+}
+
+static void *dut_echo_thread(void *arg)
+{
+	unsigned char buf[sizeof(struct tlv_hdr)];
+	int sockfd = *(int *)arg;
+
+	while (!exiting) {
+		struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
+		struct sockaddr_storage addr;
+		socklen_t addrlen;
+		size_t n;
+
+		n = recvfrom(sockfd, buf, sizeof(buf), MSG_WAITALL,
+			     (struct sockaddr *)&addr, &addrlen);
+		if (n != ntohs(tlv->len))
+			continue;
+
+		if (ntohs(tlv->type) != CMD_ECHO)
+			continue;
+
+		sendto(sockfd, buf, sizeof(buf), MSG_NOSIGNAL | MSG_CONFIRM,
+		       (struct sockaddr *)&addr, addrlen);
+	}
+
+	pthread_exit((void *)0);
+	close(sockfd);
+
+	return NULL;
+}
+
+static int dut_run_echo_thread(pthread_t *t, int *sockfd)
+{
+	int err;
+
+	sockfd = start_reuseport_server(env.family, SOCK_DGRAM, NULL,
+					DUT_ECHO_PORT, 0, 1);
+	if (!sockfd) {
+		fprintf(stderr, "Failed to create echo socket\n");
+		return -errno;
+	}
+
+	/* start echo channel */
+	err = pthread_create(t, NULL, dut_echo_thread, sockfd);
+	if (err) {
+		fprintf(stderr, "Failed creating dut_echo thread: %s\n",
+			strerror(-err));
+		free_fds(sockfd, 1);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int dut_attach_xdp_prog(struct xdp_features *skel, int feature,
+			       int flags)
+{
+	struct bpf_program *prog;
+	unsigned int key = 0;
+	int err, fd = 0;
+
+	switch (feature) {
+	case XDP_FEATURE_TX:
+		prog = skel->progs.xdp_do_tx;
+		break;
+	case XDP_FEATURE_DROP:
+		prog = skel->progs.xdp_do_drop;
+		break;
+	case XDP_FEATURE_ABORTED:
+		prog = skel->progs.xdp_do_aborted;
+		break;
+	case XDP_FEATURE_PASS:
+		prog = skel->progs.xdp_do_pass;
+		break;
+	case XDP_FEATURE_NDO_XMIT: {
+		struct bpf_devmap_val entry = {
+			.ifindex = env.ifindex,
+		};
+
+		err = bpf_map__update_elem(skel->maps.dev_map,
+					   &key, sizeof(key),
+					   &entry, sizeof(entry), 0);
+		if (err < 0)
+			return err;
+
+		fd = bpf_program__fd(skel->progs.xdp_do_redirect_cpumap);
+	}
+	case XDP_FEATURE_REDIRECT: {
+		struct bpf_cpumap_val entry = {
+			.qsize = 2048,
+			.bpf_prog.fd = fd,
+		};
+
+		err = bpf_map__update_elem(skel->maps.cpu_map,
+					   &key, sizeof(key),
+					   &entry, sizeof(entry), 0);
+		if (err < 0)
+			return err;
+
+		prog = skel->progs.xdp_do_redirect;
+		break;
+	}
+	default:
+		return -EINVAL;
+	}
+
+	err = bpf_xdp_attach(env.ifindex, bpf_program__fd(prog), flags, NULL);
+	if (err)
+		fprintf(stderr,
+			"Failed to attach XDP program to ifindex %d\n",
+			env.ifindex);
+	return err;
+}
+
+static int __recv_msg(int sockfd, void *buf, size_t bufsize,
+		      unsigned int *val, unsigned int val_size)
+{
+	struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
+	int len, n = sizeof(*tlv), i = 0;
+
+	len = recv(sockfd, buf, bufsize, 0);
+	if (len != ntohs(tlv->len))
+		return -EINVAL;
+
+	while (n < len && i < val_size) {
+		val[i] = ntohl(tlv->data[i]);
+		n += sizeof(tlv->data[0]);
+		i++;
+	}
+
+	return i;
+}
+
+static int recv_msg(int sockfd, void *buf, size_t bufsize)
+{
+	return __recv_msg(sockfd, buf, bufsize, NULL, 0);
+}
+
+static int dut_run(struct xdp_features *skel)
+{
+	int flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
+	int state, err, *sockfd, ctrl_sockfd, echo_sockfd;
+	struct sockaddr_storage ctrl_addr;
+	pthread_t dut_thread;
+	socklen_t addrlen;
+
+	sockfd = start_reuseport_server(env.family, SOCK_STREAM, NULL,
+					DUT_CTRL_PORT, 0, 1);
+	if (!sockfd) {
+		fprintf(stderr, "Failed to create DUT socket\n");
+		return -errno;
+	}
+
+	ctrl_sockfd = accept(*sockfd, (struct sockaddr *)&ctrl_addr, &addrlen);
+	if (ctrl_sockfd < 0) {
+		fprintf(stderr, "Failed to accept connection on DUT socket\n");
+		free_fds(sockfd, 1);
+		return -errno;
+	}
+
+	/* CTRL loop */
+	while (!exiting) {
+		unsigned char buf[BUFSIZE] = {};
+		struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
+
+		err = recv_msg(ctrl_sockfd, buf, BUFSIZE);
+		if (err)
+			continue;
+
+		switch (ntohs(tlv->type)) {
+		case CMD_START: {
+			if (state == CMD_START)
+				continue;
+
+			state = CMD_START;
+			/* Load the XDP program on the DUT */
+			err = dut_attach_xdp_prog(skel, ntohl(tlv->data[0]), flags);
+			if (err)
+				goto out;
+
+			err = dut_run_echo_thread(&dut_thread, &echo_sockfd);
+			if (err < 0)
+				goto out;
+
+			tlv->type = htons(CMD_ACK);
+			tlv->len = htons(sizeof(*tlv));
+			err = send(ctrl_sockfd, buf, sizeof(*tlv), 0);
+			if (err < 0)
+				goto end_thread;
+			break;
+		}
+		case CMD_STOP:
+			if (state != CMD_START)
+				break;
+
+			state = CMD_STOP;
+
+			exiting = true;
+			bpf_xdp_detach(env.ifindex, flags, NULL);
+
+			tlv->type = htons(CMD_ACK);
+			tlv->len = htons(sizeof(*tlv));
+			err = send(ctrl_sockfd, buf, sizeof(*tlv), 0);
+			goto end_thread;
+		case CMD_GET_XDP_CAP: {
+			LIBBPF_OPTS(bpf_xdp_query_opts, opts);
+			size_t n;
+
+			err = bpf_xdp_query(env.ifindex, XDP_FLAGS_DRV_MODE,
+					    &opts);
+			if (err) {
+				fprintf(stderr,
+					"Failed to query XDP cap for ifindex %d\n",
+					env.ifindex);
+				goto end_thread;
+			}
+
+			tlv->type = htons(CMD_ACK);
+			n = sizeof(*tlv) + sizeof(opts.feature_flags);
+			tlv->len = htons(n);
+			tlv->data[0] = htonl(opts.feature_flags);
+
+			err = send(ctrl_sockfd, buf, n, 0);
+			if (err < 0)
+				goto end_thread;
+			break;
+		}
+		case CMD_GET_STATS: {
+			unsigned int key = 0, val;
+			size_t n;
+
+			err = bpf_map__lookup_elem(skel->maps.dut_stats,
+						   &key, sizeof(key),
+						   &val, sizeof(val), 0);
+			if (err) {
+				fprintf(stderr, "bpf_map_lookup_elem failed\n");
+				goto end_thread;
+			}
+
+			tlv->type = htons(CMD_ACK);
+			n = sizeof(*tlv) + sizeof(val);
+			tlv->len = htons(n);
+			tlv->data[0] = htonl(val);
+
+			err = send(ctrl_sockfd, buf, n, 0);
+			if (err < 0)
+				goto end_thread;
+			break;
+		}
+		default:
+			break;
+		}
+	}
+
+end_thread:
+	pthread_join(dut_thread, NULL);
+out:
+	bpf_xdp_detach(env.ifindex, flags, NULL);
+	close(ctrl_sockfd);
+	free_fds(sockfd, 1);
+
+	return err;
+}
+
+static bool tester_collect_advertised_cap(unsigned int cap)
+{
+	switch (env.feature) {
+	case XDP_FEATURE_ABORTED:
+	case XDP_FEATURE_DROP:
+	case XDP_FEATURE_PASS:
+	case XDP_FEATURE_TX:
+		return cap & NETDEV_XDP_ACT_BASIC;
+	case XDP_FEATURE_REDIRECT:
+		return cap & NETDEV_XDP_ACT_REDIRECT;
+	case XDP_FEATURE_NDO_XMIT:
+		return cap & NETDEV_XDP_ACT_NDO_XMIT;
+	default:
+		return false;
+	}
+}
+
+static bool tester_collect_detected_cap(struct xdp_features *skel,
+					unsigned int dut_stats)
+{
+	unsigned int err, key = 0, val;
+
+	if (!dut_stats)
+		return false;
+
+	err = bpf_map__lookup_elem(skel->maps.stats, &key, sizeof(key),
+				   &val, sizeof(val), 0);
+	if (err) {
+		fprintf(stderr, "bpf_map_lookup_elem failed\n");
+		return false;
+	}
+
+	switch (env.feature) {
+	case XDP_FEATURE_PASS:
+	case XDP_FEATURE_TX:
+	case XDP_FEATURE_REDIRECT:
+	case XDP_FEATURE_NDO_XMIT:
+		return val > 0;
+	case XDP_FEATURE_DROP:
+	case XDP_FEATURE_ABORTED:
+		return val == 0;
+	default:
+		return false;
+	}
+}
+
+static int __send_and_recv_msg(int sockfd, enum test_commands cmd,
+			       unsigned int *val, unsigned int val_size)
+{
+	unsigned char buf[BUFSIZE] = {};
+	struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
+	int n = sizeof(*tlv), err;
+
+	tlv->type = htons(cmd);
+	switch (cmd) {
+	case CMD_START:
+		tlv->data[0] = htonl(env.feature);
+		n += sizeof(*val);
+		break;
+	default:
+		break;
+	}
+	tlv->len = htons(n);
+
+	err = send(sockfd, buf, n, 0);
+	if (err < 0)
+		return err;
+
+	err = __recv_msg(sockfd, buf, BUFSIZE, val, val_size);
+	if (err < 0)
+		return err;
+
+	return ntohs(tlv->type) == CMD_ACK ? 0 : -EINVAL;
+}
+
+static int send_and_recv_msg(int sockfd, enum test_commands cmd)
+{
+	return __send_and_recv_msg(sockfd, cmd, NULL, 0);
+}
+
+static int send_echo_msg(void)
+{
+	unsigned char buf[sizeof(struct tlv_hdr)];
+	struct tlv_hdr *tlv = (struct tlv_hdr *)buf;
+	int sockfd, n;
+
+	sockfd = socket(env.family, SOCK_DGRAM, 0);
+	if (sockfd < 0) {
+		fprintf(stderr, "Failed to create echo socket\n");
+		return -errno;
+	}
+
+	tlv->type = htons(CMD_ECHO);
+	tlv->len = htons(sizeof(*tlv));
+
+	n = sendto(sockfd, buf, sizeof(*tlv), MSG_NOSIGNAL | MSG_CONFIRM,
+		   (struct sockaddr *)&env.dut.addr, env.dut.addrlen);
+	close(sockfd);
+
+	return n == ntohs(tlv->len) ? 0 : -EINVAL;
+}
+
+static int tester_run(struct xdp_features *skel)
+{
+	int flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
+	bool advertised_cap;
+	unsigned int val[1];
+	int i, err, sockfd;
+	bool detected_cap;
+
+	sockfd = socket(env.family, SOCK_STREAM, 0);
+	if (sockfd < 0) {
+		fprintf(stderr, "Failed to create tester socket\n");
+		return -errno;
+	}
+
+	if (settimeo(sockfd, 1000) < 0)
+		return -EINVAL;
+
+	err = connect(sockfd, (struct sockaddr *)&env.dut_ctrl.addr,
+		      env.dut_ctrl.addrlen);
+	if (err) {
+		fprintf(stderr, "Failed to connect to the DUT\n");
+		return -errno;
+	}
+
+	err = __send_and_recv_msg(sockfd, CMD_GET_XDP_CAP, val,
+				  ARRAY_SIZE(val));
+	if (err < 0) {
+		close(sockfd);
+		return err;
+	}
+
+	advertised_cap = tester_collect_advertised_cap(val[0]);
+
+	err = bpf_xdp_attach(env.ifindex,
+			     bpf_program__fd(skel->progs.xdp_tester),
+			     flags, NULL);
+	if (err) {
+		fprintf(stderr, "Failed to attach XDP program to ifindex %d\n",
+			env.ifindex);
+		goto out;
+	}
+
+	err = send_and_recv_msg(sockfd, CMD_START);
+	if (err)
+		goto out;
+
+	for (i = 0; i < 10 && !exiting; i++) {
+		err = send_echo_msg();
+		if (err < 0)
+			goto out;
+
+		sleep(1);
+	}
+
+	err = __send_and_recv_msg(sockfd, CMD_GET_STATS, val, ARRAY_SIZE(val));
+	if (err)
+		goto out;
+
+	/* stop the test */
+	err = send_and_recv_msg(sockfd, CMD_STOP);
+	/* send a new echo message to wake echo thread of the dut */
+	send_echo_msg();
+
+	detected_cap = tester_collect_detected_cap(skel, val[0]);
+
+	fprintf(stdout, "Feature %s: [%s][%s]\n", get_xdp_feature_str(env.feature),
+		detected_cap ? GREEN("DETECTED") : RED("NOT DETECTED"),
+		advertised_cap ? GREEN("ADVERTISED") : RED("NOT ADVERTISED"));
+out:
+	bpf_xdp_detach(env.ifindex, flags, NULL);
+	close(sockfd);
+	return err < 0 ? err : 0;
+}
+
+static void set_skel_rodata(struct xdp_features *skel)
+{
+	skel->rodata->expected_feature = env.feature;
+	if (env.family == AF_INET6) {
+		struct sockaddr_in6 *tester_addr = (void *)&env.tester.addr;
+		struct sockaddr_in6 *dut_addr = (void *)&env.dut.addr;
+
+		skel->rodata->tester_addr.ip6 = tester_addr->sin6_addr;
+		skel->rodata->dut_addr.ip6 = dut_addr->sin6_addr;
+	} else {
+		struct sockaddr_in *tester_addr = (void *)&env.tester.addr;
+		struct sockaddr_in *dut_addr = (void *)&env.dut.addr;
+
+		skel->rodata->tester_addr.ip = tester_addr->sin_addr;
+		skel->rodata->dut_addr.ip = dut_addr->sin_addr;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	struct xdp_features *skel;
+	int err;
+
+	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
+	libbpf_set_print(libbpf_print_fn);
+
+	signal(SIGINT, sig_handler);
+	signal(SIGTERM, sig_handler);
+
+	set_env_defaul();
+
+	/* Parse command line arguments */
+	err = argp_parse(&argp, argc, argv, 0, NULL, NULL);
+	if (err)
+		return err;
+
+	if (env.ifindex < 0) {
+		fprintf(stderr, "Invalid ifindex\n");
+		return -ENODEV;
+	}
+
+	/* Load and verify BPF application */
+	skel = xdp_features__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to open and load BPF skeleton\n");
+		return -EINVAL;
+	}
+
+	set_skel_rodata(skel);
+
+	/* Load & verify BPF programs */
+	err = xdp_features__load(skel);
+	if (err) {
+		fprintf(stderr, "Failed to load and verify BPF skeleton\n");
+		goto cleanup;
+	}
+
+	err = xdp_features__attach(skel);
+	if (err) {
+		fprintf(stderr, "Failed to attach BPF skeleton\n");
+		goto cleanup;
+	}
+
+	if (env.is_tester) {
+		/* Tester */
+		fprintf(stdout, "Starting tester on device %d\n", env.ifindex);
+		err = tester_run(skel);
+	} else {
+		/* DUT */
+		fprintf(stdout, "Starting DUT on device %d\n", env.ifindex);
+		err = dut_run(skel);
+	}
+
+cleanup:
+	xdp_features__destroy(skel);
+
+	return err < 0 ? -err : 0;
+}
diff --git a/tools/testing/selftests/bpf/xdp_features.h b/tools/testing/selftests/bpf/xdp_features.h
new file mode 100644
index 000000000000..28d7614c4f02
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_features.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+/* test commands */
+enum test_commands {
+	CMD_STOP,		/* CMD */
+	CMD_START,		/* CMD + xdp feature */
+	CMD_ECHO,		/* CMD */
+	CMD_ACK,		/* CMD + data */
+	CMD_GET_XDP_CAP,	/* CMD */
+	CMD_GET_STATS,		/* CMD */
+};
+
+#define DUT_CTRL_PORT	12345
+#define DUT_ECHO_PORT	12346
+
+struct tlv_hdr {
+	__be16 type;
+	__be16 len;
+	__be32 data[];
+};
+
+enum {
+	XDP_FEATURE_ABORTED,
+	XDP_FEATURE_DROP,
+	XDP_FEATURE_PASS,
+	XDP_FEATURE_TX,
+	XDP_FEATURE_REDIRECT,
+	XDP_FEATURE_NDO_XMIT,
+	XDP_FEATURE_XSK_ZEROCOPY,
+	XDP_FEATURE_HW_OFFLOAD,
+	XDP_FEATURE_RX_SG,
+	XDP_FEATURE_NDO_XMIT_SG,
+};
-- 
2.39.1

