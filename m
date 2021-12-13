Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A279473085
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240127AbhLMPbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:31:36 -0500
Received: from mga04.intel.com ([192.55.52.120]:4850 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240110AbhLMPbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 10:31:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639409493; x=1670945493;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p3wfREPxIWyV7+YjRddZlswhnJ1Ba/ctyihpKflFrUU=;
  b=JAmYtu7pveWnY75PrAe80giJSvZuS9CmYIX0H/yVCjSt39A8VWfWHtaZ
   fdYMAe9bsT+dvtxflMWua5IJIJegqHRst++klt6tlwpOT9DcE/Wh4Z/0v
   8icrs8PAv1dbSC2jOrqrFQ9brcbuYOL46bGHUAiToc4FnByvrmVYe9KM8
   aA1Dq2/BWPVH3RtivV5XsVFIHduhMhKM0XEnmwxEylR1TWu1QMAoMo+2p
   F9x6g2MtqO949Aik7dGAXI8Ga6OBU/E3bYdCofKK11r9rB2SpRHPBo/Nu
   mverq9ppcU+nEkQGjY6eAgfc+Dv+Q8aI6Ve02KeqxiJYZdQ9751kiARJD
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10196"; a="237490518"
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="237490518"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 07:31:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,202,1635231600"; 
   d="scan'208";a="613864755"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 13 Dec 2021 07:31:30 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, elza.mathew@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 4/6] ice: xsk: do not clear status_error0 for ntu + nb_buffs descriptor
Date:   Mon, 13 Dec 2021 16:31:09 +0100
Message-Id: <20211213153111.110877-5-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
References: <20211213153111.110877-1-maciej.fijalkowski@intel.com>
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
Reported-by: Elza Mathew <elza.mathew@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
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
2.33.1

