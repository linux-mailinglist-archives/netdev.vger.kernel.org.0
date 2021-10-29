Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61D1440161
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhJ2Rpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 13:45:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:63752 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229837AbhJ2Rpk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 13:45:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10152"; a="210767116"
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="210767116"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2021 10:42:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="574760213"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by FMSMGA003.fm.intel.com with ESMTP; 29 Oct 2021 10:42:41 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Nechama Kraus <nechamax.kraus@linux.intel.com>
Subject: [PATCH net-next 3/3] igc: Change Device Reset to Port Reset
Date:   Fri, 29 Oct 2021 10:41:01 -0700
Message-Id: <20211029174101.2970935-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
References: <20211029174101.2970935-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

The _reset_hw_base method switched from port reset (CTRL[26]) to device
reset (CTRL[29]) since the FW was receiving an interrupt on CTRL[29].
FW code was later modified to also receive an interrupt on CTRL[26].
Since certain HW values are not reset to default by CTRL[29], we go back
to CTRL[26] for the HW reset, as it meets all current requirements.

This reverts commit bb4265ec24c1 ("igc: Update the MAC reset flow").

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Nechama Kraus <nechamax.kraus@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_base.c    | 2 +-
 drivers/net/ethernet/intel/igc/igc_defines.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_base.c b/drivers/net/ethernet/intel/igc/igc_base.c
index 2612a58fc52a..f068b66b8025 100644
--- a/drivers/net/ethernet/intel/igc/igc_base.c
+++ b/drivers/net/ethernet/intel/igc/igc_base.c
@@ -40,7 +40,7 @@ static s32 igc_reset_hw_base(struct igc_hw *hw)
 	ctrl = rd32(IGC_CTRL);
 
 	hw_dbg("Issuing a global reset to MAC\n");
-	wr32(IGC_CTRL, ctrl | IGC_CTRL_DEV_RST);
+	wr32(IGC_CTRL, ctrl | IGC_CTRL_RST);
 
 	ret_val = igc_get_auto_rd_done(hw);
 	if (ret_val) {
diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index a4bbee748798..c7fe61509d5b 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -130,7 +130,7 @@
 #define IGC_ERR_SWFW_SYNC		13
 
 /* Device Control */
-#define IGC_CTRL_DEV_RST	0x20000000  /* Device reset */
+#define IGC_CTRL_RST		0x04000000  /* Global reset */
 
 #define IGC_CTRL_PHY_RST	0x80000000  /* PHY Reset */
 #define IGC_CTRL_SLU		0x00000040  /* Set link up (Force Link) */
-- 
2.31.1

