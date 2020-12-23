Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C19772E1249
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729127AbgLWCUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgLWCUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 755A823159;
        Wed, 23 Dec 2020 02:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690035;
        bh=Mkb77UdVz/5p1f8UEjjbVmNsg1UaKH/m8P8zqp2BlQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M0o4CtxZk8oHhMjVoUhdeKLdkBC+jh0rIXIh03INyqGMi6bIQJs2/U00z/42sJRD5
         8t5F94ovA+M+l5NuweH7VSbh6uZBBr1PFrMqOmiVgG4c6nHrYrD/+Mj78/PC+wr6Cl
         nt41SNNNdF339Bje60PNWqK7aLbq+YVUNXryPNPGfb7Gxlil49e/SVaJF27P5M/pqL
         jFAcG/Nc74GEU0Ul+8foRcjP1CohUP+IagGsp7e68LP7Y36hsIw/B3t7XGUtaKvSVL
         mFZ0t8eiVoEjwDQ8/hNMGWBAdLQXkKtMHwCHChk3ptPPb8QCktlVYWW73pKOadk6zP
         O9R/Klodu44WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 110/130] iwlwifi: trans: consider firmware dead after errors
Date:   Tue, 22 Dec 2020 21:17:53 -0500
Message-Id: <20201223021813.2791612-110-sashal@kernel.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 152fdc0f698896708f9d7889a4ba4da6944b74f7 ]

If we get an error, no longer consider the firmware to be
in IWL_TRANS_FW_ALIVE state.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.a9d01e79c1c7.Ib2deb076b392fb516a7230bac91d7ab8a9586d86@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 1e85d59b91613..b31bb56ca6591 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1230,8 +1230,10 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 		return;
 
 	/* prevent double restarts due to the same erroneous FW */
-	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status))
+	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status)) {
 		iwl_op_mode_nic_error(trans->op_mode);
+		trans->state = IWL_TRANS_NO_FW;
+	}
 }
 
 static inline void iwl_trans_sync_nmi(struct iwl_trans *trans)
-- 
2.27.0

