Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD2333781B
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhCKPlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:41:25 -0500
Received: from mga06.intel.com ([134.134.136.31]:60959 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhCKPlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:02 -0500
IronPort-SDR: Ak0D2Evfd44BOx0YzYtCEWj7EbakLfYKIBjDTjc6OgCVAun1EEKkg1KCNATK2SxGvzxeTocJiO
 t9u2ICw7KSXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="250048421"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="250048421"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:02 -0800
IronPort-SDR: G4aaYju0x/ptGFSEGWFNz3eWtChUIPaYsS3coNeoZ9EFOG1zm6451d/4poDGl3CF+BTgdkp6E1
 YGev1dnB5EHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253420"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:41:00 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 01/17] selftests: xsk: don't call worker_pkt_dump() for stats test
Date:   Thu, 11 Mar 2021 16:28:54 +0100
Message-Id: <20210311152910.56760-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For TEST_TYPE_STATS, worker_pkt_validate() that places frames onto
pkt_buf is not called. Therefore, when dump mode is set, don't call
worker_pkt_dump() for mentioned test type, so that it won't crash on
pkt_buf() access.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 8b0f7fdd9003..04574c2b4f41 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -999,7 +999,7 @@ static void testapp_validate(void)
 	pthread_join(t1, NULL);
 	pthread_join(t0, NULL);
 
-	if (debug_pkt_dump) {
+	if (debug_pkt_dump && test_type != TEST_TYPE_STATS) {
 		worker_pkt_dump();
 		for (int iter = 0; iter < num_frames - 1; iter++) {
 			free(pkt_buf[iter]->payload);
-- 
2.20.1

