Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68972345187
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhCVVKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229639AbhCVVJZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:25 -0400
IronPort-SDR: LKETwT6FNKxrnupOjFzXIpFKAxhDfjltGEg75BHZM5LqjmphD/nbOCodAWUssS794V6CVBvqCg
 7Go9c3G3bceA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423750"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423750"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:24 -0700
IronPort-SDR: ESRql6kUSGFYk8NViAutYeK0XeUn4wTMfynU+96c0e+w8+VZrCMkV1zlHuCV0W38Y8ykfstubk
 M73w8fh0O0Hw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448869"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:22 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 12/17] selftests: xsk: remove sync_mutex_tx and atomic var
Date:   Mon, 22 Mar 2021 21:58:11 +0100
Message-Id: <20210322205816.65159-13-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Although thread_common_ops() are called in both Tx and Rx threads,
testapp_validate() will not spawn Tx thread until Rx thread signals that
it has finished its initialization via condition variable.

Therefore, locking in thread_common_ops is not needed and furthermore Tx
thread does not have to spin on atomic variable.

Note that this simplification wouldn't be possible if there would still
be a common worker thread.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 31 ++++++------------------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 --
 2 files changed, 7 insertions(+), 26 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index aeff5340be49..be7f4930dee9 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -121,17 +121,15 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 			       test_type == TEST_TYPE_BIDI ? "Bi-directional Sockets" : "",\
 			       test_type == TEST_TYPE_STATS ? "Stats" : ""))
 
-static void pthread_init_mutex(void)
+static void init_sync_resources(void)
 {
 	pthread_mutex_init(&sync_mutex, NULL);
-	pthread_mutex_init(&sync_mutex_tx, NULL);
 	pthread_cond_init(&signal_rx_condition, NULL);
 }
 
-static void pthread_destroy_mutex(void)
+static void destroy_sync_resources(void)
 {
 	pthread_mutex_destroy(&sync_mutex);
-	pthread_mutex_destroy(&sync_mutex_tx);
 	pthread_cond_destroy(&signal_rx_condition);
 }
 
@@ -752,7 +750,7 @@ static void worker_pkt_validate(void)
 	}
 }
 
-static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mutex_t *mutexptr)
+static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 {
 	int ctr = 0;
 	int ret;
@@ -771,22 +769,13 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mut
 
 	/* Retry Create Socket if it fails as xsk_socket__create()
 	 * is asynchronous
-	 *
-	 * Essential to lock Mutex here to prevent Tx thread from
-	 * entering before Rx and causing a deadlock
 	 */
-	pthread_mutex_lock(mutexptr);
 	while (ret && ctr < SOCK_RECONF_CTR) {
-		if (ifobject->fv.vector == rx)
-			atomic_store(&spinning_rx, 1);
 		xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
 		ret = xsk_configure_socket(ifobject);
 		usleep(USLEEP_MAX);
 		ctr++;
 	}
-	if (ifobject->fv.vector == rx)
-		atomic_store(&spinning_rx, 0);
-	pthread_mutex_unlock(mutexptr);
 
 	if (ctr >= SOCK_RECONF_CTR)
 		exit_with_error(ret);
@@ -803,16 +792,10 @@ static void *worker_testapp_validate_tx(void *arg)
 	struct ethhdr *eth_hdr = (struct ethhdr *)pkt_data;
 	struct ifobject *ifobject = (struct ifobject *)arg;
 	struct generic_data data;
-	int spinningrxctr = 0;
 	void *bufs = NULL;
 
 	if (!bidi_pass)
-		thread_common_ops(ifobject, bufs, &sync_mutex_tx);
-
-	while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
-		spinningrxctr++;
-		usleep(USLEEP_MAX);
-	}
+		thread_common_ops(ifobject, bufs);
 
 	for (int i = 0; i < num_frames; i++) {
 		/*send EOT frame */
@@ -845,7 +828,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	void *bufs = NULL;
 
 	if (!bidi_pass)
-		thread_common_ops(ifobject, bufs, &sync_mutex_tx);
+		thread_common_ops(ifobject, bufs);
 
 	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
 		xsk_populate_fill_ring(ifobject->umem);
@@ -1103,7 +1086,7 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
-	pthread_init_mutex();
+	init_sync_resources();
 
 	for (i = 0; i < TEST_MODE_MAX; i++) {
 		for (j = 0; j < TEST_TYPE_MAX; j++)
@@ -1116,7 +1099,7 @@ int main(int argc, char **argv)
 		free(ifdict[i]);
 	}
 
-	pthread_destroy_mutex();
+	destroy_sync_resources();
 
 	ksft_exit_pass();
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 3945746900af..e304229d8a4c 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -146,9 +146,7 @@ static struct ifobject *ifdict_rx;
 static struct ifobject *ifdict_tx;
 
 /*threads*/
-atomic_int spinning_rx;
 pthread_mutex_t sync_mutex;
-pthread_mutex_t sync_mutex_tx;
 pthread_cond_t signal_rx_condition;
 pthread_t t0, t1;
 pthread_attr_t attr;
-- 
2.20.1

