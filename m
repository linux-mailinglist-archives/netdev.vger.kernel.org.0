Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6BEE470354
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242403AbhLJPDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:03:31 -0500
Received: from mga04.intel.com ([192.55.52.120]:14344 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231735AbhLJPDa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Dec 2021 10:03:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639148396; x=1670684396;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yViGtc+V2Swh9rosOnVjkOgVuHR/Y4/lbaI9ptPTU+s=;
  b=cHoO5r9mgO6UUxpDnGJS1Qbxg6hHPoyHmt/eN8AMIdjhujrFrWPKdFXd
   z6edi6DT1NYKfQkmANklK0s+oMC+/hr8MtDJHqT7K5MfgDz8CKWdYke1E
   6uawxkhUUw3orbh2rFx2l8SKEc4UDBTjrAaP6hhPt9o2xOByoqqzDiMQs
   IUB58v6fFf40KJlaJrFWys+O86wMZ5M9NCvC2LDHUeceS2cOfOeg9/its
   CM3QbDBdj6etgCxdHqwf9DkFg0BOUg5FhwOx1eYsMu4pa3J2s01c98k11
   ClNhwCfWvhUKvpzTGak05tq35aiorCXG5XM+FSnPRXlXQQv1kHelKpxul
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10193"; a="237093265"
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="237093265"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2021 06:59:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,195,1635231600"; 
   d="scan'208";a="680763736"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 10 Dec 2021 06:59:53 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 3/5] ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
Date:   Fri, 10 Dec 2021 15:59:39 +0100
Message-Id: <20211210145941.5865-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211210145941.5865-1-maciej.fijalkowski@intel.com>
References: <20211210145941.5865-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The descriptor that ntu is pointing at when we exit
ice_alloc_rx_bufs_zc() should not have its corresponding DD bit cleared
as descriptor is not allocated in there and it is not valid for HW
usage.

The allocation routine at the entry will fill the descriptor that ntu
points to after it was set to ntu + nb_buffs on previous call.

Even the spec says:
"The tail pointer should be set to one descriptor beyond the last empty
descriptor in host descriptor ring."

Therefore, step away from clearing the status_error0 on ntu + nb_buffs
descriptor.

Fixes: db804cfc21e9 ("ice: Use the xsk batched rx allocation interface")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 5cb61955c1f3..874fce9fa1c3 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -394,14 +394,9 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	}
 
 	ntu += nb_buffs;
-	if (ntu == rx_ring->count) {
-		rx_desc = ICE_RX_DESC(rx_ring, 0);
-		xdp = rx_ring->xdp_buf;
+	if (ntu == rx_ring->count)
 		ntu = 0;
-	}
 
-	/* clear the status bits for the next_to_use descriptor */
-	rx_desc->wb.status_error0 = 0;
 	ice_release_rx_desc(rx_ring, ntu);
 
 	return count == nb_buffs;
-- 
2.33.1

