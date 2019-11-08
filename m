Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17099F4A9A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733099AbfKHLjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 06:39:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:52044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733053AbfKHLjH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5A0120869;
        Fri,  8 Nov 2019 11:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213146;
        bh=JT53lHzlxTCvHdD2h1AKBQEq+cdCUIcoomU7kVIRX94=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zS1NjXeAYrql3FpZs96bc4c3cGC8PZYln240rco/nnyShsfrDv2Q+afNO5LDiYDyw
         9r+D3X0ALz4M86v+6gl8RY6LqvpwIGDQDKUBv+YML1HCQ/YZWk159WGZDcmVuYNzdA
         5ZN/g7wIoIzrHN9pbFzDYTmZSnfjm8D+SnHXLYUg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 057/205] iwlwifi: don't WARN on trying to dump dead firmware
Date:   Fri,  8 Nov 2019 06:35:24 -0500
Message-Id: <20191108113752.12502-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
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
index a31a42e673c46..8070b2d4c46fe 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -1016,7 +1016,7 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
 	 * If the loading of the FW completed successfully, the next step is to
 	 * get the SMEM config data. Thus, if fwrt->smem_cfg.num_lmacs is non
 	 * zero, the FW was already loaded successully. If the state is "NO_FW"
-	 * in such a case - WARN and exit, since FW may be dead. Otherwise, we
+	 * in such a case - exit, since FW may be dead. Otherwise, we
 	 * can try to collect the data, since FW might just not be fully
 	 * loaded (no "ALIVE" yet), and the debug data is accessible.
 	 *
@@ -1024,9 +1024,8 @@ int iwl_fw_dbg_collect_desc(struct iwl_fw_runtime *fwrt,
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

