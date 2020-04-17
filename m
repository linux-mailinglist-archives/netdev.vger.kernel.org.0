Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEE61AE504
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 20:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729901AbgDQSm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 14:42:58 -0400
Received: from mga03.intel.com ([134.134.136.65]:31355 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbgDQSm4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Apr 2020 14:42:56 -0400
IronPort-SDR: FEXWCEnqFhOP8Wcdj6gvlig/JKD8GeDJwmyY69TU44kq/QC2O3iEi3nwoDEv7FiqhPHfrVW9kR
 6IF6xCO7nP1w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 11:42:53 -0700
IronPort-SDR: /Fy9q18mpJrgSM8hvPMK7P4n6mITXEI2E+x+BahsgLDYWIFlB/yILF5mE/yvAT7KcYlmG39J5y
 gqRzE4+z5n7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,395,1580803200"; 
   d="scan'208";a="254294390"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 11:42:52 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/14] igc: Remove copper fiber switch control
Date:   Fri, 17 Apr 2020 11:42:48 -0700
Message-Id: <20200417184251.1962762-12-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
References: <20200417184251.1962762-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

i225 device support copper mode only
PHY signal detect indication for copper fiber switch
not applicable to i225 part

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 --
 drivers/net/ethernet/intel/igc/igc_main.c    | 9 ---------
 2 files changed, 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 40d6f557079b..42fe4d75cc0d 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -91,8 +91,6 @@
 #define IGC_CTRL_RFCE		0x08000000  /* Receive Flow Control enable */
 #define IGC_CTRL_TFCE		0x10000000  /* Transmit flow control enable */
 
-#define IGC_CONNSW_AUTOSENSE_EN	0x1
-
 /* As per the EAS the maximum supported size is 9.5KB (9728 bytes) */
 #define MAX_JUMBO_FRAME_SIZE	0x2600
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 800268da0834..44366c1bec19 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -4033,7 +4033,6 @@ static void igc_watchdog_task(struct work_struct *work)
 	struct igc_hw *hw = &adapter->hw;
 	struct igc_phy_info *phy = &hw->phy;
 	u16 phy_data, retry_count = 20;
-	u32 connsw;
 	u32 link;
 	int i;
 
@@ -4046,14 +4045,6 @@ static void igc_watchdog_task(struct work_struct *work)
 			link = false;
 	}
 
-	/* Force link down if we have fiber to swap to */
-	if (adapter->flags & IGC_FLAG_MAS_ENABLE) {
-		if (hw->phy.media_type == igc_media_type_copper) {
-			connsw = rd32(IGC_CONNSW);
-			if (!(connsw & IGC_CONNSW_AUTOSENSE_EN))
-				link = 0;
-		}
-	}
 	if (link) {
 		/* Cancel scheduled suspend requests. */
 		pm_runtime_resume(netdev->dev.parent);
-- 
2.25.2

