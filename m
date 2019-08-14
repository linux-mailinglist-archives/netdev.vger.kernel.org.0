Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 440298C624
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 04:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728211AbfHNCNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 22:13:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbfHNCNK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 22:13:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B15E020842;
        Wed, 14 Aug 2019 02:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748788;
        bh=WQN/2CG7EqwekK1fcgDFFFV37yfP91JJmvNcjKYLxrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o6L7SEAot05d9kGRJFMCckW3C85p0JrWwpWbuNWRDrUUwRUcwJbasbSwKfc8I/x+S
         45YfhuhuVR0QTOHx+6SY2zdMQvHexPKRETIKylIRiOMlXqEXMjlgnVT9geqH6EMtRZ
         lV7arqPruRw4zkW8NYEQHdF2PJ8Xgfbbk/SmGSXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 065/123] iwlwifi: fix locking in delayed GTK setting
Date:   Tue, 13 Aug 2019 22:09:49 -0400
Message-Id: <20190814021047.14828-65-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021047.14828-1-sashal@kernel.org>
References: <20190814021047.14828-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 6569e7d36773956298ec1d5f4e6a2487913d2752 ]

This code clearly never could have worked, since it locks
while already locked. Add an unlocked __iwl_mvm_mac_set_key()
variant that doesn't do locking to fix that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 39 ++++++++++++-------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 964c7baabede3..edffae3741e00 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -207,11 +207,11 @@ static const struct cfg80211_pmsr_capabilities iwl_mvm_pmsr_capa = {
 	},
 };
 
-static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
-			       enum set_key_cmd cmd,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta,
-			       struct ieee80211_key_conf *key);
+static int __iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+				 enum set_key_cmd cmd,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 struct ieee80211_key_conf *key);
 
 void iwl_mvm_ref(struct iwl_mvm *mvm, enum iwl_mvm_ref_type ref_type)
 {
@@ -2725,7 +2725,7 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 
 		mvmvif->ap_early_keys[i] = NULL;
 
-		ret = iwl_mvm_mac_set_key(hw, SET_KEY, vif, NULL, key);
+		ret = __iwl_mvm_mac_set_key(hw, SET_KEY, vif, NULL, key);
 		if (ret)
 			goto out_quota_failed;
 	}
@@ -3493,11 +3493,11 @@ static int iwl_mvm_mac_sched_scan_stop(struct ieee80211_hw *hw,
 	return ret;
 }
 
-static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
-			       enum set_key_cmd cmd,
-			       struct ieee80211_vif *vif,
-			       struct ieee80211_sta *sta,
-			       struct ieee80211_key_conf *key)
+static int __iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+				 enum set_key_cmd cmd,
+				 struct ieee80211_vif *vif,
+				 struct ieee80211_sta *sta,
+				 struct ieee80211_key_conf *key)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
@@ -3552,8 +3552,6 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 			return -EOPNOTSUPP;
 	}
 
-	mutex_lock(&mvm->mutex);
-
 	switch (cmd) {
 	case SET_KEY:
 		if ((vif->type == NL80211_IFTYPE_ADHOC ||
@@ -3699,7 +3697,22 @@ static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
 		ret = -EINVAL;
 	}
 
+	return ret;
+}
+
+static int iwl_mvm_mac_set_key(struct ieee80211_hw *hw,
+			       enum set_key_cmd cmd,
+			       struct ieee80211_vif *vif,
+			       struct ieee80211_sta *sta,
+			       struct ieee80211_key_conf *key)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = __iwl_mvm_mac_set_key(hw, cmd, vif, sta, key);
 	mutex_unlock(&mvm->mutex);
+
 	return ret;
 }
 
-- 
2.20.1

