Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07108EB99E
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387463AbfJaWRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:17:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:61771 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbfJaWRW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 31 Oct 2019 18:17:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Oct 2019 15:17:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,253,1569308400"; 
   d="scan'208";a="199662501"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga007.fm.intel.com with ESMTP; 31 Oct 2019 15:17:21 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Manfred Rudigier <manfred.rudigier@omicronenergy.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/7] igb: Enable media autosense for the i350.
Date:   Thu, 31 Oct 2019 15:17:14 -0700
Message-Id: <20191031221719.14028-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
References: <20191031221719.14028-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Manfred Rudigier <manfred.rudigier@omicronenergy.com>

This patch enables the hardware feature "Media Auto Sense" also on the
i350. It works in the same way as on the 82850 devices. Hardware designs
using dual PHYs (fiber/copper) can enable this feature by setting the MAS
enable bits in the NVM_COMPAT register (0x03) in the EEPROM.

Signed-off-by: Manfred Rudigier <manfred.rudigier@omicronenergy.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_82575.c | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 3ec2ce0725d5..8a6ef3514129 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -466,7 +466,7 @@ static s32 igb_init_mac_params_82575(struct e1000_hw *hw)
 			? igb_setup_copper_link_82575
 			: igb_setup_serdes_link_82575;
 
-	if (mac->type == e1000_82580) {
+	if (mac->type == e1000_82580 || mac->type == e1000_i350) {
 		switch (hw->device_id) {
 		/* feature not supported on these id's */
 		case E1000_DEV_ID_DH89XXCC_SGMII:
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 31b9e02875cc..17a961c3d6e4 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2371,7 +2371,7 @@ void igb_reset(struct igb_adapter *adapter)
 		adapter->ei.get_invariants(hw);
 		adapter->flags &= ~IGB_FLAG_MEDIA_RESET;
 	}
-	if ((mac->type == e1000_82575) &&
+	if ((mac->type == e1000_82575 || mac->type == e1000_i350) &&
 	    (adapter->flags & IGB_FLAG_MAS_ENABLE)) {
 		igb_enable_mas(adapter);
 	}
-- 
2.21.0

