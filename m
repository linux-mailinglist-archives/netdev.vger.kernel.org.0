Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5B471B6B2C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 04:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgDXCMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 22:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:37424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726259AbgDXCMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 22:12:13 -0400
Received: from C02YQ0RWLVCF.internal.digitalocean.com (c-73-181-34-237.hsd1.co.comcast.net [73.181.34.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FAE72173E;
        Fri, 24 Apr 2020 02:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587694332;
        bh=Osr6n6RbUtNAr1dLwR3NqoVK8ZsQ1q9cLfkUfEvK5ok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8inPu57FyQJaXUYi3V+S5BMxjKgANdKZi+WYu3fNeef8v393slfURHC+FwTgJVy4
         9ErDIVgEri/ofqtcICRQ775x7C2oBBw3gm7UIbypyYzuKnWfIcDa+7oO7EuMTcioaj
         6FhyrU2polwa2hz6IekfaBbmytWPGJmD/Nu6G+ts=
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: [PATCH v2 bpf-next 15/17] selftest: Add test for xdp_egress
Date:   Thu, 23 Apr 2020 20:11:46 -0600
Message-Id: <20200424021148.83015-16-dsahern@kernel.org>
X-Mailer: git-send-email 2.21.1 (Apple Git-122.3)
In-Reply-To: <20200424021148.83015-1-dsahern@kernel.org>
References: <20200424021148.83015-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add selftest for xdp_egress. Add xdp_drop program to veth connecting
a namespace to drop packets and break connectivity.

Signed-off-by: David Ahern <dahern@digitalocean.com>
---
 tools/testing/selftests/bpf/Makefile          |   1 +
 tools/testing/selftests/bpf/progs/xdp_drop.c  |  25 +++
 .../testing/selftests/bpf/test_xdp_egress.sh  | 159 ++++++++++++++++++
 3 files changed, 185 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_drop.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_egress.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 7729892e0b04..5dae18ebac13 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -50,6 +50,7 @@ TEST_PROGS := test_kmod.sh \
 	test_xdp_redirect.sh \
 	test_xdp_meta.sh \
 	test_xdp_veth.sh \
+	test_xdp_egress.sh \
 	test_offload.py \
 	test_sock_addr.sh \
 	test_tunnel.sh \
diff --git a/tools/testing/selftests/bpf/progs/xdp_drop.c b/tools/testing/selftests/bpf/progs/xdp_drop.c
new file mode 100644
index 000000000000..cffabc53a5e1
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_drop.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/if_ether.h>
+#include <bpf/bpf_helpers.h>
+
+SEC("drop")
+int xdp_drop(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	void *nh;
+
+	nh = data + sizeof(*eth);
+	if (nh > data_end)
+		return XDP_DROP;
+
+	if (eth->h_proto == 0x0008)
+		return XDP_DROP;
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdp_egress.sh b/tools/testing/selftests/bpf/test_xdp_egress.sh
new file mode 100755
index 000000000000..03f64f38fac2
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_egress.sh
@@ -0,0 +1,159 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# XDP egress tests.
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TESTNAME=xdp_egress
+BPF_FS=$(awk '$3 == "bpf" {print $2; exit}' /proc/mounts)
+
+ret=0
+
+################################################################################
+#
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "TEST: %-60s  [ OK ]\n" "${msg}"
+	else
+		ret=1
+		printf "TEST: %-60s  [FAIL]\n" "${msg}"
+	fi
+}
+
+################################################################################
+# create namespaces and connect them
+
+create_ns()
+{
+	local ns=$1
+	local addr=$2
+	local addr6=$3
+
+	ip netns add ${ns}
+
+	ip -netns ${ns} link set lo up
+	ip -netns ${ns} addr add dev lo ${addr}
+	ip -netns ${ns} -6 addr add dev lo ${addr6}
+
+	ip -netns ${ns} ro add unreachable default metric 8192
+	ip -netns ${ns} -6 ro add unreachable default metric 8192
+
+	ip netns exec ${ns} sysctl -qw net.ipv4.ip_forward=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
+}
+
+connect_ns()
+{
+	local ns1=$1
+	local ns1_dev=$2
+	local ns1_addr=$3
+	local ns1_addr6=$4
+	local ns2=$5
+	local ns2_dev=$6
+	local ns2_addr=$7
+	local ns2_addr6=$8
+	local ns1arg
+	local ns2arg
+
+	if [ -n "${ns1}" ]; then
+		ns1arg="-netns ${ns1}"
+	fi
+	if [ -n "${ns2}" ]; then
+		ns2arg="-netns ${ns2}"
+	fi
+
+	ip ${ns1arg} li add ${ns1_dev} type veth peer name tmp
+	ip ${ns1arg} li set ${ns1_dev} up
+	ip ${ns1arg} li set tmp netns ${ns2} name ${ns2_dev}
+	ip ${ns2arg} li set ${ns2_dev} up
+
+	ip ${ns1arg} addr add dev ${ns1_dev} ${ns1_addr}
+	ip ${ns2arg} addr add dev ${ns2_dev} ${ns2_addr}
+
+	ip ${ns1arg} addr add dev ${ns1_dev} ${ns1_addr6} nodad
+	ip ${ns2arg} addr add dev ${ns2_dev} ${ns2_addr6} nodad
+}
+
+################################################################################
+#
+
+setup()
+{
+	create_ns host 172.16.101.1/32 2001:db8:101::1/128
+	connect_ns "" veth-host 172.16.1.1/24 2001:db8:1::1/64 host eth0 172.16.1.2/24 2001:db8:1::2/64
+	ip ro add 172.16.101.1 via 172.16.1.2
+	ip -6 ro add 2001:db8:101::1 via 2001:db8:1::2
+	ping -c1 -w1 172.16.101.1 >/dev/null 2>&1
+	ping -c1 -w1 2001:db8:101::1 >/dev/null 2>&1
+}
+
+cleanup()
+{
+	ip li del veth-host 2>/dev/null
+	ip netns del host 2>/dev/null
+	rm -f $BPF_FS/test_$TESTNAME
+}
+
+################################################################################
+# main
+
+if [ $(id -u) -ne 0 ]; then
+	echo "selftests: $TESTNAME [SKIP] Need root privileges"
+	exit $ksft_skip
+fi
+
+if ! ip link set dev lo xdp off > /dev/null 2>&1; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without the ip xdp support"
+	exit $ksft_skip
+fi
+
+if [ -z "$BPF_FS" ]; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without bpffs mounted"
+	exit $ksft_skip
+fi
+
+if ! bpftool version > /dev/null 2>&1; then
+	echo "selftests: $TESTNAME [SKIP] Could not run test without bpftool"
+	exit $ksft_skip
+fi
+
+cleanup
+trap cleanup EXIT
+
+set -e
+setup
+set +e
+
+bpftool prog load xdp_drop.o $BPF_FS/test_$TESTNAME type xdp_egress || exit 1
+ID=$(bpftool prog show name xdp_drop | awk '$4 == "xdp_drop" {print $1}')
+
+# attach egress program
+bpftool net attach xdp_egress id ${ID/:/} dev veth-host
+ping -c1 -w1 172.16.101.1 >/dev/null 2>&1
+log_test $? 1 "IPv4 connectivity disabled by xdp_egress"
+ping -c1 -w1 2001:db8:101::1 >/dev/null 2>&1
+log_test $? 0 "IPv6 connectivity not disabled by egress drop program"
+
+# detach program should restore connectivity
+bpftool net detach xdp_egress dev veth-host
+ping -c1 -w1 172.16.101.1 >/dev/null 2>&1
+log_test $? 0 "IPv4 connectivity restored"
+
+# cleanup on delete
+ip netns exec host bpftool net attach xdp_egress id ${ID/:/} dev eth0
+bpftool net attach xdp_egress id ${ID/:/} dev veth-host
+ip li del veth-host
+rm -f $BPF_FS/test_$TESTNAME
+bpftool prog show name xdp_drop
+
+exit $ret
-- 
2.21.1 (Apple Git-122.3)

