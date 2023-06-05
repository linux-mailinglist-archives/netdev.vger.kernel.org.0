Return-Path: <netdev+bounces-8072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF5A17229EA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:55:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A735B281363
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:55:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 353A124EA6;
	Mon,  5 Jun 2023 14:45:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2685924EA5;
	Mon,  5 Jun 2023 14:45:58 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB75E9;
	Mon,  5 Jun 2023 07:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976352; x=1717512352;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E1PpbianqSaWVZC27oWXUG587TT/6DzcPC2h5xUUaHU=;
  b=coHZEsns7A5V11o855RwZaIndfhG9hIGObG08rvGMzTanxKh7ZVS/NIT
   MePGzDFK06hSYSiqfrGkqfce4TXNXgZJKFUQXSMzY9ng4YgnTfjlmpbQE
   H/8ZfsQjG52ZokFKcsbYNzKAIx4kX6lDlbCvd2kt3HmPzXL5uFUtCf/bg
   jRaXh8ZQlPAlJPlSskeN7wFP8TNBdxtVXD4cmiwsclQXJ9D58Vg8VpzPS
   YbuLFhWLjXRk2gi8qx10nANB1R8AMMEicXHLh+LltMqHP72gAzleWaMXW
   q/mCaX8C2LB8W9USPGZb/6lXlQ+OpDv8ohP/HncMNKl0BHuHplEMy1VR1
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442758081"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442758081"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:45:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798464470"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798464470"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 07:45:49 -0700
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
	simon.horman@corigine.com
Subject: [PATCH v3 bpf-next 21/22] selftests/xsk: add test for too many frags
Date: Mon,  5 Jun 2023 16:44:32 +0200
Message-Id: <20230605144433.290114-22-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
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

Add a test for testing that a packet consisting of more than 18 frags
is discarded. This is only valid for SKB and DRV mode since in
zero-copy mode, this limit is up to the HW and what it supports.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 40 ++++++++++++++++++++++++
 tools/testing/selftests/bpf/xskxceiver.h |  2 ++
 2 files changed, 42 insertions(+)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 848f48bb83e4..f5eed27759df 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1982,6 +1982,43 @@ static int testapp_poll_rxq_tmout(struct test_spec *test)
 	return testapp_validate_traffic_single_thread(test, test->ifobj_rx);
 }
 
+static int testapp_too_many_frags(struct test_spec *test)
+{
+	struct pkt pkts[2 * XSK_DESC__MAX_FRAGS + 2] = {};
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
+	/* Produce two longs packets below out of this */
+	for (i = 1; i < 2 * XSK_DESC__MAX_FRAGS + 1; i++) {
+		pkts[i].len = MIN_PKT_SIZE;
+		pkts[i].options = XDP_PKT_CONTD;
+		pkts[i].valid = true;
+	}
+	/* 1st packet: Produce the highest amount of frags possible */
+	pkts[XSK_DESC__MAX_FRAGS].options = 0;
+	/* 2nd packet: Do not signal end-of-packet in the 17th frag. This is not legal. */
+	pkts[2 * XSK_DESC__MAX_FRAGS].valid = false;
+
+	/* Valid packet for synch */
+	pkts[2 * XSK_DESC__MAX_FRAGS + 1].len = MIN_PKT_SIZE;
+	pkts[2 * XSK_DESC__MAX_FRAGS + 1].valid = true;
+
+	pkt_stream_generate_custom(test, pkts, ARRAY_SIZE(pkts));
+	return testapp_validate_traffic(test);
+}
+
 static int xsk_load_xdp_programs(struct ifobject *ifobj)
 {
 	ifobj->xdp_progs = xsk_xdp_progs__open_and_load();
@@ -2169,6 +2206,9 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
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
index 9e1f66e0a3b6..0621b6fb8fb3 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -53,6 +53,7 @@
 #define XSK_UMEM__LARGE_FRAME_SIZE (3 * 1024)
 #define XSK_UMEM__MAX_FRAME_SIZE (4 * 1024)
 #define XSK_DESC__INVALID_OPTION (0xffff)
+#define XSK_DESC__MAX_FRAGS 18
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
2.34.1


