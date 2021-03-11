Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B150337846
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbhCKPmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:42:05 -0500
Received: from mga14.intel.com ([192.55.52.115]:42370 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234357AbhCKPlq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:46 -0500
IronPort-SDR: m6xtWD6+XUgEO6sfvDkDPgcE2UfuMEEjHl7EaKhdonFtQrDmSPTzWWfpu4vaMjy0zAG+fV2pJm
 kBJ94wDLPGIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188050746"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188050746"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:46 -0800
IronPort-SDR: XaKd8D0lItQ3GVGyXZeHNsChibJA0DCANLMW/vx4x1tj6HsNoh7ghuU20JQ1/F1P58cRRG0eQ2
 GH4epm9cKpMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253639"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:41:43 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 14/17] selftests: xsk: implement bpf_link test
Date:   Thu, 11 Mar 2021 16:29:07 +0100
Message-Id: <20210311152910.56760-15-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a test that is supposed to verify the persistence of BPF
resources based on underlying bpf_link usage.

Test will:
1) create and bind two sockets on queue ids 0 and 1
2) run a traffic on queue ids 0
3) remove xsk sockets from queue 0 on both veth interfaces
4) run a traffic on queues ids 1

Running traffic successfully on qids 1 means that BPF resources were
not removed on step 3).

In order to make it work, change the command that creates veth pair to
have the 4 queue pairs by default.

Introduce the arrays of xsks and umems to ifobject struct but keep a
pointers to single entities, so rest of the logic around Rx/Tx can be
kept as-is.

For umem handling, double the size of mmapped space and split that
between the two sockets.

Rename also bidi_pass to a variable 'second_step' of a boolean type as
it's now used also for the test that is introduced here and it doesn't
have anything in common with bi-directional testing.

Drop opt_queue command line argument as it wasn't working before anyway.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  |   2 +-
 tools/testing/selftests/bpf/xdpxceiver.c | 179 +++++++++++++++++------
 tools/testing/selftests/bpf/xdpxceiver.h |   7 +-
 3 files changed, 138 insertions(+), 50 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 56d4474e2c83..2a00b8222475 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -107,7 +107,7 @@ setup_vethPairs() {
 	        echo "setting up ${VETH0}: namespace: ${NS0}"
 	fi
 	ip netns add ${NS1}
-	ip link add ${VETH0} type veth peer name ${VETH1}
+	ip link add ${VETH0} numtxqueues 4 numrxqueues 4 type veth peer name ${VETH1} numtxqueues 4 numrxqueues 4
 	if [ -f /proc/net/if_inet6 ]; then
 		echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
 	fi
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index aef5840e1c24..dc775ee139c5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -41,8 +41,12 @@
  *            Reduce the size of the RX ring to a fraction of the fill ring size.
  *       iv.  fill queue empty
  *            Do not populate the fill queue and then try to receive pkts.
+ *    f. bpf_link resource persitence
+ *       Configure sockets at indexes 0 and 1,run a traffic on queue ids 0,
+ *       then remove xsk sockets from queue 0 on both veth interfaces and
+ *       finally run a traffic on queues ids 1
  *
- * Total tests: 10
+ * Total tests: 12
  *
  * Flow:
  * -----
@@ -115,11 +119,12 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 #define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
 
 #define print_ksft_result(void)\
-	(ksft_test_result_pass("PASS: %s %s %s%s%s\n", configured_mode ? "DRV" : "SKB",\
+	(ksft_test_result_pass("PASS: %s %s %s%s%s%s\n", configured_mode ? "DRV" : "SKB",\
 			       test_type == TEST_TYPE_POLL ? "POLL" : "NOPOLL",\
 			       test_type == TEST_TYPE_TEARDOWN ? "Socket Teardown" : "",\
 			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : "",\
-			       test_type == TEST_TYPE_STATS ? "Stats" : ""))
+			       test_type == TEST_TYPE_STATS ? "Stats" : "",\
+			       test_type == TEST_TYPE_BPF_RES ? "BPF RES" : ""))
 
 static void init_sync_resources(void)
 {
@@ -258,9 +263,8 @@ static void gen_eth_frame(struct xsk_umem_info *umem, u64 addr)
 	memcpy(xsk_umem__get_data(umem->buffer, addr), pkt_data, PKT_SIZE);
 }
 
-static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
+static void xsk_configure_umem(struct ifobject *data, void *buffer, int idx)
 {
-	int ret;
 	struct xsk_umem_config cfg = {
 		.fill_size = XSK_RING_PROD__DEFAULT_NUM_DESCS,
 		.comp_size = XSK_RING_CONS__DEFAULT_NUM_DESCS,
@@ -268,17 +272,22 @@ static void xsk_configure_umem(struct ifobject *data, void *buffer, u64 size)
 		.frame_headroom = frame_headroom,
 		.flags = XSK_UMEM__DEFAULT_FLAGS
 	};
+	int size = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
+	struct xsk_umem_info *umem;
+	int ret;
 
-	data->umem = calloc(1, sizeof(struct xsk_umem_info));
-	if (!data->umem)
+	umem = calloc(1, sizeof(struct xsk_umem_info));
+	if (!umem)
 		exit_with_error(errno);
 
-	ret = xsk_umem__create(&data->umem->umem, buffer, size,
-			       &data->umem->fq, &data->umem->cq, &cfg);
+	ret = xsk_umem__create(&umem->umem, buffer, size,
+			       &umem->fq, &umem->cq, &cfg);
 	if (ret)
 		exit_with_error(ret);
 
-	data->umem->buffer = buffer;
+	umem->buffer = buffer;
+
+	data->umem_arr[idx] = umem;
 }
 
 static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
@@ -294,18 +303,19 @@ static void xsk_populate_fill_ring(struct xsk_umem_info *umem)
 	xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
 }
 
-static int xsk_configure_socket(struct ifobject *ifobject)
+static int xsk_configure_socket(struct ifobject *ifobject, int idx)
 {
 	struct xsk_socket_config cfg;
+	struct xsk_socket_info *xsk;
 	struct xsk_ring_cons *rxr;
 	struct xsk_ring_prod *txr;
 	int ret;
 
-	ifobject->xsk = calloc(1, sizeof(struct xsk_socket_info));
-	if (!ifobject->xsk)
+	xsk = calloc(1, sizeof(struct xsk_socket_info));
+	if (!xsk)
 		exit_with_error(errno);
 
-	ifobject->xsk->umem = ifobject->umem;
+	xsk->umem = ifobject->umem;
 	cfg.rx_size = rxqsize;
 	cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
 	cfg.libbpf_flags = 0;
@@ -313,19 +323,20 @@ static int xsk_configure_socket(struct ifobject *ifobject)
 	cfg.bind_flags = xdp_bind_flags;
 
 	if (test_type != TEST_TYPE_BIDI) {
-		rxr = (ifobject->fv.vector == rx) ? &ifobject->xsk->rx : NULL;
-		txr = (ifobject->fv.vector == tx) ? &ifobject->xsk->tx : NULL;
+		rxr = (ifobject->fv.vector == rx) ? &xsk->rx : NULL;
+		txr = (ifobject->fv.vector == tx) ? &xsk->tx : NULL;
 	} else {
-		rxr = &ifobject->xsk->rx;
-		txr = &ifobject->xsk->tx;
+		rxr = &xsk->rx;
+		txr = &xsk->tx;
 	}
 
-	ret = xsk_socket__create(&ifobject->xsk->xsk, ifobject->ifname,
-				 opt_queue, ifobject->umem->umem, rxr, txr, &cfg);
-
+	ret = xsk_socket__create(&xsk->xsk, ifobject->ifname, idx,
+				 ifobject->umem->umem, rxr, txr, &cfg);
 	if (ret)
 		return 1;
 
+	ifobject->xsk_arr[idx] = xsk;
+
 	return 0;
 }
 
@@ -393,7 +404,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:DC:v", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:DC:v", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -413,9 +424,6 @@ static void parse_command_line(int argc, char **argv)
 				       MAX_INTERFACES_NAMESPACE_CHARS);
 			interface_index++;
 			break;
-		case 'q':
-			opt_queue = atoi(optarg);
-			break;
 		case 'D':
 			debug_pkt_dump = 1;
 			break;
@@ -753,27 +761,33 @@ static void worker_pkt_validate(void)
 
 static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 {
+	int umem_sz = num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE;
 	int ctr = 0;
 	int ret;
 
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
-	bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
+	ifobject->ns_fd = switch_namespace(ifobject->nsname);
+
+	if (test_type == TEST_TYPE_BPF_RES)
+		umem_sz *= 2;
+
+	bufs = mmap(NULL, umem_sz,
 		    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
 
-	ifobject->ns_fd = switch_namespace(ifobject->nsname);
-
-	xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
-	ret = xsk_configure_socket(ifobject);
+	xsk_configure_umem(ifobject, bufs, 0);
+	ifobject->umem = ifobject->umem_arr[0];
+	ret = xsk_configure_socket(ifobject, 0);
 
 	/* Retry Create Socket if it fails as xsk_socket__create()
 	 * is asynchronous
 	 */
 	while (ret && ctr < SOCK_RECONF_CTR) {
-		xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
-		ret = xsk_configure_socket(ifobject);
+		xsk_configure_umem(ifobject, bufs, 0);
+		ifobject->umem = ifobject->umem_arr[0];
+		ret = xsk_configure_socket(ifobject, 0);
 		usleep(USLEEP_MAX);
 		ctr++;
 	}
@@ -781,10 +795,34 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 	if (ctr >= SOCK_RECONF_CTR)
 		exit_with_error(ret);
 
+	ifobject->umem = ifobject->umem_arr[0];
+	ifobject->xsk = ifobject->xsk_arr[0];
+
+	if (test_type == TEST_TYPE_BPF_RES) {
+		xsk_configure_umem(ifobject, (u8 *)bufs + (umem_sz / 2), 1);
+		ifobject->umem = ifobject->umem_arr[1];
+		ret = xsk_configure_socket(ifobject, 1);
+	}
+
+	ifobject->umem = ifobject->umem_arr[0];
+	ifobject->xsk = ifobject->xsk_arr[0];
 	print_verbose("Interface [%s] vector [%s]\n",
 		       ifobject->ifname, ifobject->fv.vector == tx ? "Tx" : "Rx");
 }
 
+static bool testapp_is_test_two_stepped(void)
+{
+	return (test_type != TEST_TYPE_BIDI && test_type != TEST_TYPE_BPF_RES) || second_step;
+}
+
+static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
+{
+	if (testapp_is_test_two_stepped()) {
+		xsk_socket__delete(ifobj->xsk->xsk);
+		(void)xsk_umem__delete(ifobj->umem->umem);
+	}
+}
+
 static void *worker_testapp_validate_tx(void *arg)
 {
 	struct udphdr *udp_hdr =
@@ -795,7 +833,7 @@ static void *worker_testapp_validate_tx(void *arg)
 	struct generic_data data;
 	void *bufs = NULL;
 
-	if (!bidi_pass)
+	if (!second_step)
 		thread_common_ops(ifobject, bufs);
 
 	for (int i = 0; i < num_frames; i++) {
@@ -815,10 +853,7 @@ static void *worker_testapp_validate_tx(void *arg)
 		       (opt_pkt_count - 1), ifobject->ifname);
 	tx_only_all(ifobject);
 
-	if ((test_type != TEST_TYPE_BIDI) || bidi_pass) {
-		xsk_socket__delete(ifobject->xsk->xsk);
-		(void)xsk_umem__delete(ifobject->umem->umem);
-	}
+	testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
 }
 
@@ -828,7 +863,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	struct pollfd fds[MAX_SOCKS] = { };
 	void *bufs = NULL;
 
-	if (!bidi_pass)
+	if (!second_step)
 		thread_common_ops(ifobject, bufs);
 
 	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
@@ -865,10 +900,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	if (test_type == TEST_TYPE_TEARDOWN)
 		print_verbose("Destroying socket\n");
 
-	if ((test_type != TEST_TYPE_BIDI) || bidi_pass) {
-		xsk_socket__delete(ifobject->xsk->xsk);
-		(void)xsk_umem__delete(ifobject->umem->umem);
-	}
+	testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
 }
 
@@ -876,6 +908,7 @@ static void testapp_validate(void)
 {
 	struct timespec max_wait = { 0, 0 };
 	bool bidi = test_type == TEST_TYPE_BIDI;
+	bool bpf = test_type == TEST_TYPE_BPF_RES;
 
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
@@ -909,7 +942,7 @@ static void testapp_validate(void)
 		free(pkt_buf);
 	}
 
-	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi && !(test_type == TEST_TYPE_STATS))
+	if (!(test_type == TEST_TYPE_TEARDOWN) && !bidi && !bpf && !(test_type == TEST_TYPE_STATS))
 		print_ksft_result();
 }
 
@@ -951,11 +984,11 @@ static void testapp_bidi(void)
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
-		if (!bidi_pass) {
+		if (!second_step) {
 			print_verbose("Switching Tx/Rx vectors\n");
 			swap_vectors(ifdict[1], ifdict[0]);
 		}
-		bidi_pass++;
+		second_step = true;
 	}
 
 	swap_vectors(ifdict[0], ifdict[1]);
@@ -963,6 +996,36 @@ static void testapp_bidi(void)
 	print_ksft_result();
 }
 
+static void swap_xsk_res(void)
+{
+	xsk_socket__delete(ifdict_tx->xsk->xsk);
+	xsk_umem__delete(ifdict_tx->umem->umem);
+	xsk_socket__delete(ifdict_rx->xsk->xsk);
+	xsk_umem__delete(ifdict_rx->umem->umem);
+	ifdict_tx->umem = ifdict_tx->umem_arr[1];
+	ifdict_tx->xsk = ifdict_tx->xsk_arr[1];
+	ifdict_rx->umem = ifdict_rx->umem_arr[1];
+	ifdict_rx->xsk = ifdict_rx->xsk_arr[1];
+}
+
+static void testapp_bpf_res(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_BPF_ITER; i++) {
+		pkt_counter = 0;
+		prev_pkt = -1;
+		sigvar = 0;
+		print_verbose("Creating socket\n");
+		testapp_validate();
+		if (!second_step)
+			swap_xsk_res();
+		second_step = true;
+	}
+
+	print_ksft_result();
+}
+
 static void testapp_stats(void)
 {
 	for (int i = 0; i < STAT_TEST_TYPE_MAX; i++) {
@@ -1026,13 +1089,15 @@ static void run_pkt_test(int mode, int type)
 	/* reset defaults after potential previous test */
 	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 	pkt_counter = 0;
-	bidi_pass = 0;
+	second_step = 0;
 	prev_pkt = -1;
 	sigvar = 0;
 	stat_test_type = -1;
 	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
 	frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM;
 
+	configured_mode = mode;
+
 	switch (mode) {
 	case (TEST_MODE_SKB):
 		xdp_flags |= XDP_FLAGS_SKB_MODE;
@@ -1054,6 +1119,9 @@ static void run_pkt_test(int mode, int type)
 	case TEST_TYPE_BIDI:
 		testapp_bidi();
 		break;
+	case TEST_TYPE_BPF_RES:
+		testapp_bpf_res();
+		break;
 	default:
 		testapp_validate();
 		break;
@@ -1063,6 +1131,7 @@ static void run_pkt_test(int mode, int type)
 int main(int argc, char **argv)
 {
 	struct rlimit _rlim = { RLIM_INFINITY, RLIM_INFINITY };
+	bool failure = false;
 	int i, j;
 
 	if (setrlimit(RLIMIT_MEMLOCK, &_rlim))
@@ -1074,6 +1143,16 @@ int main(int argc, char **argv)
 			exit_with_error(errno);
 
 		ifdict[i]->ifdict_index = i;
+		ifdict[i]->xsk_arr = calloc(2, sizeof(struct xsk_socket_info *));
+		if (!ifdict[i]->xsk_arr) {
+			failure = true;
+			goto cleanup;
+		}
+		ifdict[i]->umem_arr = calloc(2, sizeof(struct xsk_umem_info *));
+		if (!ifdict[i]->umem_arr) {
+			failure = true;
+			goto cleanup;
+		}
 	}
 
 	setlocale(LC_ALL, "");
@@ -1094,13 +1173,19 @@ int main(int argc, char **argv)
 			run_pkt_test(i, j);
 	}
 
+	destroy_sync_resources();
+
+cleanup:
 	for (int i = 0; i < MAX_INTERFACES; i++) {
 		if (ifdict[i]->ns_fd != -1)
 			close(ifdict[i]->ns_fd);
+		free(ifdict[i]->xsk_arr);
+		free(ifdict[i]->umem_arr);
 		free(ifdict[i]);
 	}
 
-	destroy_sync_resources();
+	if (failure)
+		exit_with_error(errno);
 
 	ksft_exit_pass();
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 44e2663d069d..302cb66f8c57 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -23,6 +23,7 @@
 #define MAX_SOCKS 1
 #define MAX_TEARDOWN_ITER 10
 #define MAX_BIDI_ITER 2
+#define MAX_BPF_ITER 2
 #define PKT_HDR_SIZE (sizeof(struct ethhdr) + sizeof(struct iphdr) + \
 			sizeof(struct udphdr))
 #define MIN_PKT_SIZE 64
@@ -63,6 +64,7 @@ enum TEST_TYPES {
 	TEST_TYPE_TEARDOWN,
 	TEST_TYPE_BIDI,
 	TEST_TYPE_STATS,
+	TEST_TYPE_BPF_RES,
 	TEST_TYPE_MAX
 };
 
@@ -77,10 +79,9 @@ enum STAT_TEST_TYPES {
 static int configured_mode = TEST_MODE_UNCONFIGURED;
 static u8 debug_pkt_dump;
 static u32 num_frames;
-static u8 bidi_pass;
+static bool second_step;
 static int test_type;
 
-static int opt_queue;
 static int opt_pkt_count;
 static u8 opt_verbose;
 
@@ -128,6 +129,8 @@ struct ifobject {
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
 	struct xsk_socket_info *xsk;
+	struct xsk_socket_info **xsk_arr;
+	struct xsk_umem_info **umem_arr;
 	struct xsk_umem_info *umem;
 	void *(*func_ptr)(void *);
 	struct flow_vector fv;
-- 
2.20.1

