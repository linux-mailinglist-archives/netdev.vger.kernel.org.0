Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36B86337BC2
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhCKSIV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:08:21 -0500
Received: from mga09.intel.com ([134.134.136.24]:47785 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhCKSH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:07:59 -0500
IronPort-SDR: Y16+AM5OE2qxSGa5WhKBR+pITrNuLkopzTO/DJmy8ahW2OF+XnHz3aFoSwkEH/Q84lplJuJ3a1
 J4JFk6yq6+sQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188809480"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188809480"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:07:58 -0800
IronPort-SDR: 1nIaSqQ+8SZSDEUSSLLafwRJ7iQ6GIj2yIO5rGwC7Q+JK+1eyGF/3DbGSdmZ6PW/3x/b1C26Qa
 j44kC6C4bNMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="409570551"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 10:07:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 1/6] igc: reinit_locked() should be called with rtnl_lock
Date:   Thu, 11 Mar 2021 10:09:10 -0800
Message-Id: <20210311180915.1489936-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
References: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

This commit applies to the igc_reset_task the same changes that
were applied to the igb driver in commit 024a8168b749 ("igb:
reinit_locked() should be called with rtnl_lock")
and fix possible race in reset subtask.

Fixes: 0507ef8a0372 ("igc: Add transmit and receive fastpath and interrupt handlers")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 7ac9597ddb84..4d989ebc9713 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3831,10 +3831,19 @@ static void igc_reset_task(struct work_struct *work)
 
 	adapter = container_of(work, struct igc_adapter, reset_task);
 
+	rtnl_lock();
+	/* If we're already down or resetting, just bail */
+	if (test_bit(__IGC_DOWN, &adapter->state) ||
+	    test_bit(__IGC_RESETTING, &adapter->state)) {
+		rtnl_unlock();
+		return;
+	}
+
 	igc_rings_dump(adapter);
 	igc_regs_dump(adapter);
 	netdev_err(adapter->netdev, "Reset adapter\n");
 	igc_reinit_locked(adapter);
+	rtnl_unlock();
 }
 
 /**
-- 
2.26.2

