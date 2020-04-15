Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCC61A97A7
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 10:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408184AbgDOIzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 04:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2408176AbgDOIzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 04:55:10 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9DFC061A0C;
        Wed, 15 Apr 2020 01:55:09 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id x2so12604719qtr.0;
        Wed, 15 Apr 2020 01:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZhnPGyz1mu7U3eg7DvuCcqnFTmEghyO5Zvc8DWdeHqM=;
        b=RDbRiq+NJ0wKvZRYedm/TuhknTn+JMU9P7ntJ4hDbzy4NaMoEXA7J/IWlX3DFn4rHS
         E0ndr5JWGQ0fOBmUPG0VHXk0r4gRlWUUMYQmVYY1KiMg37UahnR3v8EPKthT7q+nn3zz
         JI0qz+VAmkwPbE8/MGLcxj+XuKYGGDfUIkB+aOOcaw1Et0ctloeJvuS6R7cOpUp1xN3X
         FGzrLbY/1uypeOEswfyQNh0onq5BlGhAtztHOeI51NYSW2NnCWM/UUoLkVA7GkRAJA+u
         +0z806pyzP71IJXcpR7qwnquWNYdZCTMLueR5H0s0djL9oGTifTG9Ak8+TPQbmZsQuPS
         Wodg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZhnPGyz1mu7U3eg7DvuCcqnFTmEghyO5Zvc8DWdeHqM=;
        b=No8NNEVVxqiS1SzdjSjKg6qLf+gXvCXsZkYPizjC3IY43gqz3zZ/14PQzc6UcO1A7w
         Fgmno8TjvZmRc42URGX51MZE2DhLpPMI2rDqlOTLEsBJwzAM4SpNuaKe6m+mkIn3VytI
         0yNXKo7m6JCa0fAjJWmeo7aDXpZ1W19KCT/Wop9eX+kgbEA40t3pi3o7IyIgj2//gqDC
         lIosbmLuVCOYNVEXpenk4RIMYVxWN3wLVBWyJUSCy0jZP0kZMa0RqdG5exlU2tLk9Oa0
         yrCiCkL1V3z6t83xUina3BrxkQ2sICahzAHy2AB200B/If7OzNRx4VtyI17CaSTPwWNE
         d4Aw==
X-Gm-Message-State: AGi0PuYohgj7FTV0Nwfy6Fgjc62tlRe54G/XqbxZLsDjtNxPxJmpQeJt
        9guOZLO8/3qETm8xmsKi9xzlXP736Us=
X-Google-Smtp-Source: APiQypLTWfngh0EN/NhypC68EnOec+5/PpRicJiEcAWnLz3zl5gYqK7qkDVIKeToa4ec5MpWgU7zNQ==
X-Received: by 2002:ac8:2a68:: with SMTP id l37mr19902564qtl.77.1586940908443;
        Wed, 15 Apr 2020 01:55:08 -0700 (PDT)
Received: from dhcp-12-139.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o22sm1882750qtm.90.2020.04.15.01.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 01:55:07 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [RFC PATCH bpf-next 2/2] sample/bpf: add xdp_redirect_map_multicast test
Date:   Wed, 15 Apr 2020 16:54:37 +0800
Message-Id: <20200415085437.23028-3-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20200415085437.23028-1-liuhangbin@gmail.com>
References: <20200415085437.23028-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test is used for testing xdp multicast. It defined 3 groups
for different usage. Each interface in init net has different
exclude interfaces. In the test it tests both generic/native mode
and 3 different map-in-map types.

For more testing details, please see the test description in
xdp_redirect_map_multicast.sh.

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 samples/bpf/Makefile                          |   3 +
 samples/bpf/xdp_redirect_map_multicast.sh     | 142 ++++++++
 samples/bpf/xdp_redirect_map_multicast_kern.c | 147 +++++++++
 samples/bpf/xdp_redirect_map_multicast_user.c | 306 ++++++++++++++++++
 4 files changed, 598 insertions(+)
 create mode 100755 samples/bpf/xdp_redirect_map_multicast.sh
 create mode 100644 samples/bpf/xdp_redirect_map_multicast_kern.c
 create mode 100644 samples/bpf/xdp_redirect_map_multicast_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 424f6fe7ce38..55555b0267cf 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -41,6 +41,7 @@ tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
 tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
+tprogs-y += xdp_redirect_map_multicast
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_monitor
 tprogs-y += xdp_rxq_info
@@ -97,6 +98,7 @@ test_map_in_map-objs := bpf_load.o test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
 xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
+xdp_redirect_map_multicast-objs := bpf_load.o xdp_redirect_map_multicast_user.o
 xdp_redirect_cpu-objs := bpf_load.o xdp_redirect_cpu_user.o
 xdp_monitor-objs := bpf_load.o xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
@@ -156,6 +158,7 @@ always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
 always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
+always-y += xdp_redirect_map_multicast_kern.o
 always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_monitor_kern.o
 always-y += xdp_rxq_info_kern.o
diff --git a/samples/bpf/xdp_redirect_map_multicast.sh b/samples/bpf/xdp_redirect_map_multicast.sh
new file mode 100755
index 000000000000..01f825e33060
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multicast.sh
@@ -0,0 +1,142 @@
+#!/bin/bash
+# Test topology:
+#     - - - - - - - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3         veth4 |  init net
+#     - -| - - - - - - | - - - - - - | - - - - - - | - -
+#    ---------     ---------     ---------     ---------
+#    | veth0 |     | veth0 |     | veth0 |     | veth0 |
+#    ---------     ---------     ---------     ---------
+#       ns1           ns2           ns3           ns4
+#
+# Include Groups:
+#     Group 1 has interfaces: veth1, veth2, veth3, veth4 (All traffic except IPv4, IPv6)
+#     Group 2 has interfaces: veth1, veth3 (For IPv4 traffic only)
+#     Group 3 has interfaces: veth2, veth4 (For IPv6 traffic only)
+# Exclude Groups:
+#     veth1: exclude veth1
+#     veth2: exclude veth2
+#     veth3: exclude veth3, veth4
+#     veth4: exclude veth3, veth4
+#
+# Testing:
+# XDP modes: generic, native
+# map types: array of array, hash of array, hash of hash
+# Include:
+#     IPv4:
+#        ns1 -> ns2 (fail), ns1 -> ns3 (pass)
+#     IPv6
+#        ns4 -> ns1 (fail), ns4 -> ns2 (pass)
+# Exclude:
+#     arp ns1 -> ns2: ns2, ns3, ns4 should receive the arp request
+#     arp ns4 -> ns1: ns1, ns2 should receive the arp request, ns3 should not
+#
+
+
+# netns numbers
+NUM=4
+IFACES=""
+DRV_MODE="generic native"
+MAP_TYPE="aa ha hh"
+
+test_pass()
+{
+	echo "Pass: $@"
+}
+
+test_fail()
+{
+	echo "fail: $@"
+}
+
+clean_up()
+{
+	for i in $(seq $NUM); do
+		ip netns del ns$i
+	done
+}
+
+setup_ns()
+{
+	local mode=$1
+
+	for i in $(seq $NUM); do
+	        ip netns add ns$i
+	        ip link add veth0 type veth peer name veth$i
+	        ip link set veth0 netns ns$i
+		ip netns exec ns$i ip link set veth0 up
+		ip link set veth$i up
+
+		ip netns exec ns$i ip addr add 192.0.2.$i/24 dev veth0
+		ip netns exec ns$i ip addr add 2001:db8::$i/24 dev veth0
+		# Use xdp_redirect_map_kern.o because the dummy section in
+		# xdp_redirect_map_multicast_kern.o does not support iproute2 loading
+		ip netns exec ns$i ip link set veth0 xdp$mode obj xdp_redirect_map_kern.o sec xdp_redirect_dummy &> /dev/null || \
+			{ test_fail "Unable to load dummy xdp" && exit 1; }
+		IFACES="$IFACES veth$i"
+	done
+}
+
+do_tests()
+{
+	local drv_mode=$1
+	local map_type=$2
+	local drv_p
+
+	[ ${drv_mode} == "drv" ] && drv_p="-N" || drv_p="-S"
+
+	./xdp_redirect_map_multicast $drv_p -M $map_type $IFACES &> xdp_${drv_mode}_${map_type}.log &
+	xdp_pid=$!
+	sleep 10
+
+	# arp test
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> arp_ns1-2_${drv_mode}_${map_type}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> arp_ns1-3_${drv_mode}_${map_type}.log &
+	ip netns exec ns4 tcpdump -i veth0 -nn -l -e &> arp_ns1-4_${drv_mode}_${map_type}.log &
+	ip netns exec ns1 ping 192.0.2.100 -c 4 &> /dev/null
+	sleep 2
+	pkill -9 tcpdump
+	grep -q "Request who-has 192.0.2.100 tell 192.0.2.1" arp_ns1-2_${drv_mode}_${map_type}.log && \
+		test_pass "$drv_mode $map_type arp ns1-2" || test_fail "$drv_mode $map_type arp ns1-2"
+	grep -q "Request who-has 192.0.2.100 tell 192.0.2.1" arp_ns1-3_${drv_mode}_${map_type}.log && \
+		test_pass "$drv_mode $map_type arp ns1-3" || test_fail "$drv_mode $map_type arp ns1-3"
+	grep -q "Request who-has 192.0.2.100 tell 192.0.2.1" arp_ns1-4_${drv_mode}_${map_type}.log && \
+		test_pass "$drv_mode $map_type arp ns1-4" || test_fail "$drv_mode $map_type arp ns1-4"
+
+	ip netns exec ns1 tcpdump -i veth0 -nn -l -e &> arp_ns4-1_${drv_mode}_${map_type}.log &
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> arp_ns4-2_${drv_mode}_${map_type}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> arp_ns4-3_${drv_mode}_${map_type}.log &
+	ip netns exec ns4 ping 192.0.2.100 -c 4 &> /dev/null
+	sleep 2
+	pkill -9 tcpdump
+	grep -q "Request who-has 192.0.2.100 tell 192.0.2.4" arp_ns4-1_${drv_mode}_${map_type}.log && \
+		test_pass "$drv_mode $map_type arp ns4-1" || test_fail "$drv_mode $map_type arp ns4-1"
+	grep -q "Request who-has 192.0.2.100 tell 192.0.2.4" arp_ns4-2_${drv_mode}_${map_type}.log && \
+		test_pass "$drv_mode $map_type arp ns4-2" || test_fail "$drv_mode $map_type arp ns4-2"
+	grep -q "Request who-has 192.0.2.100 tell 192.0.2.4" arp_ns4-3_${drv_mode}_${map_type}.log && \
+		test_fail "$drv_mode $map_type arp ns4-3" || test_pass "$drv_mode $map_type arp ns4-3"
+
+
+	# ping test
+	ip netns exec ns1 ping 192.0.2.2 -c 4 &> /dev/null && \
+		test_fail "$drv_mode $map_type ping ns1-2" || test_pass "$drv_mode $map_type ping ns1-2"
+	ip netns exec ns1 ping 192.0.2.3 -c 4 &> /dev/null && \
+		test_pass "$drv_mode $map_type ping ns1-3" || test_fail "$drv_mode $map_type ping ns1-3"
+
+	# ping6 test
+	ip netns exec ns4 ping6 2001:db8::1 -c 4 &> /dev/null && \
+		test_fail "$drv_mode $map_type ping6 ns4-1" || test_pass "$drv_mode $map_type ping6 ns4-1"
+	ip netns exec ns4 ping6 2001:db8::2 -c 4 &> /dev/null && \
+		test_pass "$drv_mode $map_type ping6 ns4-2" || test_fail "$drv_mode $map_type ping6 ns4-2"
+
+	kill $xdp_pid
+}
+
+for mode in ${DRV_MODE}; do
+	sleep 2
+	setup_ns $mode
+	for type in ${MAP_TYPE}; do
+		do_tests $mode $type
+	done
+	sleep 20
+	clean_up
+done
diff --git a/samples/bpf/xdp_redirect_map_multicast_kern.c b/samples/bpf/xdp_redirect_map_multicast_kern.c
new file mode 100644
index 000000000000..f2ac36eed0e9
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multicast_kern.c
@@ -0,0 +1,147 @@
+/* This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#define KBUILD_MODNAME "foo"
+#include <uapi/linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <bpf/bpf_helpers.h>
+
+#define MAX_NR_PORTS 65536
+
+/* In the sample we will store all ports to group 1.
+ * And add two multicast groups:
+ * group 2 for even number interfaces, group 3 for odd number interfaces
+ */
+
+/* This is an array map template(NOT used) for multicast group storage
+ * The format could be lined by index:ifindex, like
+ * [0, 0], [1, 1], [2, 0], [3, 3], [4,4], [5, 0], [6, 0] ...
+ * which would be easier to modify and update.
+ *
+ * This map also could be used as multicast exclude array map.
+ * */
+struct bpf_map_def SEC("maps") group_a = {
+	.type = BPF_MAP_TYPE_DEVMAP,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = MAX_NR_PORTS,
+};
+
+/* This is a hash map template(NOT used) for multicast group storage
+ * The format could be none-lined index:ifindex, like
+ * [1, 1], [3, 3], [4, 4]...
+ * which would save more spaces for storage
+ *
+ * This map also could be used as multicast exclude hash map.
+ * */
+struct bpf_map_def SEC("maps") group_h = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(int),
+	.max_entries = MAX_NR_PORTS,
+};
+
+/* This is an array map-in-map, the inner maps will store all the
+ * include array maps and exclude array maps
+ *
+ * The max_entries is MAX_NR_PORTS * 32 as I only use 3 groups.
+ * */
+struct bpf_map_def SEC("maps") a_of_group_a = {
+	.type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u32),
+	.max_entries = MAX_NR_PORTS * 32,
+};
+
+/* This is a hash map-in-map, the inner maps will store all the
+ * include array maps and exclude array maps
+ * */
+struct bpf_map_def SEC("maps") h_of_group_a = {
+	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u32),
+	.max_entries = MAX_NR_PORTS * 32,
+};
+
+/* This is a hash map-in-map, the inner maps will store all the
+ * include hash maps and exclude hash maps
+ * */
+struct bpf_map_def SEC("maps") h_of_group_h = {
+	.type = BPF_MAP_TYPE_HASH_OF_MAPS,
+	.key_size = sizeof(u32),
+	.value_size = sizeof(u32),
+	.max_entries = MAX_NR_PORTS * 32,
+};
+
+/* Note: This map is not used yet, we get the gourp id based on IP version at
+ * present.
+ *
+ * This map is used to store all the include groups fds based on ip/mac dest.
+ */
+struct bpf_map_def SEC("maps") mcast_route_map = {
+	.type = BPF_MAP_TYPE_HASH,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(__u16),
+	.max_entries = MAX_NR_PORTS,
+};
+
+/* TODO: This is used for broadcast redirecting/forwarding,
+ * how to do the redirecting/forwarding one on one based on neigh tables?? */
+SEC("xdp_redirect_map")
+int xdp_redirect_map_prog(struct xdp_md *ctx)
+{
+	u32 key, mcast_group_id, exclude_group_id, redirect_key;
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	int *inmap_id;
+	u16 h_proto;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	h_proto = eth->h_proto;
+
+	if (h_proto == htons(ETH_P_IPV6))
+		mcast_group_id = 3;
+	else if (h_proto == htons(ETH_P_IP))
+		mcast_group_id = 2;
+	else
+		mcast_group_id = 1;
+
+	exclude_group_id = ctx->ingress_ifindex;
+	redirect_key = (mcast_group_id << 16) | exclude_group_id;
+
+	key = 1 << 16;
+	if ((inmap_id = bpf_map_lookup_elem(&a_of_group_a, &key)) && inmap_id)
+		return bpf_redirect_map(&a_of_group_a, redirect_key, 0);
+	else if ((inmap_id = bpf_map_lookup_elem(&h_of_group_a, &key)) && inmap_id)
+		return bpf_redirect_map(&h_of_group_a, redirect_key, 0);
+	else if ((inmap_id = bpf_map_lookup_elem(&h_of_group_h, &key)) && inmap_id)
+		return bpf_redirect_map(&h_of_group_h, redirect_key, 0);
+
+	return XDP_PASS;
+}
+
+/* FIXME: This prog could not be load by iproute2 as the map-in-map need
+ * set inner map fd first.
+ */
+SEC("xdp_redirect_dummy")
+int xdp_redirect_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_map_multicast_user.c b/samples/bpf/xdp_redirect_map_multicast_user.c
new file mode 100644
index 000000000000..a451c90a05b6
--- /dev/null
+++ b/samples/bpf/xdp_redirect_map_multicast_user.c
@@ -0,0 +1,306 @@
+/* SPDX-License-Identifier: GPL-2.0-only
+ */
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <net/if.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+
+#include "bpf_load.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define MAX_IFACE_NUM 32
+#define MAX_NR_PORTS 65536
+
+static int ifaces[MAX_IFACE_NUM] = {};
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+
+static void int_exit(int sig)
+{
+	__u32 prog_id = 0;
+	int i;
+
+	for (i = 0; ifaces[i] > 0; i++) {
+		if (bpf_get_link_xdp_id(ifaces[i], &prog_id, xdp_flags)) {
+			printf("bpf_get_link_xdp_id failed\n");
+			exit(1);
+		}
+		if (prog_id)
+			bpf_set_link_xdp_fd(ifaces[i], -1, xdp_flags);
+	}
+
+	exit(0);
+}
+
+static int init_map_in_map(struct bpf_object *obj, char *outmap_name, bool inmap_hash)
+{
+	struct bpf_map *outmap;
+	int inmap_fd, ret;
+
+	inmap_fd = bpf_create_map(inmap_hash ? BPF_MAP_TYPE_DEVMAP_HASH : BPF_MAP_TYPE_DEVMAP, sizeof(__u32), sizeof(int), MAX_NR_PORTS, 0);
+	if (inmap_fd < 0) {
+		printf("Failed to create inner map '%s'!\n", strerror(errno));
+		return 1;
+	}
+	outmap = bpf_object__find_map_by_name(obj, outmap_name);
+	if (!outmap) {
+		printf("Failed to load map %s from test prog\n", outmap_name);
+		return 1;
+	}
+        ret = bpf_map__set_inner_map_fd(outmap, inmap_fd);
+        if (ret) {
+                printf("Failed to set inner_map_fd for map %s\n", outmap_name);
+		return 1;
+        }
+
+	return 0;
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n"
+		"    -M    map-in-map mode, could be aa, ha, hh(default)\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_object_open_attr obj_open_attr = {
+		.prog_type      = BPF_PROG_TYPE_XDP,
+	};
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *outmap;
+	char *outmap_name;
+	char ifname[IF_NAMESIZE];
+	int pro_fd, inmap_fd, outmap_fd;
+	int i, j, ret, opt, ifindex;
+	__u32 inmap_id, key;
+	char filename[256];
+	bool inmap_hash;
+	char *mode = NULL;
+
+	while ((opt = getopt(argc, argv, "SNFM:")) != -1) {
+		switch (opt) {
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'N':
+			/* default, set below */
+			break;
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
+		case 'M':
+			mode = optarg;
+			break;
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
+	if (optind == argc) {
+		printf("usage: %s <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n", argv[0]);
+		return 1;
+	}
+
+	/* array of array */
+	if (strncmp(mode, "aa", 2) == 0) {
+		outmap_name = "a_of_group_a";
+		inmap_hash = false;
+	/* hash of array */
+	} else if (strncmp(mode, "ha", 2) == 0) {
+		outmap_name = "h_of_group_a";
+		inmap_hash = false;
+	/* hash of hash */
+	} else {
+		outmap_name = "h_of_group_h";
+		inmap_hash = true;
+	}
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	printf("Get interfaces");
+	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i ++) {
+		ifaces[i] = if_nametoindex(argv[optind + i]);
+		if (!ifaces[i])
+			ifaces[i] = strtoul(argv[optind + i], NULL, 0);
+		if (!if_indextoname(ifaces[i], ifname)) {
+			perror("Invalid interface name or i");
+			return 1;
+		}
+		printf(" %d", ifaces[i]);
+	}
+	printf("\n");
+
+	/* open bpf obj, set inner fd for out map-in-map and load bpf obj */
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	obj_open_attr.file = filename;
+	obj = bpf_object__open_xattr(&obj_open_attr);
+
+	/* We need set inner map fd for all outmaps. */
+	if(init_map_in_map(obj, "a_of_group_a", false)) {
+		printf("Failed to init out map a_of_group_a\n");
+		goto err_out;
+	}
+	if(init_map_in_map(obj, "h_of_group_a", false)) {
+		printf("Failed to init out map h_of_group_a\n");
+		goto err_out;
+	}
+	if(init_map_in_map(obj, "h_of_group_h", true)) {
+		printf("Failed to init out map h_of_group_h\n");
+		goto err_out;
+	}
+
+	bpf_object__load(obj);
+
+	prog = bpf_program__next(NULL, obj);
+	pro_fd = bpf_program__fd(prog);
+
+	outmap = bpf_object__find_map_by_name(obj, outmap_name);
+	if (!outmap) {
+		printf("Failed to load map %s from test prog\n", outmap_name);
+		goto err_out;
+	}
+	outmap_fd = bpf_map__fd(outmap);
+	if (outmap_fd < 0) {
+		printf("Failed to get fd from map %s\n", outmap_name);
+		goto err_out;
+	}
+	/* Init 3 multicast groups first.
+	 * group 1: this is used for all ports group
+	 * group 2: this is used for even number interfaces
+	 * group 3: this is used for odd number interfaces
+	 * You can store the group number in mcast_route_map for furture
+	 * IP/MAC -> Multicast Group lookup.
+	 */
+	for (i = 1; i <= 3; i++) {
+		/* Split the include/exclude groups by 16 bit
+		 * FIXME: is there a flexible way? how to let
+		 * kernel side know this?
+		 */
+		key = i << 16;
+		inmap_fd = bpf_create_map(inmap_hash ? BPF_MAP_TYPE_DEVMAP_HASH : BPF_MAP_TYPE_DEVMAP, sizeof(__u32), sizeof(int), MAX_NR_PORTS, 0);
+		if (inmap_fd < 0) {
+			printf("Failed to create inner map '%s'!\n", strerror(errno));
+			goto err_out;
+		}
+		ret = bpf_map_update_elem(outmap_fd, &key, &inmap_fd, 0);
+		if (ret) {
+			printf("Failed to update map %s\n", outmap_name);
+			goto err_out;
+		}
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	/* Set values for each map
+	 * 1. set all ports to group 1
+	 * 2. set ports to group 2 or 3 based on interface index
+	 * 3. set exclude group for each interface
+	 */
+	for (i = 0; ifaces[i] > 0; i++) {
+		ifindex = ifaces[i];
+
+		/* bind pro_fd to each interface */
+		ret = bpf_set_link_xdp_fd(ifindex, pro_fd, xdp_flags);
+		if (ret) {
+			printf("Set xdp fd failed on %d\n", ifindex);
+			goto err_out;
+		}
+
+		/* Add the interface to group 1 */
+		key = 1 << 16;
+		ret = bpf_map_lookup_elem(outmap_fd, &key, &inmap_id);
+		if (ret) {
+			printf("Failed to lookup inmap by key %u from map %s\n", key, outmap_name);
+			goto err_out;
+		}
+		inmap_fd = bpf_map_get_fd_by_id(inmap_id);
+		ret = bpf_map_update_elem(inmap_fd, &ifindex, &ifindex, 0);
+		if (ret) {
+			printf("Failed to update key %d, value %d for inmap id %u\n", ifindex, ifindex, inmap_id);
+			goto err_out;
+		}
+
+		/* Add the even number ifaces to group 2 and odd ifaces to group 3 */
+		if (i % 2 == 0)
+			key = 2 << 16;
+		else
+			key = 3 << 16;
+		ret = bpf_map_lookup_elem(outmap_fd, &key, &inmap_id);
+		if (ret) {
+			printf("Failed to lookup inmap by key %u from map %s\n", key, outmap_name);
+			goto err_out;
+		}
+		inmap_fd = bpf_map_get_fd_by_id(inmap_id);
+		ret = bpf_map_update_elem(inmap_fd, &ifindex, &ifindex, 0);
+		if (ret) {
+			printf("Failed to update key %d, value %d for inmap id %u\n", ifindex, ifindex, inmap_id);
+			goto err_out;
+		}
+
+		/* Set the exclude map for the interfaces */
+		key = ifindex;
+		inmap_fd = bpf_create_map(inmap_hash ? BPF_MAP_TYPE_DEVMAP_HASH : BPF_MAP_TYPE_DEVMAP, sizeof(__u32), sizeof(int), MAX_NR_PORTS, 0);
+		if (inmap_fd < 0) {
+			printf("Failed to create inner map '%s'!\n", strerror(errno));
+			goto err_out;
+		}
+		ret = bpf_map_update_elem(inmap_fd, &ifindex, &ifindex, 0);
+		if (ret) {
+			printf("Failed to update key %d, value %d for exclude inmap\n", ifindex, ifindex);
+			goto err_out;
+		}
+
+		/* let test exclude map by excluding all the interfaces except
+		 * the first one. The first two interfaces are not affect. e.g.
+		 * iface_1 = [1], iface_2 = [2], iface_3 = [3, 4,..],
+		 * iface_4 = [3, 4,...]
+		 */
+		for (j = 2; ifaces[j] > 0; j++) {
+			if (i <= 1 || i == j)
+				continue;
+			ifindex = ifaces[j];
+			ret = bpf_map_update_elem(inmap_fd, &ifindex, &ifindex, 0);
+			if (ret) {
+				printf("Failed to update key %d, value %d for exclude inmap\n", ifindex, ifindex);
+				goto err_out;
+		}
+
+		}
+		ret = bpf_map_update_elem(outmap_fd, &key, &inmap_fd, 0);
+		if (ret) {
+			printf("Failed to update map %s\n", outmap_name);
+			goto err_out;
+		}
+	}
+
+	sleep(600);
+	return 0;
+
+err_out:
+	return 1;
+}
-- 
2.19.2

