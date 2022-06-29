Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B148956032C
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbiF2Ofc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232419AbiF2Of2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:35:28 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD38432EE9;
        Wed, 29 Jun 2022 07:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656513327; x=1688049327;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W1CDd87SLyk4CEbSClgzi5L1h06xJSabtYnCcq28xMY=;
  b=Af1LeHydnO0EWU4duXupG0uZ2Ir+Wi997RDRIsO5Th+ONoKuCgU+Gpui
   L+/zO/+CnBelzi6+DF+QO8oYPHaZHglU0cF2Xb4ThMyVkcNqYSL/xa6Hf
   wuCpRr4O0NxwAH5wC9R5X1H2+s6rDTQzy2aQuHt5Cy7qHTWsctk+KU4au
   uLBR5786h5atsvpjk7NKXxQz37v2xvZaOAEGPen8yfMcOxGYxMvZPZjMG
   eQrBwpKc5FW2AVwWHAuDy0CnaQnziyyHCEsw1ykkRAU/Wb3RdR83eMcz9
   9XyFvetFX6fEAbrZcsAmKKNBmet55obGct/nEQuUeUsUvMvmvBB19oDUg
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="368357943"
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="368357943"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2022 07:35:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,231,1650956400"; 
   d="scan'208";a="590765166"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 29 Jun 2022 07:35:25 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 3/4] selftests: xsk: verify correctness of XDP prog attach point
Date:   Wed, 29 Jun 2022 16:34:57 +0200
Message-Id: <20220629143458.934337-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To prevent the case we had previously where for TEST_MODE_SKB, XDP prog
was attached in native mode, call bpf_xdp_query() after loading prog and
make sure that attach_mode is as expected.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index c024aa91ea02..4c425a43e5b0 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1085,6 +1085,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 {
 	u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
 	int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
+	LIBBPF_OPTS(bpf_xdp_query_opts, opts);
 	int ret, ifindex;
 	void *bufs;
 	u32 i;
@@ -1134,6 +1135,22 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
 	if (ret)
 		exit_with_error(-ret);
 
+	ret = bpf_xdp_query(ifindex, ifobject->xdp_flags, &opts);
+	if (ret)
+		exit_with_error(-ret);
+
+	if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
+		if (opts.attach_mode != XDP_ATTACHED_SKB) {
+			ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
+			exit_with_error(-EINVAL);
+		}
+	} else if (ifobject->xdp_flags & XDP_FLAGS_DRV_MODE) {
+		if (opts.attach_mode != XDP_ATTACHED_DRV) {
+			ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
+			exit_with_error(-EINVAL);
+		}
+	}
+
 	ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
 	if (ret)
 		exit_with_error(-ret);
-- 
2.27.0

