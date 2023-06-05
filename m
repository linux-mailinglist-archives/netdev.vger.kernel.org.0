Return-Path: <netdev+bounces-8071-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBB07229DF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:54:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85D25281367
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:54:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1342B24157;
	Mon,  5 Jun 2023 14:45:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE10024152;
	Mon,  5 Jun 2023 14:45:56 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7E1100;
	Mon,  5 Jun 2023 07:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976349; x=1717512349;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NcZQUaESYqjPKfpbAl4otD295VcCvV+24eiZ0HVvv0U=;
  b=mXSm/cRyngeXi+GyIdBg4rxIUaZ9pdiGCEOtL+Ww2iu9Hx91PC5dVUk5
   V8A3s2LvBjQLhxYbvTcc8Vg8EDh9G2WeHhZ2CqLSOSD9tsMKGMKPt5bRn
   OwtmiGSrmNnWl1F3wmmKCgEtFSMxq8UPNFzGo2C7KsAl3Dfq8GR7RfjYG
   eAB24SJakJa7YyqRV+OK9621cKKVvz9C7+E8NxqHLlrqF+4DDdLoJRND+
   UbyIvjByUtB1AKmStTpqKEQs3G376opK+1+kQyHRQbbioEVGngzYFWS01
   +0Bcty794U63C+GXRrPnOtxs2wzNoSdRN6kR5CtM/jLq+XX1v7QyyR4h/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442758061"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442758061"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:45:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798464443"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798464443"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 07:45:46 -0700
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
Subject: [PATCH v3 bpf-next 20/22] selftests/xsk: add metadata copy test for multi-buff
Date: Mon,  5 Jun 2023 16:44:31 +0200
Message-Id: <20230605144433.290114-21-maciej.fijalkowski@intel.com>
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

Enable the already existing metadata copy test to also run in
multi-buffer mode with 9K packets.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/progs/xsk_xdp_progs.c | 2 +-
 tools/testing/selftests/bpf/xskxceiver.c          | 7 ++++++-
 tools/testing/selftests/bpf/xskxceiver.h          | 1 +
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
index ac76e7363776..24369f242853 100644
--- a/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
+++ b/tools/testing/selftests/bpf/progs/xsk_xdp_progs.c
@@ -29,7 +29,7 @@ SEC("xdp.frags") int xsk_xdp_drop(struct xdp_md *xdp)
 	return bpf_redirect_map(&xsk, 0, XDP_DROP);
 }
 
-SEC("xdp") int xsk_xdp_populate_metadata(struct xdp_md *xdp)
+SEC("xdp.frags") int xsk_xdp_populate_metadata(struct xdp_md *xdp)
 {
 	void *data, *data_meta;
 	struct xdp_info *meta;
diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index 090f2cff1590..848f48bb83e4 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1949,7 +1949,6 @@ static int testapp_xdp_metadata_count(struct test_spec *test)
 	int count = 0;
 	int key = 0;
 
-	test_spec_set_name(test, "XDP_METADATA_COUNT");
 	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_populate_metadata,
 			       skel_tx->progs.xsk_xdp_populate_metadata,
 			       skel_rx->maps.xsk, skel_tx->maps.xsk);
@@ -2162,6 +2161,12 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		ret = testapp_xdp_drop(test);
 		break;
 	case TEST_TYPE_XDP_METADATA_COUNT:
+		test_spec_set_name(test, "XDP_METADATA_COUNT");
+		ret = testapp_xdp_metadata_count(test);
+		break;
+	case TEST_TYPE_XDP_METADATA_COUNT_MB:
+		test_spec_set_name(test, "XDP_METADATA_COUNT_MULTI_BUFF");
+		test->mtu = MAX_ETH_JUMBO_SIZE;
 		ret = testapp_xdp_metadata_count(test);
 		break;
 	default:
diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
index 7140943410de..9e1f66e0a3b6 100644
--- a/tools/testing/selftests/bpf/xskxceiver.h
+++ b/tools/testing/selftests/bpf/xskxceiver.h
@@ -88,6 +88,7 @@ enum test_type {
 	TEST_TYPE_BPF_RES,
 	TEST_TYPE_XDP_DROP_HALF,
 	TEST_TYPE_XDP_METADATA_COUNT,
+	TEST_TYPE_XDP_METADATA_COUNT_MB,
 	TEST_TYPE_RUN_TO_COMPLETION_MB,
 	TEST_TYPE_UNALIGNED_MB,
 	TEST_TYPE_ALIGNED_INV_DESC_MB,
-- 
2.34.1


