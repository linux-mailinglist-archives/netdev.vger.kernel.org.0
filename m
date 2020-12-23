Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5797C2E1613
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731285AbgLWC5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:57:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729077AbgLWCUp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56672229C5;
        Wed, 23 Dec 2020 02:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690030;
        bh=CLpvyJm6ey7siVxyqi+mtoGI9mlj4GFiKdSRV/eta8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bQLATC8+z/sKizgIv+Z/8+XYSJj1k4GDJz1+RVsfr6HcLBLrCohPxVyh1MXXoWB6d
         Nkrp8MPmbZsI+eNmKyI8aQGLrWgoikDeMI2Kqydy36M1KeEZZhy3Z3pRbNhQM/wB8+
         6muKQrqRwW8WQ2fi5I8tUmZ+JvARYxKfpL7ETOjBNkDHMVyq/ZQ8tly7u3bE+XerdU
         oI9SZ0vwms77af8jLB8fxU5/N5NKzTkmPTNcrwyQUMGyomNA9O+aDzYY7kU9yIuOiw
         C/tQYZ/VC3sVvhT59k3pSpfsAGIN8UX1crRGeyAzRdDxYpyz9p2f/Q/Jyan5SuckM4
         ZKtRUxr0xopwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 106/130] iwlwifi: avoid endless HW errors at assert time
Date:   Tue, 22 Dec 2020 21:17:49 -0500
Message-Id: <20201223021813.2791612-106-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit 861bae42e1f125a5a255ace3ccd731e59f58ddec ]

Curretly we only mark HW error state "after" trying to collect HW data,
but if any HW error happens while colleting HW data we go into endless
loop. avoid this by setting HW error state "before" collecting HW data.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.4c7e5a87da15.Ic35b2f28ff08f7ac23143c80f224d52eb97a0454@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 3acbd5b7ab4b2..87f53810fdac3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1291,6 +1291,12 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 	} else if (mvm->fwrt.cur_fw_img == IWL_UCODE_REGULAR &&
 		   mvm->hw_registered &&
 		   !test_bit(STATUS_TRANS_DEAD, &mvm->trans->status)) {
+		/* This should be first thing before trying to collect any
+		 * data to avoid endless loops if any HW error happens while
+		 * collecting debug data.
+		 */
+		set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
+
 		if (mvm->fw->ucode_capa.error_log_size) {
 			u32 src_size = mvm->fw->ucode_capa.error_log_size;
 			u32 src_addr = mvm->fw->ucode_capa.error_log_addr;
@@ -1309,7 +1315,6 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 
 		if (fw_error && mvm->fw_restart > 0)
 			mvm->fw_restart--;
-		set_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED, &mvm->status);
 		ieee80211_restart_hw(mvm->hw);
 	}
 }
-- 
2.27.0

