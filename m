Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C014C1A02F1
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgDGACE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727847AbgDGACD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E466720842;
        Tue,  7 Apr 2020 00:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217722;
        bh=Sb3NPDH1SdCPrT2vOzdHnbroa9okV1T2L90Jo+ULj9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OI2dCHera2FI6OE6tIqLcqoCkNEyuVnPbDepu8TjVUJJd+Ltatj4egYCzCipjvmxe
         MNU/NnMYGKOPJYEokQYx2k+zmdqFKfYFNtEJctsJHVm5AoMlmU4NcryZ/opoR8QI8d
         ypiRGb3zlKXfo5NS2fHYrn3e5yLJkx1RFUAUchV4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/32] iwlwifi: dbg: don't abort if sending DBGC_SUSPEND_RESUME fails
Date:   Mon,  6 Apr 2020 20:01:26 -0400
Message-Id: <20200407000151.16768-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 699b760bd29edba736590fffef7654cb079c753e ]

If the firmware is in a bad state or not initialized fully, sending
the DBGC_SUSPEND_RESUME command fails but we can still collect logs.

Instead of aborting the entire dump process, simply ignore the error.
By removing the last callpoint that was checking the return value, we
can also convert the function to return void.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: 576058330f2d ("iwlwifi: dbg: support debug recording suspend resume command")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151129.dcec37b2efd4.I8dcd190431d110a6a0e88095ce93591ccfb3d78d@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 15 +++++----------
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h |  6 +++---
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index ef65e1ea374fd..cb5465d9c0686 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2311,10 +2311,7 @@ static void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt, u8 wk_idx)
 		goto out;
 	}
 
-	if (iwl_fw_dbg_stop_restart_recording(fwrt, &params, true)) {
-		IWL_ERR(fwrt, "Failed to stop DBGC recording, aborting dump\n");
-		goto out;
-	}
+	iwl_fw_dbg_stop_restart_recording(fwrt, &params, true);
 
 	IWL_DEBUG_FW_INFO(fwrt, "WRT: Data collection start\n");
 	if (iwl_trans_dbg_ini_valid(fwrt->trans))
@@ -2480,14 +2477,14 @@ static int iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
 	return 0;
 }
 
-int iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
-				      struct iwl_fw_dbg_params *params,
-				      bool stop)
+void iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
+				       struct iwl_fw_dbg_params *params,
+				       bool stop)
 {
 	int ret = 0;
 
 	if (test_bit(STATUS_FW_ERROR, &fwrt->trans->status))
-		return 0;
+		return;
 
 	if (fw_has_capa(&fwrt->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_DBG_SUSPEND_RESUME_CMD_SUPP))
@@ -2504,7 +2501,5 @@ int iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
 			iwl_fw_set_dbg_rec_on(fwrt);
 	}
 #endif
-
-	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_stop_restart_recording);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index e3b5dd34643f5..2ac61629f46f4 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -263,9 +263,9 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
 	_iwl_fw_dbg_trigger_simple_stop((fwrt), (wdev),		\
 					iwl_fw_dbg_get_trigger((fwrt)->fw,\
 							       (trig)))
-int iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
-				      struct iwl_fw_dbg_params *params,
-				      bool stop);
+void iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
+				       struct iwl_fw_dbg_params *params,
+				       bool stop);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 static inline void iwl_fw_set_dbg_rec_on(struct iwl_fw_runtime *fwrt)
-- 
2.20.1

