Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57A42C2D7E
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403816AbgKXQxJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:53:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:45927 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403807AbgKXQxH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:53:07 -0500
IronPort-SDR: LDwWNyC8KdBKd98780TGQafYLRh1ibSfpN4yOtK8brjDJaL5bcnkPgc1Vz0O52DoZP2LwFhjJ8
 iu69PAbV6sGw==
X-IronPort-AV: E=McAfee;i="6000,8403,9815"; a="172134515"
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="172134515"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2020 08:53:05 -0800
IronPort-SDR: 47S1SMUnrqvLWgUgsMfsfjN+vCC+PjZKiL7KPro3thuwY3lJ2dMWij8vIZtrGzMAVb3e8Q9ymg
 LnQmW2EdD6WQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,366,1599548400"; 
   d="scan'208";a="365068662"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga002.fm.intel.com with ESMTP; 24 Nov 2020 08:53:05 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Karen Sornek <karen.sornek@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v2 3/3] igbvf: Refactor traces
Date:   Tue, 24 Nov 2020 08:52:45 -0800
Message-Id: <20201124165245.2844118-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
References: <20201124165245.2844118-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karen Sornek <karen.sornek@intel.com>

Refactoring "PF still resetting" and changing "Failed
 to add vlan id" to "Vlan id is not added"
messages because previous version looked like a bug
- it informed about changes that worked as
designed but might confuse users

Signed-off-by: Karen Sornek <karen.sornek@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igbvf/netdev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index ee9f8c1dca83..30fdea24e94a 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -1236,7 +1236,7 @@ static int igbvf_vlan_rx_add_vid(struct net_device *netdev,
 	spin_lock_bh(&hw->mbx_lock);
 
 	if (hw->mac.ops.set_vfta(hw, vid, true)) {
-		dev_err(&adapter->pdev->dev, "Failed to add vlan id %d\n", vid);
+		dev_warn(&adapter->pdev->dev, "Vlan id %d\n is not added", vid);
 		spin_unlock_bh(&hw->mbx_lock);
 		return -EINVAL;
 	}
@@ -1520,7 +1520,7 @@ static void igbvf_reset(struct igbvf_adapter *adapter)
 
 	/* Allow time for pending master requests to run */
 	if (mac->ops.reset_hw(hw))
-		dev_err(&adapter->pdev->dev, "PF still resetting\n");
+		dev_warn(&adapter->pdev->dev, "PF still resetting\n");
 
 	mac->ops.init_hw(hw);
 
-- 
2.26.2

