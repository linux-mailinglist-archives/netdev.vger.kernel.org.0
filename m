Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682124915F0
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345943AbiARCcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:32:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345262AbiARCbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:31:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D281C08C5DA;
        Mon, 17 Jan 2022 18:28:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DE94B81247;
        Tue, 18 Jan 2022 02:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63672C36AE3;
        Tue, 18 Jan 2022 02:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472923;
        bh=3JX4NxME83wn+3Sx/vJIXU37WPkZe9zA5CufjNXYz9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGc7xV2JDH9Zsg4XJvY8+s3iXOtWjbu4+Qf4aUuaZlAss0mgKO3Mz5tpg4+xEeDKd
         rX+zyQTCQeca5V97JHZGp01cpNDt9GLWKsQYTZp8rs9qfBRDW8hzvbTlChNopxsyRQ
         xyl/eJLly2bVtO3ZhK08z14iHbJxh3O3IbSDo9/KQ5pRCdxPSdLo5tYP2MOade+Wgx
         M2wcHghMhDUNeqvtC1NacxfhkrKLruwACR4N/fG4n3T8brOcIS/ICW8C+dZlIKUqlp
         08+nIZfq9eywBHJTAcJjC9HB0P+HgR0/R9zkz3G0oEPLamCCZ9nI+VpHav3g1EXRiH
         yc9gT1tgosTgA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sam Edwards <CFSworks@gmail.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        matti.gottlieb@intel.com, roee.h.goldfiner@intel.com,
        drorx.moshe@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 163/217] iwlwifi: recognize missing PNVM data and then log filename
Date:   Mon, 17 Jan 2022 21:18:46 -0500
Message-Id: <20220118021940.1942199-163-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 1db385c668d3ccb04ccdb5f0f190fd17b2db29c6 ]

We can detect that a FW SYSASSERT is due to missing PNVM data by
checking the assertion code.  When this happens, it's is useful for
the user if we print the filename where the driver is looking for the
data.

Add the PNVM missing assertion code to the dump list and print out the
name of the file we're looking for when this happens.

Reported-by: Sam Edwards <CFSworks@gmail.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211210090244.1d8725b7518a.I0c36617a7282bd445cda484d97ac4a83022706ee@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dump.c | 9 +++++++++
 drivers/net/wireless/intel/iwlwifi/fw/img.c  | 6 +++---
 drivers/net/wireless/intel/iwlwifi/fw/img.h  | 4 ++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dump.c b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
index 016b3a4c5f513..6a37933a02169 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dump.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dump.c
@@ -12,6 +12,7 @@
 #include "iwl-io.h"
 #include "iwl-prph.h"
 #include "iwl-csr.h"
+#include "pnvm.h"
 
 /*
  * Note: This structure is read from the device with IO accesses,
@@ -147,6 +148,7 @@ static void iwl_fwrt_dump_umac_error_log(struct iwl_fw_runtime *fwrt)
 	struct iwl_trans *trans = fwrt->trans;
 	struct iwl_umac_error_event_table table = {};
 	u32 base = fwrt->trans->dbg.umac_error_event_table;
+	char pnvm_name[MAX_PNVM_NAME];
 
 	if (!base &&
 	    !(fwrt->trans->dbg.error_event_table_tlv_status &
@@ -164,6 +166,13 @@ static void iwl_fwrt_dump_umac_error_log(struct iwl_fw_runtime *fwrt)
 			fwrt->trans->status, table.valid);
 	}
 
+	if ((table.error_id & ~FW_SYSASSERT_CPU_MASK) ==
+	    FW_SYSASSERT_PNVM_MISSING) {
+		iwl_pnvm_get_fs_name(trans, pnvm_name, sizeof(pnvm_name));
+		IWL_ERR(fwrt, "PNVM data is missing, please install %s\n",
+			pnvm_name);
+	}
+
 	IWL_ERR(fwrt, "0x%08X | %s\n", table.error_id,
 		iwl_fw_lookup_assert_desc(table.error_id));
 	IWL_ERR(fwrt, "0x%08X | umac branchlink1\n", table.blink1);
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.c b/drivers/net/wireless/intel/iwlwifi/fw/img.c
index 24a9666736913..530674a35eeb2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright(c) 2019 - 2020 Intel Corporation
+ * Copyright(c) 2019 - 2021 Intel Corporation
  */
 
 #include "img.h"
@@ -49,10 +49,9 @@ u8 iwl_fw_lookup_notif_ver(const struct iwl_fw *fw, u8 grp, u8 cmd, u8 def)
 }
 EXPORT_SYMBOL_GPL(iwl_fw_lookup_notif_ver);
 
-#define FW_SYSASSERT_CPU_MASK 0xf0000000
 static const struct {
 	const char *name;
-	u8 num;
+	u32 num;
 } advanced_lookup[] = {
 	{ "NMI_INTERRUPT_WDG", 0x34 },
 	{ "SYSASSERT", 0x35 },
@@ -73,6 +72,7 @@ static const struct {
 	{ "NMI_INTERRUPT_ACTION_PT", 0x7C },
 	{ "NMI_INTERRUPT_UNKNOWN", 0x84 },
 	{ "NMI_INTERRUPT_INST_ACTION_PT", 0x86 },
+	{ "PNVM_MISSING", FW_SYSASSERT_PNVM_MISSING },
 	{ "ADVANCED_SYSASSERT", 0 },
 };
 
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/img.h b/drivers/net/wireless/intel/iwlwifi/fw/img.h
index 993bda17fa309..fa7b1780064c2 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/img.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/img.h
@@ -279,4 +279,8 @@ u8 iwl_fw_lookup_cmd_ver(const struct iwl_fw *fw, u8 grp, u8 cmd, u8 def);
 
 u8 iwl_fw_lookup_notif_ver(const struct iwl_fw *fw, u8 grp, u8 cmd, u8 def);
 const char *iwl_fw_lookup_assert_desc(u32 num);
+
+#define FW_SYSASSERT_CPU_MASK		0xf0000000
+#define FW_SYSASSERT_PNVM_MISSING	0x0010070d
+
 #endif  /* __iwl_fw_img_h__ */
-- 
2.34.1

