Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C6D3EC344
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 16:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238604AbhHNOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 10:24:23 -0400
Received: from mga07.intel.com ([134.134.136.100]:45196 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238654AbhHNOXj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Aug 2021 10:23:39 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10075"; a="279426324"
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="279426324"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2021 07:23:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,321,1620716400"; 
   d="scan'208";a="447568475"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga007.fm.intel.com with ESMTP; 14 Aug 2021 07:23:06 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com, joamaki@gmail.com, toke@redhat.com,
        brett.creeley@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v5 intel-next 5/9] ice: do not create xdp_frame on XDP_TX
Date:   Sat, 14 Aug 2021 16:08:08 +0200
Message-Id: <20210814140812.46632-6-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
References: <20210814140812.46632-1-maciej.fijalkowski@intel.com>
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

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 851a6e68aedf..f2e6a37112d1 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -552,7 +552,7 @@ ice_run_xdp(struct ice_rx_ring *rx_ring, struct xdp_buff *xdp,
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

