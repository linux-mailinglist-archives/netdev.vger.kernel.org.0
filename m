Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026C4794D4
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240671AbhLQTcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:32:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:11893 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240659AbhLQTcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:32:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639769537; x=1671305537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rBlTzRgRJlhKQT1R10dtuHTvIqzhXrK1mkNMLF92EC4=;
  b=g+Vz5sY2geAlC1MY4nZxnR67WVxCnEKPusXpzA2iNkgyTKDzSjCw1EY7
   bLG2rdXybwhTgyC819VRD/plytkb+J83J08XNGmvIyoaRtNgoIjPpFXiQ
   mRpZYcNxmczTKJJ0xGnkeCvGoLiCqeeDvAzapy3pzsq52ZlVwEeYMiA9A
   Ce7qaEisRivPtPdYJ0PcTujnyRqicEuQ8W7/ppr0Tj2OceDTubt2e3+0S
   GIlMFitM+oeV7f0ITK2RwAX+aO1ITBl//XRZ3CshAmwdNfDAtZlnYc3Ud
   drIAR4Et0jAARsFcao3h/KOuFOIMWk5Gb2/ql8PkE2s0Trbx+0G6wLbIb
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="263998132"
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="263998132"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 11:32:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,214,1635231600"; 
   d="scan'208";a="754659458"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 17 Dec 2021 11:32:13 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        Elza Mathew <elza.mathew@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 4/6] ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
Date:   Fri, 17 Dec 2021 11:31:12 -0800
Message-Id: <20211217193114.392106-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
References: <20211217193114.392106-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

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
Reported-by: Elza Mathew <elza.mathew@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 27f5f64dcbd6..ffa9a160766a 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -395,13 +395,9 @@ bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 	}
 
 	ntu += nb_buffs;
-	if (ntu == rx_ring->count) {
-		rx_desc = ICE_RX_DESC(rx_ring, 0);
+	if (ntu == rx_ring->count)
 		ntu = 0;
-	}
 
-	/* clear the status bits for the next_to_use descriptor */
-	rx_desc->wb.status_error0 = 0;
 	ice_release_rx_desc(rx_ring, ntu);
 
 	return count == nb_buffs;
-- 
2.31.1

