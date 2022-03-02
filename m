Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A144CACB7
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 18:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244327AbiCBSAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 13:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244302AbiCBSAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 13:00:04 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFF4CA716;
        Wed,  2 Mar 2022 09:59:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646243961; x=1677779961;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u1wtRHCrk57m1uZ76DRy2I2JW4Y7x/+wKx6b8X/Wlac=;
  b=F7WaFjNVzyUP2QqtsNPJ347NyFphKNDNPM7Wmop0lQHRS6btFZd+XHsi
   9WWJyU1PhXjmLpmNl73G+FUp1xvDgg0NB/WAUpmAGgr0Ri4FiAP1V6k0i
   7b7J/yuJqMFmvZc09asIAs2CiTd1tEKLt3jEU44wRmIXgXDcTtJIRJZTY
   tzQeXyLaajiw5LbDK/EvyYxvQcu4D9fL1We9IZki146T0GHyWvCmuIMZg
   x6z9aMegV5/TOnPapNd4ef6NFwo0fBc0/JwLky3BSWU37jM0LG4KKP5uo
   jvg6waAO+rSoRYPiMFqeX92AIc+gtrP2ZwouTf+5YrIcaxfMZPRfAonyo
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="251041195"
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="251041195"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 09:59:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,149,1643702400"; 
   d="scan'208";a="630492512"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Mar 2022 09:59:20 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org,
        andrii@kernel.org, kpsingh@kernel.org, kafai@fb.com, yhs@fb.com,
        songliubraving@fb.com,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Kiran Bhandare <kiranx.bhandare@intel.com>
Subject: [PATCH net 2/2] ice: avoid XDP checks in ice_clean_tx_irq()
Date:   Wed,  2 Mar 2022 09:59:28 -0800
Message-Id: <20220302175928.4129098-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
References: <20220302175928.4129098-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Commit 9610bd988df9 ("ice: optimize XDP_TX workloads") introduced Tx IRQ
cleaning routine dedicated for XDP rings. Currently it is impossible to
call ice_clean_tx_irq() against XDP ring, so it is safe to drop
ice_ring_is_xdp() calls in there.

Fixes: 1c96c16858ba ("ice: update to newer kernel API")
Fixes: cc14db11c8a4 ("ice: use prefetch methods")
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 3e38695f1c9d..2a1a12299fbb 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -221,8 +221,7 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 	struct ice_tx_buf *tx_buf;
 
 	/* get the bql data ready */
-	if (!ice_ring_is_xdp(tx_ring))
-		netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
+	netdev_txq_bql_complete_prefetchw(txring_txq(tx_ring));
 
 	tx_buf = &tx_ring->tx_buf[i];
 	tx_desc = ICE_TX_DESC(tx_ring, i);
@@ -311,10 +310,6 @@ static bool ice_clean_tx_irq(struct ice_tx_ring *tx_ring, int napi_budget)
 	tx_ring->next_to_clean = i;
 
 	ice_update_tx_ring_stats(tx_ring, total_pkts, total_bytes);
-
-	if (ice_ring_is_xdp(tx_ring))
-		return !!budget;
-
 	netdev_tx_completed_queue(txring_txq(tx_ring), total_pkts, total_bytes);
 
 #define TX_WAKE_THRESHOLD ((s16)(DESC_NEEDED * 2))
-- 
2.31.1

