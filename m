Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553F934516C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhCVVJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:09:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:4961 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230159AbhCVVJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:01 -0400
IronPort-SDR: 572vpkkPWgwO0GMnA1dPrZwZwzn4z4Aq/dUmOHTJfo6EaMIoc9OcSGKgPhmGikIRDE31MQWtyP
 fVaVfbsgFVIA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423697"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423697"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:01 -0700
IronPort-SDR: QFgnW9SIyLJ4+u1F8SGaCHc82VA7dUhBfkOJLBsIN+7TZxgPdIfdyCPtrFJTTAm5vbhYwJxmrz
 VI/t/BI1B8YQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448735"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:08:59 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 01/17] selftests: xsk: don't call worker_pkt_dump() for stats test
Date:   Mon, 22 Mar 2021 21:58:00 +0100
Message-Id: <20210322205816.65159-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
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

