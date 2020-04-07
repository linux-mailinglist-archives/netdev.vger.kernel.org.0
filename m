Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E21DE1A01F7
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgDGABP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726676AbgDGABL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E45A20768;
        Tue,  7 Apr 2020 00:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217671;
        bh=YJLA9UOw8df/fYXmEFyAHkWnjnxrWSoSrDIt/6Crg/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGdQNiuJYoHB+le3Q9LKmtMWN7KBal9QKnGIiP/GBTrIi9RvR5zzy0CVkNOR9ElUl
         0G9huC0jIFj/iBxMElIDEi/HVbosdSlgscmLiQlDTXlETIh86EBwphkxeR5B5y0gBa
         KfWpeYs60Wh/5PulH9Kym4wBhP3DfpcIxlafvjw8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 09/35] iwlwifi: dbg: don't abort if sending DBGC_SUSPEND_RESUME fails
Date:   Mon,  6 Apr 2020 20:00:31 -0400
Message-Id: <20200407000058.16423-9-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
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
index e5c9149099886..bf93da0b04aef 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -2491,10 +2491,7 @@ static void iwl_fw_dbg_collect_sync(struct iwl_fw_runtime *fwrt, u8 wk_idx)
 		goto out;
 	}
 
-	if (iwl_fw_dbg_stop_restart_recording(fwrt, &params, true)) {
-		IWL_ERR(fwrt, "Failed to stop DBGC recording, aborting dump\n");
-		goto out;
-	}
+	iwl_fw_dbg_stop_restart_recording(fwrt, &params, true);
 
 	IWL_DEBUG_FW_INFO(fwrt, "WRT: Data collection start\n");
 	if (iwl_trans_dbg_ini_valid(fwrt->trans))
@@ -2659,14 +2656,14 @@ static int iwl_fw_dbg_restart_recording(struct iwl_trans *trans,
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
@@ -2683,7 +2680,5 @@ int iwl_fw_dbg_stop_restart_recording(struct iwl_fw_runtime *fwrt,
 			iwl_fw_set_dbg_rec_on(fwrt);
 	}
 #endif
-
-	return ret;
 }
 IWL_EXPORT_SYMBOL(iwl_fw_dbg_stop_restart_recording);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
index 179f2905d56b0..9d3513213f5ff 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.h
@@ -239,9 +239,9 @@ _iwl_fw_dbg_trigger_simple_stop(struct iwl_fw_runtime *fwrt,
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

