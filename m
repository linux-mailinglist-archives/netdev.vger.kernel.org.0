Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2CA4A83A9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 13:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350456AbiBCMQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 07:16:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:45039 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350390AbiBCMQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 07:16:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643890618; x=1675426618;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mTxtmM7PxDYabUdQxaPGX7R+O/XvKUxedI0be3fyatI=;
  b=Bg8jOMybKjDqwSxxJA1XzUlAVC6l93JJykTjwpcf5Bracdou1jaSV8sO
   EY4oTevoh44Bc7Zhbs6ZwHGAmX7pFyL/jwnkbXieuaQVo+QZADFqNXMB1
   m1VJ6wPPHRQuLS9FjVzS3pIBnUVDm0trl/ubeHcumjqQH94wPgdT69MKU
   EQhToVC3j+vUUJWPxIJzMaY6/b1ESytEX140a4cK7vGmx+8Du4GVsN4GR
   +6eZEwQaYyjCTykmAE87ImTpBuVVIxBsJlyfgL6h2FZjqHGiDS5fOmMZp
   dm7Tyip+3/vuwAuY+egb0ZrEqNvvqC5JEiCkP/62B+IN4uKW7Ut2j4MlF
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10246"; a="245726109"
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="245726109"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2022 04:16:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,339,1635231600"; 
   d="scan'208";a="631322307"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga004.jf.intel.com with ESMTP; 03 Feb 2022 04:16:55 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        anthony.l.nguyen@intel.com, kuba@kernel.org, davem@davemloft.net,
        magnus.karlsson@intel.com, alexandr.lobakin@intel.com,
        jesse.brandeburg@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 intel-net] ice: avoid XDP checks in ice_clean_tx_irq()
Date:   Thu,  3 Feb 2022 13:16:51 +0100
Message-Id: <20220203121651.18937-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced Tx IRQ
cleaning routine dedicated for XDP rings. Currently it is impossible to
call ice_clean_tx_irq() against XDP ring, so it is safe to drop
ice_ring_is_xdp() calls in there.

Fixes: 1c96c16858ba ("ice: update to newer kernel API")
Fixes: cc14db11c8a4 ("ice: use prefetch methods")
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---

v2: fix commit msg and collect ack (Alex)

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

