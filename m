Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 876145A63EA
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 14:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbiH3Mvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 08:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiH3Mvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 08:51:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5DCFAC6E;
        Tue, 30 Aug 2022 05:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661863898; x=1693399898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3oOsAJbtvFZwqYYFDrI/ZRzxiKYeStTLQyTM5B7ilko=;
  b=Yhit6nPIgJ6jbj1Gm+ycnCUCjHhDxMHptZywxINp9HxtrCaPYKrc68yL
   ZTG28nONTleKjblx1OF97qTKe86jWz7EDwziiNXWynxHZswXfji7KfZN0
   eW7TAFDB7qxHVLmgIDTx+JahdT9VnwagyrvpY5duZuv4wI78vo8J8P6so
   it20ZDtmR/ZwwmVW52UNFbZJ+F1Gyvv99cfDfburRyMQhiS41dkBPaUjj
   i63rWQDz1hfyTtGpPCEPv4QAE+iQLDJ7VXt6iJKsTSX9sGQZ0r+SErRxG
   k+tiGbAF1P9eIAaN8w09hcQUiLvPv0MkZVY+gH7rtHeENbKBUHdRBnQMr
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="321292297"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="321292297"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:51:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="680024104"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga004.fm.intel.com with ESMTP; 30 Aug 2022 05:51:36 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, magnus.karlsson@intel.com,
        alasdair.mcwilliam@outlook.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net 2/2] ice: xsk: drop power of 2 ring size restriction for AF_XDP
Date:   Tue, 30 Aug 2022 14:51:22 +0200
Message-Id: <20220830125122.9665-3-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220830125122.9665-1-maciej.fijalkowski@intel.com>
References: <20220830125122.9665-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We had multiple customers in the past months that reported commit
296f13ff3854 ("ice: xsk: Force rings to be sized to power of 2")
makes them unable to use ring size of 8160 in conjunction with AF_XDP.
Remove this restriction.

Fixes: 296f13ff3854 ("ice: xsk: Force rings to be sized to power of 2")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_xsk.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 46efe72d1342..d51e45ea4499 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -329,13 +329,6 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 	bool if_running, pool_present = !!pool;
 	int ret = 0, pool_failure = 0;
 
-	if (!is_power_of_2(vsi->rx_rings[qid]->count) ||
-	    !is_power_of_2(vsi->tx_rings[qid]->count)) {
-		netdev_err(vsi->netdev, "Please align ring sizes to power of 2\n");
-		pool_failure = -EINVAL;
-		goto failure;
-	}
-
 	if_running = netif_running(vsi->netdev) && ice_is_xdp_ena_vsi(vsi);
 
 	if (if_running) {
@@ -358,7 +351,6 @@ int ice_xsk_pool_setup(struct ice_vsi *vsi, struct xsk_buff_pool *pool, u16 qid)
 			netdev_err(vsi->netdev, "ice_qp_ena error = %d\n", ret);
 	}
 
-failure:
 	if (pool_failure) {
 		netdev_err(vsi->netdev, "Could not %sable buffer pool, error = %d\n",
 			   pool_present ? "en" : "dis", pool_failure);
@@ -465,11 +457,10 @@ static bool __ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 bool ice_alloc_rx_bufs_zc(struct ice_rx_ring *rx_ring, u16 count)
 {
 	u16 rx_thresh = ICE_RING_QUARTER(rx_ring);
-	u16 batched, leftover, i, tail_bumps;
+	u16 leftover, i, tail_bumps;
 
-	batched = ALIGN_DOWN(count, rx_thresh);
-	tail_bumps = batched / rx_thresh;
-	leftover = count & (rx_thresh - 1);
+	tail_bumps = count / rx_thresh;
+	leftover = count - (tail_bumps * rx_thresh);
 
 	for (i = 0; i < tail_bumps; i++)
 		if (!__ice_alloc_rx_bufs_zc(rx_ring, rx_thresh))
@@ -968,14 +959,17 @@ bool ice_xsk_any_rx_ring_ena(struct ice_vsi *vsi)
  */
 void ice_xsk_clean_rx_ring(struct ice_rx_ring *rx_ring)
 {
-	u16 count_mask = rx_ring->count - 1;
 	u16 ntc = rx_ring->next_to_clean;
 	u16 ntu = rx_ring->next_to_use;
 
-	for ( ; ntc != ntu; ntc = (ntc + 1) & count_mask) {
+	while (ntc != ntu) {
 		struct xdp_buff *xdp = *ice_xdp_buf(rx_ring, ntc);
 
 		xsk_buff_free(xdp);
+
+		ntc++;
+		if (ntc >= rx_ring->count)
+			ntc = 0;
 	}
 }
 
-- 
2.34.1

