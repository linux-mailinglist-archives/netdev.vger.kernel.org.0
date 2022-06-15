Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECB354CE43
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354712AbiFOQPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354486AbiFOQNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:13:45 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AD239BBC;
        Wed, 15 Jun 2022 09:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309596; x=1686845596;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5MKX3A+Kq0uVtr+3KWFqll7T9q90GcHf4K/urm0XVms=;
  b=GrrAtU99Wj7GNtdCKqr7XCHgdKgkBMfgN2jTKNgoNT7dJxSVH4sZj/t8
   2OVjN0elvKZKtvbmV0DI66xezLd8lq86N9m2wEaim2EHkZPFAiS6sGnfv
   PFOOKjhoNppS//MmkB0Sc2dciv0QLQ9I2+DnPyIS6YqOp2/4BYSY5Ooa/
   wqgnFkPeExcVPWNdfJbX1v1SWNPBlgqGJoF7zHfI2wFdfG3gQ9JvZjLdR
   BF+gMcI86aQ+fSwmb4mk2KdAty/3rEUEFYSZVLV71d64YR5NG2yz2+DJ9
   obMJY3aFwinSHPwF9Lv7B/OvnXlkfM3cV8hhBZIkMDi0iisyMlZ+Ui3ob
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280050199"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280050199"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="713005385"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 09:11:18 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 09/11] selftests: xsk: rely on pkts_in_flight in wait_for_tx_completion()
Date:   Wed, 15 Jun 2022 18:10:39 +0200
Message-Id: <20220615161041.902916-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the drivers that implement support for AF_XDP Zero Copy (like
ice) can have lazy approach for cleaning Tx descriptors. For ZC, when
descriptor is cleaned, it is placed onto AF_XDP completion queue. This
means that current implementation of wait_for_tx_completion() in
xdpxceiver can get onto infinite loop, as some of the descriptors can
never reach CQ.

This function can be changed to rely on pkts_in_flight instead.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 3 ++-
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index de4cf0432243..13a3b2ac2399 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -965,7 +965,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
 
 static void wait_for_tx_completion(struct xsk_socket_info *xsk)
 {
-	while (xsk->outstanding_tx)
+	while (pkts_in_flight)
 		complete_pkts(xsk, BATCH_SIZE);
 }
 
@@ -1269,6 +1269,7 @@ static void *worker_testapp_validate_rx(void *arg)
 		pthread_mutex_unlock(&pacing_mutex);
 	}
 
+	pkts_in_flight = 0;
 	pthread_exit(NULL);
 }
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index b7aa6c7cf2be..f364a92675f8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -170,6 +170,6 @@ pthread_barrier_t barr;
 pthread_mutex_t pacing_mutex = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t pacing_cond = PTHREAD_COND_INITIALIZER;
 
-int pkts_in_flight;
+volatile int pkts_in_flight;
 
 #endif				/* XDPXCEIVER_H */
-- 
2.27.0

