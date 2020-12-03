Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27E52CD7CE
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389068AbgLCN37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:29:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:47782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388889AbgLCN36 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 08:29:58 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 07/39] iwlwifi: pcie: set LTR to avoid completion timeout
Date:   Thu,  3 Dec 2020 08:28:01 -0500
Message-Id: <20201203132834.930999-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit edb625208d84aef179e3f16590c1c582fc5fdae6 ]

On some platforms, the preset values aren't correct and then we may
get a completion timeout in the firmware. Change the LTR configuration
to avoid that. The firmware will do some more complex reinit of this
later, but for the boot process we use ~250usec.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20201107104557.d83d591c05ba.I42885c9fb500bc08b9a4c07c4ff3d436cc7a3c84@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  | 10 ++++++++++
 .../intel/iwlwifi/pcie/ctxt-info-gen3.c       | 20 +++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index cb9e8e189a1a4..1d48c7d7fffd4 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -147,6 +147,16 @@
 #define CSR_MAC_SHADOW_REG_CTL2		(CSR_BASE + 0x0AC)
 #define CSR_MAC_SHADOW_REG_CTL2_RX_WAKE	0xFFFF
 
+/* LTR control (since IWL_DEVICE_FAMILY_22000) */
+#define CSR_LTR_LONG_VAL_AD			(CSR_BASE + 0x0D4)
+#define CSR_LTR_LONG_VAL_AD_NO_SNOOP_REQ	0x80000000
+#define CSR_LTR_LONG_VAL_AD_NO_SNOOP_SCALE	0x1c000000
+#define CSR_LTR_LONG_VAL_AD_NO_SNOOP_VAL	0x03ff0000
+#define CSR_LTR_LONG_VAL_AD_SNOOP_REQ		0x00008000
+#define CSR_LTR_LONG_VAL_AD_SNOOP_SCALE		0x00001c00
+#define CSR_LTR_LONG_VAL_AD_SNOOP_VAL		0x000003ff
+#define CSR_LTR_LONG_VAL_AD_SCALE_USEC		2
+
 /* GIO Chicken Bits (PCI Express bus link power management) */
 #define CSR_GIO_CHICKEN_BITS    (CSR_BASE+0x100)
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
index 1ab1366004159..0fc2a6e49f9ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c
@@ -252,6 +252,26 @@ int iwl_pcie_ctxt_info_gen3_init(struct iwl_trans *trans,
 
 	iwl_set_bit(trans, CSR_CTXT_INFO_BOOT_CTRL,
 		    CSR_AUTO_FUNC_BOOT_ENA);
+
+	if (trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_AX210) {
+		/*
+		 * The firmware initializes this again later (to a smaller
+		 * value), but for the boot process initialize the LTR to
+		 * ~250 usec.
+		 */
+		u32 val = CSR_LTR_LONG_VAL_AD_NO_SNOOP_REQ |
+			  u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
+					  CSR_LTR_LONG_VAL_AD_NO_SNOOP_SCALE) |
+			  u32_encode_bits(250,
+					  CSR_LTR_LONG_VAL_AD_NO_SNOOP_VAL) |
+			  CSR_LTR_LONG_VAL_AD_SNOOP_REQ |
+			  u32_encode_bits(CSR_LTR_LONG_VAL_AD_SCALE_USEC,
+					  CSR_LTR_LONG_VAL_AD_SNOOP_SCALE) |
+			  u32_encode_bits(250, CSR_LTR_LONG_VAL_AD_SNOOP_VAL);
+
+		iwl_write32(trans, CSR_LTR_LONG_VAL_AD, val);
+	}
+
 	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210)
 		iwl_write_umac_prph(trans, UREG_CPU_INIT_RUN, 1);
 	else
-- 
2.27.0

