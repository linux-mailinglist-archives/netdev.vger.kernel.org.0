Return-Path: <netdev+bounces-11207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B79C6731F30
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:34:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E85F71C20F13
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:34:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FB71DDD0;
	Thu, 15 Jun 2023 17:27:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ECD1DDCD;
	Thu, 15 Jun 2023 17:27:17 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6892724;
	Thu, 15 Jun 2023 10:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850031; x=1718386031;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IqcthntQ1brNatFRgwkw8KX9jcM7Jrf6smtNPjHRfjo=;
  b=H5J97FYxaxMifY8rzdbozX+q1bo2cKM/hCYAzrBlyRx+ZFdYuKvRVzOG
   p1dzjRZyoq3JZuararBwEHeHVntWznESZf5VUpSDGij6JCY7ZW8TpFSzw
   Q01jNxPGsPbrM4xAcecrjJHcargsiVCefGXI2vcWgGq8uXLwkOQILaAHA
   oHu+K2DnnVUIJJy5rDsWZrXClCLJ4Y26mW7WKEIDPiA5Ctyvyf7dc4Xxv
   ra2hyHp8Gj8+x/hxo7kpWw3NNWFMGUET3dIV1JkzEM2ZM7w/8ziM1l10W
   RfgWIuPwy1zLRw5CLt90RHstWjs1DOITJAP7WKxs6Y/tkLD6MLfd4hr8D
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358983674"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358983674"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:27:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689858920"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689858920"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 10:27:06 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	simon.horman@corigine.com,
	toke@kernel.org
Subject: [PATCH v4 bpf-next 18/22] selftests/xsk: add unaligned mode test for multi-buffer
Date: Thu, 15 Jun 2023 19:26:02 +0200
Message-Id: <20230615172606.349557-19-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
References: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
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
index a6a148d1d78f..457f7058b523 100644
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
@@ -1761,6 +1763,16 @@ static int testapp_unaligned(struct test_spec *test)
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
@@ -2037,6 +2049,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
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
index cfc7c572fd2c..48cb48f1c5e6 100644
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
2.34.1


