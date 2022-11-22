Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 544516349D8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234920AbiKVWLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:11:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234915AbiKVWK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:10:59 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F1127DC5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669155057; x=1700691057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XMvNrvaT0EEtRmq4MQJBY4uVcQTxJKUaQHEgSXwgMUQ=;
  b=BkSjparrxoBFf6T9KHhtU1Sa34mSEGzjaGd6hDTAYzBIPRmMRWXznBo3
   eKGGao5Ypugq+4BM61BZS5Xx0YPoD8xsQtFuFxFQAKQzFsJ8akqZXhoAQ
   abETSXJJglyolVtGduE+ij8+C9YDZoYGyhSV3cehHplQRxDYH9Coh8pjx
   xE1HKwnJPEIW50fPM7qJmm9Td6tbkUPemEV8AidH666IXpcLrAVzQ/AoJ
   urH0gL7egGf5JKEHaDSpx1m0TY9RxMp9beDcx1Lppe9WEmc7qFv+nn5yn
   3KMm8uMvrEGrRAIYP3YJ/LxG3CErLCfkXFtjeHeSUe1pGuevZSxFdTIyp
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378182932"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="378182932"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 14:10:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="705127024"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="705127024"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2022 14:10:55 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next v2 6/7] ice: Fix configuring VIRTCHNL_OP_CONFIG_VSI_QUEUES with unbalanced queues
Date:   Tue, 22 Nov 2022 14:10:46 -0800
Message-Id: <20221122221047.3095231-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
References: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marcin Szycik <marcin.szycik@linux.intel.com>

Currently the VIRTCHNL_OP_CONFIG_VSI_QUEUES command may fail if there are
less RX queues than TX queues requested.

To fix it, only configure RXDID if RX queue exists.

Fixes: e753df8fbca5 ("ice: Add support Flex RXD")
Signed-off-by: Marcin Szycik <marcin.szycik@linux.intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_virtchnl.c | 37 +++++++++----------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl.c b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
index ec90e594986e..dab3cd5d300e 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl.c
@@ -1621,9 +1621,6 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 	}
 
 	for (i = 0; i < qci->num_queue_pairs; i++) {
-		struct ice_hw *hw;
-		u32 rxdid;
-		u16 pf_q;
 		qpi = &qci->qpair[i];
 		if (qpi->txq.vsi_id != qci->vsi_id ||
 		    qpi->rxq.vsi_id != qci->vsi_id ||
@@ -1664,6 +1661,7 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 		/* copy Rx queue info from VF into VSI */
 		if (qpi->rxq.ring_len > 0) {
 			u16 max_frame_size = ice_vc_get_max_frame_size(vf);
+			u32 rxdid;
 
 			vsi->rx_rings[i]->dma = qpi->rxq.dma_ring_addr;
 			vsi->rx_rings[i]->count = qpi->rxq.ring_len;
@@ -1691,26 +1689,25 @@ static int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 					 vf->vf_id, i);
 				goto error_param;
 			}
-		}
 
-		/* VF Rx queue RXDID configuration */
-		pf_q = vsi->rxq_map[qpi->rxq.queue_id];
-		rxdid = qpi->rxq.rxdid;
-		hw = &vsi->back->hw;
+			/* If Rx flex desc is supported, select RXDID for Rx
+			 * queues. Otherwise, use legacy 32byte descriptor
+			 * format. Legacy 16byte descriptor is not supported.
+			 * If this RXDID is selected, return error.
+			 */
+			if (vf->driver_caps &
+			    VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC) {
+				rxdid = qpi->rxq.rxdid;
+				if (!(BIT(rxdid) & pf->supported_rxdids))
+					goto error_param;
+			} else {
+				rxdid = ICE_RXDID_LEGACY_1;
+			}
 
-		/* If Rx flex desc is supported, select RXDID for Rx queues.
-		 * Otherwise, use legacy 32byte descriptor format.
-		 * Legacy 16byte descriptor is not supported. If this RXDID
-		 * is selected, return error.
-		 */
-		if (vf->driver_caps & VIRTCHNL_VF_OFFLOAD_RX_FLEX_DESC) {
-			if (!(BIT(rxdid) & pf->supported_rxdids))
-				goto error_param;
-		} else {
-			rxdid = ICE_RXDID_LEGACY_1;
+			ice_write_qrxflxp_cntxt(&vsi->back->hw,
+						vsi->rxq_map[q_idx],
+						rxdid, 0x03, false);
 		}
-
-		ice_write_qrxflxp_cntxt(hw, pf_q, rxdid, 0x03, false);
 	}
 
 	/* send the response to the VF */
-- 
2.35.1

