Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5444473080
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbhLMPba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:31:30 -0500
Received: from mga04.intel.com ([192.55.52.120]:4850 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235650AbhLMPb2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:31:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639409488; x=1670945488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ESk7lCQue1vgoFmWYSSeL0HGjoKRzv97ZtcUy95rvkM=;
  b=jS8M5KDEXdjcC9O6Y2URJ3oXImnSpNi9rOXdDRCrwCLrAjHufsTBd5f9
   S3vrlP9ZeiF7san4epCliG4PA1Z5uPbFD3e8TDCI8wXrfne47KeYkZBxh
   w1sOXLasL0qQdMtEJRoYKRU6sOUXTWAiPYS+m4IzELN1ok8Z+jZPYHJ8l
   /TUfVhlz2y0sb9WHwSv8jWb8T8m8iejtdTovk0DGii57p2p3Up2cl7RkT
   QD8PRNUTl4+R6d+0wxWBGiWJ4HaHlAKa//Y6VCFPsgqHYg1GSZdfq/80V
   m5b9qijrZT48bsuYIpmO+lMjC6UKL40Ko6YjIFKCuJ1LQSLpUx04odqw5
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237490481"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="237490481"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:31:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="613864714"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 07:31:22 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 1/6] ice: xsk: return xsk buffers back to pool when cleaning the ring
Date:   Mon, 13 Dec 2021 16:31:06 +0100
Message-Id: <20211213153111.110877-2-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently we only NULL the xdp_buff pointer in the internal SW ring but
we never give it back to the xsk buffer pool. This means that buffers
can be leaked out of the buff pool and never be used again.

Add missing xsk_buff_free() call to the routine that is supposed to
clean the entries that are left in the ring so that these buffers in the
umem can be used by other sockets.

Also, only go through the space that is actually left to be cleaned
instead of a whole ring.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index bb9a80847298..8593717a755e 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -811,14 +811,14 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
  */
 void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 {
-	u16 i;
-
-	for (i = 0; i < rx_ring->count; i++) {
-		struct xdp_buff **xdp = &rx_ring->xdp_buf[i];
+	u16 count_mask = rx_ring->count - 1;
+	u16 ntc = rx_ring->next_to_clean;
+	u16 ntu = rx_ring->next_to_use;
 
-		if (!xdp)
-			continue;
+	for ( ; ntc != ntu; ntc = (ntc + 1) & count_mask) {
+		struct xdp_buff **xdp = &rx_ring->xdp_buf[ntc];
 
+		xsk_buff_free(*xdp);
 		*xdp = NULL;
 	}
 }
-- 
2.33.1

