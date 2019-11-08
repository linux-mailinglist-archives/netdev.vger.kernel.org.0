Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8708BF491A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390905AbfKHMAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:58432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390552AbfKHLnt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:43:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7777222C2;
        Fri,  8 Nov 2019 11:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213428;
        bh=kbSPGq080Nn0FUfGmRqHlogt7rWfHK73COfGgh2PqDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gY4air3476OKG4j1xRwF2LOU4Aq+V/ktROHBSyt6lot1WvYgYBgFkO663eZFD3z4d
         quHnRo4SKF6svObsadDJAFotC8ZTVCQUKsTViQtfXTJ2FUiPz6FiqCFLAwjbu5nHnr
         SoYfVwwneSjaOxqHG1ziP7Tga6diqfWXNb4J1ct4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 028/103] iwlwifi: don't WARN on trying to dump dead firmware
Date:   Fri,  8 Nov 2019 06:41:53 -0500
Message-Id: <20191108114310.14363-28-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 84f260251ed8153e84c64eb2c5278ab18d3ddef6 ]

There's no point in warning here, the user will just get an
error back to the debugfs file write, and warning just makes
it seem like there's an internal consistency problem when in
reality the user just happened to hit this at a bad time.
Remove the warning.

Fixes: f45f979dc208 ("iwlwifi: mvm: disable dbg data collect when fw isn't alive")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 8390104172410..e72c0b825420c 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -954,7 +954,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	 * If the loading of the FW completed successfully, the next step is to
 	 * get the SMEM config data. Thus, if fwrt->smem_cfg.num_lmacs is non
 	 * zero, the FW was already loaded successully. If the state is "NO_FW"
-	 * in such a case - WARN and exit, since FW may be dead. Otherwise, we
+	 * in such a case - exit, since FW may be dead. Otherwise, we
 	 * can try to collect the data, since FW might just not be fully
 	 * loaded (no "ALIVE" yet), and the debug data is accessible.
 	 *
@@ -962,9 +962,8 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	 *	config. In such a case, due to HW access problems, we might
 	 *	collect garbage.
 	 */
-	if (WARN((fwrt->trans->state == IWL_TRANS_NO_FW) &&
-		 fwrt->smem_cfg.num_lmacs,
-		 "Can't collect dbg data when FW isn't alive\n"))
+	if (fwrt->trans->state == IWL_TRANS_NO_FW &&
+	    fwrt->smem_cfg.num_lmacs)
 		return -EIO;
 
 	if (test_and_set_bit(IWL_FWRT_STATUS_DUMPING, &fwrt->status))
-- 
2.20.1

