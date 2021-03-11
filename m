Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E48D337848
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbhCKPmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:42:06 -0500
Received: from mga14.intel.com ([192.55.52.115]:42370 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234358AbhCKPlt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:49 -0500
IronPort-SDR: lK0T6Di6q5VCTDPgnPcgZrULpMNe7r4LeV5pms+0kTXSh3/K3lqlm7nnZywaWkbZ6hpUWCQbTn
 //EN9m2ijZng==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188050747"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188050747"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:49 -0800
IronPort-SDR: syO3c6n8ldWsfyvDqoLDX+tgeF8JSIFxOIJPxUXEuzxJmn85xIjtQ9xIG0llqrsH5kdeeNbqk5
 Cf+XxA3EvETA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253645"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:41:46 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com
Subject: [PATCH v2 bpf-next 15/17] selftests: xsk: remove thread attribute
Date:   Thu, 11 Mar 2021 16:29:08 +0100
Message-Id: <20210311152910.56760-16-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

There is really no reason to have a non-default thread stack
size. Remove that.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 9 ++-------
 tools/testing/selftests/bpf/xdpxceiver.h | 2 --
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index dc775ee139c5..35826d73266f 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -765,8 +765,6 @@ static void thread_common_ops(struct ifobject *ifobject, void *bufs)
 	int ctr = 0;
 	int ret;
 
-	pthread_attr_setstacksize(&attr, THREAD_STACK);
-
 	ifobject->ns_fd = switch_namespace(ifobject->nsname);
 
 	if (test_type == TEST_TYPE_BPF_RES)
@@ -910,13 +908,10 @@ static void testapp_validate(void)
 	bool bidi = test_type == TEST_TYPE_BIDI;
 	bool bpf = test_type == TEST_TYPE_BPF_RES;
 
-	pthread_attr_init(&attr);
-	pthread_attr_setstacksize(&attr, THREAD_STACK);
-
 	pthread_mutex_lock(&sync_mutex);
 
 	/*Spawn RX thread */
-	pthread_create(&t0, &attr, ifdict_rx->func_ptr, ifdict_rx);
+	pthread_create(&t0, NULL, ifdict_rx->func_ptr, ifdict_rx);
 
 	if (clock_gettime(CLOCK_REALTIME, &max_wait))
 		exit_with_error(errno);
@@ -928,7 +923,7 @@ static void testapp_validate(void)
 	pthread_mutex_unlock(&sync_mutex);
 
 	/*Spawn TX thread */
-	pthread_create(&t1, &attr, ifdict_tx->func_ptr, ifdict_tx);
+	pthread_create(&t1, NULL, ifdict_tx->func_ptr, ifdict_tx);
 
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 302cb66f8c57..09b85a2925a5 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -37,7 +37,6 @@
 #define TMOUT_SEC (3)
 #define EOT (-1)
 #define USLEEP_MAX 200000
-#define THREAD_STACK 60000000
 #define SOCK_RECONF_CTR 10
 #define BATCH_SIZE 64
 #define POLL_TMOUT 1000
@@ -152,7 +151,6 @@ static struct ifobject *ifdict_tx;
 pthread_mutex_t sync_mutex;
 pthread_cond_t signal_rx_condition;
 pthread_t t0, t1;
-pthread_attr_t attr;
 
 TAILQ_HEAD(head_s, pkt) head = TAILQ_HEAD_INITIALIZER(head);
 struct head_s *head_p;
-- 
2.20.1

