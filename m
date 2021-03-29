Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11634DC40
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232231AbhC2W4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:56:11 -0400
Received: from mga04.intel.com ([192.55.52.120]:2470 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhC2Wzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:55:47 -0400
IronPort-SDR: CMuop0xxaXMtlgb3QkS2pG22nKqOBf8+qRggiG3/q6n4S7+DvLo1L0aHbAYV548LA/KO09bzZn
 KCtLghpq5Emw==
X-IronPort-AV: E=McAfee;i="6000,8403,9938"; a="189393046"
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="189393046"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2021 15:55:46 -0700
IronPort-SDR: 7L7dU7XssSFBDT4tGmEdnKK90zlMDRMLXnI9tM1tQCxETMDwfH2kXgmE2O9LIZGbBSgcfimYzj
 d+x5RQymzPew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,289,1610438400"; 
   d="scan'208";a="417884358"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga008.jf.intel.com with ESMTP; 29 Mar 2021 15:55:44 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com
Subject: [PATCH v5 bpf-next 16/17] selftests: xsk: Remove mutex and condition variable
Date:   Tue, 30 Mar 2021 00:43:15 +0200
Message-Id: <20210329224316.17793-17-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
References: <20210329224316.17793-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The usage of the condition variable is broken, and overkill. Replace it
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

