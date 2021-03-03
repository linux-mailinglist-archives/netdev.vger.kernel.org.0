Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68BA532C46C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354932AbhCDANs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:13:48 -0500
Received: from mga01.intel.com ([192.55.52.88]:22650 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343679AbhCCPw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 10:52:59 -0500
IronPort-SDR: rV2AFt2wjLAQe7UTU0ft/GR7zE0WuoYWXuTT8kp57iw+jU7PTlTQPHbqMjJmsDxXm9s11aY0Rm
 xTEwMzM0WSwg==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="206909556"
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="206909556"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2021 07:49:42 -0800
IronPort-SDR: 86gi0OMIkXjt6dCztDa0gMgb5OY4fgXTJXIx3DrWTM36X54P+jtgQPq5b/AIKFmUeu51wQsJzo
 wqLvcj9GTgYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,220,1610438400"; 
   d="scan'208";a="518322023"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga004.jf.intel.com with ESMTP; 03 Mar 2021 07:49:39 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, brouer@redhat.com,
        anthony.l.nguyen@intel.com, kuba@kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH intel-net 3/3] ixgbe: move headroom initialization to ixgbe_configure_rx_ring
Date:   Wed,  3 Mar 2021 16:39:28 +0100
Message-Id: <20210303153928.11764-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
References: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index fae84202d870..ac0d7a80de0d 100644
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
2.20.1

