Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8A53D0530
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 01:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbhGTWiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 18:38:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:50233 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhGTWhZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 18:37:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10051"; a="211341476"
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="211341476"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2021 16:17:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,256,1620716400"; 
   d="scan'208";a="415407133"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga003.jf.intel.com with ESMTP; 20 Jul 2021 16:17:54 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, vitaly.lifshits@intel.com,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 04/12] e1000e: Add support for Lunar Lake
Date:   Tue, 20 Jul 2021 16:20:53 -0700
Message-Id: <20210720232101.3087589-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
References: <20210720232101.3087589-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add devices IDs for the next LOM generations that will be
available on the next Intel Client platform (Lunar Lake)
This patch provides the initial support for these devices

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 2 ++
 drivers/net/ethernet/intel/e1000e/hw.h      | 5 +++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 7 +++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 6 ++++++
 drivers/net/ethernet/intel/e1000e/ptp.c     | 1 +
 5 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index 06442e6bef73..7256b43b7a65 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -903,6 +903,7 @@ static int e1000_reg_test(struct e1000_adapter *adapter, u64 *data)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		mask |= BIT(18);
 		break;
 	default:
@@ -1569,6 +1570,7 @@ static void e1000_loopback_cleanup(struct e1000_adapter *adapter)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		fext_nvm11 = er32(FEXTNVM11);
 		fext_nvm11 &= ~E1000_FEXTNVM11_DISABLE_MULR_FIX;
 		ew32(FEXTNVM11, fext_nvm11);
diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index db79c4e6413e..36ff936918c9 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -106,6 +106,10 @@ struct e1000_hw;
 #define E1000_DEV_ID_PCH_MTP_I219_V18		0x550B
 #define E1000_DEV_ID_PCH_MTP_I219_LM19		0x550C
 #define E1000_DEV_ID_PCH_MTP_I219_V19		0x550D
+#define E1000_DEV_ID_PCH_LNP_I219_LM20		0x550E
+#define E1000_DEV_ID_PCH_LNP_I219_V20		0x550F
+#define E1000_DEV_ID_PCH_LNP_I219_LM21		0x5510
+#define E1000_DEV_ID_PCH_LNP_I219_V21		0x5511
 
 #define E1000_REVISION_4	4
 
@@ -132,6 +136,7 @@ enum e1000_mac_type {
 	e1000_pch_tgp,
 	e1000_pch_adp,
 	e1000_pch_mtp,
+	e1000_pch_lnp,
 };
 
 enum e1000_media_type {
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index cf7b3887da1d..b75196c6a29b 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -321,6 +321,7 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		if (e1000_phy_is_accessible_pchlan(hw))
 			break;
 
@@ -466,6 +467,7 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 		case e1000_pch_tgp:
 		case e1000_pch_adp:
 		case e1000_pch_mtp:
+		case e1000_pch_lnp:
 			/* In case the PHY needs to be in mdio slow mode,
 			 * set slow mode and try to get the PHY id again.
 			 */
@@ -711,6 +713,7 @@ static s32 e1000_init_mac_params_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 	case e1000_pchlan:
 		/* check management mode */
 		mac->ops.check_mng_mode = e1000_check_mng_mode_pchlan;
@@ -1663,6 +1666,7 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		rc = e1000_init_phy_params_pchlan(hw);
 		break;
 	default:
@@ -2118,6 +2122,7 @@ static s32 e1000_sw_lcd_config_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		sw_cfg_mask = E1000_FEXTNVM_SW_CONFIG_ICH8M;
 		break;
 	default:
@@ -3162,6 +3167,7 @@ static s32 e1000_valid_nvm_bank_detect_ich8lan(struct e1000_hw *hw, u32 *bank)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		bank1_offset = nvm->flash_bank_size;
 		act_offset = E1000_ICH_NVM_SIG_WORD;
 
@@ -4101,6 +4107,7 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		word = NVM_COMPAT;
 		valid_csum_mask = NVM_COMPAT_VALID_CSUM;
 		break;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 79e8791119cd..59f22a75b96d 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3550,6 +3550,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI) {
 			/* Stable 24MHz frequency */
 			incperiod = INCPERIOD_24MHZ;
@@ -4068,6 +4069,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		fc->refresh_time = 0xFFFF;
 		fc->pause_time = 0xFFFF;
 
@@ -7908,6 +7910,10 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V18), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_LM19), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_MTP_I219_V19), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM20), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V20), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_LM21), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_LNP_I219_V21), board_pch_cnp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index 9e79d672f4f1..eb5c014c02fb 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -298,6 +298,7 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
 	case e1000_pch_tgp:
 	case e1000_pch_adp:
 	case e1000_pch_mtp:
+	case e1000_pch_lnp:
 		if ((hw->mac.type < e1000_pch_lpt) ||
 		    (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI)) {
 			adapter->ptp_clock_info.max_adj = 24000000 - 1;
-- 
2.26.2

