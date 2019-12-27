Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641AD12B879
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbfL0R4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:56:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727165AbfL0RmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:42:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AA9F21D7E;
        Fri, 27 Dec 2019 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468526;
        bh=TQYSuAZJRaCzizmp6PoJ4JqrQQooRARmD8G+/wehoZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSO/zpSJzA+k/8EMcBaonvzaahYWvdzusf5cI51mgpmKjMBYlr31RPoGtCEE/1wFR
         5tERXo0h9pRtgOIobqhvatpxq0i9CqJunI7zxMcdMgsyZLrJCuYRzyJA1daYE6ig78
         CUaAdvc74xmeCodwd0yd/1XP9rheL50eH2hU4sm4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>, stable@ver.kernel.org,
        Anders Kaseorg <andersk@mit.edu>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 057/187] iwlwifi: pcie: move power gating workaround earlier in the flow
Date:   Fri, 27 Dec 2019 12:38:45 -0500
Message-Id: <20191227174055.4923-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 0df36b90c47d93295b7e393da2d961b2f3b6cde4 ]

We need to reset the NIC after setting the bits to enable power
gating and that cannot be done too late in the flow otherwise it
cleans other registers and things that were already configured,
causing initialization to fail.

In order to fix this, move the function to the common code in trans.c
so it can be called directly from there at an earlier point, just
after the reset we already do during initialization.

Fixes: 9a47cb988338 ("iwlwifi: pcie: add workaround for power gating in integrated 22000")
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=205719
Cc: stable@ver.kernel.org # 5.4+
Reported-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/intel/iwlwifi/pcie/trans-gen2.c  | 25 ----------------
 .../net/wireless/intel/iwlwifi/pcie/trans.c   | 30 +++++++++++++++++++
 2 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index ca3bb4d65b00..df8455f14e4d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -57,24 +57,6 @@
 #include "internal.h"
 #include "fw/dbg.h"
 
-static int iwl_pcie_gen2_force_power_gating(struct iwl_trans *trans)
-{
-	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			  HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
-	udelay(20);
-	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			  HPM_HIPM_GEN_CFG_CR_PG_EN |
-			  HPM_HIPM_GEN_CFG_CR_SLP_EN);
-	udelay(20);
-	iwl_clear_bits_prph(trans, HPM_HIPM_GEN_CFG,
-			    HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
-
-	iwl_trans_sw_reset(trans);
-	iwl_clear_bit(trans, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);
-
-	return 0;
-}
-
 /*
  * Start up NIC's basic functionality after it has been reset
  * (e.g. after platform boot, or shutdown via iwl_pcie_apm_stop())
@@ -110,13 +92,6 @@ int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
 
 	iwl_pcie_apm_config(trans);
 
-	if (trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000 &&
-	    trans->cfg->integrated) {
-		ret = iwl_pcie_gen2_force_power_gating(trans);
-		if (ret)
-			return ret;
-	}
-
 	ret = iwl_finish_nic_init(trans, trans->trans_cfg);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 6961f00ff812..d3db38c3095b 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1783,6 +1783,29 @@ static int iwl_trans_pcie_clear_persistence_bit(struct iwl_trans *trans)
 	return 0;
 }
 
+static int iwl_pcie_gen2_force_power_gating(struct iwl_trans *trans)
+{
+	int ret;
+
+	ret = iwl_finish_nic_init(trans, trans->trans_cfg);
+	if (ret < 0)
+		return ret;
+
+	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
+			  HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
+	udelay(20);
+	iwl_set_bits_prph(trans, HPM_HIPM_GEN_CFG,
+			  HPM_HIPM_GEN_CFG_CR_PG_EN |
+			  HPM_HIPM_GEN_CFG_CR_SLP_EN);
+	udelay(20);
+	iwl_clear_bits_prph(trans, HPM_HIPM_GEN_CFG,
+			    HPM_HIPM_GEN_CFG_CR_FORCE_ACTIVE);
+
+	iwl_trans_pcie_sw_reset(trans);
+
+	return 0;
+}
+
 static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
@@ -1802,6 +1825,13 @@ static int _iwl_trans_pcie_start_hw(struct iwl_trans *trans)
 
 	iwl_trans_pcie_sw_reset(trans);
 
+	if (trans->trans_cfg->device_family == IWL_DEVICE_FAMILY_22000 &&
+	    trans->cfg->integrated) {
+		err = iwl_pcie_gen2_force_power_gating(trans);
+		if (err)
+			return err;
+	}
+
 	err = iwl_pcie_apm_init(trans);
 	if (err)
 		return err;
-- 
2.20.1

