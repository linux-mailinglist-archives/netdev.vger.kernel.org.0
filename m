Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6764B54CE29
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 18:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350692AbiFOQOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353659AbiFOQNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:13:44 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AA039684;
        Wed, 15 Jun 2022 09:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655309594; x=1686845594;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/JO16V/AXkkPcbAJE2CdoB0/uUAQIHrV4zJ+rrY4VL0=;
  b=ZFy3lLaedsUVWjnyvekSQvK/GfxzqfTgxJ3M3o46jRcvVLgh0rxWIJPg
   72RUeySz1WtS3+EUYRvMcqHubadnQe6zv7JfynzmnbrHTq6Tuw7t0VowX
   P8updFeiGShQx5fLEQvUrTzDItqlESHyCXi3d2V1QXDppHLSrW4vQj2h+
   E1bfhA/XrcEuj0mYI+wgYtKckhST7XxKO8gPKasyx/LVYPqrPf7pEKEtU
   GPzUs3thni1OsK6tLGdSf2ApM3+FIZhGt/izaKY3z9Vr1qYPvesatD+2u
   a0YhHboW6NNwHm7IcwEm+xhexcbYUvG3LNEwqcpHgcvUQrnMLoBo4UDlQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280050163"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280050163"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 09:11:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="713005325"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 15 Jun 2022 09:11:09 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 05/11] selftests: xsk: query for native XDP support
Date:   Wed, 15 Jun 2022 18:10:35 +0200
Message-Id: <20220615161041.902916-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
References: <20220615161041.902916-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, xdpxceiver assumes that underlying device supports XDP in
native mode - it is fine by now since tests can run only on a veth pair.
Future commit is going to allow running test suite against physical
devices, so let us query the device if it is capable of running XDP
programs in native mode. This way xdpxceiver will not try to run
TEST_MODE_DRV if device being tested is not supporting it.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 36 ++++++++++++++++++++++--
 1 file changed, 34 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index e5992a6b5e09..a1e410f6a5d8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -98,6 +98,8 @@
 #include <unistd.h>
 #include <stdatomic.h>
 #include <bpf/xsk.h>
+#include <bpf/bpf.h>
+#include <linux/filter.h>
 #include "xdpxceiver.h"
 #include "../kselftest.h"
 
@@ -1605,10 +1607,37 @@ static void ifobject_delete(struct ifobject *ifobj)
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
+	if (err)
+		return false;
+
+	bpf_xdp_detach(ifindex, flags, NULL);
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
 
@@ -1636,15 +1665,18 @@ int main(int argc, char **argv)
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
2.27.0

