Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB245A65CB
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbiH3N6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbiH3N5R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:57:17 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2611611B3D7;
        Tue, 30 Aug 2022 06:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867792; x=1693403792;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i1YT0Vjjagx5X97FN7FCMzOowUCA9lM2z/uWQ2Hh5KY=;
  b=BE+TmzjSiRmPrvLGxd+o/zi34a67JdrW71xpcQ3U+EkZpRfNaFtpiREV
   Bp4pXu+7CRAN7z3Kkm7UoSKxcrNcMpxXu2xO5Rk8Hy6FMPo/yVMrtHqbU
   vK7hSyotpMZeT9+dmoVG4Be+DSKdVBGkEe7qz+YbdAFds3WuzVhhx7EB0
   eODzzz/DZgPxxpb1QenAd0qZ+w97tlOEvRWYa9nS77idHuZoNt1Cr1PgL
   zHUQzCuA6KyNBVDeka/kty++1U7AxuBj0w+D5PJjPti43q2AwEG8luFgF
   BQvIO54ODfwR5RsCxPCFeg8CVc6fiehRBT3bzzQ7JXo0qD1hWaOWYYU1w
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295180425"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295180425"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:56:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="562651340"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 06:56:29 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 5/6] selftests: xsk: make sure single threaded test terminates
Date:   Tue, 30 Aug 2022 15:56:03 +0200
Message-Id: <20220830135604.10173-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For single threaded poll tests call pthread_kill() from main thread so
that we are sure worker thread has finished its job and it is possible
to proceed with next test types from test suite. It was observed that on
some platforms it takes a bit longer for worker thread to exit and next
test case sees device as busy in this case.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 4f8a028f5433..8e157c462cd0 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1345,6 +1345,11 @@ static void testapp_clean_xsk_umem(struct ifobject *ifobj)
 	munmap(ifobj->umem->buffer, umem_sz);
 }
 
+static void handler(int signum)
+{
+	pthread_exit(NULL);
+}
+
 static int testapp_validate_traffic_single_thread(struct test_spec *test, struct ifobject *ifobj,
 						  enum test_type type)
 {
@@ -1362,6 +1367,7 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 	test->ifobj_rx->shared_umem = false;
 	test->ifobj_tx->shared_umem = false;
 
+	signal(SIGUSR1, handler);
 	/* Spawn thread */
 	pthread_create(&t0, NULL, ifobj->func_ptr, test);
 
@@ -1371,6 +1377,7 @@ static int testapp_validate_traffic_single_thread(struct test_spec *test, struct
 	if (pthread_barrier_destroy(&barr))
 		exit_with_error(errno);
 
+	pthread_kill(t0, SIGUSR1);
 	pthread_join(t0, NULL);
 
 	if (test->total_steps == test->current_step || test->fail) {
-- 
2.34.1

