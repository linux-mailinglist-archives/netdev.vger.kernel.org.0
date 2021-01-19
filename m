Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 959C22FBB65
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725771AbhASPj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:39:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391539AbhASPh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:37:59 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54836C061793;
        Tue, 19 Jan 2021 07:37:19 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id m25so29621723lfc.11;
        Tue, 19 Jan 2021 07:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mzur33W7H1Bgzwa0dFrLF2wAgaQwxYBaCzvYFoXPOHU=;
        b=g410lA8FMwC6f+P2pwDXfImkiS+xpXRZb2lhTLCq4pwZNz5zqgaOJBmLdBJK8ihmYV
         CsXAzUKB//54anGcEBLElRHiUgitWKot1t695762lgxjE8CeR2QYzBs8OR92R8pb/52x
         uVoW+zv6sOam23MnxArZUIRWB+SBWdCBak0ZoSfyha0rDKwtt6wtPMJhZOlVpNAzS/8s
         YzOADREppyUyhL1snNTF7tO/9d/ylVnnaR5HHepy79gszrrVTKDBkGJan3h+kFZjgLya
         f/j2ugexxtyTK35OZkbI4kcRz/Qu6etC2qNXFzEpsouiDzpyzqDBZsHBfXRz7t49wOwE
         WTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mzur33W7H1Bgzwa0dFrLF2wAgaQwxYBaCzvYFoXPOHU=;
        b=MebriF7crs9yd8hodPVmcPpHtEjm2M5ZX0NnLe0s4sEEC61GGb2S/FPcSw39d5Y7bf
         /ZX2j9nG55crr3NVjRovbmZC8e3nTVI3jR4qRJxbVOuzevxYY1X09hyNv78Wrch+EK9a
         +mFNVGlltlJHaKtSo2oAp1aMLQsq1lTT13zSmuvQVBv2L/CC0oZk6PTZUJspyJhFOUVf
         MHp/krGjoetwCjg8MdFuVR3HdVg3G/Tc3/3hqcpP2Gezo8ofh/fZ3Af43lrgNjhBsiTs
         JLHS348bMyCGNQ0LhqdU6ZQSl3hrA6TaqQ56PbAG/VOaK0XXZZk63BBae4I1fzUeFASP
         0hbw==
X-Gm-Message-State: AOAM530AWsPZyJ0KJM+yi5I4GgAmEPIaOQDUCAFVoOzZtAW773va1xUL
        7LHTEr4um+08DBbQq7IVKKk=
X-Google-Smtp-Source: ABdhPJzWKTfZxuv5pAX/GcihOwSizk30yBJX2yvw+9fTHGiHVFYYt0ZA3fiH8hp6oz2qZENOm8NSUw==
X-Received: by 2002:a19:7d2:: with SMTP id 201mr2003647lfh.518.1611070637880;
        Tue, 19 Jan 2021 07:37:17 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id z2sm2309075lfd.142.2021.01.19.07.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 07:37:17 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org, jonathan.lemon@gmail.com, maximmi@nvidia.com,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 7/8] selftest/bpf: add XDP socket tests for bpf_redirect_{xsk, map}()
Date:   Tue, 19 Jan 2021 16:36:54 +0100
Message-Id: <20210119153655.153999-8-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210119153655.153999-1-bjorn.topel@gmail.com>
References: <20210119153655.153999-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Add support for externally loaded XDP programs to
xdpxceiver/test_xsk.sh, so that bpf_redirect_xsk() and
bpf_redirect_map() can be exercised.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 48 +++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 77 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/xdpxceiver.h |  2 +
 3 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 88a7483eaae4..3a3996edf527 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -245,6 +245,54 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 10
+TEST_NAME="SKB EXT BPF_REDIRECT_MAP"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "--ext-prog1")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 11
+TEST_NAME="DRV EXT BPF_REDIRECT_MAP"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "--ext-prog1")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 12
+TEST_NAME="SKB EXT BPF_REDIRECT_XSK"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "--ext-prog2")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 13
+TEST_NAME="DRV EXT BPF_REDIRECT_XSK"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "--ext-prog2")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1e722ee76b1f..b88be91a6875 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -45,7 +45,7 @@
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
  *
- * Total tests: 8
+ * Total tests: 13
  *
  * Flow:
  * -----
@@ -93,6 +93,7 @@ typedef __u16 __sum16;
 #include <unistd.h>
 #include <stdatomic.h>
 #include <bpf/xsk.h>
+#include <bpf/bpf.h>
 #include "xdpxceiver.h"
 #include "../kselftest.h"
 
@@ -296,6 +297,23 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
 }
 
+static int update_xskmap(struct bpf_object *obj, struct xsk_socket_info *xsk)
+{
+	int xskmap, fd, key = opt_queue;
+	struct bpf_map *map;
+
+	map = bpf_object__find_map_by_name(obj, "xsks_map");
+	xskmap = bpf_map__fd(map);
+	if (xskmap < 0)
+		return 0;
+
+	fd = xsk_socket__fd(xsk->xsk);
+	if (bpf_map_update_elem(xskmap, &key, &fd, 0))
+		return -1;
+
+	return 0;
+}
+
 static int xsk_configure_socket(struct ifobject *ifobject)
 {
 	struct xsk_socket_config cfg;
@@ -310,7 +328,7 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 	ifobject->xsk->umem = ifobject->umem;
 	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
-	cfg.libbpf_flags = 0;
+	cfg.libbpf_flags = ifobject->obj ? XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD : 0;
 	cfg.xdp_flags = opt_xdp_flags;
 	cfg.bind_flags = opt_xdp_bind_flags;
 
@@ -328,6 +346,11 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 	if (ret)
 		return 1;
 
+	if (ifobject->obj) {
+		if (update_xskmap(ifobject->obj, ifobject->xsk))
+			exit_with_error(errno);
+	}
+
 	return 0;
 }
 
@@ -342,6 +365,8 @@ static struct option long_options[] = {
 	{"bidi", optional_argument, 0, 'B'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
+	{"ext-prog1", no_argument, 0, 1},
+	{"ext-prog2", no_argument, 0, 1},
 	{0, 0, 0, 0}
 };
 
@@ -441,9 +466,30 @@ static int validate_interfaces(void)
 	return ret;
 }
 
+static int load_xdp_program(char *argv0, struct bpf_object **obj, int ext_prog)
+{
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type      = BPF_PROG_TYPE_XDP,
+	};
+	char xdp_filename[256];
+	int prog_fd;
+
+	snprintf(xdp_filename, sizeof(xdp_filename), "%s_ext%d.o", argv0, ext_prog);
+	prog_load_attr.file = xdp_filename;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, obj, &prog_fd))
+		return -1;
+	return prog_fd;
+}
+
+static int attach_xdp_program(int ifindex, int prog_fd)
+{
+	return bpf_set_link_xdp_fd(ifindex, prog_fd, opt_xdp_flags);
+}
+
 static void parse_command_line(int argc, char **argv)
 {
-	int option_index, interface_index = 0, c;
+	int option_index = 0, interface_index = 0, ext_prog = 0, c;
 
 	opterr = 0;
 
@@ -454,6 +500,9 @@ static void parse_command_line(int argc, char **argv)
 			break;
 
 		switch (c) {
+		case 1:
+			ext_prog = atoi(long_options[option_index].name + strlen("ext-prog"));
+			break;
 		case 'i':
 			if (interface_index == MAX_INTERFACES)
 				break;
@@ -509,6 +558,22 @@ static void parse_command_line(int argc, char **argv)
 		usage(basename(argv[0]));
 		ksft_exit_xfail();
 	}
+
+	if (ext_prog) {
+		struct bpf_object *obj;
+		int prog_fd;
+
+		for (int i = 0; i < MAX_INTERFACES; i++) {
+			prog_fd = load_xdp_program(argv[0], &obj, ext_prog);
+			if (prog_fd < 0) {
+				ksft_test_result_fail("ERROR: could not load external XDP program\n");
+				ksft_exit_xfail();
+			}
+
+			ifdict[i]->prog_fd = prog_fd;
+			ifdict[i]->obj = obj;
+		}
+	}
 }
 
 static void kick_tx(struct xsk_socket_info *xsk)
@@ -818,6 +883,7 @@ static void *worker_testapp_validate(void *arg)
 	struct generic_data *data = (struct generic_data *)malloc(sizeof(struct generic_data));
 	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
+	struct ifobject *ifobject = (struct ifobject *)arg;
 	void *bufs = NULL;
 
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
@@ -830,6 +896,9 @@ static void *worker_testapp_validate(void *arg)
 
 		if (strcmp(((struct ifobject *)arg)->nsname, ""))
 			switch_namespace(((struct ifobject *)arg)->ifdict_index);
+
+		if (ifobject->obj && attach_xdp_program(ifobject->ifindex, ifobject->prog_fd) < 0)
+			exit_with_error(errno);
 	}
 
 	if (((struct ifobject *)arg)->fv.vector == tx) {
@@ -1035,7 +1104,7 @@ int main(int argc, char **argv)
 	ifaceconfig->src_port = UDP_SRC_PORT;
 
 	for (int i = 0; i < MAX_INTERFACES; i++) {
-		ifdict[i] = (struct ifobject *)malloc(sizeof(struct ifobject));
+		ifdict[i] = (struct ifobject *)calloc(1, sizeof(struct ifobject));
 		if (!ifdict[i])
 			exit_with_error(errno);
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 61f595b6f200..3c15c2e95026 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -124,6 +124,8 @@ struct ifobject {
 	u32 src_ip;
 	u16 src_port;
 	u16 dst_port;
+	int prog_fd;
+	struct bpf_object *obj;
 };
 
 static struct ifobject *ifdict[MAX_INTERFACES];
-- 
2.27.0

