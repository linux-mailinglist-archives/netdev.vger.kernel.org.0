Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4AC31DD74
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 17:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234281AbhBQQfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 11:35:06 -0500
Received: from mga03.intel.com ([134.134.136.65]:47626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234275AbhBQQeB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 11:34:01 -0500
IronPort-SDR: QIesddmNwcCbV2C2DZ9twdQ2aviE137UR3m8a/Y1t1DUn8G5B4l0pgFKOkR0LQ74eVFRAktcOn
 M/IrsylWyKVw==
X-IronPort-AV: E=McAfee;i="6000,8403,9897"; a="183315348"
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="183315348"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2021 08:33:06 -0800
IronPort-SDR: mqnJDWU5Ls0zXl3AZQ3x6rwUFiS4O0tK5nZONSBCdONshiAuGgV02lSpFieutSM4RAq9q3K/cE
 /+cHh6D87wKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,184,1610438400"; 
   d="scan'208";a="494184892"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga001.fm.intel.com with ESMTP; 17 Feb 2021 08:33:04 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next 3/4] selftests/bpf: restructure xsk selftests
Date:   Wed, 17 Feb 2021 16:02:13 +0000
Message-Id: <20210217160214.7869-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210217160214.7869-1-ciara.loftus@intel.com>
References: <20210217160214.7869-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this commit individual xsk tests were launched from the
shell script 'test_xsk.sh'. When adding a new test type, two new test
configurations had to be added to this file - one for each of the
supported XDP 'modes' (skb or drv). Should zero copy support be added to
the xsk selftest framework in the future, three new test configurations
would need to be added for each new test type. Each new test type also
typically requires new CLI arguments for the xdpxceiver program.

This commit aims to reduce the overhead of adding new tests, by launching
the test configurations from within the xdpxceiver program itself, using
simple loops. Every test is run every time the C program is executed. Many
of the CLI arguments can be removed as a result.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 112 +-----------
 tools/testing/selftests/bpf/xdpxceiver.c   | 199 ++++++++++++---------
 tools/testing/selftests/bpf/xdpxceiver.h   |  27 ++-
 tools/testing/selftests/bpf/xsk_prereqs.sh |  24 +--
 4 files changed, 139 insertions(+), 223 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index a72f8ed2932d..ae2936e0208f 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -146,117 +146,9 @@ test_status $retval "${TEST_NAME}"
 
 statusList=()
 
-### TEST 1
-TEST_NAME="XSK KSELFTEST FRAMEWORK"
+TEST_NAME="XSK KSELFTESTS"
 
-if [[ $verbose -eq 1 ]]; then
-        echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Generic mode"
-fi
-vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
-
-retval=$?
-if [ $retval -eq 0 ]; then
-        if [[ $verbose -eq 1 ]]; then
-	        echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Native mode"
-	fi
-	vethXDPnative ${VETH0} ${VETH1} ${NS1}
-fi
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 2
-TEST_NAME="SKB NOPOLL"
-
-vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
-
-params=("-S")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 3
-TEST_NAME="SKB POLL"
-
-vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
-
-params=("-S" "-p")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 4
-TEST_NAME="DRV NOPOLL"
-
-vethXDPnative ${VETH0} ${VETH1} ${NS1}
-
-params=("-N")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 5
-TEST_NAME="DRV POLL"
-
-vethXDPnative ${VETH0} ${VETH1} ${NS1}
-
-params=("-N" "-p")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 6
-TEST_NAME="SKB SOCKET TEARDOWN"
-
-vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
-
-params=("-S" "-T")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 7
-TEST_NAME="DRV SOCKET TEARDOWN"
-
-vethXDPnative ${VETH0} ${VETH1} ${NS1}
-
-params=("-N" "-T")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 8
-TEST_NAME="SKB BIDIRECTIONAL SOCKETS"
-
-vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
-
-params=("-S" "-B")
-execxdpxceiver params
-
-retval=$?
-test_status $retval "${TEST_NAME}"
-statusList+=($retval)
-
-### TEST 9
-TEST_NAME="DRV BIDIRECTIONAL SOCKETS"
-
-vethXDPnative ${VETH0} ${VETH1} ${NS1}
-
-params=("-N" "-B")
-execxdpxceiver params
+execxdpxceiver
 
 retval=$?
 test_status $retval "${TEST_NAME}"
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8af746c9a6b6..7cb4a13597d0 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -18,12 +18,7 @@
  * These selftests test AF_XDP SKB and Native/DRV modes using veth
  * Virtual Ethernet interfaces.
  *
- * The following tests are run:
- *
- * 1. AF_XDP SKB mode
- *    Generic mode XDP is driver independent, used when the driver does
- *    not have support for XDP. Works on any netdevice using sockets and
- *    generic XDP path. XDP hook from netif_receive_skb().
+ * For each mode, the following tests are run:
  *    a. nopoll - soft-irq processing
  *    b. poll - using poll() syscall
  *    c. Socket Teardown
@@ -34,17 +29,6 @@
  *       completion rings on each socket, tx/rx in both directions. Only nopoll
  *       mode is used
  *
- * 2. AF_XDP DRV/Native mode
- *    Works on any netdevice with XDP_REDIRECT support, driver dependent. Processes
- *    packets before SKB allocation. Provides better performance than SKB. Driver
- *    hook available just after DMA of buffer descriptor.
- *    a. nopoll
- *    b. poll
- *    c. Socket Teardown
- *    d. Bi-directional sockets
- *    - Only copy mode is supported because veth does not currently support
- *      zero-copy mode
- *
  * Total tests: 8
  *
  * Flow:
@@ -106,9 +90,10 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
-			       "NOPOLL", opt_teardown ? "Socket Teardown" : "",\
-			       opt_bidi ? "Bi-directional Sockets" : ""))
+	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB",\
+			       test_type == TEST_TYPE_POLL ? "POLL" : "NOPOLL",\
+			       test_type == TEST_TYPE_TEARDOWN ? "Socket Teardown" : "",\
+			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -311,10 +296,10 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 	cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
-	cfg.xdp_flags = opt_xdp_flags;
-	cfg.bind_flags = opt_xdp_bind_flags;
+	cfg.xdp_flags = xdp_flags;
+	cfg.bind_flags = xdp_bind_flags;
 
-	if (!opt_bidi) {
+	if (test_type != TEST_TYPE_BIDI) {
 		rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
 		txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
 	} else {
@@ -334,12 +319,6 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 static struct option long_options[] = {
 	{"interface", required_argument, 0, 'i'},
 	{"queue", optional_argument, 0, 'q'},
-	{"poll", no_argument, 0, 'p'},
-	{"xdp-skb", no_argument, 0, 'S'},
-	{"xdp-native", no_argument, 0, 'N'},
-	{"copy", no_argument, 0, 'c'},
-	{"tear-down", no_argument, 0, 'T'},
-	{"bidi", optional_argument, 0, 'B'},
 	{"debug", optional_argument, 0, 'D'},
 	{"verbose", no_argument, 0, 'v'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
@@ -353,12 +332,6 @@ static void usage(const char *prog)
 	    "  Options:\n"
 	    "  -i, --interface      Use interface\n"
 	    "  -q, --queue=n        Use queue n (default 0)\n"
-	    "  -p, --poll           Use poll syscall\n"
-	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
-	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
-	    "  -c, --copy           Force copy mode\n"
-	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
-	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
 	    "  -v, --verbose        Verbose output\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
@@ -448,7 +421,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:v", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:DC:v", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -471,28 +444,6 @@ static void parse_command_line(int argc, char **argv)
 		case 'q':
 			opt_queue = atoi(optarg);
 			break;
-		case 'p':
-			opt_poll = 1;
-			break;
-		case 'S':
-			opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
-			opt_xdp_bind_flags |= XDP_COPY;
-			uut = ORDER_CONTENT_VALIDATE_XDP_SKB;
-			break;
-		case 'N':
-			opt_xdp_flags |= XDP_FLAGS_DRV_MODE;
-			opt_xdp_bind_flags |= XDP_COPY;
-			uut = ORDER_CONTENT_VALIDATE_XDP_DRV;
-			break;
-		case 'c':
-			opt_xdp_bind_flags |= XDP_COPY;
-			break;
-		case 'T':
-			opt_teardown = 1;
-			break;
-		case 'B':
-			opt_bidi = 1;
-			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -659,7 +610,7 @@ static void tx_only_all(struct ifobject *ifobject)
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
 
-		if (opt_poll) {
+		if (test_type == TEST_TYPE_POLL) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret <= 0)
 				continue;
@@ -883,7 +834,7 @@ static void *worker_testapp_validate(void *arg)
 		pthread_mutex_unlock(&sync_mutex);
 
 		while (1) {
-			if (opt_poll) {
+			if (test_type == TEST_TYPE_POLL) {
 				ret = poll(fds, 1, POLL_TMOUT);
 				if (ret <= 0)
 					continue;
@@ -898,11 +849,11 @@ static void *worker_testapp_validate(void *arg)
 		print_verbose("Received %d packets on interface %s\n",
 			       pkt_counter, ifobject->ifname);
 
-		if (opt_teardown)
+		if (test_type == TEST_TYPE_TEARDOWN)
 			print_verbose("Destroying socket\n");
 	}
 
-	if (!opt_bidi || bidi_pass) {
+	if ((test_type != TEST_TYPE_BIDI) || bidi_pass) {
 		xsk_socket__delete(ifobject->xsk->xsk);
 		(void)xsk_umem__delete(ifobject->umem->umem);
 	}
@@ -912,11 +863,12 @@ static void *worker_testapp_validate(void *arg)
 static void testapp_validate(void)
 {
 	struct timespec max_wait = { 0, 0 };
+	bool bidi = test_type == TEST_TYPE_BIDI;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
-	if (opt_bidi && bidi_pass) {
+	if ((test_type == TEST_TYPE_BIDI) && bidi_pass) {
 		pthread_init_mutex();
 		if (!switching_notify) {
 			print_verbose("Switching Tx/Rx vectors\n");
@@ -927,10 +879,10 @@ static void testapp_validate(void)
 	pthread_mutex_lock(&sync_mutex);
 
 	/*Spawn RX thread */
-	if (!opt_bidi || !bidi_pass) {
+	if (!bidi || !bidi_pass) {
 		if (pthread_create(&t0, &attr, worker_testapp_validate, ifdict[1]))
 			exit_with_error(errno);
-	} else if (opt_bidi && bidi_pass) {
+	} else if (bidi && bidi_pass) {
 		/*switch Tx/Rx vectors */
 		ifdict[0]->fv.vector = rx;
 		if (pthread_create(&t0, &attr, worker_testapp_validate, ifdict[0]))
@@ -947,10 +899,10 @@ static void testapp_validate(void)
 	pthread_mutex_unlock(&sync_mutex);
 
 	/*Spawn TX thread */
-	if (!opt_bidi || !bidi_pass) {
+	if (!bidi || !bidi_pass) {
 		if (pthread_create(&t1, &attr, worker_testapp_validate, ifdict[0]))
 			exit_with_error(errno);
-	} else if (opt_bidi && bidi_pass) {
+	} else if (bidi && bidi_pass) {
 		/*switch Tx/Rx vectors */
 		ifdict[1]->fv.vector = tx;
 		if (pthread_create(&t1, &attr, worker_testapp_validate, ifdict[1]))
@@ -969,19 +921,20 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
-	if (!opt_teardown && !opt_bidi)
+	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi)
 		print_ksft_result();
 }
 
 static void testapp_sockets(void)
 {
-	for (int i = 0; i < (opt_teardown ? MAX_TEARDOWN_ITER : MAX_BIDI_ITER); i++) {
+	for (int i = 0; i < ((test_type == TEST_TYPE_TEARDOWN) ? MAX_TEARDOWN_ITER : MAX_BIDI_ITER);
+	     i++) {
 		pkt_counter = 0;
 		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
-		opt_bidi ? bidi_pass++ : bidi_pass;
+		test_type == TEST_TYPE_BIDI ? bidi_pass++ : bidi_pass;
 	}
 
 	print_ksft_result();
@@ -1008,6 +961,94 @@ static void init_iface_config(struct ifaceconfigobj *ifaceconfig)
 	ifdict[1]->src_port = ifaceconfig->dst_port;
 }
 
+static int configure_skb(void)
+{
+
+	char cmd[80];
+
+	snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpdrv off", ifdict[0]->ifname);
+	if (system(cmd)) {
+		ksft_test_result_fail("Failed to configure native mode on iface %s\n",
+						ifdict[0]->ifname);
+		return -1;
+	}
+	snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s xdpdrv off",
+					ifdict[1]->nsname, ifdict[1]->ifname);
+	if (system(cmd)) {
+		ksft_test_result_fail("Failed to configure native mode on iface/ns %s\n",
+						ifdict[1]->ifname, ifdict[1]->nsname);
+		return -1;
+	}
+
+	cur_mode = TEST_MODE_SKB;
+
+	return 0;
+
+}
+
+static int configure_drv(void)
+{
+	char cmd[80];
+
+	snprintf(cmd, sizeof(cmd), "ip link set dev %s xdpgeneric off", ifdict[0]->ifname);
+	if (system(cmd)) {
+		ksft_test_result_fail("Failed to configure native mode on iface %s\n",
+						ifdict[0]->ifname);
+		return -1;
+	}
+	snprintf(cmd, sizeof(cmd), "ip netns exec %s ip link set dev %s xdpgeneric off",
+					ifdict[1]->nsname, ifdict[1]->ifname);
+	if (system(cmd)) {
+		ksft_test_result_fail("Failed to configure native mode on iface/ns %s\n",
+						ifdict[1]->ifname, ifdict[1]->nsname);
+		return -1;
+	}
+
+	cur_mode = TEST_MODE_DRV;
+
+	return 0;
+}
+
+static void run_pkt_test(int mode, int type)
+{
+	test_type = type;
+
+	/* reset defaults after potential previous test */
+	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+	pkt_counter = 0;
+	switching_notify = 0;
+	bidi_pass = 0;
+	prev_pkt = -1;
+	ifdict[0]->fv.vector = tx;
+	ifdict[1]->fv.vector = rx;
+
+	switch (mode) {
+	case (TEST_MODE_SKB):
+		if (cur_mode != TEST_MODE_SKB)
+			configure_skb();
+		xdp_flags |= XDP_FLAGS_SKB_MODE;
+		uut = TEST_MODE_SKB;
+		break;
+	case (TEST_MODE_DRV):
+		if (cur_mode != TEST_MODE_DRV)
+			configure_drv();
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+		uut = TEST_MODE_DRV;
+		break;
+	default:
+		break;
+	}
+
+	pthread_init_mutex();
+
+	if ((test_type != TEST_TYPE_TEARDOWN) && (test_type != TEST_TYPE_BIDI))
+		testapp_validate();
+	else
+		testapp_sockets();
+
+	pthread_destroy_mutex();
+}
+
 int main(int argc, char **argv)
 {
 	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
@@ -1021,6 +1062,7 @@ int main(int argc, char **argv)
 	const char *IP2 = "192.168.100.161";
 	u16 UDP_DST_PORT = 2020;
 	u16 UDP_SRC_PORT = 2121;
+	int i, j;
 
 	ifaceconfig = malloc(sizeof(struct ifaceconfigobj));
 	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
@@ -1046,24 +1088,19 @@ int main(int argc, char **argv)
 
 	init_iface_config(ifaceconfig);
 
-	pthread_init_mutex();
+	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
-	ksft_set_plan(1);
+	configure_skb();
+	cur_mode = TEST_MODE_SKB;
 
-	if (!opt_teardown && !opt_bidi) {
-		testapp_validate();
-	} else if (opt_teardown && opt_bidi) {
-		ksft_test_result_fail("ERROR: parameters -T and -B cannot be used together\n");
-		ksft_exit_xfail();
-	} else {
-		testapp_sockets();
+	for (i = 0; i < TEST_MODE_MAX; i++) {
+		for (j = 0; j < TEST_TYPE_MAX; j++)
+			run_pkt_test(i, j);
 	}
 
 	for (int i = 0; i < MAX_INTERFACES; i++)
 		free(ifdict[i]);
 
-	pthread_destroy_mutex();
-
 	ksft_exit_pass();
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index f66f399dfb2d..1127a396d5d0 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -48,9 +48,18 @@ typedef __u32 u32;
 typedef __u16 u16;
 typedef __u8 u8;
 
-enum TESTS {
-	ORDER_CONTENT_VALIDATE_XDP_SKB = 0,
-	ORDER_CONTENT_VALIDATE_XDP_DRV = 1,
+enum TEST_MODES {
+	TEST_MODE_SKB,
+	TEST_MODE_DRV,
+	TEST_MODE_MAX
+};
+
+enum TEST_TYPES {
+	TEST_TYPE_NOPOLL,
+	TEST_TYPE_POLL,
+	TEST_TYPE_TEARDOWN,
+	TEST_TYPE_BIDI,
+	TEST_TYPE_MAX
 };
 
 static u8 uut;
@@ -58,18 +67,18 @@ static u8 debug_pkt_dump;
 static u32 num_frames;
 static u8 switching_notify;
 static u8 bidi_pass;
+static int cur_mode;
+static int test_type;
 
-static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
 static int opt_pkt_count;
-static int opt_poll;
-static int opt_teardown;
-static int opt_bidi;
-static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
 static u8 opt_verbose;
+
+static u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static u32 xdp_bind_flags = XDP_USE_NEED_WAKEUP | XDP_COPY;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
-static u32 prev_pkt = -1;
+static long prev_pkt = -1;
 static int sigvar;
 
 struct xsk_umem_info {
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index d95018051fcc..2d0fc9b7fe34 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -105,29 +105,7 @@ validate_ip_utility()
 	[ ! $(type -P ip) ] && { echo "'ip' not found. Skipping tests."; test_exit $ksft_skip 1; }
 }
 
-vethXDPgeneric()
-{
-	ip link set dev $1 xdpdrv off
-	ip netns exec $3 ip link set dev $2 xdpdrv off
-}
-
-vethXDPnative()
-{
-	ip link set dev $1 xdpgeneric off
-	ip netns exec $3 ip link set dev $2 xdpgeneric off
-}
-
 execxdpxceiver()
 {
-	local -a 'paramkeys=("${!'"$1"'[@]}")' copy
-	paramkeysstr=${paramkeys[*]}
-
-	for index in $paramkeysstr;
-		do
-			current=$1"[$index]"
-			copy[$index]=${!current}
-		done
-
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG} \
-		${DEBUG_ARG}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} -C ${NUMPKTS} ${VERBOSE_ARG} ${DEBUG_ARG}
 }
-- 
2.17.1

