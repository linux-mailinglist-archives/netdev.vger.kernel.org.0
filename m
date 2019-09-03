Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1649A7087
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 18:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730208AbfICQY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 12:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbfICQY4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 12:24:56 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7180D23431;
        Tue,  3 Sep 2019 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567527895;
        bh=rGd/jhcohvfr33CDRbiPtj5fZm7BrKnfFVmg+V1ROq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rUqcepTJ6LgnAJIOMseZF84yO5EobLQD5i64G+KJl65lz5Nh3fFA6S2Zu6otmOrMZ
         /Tg5WYB1F0HMvkrb6LRAMhW93GsFm6NeSgewmEmmAiVQtu4tyQcbuZ4WCDa6vkxNae
         iEnQEPDuTizlctaxziOkk6mODUqVANS/jAqDUaf4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 08/23] iwlwifi: pcie: add support for qu c-step devices
Date:   Tue,  3 Sep 2019 12:24:09 -0400
Message-Id: <20190903162424.6877-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162424.6877-1-sashal@kernel.org>
References: <20190903162424.6877-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Add support for C-step devices.  Currently we don't have a nice way of
matching the step and choosing the proper configuration, so we need to
switch the config structs one by one.

Cc: stable@vger.kernel.org
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 .../net/wireless/intel/iwlwifi/cfg/22000.c    | 53 +++++++++++++++++++
 .../net/wireless/intel/iwlwifi/iwl-config.h   |  7 +++
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h  |  2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 21 ++++++++
 4 files changed, 83 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 93526dfaf7912..1f500cddb3a75 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -80,7 +80,9 @@
 #define IWL_22000_QU_B_HR_B_FW_PRE	"iwlwifi-Qu-b0-hr-b0-"
 #define IWL_22000_HR_B_FW_PRE		"iwlwifi-QuQnj-b0-hr-b0-"
 #define IWL_22000_HR_A0_FW_PRE		"iwlwifi-QuQnj-a0-hr-a0-"
+#define IWL_QU_C_HR_B_FW_PRE		"iwlwifi-Qu-c0-hr-b0-"
 #define IWL_QU_B_JF_B_FW_PRE		"iwlwifi-Qu-b0-jf-b0-"
+#define IWL_QU_C_JF_B_FW_PRE		"iwlwifi-Qu-c0-jf-b0-"
 #define IWL_QUZ_A_HR_B_FW_PRE		"iwlwifi-QuZ-a0-hr-b0-"
 #define IWL_QUZ_A_JF_B_FW_PRE		"iwlwifi-QuZ-a0-jf-b0-"
 #define IWL_QNJ_B_JF_B_FW_PRE		"iwlwifi-QuQnj-b0-jf-b0-"
@@ -109,6 +111,8 @@
 	IWL_QUZ_A_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QUZ_A_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QUZ_A_JF_B_FW_PRE __stringify(api) ".ucode"
+#define IWL_QU_C_HR_B_MODULE_FIRMWARE(api) \
+	IWL_QU_C_HR_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QU_B_JF_B_MODULE_FIRMWARE(api) \
 	IWL_QU_B_JF_B_FW_PRE __stringify(api) ".ucode"
 #define IWL_QNJ_B_JF_B_MODULE_FIRMWARE(api)		\
@@ -256,6 +260,30 @@ const struct iwl_cfg iwl_ax201_cfg_qu_hr = {
 	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
 };
 
+const struct iwl_cfg iwl_ax101_cfg_qu_c0_hr_b0 = {
+	.name = "Intel(R) Wi-Fi 6 AX101",
+	.fw_name_pre = IWL_QU_C_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
+const struct iwl_cfg iwl_ax201_cfg_qu_c0_hr_b0 = {
+	.name = "Intel(R) Wi-Fi 6 AX201 160MHz",
+	.fw_name_pre = IWL_QU_C_HR_B_FW_PRE,
+	IWL_DEVICE_22500,
+	/*
+	 * This device doesn't support receiving BlockAck with a large bitmap
+	 * so we need to restrict the size of transmitted aggregation to the
+	 * HT size; mac80211 would otherwise pick the HE max (256) by default.
+	 */
+	.max_tx_agg_size = IEEE80211_MAX_AMPDU_BUF_HT,
+};
+
 const struct iwl_cfg iwl_ax101_cfg_quz_hr = {
 	.name = "Intel(R) Wi-Fi 6 AX101",
 	.fw_name_pre = IWL_QUZ_A_HR_B_FW_PRE,
@@ -372,6 +400,30 @@ const struct iwl_cfg iwl9560_2ac_160_cfg_qu_b0_jf_b0 = {
 	IWL_DEVICE_22500,
 };
 
+const struct iwl_cfg iwl9461_2ac_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9461",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9462_2ac_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9462",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9560_2ac_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9560",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
+const struct iwl_cfg iwl9560_2ac_160_cfg_qu_c0_jf_b0 = {
+	.name = "Intel(R) Wireless-AC 9560 160MHz",
+	.fw_name_pre = IWL_QU_C_JF_B_FW_PRE,
+	IWL_DEVICE_22500,
+};
+
 const struct iwl_cfg iwl9560_2ac_cfg_qnj_jf_b0 = {
 	.name = "Intel(R) Wireless-AC 9560 160MHz",
 	.fw_name_pre = IWL_QNJ_B_JF_B_FW_PRE,
@@ -590,6 +642,7 @@ MODULE_FIRMWARE(IWL_22000_HR_A_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_F0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_B_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_22000_HR_A0_QNJ_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL_QU_C_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QU_B_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_HR_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL_QUZ_A_JF_B_MODULE_FIRMWARE(IWL_22000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index bc267bd2c3b0e..1c1bf1b281cd9 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -565,10 +565,13 @@ extern const struct iwl_cfg iwl22000_2ac_cfg_hr;
 extern const struct iwl_cfg iwl22000_2ac_cfg_hr_cdb;
 extern const struct iwl_cfg iwl22000_2ac_cfg_jf;
 extern const struct iwl_cfg iwl_ax101_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax101_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax101_cfg_quz_hr;
 extern const struct iwl_cfg iwl22000_2ax_cfg_hr;
 extern const struct iwl_cfg iwl_ax200_cfg_cc;
 extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax201_cfg_qu_hr;
+extern const struct iwl_cfg iwl_ax201_cfg_qu_c0_hr_b0;
 extern const struct iwl_cfg iwl_ax201_cfg_quz_hr;
 extern const struct iwl_cfg iwl_ax1650i_cfg_quz_hr;
 extern const struct iwl_cfg iwl_ax1650s_cfg_quz_hr;
@@ -580,6 +583,10 @@ extern const struct iwl_cfg iwl9461_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9462_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9560_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl9560_2ac_160_cfg_qu_b0_jf_b0;
+extern const struct iwl_cfg iwl9461_2ac_cfg_qu_c0_jf_b0;
+extern const struct iwl_cfg iwl9462_2ac_cfg_qu_c0_jf_b0;
+extern const struct iwl_cfg iwl9560_2ac_cfg_qu_c0_jf_b0;
+extern const struct iwl_cfg iwl9560_2ac_160_cfg_qu_c0_jf_b0;
 extern const struct iwl_cfg killer1550i_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg killer1550s_2ac_cfg_qu_b0_jf_b0;
 extern const struct iwl_cfg iwl22000_2ax_cfg_jf;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index 93da96a7247c3..cb4c5514a5560 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -328,6 +328,8 @@ enum {
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 #define CSR_HW_REV_TYPE_QNJ		(0x0000360)
 #define CSR_HW_REV_TYPE_QNJ_B0		(0x0000364)
+#define CSR_HW_REV_TYPE_QU_B0		(0x0000334)
+#define CSR_HW_REV_TYPE_QU_C0		(0x0000338)
 #define CSR_HW_REV_TYPE_QUZ		(0x0000354)
 #define CSR_HW_REV_TYPE_HR_CDB		(0x0000340)
 #define CSR_HW_REV_TYPE_SO		(0x0000370)
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index fe645380bd2fa..ea2a03d4bf55c 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -1039,6 +1039,27 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		}
 		iwl_trans->cfg = cfg;
 	}
+
+	/*
+	 * This is a hack to switch from Qu B0 to Qu C0.  We need to
+	 * do this for all cfgs that use Qu B0.  All this code is in
+	 * urgent need for a refactor, but for now this is the easiest
+	 * thing to do to support Qu C-step.
+	 */
+	if (iwl_trans->hw_rev == CSR_HW_REV_TYPE_QU_C0) {
+		if (iwl_trans->cfg == &iwl_ax101_cfg_qu_hr)
+			iwl_trans->cfg = &iwl_ax101_cfg_qu_c0_hr_b0;
+		else if (iwl_trans->cfg == &iwl_ax201_cfg_qu_hr)
+			iwl_trans->cfg = &iwl_ax201_cfg_qu_c0_hr_b0;
+		else if (iwl_trans->cfg == &iwl9461_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9461_2ac_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &iwl9462_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9462_2ac_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &iwl9560_2ac_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9560_2ac_cfg_qu_c0_jf_b0;
+		else if (iwl_trans->cfg == &iwl9560_2ac_160_cfg_qu_b0_jf_b0)
+			iwl_trans->cfg = &iwl9560_2ac_160_cfg_qu_c0_jf_b0;
+	}
 #endif
 
 	pci_set_drvdata(pdev, iwl_trans);
-- 
2.20.1

