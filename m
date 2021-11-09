Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F02B44A2E3
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242919AbhKIBWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:22:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:44392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243681AbhKIBT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:19:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDF4561AF7;
        Tue,  9 Nov 2021 01:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420069;
        bh=KjBcQ+WI1oP0C2UNHD/b64r3d+eqgFExUu/QF5FfxGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHk21hBQXyFv/DVu6zKyqQono35o/5BmnnKi0kjRbqHPjKbc8D+A1cacvDGPaO/7z
         Uc+svb8OKx1+tlarihl8fuYzZTuIVrNP/1n5stUkYv3VNpHVtNnU3vnqpmEJaat68m
         2FkMYC9myLNcDGagvB8cETXOFLmp4eJUl3UWWfmbhhmxDAcl3CpGJSP9iSnmGJTEI4
         QgqOyoIy0lX+fvGZ5oxnUiFgmBAsTcxW5+f8ubZtyRqVdrn9R2M/ccqagOHLOB06O7
         s0P3niRUS5rr4gnYlQKuqbbfBjQg4TjWOuLpijejxbtnH71+85ZQ3xrOMvnaZ/jEG3
         RBLDYoS5P0w4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        miriam.rachel.korenblit@intel.com, mordechay.goodstein@intel.com,
        emmanuel.grumbach@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 31/39] iwlwifi: mvm: disable RX-diversity in powersave
Date:   Mon,  8 Nov 2021 20:06:41 -0500
Message-Id: <20211109010649.1191041-31-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010649.1191041-1-sashal@kernel.org>
References: <20211109010649.1191041-1-sashal@kernel.org>
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
index d2cada0ab4264..3303fc85d76f5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1029,6 +1029,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		return false;
+
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
-- 
2.33.0

