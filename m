Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D245BCDBF
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 15:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiISN57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 09:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiISN5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 09:57:55 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A6C92A70A;
        Mon, 19 Sep 2022 06:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663595874; x=1695131874;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rVLwnepZShLYi0CxrPl67f1ZjluOas+qgi/tbAoa+DM=;
  b=QsODZRDhEmbnPLDuHuYJO8Z7MCPXj2O2fPHdotIMhQPQ+OkMwi+OB0kr
   UbQq857x09Cq2uHWgNF7RLYPpTfUKNzPsCz5oezoQAiFqfD5+GuqPK51t
   dNGQOjq1DvjWnbNOkYHqQU5mDdditILdhixFai/D6Wde8GJcFdMc36kRt
   FzJ/kJkda8asXk8rbqGU0Dwn9FYtO6+W3RCTUQfsI8RfAL4f5BFlilZJK
   Hex3IyrvG6p3PsSpyC32gkc3eENocfOLYb9oxWYleQ8dTvqm9tDLjmP3z
   Ci2YrXYqNMJ17Oxt7E9mcPviqJyHxOMoi1pKmRDW3T+Wb+AF7esbwt5NV
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="279786502"
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="279786502"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 06:57:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,327,1654585200"; 
   d="scan'208";a="722306733"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by fmsmga002.fm.intel.com with ESMTP; 19 Sep 2022 06:57:46 -0700
Received: from lincoln.igk.intel.com (lincoln.igk.intel.com [10.102.21.235])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 28JDvi5X023980;
        Mon, 19 Sep 2022 14:57:44 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Larysa Zaremba <larysa.zaremba@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH net] ice: Fix ice_xdp_xmit() when XDP TX queue number is not sufficient
Date:   Mon, 19 Sep 2022 15:43:46 +0200
Message-Id: <20220919134346.25030-1-larysa.zaremba@intel.com>
X-Mailer: git-send-email 2.35.3
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

The original patch added the static branch to handle the situation,
when assigning an XDP TX queue to every CPU is not possible,
so they have to be shared.

However, in the XDP transmit handler ice_xdp_xmit(), an error was
returned in such cases even before static condition was checked,
thus making queue sharing still impossible.

Fixes: 22bf877e528f ("ice: introduce XDP_TX fallback path")
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_txrx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index 42b42f4b21ef..a5a0c9706b5a 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -610,7 +610,7 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
-	if (!ice_is_xdp_ena_vsi(vsi) || queue_index >= vsi->num_xdp_txq)
+	if (!ice_is_xdp_ena_vsi(vsi))
 		return -ENXIO;
 
 	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
@@ -621,6 +621,9 @@ ice_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		xdp_ring = vsi->xdp_rings[queue_index];
 		spin_lock(&xdp_ring->tx_lock);
 	} else {
+		/* Generally, should not happen */
+		if (unlikely(queue_index >= vsi->num_xdp_txq))
+			return -ENXIO;
 		xdp_ring = vsi->xdp_rings[queue_index];
 	}
 
-- 
2.35.3

