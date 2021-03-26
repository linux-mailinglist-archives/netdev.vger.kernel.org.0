Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A881B34B2EB
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhCZXVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:21:46 -0400
Received: from mga14.intel.com ([192.55.52.115]:11392 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231296AbhCZXVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:21:37 -0400
IronPort-SDR: a9WG2us0RHnM/GrNWxGQED5Emju9QllCFInd8ORVyT+slFGSMEddxHrAJUJ7PnEczcgNKwEt6I
 Y8p9pTLJVlEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9935"; a="190681416"
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="190681416"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2021 16:21:02 -0700
IronPort-SDR: DFwecH82jq0IDkiSl3fSgU1glq7vNxOrEGAGO/4jDKxKQpCGxZ9ZGS3kasqJD1enwY16koTBuI
 1JhlBS5ckEyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,281,1610438400"; 
   d="scan'208";a="410113170"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 26 Mar 2021 16:21:00 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v4 bpf-next 01/17] selftests: xsk: don't call worker_pkt_dump() for stats test
Date:   Sat, 27 Mar 2021 00:09:22 +0100
Message-Id: <20210326230938.49998-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
References: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
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

