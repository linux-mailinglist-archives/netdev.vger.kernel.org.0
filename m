Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B067F44A3F1
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241853AbhKIBci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:32:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242258AbhKIBZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:25:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB03A61B44;
        Tue,  9 Nov 2021 01:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636420206;
        bh=2g6uoVwI8XWT0DCm0+zBjkaYZ7m+41pw/tE2yKLiexM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avddYSsethml/nUqW69ItR9wrlxdH4iplyLOmMTfzx6X/hJ3fRjwnATkt9YtPmWbr
         uJ4VkMWiqc186NHo2+qPAzPws8IvQOpZxJmGRqTk0sOcCuJfCThFwqjDwMx3hIm1Uv
         cBP050YNyTGdbuOEhnKgmvC52+fHl5WrHfIh2LR/MlB0c5SAi+njuIxb6KZ+oiVCES
         1XJYx2Ku3pd/S15nHrv6b4risR+/iLWHok9/mtbYOLLngLo5qTVE2CliaMhM/diQpT
         SZFvL5E66Jf4OD/CLvXWC2oHui4lDmpRXiLoluwZvWgwMtXgI3Ulz7sbaXCUzi3MWV
         8O5Kf6kbz5JQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 25/30] iwlwifi: mvm: disable RX-diversity in powersave
Date:   Mon,  8 Nov 2021 20:09:13 -0500
Message-Id: <20211109010918.1192063-25-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109010918.1192063-1-sashal@kernel.org>
References: <20211109010918.1192063-1-sashal@kernel.org>
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
 drivers/net/wireless/iwlwifi/mvm/utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index ad0f16909e2e2..3d089eb9dff51 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -923,6 +923,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		return false;
+
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
-- 
2.33.0

