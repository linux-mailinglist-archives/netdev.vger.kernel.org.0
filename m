Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF2433955D
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 18:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232626AbhCLRrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 12:47:12 -0500
Received: from mga06.intel.com ([134.134.136.31]:9116 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231636AbhCLRqj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 12:46:39 -0500
IronPort-SDR: 23OxUva0vixwFZ/0cRrbf5gdkA5IgiKsmS5IjyiREmqaEAssAcdPT0hVp1gERHea7gYG0c4odu
 er63Qn1dMVJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="250232658"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="250232658"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 09:46:38 -0800
IronPort-SDR: rp+J/uAWRgt4COy/mzmQPL48aSpWfOVSW0yzdeEYMsrw594wHB4Mm5cWInxc56OAmkGD3NpfSA
 hx/sePMpwlyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="scan'208";a="589615856"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga005.jf.intel.com with ESMTP; 12 Mar 2021 09:46:38 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Vishakha Jambekar <vishakha.jambekar@intel.com>
Subject: [PATCH net 4/5] ixgbe: move headroom initialization to ixgbe_configure_rx_ring
Date:   Fri, 12 Mar 2021 09:47:54 -0800
Message-Id: <20210312174755.2103336-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
References: <20210312174755.2103336-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

ixgbe_rx_offset(), that is supposed to initialize the Rx buffer headroom,
relies on __IXGBE_RX_BUILD_SKB_ENABLED flag.

Currently, the callsite of mentioned function is placed incorrectly
within ixgbe_setup_rx_resources() where Rx ring's build skb flag is not
set yet. This causes the XDP_REDIRECT to be partially broken due to
inability to create xdp_frame in the headroom space, as the headroom is
0.

Fix this by moving ixgbe_rx_offset() to ixgbe_configure_rx_ring() after
the flag setting, which happens to be set in ixgbe_set_rx_buffer_len.

Fixes: c0d4e9d223c5 ("ixgbe: store the result of ixgbe_rx_offset() onto ixgbe_ring")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 9f3f12e2ccf2..03d9aad516d4 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -4118,6 +4118,8 @@ void ixgbe_configure_rx_ring(struct ixgbe_adapter *adapter,
 #endif
 	}
 
+	ring->rx_offset = ixgbe_rx_offset(ring);
+
 	if (ring->xsk_pool && hw->mac.type != ixgbe_mac_82599EB) {
 		u32 xsk_buf_len = xsk_pool_get_rx_frame_size(ring->xsk_pool);
 
@@ -6578,7 +6580,6 @@ int ixgbe_setup_rx_resources(struct ixgbe_adapter *adapter,
 
 	rx_ring->next_to_clean = 0;
 	rx_ring->next_to_use = 0;
-	rx_ring->rx_offset = ixgbe_rx_offset(rx_ring);
 
 	/* XDP RX-queue info */
 	if (xdp_rxq_info_reg(&rx_ring->xdp_rxq, adapter->netdev,
-- 
2.26.2

