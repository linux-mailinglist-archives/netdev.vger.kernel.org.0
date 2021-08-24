Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C58933F543A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 02:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhHXAyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 20:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233441AbhHXAym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 20:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A249613AD;
        Tue, 24 Aug 2021 00:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629766438;
        bh=S9iJn1Hv/lkhDJlzG1PsR7eS5tjZs98s/7plS8XSqZk=;
        h=From:To:Cc:Subject:Date:From;
        b=UOVB14cjbywGUu2PAOSWdbr79yjb2rGgYIdlnHCjvC5CCgzlIdtV8qpIwUrKPcdgf
         KuTGtQJ/43ecRwrdlbaE3WuaPh91Ge4L/NEUbpzT9al1agOpdTQ7yVCMui+x8nugZf
         CMJ7CopCMTA4rSknhviWQ8CU6EmzxIVivSKYH0hK7M5lQHRCYnoKAYE5rZcb97dI4o
         48COGKCU1/76rr+OlRjBolqkybvE5e9gYGFbngQpnhe2fc3nvHy7dhtRQ3cI7ozYGJ
         v73b6dSuvu4EH8kBXeGLmhFDLZdnP7zKDrAksu7VkZrp5OwIUy9Ng8+Ainz7UmBwZe
         crzbc8qyeaAkA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 01/26] iwlwifi: pnvm: accept multiple HW-type TLVs
Date:   Mon, 23 Aug 2021 20:53:31 -0400
Message-Id: <20210824005356.630888-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 0f673c16c850250db386537a422c11d248fb123c ]

Some products (So) may have two different types of products
with different mac-type that are otherwise equivalent, and
have the same PNVM data, so the PNVM file will contain two
(or perhaps later more) HW-type TLVs. Accept the file and
use the data section that contains any matching entry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210719140154.a6a86e903035.Ic0b1b75c45d386698859f251518e8a5144431938@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/pnvm.c | 25 +++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
index 40f2109a097f..1a63cae6567e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/pnvm.c
@@ -37,6 +37,7 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	u32 sha1 = 0;
 	u16 mac_type = 0, rf_id = 0;
 	u8 *pnvm_data = NULL, *tmp;
+	bool hw_match = false;
 	u32 size = 0;
 	int ret;
 
@@ -83,6 +84,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				break;
 			}
 
+			if (hw_match)
+				break;
+
 			mac_type = le16_to_cpup((__le16 *)data);
 			rf_id = le16_to_cpup((__le16 *)(data + sizeof(__le16)));
 
@@ -90,15 +94,9 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 				     "Got IWL_UCODE_TLV_HW_TYPE mac_type 0x%0x rf_id 0x%0x\n",
 				     mac_type, rf_id);
 
-			if (mac_type != CSR_HW_REV_TYPE(trans->hw_rev) ||
-			    rf_id != CSR_HW_RFID_TYPE(trans->hw_rf_id)) {
-				IWL_DEBUG_FW(trans,
-					     "HW mismatch, skipping PNVM section, mac_type 0x%0x, rf_id 0x%0x.\n",
-					     CSR_HW_REV_TYPE(trans->hw_rev), trans->hw_rf_id);
-				ret = -ENOENT;
-				goto out;
-			}
-
+			if (mac_type == CSR_HW_REV_TYPE(trans->hw_rev) &&
+			    rf_id == CSR_HW_RFID_TYPE(trans->hw_rf_id))
+				hw_match = true;
 			break;
 		case IWL_UCODE_TLV_SEC_RT: {
 			struct iwl_pnvm_section *section = (void *)data;
@@ -149,6 +147,15 @@ static int iwl_pnvm_handle_section(struct iwl_trans *trans, const u8 *data,
 	}
 
 done:
+	if (!hw_match) {
+		IWL_DEBUG_FW(trans,
+			     "HW mismatch, skipping PNVM section (need mac_type 0x%x rf_id 0x%x)\n",
+			     CSR_HW_REV_TYPE(trans->hw_rev),
+			     CSR_HW_RFID_TYPE(trans->hw_rf_id));
+		ret = -ENOENT;
+		goto out;
+	}
+
 	if (!size) {
 		IWL_DEBUG_FW(trans, "Empty PNVM, skipping.\n");
 		ret = -ENOENT;
-- 
2.30.2

