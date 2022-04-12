Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12084FE824
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233948AbiDLSmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358751AbiDLSlx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:41:53 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98D631DE7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649788774; x=1681324774;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rJRh226fevwg1kmfW2gRR1hLrkcuWnT3sTYFRcgP3xw=;
  b=UAKuvxWRLvRz0JdTsabWsxQNCVi+Ba57g/x1VhNDX2l5a0vbuHnKpv1H
   ozUIly4g+UyeIvgmRsc1NVnv9w6y9RACiq/K5sP3E+Pka/e7yYL/qEGdr
   bQ7Iyh24uiUcXF1ooF1IZB4zHH7AVRGbhHU1MngMZF/oo10zktiF5iGAj
   hLotHUFRlDDRJTHEGRIm25bqR2SE07u3jR1o5DVRJXRhOOc4WTzDetJCz
   X9yJZAtRFxafAF7M9PKl/5kA6b+FifpjZBe8r4KgQ0IfsUN7MpXAvvIvN
   fiFoes0V4kJDmj27WA0D63KkYwY8476DqZEHMBCh1O63Cz9xY2VWUUvHU
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="322919270"
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="322919270"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 11:39:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,254,1643702400"; 
   d="scan'208";a="590453085"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 12 Apr 2022 11:39:29 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sassmann@redhat.com,
        Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 3/5] i40e: Add tx_stopped stat
Date:   Tue, 12 Apr 2022 11:36:34 -0700
Message-Id: <20220412183636.1408915-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
References: <20220412183636.1408915-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Damato <jdamato@fastly.com>

Track TX queue stop events and export the new stat with ethtool.

Signed-off-by: Joe Damato <jdamato@fastly.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e.h         | 1 +
 drivers/net/ethernet/intel/i40e/i40e_debugfs.c | 5 +++--
 drivers/net/ethernet/intel/i40e/i40e_ethtool.c | 1 +
 drivers/net/ethernet/intel/i40e/i40e_main.c    | 4 ++++
 drivers/net/ethernet/intel/i40e/i40e_txrx.c    | 2 ++
 drivers/net/ethernet/intel/i40e/i40e_txrx.h    | 1 +
 6 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 55c6bce5da61..18558a019353 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -852,6 +852,7 @@ struct i40e_vsi {
 	u64 tx_busy;
 	u64 tx_linearize;
 	u64 tx_force_wb;
+	u64 tx_stopped;
 	u64 rx_buf_failed;
 	u64 rx_page_failed;
 	u64 rx_page_reuse;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
index be7c6f34d45c..c9dcd6d92c83 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_debugfs.c
@@ -309,10 +309,11 @@ static void i40e_dbg_dump_vsi_seid(struct i40e_pf *pf, int seid)
 			 tx_ring->stats.bytes,
 			 tx_ring->tx_stats.restart_queue);
 		dev_info(&pf->pdev->dev,
-			 "    tx_rings[%i]: tx_stats: tx_busy = %lld, tx_done_old = %lld\n",
+			 "    tx_rings[%i]: tx_stats: tx_busy = %lld, tx_done_old = %lld, tx_stopped = %lld\n",
 			 i,
 			 tx_ring->tx_stats.tx_busy,
-			 tx_ring->tx_stats.tx_done_old);
+			 tx_ring->tx_stats.tx_done_old,
+			 tx_ring->tx_stats.tx_stopped);
 		dev_info(&pf->pdev->dev,
 			 "    tx_rings[%i]: size = %i\n",
 			 i, tx_ring->size);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
index e48499624d22..162bae158160 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_ethtool.c
@@ -293,6 +293,7 @@ static const struct i40e_stats i40e_gstrings_misc_stats[] = {
 	I40E_VSI_STAT("tx_linearize", tx_linearize),
 	I40E_VSI_STAT("tx_force_wb", tx_force_wb),
 	I40E_VSI_STAT("tx_busy", tx_busy),
+	I40E_VSI_STAT("tx_stopped", tx_stopped),
 	I40E_VSI_STAT("rx_alloc_fail", rx_buf_failed),
 	I40E_VSI_STAT("rx_pg_alloc_fail", rx_page_failed),
 	I40E_VSI_STAT("rx_cache_reuse", rx_page_reuse),
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b7f11fd8297b..fea40efbd1ca 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -785,6 +785,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	unsigned int start;
 	u64 tx_linearize;
 	u64 tx_force_wb;
+	u64 tx_stopped;
 	u64 rx_p, rx_b;
 	u64 tx_p, tx_b;
 	u16 q;
@@ -804,6 +805,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	rx_b = rx_p = 0;
 	tx_b = tx_p = 0;
 	tx_restart = tx_busy = tx_linearize = tx_force_wb = 0;
+	tx_stopped = 0;
 	rx_page = 0;
 	rx_buf = 0;
 	rx_reuse = 0;
@@ -828,6 +830,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 		tx_busy += p->tx_stats.tx_busy;
 		tx_linearize += p->tx_stats.tx_linearize;
 		tx_force_wb += p->tx_stats.tx_force_wb;
+		tx_stopped += p->tx_stats.tx_stopped;
 
 		/* locate Rx ring */
 		p = READ_ONCE(vsi->rx_rings[q]);
@@ -872,6 +875,7 @@ static void i40e_update_vsi_stats(struct i40e_vsi *vsi)
 	vsi->tx_busy = tx_busy;
 	vsi->tx_linearize = tx_linearize;
 	vsi->tx_force_wb = tx_force_wb;
+	vsi->tx_stopped = tx_stopped;
 	vsi->rx_page_failed = rx_page;
 	vsi->rx_buf_failed = rx_buf;
 	vsi->rx_page_reuse = rx_reuse;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 8b844ad08a86..7bc1174edf6b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -3396,6 +3396,8 @@ int __i40e_maybe_stop_tx(struct i40e_ring *tx_ring, int size)
 	/* Memory barrier before checking head and tail */
 	smp_mb();
 
+	++tx_ring->tx_stats.tx_stopped;
+
 	/* Check again in a case another CPU has just made room available. */
 	if (likely(I40E_DESC_UNUSED(tx_ring) < size))
 		return -EBUSY;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index c471c2da313c..41f86e9535a0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -290,6 +290,7 @@ struct i40e_tx_queue_stats {
 	u64 tx_done_old;
 	u64 tx_linearize;
 	u64 tx_force_wb;
+	u64 tx_stopped;
 	int prev_pkt_ctr;
 };
 
-- 
2.31.1

