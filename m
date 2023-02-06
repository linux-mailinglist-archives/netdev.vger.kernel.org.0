Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C77168C270
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjBFQER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:04:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBFQEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:04:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8C4173C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 08:04:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675699455; x=1707235455;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tsywCx2Puj3tEwthQozDScSn4JJ2oxvtOw+X9d6OgFw=;
  b=PKIVzRDjBAPhysXgWX7xHEHHusbD+51lNdxc/FZ7KJZsFM0a9vqC2qpB
   /xNyX8npiGXYfcvL57jzxjUVX9XuzcfvJmMsLQOEchM6Dw+7GqrlI0TRZ
   62wTl4gzhJeF7IjXwehtuRUmyYHkBM9fVqrteol5QkO84GjQLx5StTU1l
   h/8AMSspIw36FFK6sAx+rUhx7uozHNS8ENl2ipgh9dua2FKR35UCIxQqD
   /vahMglNrB/G0kW8m5EKGihDjSaJQMA6diOye38SB7JyLlE69NNXVOmkG
   8B3AMrfF7jBhdZzU9fTWqa1ZeSHLRrAWAsWo9DTihzfHHty4B0D7FCDPm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="330530942"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="330530942"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2023 08:04:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10613"; a="809181794"
X-IronPort-AV: E=Sophos;i="5.97,276,1669104000"; 
   d="scan'208";a="809181794"
Received: from irvmail002.ir.intel.com ([10.43.11.120])
  by fmsmga001.fm.intel.com with ESMTP; 06 Feb 2023 08:04:08 -0800
Received: from baltimore.igk.intel.com (baltimore.igk.intel.com [10.102.21.1])
        by irvmail002.ir.intel.com (Postfix) with ESMTP id F01E233E1E;
        Mon,  6 Feb 2023 16:04:07 +0000 (GMT)
From:   Pawel Chmielewski <pawel.chmielewski@intel.com>
To:     netdev@vger.kernel.org
Cc:     intel-wired-lan@osuosl.org,
        Pawel Chmielewski <pawel.chmielewski@intel.com>
Subject: [PATCH 1/1] ice: add support BIG TCP on IPv6
Date:   Mon,  6 Feb 2023 16:59:12 +0100
Message-Id: <20230206155912.2032457-1-pawel.chmielewski@intel.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change enables sending BIG TCP packets on IPv6 in the ice driver using
generic ipv6_hopopt_jumbo_remove helper for stripping HBH header.

Tested:
netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O MIN_LATENCY,P90_LATENCY,P99_LATENCY,THROUGHPUT

Results varied from one setup to another, but in every case we got lower
latencies and increased transactions rate.

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
---
 drivers/net/ethernet/intel/ice/ice.h      | 2 ++
 drivers/net/ethernet/intel/ice/ice_main.c | 2 ++
 drivers/net/ethernet/intel/ice/ice_txrx.c | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 3d26ff4122e0..c774fdd482cd 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -122,6 +122,8 @@
 
 #define ICE_MAX_MTU	(ICE_AQ_SET_MAC_FRAME_SIZE_MAX - ICE_ETH_PKT_HDR_PAD)
 
+#define ICE_MAX_TSO_SIZE 131072
+
 #define ICE_UP_TABLE_TRANSLATE(val, i) \
 		(((val) << ICE_AQ_VSI_UP_TABLE_UP##i##_S) & \
 		  ICE_AQ_VSI_UP_TABLE_UP##i##_M)
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 22b8ad058286..8c74a48ad0d3 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3421,6 +3421,8 @@ static void ice_set_netdev_features(struct net_device *netdev)
 	 * be changed at runtime
 	 */
 	netdev->hw_features |= NETIF_F_RXFCS;
+
+	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethernet/intel/ice/ice_txrx.c
index ccf09c957a1c..bef927afb766 100644
--- a/drivers/net/ethernet/intel/ice/ice_txrx.c
+++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
@@ -2297,6 +2297,9 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ice_tx_ring *tx_ring)
 
 	ice_trace(xmit_frame_ring, tx_ring, skb);
 
+	if (unlikely(ipv6_hopopt_jumbo_remove(skb)))
+		goto out_drop;
+
 	count = ice_xmit_desc_count(skb);
 	if (ice_chk_linearize(skb, count)) {
 		if (__skb_linearize(skb))
-- 
2.37.3

