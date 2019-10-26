Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA37E5AB5
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 15:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfJZNRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 09:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbfJZNRO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7391D21655;
        Sat, 26 Oct 2019 13:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095834;
        bh=P+x0vk8c6GjcSwPpPa+2eiHOdIpm+8+UEleTFKRbyOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOPwo2t1SG4oE+WymKEDzvlZqzz6xgekMorPGK76/i5viXNCcjSCSzREjWDoFvbLO
         iAuGi98kJQcL64Z80iTPlfHYLSFcn7SNjo2vYAMStK42GTsk978IjRy7n+GCZq3qp/
         CwVo5qcbZ0VJLvfkrLVpuqDaU0W6DvKKcYPZRApk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 38/99] iwlwifi: exclude GEO SAR support for 3168
Date:   Sat, 26 Oct 2019 09:14:59 -0400
Message-Id: <20191026131600.2507-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

[ Upstream commit 12e36d98d3e5acf5fc57774e0a15906d55f30cb9 ]

We currently support two NICs in FW version 29, namely 7265D and 3168.
Out of these, only 7265D supports GEO SAR, so adjust the function that
checks for it accordingly.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Fixes: f5a47fae6aa3 ("iwlwifi: mvm: fix version check for GEO_TX_POWER_LIMIT support")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 8b0b464a1f213..c520f42d165cd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -887,15 +887,17 @@ static bool iwl_mvm_sar_geo_support(struct iwl_mvm *mvm)
 	 * firmware versions.  Unfortunately, we don't have a TLV API
 	 * flag to rely on, so rely on the major version which is in
 	 * the first byte of ucode_ver.  This was implemented
-	 * initially on version 38 and then backported to29 and 17.
-	 * The intention was to have it in 36 as well, but not all
-	 * 8000 family got this feature enabled.  The 8000 family is
-	 * the only one using version 36, so skip this version
-	 * entirely.
+	 * initially on version 38 and then backported to 17.  It was
+	 * also backported to 29, but only for 7265D devices.  The
+	 * intention was to have it in 36 as well, but not all 8000
+	 * family got this feature enabled.  The 8000 family is the
+	 * only one using version 36, so skip this version entirely.
 	 */
 	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >= 38 ||
-	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 ||
-	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17;
+	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 17 ||
+	       (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) == 29 &&
+		((mvm->trans->hw_rev & CSR_HW_REV_TYPE_MSK) ==
+		 CSR_HW_REV_TYPE_7265D));
 }
 
 int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
-- 
2.20.1

