Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237385A95F7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 13:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiIALs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 07:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiIALsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 07:48:32 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0975013A7D1;
        Thu,  1 Sep 2022 04:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662032910; x=1693568910;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PNFxYgMRiGgQdhK5MLuKFPduXgrGWXWcwIqvdjKITFc=;
  b=SUnPQlD/NqCGEts++DvbUVDor9+28EhmQuc0lAluC/Qjd7gCwFrZeWjW
   2OpIOB7VWWOV9w2d6bzzY3YwShD3F/Ud2q89p7RzhIp4B/6FQRaN4oCHs
   zPj/V8DPThIIzpRR1prvSk5jRQ8XbWYenTquNWtr552X9Ts/Y2ak+/guv
   Zvp1bbunMYkeWSBSej460e4XPExemnvvYaUjDZ8NG8NLqMM2cLQw9mPrJ
   6R2Ffcjp9Eng5ZjvpvV/OyxVTmF+t5ntJv5/+wi39JPOMm4ZtQAa5DV8+
   5tacydT5W8A80Dl/29Tha6xutQ4UdiT/uus/UFirsyPAP/F5qo4KktXEV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="357410392"
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="357410392"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 04:48:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,280,1654585200"; 
   d="scan'208";a="673814396"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2022 04:48:27 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v6 bpf-next 5/6] selftests: xsk: make sure single threaded test terminates
Date:   Thu,  1 Sep 2022 13:48:12 +0200
Message-Id: <20220901114813.16275-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
References: <20220901114813.16275-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index b54b844cae89..74b21ddf5a98 100644
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

