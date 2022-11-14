Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D409A628DAA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237675AbiKNXnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:43:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiKNXnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:43:00 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE7A13D22
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668469379; x=1700005379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XMvNrvaT0EEtRmq4MQJBY4uVcQTxJKUaQHEgSXwgMUQ=;
  b=Mkg6S39OirZmzvP/hjARSUyEofY4Xu9dl3fxxysWlQTVbRVzpL9ZebuO
   0SlGMDoHmAZHkgVOftCf8TpcFtelc6a8F8lWsRIHQjfus3pSz/5hLqsVB
   2uW+Qm0pZGt3ZIInAKC9o7j7G+2HbBk3WhaBHGy1OLhFHmw7K5AFMAKWk
   ldKRYkCr6XVw+1UfvV64n9kIB2ewCHoPc2jiIxoK6GPs2sxSuG73VOD09
   7vn0TYTAvnX80g1xkMAtAFENd4XScljyH/R1Fm0KWjt9h/HPTcouK0Ahd
   XfJcKk8mp6FaN0usdJmwdtPaFsipfDkeTtvTZ3diMrF995/aPLYQUjLyy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310821195"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310821195"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:42:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702208682"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702208682"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 15:42:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Marcin Szycik <marcin.szycik@linux.intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net-next 6/7] ice: Fix configuring VIRTCHNL_OP_CONFIG_VSI_QUEUES with unbalanced queues
Date:   Mon, 14 Nov 2022 15:42:49 -0800
Message-Id: <20221114234250.3039889-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
References: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
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

