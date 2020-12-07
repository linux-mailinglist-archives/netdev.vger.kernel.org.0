Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D62D1C77
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 22:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727762AbgLGVyu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 16:54:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgLGVyt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 16:54:49 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81806C0617B0;
        Mon,  7 Dec 2020 13:54:08 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id x22so556117wmc.5;
        Mon, 07 Dec 2020 13:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFD+M+1PmvEjO90D1UfMAL1PjOjTY46aguJxjsdOt4g=;
        b=cNIdIpk86yb9AMhNPGX1Jiw7fknGQXzkKSov+T+gRJVJFxShlgbwB5Yyqtr/SB0aeS
         AXJfuCwC4xOoyNR1Hj2R4FCtQuIF8qvh9M246bi38HfShnFBF9NEGcJGUJWkpRSfAZaU
         TS3VAkonzMjGAhoBUNIorzVNV7w2JV3+x1LNDgyMQR0FYdlLJ+FY973Tiz5fjhins+Hh
         bcvNznkve68U8+/ojEkPGsvU5dtp9DG2l3uxc9wP9HNEhxD7FHSJHdnAMKcN+3fodUl0
         dgyr+fJKLvwlaw9G1nXeYE+BLLrLcM7ZN8z/dsoILDxytQp3v0jKKLKMjX743ocoooKa
         mu8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFD+M+1PmvEjO90D1UfMAL1PjOjTY46aguJxjsdOt4g=;
        b=FfqWIphv2bk74EW8NMzsa5pIUOIydu5QlrybayQrj29Gz2Dl/1rq+O8tgtw/+wj8G4
         XTEpN2gY22AEYl3e/MEO/EPiTrQMVnWBRDpDkqfV29XWKpP6wF+t3V3o6qV9dr5j+uKo
         xUEBLBQ3nCczBaAvh+k0nDwF2gD+yezSluNbtI39N3xx/CIiZAzAT6jiYGTg1myurcBP
         SPX2NuPzEPScc8y+b7ytJyaHueLx7Rn6kK4MLrjlQ/TKBcIeq1hXriKgm3bYiZnqDPsJ
         3ipanE2P7znYirOelYjzHMkkhOJVobQP9pRER3rkO91PCgr+kth4NMh7L/tQCuVmfvcl
         /Zaw==
X-Gm-Message-State: AOAM530Yh0W/CNzuex2V5+dYteadUjSdimwmQ8ZJW2TGpWoiinLrXeJd
        Uib5gVS/Y7FmNxy03JlD6r1k3hr+4ymEuSDT
X-Google-Smtp-Source: ABdhPJzIcFSRP0ABLhHCpRxl5V4pcDI3UJi32p6e+ozpVSoSL8w71oaS+FA2+TmZmE0LB89niPYvOg==
X-Received: by 2002:a7b:cc0f:: with SMTP id f15mr857695wmh.29.1607378046544;
        Mon, 07 Dec 2020 13:54:06 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id z15sm1967290wrv.67.2020.12.07.13.54.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 13:54:05 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v4 4/5] selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
Date:   Mon,  7 Dec 2020 21:53:32 +0000
Message-Id: <20201207215333.11586-5-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
References: <20201207215333.11586-1-weqaar.a.janjua@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds following tests:

1. AF_XDP SKB mode
   c. Socket Teardown
      Create a Tx and a Rx socket, Tx from one socket, Rx on another.
      Destroy both sockets, then repeat multiple times. Only nopoll mode
      is used

2. AF_XDP DRV/Native mode
   c. Socket Teardown
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  | 24 ++++++++++++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 35 +++++++++++++++++++++---
 tools/testing/selftests/bpf/xdpxceiver.h |  2 ++
 3 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index aad8065637fd..9be9dff25560 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -197,6 +197,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 6
+TEST_NAME="SKB SOCKET TEARDOWN"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-T")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 7
+TEST_NAME="DRV SOCKET TEARDOWN"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-T")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 9fcd80a38b07..e8907109782d 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -26,6 +26,9 @@
  *    generic XDP path. XDP hook from netif_receive_skb().
  *    a. nopoll - soft-irq processing
  *    b. poll - using poll() syscall
+ *    c. Socket Teardown
+ *       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
+ *       both sockets, then repeat multiple times. Only nopoll mode is used
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -33,10 +36,11 @@
  *    hook available just after DMA of buffer descriptor.
  *    a. nopoll
  *    b. poll
+ *    c. Socket Teardown
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
  *
- * Total tests: 4
+ * Total tests: 6
  *
  * Flow:
  * -----
@@ -97,7 +101,8 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
+			       "NOPOLL", opt_teardown ? "Socket Teardown" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -322,6 +327,7 @@ static struct option long_options[] = {
 	{"xdp-skb", no_argument, 0, 'S'},
 	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
+	{"tear-down", no_argument, 0, 'T'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -338,6 +344,7 @@ static void usage(const char *prog)
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
 	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
+	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
@@ -428,7 +435,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -467,6 +474,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
+		case 'T':
+			opt_teardown = 1;
+			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -871,6 +881,9 @@ static void *worker_testapp_validate(void *arg)
 
 		ksft_print_msg("Received %d packets on interface %s\n",
 			       pkt_counter, ((struct ifobject *)arg)->ifname);
+
+		if (opt_teardown)
+			ksft_print_msg("Destroying socket\n");
 	}
 
 	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
@@ -916,6 +929,20 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
+	if (!opt_teardown)
+		print_ksft_result();
+}
+
+static void testapp_sockets(void)
+{
+	for (int i = 0; i < MAX_TEARDOWN_ITER; i++) {
+		pkt_counter = 0;
+		prev_pkt = -1;
+		sigvar = 0;
+		ksft_print_msg("Creating socket\n");
+		testapp_validate();
+	}
+
 	print_ksft_result();
 }
 
@@ -982,7 +1009,7 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
-	testapp_validate();
+	opt_teardown ? testapp_sockets() : testapp_validate();
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 12070d66344b..58185b914f99 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -21,6 +21,7 @@
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
+#define MAX_TEARDOWN_ITER 10
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -57,6 +58,7 @@ static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
 static int opt_poll;
+static int opt_teardown;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-- 
2.20.1

