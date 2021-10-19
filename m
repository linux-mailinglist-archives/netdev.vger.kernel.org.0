Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2791A433E79
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 20:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhJSSed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 14:34:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:51639 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233744AbhJSSea (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 14:34:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="226058558"
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="226058558"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2021 11:32:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,164,1631602800"; 
   d="scan'208";a="444602707"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 19 Oct 2021 11:32:15 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 03/10] ice: fix rate limit update after coalesce change
Date:   Tue, 19 Oct 2021 11:30:20 -0700
Message-Id: <20211019183027.2820413-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
References: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesse Brandeburg <jesse.brandeburg@intel.com>

If the adaptive settings are changed with
ethtool -C ethx adaptive-rx off adaptive-tx off
then the interrupt rate limit should be maintained as a user set value,
but only if BOTH adaptive settings are off. Fix a bug where the rate
limit that was being used in adaptive mode was staying set in the
register but was not reported correctly by ethtool -c ethx. Due to long
lines include a small refactor of q_vector variable.

Fixes: b8b4772377dd ("ice: refactor interrupt moderation writes")
Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 17 +++++++++++------
 drivers/net/ethernet/intel/ice/ice_lib.c     |  4 ++--
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 6e0af72c2020..f4b3c5b73c7d 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3640,6 +3640,9 @@ ice_set_rc_coalesce(struct ethtool_coalesce *ec,
 
 	switch (rc->type) {
 	case ICE_RX_CONTAINER:
+	{
+		struct ice_q_vector *q_vector = rc->rx_ring->q_vector;
+
 		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
 		    (ec->rx_coalesce_usecs_high &&
 		     ec->rx_coalesce_usecs_high < pf->hw.intrl_gran)) {
@@ -3648,22 +3651,20 @@ ice_set_rc_coalesce(struct ethtool_coalesce *ec,
 				    ICE_MAX_INTRL);
 			return -EINVAL;
 		}
-		if (ec->rx_coalesce_usecs_high != rc->rx_ring->q_vector->intrl &&
+		if (ec->rx_coalesce_usecs_high != q_vector->intrl &&
 		    (ec->use_adaptive_rx_coalesce || ec->use_adaptive_tx_coalesce)) {
 			netdev_info(vsi->netdev, "Invalid value, %s-usecs-high cannot be changed if adaptive-tx or adaptive-rx is enabled\n",
 				    c_type_str);
 			return -EINVAL;
 		}
-		if (ec->rx_coalesce_usecs_high != rc->rx_ring->q_vector->intrl) {
-			rc->rx_ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
-			ice_write_intrl(rc->rx_ring->q_vector,
-					ec->rx_coalesce_usecs_high);
-		}
+		if (ec->rx_coalesce_usecs_high != q_vector->intrl)
+			q_vector->intrl = ec->rx_coalesce_usecs_high;
 
 		use_adaptive_coalesce = ec->use_adaptive_rx_coalesce;
 		coalesce_usecs = ec->rx_coalesce_usecs;
 
 		break;
+	}
 	case ICE_TX_CONTAINER:
 		use_adaptive_coalesce = ec->use_adaptive_tx_coalesce;
 		coalesce_usecs = ec->tx_coalesce_usecs;
@@ -3808,6 +3809,8 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 
 			if (ice_set_q_coalesce(vsi, ec, v_idx))
 				return -EINVAL;
+
+			ice_set_q_vector_intrl(vsi->q_vectors[v_idx]);
 		}
 		goto set_complete;
 	}
@@ -3815,6 +3818,8 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	if (ice_set_q_coalesce(vsi, ec, q_num))
 		return -EINVAL;
 
+	ice_set_q_vector_intrl(vsi->q_vectors[q_num]);
+
 set_complete:
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index fd894e89be3b..231f8bea2519 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3121,7 +3121,7 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		}
 
 		vsi->q_vectors[i]->intrl = coalesce[i].intrl;
-		ice_write_intrl(vsi->q_vectors[i], coalesce[i].intrl);
+		ice_set_q_vector_intrl(vsi->q_vectors[i]);
 	}
 
 	/* the number of queue vectors increased so write whatever is in
@@ -3139,7 +3139,7 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		ice_write_itr(rc, rc->itr_setting);
 
 		vsi->q_vectors[i]->intrl = coalesce[0].intrl;
-		ice_write_intrl(vsi->q_vectors[i], coalesce[0].intrl);
+		ice_set_q_vector_intrl(vsi->q_vectors[i]);
 	}
 }
 
-- 
2.31.1

