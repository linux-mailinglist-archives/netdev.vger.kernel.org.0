Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC9CB3BC1E6
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 18:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhGERAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:00:42 -0400
Received: from mga05.intel.com ([192.55.52.43]:50106 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229784AbhGERAl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 13:00:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="294646411"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="294646411"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2021 09:58:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="562686299"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 05 Jul 2021 09:58:02 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, joamaki@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-next 3/4] ice: do not create xdp_frame on XDP_TX
Date:   Mon,  5 Jul 2021 18:43:37 +0200
Message-Id: <20210705164338.58313-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
References: <20210705164338.58313-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_frame is not needed for XDP_TX data path in ice driver case.
For this data path cleaning of sent descriptor will not happen anywhere
outside of the driver, which means that carrying the information about
the underlying memory model via xdp_frame will not be used. Therefore,
this conversion can be simply dropped, which would relieve CPU a bit.

Call directly ice_xmit_xdp_ring instead of ice_xmit_xdp_buff for XDP_TX
action returned from BPF program.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 23b97c9579fb..fef1f74562e5 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -586,7 +586,7 @@ ice_run_xdp(struct ice_ring *rx_ring, struct xdp_buff *xdp,
 		return ICE_XDP_PASS;
 	case XDP_TX:
 		xdp_ring = rx_ring->vsi->xdp_rings[smp_processor_id()];
-		result = ice_xmit_xdp_buff(xdp, xdp_ring);
+		result = ice_xmit_xdp_ring(xdp->data, xdp->data_end - xdp->data, xdp_ring);
 		if (result == ICE_XDP_CONSUMED)
 			goto out_failure;
 		return result;
-- 
2.20.1

