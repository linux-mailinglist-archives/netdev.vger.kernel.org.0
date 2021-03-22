Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D79345186
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhCVVKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229871AbhCVVJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:22 -0400
IronPort-SDR: rlArwj0A5NskaJuWCDzWXaSSVzlinET0I9Oo4j7YQQzVZM2dXb87PpYPbro5SWHY7hkKODsjb0
 2njIRYa+G0aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423747"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423747"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:22 -0700
IronPort-SDR: 6dg/cffPD1ZsQWdYUqkZvoBa7c/xozgFVk7rJV/8meKd0HqfPNtpZtfuQcJuuQi3954m9dBh0g
 LijYsd5YsTwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448856"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:20 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 11/17] selftests: xsk: refactor teardown/bidi test cases and testapp_validate
Date:   Mon, 22 Mar 2021 21:58:10 +0100
Message-Id: <20210322205816.65159-12-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is a testapp_sockets() that acts like a wrapper around
testapp_validate() and it is called for bidi and teardown test types.
Other test types call testapp_validate() directly.

Split testapp_sockets() onto two separate functions so a bunch of bidi
specific logic can be moved there and out of testapp_validate() itself.

Introduce function pointer to ifobject struct which will be used for
assigning the Rx/Tx function that is assigned to worker thread. Let's
also have a global ifobject Rx/Tx pointers so it's easier to swap the
vectors on a second run of a bi-directional test. Thread creation now is
easey to follow.

switching_notify variable is useless, info about vector switch can be
printed based on bidi_pass state.

Last but not least, init/destroy synchronization variables only once,
not per each test.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 117 ++++++++++++++---------
 tools/testing/selftests/bpf/xdpxceiver.h |  14 +--
 2 files changed, 78 insertions(+), 53 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 3db221e548cc..aeff5340be49 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -896,26 +896,10 @@ static void testapp_validate(void)
 	pthread_attr_init(&attr);
 	pthread_attr_setstacksize(&attr, THREAD_STACK);
 
-	if ((test_type == TEST_TYPE_BIDI) && bidi_pass) {
-		pthread_init_mutex();
-		if (!switching_notify) {
-			print_verbose("Switching Tx/Rx vectors\n");
-			switching_notify++;
-		}
-	}
-
 	pthread_mutex_lock(&sync_mutex);
 
 	/*Spawn RX thread */
-	if (!bidi || !bidi_pass) {
-		if (pthread_create(&t0, &attr, worker_testapp_validate_rx, ifdict[1]))
-			exit_with_error(errno);
-	} else if (bidi && bidi_pass) {
-		/*switch Tx/Rx vectors */
-		ifdict[0]->fv.vector = rx;
-		if (pthread_create(&t0, &attr, worker_testapp_validate_rx, ifdict[0]))
-			exit_with_error(errno);
-	}
+	pthread_create(&t0, &attr, ifdict_rx->func_ptr, ifdict_rx);
 
 	if (clock_gettime(CLOCK_REALTIME, &max_wait))
 		exit_with_error(errno);
@@ -927,15 +911,7 @@ static void testapp_validate(void)
 	pthread_mutex_unlock(&sync_mutex);
 
 	/*Spawn TX thread */
-	if (!bidi || !bidi_pass) {
-		if (pthread_create(&t1, &attr, worker_testapp_validate_tx, ifdict[0]))
-			exit_with_error(errno);
-	} else if (bidi && bidi_pass) {
-		/*switch Tx/Rx vectors */
-		ifdict[1]->fv.vector = tx;
-		if (pthread_create(&t1, &attr, worker_testapp_validate_tx, ifdict[1]))
-			exit_with_error(errno);
-	}
+	pthread_create(&t1, &attr, ifdict_tx->func_ptr, ifdict_tx);
 
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
@@ -953,18 +929,53 @@ static void testapp_validate(void)
 		print_ksft_result();
 }
 
-static void testapp_sockets(void)
+static void testapp_teardown(void)
+{
+	int i;
+
+	for (i = 0; i < MAX_TEARDOWN_ITER; i++) {
+		pkt_counter = 0;
+		prev_pkt = -1;
+		sigvar = 0;
+		print_verbose("Creating socket\n");
+		testapp_validate();
+	}
+
+	print_ksft_result();
+}
+
+static void swap_vectors(struct ifobject *ifobj1, struct ifobject *ifobj2)
+{
+	void *(*tmp_func_ptr)(void *) = ifobj1->func_ptr;
+	enum fvector tmp_vector = ifobj1->fv.vector;
+
+	ifobj1->func_ptr = ifobj2->func_ptr;
+	ifobj1->fv.vector = ifobj2->fv.vector;
+
+	ifobj2->func_ptr = tmp_func_ptr;
+	ifobj2->fv.vector = tmp_vector;
+
+	ifdict_tx = ifobj1;
+	ifdict_rx = ifobj2;
+}
+
+static void testapp_bidi(void)
 {
-	for (int i = 0; i < ((test_type == TEST_TYPE_TEARDOWN) ? MAX_TEARDOWN_ITER : MAX_BIDI_ITER);
-	     i++) {
+	for (int i = 0; i < MAX_BIDI_ITER; i++) {
 		pkt_counter = 0;
 		prev_pkt = -1;
 		sigvar = 0;
 		print_verbose("Creating socket\n");
 		testapp_validate();
-		test_type == TEST_TYPE_BIDI ? bidi_pass++ : bidi_pass;
+		if (!bidi_pass) {
+			print_verbose("Switching Tx/Rx vectors\n");
+			swap_vectors(ifdict[1], ifdict[0]);
+		}
+		bidi_pass++;
 	}
 
+	swap_vectors(ifdict[0], ifdict[1]);
+
 	print_ksft_result();
 }
 
@@ -997,7 +1008,7 @@ static void testapp_stats(void)
 static void init_iface(struct ifobject *ifobj, const char *dst_mac,
 		       const char *src_mac, const char *dst_ip,
 		       const char *src_ip, const u16 dst_port,
-		       const u16 src_port)
+		       const u16 src_port, enum fvector vector)
 {
 	struct in_addr ip;
 
@@ -1012,6 +1023,16 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac,
 
 	ifobj->dst_port = dst_port;
 	ifobj->src_port = src_port;
+
+	if (vector == tx) {
+		ifobj->fv.vector = tx;
+		ifobj->func_ptr = worker_testapp_validate_tx;
+		ifdict_tx = ifobj;
+	} else {
+		ifobj->fv.vector = rx;
+		ifobj->func_ptr = worker_testapp_validate_rx;
+		ifdict_rx = ifobj;
+	}
 }
 
 static void run_pkt_test(int mode, int type)
@@ -1021,11 +1042,8 @@ static void run_pkt_test(int mode, int type)
 	/* reset defaults after potential previous test */
 	xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 	pkt_counter = 0;
-	switching_notify = 0;
 	bidi_pass = 0;
 	prev_pkt = -1;
-	ifdict[0]->fv.vector = tx;
-	ifdict[1]->fv.vector = rx;
 	sigvar = 0;
 	stat_test_type = -1;
 	rxqsize = XSK_RING_CONS__DEFAULT_NUM_DESCS;
@@ -1042,16 +1060,20 @@ static void run_pkt_test(int mode, int type)
 		break;
 	}
 
-	pthread_init_mutex();
-
-	if (test_type == TEST_TYPE_STATS)
+	switch (test_type) {
+	case TEST_TYPE_STATS:
 		testapp_stats();
-	else if ((test_type != TEST_TYPE_TEARDOWN) && (test_type != TEST_TYPE_BIDI))
+		break;
+	case TEST_TYPE_TEARDOWN:
+		testapp_teardown();
+		break;
+	case TEST_TYPE_BIDI:
+		testapp_bidi();
+		break;
+	default:
 		testapp_validate();
-	else
-		testapp_sockets();
-
-	pthread_destroy_mutex();
+		break;
+	}
 }
 
 int main(int argc, char **argv)
@@ -1076,14 +1098,13 @@ int main(int argc, char **argv)
 
 	num_frames = ++opt_pkt_count;
 
-	ifdict[0]->fv.vector = tx;
-	init_iface(ifdict[0], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2);
-
-	ifdict[1]->fv.vector = rx;
-	init_iface(ifdict[1], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1);
+	init_iface(ifdict[0], MAC1, MAC2, IP1, IP2, UDP_PORT1, UDP_PORT2, tx);
+	init_iface(ifdict[1], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1, rx);
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
+	pthread_init_mutex();
+
 	for (i = 0; i < TEST_MODE_MAX; i++) {
 		for (j = 0; j < TEST_TYPE_MAX; j++)
 			run_pkt_test(i, j);
@@ -1095,6 +1116,8 @@ int main(int argc, char **argv)
 		free(ifdict[i]);
 	}
 
+	pthread_destroy_mutex();
+
 	ksft_exit_pass();
 
 	return 0;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 483be41229c6..3945746900af 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -77,7 +77,6 @@ enum STAT_TEST_TYPES {
 static int configured_mode = TEST_MODE_UNCONFIGURED;
 static u8 debug_pkt_dump;
 static u32 num_frames;
-static u8 switching_notify;
 static u8 bidi_pass;
 static int test_type;
 
@@ -126,22 +125,25 @@ struct generic_data {
 };
 
 struct ifobject {
-	int ns_fd;
-	int ifdict_index;
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
-	struct flow_vector fv;
 	struct xsk_socket_info *xsk;
 	struct xsk_umem_info *umem;
-	u8 dst_mac[ETH_ALEN];
-	u8 src_mac[ETH_ALEN];
+	void *(*func_ptr)(void *arg);
+	struct flow_vector fv;
+	int ns_fd;
+	int ifdict_index;
 	u32 dst_ip;
 	u32 src_ip;
 	u16 src_port;
 	u16 dst_port;
+	u8 dst_mac[ETH_ALEN];
+	u8 src_mac[ETH_ALEN];
 };
 
 static struct ifobject *ifdict[MAX_INTERFACES];
+static struct ifobject *ifdict_rx;
+static struct ifobject *ifdict_tx;
 
 /*threads*/
 atomic_int spinning_rx;
-- 
2.20.1

