Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABC34794CA
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbhLQTcR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:32:17 -0500
Received: from mga01.intel.com ([192.55.52.88]:11893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240636AbhLQTcQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:32:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639769536; x=1671305536;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Asnr9C3rtJ1yxCwhycrfdfNm6aHEMncqw36oi8G+ikk=;
  b=PbD0xMFzu9LjUGqn2gbRys3iWCpY94QqSN9ybnQxYY+oMLT+usCUT/Jp
   P4dMtYFFcu5LPIhfmfFr1QK/tDXKZBUt08s9yjrVjfFv9ikl6L+NwwHdN
   QUI6k3apdCDi526TLiDY24RQUgVkX+3rQmwlVhoeR9tf7sbcYgHPMzaqx
   PMnNXdSRu1FoQkackVXLnCkMRm5AfToyIuLcOjTmZmN42RnI0j6Dgd5AE
   E+YaEIxrd/pmn0lmAIlWQeIjwq/zJnbdmERguYwDUMYO7uXkZz8suBmo1
   eoSqE0FUJDF7dWSC9FTSPFu6pxSG0SQ3ZtjtdYkJK2baxOpM9sG18ilpx
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="263998120"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="263998120"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 11:32:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="754659446"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2021 11:32:12 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 1/6] ice: xsk: return xsk buffers back to pool when cleaning the ring
Date:   Fri, 17 Dec 2021 11:31:09 -0800
Message-Id: <20211217193114.392106-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
References: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
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
2.31.1

