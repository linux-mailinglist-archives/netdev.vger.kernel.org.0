Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97E7629534
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:03:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbiKOKDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:03:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiKOKDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:03:18 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5672023E88;
        Tue, 15 Nov 2022 02:03:14 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NBMDt1tKxzRpJn;
        Tue, 15 Nov 2022 18:02:54 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 18:03:11 +0800
From:   Wang Yufen <wangyufen@huawei.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <andrii@kernel.org>,
        <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>, Wang Yufen <wangyufen@huawei.com>
Subject: [PATCH v2 2/2] selftests/net: fix opening object file failed
Date:   Tue, 15 Nov 2022 18:23:20 +0800
Message-ID: <1668507800-45450-3-git-send-email-wangyufen@huawei.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
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

The program file used in the udpgro_frglist testcase is "../bpf/nat6to4.o",
but the actual nat6to4.o file is in "bpf/" not "../bpf".
The following error occurs:
  Error opening object ../bpf/nat6to4.o: No such file or directory
  Cannot initialize ELF context!
  Unable to load program

In addition, all the kernel bpf source files are centred under the
subdir "progs" after commit bd4aed0ee73c ("selftests: bpf: centre
kernel bpf objects under new subdir "progs""). So mv nat6to4.c to
"../bpf/progs" and use "../bpf/nat6to4.bpf.o". And also move the
test program to selftests/bpf.

Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
---
 tools/testing/selftests/bpf/Makefile               |   7 +-
 tools/testing/selftests/bpf/in_netns.sh            |  23 +
 .../testing/selftests/bpf/progs/nat6to4_egress4.c  | 184 ++++++
 .../testing/selftests/bpf/progs/nat6to4_ingress6.c | 149 +++++
 tools/testing/selftests/bpf/test_udpgro_frglist.sh | 110 ++++
 tools/testing/selftests/bpf/udpgso_bench_rx.c      | 409 ++++++++++++
 tools/testing/selftests/bpf/udpgso_bench_tx.c      | 712 +++++++++++++++++++++
 tools/testing/selftests/net/Makefile               |   2 -
 tools/testing/selftests/net/bpf/Makefile           |  14 -
 tools/testing/selftests/net/bpf/nat6to4.c          | 285 ---------
 tools/testing/selftests/net/udpgro_frglist.sh      | 103 ---
 11 files changed, 1592 insertions(+), 406 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/in_netns.sh
 create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_egress4.c
 create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
 create mode 100755 tools/testing/selftests/bpf/test_udpgro_frglist.sh
 create mode 100644 tools/testing/selftests/bpf/udpgso_bench_rx.c
 create mode 100644 tools/testing/selftests/bpf/udpgso_bench_tx.c
 delete mode 100644 tools/testing/selftests/net/bpf/Makefile
 delete mode 100644 tools/testing/selftests/net/bpf/nat6to4.c
 delete mode 100755 tools/testing/selftests/net/udpgro_frglist.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index e6cf21f..e81e32d 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -39,7 +39,9 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
 	test_sock test_sockmap get_cgroup_id_user \
 	test_cgroup_storage \
 	test_tcpnotify_user test_sysctl \
-	test_progs-no_alu32
+	test_progs-no_alu32 \
+	udpgso_bench_rx \
+	udpgso_bench_tx
 
 # Also test bpf-gcc, if present
 ifneq ($(BPF_GCC),)
@@ -73,7 +75,8 @@ TEST_PROGS := test_kmod.sh \
 	test_bpftool.sh \
 	test_bpftool_metadata.sh \
 	test_doc_build.sh \
-	test_xsk.sh
+	test_xsk.sh \
+	test_udpgro_frglist.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh ima_setup.sh verify_sig_setup.sh \
diff --git a/tools/testing/selftests/bpf/in_netns.sh b/tools/testing/selftests/bpf/in_netns.sh
new file mode 100755
index 0000000..88795b5
--- /dev/null
+++ b/tools/testing/selftests/bpf/in_netns.sh
@@ -0,0 +1,23 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Execute a subprocess in a network namespace
+
+set -e
+
+readonly NETNS="ns-$(mktemp -u XXXXXX)"
+
+setup() {
+	ip netns add "${NETNS}"
+	ip -netns "${NETNS}" link set lo up
+}
+
+cleanup() {
+	ip netns del "${NETNS}"
+}
+
+trap cleanup EXIT
+setup
+
+ip netns exec "${NETNS}" "$@"
+exit "$?"
diff --git a/tools/testing/selftests/bpf/progs/nat6to4_egress4.c b/tools/testing/selftests/bpf/progs/nat6to4_egress4.c
new file mode 100644
index 0000000..9ebb2b2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/nat6to4_egress4.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This code is taken from the Android Open Source Project and the author
+ * (Maciej Żenczykowski) has gave permission to relicense it under the
+ * GPLv2. Therefore this program is free software;
+ * You can redistribute it and/or modify it under the terms of the GNU
+ * General Public License version 2 as published by the Free Software
+ * Foundation
+
+ * The original headers, including the original license headers, are
+ * included below for completeness.
+ *
+ * Copyright (C) 2019 The Android Open Source Project
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *      http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+#include <linux/bpf.h>
+#include <linux/if.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/swab.h>
+#include <stdbool.h>
+#include <stdint.h>
+
+
+#include <linux/udp.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define IP_DF 0x4000  // Flag: "Don't Fragment"
+
+SEC("tc")
+int sched_cls_egress4_snat4_prog(struct __sk_buff *skb)
+{
+	const int l2_header_size =  sizeof(struct ethhdr);
+	void *data = (void *)(long)skb->data;
+	const void *data_end = (void *)(long)skb->data_end;
+	const struct ethhdr *const eth = data;  // used iff is_ethernet
+	const struct iphdr *const ip4 = (void *)(eth + 1);
+
+	// Must be meta-ethernet IPv4 frame
+	if (skb->protocol != bpf_htons(ETH_P_IP))
+		return TC_ACT_OK;
+
+	// Must have ipv4 header
+	if (data + l2_header_size + sizeof(struct ipv6hdr) > data_end)
+		return TC_ACT_OK;
+
+	// Ethertype - if present - must be IPv4
+	if (eth->h_proto != bpf_htons(ETH_P_IP))
+		return TC_ACT_OK;
+
+	// IP version must be 4
+	if (ip4->version != 4)
+		return TC_ACT_OK;
+
+	// We cannot handle IP options, just standard 20 byte == 5 dword minimal IPv4 header
+	if (ip4->ihl != 5)
+		return TC_ACT_OK;
+
+	// Maximum IPv6 payload length that can be translated to IPv4
+	if (bpf_htons(ip4->tot_len) > 0xFFFF - sizeof(struct ipv6hdr))
+		return TC_ACT_OK;
+
+	// Calculate the IPv4 one's complement checksum of the IPv4 header.
+	__wsum sum4 = 0;
+
+	for (int i = 0; i < sizeof(*ip4) / sizeof(__u16); ++i)
+		sum4 += ((__u16 *)ip4)[i];
+
+	// Note that sum4 is guaranteed to be non-zero by virtue of ip4->version == 4
+	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse u32 into range 1 .. 0x1FFFE
+	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse any potential carry into u16
+	// for a correct checksum we should get *a* zero, but sum4 must be positive, ie 0xFFFF
+	if (sum4 != 0xFFFF)
+		return TC_ACT_OK;
+
+	// Minimum IPv4 total length is the size of the header
+	if (bpf_ntohs(ip4->tot_len) < sizeof(*ip4))
+		return TC_ACT_OK;
+
+	// We are incapable of dealing with IPv4 fragments
+	if (ip4->frag_off & ~bpf_htons(IP_DF))
+		return TC_ACT_OK;
+
+	switch (ip4->protocol) {
+	case IPPROTO_TCP:  // For TCP & UDP the checksum neutrality of the chosen IPv6
+	case IPPROTO_GRE:  // address means there is no need to update their checksums.
+	case IPPROTO_ESP:  // We do not need to bother looking at GRE/ESP headers,
+		break;         // since there is never a checksum to update.
+
+	case IPPROTO_UDP:  // See above comment, but must also have UDP header...
+		if (data + sizeof(*ip4) + sizeof(struct udphdr) > data_end)
+			return TC_ACT_OK;
+		const struct udphdr *uh = (const struct udphdr *)(ip4 + 1);
+		// If IPv4/UDP checksum is 0 then fallback to clatd so it can calculate the
+		// checksum.  Otherwise the network or more likely the NAT64 gateway might
+		// drop the packet because in most cases IPv6/UDP packets with a zero checksum
+		// are invalid. See RFC 6935.  TODO: calculate checksum via bpf_csum_diff()
+		if (!uh->check)
+			return TC_ACT_OK;
+		break;
+
+	default:  // do not know how to handle anything else
+		return TC_ACT_OK;
+	}
+	struct ethhdr eth2;  // used iff is_ethernet
+
+	eth2 = *eth;                     // Copy over the ethernet header (src/dst mac)
+	eth2.h_proto = bpf_htons(ETH_P_IPV6);  // But replace the ethertype
+
+	struct ipv6hdr ip6 = {
+		.version = 6,                                    // __u8:4
+		.priority = ip4->tos >> 4,                       // __u8:4
+		.flow_lbl = {(ip4->tos & 0xF) << 4, 0, 0},       // __u8[3]
+		.payload_len = bpf_htons(bpf_ntohs(ip4->tot_len) - 20),  // __be16
+		.nexthdr = ip4->protocol,                        // __u8
+		.hop_limit = ip4->ttl,                           // __u8
+	};
+	ip6.saddr.in6_u.u6_addr32[0] = bpf_htonl(0x20010db8);
+	ip6.saddr.in6_u.u6_addr32[1] = 0;
+	ip6.saddr.in6_u.u6_addr32[2] = 0;
+	ip6.saddr.in6_u.u6_addr32[3] = bpf_htonl(1);
+	ip6.daddr.in6_u.u6_addr32[0] = bpf_htonl(0x20010db8);
+	ip6.daddr.in6_u.u6_addr32[1] = 0;
+	ip6.daddr.in6_u.u6_addr32[2] = 0;
+	ip6.daddr.in6_u.u6_addr32[3] = bpf_htonl(2);
+
+	// Calculate the IPv6 16-bit one's complement checksum of the IPv6 header.
+	__wsum sum6 = 0;
+	// We'll end up with a non-zero sum due to ip6.version == 6
+	for (int i = 0; i < sizeof(ip6) / sizeof(__u16); ++i)
+		sum6 += ((__u16 *)&ip6)[i];
+
+	// Packet mutations begin - point of no return, but if this first modification fails
+	// the packet is probably still pristine, so let clatd handle it.
+	if (bpf_skb_change_proto(skb, bpf_htons(ETH_P_IPV6), 0))
+		return TC_ACT_OK;
+
+	// This takes care of updating the skb->csum field for a CHECKSUM_COMPLETE packet.
+	// In such a case, skb->csum is a 16-bit one's complement sum of the entire payload,
+	// thus we need to subtract out the ipv4 header's sum, and add in the ipv6 header's sum.
+	// However, we've already verified the ipv4 checksum is correct and thus 0.
+	// Thus we only need to add the ipv6 header's sum.
+	//
+	// bpf_csum_update() always succeeds if the skb is CHECKSUM_COMPLETE and returns an error
+	// (-ENOTSUPP) if it isn't.  So we just ignore the return code (see above for more details).
+	bpf_csum_update(skb, sum6);
+
+	// bpf_skb_change_proto() invalidates all pointers - reload them.
+	data = (void *)(long)skb->data;
+	data_end = (void *)(long)skb->data_end;
+
+	// I cannot think of any valid way for this error condition to trigger, however I do
+	// believe the explicit check is required to keep the in kernel ebpf verifier happy.
+	if (data + l2_header_size + sizeof(ip6) > data_end)
+		return TC_ACT_SHOT;
+
+	struct ethhdr *new_eth = data;
+
+	// Copy over the updated ethernet header
+	*new_eth = eth2;
+	// Copy over the new ipv4 header.
+	*(struct ipv6hdr *)(new_eth + 1) = ip6;
+	return TC_ACT_OK;
+}
+
+char _license[] SEC("license") = ("GPL");
diff --git a/tools/testing/selftests/bpf/progs/nat6to4_ingress6.c b/tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
new file mode 100644
index 0000000..76a7b19
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
@@ -0,0 +1,149 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This code is taken from the Android Open Source Project and the author
+ * (Maciej Żenczykowski) has gave permission to relicense it under the
+ * GPLv2. Therefore this program is free software;
+ * You can redistribute it and/or modify it under the terms of the GNU
+ * General Public License version 2 as published by the Free Software
+ * Foundation
+
+ * The original headers, including the original license headers, are
+ * included below for completeness.
+ *
+ * Copyright (C) 2019 The Android Open Source Project
+ *
+ * Licensed under the Apache License, Version 2.0 (the "License");
+ * you may not use this file except in compliance with the License.
+ * You may obtain a copy of the License at
+ *
+ *      http://www.apache.org/licenses/LICENSE-2.0
+ *
+ * Unless required by applicable law or agreed to in writing, software
+ * distributed under the License is distributed on an "AS IS" BASIS,
+ * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+ * See the License for the specific language governing permissions and
+ * limitations under the License.
+ */
+#include <linux/bpf.h>
+#include <linux/if.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/pkt_cls.h>
+#include <linux/swab.h>
+#include <stdbool.h>
+#include <stdint.h>
+
+
+#include <linux/udp.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define IP_DF 0x4000  // Flag: "Don't Fragment"
+
+SEC("tc")
+int sched_cls_ingress6_nat_6_prog(struct __sk_buff *skb)
+{
+	const int l2_header_size =  sizeof(struct ethhdr);
+	void *data = (void *)(long)skb->data;
+	const void *data_end = (void *)(long)skb->data_end;
+	const struct ethhdr * const eth = data;  // used iff is_ethernet
+	const struct ipv6hdr * const ip6 =  (void *)(eth + 1);
+
+	// Require ethernet dst mac address to be our unicast address.
+	if  (skb->pkt_type != PACKET_HOST)
+		return TC_ACT_OK;
+
+	// Must be meta-ethernet IPv6 frame
+	if (skb->protocol != bpf_htons(ETH_P_IPV6))
+		return TC_ACT_OK;
+
+	// Must have (ethernet and) ipv6 header
+	if (data + l2_header_size + sizeof(*ip6) > data_end)
+		return TC_ACT_OK;
+
+	// Ethertype - if present - must be IPv6
+	if (eth->h_proto != bpf_htons(ETH_P_IPV6))
+		return TC_ACT_OK;
+
+	// IP version must be 6
+	if (ip6->version != 6)
+		return TC_ACT_OK;
+	// Maximum IPv6 payload length that can be translated to IPv4
+	if (bpf_ntohs(ip6->payload_len) > 0xFFFF - sizeof(struct iphdr))
+		return TC_ACT_OK;
+	switch (ip6->nexthdr) {
+	case IPPROTO_TCP:  // For TCP & UDP the checksum neutrality of the chosen IPv6
+	case IPPROTO_UDP:  // address means there is no need to update their checksums.
+	case IPPROTO_GRE:  // We do not need to bother looking at GRE/ESP headers,
+	case IPPROTO_ESP:  // since there is never a checksum to update.
+		break;
+	default:  // do not know how to handle anything else
+		return TC_ACT_OK;
+	}
+
+	struct ethhdr eth2;  // used iff is_ethernet
+
+	eth2 = *eth;                     // Copy over the ethernet header (src/dst mac)
+	eth2.h_proto = bpf_htons(ETH_P_IP);  // But replace the ethertype
+
+	struct iphdr ip = {
+		.version = 4,                                                      // u4
+		.ihl = sizeof(struct iphdr) / sizeof(__u32),                       // u4
+		.tos = (ip6->priority << 4) + (ip6->flow_lbl[0] >> 4),             // u8
+		.tot_len = bpf_htons(bpf_ntohs(ip6->payload_len) + sizeof(struct iphdr)),  // u16
+		.id = 0,                                                           // u16
+		.frag_off = bpf_htons(IP_DF),                                          // u16
+		.ttl = ip6->hop_limit,                                             // u8
+		.protocol = ip6->nexthdr,                                          // u8
+		.check = 0,                                                        // u16
+		.saddr = 0x0201a8c0,                            // u32
+		.daddr = 0x0101a8c0,                                         // u32
+	};
+
+	// Calculate the IPv4 one's complement checksum of the IPv4 header.
+	__wsum sum4 = 0;
+
+	for (int i = 0; i < sizeof(ip) / sizeof(__u16); ++i)
+		sum4 += ((__u16 *)&ip)[i];
+
+	// Note that sum4 is guaranteed to be non-zero by virtue of ip.version == 4
+	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse u32 into range 1 .. 0x1FFFE
+	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse any potential carry into u16
+	ip.check = (__u16)~sum4;                // sum4 cannot be zero, so this is never 0xFFFF
+
+	// Calculate the *negative* IPv6 16-bit one's complement checksum of the IPv6 header.
+	__wsum sum6 = 0;
+	// We'll end up with a non-zero sum due to ip6->version == 6 (which has '0' bits)
+	for (int i = 0; i < sizeof(*ip6) / sizeof(__u16); ++i)
+		sum6 += ~((__u16 *)ip6)[i];  // note the bitwise negation
+
+	// Note that there is no L4 checksum update: we are relying on the checksum neutrality
+	// of the ipv6 address chosen by netd's ClatdController.
+
+	// Packet mutations begin - point of no return, but if this first modification fails
+	// the packet is probably still pristine, so let clatd handle it.
+	if (bpf_skb_change_proto(skb, bpf_htons(ETH_P_IP), 0))
+		return TC_ACT_OK;
+	bpf_csum_update(skb, sum6);
+
+	data = (void *)(long)skb->data;
+	data_end = (void *)(long)skb->data_end;
+	if (data + l2_header_size + sizeof(struct iphdr) > data_end)
+		return TC_ACT_SHOT;
+
+	struct ethhdr *new_eth = data;
+
+	// Copy over the updated ethernet header
+	*new_eth = eth2;
+
+	// Copy over the new ipv4 header.
+	*(struct iphdr *)(new_eth + 1) = ip;
+	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
+}
+
+char _license[] SEC("license") = ("GPL");
diff --git a/tools/testing/selftests/bpf/test_udpgro_frglist.sh b/tools/testing/selftests/bpf/test_udpgro_frglist.sh
new file mode 100755
index 0000000..95c92c4
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_udpgro_frglist.sh
@@ -0,0 +1,110 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Run a series of udpgro benchmarks
+
+readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
+
+BPF_FILE="xdp_dummy.bpf.o"
+BPF_FILE_INGRESS="nat6to4_ingress6.bpf.o"
+BPF_FILE_EGRESS="nat6to4_egress4.bpf.o"
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
+	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
+	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
+	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ${BPF_FILE_INGRESS} section tc direct-action
+	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ${BPF_FILE_EGRESS} section tc direct-action
+        echo ${rx_args}
+	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
+
+	# Hack: let bg programs complete the startup
+	sleep 0.2
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
+if [ ! -f ${BPF_FILE} ]; then
+	echo "Missing xdp_dummy helper. Build bpf selftest first"
+	exit -1
+fi
+
+if [ ! -f ${BPF_FILE_INGRESS} ]; then
+	echo "Missing nat6to4_ingress6 helper. Build bpf selftest first"
+	exit -1
+fi
+
+if [ ! -f ${BPF_FILE_EGRESS} ]; then
+	echo "Missing nat6to4_egress4 helper. Build bpf selftest first"
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
diff --git a/tools/testing/selftests/bpf/udpgso_bench_rx.c b/tools/testing/selftests/bpf/udpgso_bench_rx.c
new file mode 100644
index 0000000..6a19342
--- /dev/null
+++ b/tools/testing/selftests/bpf/udpgso_bench_rx.c
@@ -0,0 +1,409 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <error.h>
+#include <errno.h>
+#include <limits.h>
+#include <linux/errqueue.h>
+#include <linux/if_packet.h>
+#include <linux/socket.h>
+#include <linux/sockios.h>
+#include <net/ethernet.h>
+#include <net/if.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/tcp.h>
+#include <netinet/udp.h>
+#include <poll.h>
+#include <sched.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/socket.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#ifndef UDP_GRO
+#define UDP_GRO		104
+#endif
+
+static int  cfg_port		= 8000;
+static bool cfg_tcp;
+static bool cfg_verify;
+static bool cfg_read_all;
+static bool cfg_gro_segment;
+static int  cfg_family		= PF_INET6;
+static int  cfg_alen 		= sizeof(struct sockaddr_in6);
+static int  cfg_expected_pkt_nr;
+static int  cfg_expected_pkt_len;
+static int  cfg_expected_gso_size;
+static int  cfg_connect_timeout_ms;
+static int  cfg_rcv_timeout_ms;
+static struct sockaddr_storage cfg_bind_addr;
+
+static bool interrupted;
+static unsigned long packets, bytes;
+
+static void sigint_handler(int signum)
+{
+	if (signum == SIGINT)
+		interrupted = true;
+}
+
+static void setup_sockaddr(int domain, const char *str_addr, void *sockaddr)
+{
+	struct sockaddr_in6 *addr6 = (void *) sockaddr;
+	struct sockaddr_in *addr4 = (void *) sockaddr;
+
+	switch (domain) {
+	case PF_INET:
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(cfg_port);
+		if (inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
+			error(1, 0, "ipv4 parse error: %s", str_addr);
+		break;
+	case PF_INET6:
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(cfg_port);
+		if (inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
+			error(1, 0, "ipv6 parse error: %s", str_addr);
+		break;
+	default:
+		error(1, 0, "illegal domain");
+	}
+}
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+static void do_poll(int fd, int timeout_ms)
+{
+	struct pollfd pfd;
+	int ret;
+
+	pfd.events = POLLIN;
+	pfd.revents = 0;
+	pfd.fd = fd;
+
+	do {
+		ret = poll(&pfd, 1, 10);
+		if (interrupted)
+			break;
+		if (ret == -1)
+			error(1, errno, "poll");
+		if (ret == 0) {
+			if (!timeout_ms)
+				continue;
+
+			timeout_ms -= 10;
+			if (timeout_ms <= 0) {
+				interrupted = true;
+				break;
+			}
+
+			/* no events and more time to wait, do poll again */
+			continue;
+		}
+		if (pfd.revents != POLLIN)
+			error(1, errno, "poll: 0x%x expected 0x%x\n",
+					pfd.revents, POLLIN);
+	} while (!ret);
+}
+
+static int do_socket(bool do_tcp)
+{
+	int fd, val;
+
+	fd = socket(cfg_family, cfg_tcp ? SOCK_STREAM : SOCK_DGRAM, 0);
+	if (fd == -1)
+		error(1, errno, "socket");
+
+	val = 1 << 21;
+	if (setsockopt(fd, SOL_SOCKET, SO_RCVBUF, &val, sizeof(val)))
+		error(1, errno, "setsockopt rcvbuf");
+	val = 1;
+	if (setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val)))
+		error(1, errno, "setsockopt reuseport");
+
+	if (bind(fd, (void *)&cfg_bind_addr, cfg_alen))
+		error(1, errno, "bind");
+
+	if (do_tcp) {
+		int accept_fd = fd;
+
+		if (listen(accept_fd, 1))
+			error(1, errno, "listen");
+
+		do_poll(accept_fd, cfg_connect_timeout_ms);
+		if (interrupted)
+			exit(0);
+
+		fd = accept(accept_fd, NULL, NULL);
+		if (fd == -1)
+			error(1, errno, "accept");
+		if (close(accept_fd))
+			error(1, errno, "close accept fd");
+	}
+
+	return fd;
+}
+
+/* Flush all outstanding bytes for the tcp receive queue */
+static void do_flush_tcp(int fd)
+{
+	int ret;
+
+	while (true) {
+		/* MSG_TRUNC flushes up to len bytes */
+		ret = recv(fd, NULL, 1 << 21, MSG_TRUNC | MSG_DONTWAIT);
+		if (ret == -1 && errno == EAGAIN)
+			return;
+		if (ret == -1)
+			error(1, errno, "flush");
+		if (ret == 0) {
+			/* client detached */
+			exit(0);
+		}
+
+		packets++;
+		bytes += ret;
+	}
+
+}
+
+static char sanitized_char(char val)
+{
+	return (val >= 'a' && val <= 'z') ? val : '.';
+}
+
+static void do_verify_udp(const char *data, int len)
+{
+	char cur = data[0];
+	int i;
+
+	/* verify contents */
+	if (cur < 'a' || cur > 'z')
+		error(1, 0, "data initial byte out of range");
+
+	for (i = 1; i < len; i++) {
+		if (cur == 'z')
+			cur = 'a';
+		else
+			cur++;
+
+		if (data[i] != cur)
+			error(1, 0, "data[%d]: len %d, %c(%hhu) != %c(%hhu)\n",
+			      i, len,
+			      sanitized_char(data[i]), data[i],
+			      sanitized_char(cur), cur);
+	}
+}
+
+static int recv_msg(int fd, char *buf, int len, int *gso_size)
+{
+	char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	struct cmsghdr *cmsg;
+	uint16_t *gsosizeptr;
+	int ret;
+
+	iov.iov_base = buf;
+	iov.iov_len = len;
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+
+	*gso_size = -1;
+	ret = recvmsg(fd, &msg, MSG_TRUNC | MSG_DONTWAIT);
+	if (ret != -1) {
+		for (cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL;
+		     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
+			if (cmsg->cmsg_level == SOL_UDP
+			    && cmsg->cmsg_type == UDP_GRO) {
+				gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
+				*gso_size = *gsosizeptr;
+				break;
+			}
+		}
+	}
+	return ret;
+}
+
+/* Flush all outstanding datagrams. Verify first few bytes of each. */
+static void do_flush_udp(int fd)
+{
+	static char rbuf[ETH_MAX_MTU];
+	int ret, len, gso_size, budget = 256;
+
+	len = cfg_read_all ? sizeof(rbuf) : 0;
+	while (budget--) {
+		/* MSG_TRUNC will make return value full datagram length */
+		if (!cfg_expected_gso_size)
+			ret = recv(fd, rbuf, len, MSG_TRUNC | MSG_DONTWAIT);
+		else
+			ret = recv_msg(fd, rbuf, len, &gso_size);
+		if (ret == -1 && errno == EAGAIN)
+			break;
+		if (ret == -1)
+			error(1, errno, "recv");
+		if (cfg_expected_pkt_len && ret != cfg_expected_pkt_len)
+			error(1, 0, "recv: bad packet len, got %d,"
+			      " expected %d\n", ret, cfg_expected_pkt_len);
+		if (len && cfg_verify) {
+			if (ret == 0)
+				error(1, errno, "recv: 0 byte datagram\n");
+
+			do_verify_udp(rbuf, ret);
+		}
+		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
+			error(1, 0, "recv: bad gso size, got %d, expected %d "
+			      "(-1 == no gso cmsg))\n", gso_size,
+			      cfg_expected_gso_size);
+
+		packets++;
+		bytes += ret;
+		if (cfg_expected_pkt_nr && packets >= cfg_expected_pkt_nr)
+			break;
+	}
+}
+
+static void usage(const char *filepath)
+{
+	error(1, 0, "Usage: %s [-C connect_timeout] [-Grtv] [-b addr] [-p port]"
+	      " [-l pktlen] [-n packetnr] [-R rcv_timeout] [-S gsosize]",
+	      filepath);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	const char *bind_addr = NULL;
+	int c;
+
+	while ((c = getopt(argc, argv, "4b:C:Gl:n:p:rR:S:tv")) != -1) {
+		switch (c) {
+		case '4':
+			cfg_family = PF_INET;
+			cfg_alen = sizeof(struct sockaddr_in);
+			break;
+		case 'b':
+			bind_addr = optarg;
+			break;
+		case 'C':
+			cfg_connect_timeout_ms = strtoul(optarg, NULL, 0);
+			break;
+		case 'G':
+			cfg_gro_segment = true;
+			break;
+		case 'l':
+			cfg_expected_pkt_len = strtoul(optarg, NULL, 0);
+			break;
+		case 'n':
+			cfg_expected_pkt_nr = strtoul(optarg, NULL, 0);
+			break;
+		case 'p':
+			cfg_port = strtoul(optarg, NULL, 0);
+			break;
+		case 'r':
+			cfg_read_all = true;
+			break;
+		case 'R':
+			cfg_rcv_timeout_ms = strtoul(optarg, NULL, 0);
+			break;
+		case 'S':
+			cfg_expected_gso_size = strtol(optarg, NULL, 0);
+			break;
+		case 't':
+			cfg_tcp = true;
+			break;
+		case 'v':
+			cfg_verify = true;
+			cfg_read_all = true;
+			break;
+		}
+	}
+
+	if (!bind_addr)
+		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
+
+	setup_sockaddr(cfg_family, bind_addr, &cfg_bind_addr);
+
+	if (optind != argc)
+		usage(argv[0]);
+
+	if (cfg_tcp && cfg_verify)
+		error(1, 0, "TODO: implement verify mode for tcp");
+}
+
+static void do_recv(void)
+{
+	int timeout_ms = cfg_tcp ? cfg_rcv_timeout_ms : cfg_connect_timeout_ms;
+	unsigned long tnow, treport;
+	int fd;
+
+	fd = do_socket(cfg_tcp);
+
+	if (cfg_gro_segment && !cfg_tcp) {
+		int val = 1;
+		if (setsockopt(fd, IPPROTO_UDP, UDP_GRO, &val, sizeof(val)))
+			error(1, errno, "setsockopt UDP_GRO");
+	}
+
+	treport = gettimeofday_ms() + 1000;
+	do {
+		do_poll(fd, timeout_ms);
+
+		if (cfg_tcp)
+			do_flush_tcp(fd);
+		else
+			do_flush_udp(fd);
+
+		tnow = gettimeofday_ms();
+		if (tnow > treport) {
+			if (packets)
+				fprintf(stderr,
+					"%s rx: %6lu MB/s %8lu calls/s\n",
+					cfg_tcp ? "tcp" : "udp",
+					bytes >> 20, packets);
+			bytes = packets = 0;
+			treport = tnow + 1000;
+		}
+
+		timeout_ms = cfg_rcv_timeout_ms;
+
+	} while (!interrupted);
+
+	if (cfg_expected_pkt_nr && (packets != cfg_expected_pkt_nr))
+		error(1, 0, "wrong packet number! got %ld, expected %d\n",
+		      packets, cfg_expected_pkt_nr);
+
+	if (close(fd))
+		error(1, errno, "close");
+}
+
+int main(int argc, char **argv)
+{
+	parse_opts(argc, argv);
+
+	signal(SIGINT, sigint_handler);
+
+	do_recv();
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/udpgso_bench_tx.c b/tools/testing/selftests/bpf/udpgso_bench_tx.c
new file mode 100644
index 0000000..f1fdaa2
--- /dev/null
+++ b/tools/testing/selftests/bpf/udpgso_bench_tx.c
@@ -0,0 +1,712 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <errno.h>
+#include <error.h>
+#include <linux/errqueue.h>
+#include <linux/net_tstamp.h>
+#include <netinet/if_ether.h>
+#include <netinet/in.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <netinet/udp.h>
+#include <poll.h>
+#include <sched.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <sys/time.h>
+#include <sys/poll.h>
+#include <sys/types.h>
+#include <unistd.h>
+
+#include "../kselftest.h"
+
+#ifndef ETH_MAX_MTU
+#define ETH_MAX_MTU 0xFFFFU
+#endif
+
+#ifndef UDP_SEGMENT
+#define UDP_SEGMENT		103
+#endif
+
+#ifndef SO_ZEROCOPY
+#define SO_ZEROCOPY	60
+#endif
+
+#ifndef SO_EE_ORIGIN_ZEROCOPY
+#define SO_EE_ORIGIN_ZEROCOPY 5
+#endif
+
+#ifndef MSG_ZEROCOPY
+#define MSG_ZEROCOPY	0x4000000
+#endif
+
+#ifndef ENOTSUPP
+#define ENOTSUPP	524
+#endif
+
+#define NUM_PKT		100
+
+static bool	cfg_cache_trash;
+static int	cfg_cpu		= -1;
+static int	cfg_connected	= true;
+static int	cfg_family	= PF_UNSPEC;
+static uint16_t	cfg_mss;
+static int	cfg_payload_len	= (1472 * 42);
+static int	cfg_port	= 8000;
+static int	cfg_runtime_ms	= -1;
+static bool	cfg_poll;
+static bool	cfg_segment;
+static bool	cfg_sendmmsg;
+static bool	cfg_tcp;
+static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
+static bool	cfg_tx_tstamp;
+static bool	cfg_audit;
+static bool	cfg_verbose;
+static bool	cfg_zerocopy;
+static int	cfg_msg_nr;
+static uint16_t	cfg_gso_size;
+static unsigned long total_num_msgs;
+static unsigned long total_num_sends;
+static unsigned long stat_tx_ts;
+static unsigned long stat_tx_ts_errors;
+static unsigned long tstart;
+static unsigned long tend;
+static unsigned long stat_zcopies;
+
+static socklen_t cfg_alen;
+static struct sockaddr_storage cfg_dst_addr;
+
+static bool interrupted;
+static char buf[NUM_PKT][ETH_MAX_MTU];
+
+static void sigint_handler(int signum)
+{
+	if (signum == SIGINT)
+		interrupted = true;
+}
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+static int set_cpu(int cpu)
+{
+	cpu_set_t mask;
+
+	CPU_ZERO(&mask);
+	CPU_SET(cpu, &mask);
+	if (sched_setaffinity(0, sizeof(mask), &mask))
+		error(1, 0, "setaffinity %d", cpu);
+
+	return 0;
+}
+
+static void setup_sockaddr(int domain, const char *str_addr, void *sockaddr)
+{
+	struct sockaddr_in6 *addr6 = (void *) sockaddr;
+	struct sockaddr_in *addr4 = (void *) sockaddr;
+
+	switch (domain) {
+	case PF_INET:
+		addr4->sin_family = AF_INET;
+		addr4->sin_port = htons(cfg_port);
+		if (inet_pton(AF_INET, str_addr, &(addr4->sin_addr)) != 1)
+			error(1, 0, "ipv4 parse error: %s", str_addr);
+		break;
+	case PF_INET6:
+		addr6->sin6_family = AF_INET6;
+		addr6->sin6_port = htons(cfg_port);
+		if (inet_pton(AF_INET6, str_addr, &(addr6->sin6_addr)) != 1)
+			error(1, 0, "ipv6 parse error: %s", str_addr);
+		break;
+	default:
+		error(1, 0, "illegal domain");
+	}
+}
+
+static void flush_cmsg(struct cmsghdr *cmsg)
+{
+	struct sock_extended_err *err;
+	struct scm_timestamping *tss;
+	__u32 lo;
+	__u32 hi;
+	int i;
+
+	switch (cmsg->cmsg_level) {
+	case SOL_SOCKET:
+		if (cmsg->cmsg_type == SO_TIMESTAMPING) {
+			i = (cfg_tx_ts == SOF_TIMESTAMPING_TX_HARDWARE) ? 2 : 0;
+			tss = (struct scm_timestamping *)CMSG_DATA(cmsg);
+			if (tss->ts[i].tv_sec == 0)
+				stat_tx_ts_errors++;
+		} else {
+			error(1, 0, "unknown SOL_SOCKET cmsg type=%u\n",
+			      cmsg->cmsg_type);
+		}
+		break;
+	case SOL_IP:
+	case SOL_IPV6:
+		switch (cmsg->cmsg_type) {
+		case IP_RECVERR:
+		case IPV6_RECVERR:
+		{
+			err = (struct sock_extended_err *)CMSG_DATA(cmsg);
+			switch (err->ee_origin) {
+			case SO_EE_ORIGIN_TIMESTAMPING:
+				/* Got a TX timestamp from error queue */
+				stat_tx_ts++;
+				break;
+			case SO_EE_ORIGIN_ICMP:
+			case SO_EE_ORIGIN_ICMP6:
+				if (cfg_verbose)
+					fprintf(stderr,
+						"received ICMP error: type=%u, code=%u\n",
+						err->ee_type, err->ee_code);
+				break;
+			case SO_EE_ORIGIN_ZEROCOPY:
+			{
+				lo = err->ee_info;
+				hi = err->ee_data;
+				/* range of IDs acknowledged */
+				stat_zcopies += hi - lo + 1;
+				break;
+			}
+			case SO_EE_ORIGIN_LOCAL:
+				if (cfg_verbose)
+					fprintf(stderr,
+						"received packet with local origin: %u\n",
+						err->ee_origin);
+				break;
+			default:
+				error(0, 1, "received packet with origin: %u",
+				      err->ee_origin);
+			}
+			break;
+		}
+		default:
+			error(0, 1, "unknown IP msg type=%u\n",
+			      cmsg->cmsg_type);
+			break;
+		}
+		break;
+	default:
+		error(0, 1, "unknown cmsg level=%u\n",
+		      cmsg->cmsg_level);
+	}
+}
+
+static void flush_errqueue_recv(int fd)
+{
+	char control[CMSG_SPACE(sizeof(struct scm_timestamping)) +
+		     CMSG_SPACE(sizeof(struct sock_extended_err)) +
+		     CMSG_SPACE(sizeof(struct sockaddr_in6))] = {0};
+	struct msghdr msg = {0};
+	struct cmsghdr *cmsg;
+	int ret;
+
+	while (1) {
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
+		ret = recvmsg(fd, &msg, MSG_ERRQUEUE);
+		if (ret == -1 && errno == EAGAIN)
+			break;
+		if (ret == -1)
+			error(1, errno, "errqueue");
+		if (msg.msg_flags != MSG_ERRQUEUE)
+			error(1, 0, "errqueue: flags 0x%x\n", msg.msg_flags);
+		if (cfg_audit) {
+			for (cmsg = CMSG_FIRSTHDR(&msg);
+					cmsg;
+					cmsg = CMSG_NXTHDR(&msg, cmsg))
+				flush_cmsg(cmsg);
+		}
+		msg.msg_flags = 0;
+	}
+}
+
+static void flush_errqueue(int fd, const bool do_poll)
+{
+	if (do_poll) {
+		struct pollfd fds = {0};
+		int ret;
+
+		fds.fd = fd;
+		ret = poll(&fds, 1, 500);
+		if (ret == 0) {
+			if (cfg_verbose)
+				fprintf(stderr, "poll timeout\n");
+		} else if (ret < 0) {
+			error(1, errno, "poll");
+		}
+	}
+
+	flush_errqueue_recv(fd);
+}
+
+static int send_tcp(int fd, char *data)
+{
+	int ret, done = 0, count = 0;
+
+	while (done < cfg_payload_len) {
+		ret = send(fd, data + done, cfg_payload_len - done,
+			   cfg_zerocopy ? MSG_ZEROCOPY : 0);
+		if (ret == -1)
+			error(1, errno, "write");
+
+		done += ret;
+		count++;
+	}
+
+	return count;
+}
+
+static int send_udp(int fd, char *data)
+{
+	int ret, total_len, len, count = 0;
+
+	total_len = cfg_payload_len;
+
+	while (total_len) {
+		len = total_len < cfg_mss ? total_len : cfg_mss;
+
+		ret = sendto(fd, data, len, cfg_zerocopy ? MSG_ZEROCOPY : 0,
+			     cfg_connected ? NULL : (void *)&cfg_dst_addr,
+			     cfg_connected ? 0 : cfg_alen);
+		if (ret == -1)
+			error(1, errno, "write");
+		if (ret != len)
+			error(1, errno, "write: %uB != %uB\n", ret, len);
+
+		total_len -= len;
+		count++;
+	}
+
+	return count;
+}
+
+static void send_ts_cmsg(struct cmsghdr *cm)
+{
+	uint32_t *valp;
+
+	cm->cmsg_level = SOL_SOCKET;
+	cm->cmsg_type = SO_TIMESTAMPING;
+	cm->cmsg_len = CMSG_LEN(sizeof(cfg_tx_ts));
+	valp = (void *)CMSG_DATA(cm);
+	*valp = cfg_tx_ts;
+}
+
+static int send_udp_sendmmsg(int fd, char *data)
+{
+	char control[CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
+	const int max_nr_msg = ETH_MAX_MTU / ETH_DATA_LEN;
+	struct mmsghdr mmsgs[max_nr_msg];
+	struct iovec iov[max_nr_msg];
+	unsigned int off = 0, left;
+	size_t msg_controllen = 0;
+	int i = 0, ret;
+
+	memset(mmsgs, 0, sizeof(mmsgs));
+
+	if (cfg_tx_tstamp) {
+		struct msghdr msg = {0};
+		struct cmsghdr *cmsg;
+
+		msg.msg_control = control;
+		msg.msg_controllen = sizeof(control);
+		cmsg = CMSG_FIRSTHDR(&msg);
+		send_ts_cmsg(cmsg);
+		msg_controllen += CMSG_SPACE(sizeof(cfg_tx_ts));
+	}
+
+	left = cfg_payload_len;
+	while (left) {
+		if (i == max_nr_msg)
+			error(1, 0, "sendmmsg: exceeds max_nr_msg");
+
+		iov[i].iov_base = data + off;
+		iov[i].iov_len = cfg_mss < left ? cfg_mss : left;
+
+		mmsgs[i].msg_hdr.msg_iov = iov + i;
+		mmsgs[i].msg_hdr.msg_iovlen = 1;
+
+		mmsgs[i].msg_hdr.msg_name = (void *)&cfg_dst_addr;
+		mmsgs[i].msg_hdr.msg_namelen = cfg_alen;
+		if (msg_controllen) {
+			mmsgs[i].msg_hdr.msg_control = control;
+			mmsgs[i].msg_hdr.msg_controllen = msg_controllen;
+		}
+
+		off += iov[i].iov_len;
+		left -= iov[i].iov_len;
+		i++;
+	}
+
+	ret = sendmmsg(fd, mmsgs, i, cfg_zerocopy ? MSG_ZEROCOPY : 0);
+	if (ret == -1)
+		error(1, errno, "sendmmsg");
+
+	return ret;
+}
+
+static void send_udp_segment_cmsg(struct cmsghdr *cm)
+{
+	uint16_t *valp;
+
+	cm->cmsg_level = SOL_UDP;
+	cm->cmsg_type = UDP_SEGMENT;
+	cm->cmsg_len = CMSG_LEN(sizeof(cfg_gso_size));
+	valp = (void *)CMSG_DATA(cm);
+	*valp = cfg_gso_size;
+}
+
+static int send_udp_segment(int fd, char *data)
+{
+	char control[CMSG_SPACE(sizeof(cfg_gso_size)) +
+		     CMSG_SPACE(sizeof(cfg_tx_ts))] = {0};
+	struct msghdr msg = {0};
+	struct iovec iov = {0};
+	size_t msg_controllen;
+	struct cmsghdr *cmsg;
+	int ret;
+
+	iov.iov_base = data;
+	iov.iov_len = cfg_payload_len;
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+	cmsg = CMSG_FIRSTHDR(&msg);
+	send_udp_segment_cmsg(cmsg);
+	msg_controllen = CMSG_SPACE(sizeof(cfg_mss));
+	if (cfg_tx_tstamp) {
+		cmsg = CMSG_NXTHDR(&msg, cmsg);
+		send_ts_cmsg(cmsg);
+		msg_controllen += CMSG_SPACE(sizeof(cfg_tx_ts));
+	}
+
+	msg.msg_controllen = msg_controllen;
+	msg.msg_name = (void *)&cfg_dst_addr;
+	msg.msg_namelen = cfg_alen;
+
+	ret = sendmsg(fd, &msg, cfg_zerocopy ? MSG_ZEROCOPY : 0);
+	if (ret == -1)
+		error(1, errno, "sendmsg");
+	if (ret != iov.iov_len)
+		error(1, 0, "sendmsg: %u != %llu\n", ret,
+			(unsigned long long)iov.iov_len);
+
+	return 1;
+}
+
+static void usage(const char *filepath)
+{
+	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
+		    filepath);
+}
+
+static void parse_opts(int argc, char **argv)
+{
+	const char *bind_addr = NULL;
+	int max_len, hdrlen;
+	int c;
+
+	while ((c = getopt(argc, argv, "46acC:D:Hl:mM:p:s:PS:tTuvz")) != -1) {
+		switch (c) {
+		case '4':
+			if (cfg_family != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			cfg_family = PF_INET;
+			cfg_alen = sizeof(struct sockaddr_in);
+			break;
+		case '6':
+			if (cfg_family != PF_UNSPEC)
+				error(1, 0, "Pass one of -4 or -6");
+			cfg_family = PF_INET6;
+			cfg_alen = sizeof(struct sockaddr_in6);
+			break;
+		case 'a':
+			cfg_audit = true;
+			break;
+		case 'c':
+			cfg_cache_trash = true;
+			break;
+		case 'C':
+			cfg_cpu = strtol(optarg, NULL, 0);
+			break;
+		case 'D':
+			bind_addr = optarg;
+			break;
+		case 'l':
+			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
+			break;
+		case 'm':
+			cfg_sendmmsg = true;
+			break;
+		case 'M':
+			cfg_msg_nr = strtoul(optarg, NULL, 10);
+			break;
+		case 'p':
+			cfg_port = strtoul(optarg, NULL, 0);
+			break;
+		case 'P':
+			cfg_poll = true;
+			break;
+		case 's':
+			cfg_payload_len = strtoul(optarg, NULL, 0);
+			break;
+		case 'S':
+			cfg_gso_size = strtoul(optarg, NULL, 0);
+			cfg_segment = true;
+			break;
+		case 'H':
+			cfg_tx_ts = SOF_TIMESTAMPING_TX_HARDWARE;
+			cfg_tx_tstamp = true;
+			break;
+		case 't':
+			cfg_tcp = true;
+			break;
+		case 'T':
+			cfg_tx_tstamp = true;
+			break;
+		case 'u':
+			cfg_connected = false;
+			break;
+		case 'v':
+			cfg_verbose = true;
+			break;
+		case 'z':
+			cfg_zerocopy = true;
+			break;
+		}
+	}
+
+	if (!bind_addr)
+		bind_addr = cfg_family == PF_INET6 ? "::" : "0.0.0.0";
+
+	setup_sockaddr(cfg_family, bind_addr, &cfg_dst_addr);
+
+	if (optind != argc)
+		usage(argv[0]);
+
+	if (cfg_family == PF_UNSPEC)
+		error(1, 0, "must pass one of -4 or -6");
+	if (cfg_tcp && !cfg_connected)
+		error(1, 0, "connectionless tcp makes no sense");
+	if (cfg_segment && cfg_sendmmsg)
+		error(1, 0, "cannot combine segment offload and sendmmsg");
+	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg))
+		error(1, 0, "Options -T and -H require either -S or -m option");
+
+	if (cfg_family == PF_INET)
+		hdrlen = sizeof(struct iphdr) + sizeof(struct udphdr);
+	else
+		hdrlen = sizeof(struct ip6_hdr) + sizeof(struct udphdr);
+
+	cfg_mss = ETH_DATA_LEN - hdrlen;
+	max_len = ETH_MAX_MTU - hdrlen;
+	if (!cfg_gso_size)
+		cfg_gso_size = cfg_mss;
+
+	if (cfg_payload_len > max_len)
+		error(1, 0, "payload length %u exceeds max %u",
+		      cfg_payload_len, max_len);
+}
+
+static void set_pmtu_discover(int fd, bool is_ipv4)
+{
+	int level, name, val;
+
+	if (is_ipv4) {
+		level	= SOL_IP;
+		name	= IP_MTU_DISCOVER;
+		val	= IP_PMTUDISC_DO;
+	} else {
+		level	= SOL_IPV6;
+		name	= IPV6_MTU_DISCOVER;
+		val	= IPV6_PMTUDISC_DO;
+	}
+
+	if (setsockopt(fd, level, name, &val, sizeof(val)))
+		error(1, errno, "setsockopt path mtu");
+}
+
+static void set_tx_timestamping(int fd)
+{
+	int val = SOF_TIMESTAMPING_OPT_CMSG | SOF_TIMESTAMPING_OPT_ID |
+			SOF_TIMESTAMPING_OPT_TSONLY;
+
+	if (cfg_tx_ts == SOF_TIMESTAMPING_TX_SOFTWARE)
+		val |= SOF_TIMESTAMPING_SOFTWARE;
+	else
+		val |= SOF_TIMESTAMPING_RAW_HARDWARE;
+
+	if (setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val)))
+		error(1, errno, "setsockopt tx timestamping");
+}
+
+static void print_audit_report(unsigned long num_msgs, unsigned long num_sends)
+{
+	unsigned long tdelta;
+
+	tdelta = tend - tstart;
+	if (!tdelta)
+		return;
+
+	fprintf(stderr, "Summary over %lu.%03lu seconds...\n",
+			tdelta / 1000, tdelta % 1000);
+	fprintf(stderr,
+		"sum %s tx: %6lu MB/s %10lu calls (%lu/s) %10lu msgs (%lu/s)\n",
+		cfg_tcp ? "tcp" : "udp",
+		((num_msgs * cfg_payload_len) >> 10) / tdelta,
+		num_sends, num_sends * 1000 / tdelta,
+		num_msgs, num_msgs * 1000 / tdelta);
+
+	if (cfg_tx_tstamp) {
+		if (stat_tx_ts_errors)
+			error(1, 0,
+			      "Expected clean TX Timestamps: %9lu msgs received %6lu errors",
+			      stat_tx_ts, stat_tx_ts_errors);
+		if (stat_tx_ts != num_sends)
+			error(1, 0,
+			      "Unexpected number of TX Timestamps: %9lu expected %9lu received",
+			      num_sends, stat_tx_ts);
+		fprintf(stderr,
+			"Tx Timestamps: %19lu received %17lu errors\n",
+			stat_tx_ts, stat_tx_ts_errors);
+	}
+
+	if (cfg_zerocopy) {
+		if (stat_zcopies != num_sends)
+			error(1, 0, "Unexpected number of Zerocopy completions: %9lu expected %9lu received",
+			      num_sends, stat_zcopies);
+		fprintf(stderr,
+			"Zerocopy acks: %19lu\n",
+			stat_zcopies);
+	}
+}
+
+static void print_report(unsigned long num_msgs, unsigned long num_sends)
+{
+	fprintf(stderr,
+		"%s tx: %6lu MB/s %8lu calls/s %6lu msg/s\n",
+		cfg_tcp ? "tcp" : "udp",
+		(num_msgs * cfg_payload_len) >> 20,
+		num_sends, num_msgs);
+
+	if (cfg_audit) {
+		total_num_msgs += num_msgs;
+		total_num_sends += num_sends;
+	}
+}
+
+int main(int argc, char **argv)
+{
+	unsigned long num_msgs, num_sends;
+	unsigned long tnow, treport, tstop;
+	int fd, i, val, ret;
+
+	parse_opts(argc, argv);
+
+	if (cfg_cpu > 0)
+		set_cpu(cfg_cpu);
+
+	for (i = 0; i < sizeof(buf[0]); i++)
+		buf[0][i] = 'a' + (i % 26);
+	for (i = 1; i < NUM_PKT; i++)
+		memcpy(buf[i], buf[0], sizeof(buf[0]));
+
+	signal(SIGINT, sigint_handler);
+
+	fd = socket(cfg_family, cfg_tcp ? SOCK_STREAM : SOCK_DGRAM, 0);
+	if (fd == -1)
+		error(1, errno, "socket");
+
+	if (cfg_zerocopy) {
+		val = 1;
+
+		ret = setsockopt(fd, SOL_SOCKET, SO_ZEROCOPY,
+				 &val, sizeof(val));
+		if (ret) {
+			if (errno == ENOPROTOOPT || errno == ENOTSUPP) {
+				fprintf(stderr, "SO_ZEROCOPY not supported");
+				exit(KSFT_SKIP);
+			}
+			error(1, errno, "setsockopt zerocopy");
+		}
+	}
+
+	if (cfg_connected &&
+	    connect(fd, (void *)&cfg_dst_addr, cfg_alen))
+		error(1, errno, "connect");
+
+	if (cfg_segment)
+		set_pmtu_discover(fd, cfg_family == PF_INET);
+
+	if (cfg_tx_tstamp)
+		set_tx_timestamping(fd);
+
+	num_msgs = num_sends = 0;
+	tnow = gettimeofday_ms();
+	tstart = tnow;
+	tend = tnow;
+	tstop = tnow + cfg_runtime_ms;
+	treport = tnow + 1000;
+
+	i = 0;
+	do {
+		if (cfg_tcp)
+			num_sends += send_tcp(fd, buf[i]);
+		else if (cfg_segment)
+			num_sends += send_udp_segment(fd, buf[i]);
+		else if (cfg_sendmmsg)
+			num_sends += send_udp_sendmmsg(fd, buf[i]);
+		else
+			num_sends += send_udp(fd, buf[i]);
+		num_msgs++;
+		if ((cfg_zerocopy && ((num_msgs & 0xF) == 0)) || cfg_tx_tstamp)
+			flush_errqueue(fd, cfg_poll);
+
+		if (cfg_msg_nr && num_msgs >= cfg_msg_nr)
+			break;
+
+		tnow = gettimeofday_ms();
+		if (tnow >= treport) {
+			print_report(num_msgs, num_sends);
+			num_msgs = num_sends = 0;
+			treport = tnow + 1000;
+		}
+
+		/* cold cache when writing buffer */
+		if (cfg_cache_trash)
+			i = ++i < NUM_PKT ? i : 0;
+
+	} while (!interrupted && (cfg_runtime_ms == -1 || tnow < tstop));
+
+	if (cfg_zerocopy || cfg_tx_tstamp)
+		flush_errqueue(fd, true);
+
+	if (close(fd))
+		error(1, errno, "close");
+
+	if (cfg_audit) {
+		tend = tnow;
+		total_num_msgs += num_msgs;
+		total_num_sends += num_sends;
+		print_audit_report(total_num_msgs, total_num_sends);
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 69c5836..a2ac42a 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -76,8 +76,6 @@ TEST_FILES := settings
 
 include ../lib.mk
 
-include bpf/Makefile
-
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
deleted file mode 100644
index 8ccaf87..0000000
--- a/tools/testing/selftests/net/bpf/Makefile
+++ /dev/null
@@ -1,14 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-
-CLANG ?= clang
-CCINCLUDE += -I../../bpf
-CCINCLUDE += -I../../../../lib
-CCINCLUDE += -I../../../../../usr/include/
-
-TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
-all: $(TEST_CUSTOM_PROGS)
-
-$(OUTPUT)/%.o: %.c
-	$(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
-
-EXTRA_CLEAN := $(TEST_CUSTOM_PROGS)
diff --git a/tools/testing/selftests/net/bpf/nat6to4.c b/tools/testing/selftests/net/bpf/nat6to4.c
deleted file mode 100644
index ac54c36..0000000
--- a/tools/testing/selftests/net/bpf/nat6to4.c
+++ /dev/null
@@ -1,285 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/*
- * This code is taken from the Android Open Source Project and the author
- * (Maciej Żenczykowski) has gave permission to relicense it under the
- * GPLv2. Therefore this program is free software;
- * You can redistribute it and/or modify it under the terms of the GNU
- * General Public License version 2 as published by the Free Software
- * Foundation
-
- * The original headers, including the original license headers, are
- * included below for completeness.
- *
- * Copyright (C) 2019 The Android Open Source Project
- *
- * Licensed under the Apache License, Version 2.0 (the "License");
- * you may not use this file except in compliance with the License.
- * You may obtain a copy of the License at
- *
- *      http://www.apache.org/licenses/LICENSE-2.0
- *
- * Unless required by applicable law or agreed to in writing, software
- * distributed under the License is distributed on an "AS IS" BASIS,
- * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
- * See the License for the specific language governing permissions and
- * limitations under the License.
- */
-#include <linux/bpf.h>
-#include <linux/if.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-#include <linux/in.h>
-#include <linux/in6.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/pkt_cls.h>
-#include <linux/swab.h>
-#include <stdbool.h>
-#include <stdint.h>
-
-
-#include <linux/udp.h>
-
-#include <bpf/bpf_helpers.h>
-#include <bpf/bpf_endian.h>
-
-#define IP_DF 0x4000  // Flag: "Don't Fragment"
-
-SEC("schedcls/ingress6/nat_6")
-int sched_cls_ingress6_nat_6_prog(struct __sk_buff *skb)
-{
-	const int l2_header_size =  sizeof(struct ethhdr);
-	void *data = (void *)(long)skb->data;
-	const void *data_end = (void *)(long)skb->data_end;
-	const struct ethhdr * const eth = data;  // used iff is_ethernet
-	const struct ipv6hdr * const ip6 =  (void *)(eth + 1);
-
-	// Require ethernet dst mac address to be our unicast address.
-	if  (skb->pkt_type != PACKET_HOST)
-		return TC_ACT_OK;
-
-	// Must be meta-ethernet IPv6 frame
-	if (skb->protocol != bpf_htons(ETH_P_IPV6))
-		return TC_ACT_OK;
-
-	// Must have (ethernet and) ipv6 header
-	if (data + l2_header_size + sizeof(*ip6) > data_end)
-		return TC_ACT_OK;
-
-	// Ethertype - if present - must be IPv6
-	if (eth->h_proto != bpf_htons(ETH_P_IPV6))
-		return TC_ACT_OK;
-
-	// IP version must be 6
-	if (ip6->version != 6)
-		return TC_ACT_OK;
-	// Maximum IPv6 payload length that can be translated to IPv4
-	if (bpf_ntohs(ip6->payload_len) > 0xFFFF - sizeof(struct iphdr))
-		return TC_ACT_OK;
-	switch (ip6->nexthdr) {
-	case IPPROTO_TCP:  // For TCP & UDP the checksum neutrality of the chosen IPv6
-	case IPPROTO_UDP:  // address means there is no need to update their checksums.
-	case IPPROTO_GRE:  // We do not need to bother looking at GRE/ESP headers,
-	case IPPROTO_ESP:  // since there is never a checksum to update.
-		break;
-	default:  // do not know how to handle anything else
-		return TC_ACT_OK;
-	}
-
-	struct ethhdr eth2;  // used iff is_ethernet
-
-	eth2 = *eth;                     // Copy over the ethernet header (src/dst mac)
-	eth2.h_proto = bpf_htons(ETH_P_IP);  // But replace the ethertype
-
-	struct iphdr ip = {
-		.version = 4,                                                      // u4
-		.ihl = sizeof(struct iphdr) / sizeof(__u32),                       // u4
-		.tos = (ip6->priority << 4) + (ip6->flow_lbl[0] >> 4),             // u8
-		.tot_len = bpf_htons(bpf_ntohs(ip6->payload_len) + sizeof(struct iphdr)),  // u16
-		.id = 0,                                                           // u16
-		.frag_off = bpf_htons(IP_DF),                                          // u16
-		.ttl = ip6->hop_limit,                                             // u8
-		.protocol = ip6->nexthdr,                                          // u8
-		.check = 0,                                                        // u16
-		.saddr = 0x0201a8c0,                            // u32
-		.daddr = 0x0101a8c0,                                         // u32
-	};
-
-	// Calculate the IPv4 one's complement checksum of the IPv4 header.
-	__wsum sum4 = 0;
-
-	for (int i = 0; i < sizeof(ip) / sizeof(__u16); ++i)
-		sum4 += ((__u16 *)&ip)[i];
-
-	// Note that sum4 is guaranteed to be non-zero by virtue of ip.version == 4
-	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse u32 into range 1 .. 0x1FFFE
-	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse any potential carry into u16
-	ip.check = (__u16)~sum4;                // sum4 cannot be zero, so this is never 0xFFFF
-
-	// Calculate the *negative* IPv6 16-bit one's complement checksum of the IPv6 header.
-	__wsum sum6 = 0;
-	// We'll end up with a non-zero sum due to ip6->version == 6 (which has '0' bits)
-	for (int i = 0; i < sizeof(*ip6) / sizeof(__u16); ++i)
-		sum6 += ~((__u16 *)ip6)[i];  // note the bitwise negation
-
-	// Note that there is no L4 checksum update: we are relying on the checksum neutrality
-	// of the ipv6 address chosen by netd's ClatdController.
-
-	// Packet mutations begin - point of no return, but if this first modification fails
-	// the packet is probably still pristine, so let clatd handle it.
-	if (bpf_skb_change_proto(skb, bpf_htons(ETH_P_IP), 0))
-		return TC_ACT_OK;
-	bpf_csum_update(skb, sum6);
-
-	data = (void *)(long)skb->data;
-	data_end = (void *)(long)skb->data_end;
-	if (data + l2_header_size + sizeof(struct iphdr) > data_end)
-		return TC_ACT_SHOT;
-
-	struct ethhdr *new_eth = data;
-
-	// Copy over the updated ethernet header
-	*new_eth = eth2;
-
-	// Copy over the new ipv4 header.
-	*(struct iphdr *)(new_eth + 1) = ip;
-	return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
-}
-
-SEC("schedcls/egress4/snat4")
-int sched_cls_egress4_snat4_prog(struct __sk_buff *skb)
-{
-	const int l2_header_size =  sizeof(struct ethhdr);
-	void *data = (void *)(long)skb->data;
-	const void *data_end = (void *)(long)skb->data_end;
-	const struct ethhdr *const eth = data;  // used iff is_ethernet
-	const struct iphdr *const ip4 = (void *)(eth + 1);
-
-	// Must be meta-ethernet IPv4 frame
-	if (skb->protocol != bpf_htons(ETH_P_IP))
-		return TC_ACT_OK;
-
-	// Must have ipv4 header
-	if (data + l2_header_size + sizeof(struct ipv6hdr) > data_end)
-		return TC_ACT_OK;
-
-	// Ethertype - if present - must be IPv4
-	if (eth->h_proto != bpf_htons(ETH_P_IP))
-		return TC_ACT_OK;
-
-	// IP version must be 4
-	if (ip4->version != 4)
-		return TC_ACT_OK;
-
-	// We cannot handle IP options, just standard 20 byte == 5 dword minimal IPv4 header
-	if (ip4->ihl != 5)
-		return TC_ACT_OK;
-
-	// Maximum IPv6 payload length that can be translated to IPv4
-	if (bpf_htons(ip4->tot_len) > 0xFFFF - sizeof(struct ipv6hdr))
-		return TC_ACT_OK;
-
-	// Calculate the IPv4 one's complement checksum of the IPv4 header.
-	__wsum sum4 = 0;
-
-	for (int i = 0; i < sizeof(*ip4) / sizeof(__u16); ++i)
-		sum4 += ((__u16 *)ip4)[i];
-
-	// Note that sum4 is guaranteed to be non-zero by virtue of ip4->version == 4
-	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse u32 into range 1 .. 0x1FFFE
-	sum4 = (sum4 & 0xFFFF) + (sum4 >> 16);  // collapse any potential carry into u16
-	// for a correct checksum we should get *a* zero, but sum4 must be positive, ie 0xFFFF
-	if (sum4 != 0xFFFF)
-		return TC_ACT_OK;
-
-	// Minimum IPv4 total length is the size of the header
-	if (bpf_ntohs(ip4->tot_len) < sizeof(*ip4))
-		return TC_ACT_OK;
-
-	// We are incapable of dealing with IPv4 fragments
-	if (ip4->frag_off & ~bpf_htons(IP_DF))
-		return TC_ACT_OK;
-
-	switch (ip4->protocol) {
-	case IPPROTO_TCP:  // For TCP & UDP the checksum neutrality of the chosen IPv6
-	case IPPROTO_GRE:  // address means there is no need to update their checksums.
-	case IPPROTO_ESP:  // We do not need to bother looking at GRE/ESP headers,
-		break;         // since there is never a checksum to update.
-
-	case IPPROTO_UDP:  // See above comment, but must also have UDP header...
-		if (data + sizeof(*ip4) + sizeof(struct udphdr) > data_end)
-			return TC_ACT_OK;
-		const struct udphdr *uh = (const struct udphdr *)(ip4 + 1);
-		// If IPv4/UDP checksum is 0 then fallback to clatd so it can calculate the
-		// checksum.  Otherwise the network or more likely the NAT64 gateway might
-		// drop the packet because in most cases IPv6/UDP packets with a zero checksum
-		// are invalid. See RFC 6935.  TODO: calculate checksum via bpf_csum_diff()
-		if (!uh->check)
-			return TC_ACT_OK;
-		break;
-
-	default:  // do not know how to handle anything else
-		return TC_ACT_OK;
-	}
-	struct ethhdr eth2;  // used iff is_ethernet
-
-	eth2 = *eth;                     // Copy over the ethernet header (src/dst mac)
-	eth2.h_proto = bpf_htons(ETH_P_IPV6);  // But replace the ethertype
-
-	struct ipv6hdr ip6 = {
-		.version = 6,                                    // __u8:4
-		.priority = ip4->tos >> 4,                       // __u8:4
-		.flow_lbl = {(ip4->tos & 0xF) << 4, 0, 0},       // __u8[3]
-		.payload_len = bpf_htons(bpf_ntohs(ip4->tot_len) - 20),  // __be16
-		.nexthdr = ip4->protocol,                        // __u8
-		.hop_limit = ip4->ttl,                           // __u8
-	};
-	ip6.saddr.in6_u.u6_addr32[0] = bpf_htonl(0x20010db8);
-	ip6.saddr.in6_u.u6_addr32[1] = 0;
-	ip6.saddr.in6_u.u6_addr32[2] = 0;
-	ip6.saddr.in6_u.u6_addr32[3] = bpf_htonl(1);
-	ip6.daddr.in6_u.u6_addr32[0] = bpf_htonl(0x20010db8);
-	ip6.daddr.in6_u.u6_addr32[1] = 0;
-	ip6.daddr.in6_u.u6_addr32[2] = 0;
-	ip6.daddr.in6_u.u6_addr32[3] = bpf_htonl(2);
-
-	// Calculate the IPv6 16-bit one's complement checksum of the IPv6 header.
-	__wsum sum6 = 0;
-	// We'll end up with a non-zero sum due to ip6.version == 6
-	for (int i = 0; i < sizeof(ip6) / sizeof(__u16); ++i)
-		sum6 += ((__u16 *)&ip6)[i];
-
-	// Packet mutations begin - point of no return, but if this first modification fails
-	// the packet is probably still pristine, so let clatd handle it.
-	if (bpf_skb_change_proto(skb, bpf_htons(ETH_P_IPV6), 0))
-		return TC_ACT_OK;
-
-	// This takes care of updating the skb->csum field for a CHECKSUM_COMPLETE packet.
-	// In such a case, skb->csum is a 16-bit one's complement sum of the entire payload,
-	// thus we need to subtract out the ipv4 header's sum, and add in the ipv6 header's sum.
-	// However, we've already verified the ipv4 checksum is correct and thus 0.
-	// Thus we only need to add the ipv6 header's sum.
-	//
-	// bpf_csum_update() always succeeds if the skb is CHECKSUM_COMPLETE and returns an error
-	// (-ENOTSUPP) if it isn't.  So we just ignore the return code (see above for more details).
-	bpf_csum_update(skb, sum6);
-
-	// bpf_skb_change_proto() invalidates all pointers - reload them.
-	data = (void *)(long)skb->data;
-	data_end = (void *)(long)skb->data_end;
-
-	// I cannot think of any valid way for this error condition to trigger, however I do
-	// believe the explicit check is required to keep the in kernel ebpf verifier happy.
-	if (data + l2_header_size + sizeof(ip6) > data_end)
-		return TC_ACT_SHOT;
-
-	struct ethhdr *new_eth = data;
-
-	// Copy over the updated ethernet header
-	*new_eth = eth2;
-	// Copy over the new ipv4 header.
-	*(struct ipv6hdr *)(new_eth + 1) = ip6;
-	return TC_ACT_OK;
-}
-
-char _license[] SEC("license") = ("GPL");
diff --git a/tools/testing/selftests/net/udpgro_frglist.sh b/tools/testing/selftests/net/udpgro_frglist.sh
deleted file mode 100755
index 7f94175..0000000
--- a/tools/testing/selftests/net/udpgro_frglist.sh
+++ /dev/null
@@ -1,103 +0,0 @@
-#!/bin/bash
-# SPDX-License-Identifier: GPL-2.0
-#
-# Run a series of udpgro benchmarks
-
-readonly PEER_NS="ns-peer-$(mktemp -u XXXXXX)"
-
-BPF_FILE="../bpf/xdp_dummy.bpf.o"
-
-cleanup() {
-	local -r jobs="$(jobs -p)"
-	local -r ns="$(ip netns list|grep $PEER_NS)"
-
-	[ -n "${jobs}" ] && kill -INT ${jobs} 2>/dev/null
-	[ -n "$ns" ] && ip netns del $ns 2>/dev/null
-}
-trap cleanup EXIT
-
-run_one() {
-	# use 'rx' as separator between sender args and receiver args
-	local -r all="$@"
-	local -r tx_args=${all%rx*}
-	local rx_args=${all#*rx}
-
-
-
-	ip netns add "${PEER_NS}"
-	ip -netns "${PEER_NS}" link set lo up
-	ip link add type veth
-	ip link set dev veth0 up
-	ip addr add dev veth0 192.168.1.2/24
-	ip addr add dev veth0 2001:db8::2/64 nodad
-
-	ip link set dev veth1 netns "${PEER_NS}"
-	ip -netns "${PEER_NS}" addr add dev veth1 192.168.1.1/24
-	ip -netns "${PEER_NS}" addr add dev veth1 2001:db8::1/64 nodad
-	ip -netns "${PEER_NS}" link set dev veth1 up
-	ip netns exec "${PEER_NS}" ethtool -K veth1 rx-gro-list on
-
-
-	ip -n "${PEER_NS}" link set veth1 xdp object ${BPF_FILE} section xdp
-	tc -n "${PEER_NS}" qdisc add dev veth1 clsact
-	tc -n "${PEER_NS}" filter add dev veth1 ingress prio 4 protocol ipv6 bpf object-file ../bpf/nat6to4.o section schedcls/ingress6/nat_6  direct-action
-	tc -n "${PEER_NS}" filter add dev veth1 egress prio 4 protocol ip bpf object-file ../bpf/nat6to4.o section schedcls/egress4/snat4 direct-action
-        echo ${rx_args}
-	ip netns exec "${PEER_NS}" ./udpgso_bench_rx ${rx_args} -r &
-
-	# Hack: let bg programs complete the startup
-	sleep 0.2
-	./udpgso_bench_tx ${tx_args}
-}
-
-run_in_netns() {
-	local -r args=$@
-  echo ${args}
-	./in_netns.sh $0 __subprocess ${args}
-}
-
-run_udp() {
-	local -r args=$@
-
-	echo "udp gso - over veth touching data"
-	run_in_netns ${args} -u -S 0 rx -4 -v
-
-	echo "udp gso and gro - over veth touching data"
-	run_in_netns ${args} -S 0 rx -4 -G
-}
-
-run_tcp() {
-	local -r args=$@
-
-	echo "tcp - over veth touching data"
-	run_in_netns ${args} -t rx -4 -t
-}
-
-run_all() {
-	local -r core_args="-l 4"
-	local -r ipv4_args="${core_args} -4  -D 192.168.1.1"
-	local -r ipv6_args="${core_args} -6  -D 2001:db8::1"
-
-	echo "ipv6"
-	run_tcp "${ipv6_args}"
-	run_udp "${ipv6_args}"
-}
-
-if [ ! -f ${BPF_FILE} ]; then
-	echo "Missing xdp_dummy helper. Build bpf selftest first"
-	exit -1
-fi
-
-if [ ! -f bpf/nat6to4.o ]; then
-	echo "Missing nat6to4 helper. Build bpfnat6to4.o selftest first"
-	exit -1
-fi
-
-if [[ $# -eq 0 ]]; then
-	run_all
-elif [[ $1 == "__subprocess" ]]; then
-	shift
-	run_one $@
-else
-	run_in_netns $@
-fi
-- 
1.8.3.1

