Return-Path: <netdev+bounces-6130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E340F714DB2
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89CF01C20A36
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 979A61426A;
	Mon, 29 May 2023 15:51:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6BC14265;
	Mon, 29 May 2023 15:51:20 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 751F0A3;
	Mon, 29 May 2023 08:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375479; x=1716911479;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=95GqTvlmuQ59hVLj2UomxKfzOqq0J8bLQWQg/CLG5/M=;
  b=jvZpJJfEqJa8K8L+a15FilDhz++O5IsF1Js/9BgEIqrdjyAjs+/wEv15
   Ho8XswPQ7qgBFod8botNfj1RU4mzYr0+Rp9XjTVaVitUAI9M6hFBpy3oN
   ou0x1Qz+9qLxaNZHKqTiMSzZFbDsk8mRSO4dcTOQZ7vOZO13HkmeH9MwD
   ZjXGIcopU4nK6TpaxFmXfs9T8mOj/CrW0dtzxJUTUkXWwQ8xDvm8cET6n
   ndoxR9WpIsbtSYRPoxq8TyN2U77vMqKkjsO9sFZ0nrrgXz3aRwbfED+Bs
   /P3RDpDHqIpftgvyXHGmRMaYTwUtiCQJLT2Wcs9ACOy3Vnlo3xp11n/Mf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344229104"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344229104"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:51:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441270"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441270"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:51:16 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH v2 bpf-next 21/22] selftests/xsk: add test for too many frags
Date: Mon, 29 May 2023 17:50:23 +0200
Message-Id: <20230529155024.222213-22-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add a test for testing that a packet consisting of more than 17 frags
is discarded. This is only valid for SKB and DRV mode since in
zero-copy mode, this limit is up to the HW and what it supports.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 37 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  2 ++
 2 files changed, 39 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 658e978053d4..430ff0cec24c 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1975,6 +1975,40 @@ static int testapp_poll_rxq_tmout(struct test_spec *test)
 	return testapp_validate_traffic_single_thread(test, test->ifobj_rx);
 }
 
+static int testapp_too_many_frags(struct test_spec *test)
+{
+	struct pkt pkts[XSK_DESC__MAX_FRAGS + 3] = {};
+	u32 i;
+
+	test_spec_set_name(test, "TOO_MANY_FRAGS");
+	if (test->mode == TEST_MODE_ZC) {
+		/* Limit is up to driver for zero-copy mode so not testable. */
+		ksft_test_result_skip("Cannot be run for zero-copy mode.\n");
+		return TEST_SKIP;
+	}
+
+	test->mtu = MAX_ETH_JUMBO_SIZE;
+
+	/* Valid packet for synch */
+	pkts[0].len = MIN_PKT_SIZE;
+	pkts[0].valid = true;
+
+	/* Do not signal end-of-packet in the 17th frag. This is not legal. */
+	for (i = 1; i < XSK_DESC__MAX_FRAGS + 2; i++) {
+		pkts[i].len = MIN_PKT_SIZE;
+		pkts[i].options = XDP_PKT_CONTD;
+		pkts[i].valid = true;
+	}
+	pkts[XSK_DESC__MAX_FRAGS + 1].valid = false;
+
+	/* Valid packet for synch */
+	pkts[XSK_DESC__MAX_FRAGS + 2].len = MIN_PKT_SIZE;
+	pkts[XSK_DESC__MAX_FRAGS + 2].valid = true;
+
+	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
+	return testapp_validate_traffic(test);
+}
+
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->xdp_progs = xsk_xdp_progs__open_and_load();
@@ -2160,6 +2194,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		test->mtu = MAX_ETH_JUMBO_SIZE;
 		ret = testapp_xdp_metadata_count(test);
 		break;
+	case TEST_TYPE_TOO_MANY_FRAGS:
+		ret = testapp_too_many_frags(test);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 786c2dfab7a6..bb9d36a7e544 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -53,6 +53,7 @@
 #define XSK_UMEM__LARGE_FRAME_SIZE (3 * 1024)
 #define XSK_UMEM__MAX_FRAME_SIZE (4 * 1024)
 #define XSK_DESC__INVALID_OPTION (0xffff)
+#define XSK_DESC__MAX_FRAGS 17
 #define HUGEPAGE_SIZE (2 * 1024 * 1024)
 #define PKT_DUMP_NB_TO_PRINT 16
 
@@ -93,6 +94,7 @@ enum test_type {
 	TEST_TYPE_UNALIGNED_MB,
 	TEST_TYPE_ALIGNED_INV_DESC_MB,
 	TEST_TYPE_UNALIGNED_INV_DESC_MB,
+	TEST_TYPE_TOO_MANY_FRAGS,
 	TEST_TYPE_MAX
 };
 
-- 
2.35.3


