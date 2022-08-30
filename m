Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E55A65C9
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbiH3N5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiH3N5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:57:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23F38101FE;
        Tue, 30 Aug 2022 06:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867790; x=1693403790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7BMK0ejYQqopISBjQWLoM+Gba6+MiCaOj5VYVwGbygU=;
  b=SMpwtFnBaGFSqWpr/ZgdSBH7WnXsupkDmNBBZVhyj9BhoGmJ54K4mNfY
   88MapiAgJP4eHoHZVmqRzoEKn02fmPm9WLswkBPgsSvqmcaGc3ITrZvBx
   MfYfjunRnAHHILRMzk8Es5YJsbJNK1Xvo/OpHVPi6ZipuUkZyHVrYbeC2
   zdNggteFtYtte4Oeao8NFYenk/RQMDtNUGBUMuZAEwUSouyGoOjbLolGV
   CXdymM9lXo/SPun+eSGidYkNNO0FeWSH6ZtQWx9vBt4NYotpEEm/VGsF4
   j9ex2Fsein8ZLzcZaTU7m1WGBdBXuo/+OJPeWivWgEqnAR8LGQzOJnp84
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295180404"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295180404"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:56:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="562651327"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 06:56:27 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 4/6] selftests: xsk: add support for executing tests on physical device
Date:   Tue, 30 Aug 2022 15:56:02 +0200
Message-Id: <20220830135604.10173-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, architecture of xskxceiver is designed strictly for
conducting veth based tests. Veth pair is created together with a
network namespace and one of the veth interfaces is moved to the
mentioned netns. Then, separate threads for Tx and Rx are spawned which
will utilize described setup.

Infrastructure described in the paragraph above can not be used for
testing AF_XDP support on physical devices. That testing will be
conducted on a single network interface and same queue. Xdpxceiver
needs to be extended to distinguish between veth tests and physical
interface tests.

Since same iface/queue id pair will be used by both Tx/Rx threads for
physical device testing, Tx thread, which happen to run after the Rx
thread, is going to create XSK socket with shared umem flag. In order to
track this setting throughout the lifetime of spawned threads, introduce
'shared_umem' boolean variable to struct ifobject and set it to true
when xskxceiver is run against physical device. In such case, UMEM size
needs to be doubled, so half of it will be used by Rx thread and other
half by Tx thread. For two step based test types, value of XSKMAP
element under key 0 has to be updated as there is now another socket for
the second step. Also, to avoid race conditions when destroying XSK
resources, move this activity to the main thread after spawned Rx and Tx
threads have finished its job. This way it is possible to gracefully
remove shared umem without introducing synchronization mechanisms.

To run xsk selftests suite on physical device, append "-i $IFACE" when
invoking test_xsk.sh. For veth based tests, simply skip it. When "-i
$IFACE" is in place, under the hood test_xsk.sh will use $IFACE for both
interfaces supplied to xskxceiver, which in turn will interpret that
this execution of test suite is for a physical device.

Note that currently this makes it possible only to test SKB and DRV mode
(in case underlying device has native XDP support). ZC testing support
is added in a later patch.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh  |  52 ++++--
 tools/testing/selftests/bpf/xskxceiver.c | 205 +++++++++++++++--------
 tools/testing/selftests/bpf/xskxceiver.h |   1 +
 3 files changed, 170 insertions(+), 88 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 096a957594cd..d821fd098504 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -73,14 +73,20 @@
 #
 # Run and dump packet contents:
 #   sudo ./test_xsk.sh -D
+#
+# Run test suite for physical device in loopback mode
+#   sudo ./test_xsk.sh -i IFACE
 
 . xsk_prereqs.sh
 
-while getopts "vD" flag
+ETH=""
+
+while getopts "vDi:" flag
 do
 	case "${flag}" in
 		v) verbose=1;;
 		D) dump_pkts=1;;
+		i) ETH=${OPTARG};;
 	esac
 done
 
@@ -132,18 +138,25 @@ setup_vethPairs() {
 	ip link set ${VETH0} up
 }
 
-validate_root_exec
-validate_veth_support ${VETH0}
-validate_ip_utility
-setup_vethPairs
-
-retval=$?
-if [ $retval -ne 0 ]; then
-	test_status $retval "${TEST_NAME}"
-	cleanup_exit ${VETH0} ${VETH1} ${NS1}
-	exit $retval
+if [ ! -z $ETH ]; then
+	VETH0=${ETH}
+	VETH1=${ETH}
+	NS1=""
+else
+	validate_root_exec
+	validate_veth_support ${VETH0}
+	validate_ip_utility
+	setup_vethPairs
+
+	retval=$?
+	if [ $retval -ne 0 ]; then
+		test_status $retval "${TEST_NAME}"
+		cleanup_exit ${VETH0} ${VETH1} ${NS1}
+		exit $retval
+	fi
 fi
 
+
 if [[ $verbose -eq 1 ]]; then
 	ARGS+="-v "
 fi
@@ -152,26 +165,33 @@ if [[ $dump_pkts -eq 1 ]]; then
 	ARGS="-D "
 fi
 
+retval=$?
 test_status $retval "${TEST_NAME}"
 
 ## START TESTS
 
 statusList=()
 
-TEST_NAME="XSK_SELFTESTS_SOFTIRQ"
+TEST_NAME="XSK_SELFTESTS_${VETH0}_SOFTIRQ"
 
 exec_xskxceiver
 
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
-TEST_NAME="XSK_SELFTESTS_BUSY_POLL"
+if [ -z $ETH ]; then
+	cleanup_exit ${VETH0} ${VETH1} ${NS1}
+fi
+TEST_NAME="XSK_SELFTESTS_${VETH0}_BUSY_POLL"
 busy_poll=1
 
-setup_vethPairs
+if [ -z $ETH ]; then
+	setup_vethPairs
+fi
 exec_xskxceiver
 
 ## END TESTS
 
-cleanup_exit ${VETH0} ${VETH1} ${NS1}
+if [ -z $ETH ]; then
+	cleanup_exit ${VETH0} ${VETH1} ${NS1}
+fi
 
 failures=0
 echo -e "\nSummary:"
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 90d5691c0490..4f8a028f5433 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -301,8 +301,8 @@ static void enable_busy_poll(struct xsk_socket_info *xsk)
 		exit_with_error(errno);
 }
 
-static int xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
-				struct ifobject *ifobject, bool shared)
+static int __xsk_configure_socket(struct xsk_socket_info *xsk, struct xsk_umem_info *umem,
+				  struct ifobject *ifobject, bool shared)
 {
 	struct xsk_socket_config cfg = {};
 	struct xsk_ring_cons *rxr;
@@ -448,6 +448,9 @@ static void __test_spec_init(struct test_spec *test, struct ifobject *ifobj_tx,
 		memset(ifobj->umem, 0, sizeof(*ifobj->umem));
 		ifobj->umem->num_frames = DEFAULT_UMEM_BUFFERS;
 		ifobj->umem->frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
+		if (ifobj->shared_umem && ifobj->rx_on)
+			ifobj->umem->base_addr = DEFAULT_UMEM_BUFFERS *
+				XSK_UMEM__DEFAULT_FRAME_SIZE;
 
 		for (j = 0; j < MAX_SOCKETS; j++) {
 			memset(&ifobj->xsk_arr[j], 0, sizeof(ifobj->xsk_arr[j]));
@@ -1146,6 +1149,70 @@ static int validate_tx_invalid_descs(struct ifobject *ifobject)
 	return TEST_PASS;
 }
 
+static void xsk_configure_socket(struct test_spec *test, struct ifobject *ifobject,
+				 struct xsk_umem_info *umem, bool tx)
+{
+	int i, ret;
+
+	for (i = 0; i < test->nb_sockets; i++) {
+		bool shared = (ifobject->shared_umem && tx) ? true : !!i;
+		u32 ctr = 0;
+
+		while (ctr++ < SOCK_RECONF_CTR) {
+			ret = __xsk_configure_socket(&ifobject->xsk_arr[i], umem,
+						     ifobject, shared);
+			if (!ret)
+				break;
+
+			/* Retry if it fails as xsk_socket__create() is asynchronous */
+			if (ctr >= SOCK_RECONF_CTR)
+				exit_with_error(-ret);
+			usleep(USLEEP_MAX);
+		}
+		if (ifobject->busy_poll)
+			enable_busy_poll(&ifobject->xsk_arr[i]);
+	}
+}
+
+static void thread_common_ops_tx(struct test_spec *test, struct ifobject *ifobject)
+{
+	xsk_configure_socket(test, ifobject, test->ifobj_rx->umem, true);
+	ifobject->xsk = &ifobject->xsk_arr[0];
+	ifobject->xsk_map_fd = test->ifobj_rx->xsk_map_fd;
+	memcpy(ifobject->umem, test->ifobj_rx->umem, sizeof(struct xsk_umem_info));
+}
+
+static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
+{
+	u32 idx = 0, i, buffers_to_fill;
+	int ret;
+
+	if (umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
+		buffers_to_fill = umem->num_frames;
+	else
+		buffers_to_fill = XSK_RING_PROD__DEFAULT_NUM_DESCS;
+
+	ret = xsk_ring_prod__reserve(&umem->fq, buffers_to_fill, &idx);
+	if (ret != buffers_to_fill)
+		exit_with_error(ENOSPC);
+	for (i = 0; i < buffers_to_fill; i++) {
+		u64 addr;
+
+		if (pkt_stream->use_addr_for_fill) {
+			struct pkt *pkt = pkt_stream_get_pkt(pkt_stream, i);
+
+			if (!pkt)
+				break;
+			addr = pkt->addr;
+		} else {
+			addr = i * umem->frame_size;
+		}
+
+		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
+	}
+	xsk_ring_prod__submit(&umem->fq, buffers_to_fill);
+}
+
 static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 {
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
@@ -1153,13 +1220,15 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
 	int ret, ifindex;
 	void *bufs;
-	u32 i;
 
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
 	if (ifobject->umem->unaligned_mode)
 		mmap_flags |= MAP_HUGETLB;
 
+	if (ifobject->shared_umem)
+		umem_sz *= 2;
+
 	bufs = mmap(NULL, umem_sz, PROT_READ | PROT_WRITE, mmap_flags, -1, 0);
 	if (bufs == MAP_FAILED)
 		exit_with_error(errno);
@@ -1168,24 +1237,9 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (ret)
 		exit_with_error(-ret);
 
-	for (i = 0; i < test->nb_sockets; i++) {
-		u32 ctr = 0;
-
-		while (ctr++ < SOCK_RECONF_CTR) {
-			ret = xsk_configure_socket(&ifobject->xsk_arr[i], ifobject->umem,
-						   ifobject, !!i);
-			if (!ret)
-				break;
-
-			/* Retry if it fails as xsk_socket__create() is asynchronous */
-			if (ctr >= SOCK_RECONF_CTR)
-				exit_with_error(-ret);
-			usleep(USLEEP_MAX);
-		}
+	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
 
-		if (ifobject->busy_poll)
-			enable_busy_poll(&ifobject->xsk_arr[i]);
-	}
+	xsk_configure_socket(test, ifobject, ifobject->umem, false);
 
 	ifobject->xsk = &ifobject->xsk_arr[0];
 
@@ -1221,22 +1275,18 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 		exit_with_error(-ret);
 }
 
-static void testapp_cleanup_xsk_res(struct ifobject *ifobj)
-{
-	print_verbose("Destroying socket\n");
-	xsk_socket__delete(ifobj->xsk->xsk);
-	munmap(ifobj->umem->buffer, ifobj->umem->num_frames * ifobj->umem->frame_size);
-	xsk_umem__delete(ifobj->umem->umem);
-}
-
 static void *worker_testapp_validate_tx(void *arg)
 {
 	struct test_spec *test = (struct test_spec *)arg;
 	struct ifobject *ifobject = test->ifobj_tx;
 	int err;
 
-	if (test->current_step == 1)
-		thread_common_ops(test, ifobject);
+	if (test->current_step == 1) {
+		if (!ifobject->shared_umem)
+			thread_common_ops(test, ifobject);
+		else
+			thread_common_ops_tx(test, ifobject);
+	}
 
 	print_verbose("Sending %d packets on interface %s\n", ifobject->pkt_stream->nb_pkts,
 		      ifobject->ifname);
@@ -1247,53 +1297,23 @@ static void *worker_testapp_validate_tx(void *arg)
 	if (err)
 		report_failure(test);
 
-	if (test->total_steps == test->current_step || err)
-		testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
 }
 
-static void xsk_populate_fill_ring(struct xsk_umem_info *umem, struct pkt_stream *pkt_stream)
-{
-	u32 idx = 0, i, buffers_to_fill;
-	int ret;
-
-	if (umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
-		buffers_to_fill = umem->num_frames;
-	else
-		buffers_to_fill = XSK_RING_PROD__DEFAULT_NUM_DESCS;
-
-	ret = xsk_ring_prod__reserve(&umem->fq, buffers_to_fill, &idx);
-	if (ret != buffers_to_fill)
-		exit_with_error(ENOSPC);
-	for (i = 0; i < buffers_to_fill; i++) {
-		u64 addr;
-
-		if (pkt_stream->use_addr_for_fill) {
-			struct pkt *pkt = pkt_stream_get_pkt(pkt_stream, i);
-
-			if (!pkt)
-				break;
-			addr = pkt->addr;
-		} else {
-			addr = i * umem->frame_size;
-		}
-
-		*xsk_ring_prod__fill_addr(&umem->fq, idx++) = addr;
-	}
-	xsk_ring_prod__submit(&umem->fq, buffers_to_fill);
-}
-
 static void *worker_testapp_validate_rx(void *arg)
 {
 	struct test_spec *test = (struct test_spec *)arg;
 	struct ifobject *ifobject = test->ifobj_rx;
 	struct pollfd fds = { };
+	int id = 0;
 	int err;
 
-	if (test->current_step == 1)
+	if (test->current_step == 1) {
 		thread_common_ops(test, ifobject);
-
-	xsk_populate_fill_ring(ifobject->umem, ifobject->pkt_stream);
+	} else {
+		bpf_map_delete_elem(ifobject->xsk_map_fd, &id);
+		xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
+	}
 
 	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds.events = POLLIN;
@@ -1311,25 +1331,38 @@ static void *worker_testapp_validate_rx(void *arg)
 		pthread_mutex_unlock(&pacing_mutex);
 	}
 
-	if (test->total_steps == test->current_step || err)
-		testapp_cleanup_xsk_res(ifobject);
 	pthread_exit(NULL);
 }
 
+static void testapp_clean_xsk_umem(struct ifobject *ifobj)
+{
+	u64 umem_sz = ifobj->umem->num_frames * ifobj->umem->frame_size;
+
+	if (ifobj->shared_umem)
+		umem_sz *= 2;
+
+	xsk_umem__delete(ifobj->umem->umem);
+	munmap(ifobj->umem->buffer, umem_sz);
+}
+
 static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
 						  enum test_type type)
 {
+	bool old_shared_umem = ifobj->shared_umem;
 	pthread_t t0;
 
 	if (pthread_barrier_init(&barr, NULL, 2))
 		exit_with_error(errno);
 
 	test->current_step++;
-	if (type  == TEST_TYPE_POLL_RXQ_TMOUT)
+	if (type == TEST_TYPE_POLL_RXQ_TMOUT)
 		pkt_stream_reset(ifobj->pkt_stream);
 	pkts_in_flight = 0;
 
-	/*Spawn thread */
+	test->ifobj_rx->shared_umem = false;
+	test->ifobj_tx->shared_umem = false;
+
+	/* Spawn thread */
 	pthread_create(&t0, NULL, ifobj->func_ptr, test);
 
 	if (type != TEST_TYPE_POLL_TXQ_TMOUT)
@@ -1340,6 +1373,14 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 
 	pthread_join(t0, NULL);
 
+	if (test->total_steps == test->current_step || test->fail) {
+		xsk_socket__delete(ifobj->xsk->xsk);
+		testapp_clean_xsk_umem(ifobj);
+	}
+
+	test->ifobj_rx->shared_umem = old_shared_umem;
+	test->ifobj_tx->shared_umem = old_shared_umem;
+
 	return !!test->fail;
 }
 
@@ -1369,6 +1410,14 @@ static int testapp_validate_traffic(struct test_spec *test)
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
 
+	if (test->total_steps == test->current_step || test->fail) {
+		xsk_socket__delete(ifobj_tx->xsk->xsk);
+		xsk_socket__delete(ifobj_rx->xsk->xsk);
+		testapp_clean_xsk_umem(ifobj_rx);
+		if (!ifobj_tx->shared_umem)
+			testapp_clean_xsk_umem(ifobj_tx);
+	}
+
 	return !!test->fail;
 }
 
@@ -1448,9 +1497,9 @@ static void testapp_headroom(struct test_spec *test)
 static void testapp_stats_rx_dropped(struct test_spec *test)
 {
 	test_spec_set_name(test, "STAT_RX_DROPPED");
+	pkt_stream_replace_half(test, MIN_PKT_SIZE * 4, 0);
 	test->ifobj_rx->umem->frame_headroom = test->ifobj_rx->umem->frame_size -
 		XDP_PACKET_HEADROOM - MIN_PKT_SIZE * 3;
-	pkt_stream_replace_half(test, MIN_PKT_SIZE * 4, 0);
 	pkt_stream_receive_half(test);
 	test->ifobj_rx->validation_func = validate_rx_dropped;
 	testapp_validate_traffic(test);
@@ -1573,6 +1622,11 @@ static void testapp_invalid_desc(struct test_spec *test)
 		pkts[7].valid = false;
 	}
 
+	if (test->ifobj_tx->shared_umem) {
+		pkts[4].addr += UMEM_SIZE;
+		pkts[5].addr += UMEM_SIZE;
+	}
+
 	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
 	testapp_validate_traffic(test);
 	pkt_stream_restore_default(test);
@@ -1731,7 +1785,6 @@ static void ifobject_delete(struct ifobject *ifobj)
 {
 	if (ifobj->ns_fd != -1)
 		close(ifobj->ns_fd);
-	free(ifobj->umem);
 	free(ifobj->xsk_arr);
 	free(ifobj);
 }
@@ -1773,6 +1826,7 @@ int main(int argc, char **argv)
 	int modes = TEST_MODE_SKB + 1;
 	u32 i, j, failed_tests = 0;
 	struct test_spec test;
+	bool shared_umem;
 
 	/* Use libbpf 1.0 API mode */
 	libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
@@ -1787,6 +1841,10 @@ int main(int argc, char **argv)
 	setlocale(LC_ALL, "");
 
 	parse_command_line(ifobj_tx, ifobj_rx, argc, argv);
+	shared_umem = !strcmp(ifobj_tx->ifname, ifobj_rx->ifname);
+
+	ifobj_tx->shared_umem = shared_umem;
+	ifobj_rx->shared_umem = shared_umem;
 
 	if (!validate_interface(ifobj_tx) || !validate_interface(ifobj_rx)) {
 		usage(basename(argv[0]));
@@ -1823,6 +1881,9 @@ int main(int argc, char **argv)
 
 	pkt_stream_delete(tx_pkt_stream_default);
 	pkt_stream_delete(rx_pkt_stream_default);
+	free(ifobj_rx->umem);
+	if (!ifobj_tx->shared_umem)
+		free(ifobj_tx->umem);
 	ifobject_delete(ifobj_tx);
 	ifobject_delete(ifobj_rx);
 
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 12bfa6e463d3..068e88d7327e 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -153,6 +153,7 @@ struct ifobject {
 	bool busy_poll;
 	bool use_fill_ring;
 	bool release_rx;
+	bool shared_umem;
 	u8 dst_mac[ETH_ALEN];
 	u8 src_mac[ETH_ALEN];
 };
-- 
2.34.1

