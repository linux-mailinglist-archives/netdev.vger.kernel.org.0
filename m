Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44AB454690
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 13:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236773AbhKQMsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 07:48:08 -0500
Received: from mga18.intel.com ([134.134.136.126]:47392 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232278AbhKQMsH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 07:48:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="220824909"
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="220824909"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 04:45:08 -0800
X-IronPort-AV: E=Sophos;i="5.87,241,1631602800"; 
   d="scan'208";a="536267480"
Received: from unknown (HELO paamrpdk12-S2600BPB.aw.intel.com) ([10.228.151.193])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2021 04:45:08 -0800
From:   Tirthendu Sarkar <tirthendu.sarkar@intel.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next] selftests/bpf: fix xdpxceiver failures for no hugepages
Date:   Wed, 17 Nov 2021 18:06:13 +0530
Message-Id: <20211117123613.22288-1-tirthendu.sarkar@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xsk_configure_umem() needs hugepages to work in unaligned mode. So when
hugepages are not configured, 'unaligned' tests should be skipped which
is determined by the helper function hugepages_present(). This function
erroneously returns true with MAP_NORESERVE flag even when no hugepages
are configured. The removal of this flag fixes the issue.

The test TEST_TYPE_UNALIGNED_INV_DESC also needs to be skipped when
there are no hugepages. However, this was not skipped as there was no
check for presence of hugepages and hence was failing. The check to skip
the test has now been added.

Fixes: a4ba98dd0c693 (selftests: xsk: Add test for unaligned mode)
Signed-off-by: Tirthendu Sarkar tirthendu.sarkar@intel.com
---
 tools/testing/selftests/bpf/xdpxceiver.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index fe7f423b8c3f..040164c7efc1 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -1217,7 +1217,7 @@ static bool hugepages_present(struct ifobject *ifobject)
 	void *bufs;
 
 	bufs = mmap(NULL, mmap_sz, PROT_READ | PROT_WRITE,
-		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE | MAP_HUGETLB, -1, 0);
+		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
 	if (bufs == MAP_FAILED)
 		return false;
 
@@ -1364,6 +1364,10 @@ static void run_pkt_test(struct test_spec *test, enum test_mode mode, enum test_
 		testapp_invalid_desc(test);
 		break;
 	case TEST_TYPE_UNALIGNED_INV_DESC:
+		if (!hugepages_present(test->ifobj_tx)) {
+			ksft_test_result_skip("No 2M huge pages present.\n");
+			return;
+		}
 		test_spec_set_name(test, "UNALIGNED_INV_DESC");
 		test->ifobj_tx->umem->unaligned_mode = true;
 		test->ifobj_rx->umem->unaligned_mode = true;
-- 
2.25.1

