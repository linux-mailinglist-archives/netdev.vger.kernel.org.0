Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 398613BD5C9
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240495AbhGFMZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 08:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236795AbhGFLfl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9719C613B0;
        Tue,  6 Jul 2021 11:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570660;
        bh=L8p0SwQFqnS23W3Kn4oqQgCrUhp80/4lWpUPylWHEpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXqjc/ky1WJR/vdJpMw5gIZSIRzuAnGlbvz0zmcfjaie0P08uwahlziY5aOucEw9j
         aNyIzOeyfaZFi8yJQyVc1bOumHzlPtqn5JnMTdMf/PSXdxN7W98RNEaPKy1BB0465P
         PyeNBuOHrsjQoAvA5NPtz1lGdL6X/qilRnny7jjF8B5RGudenIAAO2b0LV6UtXfM/J
         g3kZ0kuUCSxH0xT7PPW99aexQYhL1S2+M1yIkPcvhUZF1QftgPXgRDReymLsXhp5qA
         MxiXK97tPaRZ3GQp5b8m7hCwzI3496ZftTvwdRHsDvWs5pUiv02AbGg/+d1eMDiZ7/
         rHVobohc5OmGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 105/137] iwlwifi: mvm: don't change band on bound PHY contexts
Date:   Tue,  6 Jul 2021 07:21:31 -0400
Message-Id: <20210706112203.2062605-105-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 8835a64f74c46baebfc946cd5a2c861b866ebcee ]

When we have a P2P Device active, we attempt to only change the
PHY context it uses when we get a new remain-on-channel, if the
P2P Device is the only user of the PHY context.

This is fine if we're switching within a band, but if we're
switching bands then the switch implies a removal and re-add
of the PHY context, which isn't permitted by the firmware while
it's bound to an interface.

Fix the code to skip the unbind/release/... cycle only if the
band doesn't change (or we have old devices that can switch the
band on the fly as well.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210612142637.e9ac313f70f3.I713b9d109957df7e7d9ed0861d5377ce3f8fccd3@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d42165559df6..8cba923b1ec6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3794,6 +3794,7 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct cfg80211_chan_def chandef;
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
+	bool band_change_removal;
 	int ret, i;
 
 	IWL_DEBUG_MAC80211(mvm, "enter (%d, %d, %d)\n", channel->hw_value,
@@ -3874,19 +3875,30 @@ static int iwl_mvm_roc(struct ieee80211_hw *hw,
 	cfg80211_chandef_create(&chandef, channel, NL80211_CHAN_NO_HT);
 
 	/*
-	 * Change the PHY context configuration as it is currently referenced
-	 * only by the P2P Device MAC
+	 * Check if the remain-on-channel is on a different band and that
+	 * requires context removal, see iwl_mvm_phy_ctxt_changed(). If
+	 * so, we'll need to release and then re-configure here, since we
+	 * must not remove a PHY context that's part of a binding.
 	 */
-	if (mvmvif->phy_ctxt->ref == 1) {
+	band_change_removal =
+		fw_has_capa(&mvm->fw->ucode_capa,
+			    IWL_UCODE_TLV_CAPA_BINDING_CDB_SUPPORT) &&
+		mvmvif->phy_ctxt->channel->band != chandef.chan->band;
+
+	if (mvmvif->phy_ctxt->ref == 1 && !band_change_removal) {
+		/*
+		 * Change the PHY context configuration as it is currently
+		 * referenced only by the P2P Device MAC (and we can modify it)
+		 */
 		ret = iwl_mvm_phy_ctxt_changed(mvm, mvmvif->phy_ctxt,
 					       &chandef, 1, 1);
 		if (ret)
 			goto out_unlock;
 	} else {
 		/*
-		 * The PHY context is shared with other MACs. Need to remove the
-		 * P2P Device from the binding, allocate an new PHY context and
-		 * create a new binding
+		 * The PHY context is shared with other MACs (or we're trying to
+		 * switch bands), so remove the P2P Device from the binding,
+		 * allocate an new PHY context and create a new binding.
 		 */
 		phy_ctxt = iwl_mvm_get_free_phy_ctxt(mvm);
 		if (!phy_ctxt) {
-- 
2.30.2

