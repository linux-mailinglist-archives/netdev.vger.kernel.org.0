Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E4234518B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhCVVK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:4989 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230022AbhCVVJe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:34 -0400
IronPort-SDR: 7dgF4yKzn0rHs5fjBMTZPS+pgttHb+k1oauL8ok0GwRkzrE+0zlENtPpMysZwQGvhMVOknhpTB
 LJt7IZ9WI+zw==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423774"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423774"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:33 -0700
IronPort-SDR: 8TD62jwSt9xz6nNHjmuUrEnwCgNbogXBq7eZcnuZXSZZPI59NciW0sstVv3UX7gAw21MheBqsu
 0aSOGfH4mGDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448925"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:31 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com
Subject: [PATCH v3 bpf-next 16/17] selftest: xsk: Remove mutex and condition variable
Date:   Mon, 22 Mar 2021 21:58:15 +0100
Message-Id: <20210322205816.65159-17-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The usage of the condition variable is broken, and overkill. Replace
with a pthread barrier.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 33 ++++--------------------
 tools/testing/selftests/bpf/xdpxceiver.h |  3 +--
 2 files changed, 6 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 95d9d35dbb93..084ba052fa89 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -126,18 +126,6 @@ static void __exit_with_error(int error, const char *file, const char *func, int
 			       test_type == TEST_TYPE_STATS ? "Stats" : "",\
 			       test_type == TEST_TYPE_BPF_RES ? "BPF RES" : ""))
 
-static void init_sync_resources(void)
-{
-	pthread_mutex_init(&sync_mutex, NULL);
-	pthread_cond_init(&signal_rx_condition, NULL);
-}
-
-static void destroy_sync_resources(void)
-{
-	pthread_mutex_destroy(&sync_mutex);
-	pthread_cond_destroy(&signal_rx_condition);
-}
-
 static void *memset32_htonl(void *dest, u32 val, u32 size)
 {
 	u32 *ptr = (u32 *)dest;
@@ -876,9 +864,7 @@ static void *worker_testapp_validate_rx(void *arg)
 	fds[0].fd = xsk_socket__fd(ifobject->xsk->xsk);
 	fds[0].events = POLLIN;
 
-	pthread_mutex_lock(&sync_mutex);
-	pthread_cond_signal(&signal_rx_condition);
-	pthread_mutex_unlock(&sync_mutex);
+	pthread_barrier_wait(&barr);
 
 	while (1) {
 		if (test_type != TEST_TYPE_STATS) {
@@ -903,24 +889,19 @@ static void *worker_testapp_validate_rx(void *arg)
 
 static void testapp_validate(void)
 {
-	struct timespec max_wait = { 0, 0 };
 	bool bidi = test_type == TEST_TYPE_BIDI;
 	bool bpf = test_type == TEST_TYPE_BPF_RES;
 
-	pthread_mutex_lock(&sync_mutex);
+	if (pthread_barrier_init(&barr, NULL, 2))
+		exit_with_error(errno);
 
 	/*Spawn RX thread */
 	pthread_create(&t0, NULL, ifdict_rx->func_ptr, ifdict_rx);
 
-	if (clock_gettime(CLOCK_REALTIME, &max_wait))
-		exit_with_error(errno);
-	max_wait.tv_sec += TMOUT_SEC;
-
-	if (pthread_cond_timedwait(&signal_rx_condition, &sync_mutex, &max_wait) == ETIMEDOUT)
+	pthread_barrier_wait(&barr);
+	if (pthread_barrier_destroy(&barr))
 		exit_with_error(errno);
 
-	pthread_mutex_unlock(&sync_mutex);
-
 	/*Spawn TX thread */
 	pthread_create(&t1, NULL, ifdict_tx->func_ptr, ifdict_tx);
 
@@ -1160,15 +1141,11 @@ int main(int argc, char **argv)
 
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
-	init_sync_resources();
-
 	for (i = 0; i < TEST_MODE_MAX; i++) {
 		for (j = 0; j < TEST_TYPE_MAX; j++)
 			run_pkt_test(i, j);
 	}
 
-	destroy_sync_resources();
-
 cleanup:
 	for (int i = 0; i < MAX_INTERFACES; i++) {
 		if (ifdict[i]->ns_fd != -1)
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 78863820fb81..ef219c0785eb 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -148,8 +148,7 @@ static struct ifobject *ifdict_rx;
 static struct ifobject *ifdict_tx;
 
 /*threads*/
-pthread_mutex_t sync_mutex;
-pthread_cond_t signal_rx_condition;
+pthread_barrier_t barr;
 pthread_t t0, t1;
 
 TAILQ_HEAD(head_s, pkt) head = TAILQ_HEAD_INITIALIZER(head);
-- 
2.20.1

