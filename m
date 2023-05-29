Return-Path: <netdev+bounces-6129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA99C714DAF
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6DCA5280E5D
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A289F134C8;
	Mon, 29 May 2023 15:51:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A46134B4;
	Mon, 29 May 2023 15:51:18 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFBBA3;
	Mon, 29 May 2023 08:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375477; x=1716911477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JEcwyDi2S/o9tBSXLAY7AqTGgMfcnOLSTWP8FSJ2hp4=;
  b=nw9B6d+waK3Bnuee2jsVJ2tXZG1t9dnkYVpH9Gs/TtB6b33jR6q6ioUg
   9CAJe0m6CDdNmLovlifvXJsX/rU3XtutkATcllExhlizjW6Ie55Mp3u/j
   35843DjGZUFOXD6WZOWsBhBG7ivEe8NlXbyzisIChgMT4xQ/zoaegQDpe
   9julaSe4rwaDCeb+ILFdvZoLwR/uyi/fQwfeVeD7jB/DYF8PnD067Vlu2
   ruLDsKTVGI8KhZfyIJHGksXdOZiINKrJxA4g09PXMi0LWaknZu1h4gENB
   h2UP6g3aze3byo5aHra8BdDYOAoAjYYpnlcTTwslCPj2yHcLPjw5i38R6
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344229092"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344229092"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:51:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441259"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441259"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:51:14 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com
Subject: [PATCH v2 bpf-next 20/22] selftests/xsk: add metadata copy test for multi-buff
Date: Mon, 29 May 2023 17:50:22 +0200
Message-Id: <20230529155024.222213-21-maciej.fijalkowski@intel.com>
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
index 1e1e9422ca0a..658e978053d4 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -1942,7 +1942,6 @@ static int testapp_xdp_metadata_count(struct test_spec *test)
 	int count = 0;
 	int key = 0;
 
-	test_spec_set_name(test, "XDP_METADATA_COUNT");
 	test_spec_set_xdp_prog(test, skel_rx->progs.xsk_xdp_populate_metadata,
 			       skel_tx->progs.xsk_xdp_populate_metadata,
 			       skel_rx->maps.xsk, skel_tx->maps.xsk);
@@ -2153,6 +2152,12 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
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
index de781357ea15..786c2dfab7a6 100644
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
2.35.3


