Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F082102BC
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 06:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGAEVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 00:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgGAEVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 00:21:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 756F6C061755;
        Tue, 30 Jun 2020 21:21:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id j1so10416213pfe.4;
        Tue, 30 Jun 2020 21:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nq4iE3h2CHniWtGtCB9yP7TYgQOyYG/fU+lKyi9Xx0g=;
        b=dLBusUZPhgpo30GYuikvBDbs82TIDzHi6XB5xe/jJFOw7iBio+uFmemTaXrDRLcdli
         WfB1Dd0YjRVRQOlVg9HEcJtY03rNaHO8zPEkCXtttG+yQ/4OkssfeWM9PxL2cB+BwVCn
         pCgSCshO7rgJGJcw+Qt3OIvs0LO9HK1FmFBWvCWG9Bqm0zOqHNQM3kfhJP2n8Ri+2uob
         OtPDYHUj5l7lQJGxZbXA2vb2lzs6Hci3J4GIoSuP6k1ni+LjWp88GX5SGJ2Kt5xHGhUe
         qSMv00oMk4Zj2V0KzDYHZja4bw1g46F5V68obsLyBEPiOsTYGqRiNeiGov4lV9I4lfoM
         LxNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nq4iE3h2CHniWtGtCB9yP7TYgQOyYG/fU+lKyi9Xx0g=;
        b=IxTDThvMchQhWXWa7+JQDa2Q9fIti5mmA2T9muShFpTvbyz3/kKbaLHCeWsOP8bIAm
         SHO1xnxfJH5vposhvEFSXT/b3uopvV9YT8FmnyDVrFZy/GPLrpDzF/712Xa5spV4mzKN
         L3tgxyvlGbZSHZCYpK43z8T43y/av33q5sa3qMFIsBnqAkjdjFCNI7wqiA+2UYfTj50P
         dJki1/4XuNiFb3XLlNBQFhHOxrhRPMKsRWQdXNEL7BI0g7sMVoRVf4Olsfx5MR/3tVTA
         0SYghd69/L3b2u6ggyvuKFMy82edgxiec2+SnAZ677hcU6UNx3uqhyslrqoty06yFKCs
         xC3w==
X-Gm-Message-State: AOAM533hkSCg6XBf3QNRdCn9YYzGloVLJG9S518sU6F4QzCC2CRBUMh5
        FZ24FF4zwdznw0CA/aAwfim1i7mDcAg=
X-Google-Smtp-Source: ABdhPJwGed4pnPd9jXKJsgZ7cBA3HVQBi1z6U7XbCquKnyIkaxrBLU9l3acF4dOguDioZ8PU2t7LPw==
X-Received: by 2002:a62:8c54:: with SMTP id m81mr18912585pfd.215.1593577279544;
        Tue, 30 Jun 2020 21:21:19 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h9sm3420227pjs.50.2020.06.30.21.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 21:21:19 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv5 bpf-next 3/3] selftests/bpf: add xdp_redirect_multi test
Date:   Wed,  1 Jul 2020 12:19:38 +0800
Message-Id: <20200701041938.862200-4-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200701041938.862200-1-liuhangbin@gmail.com>
References: <20200526140539.4103528-1-liuhangbin@gmail.com>
 <20200701041938.862200-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bpf selftest for new helper xdp_redirect_map_multi(). In this
test we have 3 forward groups groups and 1 exclude group. The test will
redirect each interface's packets to all the interfaces in the forward
group, and exclude the interface in exclude map. We will also test both
DEVMAP and DEVMAP_HASH with xdp generic and drv.

For more test details, you can find it in the test script. Here is
the test result.
]# ./test_xdp_redirect_multi.sh
Pass: xdpgeneric arp ns1-2
Pass: xdpgeneric arp ns1-3
Pass: xdpgeneric arp ns1-4
Pass: xdpgeneric ping ns1-2
Pass: xdpgeneric ping ns1-3
Pass: xdpgeneric ping ns1-4
Pass: xdpgeneric ping6 ns2-1
Pass: xdpgeneric ping6 ns2-3
Pass: xdpgeneric ping6 ns2-4
Pass: xdpdrv arp ns1-2
Pass: xdpdrv arp ns1-3
Pass: xdpdrv arp ns1-4
Pass: xdpdrv ping ns1-2
Pass: xdpdrv ping ns1-3
Pass: xdpdrv ping ns1-4
Pass: xdpdrv ping6 ns2-1
Pass: xdpdrv ping6 ns2-3
Pass: xdpdrv ping6 ns2-4
Summary: PASS 18, FAIL 0

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../bpf/progs/xdp_redirect_multi_kern.c       |  90 +++++++++
 .../selftests/bpf/test_xdp_redirect_multi.sh  | 164 +++++++++++++++++
 .../selftests/bpf/xdp_redirect_multi.c        | 173 ++++++++++++++++++
 4 files changed, 430 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_redirect_multi.c

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1f9c696b3edf..66b857210814 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -51,6 +51,7 @@ TEST_FILES = test_lwt_ip_encap.o \
 # Order correspond to 'make run_tests' order
 TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
+	test_xdp_redirect_multi.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
 	test_offload.py \
@@ -79,7 +80,8 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 # Compile but not part of 'make run_tests'
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
-	test_lirc_mode2_user xdping test_cpp runqslower bench
+	test_lirc_mode2_user xdping test_cpp runqslower bench \
+	xdp_redirect_multi
 
 TEST_CUSTOM_PROGS = urandom_read
 
diff --git a/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
new file mode 100644
index 000000000000..70b8476b9df3
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_redirect_multi_kern.c
@@ -0,0 +1,90 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#define KBUILD_MODNAME "foo"
+#include <string.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+struct bpf_map_def SEC("maps") forward_map_v4 = {
+	.type = BPF_MAP_TYPE_DEVMAP,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(int),
+	.max_entries = 4096,
+};
+
+struct bpf_map_def SEC("maps") forward_map_v6 = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+struct bpf_map_def SEC("maps") forward_map_all = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+struct bpf_map_def SEC("maps") exclude_map = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(int),
+	.max_entries = 128,
+};
+
+struct bpf_map_def SEC("maps") null_map = {
+	.type = BPF_MAP_TYPE_DEVMAP_HASH,
+	.key_size = sizeof(__u32),
+	.value_size = sizeof(int),
+	.max_entries = 1,
+};
+
+SEC("xdp_redirect_map_multi")
+int xdp_redirect_map_multi_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	__u16 h_proto;
+	__u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	h_proto = eth->h_proto;
+
+	if (h_proto == bpf_htons(ETH_P_IP))
+		return bpf_redirect_map_multi(&forward_map_v4, &exclude_map,
+					      BPF_F_EXCLUDE_INGRESS);
+	else if (h_proto == bpf_htons(ETH_P_IPV6))
+		return bpf_redirect_map_multi(&forward_map_v6, &exclude_map,
+					      BPF_F_EXCLUDE_INGRESS);
+	else
+		return bpf_redirect_map_multi(&forward_map_all, &null_map,
+					      BPF_F_EXCLUDE_INGRESS);
+}
+
+SEC("xdp_dummy")
+int xdp_pass(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
new file mode 100755
index 000000000000..f4f8f751854e
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_redirect_multi.sh
@@ -0,0 +1,164 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# Test topology:
+#     - - - - - - - - - - - - - - - - - - - - - - - - -
+#    | veth1         veth2         veth3         veth4 |  ... init net
+#     - -| - - - - - - | - - - - - - | - - - - - - | - -
+#    ---------     ---------     ---------     ---------
+#    | veth0 |     | veth0 |     | veth0 |     | veth0 |  ...
+#    ---------     ---------     ---------     ---------
+#       ns1           ns2           ns3           ns4
+#
+# Forward multicast groups:
+#     Forward group all has interfaces: veth1, veth2, veth3, veth4, ... (All traffic except IPv4, IPv6)
+#     Forward group v4 has interfaces: veth1, veth3, veth4, ... (For IPv4 traffic only)
+#     Forward group v6 has interfaces: veth2, veth3, veth4, ... (For IPv6 traffic only)
+# Exclude Groups:
+#     Exclude group: veth3 (assume ns3 is in black list)
+#
+# Test modules:
+# XDP modes: generic, native
+# map types: group v4 use DEVMAP, others use DEVMAP_HASH
+#
+# Test cases:
+#     ARP(we didn't block ARP for ns3):
+#        ns1 -> gw: ns2, ns3, ns4 should receive the arp request
+#     IPv4:
+#        ns1 -> ns2 (fail), ns1 -> ns3 (fail), ns1 -> ns4 (pass)
+#     IPv6
+#        ns2 -> ns1 (fail), ns2 -> ns3 (fail), ns2 -> ns4 (pass)
+#
+
+
+# netns numbers
+NUM=4
+IFACES=""
+DRV_MODE="xdpgeneric xdpdrv"
+PASS=0
+FAIL=0
+
+test_pass()
+{
+	echo "Pass: $@"
+	PASS=$((PASS + 1))
+}
+
+test_fail()
+{
+	echo "fail: $@"
+	FAIL=$((FAIL + 1))
+}
+
+clean_up()
+{
+	for i in $(seq $NUM); do
+		ip link del veth$i 2> /dev/null
+		ip netns del ns$i 2> /dev/null
+	done
+	rm -f xdp_redirect_*.log arp_ns*.log
+}
+
+# Kselftest framework requirement - SKIP code is 4.
+check_env()
+{
+	ip link set dev lo xdpgeneric off &>/dev/null
+	if [ $? -ne 0 ];then
+		echo "selftests: [SKIP] Could not run test without the ip xdpgeneric support"
+		exit 4
+	fi
+
+	which tcpdump &>/dev/null
+	if [ $? -ne 0 ];then
+		echo "selftests: [SKIP] Could not run test without tcpdump"
+		exit 4
+	fi
+}
+
+setup_ns()
+{
+	local mode=$1
+	IFACES=""
+
+	for i in $(seq $NUM); do
+	        ip netns add ns$i
+	        ip link add veth$i type veth peer name veth0 netns ns$i
+		ip link set veth$i up
+		ip -n ns$i link set veth0 up
+
+		ip -n ns$i addr add 192.0.2.$i/24 dev veth0
+		ip -n ns$i addr add 2001:db8::$i/64 dev veth0
+		ip -n ns$i link set veth0 $mode obj \
+			xdp_redirect_multi_kern.o sec xdp_dummy &> /dev/null || \
+			{ test_fail "Unable to load dummy xdp" && exit 1; }
+		IFACES="$IFACES veth$i"
+	done
+}
+
+do_ping_tests()
+{
+	local mode=$1
+
+	# arp test
+	ip netns exec ns2 tcpdump -i veth0 -nn -l -e &> arp_ns1-2_${mode}.log &
+	ip netns exec ns3 tcpdump -i veth0 -nn -l -e &> arp_ns1-3_${mode}.log &
+	ip netns exec ns4 tcpdump -i veth0 -nn -l -e &> arp_ns1-4_${mode}.log &
+	ip netns exec ns1 ping 192.0.2.254 -c 4 &> /dev/null
+	sleep 2
+	pkill -9 tcpdump
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-2_${mode}.log && \
+		test_pass "$mode arp ns1-2" || test_fail "$mode arp ns1-2"
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-3_${mode}.log && \
+		test_pass "$mode arp ns1-3" || test_fail "$mode arp ns1-3"
+	grep -q "Request who-has 192.0.2.254 tell 192.0.2.1" arp_ns1-4_${mode}.log && \
+		test_pass "$mode arp ns1-4" || test_fail "$mode arp ns1-4"
+
+	# ping test
+	ip netns exec ns1 ping 192.0.2.2 -c 4 &> /dev/null && \
+		test_fail "$mode ping ns1-2" || test_pass "$mode ping ns1-2"
+	ip netns exec ns1 ping 192.0.2.3 -c 4 &> /dev/null && \
+		test_fail "$mode ping ns1-3" || test_pass "$mode ping ns1-3"
+	ip netns exec ns1 ping 192.0.2.4 -c 4 &> /dev/null && \
+		test_pass "$mode ping ns1-4" || test_fail "$mode ping ns1-4"
+
+	# ping6 test
+	ip netns exec ns2 ping6 2001:db8::1 -c 4 &> /dev/null && \
+		test_fail "$mode ping6 ns2-1" || test_pass "$mode ping6 ns2-1"
+	ip netns exec ns2 ping6 2001:db8::3 -c 4 &> /dev/null && \
+		test_fail "$mode ping6 ns2-3" || test_pass "$mode ping6 ns2-3"
+	ip netns exec ns2 ping6 2001:db8::4 -c 4 &> /dev/null && \
+		test_pass "$mode ping6 ns2-4" || test_fail "$mode ping6 ns2-4"
+}
+
+do_tests()
+{
+	local mode=$1
+	local drv_p
+
+	[ ${mode} == "xdpdrv" ] && drv_p="-N" || drv_p="-S"
+
+	# run `ulimit -l unlimited` if you got errors like
+	# libbpf: Error in bpf_object__probe_global_data():Operation not permitted(1).
+	./xdp_redirect_multi $drv_p $IFACES &> xdp_redirect_${mode}.log &
+	xdp_pid=$!
+	sleep 10
+
+	do_ping_tests $mode
+
+	kill $xdp_pid
+}
+
+trap clean_up 0 2 3 6 9
+
+check_env
+
+for mode in ${DRV_MODE}; do
+	setup_ns $mode
+	do_tests $mode
+	sleep 10
+	clean_up
+	sleep 5
+done
+
+echo "Summary: PASS $PASS, FAIL $FAIL"
+[ $FAIL -eq 0 ] && exit 0 || exit 1
diff --git a/tools/testing/selftests/bpf/xdp_redirect_multi.c b/tools/testing/selftests/bpf/xdp_redirect_multi.c
new file mode 100644
index 000000000000..5626005cb679
--- /dev/null
+++ b/tools/testing/selftests/bpf/xdp_redirect_multi.c
@@ -0,0 +1,173 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <net/if.h>
+#include <unistd.h>
+#include <libgen.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+#define MAX_IFACE_NUM 32
+
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int ifaces[MAX_IFACE_NUM] = {};
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
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	int prog_fd, group_all, group_v4, group_v6, exclude;
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type      = BPF_PROG_TYPE_XDP,
+	};
+	int i, ret, opt, ifindex;
+	char ifname[IF_NAMESIZE];
+	struct bpf_object *obj;
+	char filename[256];
+
+	while ((opt = getopt(argc, argv, "SNF")) != -1) {
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
+	printf("Get interfaces");
+	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
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
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	prog_load_attr.file = filename;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
+		return 1;
+
+	group_all = bpf_object__find_map_fd_by_name(obj, "forward_map_all");
+	group_v4 = bpf_object__find_map_fd_by_name(obj, "forward_map_v4");
+	group_v6 = bpf_object__find_map_fd_by_name(obj, "forward_map_v6");
+	exclude = bpf_object__find_map_fd_by_name(obj, "exclude_map");
+
+	if (group_all < 0 || group_v4 < 0 || group_v6 < 0 || exclude < 0) {
+		printf("bpf_object__find_map_fd_by_name failed\n");
+		return 1;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	/* Init forward multicast groups and exclude group */
+	for (i = 0; ifaces[i] > 0; i++) {
+		ifindex = ifaces[i];
+
+		/* Add all the interfaces to group all */
+		ret = bpf_map_update_elem(group_all, &ifindex, &ifindex, 0);
+		if (ret) {
+			perror("bpf_map_update_elem");
+			goto err_out;
+		}
+
+		/* For testing: remove the 1st interfaces from group v6 */
+		if (i != 0) {
+			ret = bpf_map_update_elem(group_v6, &ifindex, &ifindex, 0);
+			if (ret) {
+				perror("bpf_map_update_elem");
+				goto err_out;
+			}
+		}
+
+		/* For testing: remove the 2nd interfaces from group v4 */
+		if (i != 1) {
+			ret = bpf_map_update_elem(group_v4, &ifindex, &ifindex, 0);
+			if (ret) {
+				perror("bpf_map_update_elem");
+				goto err_out;
+			}
+		}
+
+		/* For testing: add the 3rd interfaces to exclude map */
+		if (i == 2) {
+			ret = bpf_map_update_elem(exclude, &ifindex, &ifindex, 0);
+			if (ret) {
+				perror("bpf_map_update_elem");
+				goto err_out;
+			}
+		}
+
+		/* bind prog_fd to each interface */
+		ret = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
+		if (ret) {
+			printf("Set xdp fd failed on %d\n", ifindex);
+			goto err_out;
+		}
+
+	}
+
+	/* sleep some time for testing */
+	sleep(999);
+
+	return 0;
+
+err_out:
+	return 1;
+}
-- 
2.25.4

