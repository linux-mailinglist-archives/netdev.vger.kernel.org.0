Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5004546925
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241794AbiFJPKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344378AbiFJPJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:09:59 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD0F173280;
        Fri, 10 Jun 2022 08:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654873798; x=1686409798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kKns8uAtykiWrUp/EyOKxPcbD+Jb7ZrhmwVrjXsT/f8=;
  b=TpLkKyw1drAGaId41tAWUit/bxIBB5Z6JUYFrh1NeAighjTNpuTvqQA7
   3Z7hYoL88XPXMqzRnRnysZHM9/oTmRHiygFp3Utia5s1wBFwn+JY/t/Q6
   ikSI4d/fgBiNcCtfmK9GxOZ+ZcMgp1PKoRPRLsbPriHdN48j6Vcqa6NNI
   gNc23bnAG4HCXVGtwuq1FlXu7mLwrWXT+TYxPOMm6zslF1CORgbI1Zy4x
   fuJ8lJPvw3z7tvln2jxQoLqK/MsX+z1YvE+LjUfmSDUrbNgNSMunDqdNy
   b5KrpSYuFpkHCmvqkOo63DenDj0QRTDI88+C0QLJMjU1pU688jtN/hyfL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278788479"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="278788479"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 08:09:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638176249"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jun 2022 08:09:56 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 08/10] selftests: xsk: rely on pkts_in_flight in wait_for_tx_completion()
Date:   Fri, 10 Jun 2022 17:09:21 +0200
Message-Id: <20220610150923.583202-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 3 ++-
 tools/testing/selftests/bpf/xdpxceiver.h | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 316f1dd338fc..c9385690af09 100644
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

