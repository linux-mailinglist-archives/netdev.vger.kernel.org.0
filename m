Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5A53B95D4
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 20:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233851AbhGASEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 14:04:11 -0400
Received: from mga12.intel.com ([192.55.52.136]:63747 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhGASD7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Jul 2021 14:03:59 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10032"; a="188272891"
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="188272891"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2021 11:01:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,315,1616482800"; 
   d="scan'208";a="409018433"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 01 Jul 2021 11:01:27 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net 11/11] igb: Fix position of assignment to *ring
Date:   Thu,  1 Jul 2021 11:04:20 -0700
Message-Id: <20210701180420.346126-12-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
References: <20210701180420.346126-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

Assignment to *ring should be done after correctness check of the
argument queue.

Fixes: 91db364236c8 ("igb: Refactor igb_configure_cbs()")
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 9470ba891483..171a7a629b20 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -1685,14 +1685,15 @@ static bool is_any_txtime_enabled(struct igb_adapter *adapter)
  **/
 static void igb_config_tx_modes(struct igb_adapter *adapter, int queue)
 {
-	struct igb_ring *ring = adapter->tx_ring[queue];
 	struct net_device *netdev = adapter->netdev;
 	struct e1000_hw *hw = &adapter->hw;
+	struct igb_ring *ring;
 	u32 tqavcc, tqavctrl;
 	u16 value;
 
 	WARN_ON(hw->mac.type != e1000_i210);
 	WARN_ON(queue < 0 || queue > 1);
+	ring = adapter->tx_ring[queue];
 
 	/* If any of the Qav features is enabled, configure queues as SR and
 	 * with HIGH PRIO. If none is, then configure them with LOW PRIO and
-- 
2.26.2

