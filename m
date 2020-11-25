Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D73FE2C47CA
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733138AbgKYSi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgKYSi3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:38:29 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D406C0613D4;
        Wed, 25 Nov 2020 10:38:28 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id s13so3063933wmh.4;
        Wed, 25 Nov 2020 10:38:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aatPO7YDsL7B5Uxzmh/eplfBMl4ij9VUGkMtmDCawWw=;
        b=nI+7xeypL5nJ7AgBwVskvDD4TcxHLJis/9m7tym+n39WNuUqWUrHb5wfEAbmn88y4x
         yvIn0k4XHJxsB2AtbH+C8QmdnhMAPUzPC7KLbRKgbAY7rdTSw/x+5JEOjNnuLubSjult
         hNK4RvlElxgvizvieDtHAuI/9jI9DMJ19y+KIH2EEmbffatrJ3qNk79XpXuSGoCMaaxp
         tIOwdsbgDkMBbAQTZwdIrZsFiBzX7Sdp5t1+pU3Ob5dvFxssCBmG4SamvwTNo0/1SNPf
         pVGCvf6tWXPoUZrP85rU2bO5QZrDmg966Gzy7PeUZrl6zCJLMqKP9wYYmarhcjJ1nvjh
         I9HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aatPO7YDsL7B5Uxzmh/eplfBMl4ij9VUGkMtmDCawWw=;
        b=uS/o5m/frhPjWvlgXZK3diX0j4dKRrbj2MZcN4IIvsMtPb8LejvwLmHztSE9NhnSou
         mSCn1QYNFwpWmSzknItzxcbYyScSFkht1UM88pVNLneQGkiyIn4mL4/K6/Y6ERRCvgeQ
         KuhhpIVekmliLHM+V8hDPmGXwsSzwXsvRuTu6jhxi813/F1pHaaiYouDN4fqNuOSI9ES
         T+gmv+qQxSRKaP3VCuf32mJ/l+0H1I1H6mtYY0/xT+Gd2sbId/bWMghBvdCJnWVgcgIC
         Zo4U2bpIFGol2rgazk6zvCSz4XU7RN4ft/s3KAHFnK16CJCJVqeld0GHPA+R0tWGl1U7
         A0sA==
X-Gm-Message-State: AOAM53189FvJPo/ASSbWNaDzn5xTvkQrItE5dF5kO+KGg5J8qyMD2Yp6
        +oZp591Wx0YsKYkqo1E1DyG2NB613zjoD+Nq
X-Google-Smtp-Source: ABdhPJy90CUdL8OmTdpLH+dIyH742FSzU9LTJyFi6WYjNb+vLXd6PAco6GosW0Dni0bNfdPFn3OUOw==
X-Received: by 2002:a1c:e289:: with SMTP id z131mr5379267wmg.80.1606329506478;
        Wed, 25 Nov 2020 10:38:26 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id h2sm5830035wrv.76.2020.11.25.10.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:38:25 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 4/5] selftests/bpf: xsk selftests - Socket Teardown - SKB, DRV
Date:   Wed, 25 Nov 2020 18:37:48 +0000
Message-Id: <20201125183749.13797-5-weqaar.a.janjua@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
References: <20201125183749.13797-1-weqaar.a.janjua@intel.com>
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
index 375f9590db90..76de8080092d 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -176,6 +176,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 5
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
+### TEST 6
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
index 3027247bbb4e..62560e058111 100644
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
@@ -96,7 +100,8 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" : "NOPOLL"))
+	(ksft_test_result_pass("PASS: %s %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
+			       "NOPOLL", opt_teardown ? "Socket Teardown" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -321,6 +326,7 @@ static struct option long_options[] = {
 	{"xdp-skb", no_argument, 0, 'S'},
 	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
+	{"tear-down", no_argument, 0, 'T'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -337,6 +343,7 @@ static void usage(const char *prog)
 	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
 	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
+	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
@@ -427,7 +434,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -465,6 +472,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'c':
 			opt_xdp_bind_flags |= XDP_COPY;
 			break;
+		case 'T':
+			opt_teardown = 1;
+			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -853,6 +863,9 @@ static void *worker_testapp_validate(void *arg)
 
 		ksft_print_msg("Received %d packets on interface %s\n",
 			       pkt_counter, ((struct ifobject *)arg)->ifname);
+
+		if (opt_teardown)
+			ksft_print_msg("Destroying socket\n");
 	}
 
 	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
@@ -898,6 +911,20 @@ static void testapp_validate(void)
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
 
@@ -964,7 +991,7 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
-	testapp_validate();
+	opt_teardown ? testapp_sockets() : testapp_validate();
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index dba47e818466..9d2670f28d86 100644
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
@@ -55,6 +56,7 @@ static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
 static int opt_poll;
+static int opt_teardown;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-- 
2.20.1

