Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 753A9521466
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 13:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241323AbiEJMBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241330AbiEJMAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:00:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A04419AD;
        Tue, 10 May 2022 04:56:53 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id x18so23507113wrc.0;
        Tue, 10 May 2022 04:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gAL6zZTa140Etsk0f3R0C3qsnG9t6c99DknSxRBwIyE=;
        b=AZ/k/VJEUTm/DBQkLH6uVN/OKA1BC+pFJn2WbK0b/3GUqPHrIi0MpFZ5Ghc5lg/K/T
         /8vj+QEowaQWzqXYuiWAV/XIk39IRBED6PP1Q6HNUghH7u3mY+uk0Z/qDsk/HB5Hxzl5
         xbpTAy61Vb/DlkoKvcvPNDoowZIKy4MeoZSKLCOprKOCFT7sNhpLvtJfyUItUjQeC+85
         9cmlLGIy9uoa/jyi4eAU0FCM+uf3zFMK17OipoAFLa59RXHdtfuttRfoSyDRmmt+7nsS
         g2IaaGALf9uHrnuZyBCssNC5L49z3NEMW5PFKxk7uhF91ZA2CZj1xoK5Qr9wzHUqAJlX
         adSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gAL6zZTa140Etsk0f3R0C3qsnG9t6c99DknSxRBwIyE=;
        b=kaHC/41inCBSrcHb7sfLamFG/nSbYurFNY1ViWTD6XInTcKi7nObp1p9gL87ew02UT
         uiicg+vESEfWi7vCaJo9vT0m+dlEIkpEektjYeMxakwEHP+piOmfAHOEU/pxIf3noN2/
         MN2Xv5VIZsR491mSaR1GYoReGAHkq5dHtTbsw96xbf/RC/9yC+trCbanKQ9JI3Y14fI4
         wCOOw8/jlySg3tKFTa7o/dS6AN3EEsrr4BWnyPHaYOAjFy8azTLn4SNRFUr/clKi42nK
         o6TmnQ21CA1fkcyXImcvBdmWnjz4partJ4d1PWebse+y0/sBEEWiyg9N84oCsfDy/GWf
         Yu4Q==
X-Gm-Message-State: AOAM5339sBX9ZrMlxRcMZChhphLokt2YObj5EatNFnnsHpAPae4pzFDG
        jdhGsOoIdsBQ73nKyfK0PYb+DAlYZAmtHllq
X-Google-Smtp-Source: ABdhPJwMCAGMYZ0eBoi3kJzrXNGm6P2P7o/P/4PQYuqTTMVbySWVoRP2yZU5MEiabQyuavpHXeAkcw==
X-Received: by 2002:a5d:678b:0:b0:20a:db0b:7395 with SMTP id v11-20020a5d678b000000b0020adb0b7395mr18770988wru.668.1652183812478;
        Tue, 10 May 2022 04:56:52 -0700 (PDT)
Received: from localhost.localdomain ([188.149.128.194])
        by smtp.gmail.com with ESMTPSA id e25-20020a05600c4b9900b003942a244f51sm2267797wmp.42.2022.05.10.04.56.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 May 2022 04:56:52 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, yhs@fb.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org
Cc:     jonathan.lemon@gmail.com, bpf@vger.kernel.org
Subject: [PATCH bpf-next 3/9] selftests: xsk: run all tests for busy-poll
Date:   Tue, 10 May 2022 13:55:58 +0200
Message-Id: <20220510115604.8717-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220510115604.8717-1-magnus.karlsson@gmail.com>
References: <20220510115604.8717-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Execute all xsk selftests for busy-poll mode too. Currently they were
only run for the standard interrupt driven softirq mode. Replace the
unused option queue-id with the new option busy-poll.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 25 +++++++-
 tools/testing/selftests/bpf/xdpxceiver.c   | 68 ++++++++++++++++++----
 tools/testing/selftests/bpf/xdpxceiver.h   |  9 +++
 tools/testing/selftests/bpf/xsk_prereqs.sh |  6 +-
 4 files changed, 94 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 2bd12c16fbb7..7989a9376f0e 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -109,6 +109,14 @@ setup_vethPairs() {
 	if [[ $verbose -eq 1 ]]; then
 	        echo "setting up ${VETH1}: namespace: ${NS1}"
 	fi
+
+	if [[ $busy_poll -eq 1 ]]; then
+	        echo 2 > /sys/class/net/${VETH0}/napi_defer_hard_irqs
+		echo 200000 > /sys/class/net/${VETH0}/gro_flush_timeout
+		echo 2 > /sys/class/net/${VETH1}/napi_defer_hard_irqs
+		echo 200000 > /sys/class/net/${VETH1}/gro_flush_timeout
+	fi
+
 	ip link set ${VETH1} netns ${NS1}
 	ip netns exec ${NS1} ip link set ${VETH1} mtu ${MTU}
 	ip link set ${VETH0} mtu ${MTU}
@@ -130,11 +138,11 @@ if [ $retval -ne 0 ]; then
 fi
 
 if [[ $verbose -eq 1 ]]; then
-	VERBOSE_ARG="-v"
+	ARGS+="-v "
 fi
 
 if [[ $dump_pkts -eq 1 ]]; then
-	DUMP_PKTS_ARG="-D"
+	ARGS="-D "
 fi
 
 test_status $retval "${TEST_NAME}"
@@ -143,8 +151,19 @@ test_status $retval "${TEST_NAME}"
 
 statusList=()
 
-TEST_NAME="XSK KSELFTESTS"
+TEST_NAME="XSK_SELFTESTS_SOFTIRQ"
+
+execxdpxceiver
+
+retval=$?
+test_status $retval "${TEST_NAME}"
+statusList+=($retval)
 
+cleanup_exit ${VETH0} ${VETH1} ${NS1}
+TEST_NAME="XSK_SELFTESTS_BUSY_POLL"
+busy_poll=1
+
+setup_vethPairs
 execxdpxceiver
 
 retval=$?
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 218f20f135c9..6efac9e35c2e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -90,6 +90,7 @@
 #include <string.h>
 #include <stddef.h>
 #include <sys/mman.h>
+#include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/queue.h>
 #include <time.h>
@@ -122,9 +123,11 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define mode_string(test) (test)->ifobj_tx->xdp_flags & XDP_FLAGS_SKB_MODE ? "SKB" : "DRV"
+#define busy_poll_string(test) (test)->ifobj_tx->busy_poll ? "BUSY-POLL " : ""
 
 #define print_ksft_result(test)						\
-	(ksft_test_result_pass("PASS: %s %s\n", mode_string(test), (test)->name))
+	(ksft_test_result_pass("PASS: %s %s%s\n", mode_string(test), busy_poll_string(test), \
+			       (test)->name))
 
 static void memset32_htonl(void *dest, u32 val, u32 size)
 {
@@ -264,6 +267,26 @@ static int xsk_configure_umem(struct xsk_umem_info *umem, void *buffer, u64 size
 	return 0;
 }
 
+static void enable_busy_poll(struct xsk_socket_info *xsk)
+{
+	int sock_opt;
+
+	sock_opt = 1;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_PREFER_BUSY_POLL,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+
+	sock_opt = 20;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+
+	sock_opt = BATCH_SIZE;
+	if (setsockopt(xsk_socket__fd(xsk->xsk), SOL_SOCKET, SO_BUSY_POLL_BUDGET,
+		       (void *)&sock_opt, sizeof(sock_opt)) < 0)
+		exit_with_error(errno);
+}
+
 static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
 				struct ifobject *ifobject, bool shared)
 {
@@ -287,8 +310,8 @@ static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_inf
 
 static struct option long_options[] = {
 	{"interface", required_argument, 0, 'i'},
-	{"queue", optional_argument, 0, 'q'},
-	{"dump-pkts", optional_argument, 0, 'D'},
+	{"busy-poll", no_argument, 0, 'b'},
+	{"dump-pkts", no_argument, 0, 'D'},
 	{"verbose", no_argument, 0, 'v'},
 	{0, 0, 0, 0}
 };
@@ -299,9 +322,9 @@ static void usage(const char *prog)
 		"  Usage: %s [OPTIONS]\n"
 		"  Options:\n"
 		"  -i, --interface      Use interface\n"
-		"  -q, --queue=n        Use queue n (default 0)\n"
 		"  -D, --dump-pkts      Dump packets L2 - L5\n"
-		"  -v, --verbose        Verbose output\n";
+		"  -v, --verbose        Verbose output\n"
+		"  -b, --busy-poll      Enable busy poll\n";
 
 	ksft_print_msg(str, prog);
 }
@@ -347,7 +370,7 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 	for (;;) {
 		char *sptr, *token;
 
-		c = getopt_long(argc, argv, "i:Dv", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:Dvb", long_options, &option_index);
 		if (c == -1)
 			break;
 
@@ -373,6 +396,10 @@ static void parse_command_line(struct ifobject *ifobj_tx, struct ifobject *ifobj
 		case 'v':
 			opt_verbose = true;
 			break;
+		case 'b':
+			ifobj_tx->busy_poll = true;
+			ifobj_rx->busy_poll = true;
+			break;
 		default:
 			usage(basename(argv[0]));
 			ksft_exit_xfail();
@@ -716,11 +743,24 @@ static void kick_tx(struct xsk_socket_info *xsk)
 	int ret;
 
 	ret = sendto(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, 0);
-	if (ret >= 0 || errno == ENOBUFS || errno == EAGAIN || errno == EBUSY || errno == ENETDOWN)
+	if (ret >= 0)
+		return;
+	if (errno == ENOBUFS || errno == EAGAIN || errno == EBUSY || errno == ENETDOWN) {
+		usleep(100);
 		return;
+	}
 	exit_with_error(errno);
 }
 
+static void kick_rx(struct xsk_socket_info *xsk)
+{
+	int ret;
+
+	ret = recvfrom(xsk_socket__fd(xsk->xsk), NULL, 0, MSG_DONTWAIT, NULL, NULL);
+	if (ret < 0)
+		exit_with_error(errno);
+}
+
 static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 {
 	unsigned int rcvd;
@@ -745,15 +785,18 @@ static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 	}
 }
 
-static void receive_pkts(struct pkt_stream *pkt_stream, struct xsk_socket_info *xsk,
-			 struct pollfd *fds)
+static void receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 {
+	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
 	struct pkt *pkt = pkt_stream_get_next_rx_pkt(pkt_stream);
+	struct xsk_socket_info *xsk = ifobj->xsk;
 	struct xsk_umem_info *umem = xsk->umem;
 	u32 idx_rx = 0, idx_fq = 0, rcvd, i;
 	int ret;
 
 	while (pkt) {
+		kick_rx(xsk);
+
 		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
 		if (!rcvd) {
 			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
@@ -890,6 +933,8 @@ static bool rx_stats_are_valid(struct ifobject *ifobject)
 	socklen_t optlen;
 	int err;
 
+	kick_rx(ifobject->xsk);
+
 	optlen = sizeof(stats);
 	err = getsockopt(fd, SOL_XDP, XDP_STATISTICS, &stats, &optlen);
 	if (err) {
@@ -984,6 +1029,9 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 				exit_with_error(-ret);
 			usleep(USLEEP_MAX);
 		}
+
+		if (ifobject->busy_poll)
+			enable_busy_poll(&ifobject->xsk_arr[i]);
 	}
 
 	ifobject->xsk = &ifobject->xsk_arr[0];
@@ -1083,7 +1131,7 @@ static void *worker_testapp_validate_rx(void *arg)
 		while (!rx_stats_are_valid(ifobject))
 			continue;
 	else
-		receive_pkts(ifobject->pkt_stream, ifobject->xsk, &fds);
+		receive_pkts(ifobject, &fds);
 
 	if (test->total_steps == test->current_step)
 		testapp_cleanup_xsk_res(ifobject);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 37ab549ce5fe..0eea0e1495ba 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -17,6 +17,14 @@
 #define PF_XDP AF_XDP
 #endif
 
+#ifndef SO_BUSY_POLL_BUDGET
+#define SO_BUSY_POLL_BUDGET 70
+#endif
+
+#ifndef SO_PREFER_BUSY_POLL
+#define SO_PREFER_BUSY_POLL 69
+#endif
+
 #define MAX_INTERFACES 2
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
@@ -139,6 +147,7 @@ struct ifobject {
 	bool tx_on;
 	bool rx_on;
 	bool use_poll;
+	bool busy_poll;
 	bool pacing_on;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index 7606d59b06bd..8b77d4c78aba 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -80,5 +80,9 @@ validate_ip_utility()
 
 execxdpxceiver()
 {
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${VERBOSE_ARG} ${DUMP_PKTS_ARG}
+        if [[ $busy_poll -eq 1 ]]; then
+	        ARGS+="-b "
+	fi
+
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${ARGS}
 }
-- 
2.34.1

