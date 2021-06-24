Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7163B366F
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhFXTCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:02:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:39678 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229464AbhFXTCs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:02:48 -0400
IronPort-SDR: ywq3aHVl8RuWwIowcIMwoll7zUpAUAd48CG8UvWzaednPRqifv+4SQ6eA8XGbEZhdcs5snUNKh
 BaZK/eL1wuuw==
X-IronPort-AV: E=McAfee;i="6200,9189,10025"; a="229130283"
X-IronPort-AV: E=Sophos;i="5.83,297,1616482800"; 
   d="scan'208";a="229130283"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2021 12:00:27 -0700
IronPort-SDR: jC4nj+nrhXK5S2H9wTZCBwpfPV0KnxYu1YVGahqBbLXW4Yau8y9diWLuWKUZHUIYoJhi1d+jii
 II9zDN7Yxs6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,297,1616482800"; 
   d="scan'208";a="418169902"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 24 Jun 2021 12:00:26 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net 1/1] e1000e: Check the PCIm state
Date:   Thu, 24 Jun 2021 12:02:48 -0700
Message-Id: <20210624190248.1213590-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Complete to commit def4ec6dce393e ("e1000e: PCIm function state support")
Check the PCIm state only on CSME systems. There is no point to do this
check on non CSME systems.
This patch fixes a generation a false-positive warning:
"Error in exiting dmoff"

Fixes: def4ec6dce39 ("e1000e: PCIm function state support")
Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/netdev.c | 24 ++++++++++++----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 88e9035b75cf..dc0ded7e5e61 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5223,18 +5223,20 @@ static void e1000_watchdog_task(struct work_struct *work)
 			pm_runtime_resume(netdev->dev.parent);
 
 			/* Checking if MAC is in DMoff state*/
-			pcim_state = er32(STATUS);
-			while (pcim_state & E1000_STATUS_PCIM_STATE) {
-				if (tries++ == dmoff_exit_timeout) {
-					e_dbg("Error in exiting dmoff\n");
-					break;
-				}
-				usleep_range(10000, 20000);
+			if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
 				pcim_state = er32(STATUS);
-
-				/* Checking if MAC exited DMoff state */
-				if (!(pcim_state & E1000_STATUS_PCIM_STATE))
-					e1000_phy_hw_reset(&adapter->hw);
+				while (pcim_state & E1000_STATUS_PCIM_STATE) {
+					if (tries++ == dmoff_exit_timeout) {
+						e_dbg("Error in exiting dmoff\n");
+						break;
+					}
+					usleep_range(10000, 20000);
+					pcim_state = er32(STATUS);
+
+					/* Checking if MAC exited DMoff state */
+					if (!(pcim_state & E1000_STATUS_PCIM_STATE))
+						e1000_phy_hw_reset(&adapter->hw);
+				}
 			}
 
 			/* update snapshot of PHY registers on LSC */
-- 
2.26.2

