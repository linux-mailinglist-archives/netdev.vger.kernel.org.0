Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A28337BC3
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 19:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhCKSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 13:08:23 -0500
Received: from mga09.intel.com ([134.134.136.24]:47788 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229607AbhCKSIA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 13:08:00 -0500
IronPort-SDR: ECSJtFOpZYM+CcewV+r/DaLm8HEQwgoAlNuOK1ZBWrZ7zaxXm/70JsN6to6zK4HQFSzHEBi2t+
 ePr69nfQBtww==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188809485"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188809485"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 10:07:58 -0800
IronPort-SDR: iIlXC9wHguvceqGMmsr93FzHJNl8U8ruDDE9t7LowxVK6zEnOTsTHLsxQe7L6j5hk46bAl+tCq
 JlU3h7bA0KsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="409570566"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2021 10:07:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 6/6] e1000e: Fix error handling in e1000_set_d0_lplu_state_82571
Date:   Thu, 11 Mar 2021 10:09:15 -0800
Message-Id: <20210311180915.1489936-7-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
References: <20210311180915.1489936-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

There is one e1e_wphy() call in e1000_set_d0_lplu_state_82571
that we have caught its return value but lack further handling.
Check and terminate the execution flow just like other e1e_wphy()
in this function.

Fixes: bc7f75fa9788 ("[E1000E]: New pci-express e1000 driver (currently for ICH9 devices only)")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/82571.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/82571.c b/drivers/net/ethernet/intel/e1000e/82571.c
index 88faf05e23ba..0b1e890dd583 100644
--- a/drivers/net/ethernet/intel/e1000e/82571.c
+++ b/drivers/net/ethernet/intel/e1000e/82571.c
@@ -899,6 +899,8 @@ static s32 e1000_set_d0_lplu_state_82571(struct e1000_hw *hw, bool active)
 	} else {
 		data &= ~IGP02E1000_PM_D0_LPLU;
 		ret_val = e1e_wphy(hw, IGP02E1000_PHY_POWER_MGMT, data);
+		if (ret_val)
+			return ret_val;
 		/* LPLU and SmartSpeed are mutually exclusive.  LPLU is used
 		 * during Dx states where the power conservation is most
 		 * important.  During driver activity we should enable
-- 
2.26.2

