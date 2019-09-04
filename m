Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D215A79EF
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbfIDEf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:35:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:26528 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728139AbfIDEfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 00:35:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 21:35:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,465,1559545200"; 
   d="scan'208";a="176804396"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga008.jf.intel.com with ESMTP; 03 Sep 2019 21:35:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/15] ice: Report what the user set for coalesce [tx|rx]-usecs
Date:   Tue,  3 Sep 2019 21:35:00 -0700
Message-Id: <20190904043512.28066-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
References: <20190904043512.28066-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Currently if the user sets an odd value for [tx|rx]-usecs we align the
value because the hardware only understands ITR values in multiples of
2. This seems misleading because we are essentially telling the user
that the ITR value is odd, when in fact we have changed it internally.
Fix this by reporting that setting odd ITR values is not allowed.

Also, while making changes to ice_set_rc_coalesce() I noticed a bit of
code/error duplication. Make the necessary changes to remove the
duplication.

Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 88 ++++++++++----------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index f7dd0bd03d39..edba5bd79097 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3253,25 +3253,25 @@ static int
 ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 		    struct ice_ring_container *rc, struct ice_vsi *vsi)
 {
+	const char *c_type_str = (c_type == ICE_RX_CONTAINER) ? "rx" : "tx";
+	u32 use_adaptive_coalesce, coalesce_usecs;
 	struct ice_pf *pf = vsi->back;
 	u16 itr_setting;
 
 	if (!rc->ring)
 		return -EINVAL;
 
-	itr_setting = rc->itr_setting & ~ICE_ITR_DYNAMIC;
-
 	switch (c_type) {
 	case ICE_RX_CONTAINER:
 		if (ec->rx_coalesce_usecs_high > ICE_MAX_INTRL ||
 		    (ec->rx_coalesce_usecs_high &&
 		     ec->rx_coalesce_usecs_high < pf->hw.intrl_gran)) {
 			netdev_info(vsi->netdev,
-				    "Invalid value, rx-usecs-high valid values are 0 (disabled), %d-%d\n",
-				    pf->hw.intrl_gran, ICE_MAX_INTRL);
+				    "Invalid value, %s-usecs-high valid values are 0 (disabled), %d-%d\n",
+				    c_type_str, pf->hw.intrl_gran,
+				    ICE_MAX_INTRL);
 			return -EINVAL;
 		}
-
 		if (ec->rx_coalesce_usecs_high != rc->ring->q_vector->intrl) {
 			rc->ring->q_vector->intrl = ec->rx_coalesce_usecs_high;
 			wr32(&pf->hw, GLINT_RATE(rc->ring->q_vector->reg_idx),
@@ -3279,60 +3279,60 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 						   pf->hw.intrl_gran));
 		}
 
-		if (ec->rx_coalesce_usecs != itr_setting &&
-		    ec->use_adaptive_rx_coalesce) {
-			netdev_info(vsi->netdev,
-				    "Rx interrupt throttling cannot be changed if adaptive-rx is enabled\n");
-			return -EINVAL;
-		}
+		use_adaptive_coalesce = ec->use_adaptive_rx_coalesce;
+		coalesce_usecs = ec->rx_coalesce_usecs;
 
-		if (ec->rx_coalesce_usecs > ICE_ITR_MAX) {
-			netdev_info(vsi->netdev,
-				    "Invalid value, rx-usecs range is 0-%d\n",
-				   ICE_ITR_MAX);
-			return -EINVAL;
-		}
-
-		if (ec->use_adaptive_rx_coalesce) {
-			rc->itr_setting |= ICE_ITR_DYNAMIC;
-		} else {
-			rc->itr_setting = ITR_REG_ALIGN(ec->rx_coalesce_usecs);
-			rc->target_itr = ITR_TO_REG(rc->itr_setting);
-		}
 		break;
 	case ICE_TX_CONTAINER:
 		if (ec->tx_coalesce_usecs_high) {
 			netdev_info(vsi->netdev,
-				    "setting tx-usecs-high is not supported\n");
-			return -EINVAL;
-		}
-
-		if (ec->tx_coalesce_usecs != itr_setting &&
-		    ec->use_adaptive_tx_coalesce) {
-			netdev_info(vsi->netdev,
-				    "Tx interrupt throttling cannot be changed if adaptive-tx is enabled\n");
+				    "setting %s-usecs-high is not supported\n",
+				    c_type_str);
 			return -EINVAL;
 		}
 
-		if (ec->tx_coalesce_usecs > ICE_ITR_MAX) {
-			netdev_info(vsi->netdev,
-				    "Invalid value, tx-usecs range is 0-%d\n",
-				   ICE_ITR_MAX);
-			return -EINVAL;
-		}
+		use_adaptive_coalesce = ec->use_adaptive_tx_coalesce;
+		coalesce_usecs = ec->tx_coalesce_usecs;
 
-		if (ec->use_adaptive_tx_coalesce) {
-			rc->itr_setting |= ICE_ITR_DYNAMIC;
-		} else {
-			rc->itr_setting = ITR_REG_ALIGN(ec->tx_coalesce_usecs);
-			rc->target_itr = ITR_TO_REG(rc->itr_setting);
-		}
 		break;
 	default:
 		dev_dbg(&pf->pdev->dev, "Invalid container type %d\n", c_type);
 		return -EINVAL;
 	}
 
+	itr_setting = rc->itr_setting & ~ICE_ITR_DYNAMIC;
+	if (coalesce_usecs != itr_setting && use_adaptive_coalesce) {
+		netdev_info(vsi->netdev,
+			    "%s interrupt throttling cannot be changed if adaptive-%s is enabled\n",
+			    c_type_str, c_type_str);
+		return -EINVAL;
+	}
+
+	if (coalesce_usecs > ICE_ITR_MAX) {
+		netdev_info(vsi->netdev,
+			    "Invalid value, %s-usecs range is 0-%d\n",
+			    c_type_str, ICE_ITR_MAX);
+		return -EINVAL;
+	}
+
+	/* hardware only supports an ITR granularity of 2us */
+	if (coalesce_usecs % 2 != 0) {
+		netdev_info(vsi->netdev,
+			    "Invalid value, %s-usecs must be even\n",
+			    c_type_str);
+		return -EINVAL;
+	}
+
+	if (use_adaptive_coalesce) {
+		rc->itr_setting |= ICE_ITR_DYNAMIC;
+	} else {
+		/* store user facing value how it was set */
+		rc->itr_setting = coalesce_usecs;
+		/* set to static and convert to value HW understands */
+		rc->target_itr =
+			ITR_TO_REG(ITR_REG_ALIGN(rc->itr_setting));
+	}
+
 	return 0;
 }
 
-- 
2.21.0

