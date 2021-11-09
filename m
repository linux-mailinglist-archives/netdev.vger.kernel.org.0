Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690B844A322
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242378AbhKIB0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:26:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243465AbhKIBXT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:23:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1B34461A79;
        Tue,  9 Nov 2021 01:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420142;
        bh=tXNqZFEup+T7Gb0GfPeWhphkJylcrBNUBCMBVQ2ToDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UMejXKMWJItSXPftSCrgpZRdkYRR8PwZSaVEABqT7m4WBYrct5+m4rbymQUD8XQ1B
         jbjG0s8tDHkpQiXdDHCrv1k2aIsLhBY4TNkxxpZhG9wnkrs7ufbnPWeF5CVoOSr1Bx
         r4vgyHMxtygwTAUtMSgA9xcC6mV89JS6K9ciruKGftyz3VDK7WtJcmGM2PqBuYP+Rw
         baEff2z9fhhhcrMxlLNTLYmo5ua8QOnTRN92Y9E/T58WLpv3elelR27h1UOpnXOVEy
         YSUZvZZ1ZX5kMCQqtLVOD2G8r1cNMT4Bu8zRwVI1MgmRTrsNJTU+3z3oEAHHiYt1Qo
         ybdXIl1QMbUrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        miriam.rachel.korenblit@intel.com, mordechay.goodstein@intel.com,
        emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 27/33] iwlwifi: mvm: disable RX-diversity in powersave
Date:   Mon,  8 Nov 2021 20:08:01 -0500
Message-Id: <20211109010807.1191567-27-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010807.1191567-1-sashal@kernel.org>
References: <20211109010807.1191567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e5322b9ab5f63536c41301150b7ce64605ce52cc ]

Just like we have default SMPS mode as dynamic in powersave,
we should not enable RX-diversity in powersave, to reduce
power consumption when connected to a non-MIMO AP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211017113927.fc896bc5cdaa.I1d11da71b8a5cbe921a37058d5f578f1b14a2023@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index ff5ce1ed03c42..4746f4b096c56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -913,6 +913,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		return false;
+
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
-- 
2.33.0

