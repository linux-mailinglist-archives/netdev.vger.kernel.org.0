Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6682345184
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhCVVKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhCVVJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:18 -0400
IronPort-SDR: 9mYPFJ92Ir/Yw1Lf6126kE5Qm3r3XvBMANcOUJCgD6MBvACViLr9Aa39sQR+sQmd4KL12Bv+3Q
 Exy6tQx5ieHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423738"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423738"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:18 -0700
IronPort-SDR: ZIxyjM6VMn1O2ziMt/lljJNLZByAS9x8eqYaLfCgvSek+5CFlHxsYAqwEBjA4ygW5N8/H2kntC
 Q6l49D7laZSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448838"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:16 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 09/17] selftests: xsk: split worker thread
Date:   Mon, 22 Mar 2021 21:58:08 +0100
Message-Id: <20210322205816.65159-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's a have a separate Tx/Rx worker threads instead of a one common
thread packed with Tx/Rx specific checks.

Move mmap for umem buffer space and a switch_namespace() call to
thread_common_ops.

This also allows for a bunch of simplifactions that are the subject of
the next commits. The final result will be a code base that is much
easier to follow.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 156 +++++++++++------------
 1 file changed, 77 insertions(+), 79 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 2e5f536563e4..b6fd5eb1d620 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -760,6 +760,15 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mut
 	int ctr = 0;
 	int ret;
 
+	pthread_attr_setstacksize(&attr, THREAD_STACK);
+
+	bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
+		    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (bufs == MAP_FAILED)
+		exit_with_error(errno);
+
+	ifobject->ns_fd = switch_namespace(ifobject->nsname);
+
 	xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
 	ret = xsk_configure_socket(ifobject);
 
@@ -782,9 +791,12 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mut
 
 	if (ctr >= SOCK_RECONF_CTR)
 		exit_with_error(ret);
+
+	print_verbose("Interface [%s] vector [%s]\n",
+		      ifobject->ifname, ifobject->fv.vector == tx ? "Tx" : "Rx");
 }
 
-static void *worker_testapp_validate(void *arg)
+static void *worker_testapp_validate_tx(void *arg)
 {
 	struct udphdr *udp_hdr =
 	    (struct udphdr *)(pkt_data + sizeof(struct ethhdr) + sizeof(struct iphdr));
@@ -792,97 +804,83 @@ static void *worker_testapp_validate(void *arg)
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
 	struct ifobject *ifobject = (struct ifobject *)arg;
 	struct generic_data data;
+	int spinningrxctr = 0;
 	void *bufs = NULL;
 
-	pthread_attr_setstacksize(&attr, THREAD_STACK);
-
-	if (!bidi_pass) {
-		bufs = mmap(NULL, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE,
-			    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-		if (bufs == MAP_FAILED)
-			exit_with_error(errno);
+	if (!bidi_pass)
+		thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_tx);
 
-		ifobject->ns_fd = switch_namespace(ifobject->nsname);
+	while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
+		spinningrxctr++;
+		usleep(USLEEP_MAX);
 	}
 
-	if (ifobject->fv.vector == tx) {
-		int spinningrxctr = 0;
+	for (int i = 0; i < num_frames; i++) {
+		/*send EOT frame */
+		if (i == (num_frames - 1))
+			data.seqnum = -1;
+		else
+			data.seqnum = i;
+		gen_udp_hdr(&data, ifobject, udp_hdr);
+		gen_ip_hdr(ifobject, ip_hdr);
+		gen_udp_csum(udp_hdr, ip_hdr);
+		gen_eth_hdr(ifobject, eth_hdr);
+		gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
+	}
 
-		if (!bidi_pass)
-			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_tx);
+	print_verbose("Sending %d packets on interface %s\n",
+		      (opt_pkt_count - 1), ifobject->ifname);
+	tx_only_all(ifobject);
 
-		while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
-			spinningrxctr++;
-			usleep(USLEEP_MAX);
-		}
+	if (test_type != TEST_TYPE_BIDI || bidi_pass) {
+		xsk_socket__delete(ifobject->xsk->xsk);
+		(void)xsk_umem__delete(ifobject->umem->umem);
+	}
+	pthread_exit(NULL);
+}
 
-		print_verbose("Interface [%s] vector [Tx]\n", ifobject->ifname);
-		for (int i = 0; i < num_frames; i++) {
-			/*send EOT frame */
-			if (i == (num_frames - 1))
-				data.seqnum = -1;
-			else
-				data.seqnum = i;
-			gen_udp_hdr(&data, ifobject, udp_hdr);
-			gen_ip_hdr(ifobject, ip_hdr);
-			gen_udp_csum(udp_hdr, ip_hdr);
-			gen_eth_hdr(ifobject, eth_hdr);
-			gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
-		}
+static void *worker_testapp_validate_rx(void *arg)
+{
+	struct ifobject *ifobject = (struct ifobject *)arg;
+	struct pollfd fds[MAX_SOCKS] = { };
+	void *bufs = NULL;
 
-		print_verbose("Sending %d packets on interface %s\n",
-			       (opt_pkt_count - 1), ifobject->ifname);
-		tx_only_all(ifobject);
-	} else if (ifobject->fv.vector == rx) {
-		struct pollfd fds[MAX_SOCKS] = { };
-		int ret;
-
-		if (!bidi_pass)
-			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
-
-		print_verbose("Interface [%s] vector [Rx]\n", ifobject->ifname);
-		if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
-			xsk_populate_fill_ring(ifobject->umem);
-
-		TAILQ_INIT(&head);
-		if (debug_pkt_dump) {
-			pkt_buf = calloc(num_frames, sizeof(*pkt_buf));
-			if (!pkt_buf)
-				exit_with_error(errno);
-		}
+	if (!bidi_pass)
+		thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
 
-		fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
-		fds[0].events = POLLIN;
+	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
+		xsk_populate_fill_ring(ifobject->umem);
 
-		pthread_mutex_lock(&sync_mutex);
-		pthread_cond_signal(&signal_rx_condition);
-		pthread_mutex_unlock(&sync_mutex);
+	TAILQ_INIT(&head);
+	if (debug_pkt_dump) {
+		pkt_buf = calloc(num_frames, sizeof(*pkt_buf));
+		if (!pkt_buf)
+			exit_with_error(errno);
+	}
 
-		while (1) {
-			if (test_type == TEST_TYPE_POLL) {
-				ret = poll(fds, 1, POLL_TMOUT);
-				if (ret <= 0)
-					continue;
-			}
+	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
+	fds[0].events = POLLIN;
 
-			if (test_type != TEST_TYPE_STATS) {
-				rx_pkt(ifobject->xsk, fds);
-				worker_pkt_validate();
-			} else {
-				worker_stats_validate(ifobject);
-			}
+	pthread_mutex_lock(&sync_mutex);
+	pthread_cond_signal(&signal_rx_condition);
+	pthread_mutex_unlock(&sync_mutex);
 
-			if (sigvar)
-				break;
+	while (1) {
+		if (test_type != TEST_TYPE_STATS) {
+			rx_pkt(ifobject->xsk, fds);
+			worker_pkt_validate();
+		} else {
+			worker_stats_validate(ifobject);
 		}
+		if (sigvar)
+			break;
+	}
 
-		if (test_type != TEST_TYPE_STATS)
-			print_verbose("Received %d packets on interface %s\n",
-				pkt_counter, ifobject->ifname);
+	print_verbose("Received %d packets on interface %s\n",
+		      pkt_counter, ifobject->ifname);
 
-		if (test_type == TEST_TYPE_TEARDOWN)
-			print_verbose("Destroying socket\n");
-	}
+	if (test_type == TEST_TYPE_TEARDOWN)
+		print_verbose("Destroying socket\n");
 
 	if ((test_type != TEST_TYPE_BIDI) || bidi_pass) {
 		xsk_socket__delete(ifobject->xsk->xsk);
@@ -911,12 +909,12 @@ static void testapp_validate(void)
 
 	/*Spawn RX thread */
 	if (!bidi || !bidi_pass) {
-		if (pthread_create(&t0, &attr, worker_testapp_validate, ifdict[1]))
+		if (pthread_create(&t0, &attr, worker_testapp_validate_rx, ifdict[1]))
 			exit_with_error(errno);
 	} else if (bidi && bidi_pass) {
 		/*switch Tx/Rx vectors */
 		ifdict[0]->fv.vector = rx;
-		if (pthread_create(&t0, &attr, worker_testapp_validate, ifdict[0]))
+		if (pthread_create(&t0, &attr, worker_testapp_validate_rx, ifdict[0]))
 			exit_with_error(errno);
 	}
 
@@ -931,12 +929,12 @@ static void testapp_validate(void)
 
 	/*Spawn TX thread */
 	if (!bidi || !bidi_pass) {
-		if (pthread_create(&t1, &attr, worker_testapp_validate, ifdict[0]))
+		if (pthread_create(&t1, &attr, worker_testapp_validate_tx, ifdict[0]))
 			exit_with_error(errno);
 	} else if (bidi && bidi_pass) {
 		/*switch Tx/Rx vectors */
 		ifdict[1]->fv.vector = tx;
-		if (pthread_create(&t1, &attr, worker_testapp_validate, ifdict[1]))
+		if (pthread_create(&t1, &attr, worker_testapp_validate_tx, ifdict[1]))
 			exit_with_error(errno);
 	}
 
-- 
2.20.1

