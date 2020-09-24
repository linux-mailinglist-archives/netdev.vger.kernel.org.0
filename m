Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3F127665B
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 04:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgIXC0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 22:26:02 -0400
Received: from mga03.intel.com ([134.134.136.65]:22737 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726262AbgIXC0C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 22:26:02 -0400
IronPort-SDR: Y2fSEclunDvyl8EpShrehyyqVSvmj+2/p9UfkrOc5bblRzbpYX5Y29plLkM74kozxP60fuHcAR
 QDIJhYvulb2Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="161139383"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="161139383"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2020 19:26:01 -0700
IronPort-SDR: CikwBmpHjsxibG6U5kiJP3I4RopC5G5ENgCNrmeOL1/wuK6aCKUpmWCmN+T+wLk7CR2/PAMF2a
 eNFCLL5DpDVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="511347252"
Received: from bpujari-bxdsw.sc.intel.com ([10.232.14.242])
  by fmsmga006.fm.intel.com with ESMTP; 23 Sep 2020 19:26:00 -0700
From:   bimmy.pujari@intel.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, mchehab@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, maze@google.com,
        bimmy.pujari@intel.com, ashkan.nikravesh@intel.com
Subject: [PATCH bpf-next v3 2/2] selftests/bpf: Verifying real time helper function
Date:   Wed, 23 Sep 2020 19:25:57 -0700
Message-Id: <20200924022557.16561-2-bimmy.pujari@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200924022557.16561-1-bimmy.pujari@intel.com>
References: <20200924022557.16561-1-bimmy.pujari@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bimmy Pujari <bimmy.pujari@intel.com>

Test xdping measures RTT from xdp using monotonic time helper.
Extending xdping test to use real time helper function in order
to verify this helper function.

Signed-off-by: Bimmy Pujari <bimmy.pujari@intel.com>
---
 .../testing/selftests/bpf/progs/xdping_kern.c | 183 +----------------
 .../testing/selftests/bpf/progs/xdping_kern.h | 193 ++++++++++++++++++
 .../bpf/progs/xdping_realtime_kern.c          |   4 +
 tools/testing/selftests/bpf/test_xdping.sh    |  44 +++-
 4 files changed, 235 insertions(+), 189 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/xdping_kern.h
 create mode 100644 tools/testing/selftests/bpf/progs/xdping_realtime_kern.c

diff --git a/tools/testing/selftests/bpf/progs/xdping_kern.c b/tools/testing/selftests/bpf/progs/xdping_kern.c
index 6b9ca40bd1f4..0a152f6835fe 100644
--- a/tools/testing/selftests/bpf/progs/xdping_kern.c
+++ b/tools/testing/selftests/bpf/progs/xdping_kern.c
@@ -1,184 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
-/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+#undef REALTIME
 
-#define KBUILD_MODNAME "foo"
-#include <stddef.h>
-#include <string.h>
-#include <linux/bpf.h>
-#include <linux/icmp.h>
-#include <linux/in.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-#include <linux/if_vlan.h>
-#include <linux/ip.h>
+#include "xdping_kern.h"
 
-#include <bpf/bpf_helpers.h>
-#include <bpf/bpf_endian.h>
-
-#include "xdping.h"
-
-struct {
-	__uint(type, BPF_MAP_TYPE_HASH);
-	__uint(max_entries, 256);
-	__type(key, __u32);
-	__type(value, struct pinginfo);
-} ping_map SEC(".maps");
-
-static __always_inline void swap_src_dst_mac(void *data)
-{
-	unsigned short *p = data;
-	unsigned short dst[3];
-
-	dst[0] = p[0];
-	dst[1] = p[1];
-	dst[2] = p[2];
-	p[0] = p[3];
-	p[1] = p[4];
-	p[2] = p[5];
-	p[3] = dst[0];
-	p[4] = dst[1];
-	p[5] = dst[2];
-}
-
-static __always_inline __u16 csum_fold_helper(__wsum sum)
-{
-	sum = (sum & 0xffff) + (sum >> 16);
-	return ~((sum & 0xffff) + (sum >> 16));
-}
-
-static __always_inline __u16 ipv4_csum(void *data_start, int data_size)
-{
-	__wsum sum;
-
-	sum = bpf_csum_diff(0, 0, data_start, data_size, 0);
-	return csum_fold_helper(sum);
-}
-
-#define ICMP_ECHO_LEN		64
-
-static __always_inline int icmp_check(struct xdp_md *ctx, int type)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	struct icmphdr *icmph;
-	struct iphdr *iph;
-
-	if (data + sizeof(*eth) + sizeof(*iph) + ICMP_ECHO_LEN > data_end)
-		return XDP_PASS;
-
-	if (eth->h_proto != bpf_htons(ETH_P_IP))
-		return XDP_PASS;
-
-	iph = data + sizeof(*eth);
-
-	if (iph->protocol != IPPROTO_ICMP)
-		return XDP_PASS;
-
-	if (bpf_ntohs(iph->tot_len) - sizeof(*iph) != ICMP_ECHO_LEN)
-		return XDP_PASS;
-
-	icmph = data + sizeof(*eth) + sizeof(*iph);
-
-	if (icmph->type != type)
-		return XDP_PASS;
-
-	return XDP_TX;
-}
-
-SEC("xdpclient")
-int xdping_client(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
-	struct pinginfo *pinginfo = NULL;
-	struct ethhdr *eth = data;
-	struct icmphdr *icmph;
-	struct iphdr *iph;
-	__u64 recvtime;
-	__be32 raddr;
-	__be16 seq;
-	int ret;
-	__u8 i;
-
-	ret = icmp_check(ctx, ICMP_ECHOREPLY);
-
-	if (ret != XDP_TX)
-		return ret;
-
-	iph = data + sizeof(*eth);
-	icmph = data + sizeof(*eth) + sizeof(*iph);
-	raddr = iph->saddr;
-
-	/* Record time reply received. */
-	recvtime = bpf_ktime_get_ns();
-	pinginfo = bpf_map_lookup_elem(&ping_map, &raddr);
-	if (!pinginfo || pinginfo->seq != icmph->un.echo.sequence)
-		return XDP_PASS;
-
-	if (pinginfo->start) {
-#pragma clang loop unroll(full)
-		for (i = 0; i < XDPING_MAX_COUNT; i++) {
-			if (pinginfo->times[i] == 0)
-				break;
-		}
-		/* verifier is fussy here... */
-		if (i < XDPING_MAX_COUNT) {
-			pinginfo->times[i] = recvtime -
-					     pinginfo->start;
-			pinginfo->start = 0;
-			i++;
-		}
-		/* No more space for values? */
-		if (i == pinginfo->count || i == XDPING_MAX_COUNT)
-			return XDP_PASS;
-	}
-
-	/* Now convert reply back into echo request. */
-	swap_src_dst_mac(data);
-	iph->saddr = iph->daddr;
-	iph->daddr = raddr;
-	icmph->type = ICMP_ECHO;
-	seq = bpf_htons(bpf_ntohs(icmph->un.echo.sequence) + 1);
-	icmph->un.echo.sequence = seq;
-	icmph->checksum = 0;
-	icmph->checksum = ipv4_csum(icmph, ICMP_ECHO_LEN);
-
-	pinginfo->seq = seq;
-	pinginfo->start = bpf_ktime_get_ns();
-
-	return XDP_TX;
-}
-
-SEC("xdpserver")
-int xdping_server(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	struct icmphdr *icmph;
-	struct iphdr *iph;
-	__be32 raddr;
-	int ret;
-
-	ret = icmp_check(ctx, ICMP_ECHO);
-
-	if (ret != XDP_TX)
-		return ret;
-
-	iph = data + sizeof(*eth);
-	icmph = data + sizeof(*eth) + sizeof(*iph);
-	raddr = iph->saddr;
-
-	/* Now convert request into echo reply. */
-	swap_src_dst_mac(data);
-	iph->saddr = iph->daddr;
-	iph->daddr = raddr;
-	icmph->type = ICMP_ECHOREPLY;
-	icmph->checksum = 0;
-	icmph->checksum = ipv4_csum(icmph, ICMP_ECHO_LEN);
-
-	return XDP_TX;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/xdping_kern.h b/tools/testing/selftests/bpf/progs/xdping_kern.h
new file mode 100644
index 000000000000..ca4b62214808
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdping_kern.h
@@ -0,0 +1,193 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2019, Oracle and/or its affiliates. All rights reserved. */
+
+#define KBUILD_MODNAME "foo"
+#include <stddef.h>
+#include <string.h>
+#include <linux/bpf.h>
+#include <linux/icmp.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#include "xdping.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 256);
+	__type(key, __u32);
+	__type(value, struct pinginfo);
+} ping_map SEC(".maps");
+
+static __always_inline void swap_src_dst_mac(void *data)
+{
+	unsigned short *p = data;
+	unsigned short dst[3];
+
+	dst[0] = p[0];
+	dst[1] = p[1];
+	dst[2] = p[2];
+	p[0] = p[3];
+	p[1] = p[4];
+	p[2] = p[5];
+	p[3] = dst[0];
+	p[4] = dst[1];
+	p[5] = dst[2];
+}
+
+static __always_inline __u16 csum_fold_helper(__wsum sum)
+{
+	sum = (sum & 0xffff) + (sum >> 16);
+	return ~((sum & 0xffff) + (sum >> 16));
+}
+
+static __always_inline __u16 ipv4_csum(void *data_start, int data_size)
+{
+	__wsum sum;
+
+	sum = bpf_csum_diff(0, 0, data_start, data_size, 0);
+	return csum_fold_helper(sum);
+}
+
+#define ICMP_ECHO_LEN		64
+
+static __always_inline int icmp_check(struct xdp_md *ctx, int type)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	struct icmphdr *icmph;
+	struct iphdr *iph;
+
+	if (data + sizeof(*eth) + sizeof(*iph) + ICMP_ECHO_LEN > data_end)
+		return XDP_PASS;
+
+	if (eth->h_proto != bpf_htons(ETH_P_IP))
+		return XDP_PASS;
+
+	iph = data + sizeof(*eth);
+
+	if (iph->protocol != IPPROTO_ICMP)
+		return XDP_PASS;
+
+	if (bpf_ntohs(iph->tot_len) - sizeof(*iph) != ICMP_ECHO_LEN)
+		return XDP_PASS;
+
+	icmph = data + sizeof(*eth) + sizeof(*iph);
+
+	if (icmph->type != type)
+		return XDP_PASS;
+
+	return XDP_TX;
+}
+
+SEC("xdpclient")
+int xdping_client(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct pinginfo *pinginfo = NULL;
+	struct ethhdr *eth = data;
+	struct icmphdr *icmph;
+	struct iphdr *iph;
+	__u64 recvtime;
+	__be32 raddr;
+	__be16 seq;
+	int ret;
+	__u8 i;
+
+	ret = icmp_check(ctx, ICMP_ECHOREPLY);
+
+	if (ret != XDP_TX)
+		return ret;
+
+	iph = data + sizeof(*eth);
+	icmph = data + sizeof(*eth) + sizeof(*iph);
+	raddr = iph->saddr;
+
+	/* Record time reply received. */
+#ifdef REALTIME
+	recvtime = bpf_ktime_get_real_ns();
+#else
+	recvtime = bpf_ktime_get_ns();
+#endif
+	pinginfo = bpf_map_lookup_elem(&ping_map, &raddr);
+	if (!pinginfo || pinginfo->seq != icmph->un.echo.sequence)
+		return XDP_PASS;
+
+	if (pinginfo->start) {
+#pragma clang loop unroll(full)
+		for (i = 0; i < XDPING_MAX_COUNT; i++) {
+			if ((pinginfo->times[i] == 0) ||
+					(pinginfo->start >= recvtime))
+				break;
+		}
+		/* verifier is fussy here... */
+		if (i < XDPING_MAX_COUNT) {
+			pinginfo->times[i] = recvtime -
+					     pinginfo->start;
+			pinginfo->start = 0;
+			i++;
+		}
+		/* No more space for values? */
+		if (i == pinginfo->count || i == XDPING_MAX_COUNT)
+			return XDP_PASS;
+	}
+
+	/* Now convert reply back into echo request. */
+	swap_src_dst_mac(data);
+	iph->saddr = iph->daddr;
+	iph->daddr = raddr;
+	icmph->type = ICMP_ECHO;
+	seq = bpf_htons(bpf_ntohs(icmph->un.echo.sequence) + 1);
+	icmph->un.echo.sequence = seq;
+	icmph->checksum = 0;
+	icmph->checksum = ipv4_csum(icmph, ICMP_ECHO_LEN);
+
+	pinginfo->seq = seq;
+#ifdef REALTIME
+	pinginfo->start = bpf_ktime_get_real_ns();
+#else
+	pinginfo->start = bpf_ktime_get_ns();
+#endif
+
+	return XDP_TX;
+}
+
+SEC("xdpserver")
+int xdping_server(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	struct icmphdr *icmph;
+	struct iphdr *iph;
+	__be32 raddr;
+	int ret;
+
+	ret = icmp_check(ctx, ICMP_ECHO);
+
+	if (ret != XDP_TX)
+		return ret;
+
+	iph = data + sizeof(*eth);
+	icmph = data + sizeof(*eth) + sizeof(*iph);
+	raddr = iph->saddr;
+
+	/* Now convert request into echo reply. */
+	swap_src_dst_mac(data);
+	iph->saddr = iph->daddr;
+	iph->daddr = raddr;
+	icmph->type = ICMP_ECHOREPLY;
+	icmph->checksum = 0;
+	icmph->checksum = ipv4_csum(icmph, ICMP_ECHO_LEN);
+
+	return XDP_TX;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/xdping_realtime_kern.c b/tools/testing/selftests/bpf/progs/xdping_realtime_kern.c
new file mode 100644
index 000000000000..85f9d9bfc5b7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdping_realtime_kern.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+#define REALTIME
+
+#include "xdping_kern.h"
diff --git a/tools/testing/selftests/bpf/test_xdping.sh b/tools/testing/selftests/bpf/test_xdping.sh
index c2f0ddb45531..3e357755b279 100755
--- a/tools/testing/selftests/bpf/test_xdping.sh
+++ b/tools/testing/selftests/bpf/test_xdping.sh
@@ -42,11 +42,13 @@ setup()
 	ip addr add ${LOCAL_IP}/24 dev veth1
 	ip netns exec $TARGET_NS ip link set veth0 up
 	ip link set veth1 up
+	ln -s xdping xdping_realtime
 }
 
 cleanup()
 {
 	set +e
+	rm xdping_realtime
 	ip netns delete $TARGET_NS 2>/dev/null
 	ip link del veth1 2>/dev/null
 	if [[ $server_pid -ne 0 ]]; then
@@ -54,7 +56,7 @@ cleanup()
 	fi
 }
 
-test()
+test1()
 {
 	client_args="$1"
 	server_args="$2"
@@ -77,6 +79,28 @@ test()
 	echo "Test client args '$client_args'; server args '$server_args': PASS"
 }
 
+test2()
+{
+	client_args="$1"
+        server_args="$2"
+
+        echo "Test client args '$client_args'; server args '$server_args'"
+
+        server_pid=0
+        if [[ -n "$server_args" ]]; then
+                ip netns exec $TARGET_NS ./xdping_realtime $server_args &
+                server_pid=$!
+                sleep 10
+        fi
+        ./xdping_realtime $client_args $TARGET_IP
+
+        if [[ $server_pid -ne 0 ]]; then
+                kill -TERM $server_pid
+                server_pid=0
+        fi
+
+        echo "Test client args '$client_args'; server args '$server_args': PASS"
+}
 set -e
 
 server_pid=0
@@ -85,14 +109,18 @@ trap cleanup EXIT
 
 setup
 
-for server_args in "" "-I veth0 -s -S" ; do
-	# client in skb mode
-	client_args="-I veth1 -S"
-	test "$client_args" "$server_args"
+for tests in test1 test2; do
+	echo "Running ${tests}:"
+	for server_args in "" "-I veth0 -s -S" ; do
+		# client in skb mode
+		client_args="-I veth1 -S"
+		${tests} "$client_args" "$server_args"
+
+		# client with count of 10 RTT measurements.
+		client_args="-I veth1 -S -c 10"
+		${tests} "$client_args" "$server_args"
+	done
 
-	# client with count of 10 RTT measurements.
-	client_args="-I veth1 -S -c 10"
-	test "$client_args" "$server_args"
 done
 
 echo "OK. All tests passed"
-- 
2.17.1

