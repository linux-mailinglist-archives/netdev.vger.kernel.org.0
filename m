Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5BA330C4E4
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236052AbhBBQFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234983AbhBBPLb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:11:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C862464F6E;
        Tue,  2 Feb 2021 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278398;
        bh=L3B6ZScRpTteiAHfJ25ES5UssYuyHCpMGNOYLXRSOmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHbLj5qhaScCt9dJ4CKkB2Gn3Y71BKtzlIJQcaxAKvb2p6VpcYGE7ey278zxkizhB
         i6gHJR6mIIDCe+mk9TIIzMc9AH1VrfewUH5aF+6rONq/UERccMzHMuzoOw7/Ih9Q+B
         NMxSmBmJII6hnB/+7QtGS5QwGBKxkyr5jO/r5N3t+xuVKmNq/4sZaDm74CVB+HX6lN
         CuBF0FdoGMG98y81x8TtVJlqXkP6awmEX2ORAbR4QB4+kC2eIv2ourH2fqA3ZD3wp2
         vmkiJ2v1Jioc81tvW847z4VyF44PVed05BpiLuWSdV36hsfhbbPv6syrU0wWzR+xcz
         8QnBqKrSepovw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/25] iwlwifi: mvm: invalidate IDs of internal stations at mvm start
Date:   Tue,  2 Feb 2021 10:06:07 -0500
Message-Id: <20210202150615.1864175-17-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gregory Greenman <gregory.greenman@intel.com>

[ Upstream commit e223e42aac30bf81f9302c676cdf58cf2bf36950 ]

Having sta_id not set for aux_sta and snif_sta can potentially lead to a
hard to debug issue in case remove station is called without an add. In
this case sta_id 0, an unrelated regular station, will be removed.

In fact, we do have a FW assert that occures rarely and from the debug
data analysis it looks like sta_id 0 is removed by mistake, though it's
hard to pinpoint the exact flow. The WARN_ON in this patch should help
to find it.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.5dc6dd9b22d5.I2add1b5ad24d0d0a221de79d439c09f88fcaf15d@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 4 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index 0d1118f66f0d5..cea8e397fe0f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -845,6 +845,10 @@ iwl_op_mode_mvm_start(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 	if (!mvm->scan_cmd)
 		goto out_free;
 
+	/* invalidate ids to prevent accidental removal of sta_id 0 */
+	mvm->aux_sta.sta_id = IWL_MVM_INVALID_STA;
+	mvm->snif_sta.sta_id = IWL_MVM_INVALID_STA;
+
 	/* Set EBS as successful as long as not stated otherwise by the FW. */
 	mvm->last_ebs_successful = true;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 799d8219463cb..a66a5c19474a9 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2103,6 +2103,9 @@ int iwl_mvm_rm_snif_sta(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON_ONCE(mvm->snif_sta.sta_id == IWL_MVM_INVALID_STA))
+		return -EINVAL;
+
 	iwl_mvm_disable_txq(mvm, NULL, mvm->snif_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->snif_sta.sta_id);
 	if (ret)
@@ -2117,6 +2120,9 @@ int iwl_mvm_rm_aux_sta(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (WARN_ON_ONCE(mvm->aux_sta.sta_id == IWL_MVM_INVALID_STA))
+		return -EINVAL;
+
 	iwl_mvm_disable_txq(mvm, NULL, mvm->aux_queue, IWL_MAX_TID_COUNT, 0);
 	ret = iwl_mvm_rm_sta_common(mvm, mvm->aux_sta.sta_id);
 	if (ret)
-- 
2.27.0

