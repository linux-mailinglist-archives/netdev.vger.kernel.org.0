Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D172BAABE
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbgKTNAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgKTNAs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:00:48 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706BEC0617A7;
        Fri, 20 Nov 2020 05:00:48 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k2so10001727wrx.2;
        Fri, 20 Nov 2020 05:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqPDMpsBsWncN0D3vZHUEIWW+p9RrnaMSW99zcouJ2U=;
        b=QGd1GHgALAI2gakDnb+Tus1CZANbHSax7qqHwluuYxQPqQkj/A2o++dHAfzbwVmrqb
         YdrmO90HFXZUHtnZV1j3CLbl2/UhJSFcNEiGp3OBFObIL2Q2Z6pBEys4AMfSJYfOF2GU
         2F2GM9/7j6d9im898Fwke+HnHRbQlWyzOqHi9KYlJhr70MwtUeFptkXszPu34pY2HR8q
         APenf18Uef4gomjv1UmMSMPDF3b/ngjFeO2Vq24JZyRI2BOLP7KIPJZslgqRU1xnWdBn
         +5lULvuIEatEobGcsJYy4xsC/Bg9pk341X0P1uZhYElwdineyVvF00+J4j4orbl2Vv4i
         sU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqPDMpsBsWncN0D3vZHUEIWW+p9RrnaMSW99zcouJ2U=;
        b=lxWaoOhIU2162tyHBBAro6PbaYOQadUAPJGswgzeA4l4cOp3F672rrgAH9/Wau9yhM
         Mi51iNwQbZjJRERWxZBv/qYvvCuaBcZAuoT0hJ7iUQ+Iljdse0A2eO9OQF9TIaqhUMyq
         mjt3VXYcSj0tdXGm/yxnqi4m/xcXOEsl0BRvtStXwx1WkpbUj2CB+aYZAzH51IMcxY2u
         ZlSpBaVyiS7sDj/ptj/a4e8OHcmFV/kOEQg9PDKgHbyQfOiv/5sHtVIzSLO2efkYPcNj
         cx6Hv93hMy/tjrqTjbim8vvr1YnwfgS6TlnBJhg7MmWrKMg8c8MNBUoZ/IenN25p8MtM
         L5zQ==
X-Gm-Message-State: AOAM533Q7hoTRLAHZlxU0a/nm4dXPnLkIrsdOG+sbIvhFyVv240aN5Pf
        d7qn51jIX8pReMOiy9zUy4TOInXJcqCvNnxthLo=
X-Google-Smtp-Source: ABdhPJxursT98gNAnhKgzTWKag17A3LYeHuSU6xzvIDoaexz9HYAjujC6YOkQ0L8YC25MnWPXpdMnQ==
X-Received: by 2002:adf:8521:: with SMTP id 30mr15965711wrh.265.1605877246545;
        Fri, 20 Nov 2020 05:00:46 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id b8sm4074238wmj.9.2020.11.20.05.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 05:00:45 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, magnus.karlsson@gmail.com, bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v2 3/5] selftests/bpf: xsk selftests - DRV POLL, NOPOLL
Date:   Fri, 20 Nov 2020 13:00:24 +0000
Message-Id: <20201120130026.19029-4-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
References: <20201120130026.19029-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds following tests:

2. AF_XDP DRV/Native mode
   Works on any netdevice with XDP_REDIRECT support, driver dependent.
   Processes packets before SKB allocation. Provides better performance
   than SKB. Driver hook available just after DMA of buffer descriptor.
   a. nopoll
   b. poll
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/Makefile          |  4 +++-
 .../selftests/bpf/test_xsk_drv_nopoll.sh      | 20 ++++++++++++++++
 .../selftests/bpf/test_xsk_drv_poll.sh        | 23 +++++++++++++++++++
 .../selftests/bpf/test_xsk_skb_poll.sh        |  3 ---
 tools/testing/selftests/bpf/xdpxceiver.c      | 22 +++++++++++++++---
 tools/testing/selftests/bpf/xdpxceiver.h      |  1 +
 6 files changed, 66 insertions(+), 7 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_nopoll.sh
 create mode 100755 tools/testing/selftests/bpf/test_xsk_drv_poll.sh

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 17af570a32d7..9dd3f3b9014f 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -74,7 +74,9 @@ TEST_PROGS := test_kmod.sh \
 	test_bpftool_metadata.sh \
 	test_xsk_prerequisites.sh \
 	test_xsk_skb_nopoll.sh \
-	test_xsk_skb_poll.sh
+	test_xsk_skb_poll.sh \
+	test_xsk_drv_nopoll.sh \
+	test_xsk_drv_poll.sh
 
 TEST_PROGS_EXTENDED := with_addr.sh \
 	with_tunnels.sh \
diff --git a/tools/testing/selftests/bpf/test_xsk_drv_nopoll.sh b/tools/testing/selftests/bpf/test_xsk_drv_nopoll.sh
new file mode 100755
index 000000000000..a7e895bc4bfd
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk_drv_nopoll.sh
@@ -0,0 +1,20 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+# See test_xsk_prerequisites.sh for detailed information on tests
+
+. xsk_prereqs.sh
+. xsk_env.sh
+
+TEST_NAME="DRV NOPOLL"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/bpf/test_xsk_drv_poll.sh b/tools/testing/selftests/bpf/test_xsk_drv_poll.sh
new file mode 100755
index 000000000000..1fe488d5794a
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_xsk_drv_poll.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2020 Intel Corporation.
+
+# See test_xsk_prerequisites.sh for detailed information on tests
+
+. xsk_prereqs.sh
+. xsk_env.sh
+
+TEST_NAME="DRV POLL"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-p")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+
+# Must be called in the last test to execute
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+
+test_exit $retval 0
diff --git a/tools/testing/selftests/bpf/test_xsk_skb_poll.sh b/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
index d152c8a24251..962a89b40a32 100755
--- a/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
+++ b/tools/testing/selftests/bpf/test_xsk_skb_poll.sh
@@ -17,7 +17,4 @@ execxdpxceiver params
 retval=$?
 test_status $retval "${TEST_NAME}"
 
-# Must be called in the last test to execute
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
-
 test_exit $retval 0
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 106307155bbe..e998200502de 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -27,7 +27,16 @@
  *    a. nopoll - soft-irq processing
  *    b. poll - using poll() syscall
  *
- * Total tests: 2
+ * 2. AF_XDP DRV/Native mode
+ *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
+ *    packets before SKB allocation. Provides better performance than SKB. Driver
+ *    hook available just after DMA of buffer descriptor.
+ *    a. nopoll
+ *    b. poll
+ *    - Only copy mode is supported because veth does not currently support
+ *      zero-copy mode
+ *
+ * Total tests: 4
  *
  * Flow:
  * -----
@@ -87,7 +96,7 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
 
 static void pthread_init_mutex(void)
 {
@@ -310,6 +319,7 @@ static struct option long_options[] = {
 	{"queue", optional_argument, 0, 'q'},
 	{"poll", no_argument, 0, 'p'},
 	{"xdp-skb", no_argument, 0, 'S'},
+	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
@@ -325,6 +335,7 @@ static void usage(const char *prog)
 	    "  -q, --queue=n        Use queue n (default 0)\n"
 	    "  -p, --poll           Use poll syscall\n"
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
+	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
@@ -416,7 +427,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pScDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -446,6 +457,11 @@ static void parse_command_line(int argc, char **argv)
 			opt_xdp_bind_flags |= XDP_COPY;
 			uut = ORDER_CONTENT_VALIDATE_XDP_SKB;
 			break;
+		case 'N':
+			opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
+			opt_xdp_bind_flags |= XDP_COPY;
+			uut = ORDER_CONTENT_VALIDATE_XDP_DRV;
+			break;
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 32ee33311141..dba47e818466 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -44,6 +44,7 @@ typedef __u8 u8;
 
 enum TESTS {
 	ORDER_CONTENT_VALIDATE_XDP_SKB = 0,
+	ORDER_CONTENT_VALIDATE_XDP_DRV = 1,
 };
 
 u8 uut;
-- 
2.20.1

