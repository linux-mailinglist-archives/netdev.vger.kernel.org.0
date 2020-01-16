Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14A7113F7E3
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732759AbgAPQzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:55:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733085AbgAPQzk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:40 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DACE0205F4;
        Thu, 16 Jan 2020 16:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193738;
        bh=3qkvYVxuHANPIG+yw+3YGj7uuh+zg48E4PUamF3Heb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sFpwu5A49rabtlMvEyWo5+GQmvYHWd6WXgANGK18sihVSncSImCxAKi1PFY6RhKS0
         bYUM+Hw4dxN44ICbeu6xm1vOX7XdhighmFyH3HRGBymG9tDvb96MIJ/dbbvLZ92qlD
         fzmPZTceS9LEcxsMrTxq6Sn45Y1yug8pSwBFwcwM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/671] iwlwifi: nvm: get num of hw addresses from firmware
Date:   Thu, 16 Jan 2020 11:44:21 -0500
Message-Id: <20200116165502.8838-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit e7eeee08434873c2f781dc1afaa42b03a014b95d ]

With NICs that don't read the NVM directly and instead rely on getting
the relevant data from the firmware, the number of reserved MAC
addresses was not added to the API. This caused the driver to assume
there is only one address which results in all interfaces getting the
same address. Update the API to fix this.

While at it, fix-up the comments with firmware api names to actually
match what we have in the firmware.

Fixes: e9e1ba3dbf00 ("iwlwifi: mvm: support getting nvm data from firmware")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/fw/api/nvm-reg.h    | 14 +++++++-------
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 10 +++++++++-
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
index 6c5338364794..d22c1eefba6a 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h
@@ -165,7 +165,7 @@ struct iwl_nvm_access_resp {
  */
 struct iwl_nvm_get_info {
 	__le32 reserved;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_CMD_S_VER_1 */
+} __packed; /* REGULATORY_NVM_GET_INFO_CMD_API_S_VER_1 */
 
 /**
  * enum iwl_nvm_info_general_flags - flags in NVM_GET_INFO resp
@@ -180,14 +180,14 @@ enum iwl_nvm_info_general_flags {
  * @flags: bit 0: 1 - empty, 0 - non-empty
  * @nvm_version: nvm version
  * @board_type: board type
- * @reserved: reserved
+ * @n_hw_addrs: number of reserved MAC addresses
  */
 struct iwl_nvm_get_info_general {
 	__le32 flags;
 	__le16 nvm_version;
 	u8 board_type;
-	u8 reserved;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_GENERAL_S_VER_1 */
+	u8 n_hw_addrs;
+} __packed; /* REGULATORY_NVM_GET_INFO_GENERAL_S_VER_2 */
 
 /**
  * enum iwl_nvm_mac_sku_flags - flags in &iwl_nvm_get_info_sku
@@ -231,7 +231,7 @@ struct iwl_nvm_get_info_sku {
 struct iwl_nvm_get_info_phy {
 	__le32 tx_chains;
 	__le32 rx_chains;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_PHY_SKU_SECTION_S_VER_1 */
+} __packed; /* REGULATORY_NVM_GET_INFO_PHY_SKU_SECTION_S_VER_1 */
 
 #define IWL_NUM_CHANNELS (51)
 
@@ -245,7 +245,7 @@ struct iwl_nvm_get_info_regulatory {
 	__le32 lar_enabled;
 	__le16 channel_profile[IWL_NUM_CHANNELS];
 	__le16 reserved;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_1 */
+} __packed; /* REGULATORY_NVM_GET_INFO_REGULATORY_S_VER_1 */
 
 /**
  * struct iwl_nvm_get_info_rsp - response to get NVM data
@@ -259,7 +259,7 @@ struct iwl_nvm_get_info_rsp {
 	struct iwl_nvm_get_info_sku mac_sku;
 	struct iwl_nvm_get_info_phy phy_sku;
 	struct iwl_nvm_get_info_regulatory regulatory;
-} __packed; /* GRP_REGULATORY_NVM_GET_INFO_CMD_RSP_S_VER_2 */
+} __packed; /* REGULATORY_NVM_GET_INFO_RSP_API_S_VER_3 */
 
 /**
  * struct iwl_nvm_access_complete_cmd - NVM_ACCESS commands are completed
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 73969dbeb5c5..b850cca9853c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -1315,6 +1315,7 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	bool lar_fw_supported = !iwlwifi_mod_params.lar_disable &&
 				fw_has_capa(&fw->ucode_capa,
 					    IWL_UCODE_TLV_CAPA_LAR_SUPPORT);
+	bool empty_otp;
 	u32 mac_flags;
 	u32 sbands_flags = 0;
 
@@ -1330,7 +1331,9 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 	}
 
 	rsp = (void *)hcmd.resp_pkt->data;
-	if (le32_to_cpu(rsp->general.flags) & NVM_GENERAL_FLAGS_EMPTY_OTP)
+	empty_otp = !!(le32_to_cpu(rsp->general.flags) &
+		       NVM_GENERAL_FLAGS_EMPTY_OTP);
+	if (empty_otp)
 		IWL_INFO(trans, "OTP is empty\n");
 
 	nvm = kzalloc(sizeof(*nvm) +
@@ -1354,6 +1357,11 @@ struct iwl_nvm_data *iwl_get_nvm(struct iwl_trans *trans,
 
 	/* Initialize general data */
 	nvm->nvm_version = le16_to_cpu(rsp->general.nvm_version);
+	nvm->n_hw_addrs = rsp->general.n_hw_addrs;
+	if (nvm->n_hw_addrs == 0)
+		IWL_WARN(trans,
+			 "Firmware declares no reserved mac addresses. OTP is empty: %d\n",
+			 empty_otp);
 
 	/* Initialize MAC sku data */
 	mac_flags = le32_to_cpu(rsp->mac_sku.mac_sku_flags);
-- 
2.20.1

