Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE84F34DC3A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232096AbhC2Wz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:55:56 -0400
Received: from mga04.intel.com ([192.55.52.120]:2470 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231644AbhC2Wz3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:55:29 -0400
IronPort-SDR: 79Vmj+0nQ6HFBYyI2uLF+tu5TbPuA7Z3kB/oZl2Pnj+riwEN39RhgY978CrXW3Ze0yGEAVJNNt
 +kALNZ8ARJPw==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="189393026"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="189393026"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 15:55:29 -0700
IronPort-SDR: NkuK2Di0cJYl2WjvipLydJdnfZUbOHgY+qRlQya8onwMTfl6Z1epaJsar+Bocm9B9mnsRUPpeF
 HgpBtM9FmqSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="417884271"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2021 15:55:26 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 10/17] selftests: xsk: remove Tx synchronization resources
Date:   Tue, 30 Mar 2021 00:43:09 +0200
Message-Id: <20210329224316.17793-11-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
References: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx thread needs to be started after the Rx side is fully initialized so
that packets are not xmitted until xsk Rx socket is ready to be used.

It can be observed that atomic variable spinning_tx is not checked from
Rx side in any way, so thread_common_ops can be modified to only address
the spinning_rx. This means that spinning_tx can be removed altogheter.

signal_tx_condition is never utilized, so simply remove it.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 15 +++++++--------
 tools/testing/selftests/bpf/xdpxceiver.h |  2 --
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index b6fd5eb1d620..3db221e548cc 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -126,7 +126,6 @@ static void pthread_init_mutex(void)
 	pthread_mutex_init(&sync_mutex, NULL);
 	pthread_mutex_init(&sync_mutex_tx, NULL);
 	pthread_cond_init(&signal_rx_condition, NULL);
-	pthread_cond_init(&signal_tx_condition, NULL);
 }
 
 static void pthread_destroy_mutex(void)
@@ -134,7 +133,6 @@ static void pthread_destroy_mutex(void)
 	pthread_mutex_destroy(&sync_mutex);
 	pthread_mutex_destroy(&sync_mutex_tx);
 	pthread_cond_destroy(&signal_rx_condition);
-	pthread_cond_destroy(&signal_tx_condition);
 }
 
 static void *memset32_htonl(void *dest, u32 val, u32 size)
@@ -754,8 +752,7 @@ static void worker_pkt_validate(void)
 	}
 }
 
-static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mutex_t *mutexptr,
-			      atomic_int *spinningptr)
+static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mutex_t *mutexptr)
 {
 	int ctr = 0;
 	int ret;
@@ -780,13 +777,15 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs, pthread_mut
 	 */
 	pthread_mutex_lock(mutexptr);
 	while (ret && ctr < SOCK_RECONF_CTR) {
-		atomic_store(spinningptr, 1);
+		if (ifobject->fv.vector == rx)
+			atomic_store(&spinning_rx, 1);
 		xsk_configure_umem(ifobject, bufs, num_frames * XSK_UMEM__DEFAULT_FRAME_SIZE);
 		ret = xsk_configure_socket(ifobject);
 		usleep(USLEEP_MAX);
 		ctr++;
 	}
-	atomic_store(spinningptr, 0);
+	if (ifobject->fv.vector == rx)
+		atomic_store(&spinning_rx, 0);
 	pthread_mutex_unlock(mutexptr);
 
 	if (ctr >= SOCK_RECONF_CTR)
@@ -808,7 +807,7 @@ static void *worker_testapp_validate_tx(void *arg)
 	void *bufs = NULL;
 
 	if (!bidi_pass)
-		thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_tx);
+		thread_common_ops(ifobject, bufs, &sync_mutex_tx);
 
 	while (atomic_load(&spinning_rx) && spinningrxctr < SOCK_RECONF_CTR) {
 		spinningrxctr++;
@@ -846,7 +845,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	void *bufs = NULL;
 
 	if (!bidi_pass)
-		thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
+		thread_common_ops(ifobject, bufs, &sync_mutex_tx);
 
 	if (stat_test_type != STAT_TEST_RX_FILL_EMPTY)
 		xsk_populate_fill_ring(ifobject->umem);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 493f7498d40e..483be41229c6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -144,12 +144,10 @@ struct ifobject {
 static struct ifobject *ifdict[MAX_INTERFACES];
 
 /*threads*/
-atomic_int spinning_tx;
 atomic_int spinning_rx;
 pthread_mutex_t sync_mutex;
 pthread_mutex_t sync_mutex_tx;
 pthread_cond_t signal_rx_condition;
-pthread_cond_t signal_tx_condition;
 pthread_t t0, t1;
 pthread_attr_t attr;
 
-- 
2.20.1

