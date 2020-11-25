Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B622C47CE
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733144AbgKYSik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgKYSik (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:38:40 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28965C061A4F;
        Wed, 25 Nov 2020 10:38:27 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id x22so2855288wmc.5;
        Wed, 25 Nov 2020 10:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ykg+zRKUz3wwEC89YVTbUV/NP2PvBj24tnqMc0bQybQ=;
        b=F8l7qpc7AzjvUqk7toMaxbrAvVHvZrk08zN60hXIpvyMmxqTwodaRKglozVNkbb75j
         Xkh/Dww7sU5y42BjmQbTwRdrvoFLrH5DiY3a2MDX49Ok21Vu3L4aX01QWTVAt4ajFm+b
         wpMAMAB9M62AalMXMCIr7dHF0OTLYy58RHHlHYpP2a97oWrwC/gIVVVTaVGeJrtv6CQt
         YGqoFxx9LvGazjytudfv68f00mn8IdJeMkxD+QJyTS9vp+5zhemJa4AlXGHA3ibabryA
         P+Xrij6OXg1/S38oYrRc9HSzGi2hVP3iWUoKGDngeD6OmsV62g4jt3Ki8ozFN58A6iac
         OLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ykg+zRKUz3wwEC89YVTbUV/NP2PvBj24tnqMc0bQybQ=;
        b=c5ToxXEdprrBLlpP+EVtPBA8kEj+JgUMhytYT+m+Mxu8Q80Qlz7WL3fzEsW7tPQBMC
         5r7uz2kqxB8F+4o8xM0uEOupoPeozCYmJ75gVl4P9yAMabzS6yVcnum74rvKyx2SUJ7P
         gTaF+Z/epYW4kVl2vv00rgYUu84O0KHV0693HtWtQ5ShM9dRO24VslPuXiTfR0APLaru
         TPF41kF8CL5s6YfJSSElir3brnsgZHdJuHNP8kH8giEppVyRaEpiXLsMUJyYE41qQDeK
         73sipVAkSlXMnPr7Pz2JBzYVAL5YLDoq61zLC2VMzvEQD7kCfQ2adH6nyLGKZ0JFTAgQ
         g/PA==
X-Gm-Message-State: AOAM531ee3aZDu0VMa4A+/mBh2dTcLm2Q3qO4Hd2WToofU5WXBybLUY1
        9SkoYmHb6oRVNdJoazGIpT5al74C3ajVOqpj
X-Google-Smtp-Source: ABdhPJxyqV9XzXWphIbgEoDVQcexn3dAc1QsL/ZO3ByTD35iZ6YFCBIhMv2GRulCpqzV4wLp8VMEFA==
X-Received: by 2002:a1c:b082:: with SMTP id z124mr5231640wme.129.1606329505359;
        Wed, 25 Nov 2020 10:38:25 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id h2sm5830035wrv.76.2020.11.25.10.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:38:24 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 3/5] selftests/bpf: xsk selftests - DRV POLL, NOPOLL
Date:   Wed, 25 Nov 2020 18:37:47 +0000
Message-Id: <20201125183749.13797-4-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
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
 tools/testing/selftests/bpf/xdpxceiver.h |  1 +
 3 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 9c3812bd353f..375f9590db90 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -152,6 +152,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 3
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
+### TEST 4
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
index e6c448668cd9..3027247bbb4e 100644
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

