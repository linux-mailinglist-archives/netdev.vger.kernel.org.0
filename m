Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27FAB56A7AF
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 18:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbiGGQMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 12:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbiGGQMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 12:12:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D801F4D173;
        Thu,  7 Jul 2022 09:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657210296; x=1688746296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vesXtGlDmOsjMCJXAf5YAftKju8+FHR1Lh+U8lCzIoU=;
  b=QJIJh4eZcv/NRof01cf6boByjYzjms1hW9qBN8/Jeo1+wdVot83kwAvA
   NX9RCuYycyHOCiBCaw1mFOvAzt6wYU1+jv44uMxO4oJOAGmWBYoWCWcUy
   avn+53yoCDpNGUlyqaWeibBJNsx+6lp50Td+S0qhmeELWMmuWQQSZdg+3
   XfZtAWAOrUveXblvCDg3Crc4DJ8rLhdWFsV0MNkJzgfd9p399uoqHOhTW
   oUL6oNhGzLlpneU1J4J7YgVQNztYsyeErZktXkUImE/W1whenaVEF0vyN
   4MUHV5/fkaJRvmzgS+9hAOh4dlX7b2vP9PwUtwnBTAYzB17JdEcBhpDUa
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="284803787"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="284803787"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 09:11:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="839971579"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jul 2022 09:11:34 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net] ice: xsk: use Rx ring when picking NAPI context
Date:   Thu,  7 Jul 2022 18:11:28 +0200
Message-Id: <20220707161128.54215-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ice driver allocates per cpu XDP queues so that redirect path can safely
use smp_processor_id() as an index to the array. At the same time
though, XDP rings are used to pick NAPI context to call napi_schedule()
or set NAPIF_STATE_MISSED. When user reduces queue count, say to 8, and
num_possible_cpus() of underlying platform is 44, then this means queue
vectors with correlated NAPI contexts will carry several XDP queues.

This in turn can result in a broken behavior where NAPI context of
interest will never be scheduled and AF_XDP socket will not process any
traffic.

To fix this issue, use Rx ring to pull out the NAPI context.

Fixes: 2d4238f55697 ("ice: Add support for AF_XDP")
Fixes: 22bf877e528f ("ice: introduce XDP_TX fallback path")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 49ba8bfdbf04..34d851d3e767 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -353,7 +353,7 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	if (if_running) {
 		ret = ice_qp_ena(vsi, qid);
 		if (!ret && pool_present)
-			napi_schedule(&vsi->xdp_rings[qid]->q_vector->napi);
+			napi_schedule(&vsi->rx_rings[qid]->q_vector->napi);
 		else if (ret)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
@@ -936,7 +936,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_q_vector *q_vector;
 	struct ice_vsi *vsi = np->vsi;
-	struct ice_tx_ring *ring;
+	struct ice_rx_ring *ring;
 
 	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
@@ -944,13 +944,13 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	if (!ice_is_xdp_ena_vsi(vsi))
 		return -EINVAL;
 
-	if (queue_id >= vsi->num_txq)
+	if (queue_id >= vsi->num_txq || queue_id >= vsi->num_rxq)
 		return -EINVAL;
 
 	if (!vsi->xdp_rings[queue_id]->xsk_pool)
 		return -EINVAL;
 
-	ring = vsi->xdp_rings[queue_id];
+	ring = vsi->rx_rings[queue_id];
 
 	/* The idea here is that if NAPI is running, mark a miss, so
 	 * it will run again. If not, trigger an interrupt and
-- 
2.27.0

