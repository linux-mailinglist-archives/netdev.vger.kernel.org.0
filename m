Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24C565A65C3
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 15:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiH3N5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 09:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiH3N5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 09:57:02 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04553F997C;
        Tue, 30 Aug 2022 06:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661867783; x=1693403783;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rCf3ipGPR28oxh+IyQOvLYEhKUzl8GL1Fn8JO9qx4d0=;
  b=KW+bRkkoF0NWYFjwmS5nEENyMw5DP2ZC6Ccjc1zUpBcKLGfSzTW1YJSY
   YyaPgf1EzEhHEZGVPIeifK1T1A7d49/9FO6TQJrodfyZUnpLv97C+JzgR
   rxNSmFR4YNMqs6H28MrNvGtiVAAcNsFYOvS854Yfoxt7aWLwlZ3hCqXvL
   gG/H9ysKc6AhxHoLXGryHXaGLgVlXZpzgPHU9QLK5i5jXoCySwpuAVnX7
   4OGE2B5D6h/m7g7+Ej0IFOfIPJ3yhO1KO3bMlr0sBMkgv0WgY5nlICkcQ
   Hq6QQOHPJBSxX3xhDTOXCgDxA1eGcJ0KrW+taX6bW/u0pS8ikpsozzvrI
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="295180359"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="295180359"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 06:56:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="562651305"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga003.jf.intel.com with ESMTP; 30 Aug 2022 06:56:21 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 bpf-next 1/6] selftests: xsk: query for native XDP support
Date:   Tue, 30 Aug 2022 15:55:59 +0200
Message-Id: <20220830135604.10173-2-maciej.fijalkowski@intel.com>
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

Currently, xskxceiver assumes that underlying device supports XDP in
native mode - it is fine by now since tests can run only on a veth pair.
Future commit is going to allow running test suite against physical
devices, so let us query the device if it is capable of running XDP
programs in native mode. This way xskxceiver will not try to run
TEST_MODE_DRV if device being tested is not supporting it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xskxceiver.c | 39 ++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xskxceiver.c b/tools/testing/selftests/bpf/xskxceiver.c
index a07f120c5f75..d64652558d12 100644
--- a/tools/testing/selftests/bpf/xskxceiver.c
+++ b/tools/testing/selftests/bpf/xskxceiver.c
@@ -99,6 +99,8 @@
 #include <stdatomic.h>
 #include "xsk.h"
 #include "xskxceiver.h"
+#include <bpf/bpf.h>
+#include <linux/filter.h>
 #include "../kselftest.h"
 
 /* AF_XDP APIs were moved into libxdp and marked as deprecated in libbpf.
@@ -1716,10 +1718,40 @@ static void ifobject_delete(struct ifobject *ifobj)
 	free(ifobj);
 }
 
+static bool is_xdp_supported(struct ifobject *ifobject)
+{
+	int flags = XDP_FLAGS_DRV_MODE;
+
+	LIBBPF_OPTS(bpf_link_create_opts, opts, .flags = flags);
+	struct bpf_insn insns[2] = {
+		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
+		BPF_EXIT_INSN()
+	};
+	int ifindex = if_nametoindex(ifobject->ifname);
+	int prog_fd, insn_cnt = ARRAY_SIZE(insns);
+	int err;
+
+	prog_fd = bpf_prog_load(BPF_PROG_TYPE_XDP, NULL, "GPL", insns, insn_cnt, NULL);
+	if (prog_fd < 0)
+		return false;
+
+	err = bpf_xdp_attach(ifindex, prog_fd, flags, NULL);
+	if (err) {
+		close(prog_fd);
+		return false;
+	}
+
+	bpf_xdp_detach(ifindex, flags, NULL);
+	close(prog_fd);
+
+	return true;
+}
+
 int main(int argc, char **argv)
 {
 	struct pkt_stream *pkt_stream_default;
 	struct ifobject *ifobj_tx, *ifobj_rx;
+	int modes = TEST_MODE_SKB + 1;
 	u32 i, j, failed_tests = 0;
 	struct test_spec test;
 
@@ -1747,15 +1779,18 @@ int main(int argc, char **argv)
 	init_iface(ifobj_rx, MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1,
 		   worker_testapp_validate_rx);
 
+	if (is_xdp_supported(ifobj_tx))
+		modes++;
+
 	test_spec_init(&test, ifobj_tx, ifobj_rx, 0);
 	pkt_stream_default = pkt_stream_generate(ifobj_tx->umem, DEFAULT_PKT_CNT, PKT_SIZE);
 	if (!pkt_stream_default)
 		exit_with_error(ENOMEM);
 	test.pkt_stream_default = pkt_stream_default;
 
-	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
+	ksft_set_plan(modes * TEST_TYPE_MAX);
 
-	for (i = 0; i < TEST_MODE_MAX; i++)
+	for (i = 0; i < modes; i++)
 		for (j = 0; j < TEST_TYPE_MAX; j++) {
 			test_spec_init(&test, ifobj_tx, ifobj_rx, i);
 			run_pkt_test(&test, i, j);
-- 
2.34.1

