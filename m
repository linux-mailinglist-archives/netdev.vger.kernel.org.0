Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7EE61A2BB
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiKDUy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKDUy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:54:27 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737ED1274C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667595266; x=1699131266;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FhmNrjAbA5AVghfSb9KCJqDxVRHXHT5WIKlHZb4UMcI=;
  b=JcasVF9aC3EXyCd5xJUTJAT0aXuMnZve1Gp8/FQowdUJF+2QblY9F74w
   jeHD0wUnjMqqpoaf9aOKfJbB/X0UdYZ+FWmGGVqBCuuhGhi8ZWpDNAFFn
   TC3xVVGf774u0YSGHu6orT7PrDGps4ZK3H1w1UxNU0CFsHGOUCmgBJLfC
   gnNnC5AJVFfBu4hPSviqnpw+Ter/uPHPHCvGXMciLbh68WpcD1DYePyzK
   uXleCsWcEI4SmkkWBavlt+pjQxPjKRB+xz/0lN4ThCcYYw73b/RObvIOH
   0aZp6/rLv0z+KqQ9/i1upQ1jSVWzIVKfZPYmSAU+iTgpSrtOgH9Ch7Xwm
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="372177362"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="372177362"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2022 13:54:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10521"; a="637716204"
X-IronPort-AV: E=Sophos;i="5.96,138,1665471600"; 
   d="scan'208";a="637716204"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 04 Nov 2022 13:54:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Daniel Willenson <daniel@veobot.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, Gurucharan <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/6] ixgbe: change MAX_RXD/MAX_TXD based on adapter type
Date:   Fri,  4 Nov 2022 13:54:09 -0700
Message-Id: <20221104205414.2354973-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Willenson <daniel@veobot.com>

Set the length limit for the receive descriptor buffer and transmit
descriptor buffer based on the controller type. The values used are called
out in the controller datasheets as a 'Note:' in the RDLEN and TDLEN
register descriptions.

This allows the user to use ethtool to allocate larger descriptor buffers
in the case where data is received or transmitted too quickly for the
driver to keep up.

Signed-off-by: Daniel Willenson <daniel@veobot.com>
Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe.h      | 10 ++++-
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  | 44 +++++++++++++++++--
 2 files changed, 48 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 5369a97ff5ec..bc68b8f2176d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -39,7 +39,10 @@
 /* TX/RX descriptor defines */
 #define IXGBE_DEFAULT_TXD		    512
 #define IXGBE_DEFAULT_TX_WORK		    256
-#define IXGBE_MAX_TXD			   4096
+#define IXGBE_MAX_TXD_82598		   4096
+#define IXGBE_MAX_TXD_82599		   8192
+#define IXGBE_MAX_TXD_X540		   8192
+#define IXGBE_MAX_TXD_X550		  32768
 #define IXGBE_MIN_TXD			     64
 
 #if (PAGE_SIZE < 8192)
@@ -47,7 +50,10 @@
 #else
 #define IXGBE_DEFAULT_RXD		    128
 #endif
-#define IXGBE_MAX_RXD			   4096
+#define IXGBE_MAX_RXD_82598		   4096
+#define IXGBE_MAX_RXD_82599		   8192
+#define IXGBE_MAX_RXD_X540		   8192
+#define IXGBE_MAX_RXD_X550		  32768
 #define IXGBE_MIN_RXD			     64
 
 /* flow control */
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index eda7188e8df4..d737e851a9e0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -1117,6 +1117,42 @@ static void ixgbe_get_drvinfo(struct net_device *netdev,
 	drvinfo->n_priv_flags = IXGBE_PRIV_FLAGS_STR_LEN;
 }
 
+static u32 ixgbe_get_max_rxd(struct ixgbe_adapter *adapter)
+{
+	switch (adapter->hw.mac.type) {
+	case ixgbe_mac_82598EB:
+		return IXGBE_MAX_RXD_82598;
+	case ixgbe_mac_82599EB:
+		return IXGBE_MAX_RXD_82599;
+	case ixgbe_mac_X540:
+		return IXGBE_MAX_RXD_X540;
+	case ixgbe_mac_X550:
+	case ixgbe_mac_X550EM_x:
+	case ixgbe_mac_x550em_a:
+		return IXGBE_MAX_RXD_X550;
+	default:
+		return IXGBE_MAX_RXD_82598;
+	}
+}
+
+static u32 ixgbe_get_max_txd(struct ixgbe_adapter *adapter)
+{
+	switch (adapter->hw.mac.type) {
+	case ixgbe_mac_82598EB:
+		return IXGBE_MAX_TXD_82598;
+	case ixgbe_mac_82599EB:
+		return IXGBE_MAX_TXD_82599;
+	case ixgbe_mac_X540:
+		return IXGBE_MAX_TXD_X540;
+	case ixgbe_mac_X550:
+	case ixgbe_mac_X550EM_x:
+	case ixgbe_mac_x550em_a:
+		return IXGBE_MAX_TXD_X550;
+	default:
+		return IXGBE_MAX_TXD_82598;
+	}
+}
+
 static void ixgbe_get_ringparam(struct net_device *netdev,
 				struct ethtool_ringparam *ring,
 				struct kernel_ethtool_ringparam *kernel_ring,
@@ -1126,8 +1162,8 @@ static void ixgbe_get_ringparam(struct net_device *netdev,
 	struct ixgbe_ring *tx_ring = adapter->tx_ring[0];
 	struct ixgbe_ring *rx_ring = adapter->rx_ring[0];
 
-	ring->rx_max_pending = IXGBE_MAX_RXD;
-	ring->tx_max_pending = IXGBE_MAX_TXD;
+	ring->rx_max_pending = ixgbe_get_max_rxd(adapter);
+	ring->tx_max_pending = ixgbe_get_max_txd(adapter);
 	ring->rx_pending = rx_ring->count;
 	ring->tx_pending = tx_ring->count;
 }
@@ -1146,11 +1182,11 @@ static int ixgbe_set_ringparam(struct net_device *netdev,
 		return -EINVAL;
 
 	new_tx_count = clamp_t(u32, ring->tx_pending,
-			       IXGBE_MIN_TXD, IXGBE_MAX_TXD);
+			       IXGBE_MIN_TXD, ixgbe_get_max_txd(adapter));
 	new_tx_count = ALIGN(new_tx_count, IXGBE_REQ_TX_DESCRIPTOR_MULTIPLE);
 
 	new_rx_count = clamp_t(u32, ring->rx_pending,
-			       IXGBE_MIN_RXD, IXGBE_MAX_RXD);
+			       IXGBE_MIN_RXD, ixgbe_get_max_rxd(adapter));
 	new_rx_count = ALIGN(new_rx_count, IXGBE_REQ_RX_DESCRIPTOR_MULTIPLE);
 
 	if ((new_tx_count == adapter->tx_ring_count) &&
-- 
2.35.1

