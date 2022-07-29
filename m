Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0DF5850D6
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 15:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbiG2NXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 09:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231976AbiG2NXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 09:23:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD5567594;
        Fri, 29 Jul 2022 06:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659101021; x=1690637021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8F3C43ey2A1CgV0okZzoTflvDq0Ep6YjnCAtC3gCz3M=;
  b=eiJYHT2AlehWG3ZqN3axcPfuN7jM0MTv96fp27AkhuPUoiPqs/iE9O7L
   cZa1/0dpwT2CiCLirD5OMKPnzS3L1kL/5dKpnyfXlMhmwvCEyyt7RJSMa
   jgXEVTNGNbzw0VboshB4hRGOxL5W5knG0SchtHi8f5Q2eBfegrb1m0y+J
   /XT+iAkhzGxGApaSLp1jPeGM5eaBbwO8zmz9O7RZu+dfLIQtAEDp5qx5t
   au8Od1WpZFawSF9wIsvvo+MvDMTsl8OMEp3YnWXu8hIumok1uC+TU9Pcd
   NTuapnOIKfSzQ620sqaute+3cAHrrhdSw7hGDXVO7RV9bltyWsvvcuJhV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10423"; a="314565634"
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="314565634"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2022 06:23:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,201,1654585200"; 
   d="scan'208";a="928742628"
Received: from silpixa00401350.ir.intel.com (HELO silpixav00401350..) ([10.55.128.131])
  by fmsmga005.fm.intel.com with ESMTP; 29 Jul 2022 06:23:38 -0700
From:   Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org, maciej.fijalkowski@intel.com,
        andrii@kernel.org, ciara.loftus@intel.com,
        Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
Subject: [PATCH bpf-next v3] selftests: xsk: Update poll test cases
Date:   Fri, 29 Jul 2022 13:23:37 +0000
Message-Id: <20220729132337.211443-1-shibin.koikkara.reeny@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Poll test case was not testing all the functionality
of the poll feature in the testsuite. This patch
update the poll test case which contain 2 testcases to
test the RX and the TX poll functionality and additional
2 more testcases to check the timeout features of the
poll event.

Poll testsuite have 4 test cases:

1. TEST_TYPE_RX_POLL:
Check if RX path POLLIN function work as expect. TX path
can use any method to sent the traffic.

2. TEST_TYPE_TX_POLL:
Check if TX path POLLOUT function work as expect. RX path
can use any method to receive the traffic.

3. TEST_TYPE_POLL_RXQ_EMPTY:
Call poll function with parameter POLLIN on empty rx queue
will cause timeout.If return timeout then test case is pass.

4. TEST_TYPE_POLL_TXQ_FULL:
When txq is filled and packets are not cleaned by the kernel
then if we invoke the poll function with POLLOUT then it
should trigger timeout.

v1: https://lore.kernel.org/bpf/20220718095712.588513-1-shibin.koikkara.reeny@intel.com/
v2: https://lore.kernel.org/bpf/20220726101723.250746-1-shibin.koikkara.reeny@intel.com/

Changes in v2:
 * Updated the commit message
 * fixed the while loop flow in receive_pkts function.
Changes in v3:
 * Introduced single thread validation function.
 * Removed pkt_stream_invalid().
 * Updated TEST_TYPE_POLL_TXQ_FULL testcase to create invalid frame.
 * Removed timer from send_pkts().
 * Removed boolean variable skip_rx and skip_tx

Signed-off-by: Shibin Koikkara Reeny <shibin.koikkara.reeny@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 155 +++++++++++++++++------
 tools/testing/selftests/bpf/xskxceiver.h |   8 +-
 2 files changed, 125 insertions(+), 38 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 74d56d971baf..32ba6464f29f 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -817,9 +817,9 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 	return TEST_PASS;
 }
 
-static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
+static int receive_pkts(struct test_spec *test, struct ifobject *ifobj, struct pollfd *fds)
 {
-	struct timeval tv_end, tv_now, tv_timeout = {RECV_TMOUT, 0};
+	struct timeval tv_end, tv_now, tv_timeout = {THREAD_TMOUT, 0};
 	u32 idx_rx = 0, idx_fq = 0, rcvd, i, pkts_sent = 0;
 	struct pkt_stream *pkt_stream = ifobj->pkt_stream;
 	struct xsk_socket_info *xsk = ifobj->xsk;
@@ -843,17 +843,28 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 		}
 
 		kick_rx(xsk);
+		if (ifobj->use_poll) {
+			ret = poll(fds, 1, POLL_TMOUT);
+			if (ret < 0)
+				exit_with_error(-ret);
+
+			if (!ret) {
+				if (!test->ifobj_tx->umem->umem)
+					return TEST_PASS;
+
+				ksft_print_msg("ERROR: [%s] Poll timed out\n", __func__);
+				return TEST_FAILURE;
 
-		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
-		if (!rcvd) {
-			if (xsk_ring_prod__needs_wakeup(&umem->fq)) {
-				ret = poll(fds, 1, POLL_TMOUT);
-				if (ret < 0)
-					exit_with_error(-ret);
 			}
-			continue;
+
+			if (!(fds->revents & POLLIN))
+				continue;
 		}
 
+		rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
+		if (!rcvd)
+			continue;
+
 		if (ifobj->use_fill_ring) {
 			ret = xsk_ring_prod__reserve(&umem->fq, rcvd, &idx_fq);
 			while (ret != rcvd) {
@@ -900,13 +911,34 @@ static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
 	return TEST_PASS;
 }
 
-static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
+static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb, bool use_poll,
+		       struct pollfd *fds, bool timeout)
 {
 	struct xsk_socket_info *xsk = ifobject->xsk;
-	u32 i, idx, valid_pkts = 0;
+	u32 i, idx, ret, valid_pkts = 0;
+
+	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE) {
+		if (use_poll) {
+			ret = poll(fds, 1, POLL_TMOUT);
+			if (timeout) {
+				if (ret < 0) {
+					ksft_print_msg("ERROR: [%s] Poll error %d\n",
+						       __func__, ret);
+					return TEST_FAILURE;
+				}
+				if (ret == 0)
+					return TEST_PASS;
+				break;
+			}
+			if (ret <= 0) {
+				ksft_print_msg("ERROR: [%s] Poll error %d\n",
+					       __func__, ret);
+				return TEST_FAILURE;
+			}
+		}
 
-	while (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) < BATCH_SIZE)
 		complete_pkts(xsk, BATCH_SIZE);
+	}
 
 	for (i = 0; i < BATCH_SIZE; i++) {
 		struct xdp_desc *tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i);
@@ -933,11 +965,27 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
 
 	xsk_ring_prod__submit(&xsk->tx, i);
 	xsk->outstanding_tx += valid_pkts;
-	if (complete_pkts(xsk, i))
-		return TEST_FAILURE;
 
-	usleep(10);
-	return TEST_PASS;
+	if (use_poll) {
+		ret = poll(fds, 1, POLL_TMOUT);
+		if (ret <= 0) {
+			if (ret == 0 && timeout)
+				return TEST_PASS;
+
+			ksft_print_msg("ERROR: [%s] Poll error %d\n", __func__, ret);
+			return TEST_FAILURE;
+		}
+	}
+
+	if (!timeout) {
+		if (complete_pkts(xsk, i))
+			return TEST_FAILURE;
+
+		usleep(10);
+		return TEST_PASS;
+	}
+
+	return TEST_CONTINUE;
 }
 
 static void wait_for_tx_completion(struct xsk_socket_info *xsk)
@@ -948,29 +996,19 @@ static void wait_for_tx_completion(struct xsk_socket_info *xsk)
 
 static int send_pkts(struct test_spec *test, struct ifobject *ifobject)
 {
+	bool timeout = (!test->ifobj_rx->umem->umem) ? true : false;
 	struct pollfd fds = { };
-	u32 pkt_cnt = 0;
+	u32 pkt_cnt = 0, ret;
 
 	fds.fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds.events = POLLOUT;
 
 	while (pkt_cnt < ifobject->pkt_stream->nb_pkts) {
-		int err;
-
-		if (ifobject->use_poll) {
-			int ret;
-
-			ret = poll(&fds, 1, POLL_TMOUT);
-			if (ret <= 0)
-				continue;
-
-			if (!(fds.revents & POLLOUT))
-				continue;
-		}
-
-		err = __send_pkts(ifobject, &pkt_cnt);
-		if (err || test->fail)
+		ret = __send_pkts(ifobject, &pkt_cnt, ifobject->use_poll, &fds, timeout);
+		if ((ret || test->fail) && !timeout)
 			return TEST_FAILURE;
+		else if (ret == TEST_PASS && timeout)
+			return ret;
 	}
 
 	wait_for_tx_completion(ifobject->xsk);
@@ -1235,7 +1273,7 @@ static void *worker_testapp_validate_rx(void *arg)
 
 	pthread_barrier_wait(&barr);
 
-	err = receive_pkts(ifobject, &fds);
+	err = receive_pkts(test, ifobject, &fds);
 
 	if (!err && ifobject->validation_func)
 		err = ifobject->validation_func(ifobject);
@@ -1251,6 +1289,33 @@ static void *worker_testapp_validate_rx(void *arg)
 	pthread_exit(NULL);
 }
 
+static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
+						  enum test_type type)
+{
+	pthread_t t0;
+
+	if (pthread_barrier_init(&barr, NULL, 2))
+		exit_with_error(errno);
+
+	test->current_step++;
+	if (type  == TEST_TYPE_POLL_RXQ_TMOUT)
+		pkt_stream_reset(ifobj->pkt_stream);
+	pkts_in_flight = 0;
+
+	/*Spawn thread */
+	pthread_create(&t0, NULL, ifobj->func_ptr, test);
+
+	if (type  != TEST_TYPE_POLL_TXQ_TMOUT)
+		pthread_barrier_wait(&barr);
+
+	if (pthread_barrier_destroy(&barr))
+		exit_with_error(errno);
+
+	pthread_join(t0, NULL);
+
+	return !!test->fail;
+}
+
 static int testapp_validate_traffic(struct test_spec *test)
 {
 	struct ifobject *ifobj_tx = test->ifobj_tx;
@@ -1548,12 +1613,30 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 
 		pkt_stream_restore_default(test);
 		break;
-	case TEST_TYPE_POLL:
-		test->ifobj_tx->use_poll = true;
+	case TEST_TYPE_RX_POLL:
 		test->ifobj_rx->use_poll = true;
-		test_spec_set_name(test, "POLL");
+		test_spec_set_name(test, "POLL_RX");
+		testapp_validate_traffic(test);
+		break;
+	case TEST_TYPE_TX_POLL:
+		test->ifobj_tx->use_poll = true;
+		test_spec_set_name(test, "POLL_TX");
 		testapp_validate_traffic(test);
 		break;
+	case TEST_TYPE_POLL_TXQ_TMOUT:
+		test_spec_set_name(test, "POLL_TXQ_FULL");
+		test->ifobj_tx->use_poll = true;
+		/* create invalid frame by set umem frame_size and pkt length equal to 2048 */
+		test->ifobj_tx->umem->frame_size = 2048;
+		pkt_stream_replace(test, 2 * DEFAULT_PKT_CNT, 2048);
+		testapp_validate_traffic_single_thread(test, test->ifobj_tx, type);
+		pkt_stream_restore_default(test);
+		break;
+	case TEST_TYPE_POLL_RXQ_TMOUT:
+		test_spec_set_name(test, "POLL_RXQ_EMPTY");
+		test->ifobj_rx->use_poll = true;
+		testapp_validate_traffic_single_thread(test, test->ifobj_rx, type);
+		break;
 	case TEST_TYPE_ALIGNED_INV_DESC:
 		test_spec_set_name(test, "ALIGNED_INV_DESC");
 		testapp_invalid_desc(test);
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 3d17053f98e5..ee97576757a9 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -27,6 +27,7 @@
 
 #define TEST_PASS 0
 #define TEST_FAILURE -1
+#define TEST_CONTINUE 1
 #define MAX_INTERFACES 2
 #define MAX_INTERFACE_NAME_CHARS 7
 #define MAX_INTERFACES_NAMESPACE_CHARS 10
@@ -48,7 +49,7 @@
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
-#define RECV_TMOUT 3
+#define THREAD_TMOUT 3
 #define DEFAULT_PKT_CNT (4 * 1024)
 #define DEFAULT_UMEM_BUFFERS (DEFAULT_PKT_CNT / 4)
 #define UMEM_SIZE (DEFAULT_UMEM_BUFFERS * XSK_UMEM__DEFAULT_FRAME_SIZE)
@@ -68,7 +69,10 @@ enum test_type {
 	TEST_TYPE_RUN_TO_COMPLETION,
 	TEST_TYPE_RUN_TO_COMPLETION_2K_FRAME,
 	TEST_TYPE_RUN_TO_COMPLETION_SINGLE_PKT,
-	TEST_TYPE_POLL,
+	TEST_TYPE_RX_POLL,
+	TEST_TYPE_TX_POLL,
+	TEST_TYPE_POLL_RXQ_TMOUT,
+	TEST_TYPE_POLL_TXQ_TMOUT,
 	TEST_TYPE_UNALIGNED,
 	TEST_TYPE_ALIGNED_INV_DESC,
 	TEST_TYPE_ALIGNED_INV_DESC_2K_FRAME,
-- 
2.34.1

