Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 552FA2D2BE
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727557AbfE2ARf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 20:17:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:59374 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727483AbfE2ARa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 20:17:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 17:17:28 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 28 May 2019 17:17:27 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/10] igc: Cleanup the redundant code
Date:   Tue, 28 May 2019 17:17:26 -0700
Message-Id: <20190529001726.26097-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
References: <20190529001726.26097-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The default flow control settings for the i225 device is both
'rx' and 'tx' pause frames. There is no depend on the NVM value.
This patch comes to fix this and clean up the driver code.

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index f7683d3ae47c..ba4646737288 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -8,7 +8,6 @@
 #include "igc_hw.h"
 
 /* forward declaration */
-static s32 igc_set_default_fc(struct igc_hw *hw);
 static s32 igc_set_fc_watermarks(struct igc_hw *hw);
 
 /**
@@ -96,13 +95,10 @@ s32 igc_setup_link(struct igc_hw *hw)
 		goto out;
 
 	/* If requested flow control is set to default, set flow control
-	 * based on the EEPROM flow control settings.
+	 * to the both 'rx' and 'tx' pause frames.
 	 */
-	if (hw->fc.requested_mode == igc_fc_default) {
-		ret_val = igc_set_default_fc(hw);
-		if (ret_val)
-			goto out;
-	}
+	if (hw->fc.requested_mode == igc_fc_default)
+		hw->fc.requested_mode = igc_fc_full;
 
 	/* We want to save off the original Flow Control configuration just
 	 * in case we get disconnected and then reconnected into a different
@@ -135,19 +131,6 @@ s32 igc_setup_link(struct igc_hw *hw)
 	return ret_val;
 }
 
-/**
- * igc_set_default_fc - Set flow control default values
- * @hw: pointer to the HW structure
- *
- * Read the EEPROM for the default values for flow control and store the
- * values.
- */
-static s32 igc_set_default_fc(struct igc_hw *hw)
-{
-	hw->fc.requested_mode = igc_fc_full;
-	return 0;
-}
-
 /**
  * igc_force_mac_fc - Force the MAC's flow control settings
  * @hw: pointer to the HW structure
-- 
2.21.0

