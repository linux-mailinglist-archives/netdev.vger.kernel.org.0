Return-Path: <netdev+bounces-6127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6B4714DAA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 56A00280F62
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DC3612B78;
	Mon, 29 May 2023 15:51:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905E912B77;
	Mon, 29 May 2023 15:51:13 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E64C4;
	Mon, 29 May 2023 08:51:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375472; x=1716911472;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DjtwMP2aDBHMT1I9aUhD7mqXomqhz7U3PVtqcr9+d+s=;
  b=FjA+0Fl7/l+ntBxFFLNid08HElxW7FAXZeycDl9HrdVibzTZe7WGsDkm
   iHXkBvwN4weLDhWdIG1HhBExJzE2ayI3R6TADiDb1kRCc7bV8GLpWzHYI
   O0XsnZlNWmJZ6GmMMYemHHsu0gEXbVUq7sl6LLrjZwdD7o6PSGEGARIfc
   oXw0y5Wr4XTm/AgOcMiD6kJwOkL3TBSrYadtdnJKzY5l/EAYqp1gqiZQV
   XrUtZerJhsVgusBUwaQ/zrH0PbT1CjpIRfSTCgM5vJP3EcxaB5pv31UFx
   Ol/lrDYUvhEX6XuIzq7gT4Vs5gIv3elpQO65Q4MZQu2JedPZcuvFmN5Rg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344229072"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344229072"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:51:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441216"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441216"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:51:10 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH v2 bpf-next 18/22] selftests/xsk: add unaligned mode test for multi-buffer
Date: Mon, 29 May 2023 17:50:20 +0200
Message-Id: <20230529155024.222213-19-maciej.fijalkowski@intel.com>
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

Add a test for multi-buffer AF_XDP when using unaligned mode. The test
sends 4096 9K-buffers.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 15 +++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 41b8450561c9..8ad98eda90ad 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -50,6 +50,8 @@
  *       are discarded and let through, respectively.
  *    i. 2K frame size tests
  *    j. If multi-buffer is supported, send 9k packets divided into 3 frames
+ *    k. If multi-buffer and huge pages are supported, send 9k packets in a single frame
+ *       using unaligned mode
  *
  * Total tests: 12
  *
@@ -1754,6 +1756,16 @@ static int testapp_unaligned(struct test_spec *test)
 	return testapp_validate_traffic(test);
 }
 
+static int testapp_unaligned_mb(struct test_spec *test)
+{
+	test_spec_set_name(test, "UNALIGNED_MODE_9K");
+	test->mtu = MAX_ETH_JUMBO_SIZE;
+	test->ifobj_tx->umem->unaligned_mode = true;
+	test->ifobj_rx->umem->unaligned_mode = true;
+	pkt_stream_replace(test, DEFAULT_PKT_CNT, MAX_ETH_JUMBO_SIZE);
+	return testapp_validate_traffic(test);
+}
+
 static int testapp_single_pkt(struct test_spec *test)
 {
 	struct pkt pkts[] = {{0, MIN_PKT_SIZE, 0, true}};
@@ -2028,6 +2040,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 	case TEST_TYPE_UNALIGNED:
 		ret = testapp_unaligned(test);
 		break;
+	case TEST_TYPE_UNALIGNED_MB:
+		ret = testapp_unaligned_mb(test);
+		break;
 	case TEST_TYPE_HEADROOM:
 		ret = testapp_headroom(test);
 		break;
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index c2091b1512f5..42bde17e8d17 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -86,6 +86,7 @@ enum test_type {
 	TEST_TYPE_XDP_DROP_HALF,
 	TEST_TYPE_XDP_METADATA_COUNT,
 	TEST_TYPE_RUN_TO_COMPLETION_MB,
+	TEST_TYPE_UNALIGNED_MB,
 	TEST_TYPE_MAX
 };
 
-- 
2.35.3


