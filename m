Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88F9A2E12DA
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgLWCZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:25:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:52758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbgLWCZV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9C2C22248;
        Wed, 23 Dec 2020 02:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690304;
        bh=dSJT/hf9sQ4STW0fKdZkEoCl8LAygSmBoFKw60XSpeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8DFRsmFrJ1gUzoiTBLpGHGTfOPN3/9GQmNT2PxCNpPReONaZyPxOBwmPNZ/DFvs7
         KWeKVnKQM1IqN4Rr/yOp5XJz31M4puSkfQbxVZ1xspfzaFXLdWgtWfYAGiCV/7VM3H
         cqGpqYc6HR7W4wLA5wcxZHnNEodefVS7ttOONVqNaCDb9zCFXaKTbiy2FbHZklqE0D
         Zbs3FIKNwiWadx0EdX0crEVwsxrQcHGPBM2jNOAFQzO/hZKGoH3PyHUk1jx+jnCBxk
         JP26esxUS+GU0T/oTag0oiR5Up618QA2EyGz+HLWoYB0U1JbrmWFDLTsq8Py0q9Uv5
         /Ibcgm0JaeVGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 39/48] iwlwifi: trans: consider firmware dead after errors
Date:   Tue, 22 Dec 2020 21:24:07 -0500
Message-Id: <20201223022417.2794032-39-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 0296124a7f9cf..360554727a817 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -1238,8 +1238,10 @@ static inline void iwl_trans_fw_error(struct iwl_trans *trans)
 		return;
 
 	/* prevent double restarts due to the same erroneous FW */
-	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status))
+	if (!test_and_set_bit(STATUS_FW_ERROR, &trans->status)) {
 		iwl_op_mode_nic_error(trans->op_mode);
+		trans->state = IWL_TRANS_NO_FW;
+	}
 }
 
 /*****************************************************
-- 
2.27.0

