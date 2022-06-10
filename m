Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90941546927
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 17:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242350AbiFJPKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 11:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344944AbiFJPKB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 11:10:01 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C26E181579;
        Fri, 10 Jun 2022 08:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654873800; x=1686409800;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YdrgKEfIYdsKim+IyiK5k8ucFOUHTdtHGlBpns4/YUY=;
  b=PqasHdxWk7joEn44XEPQMwOiHOYxKtv0lGa6ps463QYJN2/UiEfFqdmA
   6UUamn6RrmEmaBeZX1ptmlC7oPPNwCwmwmqJLRDMvJVGIMS9E+OAXSoLB
   1V0eTWWCsXNCijevrMeEX16oZmKhRqmMhfGxJ9mF0NJDCH8HAlZ8zatNv
   cVWKQz3nInf3vm70Ocwu3Vqvhzim5bdr+RR4cvIF1Qcshlx6OOTZIrmoJ
   dnbwWcu5xmdOnIcaKAsOazeMqmL8hi6V1eeoTZjG3z7LcYcsxLJReczk4
   AX7IMxMreiwDhqIF/17LKKF5IVRYd6SdW4E8+y5AqYMZNntrToC7nfz3a
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="278788482"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="278788482"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 08:10:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638176260"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga008.fm.intel.com with ESMTP; 10 Jun 2022 08:09:58 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 09/10] selftests: xsk: remove struct xsk_socket_info::outstanding_tx
Date:   Fri, 10 Jun 2022 17:09:22 +0200
Message-Id: <20220610150923.583202-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
References: <20220610150923.583202-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous change makes xsk->outstanding_tx a dead code, so let's remove
it.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 20 +++-----------------
 tools/testing/selftests/bpf/xdpxceiver.h |  1 -
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index c9385690af09..a2aa652d0bb8 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -815,7 +815,7 @@ static void kick_rx(struct xsk_socket_info *xsk)
 		exit_with_error(errno);
 }
 
-static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
+static void complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 {
 	unsigned int rcvd;
 	u32 idx;
@@ -824,20 +824,8 @@ static int complete_pkts(struct xsk_socket_info *xsk, int batch_size)
 		kick_tx(xsk);
 
 	rcvd = xsk_ring_cons__peek(&xsk->umem->cq, batch_size, &idx);
-	if (rcvd) {
-		if (rcvd > xsk->outstanding_tx) {
-			u64 addr = *xsk_ring_cons__comp_addr(&xsk->umem->cq, idx + rcvd - 1);
-
-			ksft_print_msg("[%s] Too many packets completed\n", __func__);
-			ksft_print_msg("Last completion address: %llx\n", addr);
-			return TEST_FAILURE;
-		}
-
+	if (rcvd)
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
-		xsk->outstanding_tx -= rcvd;
-	}
-
-	return TEST_PASS;
 }
 
 static int receive_pkts(struct ifobject *ifobj, struct pollfd *fds)
@@ -955,9 +943,7 @@ static int __send_pkts(struct ifobject *ifobject, u32 *pkt_nb)
 	pthread_mutex_unlock(&pacing_mutex);
 
 	xsk_ring_prod__submit(&xsk->tx, i);
-	xsk->outstanding_tx += valid_pkts;
-	if (complete_pkts(xsk, i))
-		return TEST_FAILURE;
+	complete_pkts(xsk, i);
 
 	usleep(10);
 	return TEST_PASS;
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index f364a92675f8..12b792004163 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -104,7 +104,6 @@ struct xsk_socket_info {
 	struct xsk_ring_prod tx;
 	struct xsk_umem_info *umem;
 	struct xsk_socket *xsk;
-	u32 outstanding_tx;
 	u32 rxqsize;
 };
 
-- 
2.27.0

