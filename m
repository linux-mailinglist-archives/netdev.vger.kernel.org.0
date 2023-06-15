Return-Path: <netdev+bounces-11209-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCE0731F3D
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:35:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBAE32815A7
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:35:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83FE61EA9D;
	Thu, 15 Jun 2023 17:27:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711271EA99;
	Thu, 15 Jun 2023 17:27:21 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9712719;
	Thu, 15 Jun 2023 10:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850037; x=1718386037;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NcZQUaESYqjPKfpbAl4otD295VcCvV+24eiZ0HVvv0U=;
  b=inaYm9nnvF2Lyu5zR1MmhyS/Ptm5LA3Q9CGVOCRbiea1upw8IVJZKXS7
   pGXVHMUU3KrbyN8oKyNtzT+6YDtQhD1h52OLBvqO9SiEthd34Xi+TXdkd
   PPtLx6ZuRbf2mi8pO4BblSWwuUavd6I5YrXbgG3sIw1f8nPLPStRkXkWG
   DPXy4GBVVVtcY+dlveidfdYYuRV9Sb9z+jMPWqfRb8MNcXYxHvAonkwWt
   muMk5XUP9UNoG+fnC7XI0QhsC/cMu2THXWDe3FYngT8tsCeHfnkOauGJY
   31NbYXt+FFoUzoU73elgZI0ORjkwTWya0Xsdi8Q5Ewmp6Qm/ag0tNP8HN
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358983710"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358983710"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:27:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689859010"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689859010"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 10:27:12 -0700
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
Subject: [PATCH v4 bpf-next 20/22] selftests/xsk: add metadata copy test for multi-buff
Date: Thu, 15 Jun 2023 19:26:04 +0200
Message-Id: <20230615172606.349557-21-maciej.fijalkowski@intel.com>
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


