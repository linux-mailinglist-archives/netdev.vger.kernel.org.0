Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB173F3045
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241369AbhHTP41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:56:27 -0400
Received: from mga17.intel.com ([192.55.52.151]:53677 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241319AbhHTP4V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:56:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10082"; a="197050457"
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="197050457"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 08:55:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="scan'208";a="680126981"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2021 08:55:43 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dima Ruinskiy <dima.ruinskiy@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 4/4] e1000e: Do not take care about recovery NVM checksum
Date:   Fri, 20 Aug 2021 08:59:15 -0700
Message-Id: <20210820155915.1119889-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
References: <20210820155915.1119889-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

On new platforms, the NVM is read-only. Attempting to update the NVM
is causing a lockup to occur. Do not attempt to write to the NVM
on platforms where it's not supported.
Emit an error message when the NVM checksum is invalid.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=213667
Fixes: fb776f5d57ee ("e1000e: Add support for Tiger Lake")
Suggested-by: Dima Ruinskiy <dima.ruinskiy@intel.com>
Suggested-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 2c412bf9232a..a80336c4319b 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -4127,13 +4127,17 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 		return ret_val;
 
 	if (!(data & valid_csum_mask)) {
-		data |= valid_csum_mask;
-		ret_val = e1000_write_nvm(hw, word, 1, &data);
-		if (ret_val)
-			return ret_val;
-		ret_val = e1000e_update_nvm_checksum(hw);
-		if (ret_val)
-			return ret_val;
+		e_dbg("NVM Checksum Invalid\n");
+
+		if (hw->mac.type < e1000_pch_cnp) {
+			data |= valid_csum_mask;
+			ret_val = e1000_write_nvm(hw, word, 1, &data);
+			if (ret_val)
+				return ret_val;
+			ret_val = e1000e_update_nvm_checksum(hw);
+			if (ret_val)
+				return ret_val;
+		}
 	}
 
 	return e1000e_validate_nvm_checksum_generic(hw);
-- 
2.26.2

