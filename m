Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDEA4658BE
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 23:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353024AbhLAWEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 17:04:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:6240 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239825AbhLAWEF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Dec 2021 17:04:05 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="223795731"
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="223795731"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2021 14:00:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,280,1631602800"; 
   d="scan'208";a="540980321"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga001.jf.intel.com with ESMTP; 01 Dec 2021 14:00:23 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Michal Maloszewski <michal.maloszewski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        sassmann@redhat.com,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: [PATCH net 2/6] iavf: Fix reporting when setting descriptor count
Date:   Wed,  1 Dec 2021 13:59:10 -0800
Message-Id: <20211201215914.1200153-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
References: <20211201215914.1200153-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Maloszewski <michal.maloszewski@intel.com>

iavf_set_ringparams doesn't communicate to the user that

1. The user requested descriptor count is out of range. Instead it
   just quietly sets descriptors to the "clamped" value and calls it
   done. This makes it look an invalid value was successfully set as
   the descriptor count when this isn't actually true.

2. The user provided descriptor count needs to be inflated for alignment
   reasons.

This behavior is confusing. The ice driver has already addressed this
by rejecting invalid values for descriptor count and
messaging for alignment adjustments.
Do the same thing here by adding the error and info messages.

Fixes: fbb7ddfef253 ("i40evf: core ethtool functionality")
Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Signed-off-by: Michal Maloszewski <michal.maloszewski@intel.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 .../net/ethernet/intel/iavf/iavf_ethtool.c    | 43 ++++++++++++++-----
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 0cecaff38d04..a94b26d39594 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -615,23 +615,44 @@ static int iavf_set_ringparam(struct net_device *netdev,
 	if ((ring->rx_mini_pending) || (ring->rx_jumbo_pending))
 		return -EINVAL;
 
-	new_tx_count = clamp_t(u32, ring->tx_pending,
-			       IAVF_MIN_TXD,
-			       IAVF_MAX_TXD);
-	new_tx_count = ALIGN(new_tx_count, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	if (ring->tx_pending > IAVF_MAX_TXD ||
+	    ring->tx_pending < IAVF_MIN_TXD ||
+	    ring->rx_pending > IAVF_MAX_RXD ||
+	    ring->rx_pending < IAVF_MIN_RXD) {
+		netdev_err(netdev, "Descriptors requested (Tx: %d / Rx: %d) out of range [%d-%d] (increment %d)\n",
+			   ring->tx_pending, ring->rx_pending, IAVF_MIN_TXD,
+			   IAVF_MAX_RXD, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+		return -EINVAL;
+	}
 
-	new_rx_count = clamp_t(u32, ring->rx_pending,
-			       IAVF_MIN_RXD,
-			       IAVF_MAX_RXD);
-	new_rx_count = ALIGN(new_rx_count, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	new_tx_count = ALIGN(ring->tx_pending, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	if (new_tx_count != ring->tx_pending)
+		netdev_info(netdev, "Requested Tx descriptor count rounded up to %d\n",
+			    new_tx_count);
+
+	new_rx_count = ALIGN(ring->rx_pending, IAVF_REQ_DESCRIPTOR_MULTIPLE);
+	if (new_rx_count != ring->rx_pending)
+		netdev_info(netdev, "Requested Rx descriptor count rounded up to %d\n",
+			    new_rx_count);
 
 	/* if nothing to do return success */
 	if ((new_tx_count == adapter->tx_desc_count) &&
-	    (new_rx_count == adapter->rx_desc_count))
+	    (new_rx_count == adapter->rx_desc_count)) {
+		netdev_dbg(netdev, "Nothing to change, descriptor count is same as requested\n");
 		return 0;
+	}
 
-	adapter->tx_desc_count = new_tx_count;
-	adapter->rx_desc_count = new_rx_count;
+	if (new_tx_count != adapter->tx_desc_count) {
+		netdev_info(netdev, "Changing Tx descriptor count from %d to %d\n",
+			    adapter->tx_desc_count, new_tx_count);
+		adapter->tx_desc_count = new_tx_count;
+	}
+
+	if (new_rx_count != adapter->rx_desc_count) {
+		netdev_info(netdev, "Changing Rx descriptor count from %d to %d\n",
+			    adapter->rx_desc_count, new_rx_count);
+		adapter->rx_desc_count = new_rx_count;
+	}
 
 	if (netif_running(netdev)) {
 		adapter->flags |= IAVF_FLAG_RESET_NEEDED;
-- 
2.31.1

