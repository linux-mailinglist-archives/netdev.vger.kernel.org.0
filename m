Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D23C2899E5
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 22:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390844AbgJIUm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 16:42:58 -0400
Received: from www62.your-server.de ([213.133.104.62]:39494 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390511AbgJIUmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 16:42:53 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kQzE3-00085Q-8S; Fri, 09 Oct 2020 22:42:51 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, yhs@fb.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 6/6] bpf, selftests: add redirect_peer selftest
Date:   Fri,  9 Oct 2020 22:42:45 +0200
Message-Id: <20201009204245.27905-7-daniel@iogearbox.net>
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

Extend the test_tc_redirect test and add a small test that exercises the new
redirect_peer() helper for the IPv4 and IPv6 case.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 .../selftests/bpf/progs/test_tc_peer.c        | 45 +++++++++++++++++++
 .../testing/selftests/bpf/test_tc_redirect.sh | 25 +++++++----
 2 files changed, 61 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_tc_peer.c

diff --git a/tools/testing/selftests/bpf/progs/test_tc_peer.c b/tools/testing/selftests/bpf/progs/test_tc_peer.c
new file mode 100644
index 000000000000..fc84a7685aa2
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_tc_peer.c
@@ -0,0 +1,45 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <stdint.h>
+#include <stdbool.h>
+
+#include <linux/bpf.h>
+#include <linux/stddef.h>
+#include <linux/pkt_cls.h>
+
+#include <bpf/bpf_helpers.h>
+
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
+static __always_inline int get_dev_ifindex(int which)
+{
+	int *ifindex = bpf_map_lookup_elem(&ifindex_map, &which);
+
+	return ifindex ? *ifindex : 0;
+}
+
+SEC("chk_egress") int tc_chk(struct __sk_buff *skb)
+{
+	return TC_ACT_SHOT;
+}
+
+SEC("dst_ingress") int tc_dst(struct __sk_buff *skb)
+{
+	return bpf_redirect_peer(get_dev_ifindex(dev_src), 0);
+}
+
+SEC("src_ingress") int tc_src(struct __sk_buff *skb)
+{
+	return bpf_redirect_peer(get_dev_ifindex(dev_dst), 0);
+}
+
+char __license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_tc_redirect.sh b/tools/testing/selftests/bpf/test_tc_redirect.sh
index 6ad441405132..6d7482562140 100755
--- a/tools/testing/selftests/bpf/test_tc_redirect.sh
+++ b/tools/testing/selftests/bpf/test_tc_redirect.sh
@@ -4,9 +4,10 @@
 # This test sets up 3 netns (src <-> fwd <-> dst). There is no direct veth link
 # between src and dst. The netns fwd has veth links to each src and dst. The
 # client is in src and server in dst. The test installs a TC BPF program to each
-# host facing veth in fwd which calls into bpf_redirect_peer() to perform the
-# neigh addr population and redirect; it also installs a dropper prog on the
-# egress side to drop skbs if neigh addrs were not populated.
+# host facing veth in fwd which calls into i) bpf_redirect_neigh() to perform the
+# neigh addr population and redirect or ii) bpf_redirect_peer() for namespace
+# switch from ingress side; it also installs a checker prog on the egress side
+# to drop unexpected traffic.
 
 if [[ $EUID -ne 0 ]]; then
 	echo "This script must be run as root"
@@ -166,15 +167,17 @@ hex_mem_str()
 	perl -e 'print join(" ", unpack("(H2)8", pack("L", @ARGV)))' $1
 }
 
-netns_setup_neigh()
+netns_setup_bpf()
 {
+	local obj=$1
+
 	ip netns exec ${NS_FWD} tc qdisc add dev veth_src_fwd clsact
-	ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd ingress bpf da obj test_tc_neigh.o sec src_ingress
-	ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd egress  bpf da obj test_tc_neigh.o sec chk_egress
+	ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd ingress bpf da obj $obj sec src_ingress
+	ip netns exec ${NS_FWD} tc filter add dev veth_src_fwd egress  bpf da obj $obj sec chk_egress
 
 	ip netns exec ${NS_FWD} tc qdisc add dev veth_dst_fwd clsact
-	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd ingress bpf da obj test_tc_neigh.o sec dst_ingress
-	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd egress  bpf da obj test_tc_neigh.o sec chk_egress
+	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd ingress bpf da obj $obj sec dst_ingress
+	ip netns exec ${NS_FWD} tc filter add dev veth_dst_fwd egress  bpf da obj $obj sec chk_egress
 
 	veth_src=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_src_fwd/ifindex)
 	veth_dst=$(ip netns exec ${NS_FWD} cat /sys/class/net/veth_dst_fwd/ifindex)
@@ -193,5 +196,9 @@ trap netns_cleanup EXIT
 set -e
 
 netns_setup
-netns_setup_neigh
+netns_setup_bpf test_tc_neigh.o
+netns_test_connectivity
+netns_cleanup
+netns_setup
+netns_setup_bpf test_tc_peer.o
 netns_test_connectivity
-- 
2.17.1

