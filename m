Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1A2C47D1
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733151AbgKYSiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729679AbgKYSip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:38:45 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F87C0613D4;
        Wed, 25 Nov 2020 10:38:29 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id t4so2873994wrr.12;
        Wed, 25 Nov 2020 10:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FjBZ7KV9yrVslvsdIenrNACdy98tncy6XNFocJcBUtA=;
        b=Vxta5m9iBYfOdzxNyeHg0Md6WU2APXkvmzIbKkXK1x8boOL8hOk77v1rf29KKkdH+R
         JKrAiVxbRxF3ZCfnM7pwHCp/qDUfvncuje1QArR5bvyOraY5EXkBwBu4OMXPkeIuMlZv
         VBhH3vGeNGx/adzc7ZO7pcQLMoWoDXMPQHrfMO8y0+JsyeFBhAdGXwVxKL31p5mXsmkR
         OT7zb0JcKOcR3CNT1a9jCg/aWdBY6dFoRaeOHMQeNmrxl0mXAgdIKLV6b9DFLG3O+S/r
         NTjDzF8pyUsXAOmfKg5p9nsn9kKKV2oAQFPjx8uz+ZcF1/X3A7rrHuDHozKqh9h0cOuv
         KjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FjBZ7KV9yrVslvsdIenrNACdy98tncy6XNFocJcBUtA=;
        b=Iil1euwqxj1YF2cdJmPh5/oNw/y4zcx+X2x0JlzSxkbjPExMRt6O6nhjaK1+HWfUPm
         dGM3bQRfmV1fz+Fmm/SB4Tb7LEpo51onPE2oCFd4W4bU878xXd72WOMfGNBzM9AYIqcL
         tsKA0jh70gFb9L8WlX3QWz/tm59kQz9Ebi2Gv0L9nkgSsMsiQQDIkS032cX8iTeHo02A
         kHDU0H3MEPm+MKYem+yrLtD7QYfcyP1kZZtlwV4U4ggYwX+HC3meOQSfc9UTvZNsiblm
         XxCP1hk6pxR07ok5H5hwHrU31QyHZh9DPMF9K4wTLYC66LsKz6qUxq6nNJzvTiuZVHMN
         jihw==
X-Gm-Message-State: AOAM533q8z2gr06vZDnIb+emPeQFqJRSJRZPYKYrMvwN5B0iEP35SE5d
        kIlX6N0Bs83k4FLMsGkzLlUHrrlFItdPfrc5
X-Google-Smtp-Source: ABdhPJxfARxxmidJAwKOay40Jp0cpUmws80qBbGh1uASNoNAj6ytugZ9+/FDwrzDlHIXCElaVBPdNw==
X-Received: by 2002:adf:a3d1:: with SMTP id m17mr5475126wrb.289.1606329507684;
        Wed, 25 Nov 2020 10:38:27 -0800 (PST)
Received: from kernel-dev.chello.ie ([80.111.136.190])
        by smtp.gmail.com with ESMTPSA id h2sm5830035wrv.76.2020.11.25.10.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2020 10:38:27 -0800 (PST)
From:   Weqaar Janjua <weqaar.janjua@gmail.com>
X-Google-Original-From: Weqaar Janjua <weqaar.a.janjua@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, yhs@fb.com, magnus.karlsson@gmail.com,
        bjorn.topel@intel.com
Cc:     Weqaar Janjua <weqaar.a.janjua@intel.com>, shuah@kernel.org,
        skhan@linuxfoundation.org, linux-kselftest@vger.kernel.org,
        anders.roxell@linaro.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next v3 5/5] selftests/bpf: xsk selftests - Bi-directional Sockets - SKB, DRV
Date:   Wed, 25 Nov 2020 18:37:49 +0000
Message-Id: <20201125183749.13797-6-weqaar.a.janjua@intel.com>
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
   d. Bi-directional Sockets
      Configure sockets as bi-directional tx/rx sockets, sets up fill
      and completion rings on each socket, tx/rx in both directions.
      Only nopoll mode is used

2. AF_XDP DRV/Native mode
   d. Bi-directional Sockets
   * Only copy mode is supported because veth does not currently support
     zero-copy mode

Signed-off-by: Weqaar Janjua <weqaar.a.janjua@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  |  24 ++++++
 tools/testing/selftests/bpf/xdpxceiver.c | 100 +++++++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h |   4 +
 3 files changed, 104 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 76de8080092d..05df57806d95 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -200,6 +200,30 @@ retval=$?
 test_status $retval "${TEST_NAME}"
 statusList+=($retval)
 
+### TEST 7
+TEST_NAME="SKB BIDIRECTIONAL SOCKETS"
+
+vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
+
+params=("-S" "-B")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
+### TEST 8
+TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
+
+vethXDPnative ${VETH0} ${VETH1} ${NS1}
+
+params=("-N" "-B")
+execxdpxceiver params
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
+
 ## END TESTS
 
 cleanup_exit ${VETH0} ${VETH1} ${NS1}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 62560e058111..5a508a94d8f9 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -29,6 +29,10 @@
  *    c. Socket Teardown
  *       Create a Tx and a Rx socket, Tx from one socket, Rx on another. Destroy
  *       both sockets, then repeat multiple times. Only nopoll mode is used
+ *    d. Bi-directional sockets
+ *       Configure sockets as bi-directional tx/rx sockets, sets up fill and
+ *       completion rings on each socket, tx/rx in both directions. Only nopoll
+ *       mode is used
  *
  * 2. AF_XDP DRV/Native mode
  *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
@@ -37,10 +41,11 @@
  *    a. nopoll
  *    b. poll
  *    c. Socket Teardown
+ *    d. Bi-directional sockets
  *    - Only copy mode is supported because veth does not currently support
  *      zero-copy mode
  *
- * Total tests: 6
+ * Total tests: 8
  *
  * Flow:
  * -----
@@ -100,8 +105,9 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
-			       "NOPOLL", opt_teardown ? "Socket Teardown" : ""))
+	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
+			       "NOPOLL", opt_teardown ? "Socket Teardown" : "",\
+			       opt_bidi ? "Bi-directional Sockets" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -307,8 +313,13 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 	cfg.xdp_flags = opt_xdp_flags;
 	cfg.bind_flags = opt_xdp_bind_flags;
 
-	rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
-	txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
+	if (!opt_bidi) {
+		rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
+		txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
+	} else {
+		rxr = &ifobject->xsk->rx;
+		txr = &ifobject->xsk->tx;
+	}
 
 	ret = xsk_socket__create(&ifobject->xsk->xsk, ifobject->ifname,
 				 opt_queue, ifobject->umem->umem, rxr, txr, &cfg);
@@ -327,6 +338,7 @@ static struct option long_options[] = {
 	{"xdp-native", no_argument, 0, 'N'},
 	{"copy", no_argument, 0, 'c'},
 	{"tear-down", no_argument, 0, 'T'},
+	{"bidi", optional_argument, 0, 'B'},
 	{"debug", optional_argument, 0, 'D'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
@@ -344,6 +356,7 @@ static void usage(const char *prog)
 	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
 	    "  -c, --copy           Force copy mode\n"
 	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
+	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
@@ -434,7 +447,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -475,6 +488,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'T':
 			opt_teardown = 1;
 			break;
+		case 'B':
+			opt_bidi = 1;
+			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -784,22 +800,25 @@ static void *worker_testapp_validate(void *arg)
 	struct generic_data *data = (struct generic_data *)malloc(sizeof(struct generic_data));
 	struct iphdr *ip_hdr = (struct iphdr *)(pkt_data + sizeof(struct ethhdr));
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
-	void *bufs;
+	void *bufs = NULL;
 
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
-	bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
-		    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-	if (bufs == MAP_FAILED)
-		exit_with_error(errno);
+	if (!bidi_pass) {
+		bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
+			    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (bufs == MAP_FAILED)
+			exit_with_error(errno);
 
-	if (strcmp(((struct ifobject *)arg)->nsname, ""))
-		switch_namespace(((struct ifobject *)arg)->ifdict_index);
+		if (strcmp(((struct ifobject *)arg)->nsname, ""))
+			switch_namespace(((struct ifobject *)arg)->ifdict_index);
+	}
 
 	if (((struct ifobject *)arg)->fv.vector == tx) {
 		int spinningrxctr = 0;
 
-		thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_tx);
+		if (!bidi_pass)
+			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_tx);
 
 		while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
 			spinningrxctr++;
@@ -829,7 +848,8 @@ static void *worker_testapp_validate(void *arg)
 		struct pollfd fds[MAX_SOCKS] = { };
 		int ret;
 
-		thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
+		if (!bidi_pass)
+			thread_common_ops(arg, bufs, &sync_mutex_tx, &spinning_rx);
 
 		ksft_print_msg("Interface [%s] vector [Rx]\n", ((struct ifobject *)arg)->ifname);
 		xsk_populate_fill_ring(((struct ifobject *)arg)->umem);
@@ -868,8 +888,10 @@ static void *worker_testapp_validate(void *arg)
 			ksft_print_msg("Destroying socket\n");
 	}
 
-	xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
-	(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
+	if (!opt_bidi || (opt_bidi && bidi_pass)) {
+		xsk_socket__delete(((struct ifobject *)arg)->xsk->xsk);
+		(void)xsk_umem__delete(((struct ifobject *)arg)->umem->umem);
+	}
 	pthread_exit(NULL);
 }
 
@@ -878,11 +900,26 @@ static void testapp_validate(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
+	if (opt_bidi && bidi_pass) {
+		pthread_init_mutex();
+		if (!switching_notify) {
+			ksft_print_msg("Switching Tx/Rx vectors\n");
+			switching_notify++;
+		}
+	}
+
 	pthread_mutex_lock(&sync_mutex);
 
 	/*Spawn RX thread */
-	if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
-		exit_with_error(errno);
+	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
+		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[1]))
+			exit_with_error(errno);
+	} else if (opt_bidi && bidi_pass) {
+		/*switch Tx/Rx vectors */
+		ifdict[0]->fv.vector = rx;
+		if (pthread_create(&t0, &attr, worker_testapp_validate, (void *)ifdict[0]))
+			exit_with_error(errno);
+	}
 
 	struct timespec max_wait = { 0, 0 };
 
@@ -896,8 +933,15 @@ static void testapp_validate(void)
 	pthread_mutex_unlock(&sync_mutex);
 
 	/*Spawn TX thread */
-	if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
-		exit_with_error(errno);
+	if (!opt_bidi || (opt_bidi && !bidi_pass)) {
+		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[0]))
+			exit_with_error(errno);
+	} else if (opt_bidi && bidi_pass) {
+		/*switch Tx/Rx vectors */
+		ifdict[1]->fv.vector = tx;
+		if (pthread_create(&t1, &attr, worker_testapp_validate, (void *)ifdict[1]))
+			exit_with_error(errno);
+	}
 
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
@@ -911,18 +955,19 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
-	if (!opt_teardown)
+	if (!opt_teardown && !opt_bidi)
 		print_ksft_result();
 }
 
 static void testapp_sockets(void)
 {
-	for (int i = 0; i < MAX_TEARDOWN_ITER; i++) {
+	for (int i = 0; i < (opt_teardown ? MAX_TEARDOWN_ITER : MAX_BIDI_ITER); i++) {
 		pkt_counter = 0;
 		prev_pkt = -1;
 		sigvar = 0;
 		ksft_print_msg("Creating socket\n");
 		testapp_validate();
+		opt_bidi ? bidi_pass++ : bidi_pass;
 	}
 
 	print_ksft_result();
@@ -991,7 +1036,14 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(1);
 
-	opt_teardown ? testapp_sockets() : testapp_validate();
+	if (!opt_teardown && !opt_bidi) {
+		testapp_validate();
+	} else if (opt_teardown && opt_bidi) {
+		ksft_test_result_fail("ERROR: parameters -T and -B cannot be used together\n");
+		ksft_exit_xfail();
+	} else {
+		testapp_sockets();
+	}
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 9d2670f28d86..d6630a19140b 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -22,6 +22,7 @@
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
 #define MAX_SOCKS 1
 #define MAX_TEARDOWN_ITER 10
+#define MAX_BIDI_ITER 2
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -51,12 +52,15 @@ enum TESTS {
 u8 uut;
 u8 debug_pkt_dump;
 u32 num_frames;
+u8 switching_notify;
+u8 bidi_pass;
 
 static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
 static int opt_poll;
 static int opt_teardown;
+static int opt_bidi;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-- 
2.20.1

