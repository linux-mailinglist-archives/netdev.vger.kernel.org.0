Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18BD322945
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 12:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbhBWLI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 06:08:27 -0500
Received: from mga17.intel.com ([192.55.52.151]:13140 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232307AbhBWLIR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 06:08:17 -0500
IronPort-SDR: kC3x/KaOQrJRY/2HW4yEw8XwrcF4LmNmQ1awIJgX3LWu0mSAcS+ci2zJhJIW63+oI3VP1B8I5z
 g/iqiXNRZjpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="164613754"
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="164613754"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 03:07:34 -0800
IronPort-SDR: kGl5xhsGSWd6+/iCmmHgbZj+xqhyrdeHQXG0QfQ7dpfilllSmnC0v/Abq6O8BBCsZEEkbjPIwg
 87+eDWhG6+Uw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,199,1610438400"; 
   d="scan'208";a="441703909"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 03:07:03 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v2 3/4] selftests/bpf: restructure xsk selftests
Date:   Tue, 23 Feb 2021 10:35:06 +0000
Message-Id: <20210223103507.10465-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223103507.10465-1-ciara.loftus@intel.com>
References: <20210223103507.10465-1-ciara.loftus@intel.com>
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
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 112 +----------
 tools/testing/selftests/bpf/xdpxceiver.c   | 218 +++++++++++++--------
 tools/testing/selftests/bpf/xdpxceiver.h   |  33 ++--
 tools/testing/selftests/bpf/xsk_prereqs.sh |  24 +--
 4 files changed, 159 insertions(+), 228 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 870ae3f38818..cb8a9e5c34ff 100755
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
index 506423201197..e7913444518d 100644
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
@@ -98,17 +82,23 @@ typedef __u16 __sum16;
 
 static void __exit_with_error(int error, const char *file, const char *func, int line)
 {
-	ksft_test_result_fail
-	    ("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error, strerror(error));
-	ksft_exit_xfail();
+	if (configured_mode == TEST_MODE_UNCONFIGURED) {
+		ksft_exit_fail_msg
+		("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error, strerror(error));
+	} else {
+		ksft_test_result_fail
+		("[%s:%s:%i]: ERROR: %d/\"%s\"\n", file, func, line, error, strerror(error));
+		ksft_exit_xfail();
+	}
 }
 
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s%s\n", uut ? "DRV" : "SKB", opt_poll ? "POLL" :\
-			       "NOPOLL", opt_teardown ? "Socket Teardown" : "",\
-			       opt_bidi ? "Bi-directional Sockets" : ""))
+	(ksft_test_result_pass("PASS: %s %s %s%s\n", configured_mode ? "DRV" : "SKB",\
+			       test_type == TEST_TYPE_POLL ? "POLL" : "NOPOLL",\
+			       test_type == TEST_TYPE_TEARDOWN ? "Socket Teardown" : "",\
+			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : ""))
 
 static void pthread_init_mutex(void)
 {
@@ -311,10 +301,10 @@ static int xsk_configure_socket(struct ifobject *ifobject)
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
@@ -334,12 +324,6 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 static struct option long_options[] = {
 	{"interface", required_argument, 0, 'i'},
 	{"queue", optional_argument, 0, 'q'},
-	{"poll", no_argument, 0, 'p'},
-	{"xdp-skb", no_argument, 0, 'S'},
-	{"xdp-native", no_argument, 0, 'N'},
-	{"copy", no_argument, 0, 'c'},
-	{"tear-down", no_argument, 0, 'T'},
-	{"bidi", optional_argument, 0, 'B'},
 	{"dump-pkts", optional_argument, 0, 'D'},
 	{"verbose", no_argument, 0, 'v'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
@@ -353,12 +337,6 @@ static void usage(const char *prog)
 	    "  Options:\n"
 	    "  -i, --interface      Use interface\n"
 	    "  -q, --queue=n        Use queue n (default 0)\n"
-	    "  -p, --poll           Use poll syscall\n"
-	    "  -S, --xdp-skb=n      Use XDP SKB mode\n"
-	    "  -N, --xdp-native=n   Enforce XDP DRV (native) mode\n"
-	    "  -c, --copy           Force copy mode\n"
-	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
-	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --dump-pkts      Dump packets L2 - L5\n"
 	    "  -v, --verbose        Verbose output\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
@@ -448,7 +426,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:v", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:DC:v", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -471,28 +449,6 @@ static void parse_command_line(int argc, char **argv)
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
@@ -508,6 +464,11 @@ static void parse_command_line(int argc, char **argv)
 		}
 	}
 
+	if (!opt_pkt_count) {
+		print_verbose("No tx-pkt-count specified, using default %u\n", DEFAULT_PKT_CNT);
+		opt_pkt_count = DEFAULT_PKT_CNT;
+	}
+
 	if (!validate_interfaces()) {
 		usage(basename(argv[0]));
 		ksft_exit_xfail();
@@ -659,7 +620,7 @@ static void tx_only_all(struct ifobject *ifobject)
 	while ((opt_pkt_count && pkt_cnt < opt_pkt_count) || !opt_pkt_count) {
 		int batch_size = get_batch_size(pkt_cnt);
 
-		if (opt_poll) {
+		if (test_type == TEST_TYPE_POLL) {
 			ret = poll(fds, 1, POLL_TMOUT);
 			if (ret <= 0)
 				continue;
@@ -883,7 +844,7 @@ static void *worker_testapp_validate(void *arg)
 		pthread_mutex_unlock(&sync_mutex);
 
 		while (1) {
-			if (opt_poll) {
+			if (test_type == TEST_TYPE_POLL) {
 				ret = poll(fds, 1, POLL_TMOUT);
 				if (ret <= 0)
 					continue;
@@ -898,11 +859,11 @@ static void *worker_testapp_validate(void *arg)
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
@@ -912,11 +873,12 @@ static void *worker_testapp_validate(void *arg)
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
@@ -927,10 +889,10 @@ static void testapp_validate(void)
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
@@ -947,10 +909,10 @@ static void testapp_validate(void)
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
@@ -969,19 +931,20 @@ static void testapp_validate(void)
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
@@ -1008,6 +971,98 @@ static void init_iface_config(struct ifaceconfigobj *ifaceconfig)
 	ifdict[1]->src_port = ifaceconfig->dst_port;
 }
 
+static void *nsdisablemodethread(void *args)
+{
+	struct targs *targs = args;
+
+	targs->retptr = false;
+
+	if (switch_namespace(targs->idx)) {
+		targs->retptr = bpf_set_link_xdp_fd(ifdict[targs->idx]->ifindex, -1, targs->flags);
+	} else {
+		targs->retptr = errno;
+		print_verbose("Failed to switch namespace to %s\n", ifdict[targs->idx]->nsname);
+	}
+
+	pthread_exit(NULL);
+}
+
+static void disable_xdp_mode(int mode)
+{
+	int err = 0;
+	__u32 flags = XDP_FLAGS_UPDATE_IF_NOEXIST | mode;
+	char *mode_str = mode & XDP_FLAGS_SKB_MODE ? "skb" : "drv";
+
+	for (int i = 0; i < MAX_INTERFACES; i++) {
+		if (strcmp(ifdict[i]->nsname, "")) {
+			struct targs *targs;
+
+			targs = malloc(sizeof(*targs));
+			memset(targs, 0, sizeof(*targs));
+			if (!targs)
+				exit_with_error(errno);
+
+			targs->idx = i;
+			targs->flags = flags;
+			if (pthread_create(&ns_thread, NULL, nsdisablemodethread, targs))
+				exit_with_error(errno);
+
+			pthread_join(ns_thread, NULL);
+			err = targs->retptr;
+			free(targs);
+		} else {
+			err = bpf_set_link_xdp_fd(ifdict[i]->ifindex, -1, flags);
+		}
+
+		if (err) {
+			print_verbose("Failed to disable %s mode on interface %s\n",
+						mode_str, ifdict[i]->ifname);
+			exit_with_error(err);
+		}
+
+		print_verbose("Disabled %s mode for interface: %s\n", mode_str, ifdict[i]->ifname);
+		configured_mode = mode & XDP_FLAGS_SKB_MODE ? TEST_MODE_DRV : TEST_MODE_SKB;
+	}
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
+		if (configured_mode == TEST_MODE_DRV)
+			disable_xdp_mode(XDP_FLAGS_DRV_MODE);
+		xdp_flags |= XDP_FLAGS_SKB_MODE;
+		break;
+	case (TEST_MODE_DRV):
+		if (configured_mode == TEST_MODE_SKB)
+			disable_xdp_mode(XDP_FLAGS_SKB_MODE);
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
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
@@ -1021,6 +1076,7 @@ int main(int argc, char **argv)
 	const char *IP2 = "192.168.100.161";
 	u16 UDP_DST_PORT = 2020;
 	u16 UDP_SRC_PORT = 2121;
+	int i, j;
 
 	ifaceconfig = malloc(sizeof(struct ifaceconfigobj));
 	memcpy(ifaceconfig->dst_mac, MAC1, ETH_ALEN);
@@ -1046,24 +1102,18 @@ int main(int argc, char **argv)
 
 	init_iface_config(ifaceconfig);
 
-	pthread_init_mutex();
+	disable_xdp_mode(XDP_FLAGS_DRV_MODE);
 
-	ksft_set_plan(1);
+	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
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
index f66f399dfb2d..e05703f661f8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -41,6 +41,7 @@
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
 #define NEED_WAKEUP true
+#define DEFAULT_PKT_CNT 10000
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 
@@ -48,28 +49,37 @@ typedef __u32 u32;
 typedef __u16 u16;
 typedef __u8 u8;
 
-enum TESTS {
-	ORDER_CONTENT_VALIDATE_XDP_SKB = 0,
-	ORDER_CONTENT_VALIDATE_XDP_DRV = 1,
+enum TEST_MODES {
+	TEST_MODE_UNCONFIGURED = -1,
+	TEST_MODE_SKB,
+	TEST_MODE_DRV,
+	TEST_MODE_MAX
 };
 
-static u8 uut;
+enum TEST_TYPES {
+	TEST_TYPE_NOPOLL,
+	TEST_TYPE_POLL,
+	TEST_TYPE_TEARDOWN,
+	TEST_TYPE_BIDI,
+	TEST_TYPE_MAX
+};
+
+static int configured_mode = TEST_MODE_UNCONFIGURED;
 static u8 debug_pkt_dump;
 static u32 num_frames;
 static u8 switching_notify;
 static u8 bidi_pass;
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
@@ -140,8 +150,9 @@ pthread_t t0, t1, ns_thread;
 pthread_attr_t attr;
 
 struct targs {
-	bool retptr;
+	u8 retptr;
 	int idx;
+	u32 flags;
 };
 
 TAILQ_HEAD(head_s, pkt) head = TAILQ_HEAD_INITIALIZER(head);
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index da93575d757a..dac1c5f78752 100755
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
-		${DUMP_PKTS_ARG}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} -C ${NUMPKTS} ${VERBOSE_ARG} ${DUMP_PKTS_ARG}
 }
-- 
2.17.1

