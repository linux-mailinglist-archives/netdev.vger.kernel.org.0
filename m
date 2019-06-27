Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27FD9575B9
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbfF0Aby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:31:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726835AbfF0Abw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:31:52 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08C792083B;
        Thu, 27 Jun 2019 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595511;
        bh=NynziKkWJSudZK01YfC0xsODs8a2InTEdBt6NzJKDPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nHzzck19rwkXW0j4q0UiFIo5xKtwKDD9ucAL/rk1ofrCJCpUiXyVXz4eLn7KOSQJk
         xpOmvCr5VNBKcnDPll3AKPLU7OJLfn6pG5+SCg6WdNY08ODEdcaCATT4xfkBt37AG9
         98ys7t+XrjLRTla/YV0H6ZGzB+Zdd/5wCxHpuTzQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 26/95] iwlwifi: clear persistence bit according to device family
Date:   Wed, 26 Jun 2019 20:29:11 -0400
Message-Id: <20190627003021.19867-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shahar S Matityahu <shahar.s.matityahu@intel.com>

[ Upstream commit 44f61b5c832c4085fcf476484efeaeef96dcfb8b ]

The driver attempts to clear persistence bit on any device familiy even
though only 9000 and 22000 families require it. Clear the bit only on
the relevant device families.

Each HW has different address to the write protection register. Use the
right register for each HW

Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
Fixes: 8954e1eb2270 ("iwlwifi: trans: Clear persistence bit when starting the FW")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h |  7 ++-
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 46 +++++++++++++------
 2 files changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 1af9f9e1ecd4..0c0799d13e15 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -402,7 +402,12 @@ enum aux_misc_master1_en {
 #define AUX_MISC_MASTER1_SMPHR_STATUS	0xA20800
 #define RSA_ENABLE			0xA24B08
 #define PREG_AUX_BUS_WPROT_0		0xA04CC0
-#define PREG_PRPH_WPROT_0		0xA04CE0
+
+/* device family 9000 WPROT register */
+#define PREG_PRPH_WPROT_9000		0xA04CE0
+/* device family 22000 WPROT register */
+#define PREG_PRPH_WPROT_22000		0xA04D00
+
 #define SB_CPU_1_STATUS			0xA01E30
 #define SB_CPU_2_STATUS			0xA01E34
 #define UMAG_SB_CPU_1_STATUS		0xA038C0
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index c4375b868901..2a03d34afa3b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1696,26 +1696,26 @@ static int iwl_pcie_init_msix_handler(struct pci_dev *pdev,
 	return 0;
 }
 
-static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
+static int iwl_trans_pcie_clear_persistence_bit(struct iwl_trans *trans)
 {
-	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	u32 hpm;
-	int err;
-
-	lockdep_assert_held(&trans_pcie->mutex);
+	u32 hpm, wprot;
 
-	err = iwl_pcie_prepare_card_hw(trans);
-	if (err) {
-		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
-		return err;
+	switch (trans->cfg->device_family) {
+	case IWL_DEVICE_FAMILY_9000:
+		wprot = PREG_PRPH_WPROT_9000;
+		break;
+	case IWL_DEVICE_FAMILY_22000:
+		wprot = PREG_PRPH_WPROT_22000;
+		break;
+	default:
+		return 0;
 	}
 
 	hpm = iwl_read_umac_prph_no_grab(trans, HPM_DEBUG);
 	if (hpm != 0xa5a5a5a0 && (hpm & PERSISTENCE_BIT)) {
-		int wfpm_val = iwl_read_umac_prph_no_grab(trans,
-							  PREG_PRPH_WPROT_0);
+		u32 wprot_val = iwl_read_umac_prph_no_grab(trans, wprot);
 
-		if (wfpm_val & PREG_WFPM_ACCESS) {
+		if (wprot_val & PREG_WFPM_ACCESS) {
 			IWL_ERR(trans,
 				"Error, can not clear persistence bit\n");
 			return -EPERM;
@@ -1724,6 +1724,26 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
 					    hpm & ~PERSISTENCE_BIT);
 	}
 
+	return 0;
+}
+
+static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans, bool low_power)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int err;
+
+	lockdep_assert_held(&trans_pcie->mutex);
+
+	err = iwl_pcie_prepare_card_hw(trans);
+	if (err) {
+		IWL_ERR(trans, "Error while preparing HW: %d\n", err);
+		return err;
+	}
+
+	err = iwl_trans_pcie_clear_persistence_bit(trans);
+	if (err)
+		return err;
+
 	iwl_trans_pcie_sw_reset(trans);
 
 	err = iwl_pcie_apm_init(trans);
-- 
2.20.1

