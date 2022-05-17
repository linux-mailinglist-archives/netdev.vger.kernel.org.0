Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047B952A996
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 19:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351611AbiEQRs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 13:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351612AbiEQRsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 13:48:55 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D25350067
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 10:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652809733; x=1684345733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FEboPPZVLHdPxM2D+iCarexPecj2F4B+bvhYbdeer3s=;
  b=jE3APOu4SJaXNcmuWDWq8Hlrm4BwSLLPMQNPCdsYvprTGgPQIRdGksR/
   mT+NlvgoFXVCLgVai+v3CegD/UN9k/1Qt9ah3U+uCL0kXbHQbGuoz5DcE
   dUqBaClB68pmIN46qDe4w3g/WK5AIThmzS6ib5njV0jr+MHSNl3kNCEoH
   ya0g5Ilh2JCPwYVnGvKfRdYZe6BDhtF+Qw352J0grO2tBm03yHU5g4Twk
   rkpxYoYthr/nH+Gx3Za8Sz504rUNUajCE4jR98hT9QF2pQMqMmyUGmRyb
   P1acg3z5T1mYWYneSbdesBVfaX7gC2O1dmOdP/2mboK/LVos21O5ID8uK
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10350"; a="253316427"
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="253316427"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2022 10:48:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,233,1647327600"; 
   d="scan'208";a="545015282"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 17 May 2022 10:48:50 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Michal Wilczynski <michal.wilczynski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net 3/3] ice: Fix interrupt moderation settings getting cleared
Date:   Tue, 17 May 2022 10:45:47 -0700
Message-Id: <20220517174547.1757401-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
References: <20220517174547.1757401-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Wilczynski <michal.wilczynski@intel.com>

Adaptive-rx and Adaptive-tx are interrupt moderation settings
that can be enabled/disabled using ethtool:
ethtool -C ethX adaptive-rx on/off adaptive-tx on/off

Unfortunately those settings are getting cleared after
changing number of queues, or in ethtool world 'channels':
ethtool -L ethX rx 1 tx 1

Clearing was happening due to introduction of bit fields
in ice_ring_container struct. This way only itr_setting
bits were rebuilt during ice_vsi_rebuild_set_coalesce().

Introduce an anonymous struct of bitfields and create a
union to refer to them as a single variable.
This way variable can be easily saved and restored.

Fixes: 61dc79ced7aa ("ice: Restore interrupt throttle settings after VSI rebuild")
Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  | 16 ++++++++--------
 drivers/net/ethernet/intel/ice/ice_txrx.h | 11 ++++++++---
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 6d19c58ccacd..454e01ae09b9 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -3043,8 +3043,8 @@ ice_vsi_rebuild_get_coalesce(struct ice_vsi *vsi,
 	ice_for_each_q_vector(vsi, i) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[i];
 
-		coalesce[i].itr_tx = q_vector->tx.itr_setting;
-		coalesce[i].itr_rx = q_vector->rx.itr_setting;
+		coalesce[i].itr_tx = q_vector->tx.itr_settings;
+		coalesce[i].itr_rx = q_vector->rx.itr_settings;
 		coalesce[i].intrl = q_vector->intrl;
 
 		if (i < vsi->num_txq)
@@ -3100,21 +3100,21 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 		 */
 		if (i < vsi->alloc_rxq && coalesce[i].rx_valid) {
 			rc = &vsi->q_vectors[i]->rx;
-			rc->itr_setting = coalesce[i].itr_rx;
+			rc->itr_settings = coalesce[i].itr_rx;
 			ice_write_itr(rc, rc->itr_setting);
 		} else if (i < vsi->alloc_rxq) {
 			rc = &vsi->q_vectors[i]->rx;
-			rc->itr_setting = coalesce[0].itr_rx;
+			rc->itr_settings = coalesce[0].itr_rx;
 			ice_write_itr(rc, rc->itr_setting);
 		}
 
 		if (i < vsi->alloc_txq && coalesce[i].tx_valid) {
 			rc = &vsi->q_vectors[i]->tx;
-			rc->itr_setting = coalesce[i].itr_tx;
+			rc->itr_settings = coalesce[i].itr_tx;
 			ice_write_itr(rc, rc->itr_setting);
 		} else if (i < vsi->alloc_txq) {
 			rc = &vsi->q_vectors[i]->tx;
-			rc->itr_setting = coalesce[0].itr_tx;
+			rc->itr_settings = coalesce[0].itr_tx;
 			ice_write_itr(rc, rc->itr_setting);
 		}
 
@@ -3128,12 +3128,12 @@ ice_vsi_rebuild_set_coalesce(struct ice_vsi *vsi,
 	for (; i < vsi->num_q_vectors; i++) {
 		/* transmit */
 		rc = &vsi->q_vectors[i]->tx;
-		rc->itr_setting = coalesce[0].itr_tx;
+		rc->itr_settings = coalesce[0].itr_tx;
 		ice_write_itr(rc, rc->itr_setting);
 
 		/* receive */
 		rc = &vsi->q_vectors[i]->rx;
-		rc->itr_setting = coalesce[0].itr_rx;
+		rc->itr_settings = coalesce[0].itr_rx;
 		ice_write_itr(rc, rc->itr_setting);
 
 		vsi->q_vectors[i]->intrl = coalesce[0].intrl;
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.h b/drivers/net/ethernet/intel/ice/ice_txrx.h
index cead3eb149bd..ffb3f6a589da 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.h
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.h
@@ -384,9 +384,14 @@ struct ice_ring_container {
 	/* this matches the maximum number of ITR bits, but in usec
 	 * values, so it is shifted left one bit (bit zero is ignored)
 	 */
-	u16 itr_setting:13;
-	u16 itr_reserved:2;
-	u16 itr_mode:1;
+	union {
+		struct {
+			u16 itr_setting:13;
+			u16 itr_reserved:2;
+			u16 itr_mode:1;
+		};
+		u16 itr_settings;
+	};
 	enum ice_container_type type;
 };
 
-- 
2.35.1

