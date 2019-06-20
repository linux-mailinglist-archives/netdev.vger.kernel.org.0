Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5844C55C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 04:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731546AbfFTCXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 22:23:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35209 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfFTCXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 22:23:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so720448pgl.2;
        Wed, 19 Jun 2019 19:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXEldHMfNr4STLrSJDkwpcTDRF1aPJqHVLnszkg829M=;
        b=EQsgQgN/yhpyV+w+MQ3FEV/kSJnVpnlluzd4JJzWqXebvkt5KnwXUIcNGc8tGVcRJq
         jzRPve6/FT0StGYJpkscyFGjOgu6s8B4zVBLJGbpWAI+mBYAHP5eOzOMyNYfotaM0kKq
         Uh92ApldC6mvZFjNujMGc4+Cwj9PB4u6YcNveY36v+CjthwX8CtsmyV7xrFiHkEVPMFx
         Z5c2mbrbvFBSgqKDUfDkGdJhRCXG1oOnlZhMyS/kFY1CFl3h1oRzDkpgC/k1FYteDEFy
         J8Edluye3dlmN/bdIhPF/Thi7si2FyL7l6j1B0jKqBRnnRilNfYk5b1w3Dm28tGmzERs
         bhog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXEldHMfNr4STLrSJDkwpcTDRF1aPJqHVLnszkg829M=;
        b=o/R7avBvSTdaBjr+Q8YaCiKp/nQu1JCvx5z34FfT+ltYSu1ZlBmnYm98VvyBrPn2PU
         Z+DlJ+bH/2TWs6cqFhe8h0yIJlGhPEa4YyoU0pc/2Tua7vcaI9//mo5pgrT/Sozbqjed
         A2x2wPuh/d8lHSD8jpeh73GWVezzbdWensCab0PJRQ+4C39u9UUXUkytX14Be6mmNeKQ
         MQpdh1CoOP4iFwjKNdiL7hBTMiCdMwaJC2d4ndYV3QIuIrXciLTbuxY1dDJnMr5XvMri
         g5mJSJ4yscnYamuytCD6UaDnm+bBGurTWT49hXSnbAp2sxTqPLmYPF+s21RYCugOJ9ov
         aBNg==
X-Gm-Message-State: APjAAAUlIGue75pU78376sv1RDsBM0tML0B4tCI7Poiunt+NSarzR7DA
        GqHedqPpLHsJ7KTqTOfmhZ0=
X-Google-Smtp-Source: APXvYqy7i3XC7mqdxyX5B/1q312dYYoDVqNle6CbOeW5geEmUA5NKIh7izMI8V7AE/g5sGeQjpqrHw==
X-Received: by 2002:a17:90a:342c:: with SMTP id o41mr420622pjb.1.1560997424511;
        Wed, 19 Jun 2019 19:23:44 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id g2sm18873362pgi.92.2019.06.19.19.23.41
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 19:23:44 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, xdp-newbies@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH bpf-next] selftests: Add test for veth native XDP
Date:   Thu, 20 Jun 2019 11:23:23 +0900
Message-Id: <20190620022323.19243-1-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a test case for veth native XDP. It checks if XDP_PASS, XDP_TX and
XDP_REDIRECT work properly.

  $ cd tools/testing/selftests/bpf
  $ make \
  	TEST_CUSTOM_PROGS= \
  	TEST_GEN_PROGS= \
  	TEST_GEN_PROGS_EXTENDED= \
  	TEST_PROGS_EXTENDED= \
  	TEST_PROGS="test_xdp_veth.sh" \
  	run_tests
  TAP version 13
  1..1
  # selftests: bpf: test_xdp_veth.sh
  # PING 10.1.1.33 (10.1.1.33) 56(84) bytes of data.
  # 64 bytes from 10.1.1.33: icmp_seq=1 ttl=64 time=0.073 ms
  #
  # --- 10.1.1.33 ping statistics ---
  # 1 packets transmitted, 1 received, 0% packet loss, time 0ms
  # rtt min/avg/max/mdev = 0.073/0.073/0.073/0.000 ms
  # selftests: xdp_veth [PASS]
  ok 1 selftests: bpf: test_xdp_veth.sh

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 tools/testing/selftests/bpf/Makefile               |   1 +
 .../testing/selftests/bpf/progs/xdp_redirect_map.c |  31 ++++++
 tools/testing/selftests/bpf/progs/xdp_tx.c         |  12 +++
 tools/testing/selftests/bpf/test_xdp_veth.sh       | 118 +++++++++++++++++++++
 4 files changed, 162 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_redirect_map.c
 create mode 100644 tools/testing/selftests/bpf/progs/xdp_tx.c
 create mode 100755 tools/testing/selftests/bpf/test_xdp_veth.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 44fb61f..11128ba 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -46,6 +46,7 @@ TEST_PROGS := test_kmod.sh \
 	test_libbpf.sh \
 	test_xdp_redirect.sh \
 	test_xdp_meta.sh \
+	test_xdp_veth.sh \
 	test_offload.py \
 	test_sock_addr.sh \
 	test_tunnel.sh \
diff --git a/tools/testing/selftests/bpf/progs/xdp_redirect_map.c b/tools/testing/selftests/bpf/progs/xdp_redirect_map.c
new file mode 100644
index 0000000..e87a985
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_redirect_map.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+struct bpf_map_def SEC("maps") tx_port = {
+	.type = BPF_MAP_TYPE_DEVMAP,
+	.key_size = sizeof(int),
+	.value_size = sizeof(int),
+	.max_entries = 8,
+};
+
+SEC("redirect_map_0")
+int xdp_redirect_map_0(struct xdp_md *xdp)
+{
+	return bpf_redirect_map(&tx_port, 0, 0);
+}
+
+SEC("redirect_map_1")
+int xdp_redirect_map_1(struct xdp_md *xdp)
+{
+	return bpf_redirect_map(&tx_port, 1, 0);
+}
+
+SEC("redirect_map_2")
+int xdp_redirect_map_2(struct xdp_md *xdp)
+{
+	return bpf_redirect_map(&tx_port, 2, 0);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/progs/xdp_tx.c b/tools/testing/selftests/bpf/progs/xdp_tx.c
new file mode 100644
index 0000000..57912e7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/xdp_tx.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include "bpf_helpers.h"
+
+SEC("tx")
+int xdp_tx(struct xdp_md *xdp)
+{
+	return XDP_TX;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_xdp_veth.sh b/tools/testing/selftests/bpf/test_xdp_veth.sh
new file mode 100755
index 0000000..ba8ffcd
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xdp_veth.sh
@@ -0,0 +1,118 @@
+#!/bin/sh
+# SPDX-License-Identifier: GPL-2.0
+#
+# Create 3 namespaces with 3 veth peers, and
+# forward packets in-between using native XDP
+#
+#                      XDP_TX
+# NS1(veth11)        NS2(veth22)        NS3(veth33)
+#      |                  |                  |
+#      |                  |                  |
+#   (veth1,            (veth2,            (veth3,
+#   id:111)            id:122)            id:133)
+#     ^ |                ^ |                ^ |
+#     | |  XDP_REDIRECT  | |  XDP_REDIRECT  | |
+#     | ------------------ ------------------ |
+#     -----------------------------------------
+#                    XDP_REDIRECT
+
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+TESTNAME=xdp_veth
+BPF_FS=$(awk '$3 == "bpf" {print $2; exit}' /proc/mounts)
+BPF_DIR=$BPF_FS/test_$TESTNAME
+
+_cleanup()
+{
+	set +e
+	ip link del veth1 2> /dev/null
+	ip link del veth2 2> /dev/null
+	ip link del veth3 2> /dev/null
+	ip netns del ns1 2> /dev/null
+	ip netns del ns2 2> /dev/null
+	ip netns del ns3 2> /dev/null
+	rm -rf $BPF_DIR 2> /dev/null
+}
+
+cleanup_skip()
+{
+	echo "selftests: $TESTNAME [SKIP]"
+	_cleanup
+
+	exit $ksft_skip
+}
+
+cleanup()
+{
+	if [ "$?" = 0 ]; then
+		echo "selftests: $TESTNAME [PASS]"
+	else
+		echo "selftests: $TESTNAME [FAILED]"
+	fi
+	_cleanup
+}
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
+set -e
+
+trap cleanup_skip EXIT
+
+ip netns add ns1
+ip netns add ns2
+ip netns add ns3
+
+ip link add veth1 index 111 type veth peer name veth11 netns ns1
+ip link add veth2 index 122 type veth peer name veth22 netns ns2
+ip link add veth3 index 133 type veth peer name veth33 netns ns3
+
+ip link set veth1 up
+ip link set veth2 up
+ip link set veth3 up
+
+ip -n ns1 addr add 10.1.1.11/24 dev veth11
+ip -n ns3 addr add 10.1.1.33/24 dev veth33
+
+ip -n ns1 link set dev veth11 up
+ip -n ns2 link set dev veth22 up
+ip -n ns3 link set dev veth33 up
+
+mkdir $BPF_DIR
+bpftool prog loadall \
+	xdp_redirect_map.o $BPF_DIR/progs type xdp \
+	pinmaps $BPF_DIR/maps
+bpftool map update pinned $BPF_DIR/maps/tx_port key 0 0 0 0 value 122 0 0 0
+bpftool map update pinned $BPF_DIR/maps/tx_port key 1 0 0 0 value 133 0 0 0
+bpftool map update pinned $BPF_DIR/maps/tx_port key 2 0 0 0 value 111 0 0 0
+ip link set dev veth1 xdp pinned $BPF_DIR/progs/redirect_map_0
+ip link set dev veth2 xdp pinned $BPF_DIR/progs/redirect_map_1
+ip link set dev veth3 xdp pinned $BPF_DIR/progs/redirect_map_2
+
+ip -n ns1 link set dev veth11 xdp obj xdp_dummy.o sec xdp_dummy
+ip -n ns2 link set dev veth22 xdp obj xdp_tx.o sec tx
+ip -n ns3 link set dev veth33 xdp obj xdp_dummy.o sec xdp_dummy
+
+trap cleanup EXIT
+
+ip netns exec ns1 ping -c 1 -W 1 10.1.1.33
+
+exit 0
-- 
1.8.3.1

