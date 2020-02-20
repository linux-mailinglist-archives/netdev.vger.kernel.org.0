Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 840141653F2
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgBTA5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:57:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:33267 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727338AbgBTA5S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:57:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Feb 2020 16:57:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,462,1574150400"; 
   d="scan'208";a="408621355"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.76])
  by orsmga005.jf.intel.com with ESMTP; 19 Feb 2020 16:57:15 -0800
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Sasha Neftin <sasha.neftin@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/12] e1000e: Add support for Alder Lake
Date:   Wed, 19 Feb 2020 16:57:07 -0800
Message-Id: <20200220005713.682605-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
References: <20200220005713.682605-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sasha Neftin <sasha.neftin@intel.com>

Add devices ID's for the next LOM generations that will be
available on the next Intel Client platform (Alder Lake)
This patch provides the initial support for these devices

Signed-off-by: Sasha Neftin <sasha.neftin@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/e1000e/ethtool.c | 2 ++
 drivers/net/ethernet/intel/e1000e/hw.h      | 5 +++++
 drivers/net/ethernet/intel/e1000e/ich8lan.c | 7 +++++++
 drivers/net/ethernet/intel/e1000e/netdev.c  | 6 ++++++
 drivers/net/ethernet/intel/e1000e/ptp.c     | 1 +
 5 files changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/intel/e1000e/ethtool.c b/drivers/net/ethernet/intel/e1000e/ethtool.c
index adce7e319b9e..9e7881db7859 100644
--- a/drivers/net/ethernet/intel/e1000e/ethtool.c
+++ b/drivers/net/ethernet/intel/e1000e/ethtool.c
@@ -897,6 +897,7 @@ static int e1000_reg_test(struct e1000_adapter *adapter, u64 *data)
 	case e1000_pch_cnp:
 		/* fall through */
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		mask |= BIT(18);
 		break;
 	default:
@@ -1561,6 +1562,7 @@ static void e1000_loopback_cleanup(struct e1000_adapter *adapter)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		fext_nvm11 = er32(FEXTNVM11);
 		fext_nvm11 &= ~E1000_FEXTNVM11_DISABLE_MULR_FIX;
 		ew32(FEXTNVM11, fext_nvm11);
diff --git a/drivers/net/ethernet/intel/e1000e/hw.h b/drivers/net/ethernet/intel/e1000e/hw.h
index f556163481cb..a1dbf8df1c70 100644
--- a/drivers/net/ethernet/intel/e1000e/hw.h
+++ b/drivers/net/ethernet/intel/e1000e/hw.h
@@ -97,6 +97,10 @@ struct e1000_hw;
 #define E1000_DEV_ID_PCH_TGP_I219_LM14		0x15F9
 #define E1000_DEV_ID_PCH_TGP_I219_V14		0x15FA
 #define E1000_DEV_ID_PCH_TGP_I219_LM15		0x15F4
+#define E1000_DEV_ID_PCH_ADP_I219_LM16		0x1A1E
+#define E1000_DEV_ID_PCH_ADP_I219_V16		0x1A1F
+#define E1000_DEV_ID_PCH_ADP_I219_LM17		0x1A1C
+#define E1000_DEV_ID_PCH_ADP_I219_V17		0x1A1D
 
 #define E1000_REVISION_4	4
 
@@ -121,6 +125,7 @@ enum e1000_mac_type {
 	e1000_pch_spt,
 	e1000_pch_cnp,
 	e1000_pch_tgp,
+	e1000_pch_adp,
 };
 
 enum e1000_media_type {
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index b4135c50e905..735bf25952fc 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -317,6 +317,7 @@ static s32 e1000_init_phy_workarounds_pchlan(struct e1000_hw *hw)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		if (e1000_phy_is_accessible_pchlan(hw))
 			break;
 
@@ -460,6 +461,7 @@ static s32 e1000_init_phy_params_pchlan(struct e1000_hw *hw)
 		case e1000_pch_spt:
 		case e1000_pch_cnp:
 		case e1000_pch_tgp:
+		case e1000_pch_adp:
 			/* In case the PHY needs to be in mdio slow mode,
 			 * set slow mode and try to get the PHY id again.
 			 */
@@ -703,6 +705,7 @@ static s32 e1000_init_mac_params_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 	case e1000_pchlan:
 		/* check management mode */
 		mac->ops.check_mng_mode = e1000_check_mng_mode_pchlan;
@@ -1642,6 +1645,7 @@ static s32 e1000_get_variants_ich8lan(struct e1000_adapter *adapter)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		rc = e1000_init_phy_params_pchlan(hw);
 		break;
 	default:
@@ -2095,6 +2099,7 @@ static s32 e1000_sw_lcd_config_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		sw_cfg_mask = E1000_FEXTNVM_SW_CONFIG_ICH8M;
 		break;
 	default:
@@ -3133,6 +3138,7 @@ static s32 e1000_valid_nvm_bank_detect_ich8lan(struct e1000_hw *hw, u32 *bank)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		bank1_offset = nvm->flash_bank_size;
 		act_offset = E1000_ICH_NVM_SIG_WORD;
 
@@ -4077,6 +4083,7 @@ static s32 e1000_validate_nvm_checksum_ich8lan(struct e1000_hw *hw)
 	case e1000_pch_spt:
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		word = NVM_COMPAT;
 		valid_csum_mask = NVM_COMPAT_VALID_CSUM;
 		break;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 618c218978fe..59db2a865aa8 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -3536,6 +3536,7 @@ s32 e1000e_get_base_timinca(struct e1000_adapter *adapter, u32 *timinca)
 		break;
 	case e1000_pch_cnp:
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		if (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI) {
 			/* Stable 24MHz frequency */
 			incperiod = INCPERIOD_24MHZ;
@@ -4049,6 +4050,7 @@ void e1000e_reset(struct e1000_adapter *adapter)
 	case e1000_pch_cnp:
 		/* fall-through */
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		fc->refresh_time = 0xFFFF;
 		fc->pause_time = 0xFFFF;
 
@@ -7760,6 +7762,10 @@ static const struct pci_device_id e1000_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM14), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_V14), board_pch_cnp },
 	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_TGP_I219_LM15), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM16), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V16), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_LM17), board_pch_cnp },
+	{ PCI_VDEVICE(INTEL, E1000_DEV_ID_PCH_ADP_I219_V17), board_pch_cnp },
 
 	{ 0, 0, 0, 0, 0, 0, 0 }	/* terminate list */
 };
diff --git a/drivers/net/ethernet/intel/e1000e/ptp.c b/drivers/net/ethernet/intel/e1000e/ptp.c
index eaa5a0fb99f0..439fda2f5368 100644
--- a/drivers/net/ethernet/intel/e1000e/ptp.c
+++ b/drivers/net/ethernet/intel/e1000e/ptp.c
@@ -297,6 +297,7 @@ void e1000e_ptp_init(struct e1000_adapter *adapter)
 	case e1000_pch_cnp:
 		/* fall-through */
 	case e1000_pch_tgp:
+	case e1000_pch_adp:
 		if ((hw->mac.type < e1000_pch_lpt) ||
 		    (er32(TSYNCRXCTL) & E1000_TSYNCRXCTL_SYSCFI)) {
 			adapter->ptp_clock_info.max_adj = 24000000 - 1;
-- 
2.24.1

