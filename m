Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E63C2D1C72
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgLGVys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727704AbgLGVyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:54:47 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A11C06179C;
        Mon,  7 Dec 2020 13:54:07 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id v14so574054wml.1;
        Mon, 07 Dec 2020 13:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j2GJRabSunARD8YAYxcZdryyZk68rTM+/fp67be2eow=;
        b=laRh28mRrRD+3DzwjUmChGOY0T0qcHYYaW9WXtY1JIMlQJe1ZeUGEn0vKn340kLhKH
         PWKFlSt7dcpxq164lCJrbt3768E9Uxitmhyuc7K7eKF/jD0j+wltpli/5H5m8OiK+c0z
         x4DHy6edrlRV5+5F9e0BeI9V/NVqFIzIjlNVmBBav1jcFwIPcsW+xEWy/+TSggoHcBF2
         BMWSKDbWGNBX2ubiq3JHe7Suxpwns86I1kxlcCPoWVmXFO8L8XW90QyWkJiTRrwzx1Wy
         TCrTYwCF+VN1EdUdbJ/98TB0ZhAPgho0Cb1h00HrSqdgpgxtW+HpS+PyObg6yBDTgsVc
         AJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j2GJRabSunARD8YAYxcZdryyZk68rTM+/fp67be2eow=;
        b=Eu8JFTZdfM9SrudHaon/j9A9r0br4pRbt803nH4KYcNYnZIo0wedOMuIsVW2ZM1qcz
         u2PHHfBcgEwFu1zv3wMtLU932055ILeyKFnIAMSvtYPdcyhT77XOoIXpzPfi998FQdQa
         P/9FjmNUwQOwjuk31yvLgbc4W8Vvm/gWjo+GvCcT5jTAI55ktaYyboxtv7Xv1CGJt4x1
         LQgxUlvvnpV9MdlFRNhJezpi7EzdTxPFhKcbSD3SQocqW5JBdeN1RifbyyW65hbbfRCN
         KoduHrrC0kW3dojSgJAo/IuWjLqFUuPcy6nAogIELm4Q9D9MW9gYj87zdpDYlNQiKsKB
         6iHg==
X-Gm-Message-State: AOAM533AfbYzSMTyeQtwFIELbW4rsOyJb/tIay1gVLIWNcwaqe7hzkbO
        UexTfgl5XaUCL3M61OR7n6huCQg23oRLcSAC
X-Google-Smtp-Source: ABdhPJzEd2XbWTuSF0/tLbCrHfxHYlZvrNwV2l8QTbqcndMU5g8cvdiqDzs842in8fdeBkLj2ag71g==
X-Received: by 2002:a05:600c:214a:: with SMTP id v10mr854790wml.138.1607378045347;
        Mon, 07 Dec 2020 13:54:05 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id z15sm1967290wrv.67.2020.12.07.13.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:54:04 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v4 3/5] selftests/bpf: xsk selftests - DRV POLL, NOPOLL
Date:   Mon,  7 Dec 2020 21:53:31 +0000
Message-Id: <20201207215333.11586-4-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
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
 tools/testing/selftests/bpf/test_xsk.sh  | 24 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 22 +++++++++++++++++++---
 tools/testing/selftests/bpf/xdpxceiver.h |  3 ++-
 3 files changed, 45 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 0b7bafb65f43..aad8065637fd 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -173,6 +173,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 4
+TEST_NAME="DRV NOPOLL"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 5
+TEST_NAME="DRV POLL"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-p")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 3f2a65b6a9f5..9fcd80a38b07 100644
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
@@ -88,7 +97,7 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
 
 static void pthread_init_mutex(void)
 {
@@ -311,6 +320,7 @@ static struct option long_options[] = {
 	{"queue", optional_argument, 0, 'q'},
 	{"poll", no_argument, 0, 'p'},
 	{"xdp-skb", no_argument, 0, 'S'},
+	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
@@ -326,6 +336,7 @@ static void usage(const char *prog)
 	    "  -q, --queue=n        Use queue n (default 0)\n"
 	    "  -p, --poll           Use poll syscall\n"
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
+	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
@@ -417,7 +428,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pScDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -448,6 +459,11 @@ static void parse_command_line(int argc, char **argv)
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
index 5929f2fc1224..12070d66344b 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -38,7 +38,7 @@
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
-#define NEED_WAKEUP 1
+#define NEED_WAKEUP true
 
 typedef __u32 u32;
 typedef __u16 u16;
@@ -46,6 +46,7 @@ typedef __u8 u8;
 
 enum TESTS {
 	ORDER_CONTENT_VALIDATE_XDP_SKB = 0,
+	ORDER_CONTENT_VALIDATE_XDP_DRV = 1,
 };
 
 u8 uut;
-- 
2.20.1

