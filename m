Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2175E4A489F
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 14:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376925AbiAaNtg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 08:49:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:20880 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379136AbiAaNtf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 08:49:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643636975; x=1675172975;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b+eUB3X0C7TeB1NdaRzvzd5TACAEk5iAi1QmOA6le94=;
  b=HNQhCK2mcVWXR3H2GrHOGyz68OLPdx76rfUf7i1o1AGuDVBXkTdf9iJG
   RVzmsR/Xcvujvyb1NPQAklGAXjXb6HNl4hCveP1o3HM7AB0VAco6VPALx
   pPSTNEeTHBDPI4CemyL0NNIwTPKOxipVuZN1bC0NvaCU/HLOB2m27e08e
   Wn0cgTYetmXhXyaXxAv4r6YSF17F+vzVxLavh9ohJJElntKkcpj6Kaj55
   l2mnOdpMUXAw7nHADUVX9fR/zsEFoUJ9/dhhvHcFLNPkEat/w+ceMH390
   ahy4Uyl97K08q23jMJ+yUCt5Tvvw8xwW0oI2Tymncz7JuTRDIUJOubrfO
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="234852107"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="234852107"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 05:49:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="675730236"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2022 05:49:32 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, jesse.brandeburg@intel.com,
        alexandr.lobakin@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net] ice: avoid XDP checks in ice_clean_tx_irq()
Date:   Mon, 31 Jan 2022 14:49:21 +0100
Message-Id: <20220131134921.13176-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced
dedicated Tx IRQ cleaning routine dedicated for XDP rings. Currently it
is impossible to call ice_clean_tx_irq() against XDP ring, so it is safe
to drop ice_ring_is_xdp() calls in there.

Fixes: 1c96c16858ba ("ice: update to newer kernel API")
Fixes: cc14db11c8a4 ("ice: use prefetch methods")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 7d8824b4c8ff..25a5a3f2d107 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -223,8 +223,7 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 	struct ice_tx_buf *tx_buf;
 
 	/* get the bql data ready */
-	if (!ice_ring_is_xdp(tx_ring))
-		netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
+	netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
 
 	tx_buf = &tx_ring->tx_buf[i];
 	tx_desc = ICE_TX_DESC(tx_ring, i);
@@ -313,10 +312,6 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 	tx_ring->next_to_clean = i;
 
 	ice_update_tx_ring_stats(tx_ring, total_pkts, total_bytes);
-
-	if (ice_ring_is_xdp(tx_ring))
-		return !!budget;
-
 	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts, total_bytes);
 
 #define TX_WAKE_THRESHOLD ((s16)(DESC_NEEDED * 2))
-- 
2.33.1

